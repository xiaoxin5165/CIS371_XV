/* INSERT NAME AND PENNKEY HERE */

`timescale 1ns / 1ps

`default_nettype none
//`include "lc4_divider.v"
module lc4_alu(input  wire [15:0] i_insn,
               input wire [15:0]  i_pc,
               input wire [15:0]  i_r1data,
               input wire [15:0]  i_r2data,
               output wire [15:0] o_result);
   wire [15:0] o_result2;
   wire [16:0] o_result3;// = ({1'b0,i_r1data} - {{10{1'b0}}, i_insn[6:0]});
   wire [15:0] dummy, dummy2;
   barrel shift(.i_num(i_insn),.i_num2(i_r1data), .o_res(o_result2));
   lc4_divider div(.i_dividend(i_r1data), .i_divisor(i_r2data), .o_remainder(dummy2), .o_quotient(dummy));
   wire [3:0] op = i_insn[15:12];
   assign o_result3 =( (op == 'b0010) ? 
                 ((i_insn[8:7] == 'b00) ? (({i_r1data[15],i_r1data} - {i_r2data[15],i_r2data}))      : //$write("CMP R%d R%d", insn[11:9], insn[2:0]);
                 ((i_insn[8:7] == 'b01) ? (({1'b0,i_r1data} - {1'b0,i_r2data}))                      : //$write("CMPU R%d R%d", insn[11:9], insn[2:0]);
                 ((i_insn[8:7] == 'b10) ? ({i_r1data[15],i_r1data} - {{10{i_insn[6]}}, i_insn[6:0]}) : //$write("CMPI R%d SEXT(%b)", insn[11:9], insn[6:0]);
                                          ({1'b0,i_r1data} - {{10{1'b0}}, i_insn[6:0]}))))               // cmpiu
	      : 17'b0 );
   begin
   //$display("hellp");
   // branch instructions
      assign o_result = (op == 'b0000) ?
                 (i_insn[11:9] == 'b000) ? i_pc+1+{{7{i_insn[8]}}, i_insn[8:0]} : // $write("NOP");
                 ((i_insn[11:9] == 'b100) ? i_pc+1+{{7{i_insn[8]}}, i_insn[8:0]} : //$write("BRn %b", insn[8:0]);
                 ((i_insn[11:9] == 'b110) ? i_pc+1+{{7{i_insn[8]}}, i_insn[8:0]} : //$write("BRnz %b", insn[8:0]);
                 ((i_insn[11:9] == 'b101) ? i_pc+1+{{7{i_insn[8]}}, i_insn[8:0]} : //$write("BRnp %b", insn[8:0]);
                 ((i_insn[11:9] == 'b010) ? i_pc+1+{{7{i_insn[8]}}, i_insn[8:0]} : //$write("BRz %b", insn[8:0]);
                 ((i_insn[11:9] == 'b011) ? i_pc+1+{{7{i_insn[8]}}, i_insn[8:0]} : //$write("BRzp %b", insn[8:0]);
                 ((i_insn[11:9] == 'b001) ? i_pc+1+{{7{i_insn[8]}}, i_insn[8:0]} : //$write("BRp %b", insn[8:0]);
                 ((i_insn[11:9] == 'b111) ? i_pc+1+{{7{i_insn[8]}}, i_insn[8:0]} : //$write("BRnzp %b", insn[8:0]);
                                            'h0000)))))))                                 //$write("???");
      // arithmetic
      : ((op == 'b0001) ?
                 (i_insn[5:3] == 'b000) ? i_r1data+i_r2data  : //$write("ADD R%d R%d R%d", insn[11:9], insn[8:6], insn[2:0]);
                 ((i_insn[5:3] == 'b001) ? i_r1data*i_r2data : //$write("MUL R%d R%d R%d", insn[11:9], insn[8:6], insn[2:0]);
                 ((i_insn[5:3] == 'b010) ? i_r1data-i_r2data : //$write("SUB R%d R%d R%d", insn[11:9], insn[8:6], insn[2:0]);
                 ((i_insn[5:3] == 'b011) ? dummy             :
                                          i_r1data + {{11{i_insn[4]}}, i_insn[4:0]})))  //$write("ADDI R%d R%d SEXT(%b)", insn[11:9], insn[8:6], insn[4:0]);

      // compare
      : ((op == 'b0010) ? ((o_result3[16] == 'b1) ? 'hFFFF : 'h0001)
		 
      // jump save register
      : ((op == 'b0100) ?
                 (i_insn[11] == 'b1) ? (i_pc & 'h8000) | (i_insn[10:0] << 4) : //$write("JSR %b", insn[10:0]);
                                       i_r1data                                //$write("JSRR R%d", insn[8:6]);
      
      // logical
      : ((op == 'b0101) ?
                 (i_insn[5:3] == 'b000) ? i_r1data & i_r2data                         : //$write("AND R%d R%d R%d", insn[11:9], insn[8:6], insn[2:0]);
                 ((i_insn[5:3] == 'b001) ? ~i_r1data                                   : //$write("NOT R%d R%d", insn[11:9], insn[8:6]);
                 ((i_insn[5:3] == 'b010) ? i_r1data | i_r2data                         : //$write("OR R%d R%d R%d", insn[11:9], insn[8:6], insn[2:0]);
                 ((i_insn[5:3] == 'b011) ? i_r1data ^ i_r2data                         : //$write("XOR R%d R%d R%d", insn[11:9], insn[8:6], insn[2:0]);
                                           i_r1data & {{11{i_insn[4]}}, i_insn[4:0]})))     //$write("ANDI R%d R%d SEXT(%b)", insn[11:9], insn[8:6], insn[4:0]);
      
      // load/store register
      : ((op == 'b0110) ? i_r1data + {{10{i_insn[5]}}, i_insn[5:0]} //$write("LDR R%d R%d SEXT(%b)", insn[11:9], insn[8:6], insn[5:0]);-----------
      : ((op == 'b0111) ? i_r1data + {{10{i_insn[5]}}, i_insn[5:0]} //$write("STR R%d R%d SEXT(%b)", insn[11:9], insn[8:6], insn[5:0]);
      
      // RTI
      : ((op == 'b1000) ? i_r1data //$write("RTI");
      
      // load immediate
      : ((op == 'b1001) ? {{8{i_insn[8]}}, i_insn[8:0]} //$write("CONST R%d SEXT(%b)", insn[11:9], insn[8:0]);
      
      // shift/mod
      : ((op == 'b1010) ?
                 (i_insn[5:4] == 'b00) ? i_r1data << i_insn[3:0]            : //$write("SLL R%d R%d %b", insn[11:9], insn[8:6], insn[3:0]);
                 ((i_insn[5:4] == 'b01) ? o_result2 :// ($signed(i_r1data) >>> i_insn[3:0])  : //$write("SRA R%d R%d %b", insn[11:9], insn[8:6], insn[3:0]);
                 ((i_insn[5:4] == 'b10) ? i_r1data >> i_insn[3:0]            : //$write("SRL R%d R%d %b", insn[11:9], insn[8:6], insn[3:0]);
                                         dummy2))                               // Mod

      // jump
      : ((op == 'b1100) ?
                 (i_insn[11] == 'b0) ? i_r1data : //$write("JMPR R%d", insn[8:6]);
                                       i_pc+1+{{5{i_insn[10]}}, i_insn[10:0]} //$write("JMP SEXT(%b)", insn[10:0]);
      
      // hiconst (lc4_decoder.v ignores insn[8] even though ISA says it should be 1)
      : ((op == 'b1101) ? (i_r1data & 'hFF) | ( i_insn[7:0] <<8)//$write("HICONST R%d %b", insn[11:9], insn[7:0]);
      
      // trap
      : ((op == 'b1111) ?  ('h8000 |  i_insn[7:0]) //$write("TRAP %b", insn[7:0]);

      // unknown
      : 'h0000)))))))))))); //$write("???");
end
endmodule

module barrel (input wire [15:0] i_num, input wire [15:0] i_num2, output wire [15:0] o_res);
    assign o_res = $signed(i_num2) >>> i_num[3:0];
endmodule
