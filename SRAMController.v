`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2024 02:19:58 PM
// Design Name: 
// Module Name: SRAMController
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


module SRAMController(
input [31:0] s_addr,
input [31:0] s_wdata,
input s_we,
input s_access,
input clk,
input rst,
output reg [31:0] s_rdata,
output reg sram_wr_finish,
output reg [16:0] Sram_addr,
output reg Sram_wen,
output reg Sram_oen,
output reg Sram_cen,
inout [7:0] Sram_iodata
);

reg [2:0] count;
reg [31:0] data;
reg [7:0] temp_data;

assign Sram_iodata = (s_access && s_we)?temp_data:8'bz;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        count = 0;
        data = 0;
        temp_data = 0;
        Sram_wen = 1;
        Sram_oen = 1;
        Sram_cen = 1;
        sram_wr_finish = 0;
    end
    else if(s_access) begin             //write
        if(s_we)begin                   //yeu cau ghi
            Sram_cen = 0;               
            Sram_wen = 0;
            sram_wr_finish = 0;
            Sram_addr = s_addr;
            data = s_wdata;
            if(count == 0) begin
                temp_data = data[7:0];
            end
            else if(count == 1) begin
                temp_data = data[15:8];
                Sram_addr = Sram_addr + 1;
            end
            else if(count == 2) begin
                temp_data = data[23:16];
                Sram_addr = Sram_addr + 2;

            end
            else if(count == 3) begin
                temp_data = data[31:24];
                Sram_addr = Sram_addr + 3;
                sram_wr_finish = 1;
            end
            else if(count == 4) begin 
                count = -1;
                Sram_cen = 1;
                Sram_wen = 1;
                temp_data = 8'bz;
            end
            count = count + 1;
        end
        
        
        else begin                              //yeu cau doc
            Sram_cen = 0;               
            Sram_oen = 0;
            Sram_wen = 1;
            sram_wr_finish = 0;
            Sram_addr = s_addr;
 
            if(count == 0) begin
                count = 1;
            end
            else if(count == 1) begin
                s_rdata[7:0] = Sram_iodata;
                Sram_addr = Sram_addr + 1;
                count = 2;
            end
            else if(count == 2) begin
                s_rdata[7:0] = Sram_iodata;
                Sram_addr = Sram_addr + 2;
                count = 3;
            end
            else if(count == 3) begin
                s_rdata[15:8] = Sram_iodata;
                Sram_addr = Sram_addr + 3;
                count = 4;
            end
            else if(count == 4) begin
                s_rdata[23:16] = Sram_iodata;
                Sram_addr = Sram_addr + 3;
                count = 5;
            end
            else if(count == 5) begin
                s_rdata[31:24] = Sram_iodata;
                sram_wr_finish = 1;

                count = 6;
            end
            else if(count == 6) begin 
                count = 0;
                Sram_cen = 1;
                Sram_oen = 1;
            end
        end
    end
end

endmodule
