module Immediate_Generator (
    input  wire [31:0] Inst,   
    input  wire [2:0]  ImmSel, 
    output reg  [31:0] Imm     
);

    localparam IMM_I = 3'b000; 
    localparam IMM_S = 3'b001; 
    localparam IMM_B = 3'b010; 
    localparam IMM_U = 3'b011; 
    localparam IMM_J = 3'b100; 

    always @(*) begin
        case (ImmSel)
            IMM_I: begin
                Imm = {{20{Inst[31]}}, Inst[31:20]};
            end

            IMM_S: begin
                Imm = {{20{Inst[31]}}, Inst[31:25], Inst[11:7]};
            end

            IMM_B: begin
                Imm = {{20{Inst[31]}}, Inst[7], Inst[30:25], Inst[11:8], 1'b0};
            end

            IMM_U: begin
                Imm = {Inst[31:12], 12'b0};
            end

            IMM_J: begin
                Imm = {{12{Inst[31]}}, Inst[19:12], Inst[20], Inst[30:21], 1'b0};
            end

            default: begin
                Imm = 32'b0;
            end
        endcase
    end

endmodule

