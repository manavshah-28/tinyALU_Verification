// bus functional model for tinyalu DUT.
// this is an interface which contains all signal level behaviour

interface tinyalu_bfm;

import tinyalu_pkg::*;

// define all signals of the DUT.

//inputs
byte unsigned A;
byte unsigned B;
bit clk;
bit reset_n;
wire [2:0] op;
bit start;

// outputs
wire done;
wire [15:0] result;
operation_t op_set; // from the typedef in tinyalu_pkg 
// this selects the opcode from the defined operations in the pkg.

// we now assign this operation to the op input wire of the DUT.
assign op = op_set;

// generate the clock
initial begin
    clk = 0;
    forever begin
        #10;
        clk = ~clk;
    end
end

// create a task for reset functionality of the ALU.
task reset_alu();
    // reset is active low so bring the reset signal low to begin with.
    reset_n = 1'b0;
    //wait for few clock cycles
    @(negedge clk);
    @(negedge clk);
    // deassert the reset
    reset_n = 1'b1;
    start = 0;
endtask : reset_alu

// create a task to send an operation to the DUT.
task send_op(input byte iA, input byte iB, input operation_t iop, output shortint alu_result);

// send the opcode to the DUT
op_set = iop;

// if reset operation, just do normal reset functionality.
if(iop == rst_op)begin
    @(posedge clk);
    reset_n = 1'b0;
    start = 1'b0;
    @(posedge clk);
    #1;
    reset_n = 1'b1; 
end 
else begin
    @(negedge clk);
    A = iA;
    B = iB;
    start = 1'b1;
    if(iop == no_op)begin // if no_op, just wait for a clock and de-assert start
        @(posedge clk);
        #1;
        start = 1'b0;
    end
    else begin // wait for done signal to go high and then de-assert start
        do 
        @(negedge clk);
        while (done == 0);
        start = 1'b0;
    end
end
endtask : send_op
endinterface