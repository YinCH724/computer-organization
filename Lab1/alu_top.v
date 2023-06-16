`timescale 1ns/1ps
// 310512050
module alu_top(
    /* input */
    src1,       //1 bit, source 1 (A)
    src2,       //1 bit, source 2 (B)
    less,       //1 bit, less
    A_invert,   //1 bit, A_invert
    B_invert,   //1 bit, B_invert
    cin,        //1 bit, carry in
    operation,  //2 bit, operation
    /* output */
    result,     //1 bit, result
    cout        //1 bit, carry out
);

/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input src1;
input src2;
input less;
input A_invert;
input B_invert;
input cin;
input [1:0] operation;

output result;
output cout;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/

reg result, cout;
reg sel_A,sel_B;
wire add_xor0,add_result,add_and0,add_and1;
wire And_result,Or_result;

/*==================================================================*/
/*                              design                              */
/*==================================================================*/
assign add_xor0 = sel_A^sel_B;
assign add_and0 = sel_A&sel_B;
assign add_result = add_xor0^cin;
assign add_and1 = add_xor0&cin;

assign And_result = add_and0;
assign Or_result = sel_A|sel_B;


always@(*) begin
	cout = add_and1|add_and0;
end

always@(*) begin
	case(A_invert)
	1'd0: sel_A = src1;
	1'd1: sel_A = ~src1;
	default: sel_A = src1;
	endcase
end

always@(*) begin
	case(B_invert)
	1'd0: sel_B = src2;
	1'd1: sel_B = ~src2;
	default: sel_B = src2;
	endcase
end

always@(*) begin
	case(operation)
	2'd0: result = And_result;
	2'd1: result = Or_result;
	2'd2: result = add_result;
	2'd3: result = less;
	default: result = 1'd0;
	endcase
end

/* HINT: You may use 'case' or 'if-else' to determine result.
// result
always@(*) begin
    case()
        default: begin
            result = ;
        end
    endcase
end
*/

endmodule
