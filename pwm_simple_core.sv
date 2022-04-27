module pwm_simple_core
	#(parameter R=10)
	(	input	logic	i_clk,
		input	logic	i_nrst,
		input	logic	[R:0] i_duty,
		input	logic	[31:0]	i_scaler,
		output	logic	o_pwm);
		
		//declaration
		logic	[R-1:0]	duty_cntr_reg,	duty_cntr_next;
		logic	[R:0]	duty_cntr_extended;
		logic			pwm_reg,	pwm_next;
		logic	[31:0]	prescale_cntr_reg,	prescale_cntr_next;
		logic			tick;
		
		//body
		always_ff @(posedge i_clk, negedge i_nrst)
			if(!i_nrst)
				duty_cntr_reg	<= 0;
				pwm_reg	<= 0;
				prescale_cntr_reg	<= 0;
			end
			
			else
				begin
					duty_cntr_reg 	<= duty_cntr_next;
					pwm_reg	<=	pwm_next;
					prescale_cntr_reg	<=	prescale_cntr_next;
				end
			
		//"prescale" counter
		assign	prescale_cntr_next	=	(prescale_cntr_reg	== i_scaler)	?	0	: prescale_cntr_reg + 1'b1;
		assign	tick	=	(prescale_cntr_reg == 0);
		
		//duty_cycle cntr
		assign	