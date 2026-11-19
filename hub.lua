local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local antigo = PlayerGui:FindFirstChild("GrudarMenu")
if antigo then antigo:Destroy() end

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
Instance.new("UICorner", bolinha).CornerRadius = UDim.new(1, 0)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
local gui = PlayerGui and PlayerGui:FindFirstChild("GrudarMenu")
local bolinha = gui and gui:FindFirstChild("Bolinha")
if not (gui and bolinha) then return end

local COR = {
	fundo = Color3.fromRGB(16, 17, 24),
	painel = Color3.fromRGB(25, 27, 38),
	card = Color3.fromRGB(36, 39, 54),
	borda = Color3.fromRGB(58, 63, 88),
	primaria = Color3.fromRGB(88, 101, 242),
	perigo = Color3.fromRGB(205, 65, 65),
	texto = Color3.fromRGB(246, 247, 252),
	suave = Color3.fromRGB(168, 174, 196),
}

local function arredondar(inst, raio)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, raio or 9)
	c.Parent = inst
end

local function contornar(inst, cor, esp)
	local s = Instance.new("UIStroke")
	s.Color = cor or COR.borda
	s.Thickness = esp or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = inst
end

local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Size = UDim2.fromOffset(292, 412)
menu.Position = UDim2.fromOffset(82, 54)
menu.BackgroundColor3 = COR.fundo
menu.BorderSizePixel = 0
menu.Active = true
menu.Visible = false
menu.ZIndex = 30
menu.Parent = gui
arredondar(menu, 14)
contornar(menu, COR.borda, 1.2)

local barra = Instance.new("Frame")
barra.Name = "Barra"
barra.Size = UDim2.new(1, 0, 0, 42)
barra.BackgroundColor3 = COR.painel
barra.BorderSizePixel = 0
barra.Active = true
barra.ZIndex = 31
barra.Parent = menu
arredondar(barra, 14)

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, -54, 1, 0)
titulo.Position = UDim2.fromOffset(14, 0)
titulo.BackgroundTransparency = 1
titulo.Text = "Apex Mobile HUB"
titulo.TextColor3 = COR.texto
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 14
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.ZIndex = 32
titulo.Parent = barra

local fechar = Instance.new("TextButton")
fechar.Name = "Fechar"
fechar.Size = UDim2.fromOffset(30, 30)
fechar.Position = UDim2.new(1, -38, 0, 6)
fechar.BackgroundColor3 = COR.perigo
fechar.AutoButtonColor = false
fechar.Text = "X"
fechar.TextColor3 = COR.texto
fechar.Font = Enum.Font.GothamBold
fechar.TextSize = 13
fechar.ZIndex = 32
fechar.Parent = barra
arredondar(fechar, 8)

local ABAS = { "TP", "Mov", "Visão", "FPS", "Mais" }
local barraAbas = Instance.new("Frame")
barraAbas.Name = "Abas"
barraAbas.Size = UDim2.new(1, -20, 0, 34)
barraAbas.Position = UDim2.fromOffset(10, 48)
barraAbas.BackgroundColor3 = COR.painel
barraAbas.BorderSizePixel = 0
barraAbas.ZIndex = 31
barraAbas.Parent = menu
arredondar(barraAbas, 10)
contornar(barraAbas, COR.borda, 1)

local layAbas = Instance.new("UIListLayout")
layAbas.FillDirection = Enum.FillDirection.Horizontal
layAbas.HorizontalAlignment = Enum.HorizontalAlignment.Center
layAbas.VerticalAlignment = Enum.VerticalAlignment.Center
layAbas.Padding = UDim.new(0, 4)
layAbas.Parent = barraAbas

local faixaStatus = Instance.new("Frame")
faixaStatus.Name = "FaixaStatus"
faixaStatus.Size = UDim2.new(1, -20, 0, 24)
faixaStatus.Position = UDim2.fromOffset(10, 88)
faixaStatus.BackgroundColor3 = COR.painel
faixaStatus.BorderSizePixel = 0
faixaStatus.ZIndex = 31
faixaStatus.Parent = menu
arredondar(faixaStatus, 8)
contornar(faixaStatus, COR.borda, 1)

local status = Instance.new("TextLabel")
status.Name = "Status"
status.Size = UDim2.new(1, -14, 1, 0)
status.Position = UDim2.fromOffset(7, 0)
status.BackgroundTransparency = 1
status.Text = "Status: Pronto para usar"
status.TextColor3 = COR.suave
status.Font = Enum.Font.GothamMedium
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextTruncate = Enum.TextTruncate.AtEnd
status.ZIndex = 32
status.Parent = faixaStatus

local containers, botoesAba = {}, {}
local function selecionarAba(nome)
	for _, n in ipairs(ABAS) do
		local ativa = (n == nome)
		containers[n].Visible = ativa
		botoesAba[n].BackgroundColor3 = ativa and COR.primaria or COR.card
		botoesAba[n].TextColor3 = ativa and COR.texto or COR.suave
	end
end

