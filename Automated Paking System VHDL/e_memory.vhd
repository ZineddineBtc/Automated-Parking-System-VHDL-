library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity e_memory is
	generic(n: integer := 8);
	port(
		enable, reset: in std_logic;
		address: in std_logic_vector(n-5 downto 0);
		address_is_available: out boolean
	);
end e_memory;

architecture a_memory of e_memory is
	
	type memory_type is array (0 to 8) of bit;
	
	signal memory: memory_type := (others => '0');
	
	------------------------------------- architecture begins -------------------------------------
	begin
		process(enable, reset) begin
			if(reset = '0') then
				memory <= (others => '0');
			elsif(enable = '0') then
				case memory(to_integer(unsigned(address))) is 
					when '0' =>
						address_is_available <= true;
						memory(to_integer(unsigned(address))) <= '1';
					when '1' =>
						address_is_available <= false;
				end case;
			end if;
		end process;
		
end a_memory;
