`timescale 1ns / 1ps
module RegisterFile(BusA, BusB, BusW,RA,RB, RW, RegWr, Clk);
    output [63:0] BusA;
    output [63:0] BusB;
    input [4:0] RA;
    input [4:0] RB;
    input [63:0] BusW;
    input [4:0]RW;
    input RegWr;
    input Clk;
    reg [63:0] registers [31:0];
     initial
//initializes the registers
     begin
       for (integer i = 0 ;i<32 ; i++) begin
        registers[i] = i;
       end
       registers[31] = 64'b0;
     end

// sets bus to registers
    assign #2 BusA = registers[RA];
    assign #2 BusB = registers[RB];

   

     
    always @ (negedge Clk) begin
         

     if(RegWr && RW != 31) begin
        
        begin
            registers[RW] <= #3 BusW;
        end
       end

           
        end
     
    
endmodule