local larguraBtn = math.floor((272 - 16 - (#ABAS - 1) * 4) / #ABAS)
for _, nome in ipairs(ABAS) do
	local btn = Instance.new("TextButton")
	btn.Name = "Aba_" .. nome
	btn.Size = UDim2.fromOffset(larguraBtn, 26)
	btn.BackgroundColor3 = COR.card
	btn.AutoButtonColor = false
	btn.Text = nome
	btn.TextColor3 = COR.suave
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.ZIndex = 32
	btn.Parent = barraAbas
	arredondar(btn, 7)
	botoesAba[nome] = btn

	local cont = Instance.new("ScrollingFrame")
	cont.Name = "Conteudo_" .. nome
	cont.Size = UDim2.new(1, -20, 1, -124)
	cont.Position = UDim2.fromOffset(10, 118)
	cont.BackgroundTransparency = 1
	cont.BorderSizePixel = 0
	cont.ScrollBarThickness = 3
	cont.CanvasSize = UDim2.new(0, 0, 0, 0)
	cont.AutomaticCanvasSize = Enum.AutomaticSize.Y
	cont.Visible = (nome == "TP")
	cont.ZIndex = 31
	cont.Parent = menu
	containers[nome] = cont

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 2)
	pad.PaddingBottom = UDim.new(0, 8)
	pad.PaddingRight = UDim.new(0, 4)
	pad.Parent = cont

	local lay = Instance.new("UIListLayout")
	lay.SortOrder = Enum.SortOrder.LayoutOrder
	lay.Padding = UDim.new(0, 6)
	lay.Parent = cont

	btn.Activated:Connect(function() selecionarAba(nome) end)
end

local function tornarArrastavel(alca, alvo, aoToque)
	local arrastando, entrada, inicioToque, inicioPos, moveu = false, nil, nil, nil, false
	alca.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
			arrastando, moveu, entrada, inicioToque, inicioPos = true, false, inp, inp.Position, alvo.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(inp)
		if not arrastando then return end
		local ok = (inp == entrada) or (inp.UserInputType == Enum.UserInputType.MouseMovement and entrada and entrada.UserInputType == Enum.UserInputType.MouseButton1)
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
		local ok = (inp == entrada) or (inp.UserInputType == Enum.UserInputType.MouseButton1 and entrada and entrada.UserInputType == Enum.UserInputType.MouseButton1)
		if ok then
			arrastando = false
			if not moveu and aoToque then aoToque() end
		end
	end)
end

fechar.Activated:Connect(function() menu.Visible = false end)
tornarArrastavel(barra, menu, nil)
tornarArrastavel(bolinha, bolinha, function() menu.Visible = not menu.Visible end)
selecionarAba("TP")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
local gui = PlayerGui and PlayerGui:FindFirstChild("GrudarMenu")
local menu = gui and gui:FindFirstChild("Menu")
local contTP = menu and menu:FindFirstChild("Conteudo_TP")
local status = menu and menu:FindFirstChild("FaixaStatus") and menu.FaixaStatus:FindFirstChild("Status")
if not (contTP and status) then return end

local C_PAINEL, C_CARD, C_BORDA = Color3.fromRGB(25, 27, 38), Color3.fromRGB(36, 39, 54), Color3.fromRGB(58, 63, 88)
local C_PRIM, C_OK, C_WARN, C_BAD = Color3.fromRGB(88, 101, 242), Color3.fromRGB(46, 160, 90), Color3.fromRGB(215, 165, 40), Color3.fromRGB(205, 65, 65)
local C_TXT, C_SUB = Color3.fromRGB(246, 247, 252), Color3.fromRGB(168, 174, 196)

local function estilo(inst, r)
	Instance.new("UICorner", inst).CornerRadius = UDim.new(0, r or 9)
	local s = Instance.new("UIStroke", inst)
	s.Color = C_BORDA s.Thickness = 1 s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end
local function mkBtn(pai, txt, alt, bg, fg, ts)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, alt or 36)
	b.BackgroundColor3 = bg or C_CARD b.Text = txt b.TextColor3 = fg or C_TXT
	b.Font = Enum.Font.GothamBold b.TextSize = ts or 11 b.ZIndex = 33 b.Parent = pai
	estilo(b, 9) return b
end
local function mkLbl(pai, txt, alt, bg, ts)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, 0, 0, alt or 26)
	l.BackgroundColor3 = bg or C_PAINEL l.Text = txt l.TextColor3 = C_TXT
	l.Font = Enum.Font.GothamBold l.TextSize = ts or 11 l.ZIndex = 33 l.Parent = pai
	estilo(l, 8) return l
end
local function mkLinha(pai, alt)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1, 0, 0, alt or 34)
	f.BackgroundTransparency = 1 f.ZIndex = 32 f.Parent = pai return f
end

local busca = Instance.new("TextBox")
busca.Size = UDim2.new(1, 0, 0, 32)
busca.BackgroundColor3 = C_PAINEL busca.BorderSizePixel = 0
busca.PlaceholderText = "Buscar jogador..." busca.PlaceholderColor3 = C_SUB
busca.Text = "" busca.TextColor3 = C_TXT busca.Font = Enum.Font.Gotham busca.TextSize = 12
busca.ClearTextOnFocus = false busca.ZIndex = 33 busca.Parent = contTP estilo(busca, 8)

local lista = Instance.new("ScrollingFrame")
lista.Size = UDim2.new(1, 0, 0, 106)
lista.BackgroundColor3 = C_PAINEL lista.BorderSizePixel = 0 lista.ScrollBarThickness = 3
lista.CanvasSize = UDim2.new(0, 0, 0, 0) lista.AutomaticCanvasSize = Enum.AutomaticSize.Y
lista.ZIndex = 33 lista.Parent = contTP estilo(lista, 9)
local layL = Instance.new("UIListLayout", lista) layL.Padding = UDim.new(0, 4) layL.SortOrder = Enum.SortOrder.Name
local padL = Instance.new("UIPadding", lista) padL.PaddingTop = UDim.new(0, 4) padL.PaddingBottom = UDim.new(0, 4) padL.PaddingLeft = UDim.new(0, 4) padL.PaddingRight = UDim.new(0, 4)

