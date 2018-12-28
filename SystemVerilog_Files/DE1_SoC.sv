module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR,SW);
	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;
	
	
	logic [7:0] ranNumBinary;
	
	logic gameReset;
	
	logic [1:0] firstCorrectDigit, secondCorrectDigit, thirdCorrectDigit, fourthCorrectDigit;
	
	logic [1:0] guessedFirstDigit, guessedSecondDigit, guessedThirdDigit, guessedFourthDigit;
	
	logic won;
	
	logic [2:0] numCorrectAll, numCorrWrongPlace;
	
	logic stableKeyOne, stableKeyTwo, stableKeyThree, stableKeyFour;
	
	logic keyOne, keyTwo, keyThree, keyFour;
	
	logic [7:0] Q;
	
	logic enable;
	
	// Generate clk off of CLOCK_50, whichClock picks rate.
	logic [31:0] clk;
	// Hook up FSM inputs and outputs.
	


	parameter whichClock = 15; 
	clock_divider divided_clock (CLOCK_50, clk);

	
		
	//start of Project 8 new stuff
	
	// SW[1] is the reset for a new number or "enable button'
	LFSR ranNum (.Reset(SW[9]), .clk(clk[whichClock]), .switch(SW[1]), .Q(ranNumBinary));
	
	LFSRToBaseFour baseFour (.Reset(SW[9]) , .ranNumBinary(ranNumBinary), .firstDigit(firstCorrectDigit), .secondDigit(secondCorrectDigit), .thirdDigit(thirdCorrectDigit), .fourthDigit(fourthCorrectDigit));
	
	bitUpCounter Key3 (.Reset(SW[9]), .clk(clk[whichClock]), .incr(keyOne), .out(guessedFourthDigit));
	bitUpCounter Key2 (.Reset(SW[9]), .clk(clk[whichClock]), .incr(keyTwo), .out(guessedThirdDigit));
	bitUpCounter Key1 (.Reset(SW[9]), .clk(clk[whichClock]), .incr(keyThree), .out(guessedSecondDigit));
	bitUpCounter Key0 (.Reset(SW[9]), .clk(clk[whichClock]), .incr(keyFour), .out(guessedFirstDigit));
	
	HEXDisplay fourth (.Reset(SW[9]), .clk(clk[whichClock]), .guessedDigit(guessedFourthDigit), .HEX(HEX0));
	HEXDisplay third (.Reset(SW[9]), .clk(clk[whichClock]), .guessedDigit(guessedThirdDigit), .HEX(HEX1));
	HEXDisplay second (.Reset(SW[9]), .clk(clk[whichClock]), .guessedDigit(guessedSecondDigit), .HEX(HEX2));
	HEXDisplay first (.Reset(SW[9]), .clk(clk[whichClock]), .guessedDigit(guessedFirstDigit), .HEX(HEX3));
	
	// flip up SW[0] to finishSelecting and flip up SW[1] to generate a new number and flip it back down to keep a number and plya the game
	play game (.Reset(SW[9]), .clk(clk[whichClock]), .firstCorrectDigit(firstCorrectDigit), .secondCorrectDigit(secondCorrectDigit), .thirdCorrectDigit(thirdCorrectDigit), .fourthCorrectDigit(fourthCorrectDigit), .guessedFirstDigit(guessedFirstDigit), .guessedSecondDigit(guessedSecondDigit), .guessedThirdDigit(guessedThirdDigit), .guessedFourthDigit(guessedFourthDigit),  .finishSelecting(SW[0]), .switch(SW[1]), .won(won), .numCorrectAll(numCorrectAll), .numCorrWrongPlace(numCorrWrongPlace));
	
	sideHEXDisplay displayCorrAll (.Reset(SW[9]), .clk(clk[whichClock]), .numDisplay(numCorrectAll), .HEX(HEX5));
	sideHEXDisplay displayCorrWrongPlace (.Reset(SW[9]), .clk(clk[whichClock]), .numDisplay(numCorrWrongPlace), .HEX(HEX4));
	
	LEDs lights (.Reset(SW[9]), .clk(clk[20]), .won(won), .LEDR(LEDR[9:0]));
	
	seriesFlipFlop keyStableOne (.clk(clk[whichClock]), .Reset(SW[9]), .key(~KEY[0]), .out(stableKeyOne));
	seriesFlipFlop keyStableTwo (.clk(clk[whichClock]), .Reset(SW[9]), .key(~KEY[1]), .out(stableKeyTwo));
	seriesFlipFlop keyStableThree (.clk(clk[whichClock]), .Reset(SW[9]), .key(~KEY[2]), .out(stableKeyThree));
	seriesFlipFlop keyStableFour (.clk(clk[whichClock]), .Reset(SW[9]), .key(~KEY[3]), .out(stableKeyFour));
	
	userInput firstKey (.Reset(SW[9]), .clk(clk[whichClock]), .key(stableKeyOne), .awardPoint(keyOne));
	userInput secondKey (.Reset(SW[9]), .clk(clk[whichClock]), .key(stableKeyTwo), .awardPoint(keyTwo));
	userInput ThirdKey (.Reset(SW[9]), .clk(clk[whichClock]), .key(stableKeyThree), .awardPoint(keyThree));
	userInput fourthKey(.Reset(SW[9]), .clk(clk[whichClock]), .key(stableKeyFour), .awardPoint(keyFour));
	
	
	//flashing LED module for when you win the game
endmodule

// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz,
// [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
 input logic clock;
 output logic [31:0] divided_clocks = 0;

 always_ff @(posedge clock) begin
 divided_clocks <= divided_clocks + 1;
 end

endmodule 

module DE1_SoC_testbench();
	logic CLOCK_50; 
	logic [3:0] KEY;
	logic [9:0] LEDR;
	logic [9:0] SW;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	logic [31:0] clk;
	// Hook up FSM inputs and outputs.
	


	parameter whichClock = 15; 
	clock_divider divided_clock (CLOCK_50, clk);


	// Set up the clock.   
	parameter CLOCK_PERIOD = 100;   
	initial begin 
		CLOCK_50 <= 0;  
		forever #( CLOCK_PERIOD / 2 ) CLOCK_50 <= ~CLOCK_50;   
	end       
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
		
initial begin	
						      	@(posedge clk[whichClock]);
		SW[9] <= 1;	SW[8:0] <= 0;	      	@(posedge clk[whichClock]);
		SW[9] <= 0;	SW[0] <= 0;	SW[1] <= 1;      	@(posedge clk[whichClock]);
						      	@(posedge clk[whichClock]);
						      	@(posedge clk[whichClock]);
									@(posedge clk[whichClock]);
						      	@(posedge clk[whichClock]);
									SW[1] <= 0;      	@(posedge clk[whichClock]);
		KEY[0] <= 1; KEY[1] <= 1; KEY[2] <= 1; KEY[3] <= 1;		     	@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
		SW[0] <= 1;				@(posedge clk[whichClock]);
									@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
										SW[9] <= 1;	@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											SW[9] <= 0; SW[1] <= 1; @(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
		KEY[0] <= 0; KEY[1] <= 0; KEY[2] <= 0; KEY[3] <= 0;		     	@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
							SW[1] <= 0; @(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
	  KEY[0] <= 1; KEY[1] <= 1; @(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
	  KEY[0] <= 0; KEY[1] <= 0; @(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
		KEY[1] <= 1; KEY[2] <= 1; @(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
											@(posedge clk[whichClock]);
		


						      	$stop;
	end
endmodule
