local p = game.Players.LocalPlayer
local run, delayTime, minimized = true, .15, false

-- hapus GUI lama kalau ada
local old = p:WaitForChild("PlayerGui"):FindFirstChild("Xzone_001-GUI")
if old then old:Destroy() end

-- GUI utama
local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
gui.Name = "Xzone_001-GUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size, frame.Position = UDim2.new(0,180,0,170), UDim2.new(0,20,0,20)
frame.BackgroundColor3, frame.BackgroundTransparency = Color3.fromRGB(40,40,40), 0.2
frame.BorderSizePixel, frame.Active, frame.Draggable = 0, true, true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- header
local header = Instance.new("Frame", frame)
header.Size, header.Position, header.BackgroundColor3 = UDim2.new(1,0,0,30), UDim2.new(0,0,0,0), Color3.fromRGB(25,25,25)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0,12)

-- icon
local icon = Instance.new("ImageLabel", header)
icon.Size, icon.Position, icon.BackgroundTransparency = UDim2.new(0,20,0,20), UDim2.new(0,5,0,5), 1
icon.Image = "rbxassetid://3926307971"

-- title
local title = Instance.new("TextLabel", header)
title.Size, title.Position = UDim2.new(1,-60,1,0), UDim2.new(0,30,0,0)
title.BackgroundTransparency = 1
title.Text = "Fairy Net Hub"
title.TextColor3, title.Font, title.TextSize, title.TextXAlignment =
    Color3.new(1,1,1), Enum.Font.GothamBold, 14, Enum.TextXAlignment.Left

-- close & minimize
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size, closeBtn.Position, closeBtn.Text = UDim2.new(0,25,1,0), UDim2.new(1,-25,0,0), "X"
closeBtn.BackgroundColor3, closeBtn.TextColor3, closeBtn.Font, closeBtn.TextSize =
    Color3.fromRGB(170,0,0), Color3.new(1,1,1), Enum.Font.GothamBold, 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

local minBtn = Instance.new("TextButton", header)
minBtn.Size, minBtn.Position, minBtn.Text = UDim2.new(0,25,1,0), UDim2.new(1,-55,0,0), "-"
minBtn.BackgroundColor3, minBtn.TextColor3, minBtn.Font, minBtn.TextSize =
    Color3.fromRGB(200,160,0), Color3.new(1,1,1), Enum.Font.GothamBold, 14
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,6)

-- konten
local content = Instance.new("Frame", frame)
content.Size, content.Position, content.BackgroundTransparency = UDim2.new(1,0,1,-30), UDim2.new(0,0,0,30), 1

local toggle = Instance.new("TextButton", content)
toggle.Size, toggle.Position, toggle.Text = UDim2.new(1,-20,0,30), UDim2.new(0,10,0,10), "Auto: ON"
toggle.BackgroundColor3, toggle.TextColor3, toggle.Font, toggle.TextSize =
    Color3.fromRGB(0,170,0), Color3.new(1,1,1), Enum.Font.GothamBold, 14
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,8)

local delayBox = Instance.new("TextBox", content) -- FIX: TextBox (bukan SetDelay)
delayBox.Size, delayBox.Position, delayBox.PlaceholderText = UDim2.new(1,-20,0,30), UDim2.new(0,10,0,50), "Delay (0.15)"
delayBox.BackgroundColor3, delayBox.TextColor3, delayBox.Font, delayBox.TextSize =
    Color3.fromRGB(50,50,50), Color3.new(1,1,1), Enum.Font.Gotham, 14
Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0,8)

local status = Instance.new("TextLabel", content)
status.Size, status.Position, status.Text = UDim2.new(1,-20,0,30), UDim2.new(0,10,0,90), "Equipped: ❌"
status.BackgroundTransparency, status.TextColor3, status.Font, status.TextSize =
    1, Color3.new(1,1,0), Enum.Font.GothamBold, 14

-- logic
toggle.MouseButton1Click:Connect(function()
	run = not run
	if run then
		toggle.Text, toggle.BackgroundColor3 = "Auto: ON", Color3.fromRGB(0,170,0)
		pcall(function() equip() end) -- panggil ulang agar loop kembali berjalan
	else
		toggle.Text, toggle.BackgroundColor3 = "Auto: OFF", Color3.fromRGB(170,0,0)
	end
end)

delayBox.FocusLost:Connect(function()
	local n = tonumber(delayBox.Text)
	if n and n > 0 then delayTime = n end
	delayBox.Text = ""
end)

closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	content.Visible = not minimized
	minBtn.Text = minimized and "+" or "-"
end)

-- equip & auto
local function equip()
	if not run then return end
	local bp = p:WaitForChild("Backpack")
	local c = p.Character or p.CharacterAdded:Wait()
	local h = c:WaitForChild("Humanoid")
	for _,t in ipairs(bp:GetChildren()) do
		if t:IsA("Tool") and t.Name:lower():find("fairy net") then
			h:EquipTool(t); status.Text = "Equipped: ✅"
			task.spawn(function()
				while run and t.Parent == c do
					t:Activate()
					task.wait(delayTime)
				end
				if not run then status.Text = "Equipped: ⏸" else status.Text = "Equipped: ❌" end
			end)
		end
	end
end

-- hook
pcall(equip)
p.CharacterAdded:Connect(function() task.wait(.5) equip() end)
p:WaitForChild("Backpack").ChildAdded:Connect(function(t) if t:IsA("Tool") and t.Name:lower():find("fairy net") then equip() end end)
