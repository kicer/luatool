CONSOLE=false

local key = pio.P0_29
local uart_id = 2
local baudrate = 115200

local print = _G.print
local _print = function(...)
  for i,v in ipairs(arg) do
    arg[i] = type(v) == 'nil' and 'nil' or tostring(v)
  end
  uart.write(uart_id, table.concat(arg,'\t'))
  uart.write(uart_id, '\r\n')
end

pio.pin.close(key)
pio.pin.setdir(pio.INPUT, key)
pio.pin.setpull(pio.PULLUP, key)

-- press key when boot will in console mode
if pio.pin.getval(key) == 0 then
  CONSOLE=true
  _G.print = _print
  uart.setup(uart_id, baudrate, 8, uart.PAR_NONE, uart.STOP_1)
  uart.write(uart_id, 'Welcome to console.\r\n> ')
end

local line = ''
while CONSOLE do
  if msg == rtos.MSG_UART_RXDATA then
    while param == uart_id do
      local ch = uart.read(uart_id, 1)
      if ch and ch~='' then
          line = line .. ch
          if timeout <= 0 and ch == '\n' then
            uart.write(uart_id, line)
            uart.write(uart_id, '\n')
            xpcall(function()
              local f = assert(loadstring(line))
              f()
            end, function(e)
              uart.write(uart_id, e)
              uart.write(uart_id, '\r\n')
              uart.write(uart_id, debug.traceback())
            end)
            line = ''
            uart.write(uart_id, '\r\n> ')
          end
      else
        break
      end
    end
  end
end

_G.print = print
dofile('/lua/init.lua')
