module control_unit (
    input  wire [4:0] opcode_eff, 
    input  wire       funct7_fif,
    input  wire [2:0] funct3,     
    input  wire       BrEq,
    input  wire       BrLT,
    
    output wire       PCSel,
    output wire [2:0] ImmSel,
    output wire       RegWEn,
    output wire       BrUn,
    output wire       ASel,
    output wire       BSel,
    output wire [3:0] ALUSel,     
    output wire       MemRW,
    output wire [1:0] WBSel
);

    wire       Branch;
    wire       Jump;
    wire [1:0] ALUOp;

    main_decoder main_dec_inst (
        .opcode (opcode_eff),
        .Branch (Branch),
        .Jump   (Jump),
        .RegWEn (RegWEn),
        .ImmSel (ImmSel),
        .ASel   (ASel),
        .BSel   (BSel),
        .MemRW  (MemRW),
        .WBSel  (WBSel),
        .ALUOp  (ALUOp)
    );

    ALU_decoder alu_dec_inst (
        .ALUOp    (ALUOp),
        .opcode_5 (opcode_eff[3]), 
        .funct3   (funct3),
        .funct7_5 (funct7_fif),
        .ALUSel   (ALUSel)
    );

    reg Branch_Taken;

    always @(*) begin
        // Does not Branch by default
        Branch_Taken = 1'b0;

        if (Branch == 1'b1) begin
            case (funct3)
                3'b000: Branch_Taken = BrEq;   // BEQ: Branch if EQual
                3'b001: Branch_Taken = ~BrEq;  // BNE: Branch if Not EQual
                3'b100: Branch_Taken = BrLT;   // BLT: Branch if Less Than (signed)
                3'b101: Branch_Taken = ~BrLT;  // BGE: Branch if Greater or Equal (signed)
                3'b110: Branch_Taken = BrLT;   // BLTU: Branch if Less Than (Unsigned)
                3'b111: Branch_Taken = ~BrLT;  // BGEU: Branch if Greater or Equal (Unsigned)
                default: Branch_Taken = 1'b0;
            endcase
        end
    end

    // Assign the PCSel signal: Jump instructions always trigger a jump, 
    // or Branch instructions trigger a jump if the condition is met
    assign PCSel = Jump | Branch_Taken;

    // Set BrUn = 1 if it is an unsigned comparison instruction (BLTU or BGEU)
    assign BrUn = (funct3 == 3'b110 || funct3 == 3'b111) ? 1'b1 : 1'b0;

endmodule


