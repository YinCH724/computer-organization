//310512050
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o; //
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Parameter
parameter ist_Rtyp = 3'd0;
parameter ist_addi = 3'd1;
parameter ist_slti = 3'd2;
parameter ist_bequ = 3'd3;  
parameter ist_nonn = 3'd4; 
//Main function

always@(*)begin
	case(instr_op_i)
	6'd0,
	6'd8,
	6'd10: RegWrite_o = 1'd1;
	default: RegWrite_o = 1'd0;
	endcase
end

always@(*)begin
	case(instr_op_i)
	6'd8,
	6'd10: ALUSrc_o = 1'd1;
	default: ALUSrc_o = 1'd0;
	endcase
end

always@(*)begin
	case(instr_op_i)
	6'd4: Branch_o = 1'd1;
	default: Branch_o = 1'd0;
	endcase
end

always@(*)begin
	case(instr_op_i)
	6'd8,
	6'd10: RegDst_o = 1'd0;
	default: RegDst_o = 1'd1;
	endcase
end


always@(*)begin
	case(instr_op_i)
	6'd0: ALU_op_o = ist_Rtyp;
	6'd4: ALU_op_o = ist_bequ;
	6'd8: ALU_op_o = ist_addi;
	6'd10: ALU_op_o = ist_slti;
	default: ALU_op_o = ist_nonn;
	endcase
end


endmodule





                    
                    