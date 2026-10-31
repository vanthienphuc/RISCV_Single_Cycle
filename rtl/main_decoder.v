module main_decoder (
    input  wire [4:0]  opcode,
    output reg         Branch,
    output reg         Jump,
    output reg         RegWEn,
    output reg  [2:0]  ImmSel,
    output reg         ASel,
    output reg         BSel,
    output reg         MemRW,
    output reg  [1:0]  WBSel,
    output reg  [1:0]  ALUOp
);

    always @(*) begin
        Branch = 0; 
        Jump = 0; 
        RegWEn = 0; 
        ImmSel = 3'b000;
        ASel = 0; 
        BSel = 0; 
        MemRW = 0; 
        WBSel = 2'b00; 
        ALUOp = 2'b00;

        case (opcode)
            5'b01100: begin // R-Type
                RegWEn = 1; WBSel = 2'b01; ALUOp = 2'b10;
            end
            
            5'b00100: begin // I-Type
                RegWEn = 1; BSel = 1; WBSel = 2'b01; ALUOp = 2'b10;
            end
            
            5'b00000: begin // Load
                RegWEn = 1; BSel = 1;
            end
            
            5'b01000: begin // Store
                ImmSel = 3'b001; BSel = 1; MemRW = 1;
            end
            
            5'b11000: begin // Branch
                Branch = 1; ImmSel = 3'b010; ASel = 1; BSel = 1;
            end
            
            5'b11011: begin // JAL
                Jump = 1; RegWEn = 1; ImmSel = 3'b100; ASel = 1; BSel = 1; WBSel = 2'b10;
            end
            
            5'b11001: begin // JALR
                Jump = 1; RegWEn = 1; BSel = 1; WBSel = 2'b10;
            end
            
            5'b01101: begin // LUI
                RegWEn = 1; ImmSel = 3'b011; BSel = 1; WBSel = 2'b01;
            end
            
            5'b00101: begin // AUIPC
                RegWEn = 1; ImmSel = 3'b011; ASel = 1; BSel = 1; WBSel = 2'b01;
            end
            
            default: begin
            end
        endcase
    end

endmodule