local l1 = mkLinha(contTP, 36)
local btnIr = mkBtn(l1, "IR ATÉ ALVO", 36, C_PRIM, C_TXT, 11) btnIr.Size = UDim2.new(0.49, 0, 1, 0)
local btnCostas = mkBtn(l1, "COSTAS: OFF", 36, C_CARD, C_SUB, 11) btnCostas.Size = UDim2.new(0.49, 0, 1, 0) btnCostas.Position = UDim2.new(0.51, 0, 0, 0)
local btnCaotico = mkBtn(contTP, "ATIVAR TP CAÓTICO", 36, C_OK, C_TXT, 12)

mkLbl(contTP, "AIMBOT & MIRA", 22, C_PAINEL, 10)
local forcaAssist, antiParede, cabeca, aimAtivo, connAim = 18, true, true, false, nil
local lblAssist = mkLbl(contTP, "Travamento da Mira: 18", 28, C_CARD, 11)

local l2 = mkLinha(contTP, 34)
local bMenos = mkBtn(l2, "- Menos Travado", 34, C_CARD, C_TXT, 11) bMenos.Size = UDim2.new(0.49, 0, 1, 0)
local bMais = mkBtn(l2, "+ Mais Travado", 34, C_PRIM, C_TXT, 11) bMais.Size = UDim2.new(0.49, 0, 1, 0) bMais.Position = UDim2.new(0.51, 0, 0, 0)

local l3 = mkLinha(contTP, 34)
local bParede = mkBtn(l3, "PAREDE: ON", 34, C_CARD, C_OK, 11) bParede.Size = UDim2.new(0.49, 0, 1, 0)
local bParte = mkBtn(l3, "FOCO: CABEÇA", 34, C_CARD, C_WARN, 11) bParte.Size = UDim2.new(0.49, 0, 1, 0) bParte.Position = UDim2.new(0.51, 0, 0, 0)

local bAim = mkBtn(contTP, "AIMBOT: OFF", 40, C_CARD, C_SUB, 12)

local selecionado, ativoTP, tpCostas, connTP, botoesPlr = nil, false, false, nil, {}
local function raiz(c) return c and c:FindFirstChild("HumanoidRootPart") end

local function refreshTP()
	local f = string.lower(busca.Text or "")
	for plr, b in pairs(botoesPlr) do
		if b and b.Parent then
			b.Visible = (f == "") or (string.find(string.lower(plr.DisplayName .. " " .. plr.Name), f, 1, true) ~= nil)
			b.BackgroundColor3 = (plr == selecionado) and C_PRIM or C_CARD
		end
	end
	btnCostas.Text = tpCostas and "COSTAS: ON" or "COSTAS: OFF"
	btnCostas.BackgroundColor3 = tpCostas and C_OK or C_CARD
	btnCostas.TextColor3 = tpCostas and C_TXT or C_SUB
	btnCaotico.Text = ativoTP and "DESATIVAR TP CAÓTICO" or "ATIVAR TP CAÓTICO"
	btnCaotico.BackgroundColor3 = ativoTP and C_BAD or C_OK
	status.Text = "Status: " .. (selecionado and ((ativoTP and "Circulando " or (tpCostas and "Costas em " or "Alvo: ")) .. selecionado.DisplayName) or "Escolha um jogador")
end

local function pararTP()
	ativoTP, tpCostas = false, false
	if connTP then connTP:Disconnect() connTP = nil end
	refreshTP()
end

local function iniciarTP(costas)
	if not selecionado or selecionado.Parent ~= Players then status.Text = "Status: Escolha um jogador!" return end
	pararTP()
	ativoTP, tpCostas = not costas, costas
	local off, ult = Vector3.new(2, 0, 2), os.clock()
	connTP = RunService.Heartbeat:Connect(function()
		local r1, r2 = raiz(LocalPlayer.Character), raiz(selecionado and selecionado.Character)
		if not (r1 and r2) then return end
		if tpCostas then r1.CFrame = r2.CFrame * CFrame.new(0, 0, 2.6)
		else
			if os.clock() - ult >= 0.25 then ult = os.clock() off = Vector3.new(math.random(-3, 3), math.random(-2, 2), math.random(-3, 3)) end
			r1.CFrame = CFrame.lookAt(r2.Position + off, r2.Position)
		end
	end)
	refreshTP()
end

local function addPlr(plr)
	if plr == LocalPlayer or botoesPlr[plr] then return end
	local b = mkBtn(lista, plr.DisplayName .. " (@" .. plr.Name .. ")", 30, C_CARD, C_TXT, 11)
	b.Name = string.lower(plr.Name) botoesPlr[plr] = b
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

local function visivelSemParede(cam, alvoChar, pt)
	if not antiParede then return true end
	local params = RaycastParams.new() params.FilterType = Enum.RaycastFilterType.Exclude
	local ign = {}
	if LocalPlayer.Character then table.insert(ign, LocalPlayer.Character) end
	if Workspace.CurrentCamera then table.insert(ign, Workspace.CurrentCamera) end
	params.FilterDescendantsInstances = ign
	local hit = Workspace:Raycast(cam.CFrame.Position, pt - cam.CFrame.Position, params)
	if not hit then return true end
	return hit.Instance:IsDescendantOf(alvoChar)
end

local function buscarAlvo(cam)
	local melhor, menorDist = nil, 240
	local centro = Vector2.new(cam.ViewportSize.X * 0.5, cam.ViewportSize.Y * 0.5)
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			local parte = cabeca and (plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")) or (plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Head"))
			if hum and hum.Health > 0 and parte then
				local pos, vis = cam:WorldToViewportPoint(parte.Position)
				if vis and pos.Z > 0 then
					local dTela = (Vector2.new(pos.X, pos.Y) - centro).Magnitude
					if dTela <= menorDist and visivelSemParede(cam, plr.Character, parte.Position) then
						menorDist, melhor = dTela, parte.Position
					end
				end
			end
		end
	end
	return melhor
end

