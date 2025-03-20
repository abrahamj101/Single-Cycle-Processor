module singlecycle(
		   input 	     resetl,
		   input [63:0]      startpc,
		   output reg [63:0] currentpc,
		   output [63:0]     MemtoRegOut,  // this should be
						   // attached to the
						   // output of the
						   // MemtoReg Mux
		   input 	     CLK
		   );

  //MUX 2 connections
  wire [63:0] MemtoRegIn;
  wire [63:0] ALU_input;

   // Next PC connections
   wire [63:0] 			     nextpc;       // The next PC, to be updated on clock cycle

   // Instruction Memory connections
   wire [31:0] 			     instruction;  // The current instruction

   // Parts of instruction
   wire [4:0] 			     rd;            // The destination register
   wire [4:0] 			     rm;            // Operand 1;
   wire [4:0] 			     rn;            // Operand 2
   wire [10:0] 			     opcode;

   // Control wires
   wire 			     reg2loc;
   wire 			     alusrc;
   wire 			     mem2reg;
   wire 			     regwrite;
   wire 			     memread;
   wire 			     memwrite;
   wire 			     branch;
   wire 			     uncond_branch;
   wire [3:0] 			     aluctrl;
   wire [2:0] 			     signop;

   // Register file connections
   wire [63:0] 			     regoutA;     // Output A
   wire [63:0] 			     regoutB;     // Output B

   // ALU connections
   wire [63:0] 			     aluout;
   wire 			            zero;

   // Sign Extender connections
   wire [63:0] 			     extimm;

   // PC update logic
   always @(negedge CLK)
     begin
        if (resetl)
          currentpc <= #3 nextpc;
        else
          currentpc <= #3 startpc;
     end

   // Parts of instruction
   assign rd = instruction[4:0];
   assign rn = instruction[9:5];//correct
   assign rm = reg2loc ? instruction[4:0] : instruction[20:16];//correct
   assign opcode = instruction[31:21];

   InstructionMemory imem(
			  .Data(instruction),
			  .Address(currentpc)
			  );

   control control(
		   .reg2loc(reg2loc),
		   .alusrc(alusrc),
		   .mem2reg(mem2reg),
		   .regwrite(regwrite),
		   .memread(memread),
		   .memwrite(memwrite),
		   .branch(branch),
		   .uncond_branch(uncond_branch),
		   .aluop(aluctrl),
		   .signop(signop),
		   .opcode(opcode)
		   );

   /*
    * Connect the remaining datapath elements below.
    * Do not forget any additional multiplexers that may be required.
    */
    // mux for ALUOTUP
    assign ALU_input = alusrc ? extimm:regoutB;
    assign MemtoRegOut = mem2reg ? MemtoRegIn:aluout;
    
    DataMemory DataMemory_1(
      .ReadData(MemtoRegIn),
      .Address(aluout),
      .WriteData(regoutB),
      .MemoryRead(memread),
      .MemoryWrite(memwrite),
      .Clock(CLK)
      );

    NextPClogic NexNextPClogic_1(//good
    .NextPC(nextpc),
    .CurrentPC(currentpc),
    .SignExtImm64(extimm),
    .Branch(branch),
    .ALUZero(zero),
    .Uncondbranch(uncond_branch)
    );

    RegisterFile RegisterFile_1(//good
    .BusA(regoutA),
    .BusB(regoutB),
    .BusW(MemtoRegOut),
    .RA(rn),
    .RB(rm),
    .RW(rd),
    .RegWr(regwrite),
    .Clk(CLK)
    );

    ALU ALU_1(//good
    .BusW(aluout),
    .Zero(zero),
    .BusA(regoutA),
    .BusB(ALU_input),
    .ALUCtrl(aluctrl)
    );

    Sign_Extender Sign_Extender_1(//good
    .BusImm(extimm),
    .Imm25(instruction[25:0]),
    .Ctrl(signop)
    );




    




endmodule

