`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2024 03:43:45 PM
// Design Name: 
// Module Name: SRAM
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


module SRAM(
data,
ce,
we,
oe,
addr,
clk
);

inout [7:0] data;
input we;
input oe;
input ce;
input [16:0] addr;
input clk;


reg [7:0] temp;
reg [7:0] mem [0:131071];

always @(posedge clk) begin
    if(!ce && we)
        temp <= mem[addr];
end

always @(posedge clk) begin
    if(!ce && !we)
        mem[addr] <= data;
end

assign data = (!ce && !oe && we)?temp: 8'hzz;

endmodule

