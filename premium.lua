-- --- SISTEM PENYIMPANAN KONFIGURASI ---
local HttpService = game:GetService("HttpService")
local configFileName = "ZoneScriptConfig.json"
local currentConfig = {}

local function loadConfig()
    if isfile and readfile and isfile(configFileName) then
        local success, parsed = pcall(function()
            return HttpService:JSONDecode(readfile(configFileName))
        end)
        if success and type(parsed) == "table" then
            currentConfig = parsed
            return
        end
    end
    -- Tetapan asal jika tiada konfigurasi disimpan
    currentConfig = {
        autoRebirth = false,
        autoBuySpeed1 = false,
        autoBuySpeed10 = false,
        autoUpgrade = false,
        autoUpgradeAll = false,
        upgradeAmount = 1,
        infiniteJump = false,
        noclip = false,
        esp = false,
        autoFarmBest = false,
        autoCollectCash = false,
        upgradeStrength = false,
        autoSell = false
    }
end

local function saveConfig()
    if writefile and HttpService then
        writefile(configFileName, HttpService:JSONEncode(currentConfig))
    end
end

-- Muat konfigurasi semasa but skrip
loadConfig()

-- --- ANTARAMUKA UTAMA SKRIP ---
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Kawalan Automasi Zone, Tapak & Rohani",
   LoadingTitle = "Memuatkan Sistem...",
   LoadingSubtitle = "Oleh Script Builder & Spiritual Gaming",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "ZoneConfig"
   },
   KeySystem = false -- Sistem kunci dinyahaktifkan sepenuhnya
})

-- Membina Tab Menu
local MainTab = Window:CreateTab("Utama", 4483362458)
local SpiritualTab = Window:CreateTab("Rohani (Spiritual)", 4483362458)
local UtilityTab = Window:CreateTab("Utiliti", 4483362458)

-- --- LOGIK REMOTE / AUTOMASI ---
local replicatedStorage = game:GetService("ReplicatedStorage")
local eventsFolder = replicatedStorage:WaitForChild("Events", 10)

local rebirthEvent = eventsFolder and eventsFolder:WaitForChild("doRebirthEvent", 5)
local buySoloEvent = eventsFolder and eventsFolder:WaitForChild("buySoloEvent", 5)
local upgradeCharacterEvent = eventsFolder and eventsFolder:WaitForChild("upgradeCharacterEvent", 5)

-- Pembolehubah Status Automasi (Skrip Utama)
local autoRebirthEnabled = false
local autoBuySpeed1Enabled = false
local autoBuySpeed10Enabled = false
local autoUpgradeEnabled = false
local autoUpgradeAllEnabled = false
local upgradeAmount = currentConfig.upgradeAmount or 1 

-- Pembolehubah Status Automasi (Skrip Spiritual)
_G.AutoFarmBest = false
_G.AutoCollectCash = false
_G.UpgradeStrength = false
_G.AutoSell = false

-- --- PENGESAN & PENJEJAK PROMPT PEMBELIAN ROBLOX ---
local MarketplaceService = game:GetService("MarketplaceService")
local purchasePromptActive = false

MarketplaceService.PromptPurchaseFinished:Connect(function()
    purchasePromptActive = false
end)
MarketplaceService.PromptProductPurchaseFinished:Connect(function()
    purchasePromptActive = false
end)
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function()
    purchasePromptActive = false
end)

if hookfunction then
    local oldPromptPurchase
    oldPromptPurchase = hookfunction(MarketplaceService.PromptPurchase, function(self, ...)
        purchasePromptActive = true
        return oldPromptPurchase(self, ...)
    end)
    
    local oldPromptProductPurchase
    oldPromptProductPurchase = hookfunction(MarketplaceService.PromptProductPurchase, function(self, ...)
        purchasePromptActive = true
        return oldPromptProductPurchase(self, ...)
    end)
    
    local oldPromptGamePassPurchase
    oldPromptGamePassPurchase = hookfunction(MarketplaceService.PromptGamePassPurchase, function(self, ...)
        purchasePromptActive = true
        return oldPromptGamePassPurchase(self, ...)
    end)
end

