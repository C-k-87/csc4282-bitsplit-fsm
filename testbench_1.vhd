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
          wait for 20 ns;
          rst <= '0';

          -- First character
          sw <= "00001";
          btn <= '1';
          wait for 10 ns;
          btn <= '0';
          wait for 30 ns;

          -- Second character
          sw <= "00010";
          btn <= '1';
          wait for 10 ns;
          btn <= '0';
          wait for 30 ns;

          -- End simulation
          wait for 50 ns;
          assert false report "Simulation Finished" severity note;
          wait;

      end process;


end architecture;
