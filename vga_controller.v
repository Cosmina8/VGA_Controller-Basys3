`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CapGemini
// Engineer: 
// 
// Create Date: 07/23/2025 10:33:09 AM
// Design Name: Bacanu Cosmina-Adriana
// Module Name: vga_controller
// Project Name: Proiect_FullHD
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


module vga_controller(     //definirea modulului
    input wire clk,        // Clock 148.5 MHz (necesar pt rezolutia 1920x1080)
    input wire rst,       // Reset (conectat la butonul central btnC)
    input wire btnU,      // butoanele pt controlul directiei
    input wire btnD,
    input wire btnL,
    input wire btnR,
    output wire Hsync,
    output wire Vsync,
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue
);

    // Parametrii pentru 1080p60
    localparam HV = 1920;
    localparam HFP = 88;
    localparam HSP = 44;
    localparam HBP = 148;
    localparam H_TOTAL = HV + HFP + HSP + HBP;

    localparam VV = 1080;
    localparam VFP = 4;
    localparam VSP = 5;
    localparam VBP = 36;
    localparam V_TOTAL = VV + VFP + VSP + VBP;

    reg [11:0] h_count = 0;
    reg [11:0] v_count = 0;

    assign Hsync = (h_count >= HV + HFP) && (h_count < HV + HFP + HSP);
    assign Vsync = (v_count >= VV + VFP) && (v_count < VV + VFP + VSP);

    wire display_area = (h_count < HV) && (v_count < VV);

    // Poziție inițială: centru
    localparam INIT_X = HV / 2;
    localparam INIT_Y = VV / 2 - 25;

    reg [11:0] tri_x = INIT_X;
    reg [11:0] tri_y = INIT_Y;

    reg [11:0] h_prev = 0;

    // Contori debounce / întârziere mutare
    reg [24:0] counter_left = 0;
    reg [24:0] counter_right = 0;
    reg [24:0] counter_up = 0;
    reg [24:0] counter_down = 0;

    // Contoare incrementare/decrementare doar o data când se atinge pragul
    wire move_left  = (counter_left == 75000);
    wire move_right = (counter_right == 75000);
    wire move_up    = (counter_up == 75000);
    wire move_down  = (counter_down == 75000);

    // Contori butoane - cresc când butonul e apăsat, se resetează când nu
    always @(posedge clk or posedge rst) begin
        if (rst)
            counter_left <= 0;
        else if (btnL) begin
            if (counter_left < 75000)
                counter_left <= counter_left + 1;
        end else
            counter_left <= 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            counter_right <= 0;
        else if (btnR) begin
            if (counter_right < 75000)
                counter_right <= counter_right + 1;
        end else
            counter_right <= 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            counter_up <= 0;
        else if (btnU) begin
            if (counter_up < 75000)
                counter_up <= counter_up + 1;
        end else
            counter_up <= 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            counter_down <= 0;
        else if (btnD) begin
            if (counter_down < 75000)
                counter_down <= counter_down + 1;
        end else
            counter_down <= 0;
    end

    // Mișcare triunghi sincronizată cu începutul liniei (h_count == 0)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tri_x <= INIT_X;
            tri_y <= INIT_Y;
            h_prev <= 0;
        end else begin
            h_prev <= h_count;

            // La începutul liniei (și când s-a trecut linia anterioară complet)
            if (h_count == 0 && h_prev == H_TOTAL - 1) begin
                // Mută stânga
               if (move_left && tri_x > 50)
                   tri_x <= tri_x - 10;

                // Mută dreapta
               if (move_right && tri_x < HV - 50)
                   tri_x <= tri_x + 10;


                // Mută sus
                if (move_up && tri_y >= 10)
                    tri_y <= tri_y - 10;

                // Mută jos
                if (move_down && tri_y <= VV - 60)
                    tri_y <= tri_y + 10;
            end
        end
    end

    // Triunghi echilateral cu vârful în sus, latură ~50px înălțime
    wire is_triangle = (v_count >= tri_y) && (v_count <= tri_y + 50) &&
                       (h_count >= tri_x - (v_count - tri_y)) &&
                       (h_count <= tri_x + (v_count - tri_y));

    // Contor orizontal
    always @(posedge clk or posedge rst) begin
        if (rst) h_count <= 0;
        else if (h_count == H_TOTAL - 1) h_count <= 0;
        else h_count <= h_count + 1;
    end

    // Contor vertical
    always @(posedge clk or posedge rst) begin
        if (rst) v_count <= 0;
        else if (h_count == H_TOTAL - 1) begin
            if (v_count == V_TOTAL - 1)
                v_count <= 0;
            else
                v_count <= v_count + 1;
        end
    end

    // Afișare RGB
    always @(posedge clk or posedge rst) begin
        if (rst || !display_area) begin
            vgaRed   <= 4'b0000;
            vgaGreen <= 4'b0000;
            vgaBlue  <= 4'b0000;
        end else if (is_triangle) begin
            vgaRed   <= 4'b1111;
            vgaGreen <= 4'b0000;
            vgaBlue  <= 4'b0000;
        end else begin
            vgaRed   <= 4'b0000;
            vgaGreen <= 4'b1111;
            vgaBlue  <= 4'b0000;
        end
    end

endmodule



























//Cod tabla

//always @(clk or rst)
//if (rst) btn_prev <= 1'b0; else
//if (btn (venit din constrangeri) btn_prev <=1'b1;
//                                 btn_prev <=1'b0;
