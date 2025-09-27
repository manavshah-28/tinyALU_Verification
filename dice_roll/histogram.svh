class histogram extends uvm_subscriber #(int);
`uvm_component_utils(histogram);

int rolls[int];

function new(string name, uvm_component parent);
super.new(name,parent);
for(int i = 2; i < 12; i++) rolls[i] = 0;
endfunction : new

function void write(int t);
 rolls[t] ++;
endfunction

function void report_phase(uvm_phase phase);
    string bar;
    string message;

    message = "\n";
    foreach(rolls[i])begin
        string roll_msg;
        bar = "";
        repeat(rolls[i]) bar = {bar, "#"};
        roll_msg = $sformatf("%2d: %s\n", i, bar);
        message = {message,roll_msg};
    end
    $display(message);
endfunction : report_phase
endclass : histogram 