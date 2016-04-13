[![Build Status](https://travis-ci.org/aiQon/UP3D.svg?branch=master)](https://travis-ci.org/aiQon/UP3D)

Latest builds available at https://github.com/aiQon/UP3D/releases/latest

# UP3D
UP 3D Printer Tools

Little How To: http://stohn.de/3d/index.php/2016/03/10/up3dtools-little-how-to

## up3dtranscode: 

G-Code to UpMachineCode (UMC) converter

usage linux:   ./up3dtranscode input.gcode output.umc
usage mac:     ./up3dtranscode input.gcode output.umc
usage windows: up3dtranscode input.gcode output.umc

or with nozzle height added as last parameter

usage linux:  ./up3dtranscode input.gcode output.umc 123.1
usage mac:    ./up3dtranscode input.gcode output.umc 123.1
usage windows: up3dtranscode input.gcode output.umc 123.1

---

## upload: 

UpMachineCode (UMC) uploader, sends the umc file to printer and starts a print

usage linux:   sudo ./upload output.umc //requires sudo on linux
usage mac:     ./upload output.umc //requires sudo on linux
usage windows: upload output.umc //requires sudo on linux

---

## upshell: 

Interactive printer monitor and debugging tool, use to watch printing

usage linux:   sudo ./upshell //requires sudo on linux
usage mac:     ./upshell //requires sudo on linux
usage windows: upshell //requires sudo on linux

---

## upinfo: 

Retrieves information about the connected UP3D printer

usage linux:   sudo ./upshell //requires sudo on linux
usage mac:     ./upshell //requires sudo on linux
usage windows: upshell //requires sudo on linux
