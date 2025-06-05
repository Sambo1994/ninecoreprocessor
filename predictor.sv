module predictor (
    input  logic        clk,
    input  logic        reset_n,
    input  logic [31:0] data_in,
    output logic [31:0] data_out,
    input  logic        valid_in,
    output logic        valid_out
);

    // Internal registers
    logic [31:0] history [0:3];  // Store last 4 inputs
    logic [1:0]  history_ptr;    // Pointer for circular buffer
    logic [31:0] predicted;

    // Output valid signal
    logic        result_ready;

    // State machine for control
    typedef enum logic [1:0] {
        IDLE,
        UPDATE_HISTORY,
        PREDICT,
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

    // Next state logic
    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE:            if (valid_in) next_state = UPDATE_HISTORY;
            UPDATE_HISTORY:  next_state = PREDICT;
            PREDICT:         next_state = DONE;
            DONE:            next_state = IDLE;
        endcase
    end

    // Main behavior
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            for (int i = 0; i < 4; i++) history[i] <= 0;
            history_ptr   <= 0;
            predicted     <= 0;
            result_ready  <= 0;
        end else begin
            case (current_state)
                UPDATE_HISTORY: begin
                    history[history_ptr] <= data_in;
                    history_ptr <= history_ptr + 1;
                end
                PREDICT: begin
                    // Simple prediction: average of previous inputs
                    predicted <= (history[0] + history[1] + history[2] + history[3]) >> 2;
                    result_ready <= 1;
                end
                DONE: begin
                    result_ready <= 0;
                end
            endcase
        end
    end

    assign data_out  = predicted;
    assign valid_out = result_ready;

endmodule
