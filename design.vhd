library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
    port (
        clk : in std_logic;
        reset : in std_logic;
        evaluate_btn : in std_logic;
        encoded_input_character : in std_logic_vector(4 downto 0);
        out_led_0 : out std_logic;
        out_led_1 : out std_logic;
        out_led_2 : out std_logic
    );
end entity;

architecture rtl of fsm is
    type state_t is (S0,S1,S2,S3,S4,S5,S6,S7,S8);

    -- FSM0
    signal state_reg_0    :state_t;   -- Current State
    signal state_next_0   :state_t;   -- Next State
    signal state_out_0    :std_logic_vector(2 downto 0);   -- End State
    -- FSM1
    signal state_reg_1    :state_t;   -- Current State
    signal state_next_1   :state_t;   -- Next State
    signal state_out_1    :std_logic_vector(2 downto 0);
    -- FSM2
    signal state_reg_2    :state_t;   -- Current State
    signal state_next_2   :state_t;   -- Next State
    signal state_out_2    :std_logic_vector(2 downto 0);
    -- FSM3
    signal state_reg_3    :state_t;   -- Current State
    signal state_next_3   :state_t;   -- Next State
    signal state_out_3    :std_logic_vector(2 downto 0);
    -- FSM4
    signal state_reg_4    :state_t;   -- Current State
    signal state_next_4   :state_t;   -- Next State
    signal state_out_4    :std_logic_vector(2 downto 0);

    signal combined_state :std_logic_vector(2 downto 0);

begin
-------------------( FSM0 )-------------------------
    --  STATE REGISTER
    process(clk, reset)
    begin
        if reset = '1' then
            state_reg_0 <= S0;
        elsif rising_edge(clk) then
            state_reg_0 <= state_next_0;
        end if;
    end process;

    -- STATE TRANSITIONS
    process(state_reg_0, evaluate_btn)
    begin
        if evaluate_btn = '1' then
            case state_reg_0 is
                when S0 =>
                    if encoded_input_character(0) = '0' then
                        state_next_0 <= S1;
                    end if;
                
                when S1 =>
                    if encoded_input_character(0) = '0' then
                        state_next_0 <= S2;
                    else
                        state_next_0 <= S0;
                    end if;

                when S2 =>
                    if encoded_input_character(0) = '0' then
                        state_next_0 <= S3;
                    else
                        state_next_0 <= S0;
                    end if;
                
                when S3 =>
                    if encoded_input_character(0) = '0' then
                        state_next_0 <= S4;
                    else
                        state_next_0 <= S0;
                    end if;

                when S4 =>
                    if encoded_input_character(0) = '0' then
                        state_next_0 <= S4;
                    else
                        state_next_0 <= S5;
                    end if;
                
                when S5 =>
                    if encoded_input_character(0) = '0' then
                        state_next_0 <= S1;
                    else
                        state_next_0 <= S0;
                    end if;
                when others =>
                    state_next_0 <= S0;
            end case;
        end if;
    end process;

    -- OUTPUT ENCODING
    with state_reg_0 select
        state_out_0 <=  "000" when S0,
                        "000" when S1,
                        "000" when S2,
                        "110" when S3,
                        "110" when S4,
                        "001" when S5,
                        "000" when others;
                        
