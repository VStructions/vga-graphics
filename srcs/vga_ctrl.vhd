-- 
--   vga_ctrl.vhd
-- 
--   Created on: Feb 10, 2021
--       Author: VStructions
-- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- TOP LEVEL ENTITY THAT INSTATIATES 
-- vga_sync AND graph_gen AND clock_ip ENTITIES

entity vga_ctrl is
   port(
		clk_100MHz, reset		: in std_logic;
		sw0,sw1,sw2				: in std_logic;
		hsync, vsync			: out std_logic;
		red, green, blue		: out std_logic_vector (3 downto 0)
    );
end vga_ctrl;

architecture arch of vga_ctrl is

	component clk_wiz_0 is	--FPGA PLL clock from the IP_CLOCK_WIZARD
		port (
			reset             : in     std_logic;
			clk_in1           : in     std_logic;
			clk_out1          : out    std_logic
		);
	end component;

	component vga_sync is
		port(
			clk_25MHz, reset		: in std_logic;
			hsync, vsync			: out std_logic;
			video_on				: out std_logic;
			pixel_x, pixel_y		: out std_logic_vector (9 downto 0)	 
		);
	end component;

	component graph_gen is
		port (
			clk_25MHz, reset		: in  std_logic;
			sw0,sw1,sw2				: in  std_logic;
			video_on		 		: in  std_logic;
			pixel_x, pixel_y		: in  std_logic_vector (9 downto 0);
			red, green, blue		: out std_logic_vector (3 downto 0)
		);
	end component;

	signal clk_25MHz, video_on: std_logic;
	signal pixel_x, pixel_y	  : std_logic_vector (9 downto 0);

begin

	clock: clk_wiz_0
	PORT MAP (
		reset=>reset,
		clk_in1=>clk_100MHz,
		clk_out1=>clk_25MHz
	);
	--clk_25MHz <= clk_100MHz;	-- For the testbench

	vga_timing: vga_sync
	PORT MAP (
		clk_25MHz=>clk_25MHz,
		reset=>reset,
		hsync=>hsync,
		vsync=>vsync,
		video_on=>video_on,
		pixel_x=>pixel_x,
		pixel_y=>pixel_y
	);

	vga_graphics: graph_gen
	PORT MAP (
		clk_25MHz=>clk_25MHz,
		reset=>reset,
		sw0=>sw0,
		sw1=>sw1,
		sw2=>sw2,
		video_on=>video_on,
		pixel_x=>pixel_x,
		pixel_y=>pixel_y,
		red=>red,
		green=>green,
		blue=>blue
	);

end arch;