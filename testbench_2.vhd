library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fsm is
  -- empty
end entity;

architecture sim of tb_fsm is
    -- Clock period constants
    constant CLK_PERIOD : time := 10 ns;
    constant HALF_PERIOD : time := 5 ns;
    
    -- Test signals
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal btn : std_logic := '0';
    signal sw  : std_logic_vector(4 downto 0) := (others => '0');
    signal led0 : std_logic;
    signal led1 : std_logic;
    signal led2 : std_logic;
    
    -- Test control - use separate signals
    signal sim_stim_done : boolean := false;
    signal sim_timeout : boolean := false;
    
    -- Flag to stop clock
    signal sim_finished : boolean := false;

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

    -- Clock generation - stops when sim_finished is true
    clk_process : process
    begin
        while not sim_finished loop
            clk <= '0';
            wait for HALF_PERIOD;
            clk <= '1';
            wait for HALF_PERIOD;
        end loop;
        wait;
    end process;

    -- Main stimulus process
    stim : process
        
        -- Procedure to apply a character input
        procedure apply_character(
            constant input_val : in std_logic_vector(4 downto 0);
            constant description : in string
        ) is
        begin
            if sim_timeout then
                return;
            end if;
            sw <= input_val;
            btn <= '1';
            wait for CLK_PERIOD;
            btn <= '0';
            wait for 3 * CLK_PERIOD;
            report "Applied input " & description & 
                   " (value: " & integer'image(to_integer(unsigned(input_val))) & 
                   ") at time " & time'image(now);
        end procedure;
        
        -- Procedure to check LED outputs
        procedure check_leds(
            expected_led0 : in std_logic;
            expected_led1 : in std_logic;
            expected_led2 : in std_logic;
            message : in string
        ) is
        begin
            if sim_timeout then
                return;
            end if;
            wait for 1 ns;
            assert led0 = expected_led0
                report "LED0 mismatch at " & message & 
                       ": Expected " & std_logic'image(expected_led0) & 
                       ", got " & std_logic'image(led0)
                severity error;
            assert led1 = expected_led1
                report "LED1 mismatch at " & message & 
                       ": Expected " & std_logic'image(expected_led1) & 
                       ", got " & std_logic'image(led1)
                severity error;
            assert led2 = expected_led2
                report "LED2 mismatch at " & message & 
                       ": Expected " & std_logic'image(expected_led2) & 
                       ", got " & std_logic'image(led2)
                severity error;
        end procedure;
        
    begin
        -- Initial state
        report "Starting FSM Testbench";
        wait for 10 ns;
        
        -- Test Case 1: Reset
        report "=== Test Case 1: Reset Test ===";
        rst <= '1';
        wait for 20 ns;
        check_leds('0', '0', '0', "after reset");
        rst <= '0';
        wait for 10 ns;
        
        -- Exit if timeout occurred
        if sim_timeout then
            sim_stim_done <= true;
            wait;
        end if;
        
        -- Test Case 2: Test FSM0 paths
        report "=== Test Case 2: Testing FSM0 (bit 0) ===";
        apply_character("00001", "bit0=1, others=0");
        apply_character("00001", "bit0=1, others=0");
        apply_character("00001", "bit0=1, others=0");
        apply_character("00001", "bit0=1, others=0");
        apply_character("00001", "bit0=1, others=0");
        apply_character("00001", "bit0=1, others=0");
        wait for 20 ns;
        
        -- Reset for next test
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 10 ns;
        
        -- Test Case 3: Test FSM1 paths
        report "=== Test Case 3: Testing FSM1 (bit 1) ===";
        apply_character("00010", "bit1=1, others=0");
        apply_character("00010", "bit1=1, others=0");
        apply_character("00000", "bit1=0, others=0");
        apply_character("00010", "bit1=1, others=0");
        apply_character("00000", "bit1=0, others=0");
        apply_character("00010", "bit1=1, others=0");
        apply_character("00000", "bit1=0, others=0");
        apply_character("00010", "bit1=1, others=0");
        wait for 20 ns;
        
        -- Reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 10 ns;
        
        -- Test Case 4: Test FSM2 paths
        report "=== Test Case 4: Testing FSM2 (bit 2) ===";
        apply_character("00100", "bit2=1, others=0");
        apply_character("00000", "bit2=0, others=0");
        apply_character("00000", "bit2=0, others=0");
        apply_character("00100", "bit2=1, others=0");
        apply_character("00000", "bit2=0, others=0");
        apply_character("00000", "bit2=0, others=0");
        wait for 20 ns;
        
        -- Reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 10 ns;
        
        -- Test Case 5: Test FSM3/FSM4 paths
        report "=== Test Case 5: Testing FSM3 (bit 3) and FSM4 (bit 4) ===";
        apply_character("01000", "bit3=1, others=0");
        apply_character("00000", "bit3=0, others=0");
        apply_character("00000", "bit3=0, others=0");
        apply_character("00000", "bit3=0, others=0");
        apply_character("00000", "bit3=0, others=0");
        wait for 20 ns;
        
        -- Reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 10 ns;
        
        -- Test Case 6: Combined test
        report "=== Test Case 6: Combined FSMs Test ===";
        
        apply_character("00001", "Testing bit0");
        apply_character("00001", "Testing bit0");
        apply_character("00001", "Testing bit0");
        apply_character("00001", "Testing bit0");
        apply_character("00001", "Testing bit0");
        
        apply_character("00010", "Testing bit1");
        apply_character("00010", "Testing bit1");
        apply_character("00010", "Testing bit1");
        
        apply_character("00100", "Testing bit2");
        apply_character("00100", "Testing bit2");
        apply_character("00100", "Testing bit2");
        
        apply_character("01000", "Testing bit3");
        apply_character("01000", "Testing bit3");
        
        apply_character("10000", "Testing bit4");
        apply_character("10000", "Testing bit4");
        
        check_leds('0', '0', '0', "end of combined test");
        
        -- Test Case 7: Systematic testing
        report "=== Test Case 7: Systematic testing of all input combinations ===";
        
        for i in 0 to 31 loop
            exit when sim_timeout;
            
            rst <= '1';
            wait for 20 ns;
            rst <= '0';
            wait for 10 ns;
            
            report "Testing input combination: " & integer'image(i);
            
            for j in 1 to 10 loop
                exit when sim_timeout;
                sw <= std_logic_vector(to_unsigned(i, 5));
                btn <= '1';
                wait for CLK_PERIOD;
                btn <= '0';
                wait for 3 * CLK_PERIOD;
            end loop;
            
            if led0 = '1' or led1 = '1' or led2 = '1' then
                report "Found LED activation with input " & integer'image(i) &
                       ": LED0=" & std_logic'image(led0) &
                       " LED1=" & std_logic'image(led1) &
                       " LED2=" & std_logic'image(led2);
            end if;
            
            wait for 20 ns;
        end loop;
        
        -- Test Case 8: Random sequence test
        report "=== Test Case 8: Random sequence test ===";
        
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 10 ns;
        
        for idx in 0 to 19 loop
            exit when sim_timeout;
            
            case idx is
                when 0 => apply_character("00001", "random 1");
                when 1 => apply_character("00010", "random 2");
                when 2 => apply_character("00100", "random 4");
                when 3 => apply_character("01000", "random 8");
                when 4 => apply_character("10000", "random 16");
                when 5 => apply_character("00011", "random 3");
                when 6 => apply_character("00101", "random 5");
                when 7 => apply_character("00110", "random 6");
                when 8 => apply_character("01001", "random 9");
                when 9 => apply_character("01010", "random 10");
                when 10 => apply_character("01100", "random 12");
                when 11 => apply_character("10001", "random 17");
                when 12 => apply_character("10010", "random 18");
                when 13 => apply_character("10100", "random 20");
                when 14 => apply_character("11000", "random 24");
                when 15 => apply_character("00111", "random 7");
                when 16 => apply_character("01011", "random 11");
                when 17 => apply_character("01101", "random 13");
                when 18 => apply_character("01110", "random 14");
                when 19 => apply_character("10011", "random 19");
                when others => null;
            end case;
            
            if idx mod 5 = 0 then
                check_leds(led0, led1, led2, "during random sequence");
            end if;
        end loop;
        
        wait for 50 ns;
        check_leds(led0, led1, led2, "end of simulation");
        
        -- Signal that stimulus is done
        report "=== Testbench Complete ===";
        report "Simulation finished at time " & time'image(now);
        sim_stim_done <= true;
        wait;

    end process;

    -- Monitor LED changes
    led_monitor : process(led0, led1, led2)
    begin
        if led0'event then
            report "LED0 changed to " & std_logic'image(led0) & " at time " & time'image(now);
        end if;
        if led1'event then
            report "LED1 changed to " & std_logic'image(led1) & " at time " & time'image(now);
        end if;
        if led2'event then
            report "LED2 changed to " & std_logic'image(led2) & " at time " & time'image(now);
        end if;
    end process;

    -- Timeout process - only sets timeout flag
    timeout_process : process
    begin
        wait for 10 us;
        if not sim_stim_done then
            report "Simulation timeout reached!" severity warning;
            sim_timeout <= true;
        end if;
        wait;
    end process;
    
    -- End simulation controller - this is the ONLY process that sets sim_finished
    end_sim_process : process
    begin
        -- Wait for either stimulus done or timeout
        wait until sim_stim_done or sim_timeout;
        sim_finished <= true;
        wait;
    end process;

end architecture;
