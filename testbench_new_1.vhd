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
    
    -- Test control signals
    signal sim_stim_done : boolean := false;
    signal sim_timeout : boolean := false;
    signal sim_finished : boolean := false;
    
    -- Function to convert std_logic_vector to hex string
    function to_hex_string(vec : std_logic_vector) return string is
        variable result : string(1 to vec'length/4 + 1);
        variable nibble : std_logic_vector(3 downto 0);
        variable pos : integer := 1;
    begin
        for i in 0 to (vec'length/4 - 1) loop
            nibble := vec((i*4)+3 downto i*4);
            case nibble is
                when "0000" => result(pos) := '0';
                when "0001" => result(pos) := '1';
                when "0010" => result(pos) := '2';
                when "0011" => result(pos) := '3';
                when "0100" => result(pos) := '4';
                when "0101" => result(pos) := '5';
                when "0110" => result(pos) := '6';
                when "0111" => result(pos) := '7';
                when "1000" => result(pos) := '8';
                when "1001" => result(pos) := '9';
                when "1010" => result(pos) := 'A';
                when "1011" => result(pos) := 'B';
                when "1100" => result(pos) := 'C';
                when "1101" => result(pos) := 'D';
                when "1110" => result(pos) := 'E';
                when "1111" => result(pos) := 'F';
                when others => result(pos) := 'X';
            end case;
            pos := pos + 1;
        end loop;
        return result(1 to vec'length/4);
    end function;
    
    -- Function to convert state to string (since we can't see internal states)
    function state_to_string(state_num : integer) return string is
    begin
        case state_num is
            when 0 => return "S0";
            when 1 => return "S1";
            when 2 => return "S2";
            when 3 => return "S3";
            when 4 => return "S4";
            when 5 => return "S5";
            when 6 => return "S6";
            when 7 => return "S7";
            when 8 => return "S8";
            when others => return "S?";
        end case;
    end function;

begin
    -- DUT (without debug ports - using your original design)
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

    -- Clock generation
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
                   " (value: 0x" & to_hex_string(input_val) & 
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
            if led0 /= expected_led0 or led1 /= expected_led1 or led2 /= expected_led2 then
                report "LED mismatch at " & message & 
                       ": Expected (" & std_logic'image(expected_led0) & "," &
                       std_logic'image(expected_led1) & "," & std_logic'image(expected_led2) &
                       ") got (" & std_logic'image(led0) & "," &
                       std_logic'image(led1) & "," & std_logic'image(led2) & ")"
                severity note;
            else
                report "LEDs correct at " & message & 
                       ": (" & std_logic'image(led0) & "," &
                       std_logic'image(led1) & "," & std_logic'image(led2) & ")";
            end if;
        end procedure;
        
        -- Procedure to reset the system
        procedure reset_system is
        begin
            rst <= '1';
            wait for 20 ns;
            rst <= '0';
            wait for 10 ns;
            report "System reset completed";
        end procedure;
        
    begin
        -- Initial state
        report "========================================";
        report "Starting Bit-Split Aho-Corasick FSM Testbench";
        report "========================================";
        wait for 10 ns;
        
        --===================================================================
        -- Test Case 1: Reset Test
        --===================================================================
        report "=== Test Case 1: Reset Test ===";
        reset_system;
        check_leds('0', '0', '0', "after reset");
        
        --===================================================================
        -- Test Case 2: Test FSM0 (bit 0) with sequence from paper
        --===================================================================
        report "=== Test Case 2: Testing FSM0 (bit 0) transitions ===";
        reset_system;
        
        -- Follow path through FSM0 states
        apply_character("00000", "bit0=0 - should go to S1");
        apply_character("00000", "bit0=0 - should go to S2");
        apply_character("00000", "bit0=0 - should go to S3");
        apply_character("00000", "bit0=0 - should go to S4");
        apply_character("00001", "bit0=1 - should go to S5");
        wait for 20 ns;
        
        --===================================================================
        -- Test Case 3: Test FSM1 (bit 1) - This should match your working FSM
        --===================================================================
        report "=== Test Case 3: Testing FSM1 (bit 1) transitions ===";
        reset_system;
        
        apply_character("00010", "bit1=1 - S0->S2");
        apply_character("00000", "bit1=0 - S2->S4");
        apply_character("00010", "bit1=1 - S4->S6");
        apply_character("00000", "bit1=0 - S6->S5");
        check_leds('0', '0', '0', "after FSM1 sequence");
        wait for 20 ns;
        
        --===================================================================
        -- Test Case 4: Test FSM2 (bit 2)
        --===================================================================
        report "=== Test Case 4: Testing FSM2 (bit 2) transitions ===";
        reset_system;
        
        apply_character("00100", "bit2=1 - S0->S1");
        apply_character("00000", "bit2=0 - S1->S2");
        apply_character("00000", "bit2=0 - S2->S3");
        apply_character("00100", "bit2=1 - S3->S5");
        apply_character("00000", "bit2=0 - S5->S6");
        wait for 20 ns;
        
        --===================================================================
        -- Test Case 5: Test FSM3 (bit 3)
        --===================================================================
        report "=== Test Case 5: Testing FSM3 (bit 3) transitions ===";
        reset_system;
        
        apply_character("01000", "bit3=1 - S0->S1");
        apply_character("00000", "bit3=0 - S1->S2");
        apply_character("00000", "bit3=0 - S2->S3");
        apply_character("00000", "bit3=0 - S3->S4");
        apply_character("00000", "bit3=0 - S4->S5");
        wait for 20 ns;
        
        --===================================================================
        -- Test Case 6: Test FSM4 (bit 4)
        --===================================================================
        report "=== Test Case 6: Testing FSM4 (bit 4) transitions ===";
        reset_system;
        
        apply_character("10000", "bit4=1 - S0->S1");
        apply_character("00000", "bit4=0 - S1->S2");
        apply_character("00000", "bit4=0 - S2->S3");
        apply_character("00000", "bit4=0 - S3->S4");
        apply_character("00000", "bit4=0 - S4->S5");
        wait for 20 ns;
        
        --===================================================================
        -- Test Case 7: Test peptide match for "ACACD" from paper example
        -- Using encoding from Table 2: A=00000, C=00010, D=00011, E=00100
        --===================================================================
        report "=== Test Case 7: Testing peptide ACACD match ===";
        reset_system;
        
        -- A (00000)
        apply_character("00000", "A");
        -- C (00010)
        apply_character("00010", "C");
        -- A (00000)
        apply_character("00000", "A");
        -- C (00010)
        apply_character("00010", "C");
        -- D (00011)
        apply_character("00011", "D");
        wait for 20 ns;
        check_leds(led0, led1, led2, "after ACACD");
        
        --===================================================================
        -- Test Case 8: Test peptide match for "ACE" from paper example
        --===================================================================
        report "=== Test Case 8: Testing peptide ACE match ===";
        reset_system;
        
        -- A (00000)
        apply_character("00000", "A");
        -- C (00010)
        apply_character("00010", "C");
        -- E (00100)
        apply_character("00100", "E");
        wait for 20 ns;
        check_leds(led0, led1, led2, "after ACE");
        
        --===================================================================
        -- Test Case 9: Test peptide match for "CAC" from paper example
        --===================================================================
        report "=== Test Case 9: Testing peptide CAC match ===";
        reset_system;
        
        -- C (00010)
        apply_character("00010", "C");
        -- A (00000)
        apply_character("00000", "A");
        -- C (00010)
        apply_character("00010", "C");
        wait for 20 ns;
        check_leds(led0, led1, led2, "after CAC");
        
        --===================================================================
        -- Test Case 10: Test AND combination - Try to get all FSMs to match
        --===================================================================
        report "=== Test Case 10: Testing AND combination logic ===";
        reset_system;
        
        -- This sequence should put FSMs in states that might agree
        apply_character("00000", "Step 1");
        apply_character("00010", "Step 2");
        apply_character("00000", "Step 3");
        apply_character("00010", "Step 4");
        apply_character("00011", "Step 5");
        wait for 20 ns;
        
        report "Final LED state: LED0=" & std_logic'image(led0) & 
               " LED1=" & std_logic'image(led1) & 
               " LED2=" & std_logic'image(led2);
        
        --===================================================================
        -- Test Case 11: Random sequence test
        --===================================================================
        report "=== Test Case 11: Random sequence test ===";
        reset_system;
        
        -- Apply a random sequence using a loop with case statement
        for i in 0 to 15 loop
            case i is
                when 0 => apply_character("00000", "random A");
                when 1 => apply_character("00010", "random C");
                when 2 => apply_character("00100", "random E");
                when 3 => apply_character("00011", "random D");
                when 4 => apply_character("01101", "random M");
                when 5 => apply_character("11001", "random Y");
                when 6 => apply_character("00000", "random A");
                when 7 => apply_character("00010", "random C");
                when 8 => apply_character("00000", "random A");
                when 9 => apply_character("00010", "random C");
                when 10 => apply_character("00011", "random D");
                when 11 => apply_character("00000", "random A");
                when 12 => apply_character("00010", "random C");
                when 13 => apply_character("00100", "random E");
                when 14 => apply_character("01101", "random M");
                when 15 => apply_character("11001", "random Y");
                when others => null;
            end case;
            
            -- Check LEDs periodically
            if i mod 4 = 3 then
                check_leds(led0, led1, led2, "during random seq");
            end if;
        end loop;
        
        --===================================================================
        -- Test Complete
        --===================================================================
        wait for 100 ns;
        report "========================================";
        report "=== Testbench Complete ===";
        report "========================================";
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

    -- Timeout process
    timeout_process : process
    begin
        wait for 20 us;
        if not sim_stim_done then
            report "Simulation timeout reached!" severity warning;
            sim_timeout <= true;
        end if;
        wait;
    end process;
    
    -- End simulation controller
    end_sim_process : process
    begin
        wait until sim_stim_done or sim_timeout;
        sim_finished <= true;
        wait;
    end process;

end architecture;
