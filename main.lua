local p = game.Players.LocalPlayer
local run, delayTime = true, .15

-- GUI utama
local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
frame.Size, frame.Position, frame.BackgroundColor3, frame.BackgroundTransparency =
    UDim2.new(0,150,0,140), UDim2.new(0,10,0,10), Color3.fromRGB(30,30,30), 0.3
frame.BorderSizePixel, frame.Active, frame.Draggable = 0, true, true

local toggle = Instance.new("TextButton", frame)
toggle.Size, toggle.Position, toggle.Text = UDim2.new(1,-20,0,30), UDim2.new(0,10,0,10), "Auto: ON"
toggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
toggle.TextColor3, toggle.Font, toggle.TextSize = Color3.new(1,1,1), Enum.Font.GothamBold, 14

local delayBox = Instance.new("Set Delay", frame)
delayBox.Size, delayBox.Position, delayBox.PlaceholderText = UDim2.new(1,-20,0,30), UDim2.new(0,10,0,50), "Delay (0.15)"
delayBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
delayBox.TextColor3, delayBox.Font, delayBox.TextSize = Color3.new(1,1,1), Enum.Font.Gotham, 14

local status = Instance.new("TextLabel", frame)
status.Size, status.Position, status.Text = UDim2.new(1,-20,0,30), UDim2.new(0,10,0,90), "Equipped: ❌"
status.BackgroundTransparency, status.TextColor3, status.Font, status.TextSize = 1, Color3.new(1,1,0), Enum.Font.GothamBold, 14

-- toggle & delay
toggle.MouseButton1Click:Connect(function()
	run = not run
	if run then
		toggle.Text, toggle.BackgroundColor3 = "Auto: ON", Color3.fromRGB(0,170,0)
		equip() -- panggil ulang biar loop aktif lagi
	else
		toggle.Text, toggle.BackgroundColor3 = "Auto: OFF", Color3.fromRGB(170,0,0)
	end
end)

delayBox.FocusLost:Connect(function()
	local n = tonumber(delayBox.Text)
	if n and n>0 then delayTime = n end
	delayBox.Text = ""
end)

-- equip & autoclick
function equip()
	if not run then return end
	local bp,c,h=p:WaitForChild("Backpack"),p.Character or p.CharacterAdded:Wait(),(p.Character or p.CharacterAdded:Wait()):WaitForChild("Humanoid")
	for _,t in ipairs(bp:GetChildren())do
		if t:IsA("Tool")and t.Name:lower():find("fairy net")then
			h:EquipTool(t);status.Text="Equipped: ✅"
			task.spawn(function()
				while run and t.Parent==c do
					t:Activate()
					task.wait(delayTime)
				end
				if not run then status.Text="Equipped: ⏸" else status.Text="Equipped: ❌" end
			end)
		end
	end
end

-- hook
equip()
p.CharacterAdded:Connect(function()task.wait(.5)equip()end)
p.Backpack.ChildAdded:Connect(function(t)if t:IsA("Tool")and t.Name:lower():find("fairy net")then equip()end end)
