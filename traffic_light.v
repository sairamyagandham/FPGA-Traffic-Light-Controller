`timescale 1ns/1ps

module traffic_light(

    input clk,
    input reset,

    input emergency,

    input density_high,
    input density_side,

    output reg [2:0] highway,
    output reg [2:0] side

);

parameter RED    = 3'b100;
parameter YELLOW = 3'b010;
parameter GREEN  = 3'b001;

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

reg [1:0] state;
reg [3:0] count;

reg [3:0] highway_green_time;
reg [3:0] side_green_time;

always @(*)
begin

    if(density_high)
        highway_green_time = 8;
    else
        highway_green_time = 5;

    if(density_side)
        side_green_time = 8;
    else
        side_green_time = 5;

end

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin
        state   <= S0;
        count   <= 0;

        highway <= GREEN;
        side    <= RED;
    end

    else if(emergency)
    begin
        highway <= GREEN;
        side    <= RED;
    end

    else
    begin

        count <= count + 1;

        case(state)

        // Highway Green
        S0:
        begin

            highway <= GREEN;
            side    <= RED;

            if(count >= highway_green_time)
            begin
                state <= S1;
                count <= 0;
            end

        end

        // Highway Yellow
        S1:
        begin

            highway <= YELLOW;
            side    <= RED;

            if(count >= 2)
            begin
                state <= S2;
                count <= 0;
            end

        end

        // Side Green
        S2:
        begin

            highway <= RED;
            side    <= GREEN;

            if(count >= side_green_time)
            begin
                state <= S3;
                count <= 0;
            end

        end

        // Side Yellow
        S3:
        begin

            highway <= RED;
            side    <= YELLOW;

            if(count >= 2)
            begin
                state <= S0;
                count <= 0;
            end

        end

        default:
        begin
            state <= S0;
        end

        endcase

    end

end

endmodule
