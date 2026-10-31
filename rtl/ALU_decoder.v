module ALU_decoder (
    input  wire [1:0] ALUOp,
    input  wire       opcode_5,
    input  wire [2:0] funct3,   
    input  wire       funct7_5, 
    output reg  [3:0] ALUSel
);

    always @(*) begin
        case (ALUOp)
            2'b00: begin
                ALUSel = 4'h0;
            end

            2'b10: begin
                case (funct3)
                    // ADD / SUB
                    3'b000: begin
                        if (opcode_5 == 1'b1 && funct7_5 == 1'b1) 
                            ALUSel = 4'h1; // SUB
                        else 
                            ALUSel = 4'h0; // ADD
                    end
                    
                    // AND
                    3'b111: ALUSel = 4'h2; 
                    
                    // OR
                    3'b110: ALUSel = 4'h3; 
                    
                    // XOR
                    3'b100: ALUSel = 4'h4; 
                    
                    // SLL 
                    3'b001: ALUSel = 4'h5; 
                    
                    // SRL / SRA 
                    3'b101: begin
                        if (funct7_5 == 1'b1) 
                            ALUSel = 4'h7; // SRA
                        else 
                            ALUSel = 4'h6; // SRL
                    end
                    
                    // SLT 
                    3'b010: ALUSel = 4'h8;

                    // SLTU / SLTIU
                    3'b011: ALUSel = 4'h9;  
                    default: ALUSel = 4'h0;
                endcase
            end

            default: begin
                ALUSel = 4'h0;
            end
        endcase
    end

endmodule


