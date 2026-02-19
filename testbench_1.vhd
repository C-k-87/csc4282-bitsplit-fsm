library ieee;
use ieee.std_logic_1164.all;

entity tb_fsm is
-- empty
end entity;

architecture sim of tb_fsm is

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal btn : std_logic := '0';
    signal sw  : std_logic_vector(4 downto 0) := "00000";
    signal led0 : std_logic;
    signal led1 : std_logic;
    signal led2 : std_logic;

begin

    -- DUT
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

    -- Clock (10 ns period)
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
        -- Apply reset
        rst <= '1';
        sw  <= "00001";
        btn <= '0';
        wait for 20 ns;

        rst <= '0';         --  Release reset
        wait for 20 ns;

        -- First evaluate
        btn <= '1';
        wait for 20 ns;     --  full clock
        btn <= '0';
        wait for 40 ns;

        -- Second input
        sw <= "00010";
        wait for 20 ns;     -- allow stable input

        btn <= '1';
        wait for 20 ns;     --  full clock
        btn <= '0';
        wait for 40 ns;

        wait;
    end process;

end architecture;
