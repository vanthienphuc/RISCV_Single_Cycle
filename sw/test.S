.section .text
.global main

main:
    # TEST 1: JAL instruction and pipeline flush
    jal x0, test_alu

    # JAL failure trap
    addi x7, x0, -1
    beq x0, x0, end

test_alu:
    # TEST 2: Basic R-Type and I-Type instructions
    addi x2, x0, 5       # x2 = 5
    addi x3, x0, 10      # x3 = 10
    add x4, x2, x3       # x4 = 15
    sub x5, x3, x2       # x5 = 5

    # TEST 3: Unsigned comparison instructions (SLTU and SLTIU)
    addi x8, x0, -1      # x8 = 0xFFFFFFFF

    sltu x9, x2, x8      # x9 = 1 if 5 < x8 (unsigned)
    sltiu x10, x8, 10    # x10 = 0 if x8 >= 10 (unsigned)

    # Verify comparison results
    addi x11, x0, 1
    bne x9, x11, fail    # Fail if SLTU result is not 1
    bne x10, x0, fail    # Fail if SLTIU result is not 0

    # TEST 4: Store and Load instructions
    addi x1, x0, 64
    sw x4, 0(x1)         # Store 15 at address 64
    lw x6, 0(x1)         # Load the value into x6

    # TEST 5: Final branch check
    beq x4, x6, success  # Pass if x4 == x6

fail:
    addi x7, x0, -1      # Indicate test failure
    beq x0, x0, end

success:
    addi x7, x0, 1       # Indicate test success

end:
    beq x0, x0, end      # Infinite loop


