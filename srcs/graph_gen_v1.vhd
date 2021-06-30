-- 
--   graph_gen_v1.vhd
-- 
--   Created on: Feb 10, 2021
--       Author: VStructions
-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity graph_gen is
	port(
		clk_25MHz, reset		: in  std_logic;
		sw0,sw1,sw2				: in  std_logic;
		video_on		 		: in  std_logic;
		pixel_x, pixel_y		: in  std_logic_vector (9 downto 0);
		red, green, blue		: out std_logic_vector (3 downto 0)
    );
end graph_gen;

architecture Behavioral of graph_gen is

	signal pic_select: std_logic_vector(2 downto 0);
	signal pixel:      std_logic_vector(2 downto 0);

begin

	pic_select <= sw2 & sw1 & sw0;

	--Asynchronous color calculation for the checkerboard
	--Otherwise the circuit would require a pipeline delay, or a different implementation :3
	pixel <= std_logic_vector(unsigned(pixel_x(8 downto 6)) + unsigned(pixel_y(8 downto 6)));

	graph_gen_reg: process (clk_25MHz) is
	begin

		if rising_edge(clk_25MHz) then

			if reset = '1' or video_on = '0' then

				red   <= (others => '0');
				green <= (others => '0');
				blue  <= (others => '0');

			elsif video_on = '1' then

				green <= (others => '0');	--Defaults
				blue  <= (others => '0');

				case pic_select is

					when "000" =>     -- Color Checkerboard 64x64 pixels per color
								red   <= (others => pixel(2));
								green <= (others => pixel(1));
								blue  <= (others => pixel(0));

					when "001" =>     -- Color Vertical Bars 64 pixels wide
								red   <= (others => pixel_x(8));
								green <= (others => pixel_x(7));
								blue  <= (others => pixel_x(6));

					when "010" =>     -- Color Horizontal Bars 64 pixels tall
								red   <= (others => pixel_y(8));
								green <= (others => pixel_y(7));
								blue  <= (others => pixel_y(6));

					when "011" =>     -- Red Vertical Bars 64 pixels wide
								red   <= (others => pixel_x(6));

					when "100" =>     -- Red Horizontal Bars 64 pixels tall
								red   <= (others => pixel_y(6));
					
					when "111" =>     -- Red Contour 1 pixel
								if pixel_x = "0000000000" or pixel_x = "1001111111" or
								   pixel_y = "0000000000" or pixel_y = "0111011111"    then
										red <= (others => '1');
								else
										red <= (others => '0');
								end if;
					when others => 
								red   <= (others => '0');
								green <= (others => '0');
								blue  <= (others => '0');
				end case;
			end if;
		end if;
	end process graph_gen_reg;
end Behavioral;