#!/bin/bash
# (c) img2tab - https://github.com/img2tab/virtualbox-scancodes/
# Licensed under GPL 2.0 or higher
# version 0.1

# QWERTY-to-scancode dictionary. Hex scancodes, keydown and keyup event.
# Virtualbox Mac scancodes found here:
# https://wiki.osdev.org/PS/2_Keyboard#Scan_Code_Set_1
# First half of hex code - press, second half - release, unless otherwise specified
declare -A ksc=(
    ["ESC"]="01 81"
    ["1"]="02 82" 
    ["2"]="03 83" 
    ["3"]="04 84" 
    ["4"]="05 85" 
    ["5"]="06 86" 
    ["6"]="07 87" 
    ["7"]="08 88" 
    ["8"]="09 89" 
    ["9"]="0A 8A" 
    ["0"]="0B 8B" 
    ["-"]="0C 8C" 
    ["="]="0D 8D" 
    ["BKSP"]="0E 8E"
    ["TAB"]="0F 8F"
    ["q"]="10 90" 
    ["w"]="11 91" 
    ["e"]="12 92" 
    ["r"]="13 93" 
    ["t"]="14 94" 
    ["y"]="15 95" 
    ["u"]="16 96" 
    ["i"]="17 97" 
    ["o"]="18 98" 
    ["p"]="19 99" 
    ["["]="1A 9A" 
    ["]"]="1B 9B" 
    ["ENTER"]="1C 9C"
    ["CTRLprs"]="1D"
    ["CTRLrls"]="9D"
    ["a"]="1E 9E" 
    ["s"]="1F 9F" 
    ["d"]="20 A0" 
    ["f"]="21 A1" 
    ["g"]="22 A2" 
    ["h"]="23 A3" 
    ["j"]="24 A4" 
    ["k"]="25 A5" 
    ["l"]="26 A6" 
    [";"]="27 A7" 
    ["'"]="28 A8" 
    ['`']="29 A9" 
    ["LSHIFTprs"]="2A"
    ["LSHIFTrls"]="AA"
    ['\']="2B AB" 
    ["z"]="2C AC" 
    ["x"]="2D AD" 
    ["c"]="2E AE" 
    ["v"]="2F AF" 
    ["b"]="30 B0" 
    ["n"]="31 B1" 
    ["m"]="32 B2" 
    [","]="33 B3" 
    ["."]="34 B4" 
    ["/"]="35 B5" 
    ["RSHIFTprs"]="36"
    ["RSHIFTrls"]="B6"
    ["ALTprs"]="38"
    ["ALTrls"]="B8"
    ["LALT"]="38 B8"
    ["SPACE"]="39 B9"
    [" "]="39 B9"
    ["CAPS"]="3A BA"
    ["CAPSLOCK"]="3A BA"
    ["F1"]="3B BB"
    ["F2"]="3C BC"
    ["F3"]="3D BD"
    ["F4"]="3E BE"
    ["F5"]="3F BF"
    ["F6"]="40 C0"
    ["F7"]="41 C1"
    ["F8"]="42 C2"
    ["F9"]="43 C3"
    ["F10"]="44 C4"
    ["UP"]="E0 48 E0 C8"
    ["RIGHT"]="E0 4D E0 CD"
    ["LEFT"]="E0 4B E0 CB"
    ["DOWN"]="E0 50 E0 D0"
    ["HOME"]="E0 47 E0 C7"
    ["END"]="E0 4F E0 CF"
    ["PGUP"]="E0 49 E0 C9"
    ["PGDN"]="E0 51 E0 D1"
    ["CMDprs"]="E0 5C"
    ["CMDrls"]="E0 DC"
    # all codes below start with LSHIFTprs as commented in first item:
    ["!"]="2A 02 82 AA" # LSHIFTprs 1prs 1rls LSHIFTrls
    ["@"]="2A 03 83 AA"
    ["#"]="2A 04 84 AA"
    ["$"]="2A 05 85 AA"
    ["%"]="2A 06 86 AA"
    ["^"]="2A 07 87 AA"
    ["&"]="2A 08 88 AA"
    ["*"]="2A 09 89 AA"
    ["("]="2A 0A 8A AA"
    [")"]="2A 0B 8B AA"
    ["_"]="2A 0C 8C AA"
    ["+"]="2A 0D 8D AA"
    ["Q"]="2A 10 90 AA"
    ["W"]="2A 11 91 AA"
    ["E"]="2A 12 92 AA"
    ["R"]="2A 13 93 AA"
    ["T"]="2A 14 94 AA"
    ["Y"]="2A 15 95 AA"
    ["U"]="2A 16 96 AA"
    ["I"]="2A 17 97 AA"
    ["O"]="2A 18 98 AA"
    ["P"]="2A 19 99 AA"
    ["{"]="2A 1A 9A AA"
    ["}"]="2A 1B 9B AA"
    ["A"]="2A 1E 9E AA"
    ["S"]="2A 1F 9F AA"
    ["D"]="2A 20 A0 AA"
    ["F"]="2A 21 A1 AA"
    ["G"]="2A 22 A2 AA"
    ["H"]="2A 23 A3 AA"
    ["J"]="2A 24 A4 AA"
    ["K"]="2A 25 A5 AA"
    ["L"]="2A 26 A6 AA"
    [":"]="2A 27 A7 AA"
    ['"']="2A 28 A8 AA"
    ["~"]="2A 29 A9 AA"
    ["|"]="2A 2B AB AA"
    ["Z"]="2A 2C AC AA"
    ["X"]="2A 2D AD AA"
    ["C"]="2A 2E AE AA"
    ["V"]="2A 2F AF AA"
    ["B"]="2A 30 B0 AA"
    ["N"]="2A 31 B1 AA"
    ["M"]="2A 32 B2 AA"
    ["<"]="2A 33 B3 AA"
    [">"]="2A 34 B4 AA"
    ["?"]="2A 35 B5 AA"
)

function getvmname() {
    if [ -z "${vmname}" ]; then
        read -p "Enter VM name: " vmname
        export vmname="${vmname}"
    fi
}

function clearvmname() {
    vmname=""
}

# read variable kbstring and convert string to scancodes and send to guest vm
function sendkeys() {
    getvmname
    read -p "Enter string: " kbstring
    scancode=$(for (( i=0; i < ${#kbstring}; i++ ));
               do c[i]=${kbstring:i:1}; echo -n ${ksc[${c[i]}]}" "; done)
    VBoxManage controlvm "${vmname}" keyboardputscancode ${scancode}
}

# read variable kbspecial and send keystrokes by name,
# for example "CTRLprs c CTRLrls", and send to guest vm
function sendspecial() {
    getvmname
    read -p "Enter names of special characters, space delimited: " kbspecial
    scancode=""
    for keypress in ${kbspecial}; do
        scancode="${scancode}${ksc[${keypress}]}"" "
    done
    VBoxManage controlvm "${vmname}" keyboardputscancode ${scancode}
}

function sendenter() {
    getvmname
    VBoxManage controlvm "${vmname}" keyboardputscancode 1C 9C
}

alias printksc="declare -p ksc | grep -o '[A-Z][A-Z][A-Z][A-Za-z]*' | sort -d"

printf '
source scancodes.sh - load functions from script
getvmname           - read VM name and export to variable "vmname"
clearvmname         - clear variable "vmname"
sendkeys            - read a string of ASCII characters and send them as
                      scancodes to the virtual machine
sendenter           - send ENTER key scancode to the virtual machine
sendspecial         - read special characters by name, space delimited,
                      and send them as scancodes to the virtual machine
printksc            - print names of recognized special keys'
