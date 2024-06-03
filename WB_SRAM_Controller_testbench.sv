`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2024 09:04:28 AM
// Design Name: 
// Module Name: WB_SRAM_Controller_testbench
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


module WB_SRAM_Controller_testbench();
reg CLK_I;
reg RST_I;
reg [31:0] ADR_O;
reg [31:0] DAT_O;
reg WE_O;
reg STB_O;
reg CYC_O;
wire [7:0] Sram_data;
wire [31:0] DAT_I;
wire ACK_I;
wire [16:0] Sram_addr;
wire Sram_wen;
wire Sram_oen;
wire Sram_cen;
int counter;

initial begin
    reset();
    //Kiem tra tren 20 packet
    repeat (20) begin #100              
        fork
            generation();
            write();
            read();
            check();
        join
    end
end

//ham reset
task reset();
    CLK_I = 0;
    RST_I = 0; 
    WE_O = 0;
    STB_O = 0;
    CYC_O = 0;  
    #20 
    RST_I = 1;
    #20
    RST_I = 0;
endtask: reset
    
    
//Tao du lieu va dia chi de ghi du lieu
task generation();
    ADR_O = $random();
    DAT_O = $random();
endtask: generation

//Gui du lieu vao DUT
task write();
    STB_O = 1;
    CYC_O = 1;
    WE_O = 1;
    #65
    DAT_O = 'hx;
    STB_O = 0;
    CYC_O = 0;
    WE_O = 0;
endtask: write

//Doc du lieu tu DUT
task read();
    #80
    STB_O = 1;
    CYC_O = 1;
    #85
    STB_O = 0;
    CYC_O = 0;
endtask: read


logic [31:0] data_write;
logic [31:0] data_read;
bit check_result;
//So sanh du lieu gui va du lieu doc
task check();
    $display("\nPacket %2d",counter + 1);
    data_write = DAT_O;
    $display("Data write: %0h", data_write);
    #160
    data_read = DAT_I;
    $display("Data read : %0h", data_read);
    
    check_result = compare();
    if(check_result)
        $display("Write data and read data match");
    else
        $display("Write data and read data didn't match");
    counter = counter + 1;
endtask: check

function compare();
    if(data_write == data_read) return 1;
    else return 0;
endfunction

always #5 CLK_I = ~CLK_I;

//Khai bao Wishbone SRAM Controller
WB_SRAM_Controller wb_controller(CLK_I,
                                 RST_I,
                                 ADR_O,
                                 DAT_O,
                                 WE_O,
                                 STB_O,
                                 CYC_O,
                                 Sram_data,
                                 DAT_I,
                                 ACK_I,
                                 Sram_addr,
                                 Sram_wen,
                                 Sram_oen,
                                 Sram_cen);
 //Khai bao SRAM
 SRAM ram(Sram_data,
          Sram_cen,
          Sram_wen,
          Sram_oen,
          Sram_addr,
          CLK_I);
 
endmodule
