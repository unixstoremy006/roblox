-- Grow A Garden Exploit GUI by Grok
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrowGardenHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 500)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner + Stroke
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 180, 120)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "🌱 Grow A Garden Hub"
Title.TextColor3 = Color3.fromRGB(100, 255, 150)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Tab buttons container
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, -20, 0, 40)
TabFrame.Position = UDim2.new(0, 10, 0, 60)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

-- Content Frame
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -120)
Content.Position = UDim2.new(0, 10, 0, 110)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 6
Content.CanvasSize = UDim2.new(0, 0, 0, 800)
Content.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Content

-- Simple Toggle Function
local function CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 50)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ToggleFrame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 16
    Label.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 80, 0, 30)
    ToggleButton.Position = UDim2.new(1, -90, 0.5, -15)
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(60, 180, 120) or Color3.fromRGB(80, 80, 85)
    ToggleButton.Text = default and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Parent = ToggleFrame
    
    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(0, 8)
    TCorner.Parent = ToggleButton
    
    local enabled = default
    
    ToggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        ToggleButton.BackgroundColor3 = enabled and Color3.fromRGB(60, 180, 120) or Color3.fromRGB(80, 80, 85)
        ToggleButton.Text = enabled and "ON" or "OFF"
        callback(enabled)
    end)
    
    return ToggleFrame
end

-- Unlimited Jump
local jumpConnection
CreateToggle(Content, "Unlimited Jump", false, function(state)
    if state then
        jumpConnection = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpPower = 150
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if jumpConnection then jumpConnection:Disconnect() end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end
end)

-- NoClip
local noclipConnection
CreateToggle(Content, "No Clip (Phase Through Walls)", false, function(state)
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
    end
end)

-- Buy All Seeds (Seed Shop)
CreateToggle(Content, "Auto Buy All Seeds", false, function(state)
    -- Replace with actual RemoteEvent path if found via explorer
    spawn(function()
        while state and task.wait(0.5) do
            local seedShop = workspace:FindFirstChild("SeedShop") or workspace:FindFirstChild("Shops")
            if seedShop and seedShop:FindFirstChild("BuyRemote") then
                seedShop.BuyRemote:FireServer("All") -- Adjust name
            end
        end
    end)
end)

-- Buy All Gear
CreateToggle(Content, "Auto Buy All Gear", false, function(state)
    spawn(function()
        while state and task.wait(0.5) do
            -- Adjust remote
            local gearRemote = workspace:FindFirstChild("GearShop") and workspace.GearShop:FindFirstChild("Purchase")
            if gearRemote then
                gearRemote:FireServer("All")
            end
        end
    end)
end)

-- Buy All Eggs
CreateToggle(Content, "Auto Buy All Eggs", false, function(state)
    spawn(function()
        while state and task.wait(0.5) do
            -- Adjust
            if workspace:FindFirstChild("EggShop") then
                -- Fire server with egg type
            end
        end
    end)
end)

-- Additional Exploits
CreateToggle(Content, "Auto Farm / Auto Harvest", false, function(state)
    -- Common in public scripts: loop through plots and fire harvest/plant remotes
    print("Auto Farm enabled - implement loop over your garden plots")
end)

CreateToggle(Content, "Seed/Pet/Egg Spawner (Infinite)", false, function(state)
    print("Use item spawner remotes - common: ReplicatedStorage.Remotes.GiveItem")
end)

CreateToggle(Content, "Infinite Money / Shekels", false, function(state)
    -- Often via dupe or direct remote
end)

CreateToggle(Content, "Auto Sell All", false, function(state)
    -- Fire sell remote
end)

CreateToggle(Content, "Speed Hack (WalkSpeed)", false, function(state)
    spawn(function()
        while state and task.wait() do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 50
            end
        end
    end)
end)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Parent = MainFrame
local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("🌱 Grow A Garden Hub loaded! Drag the window. Use responsibly.")