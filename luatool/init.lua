PROJECT = "luatools"
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

  sys.timerStart(function()
    print(PROJECT, VERSION)
    print('version: ',misc.getVersion())
    print('   imei: ',misc.getImei())
    print('   rssi: ',net.getRssi())
    print('  state: ',net.getState())
    print(' fsfree: ',rtos.get_fs_free_size())
    print('   heap: ',collectgarbage("count"),' KB')
  end, 5000)
end)

sys.init(0, 0)
sys.run()
