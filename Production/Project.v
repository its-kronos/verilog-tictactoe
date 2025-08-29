/*
 * TicTacToe
 * Created by Its_Kronos
 * 2025-08-29T21:58:47.184Z
 * 
 * This VGA project includes the HSync/VSync generator and displays
 * a colorful test pattern demonstrating different visual effects.
 */

`default_nettype none

module tt_um_vga_example(
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,   // Dedicated outputs
  input  wire [7:0] uio_in,   // IOs: Input path
  output wire [7:0] uio_out,  // IOs: Output path
  output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
  input  wire       ena,      // always 1 when the design is powered, so you can ignore it
  input  wire       clk,      // clock
  input  wire       rst_n     // reset_n - low to reset
);

  // VGA signals
  wire hsync;
  wire vsync;
  reg [1:0] R;
  reg [1:0] G;
  reg [1:0] B;
  wire video_active;
  wire [9:0] pix_x;
  wire [9:0] pix_y;

  // TinyVGA PMOD - correct pin assignment
  assign uo_out = {hsync, B[0], G[0], R[0], vsync, B[1], G[1], R[1]};

  // Unused outputs assigned to 0
  assign uio_out = 0;
  assign uio_oe  = 0;

  // Suppress unused signals warning
  wire _unused_ok = &{ena, ui_in, uio_in};

  // Instantiate the HSync/VSync generator
  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(~rst_n),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(video_active),
    .hpos(pix_x),
    .vpos(pix_y)
  );

  render render_mod(.clk(clk), .video_active(video_active), .R(R), .G(G), .B(B));

endmodule

module render(
  input clk,
  input video_active,
  output reg [1:0] R,
  output reg [1:0] G,
  output reg [1:0] B
);

  always @(posedge clk) begin
    if (video_active) begin
      R<=2'b01;
      G<=2'b01;
      B<=2'b01;
    end
    else begin
      R <= 2'b00;
      G <= 2'b00;
      B <= 2'b00;
    end
  end

endmodule


`default_nettype none
