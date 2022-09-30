local key = KEYS[1]
local max_request = tonumber(ARGV[1])
local expiry = ARGV[2]

-- set the key if the key does not exist with the expiry
redis.call('set', key, 0, 'EX', expiry, 'NX')

local request_count = tonumber(redis.call('get', key))

if request_count >= max_request then
    return 0
else
    redis.call('incr', key)
    return 1
end


