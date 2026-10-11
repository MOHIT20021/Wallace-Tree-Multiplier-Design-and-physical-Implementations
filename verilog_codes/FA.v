`timescale 1ns / 1ps

module FA( 
    input a, b, cin, 
    output s, cout
    );  

wire x, y, z;    
    
    xor (x, a, b);
    xor #1 (s, x, cin);
    
    and (y, a, b);
    and (z, x, cin);
    or  #1 (cout, y, z);

endmodule
