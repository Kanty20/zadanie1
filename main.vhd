library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
 
entity main is
  Port (
    CLK_n       : in std_logic;    
    CLK_p       : in std_logic;    
    RST           : in std_logic;   --SW8.3  CPU_RESET
    GPIO_SW_W     : in std_logic;   --SW7 - led's button
    GPIO_LED_0, GPIO_LED_1, GPIO_LED_2, GPIO_LED_3     : out std_logic --leds
    );        
end main;

architecture Behavioral of main is

type STANY is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11);

signal state, nstate: STANY := S0;    --tu deklaruje wartoœæ jaka ma byc na samym pocz¹tku S0
signal counter : integer := 0;     --czas 0.5 s, dobra ustawilam od razu na 0, bo sam sie ogarnie
signal flaga : std_logic := '0';
signal output : std_logic := '0';
signal locked : std_logic := '0';       --do resetu, locked znajduje sie w componencie zegara
signal RST_N : std_logic;

constant TIMER50 : integer := 2000000;      -- = f zegara/f zadana, 200 000 000/50,
constant TIMER25 : integer := 4000000;      --jest 2mln bo rysuje sie pó³okresu a nie ca³y, wiêc trzeba zmniejszyæ 2razy
constant TIMER12 : integer := 8000000;
constant TIMER6 : integer := 16000000;            
constant TIMER3 : integer := 32000000;            
constant TIMER1 : integer := 64000000;            

 -- bd potrzeba dla 50Hz i po naciœniêciu ¿eby spada³o do 25, 12.5, 6.25, 3.12, 1.06Hz, a po naciœniêciu ¿eby znowu wraca³o do 50Hz
signal counter_TIMER : integer range 0 to 200000000;      --tu taki ogolny do 50Hz a pozniej bede schodzic w dol
signal counter_TIMER50 : integer range 0 to TIMER50;     --czy do zwyklego std_logic;
signal counter_TIMER25 : integer range 0 to TIMER25;
signal counter_TIMER12 : integer range 0 to TIMER12;         --rcnt
signal counter_TIMER6 : integer range 0 to TIMER6;
signal counter_TIMER3 : integer range 0 to TIMER3;
signal counter_TIMER1 : integer range 0 to TIMER1;

signal toggle_TIMER : std_logic := '0';     --ta czesc bedzie sie zmieniac
signal toggle_TIMER_50 : std_logic := '0';
signal toggle_TIMER_25 : std_logic := '0';
signal toggle_TIMER_12 : std_logic := '0';
signal toggle_TIMER_6 : std_logic := '0';
signal toggle_TIMER_3 : std_logic := '0';
signal toggle_TIMER_1 : std_logic := '0';

signal LED3 : std_logic := '0';     --do portow przypisuje sygnaly
signal LED2 : std_logic := '0';
signal LED1 : std_logic := '0';
signal LED0 : std_logic := '0';

signal SW_0 : std_logic := '0';     --sygnaly odpowiadaj¹ce za przejscie
signal SW_1 : std_logic := '0';
signal WSW0 : std_logic := '0';
signal WSW1 : std_logic := '0';

component clk_wiz_0 is        --zegar sys_clk

Port(
  clk_out1: out std_logic;
  reset: in std_logic;
  locked : out std_logic;
  clk_in1_p : in std_logic;
  clk_in1_n : in std_logic
 );
end component;

component filtr is  
Port (
      CLK : in std_logic;
      Switch : in std_logic;
      odfiltrowany_przycisk0: out std_logic;
      odfiltrowany_przycisk1 : out std_logic
      );
end component;

signal sys_clock : std_logic;       --clk_wizard opisywanie

begin
--WSW0 <= SW_0 = '1' and SW_1 = '0';
--WSW1 <= SW_0 = '0' and SW_1 = '1';

CLK0: clk_wiz_0
Port map(
  clk_out1 => sys_clock,
  reset => RST,
  locked => locked,     --wczesniej bylo open
  clk_in1_p => CLK_p,
  clk_in1_n => CLK_n
 );

filtrowanie: filtr    
Port map(
    CLK => sys_clock,
    Switch => GPIO_SW_W,
    odfiltrowany_przycisk0 => SW_0,
    odfiltrowany_przycisk1 => SW_1
);

--licznik : process (flaga, counter, sys_clock)  -- synchronizowanie zboczem sygnalu zegarowego
--begin
--    if rising_edge(sys_clock) then        --odcisniecie GPIO_SW_W
--        if flaga = '1' then         --jak cos nieuzywane        NIEPOTRZEBNE ALE NA RAZIE ZOSTAWIAM
--            counter <= counter + 1;     --licznik sie zlicza
--        elsif flaga = '0' then
--            counter <= 0;           --jest rowny 0
--        end if;
--end if;
--end process;

