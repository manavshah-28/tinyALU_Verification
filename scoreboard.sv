module scoreboard(tinyalu_bfm bfm);
import tinyalu_pkg::*;

always @(posedge bfm.clk) begin
    shortint predicted_result;
    #1;
    case(bfm.op_set)
    add_op: predicted_result = bfm.A + bfm.B;
    and_op: predicted_result = bfm.A & bfm.B;
    xor_op: predicted_result = bfm.A ^ bfm.B;
    mul_op: predicted_result = bfm.A * bfm.B; 
    endcase

    if((bfm.op_set != no_op) && (bfm.op_set != rst_op))
    if(predicted_result != bfm.result)
    $error("Failed: A = %0d B: = %0d op = %s result = %0d",bfm.A, bfm.B, bfm.op_set, bfm.result);
end
endmodule