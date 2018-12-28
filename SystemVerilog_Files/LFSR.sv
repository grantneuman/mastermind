module LFSR(Reset, clk, switch, Q);
	input  logic clk;
	input  logic Reset;
	input logic switch;
	
	localparam NumOfBit = 8;
	output logic [ NumOfBit : 1 ] Q;
	logic D;


	xnor( D, Q[ 8 ], Q[ 6 ], Q[ 5 ], Q[ 4 ], &Q[ NumOfBit - 1 : 1 ] );

	always_ff @( posedge clk ) begin
		if ( Reset ) begin
			Q <= 0;
		end else if (switch) begin
			Q <= { Q[ NumOfBit - 1 : 1 ], D };
		end
	end

endmodule 

module LFSR_testbench();   
	logic  clk, reset, switch;

	localparam NumOfBit = 8;
	logic [ NumOfBit : 1 ] Q;

	LFSR dut( .Reset(reset), .clk(clk), .switch(switch), .Q(Q) );      

	// Set up the clock.   
	parameter CLOCK_PERIOD = 100;   
	initial begin 
		clk <= '0;  
		forever #( CLOCK_PERIOD / 2 ) clk <= ~clk;   
	end      

	// Set up the inputs to the design.  Each line is a clock cycle.   
	initial begin                        
						@(posedge clk);    
		reset <= 1;  @(posedge clk); 
						@(posedge clk);
		reset <= 0; switch <= 1; @(posedge clk);                        
						@(posedge clk);                        
						@(posedge clk);                        
						@(posedge clk);                
						@(posedge clk);                
				switch <= 0;		@(posedge clk);                
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