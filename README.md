# **luatool** #

[![Join the chat at https://gitter.im/kicer/luatool](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/kicer/luatool?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

### Tool for loading Lua-based scripts from file to Air202/Air720 with luat firmware

### Summary

- Allow easy uploading of any Lua-based script into the Air202/Air720 flash memory with [luat firmware](https://github.com/openLuat)
- Fork from [luatool](https://github.com/4refr0nt/luatool), 修改后用于合宙luat模块固件下载

### Other projects
todo

### Requirements

python 2.7, pyserial

### Discuss
todo


### Changelog
v0.7.0
- luat只支持串口下载文件

v0.6.4
- add TCP as possible transport to connect to the module using the supplied telnet server code
- add --id/-i to query the ID of a module
- add --delete to remove a given file from the module
 
v0.6.3
- fix download bug
 
v0.6.2
- added support for nested strings
- added check to verify the UART buffer will not overflow.

v0.6.1
- put short versions of arguments back, see issue #2
- flush serial port, fixes issue #1

v0.6
- switched to argparse from getopts, renamed some arguments
- removed call-home from main.lua
- added --verbose option to show debugging
- added comments, fixed some grammar, updated README
- chmod 755'd the script so its runnable on POSIX
- checked with nodemcu 0.9.4 20141222

v0.5
- add new option  -r, --restart : auto restart module, send command "node.restart()", after file load 
- add new option  -d, --dofile  : auto run, send command "dofile('file')", after file load 
- delete line "lua script loaded by luatool" for correct line number, lines number now equal lines number in original file
- add 0.3 sec delay after write


v0.4
- now check proper answer from NodeMCU after send data.
  After send string we expect echo line, if not got it, then error message displayed "Error sending data to LuaMCU"
- if lua interpreter error received, then error message displayed "ERROR from LUA interpreter lua:..."
- add heap info and chip id to example file init.lua
- some changes in example file main.lua


### Run

#### Typical use:


Edit file init.lua and set SSID and MasterPassword
Then disconnect any terminal programm, and at command prompt type

```
./luatool.py --port /dev/tty.SLAB_USBtoUART --baud 115200 --src init.lua --dest /lua/init.lua --verbose

Upload starting

->file = io.open("/lua/init.lua", "w"); -> ok
->if file then file:close() end; -> ok
->Stage 1. Deleting old file from flash memory
Stage 2. Creating file in flash memory and write first lineos.remove("/lua/init.lua"); -> ok
->
Stage 3. Start writing data to flash memory...file = io.open("/lua/init.lua", "w+"); -> ok
->file:write([==[local uart_id = 2 ]==]); -> ok
->file:write([==[local _print = _G.print ]==]); -> ok
->file:write([==[local print = function(...) ]==]); -> ok
->file:write([==[for i,v in ipairs(arg) do ]==]); -> ok
->file:write([==[arg[i] = type(v) == 'nil' and 'nil' or tostring(v) ]==]); -> ok
->file:write([==[end ]==]); -> ok
->file:write([==[uart.write(uart_id, table.concat(arg,'\t')) ]==]); -> ok
->file:write([==[uart.write(uart_id, '\r\n') ]==]); -> ok
->file:write([==[end ]==]); -> ok
->file:write([==[ ]==]); -> ok
->file:write([==[print('init.lua ver 1.2') ]==]); -> ok
->file:write([==[print('   rssi: ',net.getRssi()) ]==]); -> ok
->file:write([==[print('  state: ',net.getState()) ]==]); -> ok
->file:write([==[print('   imei: ',misc.getImei()) ]==]); -> ok
->file:write([==[print('   heap: ',collectgarbage("count"),' KB') ]==]); -> ok
->
Stage 4. Flush data and closing filefile:write([==[print('version: ',misc.getVersion()) ]==]); -> ok
->file:flush(); -> ok
->file:close(); -> ok
--->>> All done <<<---
Echoing MCU output, press Ctrl-C to exitdofile("/lua/init.lua"); -> send without checkdofile("/lua/init.lua");

```
Connect you terminal program and send command (or you can use --restart option, when loading file init.lua)
```
sys.restart('luatool reboot')
```
after reboot:
```
init.lua ver 1.2
   rssi: 	19
  state: 	REGISTERED
   imei: 	xxx
   heap: 	185	 KB
version: 	SW_V5595_Air202_LUA_SSL
```

#### Examples:

```
./luatool.py --port COM4 --src file.lua --dest /lua/main.lua --baud 115200
```
- --port - COM1-COM128, default /dev/ttyUSB0
- --baud - baud rate, default 115200
- --src - source disk file, default main.lua
- --dest - destination flash file, default /lua/main.lua

Be carefully about bugs in lua-script - may cause a boot loop. Use this option after full testing only.
