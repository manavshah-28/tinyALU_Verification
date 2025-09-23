module coverage(tinyalu_bfm bfm);
import tinyalu_pkg::*;

byte unsigned A;
byte unsigned B;
operation_t op_set;

covergroup op_cov;
    coverpoint op_set {
        bins single_cycle[] = {[add_op:xor_op], rst_op,no_op};
        bins multi_cycle = {mul_op};

        bins op_rst[] = ([add_op:mul_op] => rst_op); // some operation and then a reset
        bins rst_op[] = (rst_op => [add_op:mul_op]); // reset and then some operation

        bins sngl_mul[] = ([add_op:xor_op],no_op => mul_op); // single cycle operations followed by multicycle operations.
        bins mul_sngl[] = (mul_op => [add_op:xor_op],no_op); // multi cycle operations followed by single cycle operations.

        bins twoops[] = ([add_op:mul_op][*2]);
        bins manymult = (mul_op[*3:5]);
    }
endgroup

covergroup zeros_or_ones_on_ops;

all_ops: coverpoint op_set{
    ignore_bins null_ops = { rst_op, no_op};
}

a_leg: coverpoint A{
    bins zeros = {'h00};
    bins ones = {'hFF};
    bins others = {['h01:'hFE]};
}

b_leg: coverpoint B{
    bins zeros = {'h00};
    bins ones = {'hFF};
    bins others = {['h01:'hFE]};
}

op_00_FF: cross a_leg, b_leg, all_ops{
   bins add_00 = binsof (all_ops) intersect {add_op} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         bins add_FF = binsof (all_ops) intersect {add_op} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins and_00 = binsof (all_ops) intersect {and_op} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         bins and_FF = binsof (all_ops) intersect {and_op} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins xor_00 = binsof (all_ops) intersect {xor_op} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         bins xor_FF = binsof (all_ops) intersect {xor_op} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins mul_00 = binsof (all_ops) intersect {mul_op} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         bins mul_FF = binsof (all_ops) intersect {mul_op} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins mul_max = binsof (all_ops) intersect {mul_op} &&
                        (binsof (a_leg.ones) && binsof (b_leg.ones));

         ignore_bins others_only =
                                  binsof(a_leg.others) && binsof(b_leg.others);

}

endgroup

op_cov oc;
zeros_or_ones_on_ops c_00_FF;

initial begin : coverage_block
oc = new();
c_00_FF = new();
forever begin : sampling_block
@(negedge bfm.clk);
A = bfm.A;
B = bfm.B;
op_set = bfm.op_set;
oc.sample();
c_00_FF.sample();
end : sampling_block
end : coverage_block

endmodule : coverage