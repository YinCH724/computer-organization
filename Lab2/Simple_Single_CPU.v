//310512050
//Subject:     CO project 2 - Simple Single CPU
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
module Simple_Single_CPU(
        clk_i,
		rst_i,
		src2_i
		);
		
//I/O port
input         clk_i;
input         rst_i;
output src2_i;

//Internal Signles
wire [31:0] pc_i, pc_o, n_pc, instr_o,n_pc0,n_pc1;

wire [4:0] RDaddr_i;
wire [31:0] RDdata_i, src1_i, src2_mux0, immediate_32,src2_i;
wire [2:0] ALU_op_o;
wire [3:0]ALUCtrl_o;
wire [31:0] branch_addr;		
wire Bornot;
wire RegWrite_o, RegDst_o, ALUSrc_o, Branch_o,zero_o;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(n_pc) ,   
	    .pc_out_o(pc_o) 
	    );
	
Adder Adder1(
        .src1_i(32'd4),     
	    .src2_i(pc_o),     
	    .sum_o(n_pc0)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_o),  
	    .instr_o(instr_o)    
	    );
		
/*
assign instr_op_i = instr_o[31:26];
assign RSaddr_i = instr_o[25:21];
assign RTaddr_i = instr_o[20:16];
assign RDaddr_mux1 = instr_o[15:11];
assign funct_i = instr_o[5:0];
assign immediate_16 = instr_o[15:0];
*/


MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
        .select_i(RegDst_o),
        .data_o(RDaddr_i)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr_o[25:21]) ,  
        .RTaddr_i(instr_o[20:16]) ,  
        .RDaddr_i(RDaddr_i) ,  
        .RDdata_i(RDdata_i) , 
        .RegWrite_i (RegWrite_o),
        .RSdata_o(src1_i) ,  
        .RTdata_o(src2_mux0)   
        );
	
Decoder Decoder(
        .instr_op_i(instr_o[31:26]), 
	    .RegWrite_o(RegWrite_o), 
	    .ALU_op_o(ALU_op_o),   
	    .ALUSrc_o(ALUSrc_o),   
	    .RegDst_o(RegDst_o),   
		.Branch_o(Branch_o)   
	    );

ALU_Ctrl AC(
        .funct_i(instr_o[5:0]),   
        .ALUOp_i(ALU_op_o),   
        .ALUCtrl_o(ALUCtrl_o) 
        );
	
Sign_Extend SE(
        .data_i(instr_o[15:0]),
        .data_o(immediate_32)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(src2_mux0),
        .data1_i(immediate_32),
        .select_i(ALUSrc_o),
        .data_o(src2_i)
        );	
		
ALU ALU(
        .src1_i(src1_i),
	    .src2_i(src2_i),
	    .ctrl_i(ALUCtrl_o),
	    .result_o(RDdata_i),
		.zero_o(zero_o)
	    );
		
Adder Adder2(
        .src1_i(n_pc0),     
	    .src2_i(branch_addr),     
	    .sum_o(n_pc1)      
	    );

Shift_Left_Two_32 Shifter(
        .data_i(immediate_32),
        .data_o(branch_addr)
        ); 	

		
assign Bornot = zero_o&Branch_o;
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(n_pc0),
        .data1_i(n_pc1),
        .select_i(Bornot),
        .data_o(n_pc)
        );	
endmodule
		  


