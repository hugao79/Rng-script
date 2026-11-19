local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local antigo = PlayerGui:FindFirstChild("GrudarMenu")
if antigo then
	antigo:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "GrudarMenu"
gui.Enabled = true
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local bolinha = Instance.new("TextButton")
bolinha.Name = "Bolinha"
bolinha.Size = UDim2.fromOffset(58, 58)
bolinha.Position = UDim2.fromOffset(16, 110)
bolinha.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
bolinha.AutoButtonColor = false
bolinha.Text = "HUB"
bolinha.TextColor3 = Color3.fromRGB(246, 247, 252)
bolinha.Font = Enum.Font.GothamBold
bolinha.TextSize = 15
bolinha.Visible = true
bolinha.ZIndex = 50
bolinha.Parent = gui

local cornerBolinha = Instance.new("UICorner")
cornerBolinha.CornerRadius = UDim.new(1, 0)
cornerBolinha.Parent = bolinha
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
local gui = PlayerGui and PlayerGui:FindFirstChild("GrudarMenu")
local bolinha = gui and gui:FindFirstChild("Bolinha")
if not (gui and bolinha) then
	return
end

local POS_BOLINHA_PADRAO = UDim2.fromOffset(16, 110)
local POS_MENU_PADRAO = UDim2.fromOffset(80, 60)

local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Size = UDim2.fromOffset(276, 386)
menu.Position = POS_MENU_PADRAO
menu.BackgroundColor3 = Color3.fromRGB(17, 18, 26)
menu.BorderSizePixel = 0
menu.Active = true
menu.Visible = false
menu.ZIndex = 30
menu.Parent = gui
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 14)

local barra = Instance.new("Frame")
barra.Name = "Barra"
barra.Size = UDim2.new(1, 0, 0, 42)
barra.BackgroundColor3 = Color3.fromRGB(29, 31, 43)
barra.BorderSizePixel = 0
barra.Active = true
barra.ZIndex = 31
barra.Parent = menu
Instance.new("UICorner", barra).CornerRadius = UDim.new(0, 14)

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, -56, 1, 0)
titulo.Position = UDim2.fromOffset(14, 0)
titulo.BackgroundTransparency = 1
titulo.Text = "Hub Mobile Apex"
titulo.TextColor3 = Color3.fromRGB(246, 247, 252)
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 15
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.ZIndex = 32
titulo.Parent = barra

local fechar = Instance.new("TextButton")
fechar.Name = "Fechar"
fechar.Size = UDim2.fromOffset(30, 30)
fechar.Position = UDim2.new(1, -38, 0, 6)
fechar.BackgroundColor3 = Color3.fromRGB(205, 65, 65)
fechar.AutoButtonColor = false
fechar.Text = "X"
fechar.TextColor3 = Color3.fromRGB(246, 247, 252)
fechar.Font = Enum.Font.GothamBold
fechar.TextSize = 14
fechar.ZIndex = 32
fechar.Parent = barra
Instance.new("UICorner", fechar).CornerRadius = UDim.new(0, 8)

local faixaStatus = Instance.new("Frame")
faixaStatus.Name = "FaixaStatus"
faixaStatus.Size = UDim2.new(1, -20, 0, 22)
faixaStatus.Position = UDim2.fromOffset(10, 85)
faixaStatus.BackgroundColor3 = Color3.fromRGB(25, 27, 37)
faixaStatus.BorderSizePixel = 0
faixaStatus.ZIndex = 31
faixaStatus.Parent = menu
Instance.new("UICorner", faixaStatus).CornerRadius = UDim.new(0, 6)

local status = Instance.new("TextLabel")
status.Name = "Status"
status.Size = UDim2.new(1, -12, 1, 0)
status.Position = UDim2.fromOffset(6, 0)
status.BackgroundTransparency = 1
status.Text = "Pronto para usar"
status.TextColor3 = Color3.fromRGB(165, 170, 190)
status.Font = Enum.Font.GothamMedium
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextTruncate = Enum.TextTruncate.AtEnd
status.ZIndex = 32
status.Parent = faixaStatus

local NOMES_ABAS = { "TP", "Aim", "ESP", "Speed", "Jump", "Mov", "Cam", "Fun", "FPS", "Util", "UI" }
local barraAbas = Instance.new("ScrollingFrame")
barraAbas.Name = "Abas"
barraAbas.Size = UDim2.new(1, -20, 0, 34)
barraAbas.Position = UDim2.fromOffset(10, 48)
barraAbas.BackgroundTransparency = 1
barraAbas.BorderSizePixel = 0
barraAbas.ScrollBarThickness = 2
barraAbas.ScrollingDirection = Enum.ScrollingDirection.X
barraAbas.CanvasSize = UDim2.fromOffset(#NOMES_ABAS * 50, 0)
barraAbas.ZIndex = 31
barraAbas.Parent = menu

local containers = {}
local botoes = {}

local function selecionarAba(nome)
	for _, n in ipairs(NOMES_ABAS) do
		local ativo = (n == nome)
		containers[n].Visible = ativo
		botoes[n].BackgroundColor3 = ativo and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(43, 46, 63)
		botoes[n].TextColor3 = ativo and Color3.fromRGB(246, 247, 252) or Color3.fromRGB(165, 170, 190)
	end
end

for i, nome in ipairs(NOMES_ABAS) do
	local btn = Instance.new("TextButton")
	btn.Name = "Aba_" .. nome
	btn.Size = UDim2.fromOffset(45, 30)
	btn.Position = UDim2.fromOffset((i - 1) * 50, 2)
	btn.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
	btn.AutoButtonColor = false
	btn.Text = nome
	btn.TextColor3 = Color3.fromRGB(165, 170, 190)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.ZIndex = 32
	btn.Parent = barraAbas
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	botoes[nome] = btn

	local cont = Instance.new("Frame")
	cont.Name = "Conteudo_" .. nome
	cont.Size = UDim2.new(1, -20, 0, 264)
	cont.Position = UDim2.fromOffset(10, 110)
	cont.BackgroundTransparency = 1
	cont.Visible = (nome == "TP")
	cont.ZIndex = 31
	cont.Parent = menu
	containers[nome] = cont

	btn.Activated:Connect(function()
		selecionarAba(nome)
	end)
end

local menuTravado = false
local function tornarArrastavel(alca, alvo, aoToque, checarTrava)
	local arrastando, entrada, inicioToque, inicioPos, moveu = false, nil, nil, nil, false
	alca.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
			arrastando, moveu, entrada, inicioToque, inicioPos = true, false, inp, inp.Position, alvo.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(inp)
		if not arrastando or (checarTrava and menuTravado) then return end
		local ok = (inp == entrada) or (inp.UserInputType == Enum.UserInputType.MouseMovement and entrada.UserInputType == Enum.UserInputType.MouseButton1)
		if not ok then return end
		local d = inp.Position - inicioToque
		if d.Magnitude > 8 then moveu = true end
		local tela, tam = gui.AbsoluteSize, alvo.AbsoluteSize
		alvo.Position = UDim2.fromOffset(
			math.clamp(inicioPos.X.Offset + d.X, 0, math.max(0, tela.X - tam.X)),
			math.clamp(inicioPos.Y.Offset + d.Y, 0, math.max(0, tela.Y - tam.Y))
		)
	end)
	UserInputService.InputEnded:Connect(function(inp)
		if not arrastando then return end
		local ok = (inp == entrada) or (inp.UserInputType == Enum.UserInputType.MouseButton1 and entrada.UserInputType == Enum.UserInputType.MouseButton1)
		if ok then
			arrastando = false
			if not moveu and aoToque then aoToque() end
		end
	end)