----------------------------------------------------
-------------------( FSM1 )-------------------------
    --  STATE REGISTER
    process(clk,  reset)
    begin
        if reset = '1' then
            state_reg_1 <= S0;
        elsif rising_edge(clk) then
            state_reg_1 <= state_next_1;
        end if;
    end process;

    -- STATE TRANSITIONS
    process(state_reg_1, evaluate_btn)
    begin
    if evaluate_btn = '1' then
        case state_reg_1 is
            when S0 =>
                if encoded_input_character(1) = '0' then
                    state_next_1 <= S1;
                else
                    state_next_1 <= S2;
                end if;
            
            when S1 =>
                if encoded_input_character(1) = '0' then
                    state_next_1 <= S1;
                else
                    state_next_1 <= S3;
                end if;

            when S2 =>
                if encoded_input_character(1) = '0' then
                    state_next_1 <= S4;
                else
                    state_next_1 <= S2;
                end if;
            
            when S3 =>
                if encoded_input_character(1) = '0' then
                    state_next_1 <= S5;
                else
                    state_next_1 <= S2;
                end if;

            when S4 =>
                if encoded_input_character(1) = '0' then
                    state_next_1 <= S1;
                else
                    state_next_1 <= S6;
                end if;
            
            when S5 =>
                if encoded_input_character(1) = '0' then
                    state_next_1 <= S1;
                else
                    state_next_1 <= S7;
                end if;
            
            when S6 =>
                if encoded_input_character(1) = '0' then
                    state_next_1 <= S5;
                else
                    state_next_1 <= S2;
                end if;
            
            when S7 =>
                if encoded_input_character(1) = '0' then
                    state_next_1 <= S5;
                else
                    state_next_1 <= S8;
                end if;
            
            when S8 =>
                if encoded_input_character(1) = '0' then
                    state_next_1 <= S4;
                else
                    state_next_1 <= S2;
                end if;
            end case;
        end if;
    end process;

    -- OUTPUT ENCODING
    with state_reg_1 select
        state_out_1 <=  "000" when S0,
                        "000" when S1,
                        "000" when S2,
                        "000" when S3,
                        "000" when S4,
                        "010" when S5,
                        "100" when S6,
                        "100" when S7,
                        "001" when S8;
                        
----------------------------------------------------
-------------------( FSM2 )-------------------------
    --  STATE REGISTER
    process(clk, reset)
    begin
        if reset = '1' then
            state_reg_2 <= S0;
        elsif rising_edge(clk) then
            state_reg_2 <= state_next_2;
        end if;
    end process;

    -- STATE TRANSITIONS
    process(state_reg_2, evaluate_btn)
    begin
        if evaluate_btn = '1' then
            case state_reg_2 is
                when S0 =>
                    if encoded_input_character(2) = '0' then
                        state_next_2 <= S1;
                    end if;
                
                when S1 =>
                    if encoded_input_character(2) = '0' then
                        state_next_2 <= S2;
                    else
                        state_next_2 <= S0;
                    end if;

                when S2 =>
                    if encoded_input_character(2) = '0' then
                        state_next_2 <= S3;
                    else
                        state_next_2 <= S4;
                    end if;
                
                when S3 =>
                    if encoded_input_character(2) = '0' then
                        state_next_2 <= S5;
                    else
                        state_next_2 <= S4;
                    end if;

                when S4 =>
                    if encoded_input_character(2) = '0' then
                        state_next_2 <= S1;
                    else
                        state_next_2 <= S0;
                    end if;
                
                when S5 =>
                    if encoded_input_character(2) = '0' then
                        state_next_2 <= S6;
                    else
                        state_next_2 <= S4;
                    end if;
                
                when S6 =>
                    if encoded_input_character(2) = '0' then
                        state_next_2 <= S6;
                    else
                        state_next_2 <= S4;
                    end if;
                when others =>
                    state_next_2 <= S0;
            end case;
        end if;
    end process;

    -- OUTPUT ENCODING
    with state_reg_2 select
        state_out_2 <=  "000" when S0,
                        "000" when S1,
                        "000" when S2,
                        "100" when S3,
                        "010" when S4,
                        "100" when S5,
                        "101" when S6,
                        "000" when others;
                        
