library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity automated_parking_system is
	port(
		CLOCK_50, reset: in std_logic;
		moving_car_inside_sensor, car_entering_sensor: in std_logic;
		push_password_button, push_address_button: in std_logic;
		coin_in: in std_logic_vector(2 downto 0); -- "50cents, 20cents, 10cents" -- "111"
		password_in, address_in: in std_logic_vector(3 downto 0);
		green_led, red_led: out std_logic;
		gate: out std_logic;
		hex_0, hex_1, hex_2, hex_3, hex_4, hex_5: out std_logic_vector(6 downto 0);
		coin_out: out std_logic_vector(2 downto 0) -- "50cents, 20cents, 10cents" -- "111"
	);
end automated_parking_system;

architecture a_automated_parking_system of automated_parking_system is 
	
	constant c_password: std_logic_vector(3 downto 0) := "1101";
	constant c_park_capacity: integer := 9;
	
	signal sl_password_button_last_state: std_logic := '0';
	signal sl_address_button_last_state: std_logic := '0';
	signal sl_parked_cars_count: integer range 0 to 9;
	signal sl_state_choice: integer range 0 to 9; 
	signal sl_word_choice: integer range 0 to 5;
	signal sl_paid: boolean := false;
	signal sl_address_available: boolean;
	signal sl_words_0_coins_1: std_logic;
	signal sl_payment: integer range 0 to 140;
	signal sl_memory_enable: std_logic := '1'; -- active low
	
	------------------------------------- Procedures -----------------------------------------------
	procedure procedure_toggle_greenled_gate (signal green_led : out std_logic; signal gate : out std_logic) is
		begin
			gate <= '1'; -- opening the gate
			green_led <= '1';-- green light on
			-- wait 1 ns cycles for the car to enter
			gate <= '0'; -- closing the gate
			green_led <= '0';-- green light off
	end procedure_toggle_greenled_gate;
	
	------------------------------------- Components ----------------------------------------------
	component e_parking_fsm
	generic (n:integer:= 8);
		port(
			CLOCK_50, reset: in std_logic;
			moving_car_inside_sensor, car_entering_sensor: in std_logic;
			push_password_button, push_address_button: in std_logic;
			place_available, paid: in boolean;
			password_in, address_in: in std_logic_vector(3 downto 0);
			parked_cars_count: out integer range 0 to 9;
			state_choice: out integer range 0 to 9
		);
	end component;
	
	component e_7seg_words_coins 
	generic (n:integer:= 8);
     port(
			CLOCK_50, words_0_coins_1: in std_logic;
			word_choice: in integer range 0 to 5;
			payment: in integer range 0 to 140;
			hex_1, hex_2, hex_3, hex_4, hex_5: out std_logic_vector(6 downto 0)
		);
	end component;
	
	component e_7seg_bcd_decoder 
	generic (n:integer:= 8);
		port(
			count: in integer range 0 to 9;
			hex_0: out std_logic_vector(6 downto 0)
		);
	end component;
	
	component e_memory is
	generic (n:integer:= 8);
		port(
			enable, reset: in std_logic;
			address: in std_logic_vector(3 downto 0);
			address_is_available: out boolean
		);
	end component;
	
	component e_payment_fsm is
	generic (n: integer := 8);
		port(
			coin_in: in std_logic_vector(2 downto 0);  -- "50cents, 20cents, 10cents" -- "111"
			coin_out: out std_logic_vector(2 downto 0); -- "50cents, 20cents, 10cents" -- "111"
			payment: out integer range 0 to 140;
			paid: out boolean
		);
	end component;
	 
	------------------------------------- architecture begins -------------------------------------
	begin 
		-- state_choice
		-- 0: no_action_state,
		-- 1: car_detected_state
		-- 2: password_state							 
		-- 3: address_state
		-- 4: paying_state
		-- 5: parking_car_state
		-- 6: car_inside_state
		-- 7: hold_state
		-- 8: parking_done_state
		-- 9: full_park_state
		
		-- word_choice
		-- 0 => turned off
		-- 1 => addr
		-- 2 => pay
		-- 3 => enter
		-- 4 => hold
		-- 5 => full
		
		i_e_memory: e_memory 
		generic map(n => 8)
		port map(sl_memory_enable, reset, address_in, sl_address_available);
		
		i_e_parking_fsm: e_parking_fsm 
		generic map(n => 8)
      port map(CLOCK_50,
					reset, moving_car_inside_sensor, car_entering_sensor,
					push_password_button, push_address_button,
					sl_address_available, sl_paid,
					password_in, address_in,
					sl_parked_cars_count, sl_state_choice);
		
		i_e_payment_fsm: e_payment_fsm 
		generic map(n => 8)
		port map(coin_in, coin_out, sl_payment, sl_paid);
		 
		process(sl_state_choice) begin
			case sl_state_choice is
				when 2 => -- password_state (password entered correctly, now for the address)
					sl_word_choice <= 1; -- displaying the word addr
					sl_memory_enable <= '0'; -- enable memory for address_state (next state)
					
				when 3 => -- address_state 
					if(sl_address_available) then red_led <= '0';
					else 								   red_led <= '1';
					end if;
					
				when 4 => -- paying_state
					sl_word_choice <= 2; -- displaying the word pay
				
				when 5 => -- parking_car_state
					sl_word_choice <= 3; -- displaying the word enter
					procedure_toggle_greenled_gate(green_led, gate); -- opening the gate
					
				when 6 => -- car_inside_state
					sl_word_choice <= 0; -- turned off
					procedure_toggle_greenled_gate(green_led, gate); -- closing the gate
				
				when 7 => -- hold_state
					sl_word_choice <= 4; -- displaying the word hold
				
				when 9 => -- full_park_state
					sl_word_choice <= 5; -- displaying the word full
					
				when others => 
					sl_word_choice <= 0; -- turned off
				
			end case;
		end process;
		
		with sl_state_choice select
			sl_words_0_coins_1 <= '1' when 4, -- displaying coins only in paying_state
										 '0' when others;
		
		i_e_7seg_words_coins: e_7seg_words_coins
		generic map(n => 8)
		port map(CLOCK_50, sl_words_0_coins_1, 
					sl_word_choice, sl_payment, 
					hex_1, hex_2, hex_3, hex_4, hex_5);
		
		i_e_7seg_bcd_decoder: e_7seg_bcd_decoder 
		generic map(n => 8)
		port map(sl_parked_cars_count, hex_0);						
			
end a_automated_parking_system;


























