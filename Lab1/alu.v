`timescale 1ns/1ps
// 310512050
module alu(
    /* input */
    clk,            // system clock
    rst_n,          // negative reset
    src1,           // 32 bits, source 1
    src2,           // 32 bits, source 2
    ALU_control,    // 4 bits, ALU control input
    /* output */
    result,         // 32 bits, result
    zero,           // 1 bit, set to 1 when the output is 0
    cout,           // 1 bit, carry out
    overflow        // 1 bit, overflow
);

/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input clk;
input rst_n;
input [31:0] src1;
input [31:0] src2;
input [3:0] ALU_control;

output [32-1:0] result;
output zero;
output cout;
output overflow;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/
parameter less = 1'd0;

genvar NN;
reg [32-1:0] result;
wire [30:0] w_result;
reg zero, cout, overflow;
wire in[32:0];

reg sel_A,sel_B;
wire add_xor0,add_result,add_and0,add_and1;
wire And_result,Or_result;
reg result_31;

wire or_all[31:0];
reg [3:0] R_ALU;

/*==================================================================*/
/*                              design                              */
/*==================================================================*/
////////
assign add_xor0 = sel_A^sel_B;
assign add_and0 = sel_A&sel_B;
assign add_result = add_xor0^in[31];
assign add_and1 = add_xor0&in[31];
assign And_result = add_and0;
assign Or_result = sel_A|sel_B;
/*
always@(posedge clk or negedge rst_n) 
begin
	if(!rst_n) begin
		R_ALU <= 4'd0;
	end
	else begin
		R_ALU <= ALU_control;
	end
end
*/

always@(posedge clk or negedge rst_n) 
begin
	if(!rst_n) begin
		cout <= 1'd0;
	end
	else begin
		case(ALU_control[1:0])
		2'b10: cout <= add_and1|add_and0;
		default: cout <= 1'd0;
		endcase
	end
end

always@(*) begin
	case(ALU_control[3])
	1'd0: sel_A = src1[31];
	1'd1: sel_A = ~src1[31];
	default: sel_A = src1[31];
	endcase
end

always@(*) begin
	case(ALU_control[2])
	1'd0: sel_B = src2[31];
	1'd1: sel_B = ~src2[31];
	default: sel_B = src2[31];
	endcase
end

always@(*) begin
	case(ALU_control[1:0])
	2'd0: result_31 = And_result;
	2'd1: result_31 = Or_result;
	2'd2: result_31 = add_result;
	2'd3: result_31 = less;
	default: result_31 = 1'd0;
	endcase
end
///////


///////////
assign or_all[0]=result_31;
generate
for (NN=0;NN<31;NN=NN+1)begin
	assign or_all[NN+1] = or_all[NN]|w_result[NN];
end
endgenerate

always@(posedge clk or negedge rst_n)begin
	if(!rst_n) begin
		zero <= 1'd0;
	end
	else begin
		zero <= ~or_all[31];
	end
end


assign in[0] = (ALU_control[2])? 1'd1:1'd0;
always@(posedge clk or negedge rst_n) 
begin
	if(!rst_n) begin
		result <= 32'd0;
	end
	else begin
		result <= {result_31,w_result};//,w_result
	end
end

always@(posedge clk or negedge rst_n) 
begin
	if(!rst_n) begin
		overflow <= 1'd0;
	end
	else begin
		case(ALU_control[1:0])
		2'b10: overflow <= (add_and1|add_and0)^in[31];
		default: overflow <= 1'd0;
		endcase
	end
end


alu_top ALU00(
		.src1(src1[0]), 
		.src2(src2[0]), 
		.less(add_result), 
		.A_invert(ALU_control[3]), 
		.B_invert(ALU_control[2]), 
		.cin(in[0]), 
		.operation(ALU_control[1:0]),
		.result(w_result[0]), 
		.cout(in[1])
		);
		

generate 
for (NN=1; NN<31; NN=NN+1)begin
	alu_top ALU01_30(
		.src1(src1[NN]), 
		.src2(src2[NN]), 
		.less(less), 
		.A_invert(ALU_control[3]), 
		.B_invert(ALU_control[2]), 
		.cin(in[NN]), 
		.operation(ALU_control[1:0]),
		.result(w_result[NN]), 
		.cout(in[NN+1])
		);
end
endgenerate

/* HINT: You may use alu_top as submodule.
// 32-bit ALU
alu_top ALU00(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU01(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU02(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU03(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU04(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU05(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU06(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU07(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU08(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU09(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU10(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU11(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU12(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU13(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU14(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU15(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU16(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU17(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU18(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU19(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU20(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU21(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU22(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU23(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU24(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU25(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU26(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU27(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU28(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU29(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU30(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
alu_top ALU31(.src1(), .src2(), .less(), .A_invert(), .B_invert(), .cin(), .operation(), .result(), .cout());
*/

endmodule
