//310512050
//Subject:     CO project 2 - ALU Controller
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
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter
parameter op_add = 4'b0010;
parameter op_sub = 4'b0110;
parameter op_and = 4'b0001;
parameter op_orr = 4'b0000;
parameter op_slt = 4'b0111;
parameter op_non = 4'b1111;

parameter ist_Rtyp = 3'd0;
parameter ist_addi = 3'd1;
parameter ist_slti = 3'd2;
parameter ist_bequ = 3'd3;      
//Select exact operation

always@(*)begin
	case(ALUOp_i)
	ist_Rtyp:begin
		case(funct_i)
		6'd32: ALUCtrl_o = op_add;
		6'd34: ALUCtrl_o = op_sub;
		6'd36: ALUCtrl_o = op_and;
		6'd37: ALUCtrl_o = op_orr;
		6'd42: ALUCtrl_o = op_slt;
		default: ALUCtrl_o = op_non;
		endcase
	end
	ist_addi:begin
		ALUCtrl_o = op_add;
	end
	ist_slti:begin
		ALUCtrl_o = op_slt;
	end	
	ist_bequ:begin
		ALUCtrl_o = op_sub;
	end	
	default:ALUCtrl_o = op_non;
	endcase
end

endmodule     





                    
                    