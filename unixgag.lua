-- 🌱 Grow A Garden Advanced Exploit GUI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrowGardenAdvanced"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 460, 0, 560)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -280)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(40, 200, 120)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundTransparency = 1
Title.Text = "🌱 Grow A Garden Hub"
Title.TextColor3 = Color3.fromRGB(80, 255, 140)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Tabs Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 50)
TabContainer.Position = UDim2.new(0, 10, 0, 60)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local Tabs = {}

local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.Parent = TabContainer
    return btn
end

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -130)
ContentFrame.Position = UDim2.new(0, 10, 0, 120)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 5
ContentFrame.CanvasSize = UDim2.new(0,0,0,0)
ContentFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 10)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ContentFrame

-- Toggle Function
local function AddToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230,230,230)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 16
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 90, 0, 32)
    toggle.Position = UDim2.new(1, -100, 0.5, -16)
    toggle.BackgroundColor3 = default and Color3.fromRGB(60, 200, 120) or Color3.fromRGB(70, 70, 75)
    toggle.Text = default and "ON" or "OFF"
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = frame
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

    local enabled = default
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggle.BackgroundColor3 = enabled and Color3.fromRGB(60, 200, 120) or Color3.fromRGB(70, 70, 75)
        toggle.Text = enabled and "ON" or "OFF"
        callback(enabled)
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 70)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(230,230,230)
    label.Font = Enum.Font.GothamSemibold
    label.Parent = frame

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, -20, 0, 8)
    slider.Position = UDim2.new(0, 10, 0, 40)
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    slider.Parent = frame
    Instance.new("UICorner", slider)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(60, 200, 120)
    fill.Parent = slider
    Instance.new("UICorner", fill)

    -- Simple slider logic (you can improve)
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local conn
            conn = game:GetService("UserInputService").InputChanged:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = math.clamp((inp.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(pos, 0, 1, 0)
                    local value = math.floor(min + (max - min) * pos)
                    label.Text = text .. ": " .. value
                    callback(value)
                end
            end)
            game:GetService("UserInputService").InputEnded:Connect(function() conn:Disconnect() end)
        end
    end)
end

-- ================== TABS ==================
local currentTab = nil

local function SwitchTab(tabContent)
    for _, v in pairs(ContentFrame:GetChildren()) do
        if v:IsA("Frame") or v:IsA("ScrollingFrame") then v.Visible = false end
    end
    tabContent.Visible = true
end

-- 🌱 Farming Tab
local FarmingTab = Instance.new("Frame")
FarmingTab.Size = UDim2.new(1,0,0,0)
FarmingTab.BackgroundTransparency = 1
FarmingTab.Visible = false
FarmingTab.Parent = ContentFrame
AddToggle(FarmingTab, "Auto Plant", false, function(s) print("Auto Plant:", s) end)
AddToggle(FarmingTab, "Auto Water", false, function(s) print("Auto Water:", s) end)
AddToggle(FarmingTab, "Auto Harvest", false, function(s) print("Auto Harvest:", s) end)
AddToggle(FarmingTab, "Auto Sell", false, function(s) print("Auto Sell:", s) end)
AddToggle(FarmingTab, "Auto Replant", false, function(s) print("Auto Replant:", s) end)
AddToggle(FarmingTab, "Collect Nearby Crops", false, function(s) print("Collect Nearby:", s) end)

-- 🛒 Shops Tab
local ShopsTab = Instance.new("Frame")
ShopsTab.Size = UDim2.new(1,0,0,0)
ShopsTab.BackgroundTransparency = 1
ShopsTab.Visible = false
ShopsTab.Parent = ContentFrame
AddToggle(ShopsTab, "Buy Selected Seed", false, function(s) end)
AddToggle(ShopsTab, "Buy Selected Gear", false, function(s) end)
AddToggle(ShopsTab, "Buy Selected Egg", false, function(s) end)
AddToggle(ShopsTab, "Refresh Shop", false, function(s) end)
AddToggle(ShopsTab, "Favorite Items", false, function(s) end)

