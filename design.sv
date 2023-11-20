
import Declarations1::*;
import Definitions1::*;

module DRAM_Commands;

// input for test
initial begin
done = 0;
clock = 2;
queue_in[0].in_data.time_CPU_clock_cycles = 20;
queue_in[0].in_data.core = 1;
queue_in[0].in_data.operation = 2;
queue_in[0].in_data.address = 'h12345638;
$display("done = %b, clock = %b, input file %p", done, clock, queue_in[0].in_data);
address_mapping(queue_in[0].in_data.address, queue_in[0].add_mapped);
end
// end of inputs


initial
begin : initial_blk

queue_row = queue_in[0];
$display(" queue_row %p", queue_row );
while (!done)
begin : while_done

if(!(clock%2))
begin : DIMM_clk
$display(" DIMM Clock");

next_command (queue_row.curr_cmd, queue_row.in_data.operation, queue_row.row_col);
$display(" next command %b", queue_row .curr_cmd);
$display(" Upload output file clock %b", clock);
out_file_upd(queue_row, clock);
//end : initial_cmd

end : DIMM_clk

else
begin : else_DIMM_clock
$display("else  DIMM Clock");
end : else_DIMM_clock

if(queue_row.curr_cmd == PRE)
remove_from_queue ();

clock++;

/* Add code for setting done
if()
begin : set_done
end : set_done
*/
end : while_done

end : initial_blk

endmodule
