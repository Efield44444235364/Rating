-- รายการ Place ID ที่อนุญาต
local allowedPlaceIds = {
    [126509999114328] = true,
    [1759235639673] = true
}

-- ตรวจสอบว่าอยู่ใน Place ID ที่อนุญาตหรือไม่
if not allowedPlaceIds[game.PlaceId] then
    return -- ไม่อนุญาต, หยุดสคริปต์ตรงนี้
end


local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local animator = humanoid:WaitForChild("Animator")

-- ค่า global
getgenv().Speed = getgenv().Speed or 30 -- ค่าเริ่มต้น
local normalSpeed = 16
local stopDelay = 0.1
local moving = false
local lastPos = hrp.Position

-- Asset Jump (เปลี่ยน ID ได้)
local jumpAnimId = "rbxassetid://125750702"
local jumpSoundId = "rbxassetid://12222185"

-- โหลด animation
local jumpAnim = Instance.new("Animation")
jumpAnim.AnimationId = jumpAnimId
local jumpTrack = animator:LoadAnimation(jumpAnim)

-- แจ้งเตือนครั้งเดียว
local notified = false
local function notify(msg)
	if not notified then
		pcall(function()
			StarterGui:SetCore("SendNotification", {
				Title = "Ice Script",
				Text = msg,
				Duration = 5
			})
		end)
		notified = true
	end
end

-- ตรวจสอบการเคลื่อนที่ + Speed limit
task.spawn(function()
	while task.wait(stopDelay) do
		if not (humanoid and humanoid.Parent and char:FindFirstChild("HumanoidRootPart")) then
			break
		end

		local customSpeed = tonumber(getgenv().Speed) or normalSpeed

		-- ถ้าเกิน limit → แจ้งเตือนครั้งเดียว + หยุดทุกอย่าง
		if customSpeed > 100 then
			notify("❌ Speed limit bitch ")
			humanoid.WalkSpeed = normalSpeed
			break
		end

		local currentPos = char.HumanoidRootPart.Position
		local distance = (currentPos - lastPos).Magnitude

		if distance < 0.01 then
			if moving then
				humanoid.WalkSpeed = normalSpeed
				moving = false
			end
		else
			if not moving then
				humanoid.WalkSpeed = customSpeed
				moving = true
			end
		end

		lastPos = currentPos
	end
end)

-- รีสปอว์น
player.CharacterAdded:Connect(function(newChar)
	char = newChar
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")
	animator = humanoid:WaitForChild("Animator")
	lastPos = hrp.Position
	moving = false

	-- reload animation
	jumpAnim = Instance.new("Animation")
	jumpAnim.AnimationId = jumpAnimId
	jumpTrack = animator:LoadAnimation(jumpAnim)
end)

-- Infinite Jump + Anim + Sound
UserInputService.JumpRequest:Connect(function()
	if humanoid and humanoid.Parent then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

		if jumpTrack then
			jumpTrack:Play()
		end

		local sound = Instance.new("Sound")
		sound.SoundId = jumpSoundId
		sound.Volume = 1
		sound.Parent = hrp or char
		sound:Play()
		game:GetService("Debris"):AddItem(sound, 2)
	end
end)
