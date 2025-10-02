interface tinyalu_bfm;
import tinyalu_pkg::*;

byte unsigned A;
byte unsigned B;
bit clk;
bit reset_n;
wire [2:0] op;
bit start;
wire done;
wire [15:0] result;

operation_t op_set;
assign op = op_set;

task reset_alu(); // reset is active low
 reset_n = 1'b0;  // bring reset to low
 @(negedge clk);  // wait for 2 clocks
 @(negedge clk);  // let it go high and de assert start bit 
 reset_n = 1'b1;
 start = 1'b0;
endtask : reset_alu

task send_op(input byte iA, input byte iB, input operation_t iop, output shortint alu_result);
 if(iop == rst_op) begin
 @(posedge clk);
 reset_n = 1'b0;
 start = 1'b0;
 @(posedge clk);
 #1;
 reset_n = 1'b1;
 end else begin
    @(negedge clk);
    op_set = iop;
    A = iA;
    B = iB;
    start = 1'b1;
    if(iop == no_op)begin
        @(posedge clk);
        #1;
        start = 1'b0;
    end else begin
        do 
        @(negedge clk);
        while (done == 0);
        alu_result = result;
        start = 1'b0;
    end
 end
endtask : send_op 

endinterface : tinyalu_bfm