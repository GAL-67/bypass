--local a=game:GetService("TeleportService")local b=game:GetService("Players")local b=b.LocalPlayer;local c={"Teleport","TeleportToPlaceInstance","TeleportAsync","TeleportToOptions","TeleportToGroupPlayer","TeleportPartyAsync","TeleportToPrivateServer"}local d;d=hookmetamethod(game,"__namecall",function(e,...)local f=getnamecallmethod()if e==a and table.find(c,f)then warn("[BLOCKER] Preventing Teleport via __namecall: "..tostring(f))return nil end;if e==b and f=="Kick"then warn("[BLOCKER] Preventing Kick via __namecall")return nil end;return d(e,...)end)local b;b=hookmetamethod(game,"__index",function(d,e)if d==a and table.find(c,e)then warn("[BLOCKER] Preventing access to method: "..tostring(e))return function()return nil end end;return b(d,e)end)for b,b in ipairs(c)do if a[b]and hookfunction then pcall(function()hookfunction(a[b],function(...)warn("[BLOCKER] Preventing Direct Hook: "..b)return nil end)end)end end;print("[Info] Anti-cheat bypass active!")
local a = game:GetService("TeleportService")
local b = game:GetService("Players").LocalPlayer

-- Daftar metode TeleportService + Player yang wajib diblokir
local c = {
    "Teleport", 
    "TeleportToPlaceInstance", 
    "TeleportAsync", 
    "TeleportToOptions", 
    "TeleportToGroupPlayer", 
    "TeleportPartyAsync", 
    "TeleportToPrivateServer",
    "ReserveServerAsync",
    "GetPlayerPlaceInstanceAsync",
    "Kick",
    "RequestLeaveSession"
}

-- 1. Lapisan Proteksi __namecall
local d;
d = hookmetamethod(game, "__namecall", function(e, ...)
    local f = getnamecallmethod()
    
    -- Blokir jika metode di dalam daftar dipanggil via objek TeleportService atau Player
    if (e == a or e == b) and table.find(c, f) then 
        warn("[BLOCKER] Preventing call via __namecall: " .. tostring(f))
        return nil 
    end
    
    -- Cegat jika game mencoba membuat objek TeleportOptions baru via Instance.new
    if f == "New" or f == "new" then
        local args = {...}
        if args[1] == "TeleportOptions" then
            warn("[BLOCKER] Preventing creation of TeleportOptions")
            return nil
        end
    end
    
    return d(e, ...)
end)

-- 2. Lapisan Proteksi __index (Jika game mengambil fungsi sebagai variabel)
local oldIndex;
oldIndex = hookmetamethod(game, "__index", function(t, k)
    if (t == a or t == b) and table.find(c, k) then 
        warn("[BLOCKER] Preventing access to method: " .. tostring(k))
        return function() return nil end 
    end
    return oldIndex(t, k)
end)

-- 3. Lapisan Proteksi Direct Hook (Memperbaiki bug perulangan 'b,b')
if hookfunction then
    for _, methodName in ipairs(c) do 
        -- Cek apakah metode tersebut ada di TeleportService
        if a[methodName] then
            pcall(function()
                hookfunction(a[methodName], function(...)
                    warn("[BLOCKER] Preventing Direct Hook (TeleportService): " .. methodName)
                    return nil
                end)
            end)
        -- Cek apakah metode tersebut ada di objek Player
        elseif b[methodName] then
            pcall(function()
                hookfunction(b[methodName], function(...)
                    warn("[BLOCKER] Preventing Direct Hook (Player): " .. methodName)
                    return nil
                end)
            end)
        end
    end
end

print("[Info] Anti Teleport & Anti Kick v2 Active!")