----------------------------------------------------
-------------------( FSM3 )-------------------------
    --  STATE REGISTER
    process(clk, reset)
    begin
        if reset = '1' then
            state_reg_3 <= S0;
        elsif rising_edge(clk) then
            state_reg_3 <= state_next_3;
        end if;
    end process;

    -- STATE TRANSITIONS
    process(state_reg_3, evaluate_btn)
    begin
        if evaluate_btn = '1' then
            case state_reg_3 is
                when S0 =>
                    if encoded_input_character(3) = '0' then
                        state_next_3 <= S1;
                    end if;
                
                when S1 =>
                    if encoded_input_character(3) = '0' then
                        state_next_3 <= S2;
                    else
                        state_next_3 <= S0;
                    end if;

                when S2 =>
                    if encoded_input_character(3) = '0' then
                        state_next_3 <= S3;
                    else
                        state_next_3 <= S0;
                    end if;
                
                when S3 =>
                    if encoded_input_character(3) = '0' then
                        state_next_3 <= S4;
                    else
                        state_next_3 <= S0;
                    end if;

                when S4 =>
                    if encoded_input_character(3) = '0' then
                        state_next_3 <= S5;
                    else
                        state_next_3 <= S0;
                    end if;
                
                when S5 =>
                    if encoded_input_character(3) = '0' then
                        state_next_3 <= S5;
                    else
                        state_next_3 <= S0;
                    end if;
                when others =>
                    state_next_3 <= S0;
            end case;
        end if;
    end process;

    -- OUTPUT ENCODING
    with state_reg_3 select
        state_out_3 <=  "000" when S0,
                        "000" when S1,
                        "000" when S2,
                        "110" when S3,
                        "110" when S4,
                        "111" when S5,
                        "000" when others;
                        
----------------------------------------------------
-------------------( FSM4 )-------------------------
    --  STATE REGISTER
    process(clk, reset)
    begin
        if reset = '1' then
            state_reg_4 <= S0;
        elsif rising_edge(clk) then
            state_reg_4 <= state_next_4;
        end if;
    end process;

    -- STATE TRANSITIONS
    process(state_reg_1, evaluate_btn)
    begin
        if evaluate_btn = '1' then
            case state_reg_4 is
                when S0 =>
                    if encoded_input_character(4) = '0' then
                        state_next_4 <= S1;
                    end if;
                
                when S1 =>
                    if encoded_input_character(4) = '0' then
                        state_next_4 <= S2;
                    else
                        state_next_4 <= S0;
                    end if;

                when S2 =>
                    if encoded_input_character(4) = '0' then
                        state_next_4 <= S3;
                    else
                        state_next_4 <= S0;
                    end if;
                
                when S3 =>
                    if encoded_input_character(4) = '0' then
                        state_next_4 <= S4;
                    else
                        state_next_4 <= S0;
                    end if;

                when S4 =>
                    if encoded_input_character(4) = '0' then
                        state_next_4 <= S5;
                    else
                        state_next_4 <= S0;
                    end if;
                
                when S5 =>
                    if encoded_input_character(4) = '0' then
                        state_next_4 <= S5;
                    else
                        state_next_4 <= S0;
                    end if;
                when others =>
                    state_next_4 <= S0;
            end case;
        end if;
    end process;

    -- OUTPUT ENCODING
    with state_reg_4 select
        state_out_4 <=  "000" when S0,
                        "000" when S1,
                        "000" when S2,
                        "110" when S3,
                        "110" when S4,
                        "111" when S5,
                        "000" when others;
                        
----------------------------------------------------
---------- OUTPUT LED COMBINATIONAL LOGIC ----------

    combined_state <= state_out_0 and state_out_1 and state_out_2 and state_out_3 and state_out_4;
    
    with combined_state select
            out_led_0 <=    '1' when "001",
                            '1' when "011",
                            '1' when "111",
                            '0' when others;

    with combined_state select    
        out_led_1 <=    '1' when "010",
                        '1' when "011",
                        '1' when "111",
                        '0' when others;

    with combined_state select
        out_led_2 <=    '1' when "100",
                        '1' when "011",
                        '1' when "111",
                        '0' when others;

----------------------------------------------------
end architecture;