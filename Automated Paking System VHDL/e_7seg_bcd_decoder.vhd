library ieee;
use ieee.std_logic_1164.all;

entity e_7seg_bcd_decoder is
	generic(n: integer := 8);
	port(
		count: in integer range 0 to 9;
		--hex_0: out std_logic_vector(6 downto 0)
		hex_0: out std_logic_vector(n-2 downto 0)

	);
end e_7seg_bcd_decoder;

architecture a_7seg_bcd_decoder of e_7seg_bcd_decoder is

	-- numbers for hex_0
	constant c_number_0: std_logic_vector := "0000001";
	constant c_number_1: std_logic_vector := "0110000";
	constant c_number_2: std_logic_vector := "0010010";
	constant c_number_3: std_logic_vector := "0000110";
	constant c_number_4: std_logic_vector := "1001100";
	constant c_number_5: std_logic_vector := "0100100";
	constant c_number_6: std_logic_vector := "0100000";
	constant c_number_7: std_logic_vector := "0001111";
	constant c_number_8: std_logic_vector := "0000000";
	constant c_number_9: std_logic_vector := "0000100";
	constant c_7seg_off: std_logic_vector := "1111111";
	
	------------------------------------- architecture begins -------------------------------------
	
	begin
	
	with count select 
		hex_0 <= c_number_0 when 0,
					c_number_1 when 1,
					c_number_2 when 2,
					c_number_3 when 3,
					c_number_4 when 4,
					c_number_5 when 5,
					c_number_6 when 6,
					c_number_7 when 7,
					c_number_8 when 8,
					c_number_9 when 9,
					c_7seg_off when others;
					
	
end a_7seg_bcd_decoder;