reset_down : process (RST_N, sys_clock) --gdy stan nieustalony (na samym poczatku programu)
begin
    if falling_edge(sys_clock) then
        if locked = '0' then
            RST_N <= '1';
        elsif locked = '1' then
            RST_N <= '0';
        end if;
     end if;
end process;

state_machine: process (RST, RST_N, sys_clock, state, GPIO_SW_W, SW_0, SW_1, WSW1, WSW0)     --mechanika nacisniecia przycisku,  RST_N,
begin
     
     if RST = '1' or RST_N = '1' then       --gdy zwykly lub wczesniejszy reset
        state <= S0;        
     elsif rising_edge(sys_clock) then
--     if GPIO_SW_W = '1' THEN     --odpowiada za przycisniecie przycisku
--            SW_0 <= '0';
--            SW_1 <= '1';        --odfiltrowane
--        else    --któryœ z tych przypadkow
--            SW_0 <= '1';        --odfiltrowane
--            SW_1 <= '0';
--        end if;
       
        if (SW_0 = '1' and SW_1 = '0') then     --odfiltrowane przyciski tworza zale¿noœæ i od nich zalezy jaki stan wejdzie
            WSW0 <= '1';      
            WSW1 <= '0';
        elsif (SW_0 = '0' and SW_1 = '1') then
            WSW1 <= '1';
            WSW0 <= '0';
        end if;
     
        if (WSW1 = '1' xor WSW0 = '1') then    --gdy któryœ z tych sygna³ów bêdzie '1'                                      
            state <= nstate;    --nastepny stan            
        end if;
        end if;
end process;

przejscia: process(sys_clock, WSW1, WSW0, state)    -- logika przejœc miedzy stanami, a kalby zrobic asynchroniczny
begin

     case state is       --implementacja dwuprocesowa
        when S0 =>  
        if WSW1 = '1' then
            nstate <= S1;
        elsif WSW1 /= '1' then
            nstate <= S0;
        end if;

        when S1 =>      
        if WSW0 = '1' then
            nstate <= S2;
        elsif WSW0 /= '1' then
            nstate <= S1;
            end if;
           
        when S2 =>                  --25hz
        if WSW1 = '1' then
            nstate <= S3;
        elsif WSW1 /= '1' then
            nstate <= S2;
            end if;

       when S3 =>      
       if WSW0 = '1' then
            nstate <= S4;
        elsif WSW0 /= '1' then
            nstate <= S3;
            end if;
           
       when S4 =>                   --12hz
       if WSW1 = '1' then
            nstate <= S5;
        elsif WSW1 /= '1' then
            nstate <= S4;
            end if;    

       when S5 =>    
       if WSW0 = '1' then
            nstate <= S6;
        elsif WSW0 /= '1' then
            nstate <= S5;
            end if;
           
       when S6 =>                   --6hz
       if WSW1 = '1' then
            nstate <= S7;
        elsif WSW1 /= '1' then
            nstate <= S6;
        end if;
           
       when S7 =>    
       if WSW0 = '1' then
            nstate <= S8;
       elsif WSW0 /= '1' then
            nstate <= S7;
       end if;
       
       when S8 =>                   --3hz
       if WSW1 = '1' then
            nstate <= S9;
        elsif WSW1 /= '1' then
            nstate <= S8;
       end if;
       
       when S9 =>    
       if WSW0 = '1' then
            nstate <= S10;
        elsif WSW0 /= '1' then
            nstate <= S9;
       end if;
           
       when S10 =>                      --1hz
       if WSW1 = '1' then
            nstate <= S11;
        elsif WSW1 /= '1' then
            nstate <= S10;
       end if;
       
       when S11 =>    
       if WSW0 = '1' then
            nstate <= S0;
        elsif WSW0 /= '1' then
            nstate <= S11;
       end if;
       
            when others =>
                nstate <= S0;
          end case;
end process;

f_50: process(sys_clock)            --osobne procesy dla ka¿dej czestotliwosci
begin
    if rising_edge(sys_clock) then
      if counter_TIMER50 = TIMER50 - 1 then  -- troche szybciej zaczyna liczenie
        toggle_TIMER_50 <= not toggle_TIMER_50; --tworze przelacznik
        counter_TIMER50    <= 0;        --liczy od nowa
      else
        counter_TIMER50 <= counter_TIMER50 + 1;     --leci dalej
      end if;
    end if;
end process;

