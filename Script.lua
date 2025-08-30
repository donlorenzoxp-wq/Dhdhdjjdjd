local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "CSP",
   Icon = 0,
   LoadingTitle = "UNIVERSAL CSP",
   LoadingSubtitle = "by csp studio",
   ShowText = "CSP (CAUE SCRIPTS)",
   Theme = "AmberGlow", 
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = True,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "CAUE KEY SYSTEM",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"CSP123"}
   }
})

local Tab = Window:CreateTab("Main Parry", 4483362458)
local Section = Tab:CreateSection("Main")

local Toggle = Tab:CreateToggle({
   Name = "Auto Parry (CSP ON TOP)",
   CurrentValue = false,
   Flag = "getgenv().AutoParry=false",
   Callback = function(Value)
       local RunService = game:GetService("RunService")
       local Players = game:GetService("Players")
       local VirtualInputManager = game:GetService("VirtualInputManager")

       local Player = Players.LocalPlayer

       local Cooldown = tick()
       local IsParried = false
       local Connection = nil

       local function GetBall()
           for _, Ball in ipairs(workspace.Balls:GetChildren()) do
               if Ball:GetAttribute("realBall") then
                   return Ball
               end
           end
       end

       local function ResetConnection()
           if Connection then
               Connection:Disconnect()
               Connection = nil
           end
       end

       workspace.Balls.ChildAdded:Connect(function()
           local Ball = GetBall()
           if not Ball then return end
           ResetConnection()
           Connection = Ball:GetAttributeChangedSignal("target"):Connect(function()
               Parried = false
           end)
       end)

       RunService.PreSimulation:Connect(function()
           local Ball, HRP = GetBall(), Player.Character.HumanoidRootPart
           if not Ball or not HRP then return end

           local Speed = Ball.zoomies.VectorVelocity.Magnitude
           local Distance = (HRP.Position - Ball.Position).Magnitude

           if Ball:GetAttribute("target") == Player.Name and not Parried and Distance / Speed <= 0.65 then
               VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
               Parried = true
               Cooldown = tick()

               if (tick() - Cooldown) >= 1 then
                   Parried = false
               end
           end
       end)
   end,
})

Rayfield:LoadConfiguration()

-- === Sistema de Plataforma Substituindo Noclip/Auto-Steal ===
local Tab2 = Window:CreateTab("Main STEAL A BRAINROT", 4483362458)
local Section2 = Tab2:CreateSection("Main STEAL")

local TogglePlatform = Tab2:CreateToggle({
    Name = "Ativar Plataforma (CSP ON TOP)",
    CurrentValue = false,
    Flag = "PlatformToggle",
    Callback = function(Value)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")

        local LocalPlayer = Players.LocalPlayer
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HRP = Character:WaitForChild("HumanoidRootPart")
        local Humanoid = Character:WaitForChild("Humanoid")

        local Active = Value
        local Platform
        local Connection

        local function createPlatform()
            Platform = Instance.new("Part")
            Platform.Name = "Platform"
            Platform.Size = Vector3.new(5,1,5)
            Platform.Anchored = true
            Platform.CanCollide = true
            Platform.Position = HRP.Position - Vector3.new(0,2.5,0)
            Platform.Parent = workspace
        end

        local function startPlatform()
            createPlatform()
            Connection = RunService.RenderStepped:Connect(function(dt)
                if not Active or not Platform then return end
                local targetPos = HRP.Position - Vector3.new(0,2.5,0)
                Platform.Position = Platform.Position:Lerp(targetPos, 0.5)
            end)
        end

        local function stopPlatform()
            if Connection then
                Connection:Disconnect()
                Connection = nil
            end
            if Platform then
                spawn(function()
                    while Platform.Size.Y > 0.1 do
                        Platform.Size = Platform.Size:Lerp(Vector3.new(5,0.1,5),0.3)
                        Platform.Position = Platform.Position - Vector3.new(0,0.1/2,0)
                        wait(0.03)
                    end
                    Platform:Destroy()
                    Platform = nil
                end)
            end
        end

        if Active then
            startPlatform()
        else
            stopPlatform()
        end
    end,
})

local ButtonDisable = Tab2:CreateButton({
    Name = "Desativar Plataforma",
    Callback = function()
        for _, p in pairs(workspace:GetChildren()) do
            if p.Name == "Platform" then
                spawn(function()
                    while p.Size.Y > 0.1 do
                        p.Size = p.Size:Lerp(Vector3.new(5,0.1,5),0.3)
                        p.Position = p.Position - Vector3.new(0,0.1/2,0)
                        wait(0.03)
                    end
                    p:Destroy()
                end)
            end
        end
        TogglePlatform:Set(false)
    end
})

-- === Roof TP ===
local Tab3 = Window:CreateTab("Roof TP", 4483362458)
local Section3 = Tab3:CreateSection("Sky Platform")

local RoofPlatform
local OriginalY

local ButtonRoof = Tab3:CreateButton({
    Name = "Ativar Roof TP",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HRP = Character:WaitForChild("HumanoidRootPart")

        OriginalY = HRP.Position.Y

        RoofPlatform = Instance.new("Part")
        RoofPlatform.Name = "RoofPlatform"
        RoofPlatform.Size = Vector3.new(10,1,10)
        RoofPlatform.Anchored = true
        RoofPlatform.CanCollide = true
        RoofPlatform.Position = HRP.Position + Vector3.new(0,20,0)
        RoofPlatform.Parent = workspace

        local TweenService = game:GetService("TweenService")
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {CFrame = CFrame.new(RoofPlatform.Position.X, RoofPlatform.Position.Y + 3, RoofPlatform.Position.Z)}
        TweenService:Create(HRP, tweenInfo, goal):Play()
    end
})

local ButtonRoofDisable = Tab3:CreateButton({
    Name = "Desativar Roof",
    Callback = function()
        if RoofPlatform then
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local HRP = Character:WaitForChild("HumanoidRootPart")

            local TweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local goal = {CFrame = CFrame.new(HRP.Position.X, OriginalY, HRP.Position.Z)}
            TweenService:Create(HRP, tweenInfo, goal):Play()

            RoofPlatform:Destroy()
            RoofPlatform = nil
        end
    end
})

Rayfield:LoadConfiguration()
