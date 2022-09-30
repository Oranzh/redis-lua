-- get all the elements in a table
local val = redis.call('ZRANGEBYSCORE', KEYS[1], '-inf', ARGV[1])

-- if the table is not empty, then remove all the elements in the sorted set before the current timestamp KEYS[1]
if (next(val) ~= nil) then
    redis.call('ZREMRANGEBYRANK', KEYS[1], 0, #val - 1)
    for i = 1, #val, 100 do
        -- migrate the elements to the queue
        redis.call('LPUSH', KEYS[2], unpack(val, i, math.min(i + 99, #val)))
    end
end

return val
