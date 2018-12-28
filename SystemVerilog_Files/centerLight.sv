module centerLight (clk, Reset, L, R, NL, NR, newGame, lightOn);

	input logic clk, Reset;  
	input logic L, R, NL, NR;
	input logic newGame;
	
	output logic [1:0] lightOn;
	
	parameter on = 1'b1;
	parameter off = 1'b0;
	
	logic ns;
	
	//if reset is true, lightOn should be true
	
	always_comb begin
		case (lightOn)
			on: if ((~NR & ~NL) & ((R & ~L) | (~R & L))) ns = off;
				 else if ((L&R) | (~R & ~L)) ns = on;
				 else ns = on;
			off: if ((R & NL & ~L) | (L & NR & ~R)) ns = on;
				  else if ((L&R) | (~R & ~L)) ns = off;
				  else ns = off;
			default: ns = off;
		endcase
	end

	
		
		
		
	// DFF 
	always_ff @(posedge clk) begin
		if (Reset || newGame)
			lightOn <= on;
		else 
			lightOn <= ns;
	end
	
endmodule

module centerLight_testbench();
	logic clk;
	logic Reset;
	logic L, R, NL, NR;
	logic lightOn;


	centerLight dut (clk, Reset, L, R, NL, NR, lightOn);

	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end


		
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
													  @(posedge clk);
													  @(posedge clk);
		   Reset <= 1;L <= 0; R <=0; NL <= 0; NR <=0; @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
			Reset <= 0;L <= 0; R <=0; NL <= 0; NR <=0; @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
			L <= 1; R <=0; NL <= 0; NR <=1; @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
			L <= 0; R <=1; NL <= 1; NR <=0; @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
			L <= 0; R <=1; NL <= 0; NR <=0; @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
			L <= 1; R <=0; NL <= 0; NR <=0; @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
			L <= 1; R <=1; NL <= 1; NR <=0; @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
			L <= 1; R <=1; NL <= 0; NR <=1; @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
			L <= 0; R <=0; NL <= 0; NR <=1; @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
			L <= 0; R <=0; NL <= 1; NR <=0; @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
													  @(posedge clk);
			$stop; // End the simulation.
	end
endmodule 


