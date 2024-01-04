`timescale 1ns / 1ps
module display (
input wire clk,
input wire btnU, btnL, btnR, btnD, btnP,
output reg hsync, vsync,
output reg [3:0] red, green, blue,
// output reg [2:0] red, green, blue,
output wire [6:0] seg,
output wire [3:0] an
);

wire clkAdj, clkReg, clkFast, clkBlink;

   Clock clock_ (
          // Outputs
          .clkAdj                  (clkAdj), 
          .clkReg                  (clkReg), 
          .clkFast                 (clkFast), 
          .clkBlink                (clkBlink),
          /*AUTOINST*/
          // Inputs
          .clk                       (clk));

reg [9:0] hcount = 0;
reg [9:0] vcount = 0;
reg [1:0] counter = 0;
reg enable;
wire square_on, maze_on, collision, ghost_on, dots_on;

    reg [3:0]  digits [3:0];
    reg [3:0]  anode;
    reg [1:0]  index;
    reg [6:0]  segreg;
    
        reg dot1 = 0; // needs to become 1 when Pacman lands on it
    reg dot2 = 0;
    reg dot3 = 0;
    
    reg pse = 0;

    assign seg = ~segreg;
    assign an = ~anode;


	function [6:0] segments (input [3:0] digit);
       begin
        case (digit)
            4'b0000 : segments = 7'b0111111;
            4'b0001 : segments = 7'b0000110;
            4'b0010 : segments = 7'b1011011;
            4'b0011 : segments = 7'b1001111;
            4'b0100 : segments = 7'b1100110;
            4'b0101 : segments = 7'b1101101;
            4'b0110 : segments = 7'b1111101;
            4'b0111 : segments = 7'b0000111;
            4'b1000 : segments = 7'b1111111;
            4'b1001 : segments = 7'b1100111;
            default : segments = 7'b1111001;
        endcase
       end
   endfunction
   
//   always @ (posedge pause)
//    begin
//        pse <= ~pse;
//    end

   always @ (posedge clkBlink)
        begin
//          if (reset) begin
//            dot1 <= 0;
//            dot2 <= 0;
//            dot3 <= 0;
//          end
//          else
            digits[0] <= dot1 + dot2 + dot3;
        end
        
        
   always @ (posedge clkFast)
          begin
              index <= index + 1;
              anode <= 0;
              anode[index] <= 1;
              segreg <= segments(digits[index]);
         end


always @ (posedge clk)
begin
  if (counter == 3)
  begin
    counter <= 1'b0;
    enable <= 1'b1;
  end
  else
  begin
    counter <= counter + 1'b1;
    enable <= 1'b0;
  end
end

always @(posedge clk)
begin
  if (enable == 1)
  begin
    if(hcount == 799)
    begin
      hcount <= 0;
      if(vcount == 524)
        vcount <= 0;
      else 
        vcount <= vcount+1'b1;
    end
    else
      hcount <= hcount+1'b1;
 
 
  if (vcount >= 490 && vcount < 492) 
    vsync <= 1'b0;
  else
    vsync <= 1'b1;

  if (hcount >= 656 && hcount < 752) 
    hsync <= 1'b0;
  else
    hsync <= 1'b1;
  end
end



        // tile width and height
    localparam T_W = 50; // 16
    localparam T_H = 50; // 16

    reg [9:0] ph = 300;
    reg [9:0] pv = 300;
    
    reg [9:0] gh = 400;
    reg [9:0] gv = 200;
    
    localparam WALL_W = 10;
    localparam WALL_H = 400;
    localparam NEW_W = 50 + WALL_W;
    
    function maze (input [9:0] hcount, vcount);
        begin
         maze = (hcount >= 50) && (hcount < 50 + WALL_W) && (vcount >= 50) && (vcount < 50 + WALL_H) ||
                (hcount >= 50 + WALL_H) && (hcount < 50 + WALL_H + WALL_W) && (vcount >= 50) && (vcount < 50 + WALL_H) ||
                (vcount >= 50) && (vcount <= 50 + WALL_W) && (hcount >= 50) && (hcount <= 50 + WALL_H) ||
                (vcount >= 50 + WALL_H) && (vcount <= 50 + WALL_H + WALL_W) && (hcount >= 50) && (hcount <= 50 + WALL_H + WALL_W) ||
                (hcount >= NEW_W + 60) && (hcount <= NEW_W + 140) && (vcount >= NEW_W + 60) && (vcount <= NEW_W + 60 + WALL_W) ||
                (vcount >= NEW_W + 60) && (vcount <= NEW_W + 140) && (hcount >= NEW_W + 60) && (hcount <= NEW_W + 60 + WALL_W) ||
                (hcount >= NEW_W + 60) && (hcount <= NEW_W +140) && (vcount >= NEW_W + 310) && (vcount <= NEW_W + 310 + WALL_W) ||
                (vcount >= NEW_W + 240) && (vcount <= NEW_W + 320) && (hcount >= NEW_W + 60) && (hcount <= NEW_W + 60 + WALL_W) ||
                (hcount >= NEW_W + 240) && (hcount <= NEW_W + 320) && (vcount >= NEW_W + 60) && (vcount <= NEW_W + 60 + WALL_W) ||
                (vcount >= NEW_W + 60) && (vcount <= NEW_W + 140) && (hcount >= NEW_W + 310) && (hcount <= NEW_W + 310 + WALL_W) ||
                (hcount >= NEW_W + 240) && (hcount <= NEW_W +320) && (vcount >= NEW_W + 310) && (vcount <= NEW_W + 310 + WALL_W) ||
                (vcount >= NEW_W + 240) && (vcount <= NEW_W + 320) && (hcount >= NEW_W + 310) && (hcount <= NEW_W + 310 + WALL_W) ||
                (vcount >= NEW_W + 140) && (vcount <= NEW_W + 240) && (hcount >= NEW_W + 140) && (hcount <= NEW_W + 140 + WALL_W) ||
                (hcount >= NEW_W + 140) && (hcount <= NEW_W + 240) && (vcount >= NEW_W + 230) && (vcount <= NEW_W + 230 + WALL_W) || 
                (vcount >= NEW_W + 140) && (vcount <= NEW_W + 240) && (hcount >= NEW_W + 230) && (hcount <= NEW_W + 230 + WALL_W)                            
        ;
        end
    endfunction
    

    assign maze_on = maze(hcount, vcount);
    
    localparam DOT_W = 16;
    

    
    assign dots_on = dots(hcount, vcount);
    
    function dots (input [9:0] hcount, vcount);
    begin
        dots = (hcount >= NEW_W + 22) && (hcount < NEW_W + 22 + DOT_W) && (vcount >= NEW_W + 22) && (vcount < NEW_W + 22 + DOT_W) && !dot1
        || (hcount >= NEW_W + 22) && (hcount <= NEW_W + 22 + DOT_W) && (vcount >= NEW_W + 212) && (vcount <= NEW_W + 212 +  DOT_W)  && !dot2
        || (hcount >= NEW_W + 212) && (hcount <= NEW_W + 212 + DOT_W) && (vcount >= NEW_W + 22) && (vcount <= NEW_W + 22 +  DOT_W) && !dot3
        ;
    end
    endfunction
    
//    assign maze_on = (hcount >= 50) && (hcount < 50 + WALL_W) && (vcount >= 50) && (vcount < 50 + WALL_H) ||
//                     (hcount >= 50 + WALL_H) && (hcount < 50 + WALL_H + WALL_W) && (vcount >= 50) && (vcount < 50 + WALL_H) ||
//                     (vcount >= 50) && (vcount <= 50 + WALL_W) && (hcount >= 50) && (hcount <= 50 + WALL_H) ||
//                     (vcount >= 50 + WALL_H) && (vcount <= 50 + WALL_H + WALL_W) && (hcount >= 50) && (hcount <= 50 + WALL_H + WALL_W);

    function hit (input[9:0] ph, pv, gh, gv, delta);
        begin
            if (ph >= gh && ph - gh < delta)
            begin
                if (pv >= gv && pv - gv < delta)
                            hit = 1;
                else if (gv >= pv && gv - pv < delta)
                            hit = 1;
            end
            else if (gh >= ph && gh - ph < delta)
            begin
                    if (pv >= gv && pv - gv < delta)
                        hit = 1;
                    else if (gv >= pv && gv - pv < delta)
                        hit = 1;
            end
            else
                hit = 0;
        end
    endfunction

    function hitDot (input[9:0] ph, pv, gh, gv, delta);
        begin
            if (ph > gh && ph - gh < delta)
            begin
                if ( gv > pv && gv - pv < T_W)
                    hitDot = 1;
                else if (pv > gv && pv - gv < delta)
                    hitDot = 1;
            end
            else if (gh > ph && gh - ph < T_W)
            begin
                if (pv > gv && pv - gv < delta) 
                    hitDot = 1; // here
                else if (gv > pv && gv - pv < T_W)
                    hitDot = 1;
            end
            else if (gv > pv && gv - pv < T_W)
            begin
                if (gh > ph && gh - ph < T_W)
                    hitDot = 1;
                else if (ph > gh && ph - gh < delta)
                    hitDot = 1;
            end
            else if (pv > gv && pv - gv < delta)
            begin
               if (gh > ph && gh - ph < T_W)
                   hitDot = 1;
               else if (ph > gh && ph - gh < delta)
                   hitDot = 1;
            end
            else
                hitDot = 0;
        end
    endfunction

    assign collision = hit(ph, pv, gh, gv, T_W); // there may be a bug but... later
   

    function pacman (input [9:0] hcount, vcount);
        begin
         pacman = (hcount >= ph) && (hcount < ph + T_W) &&
                           (vcount >= pv) && (vcount < pv + T_H);
        end
    endfunction

    assign square_on = pacman(hcount, vcount);

    function ghost (input [9:0] hcount, vcount);
        begin
         ghost = (hcount >= gh) && (hcount < gh + T_W) &&
                           (vcount >= gv) && (vcount < gv + T_H);
        end
    endfunction
    
    assign ghost_on = ghost(hcount, vcount);


    // symbolic states for left and right motion
    localparam LEFT = 2'b10;
    localparam RIGHT = 2'b01;
    localparam UP = 2'b00;
    localparam DOWN = 2'b11;

    reg [1:0] dir_reg, dir_next;

    
        always @(posedge clk)
//        if (reset)
//            dir_reg     <= RIGHT;
//        else
            dir_reg     <= dir_next;

    // left vertical
    // right vertical
    // top hor
    // bottom hor
//    assign collision = (ph <= 50 + WALL_W) && (pv >= 50) && (pv < 50 + WALL_H) ||
//                     (ph >= 50 + WALL_H) && (ph < 50 + WALL_H + WALL_W) && (pv >= 50) && (pv < 50 + WALL_H) ||
//                     (pv >= 50) && (pv <= 50 + WALL_W) && (ph >= 50) && (ph <= 50 + WALL_H) ||
//                     (pv >= 50 + WALL_H) && (pv <= 50 + WALL_H + WALL_W) && (ph >= 50) && (ph <= 50 + WALL_H + WALL_W);

	// direction register next-state logic
    always @*
        begin
        dir_next <= dir_reg;   // default, stay the same
       
           if (btnP)
             pse <= pse + 1;
       
        if(btnL && !btnR)     // if left button pressed, change value to LEFT
            dir_next <= LEFT;  
           
        if(btnR && !btnL)     // if right button pressed, change value to RIGHT
            dir_next <= RIGHT;
        
        if (btnU && !btnD)    // if up button pressed, change value to UP
            dir_next <= UP;

        if (btnD && !btnU)    // if down button pressed, change value to DOWN
            dir_next <= DOWN;
        end

    integer gcount; // higher means slower; this is the period of the ghosts' movement time btween each movement
    always @ (posedge clkFast)
        begin
            if (gcount == 15)
            begin
                gcount <= 0;
                if (pse == 0)
                begin
                // ghost ABOVE pacman
                if (gv < pv && !maze(gh, gv + T_W + 1) && !maze(gh + 10, gv + T_W + 1)&& !maze(gh + 20, gv + T_W + 1) && !maze(gh + 30, gv + T_W + 1) && !maze(gh + 40, gv + T_W + 1) && !maze(gh + 50, gv + T_W + 1)) // change asap for collision
                    gv <= gv + 1;
                // ghost RIGHT of pacman
                else if (gh > ph && !maze(gh - 1, gv) && !maze(gh - 1, gv + 10) && !maze(gh - 1, gv + 20) && !maze(gh - 1, gv + 30) && !maze(gh - 1, gv + 40) && !maze(gh - 1, gv + 50))
                    gh <= gh - 1;
                // ghost BELOW pacman
                else if (gv > pv && !maze(gh, gv - 1) && !maze(gh + 10, gv - 1)&& !maze(gh + 20, gv - 1) && !maze(gh + 30, gv - 1) && !maze(gh + 40, gv - 1) && !maze(gh + 50, gv - 1))
                    gv <= gv - 1;
                // ghost LEFT of pacman
                else if (gh < ph && !maze(gh + T_W + 1, gv) && !maze(gh + T_W + 1, gv + 10)&& !maze(gh + T_W + 1, gv + 20) && !maze(gh + T_W + 1, gv + 30) && !maze(gh + T_W + 1, gv + 40)&& !maze(gh + T_W + 1, gv + 50))
                    gh <= gh + 1;
                // ghost go down
                else if (!maze(gh, gv + T_W + 1) && !maze(gh + 10, gv + T_W + 1)&& !maze(gh + 20, gv + T_W + 1) && !maze(gh + 30, gv + T_W + 1) && !maze(gh + 40, gv + T_W + 1) && !maze(gh + 50, gv + T_W + 1)) // change asap for collision
                    gv <= gv + 1;
                // ghost go left
                else if (!maze(gh - 1, gv) && !maze(gh - 1, gv + 10) && !maze(gh - 1, gv + 20) && !maze(gh - 1, gv + 30) && !maze(gh - 1, gv + 40) && !maze(gh - 1, gv + 50))
                    gh <= gh - 1;
                // ghost go up
                else if (!maze(gh, gv - 1) && !maze(gh + 10, gv - 1)&& !maze(gh + 20, gv - 1) && !maze(gh + 30, gv - 1) && !maze(gh + 40, gv - 1) && !maze(gh + 50, gv - 1))
                    gv <= gv - 1;
                // ghost go right
                else if (!maze(gh + T_W + 1, gv) && !maze(gh + T_W + 1, gv + 10)&& !maze(gh + T_W + 1, gv + 20) && !maze(gh + T_W + 1, gv + 30) && !maze(gh + T_W + 1, gv + 40)&& !maze(gh + T_W + 1, gv + 50))
                    gh <= gh + 1;
                end
            end
            else
                gcount <= gcount + 1;
        end

    always @ (posedge clkFast)
        begin
            case(dir_reg)
                RIGHT: if (pse == 0 && !collision)
                        begin
                            if (!maze(ph + T_W + 1, pv) && !maze(ph + T_W + 1, pv + 10)&& !maze(ph + T_W + 1, pv + 20) && !maze(ph + T_W + 1, pv + 30) && !maze(ph + T_W + 1, pv + 40)&& !maze(ph + T_W + 1, pv + 50)) // change asap
                                ph <= ph + 1;
                        end
                LEFT:  if (pse == 0 && !collision)
                        begin
                            if (!maze(ph - 1, pv) && !maze(ph - 1, pv + 10) && !maze(ph - 1, pv + 20) && !maze(ph - 1, pv + 30) && !maze(ph - 1, pv + 40) && !maze(ph - 1, pv + 50))
                                ph <= ph - 1;
                        end
                UP:    if (pse == 0 && !collision) 
                        begin
                            if (!maze(ph, pv - 1) && !maze(ph + 10, pv - 1)&& !maze(ph + 20, pv - 1) && !maze(ph + 30, pv - 1) && !maze(ph + 40, pv - 1) && !maze(ph + 50, pv - 1))
                                pv <= pv - 1;
                        end
                DOWN:  if (pse == 0 && !collision) 
                        begin
                            if (!maze(ph, pv + T_W + 1) && !maze(ph + 10, pv + T_W + 1)&& !maze(ph + 20, pv + T_W + 1) && !maze(ph + 30, pv + T_W + 1) && !maze(ph + 40, pv + T_W + 1) && !maze(ph + 50, pv + T_W + 1))
                                pv <= pv + 1;
                        end
            endcase
            if (hitDot(ph, pv, NEW_W + 22, NEW_W + 22, DOT_W)) // change asap not working
                dot1 = 1;
            if (hitDot(ph, pv, NEW_W + 22, NEW_W + 212, DOT_W)) // change asap not working
                dot2 = 1;
            if (hitDot(ph, pv, NEW_W + 212, NEW_W + 22, DOT_W)) // change asap not working
                dot3 = 1;
        end
        
    

always @ (posedge clk)
begin
  if (enable)
  begin
    if (ghost_on)
    begin
        red <= 0;
        blue <= 3'b111;
        green <= 3'b111;
    end
    else if (square_on && collision) // pacman turns red on collision
    begin
        red <= 3'b111;
        blue <= 0;
        green <= 3'b001;
    end
    else if (square_on) // pacman normal color (yellow)
        begin
            red <= 3'b111;
            blue <= 3'b000;
            green <= 3'b111;
        end
    else if (maze_on) // blue maze
    begin
        red <= 3'b000;
        blue <= 3'b111;
        green <= 3'b000;
    end
    else if (dots_on) // peach dots ??
    begin
        red <= 3'b111;
        green <= 3'b101;
        blue <= 3'b110;
    end
    else 
    begin
      green <= 3'b000;
      blue <= 2'b00; 
      red <= 3'b000;
    end
  end 
end 
endmodule