end

fechar.Activated:Connect(function() menu.Visible = false end)
tornarArrastavel(barra, menu, nil, true)
tornarArrastavel(bolinha, bolinha, function() menu.Visible = not menu.Visible end, false)
selecionarAba("TP")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
local gui = PlayerGui and PlayerGui:FindFirstChild("GrudarMenu")
local menu = gui and gui:FindFirstChild("Menu")
local contTP = menu and menu:FindFirstChild("Conteudo_TP")
local status = menu and menu:FindFirstChild("FaixaStatus") and menu.FaixaStatus:FindFirstChild("Status")
local bolinha = gui and gui:FindFirstChild("Bolinha")
if not (contTP and status and bolinha) then return end

local busca = Instance.new("TextBox")
busca.Size = UDim2.new(1, 0, 0, 28)
busca.BackgroundColor3 = Color3.fromRGB(25, 27, 37)
busca.BorderSizePixel = 0
busca.PlaceholderText = "Buscar jogador..."
busca.PlaceholderColor3 = Color3.fromRGB(165, 170, 190)
busca.Text = ""
busca.TextColor3 = Color3.fromRGB(246, 247, 252)
busca.Font = Enum.Font.Gotham
busca.TextSize = 12
busca.ClearTextOnFocus = false
busca.Parent = contTP
Instance.new("UICorner", busca).CornerRadius = UDim.new(0, 8)

local lista = Instance.new("ScrollingFrame")
lista.Size = UDim2.new(1, 0, 0, 138)
lista.Position = UDim2.fromOffset(0, 34)
lista.BackgroundColor3 = Color3.fromRGB(29, 31, 43)
lista.BorderSizePixel = 0
lista.ScrollBarThickness = 4
lista.CanvasSize = UDim2.new(0, 0, 0, 0)
lista.AutomaticCanvasSize = Enum.AutomaticSize.Y
lista.Parent = contTP
Instance.new("UICorner", lista).CornerRadius = UDim.new(0, 10)
local layout = Instance.new("UIListLayout", lista)
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.Name

local btnIr = Instance.new("TextButton")
btnIr.Size = UDim2.new(0.48, 0, 0, 38)
btnIr.Position = UDim2.fromOffset(0, 178)
btnIr.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
btnIr.Text = "IR ATÉ ALVO"
btnIr.TextColor3 = Color3.fromRGB(246, 247, 252)
btnIr.Font = Enum.Font.GothamBold
btnIr.TextSize = 11
btnIr.Parent = contTP
Instance.new("UICorner", btnIr).CornerRadius = UDim.new(0, 9)

local btnCostas = Instance.new("TextButton")
btnCostas.Size = UDim2.new(0.49, 0, 0, 38)
btnCostas.Position = UDim2.new(0.51, 0, 0, 178)
btnCostas.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
btnCostas.Text = "COSTAS: OFF"
btnCostas.TextColor3 = Color3.fromRGB(165, 170, 190)
btnCostas.Font = Enum.Font.GothamBold
btnCostas.TextSize = 11
btnCostas.Parent = contTP
Instance.new("UICorner", btnCostas).CornerRadius = UDim.new(0, 9)

local btnCaotico = Instance.new("TextButton")
btnCaotico.Size = UDim2.new(1, 0, 0, 40)
btnCaotico.Position = UDim2.fromOffset(0, 222)
btnCaotico.BackgroundColor3 = Color3.fromRGB(46, 160, 90)
btnCaotico.Text = "ATIVAR TP CAÓTICO"
btnCaotico.TextColor3 = Color3.fromRGB(246, 247, 252)
btnCaotico.Font = Enum.Font.GothamBold
btnCaotico.TextSize = 13
btnCaotico.Parent = contTP
Instance.new("UICorner", btnCaotico).CornerRadius = UDim.new(0, 10)

local selecionado, ativoTP, tpCostas, connTP, botoesPlr = nil, false, false, nil, {}
local function raiz(c) return c and c:FindFirstChild("HumanoidRootPart") end

