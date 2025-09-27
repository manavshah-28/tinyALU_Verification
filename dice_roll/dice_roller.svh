class dice_roller extends uvm_component;
`uvm_component_utils(dice_roller);

uvm_analysis_port #(int) roll_ap; // declare a variable that holds the analysis port. : roll_ap

// now instantiate the port roll_ap in build phase
function void build_phase (uvm_phase phase);
roll_ap = new("roll_ap", this);
endfunction : build_phase

rand byte die1;
rand byte die2;

constraint c_6{
    die1 inside {[1:6]};
    die2 inside {[1:6]};
}

// we generate dice rolls and write them to indefinite number of objects. (twitter)
task run_phase(uvm_phase phase);

    int the_roll;
    phase.raise_objection(this);
    void'(randomize());

    repeat(200)begin
    void'(randomize());
    the_roll = die1 + die2;
    roll_ap.write(the_roll); // we call the write method of the ap and pass it the data
    end
    // we dont worry about who is using our data or if anyone is using it
    phase.drop_objection(this);
endtask : run_phase

function new(string name, uvm_component parent);
 super.new(name,parent);
endfunction : new

endclass : dice_roller