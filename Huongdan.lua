--// 🌈 QUAY NGƯỢC THỜI GIAN : TUA
--// Delta Executor Roblox

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local plr = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TimeReverseGUI"
gui.Parent = game.CoreGui

-- MAIN FRAME
local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0, 300, 0, 110)
main.Position = UDim2.new(0.5, -150, 0.15, 0)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,25)
corner.Parent = main

-- 🌈 Rainbow Border
local stroke = Instance.new("UIStroke")
stroke.Thickness = 4
stroke.Parent = main

spawn(function()
	while true do
		for i = 0,1,0.01 do
			stroke.Color = Color3.fromHSV(i,1,1)
			task.wait()
		end
	end
end)

-- TITLE
local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.new(0.8,0,0.3,0)
title.Position = UDim2.new(0.05,0,0.02,0)
title.BackgroundTransparency = 1
title.Text = "🌈 QUAY NGƯỢC THỜI GIAN"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- MINIMIZE BUTTON
local mini = Instance.new("TextButton")
mini.Parent = main
mini.Size = UDim2.new(0,35,0,35)
mini.Position = UDim2.new(1,-45,0,10)
mini.BackgroundColor3 = Color3.fromRGB(40,40,40)
mini.Text = "-"
mini.TextColor3 = Color3.new(1,1,1)
mini.Font = Enum.Font.GothamBold
mini.TextScaled = true
mini.BorderSizePixel = 0

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(1,0)
miniCorner.Parent = mini

-- TUA BUTTON
local btn = Instance.new("TextButton")
btn.Parent = main
btn.Size = UDim2.new(0.8,0,0.35,0)
btn.Position = UDim2.new(0.1,0,0.55,0)
btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
btn.Text = "TUA"
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
btn.BorderSizePixel = 0

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0,20)
btnCorner.Parent = btn

-- DRAG GUI
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- MINIMIZE
local minimized = false

mini.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		btn.Visible = false
		main.Size = UDim2.new(0,300,0,50)
		mini.Text = "+"
	else
		btn.Visible = true
		main.Size = UDim2.new(0,300,0,110)
		mini.Text = "-"
	end
end)

-- SAVE POSITIONS
local positions = {}
local rewinding = false

spawn(function()
	while true do
		task.wait(0.15)

		local char = plr.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			table.insert(positions,1,char.HumanoidRootPart.CFrame)

			if #positions > 300 then
				table.remove(positions,#positions)
			end
		end
	end
end)

-- REWIND
local function reverseTime()
	rewinding = true
	btn.Text = "DỪNG"

	while rewinding do
		local char = plr.Character

		if char and char:FindFirstChild("HumanoidRootPart") then
			if #positions > 0 then
				char.HumanoidRootPart.CFrame = positions[1]
				table.remove(positions,1)
			end
		end

		task.wait(0.05)
	end
end

btn.MouseButton1Click:Connect(function()
	if rewinding then
		rewinding = false
		btn.Text = "TUA"
	else
		reverseTime()
	end
end)