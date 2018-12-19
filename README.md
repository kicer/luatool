# **luatool** #

[![Join the chat at https://gitter.im/kicer/luatool](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/kicer/luatool?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

### Tool for loading Lua-based scripts from file to Air202/Air720 with luat firmware

### Summary

- Allow easy uploading of any Lua-based script into the Air202/Air720 flash memory with [luat firmware](https://github.com/openLuat)
- Fork from [luatool](https://github.com/4refr0nt/luatool), 修改后用于合宙luat模块固件下载

### Requirements

python 3, pyserial


### Changelog
v0.7.0
- luat只支持串口下载文件
- 写入文件时预设的全局变量`FILE`

### Run

#### Typical use:


Edit file init.lua and set SSID and MasterPassword
Then disconnect any terminal programm, and at command prompt type

```
./luatool.py --port /dev/tty.SLAB_USBtoUART --baud 115200 --src init.lua --dest /lua/init.lua --verbose

Upload starting

->FILE = io.open("/lua/init.lua", "w"); -> ok
->if FILE then FILE:close() end; -> ok
->Stage 1. Deleting old file from flash memory
Stage 2. Creating file in flash memory and write first lineos.remove("/lua/init.lua"); -> ok
->
Stage 3. Start writing data to flash memory...FILE = io.open("/lua/init.lua", "w+"); -> ok
->FILE:write([==[local uart_id = 2 ]==]); -> ok
->FILE:write([==[local _print = _G.print ]==]); -> ok
->FILE:write([==[local print = function(...) ]==]); -> ok
->FILE:write([==[for i,v in ipairs(arg) do ]==]); -> ok
->FILE:write([==[arg[i] = type(v) == 'nil' and 'nil' or tostring(v) ]==]); -> ok
->FILE:write([==[end ]==]); -> ok
->FILE:write([==[uart.write(uart_id, table.concat(arg,'\t')) ]==]); -> ok
->FILE:write([==[uart.write(uart_id, '\r\n') ]==]); -> ok
->FILE:write([==[end ]==]); -> ok
->FILE:write([==[ ]==]); -> ok
->FILE:write([==[print('init.lua ver 1.2') ]==]); -> ok
->FILE:write([==[print('   rssi: ',net.getRssi()) ]==]); -> ok
->FILE:write([==[print('  state: ',net.getState()) ]==]); -> ok
->FILE:write([==[print('   imei: ',misc.getImei()) ]==]); -> ok
->FILE:write([==[print('   heap: ',collectgarbage("count"),' KB') ]==]); -> ok
->
Stage 4. Flush data and closing fileFILE:write([==[print('version: ',misc.getVersion()) ]==]); -> ok
->FILE:flush(); -> ok
->FILE:close(); -> ok
--->>> All done <<<---
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
