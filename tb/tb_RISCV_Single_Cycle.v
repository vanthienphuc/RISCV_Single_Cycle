`timescale 1ns / 1ps

module tb_RISCV_Single_Cycle;

    reg rst_n;

    integer timeout_cnt;
    integer err_count;
    integer fd;
    reg [8*128-1:0] line; // Buffer for reading lines

    integer addr, expected, actual;
    integer code;
    integer inst_cnt;

    RISCV_Single_Cycle dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_RISCV_Single_Cycle);

        $readmemh("./mem/imem.hex", dut.IMEM_inst.memory);
        $readmemh("./mem/dmem_init.hex", dut.DMEM_inst.memory);

        clk = 0;
        rst_n = 0;
        inst_cnt = 0;
        timeout_cnt = 0;
        err_count = 0;
        #20;
        rst_n = 1;
    end

    always @(posedge clk) begin
        if (rst_n) begin
            timeout_cnt = timeout_cnt + 1;
            inst_cnt = inst_cnt + 1;

            actual = dut.Reg_inst.registers[7];

            if (actual === 32'd1) begin
                $display("========================================");
                $display(" [PASSED] ALL TESTS PASSED!");
                $display(" Total Instructions Executed = %0d", inst_cnt);
                $display(" Error Count = %0d", err_count);
                $display("========================================");
                $finish;
            end
            else if (actual === 32'hFFFF_FFFF) begin
                err_count = err_count + 1;
                $display("========================================");
                $display(" [FAILED] TEST FAILED AT INSTRUCTION %0d", inst_cnt);
                $display(" Total Errors = %0d", err_count);
                $display("========================================");
                $finish;
            end

            if (timeout_cnt > 1000) begin
                $display("========================================");
                $display(" [TIMEOUT] Simulation exceeded %0d cycles!", timeout_cnt);
                $display("========================================");
                $finish;
            end
        end
    end

endmodule



