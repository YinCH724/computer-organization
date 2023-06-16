//310512050
//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input signed [32-1:0]  src1_i;
input signed [32-1:0]  src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
reg             zero_o;

//Parameter
parameter op_add = 4'b0010;
parameter op_sub = 4'b0110;
parameter op_and = 4'b0001;
parameter op_orr = 4'b0000;
parameter op_slt = 4'b0111;
parameter op_non = 4'b1111;

//Main function
always@(*)begin
	case(ctrl_i)
	op_orr: begin
		result_o = src1_i|src2_i;
	end
	op_and: begin
		result_o = src1_i&src2_i;
	end
	op_add: begin
		result_o = src1_i+src2_i;
	end
	op_sub: begin
		result_o = src1_i-src2_i;
	end
	op_slt: begin
		if(src1_i<src2_i) result_o = 32'd1;
		else result_o = 32'd0;
	end
	default: result_o = 32'd0;	
	endcase
end

always@(*)begin
	if (result_o == 32'd0) zero_o = 1'd1;
	else zero_o = 1'd0;
end

endmodule





                    
                    