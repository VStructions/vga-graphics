-- 
--   vga_sync.vhd
-- 
--   Created on: Feb 10, 2021
--       Author: VStructions
-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_sync is
   port(
      clk_25MHz, reset		: in std_logic;
      hsync, vsync			: out std_logic;
      video_on				: out std_logic;
      pixel_x, pixel_y		: out std_logic_vector (9 downto 0)	 
    );
end vga_sync;

architecture arch of vga_sync is

	-- VGA 640-by-480 sync parameters
	constant HD : integer:= 640;      --horizontal display area, horizontal front porch frame
	constant HF : integer:= 16 ;      --h. front porch
	constant HB : integer:= 48 ;      --h. back porch
	constant HR : integer:= 96 ;      --h. retrace
	constant VD : integer:= 480 - 1;  --vertical display area, vertical front porch frame, -1 : v_video_on signal compensation
	constant VF : integer:= 10 ;      --v. front porch  ?11
	constant VB : integer:= 33 ;      --v. back porch  ?31
	constant VR : integer:= 2  ;      --v. retrace

	constant HRF: integer:= HD  + HF;     --horizontal retrace frame
	constant HBF: integer:= HRF + HR;     --horizontal back porch frame
	constant HRS: integer:= HBF + HB;     --horizontal reset
	constant HVT: integer:= HRS -  1;     --vertical tick
	constant VRF: integer:= VD + 1 + VF;  --vertical retrace frame, +1 : v_video_on signal compensation
	constant VBF: integer:= VRF + VR;     --vertical back porch frame
	constant VRS: integer:= VBF + VB;     --vertical reset
	constant VVO: integer:= VRS - 1;      --vertical v_video_on compensation, needs to signal one cycle earlier!

	signal x_count, y_count: unsigned(9 downto 0);
	signal hsync_s, vsync_s, v_video_on, v_tick: std_logic;

begin
    --  HSync also controlls the video_on signal
	Horizontal_Sync: process (clk_25MHz) is        
	begin
		if rising_edge(clk_25MHz) then

			v_tick <= '0';	-- Default clk value for Vsync

			if reset = '1' then
				hsync_s <= '1';
				video_on <= '1';
				x_count <= to_unsigned(0, x_count'length);--
			
			else

				if x_count = 0 then
					hsync_s <= '1';
					video_on <= '1' and v_video_on;	

				elsif x_count = HD then  --End of display area, front porch
					video_on <= '0';

				elsif x_count = HRF then --Retrace
					hsync_s <= '0';

				elsif x_count = HBF then --Back porch
					hsync_s <= '1';	
				
				elsif x_count = HVT then --Give clk when line is complete
					v_tick <= '1';	    	

				end if;

				if x_count = HRS then    --Start again
					pixel_x <= std_logic_vector(to_unsigned(0, pixel_x'length));
					x_count <= to_unsigned(1, x_count'length);
					hsync_s <= '1';
					video_on <= '1' and v_video_on;
				else
					pixel_x <= std_logic_vector(x_count);
					x_count <= x_count + 1;	--Count always
				end if;

			end if;
		end if;
	end process Horizontal_Sync;

	Vertical_Sync: process (clk_25Mhz) is
	begin
		
		if rising_edge(clk_25MHz) then

			if reset = '1' then
				vsync_s <= '1';
				v_video_on <= '1';
				pixel_y <= std_logic_vector(to_unsigned(0, pixel_y'length));
				y_count <= to_unsigned(1, y_count'length);
		
			elsif v_tick = '1' then

				if y_count = 0 then
					vsync_s <= '1';
					v_video_on <= '1';

				elsif y_count = VD then  --End of display area, front porch
					v_video_on <= '0';

				elsif y_count = VRF then --Retrace
					vsync_s <= '0';

				elsif y_count = VBF then --Back porch
					vsync_s <= '1';
					
				elsif y_count = VVO then
				    v_video_on <= '1';
	
				end if;
				
				if y_count = VRS then    --Start again
					pixel_y <= std_logic_vector(to_unsigned(0, pixel_y'length));
					y_count <= to_unsigned(1, y_count'length);
					vsync_s <= '1';
				else
					pixel_y <= std_logic_vector(y_count);
					y_count <= y_count + 1;	--Count always
				end if;
			
			end if;
		end if;
	end process Vertical_Sync;

	Sync_Pipeline_Reg: process (clk_25MHz) is
	begin

		if rising_edge(clk_25MHz) then
			if reset = '1' then
				hsync <= '0';
				vsync <= '0';
			
			else
				hsync <= hsync_s;
				vsync <= vsync_s;

			end if;
		end if;
	end process Sync_Pipeline_Reg;

end arch;