local function refreshTP()
	local f = string.lower(busca.Text or "")
	for plr, b in pairs(botoesPlr) do
		if b and b.Parent then
			b.Visible = (f == "") or (string.find(string.lower(plr.DisplayName .. " " .. plr.Name), f, 1, true) ~= nil)
			b.BackgroundColor3 = (plr == selecionado) and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(43, 46, 63)
		end
	end
	btnCostas.Text = tpCostas and "COSTAS: ON" or "COSTAS: OFF"
	btnCostas.BackgroundColor3 = tpCostas and Color3.fromRGB(46, 160, 90) or Color3.fromRGB(43, 46, 63)
	btnCaotico.Text = ativoTP and "DESATIVAR TP CAÓTICO" or "ATIVAR TP CAÓTICO"
	btnCaotico.BackgroundColor3 = ativoTP and Color3.fromRGB(205, 65, 65) or Color3.fromRGB(46, 160, 90)
	status.Text = selecionado and ((ativoTP and "Circulando: " or (tpCostas and "Costas: " or "Alvo: ")) .. selecionado.DisplayName) or "Escolha um jogador"
end

local function pararTP()
	ativoTP, tpCostas = false, false
	if connTP then connTP:Disconnect() connTP = nil end
	refreshTP()
end

local function iniciarTP(costas)
	if not selecionado or selecionado.Parent ~= Players then status.Text = "Escolha um jogador!" return end
	pararTP()
	ativoTP, tpCostas = not costas, costas
	local off, ult = Vector3.new(2, 0, 2), os.clock()
	connTP = RunService.Heartbeat:Connect(function()
		local r1, r2 = raiz(LocalPlayer.Character), raiz(selecionado and selecionado.Character)
		if not (r1 and r2) then return end
		if tpCostas then
			r1.CFrame = r2.CFrame * CFrame.new(0, 0, 2.6)
		else
			if os.clock() - ult >= 0.25 then
				ult = os.clock()
				off = Vector3.new(math.random(-3, 3), math.random(-2, 2), math.random(-3, 3))
			end
			r1.CFrame = CFrame.lookAt(r2.Position + off, r2.Position)
		end
	end)
	refreshTP()
end

local function addPlr(plr)
	if plr == LocalPlayer or botoesPlr[plr] then return end
	local b = Instance.new("TextButton")
	b.Name = string.lower(plr.Name)
	b.Size = UDim2.new(1, 0, 0, 30)
	b.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
	b.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
	b.TextColor3 = Color3.fromRGB(246, 247, 252)
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.Parent = lista
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	botoesPlr[plr] = b
	b.Activated:Connect(function() selecionado = plr refreshTP() end)
end

busca:GetPropertyChangedSignal("Text"):Connect(refreshTP)
btnIr.Activated:Connect(function()
	local r1, r2 = raiz(LocalPlayer.Character), raiz(selecionado and selecionado.Character)
	if r1 and r2 then r1.CFrame = r2.CFrame * CFrame.new(0, 0, 3) end
end)
btnCostas.Activated:Connect(function() if tpCostas then pararTP() else iniciarTP(true) end end)
btnCaotico.Activated:Connect(function() if ativoTP then pararTP() else iniciarTP(false) end end)
for _, p in ipairs(Players:GetPlayers()) do addPlr(p) end
Players.PlayerAdded:Connect(addPlr)
Players.PlayerRemoving:Connect(function(p) if botoesPlr[p] then botoesPlr[p]:Destroy() botoesPlr[p] = nil end if selecionado == p then selecionado = nil pararTP() end end)
refreshTP()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
local gui = PlayerGui and PlayerGui:FindFirstChild("GrudarMenu")
local menu = gui and gui:FindFirstChild("Menu")
local contAim = menu and menu:FindFirstChild("Conteudo_Aim")
local status = menu and menu:FindFirstChild("FaixaStatus") and menu.FaixaStatus:FindFirstChild("Status")
if not (contAim and status) then return end

local suav, filtroTela, cabeca, aimAuto, connAim = 14, true, true, false, nil

local lblSuav = Instance.new("TextLabel")
lblSuav.Size = UDim2.new(1, 0, 0, 26)
lblSuav.BackgroundColor3 = Color3.fromRGB(29, 31, 43)
lblSuav.Text = "Suavidade da Mira: 14"
lblSuav.TextColor3 = Color3.fromRGB(246, 247, 252)
lblSuav.Font = Enum.Font.GothamBold
lblSuav.TextSize = 12
lblSuav.Parent = contAim
Instance.new("UICorner", lblSuav).CornerRadius = UDim.new(0, 8)

local btnMenos = Instance.new("TextButton")
btnMenos.Size = UDim2.new(0.48, 0, 0, 34)
btnMenos.Position = UDim2.fromOffset(0, 32)
btnMenos.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
btnMenos.Text = "- Mais Suave"
btnMenos.TextColor3 = Color3.fromRGB(246, 247, 252)
btnMenos.Font = Enum.Font.GothamBold
btnMenos.TextSize = 11
btnMenos.Parent = contAim
Instance.new("UICorner", btnMenos).CornerRadius = UDim.new(0, 8)

local btnMais = Instance.new("TextButton")
btnMais.Size = UDim2.new(0.49, 0, 0, 34)
btnMais.Position = UDim2.new(0.51, 0, 0, 32)
btnMais.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
btnMais.Text = "+ Mais Firme"
btnMais.TextColor3 = Color3.fromRGB(246, 247, 252)
btnMais.Font = Enum.Font.GothamBold
btnMais.TextSize = 11
btnMais.Parent = contAim
Instance.new("UICorner", btnMais).CornerRadius = UDim.new(0, 8)

local btnFiltro = Instance.new("TextButton")
btnFiltro.Size = UDim2.new(1, 0, 0, 38)
btnFiltro.Position = UDim2.fromOffset(0, 74)
btnFiltro.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
btnFiltro.Text = "PRIORIDADE: TELA (FOV)"
btnFiltro.TextColor3 = Color3.fromRGB(56, 189, 248)
btnFiltro.Font = Enum.Font.GothamBold
btnFiltro.TextSize = 11
btnFiltro.Parent = contAim
Instance.new("UICorner", btnFiltro).CornerRadius = UDim.new(0, 9)

