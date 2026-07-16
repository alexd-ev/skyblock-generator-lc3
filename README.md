# Minecraft Skyblock Generator with LC3
## Overview
See my C++ version which showcases removing, recreating and adding the chest and tree as well found here: https://github.com/alexd-ev/skyblock-generator. My Minecraft LC3 skyblock island generator project uses the [LC3](https://github.com/rozukke/lc3-vm-mcpp) VM for the [mcpp](https://github.com/rozukke/mcpp) interfacing library with Minecraft Java Edition. This project showcases creating the land of the classic skyblock island in a Minecraft world.

[Create Island Video](https://github.com/user-attachments/assets/3280fda1-d480-4f72-8735-d6f0b526b492)

## Technical Specification
To build and run the code, the [mcpp](https://github.com/rozukke/mcpp) library must be installed, alongside a Spigot server and the ELCI plugin. [LC3](https://github.com/rozukke/lc3-vm-mcpp) for executing compiled object files and [Laser](https://github.com/rozukke/laser-mcpp) for assembling object files from the LC3 Assembly code are also required. Also, [make](https://ftp.gnu.org/gnu/make/) is helpful for streamlining running.

If using most IDE Makefile plugins, set the build target to `run`, then can build and run from IDE. Otherwise, can build and run from terminal (see [Building and Running the code](#building-and-running-the-code))

## Project Structure
```
skyblock-generator-lc3/
├── bin/                                    - Generated binary object file directory
├── src/
│   └── main.asm                            - LC3 Assembly source file application entrypoint
├── .gitignore                              - Ignore generated binary object file directory
├── LICENSE                                 - GPL-3.0 licence
├── Makefile                                - Configure build
└── README.md                               - Documentation
```

# Building and Running the Code
Build and run the application:
```bash
make run
```

# Author
`alexd-ev` (Alex Davidson)

Copyright Alex Davidson (c) 2026