-- =============================================================================
-- TAB UTAMA (Ciri-ciri daripada PushingV100)
-- =============================================================================

-- Butang Rebirth Automatik
local AutoRebirthToggle = MainTab:CreateToggle({
   Name = "Auto Rebirth (Kelahiran Semula)",
   CurrentValue = currentConfig.autoRebirth,
   Callback = function(Value)
      autoRebirthEnabled = Value
      currentConfig.autoRebirth = Value
      saveConfig()
      
      if autoRebirthEnabled then
          task.spawn(function()
              while autoRebirthEnabled do
                  if not purchasePromptActive then
                      if rebirthEvent then
                           rebirthEvent:FireServer()
                      else
                          Rayfield:Notify({
                              Name = "Ralat",
                              Content = "doRebirthEvent tidak dijumpai di ReplicatedStorage.Events!",
                              Duration = 3
                          })
                          break
                      end
                  end
                  task.wait(0.1)
              end
          end)
      end
   end,
})

-- Butang Beli Kelajuan 1 Automatik
local AutoBuySpeed1Toggle = MainTab:CreateToggle({
   Name = "Auto Beli Kelajuan 1",
   CurrentValue = currentConfig.autoBuySpeed1,
   Callback = function(Value)
      autoBuySpeed1Enabled = Value
      currentConfig.autoBuySpeed1 = Value
      saveConfig()
      
      if autoBuySpeed1Enabled then
          task.spawn(function()
              while autoBuySpeed1Enabled do
                  if not purchasePromptActive then
                      if buySoloEvent then
                          buySoloEvent:FireServer(1)
                      else
                          Rayfield:Notify({
                              Name = "Ralat",
                              Content = "buySoloEvent tidak dijumpai di ReplicatedStorage.Events!",
                              Duration = 3
                          })
                          break
                      end
                  end
                  task.wait(0.1)
              end
          end)
      end
   end,
})

-- Butang Beli Kelajuan 10 Automatik
local AutoBuySpeed10Toggle = MainTab:CreateToggle({
   Name = "Auto Beli Kelajuan 10",
   CurrentValue = currentConfig.autoBuySpeed10,
   Callback = function(Value)
      autoBuySpeed10Enabled = Value
      currentConfig.autoBuySpeed10 = Value
      saveConfig()
      
      if autoBuySpeed10Enabled then
          task.spawn(function()
              while autoBuySpeed10Enabled do
                  if not purchasePromptActive then
                      if buySoloEvent then
                          buySoloEvent:FireServer(10)
                      else
                          Rayfield:Notify({
                              Name = "Ralat",
                              Content = "buySoloEvent tidak dijumpai di ReplicatedStorage.Events!",
                              Duration = 3
                          })
                          break
                      end
                  end
                  task.wait(0.1)
              end
          end)
      end
   end,
})

-- Kotak Input Jumlah Naik Taraf (Keypad)
local UpgradeAmountInput = MainTab:CreateInput({
   Name = "Jumlah Naik Taraf (Papan Kekunci)",
   PlaceholderText = tostring(upgradeAmount),
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local parsedNumber = tonumber(Text)
      if parsedNumber then
          upgradeAmount = parsedNumber
          currentConfig.upgradeAmount = parsedNumber
          saveConfig()
      end
   end,
})

-- Butang Naik Taraf Automatik mengikut Nilai Input
local AutoUpgradeToggle = MainTab:CreateToggle({
   Name = "Auto Naik Taraf (Jumlah Keypad)",
   CurrentValue = currentConfig.autoUpgrade,
   Callback = function(Value)
      autoUpgradeEnabled = Value
      currentConfig.autoUpgrade = Value
      saveConfig()
      
      if autoUpgradeEnabled then
          task.spawn(function()
              while autoUpgradeEnabled do
                  if upgradeCharacterEvent then
                      upgradeCharacterEvent:FireServer(upgradeAmount)
                  else
                      Rayfield:Notify({
                          Name = "Ralat",
                          Content = "upgradeCharacterEvent tidak dijumpai di ReplicatedStorage.Events!",
                          Duration = 3
                      })
                      break
                  end
                  task.wait(0.1)
              end
          end)
      end
   end,
})

