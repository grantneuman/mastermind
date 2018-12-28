module play (Reset, clk, firstCorrectDigit, secondCorrectDigit, thirdCorrectDigit, fourthCorrectDigit, guessedFirstDigit, guessedSecondDigit, guessedThirdDigit, guessedFourthDigit,  finishSelecting, switch, won, numCorrectAll, numCorrWrongPlace);
	input logic Reset, clk, finishSelecting;
	input logic [1:0] guessedFirstDigit, guessedSecondDigit, guessedThirdDigit, guessedFourthDigit;
	input logic [1:0] firstCorrectDigit, secondCorrectDigit, thirdCorrectDigit, fourthCorrectDigit;
	input switch;
	
	output logic won;
	output logic [2:0] numCorrectAll, numCorrWrongPlace;
	
	logic [2:0] zero, one, two, three, four, ns, ps, prevSame, adder2; 
	logic [3:0] ps2, first, second, third, fourth, adder, prevDigit, prevDigit2, prevDigit3, prevDigit4,  ns2, last, remPrevDigit, remPrevDigit2, remPrevDigit3, remPrevDigit4; 
	logic [4:0] block;
	
	assign zero = 3'b000;
	assign one = 3'b001;
	assign two = 3'b010;
	assign three = 3'b011;
	assign four = 3'b100;
	
	assign first = 4'b1010;
	assign second = 4'b1011;
	assign third = 4'b1100;
	assign fourth = 4'b1101;
	assign last = 4'b1110;

	
	
	
	always_comb begin
		case (ps)
			zero: if (guessedFirstDigit == firstCorrectDigit) begin
						adder2 = 3'b001;
						ns = one;
					end else begin
						adder2 = 3'b000;
						ns = one;
					end
					
			one: if (guessedSecondDigit == secondCorrectDigit) begin 
						adder2 = 3'b001;
						ns = two;
					end else begin
						adder2 = 3'b000;
						ns = two;
					end
					
			two: if (guessedThirdDigit == thirdCorrectDigit) begin 
						adder2 = 3'b001;
						ns = three;
					end else begin
						adder2 = 3'b000;
						ns = three;
					end
					
			three: if (guessedFourthDigit == fourthCorrectDigit) begin 
						adder2 = 3'b001;
						ns = four;
					end else begin
						adder2 = 3'b000;
						ns = four;
					end
					
			four: begin 
						ns= four;
						adder2 = 3'b000;
					end
			default: begin 
						ns= zero;
						adder2 = 3'b000;
					end
		endcase
	end
	always_comb begin
		case (ps2)
			first: if (guessedFirstDigit == firstCorrectDigit || guessedSecondDigit == secondCorrectDigit || guessedThirdDigit == thirdCorrectDigit || guessedFourthDigit == fourthCorrectDigit) begin
					      adder = 3'b000;
							block = 5'b00001;
							ns2 = second;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
					 end else if (firstCorrectDigit == guessedSecondDigit) begin
							adder = 3'b001;
							block = 5'b00010;
							ns2 = second;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0001;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
							
					 end else if (firstCorrectDigit == guessedThirdDigit ) begin
							adder = 3'b001;
							block = 5'b00011;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0001;
							prevDigit4 = 4'b0000;
							ns2 = second;
							
					 end else if (firstCorrectDigit == guessedFourthDigit) begin
							adder = 3'b001;
							block = 5'b00100;
							ns2 = second;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0001;
					 end else begin
							adder = 3'b000;
							block = 5'b00101;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
							ns2 = second;
					 end
				
			second: if (guessedSecondDigit == secondCorrectDigit ) begin
					      adder = 3'b000;
							block = 5'b00110;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
							ns2 = third;
					 end else if (secondCorrectDigit == guessedFirstDigit && remPrevDigit == 4'b0000) begin
							adder = 3'b001;
							block = 5'b00111;
							ns2 = third;
							prevDigit = 4'b0001;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
					 end else if (secondCorrectDigit == guessedThirdDigit && remPrevDigit3 == 4'b0000) begin
							adder = 3'b001;
							block = 5'b01000;
							ns2 = third;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0001;
							prevDigit4 = 4'b0000;
					 end else if (secondCorrectDigit == guessedFourthDigit && remPrevDigit4 == 4'b0000) begin
							adder = 3'b001;
							block = 5'b01001;
							ns2 = third;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0001;
					 end else begin
							adder = 3'b000;
							block = 5'b01010;
							ns2 = third;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
					 end
				
			third: if (guessedThirdDigit == thirdCorrectDigit) begin
					      adder = 3'b000;
							block = 5'b01011;
							ns2 = fourth;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
					 end else if (thirdCorrectDigit == guessedFourthDigit && remPrevDigit4 == 4'b0000) begin
							adder = 3'b001;
							block = 5'b01100;
							ns2 = fourth;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0001;
					 end else if (thirdCorrectDigit == guessedSecondDigit && remPrevDigit2 == 4'b0000) begin
							adder = 3'b001;
							block = 5'b01101;
							ns2 = fourth;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0001;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
					 end else if (thirdCorrectDigit == guessedFirstDigit && remPrevDigit == 4'b0000) begin
							adder = 3'b001;
							block = 5'b01110;
							ns2 = fourth;
							prevDigit = 4'b0001;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
					 end else begin
							adder = 3'b000;
							block = 5'b01111;
							ns2 = fourth;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
					 end
				
			fourth: if (guessedFourthDigit == fourthCorrectDigit) begin
					      adder = 3'b000;
							block = 5'b10000;
							ns2 = last;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
					 end else if (fourthCorrectDigit == guessedThirdDigit && remPrevDigit3 == 4'b0000) begin
							adder = 3'b001;
							block = 5'b10001;
							ns2 = last;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b00001;
							prevDigit4 = 4'b0000;
					 end else if (fourthCorrectDigit == guessedFirstDigit && remPrevDigit == 4'b0000 ) begin
							adder = 3'b001;
							block = 5'b10010;
							ns2 = last;
							prevDigit = 4'b0001;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
					 end else if (fourthCorrectDigit == guessedSecondDigit && remPrevDigit2 == 4'b0000) begin
							adder = 3'b001;
							block = 5'b10011;
							ns2 = last;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0001;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
					 end else begin
							adder = 3'b000;
							block = 5'b10100;
							ns2 = last;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
					 end
				 last: begin
							adder = 3'b000;
							block = 5'b10101;
							ns2 = last;
							prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
						end
				
			default: begin
						adder = 3'b000;
						block = 5'b10101;
						ns2 = last;
						prevDigit = 4'b0000;
							prevDigit2 = 4'b0000;
							prevDigit3 = 4'b0000;
							prevDigit4 = 4'b0000;
         end
		endcase
	end
	

	
	always_ff @(posedge clk) begin
		if (Reset || !finishSelecting || switch) begin
			ps <= zero;
			numCorrectAll <= 3'b000;
		 end else begin
			ps <= ns;
			numCorrectAll <= numCorrectAll + adder2;
		 end
	end
		
	always_ff @(posedge clk) begin
		if (Reset || !finishSelecting || switch) begin
			ps2 <= 4'b1010;
			numCorrWrongPlace <= 3'b0000;
			remPrevDigit <= 4'b0000;
			remPrevDigit2 <= 4'b0000;
			remPrevDigit3 <= 4'b0000;
			remPrevDigit4 <= 4'b0000;
		end else begin
			ps2 <= ns2;
			numCorrWrongPlace <= numCorrWrongPlace + adder;
			remPrevDigit <= remPrevDigit + prevDigit;
			remPrevDigit2 <= remPrevDigit2 + prevDigit2;
			remPrevDigit3 <= remPrevDigit3 + prevDigit3;
			remPrevDigit4 <= remPrevDigit4 + prevDigit4;
		end
	end
		

	assign won = (numCorrectAll == 3'b100);
	//assign numCorrectAll = ps;
	//assign numCorrWrongPlace = ps2;
endmodule

module play_testbench(); 
	logic Reset, clk, finishSelecting, won;
	logic [1:0] firstCorrectDigit, secondCorrectDigit, thirdCorrectDigit, fourthCorrectDigit; 
	logic [1:0] guessedFirstDigit, guessedSecondDigit, guessedThirdDigit, guessedFourthDigit;  
	logic [2:0] numCorrectAll, numCorrWrongPlace;
	logic switch;
	
	play dut(Reset, clk, firstCorrectDigit, secondCorrectDigit, thirdCorrectDigit, fourthCorrectDigit, guessedFirstDigit, guessedSecondDigit, guessedThirdDigit, guessedFourthDigit,  finishSelecting, switch, won, numCorrectAll, numCorrWrongPlace);      

	// Set up the clock.   
	parameter CLOCK_PERIOD = 100;   
	initial begin 
		clk <= '0;  
		forever #( CLOCK_PERIOD / 2 ) clk <= ~clk;   
	end      
	
	// 11101111
	// Set up the inputs to the design.  Each line is a clock cycle.   
	initial begin                        
		Reset <= 1; @(posedge clk);
						@(posedge clk);
		Reset <= 0; finishSelecting <= 0; switch <= 1; @(posedge clk);
						@(posedge clk);
						@(posedge clk);
		firstCorrectDigit <= 2'b11; secondCorrectDigit <= 2'b11; thirdCorrectDigit <= 2'b01; fourthCorrectDigit <= 2'b00; @(posedge clk);
						switch <= 0; @(posedge clk);
						@(posedge clk);
		guessedFirstDigit <= 2'b01; guessedSecondDigit <= 2'b10; guessedThirdDigit <= 2'b11; guessedFourthDigit <= 2'b10; @(posedge clk);
						@(posedge clk);
					   @(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						finishSelecting <= 1; 	@(posedge clk);
						@(posedge clk);
							@(posedge clk);
					   @(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
		firstCorrectDigit <= 2'b11; secondCorrectDigit <= 2'b10; thirdCorrectDigit <= 2'b11; fourthCorrectDigit <= 2'b11; @(posedge clk);
						//switch <= 1; @(posedge clk);
						@(posedge clk);
						@(posedge clk);
						switch <= 1; @(posedge clk);
						//switch <= 0; @(posedge clk);
		switch <= 0; guessedFirstDigit <= 2'b11; guessedSecondDigit <= 2'b10; guessedThirdDigit <= 2'b11; guessedFourthDigit <= 2'b11; @(posedge clk);
						@(posedge clk);
					   @(posedge clk);
						@(posedge clk);
					   @(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						switch <= 1; @(posedge clk);
	switch <= 0; firstCorrectDigit <= 2'b00; secondCorrectDigit <= 2'b01; thirdCorrectDigit <= 2'b11; fourthCorrectDigit <= 2'b10; guessedFirstDigit <= 2'b01; guessedSecondDigit <= 2'b01; guessedThirdDigit <= 2'b01; guessedFourthDigit <= 2'b01; @(posedge clk);
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
	switch <= 1; @(posedge clk);
	switch <= 0; firstCorrectDigit <= 2'b01; secondCorrectDigit <= 2'b10; thirdCorrectDigit <= 2'b01; fourthCorrectDigit <= 2'b00; guessedFirstDigit <= 2'b01; guessedSecondDigit <= 2'b11; guessedThirdDigit <= 2'b01; guessedFourthDigit <= 2'b10; @(posedge clk);
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
