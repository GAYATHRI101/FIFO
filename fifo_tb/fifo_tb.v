//simple verilog testbench to verify fifo 16X8
module fifo_tb;
  
 parameter DEPTH=16,WIDTH=8,ADDR=4;//parameters 
  
  integer i;
  reg clk,reset;
  reg [WIDTH-1:0]data_in;
  reg wr_enb,rd_enb;
  wire [WIDTH-1:0]data_out;
  wire full,empty;
  //integer i;
  
  //clk generation
  always
    begin
    	#10 clk=~clk;
    end  
 
  //instantiation
  fifo dut(clk,reset,data_in,wr_enb,rd_enb,full,empty,data_out);
  
  initial
    begin
    
      clk=1'b1;
      reset=1;
      #10;
      reset=0;
 	for(i=0;i<16;i=i+1)
	begin
		@(posedge clk);
		wr_enb=1;
		rd_enb=0;
		data_in={$random};
	end
	for(i=0;i<16;i=i+1)
	begin
		@(posedge clk);
		wr_enb=0;
		rd_enb=1;

	end


    
      #1000 $finish;
    end

  initial
    begin
    $monitor($time,"data_out=%d,wr_enb=%d,rd_enb=%d,data_in=%d,dut.wr_ptr=%d,full=%d,empty=%d",
		    data_out,wr_enb,rd_enb,data_in,dut.wr_ptr,full,empty);
    end

  
endmodule
