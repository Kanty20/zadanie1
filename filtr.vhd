library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity filtr is
Port (
      CLK : in std_logic;
      Switch : in std_logic;
      odfiltrowany_przycisk0: out std_logic;
      odfiltrowany_przycisk1 : out std_logic
      );
end filtr;

architecture Behavioral of filtr is
signal licznik0 : std_logic_vector (19 downto 0) := (others => '0');        --liczba 20 cykli zegara, bedzie bardziej dokladny, 2^20/200 000 000 = 0.005ms
signal licznik1 : std_logic_vector (19 downto 0) := (others => '0');       
signal opoznienie: integer := 0;    --w sumie pozniej sprawdzic czy da si eto do jednego opzonieniea wcisnac
signal counter : std_logic_vector (1 downto 0) := (others => '0');     -- 2 bitowy do sprawdzenia okresla czy '1' czy 0

begin

Debouncer_przycisku: process(CLK, Switch, licznik0)
   begin
      if rising_edge(CLK) then
         if Switch = '0' then 
            licznik0 <= (others => '1');    --zmieniac na 0
         elsif licznik0 /= 0 then           --zmieniac na 1
               licznik0 <= licznik0 - 1;
         end if;
         end if;
end process Debouncer_przycisku;

process(CLK, Switch, licznik1)
begin   
    if rising_edge(CLK) then
         if Switch = '1' then
            licznik1 <= (others => '1');
         elsif licznik1 /= 0 then
               licznik1 <= licznik1 - 1;
         end if;     
         end if;
end process;    

process(CLK, opoznienie)
begin    
    if rising_edge(CLK) then    
    if opoznienie = 15 then        --to jest te 50 ms zbadania czy faktycznie jest '1' lub '0', jednak jest mniej, 200000
    --jak sie ma naprawde mala wartosc opoznienia to wychodza bledy
        opoznienie <= 0;      
        --tutaj sprawdzam [0], counter na poczatku 0 i powownuje z najstarszym bitem
        if licznik0 <= licznik0(18 downto 0) & not Switch then -- Switch = '0'
            if licznik0 = "11111111111111111111" then    --jeœli wektor wype³ni siê '0' 00000000000000000000
                counter <= not counter(1) & not licznik0(19);       --poczatkowo bylo "00"      [0] [0]
            end if;
       --tutaj sprawdzam [1], counter na poczatku 1 i powownuje z najstarszym bitem
        elsif licznik1 <= licznik1(18 downto 0) & Switch then --uzupelnia '1' lub '0' przy gdy sie zapelni okresla czy jest '1'
            if licznik1 = "11111111111111111111" then        --jeœli wype³ni siê '1'
                counter <= not counter(1) & licznik1(19);       -- ![0] i [1]
            end if;
            end if;
     else
        opoznienie <= opoznienie + 1;
        end if;
        end if;
end process;

--process(CLK, licznik2)
--begin
--    if rising_edge(CLK) then
--    if Switch = '1' and opoznienie = 200 then
--        opoznienie <= 0;       
--        if licznik2 <= licznik2(18 downto 0) & Switch then --uzupelnia '1' lub '0' przy gdy sie zapelni okresla czy jest '1'
--            if licznik2 = "11111111111111111111" then        --jeœli wype³ni siê '1'
--                opoznienie <= 0;
--                counter <= "11";
--            end if;
--         end if;
--     else
--        opoznienie <= opoznienie + 1;
--        end if;
--        end if;
--end process;

process(CLK, counter)       --obsluga przycisku, przypisuje ¿e je¿eli spe³nia waunku countera to przycisk ma byc odfiltrowany
begin

    if counter = "00" then
        odfiltrowany_przycisk0 <= '1'; -- [0]
        odfiltrowany_przycisk1 <= '0';
    elsif counter = "11" then
        odfiltrowany_przycisk1 <= '1'; -- [1]
        odfiltrowany_przycisk0 <= '0';
    else      --resetowanie
        odfiltrowany_przycisk1 <= '0'; -- [1]
        odfiltrowany_przycisk0 <= '0';

        --pomys³ co zrobic z pozostalymi stanami
--    elsif counter = "10" then
--        odfiltrowany_przycisk1 <= '1'; -- [1]
--        odfiltrowany_przycisk0 <= '0';
--    elsif counter = "01" then
--        odfiltrowany_przycisk0 <= '1'; -- [0]
--        odfiltrowany_przycisk1 <= '0';
    end if;
end process; 
 
end Behavioral;