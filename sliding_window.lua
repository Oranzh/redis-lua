local key = KEYS[1]
local max_request = tonumber(ARGV[1])
local expiry = ARGV[2]

-- get the current millisecond
local current_time = redis.call('TIME')
local current_timestamp = current_time[1] * 1000 + current_time[2] / 1000

-- get the trimmed window
local trimmed_window = current_timestamp - expiry

-- remove all the elements in the sorted set which are out of the window
redis.call('ZREMRANGEBYSCORE', key, 0, trimmed_window)

-- get the number of elements in the sorted set
local request_count = redis.call('ZCARD', key)

if request_count >= max_request then
    return 0
else
    redis.call('ZADD', key, current_timestamp, current_timestamp)
    return 1
end
