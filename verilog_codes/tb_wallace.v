`timescale 1ns / 1ps

module tb_wallace();
    reg [15:0] p;
    reg [15:0] q;
//    reg clk;
    reg [31:0] acc;
    wire [31:0] a;
    wire [25:0] b;
    wire [32:0] OUT,AOUT;
    reg error;
wallace uut(p, q, acc, a, b, OUT , AOUT);

//initial begin
//    clk = 0;
//    forever #5 clk = ~clk;
//end
always@(*)begin
error = (OUT!=AOUT);
end
initial begin

    acc = 0; 
    p = 16'h000F;
    q = 16'h0003;
    #20; 
    p = 16'hF0FF;
    q = 16'h00F0;
    #20;
    p = 0;
    q = 0;
    #20;
    acc=32'hF0000000;
    p = 16'hFFFF;
    q = 16'hFFFF;
    #20;
    acc=32'hA5A5A5A5;
p = 16'h3F00;
q = 16'h2D00;
#20;

acc=32'h12345678;
p = 16'hABCD;
q = 16'h1234;
#20;

acc=32'hFFFFFFFF;
p = 16'h0000;
q = 16'hFFFF;
#20;

acc=32'h00FF00FF;
p = 16'h7FFF;
q = 16'h8001;
#20;

acc=32'h87654321;
p = 16'hDEAD;
q = 16'hBEEF;
#20;

acc=32'h55555555;
p = 16'hAAAA;
q = 16'h5555;
#20;

acc=32'h33333333;
p = 16'hCCCC;
q = 16'h3333;
#20;

acc=32'hF0F0F0F0;
p = 16'h0F0F;
q = 16'hF0F0;
#20;

acc=32'h01234567;
p = 16'h89AB;
q = 16'hCDEF;
#20;

acc=32'hFEDCBA98;
p = 16'h7654;
q = 16'h3210;
#20;


    $stop; 
end
    
endmodule