f_25: process(sys_clock)
begin
    if rising_edge(sys_clock) then
      if counter_TIMER25 = TIMER25-1 then  
        toggle_TIMER_25 <= not toggle_TIMER_25;
        counter_TIMER25    <= 0;
      else
        counter_TIMER25 <= counter_TIMER25 + 1;
      end if;
    end if;
end process;

f_12: process(sys_clock)
begin
    if rising_edge(sys_clock) then
      if counter_TIMER12 = TIMER12 - 1 then  
        toggle_TIMER_12 <= not toggle_TIMER_12;
        counter_TIMER12    <= 0;
      else
        counter_TIMER12 <= counter_TIMER12 + 1;
      end if;
    end if;
end process;

f_6: process(sys_clock)
begin
    if rising_edge(sys_clock) then
      if counter_TIMER6 = TIMER6 - 1 then  
        toggle_TIMER_6 <= not toggle_TIMER_6;
        counter_TIMER6    <= 0;
      else
        counter_TIMER6 <= counter_TIMER6 + 1;
      end if;
    end if;
end process;

f_3: process(sys_clock)
begin
    if rising_edge(sys_clock) then
      if counter_TIMER3 = TIMER3 - 1 then  
        toggle_TIMER_3 <= not toggle_TIMER_3;
        counter_TIMER3    <= 0;
      else
        counter_TIMER3 <= counter_TIMER3 + 1;
      end if;
    end if;
end process;

f_1: process(sys_clock)
begin
    if rising_edge(sys_clock) then
      if counter_TIMER1 = TIMER1 - 1 then  
        toggle_TIMER_1 <= not toggle_TIMER_1;
        counter_TIMER1    <= 0;
      else
        counter_TIMER1 <= counter_TIMER1 + 1;
      end if;
    end if;
end process;

leds: process(sys_clock, state, toggle_TIMER_50, toggle_TIMER_25, toggle_TIMER_12,toggle_TIMER_6, toggle_TIMER_3, toggle_TIMER_1, LED3, LED2, LED1, LED0)   -- wyjœcia w zale¿noœci od stanu

begin
    GPIO_LED_3 <= LED3;     --przypisuje do portów wyjœciowych sygna³ LED[]
    GPIO_LED_2 <= LED2;
    GPIO_LED_1 <= LED1;
    GPIO_LED_0 <= LED0;
   
LED3 <= '0';        --zadaje im wartoœæ pocz¹tkow¹ (oprocz tego na gorze w sygnalach jest zapisane ¿e poczatkowa wartosc ledow to '0'
LED2 <= '0';
LED1 <= '0';
LED0 <= '0';    
     
if rising_edge(sys_clock) then
    case state is       --dzialanie diodami     --50Hz
        when S0 =>      
            LED0 <= toggle_TIMER_50;      --swieci sie z zadana czestotliwoscia
           
        when S1 =>  --50Hz
            LED0 <= toggle_TIMER_50;      --swieci sie z zadana czestotliwoscia  
               
        when S2 =>      --25Hz
            LED0 <= toggle_TIMER_25;      --swieci sie z zadana czestotliwoscia    
            LED1 <= '1';                -- "licznik binarny" robiony recznie              

        when S3 =>      --25Hz
            LED0 <= toggle_TIMER_25;      --swieci sie z zadana czestotliwoscia    
            LED1 <= '1';                -- "licznik binarny" robiony recznie          
       
        when S4 =>      --12Hz
            LED0 <= toggle_TIMER_12;
            LED2 <= '1';

        when S5 =>      --12Hz
            LED0 <= toggle_TIMER_12;
            LED2 <= '1';
           
        when S6 =>      --6Hz
            LED0 <= toggle_TIMER_6;
            LED2 <= '1';  
            LED1 <= '1';
       
        when S7 =>      --6Hz
            LED0 <= toggle_TIMER_6;
            LED2 <= '1';  
            LED1 <= '1';  
       
        when S8 =>      --3Hz
            LED0 <= toggle_TIMER_3;
            LED3 <= '1'; 
       
        when S9 =>      --3Hz
            LED0 <= toggle_TIMER_3;
            LED3 <= '1';
       
        when S10 =>     --1Hz
            LED0 <= toggle_TIMER_1;
            LED3 <= '1';
            LED1 <= '1';
       
        when S11 =>         --1Hz
            LED0 <= toggle_TIMER_1;
            LED3 <= '1';
            LED1 <= '1';

        when others =>
                LED0 <= '0';
                LED1 <= '0';
                LED2 <= '0';
                LED3 <= '0';        
        end case;
    end if;
end process;

end Behavioral;