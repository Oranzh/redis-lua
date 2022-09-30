local key_prefix = KEYS[1]
local volume = tonumber(ARGV[1])

-- get all keys matching the prefix
local keys = redis.call('keys', key_prefix .. '*')


if (next(keys) ~= nil) then
    -- increment each key
    for i, key in ipairs(keys) do
        -- if the value of the key less then volume then increment it
        if (tonumber(redis.call('get', key)) < volume) then
            redis.call('incr', key)
        end
    end
    return redis.call('mget', unpack(keys))
end
return 'No keys found'

