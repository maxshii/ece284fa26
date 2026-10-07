// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, A, B, format, acc, clk, reset);

parameter bw = 8;
parameter psum_bw = 16;
parameter smag_fill = psum_bw - (bw-1)*2 - 1; // number of bits to 0 extend a*b result in sign mag

input clk;
input acc;
input reset;
input format;

input signed [bw-1:0] A;
input signed [bw-1:0] B;

output signed [psum_bw-1:0] out;

reg signed [psum_bw-1:0] psum_q;
reg signed [bw-1:0] a_q;
reg signed [bw-1:0] b_q;

// sign of a,b,psum
wire psum_s = psum_q[psum_bw-1];
wire a_s = a_q[bw-1];
wire b_s = b_q[bw-1];

// magnitude of a and b and psum
wire [bw-2:0] a_mag = a_q[bw-2:0];
wire [bw-2:0] b_mag = b_q[bw-2:0];
wire [psum_bw-2:0] psum_mag = psum_q[psum_bw-2:0];

// compute a*b in sign mag
wire multiply_s = a_s ^ b_s;
wire [psum_bw-2:0] multiply_mag = a_mag*b_mag;
wire [psum_bw-1:0] multiply_signmag = {multiply_s, smag_fill[1'b0], multiply_mag}; 

// compute a*b + psum
reg [psum_bw-1:0] psum_signmag;
always @ (psum_q or multiply_signmag) begin // compute sign magnitude addition
    if (psum_s == multiply_s) begin // if sign are equal, add magnitudes and keep sign the same
        psum_signmag = {psum_s, psum_mag + multiply_mag};
    end
    else if (psum_mag > multiply_mag) begin 
        psum_signmag = {psum_s, psum_mag - multiply_mag}; // use sign of num with larger mag, subtract smaller mag from larger mag to find the result mag
    end
    else begin
        psum_signmag = {multiply_s, multiply_mag - psum_mag};
    end
end

assign out = psum_q;

always @ (posedge clk) begin
    a_q <= A;
    b_q <= B;

    if(reset == 1) begin
       psum_q <= 0; 
    end
    else if (acc == 1) begin
        if (format == 0) begin
            psum_q <= psum_q + (a_q*b_q);
        end
        else begin
            //$display("psum before: %d %d", psum_s, psum_mag);
            psum_q <= psum_signmag;
            $strobe("psum: %d %d\n", psum_s, psum_mag);
            $strobe("a: %d %d, b: %d %d \na*b: %d %d", a_s, a_mag, b_s, b_mag, multiply_s, multiply_mag);
            
        end
    end
    else if (acc == 0) begin
        if (format == 0) begin
            psum_q <= a_q*b_q;
        end
        else begin
            psum_q <= multiply_signmag;
            $strobe("a: %d %d, b: %d %d, \na*b: %d %d\n", a_s, a_mag, b_s, b_mag, multiply_s, multiply_mag);
        end
    end
end 



endmodule
