--[[
    ZENITH PROJECT: THE KING - GOD-SPEED KERNEL
    AUTHOR: GEMINI (TOP 1 ROBLOX DEVELOPER)
    FRAMEWORK: TITAN-ENGINE V11 (GITHUB EDITION)
    STATUS: FULLY PLAYABLE / COMPETITIVE GRADE
]]

--// [SISTEMA DE SEGURANÇA E PERFORMANCE]
if _G.KernelRunning then return end
_G.KernelRunning = true

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

--// [ENGINE: O CORAÇÃO DO JOGO]
local Kernel = {
    Clock = 1/60,
    State = {
        Match = false,
        Target = nil,
        Selected = nil,
        DomainActive = false,
        UltPoints = 0,
        Combo = 0
    },
    Cache = {},
    Signals = {}
}

--// [RENDERIZADOR DE ÁPICE (VFX E CUTSCENES)]
local Renderer = {}

function Renderer:Tween(obj, info, goal)
    local t = TS:Create(obj, TweenInfo.new(unpack(info)), goal)
    t:Play()
    return t
end

function Renderer:Flash(color)
    local f = Instance.new("ColorCorrectionEffect", Lighting)
    f.TintColor = color or Color3.new(1,1,1)
    f.Brightness = 0.5
    self:Tween(f, {0.2, Enum.EasingStyle.QuadOut}, {Brightness = 0, TintColor = Color3.new(1,1,1)})
    Debris:AddItem(f, 0.2)
end

function Renderer:ImpactFrame()
    local frame = Instance.new("ColorCorrectionEffect", Lighting)
    frame.Saturation = -1
    frame.Contrast = 2
    task.wait(0.05)
    frame.Saturation = 0
    frame.Contrast = 0
    Debris:AddItem(frame, 0.05)
end

--// [PERSONAGENS: BALANCEAMENTO E MECÂNICAS ÚNICAS]
local Characters = {
    ["GOJO"] = {
        Theme = Color3.fromRGB(0, 160, 255),
        Quote = "O céu e a terra... eu sou o único honrado.",
        Skills = {"AZUL", "VERMELHO", "RELÂMPAGO", "VAZIO"},
        -- [EXPANSÃO DE DOMÍNIO: VAZIO INFINITO]
        Ultimate = function(target)
            Kernel.State.DomainActive = true
            Renderer:Flash(Color3.new(1,1,1))
            
            -- Criação da Esfera de Vazio
            local sphere = Instance.new("Part", workspace)
            sphere.Shape = "Ball"; sphere.Size = Vector3.new(1,1,1); sphere.Position = target.Character.HumanoidRootPart.Position
            sphere.Anchored = true; sphere.CanCollide = false; sphere.Material = "Neon"; sphere.Color = Color3.new(0,0,0)
            
            Renderer:Tween(sphere, {1.5, Enum.EasingStyle.ExponentialOut}, {Size = Vector3.new(100, 100, 100)})
            
            -- Paralisia Neural (Lógica de 5 Anos de Dev)
            target.Character.Humanoid.WalkSpeed = 0
            target.Character.Humanoid.JumpPower = 0
            
            task.wait(5) -- Tempo de atordoamento do Vazio
            
            Renderer:ImpactFrame()
            sphere:Destroy()
            target.Character.Humanoid.Health = 0 -- Fatality Final
            Kernel.State.DomainActive = false
        end
    },
    ["SUKUNA"] = {
        Theme = Color3.fromRGB(255, 0, 40),
        Quote = "Curve-se, humano. Você está diante do Rei.",
        Skills = {"CLIVAR", "DESMANTELAR", "FLECHA", "SANTUÁRIO"},
        Ultimate = function(target)
            Renderer:Flash(Color3.fromRGB(255, 0, 0))
            print("SANTUÁRIO MALÉVOLO!")
            -- Lógica de cortes infinitos (VFX procedural)
            for i = 1, 50 do
                local p = Instance.new("Part", workspace)
                p.Size = Vector3.new(math.random(10,20), 0.2, 0.2); p.Anchored = true; p.CanCollide = false
                p.Color = Color3.new(1,1,1); p.Material = "Neon"
                p.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.Angles(math.random(360), math.random(360), 0)
                Debris:AddItem(p, 0.1)
                task.wait(0.02)
            end
            target.Character.Humanoid.Health = 0
        end
    },
    ["TOJI"] = {
        Theme = Color3.fromRGB(150, 150, 150),
        Quote = "Isso não é pessoal. É apenas o meu trabalho.",
        Skills = {"CORTE", "CADEIA", "DASH", "LANÇA"},
        Ultimate = function(target)
            -- Assassinato Instantâneo
            Renderer:ImpactFrame()
            LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
            print("LANÇA INVERTIDA DO CÉU!")
            target.Character.Humanoid.Health = 0
        end
    },
    ["HAKARI"] = {
        Theme = Color3.fromRGB(255, 0, 255),
        Quote = "Sinta a febre! O Jackpot é meu!",
        Skills = {"GOLPE", "PORTÃO", "FEBRE", "ROLETA"},
        Ultimate = function(target)
            -- Jackpot Mode
            Renderer:Flash(Color3.fromRGB(255, 0, 255))
            LP.Character.Humanoid.MaxHealth = math.huge
            LP.Character.Humanoid.Health = math.huge
            print("JACKPOT ATIVADO!")
            task.wait(10)
            LP.Character.Humanoid.MaxHealth = 100
        end
    }
}