-- Butang Naik Taraf Semua Tapak
local AutoUpgradeAllToggle = MainTab:CreateToggle({
   Name = "Auto Naik Taraf Semua (Tapak 1 - Max)",
   CurrentValue = currentConfig.autoUpgradeAll,
   Callback = function(Value)
      autoUpgradeAllEnabled = Value
      currentConfig.autoUpgradeAll = Value
      saveConfig()
      
      if autoUpgradeAllEnabled then
          task.spawn(function()
              while autoUpgradeAllEnabled do
                  if upgradeCharacterEvent then
                      local player = game.Players.LocalPlayer
                      local basesFolder = workspace:FindFirstChild("Bases")
                      local playerBase = nil
                      
                      if basesFolder then
                          local expectedText1 = player.Name .. "'s Base"
                          local expectedText2 = player.Name .. "’s Base"
                          
                          for _, baseModel in ipairs(basesFolder:GetChildren()) do
                              local infoPart = baseModel:FindFirstChild("InfoBasePart")
                              if infoPart then
                                  local surfaceGui = infoPart:FindFirstChildOfClass("SurfaceGui")
                                  if surfaceGui then
                                      local baseNameFrame = surfaceGui:FindFirstChild("BaseName")
                                      if baseNameFrame then
                                          local nameLabel = baseNameFrame:FindFirstChild("Name")
                                          if nameLabel and nameLabel:IsA("TextLabel") and (nameLabel.Text == expectedText1 or nameLabel.Text == expectedText2) then
                                              playerBase = baseModel
                                              break
                                          end
                                      end
                                  end
                              end
                          end
                      end
                      
                      if playerBase then
                          local spotsFolder = playerBase:FindFirstChild("Spots")
                          if spotsFolder then
                              local maxSpot = 0
                              for _, spot in ipairs(spotsFolder:GetChildren()) do
                                  local num = tonumber(spot.Name)
                                  if num and num > maxSpot then
                                      maxSpot = num
                                  end
                              end
                              
                              if maxSpot > 0 then
                                  local args = {}
                                  for i = 1, maxSpot do
                                      table.insert(args, i)
                                  end
                                  upgradeCharacterEvent:FireServer(unpack(args))
                              end
                          end
                      end
                  else
                      Rayfield:Notify({
                          Name = "Ralat",
                          Content = "upgradeCharacterEvent tidak dijumpai di ReplicatedStorage.Events!",
                          Duration = 3
                      })
                      break
                  end
                  task.wait(0.1)
              end
          end)
      end
   end,
})

-- Lompat Server (Server Hop)
local ServerHopButton = MainTab:CreateButton({
   Name = "Lompat Server (Muat Semula Automatik)",
   Callback = function()
      Rayfield:Notify({
          Name = "Sedang Melompat Server",
          Content = "Menyimpan konfigurasi dan mencari server alternatif...",
          Duration = 4
      })
      
      saveConfig()
      
      -- Menyediakan fungsi suntikan skrip untuk teleportasi seterusnya
      local queueTeleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
      if queueTeleport then
          -- Kita hantar skrip gabungan penuh ini semula
          queueTeleport(currentConfig)
      end
      
      local TeleportService = game:GetService("TeleportService")
      local Players = game:GetService("Players")
      
      local success, servers = pcall(function()
          return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
      end)
      
      if success and servers and servers.data then
          for _, server in ipairs(servers.data) do
              if server.playing < server.maxPlayers and server.id ~= game.JobId then
                  TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Players.LocalPlayer)
                  return
              end
          end
      end
      
      TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
   end,
})

-- Teleportasi Zon (Sistem Dropdown)
local zonesFolder = workspace:WaitForChild("Zones", 10)
local zoneNames = {}
local selectedZone = nil

if zonesFolder then
    for _, zone in ipairs(zonesFolder:GetChildren()) do
        if zone:IsA("BasePart") then
            table.insert(zoneNames, zone.Name)
        end
    end
else
    Rayfield:Notify({
        Name = "Amaran",
        Content = "Folder 'Zones' tidak dijumpai di Workspace!",
        Duration = 3,
    })
end