local btnParte = Instance.new("TextButton")
btnParte.Size = UDim2.new(1, 0, 0, 38)
btnParte.Position = UDim2.fromOffset(0, 118)
btnParte.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
btnParte.Text = "ALVO: CABEÇA (HEAD)"
btnParte.TextColor3 = Color3.fromRGB(215, 165, 40)
btnParte.Font = Enum.Font.GothamBold
btnParte.TextSize = 11
btnParte.Parent = contAim
Instance.new("UICorner", btnParte).CornerRadius = UDim.new(0, 9)

local btnAim = Instance.new("TextButton")
btnAim.Size = UDim2.new(1, 0, 0, 44)
btnAim.Position = UDim2.fromOffset(0, 164)
btnAim.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
btnAim.Text = "MIRA AUTOMÁTICA: OFF"
btnAim.TextColor3 = Color3.fromRGB(165, 170, 190)
btnAim.Font = Enum.Font.GothamBold
btnAim.TextSize = 12
btnAim.Parent = contAim
Instance.new("UICorner", btnAim).CornerRadius = UDim.new(0, 10)

local function pontoAlvo(char)
	if not char then return nil end
	local p = cabeca and char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
	return p and p.Position
end

local function melhorAlvo(cam)
	local melhor, score = nil, math.huge
	local centro = Vector2.new(cam.ViewportSize.X * 0.5, cam.ViewportSize.Y * 0.5)
	local minhaRaiz = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			local pt = pontoAlvo(plr.Character)
			if hum and hum.Health > 0 and pt then
				if filtroTela then
					local pos, vis = cam:WorldToViewportPoint(pt)
					if vis and pos.Z > 0 then
						local d = (Vector2.new(pos.X, pos.Y) - centro).Magnitude
						if d < score then score, melhor = d, pt end
					end
				elseif minhaRaiz then
					local d = (minhaRaiz.Position - pt).Magnitude
					if d < score then score, melhor = d, pt end
				end
			end
		end
	end
	return melhor
end

local function syncAim()
	lblSuav.Text = "Suavidade da Mira: " .. tostring(suav)
	btnFiltro.Text = filtroTela and "PRIORIDADE: TELA (FOV)" or "PRIORIDADE: DISTÂNCIA"
	btnParte.Text = cabeca and "ALVO: CABEÇA (HEAD)" or "ALVO: TORSO (ROOT)"
	btnAim.Text = aimAuto and "MIRA AUTOMÁTICA: ON" or "MIRA AUTOMÁTICA: OFF"
	btnAim.BackgroundColor3 = aimAuto and Color3.fromRGB(46, 160, 90) or Color3.fromRGB(43, 46, 63)
	btnAim.TextColor3 = aimAuto and Color3.fromRGB(246, 247, 252) or Color3.fromRGB(165, 170, 190)
end

btnMenos.Activated:Connect(function() suav = math.clamp(suav - 2, 2, 40) syncAim() end)
btnMais.Activated:Connect(function() suav = math.clamp(suav + 2, 2, 40) syncAim() end)
btnFiltro.Activated:Connect(function() filtroTela = not filtroTela syncAim() end)
btnParte.Activated:Connect(function() cabeca = not cabeca syncAim() end)
btnAim.Activated:Connect(function()
	aimAuto = not aimAuto
	if aimAuto and not connAim then
		connAim = RunService.RenderStepped:Connect(function(dt)
			local cam = Workspace.CurrentCamera
			if not (aimAuto and cam) then return end
			local pt = melhorAlvo(cam)
			if pt then
				cam.CFrame = cam.CFrame:Lerp(CFrame.lookAt(cam.CFrame.Position, pt), math.clamp(suav * dt, 0.05, 1))
			end
		end)
	elseif not aimAuto and connAim then
		connAim:Disconnect() connAim = nil
	end
	syncAim()
	status.Text = aimAuto and "Mira automática ligada" or "Mira automática desligada"
end)
syncAim()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
local gui = PlayerGui and PlayerGui:FindFirstChild("GrudarMenu")
local menu = gui and gui:FindFirstChild("Menu")
local contESP = menu and menu:FindFirstChild("Conteudo_ESP")
if not contESP then return end

local espOn, hlOn, tags, hls, connEsp = false, false, {}, {}, nil

local btnEsp = Instance.new("TextButton")
btnEsp.Size = UDim2.new(1, 0, 0, 44)
btnEsp.Position = UDim2.fromOffset(0, 8)
btnEsp.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
btnEsp.Text = "ESP TEXTO + HP: OFF"
btnEsp.TextColor3 = Color3.fromRGB(165, 170, 190)
btnEsp.Font = Enum.Font.GothamBold
btnEsp.TextSize = 12
btnEsp.Parent = contESP
Instance.new("UICorner", btnEsp).CornerRadius = UDim.new(0, 10)

local btnHl = Instance.new("TextButton")
btnHl.Size = UDim2.new(1, 0, 0, 44)
btnHl.Position = UDim2.fromOffset(0, 62)
btnHl.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
btnHl.Text = "CONTORNO JOGADORES: OFF"
btnHl.TextColor3 = Color3.fromRGB(165, 170, 190)
btnHl.Font = Enum.Font.GothamBold
btnHl.TextSize = 12
btnHl.Parent = contESP
Instance.new("UICorner", btnHl).CornerRadius = UDim.new(0, 10)

local function limparESP()
	for plr, bb in pairs(tags) do if bb and bb.Parent then bb:Destroy() end tags[plr] = nil end
	for plr, hl in pairs(hls) do if hl and hl.Parent then hl:Destroy() end hls[plr] = nil end
end

