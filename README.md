# First project

VHDL project to learn about Evaluation Kit AC701 Artix7. Blinking diode with a frequency of 50 Hz. Operation of the button - after pressing the frequency decreases 2 times (6 possibilities 50,25,12.5,6.25,3.12,1.06 Hz after reaching the lowest and pressing the button again the highest frequency is set).  Implementation of binary counter presented on 4 LEDs (or more if there will be resources) counter counts the number of presses of the button to change the frequency (modulo 15). Operation of reset button which sets the initial settings. In addition, a differential clock is included in program. 

## Contents:
- [Information about board](#information)
- [Instalation](#instalation)
- [Additional information](#additional_information)
- [Contact](#contact)

## Information about board

The project was working on an evaluation board AC701, a photo of which is shown below. On the Xilinx website, the documentation shows an .xdc document that can be attached to the constrains (although not required).<br>
|Xilinx website| https://www.xilinx.com/products/boards-and-kits/ek-a7-ac701-g.html#documentation

![image](https://github.com/user-attachments/assets/72d104d8-f342-412c-b95b-daf0aa761073)

## Instalation

You will need to install Vivado program, next to upload all file which I share. Additionally you will need to choose in "Open Design" -> "Window" -> " I/O Ports" specific for board ports. I choose:
- sys_clock - P3,
- RST       - SW8,
- button    - SW7,
- LED's     - DS11-DS13,

## Additional information

How to add differencial clock?<br>
1. You need to click "IP Catalog" (on right side)
2. Write "Clock Wizard"
3. Choose diff clock (just only one)
4. Important (!) choose suitable frequency for your project (in my case it was 200MHz)
5. Click ok or generate
6. Now you need to add your clock by using component and Portmap (you should look on main program where it is)  

## Contact
If you will need help or you have some questions feel free to write to me: dominika.kanty@onet.eu
