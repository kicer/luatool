PROJECT = "LUATOOLS"
VERSION = "1.0.0"

PRODUCT_KEY = "xxx"

require "log"
LOG_LEVEL = log.LOGLEVEL_TRACE

require "sys"
require "net"
net.startQueryAll(60000, 60000)

require "net"
require "misc"

require "errDump"
errDump.request("udp://ota.airm2m.com:9072")

sys.taskInit(function()
  while not socket.isReady() do sys.waitUntil("IP_READY_IND") end

  local uart_id = 2
  local _print = _G.print
  local print = function(...)
    for i,v in ipairs(arg) do
      arg[i] = type(v) == 'nil' and 'nil' or tostring(v)
    end
    uart.write(uart_id, table.concat(arg,'\t'))
    uart.write(uart_id, '\r\n')
  end

  print(PROJECT, VERSION)
  print('   rssi: ',net.getRssi())
  print('  state: ',net.getState())
  print('   imei: ',misc.getImei())
  print('   heap: ',collectgarbage("count"),' KB')
  print('version: ',misc.getVersion())
end)

sys.init(0, 0)
sys.run()