local function syncAim()
	lblAssist.Text = "Travamento da Mira: " .. tostring(forcaAssist)
	bParede.Text = antiParede and "PAREDE: ON" or "PAREDE: OFF"
	bParede.TextColor3 = antiParede and C_OK or C_SUB
	bParte.Text = cabeca and "FOCO: CABEÇA" or "FOCO: TORSO"
	bAim.Text = aimAtivo and "AIMBOT: ON" or "AIMBOT: OFF"
	bAim.BackgroundColor3 = aimAtivo and C_OK or C_CARD
	bAim.TextColor3 = aimAtivo and C_TXT or C_SUB
end

bMenos.Activated:Connect(function() forcaAssist = math.clamp(forcaAssist - 2, 4, 30) syncAim() end)
bMais.Activated:Connect(function() forcaAssist = math.clamp(forcaAssist + 2, 4, 30) syncAim() end)
bParede.Activated:Connect(function() antiParede = not antiParede syncAim() end)
bParte.Activated:Connect(function() cabeca = not cabeca syncAim() end)
bAim.Activated:Connect(function()
	aimAtivo = not aimAtivo
	if aimAtivo and not connAim then
		connAim = RunService.RenderStepped:Connect(function(dt)
			local cam = Workspace.CurrentCamera
			if not (aimAtivo and cam) then return end
			local pt = buscarAlvo(cam)
			if pt then
				cam.CFrame = cam.CFrame:Lerp(CFrame.lookAt(cam.CFrame.Position, pt), math.clamp(forcaAssist * dt * 0.9, 0.12, 0.85))
			end
		end)
	elseif not aimAtivo and connAim then connAim:Disconnect() connAim = nil end
	syncAim()
	status.Text = "Status: " .. (aimAtivo and "Aimbot ligado" or "Aimbot desligado")
end)
syncAim()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
local gui = PlayerGui and PlayerGui:FindFirstChild("GrudarMenu")
local menu = gui and gui:FindFirstChild("Menu")
local contMov = menu and menu:FindFirstChild("Conteudo_Mov")
if not contMov then return end

local C_CARD, C_BORDA = Color3.fromRGB(36, 39, 54), Color3.fromRGB(58, 63, 88)
local C_PRIM, C_OK = Color3.fromRGB(88, 101, 242), Color3.fromRGB(46, 160, 90)
local C_TXT, C_SUB = Color3.fromRGB(246, 247, 252), Color3.fromRGB(168, 174, 196)

local function estilo(inst, r)
	Instance.new("UICorner", inst).CornerRadius = UDim.new(0, r or 9)
	local s = Instance.new("UIStroke", inst) s.Color = C_BORDA s.Thickness = 1 s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end
local function mkBtn(pai, txt, alt, bg, fg)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, alt or 36) b.BackgroundColor3 = bg or C_CARD
	b.Text = txt b.TextColor3 = fg or C_TXT b.Font = Enum.Font.GothamBold b.TextSize = 11 b.ZIndex = 33 b.Parent = pai
	estilo(b, 9) return b
end
local function mkLbl(pai, txt)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, 0, 0, 26) l.BackgroundColor3 = C_CARD
	l.Text = txt l.TextColor3 = C_TXT l.Font = Enum.Font.GothamBold l.TextSize = 11 l.ZIndex = 33 l.Parent = pai
	estilo(l, 8) return l
end
local function mkLinha(pai, alt)
	local f = Instance.new("Frame") f.Size = UDim2.new(1, 0, 0, alt or 34)
	f.BackgroundTransparency = 1 f.ZIndex = 32 f.Parent = pai return f
end

local vel, speedOn, cfOn, connSp = 32, false, false, nil
local lblVel = mkLbl(contMov, "Velocidade: 32")
local lV1 = mkLinha(contMov, 34)
local bMenosV = mkBtn(lV1, "- Menos", 34, C_CARD, C_TXT) bMenosV.Size = UDim2.new(0.49, 0, 1, 0)
local bMaisV = mkBtn(lV1, "+ Mais", 34, C_PRIM, C_TXT) bMaisV.Size = UDim2.new(0.49, 0, 1, 0) bMaisV.Position = UDim2.new(0.51, 0, 0, 0)
local lV2 = mkLinha(contMov, 36)
local bSpeed = mkBtn(lV2, "WALKSPEED: OFF", 36, C_CARD, C_SUB) bSpeed.Size = UDim2.new(0.49, 0, 1, 0)
local bCf = mkBtn(lV2, "CFRAME SPD: OFF", 36, C_CARD, C_SUB) bCf.Size = UDim2.new(0.49, 0, 1, 0) bCf.Position = UDim2.new(0.51, 0, 0, 0)

local function syncSpeed()
	lblVel.Text = "Velocidade: " .. tostring(vel)
	bSpeed.Text = speedOn and "WALKSPEED: ON" or "WALKSPEED: OFF"
	bSpeed.BackgroundColor3 = speedOn and C_OK or C_CARD bSpeed.TextColor3 = speedOn and C_TXT or C_SUB
	bCf.Text = cfOn and "CFRAME SPD: ON" or "CFRAME SPD: OFF"
	bCf.BackgroundColor3 = cfOn and C_PRIM or C_CARD bCf.TextColor3 = cfOn and C_TXT or C_SUB
	if (speedOn or cfOn) and not connSp then
		connSp = RunService.Heartbeat:Connect(function(dt)
			local c = LocalPlayer.Character local h = c and c:FindFirstChildOfClass("Humanoid") local r = c and c:FindFirstChild("HumanoidRootPart")
			if not h then return end
			if speedOn then h.WalkSpeed = vel end
			if cfOn and r and h.MoveDirection.Magnitude > 0 then r.CFrame = r.CFrame + (h.MoveDirection * math.max(0, vel - 16) * dt) end
		end)
	elseif not (speedOn or cfOn) and connSp then
		connSp:Disconnect() connSp = nil
		local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = 16 end
	end
