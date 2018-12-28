module sideHEXDisplay (Reset, clk, numDisplay,  HEX);
	input logic Reset, clk;
	input logic [2:0] numDisplay;
	
	output logic [6:0] HEX;
	
	logic [6:0] off, zero, one, two, three, four, ps, ns;
	
	assign zero = 7'b1000000;
	assign one = 7'b1111001;
	assign two = 7'b0100100;
	assign three = 7'b0110000;
	assign four = 7'b0011001;
	assign off = 7'b1111111;
	
	always_comb begin
		case (numDisplay)
			3'b000: ns = zero;
			3'b001: ns = one;
			3'b010: ns = two;
			3'b011: ns = three;
			3'b100: ns = four;
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

module sideHEXDisplay_testbench();
	logic Reset, clk;
	logic [6:0] HEX;
	logic [2:0] numDisplay;
	
	sideHEXDisplay dut (Reset, clk, numDisplay, HEX);
	
	// Set up the clock.   
	parameter CLOCK_PERIOD = 100;   
	initial begin 
		clk <= '0;  
		forever #( CLOCK_PERIOD / 2 ) clk <= ~clk;   
	end      
	
	// Set up the inputs to the design.  Each line is a clock cycle.   
initial begin                        
				   @(posedge clk);    
	Reset <= 1; numDisplay <= 3'b000; @(posedge clk);    
	Reset <= 0; numDisplay <= 3'b000; @(posedge clk);                        
           numDisplay <= 3'b001; @(posedge clk);                         
								@(posedge clk);                        
              numDisplay <= 3'b010; @(posedge clk);                
               @(posedge clk);                
               numDisplay <= 3'b011; @(posedge clk);                 
               @(posedge clk);                        
               numDisplay <= 3'b100; @(posedge clk);                         
               @(posedge clk);                        
              numDisplay <= 3'b010; @(posedge clk);                 
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
