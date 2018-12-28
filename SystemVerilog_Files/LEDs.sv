module LEDs (Reset, clk, won, LEDR);
	input logic Reset, clk, won;
	output logic [9:0] LEDR;
	
	logic [9:0] ps;
	logic [9:0] ns;
	logic [9:0] off, on;
	
	//localparam A = 3'b001;

	assign off = 10'b0000000000;
	assign on = 10'b1111111111;
	
	// Next State logic
	always_ff @(posedge clk) 
		case (ps)
			off: if (won) ns = on;
				  else ns = off;
			on:  ns = off;
				
			default: ns = off;
		endcase


	assign LEDR = ps;

	// DFFs
	always_ff @(posedge clk) begin
		if (Reset)
			ps <= off;
		else
			ps <= ns;
	end

endmodule 

module LEDs_testbench();
	logic Reset, clk;
	logic [9:0] LEDR;
	logic won;
	
	LEDs dut (Reset, clk, won, LEDR);
	
	// Set up the clock.   
	parameter CLOCK_PERIOD = 100;   
	initial begin 
		clk <= '0;  
		forever #( CLOCK_PERIOD / 2 ) clk <= ~clk;   
	end      
	
	// Set up the inputs to the design.  Each line is a clock cycle.   
initial begin                        
				   @(posedge clk);    
	Reset <= 1; won <= 0; @(posedge clk);    
	Reset <= 0; won <= 0; @(posedge clk);                        
								@(posedge clk);                         
								@(posedge clk);                        
              won <= 1; @(posedge clk);                
               @(posedge clk);                
               @(posedge clk);                 
               @(posedge clk);                        
               @(posedge clk);                         
               @(posedge clk);                        
               @(posedge clk);                 
               @(posedge clk);                        
               @(posedge clk);   
               @(posedge clk);
               @(posedge clk); 	
               @(posedge clk); 
               @(posedge clk); 	
               @(posedge clk); 
               @(posedge clk);
               @(posedge clk); 
               @(posedge clk);					
	$stop; // End the simulation.   
end  
endmodule