local function rebuildESP()
	limparESP()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local head = plr.Character:FindFirstChild("Head")
			if espOn and head then
				local bb = Instance.new("BillboardGui")
				bb.Size = UDim2.fromOffset(170, 42)
				bb.StudsOffset = Vector3.new(0, 2.8, 0)
				bb.AlwaysOnTop = true
				bb.Parent = head
				local tl = Instance.new("TextLabel")
				tl.Size = UDim2.fromScale(1, 1)
				tl.BackgroundTransparency = 1
				tl.TextColor3 = Color3.fromRGB(246, 247, 252)
				tl.TextStrokeTransparency = 0.35
				tl.Font = Enum.Font.GothamBold
				tl.TextSize = 11
				tl.Text = plr.DisplayName .. "\n(@" .. plr.Name .. ")"
				tl.Parent = bb
				tags[plr] = bb
			end
			if hlOn then
				local hl = Instance.new("Highlight")
				hl.FillColor = Color3.fromRGB(88, 101, 242)
				hl.OutlineColor = Color3.fromRGB(246, 247, 252)
				hl.FillTransparency = 0.65
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Adornee = plr.Character
				hl.Parent = plr.Character
				hls[plr] = hl
			end
		end
	end
end

local function syncESP()
	btnEsp.Text = espOn and "ESP TEXTO + HP: ON" or "ESP TEXTO + HP: OFF"
	btnEsp.BackgroundColor3 = espOn and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(43, 46, 63)
	btnEsp.TextColor3 = espOn and Color3.fromRGB(246, 247, 252) or Color3.fromRGB(165, 170, 190)
	btnHl.Text = hlOn and "CONTORNO JOGADORES: ON" or "CONTORNO JOGADORES: OFF"
	btnHl.BackgroundColor3 = hlOn and Color3.fromRGB(215, 165, 40) or Color3.fromRGB(43, 46, 63)
	btnHl.TextColor3 = hlOn and Color3.fromRGB(17, 18, 26) or Color3.fromRGB(165, 170, 190)
	rebuildESP()
	if (espOn or hlOn) and not connEsp then
		connEsp = RunService.RenderStepped:Connect(function()
			local r1 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			for plr, bb in pairs(tags) do
				local tl = bb and bb:FindFirstChildOfClass("TextLabel")
				local r2 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
				if tl and r1 and r2 and hum then
					tl.Text = string.format("%s (@%s)\n%dm | HP %d", plr.DisplayName, plr.Name, math.floor((r1.Position - r2.Position).Magnitude), math.floor(hum.Health))
				end
			end
		end)
	elseif not (espOn or hlOn) and connEsp then
		connEsp:Disconnect() connEsp = nil
	end
end

btnEsp.Activated:Connect(function() espOn = not espOn syncESP() end)
btnHl.Activated:Connect(function() hlOn = not hlOn syncESP() end)
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(0.2) if espOn or hlOn then rebuildESP() end end) end)
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then p.CharacterAdded:Connect(function() task.wait(0.2) if espOn or hlOn then rebuildESP() end end) end end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
local gui = PlayerGui and PlayerGui:FindFirstChild("GrudarMenu")
local menu = gui and gui:FindFirstChild("Menu")
local contSpeed = menu and menu:FindFirstChild("Conteudo_Speed")
local contJump = menu and menu:FindFirstChild("Conteudo_Jump")
if not (contSpeed and contJump) then return end

local vel, speedOn, cfOn, connSp = 32, false, false, nil
local lblVel = Instance.new("TextLabel")
lblVel.Size = UDim2.new(1, 0, 0, 28)
lblVel.BackgroundColor3 = Color3.fromRGB(29, 31, 43)
lblVel.Text = "Velocidade: 32"
lblVel.TextColor3 = Color3.fromRGB(246, 247, 252)
lblVel.Font = Enum.Font.GothamBold
lblVel.TextSize = 13
lblVel.Parent = contSpeed
Instance.new("UICorner", lblVel).CornerRadius = UDim.new(0, 8)

local bMenosV = Instance.new("TextButton")
bMenosV.Size = UDim2.new(0.48, 0, 0, 34)
bMenosV.Position = UDim2.fromOffset(0, 34)
bMenosV.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
bMenosV.Text = "- Menos"
bMenosV.TextColor3 = Color3.fromRGB(246, 247, 252)
bMenosV.Font = Enum.Font.GothamBold
bMenosV.TextSize = 12
bMenosV.Parent = contSpeed
Instance.new("UICorner", bMenosV).CornerRadius = UDim.new(0, 8)

local bMaisV = Instance.new("TextButton")
bMaisV.Size = UDim2.new(0.49, 0, 0, 34)
bMaisV.Position = UDim2.new(0.51, 0, 0, 34)
bMaisV.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
bMaisV.Text = "+ Mais"
bMaisV.TextColor3 = Color3.fromRGB(246, 247, 252)
bMaisV.Font = Enum.Font.GothamBold
bMaisV.TextSize = 12
bMaisV.Parent = contSpeed
Instance.new("UICorner", bMaisV).CornerRadius = UDim.new(0, 8)

local bSpeed = Instance.new("TextButton")
bSpeed.Size = UDim2.new(1, 0, 0, 42)
bSpeed.Position = UDim2.fromOffset(0, 76)
bSpeed.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
bSpeed.Text = "WALKSPEED: OFF"
bSpeed.TextColor3 = Color3.fromRGB(165, 170, 190)
bSpeed.Font = Enum.Font.GothamBold
bSpeed.TextSize = 12
bSpeed.Parent = contSpeed
Instance.new("UICorner", bSpeed).CornerRadius = UDim.new(0, 10)

local bCf = Instance.new("TextButton")
bCf.Size = UDim2.new(1, 0, 0, 42)
bCf.Position = UDim2.fromOffset(0, 126)
bCf.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
bCf.Text = "CFRAME SPEED: OFF"
bCf.TextColor3 = Color3.fromRGB(165, 170, 190)
bCf.Font = Enum.Font.GothamBold
bCf.TextSize = 12
bCf.Parent = contSpeed
Instance.new("UICorner", bCf).CornerRadius = UDim.new(0, 10)

