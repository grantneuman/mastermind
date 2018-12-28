module HEXDisplay (Reset, clk, guessedDigit, HEX);
	input logic Reset, clk;
	input logic [1:0] guessedDigit;
	
	output logic [6:0] HEX;
	
	logic [6:0] off, zero, one, two, three, ps, ns;
	
	assign zero = 7'b1000000;
	assign one = 7'b1111001;
	assign two = 7'b0100100;
	assign three = 7'b0110000;
	assign off = 7'b1111111;
	
	always_comb begin
		case (guessedDigit)
			2'b00: ns = zero;
			2'b01: ns = one;
			2'b10: ns = two;
			2'b11: ns = three;
			default: ns = off;
		endcase
	end
	
	assign HEX = ps;
	
	always_ff @(posedge clk) begin
		if (Reset)
			ps <= off;
		else 
			ps <= ns;
	end
	
endmodule

module HEXDisplay_testbench();
	logic Reset, clk;
	logic [6:0] HEX;
	logic [1:0] guessedDigit;
	
	HEXDisplay dut (Reset, clk, guessedDigit, HEX);
	
	// Set up the clock.   
	parameter CLOCK_PERIOD = 100;   
	initial begin 
		clk <= '0;  
		forever #( CLOCK_PERIOD / 2 ) clk <= ~clk;   
	end      
	
	// Set up the inputs to the design.  Each line is a clock cycle.   
initial begin                        
				   @(posedge clk);    
	Reset <= 1; guessedDigit <= 2'b00; @(posedge clk);    
	Reset <= 0; guessedDigit <= 2'b00; @(posedge clk);                        
           guessedDigit <= 2'b00; @(posedge clk);                         
								@(posedge clk);                        
               guessedDigit <= 2'b01; @(posedge clk);                
               @(posedge clk);                
               guessedDigit <= 2'b10; @(posedge clk);                 
               @(posedge clk);                        
               guessedDigit <= 2'b11; @(posedge clk);                         
               @(posedge clk);                        
              guessedDigit <= 2'b10; @(posedge clk);                 
               @(posedge clk);                        
               @(posedge clk);   
              Reset <= 1;  @(posedge clk);
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

	
	