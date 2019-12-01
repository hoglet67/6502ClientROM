#!/bin/bash

NAME=clientrom

# Disassemble
../tools/beebdis ${NAME}.dis

# Remove a junk file left by beebdis
rm -f "c:\\tmp\\newcontrol.txt"

# Add the 65C02 CPU directive
echo "; Enable 65C02 opcodes" > tmp
echo "CPU           1" >> tmp
echo >> tmp
cat  ${NAME}.asm >> tmp
mv tmp  ${NAME}.asm

# Correct some bad opcodes
sed -i -e "s/ DEC*$/ DEC     A/" ${NAME}.asm
sed -i -e "s/ INC*$/ INC     A/" ${NAME}.asm


# Assemble
rm -f ${NAME}.bin
../tools/beebasm -i ${NAME}.asm

# Test
md5sum ${NAME}.orig
md5sum ${NAME}.bin
