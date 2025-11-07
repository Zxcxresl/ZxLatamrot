-- Zxhub -latamrot (VERSIÓN CORREGIDA)
-- Hub by deep and Zxcx

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Guardar spawn point automáticamente
local SavedSpawnPoint = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0, 0, 0)

-- Actualizar spawn point cuando el jugador respawnea
LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    SavedSpawnPoint = character.HumanoidRootPart.Position
    print("📍 Nuevo spawn point guardado: " .. tostring(SavedSpawnPoint))
end)

-- Configuración
local Config = {
    InstaSteal = false,
    SpeedEnabled = false,
    SpeedValue = 50,
    NoclipEnabled = false,
    PlatformEnabled = false,
    HitboxEnabled = false
}

-- Variables
local PlatformPart = nil
local NoclipConnection = nil
local SpeedConnection = nil
local HitboxConnection = nil

-- Crear UI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZxhubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Marco principal (rectangular alargado hacia abajo)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Rojo
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0) -- Borde negro
MainFrame.BorderSizePixel = 3
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Barra superior con botones
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 6)
TopBarCorner.Parent = TopBar

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Zxhub -latamrot"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Botones de control
local MinimizeButton = Instance.new("TextButton") -- CAMBIADO A TEXTBUTTON
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -60, 0.5, -12.5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
MinimizeButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
MinimizeButton.BorderSizePixel = 2
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0.5, -12.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
CloseButton.BorderSizePixel = 2
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TopBar

-- Contenedor de opciones
local OptionsFrame = Instance.new("ScrollingFrame")
OptionsFrame.Name = "OptionsFrame"
OptionsFrame.Size = UDim2.new(1, -20, 1, -50)
OptionsFrame.Position = UDim2.new(0, 10, 0, 40)
OptionsFrame.BackgroundTransparency = 1
OptionsFrame.ScrollBarThickness = 6
OptionsFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 0, 0)
OptionsFrame.Parent = MainFrame

local OptionsLayout = Instance.new("UIListLayout")
OptionsLayout.Padding = UDim.new(0, 10)
OptionsLayout.Parent = OptionsFrame

-- Footer
local Footer = Instance.new("TextLabel")
Footer.Name = "Footer"
Footer.Size = UDim2.new(1, -20, 0, 20)
Footer.Position = UDim2.new(0, 10, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "hub by deep and Zxcx"
Footer.TextColor3 = Color3.fromRGB(139, 69, 19) -- Café
Footer.TextSize = 12
Footer.Font = Enum.Font.Gotham
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.Parent = MainFrame

-- Círculo flotante (minimizado) - CAMBIADO A TEXTBUTTON
local FloatingCircle = Instance.new("TextButton") -- CAMBIADO DE FRAME A TEXTBUTTON
FloatingCircle.Name = "FloatingCircle"
FloatingCircle.Size = UDim2.new(0, 50, 0, 50)
FloatingCircle.Position = UDim2.new(0, 20, 0, 20)
FloatingCircle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
FloatingCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
FloatingCircle.BorderSizePixel = 3
FloatingCircle.Visible = false
FloatingCircle.Text = "" -- Texto vacío porque usaremos un Label
FloatingCircle.Parent = ScreenGui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = FloatingCircle

local CircleText = Instance.new("TextLabel")
CircleText.Name = "CircleText"
CircleText.Size = UDim2.new(1, 0, 1, 0)
CircleText.BackgroundTransparency = 1
CircleText.Text = "Z"
CircleText.TextColor3 = Color3.fromRGB(255, 255, 255)
CircleText.TextSize = 18
CircleText.Font = Enum.Font.GothamBold
CircleText.Parent = FloatingCircle

-- Función para crear botones de opción
local function CreateOptionButton(name, description)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = name .. "Frame"
    ButtonFrame.Size = UDim2.new(1, 0, 0, 60)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonFrame.BorderSizePixel = 2
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ButtonFrame
    
    local OptionName = Instance.new("TextLabel")
    OptionName.Name = "OptionName"
    OptionName.Size = UDim2.new(0.7, 0, 0, 25)
    OptionName.Position = UDim2.new(0, 10, 0, 5)
    OptionName.BackgroundTransparency = 1
    OptionName.Text = name
    OptionName.TextColor3 = Color3.fromRGB(255, 255, 255)
    OptionName.TextSize = 16
    OptionName.Font = Enum.Font.GothamBold
    OptionName.TextXAlignment = Enum.TextXAlignment.Left
    OptionName.Parent = ButtonFrame
    
    local OptionDesc = Instance.new("TextLabel")
    OptionDesc.Name = "OptionDesc"
    OptionDesc.Size = UDim2.new(0.7, 0, 0, 20)
    OptionDesc.Position = UDim2.new(0, 10, 0, 30)
    OptionDesc.BackgroundTransparency = 1
    OptionDesc.Text = description
    OptionDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    OptionDesc.TextSize = 12
    OptionDesc.Font = Enum.Font.Gotham
    OptionDesc.TextXAlignment = Enum.TextXAlignment.Left
    OptionDesc.Parent = ButtonFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 80, 0, 30)
    ToggleButton.Position = UDim2.new(1, -90, 0.5, -15)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ToggleButton.BorderSizePixel = 2
    ToggleButton.Text = "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 14
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Parent = ButtonFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleButton
    
    ButtonFrame.Parent = OptionsFrame
    return ToggleButton
end

