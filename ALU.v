`define AND   4'b0000
`define OR    4'b0001
`define ADD   4'b0010
`define SUB   4'b0110
`define PassB 4'b0111


module ALU(BusW, Zero , BusA , BusB , ALUCtrl ) ;

input [63:0] BusA, BusB;
input [3:0] ALUCtrl;

output  Zero;
output reg[63:0] BusW;
reg inter_Zero;

always @(ALUCtrl or BusA or BusB) begin
    case (ALUCtrl)
    //does the and operation
        `AND : BusW = BusA & BusB;
    //does the or operation
       `OR :BusW = BusA | BusB;
    //does addition operation
        `ADD:BusW = BusA + BusB;
    //does the subtraction operation
       `SUB:BusW = BusA - BusB;
    //Passes B through to output
       `PassB:BusW = BusB;
    endcase
//checks if zero signal should be activated 
    if (BusW[63:0] == 64'b0) begin
       inter_Zero = 1'b1;

    end
    else begin
    inter_Zero = 1'b0;
    end
    
end

//drives zero with the ouput of the register value inter_zero in order to allow use to use behavioral implementation
assign Zero = inter_Zero;


    
endmodule