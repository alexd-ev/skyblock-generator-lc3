.PHONY: default all build run clean

default: all

all: build

# Assemble the LC3 source and place the generated object in the bin directory.
build:
	mkdir -p bin
	laser -a src/main.asm
	mv src/main.obj bin/

# Build first, then run the assembled program in the LC3 VM.
run: build
	lc3 bin/main.obj

clean:
	rm -rf bin/
