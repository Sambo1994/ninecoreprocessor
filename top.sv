module top (
    input  logic        clk,
    input  logic        reset_n,
    input  logic [31:0] global_data_in,
    output logic [31:0] global_data_out
);

    // Shared signals
    logic [31:0] core_data_in   [0:8];
    logic [31:0] core_data_out  [0:8];
    logic        core_valid_in  [0:8];
    logic        core_valid_out [0:8];

    // Instantiate 8 logic cores
    generate
        genvar i;
        for (i = 0; i < 8; i++) begin : logic_cores
            logic_core core_inst (
                .clk(clk),
                .reset_n(reset_n),
                .data_in(core_data_in[i]),
                .data_out(core_data_out[i]),
                .valid_in(core_valid_in[i]),
                .valid_out(core_valid_out[i])
            );
        end
    endgenerate

    // Instantiate prediction core
    prediction_core pred_core (
        .clk(clk),
        .reset_n(reset_n),
        .data_in(core_data_in[8]),
        .data_out(core_data_out[8]),
        .valid_in(core_valid_in[8]),
        .valid_out(core_valid_out[8])
    );

    // Simple data routing logic (can be replaced with more advanced arbitration/interconnect)
    always_comb begin
        for (int j = 0; j < 9; j++) begin
            core_data_in[j]   = global_data_in;
            core_valid_in[j]  = 1'b1;
        end

        // Collect output - here just choose output from prediction core for demo
        global_data_out = core_data_out[8];  // You can modify this logic to combine or select outputs differently
    end

endmodule