local ZoneDropdown = MainTab:CreateDropdown({
   Name = "Pilih Zon Sasaran",
   Options = zoneNames,
   CurrentOption = {zoneNames[1] or ""},
   MultipleOptions = false,
   Callback = function(Option)
      selectedZone = Option[1]
   end,
})

local TeleportButton = MainTab:CreateButton({
   Name = "Teleport ke Zon Terpilih",
   Callback = function()
      if not selectedZone then
          Rayfield:Notify({Name = "Amaran", Content = "Sila pilih zon terlebih dahulu!", Duration = 3})
          return
      end
      
      local targetPart = zonesFolder:FindFirstChild(selectedZone)
      local player = game.Players.LocalPlayer
      
      if targetPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
          player.Character.HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
      else
          Rayfield:Notify({Name = "Ralat", Content = "Zon sasaran atau Karakter tidak dijumpai.", Duration = 3})
      end
   end,
})

-- Teleport ke Tapak Sendiri
local TeleportBaseButton = MainTab:CreateButton({
   Name = "Teleport ke Tapak Sendiri (Base)",
   Callback = function()
      local player = game.Players.LocalPlayer
      local basesFolder = workspace:FindFirstChild("Bases")
      
      if not basesFolder then
          Rayfield:Notify({Name = "Ralat", Content = "Folder 'Bases' tidak dijumpai di Workspace!", Duration = 3})
          return
      end
      
      local expectedText1 = player.Name .. "'s Base"
      local expectedText2 = player.Name .. "’s Base"
      local baseFound = false
      
      for _, baseModel in ipairs(basesFolder:GetChildren()) do
          local infoPart = baseModel:FindFirstChild("InfoBasePart")
          
          if infoPart then
              local surfaceGui = infoPart:FindFirstChildOfClass("SurfaceGui")
              if surfaceGui then
                  local baseNameFrame = surfaceGui:FindFirstChild("BaseName")
                  if baseNameFrame then
                      local nameLabel = baseNameFrame:FindFirstChild("Name")
                      
                      if nameLabel and nameLabel:IsA("TextLabel") then
                          if nameLabel.Text == expectedText1 or nameLabel.Text == expectedText2 then
                              if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                  player.Character.HumanoidRootPart.CFrame = infoPart.CFrame + Vector3.new(0, 3, 0)
                                  Rayfield:Notify({Name = "Berjaya", Content = "Teleport ke tapak anda berjaya!", Duration = 3})
                                  baseFound = true
                                  break 
                              end
                          end
                      end
                  end
              end
          end
      end
      
      if not baseFound then
          Rayfield:Notify({Name = "Gagal", Content = "Gagal mencari tapak yang sepadan dengan nama anda.", Duration = 3})
      end
   end,
})


-- =============================================================================
-- TAB SPIRITUAL (Ciri-ciri daripada SPIRITUAL.lua)
-- =============================================================================