end
bMenosV.Activated:Connect(function() vel = math.clamp(vel - 4, 8, 150) syncSpeed() end)
bMaisV.Activated:Connect(function() vel = math.clamp(vel + 4, 8, 150) syncSpeed() end)
bSpeed.Activated:Connect(function() speedOn = not speedOn syncSpeed() end)
bCf.Activated:Connect(function() cfOn = not cfOn syncSpeed() end)

local pulo, jumpOn, infOn, connJumpReq, connHumState, ultPulo = 100, false, false, nil, nil, 0
local lblPulo = mkLbl(contMov, "Força do Pulo: 100")
local lJ1 = mkLinha(contMov, 34)
local bMenosJ = mkBtn(lJ1, "- Pulo", 34, C_CARD, C_TXT) bMenosJ.Size = UDim2.new(0.49, 0, 1, 0)
local bMaisJ = mkBtn(lJ1, "+ Pulo", 34, C_PRIM, C_TXT) bMaisJ.Size = UDim2.new(0.49, 0, 1, 0) bMaisJ.Position = UDim2.new(0.51, 0, 0, 0)
local lJ2 = mkLinha(contMov, 36)
local bJump = mkBtn(lJ2, "SUPER JUMP: OFF", 36, C_CARD, C_SUB) bJump.Size = UDim2.new(0.49, 0, 1, 0)
local bInf = mkBtn(lJ2, "PULO INF: OFF", 36, C_CARD, C_SUB) bInf.Size = UDim2.new(0.49, 0, 1, 0) bInf.Position = UDim2.new(0.51, 0, 0, 0)

local function syncJump()
	lblPulo.Text = "Força do Pulo: " .. tostring(pulo)
	bJump.Text = jumpOn and "SUPER JUMP: ON" or "SUPER JUMP: OFF"
	bJump.BackgroundColor3 = jumpOn and C_OK or C_CARD bJump.TextColor3 = jumpOn and C_TXT or C_SUB
	bInf.Text = infOn and "PULO INF: ON" or "PULO INF: OFF"
	bInf.BackgroundColor3 = infOn and C_OK or C_CARD bInf.TextColor3 = infOn and C_TXT or C_SUB
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h then h.UseJumpPower = true h.JumpPower = jumpOn and pulo or 50 h:SetStateEnabled(Enum.HumanoidStateType.Jumping, true) h:SetStateEnabled(Enum.HumanoidStateType.Freefall, true) end
end

local function aplicarImpulsoInfinito()
	if not infOn or os.clock() - ultPulo < 0.12 then return end
	ultPulo = os.clock()
	local c = LocalPlayer.Character local h = c and c:FindFirstChildOfClass("Humanoid") local r = c and c:FindFirstChild("HumanoidRootPart")
	if h and r then
		local fy = jumpOn and math.clamp(pulo * 0.7, 50, 150) or 55
		h:SetStateEnabled(Enum.HumanoidStateType.Jumping, true) h:ChangeState(Enum.HumanoidStateType.Jumping)
		r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, fy, r.AssemblyLinearVelocity.Z)
	end
end

local function ligarInf()
	if not connJumpReq then connJumpReq = UserInputService.JumpRequest:Connect(function() if infOn then aplicarImpulsoInfinito() end end) end
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if connHumState then connHumState:Disconnect() connHumState = nil end
	if h then connHumState = h.StateChanged:Connect(function(_, est) if infOn and h.Jump and (est == Enum.HumanoidStateType.Freefall or est == Enum.HumanoidStateType.Landed) then aplicarImpulsoInfinito() end end) end
end
local function desligarInf()
	if connJumpReq then connJumpReq:Disconnect() connJumpReq = nil end
	if connHumState then connHumState:Disconnect() connHumState = nil end
end
bMenosJ.Activated:Connect(function() pulo = math.clamp(pulo - 10, 10, 250) syncJump() end)
bMaisJ.Activated:Connect(function() pulo = math.clamp(pulo + 10, 10, 250) syncJump() end)
bJump.Activated:Connect(function() jumpOn = not jumpOn syncJump() end)
bInf.Activated:Connect(function() infOn = not infOn if infOn then ligarInf() else desligarInf() end syncJump() end)
LocalPlayer.CharacterAdded:Connect(function() task.wait(0.25) syncJump() if infOn then ligarInf() end end)

local flyOn, flyVel, connFly, bg, bv = false, 55, nil, nil, nil
local segSubir, segDescer = false, false
local lblFly = mkLbl(contMov, "Vel. do Fly: 55")
local lF1 = mkLinha(contMov, 34)
local bMenosFly = mkBtn(lF1, "- Vel", 34, C_CARD, C_TXT) bMenosFly.Size = UDim2.new(0.23, 0, 1, 0)
local bMaisFly = mkBtn(lF1, "+ Vel", 34, C_PRIM, C_TXT) bMaisFly.Size = UDim2.new(0.23, 0, 1, 0) bMaisFly.Position = UDim2.new(0.25, 0, 0, 0)
local bFly = mkBtn(lF1, "FLY: OFF", 34, C_CARD, C_SUB) bFly.Size = UDim2.new(0.50, 0, 1, 0) bFly.Position = UDim2.new(0.50, 0, 0, 0)

local lF2 = mkLinha(contMov, 34)
local bSubir = mkBtn(lF2, "SUBIR ▲", 34, C_CARD, C_TXT) bSubir.Size = UDim2.new(0.49, 0, 1, 0)
local bDescer = mkBtn(lF2, "DESCER ▼", 34, C_CARD, C_TXT) bDescer.Size = UDim2.new(0.49, 0, 1, 0) bDescer.Position = UDim2.new(0.51, 0, 0, 0)

