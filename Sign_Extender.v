module Sign_Extender(BusImm, Imm25, Ctrl);
//need to account I-type, LD/Stur,

 output reg [63:0] BusImm; 
  //25bit instruction passed through
  input [25:0] Imm25; 
   //determines what instruction sign extension to run 
  input [2:0]Ctrl; 

 
   
always @(*) begin
  // D type is 00, I/R type is 01, B type is 10, CB type is 11
case (Ctrl)
  3'b000: BusImm = {{{56{Imm25[20]}}, Imm25[20:12]}};  //D
  3'b001:   BusImm = {{{58{Imm25[21]}}, Imm25[21:10]}}; // I/R
  3'b010: BusImm = {{{39{Imm25[25]}}, Imm25[25:0]}}; //B type
  3'b011:  BusImm = {{{45{Imm25[23]}}, Imm25[23:5]}};
  3'b111: BusImm = Imm25[20:5] << (Imm25[22:21]*16); 
    
 
endcase
end



endmodule