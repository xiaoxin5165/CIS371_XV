/* TODO: INSERT NAME AND PENNKEY HERE */

`timescale 1ns / 1ps
`default_nettype none

module lc4_divider(input  wire [15:0] i_dividend,
                   input  wire [15:0] i_divisor,
                   output wire [15:0] o_remainder,
                   output wire [15:0] o_quotient);

      /*** YOUR CODE HERE ***/

    wire [15:0] divi1, divi2, divi3,divi4,divi5,divi6,divi7,divi8,divi9,divi10,divi11,divi12,divi13,divi14,divi15; 
    wire [15:0] remain1, remain2, remain3,remain4,remain5,remain6,remain7,remain8,remain9,remain10,remain11,remain12,remain13,remain14,remain15,remain16; 
    wire [15:0] quot1, quot2, quot3,quot4,quot5,quot6,quot7,quot8,quot9,quot10,quot11,quot12,quot13,quot14,quot15,quot16; 
    wire [15:0] tquotient = 16'b0;
    wire [15:0] tremainder = 16'b0;
    lc4_divider_one_iter iter1(.i_dividend(i_dividend), .i_divisor(i_divisor), .i_remainder(tremainder), .i_quotient(tquotient), .o_dividend(divi1),.o_remainder(remain1), .o_quotient(quot1));
    lc4_divider_one_iter iter2(.i_dividend(divi1), .i_divisor(i_divisor), .i_remainder(remain1), .i_quotient(quot1), .o_dividend(divi2),.o_remainder(remain2), .o_quotient(quot2));
    lc4_divider_one_iter iter3(.i_dividend(divi2), .i_divisor(i_divisor), .i_remainder(remain2), .i_quotient(quot2), .o_dividend(divi3),.o_remainder(remain3), .o_quotient(quot3));
    lc4_divider_one_iter iter4(.i_dividend(divi3), .i_divisor(i_divisor), .i_remainder(remain3), .i_quotient(quot3), .o_dividend(divi4),.o_remainder(remain4), .o_quotient(quot4));
    lc4_divider_one_iter iter5(.i_dividend(divi4), .i_divisor(i_divisor), .i_remainder(remain4), .i_quotient(quot4), .o_dividend(divi5),.o_remainder(remain5), .o_quotient(quot5));
    lc4_divider_one_iter iter6(.i_dividend(divi5), .i_divisor(i_divisor), .i_remainder(remain5), .i_quotient(quot5), .o_dividend(divi6),.o_remainder(remain6), .o_quotient(quot6));
    lc4_divider_one_iter iter7(.i_dividend(divi6), .i_divisor(i_divisor), .i_remainder(remain6), .i_quotient(quot6), .o_dividend(divi7),.o_remainder(remain7), .o_quotient(quot7));
    lc4_divider_one_iter iter8(.i_dividend(divi7), .i_divisor(i_divisor), .i_remainder(remain7), .i_quotient(quot7), .o_dividend(divi8),.o_remainder(remain8), .o_quotient(quot8));
    lc4_divider_one_iter iter9(.i_dividend(divi8), .i_divisor(i_divisor), .i_remainder(remain8), .i_quotient(quot8), .o_dividend(divi9),.o_remainder(remain9), .o_quotient(quot9));
    lc4_divider_one_iter iter10(.i_dividend(divi9), .i_divisor(i_divisor), .i_remainder(remain9), .i_quotient(quot9), .o_dividend(divi10),.o_remainder(remain10), .o_quotient(quot10));
    lc4_divider_one_iter iter11(.i_dividend(divi10), .i_divisor(i_divisor), .i_remainder(remain10), .i_quotient(quot10), .o_dividend(divi11),.o_remainder(remain11), .o_quotient(quot11));
    lc4_divider_one_iter iter12(.i_dividend(divi11), .i_divisor(i_divisor), .i_remainder(remain11), .i_quotient(quot11), .o_dividend(divi12),.o_remainder(remain12), .o_quotient(quot12));
    lc4_divider_one_iter iter13(.i_dividend(divi12), .i_divisor(i_divisor), .i_remainder(remain12), .i_quotient(quot12), .o_dividend(divi13),.o_remainder(remain13), .o_quotient(quot13));
    lc4_divider_one_iter iter14(.i_dividend(divi13), .i_divisor(i_divisor), .i_remainder(remain13), .i_quotient(quot13), .o_dividend(divi14),.o_remainder(remain14), .o_quotient(quot14));
    lc4_divider_one_iter iter15(.i_dividend(divi14), .i_divisor(i_divisor), .i_remainder(remain14), .i_quotient(quot14), .o_dividend(divi15),.o_remainder(remain15), .o_quotient(quot15));
    lc4_divider_one_iter iter16(.i_dividend(divi15), .i_divisor(i_divisor), .i_remainder(remain15), .i_quotient(quot15), .o_dividend(),.o_remainder(o_remainder), .o_quotient(o_quotient));
    //assign o_remainder = (i_divisor == 16'b0) ? 16'b0 : remain16;
    //assign o_quotient = (i_divisor == 16'b0) ? 16'b0 : quot16;
endmodule // lc4_divider

module lc4_divider_one_iter(input  wire [15:0] i_dividend,
                            input  wire [15:0] i_divisor,
                            input  wire [15:0] i_remainder,
                            input  wire [15:0] i_quotient,
                            output wire [15:0] o_dividend,
                            output wire [15:0] o_remainder,
                            output wire [15:0] o_quotient);
    wire [15:0] tremainder;  
    assign tremainder = (i_remainder << 1) | ((i_dividend >> 15) & 16'b1);
    assign o_quotient = (i_divisor == 16'b0) ? 16'b0 :
                        (tremainder < i_divisor) ? (i_quotient << 1) | 16'b0 : (i_quotient << 1) | 16'b1;
    assign o_remainder = (i_divisor == 16'b0) ? 16'b0 :
                        (tremainder >= i_divisor) ? tremainder - i_divisor : tremainder;
    assign o_dividend = i_dividend << 1; 
      /*** YOUR CODE HERE ***/

endmodule
