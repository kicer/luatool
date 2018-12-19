local uart_id = 2
local _print = _G.print
local print = function(...)
  for i,v in ipairs(arg) do
    arg[i] = type(v) == 'nil' and 'nil' or tostring(v)
  end
  uart.write(uart_id, table.concat(arg,'\t'))
  uart.write(uart_id, '\r\n')
end

print('init.lua ver 1.2')
print('   rssi: ',net.getRssi())
print('  state: ',net.getState())
print('   imei: ',misc.getImei())
print('   heap: ',collectgarbage("count"),' KB')
print('version: ',misc.getVersion())