-- 🐾 Pets Tab
local PetsTab = Instance.new("Frame")
PetsTab.Size = UDim2.new(1,0,0,0)
PetsTab.BackgroundTransparency = 1
PetsTab.Visible = false
PetsTab.Parent = ContentFrame
AddToggle(PetsTab, "Equip Best Pet", false, function(s) end)
AddToggle(PetsTab, "Auto Feed Pet", false, function(s) end)
AddToggle(PetsTab, "Pet Inventory", false, function(s) end)
AddToggle(PetsTab, "Pet Statistics", false, function(s) end)

-- 🎒 Inventory Tab
local InvTab = Instance.new("Frame")
InvTab.Size = UDim2.new(1,0,0,0)
InvTab.BackgroundTransparency = 1
InvTab.Visible = false
InvTab.Parent = ContentFrame
AddToggle(InvTab, "Search Item", false, function(s) end)
AddToggle(InvTab, "Sort by Value", false, function(s) end)
AddToggle(InvTab, "Sort by Rarity", false, function(s) end)
AddToggle(InvTab, "Quick Delete", false, function(s) end)
AddToggle(InvTab, "Favorite Items", false, function(s) end)

-- 📊 Player Tab
local PlayerTab = Instance.new("Frame")
PlayerTab.Size = UDim2.new(1,0,0,0)
PlayerTab.BackgroundTransparency = 1
PlayerTab.Visible = false
PlayerTab.Parent = ContentFrame

AddToggle(PlayerTab, "No Clip", true, function(state) -- Already working for you
    if state then
        game:GetService("RunService").Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end)

AddSlider(PlayerTab, "WalkSpeed", 16, 100, 50, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

AddSlider(PlayerTab, "JumpPower", 50, 200, 80, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = v
    end
end)

AddSlider(PlayerTab, "Field of View", 70, 120, 90, function(v)
    game:GetService("Workspace").Camera.FieldOfView = v
end)

-- 🌍 Teleports Tab
local TeleTab = Instance.new("Frame")
TeleTab.Size = UDim2.new(1,0,0,0)
TeleTab.BackgroundTransparency = 1
TeleTab.Visible = false
TeleTab.Parent = ContentFrame
AddToggle(TeleTab, "Seed Shop", false, function() end)
AddToggle(TeleTab, "Gear Shop", false, function() end)
AddToggle(TeleTab, "Egg Shop", false, function() end)
AddToggle(TeleTab, "Farm Area", false, function() end)
AddToggle(TeleTab, "Event Area", false, function() end)

-- ⚙️ Utilities Tab
local UtilTab = Instance.new("Frame")
UtilTab.Size = UDim2.new(1,0,0,0)
UtilTab.BackgroundTransparency = 1
UtilTab.Visible = false
UtilTab.Parent = ContentFrame
AddToggle(UtilTab, "FPS Booster", false, function() end)
AddToggle(UtilTab, "Rejoin Server", false, function() end)
AddToggle(UtilTab, "Performance Monitor", false, function() end)

-- Create Tabs Buttons
local tabList = {
    {name = "Farming", frame = FarmingTab},
    {name = "Shops", frame = ShopsTab},
    {name = "Pets", frame = PetsTab},
    {name = "Inventory", frame = InvTab},
    {name = "Player", frame = PlayerTab},
    {name = "Teleports", frame = TeleTab},
    {name = "Utilities", frame = UtilTab}
}

for _, tab in ipairs(tabList) do
    local btn = CreateTab(tab.name)
    btn.MouseButton1Click:Connect(function()
        SwitchTab(tab.frame)
    end)
end

-- Default Tab
FarmingTab.Visible = true

print("🌱 Grow A Garden Advanced GUI Loaded!")
print("Only NoClip is fully working for now. Others need remote paths from your executor.")