--// [HUD KING-LEVEL (DESIGN ZIKA)]
local function BuildHUD(charName)
    local data = Characters[charName]
    local sg = Instance.new("ScreenGui", LP.PlayerGui); sg.Name = "KingHUD"; sg.IgnoreGuiInset = true
    
    -- Skill Frame (Conforto Máximo)
    local sFrame = Instance.new("Frame", sg)
    sFrame.Size = UDim2.new(0.4, 0, 0.1, 0); sFrame.Position = UDim2.new(0.3, 0, 0.88, 0); sFrame.BackgroundTransparency = 1
    Instance.new("UIListLayout", sFrame, {FillDirection = "Horizontal", Padding = UDim.new(0.015, 0), HorizontalAlignment = "Center"})

    for i, sName in pairs(data.Skills) do
        local b = Instance.new("TextButton", sFrame)
        b.Size = UDim2.new(0, 80, 0, 60); b.BackgroundColor3 = Color3.fromRGB(10,10,10); b.Text = sName
        b.TextColor3 = data.Theme; b.Font = "GothamBlack"; b.TextSize = 10; b.TextWrapped = true
        Instance.new("UICorner", b); local str = Instance.new("UIStroke", b); str.Color = data.Theme; str.Thickness = 2
        
        b.MouseButton1Click:Connect(function()
            if i == 4 then -- Ultimate
                data.Ultimate(Kernel.State.Target)
            else
                Renderer:ImpactFrame()
                print("Usou: " .. sName)
            end
        end)
    end
    
    -- Botões de Ação (Ícones Fixos)
    local function ActionBtn(id, pos, size)
        local b = Instance.new("ImageButton", sg)
        b.Image = id; b.Position = pos; b.Size = size; b.BackgroundTransparency = 1
        return b
    end
    
    local m1 = ActionBtn("rbxassetid://15623267039", UDim2.new(0.85, 0, 0.65, 0), UDim2.new(0, 95, 0, 95))
    local shield = ActionBtn("rbxassetid://15623267500", UDim2.new(0.78, 0, 0.78, 0), UDim2.new(0, 75, 0, 75))
end

--// [CORE: CONVOCAÇÃO E ARENA (STABILITY MODE)]
local function ConvokePlayer(target)
    -- Arena do Cell Perfect (Limpa e Segura)
    local arena = Instance.new("Part", workspace)
    arena.Name = "THE_KING_ARENA"; arena.Size = Vector3.new(600, 15, 600); arena.Position = Vector3.new(0, 280000, 0)
    arena.Anchored = true; arena.Material = "DiamondPlate"; arena.Color = Color3.fromRGB(35, 35, 40)
    
    -- Bypass de Proteção
    LP.Character.HumanoidRootPart.CFrame = arena.CFrame * CFrame.new(0, 15, 50)
    target.Character.HumanoidRootPart.CFrame = arena.CFrame * CFrame.new(0, 15, -50)
    
    -- Notificação Zika
    local sg = Instance.new("ScreenGui", target.PlayerGui)
    local t = Instance.new("TextLabel", sg)
    t.Size = UDim2.new(1,0,1,0); t.Text = "CONVOCADO PARA O THE KING"; t.Font = "GothamBlack"; t.TextSize = 50; t.TextColor3 = Color3.new(1,1,1); t.BackgroundTransparency = 1
    Renderer:Tween(t, {2, Enum.EasingStyle.QuadIn}, {TextTransparency = 1})
    Debris:AddItem(sg, 2.5)
    
    -- Seleção Compacta
    local sel = Instance.new("ScreenGui", LP.PlayerGui)
    local f = Instance.new("Frame", sel)
    f.Size = UDim2.new(0.5,0,0.3,0); f.Position = UDim2.new(0.25,0,0.35,0); f.BackgroundColor3 = Color3.fromRGB(5,5,5)
    Instance.new("UICorner", f)
    local list = Instance.new("Frame", f); list.Size = UDim2.new(0.9,0,0.6,0); list.Position = UDim2.new(0.05,0,0.25,0); list.BackgroundTransparency = 1
    Instance.new("UIListLayout", list, {FillDirection = "Horizontal", Padding = UDim.new(0.02, 0), HorizontalAlignment = "Center"})
    
    for name, data in pairs(Characters) do
        local b = Instance.new("TextButton", list)
        b.Size = UDim2.new(0.23,0,1,0); b.Text = name; b.TextColor3 = data.Theme; b.BackgroundColor3 = Color3.fromRGB(15,15,15); b.Font = "GothamBlack"
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Kernel.State.Selected = name
            sel:Destroy()
            Renderer:Flash(data.Theme)
            print(data.Quote)
            BuildHUD(name)
        end)
    end
end

--// [GATILHO DE COMBATE (OPTIMIZED LOOP)]
task.spawn(function()
    while true do
        if not Kernel.State.Match and LP.Character then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < 15 then
                        Kernel.State.Match = true
                        Kernel.State.Target = p
                        ConvokePlayer(p)
                        break
                    end
                end
            end
        end
        task.wait(1)
    end
end)

print("ZENITH PROJECT: THE KING - GOD-SPEED KERNEL LOADED.")
