

module top(
    input  [3:0] a,       // 4-bit input A
    input  [3:0] b,       // 4-bit input B
    output [3:0] s,       // 4-bit sum output
    output       c_out    // Final carry-out
);
    wire [4:0] c;         // Internal carry chain

    // Initialize the first carry-in as 0
    assign c[0] = 1'b0;

    // Instantiate full adders
    fulladder f1 (.a(a[0]), .b(b[0]), .cin(c[0]), .sum(s[0]), .cout(c[1]));
    fulladder f2 (.a(a[1]), .b(b[1]), .cin(c[1]), .sum(s[1]), .cout(c[2]));
    fulladder f3 (.a(a[2]), .b(b[2]), .cin(c[2]), .sum(s[2]), .cout(c[3]));
    fulladder f4 (.a(a[3]), .b(b[3]), .cin(c[3]), .sum(s[3]), .cout(c[4]));

    // Assign the final carry-out
    assign c_out = c[4];
endmodule
module fulladder(
    input a,       // First input bit
    input b,       // Second input bit
    input cin,     // Carry input
    output sum,    // Sum output
    output cout    // Carry output
);
    // Full Adder Logic
    assign sum = a ^ b ^ cin;                // Sum calculation
    assign cout = (a & b) | (b & cin) | (cin & a); // Carry calculation
endmodule
`timescale 1ns/1ps

module t_b;
    // Inputs to the top module
    reg [3:0] a;
    reg [3:0] b;

    // Outputs from the top module
    wire [3:0] s;       // Sum output
    wire c_out;         // Final carry-out

    // Expected outputs
    reg [4:0] expected_result;

    // Flag to check correctness
    reg match;

    // Instantiate the top module
    top uut (
        .a(a),
        .b(b),
        .s(s),
        .c_out(c_out)
    );

    // Testbench process
    integer i, j;

    initial begin
        // Initialize
        $display("| A     | B     | S     | C_out | Exp S | Exp C | Match |");
        $display("|-------|-------|-------|-------|-------|-------|-------|");

        // Loop through all possible combinations of inputs
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Assign test inputs
                a = i[3:0];
                b = j[3:0];

                // Compute the expected result
                expected_result = a + b;

                // Wait for combinational logic to settle
                #5;

                // Check for match
                match = (s == expected_result[3:0]) && (c_out == expected_result[4]);

                // Display results
                $display("| %b | %b | %b |   %b   | %b |   %b   |   %s   |",
                         a, b, s, c_out, expected_result[3:0], expected_result[4], match ? "PASS" : "FAIL");
            end
        end

        // End simulation
        $stop;
    end
endmodule