-- Butang Auto Farm Best (Pertanian Automatik Terbaik)
local AutoFarmBestToggle = SpiritualTab:CreateToggle({
   Name = "Auto Farm Best (Tolak Batu)",
   CurrentValue = currentConfig.autoFarmBest or false,
   Callback = function(Value)
      _G.AutoFarmBest = Value
      currentConfig.autoFarmBest = Value
      saveConfig()
      
      if Value then
          task.spawn(function()
              local Players = game:GetService("Players")
              local Workspace = game:GetService("Workspace")
              local player = Players.LocalPlayer
              local DISTANCE_LIMIT = 20
              local INTERACTION_DELAY = 0.15
              local GAP_DELAY = 0.5
              local HOLD_FINAL_DELAY = 1
              
              local positions = {
                  Vector3.new(1446, 394, 3),
                  Vector3.new(1193, 297, 16),
                  Vector3.new(819, 191, -30),
                  Vector3.new(839, 200, -41)
              }
              local finalDestination = Vector3.new(25, 14, -24)
              
              local function getRootPart()
                  local character = player.Character
                  if character then
                      local humanoid = character:FindFirstChildOfClass("Humanoid")
                      if (humanoid and (humanoid.Health > 0)) then
                          return character:FindFirstChild("HumanoidRootPart")
                      end
                  end
                  return nil
              end
              
              local function findBillboardNearTarget(targetPos, maxDistance)
                  local closestPart = nil
                  local shortestDistance = maxDistance
                  for _, desc in ipairs(Workspace:GetDescendants()) do
                      if ((desc.Name == "Billboard-Part") and desc:IsA("BasePart")) then
                          local distance = (targetPos - desc.Position).Magnitude
                          if (distance < shortestDistance) then
                              shortestDistance = distance
                              closestPart = desc
                          end
                      end
                  end
                  return closestPart
              end
              
              local function fireNearbyPrompts(currentRoot)
                  if not currentRoot then return end
                  for _, prompt in ipairs(Workspace:GetDescendants()) do
                      if (prompt:IsA("ProximityPrompt") and prompt.Enabled) then
                          local promptParent = prompt.Parent
                          local promptPos = (promptParent:IsA("Model") and promptParent:GetModelCFrame().Position) or promptParent.Position 
                          local dist = (currentRoot.Position - promptPos).Magnitude
                          if (dist <= DISTANCE_LIMIT) then
                              pcall(function()
                                  prompt:InputHoldBegin()
                                  task.wait(INTERACTION_DELAY)
                                  fireproximityprompt(prompt)
                                  prompt:InputHoldEnd()
                              end)
                          end
                      end
                  end
              end
              
              while _G.AutoFarmBest do
                  local rootPart = getRootPart()
                  local sequenceTriggered = false
                  if rootPart then
                      for i, targetPos in ipairs(positions) do
                          local foundBillboard = findBillboardNearTarget(targetPos, 100)
                          if foundBillboard then
                              rootPart = getRootPart()
                              if not rootPart then break end
                              sequenceTriggered = true
                              rootPart.CFrame = foundBillboard.CFrame + Vector3.new(0, 3, 0)
                              task.wait(0.05)
                              task.spawn(fireNearbyPrompts, rootPart)
                              task.wait(GAP_DELAY)
                              rootPart = getRootPart()
                              if not rootPart then break end
                              rootPart.CFrame = CFrame.new(finalDestination + Vector3.new(0, 3, 0))
                              task.wait(HOLD_FINAL_DELAY)
                              break
                          end
                      end
                  else
                      task.wait(0.5)
                  end
                  if not sequenceTriggered then
                      task.wait(0.1)
                  end
              end
          end)
      end
   end,
})

-- Butang Auto Collect Cash (Kutip Duit Automatik)
local AutoCollectCashToggle = SpiritualTab:CreateToggle({
   Name = "Auto Kutip Duit (Collect Cash)",
   CurrentValue = currentConfig.autoCollectCash or false,
   Callback = function(Value)
      _G.AutoCollectCash = Value
      currentConfig.autoCollectCash = Value
      saveConfig()
      
      if Value then
          task.spawn(function()
              local player = game.Players.LocalPlayer
              local workspace = game:GetService("Workspace")
              local targetName = "ButtonHitbox"
              local fastWait = 0.01
              
              while _G.AutoCollectCash do
                  local character = player.Character
                  local root = character and character:FindFirstChild("HumanoidRootPart")
                  if root then
                      for _, v in ipairs(workspace:GetDescendants()) do
                          if ((v.Name == targetName) and v:IsA("BasePart")) then
                              firetouchinterest(root, v, 0)
                              firetouchinterest(root, v, 1)
                          end
                      end
                  end
                  task.wait(fastWait)
              end
          end)
      end
   end,
})

-- Butang Auto Upgrade Strength (Naik Taraf Kekuatan Automatik)
local UpgradeStrengthToggle = SpiritualTab:CreateToggle({
   Name = "Auto Naik Taraf Kekuatan (Strength)",
   CurrentValue = currentConfig.upgradeStrength or false,
   Callback = function(Value)
      _G.UpgradeStrength = Value
      currentConfig.upgradeStrength = Value
      saveConfig()
      
      if Value then
          task.spawn(function()
              local args = {1}
              while _G.UpgradeStrength do
                  local ev = game:GetService("ReplicatedStorage"):WaitForChild("Events", 2)
                  local buy = ev and ev:WaitForChild("buySoloEvent", 2)
                  if buy then
                      buy:FireServer(unpack(args))
                  end
                  task.wait(0.1)
              end
          end)
      end
   end,
})

