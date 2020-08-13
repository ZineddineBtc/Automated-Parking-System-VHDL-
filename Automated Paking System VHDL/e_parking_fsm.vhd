library ieee;
use ieee.std_logic_1164.all;

entity e_parking_fsm is
	generic(n:integer:= 8);
	port(
		CLOCK_50, reset: in std_logic;
		moving_car_inside_sensor, car_entering_sensor: in std_logic;
		push_password_button, push_address_button: in std_logic;
		place_available, paid: in boolean;
		password_in, address_in: in std_logic_vector(n-5 downto 0);
		parked_cars_count: out integer range 0 to 9;
		state_choice: out integer range 0 to 9
	);
end e_parking_fsm;

architecture a_parking_fsm of e_parking_fsm is 
	
	constant c_password: std_logic_vector(3 downto 0) := "1101";
	constant c_park_capacity: integer := 9;
	
	type parking_states is (no_action_state, car_detected_state, password_state, address_state, paying_state,
									parking_car_state, car_inside_state, hold_state, parking_done_state, full_park_state);
	
	signal sl_present_state: parking_states := no_action_state;
	signal sl_password_button_last_state: std_logic := '0';
	signal sl_address_button_last_state: std_logic := '0';
	signal sl_parked_cars_count: integer range 0 to 9 := 0;
	signal sl_state_choice: integer range 0 to 9;
	 
	------------------------------------- architecture begins -------------------------------------
	begin 
		process(CLOCK_50, reset, moving_car_inside_sensor, car_entering_sensor, push_password_button, push_address_button)
		begin
			if(reset = '0') then -- active low reset
				sl_present_state <= no_action_state;
				
			elsif(rising_edge(CLOCK_50)) then
				case sl_present_state is
					
					when no_action_state =>
						if(moving_car_inside_sensor = '1') then
							sl_present_state <= car_detected_state;
						else
							sl_present_state <= no_action_state;
						end if;
					
					when car_detected_state =>
						-- the driver enters the password through the 4 switches and pushes the button
						if(push_password_button='1' and sl_password_button_last_state = '0') then -- push button pushed
							if(password_in = c_password) then -- correct password => change state
								sl_present_state <= password_state;
							end if;
						else
							sl_present_state <= car_detected_state;
						end if;
						sl_password_button_last_state <= push_password_button; -- debouncing the push button
						
					when password_state => 
						if(push_address_button = '1' and sl_address_button_last_state = '0') then -- push button pushed
							sl_present_state <= address_state;
						else 
							sl_present_state <= password_state;
						end if;
						sl_address_button_last_state <= push_address_button; -- debouncing the push button
						
					
					when address_state =>
						if(place_available) then -- checking if the place is available
							sl_present_state <= paying_state;
						end if;
					
					when paying_state =>
						if(paid) then sl_present_state <= parking_car_state;
						else          sl_present_state <= paying_state;
						end if;
						
					when parking_car_state =>
						-- checking if there are moving cars inside
						if(moving_car_inside_sensor = '0') then
							sl_present_state <= car_inside_state;
	
						else -- there is a moving car inside => HOLD
							sl_present_state <= hold_state;
						end if;
						
					when car_inside_state => 
						if(moving_car_inside_sensor = '0') then
								sl_present_state <= parking_done_state;
						end if;
						
					when hold_state =>
						if(moving_car_inside_sensor ='0') then
							sl_present_state <= parking_car_state;
						else
							sl_present_state <= hold_state;
						end if;
						
					when parking_done_state =>
						-- increment the count of parked cars
						sl_parked_cars_count <= sl_parked_cars_count + 1;
						if(sl_parked_cars_count = c_park_capacity) then -- full park
							sl_present_state <= full_park_state; 
						else
							sl_present_state <= no_action_state; -- full loop
						end if;
					
					when full_park_state =>
						sl_present_state <= full_park_state; -- deadlock	
				end case;
			end if;
		end process;
		
		parked_cars_count <= sl_parked_cars_count;
		
		with sl_present_state select
			sl_state_choice <= 0 when no_action_state, 
									 1 when car_detected_state,
									 2 when password_state, 
									 3 when address_state, 
									 4 when paying_state,
									 5 when parking_car_state, 
									 6 when car_inside_state, 
									 7 when hold_state, 
									 8 when parking_done_state, 
									 9 when full_park_state;
end a_parking_fsm;



























