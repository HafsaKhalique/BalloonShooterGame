# 🎮 16-bit Retro Assembly Game

An interactive, vintage arcade-style game written completely in 16-bit x86 Assembly language. The project features text-mode graphical renderings (including moons, stars, and sparkles), sound effects driven by the PC speaker, and customized Interrupt Service Routines (ISRs) for responsive gameplay.

(This project was built as an equal partnership group effort!)

## ✨ Features
- Custom Text Graphics: Dynamic pixel art routines for rendering game entities (printstar, printmoon, printsparkle).
- PC Speaker Sound Effects: Fully-programmed audio frequencies mimicking retro sound chips for starting, popping balloons, pausing, errors, and game over states.
- Low-Level Hardware Control: Direct manipulation of the programmable interval timer (PIT) and video memory buffers (0xb800).

## 🛠️ System Requirements
To run this assembly game, you will need:
1. NASM (Netwide Assembler) to compile the source code.
2. DOSBox (or an equivalent x86 emulator) to run the compiled .com executable file.

## 🚀 How to Run the Game

1. Compile the code using NASM in your terminal:
   ```bash
   nasm work.asm -o game.com
   ```
2. Launch DOSBox and mount your project folder.
3. Execute the game inside DOSBox:
   ```dos
   game.com
   ```

## 👥 Equal Contributors
- Hafsa Khalique - Co-Creator & Core Developer
- Aiyshah Meerab - Co-Creator & Core Developer
