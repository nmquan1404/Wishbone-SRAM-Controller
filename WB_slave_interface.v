`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 12:12:30 AM
// Design Name: 
// Module Name: WB_slave_interface
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


module WB_slave_interface(
input CLK_I,
input RST_I,
input [31:0] ADR_O,
input [31:0] DAT_O,
input WE_O,
input STB_O,
input CYC_O,
input [31:0] s_rdata,
input sram_wr_finish,
output reg [31:0] DAT_I,
output reg ACK_I,
output reg [31:0] s_addr,
output reg [31:0] s_wdata,
output reg s_we,
output reg s_access
);

reg [3:0] state;
initial begin
    state = 0;
end

always @(posedge CLK_I) begin
    if(state == 0) begin
        if(CYC_O && STB_O) begin
            state = 1;    
            s_addr = ADR_O;
            s_access = 1;
            if(!WE_O) begin 
                s_we = 0;
            end
            else begin
                s_we = 1;
                s_wdata = DAT_O;
            end
        end
    end
    else if(state == 1) begin
        if(sram_wr_finish) begin
            if(!WE_O) begin          //read
                DAT_I =  s_rdata;
            end
            s_access = 0;
            s_we = 0;
            ACK_I = 1;     
            state = 2;   
        end             
    end
    else if(state == 2) begin
        if(!STB_O && !CYC_O) begin
            DAT_I = 32'hxxxxxxxx;
            ACK_I = 0;
            state = 0;
        end       
    end
end
endmodule
