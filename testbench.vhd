library ieee;
use ieee.std_logic_1164.all;

entity tb_fsm is
-- empty
end entity;

architecture sim of tb_fsm is

-- 	Signals
	signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal btn : std_logic := '0';
    signal sw  : std_logic_vector(4 downto 0) := "00000";
    signal led0 : std_logic := '0';
    signal led1 : std_logic := '0';
    signal led2 : std_logic := '0';

begin
    -- The DUT
    dut : entity work.fsm
        port map (
            clk => clk,
            reset => rst,
            evaluate_btn => btn,
            encoded_input_character => sw,
            out_led_0 => led0,
            out_led_1 => led1,
            out_led_2 => led2
        );

    -- The Clock
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;


    -- Stimulus
    stim : process
    begin
    	rst <= '1';
        -- init
        sw <= "00001";
        btn <= '0';
        wait for 20 ns;

        -- press evaluate
        btn <= '1';
        wait for 10 ns;

        -- release
        btn  <= '0';
        wait for 30 ns;

        -- second character
        sw <= "00010";
        wait for 30 ns;

        -- Another cycle
        btn <= '1';
        wait for 10 ns;

        btn <= '0';
        wait for 30 ns;

        -- End simulation
        wait;
    end process;
end architecture sim;