local function syncSpeed()
	lblVel.Text = "Velocidade: " .. tostring(vel)
	bSpeed.Text = speedOn and "WALKSPEED: ON" or "WALKSPEED: OFF"
	bSpeed.BackgroundColor3 = speedOn and Color3.fromRGB(46, 160, 90) or Color3.fromRGB(43, 46, 63)
	bCf.Text = cfOn and "CFRAME SPEED: ON" or "CFRAME SPEED: OFF"
	bCf.BackgroundColor3 = cfOn and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(43, 46, 63)
	if (speedOn or cfOn) and not connSp then
		connSp = RunService.Heartbeat:Connect(function(dt)
			local c = LocalPlayer.Character
			local h = c and c:FindFirstChildOfClass("Humanoid")
			local r = c and c:FindFirstChild("HumanoidRootPart")
			if not h then return end
			if speedOn then h.WalkSpeed = vel end
			if cfOn and r and h.MoveDirection.Magnitude > 0 then
				r.CFrame = r.CFrame + (h.MoveDirection * math.max(0, vel - 16) * dt)
			end
		end)
	elseif not (speedOn or cfOn) and connSp then
		connSp:Disconnect() connSp = nil
		local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = 16 end
	end
end

bMenosV.Activated:Connect(function() vel = math.clamp(vel - 4, 8, 150) syncSpeed() end)
bMaisV.Activated:Connect(function() vel = math.clamp(vel + 4, 8, 150) syncSpeed() end)
bSpeed.Activated:Connect(function() speedOn = not speedOn syncSpeed() end)
bCf.Activated:Connect(function() cfOn = not cfOn syncSpeed() end)

local pulo, jumpOn, infOn, connJ = 100, false, false, nil
local lblPulo = Instance.new("TextLabel")
lblPulo.Size = UDim2.new(1, 0, 0, 28)
lblPulo.BackgroundColor3 = Color3.fromRGB(29, 31, 43)
lblPulo.Text = "Força do pulo: 100"
lblPulo.TextColor3 = Color3.fromRGB(246, 247, 252)
lblPulo.Font = Enum.Font.GothamBold
lblPulo.TextSize = 13
lblPulo.Parent = contJump
Instance.new("UICorner", lblPulo).CornerRadius = UDim.new(0, 8)

local bMenosJ = Instance.new("TextButton")
bMenosJ.Size = UDim2.new(0.48, 0, 0, 34)
bMenosJ.Position = UDim2.fromOffset(0, 34)
bMenosJ.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
bMenosJ.Text = "- Menos"
bMenosJ.TextColor3 = Color3.fromRGB(246, 247, 252)
bMenosJ.Font = Enum.Font.GothamBold
bMenosJ.TextSize = 12
bMenosJ.Parent = contJump
Instance.new("UICorner", bMenosJ).CornerRadius = UDim.new(0, 8)

local bMaisJ = Instance.new("TextButton")
bMaisJ.Size = UDim2.new(0.49, 0, 0, 34)
bMaisJ.Position = UDim2.new(0.51, 0, 0, 34)
bMaisJ.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
bMaisJ.Text = "+ Aumentar"
bMaisJ.TextColor3 = Color3.fromRGB(246, 247, 252)
bMaisJ.Font = Enum.Font.GothamBold
bMaisJ.TextSize = 12
bMaisJ.Parent = contJump
Instance.new("UICorner", bMaisJ).CornerRadius = UDim.new(0, 8)

local bJump = Instance.new("TextButton")
bJump.Size = UDim2.new(1, 0, 0, 42)
bJump.Position = UDim2.fromOffset(0, 76)
bJump.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
bJump.Text = "SUPER JUMP: OFF"
bJump.TextColor3 = Color3.fromRGB(165, 170, 190)
bJump.Font = Enum.Font.GothamBold
bJump.TextSize = 12
bJump.Parent = contJump
Instance.new("UICorner", bJump).CornerRadius = UDim.new(0, 10)

local bInf = Instance.new("TextButton")
bInf.Size = UDim2.new(1, 0, 0, 42)
bInf.Position = UDim2.fromOffset(0, 126)
bInf.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
bInf.Text = "PULO INFINITO: OFF"
bInf.TextColor3 = Color3.fromRGB(165, 170, 190)
bInf.Font = Enum.Font.GothamBold
bInf.TextSize = 12
bInf.Parent = contJump
Instance.new("UICorner", bInf).CornerRadius = UDim.new(0, 10)

local function syncJump()
	lblPulo.Text = "Força do pulo: " .. tostring(pulo)
	bJump.Text = jumpOn and "SUPER JUMP: ON" or "SUPER JUMP: OFF"
	bJump.BackgroundColor3 = jumpOn and Color3.fromRGB(46, 160, 90) or Color3.fromRGB(43, 46, 63)
	bInf.Text = infOn and "PULO INFINITO: ON" or "PULO INFINITO: OFF"
	bInf.BackgroundColor3 = infOn and Color3.fromRGB(46, 160, 90) or Color3.fromRGB(43, 46, 63)
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h then h.UseJumpPower = true h.JumpPower = jumpOn and pulo or 50 end
end

bMenosJ.Activated:Connect(function() pulo = math.clamp(pulo - 10, 10, 250) syncJump() end)
bMaisJ.Activated:Connect(function() pulo = math.clamp(pulo + 10, 10, 250) syncJump() end)
bJump.Activated:Connect(function() jumpOn = not jumpOn syncJump() end)
bInf.Activated:Connect(function()
	infOn = not infOn
	if infOn and not connJ then
		connJ = UserInputService.JumpRequest:Connect(function()
			local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if infOn and h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
		end)
	elseif not infOn and connJ then
		connJ:Disconnect() connJ = nil
	end
	syncJump()
end)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
local gui = PlayerGui and PlayerGui:FindFirstChild("GrudarMenu")
local menu = gui and gui:FindFirstChild("Menu")
local contMov = menu and menu:FindFirstChild("Conteudo_Mov")
local contCam = menu and menu:FindFirstChild("Conteudo_Cam")
if not (contMov and contCam) then return end