-- Butang Auto Sell (Jual Automatik)
local AutoSellToggle = SpiritualTab:CreateToggle({
   Name = "Auto Jual Karakter (Auto Sell)",
   CurrentValue = currentConfig.autoSell or false,
   Callback = function(Value)
      _G.AutoSell = Value
      currentConfig.autoSell = Value
      saveConfig()
      
      if Value then
          task.spawn(function()
              local events = game:GetService("ReplicatedStorage"):WaitForChild("Events", 2)
              local sellAll = events and events:WaitForChild("sellAllCharactersEvent", 2)
              while _G.AutoSell do
                  if sellAll then
                      sellAll:FireServer()
                  end
                  task.wait(1)
              end
          end)
      end
   end,
})


-- =============================================================================
-- TAB UTILITI (NOCLIP, ESP & LOMPAT TANPA HAD)
-- =============================================================================

local noclipEnabled = false
local espEnabled = false
local infiniteJumpEnabled = false
local activeHighlights = {}

-- Lompat Tanpa Had (Infinite Jump)
local InfiniteJumpToggle = UtilityTab:CreateToggle({
   Name = "Lompat Tanpa Had (Infinite Jump)",
   CurrentValue = currentConfig.infiniteJump,
   Callback = function(Value)
      infiniteJumpEnabled = Value
      currentConfig.infiniteJump = Value
      saveConfig()
   end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
   if infiniteJumpEnabled then
      local character = game.Players.LocalPlayer.Character
      if character then
         local humanoid = character:FindFirstChildOfClass("Humanoid")
         if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
         end
      end
   end
end)

-- Melintasi Dinding (Noclip)
local NoclipToggle = UtilityTab:CreateToggle({
   Name = "Tembus Dinding (Noclip)",
   CurrentValue = currentConfig.noclip,
   Callback = function(Value)
      noclipEnabled = Value
      currentConfig.noclip = Value
      saveConfig()
   end,
})

game:GetService("RunService").Stepped:Connect(function()
   if noclipEnabled then
      local character = game.Players.LocalPlayer.Character
      if character then
         for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
               part.CanCollide = false
            end
         end
      end
   end
end)

-- Sistem Pengesan Pemain (Highlight ESP)
local function applyESP(player)
   if player == game.Players.LocalPlayer then return end
   
   local function createHighlight(character)
      if not espEnabled then return end
      if character:FindFirstChild("ESPHighlight") then return end 
      
      local highlight = Instance.new("Highlight")
      highlight.Name = "ESPHighlight"
      highlight.FillColor = Color3.fromRGB(255, 75, 75)
      highlight.FillTransparency = 0.5
      highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
      highlight.OutlineTransparency = 0
      highlight.Parent = character
      activeHighlights[player] = highlight
   end

   player.CharacterAdded:Connect(createHighlight)
   if player.Character then
      createHighlight(player.Character)
   end
end

local function cleanESP(player)
   if activeHighlights[player] then
      activeHighlights[player]:Destroy()
      activeHighlights[player] = nil
   end
   if player.Character and player.Character:FindFirstChild("ESPHighlight") then
      player.Character.ESPHighlight:Destroy()
   end
end

-- Butang ESP
local EspToggle = UtilityTab:CreateToggle({
   Name = "ESP Pemain (Sorotan / Highlights)",
   CurrentValue = currentConfig.esp,
   Callback = function(Value)
      espEnabled = Value
      currentConfig.esp = Value
      saveConfig()
      if espEnabled then
         for _, player in ipairs(game.Players:GetPlayers()) do
            applyESP(player)
         end
      else
         for _, player in ipairs(game.Players:GetPlayers()) do
            cleanESP(player)
         end
      end
   end,
})

game.Players.PlayerAdded:Connect(applyESP)
game.Players.PlayerRemoving:Connect(cleanESP)

-- Mengeluarkan notifikasi bahawa menu telah berjaya dilancarkan tanpa kunci
Rayfield:Notify({
    Name = "Sistem Bersatu",
    Content = "Semua ciri daripada kedua-dua skrip berjaya digabungkan tanpa sistem kunci!",
    Duration = 5
})
