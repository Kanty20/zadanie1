# First project

VHDL project to learn about Evaluation Kit AC701 Artix7. The projects shows the control of buttons and blinking leds in different frequencies. In addition, a differential clock is included in program. 

## Contents:
- [Information about board](#information)
- [Instalation](#instalation)
- [Additional Information](#additional_information)
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


## Contact
If you will need help or you have some questions feel free to write to me: dominika.kanty@onet.eu
