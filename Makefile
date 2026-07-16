.PHONY: default all build run clean

default: all

all: build

build:
	mkdir -p bin
	laser -a src/main.asm
	mv src/*.obj bin/

run: build
	lc3 bin/main.obj

clean:
	rm -rf bin/
