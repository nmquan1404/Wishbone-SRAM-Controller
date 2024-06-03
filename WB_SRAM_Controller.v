`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 11:53:07 AM
// Design Name: 
// Module Name: WB_SRAM_Controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module WB_SRAM_Controller(
input CLK_I,
input RST_I,
input [31:0] ADR_O,
input [31:0] DAT_O,
input WE_O,
input STB_O,
input CYC_O,
inout [7:0] Sram_data,
output [31:0] DAT_I,
output ACK_I,
output [16:0] Sram_addr,
output Sram_wen,
output Sram_oen,
output Sram_cen
    );
    
    
wire [31:0] s_addr;
wire [31:0] s_rdata;
wire [31:0] s_wdata;
wire s_we;
wire sram_wr_finish;
wire s_access;

WB_slave_interface wb(.CLK_I(CLK_I),
                   .RST_I(RST_I),
                   .ADR_O(ADR_O),
                   .DAT_O(DAT_O),
                   .WE_O(WE_O),
                   .STB_O(STB_O),
                   .CYC_O(CYC_O),
                   .s_rdata(s_rdata),
                   .sram_wr_finish(sram_wr_finish),
                   .DAT_I(DAT_I),
                   .ACK_I(ACK_I),
                   .s_addr(s_addr),
                   .s_wdata(s_wdata),
                   .s_we(s_we),
                   .s_access(s_access));

SRAMController sramcontroller(.s_addr(s_addr),
                              .s_wdata(s_wdata),
                              .s_we(s_we),
                              .s_access(s_access),
                              .clk(CLK_I),
                              .rst(RST_I),
                              .s_rdata(s_rdata),
                              .sram_wr_finish(sram_wr_finish),
                              .Sram_addr(Sram_addr),
                              .Sram_wen(Sram_wen),
                              .Sram_oen(Sram_oen),
                              .Sram_cen(Sram_cen),
                              .Sram_iodata(Sram_data));
                              
endmodule
