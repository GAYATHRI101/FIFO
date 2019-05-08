

//FIFO WITH DEPTH 16 AND WIDTH 8
module fifo # (parameter DEPTH=16,WIDTH=8,ADDR=5)
	      (input clk,reset,input [WIDTH-1:0]data_in,input wr_enb,rd_enb,output full,empty,output reg [WIDTH-1:0]data_out);

  integer i;				//variable for iteration
  reg [ADDR-1:0]wr_ptr,rd_ptr;  	//read and write pointer for traversing through the fifo(bits=(2^4=16,depth) we need 4 bits to represent 16 locations 
  					//here we are taking ptr of 5 bits
					//because if its 4bit the 15th location of fifo is not written since its fisrt incremented and then written
  reg [WIDTH-1:0]mem[DEPTH-1:0];	//memory for storage to depict functionality of fifo

    //memory logic
    always@(posedge clk)	//synchronous to clk,sybchronous reset
        begin
            if(reset)
                begin
                    data_out<=0;
                    for(i=0;i<DEPTH;i=i+1)	//clearing memory
                        begin
                            mem[i]<=0;
                        end
                end
                    else
                        begin
                                if(wr_enb&&~full)
                                    begin
                                            mem[wr_ptr]<=data_in;	//writing into the memory when fifo isn't full	
                                    end
                                if(rd_enb&&~empty)
                                    begin
                                            data_out<=mem[rd_ptr];	//reading from the memory when fifo isn't empty
                                    end
                        end
        end

	//address logic
        always@(posedge clk)
            begin
                    if(reset)
                        begin
                                wr_ptr<=0;
                                rd_ptr<=0;
                        end
                            else
                                begin
                                  if(wr_enb&&~full)
                                            begin
                                                    wr_ptr<=wr_ptr+1;	//incrementing write pointer
                                            end
                                  if(rd_enb&&~empty)
                                            begin
                                                    rd_ptr<=rd_ptr+1;	//incrementing read pointer
                                            end

                                end
            end
  

	assign empty=(wr_ptr==rd_ptr)?1'b1:1'b0;			//indicates fifo is empty
	assign full=(wr_ptr=={~rd_ptr[4],rd_ptr[3:0]})?1'b1:1'b0;	//indicates fifo is full

endmodule


