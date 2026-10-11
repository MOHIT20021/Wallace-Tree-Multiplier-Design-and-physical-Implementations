`timescale 1ns / 1ps

 module wallace(
    input [15:0] p,
    input [15:0] q,
    input [31:0] acc,
    output [31:0] a,
    output [25:0] b
//    ,output [32:0] OUT,AOUT 
    );
    
wire [15:0] pq [15:0];
genvar i, j;
generate
    for (i = 0; i < 16; i = i + 1) begin: mult
        for (j = 0; j < 16; j = j + 1) begin: mult2
            and (pq[i][j], p[i], q[j]);
        end
    end
endgenerate


/////////////////////////////////////////// CAP LAYER 13 st2 ////////////////////////////////   
wire [32:0] st2 [11:0];  


HA ha0 (pq[0][0], acc[0], st2[0][0], st2[1][1]);
//1st layers of full adders
integer wires = 1;
genvar i1,i2,i3,i4,i5,i6,i7,i8,i9,i10;

generate 
// 1st FA
    for (i1=1;i1<16;i1=i1+1)begin: loop1
        FA uut1 (acc[i1], pq[0][i1], pq[1][i1-1], st2[0][i1], st2[1][i1+1]);
    end

    for (i2=1;i2<15;i2=i2+1)begin: loop2
        FA uut2 (acc[i2+15], pq[i2][15], pq[i2+1][14], st2[0][i2+15], st2[1][i2+16]);
    end    

// 2nd FA
    for (i3=2;i3<14;i3=i3+1)begin: loop3
        FA uut3 (pq[2][i3], pq[3][i3-1], pq[4][i3-2], st2[2][i3+2], st2[3][i3+3]);
    end

    for (i4=3;i4<14;i4=i4+1)begin: loop4
        FA uut4 (pq[i4][13], pq[i4+1][12], pq[i4+2][11], st2[2][i4+13], st2[3][i4+14]);
    end

// 3rd FA 
    for (i5=2;i5<11;i5=i5+1)begin: loop5
        FA uut5 (pq[5][i5], pq[6][i5-1], pq[7][i5-2], st2[4][i5+5], st2[5][i5+6]);
    end   

    for (i6=6;i6<14;i6=i6+1)begin: loop6
        FA uut6 (pq[i6][10], pq[i6+1][9], pq[i6+2][8], st2[4][i6+10], st2[5][i6+11]);
    end     
    
///4th FA    
    for (i7=2;i7<8;i7=i7+1)begin: loop7
        FA uut7 (pq[8][i7], pq[9][i7-1], pq[10][i7-2], st2[6][i7+8], st2[7][i7+9]);
    end
     
    for (i8=9;i8<14;i8=i8+1)begin: loop8
        FA uut8 (pq[i8][7], pq[i8+1][6], pq[i8+2][5], st2[6][i8+7], st2[7][i8+8]);
    end     

/// 5th FA

    for (i9=2;i9<5;i9=i9+1)begin: loop9
        FA uut9 (pq[11][i9], pq[12][i9-1], pq[13][i9-2], st2[8][i9+11], st2[9][i9+12]);
    end     
    
    for (i10=12;i10<14;i10=i10+1)begin: loop10
        FA uut10 (pq[i10][4], pq[i10+1][3], pq[i10+2][2], st2[8][i10+4], st2[9][i10+5]);
    end 
    
endgenerate

assign st2[2][2] = pq[2][0];
assign st2[2][3] = pq[2][1];
assign st2[4][6] = pq[5][1];
assign st2[5][6] = pq[6][0];
assign st2[8][11] = pq[11][0];
assign st2[8][12] = pq[11][1];
assign st2[10][15] = pq[14][1];
assign st2[11][15] = pq[15][0];
assign st2[8][19] = pq[15][4];
assign st2[8][18] = pq[14][4];
assign st2[6][21] = pq[14][7];
assign st2[8][21] = pq[15][6];
assign st2[4][24] = pq[14][10];
assign st2[2][27] = pq[14][13];
assign st2[2][28] = pq[15][13];
assign st2[0][30] = acc[30];
assign st2[2][30] = pq[15][15];



//////////////////////////////////////////CAP LAYER 9 st3  ////////////////

wire [32:0] st3 [8:0] ;
 
HA ha1 ( st2[0][1] , st2[1][1] , st3[0][1] , st3[1][2] );

/// LAYERS OF FA

genvar j1,j2,j3;
generate 
    for ( j1=2;j1<29;j1=j1+1) begin :loopj1
         FA uutj1 (st2[0][j1], st2[1][j1], st2[2][j1], st3[0][j1], st3[1][j1+1]);
    end
    
    for(j2=8;j2<25;j2=j2+1) begin : loopj2
        FA uutj2 (st2[3][j2], st2[4][j2], st2[5][j2], st3[2][j2], st3[3][j2+1]);
    end
    
    for( j3=11;j3<20;j3=j3+1) begin : loopj3 
        FA uutj3 (st2[6][j3], st2[7][j3], st2[8][j3], st3[4][j3], st3[5][j3+1]);
    end
    
endgenerate    
// Inidivisual FA  
FA fa2_1 (st2[3][6], st2[4][6], st2[5][6], st3[2][6], st3[3][7]);
FA fa2_2 (st2[9][15], st2[10][15], st2[11][15], st3[6][15], st3[7][16]);
FA fa2_3 (st2[6][21], st2[7][21], st2[8][21], st3[4][21], st3[5][22]);
FA fa2_4 (st2[0][30], st2[1][30], st2[2][30], st3[0][30], st3[1][31]);


//assign 

assign st3[2][3] = pq[3][0];
assign st3[2][5] = st2[3][5];
assign st3[2][7] = st2[4][7];
assign st3[4][9] = pq[8][1];
assign st3[5][9] = pq[9][0];
assign st3[6][16] = pq[15][1];
assign st3[8][16] = st2[9][16];
assign st3[4][20] = st2[7][20];
assign st3[4][22] = pq[15][7];
assign st3[2][25] = pq[15][10];
assign st3[2][26] = st2[3][26];
assign st3[2][27] = st2[3][27];
assign st3[0][29] = st2[1][29];
assign st3[2][29] = st2[0][29];






/////////////////////////////////////// CAP LAYER 6  st4 ///////////////////////////

wire [32:0] st4 [5:0] ;
 
HA ha2 ( st3[0][2] , st3[1][2] , st4[0][2] , st4[1][3] );

genvar k1,k2;

/// LAYERS OF FA
generate 
    
    for(k1=5; k1<28; k1=k1+1) begin : loopk1
        FA uutk1 (st3[0][k1], st3[1][k1], st3[2][k1], st4[0][k1], st4[1][k1+1]);
    end
    
    for(k2=12; k2<21; k2=k2+1) begin : loopk2
        FA uutk2 (st3[3][k2], st3[4][k2], st3[5][k2], st4[2][k2], st4[3][k2+1]);
    end    
    
endgenerate

// layer of  FA
FA fa3_1 (st3[0][3], st3[1][3], st3[2][3], st4[0][3], st4[1][4]);
FA fa3_2 (st3[3][9], st3[4][9], st3[5][9], st4[2][9], st4[3][10]);
FA fa3_3 (st3[6][16], st3[7][16], st3[8][16], st4[4][16], st4[5][17]);
FA fa3_4 (st3[3][22], st3[4][22], st3[5][22], st4[2][22], st4[3][23]);
FA fa3_5 (st3[0][29], st3[1][29], st3[2][29], st4[0][29], st4[1][30]);

// assign 
assign st4[0][4] = st3[1][4];
assign st4[2][4] = st3[0][4];
assign st4[2][7] = st3[3][7];
assign st4[2][8] = pq[8][0];
assign st4[2][10] = st2[6][10];
assign st4[2][11] = st3[3][11];
assign st4[4][14] = st2[9][14];
assign st4[5][14] = pq[14][0];
assign st4[4][15] = st3[6][15];
assign st4[4][17] = st2[9][17];
assign st4[4][18] = st2[9][18];
assign st4[5][18] = pq[15][3];
assign st4[2][21] = st3[3][21];
assign st4[2][23] = st3[3][23];
assign st4[2][24] = st3[3][24];
assign st4[2][25] = st3[3][25];
assign st4[0][28] = st3[1][28];
assign st4[2][28] = st3[0][28];
assign st4[2][27] = pq[15][12];




////////////////////////////////////// CAP LAYER 4 st5
wire [32:0] st5 [3:0] ;

HA ha3 ( st4[0][3] , st4[1][3] , st5[0][3] , st5[1][4] );

/// FA 
genvar m1;
generate 
    for ( m1=7;m1<26;m1=m1+1)begin: loopm1
         FA uutm1 (st4[0][m1], st4[1][m1], st4[2][m1], st5[0][m1], st5[1][m1+1]);
    end
endgenerate 

// FA layers 
FA fa4_1 (st4[0][4], st4[1][4], st4[2][4], st5[0][4], st5[1][5]);
FA fa4_2 (st4[3][14], st4[4][14], st4[5][14], st5[2][14], st5[3][15]);
FA fa4_3 (st4[3][17], st4[4][17], st4[5][17], st5[2][17], st5[3][18]);
FA fa4_4 (st4[3][18], st4[4][18], st4[5][18], st5[2][18], st5[3][19]);
FA fa4_5 (st4[0][27], st4[1][27], st4[2][27], st5[0][27], st5[1][28]);
FA fa4_6 (st4[0][28], st4[1][28], st4[2][28], st5[0][28], st5[1][29]);
//// HA layers

HA ha4_1 ( st4[3][15] , st4[4][15] , st5[2][15] , st5[3][16] );
HA ha4_2 ( st4[3][16] , st4[4][16] , st5[2][16] , st5[3][17] );

assign st5[0][5] = pq[5][0];
assign st5[2][5] = st4[0][5];
assign st5[2][13] = st4[3][13];
assign st5[2][12] = pq[12][0];
assign st5[2][11] = st3[4][11];
assign st5[2][10] = st4[3][10];
assign st5[2][21] = st4[3][21];
assign st5[2][20] = st4[3][20];
assign st5[2][19] = st4[3][19];
assign st5[2][23] = st4[3][23];
assign st5[2][24] = pq[15][9];
assign st5[2][25] = st2[3][25];
assign st5[0][26] = st4[1][26];
assign st5[2][26] = st4[0][26];







/////////////////////////////////////////CAP LAYERA 3 st6//////////////////////
wire [32:0] st6 [2:0];

HA ha4 ( st5[0][4] , st5[1][4] , st6[0][4] , st6[1][5] );

genvar n1;
generate 
    for( n1=10;n1<22;n1=n1+1)begin:loopn1     
        FA uutn1 (st5[0][n1], st5[1][n1], st5[2][n1], st6[0][n1], st6[1][n1+1]);
    end
endgenerate
/// LAYERS OF FA 
FA fa5_1 (st5[0][23], st5[1][23], st5[2][23], st6[0][23], st6[1][24]);
FA fa5_2 (st5[0][24], st5[1][24], st5[2][24], st6[0][24], st6[1][25]);
FA fa5_3 (st5[0][25], st5[1][25], st5[2][25], st6[0][25], st6[1][26]);
FA fa5_4 (st5[0][26], st5[1][26], st5[2][26], st6[0][26], st6[1][27]);
FA fa5_5 (st5[0][5], st5[1][5], st5[2][5], st6[0][5], st6[1][6]);


assign st6[0][6] = st4[1][6];
assign st6[2][6] = st4[0][6];
assign st6[0][7] = st2[3][7];
assign st6[1][7] = st5[0][7];
assign st6[0][8] = st5[1][8];
assign st6[1][8] = st5[0][8];
assign st6[0][9] = st5[1][9];
assign st6[1][9] = st5[0][9];
assign st6[1][10] = st3[3][10];


assign st6[0][22] = st5[1][22];




assign st6[2][22] = st5[0][22];
assign st6[2][21] = st3[4][21];
assign st6[2][20] = st2[6][20];
assign st6[2][19] = st5[3][19];
assign st6[2][18] = st5[3][18];
assign st6[2][17] = st5[3][17];
assign st6[2][16] = st5[3][16];
assign st6[2][15] = st5[3][15];


/////////////////////////////////////// CAP LAYERS 2 st7 /////////////////////////////////

wire [32:0] st7 [1:0] ;
HA ha5 ( st6[0][5] , st6[1][5] , st7[0][5] , st7[1][6] );

genvar v1,v2;
generate 
    for(v1=7;v1<15;v1=v1+1)begin:loopv1
       HA uutv1 ( st6[0][v1] , st6[1][v1] , st7[0][v1] , st7[1][v1+1] ); 
    end 
    
    
    for(v2=15;v2<23;v2=v2+1) begin: loopv2
        FA uutv2 (st6[0][v2], st6[1][v2], st6[2][v2], st7[0][v2], st7[1][v2+1]);
    end
endgenerate


// FA 
FA fa6_1 (st6[0][6], st6[1][6], st6[2][6], st7[0][6], st7[1][7]);


assign a[31] = acc[31];
assign a[30] = st4[1][30];
assign a[29] = st4[0][29];
assign a[28] = st5[0][28];
assign a[27] = st5[0][27];
assign a[26] = st6[0][26];
assign a[25] = st6[0][25];
assign a[24] = st6[0][24];
assign a[23] = st6[0][23];
assign a[22] = st7[0][22];
assign a[21] = st7[0][21];
assign a[20] = st7[0][20];
assign a[19] = st7[0][19];
assign a[18] = st7[0][18];
assign a[17] = st7[0][17];
assign a[16] = st7[0][16];
assign a[15] = st7[0][15];
assign a[14] = st7[0][14];
assign a[13] = st7[0][13];
assign a[12] = st7[0][12];
assign a[11] = st7[0][11];
assign a[10] = st7[0][10];
assign a[9]  = st7[0][9];
assign a[8]  = st7[0][8];
assign a[7]  = st7[0][7];
assign a[6]  = st7[0][6];
assign a[5]  = st7[0][5];
assign a[4]  = st6[0][4];
assign a[3]  = st5[0][3];
assign a[2]  = st4[0][2];
assign a[1]  = st3[0][1];
assign a[0]  = st2[0][0];

assign b[25] = st3[1][31];
assign b[24] = st3[0][30];
assign b[23] = st5[1][29];
assign b[22] = st5[1][28];
assign b[21] = st6[1][27];
assign b[20] = st6[1][26];
assign b[19] = st6[1][25];
assign b[18] = st6[1][24];
assign b[17] = st7[1][23];
assign b[16] = st7[1][22];
assign b[15] = st7[1][21];
assign b[14] = st7[1][20];
assign b[13] = st7[1][19];
assign b[12] = st7[1][18];
assign b[11] = st7[1][17];
assign b[10] = st7[1][16];
assign b[9]  = st7[1][15];
assign b[8]  = st7[1][14];
assign b[7]  = st7[1][13];
assign b[6]  = st7[1][12];
assign b[5]  = st7[1][11];
assign b[4]  = st7[1][10];
assign b[3]  = st7[1][9];
assign b[2]  = st7[1][8];
assign b[1]  = st7[1][7];
assign b[0]  = st7[1][6];



//assign OUT =  a + (b<<6);
//assign AOUT = acc + p*q; 
endmodule
