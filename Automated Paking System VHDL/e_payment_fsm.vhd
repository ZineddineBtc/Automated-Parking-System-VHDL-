library ieee;
use ieee.std_logic_1164.all;

entity e_payment_fsm is
	generic(n:integer:= 8);
	port(
		coin_in: in std_logic_vector(n-6 downto 0);  -- "50cents, 20cents, 10cents" -- "111"
		coin_out: out std_logic_vector(n-6 downto 0); -- "50cents, 20cents, 10cents" -- "111"
		payment: out integer range 0 to 140;
		paid: out boolean
	);
end e_payment_fsm;

architecture a_payment_fsm of e_payment_fsm is

	type payment_states is (zero_cent, ten_cents, twenty_cents, thirty_cents, forty_cents, fifty_cents, sixty_cents, 
									seventy_cents, eighty_cents, ninety_cents, one_euro, one_euro_ten_cents,
									one_euro_twenty_cents, one_euro_thirty_cents, one_euro_forty_cents);
	
	signal sl_coin_state: payment_states := zero_cent;
	
	------------------------------------- architecture begins -------------------------------------
	begin
	
	process(coin_in) begin
		case sl_coin_state is 
			when zero_cent =>
				if   (coin_in = "001") then sl_coin_state <= ten_cents;-- +10
				elsif(coin_in = "010") then sl_coin_state <= twenty_cents;-- +20
				elsif(coin_in = "100") then sl_coin_state <= fifty_cents;-- +50
				else 				   		    sl_coin_state <= zero_cent;-- +0
				end if;
				coin_out <= "000";
				payment <= 0;
								
			when ten_cents =>
				if   (coin_in = "001") then sl_coin_state <= twenty_cents;-- +10
				elsif(coin_in = "010") then sl_coin_state <= thirty_cents;-- +20
				elsif(coin_in = "100") then sl_coin_state <= sixty_cents;-- +50
				else 							    sl_coin_state <= ten_cents;-- +0
				end if;
				coin_out <= "000";
				payment <= 10;
							
			when twenty_cents =>
				if   (coin_in = "001") then sl_coin_state <= thirty_cents;-- +10
				elsif(coin_in = "010") then sl_coin_state <= forty_cents;-- +20
				elsif(coin_in = "100") then sl_coin_state <= seventy_cents;-- +50
				else 							    sl_coin_state <= twenty_cents;-- +0
				end if;
				coin_out <= "000";
				payment <= 20;
							
			when thirty_cents =>
				if   (coin_in = "001") then sl_coin_state <= forty_cents;-- +10
				elsif(coin_in = "010") then sl_coin_state <= fifty_cents;-- +20
				elsif(coin_in = "100") then sl_coin_state <= eighty_cents;-- +50
				else 							    sl_coin_state <= thirty_cents;-- +0
				end if;
				coin_out <= "000";
				payment <= 30;
								
			when forty_cents =>
				if   (coin_in = "001") then sl_coin_state <= fifty_cents;-- +10
				elsif(coin_in = "010") then sl_coin_state <= sixty_cents;-- +20
				elsif(coin_in = "100") then sl_coin_state <= ninety_cents;-- +50
				else 							    sl_coin_state <= forty_cents;-- +0
				end if;
				coin_out <= "000";
				payment <= 40;
								
			when fifty_cents =>
				if   (coin_in = "001") then sl_coin_state <= sixty_cents;-- +10
				elsif(coin_in = "010") then sl_coin_state <= seventy_cents;-- +20
				elsif(coin_in = "100") then sl_coin_state <= one_euro;-- +50
				else 							    sl_coin_state <= fifty_cents;-- +0
				end if;
				coin_out <= "000";
				payment <= 50;
								
			when sixty_cents =>
				if   (coin_in = "001") then sl_coin_state <= seventy_cents;-- +10
				elsif(coin_in = "010") then sl_coin_state <= eighty_cents;-- +20
				elsif(coin_in = "100") then sl_coin_state <= one_euro_ten_cents;-- +50
				else 							    sl_coin_state <= sixty_cents;-- +0
				end if;
				coin_out <= "000";
				payment <= 60;
								
			when seventy_cents =>
				if   (coin_in = "001") then sl_coin_state <= eighty_cents;-- +10
				elsif(coin_in = "010") then sl_coin_state <= ninety_cents;-- +20
				elsif(coin_in = "100") then sl_coin_state <= one_euro_twenty_cents;-- +50
				else 							    sl_coin_state <= seventy_cents;-- +0
			   end if;
				coin_out <= "000";
				payment <= 70;
								
			when eighty_cents =>
				if   (coin_in = "001") then sl_coin_state <= ninety_cents;-- +10
				elsif(coin_in = "010") then sl_coin_state <= one_euro;-- +20
				elsif(coin_in = "100") then sl_coin_state <= one_euro_thirty_cents;-- +50
				else 							    sl_coin_state <= eighty_cents;-- +0
				end if;
				coin_out <= "000";
				payment <= 80;
								
			when ninety_cents =>
				if   (coin_in = "001") then sl_coin_state <= one_euro;-- +10
				elsif(coin_in = "010") then sl_coin_state <= one_euro_ten_cents;-- +20
				elsif(coin_in = "100") then sl_coin_state <= one_euro_forty_cents;-- +50
				else 							    sl_coin_state <= ninety_cents;-- +0
				end if;
				coin_out <= "000";
				payment <= 90;
							
			when one_euro =>
				coin_out <= "000";
				paid <= true;
				payment <= 100;
						
			when one_euro_ten_cents => 
				coin_out <= "001"; -- give back 10
				paid <= true;
				payment <= 110;
								
			when one_euro_twenty_cents => 
				coin_out <= "010"; -- give back 20
				paid <= true;
				payment <= 120;
								
			when one_euro_thirty_cents => 
				coin_out <= "011"; -- give back 10, 20
				paid <= true;
				payment <= 130;
								
			when one_euro_forty_cents => 
				coin_out <= "011"; -- give back 10, 20
				sl_coin_state <= one_euro_ten_cents; -- to give back the remaining 10 cents
				payment <= 140;
		end case;
	end process;
end architecture;
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

	