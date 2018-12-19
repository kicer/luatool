local uart_id = 2
local baudrate = 115200

local _print = _G.print
local print = function(...)
  for i,v in ipairs(arg) do
    arg[i] = type(v) == 'nil' and 'nil' or tostring(v)
  end
  uart.write(uart_id, table.concat(arg,'\t'))
  uart.write(uart_id, '\r\n')
end
_G.print = print

uart.setup(uart_id, baudrate, 8, uart.PAR_NONE, uart.STOP_1, 0, 0)

uart.on(uart_id, 'receive', function()
    local line = uart.read(uart_id, '*l')
    uart.write(uart_id, line)
    uart.write(uart_id, '\n')
    xpcall(function()
      local f = assert(loadstring(line))
      f()
      uart.write(uart_id, '\r\n# ')
    end, function(e)
      uart.write(uart_id, e)
      uart.write(uart_id, '\r\n')
      uart.write(uart_id, debug.traceback())
    end)
end)

uart.write(uart_id, 'Welcome to console.\r\n# ')

