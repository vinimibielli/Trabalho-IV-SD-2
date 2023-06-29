`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module tb;

  reg clock, reset, start, op;
  reg [31:0] data_a, data_b;
  wire busy, ready;
  wire [31:0] data_o;

  localparam PERIOD_100MHZ = 8;  

  initial
  begin
    clock = 1'b1;
    forever #(PERIOD_100MHZ/2) clock = ~clock;
  end

  initial
  begin
    reset = 1'b1;
    #30;
    reset = 1'b0;
    start = 1'b0;
    //SOMA++
    op = 1'b0;
    data_a = 32'h53924124;
    data_b = 32'h49b53098;
    #80;
    start  = 1'b1;
    #8;
    start = 1'b0;
    wait (busy != 1'b1);
    #10;
    //SOMA--
    op = 1'b0;
    data_a = 32'he24f5659;
    data_b = 32'hDEA0FE79;
    #80;
    start  = 1'b1;
    #8;
    start = 1'b0;
    wait (busy != 1'b1);
    #10;
    //SOMA-+
    op = 1'b0;
    data_a = 32'h5b873554;
    data_b = 32'hD6F4531D;
    #80;
    start  = 1'b1;
    #8;
    start = 1'b0;
    wait (busy != 1'b1);
    #10;
    //SUB++
    op = 1'b1;
    data_a = 32'h58E966F4;
    data_b = 32'h6294EFF4;
    #80;
    start  = 1'b1;
    #8;
    start = 1'b0;
    wait (busy != 1'b1);
    #10;
    //SUB--
    op = 1'b1;
    data_a = 32'hD52552BB;
    data_b = 32'hCDEBC669;
    #80;
    start  = 1'b1;
    #8;
    start = 1'b0;
    wait (busy != 1'b1);
    #10;
    //SUB+-
    op = 1'b1;
    data_a = 32'h62CA531B;
    data_b = 32'hD285D5B1;
    #80;
    start  = 1'b1;
    #8;
    start = 1'b0;
    wait (busy != 1'b1);
    #10;
    //SOMA++
    op = 1'b0;
    data_a = 32'h1FC55B95;
    data_b = 32'h1AB378CA;
    #80;
    start  = 1'b1;
    #8;
    start = 1'b0;
    wait (busy != 1'b1);
    #10;
    //SOMA--
    op = 1'b0;
    data_a = 32'hA2CD1A9B;
    data_b = 32'hAE8D7732;
    #80;
    start  = 1'b1;
    #8;
    start = 1'b0;
    wait (busy != 1'b1);
    #10;
    //SOMA-+
    op = 1'b0;
    data_a = 32'h26E71B66;
    data_b = 32'hAF9ACEEB;
    #80;
    start  = 1'b1;
    #8;
    start = 1'b0;
    wait (busy != 1'b1);
    #10;
    //SUB++
    op = 1'b1;
    data_a = 32'h26A35B22;
    data_b = 32'h29DC4AAE;
    #80;
    start  = 1'b1;
    #8;
    start = 1'b0;
    wait (busy != 1'b1);
    #10;
    //SUB--
    op = 1'b1;
    data_a = 32'h9EB3D7A9;
    data_b = 32'h9A9B56A3;
    #80;
    start  = 1'b1;
    #8;
    start = 1'b0;
    wait (busy != 1'b1);
    #10;
    //SUB+-
    op = 1'b1;
    data_a = 32'h48C35000;
    data_b = 32'hC8C34FC0;
    #80;
    start  = 1'b1;
    #8;
    start = 1'b0;
    wait (busy != 1'b1);
    #10;
  end

  top DUT(.reset(reset), .clock(clock), .start(start), .op(op), .data_a(data_a), .data_b(data_b), .busy(busy), .ready(ready), .data_o(data_o));

endmodule 