-- Crear opciones
local InstaStealButton = CreateOptionButton("Insta Steal v1", "Teletransporta al spawn point guardado")
local SpeedButton = CreateOptionButton("Speed", "Movimiento rápido usando CFrame")
local NoclipButton = CreateOptionButton("Noclip", "Atraviesa paredes con tween")
local PlatformButton = CreateOptionButton("Platform v1", "Plataforma que sigue tus pies")
local HitboxButton = CreateOptionButton("Hitbox Bat v1", "Hitbox aumentada a 18 con tool")

-- Funcionalidades
-- Insta Steal v1
InstaStealButton.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(SavedSpawnPoint)
        print("✅ Teletransportado al spawn point!")
    end
end)

-- Speed (usando CFrame)
SpeedButton.MouseButton1Click:Connect(function()
    Config.SpeedEnabled = not Config.SpeedEnabled
    
    if Config.SpeedEnabled then
        SpeedButton.Text = "ON"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        SpeedConnection = RunService.Heartbeat:Connect(function(delta)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                local moveDirection = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + Camera.CFrame.RightVector
                end
                
                moveDirection = moveDirection.Unit * Config.SpeedValue * delta
                root.CFrame = root.CFrame + moveDirection
            end
        end)
    else
        SpeedButton.Text = "OFF"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        if SpeedConnection then
            SpeedConnection:Disconnect()
            SpeedConnection = nil
        end
    end
end)

-- Noclip con tween
NoclipButton.MouseButton1Click:Connect(function()
    Config.NoclipEnabled = not Config.NoclipEnabled
    
    if Config.NoclipEnabled then
        NoclipButton.Text = "ON"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        NoclipConnection = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                
                -- Detectar colisión y hacer tween hacia adelante
                local ray = Ray.new(root.Position, root.CFrame.LookVector * 5)
                local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
                
                if hit then
                    -- Tween a través de la pared
                    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear)
                    local goal = {CFrame = root.CFrame + root.CFrame.LookVector * 10}
                    local tween = TweenService:Create(root, tweenInfo, goal)
                    tween:Play()
                end
                
                -- Hacer noclip tradicional también
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        NoclipButton.Text = "OFF"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end
    end
end)

-- Platform v1
PlatformButton.MouseButton1Click:Connect(function()
    Config.PlatformEnabled = not Config.PlatformEnabled
    
    if Config.PlatformEnabled then
        PlatformButton.Text = "ON"
        PlatformButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Crear plataforma
        PlatformPart = Instance.new("Part")
        PlatformPart.Name = "PlayerPlatform"
        PlatformPart.Size = Vector3.new(10, 1, 10)
        PlatformPart.Anchored = true
        PlatformPart.CanCollide = true
        PlatformPart.Material = Enum.Material.Neon
        PlatformPart.BrickColor = BrickColor.new("Bright red")
        PlatformPart.Parent = Workspace
        
        -- Hacer que siga al jugador
        RunService.Heartbeat:Connect(function()
            if PlatformPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                PlatformPart.Position = Vector3.new(root.Position.X, root.Position.Y - 5, root.Position.Z)
            end
        end)
    else
        PlatformButton.Text = "OFF"
        PlatformButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        if PlatformPart then
            PlatformPart:Destroy()
            PlatformPart = nil
        end
    end
end)

-- Hitbox Bat v1
HitboxButton.MouseButton1Click:Connect(function()
    Config.HitboxEnabled = not Config.HitboxEnabled
    
    if Config.HitboxEnabled then
        HitboxButton.Text = "ON"
        HitboxButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        local function expandHitbox(character)
            if character and character:FindFirstChild("HumanoidRootPart") then
                local root = character.HumanoidRootPart
                -- Crear o actualizar hitbox
                local hitbox = root:FindFirstChild("ExpandedHitbox")
                if not hitbox then
                    hitbox = Instance.new("BillboardGui")
                    hitbox.Name = "ExpandedHitbox"
                    hitbox.Size = UDim2.new(18, 0, 18, 0)
                    hitbox.AlwaysOnTop = true
                    hitbox.Adornee = root
                    hitbox.Parent = root
                    
                    local frame = Instance.new("Frame")
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    frame.BackgroundTransparency = 0.7
                    frame.BorderSizePixel = 0
                    frame.Parent = hitbox
                    
                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(1, 0)
                    corner.Parent = frame
                end
            end
        end
        
        HitboxConnection = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                -- Aplicar a todos los jugadores
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        expandHitbox(player.Character)
                    end
                end
            else
                -- Remover hitboxes si no tiene tool
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local hitbox = player.Character.HumanoidRootPart:FindFirstChild("ExpandedHitbox")
                        if hitbox then
                            hitbox:Destroy()
                        end
                    end
                end
            end
        end)
    else
        HitboxButton.Text = "OFF"
        HitboxButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        if HitboxConnection then
            HitboxConnection:Disconnect()
            HitboxConnection = nil
        end
        
        -- Remover todas las hitboxes
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hitbox = player.Character.HumanoidRootPart:FindFirstChild("ExpandedHitbox")
                if hitbox then
                    hitbox:Destroy()
                end
            end
        end
    end
end)

-- Funciones de UI (CORREGIDAS)
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingCircle.Visible = true
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

FloatingCircle.MouseButton1Click:Connect(function()
    FloatingCircle.Visible = false
    MainFrame.Visible = true
end)

-- Hacer UI arrastrable
local dragging = false
local dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Actualizar tamaño del contenedor de opciones
OptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, OptionsLayout.AbsoluteContentSize.Y + 10)
end)

-- Parent final
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

print("🎯 Zxhub -latamrot cargado exitosamente!")
print("📍 Spawn point guardado: " .. tostring(SavedSpawnPoint))
print("🖱️ Click en el círculo 'Z' para restaurar la UI")