local flyOn, flyVel, connFly, bg, bv = false, 55, nil, nil, nil
local bFly = Instance.new("TextButton")
bFly.Size = UDim2.new(1, 0, 0, 40)
bFly.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
bFly.Text = "FLY MOBILE: OFF"
bFly.TextColor3 = Color3.fromRGB(165, 170, 190)
bFly.Font = Enum.Font.GothamBold
bFly.TextSize = 12
bFly.Parent = contMov
Instance.new("UICorner", bFly).CornerRadius = UDim.new(0, 9)

local noclipOn, connNc = false, nil
local bNc = Instance.new("TextButton")
bNc.Size = UDim2.new(1, 0, 0, 40)
bNc.Position = UDim2.fromOffset(0, 48)
bNc.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
bNc.Text = "NOCLIP: OFF"
bNc.TextColor3 = Color3.fromRGB(165, 170, 190)
bNc.Font = Enum.Font.GothamBold
bNc.TextSize = 12
bNc.Parent = contMov
Instance.new("UICorner", bNc).CornerRadius = UDim.new(0, 9)

local gravOn, gravVal = false, 75
local bGrav = Instance.new("TextButton")
bGrav.Size = UDim2.new(1, 0, 0, 40)
bGrav.Position = UDim2.fromOffset(0, 96)
bGrav.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
bGrav.Text = "GRAVIDADE 75: OFF"
bGrav.TextColor3 = Color3.fromRGB(165, 170, 190)
bGrav.Font = Enum.Font.GothamBold
bGrav.TextSize = 12
bGrav.Parent = contMov
Instance.new("UICorner", bGrav).CornerRadius = UDim.new(0, 9)

local function stopFly()
	flyOn = false
	if connFly then connFly:Disconnect() connFly = nil end
	if bg then bg:Destroy() bg = nil end
	if bv then bv:Destroy() bv = nil end
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h then h.PlatformStand = false end
	bFly.Text = "FLY MOBILE: OFF"
	bFly.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
end

bFly.Activated:Connect(function()
	if flyOn then stopFly() return end
	local c = LocalPlayer.Character
	local r = c and c:FindFirstChild("HumanoidRootPart")
	local h = c and c:FindFirstChildOfClass("Humanoid")
	if not (r and h) then return end
	flyOn = true h.PlatformStand = true
	bg = Instance.new("BodyGyro", r) bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9) bg.P = 9e4
	bv = Instance.new("BodyVelocity", r) bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bFly.Text = "FLY MOBILE: ON" bFly.BackgroundColor3 = Color3.fromRGB(46, 160, 90)
	connFly = RunService.RenderStepped:Connect(function()
		local cam = Workspace.CurrentCamera
		if not (flyOn and r.Parent and h.Parent and cam and bg and bv) then stopFly() return end
		bg.CFrame = cam.CFrame
		bv.Velocity = (h.MoveDirection.Magnitude > 0) and (cam.CFrame.LookVector * h.MoveDirection:Dot(Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit) + cam.CFrame.RightVector * h.MoveDirection:Dot(Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z).Unit)).Unit * flyVel or Vector3.zero
	end)
end)

bNc.Activated:Connect(function()
	noclipOn = not noclipOn
	bNc.Text = noclipOn and "NOCLIP: ON" or "NOCLIP: OFF"
	bNc.BackgroundColor3 = noclipOn and Color3.fromRGB(46, 160, 90) or Color3.fromRGB(43, 46, 63)
	if noclipOn and not connNc then
		connNc = RunService.Stepped:Connect(function()
			if noclipOn and LocalPlayer.Character then
				for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
			end
		end)
	elseif not noclipOn and connNc then connNc:Disconnect() connNc = nil end
end)

bGrav.Activated:Connect(function()
	gravOn = not gravOn
	Workspace.Gravity = gravOn and gravVal or 196.2
	bGrav.Text = gravOn and "GRAVIDADE 75: ON" or "GRAVIDADE 75: OFF"
	bGrav.BackgroundColor3 = gravOn and Color3.fromRGB(46, 160, 90) or Color3.fromRGB(43, 46, 63)
end)

local fbOn, fovOn, connCam = false, false, nil
local bFb = Instance.new("TextButton")
bFb.Size = UDim2.new(1, 0, 0, 42)
bFb.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
bFb.Text = "FULLBRIGHT: OFF"
bFb.TextColor3 = Color3.fromRGB(165, 170, 190)
bFb.Font = Enum.Font.GothamBold
bFb.TextSize = 12
bFb.Parent = contCam
Instance.new("UICorner", bFb).CornerRadius = UDim.new(0, 10)

local bFov = Instance.new("TextButton")
bFov.Size = UDim2.new(1, 0, 0, 42)
bFov.Position = UDim2.fromOffset(0, 50)
bFov.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
bFov.Text = "FOV 95: OFF"
bFov.TextColor3 = Color3.fromRGB(165, 170, 190)
bFov.Font = Enum.Font.GothamBold
bFov.TextSize = 12
bFov.Parent = contCam
Instance.new("UICorner", bFov).CornerRadius = UDim.new(0, 10)

local function syncCam()
	bFb.Text = fbOn and "FULLBRIGHT: ON" or "FULLBRIGHT: OFF"
	bFb.BackgroundColor3 = fbOn and Color3.fromRGB(215, 165, 40) or Color3.fromRGB(43, 46, 63)
	bFov.Text = fovOn and "FOV 95: ON" or "FOV 95: OFF"
	bFov.BackgroundColor3 = fovOn and Color3.fromRGB(46, 160, 90) or Color3.fromRGB(43, 46, 63)
	if (fbOn or fovOn) and not connCam then
		connCam = RunService.RenderStepped:Connect(function()
			if fbOn then Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.FogEnd = 100000 end
			if fovOn and Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView = 95 end
		end)
	elseif not (fbOn or fovOn) and connCam then
		connCam:Disconnect() connCam = nil
		if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView = 70 end
	end
