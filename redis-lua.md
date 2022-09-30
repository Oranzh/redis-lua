# Redis-Lua脚本

## Prons 
    高效, 原子性
## Cons
    需要写额外的Lua脚本,需要懂Lua语法 


## Lua VS Multi

    Multi能实现的,Lua脚本都能实现,而且Lua更灵活和更高效,也可以处理更为复杂的业务逻辑.

## 一个简单的例子
    ```lua

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

    ```
    


 
### 运行脚本命令 
    redis-cli --eval sliding.lua user:friday , 5 5000

    sliding.lua是脚本文件名, user:friday是key, 5是最大请求数, 5000是过期时间(单位毫秒)

    注意 , 号前后必须有空格, 否则会报错

如果需要多次运行此脚本,可以先load script,会返回一个hash值,再使用evalsha1函数

    redis-cli -x script load < sliding.lua

    evalsha hash 1 user:friday 5 5000 (登录redis客户端)

---

## Redis Lua Scripts Debugger (LDB)


也是用上面的例子, 用LDB调试一下

    redis-cli --ldb --eval sliding.lua  user:friday , 5 5000

    --ldb参数是调试模式, 会打印出脚本执行的每一步

执行结果
![ldb](https://github.com/Oranzh/photos/blob/main/image.png?raw=true)
   

    
    
