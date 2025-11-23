-- Laser Cape Auto-Spam Script con BOTÓN

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- RemoteEvent real:
local LaserEvent = RS.Packages.Net.RE.SuperCape.LaserEyes

local SPAM = false
local FIRE_RATE = 0.05 -- 20 disparos/segundo

-----------------------------------------------------------------------
-- Crear botón en pantalla
-----------------------------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 180, 0, 60)
button.Position = UDim2.new(0.05, 0, 0.7, 0)
button.Text = "Laser OFF"
button.Font = Enum.Font.GothamBold
button.TextSize = 24
button.TextColor3 = Color3.fromRGB(255,255,255)
button.BackgroundColor3 = Color3.fromRGB(20,20,20)
button.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = button

button.MouseButton1Click:Connect(function()
    SPAM = not SPAM
    button.Text = SPAM and "Laser ON" or "Laser OFF"
    button.BackgroundColor3 = SPAM and Color3.fromRGB(120,0,0) or Color3.fromRGB(20,20,20)
end)

-----------------------------------------------------------------------
-- Obtener jugador más cercano
-----------------------------------------------------------------------

local function getNearest()
    local nearest, minDist = nil, math.huge

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (pl.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = pl
            end
        end
    end

    return nearest
end

-----------------------------------------------------------------------
-- Loop de disparo automático
-----------------------------------------------------------------------

task.spawn(function()
    while true do
        if SPAM then
            local target = getNearest()
            if target then
                local targetHRP = target.Character.HumanoidRootPart

                local origin = hrp.Position
                local dir = (targetHRP.Position - origin).Unit

                -- FireServer con los 6 argumentos detectados
                LaserEvent:FireServer(
                    origin.X, origin.Y, origin.Z,
                    dir.X, dir.Y, dir.Z
                )
            end
        end
        task.wait(FIRE_RATE)
    end
end)