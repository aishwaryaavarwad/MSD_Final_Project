package Definitions1;

import Declarations2::*;
import Declarations1::*;
import Definitions2::*;


// Task for address mappijng
task automatic address_mapping (input bit [33:0]address, 
				output add_map add_mapped);

add_mapped = address;

endtask

// Task to get next command
task automatic next_command (inout commands curr_cmd, input bit [1:0] operation, inout logic row_col);

unique case(curr_cmd)
ACT0: begin curr_cmd = ACT1; row_col = 0; end
ACT1: begin curr_cmd = (operation == 1)? WR0 : RD0; row_col = 1; end
RD0: begin curr_cmd = RD1; row_col = 1; end
RD1: begin curr_cmd = PRE; row_col = 'x; end
WR0: begin curr_cmd = WR1; row_col = 1; end
WR1: begin curr_cmd = PRE; row_col = 'x; end
PRE: begin curr_cmd = ACT0; row_col = 0; end
REF: begin curr_cmd = PRE; row_col = 'x; end
default : begin curr_cmd = ACT0; row_col = 0; end
endcase

endtask

// Task to generate output file
task automatic out_file_upd(input queue_str o, input bit [63:0] clock);
$display(" clock = %b,  output queue %p ", clock, o);
out_file=$fopen("dram.txt","a");
$fwrite(out_file, " %d\t%d\t%p\t%p\t%p\t", clock, o.add_mapped.channel, o.curr_cmd, o.add_mapped.bank_group, o.add_mapped.bank);   
if(o.row_col)
begin : col
$fwrite(out_file, " %h\n", {o.add_mapped.col_high, o.add_mapped.col_low[5:4]});  
end : col
else if(o.row_col == 0)
begin : row
$fwrite(out_file, " %h\n", o.add_mapped.row);  
end : row
else
begin : none
$fwrite(out_file, " \n");
end : none
$fclose(out_file);
endtask

task automatic remove_from_queue ();
  
   request_queue.pop_back();

endtask

endpackage