local lFis = mkLinha(contMov, 36)
local noclipOn, connNc = false, nil
local bNc = mkBtn(lFis, "NOCLIP: OFF", 36, C_CARD, C_SUB) bNc.Size = UDim2.new(0.49, 0, 1, 0)
local gravOn, gravVal = false, 75
local bGrav = mkBtn(lFis, "GRAV 75: OFF", 36, C_CARD, C_SUB) bGrav.Size = UDim2.new(0.49, 0, 1, 0) bGrav.Position = UDim2.new(0.51, 0, 0, 0)

local function syncFlyUI()
	lblFly.Text = "Vel. do Fly: " .. tostring(flyVel)
	bFly.Text = flyOn and "FLY: ON" or "FLY: OFF"
	bFly.BackgroundColor3 = flyOn and C_OK or C_CARD bFly.TextColor3 = flyOn and C_TXT or C_SUB
end
local function stopFly()
	flyOn = false segSubir = false segDescer = false
	if connFly then connFly:Disconnect() connFly = nil end
	if bg then bg:Destroy() bg = nil end if bv then bv:Destroy() bv = nil end
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if h then h.PlatformStand = false end
	syncFlyUI()
end
bMenosFly.Activated:Connect(function() flyVel = math.clamp(flyVel - 10, 15, 220) syncFlyUI() end)
bMaisFly.Activated:Connect(function() flyVel = math.clamp(flyVel + 10, 15, 220) syncFlyUI() end)
bSubir.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then segSubir = true end end)
bSubir.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then segSubir = false end end)
bDescer.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then segDescer = true end end)
bDescer.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then segDescer = false end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then segSubir = false segDescer = false end end)

bFly.Activated:Connect(function()
	if flyOn then stopFly() return end
	local c = LocalPlayer.Character local r = c and c:FindFirstChild("HumanoidRootPart") local h = c and c:FindFirstChildOfClass("Humanoid")
	if not (r and h) then return end
	flyOn = true h.PlatformStand = true
	bg = Instance
		local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
local gui = PlayerGui and PlayerGui:FindFirstChild("GrudarMenu")
local menu = gui and gui:FindFirstChild("Menu")
local contVis = menu and menu:FindFirstChild("Conteudo_Visão")
if not contVis then return end

local C_FUNDO, C_PAINEL, C_CARD, C_BORDA = Color3.fromRGB(16, 17, 24), Color3.fromRGB(25, 27, 38), Color3.fromRGB(36, 39, 54), Color3.fromRGB(58, 63, 88)
local C_PRIM, C_OK, C_WARN = Color3.fromRGB(88, 101, 242), Color3.fromRGB(46, 160, 90), Color3.fromRGB(215, 165, 40)
local C_TXT, C_SUB = Color3.fromRGB(246, 247, 252), Color3.fromRGB(168, 174, 196)

local function estilo(inst, r)
	Instance.new("UICorner", inst).CornerRadius = UDim.new(0, r or 9)
	local s = Instance.new("UIStroke", inst) s.Color = C_BORDA s.Thickness = 1 s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end
local function mkBtn(pai, txt)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 40) b.BackgroundColor3 = C_CARD
	b.Text = txt b.TextColor3 = C_SUB b.Font = Enum.Font.GothamBold b.TextSize = 12 b.ZIndex = 33 b.Parent = pai
	estilo(b, 9) return b
end
local function mkSec(pai, txt)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, 0, 0, 22) l.BackgroundColor3 = C_PAINEL
	l.Text = txt l.TextColor3 = C_TXT l.Font = Enum.Font.GothamBold l.TextSize = 10 l.ZIndex = 33 l.Parent = pai
	estilo(l, 8)
end

mkSec(contVis, "ESP DE JOGADORES")
local btnEsp = mkBtn(contVis, "ESP TEXTO + HP: OFF")
local btnHl = mkBtn(contVis, "CONTORNO JOGADORES: OFF")
mkSec(contVis, "CÂMERA & ILUMINAÇÃO")
local bFb = mkBtn(contVis, "FULLBRIGHT: OFF")
local bFov = mkBtn(contVis, "FOV 95: OFF")

local espOn, hlOn, fbOn, fovOn = false, false, false, false
local tags, hls, connEsp, connCam = {}, {}, nil, nil

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
				local bb = Instance.new("BillboardGui") bb.Size = UDim2.fromOffset(170, 42) bb.StudsOffset = Vector3.new(0, 2.8, 0) bb.AlwaysOnTop = true bb.Parent = head
				local tl = Instance.new("TextLabel") tl.Size = UDim2.fromScale(1, 1) tl.BackgroundTransparency = 1 tl.TextColor3 = C_TXT tl.TextStrokeTransparency = 0.35 tl.Font = Enum.Font.GothamBold tl.TextSize = 11 tl.Text = plr.DisplayName .. "\n(@" .. plr.Name .. ")" tl.Parent = bb
				tags[plr] = bb
			end
			if hlOn then
				local hl = Instance.new("Highlight") hl.FillColor = C_PRIM hl.OutlineColor = C_TXT hl.FillTransparency = 0.65 hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop hl.Adornee = plr.Character hl.Parent = plr.Character
				hls[plr] = hl
			end
		end
	end
