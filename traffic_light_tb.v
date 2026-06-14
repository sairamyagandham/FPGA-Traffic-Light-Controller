`timescale 1ns/1ps

module traffic_light_tb();

reg clk;
reg reset;

reg emergency;

reg density_high;
reg density_side;

wire [2:0] highway;
wire [2:0] side;

traffic_light DUT(

    .clk(clk),
    .reset(reset),

    .emergency(emergency),

    .density_high(density_high),
    .density_side(density_side),

    .highway(highway),
    .side(side)

);

always #5 clk = ~clk;

initial
begin

    $dumpfile("dump.vcd");
    $dumpvars(0, traffic_light_tb);

end

initial
begin

    clk = 0;

    reset = 1;

    emergency = 0;

    density_high = 0;
    density_side = 0;

    #20;
    reset = 0;

    // Normal Traffic

    #100;

    // Heavy Highway Traffic

    density_high = 1;

    #100;

    density_high = 0;

    // Heavy Side Road Traffic

    density_side = 1;

    #100;

    density_side = 0;

    // Emergency Vehicle

    emergency = 1;

    #40;

    emergency = 0;

    #100;

    $finish;

end

endmodule
