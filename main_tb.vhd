library ieee;
use ieee.std_logic_1164.all;

entity tb_main is
end tb_main;

architecture tb of tb_main is

    component main
        port (CLK_p        : in std_logic;
              CLK_n        : in std_logic;
              RST        : in std_logic;
              GPIO_SW_W  : in std_logic;
              GPIO_LED_0, GPIO_LED_1, GPIO_LED_2, GPIO_LED_3 : out std_logic
              );
    end component;
   
    component filtr
    port (CLK : in std_logic;
      Switch : in std_logic;
      odfiltrowany_przycisk: out std_logic
    );
    end component;

    signal CLK_p        : std_logic;
    signal CLK_n        : std_logic;
    signal RST        : std_logic;
    signal GPIO_SW_W  : std_logic;
    signal GPIO_LED_0 : std_logic;
    signal GPIO_LED_1 : std_logic;
    signal GPIO_LED_2 : std_logic;
    signal GPIO_LED_3 : std_logic;
   

    constant TbPeriod : time := 5 ns;
--    signal TbClock : std_logic := '0';
--    signal TbSimEnded : std_logic := '0';

begin

    dut : main
    port map (CLK_p        => CLK_p,
              CLK_n        => CLK_n,
              RST        => RST,
              GPIO_SW_W  => GPIO_SW_W,
              GPIO_LED_0 => GPIO_LED_0,
              GPIO_LED_1 => GPIO_LED_1,
              GPIO_LED_2 => GPIO_LED_2,
              GPIO_LED_3 => GPIO_LED_3
                );
               

    -- Clock generation
--    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
--   TbClock <= not TbClock after TbPeriod/2;

    CLK_generation : process
        begin
            CLK_p <= '0';
            wait for TbPeriod/2;
            CLK_p <= '1';
            wait for TbPeriod/2;
    end process;
   
    CLK_n <= not CLK_p;

--     EDIT: Check that CLK is really your main clock signal
--    CLK <= TbClock;

    stimuli : process
    begin
        GPIO_SW_W <= '0';       --symulacja drgania stykow
        wait for 250 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 200 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
       
        GPIO_SW_W <= '0';
        wait for 100 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 50 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
       
        GPIO_SW_W <= '0';
        wait for 50 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 50 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
       
        GPIO_SW_W <= '0';
        wait for 50 ns;
        GPIO_SW_W <= '1';
        wait for 50 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
       
        GPIO_SW_W <= '1';
        wait for 50 ns;
        GPIO_SW_W <= '1';
        wait for 50 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '1';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 2 ns;
        GPIO_SW_W <= '0';
        wait for 60 ns;
        GPIO_SW_W <= '1';
        wait for 50 ns;
        GPIO_SW_W <= '0';
        wait for 70 ns;
        GPIO_SW_W <= '1';
        wait for 60 ns;
        GPIO_SW_W <= '0';
        wait for 50 ns;
        GPIO_SW_W <= '1';
        wait for 50 ns;
        GPIO_SW_W <= '0';
        wait for 50 ns;
        GPIO_SW_W <= '1';
        wait for 50 ns;
        GPIO_SW_W <= '0';
        wait for 200 ns;
        GPIO_SW_W <= '1';
        wait for 200 ns;
       
        -- EDIT Add stimuli here
--        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
--        TbSimEnded <= '1';
        wait;
    end process;
end tb;

configuration cfg_tb_main of tb_main is
    for tb
    end for;
end cfg_tb_main;