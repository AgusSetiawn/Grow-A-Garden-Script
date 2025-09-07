local p = game.Players.LocalPlayer
local run, delayTime = true, .15

-- GUI
local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
local toggle,delayBox,status = Instance.new("TextButton",gui),Instance.new("TextBox",gui),Instance.new("TextLabel",gui)
toggle.Size,toggle.Position, toggle.Text = UDim2.new(0,120,0,30),UDim2.new(0,10,0,10),"Auto: ON"
delayBox.Size,delayBox.Position,delayBox.PlaceholderText=UDim2.new(0,120,0,30),UDim2.new(0,10,0,50),"Delay (0.15)"
status.Size,status.Position,status.Text=UDim2.new(0,120,0,30),UDim2.new(0,10,0,90),"Equipped: ❌"

-- toggle & delay
toggle.MouseButton1Click:Connect(function()run=not run;toggle.Text=run and"Auto: ON"or"Auto: OFF"end)
delayBox.FocusLost:Connect(function()local n=tonumber(delayBox.Text)if n and n>0 then delayTime=n end;delayBox.Text=""end)

-- equip & autoclick
local function equip()
	if not run then return end
	local bp,c,h=p:WaitForChild("Backpack"),p.Character or p.CharacterAdded:Wait(),(p.Character or p.CharacterAdded:Wait()):WaitForChild("Humanoid")
	for _,t in ipairs(bp:GetChildren())do
		if t:IsA("Tool")and t.Name:lower():find("fairy net")then
			h:EquipTool(t);status.Text="Equipped: ✅"
			task.spawn(function()while run and t.Parent==c do t:Activate()task.wait(delayTime)end;status.Text="Equipped: ❌"end)
		end
	end
end

-- hook
equip()
p.CharacterAdded:Connect(function()task.wait(.5)equip()end)
p.Backpack.ChildAdded:Connect(function(t)if t:IsA("Tool")and t.Name:lower():find("fairy net")then equip()end end)
