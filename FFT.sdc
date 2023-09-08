# operating conditions and boundary conditions #

set cycle  20       ;#clock period defined by designer #10

create_clock -period $cycle [get_ports  clk]
#create_clock -name "clk_virtual" -period 10 -waveform {0 5}


set_dont_touch_network      [get_clocks clk]
set_clock_uncertainty  0.1  [get_clocks clk]
set_ideal_network           [get_ports clk]

set_input_delay  1     -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 0.5    -clock clk [all_outputs] 
set_load         0.1     [all_outputs]
set_drive        0     [all_inputs]

set_operating_conditions  -max_library slow -max slow -min_library fast -min fast
set_wire_load_model -name tsmc13_wl10 -library slow                        

set_max_fanout 20 [all_inputs]