/* TODO: Names of all group members
 * TODO: PennKeys of all group members
 *
 * lc4_regfile.v
 * Implements an 8-register register file parameterized on word size.
 *
 */

`timescale 1ns / 1ps

// Prevent implicit wire declaration
`default_nettype none

module lc4_regfile #(parameter n = 16)
   (input  wire         clk,
    input  wire         gwe,
    input  wire         rst,
    input  wire [  2:0] i_rs,      // rs selector
    output wire [n-1:0] o_rs_data, // rs contents
    input  wire [  2:0] i_rt,      // rt selector
    output wire [n-1:0] o_rt_data, // rt contents
    input  wire [  2:0] i_rd,      // rd selector
    input  wire [n-1:0] i_wdata,   // data to write
    input  wire         i_rd_we    // write enable
    );
module lc4_regfile #(parameter n = 16)
   (input  wire         clk,
    input  wire         gwe,
    input  wire         rst,
    input  wire [  2:0] i_rs,      // rs selector
    output wire [n-1:0] o_rs_data, // rs contents
    input  wire [  2:0] i_rt,      // rt selector
    output wire [n-1:0] o_rt_data, // rt contents
    input  wire [  2:0] i_rd,      // rd selector
    input  wire [n-1:0] i_wdata,   // data to write
    input  wire         i_rd_we    // write enable
    );

wire [15:0] out_r0, out_r1, out_r2, out_r3, out_r4, out_r5, out_r6, out_r7;

Nbit_reg #(.n(16), .r(16'h0000)) r0 (.in(i_wdata), .out(out_r0), .clk(clk), .we(i_rd_we && (i_rd == 3'b000)), .gwe(gwe), .rst(rst));

Nbit_reg #(.n(16), .r(16'h0000)) r1 (.in(i_wdata), .out(out_r1), .clk(clk), .we(i_rd_we && (i_rd == 3'b001)), .gwe(gwe), .rst(rst));

Nbit_reg #(.n(16), .r(16'h0000)) r2 (.in(i_wdata), .out(out_r2), .clk(clk), .we(i_rd_we && (i_rd == 3'b010)), .gwe(gwe), .rst(rst));

Nbit_reg #(.n(16), .r(16'h0000)) r3 (.in(i_wdata), .out(out_r3), .clk(clk), .we(i_rd_we && (i_rd == 3'b011)), .gwe(gwe), .rst(rst));

Nbit_reg #(.n(16), .r(16'h0000)) r4 (.in(i_wdata), .out(out_r4), .clk(clk), .we(i_rd_we && (i_rd == 3'b100)), .gwe(gwe), .rst(rst));

Nbit_reg #(.n(16), .r(16'h0000)) r5 (.in(i_wdata), .out(out_r5), .clk(clk), .we(i_rd_we && (i_rd == 3'b101)), .gwe(gwe), .rst(rst));

Nbit_reg #(.n(16), .r(16'h0000)) r6 (.in(i_wdata), .out(out_r6), .clk(clk), .we(i_rd_we && (i_rd == 3'b110)), .gwe(gwe), .rst(rst));

Nbit_reg #(.n(16), .r(16'h0000)) r7 (.in(i_wdata), .out(out_r7), .clk(clk), .we(i_rd_we && (i_rd == 3'b111)), .gwe(gwe), .rst(rst));


assign o_rs_data = (i_rs == 3'b000) ? out_r0
                 : (i_rs == 3'b001) ? out_r1
                 : (i_rs == 3'b010) ? out_r2
                 : (i_rs == 3'b011) ? out_r3
                 : (i_rs == 3'b100) ? out_r4
                 : (i_rs == 3'b101) ? out_r5
                 : (i_rs == 3'b110) ? out_r6
                 : out_r7;
      

assign o_rt_data = (i_rt == 3'b000) ? out_r0
                 : (i_rt == 3'b001) ? out_r1
                 : (i_rt == 3'b010) ? out_r2
                 : (i_rt == 3'b011) ? out_r3
                 : (i_rt == 3'b100) ? out_r4
                 : (i_rt == 3'b101) ? out_r5
                 : (i_rt == 3'b110) ? out_r6
                 : out_r7;

endmodule
