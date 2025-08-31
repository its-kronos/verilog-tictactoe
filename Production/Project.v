/*
 * TicTacToe
 * Created by Its_Kronos
 * 2025-08-29T21:58:47.184Z
 * 
 * This VGA project includes the HSync/VSync generator and displays
 * a colorful test pattern demonstrating different visual effects.
 */

`default_nettype none

// res_x_total = 640;
// res_y_total = 480;

parameter res_x = 480;
parameter res_y = 480;

parameter grid_thickness = 5;
parameter offset_x=80;
parameter offset_y=0;

parameter select_thickness = 5; //each unit is half of one unit for grid_thickness
parameter select_margin = 2;

parameter white = {2'b11, 2'b11, 2'b11};
parameter black = {2'b00, 2'b00, 2'b00};
parameter gray = {2'b10, 2'b10, 2'b10};


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

  wire game_over;
  assign game_over = 0;

  wire [1:0] sel_x;
  wire [1:0] sel_y;

  assign sel_x = 2'b00;
  assign sel_y = 2'b00;

  render render_mod(.clk(clk), .video_active(video_active), .game_over(game_over), .pix_x(pix_x), .pix_y(pix_y), .sel_x(sel_x), .sel_y(sel_y), .R(R), .G(G), .B(B));

endmodule

module render(
  input clk,
  input video_active,
  input game_over,
  input [9:0] pix_x,
  input [9:0] pix_y,
  input [1:0] sel_x,
  input [1:0] sel_y,
  output reg [1:0] R,
  output reg [1:0] G,
  output reg [1:0] B
);

  wire grid_active;


  assign grid_active = ((pix_x-offset_x)<=res_x&&(pix_y-offset_y)<res_y&&( ( ( ((pix_x-offset_x)<(((res_x)/3)+grid_thickness)) 
    && 
    
    ((pix_x-offset_x)>(((res_x)/3)-grid_thickness)) ) 
    
    || 
    
    ( ((pix_x-offset_x)<((((res_x)/3)*2)+grid_thickness)) 
    
    && 
    
    ((pix_x-offset_x)>((((res_x)/3)*2)-grid_thickness)) ) ) 
    
    || 
    
    ( ( ((pix_y-offset_y)>((((res_y)/3)*2)-grid_thickness)) 
    
    &&

    ((pix_y-offset_y)<((((res_y)/3)*2)+grid_thickness))

    ) 
    
    || 
    
    (((pix_y-offset_y)>(((res_y)/3)-grid_thickness))
    
    && ((pix_y-offset_y)<(((res_y)/3)+grid_thickness))

    ) ) )) 
    
    ? 1 : 0; //grid active

  
  wire select_active;
  reg select_active_x;
  reg select_active_y;

  always @(*) begin
    //x
    if (sel_x==2'b00) begin
      select_active_x = ((((pix_x-offset_x+grid_thickness+select_margin)<(res_x/3))&&(pix_x-offset_x+grid_thickness+select_margin+select_thickness)>(res_x/3)) ||(((pix_x-offset_x)<(0+grid_thickness+select_margin+select_thickness)))&&((pix_x-offset_x)>(0+grid_thickness+select_margin)));
    end
    else if (sel_x==2'b01) begin
      select_active_x = ((((pix_x-offset_x+grid_thickness+select_margin)<(res_x*2/3))&&(pix_x-offset_x+grid_thickness+select_margin+select_thickness)>(res_x*2/3)) ||(((pix_x-offset_x)<((res_x/3)+grid_thickness+select_margin+select_thickness)))&&((pix_x-offset_x)>((res_x/3)+grid_thickness+select_margin)));
    end
    else begin
      select_active_x = ((((pix_x-offset_x+grid_thickness+select_margin)<(res_x))&&(pix_x-offset_x+grid_thickness+select_margin+select_thickness)>(res_x)) ||(((pix_x-offset_x)<((res_x*2/3)+grid_thickness+select_margin+select_thickness)))&&((pix_x-offset_x)>((res_x*2/3)+grid_thickness+select_margin)));
    end

    //y

    if (sel_y==2'b00) begin
      select_active_y = ((((pix_y-offset_y+grid_thickness+select_margin)<(res_y/3))&&(pix_y-offset_y+grid_thickness+select_margin+select_thickness)>(res_y/3)) ||(((pix_y-offset_y)<(0+grid_thickness+select_margin+select_thickness)))&&((pix_y-offset_y)>(0+grid_thickness+select_margin)));
    end
    else if (sel_y==2'b01) begin
      select_active_y = ((((pix_y-offset_y+grid_thickness+select_margin)<(res_y*2/3))&&(pix_y-offset_y+grid_thickness+select_margin+select_thickness)>(res_y*2/3)) ||(((pix_y-offset_y)<((res_y/3)+grid_thickness+select_margin+select_thickness)))&&((pix_y-offset_y)>((res_y/3)+grid_thickness+select_margin)));
    end
    else begin
      select_active_y = ((((pix_y-offset_y+grid_thickness+select_margin)<(res_y))&&(pix_y-offset_x+grid_thickness+select_margin+select_thickness)>(res_y)) ||(((pix_y-offset_y)<((res_y*2/3)+grid_thickness+select_margin+select_thickness)))&&((pix_y-offset_y)>((res_y*2/3)+grid_thickness+select_margin)));
    end

    
  end


  assign select_active = select_active_x && select_active_y;


  always @(posedge clk) begin
    {R, G, B} <= black;
    if (video_active) begin

      // grid
      if (grid_active) begin
        {R,G,B} <= white;
      end

      if (~game_over) begin
        // select

        if (select_active) begin
          {R,G,B} <= gray;
        end

        
      end
      else begin // game over

      end
    end
    else begin // video active
    end
  end

endmodule


`default_nettype none
