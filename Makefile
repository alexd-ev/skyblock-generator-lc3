.PHONY: default all build run

default: all

all: build

build:
	mkdir -p bin
	laser -a src/*.asm
	mv src/*.obj bin/

run: build
	lc3 bin/*.obj

clean:
	rm -rf bin/
