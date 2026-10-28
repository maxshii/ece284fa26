// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a0, b0, a1, b1, a2, b2, a3, b3, c);

parameter bw = 4;
parameter psum_bw = 16;

input unsigned [bw-1:0] a0;
input signed [bw-1:0] b0;
input unsigned [bw-1:0] a1;
input signed [bw-1:0] b1;
input unsigned [bw-1:0] a2;
input signed [bw-1:0] b2;
input unsigned [bw-1:0] a3;
input signed [bw-1:0] b3;
input signed [psum_bw-1:0] c;

output signed [psum_bw-1:0] out;

// multiply a and b inputs
wire signed [psum_bw-1:0] mult0;
wire signed [psum_bw-1:0] mult1;
wire signed [psum_bw-1:0] mult2;
wire signed [psum_bw-1:0] mult3;
assign mult0 =  $signed({1'b0,a0}) * b0;
assign mult1 =  $signed({1'b0,a1}) * b1;
assign mult2 =  $signed({1'b0,a2}) * b2;
assign mult3 =  $signed({1'b0,a3}) * b3;

// add the multiplication results
wire signed [psum_bw-1:0] add0;
wire signed [psum_bw-1:0] add1;
wire signed [psum_bw-1:0] add2;
assign add0 = mult0 + mult1;
assign add1 = mult2 + mult3;
assign add2 = add0 + add1;

// add the final result to the input c
assign out = c + add2;

endmodule
