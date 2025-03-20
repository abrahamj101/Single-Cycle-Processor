
module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch); 
//initializing the inputs and outputs
       input [63:0] CurrentPC, SignExtImm64; 
       input Branch, ALUZero, Uncondbranch; 
       output reg [63:0] NextPC; 
   //always block to do behavioral logic
    always @(CurrentPC or SignExtImm64 or Branch or ALUZero or Uncondbranch) begin
        
      
    if (Uncondbranch) begin
        //does left shift of the offset that is sign extended before adding to pc
        NextPC = CurrentPC + (SignExtImm64 << 2);
        
       end 
    else if(Branch == 1'b1 & ALUZero == 1'b1)begin
        //we assumed that we shifted the bits to the left so it isn't an issue
        NextPC = CurrentPC + (SignExtImm64 << 2);
         
       end
    else
    begin
        //moves to next instruction
        NextPC = CurrentPC + 4;

    end
       end
endmodule