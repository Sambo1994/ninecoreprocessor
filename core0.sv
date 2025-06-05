module core0 (
    input  logic        clk,
    input  logic        reset_n,
    input  logic [31:0] data_in,
    output logic [31:0] data_out,
    input  logic        valid_in,
    output logic        valid_out
);

    // Registers
    logic [31:0] reg_a, reg_b;
    logic [31:0] result;

    // Output valid signal
    logic        result_ready;

    // Simple state machine for processing
    typedef enum logic [1:0] {
        IDLE,
        LOAD,
        EXECUTE,
        DONE
    } state_t;

    state_t current_state, next_state;

    // State transition
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // State logic
    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE:     if (valid_in) next_state = LOAD;
            LOAD:     next_state = EXECUTE;
            EXECUTE:  next_state = DONE;
            DONE:     next_state = IDLE;
        endcase
    end

    // Main logic
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            reg_a <= 0;
            reg_b <= 0;
            result <= 0;
            result_ready <= 0;
        end else begin
            case (current_state)
                LOAD: begin
                    reg_a <= data_in[31:16]; // upper 16 bits
                    reg_b <= data_in[15:0];  // lower 16 bits
                end
                EXECUTE: begin
                    result <= reg_a & reg_b; // AND operation
                    result_ready <= 1;
                end
                DONE: begin
                    result_ready <= 0;
                end
            endcase
        end
    end

    assign data_out  = result;
    assign valid_out = result_ready;

endmodule
