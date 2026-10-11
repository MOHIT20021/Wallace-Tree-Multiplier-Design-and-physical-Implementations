`timescale 1ns / 1ps


module HA(
    input a, b, 
    output s, cout
    );
    
    xor #1 (s, a, b);                             
    and #1 (cout, a, b);

endmodule