end

bFb.Activated:Connect(function() fbOn = not fbOn syncCam() end)
bFov.Activated:Connect(function() fovOn = not fovOn syncCam() end)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
local gui = PlayerGui and PlayerGui:FindFirstChild("GrudarMenu")
local menu = gui and gui:FindFirstChild("Menu")
local bolinha = gui and gui:FindFirstChild("Bolinha")
local contFun = menu and menu:FindFirstChild("Conteudo_Fun")
local contFPS = menu and menu:FindFirstChild("Conteudo_FPS")
local contUtil = menu and menu:FindFirstChild("Conteudo_Util")
local contUI = menu and menu:FindFirstChild("Conteudo_UI")
if not (bolinha and contFun and contFPS and contUtil and contUI) then return end

local spinOn, connSpn = false, nil
local bSpin = Instance.new("TextButton")
bSpin.Size = UDim2.new(1, 0, 0, 42)
bSpin.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
bSpin.Text = "SPIN BONECO: OFF"
bSpin.TextColor3 = Color3.fromRGB(165, 170, 190)
bSpin.Font = Enum.Font.GothamBold
bSpin.TextSize = 12
bSpin.Parent = contFun
Instance.new("UICorner", bSpin).CornerRadius = UDim.new(0, 10)

local bSentar = Instance.new("TextButton")
bSentar.Size = UDim2.new(1, 0, 0, 42)
bSentar.Position = UDim2.fromOffset(0, 50)
bSentar.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
bSentar.Text = "SENTAR / LEVANTAR"
bSentar.TextColor3 = Color3.fromRGB(246, 247, 252)
bSentar.Font = Enum.Font.GothamBold
bSentar.TextSize = 12
bSentar.Parent = contFun
Instance.new("UICorner", bSentar).CornerRadius = UDim.new(0, 10)

bSpin.Activated:Connect(function()
	spinOn = not spinOn
	bSpin.Text = spinOn and "SPIN BONECO: ON" or "SPIN BONECO: OFF"
	bSpin.BackgroundColor3 = spinOn and Color3.fromRGB(46, 160, 90) or Color3.fromRGB(43, 46, 63)
	if spinOn and not connSpn then
		connSpn = RunService.Heartbeat:Connect(function(dt)
			local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if spinOn and r then r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(600 * dt), 0) end
		end)
	elseif not spinOn and connSpn then connSpn:Disconnect() connSpn = nil end
end)
bSentar.Activated:Connect(function()
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h then h.Sit = not h.Sit end
end)

local bFps = Instance.new("TextButton")
bFps.Size = UDim2.new(1, 0, 0, 44)
bFps.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
bFps.Text = "OTIMIZAR FPS / MODO LISO"
bFps.TextColor3 = Color3.fromRGB(246, 247, 252)
bFps.Font = Enum.Font.GothamBold
bFps.TextSize = 12
bFps.Parent = contFPS
Instance.new("UICorner", bFps).CornerRadius = UDim.new(0, 10)

bFps.Activated:Connect(function()
	pcall(function() Lighting.GlobalShadows = false end)
	for _, o in ipairs(Workspace:GetDescendants()) do
		if o:IsA("BasePart") then
			pcall(function() o.CastShadow = false o.Material = Enum.Material.SmoothPlastic end)
		elseif o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") or o:IsA("Fire") or o:IsA("Smoke") then
			pcall(function() o.Enabled = false end)
		end
	end
	bFps.Text = "FPS OTIMIZADO!"
	bFps.BackgroundColor3 = Color3.fromRGB(46, 160, 90)
end)

local bResp = Instance.new("TextButton")
bResp.Size = UDim2.new(1, 0, 0, 44)
bResp.BackgroundColor3 = Color3.fromRGB(205, 65, 65)
bResp.Text = "RESPAWN RÁPIDO"
bResp.TextColor3 = Color3.fromRGB(246, 247, 252)
bResp.Font = Enum.Font.GothamBold
bResp.TextSize = 12
bResp.Parent = contUtil
Instance.new("UICorner", bResp).CornerRadius = UDim.new(0, 10)
bResp.Activated:Connect(function()
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h then h.Health = 0 end
end)

local compacta = false
local bTam = Instance.new("TextButton")
bTam.Size = UDim2.new(1, 0, 0, 44)
bTam.BackgroundColor3 = Color3.fromRGB(43, 46, 63)
bTam.Text = "BOLINHA: NORMAL (58px)"
bTam.TextColor3 = Color3.fromRGB(246, 247, 252)
bTam.Font = Enum.Font.GothamBold
bTam.TextSize = 12
bTam.Parent = contUI
Instance.new("UICorner", bTam).CornerRadius = UDim.new(0, 10)
bTam.Activated:Connect(function()
	compacta = not compacta
	bolinha.Size = compacta and UDim2.fromOffset(44, 44) or UDim2.fromOffset(58, 58)
	bTam.Text = compacta and "BOLINHA: COMPACTA (44px)" or "BOLINHA: NORMAL (58px)"
end)

local bPos = Instance.new("TextButton")
bPos.Size = UDim2.new(1, 0, 0, 44)
bPos.Position = UDim2.fromOffset(0, 52)
bPos.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
bPos.Text = "RESETAR POSIÇÃO"
bPos.TextColor3 = Color3.fromRGB(246, 247, 252)
bPos.Font = Enum.Font.GothamBold
bPos.TextSize = 12
bPos.Parent = contUI
Instance.new("UICorner", bPos).CornerRadius = UDim.new(0, 10)
bPos.Activated:Connect(function()
	bolinha.Position = UDim2.fromOffset(16, 110)
	menu.Position = UDim2.fromOffset(80, 60)
end)