end
local function syncESP()
	btnEsp.Text = espOn and "ESP TEXTO + HP: ON" or "ESP TEXTO + HP: OFF"
	btnEsp.BackgroundColor3 = espOn and C_PRIM or C_CARD btnEsp.TextColor3 = espOn and C_TXT or C_SUB
	btnHl.Text = hlOn and "CONTORNO JOGADORES: ON" or "CONTORNO JOGADORES: OFF"
	btnHl.BackgroundColor3 = hlOn and C_WARN or C_CARD btnHl.TextColor3 = hlOn and C_FUNDO or C_SUB
	rebuildESP()
	if (espOn or hlOn) and not connEsp then
		connEsp = RunService.RenderStepped:Connect(function()
			local r1 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			for plr, bb in pairs(tags) do
				local tl = bb and bb:FindFirstChildOfClass("TextLabel") local r2 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
				if tl and r1 and r2 and hum then tl.Text = string.format("%s (@%s)\n%dm | HP %d", plr.DisplayName, plr.Name, math.floor((r1.Position - r2.Position).Magnitude), math.floor(hum.Health)) end
			end
		end)
	elseif not (espOn or hlOn) and connEsp then connEsp:Disconnect() connEsp = nil end
end
local function syncCam()
	bFb.Text = fbOn and "FULLBRIGHT: ON" or "FULLBRIGHT: OFF"
	bFb.BackgroundColor3 = fbOn and C_WARN or C_CARD bFb.TextColor3 = fbOn and C_FUNDO or C_SUB
	bFov.Text = fovOn and "FOV 95: ON" or "FOV 95: OFF"
	bFov.BackgroundColor3 = fovOn and C_OK or C_CARD bFov.TextColor3 = fovOn and C_TXT or C_SUB
	if (fbOn or fovOn) and not connCam then
		connCam = RunService.RenderStepped:Connect(function()
			if fbOn then Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.FogEnd = 100000 end
			if fovOn and Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView = 95 end
		end)
	elseif not (fbOn or fovOn) and connCam then connCam:Disconnect() connCam = nil if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView = 70 end end
end
btnEsp.Activated:Connect(function() espOn = not espOn syncESP() end)
btnHl.Activated:Connect(function() hlOn = not hlOn syncESP() end)
bFb.Activated:Connect(function() fbOn = not fbOn syncCam() end)
bFov.Activated:Connect(function() fovOn = not fovOn syncCam() end)
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(0.2) if espOn or hlOn then rebuildESP() end end) end)
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then p.CharacterAdded:Connect(function() task.wait(0.2) if espOn or hlOn then rebuildESP() end end) end end
		local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
local gui = PlayerGui and PlayerGui:FindFirstChild("GrudarMenu")
local menu = gui and gui:FindFirstChild("Menu")
local bolinha = gui and gui:FindFirstChild("Bolinha")
local contFPS = menu and menu:FindFirstChild("Conteudo_FPS")
local contMais = menu and menu:FindFirstChild("Conteudo_Mais")
local status = menu and menu:FindFirstChild("FaixaStatus") and menu.FaixaStatus:FindFirstChild("Status")
if not (bolinha and contFPS and contMais and status) then return end

local C_PAINEL, C_CARD, C_BORDA = Color3.fromRGB(25, 27, 38), Color3.fromRGB(36, 39, 54), Color3.fromRGB(58, 63, 88)
local C_PRIM, C_OK, C_WARN, C_BAD = Color3.fromRGB(88, 101, 242), Color3.fromRGB(46, 160, 90), Color3.fromRGB(215, 165, 40), Color3.fromRGB(205, 65, 65)
local C_TXT, C_SUB = Color3.fromRGB(246, 247, 252), Color3.fromRGB(168, 174, 196)

local function estilo(inst, r)
	Instance.new("UICorner", inst).CornerRadius = UDim.new(0, r or 9)
	local s = Instance.new("UIStroke", inst) s.Color = C_BORDA s.Thickness = 1 s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end
local function mkBtn(pai, txt, alt, bg, fg, ts)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, alt or 38) b.BackgroundColor3 = bg or C_CARD
	b.Text = txt b.TextColor3 = fg or C_TXT b.Font = Enum.Font.GothamBold b.TextSize = ts or 11 b.ZIndex = 33 b.Parent = pai
	estilo(b, 9) return b
end
local function mkSec(pai, txt)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, 0, 0, 22) l.BackgroundColor3 = C_PAINEL
	l.Text = txt l.TextColor3 = C_TXT l.Font = Enum.Font.GothamBold l.TextSize = 10 l.ZIndex = 33 l.Parent = pai
	estilo(l, 8)
end

mkSec(contFPS, "NÍVEIS DE DESEMPENHO")
local sombrasPadrao, origProps, nivelAtualFPS, connsFPS = Lighting.GlobalShadows, {}, 0, {}

local function salvarOrig(obj, prop)
	if not obj then return end
	if not origProps[obj] then origProps[obj] = {} end
	if origProps[obj][prop] == nil then local ok, val = pcall(function() return obj[prop] end) if ok then origProps[obj][prop] = val end end
end
local function aplicarNoObjeto(obj, nivel)
	if nivel >= 1 and obj:IsA("PostEffect") then salvarOrig(obj, "Enabled") pcall(function() obj.Enabled = false end) end
	if nivel >= 2 then
		if obj:IsA("BasePart") then salvarOrig(obj, "CastShadow") pcall(function() obj.CastShadow = false end)
		elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then salvarOrig(obj, "Enabled") pcall(function() obj.Enabled = false end) end
	end
	if nivel >= 3 then
		if obj:IsA("BasePart") then salvarOrig(obj, "Material") pcall(function() obj.Material = Enum.Material.SmoothPlastic end)
		elseif obj:IsA("Decal") or obj:IsA("Texture") then salvarOrig(obj, "Transparency") pcall(function() obj.Transparency = 1 end) end
	end
end
local function garantirWatchersFPS()
	if #connsFPS > 0 then return end
	table.insert(connsFPS, Workspace.DescendantAdded:Connect(function(o) if nivelAtualFPS > 0 then aplicarNoObjeto(o, nivelAtualFPS) end end))
	table.insert(connsFPS, Lighting.DescendantAdded:Connect(function(o) if nivelAtualFPS > 0 then aplicarNoObjeto(o, nivelAtualFPS) end end))
