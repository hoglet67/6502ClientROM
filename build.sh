#!/bin/bash

rm -rf build
mkdir -p build

cd build

../tools/beebasm -v -i ../clientrom.asm -o tuberom_6502_turbo
xxd -i tuberom_6502_turbo > tuberom_6502_turbo.c
ls -l
cp tuberom_6502_turbo.c ../../PiTubeDirect/src
md5sum tuberom_6502_turbo

cd ..
