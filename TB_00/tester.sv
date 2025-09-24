// this is the Tester module which generates the test stimulus.
module tester(tinyalu_bfm bfm); // pass the bfm interface to this module

    // import the tinyalu package.
    import tinyalu_pkg::*;

    // funtion to get an opcode to send to the DUT
    function operation_t get_op();
    bit [2:0] op_choice;
    op_choice = $random; // create a random opcode
    case(op_choice)
    3'b000 : return no_op;
    3'b001 : return add_op;
    3'b010 : return and_op;
    3'b011 : return xor_op;
    3'b100 : return mul_op;
    3'b101 : return no_op;
    3'b110 : return rst_op;
    3'b111 : return rst_op;
    endcase
    endfunction : get_op

    // to keep getting interesting data, we randomize the selection of either all 0, all 1s or random data.
    function byte get_data();
    bit [1:0] zero_ones;
    zero_ones = $random; 

    if(zero_ones == 2'b 00)
    return 8'h00;
    else if(zero_ones == 2'b11)
    return 8'hFF;
    else return $random;
    endfunction : get_data
    // this get data function will give us all 0's and all ones 25%, 25% of times.
    // and we will get random data 50% of times

    // Start the actual Tester functions
    initial begin
        byte unsigned iA;
        byte unsigned iB;
        operation_t op_set;
        shortint result;

        bfm.reset_alu();
        repeat(1000) begin : random_loop
        op_set = get_op();
        iA = get_data();
        iB = get_data();
        bfm.send_op(iA,iB,op_set,result);
        end : random_loop
        $stop;
    end // initial begin
endmodule : tester