end
local function limparWatchersFPS() for _, c in ipairs(connsFPS) do c:Disconnect() end table.clear(connsFPS) end
local function aplicarNivelFPS(nivel)
	nivelAtualFPS = nivel
	if nivel >= 1 then pcall(function() Lighting.GlobalShadows = false end) for _, o in ipairs(Lighting:GetDescendants()) do aplicarNoObjeto(o, nivel) end end
	if nivel >= 2 then for _, o in ipairs(Workspace:GetDescendants()) do aplicarNoObjeto(o, nivel) end end
	garantirWatchersFPS()
	status.Text = "Status: FPS Nível " .. tostring(nivel) .. " ativo"
end
local function restaurarFPS()
	nivelAtualFPS = 0 limparWatchersFPS()
	pcall(function() Lighting.GlobalShadows = sombrasPadrao end)
	for obj, props in pairs(origProps) do if obj and obj.Parent then for prop, val in pairs(props) do pcall(function() obj[prop] = val end) end end end
	for _, o in ipairs(Lighting:GetDescendants()) do if o:IsA("PostEffect") then pcall(function() o.Enabled = true end) end end
	for _, o in ipairs(Workspace:GetDescendants()) do
		if o:IsA("BasePart") then pcall(function() o.CastShadow = true end)
		elseif o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") or o:IsA("Fire") or o:IsA("Smoke") or o:IsA("Sparkles") then pcall(function() o.Enabled = true end)
		elseif o:IsA("Decal") or o:IsA("Texture") then pcall(function() if o.Transparency == 1 then o.Transparency = 0 end end) end
	end
	table.clear(origProps)
	status.Text = "Status: Gráficos restaurados ao padrão"
end

local bFps1 = mkBtn(contFPS, "FPS NÍVEL 1 (LEVE - SOMBRAS)", 38, C_CARD, C_TXT, 11)
local bFps2 = mkBtn(contFPS, "FPS NÍVEL 2 (MÉDIO - EFEITOS)", 38, C_CARD, C_WARN, 11)
local bFps3 = mkBtn(contFPS, "FPS NÍVEL 3 (MÁXIMO - LISO)", 38, C_CARD, C_OK, 11)
local bRestaurarFps = mkBtn(contFPS, "RESTAURAR FPS (PADRÃO)", 40, C_PRIM, C_TXT, 11)
local function pintarFPS(ativoBtn)
	bFps1.BackgroundColor3 = C_CARD bFps2.BackgroundColor3 = C_CARD bFps3.BackgroundColor3 = C_CARD
	if ativoBtn then ativoBtn.BackgroundColor3 = C_OK end
end
bFps1.Activated:Connect(function() aplicarNivelFPS(1) pintarFPS(bFps1) end)
bFps2.Activated:Connect(function() aplicarNivelFPS(2) pintarFPS(bFps2) end)
bFps3.Activated:Connect(function() aplicarNivelFPS(3) pintarFPS(bFps3) end)
bRestaurarFps.Activated:Connect(function() restaurarFPS() pintarFPS(nil) end)

mkSec(contMais, "DIVERSÃO & UTILIDADES")
local spinOn, connSpn = false, nil
local linhaFun = Instance.new("Frame") linhaFun.Size = UDim2.new(1, 0, 0, 38) linhaFun.BackgroundTransparency = 1 linhaFun.ZIndex = 32 linhaFun.Parent = contMais
local bSpin = mkBtn(linhaFun, "SPIN: OFF", 38, C_CARD, C_SUB, 11) bSpin.Size = UDim2.new(0.49, 0, 1, 0)
local bSentar = mkBtn(linhaFun, "SENTAR / LEVANTAR", 38, C_PRIM, C_TXT, 11) bSentar.Size = UDim2.new(0.49, 0, 1, 0) bSentar.Position = UDim2.new(0.51, 0, 0, 0)
local bResp = mkBtn(contMais, "RESPAWN RÁPIDO", 38, C_BAD, C_TXT, 12)

mkSec(contMais, "INTERFACE MOBILE")
local compacta = false
local bTam = mkBtn(contMais, "BOLINHA: NORMAL (58px)", 38, C_CARD, C_TXT, 11)
local bPos = mkBtn(contMais, "RESETAR POSIÇÃO DO MENU", 38, C_PRIM, C_TXT, 11)

bSpin.Activated:Connect(function()
	spinOn = not spinOn bSpin.Text = spinOn and "SPIN: ON" or "SPIN: OFF"
	bSpin.BackgroundColor3 = spinOn and C_OK or C_CARD bSpin.TextColor3 = spinOn and C_TXT or C_SUB
	if spinOn and not connSpn then connSpn = RunService.Heartbeat:Connect(function(dt) local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if spinOn and r then r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(600 * dt), 0) end end)
	elseif not spinOn and connSpn then connSpn:Disconnect() connSpn = nil end
end)
bSentar.Activated:Connect(function() local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if h then h.Sit = not h.Sit end end)
bResp.Activated:Connect(function() local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if h then h.Health = 0 end end)
bTam.Activated:Connect(function() compacta = not compacta bolinha.Size = compacta and UDim2.fromOffset(44, 44) or UDim2.fromOffset(58, 58) bTam.Text = compacta and "BOLINHA: COMPACTA (44px)" or "BOLINHA: NORMAL (58px)" end)
bPos.Activated:Connect(function() bolinha.Position = UDim2.fromOffset(16, 110) menu.Position = UDim2.fromOffset(82, 54) status.Text = "Status: Posição resetada" end)
		
