library ieee;
use ieee.std_logic_1164.all;

entity e_7seg_words_coins is
	generic(n: integer := 8);
	port(
		CLOCK_50, words_0_coins_1: in std_logic;
		word_choice: in integer range 0 to 5;
		payment: in integer range 0 to 140;
		hex_1, hex_2, hex_3, hex_4, hex_5: out std_logic_vector(n-2 downto 0)
	);
end e_7seg_words_coins;

architecture a_7seg_words_coins of e_7seg_words_coins is

	constant c_7seg_off: std_logic_vector := "1111111";
	-- the word EntEr
	constant c_letter_E: std_logic_vector := "0110000";
	constant c_letter_n: std_logic_vector := "1101010";
	constant c_letter_t: std_logic_vector := "1110000";
	constant c_letter_r: std_logic_vector := "1111010";
	
	-- the word Hold
	constant c_letter_H: std_logic_vector := "1001000";
	constant c_letter_l: std_logic_vector := "1111001";
	constant c_letter_d: std_logic_vector := "1000010";
	constant c_letter_o: std_logic_vector := "1100010";
	
	-- the word Full
	constant c_letter_f: std_logic_vector := "0111000";
	constant c_letter_u: std_logic_vector := "1100011";
	
	-- the word Addr (address)
	constant c_letter_A: std_logic_vector := "0001000";
	
	-- the word Pay
	constant c_letter_P: std_logic_vector := "0011000";
	constant c_letter_Y: std_logic_vector := "1000100";
	
	-- decimal digits
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
	
	------------------------------------- architecture begins -------------------------------------
	
	begin
	
	process(CLOCK_50, words_0_coins_1) begin
		if(rising_edge(CLOCK_50)) then
			if(words_0_coins_1 = '0') then
				-- 0 => turned off
				-- 1 => addr
				-- 2 => pay
				-- 3 => enter
				-- 4 => hold
				-- 5 => full
				
				case word_choice is
					when 0 => -- turned off
						hex_5 <= c_7seg_off;
						hex_4 <= c_7seg_off;
						hex_3 <= c_7seg_off;
						hex_2 <= c_7seg_off;
						hex_1 <= c_7seg_off;
					
					when 1 => -- addr
						hex_5 <= c_letter_A;
						hex_4 <= c_letter_d;
						hex_3 <= c_letter_d;
						hex_2 <= c_letter_r;
						hex_1 <= c_7seg_off;
					
					when 2 => -- pay
						hex_5 <= c_letter_p;
						hex_4 <= c_letter_a;
						hex_3 <= c_letter_y;
						hex_2 <= c_7seg_off;
						hex_1 <= c_7seg_off;
					
					when 3 => -- enter
						hex_5 <= c_letter_e;
						hex_4 <= c_letter_n;
						hex_3 <= c_letter_t;
						hex_2 <= c_letter_e;
						hex_1 <= c_letter_r;
					
					when 4 => -- hold
						hex_5 <= c_letter_h;
						hex_4 <= c_letter_o;
						hex_3 <= c_letter_l;
						hex_2 <= c_letter_d;
						hex_1 <= c_7seg_off;
						
					when 5 => -- full
						hex_5 <= c_letter_f;
						hex_4 <= c_letter_u;
						hex_3 <= c_letter_l;
						hex_2 <= c_letter_l;
						hex_1 <= c_7seg_off;
				end case;
				
			elsif(words_0_coins_1 = '1') then
				hex_1 <= c_7seg_off;
				hex_2 <= c_7seg_off;
				hex_3 <= c_number_0;
				case payment is
					when 0   => hex_5 <= c_number_0; hex_4 <= c_number_0;
					when 10  => hex_5 <= c_number_0; hex_4 <= c_number_1;
					when 20  => hex_5 <= c_number_0; hex_4 <= c_number_2;
					when 30  => hex_5 <= c_number_0; hex_4 <= c_number_3;
					when 40  => hex_5 <= c_number_0; hex_4 <= c_number_4;
					when 50  => hex_5 <= c_number_0; hex_4 <= c_number_5;
					when 60  => hex_5 <= c_number_0; hex_4 <= c_number_6;
					when 70  => hex_5 <= c_number_0; hex_4 <= c_number_7;
					when 80  => hex_5 <= c_number_0; hex_4 <= c_number_8;
					when 90  => hex_5 <= c_number_0; hex_4 <= c_number_9;
					when 100 => hex_5 <= c_number_1; hex_4 <= c_number_0;
					when 110 => hex_5 <= c_number_1; hex_4 <= c_number_1;
					when 120 => hex_5 <= c_number_1; hex_4 <= c_number_2;
					when 130 => hex_5 <= c_number_1; hex_4 <= c_number_3;
					when 140 => hex_5 <= c_number_1; hex_4 <= c_number_4;
					when others =>hex_5 <= c_7seg_off; hex_4 <= c_7seg_off;
				end case;
			end if;
		end if;
	end process;
end a_7seg_words_coins;





















