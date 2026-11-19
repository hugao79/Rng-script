local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	return
end

local RAIO_TP = 3
local TEMPO_TROCA_TP = 0.25

local VELOCIDADE_PADRAO = 16
local VELOCIDADE_INICIAL = 32
local PASSO_VELOCIDADE = 4
local VELOCIDADE_MINIMA = 8
local VELOCIDADE_MAXIMA = 150

local PULO_INICIAL = 100
local PASSO_PULO = 10
local PULO_MINIMO = 10
local PULO_MAXIMO = 250

local FLY_VEL_INICIAL = 55
local PASSO_FLY = 10
local FLY_MIN = 15
local FLY_MAX = 200

local GRAVIDADE_PADRAO = Workspace.Gravity
local GRAVIDADE_INICIAL = 75
local PASSO_GRAVIDADE = 15
local GRAVIDADE_MINIMA = 15
local GRAVIDADE_MAXIMA = 300

local FOV_PADRAO = 70
local FOV_INICIAL = 90
local PASSO_FOV = 5
local FOV_MINIMO = 40
local FOV_MAXIMO = 120

local SPIN_VEL_INICIAL = 20
local PASSO_SPIN = 5
local SPIN_MIN = 5
local SPIN_MAX = 80

local AIM_SUAVIDADE_INICIAL = 14
local PASSO_AIM_SUAVIDADE = 2
local AIM_SUAVIDADE_MIN = 2
local AIM_SUAVIDADE_MAX = 40

local COR_FUNDO = Color3.fromRGB(17, 18, 26)
local COR_BARRA = Color3.fromRGB(29, 31, 43)
local COR_CARD = Color3.fromRGB(25, 27, 37)
local COR_ITEM = Color3.fromRGB(43, 46, 63)
local COR_DESTAQUE = Color3.fromRGB(88, 101, 242)
local COR_VERDE = Color3.fromRGB(46, 160, 90)
local COR_VERMELHO = Color3.fromRGB(205, 65, 65)
local COR_AMARELO = Color3.fromRGB(215, 165, 40)
local COR_CIANO = Color3.fromRGB(56, 189, 248)
local COR_TEXTO = Color3.fromRGB(246, 247, 252)
local COR_TEXTO_FRACO = Color3.fromRGB(165, 170, 190)

local conexoesGerais = {}

local function guardarConexao(conexao)
	table.insert(conexoesGerais, conexao)
	return conexao
end

local function criar(classe, props)
	local obj = Instance.new(classe)
	local pai = props.Parent

	for nome, valor in pairs(props) do
		if nome ~= "Parent" then
			obj[nome] = valor
		end
	end

	if pai then
		obj.Parent = pai
	end
	return obj
end

local function arredondar(obj, raio)
	if obj then
		criar("UICorner", {
			CornerRadius = raio,
			Parent = obj,
		})
	end
end

local function contornar(obj, cor, espessura)
	if obj then
		criar("UIStroke", {
			Color = cor or Color3.fromRGB(68, 72, 96),
			Thickness = espessura or 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Parent = obj,
		})
	end
end
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

local antigo = playerGui:FindFirstChild("GrudarMenu")
if antigo then
	antigo:Destroy()
end

local gui = criar("ScreenGui", {
	Name = "GrudarMenu",
	Enabled = true,
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 9999,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = playerGui,
})

local POS_BOLINHA_PADRAO = UDim2.fromOffset(16, 110)
local POS_MENU_PADRAO = UDim2.fromOffset(80, 60)
local menuTravado = false

local function tornarArrastavel(alca, alvo, aoToque, verificarTrava)
	local arrastando = false
	local entrada
	local inicioToque
	local inicioPos
	local moveu = false

	guardarConexao(alca.InputBegan:Connect(function(input)
		local tipo = input.UserInputType
		if tipo == Enum.UserInputType.Touch or tipo == Enum.UserInputType.MouseButton1 then
			arrastando = true
			moveu = false
			entrada = input
			inicioToque = input.Position
			inicioPos = alvo.Position
		end
	end))

	guardarConexao(UserInputService.InputChanged:Connect(function(input)
		if not arrastando then
			return
		end
		if verificarTrava and menuTravado then
			return
		end

		local mesmoToque = input == entrada
		local mesmoMouse = input.UserInputType == Enum.UserInputType.MouseMovement
			and entrada.UserInputType == Enum.UserInputType.MouseButton1

		if not (mesmoToque or mesmoMouse) then
			return
		end

		local delta = input.Position - inicioToque
		if delta.Magnitude > 8 then
			moveu = true
		end

		local tela = gui.AbsoluteSize
		local tam = alvo.AbsoluteSize

		local x = math.clamp(inicioPos.X.Offset + delta.X, 0, math.max(0, tela.X - tam.X))
		local y = math.clamp(inicioPos.Y.Offset + delta.Y, 0, math.max(0, tela.Y - tam.Y))
		alvo.Position = UDim2.fromOffset(x, y)
	end))

	guardarConexao(UserInputService.InputEnded:Connect(function(input)
		if not arrastando then
			return
		end

		local mesmoToque = input == entrada
		local mesmoMouse = input.UserInputType == Enum.UserInputType.MouseButton1
			and entrada.UserInputType == Enum.UserInputType.MouseButton1

		if mesmoToque or mesmoMouse then
			arrastando = false
			if not moveu and aoToque then
				aoToque()
			end
		end
	end))
end

local bolinha = criar("TextButton", {
	Name = "Bolinha",
	Size = UDim2.fromOffset(58, 58),
	Position = POS_BOLINHA_PADRAO,
	BackgroundColor3 = COR_DESTAQUE,
	AutoButtonColor = false,
	Text = "HUB",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	Visible = true,
	ZIndex = 20,
	Parent = gui,
})
arredondar(bolinha, UDim.new(1, 0))
contornar(bolinha, Color3.fromRGB(150, 160, 255), 1.5)

local menu = criar("Frame", {
	Name = "Menu",
	Size = UDim2.fromOffset(276, 386),
	Position = POS_MENU_PADRAO,
	BackgroundColor3 = COR_FUNDO,
	BorderSizePixel = 0,
	Active = true,
	Visible = false,
	ZIndex = 15,
	Parent = gui,
})
arredondar(menu, UDim.new(0, 14))
contornar(menu, Color3.fromRGB(64, 68, 92), 1.2)

local barra = criar("Frame", {
	Name = "Barra",
	Size = UDim2.new(1, 0, 0, 42),
	BackgroundColor3 = COR_BARRA,
	BorderSizePixel = 0,
	Active = true,
	Parent = menu,
})
arredondar(barra, UDim.new(0, 14))

criar("Frame", {
	Size = UDim2.new(1, 0, 0, 14),
	Position = UDim2.new(0, 0, 1, -14),
	BackgroundColor3 = COR_BARRA,
	BorderSizePixel = 0,
	Parent = barra,
})

criar("TextLabel", {
	Size = UDim2.new(1, -56, 1, 0),
	Position = UDim2.fromOffset(14, 0),
	BackgroundTransparency = 1,
	Text = "Hub Mobile Apex",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = barra,
})

local fechar = criar("TextButton", {
	Name = "Fechar",
	Size = UDim2.fromOffset(30, 30),
	Position = UDim2.new(1, -38, 0, 6),
	BackgroundColor3 = COR_VERMELHO,
	AutoButtonColor = false,
	Text = "X",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	Parent = barra,
})
arredondar(fechar, UDim.new(0, 8))

local NOMES_ABAS = { "TP", "Aim", "ESP", "Speed", "Jump", "Mov", "Cam", "Fun", "FPS", "Util", "UI" }
local LARGURA_ABA = 45
local ESPACO_ABA = 5

local barraAbas = criar("ScrollingFrame", {
	Name = "Abas",
	Size = UDim2.new(1, -20, 0, 34),
	Position = UDim2.fromOffset(10, 48),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 2,
	ScrollingDirection = Enum.ScrollingDirection.X,
	CanvasSize = UDim2.fromOffset(#NOMES_ABAS * (LARGURA_ABA + ESPACO_ABA), 0),
	Parent = menu,
})

local botoesAbas = {}
local containersAbas = {}

for indice, nomeAba in ipairs(NOMES_ABAS) do
	local btn = criar("TextButton", {
		Name = "Aba_" .. nomeAba,
		Size = UDim2.fromOffset(LARGURA_ABA, 30),
		Position = UDim2.fromOffset((indice - 1) * (LARGURA_ABA + ESPACO_ABA), 2),
		BackgroundColor3 = COR_ITEM,
		AutoButtonColor = false,
		Text = nomeAba,
		TextColor3 = COR_TEXTO_FRACO,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		Parent = barraAbas,
	})
	arredondar(btn, UDim.new(0, 8))
	botoesAbas[nomeAba] = btn

	local cont = criar("Frame", {
		Name = "Conteudo_" .. nomeAba,
		Size = UDim2.new(1, -20, 0, 264),
		Position = UDim2.fromOffset(10, 110),
		BackgroundTransparency = 1,
		Visible = (nomeAba == "TP"),
		Parent = menu,
	})
	containersAbas[nomeAba] = cont
end

local faixaStatus = criar("Frame", {
	Name = "FaixaStatus",
	Size = UDim2.new(1, -20, 0, 22),
	Position = UDim2.fromOffset(10, 85),
	BackgroundColor3 = COR_CARD,
	BorderSizePixel = 0,
	Parent = menu,
})
arredondar(faixaStatus, UDim.new(0, 6))

local status = criar("TextLabel", {
	Name = "Status",
	Size = UDim2.new(1, -12, 1, 0),
	Position = UDim2.fromOffset(6, 0),
	BackgroundTransparency = 1,
	Text = "Pronto para usar",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamMedium,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Parent = faixaStatus,
})
-- ABA TP
local contTP = containersAbas.TP

local caixaBusca = criar("TextBox", {
	Name = "BuscaJogador",
	Size = UDim2.new(1, 0, 0, 28),
	Position = UDim2.fromOffset(0, 0),
	BackgroundColor3 = COR_CARD,
	BorderSizePixel = 0,
	PlaceholderText = "Buscar jogador...",
	PlaceholderColor3 = COR_TEXTO_FRACO,
	Text = "",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.Gotham,
	TextSize = 12,
	ClearTextOnFocus = false,
	Parent = contTP,
})
arredondar(caixaBusca, UDim.new(0, 8))
contornar(caixaBusca, Color3.fromRGB(55, 59, 80), 1)

local lista = criar("ScrollingFrame", {
	Name = "Lista",
	Size = UDim2.new(1, 0, 0, 138),
	Position = UDim2.fromOffset(0, 34),
	BackgroundColor3 = COR_BARRA,
	BorderSizePixel = 0,
	ScrollBarThickness = 4,
	ScrollingDirection = Enum.ScrollingDirection.Y,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	Parent = contTP,
})
arredondar(lista, UDim.new(0, 10))
criar("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.Name, Parent = lista })
criar("UIPadding", {
	PaddingTop = UDim.new(0, 4),
	PaddingBottom = UDim.new(0, 4),
	PaddingLeft = UDim.new(0, 5),
	PaddingRight = UDim.new(0, 7),
	Parent = lista,
})

local vazio = criar("TextLabel", {
	Name = "Vazio",
	Size = lista.Size,
	Position = lista.Position,
	BackgroundTransparency = 1,
	Text = "Nenhum jogador encontrado",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.Gotham,
	TextSize = 12,
	Parent = contTP,
})

local botaoTPDireto = criar("TextButton", {
	Name = "TPDireto",
	Size = UDim2.new(0.48, 0, 0, 38),
	Position = UDim2.fromOffset(0, 178),
	BackgroundColor3 = COR_DESTAQUE,
	AutoButtonColor = false,
	Text = "IR ATÉ ALVO",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = contTP,
})
arredondar(botaoTPDireto, UDim.new(0, 9))

local botaoTPCostas = criar("TextButton", {
	Name = "TPCostas",
	Size = UDim2.new(0.49, 0, 0, 38),
	Position = UDim2.new(0.51, 0, 0, 178),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "COSTAS: OFF",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = contTP,
})
arredondar(botaoTPCostas, UDim.new(0, 9))

local botaoTP = criar("TextButton", {
	Name = "AlternarTP",
	Size = UDim2.new(1, 0, 0, 40),
	Position = UDim2.fromOffset(0, 222),
	BackgroundColor3 = COR_VERDE,
	AutoButtonColor = false,
	Text = "ATIVAR TP CAÓTICO",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	Parent = contTP,
})
arredondar(botaoTP, UDim.new(0, 10))

-- ABA AIM (MIRA / FOCO)
local contAim = containersAbas.Aim

local painelAimSuav = criar("Frame", {
	Name = "PainelAimSuavidade",
	Size = UDim2.new(1, 0, 0, 74),
	Position = UDim2.fromOffset(0, 2),
	BackgroundColor3 = COR_BARRA,
	BorderSizePixel = 0,
	Parent = contAim,
})
arredondar(painelAimSuav, UDim.new(0, 10))

local labelAimSuav = criar("TextLabel", {
	Size = UDim2.new(1, -16, 0, 22),
	Position = UDim2.fromOffset(8, 4),
	BackgroundTransparency = 1,
	Text = "Suavidade da Mira: " .. tostring(AIM_SUAVIDADE_INICIAL),
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = painelAimSuav,
})

local btnMenosAim = criar("TextButton", {
	Size = UDim2.fromOffset(112, 34),
	Position = UDim2.fromOffset(10, 32),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "- Mais Suave",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = painelAimSuav,
})
arredondar(btnMenosAim, UDim.new(0, 8))

local btnMaisAim = criar("TextButton", {
	Size = UDim2.fromOffset(112, 34),
	Position = UDim2.fromOffset(134, 32),
	BackgroundColor3 = COR_DESTAQUE,
	AutoButtonColor = false,
	Text = "+ Mais Firme",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = painelAimSuav,
})
arredondar(btnMaisAim, UDim.new(0, 8))

local botaoAimModoFiltro = criar("TextButton", {
	Size = UDim2.new(1, 0, 0, 38),
	Position = UDim2.fromOffset(0, 84),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "PRIORIDADE: TELA (FOV)",
	TextColor3 = COR_CIANO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = contAim,
})
arredondar(botaoAimModoFiltro, UDim.new(0, 9))

local botaoAimParte = criar("TextButton", {
	Size = UDim2.new(1, 0, 0, 38),
	Position = UDim2.fromOffset(0, 128),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "ALVO DA MIRA: CABEÇA (HEAD)",
	TextColor3 = COR_AMARELO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = contAim,
})
arredondar(botaoAimParte, UDim.new(0, 9))

local botaoFocoCam = criar("TextButton", {
	Size = UDim2.new(1, 0, 0, 42),
	Position = UDim2.fromOffset(0, 174),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "FOCO NO ALVO (TP): OFF",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = contAim,
})
arredondar(botaoFocoCam, UDim.new(0, 10))

local botaoAimProximo = criar("TextButton", {
	Size = UDim2.new(1, 0, 0, 42),
	Position = UDim2.fromOffset(0, 222),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "MIRA AUTOMÁTICA (MAIS PRÓXIMO): OFF",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = contAim,
})
arredondar(botaoAimProximo, UDim.new(0, 10))

-- ABA ESP
local contESP = containersAbas.ESP

local descESP = criar("TextLabel", {
	Size = UDim2.new(1, 0, 0, 56),
	Position = UDim2.fromOffset(0, 4),
	BackgroundColor3 = COR_BARRA,
	Text = "Mostra nome, @usuário, HP e distância\nacima dos jogadores + contornos visuais.",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.Gotham,
	TextSize = 11,
	Parent = contESP,
})
arredondar(descESP, UDim.new(0, 10))

local botaoEsp = criar("TextButton", {
	Name = "AlternarESP",
	Size = UDim2.new(1, 0, 0, 44),
	Position = UDim2.fromOffset(0, 68),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "ESP TEXTO + HP: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = contESP,
})
arredondar(botaoEsp, UDim.new(0, 10))

local botaoHighlight = criar("TextButton", {
	Name = "AlternarHighlight",
	Size = UDim2.new(1, 0, 0, 44),
	Position = UDim2.fromOffset(0, 120),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "CONTORNO NO ALVO: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = contESP,
})
arredondar(botaoHighlight, UDim.new(0, 10))

local botaoHighlightTodos = criar("TextButton", {
	Name = "AlternarHighlightTodos",
	Size = UDim2.new(1, 0, 0, 44),
	Position = UDim2.fromOffset(0, 172),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "CONTORNO EM TODOS: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = contESP,
})
arredondar(botaoHighlightTodos, UDim.new(0, 10))
-- ABA SPEED
local contSpeed = containersAbas.Speed

local painelSpeed = criar("Frame", {
	Name = "PainelSpeed",
	Size = UDim2.new(1, 0, 0, 96),
	Position = UDim2.fromOffset(0, 4),
	BackgroundColor3 = COR_BARRA,
	BorderSizePixel = 0,
	Parent = contSpeed,
})
arredondar(painelSpeed, UDim.new(0, 10))

local labelSpeed = criar("TextLabel", {
	Name = "ValorSpeed",
	Size = UDim2.new(1, -20, 0, 30),
	Position = UDim2.fromOffset(10, 6),
	BackgroundTransparency = 1,
	Text = "Velocidade: " .. tostring(VELOCIDADE_INICIAL),
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	Parent = painelSpeed,
})

local btnMenos = criar("TextButton", {
	Name = "DiminuirSpeed",
	Size = UDim2.fromOffset(74, 38),
	Position = UDim2.fromOffset(10, 46),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "- Menos",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = painelSpeed,
})
arredondar(btnMenos, UDim.new(0, 8))

local btnPadraoSpeed = criar("TextButton", {
	Name = "PadraoSpeed",
	Size = UDim2.fromOffset(76, 38),
	Position = UDim2.fromOffset(90, 46),
	BackgroundColor3 = COR_CARD,
	AutoButtonColor = false,
	Text = "Padrão",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = painelSpeed,
})
arredondar(btnPadraoSpeed, UDim.new(0, 8))

local btnMais = criar("TextButton", {
	Name = "AumentarSpeed",
	Size = UDim2.fromOffset(74, 38),
	Position = UDim2.fromOffset(172, 46),
	BackgroundColor3 = COR_DESTAQUE,
	AutoButtonColor = false,
	Text = "+ Mais",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = painelSpeed,
})
arredondar(btnMais, UDim.new(0, 8))

local botaoSpeed = criar("TextButton", {
	Name = "AlternarSpeed",
	Size = UDim2.new(1, 0, 0, 44),
	Position = UDim2.fromOffset(0, 108),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "WALKSPEED: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	Parent = contSpeed,
})
arredondar(botaoSpeed, UDim.new(0, 10))

local botaoCFrameSpeed = criar("TextButton", {
	Name = "AlternarCFrameSpeed",
	Size = UDim2.new(1, 0, 0, 44),
	Position = UDim2.fromOffset(0, 160),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "CFRAME SPEED: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = contSpeed,
})
arredondar(botaoCFrameSpeed, UDim.new(0, 10))

-- ABA JUMP
local contJump = containersAbas.Jump

local painelJump = criar("Frame", {
	Name = "PainelJump",
	Size = UDim2.new(1, 0, 0, 96),
	Position = UDim2.fromOffset(0, 4),
	BackgroundColor3 = COR_BARRA,
	BorderSizePixel = 0,
	Parent = contJump,
})
arredondar(painelJump, UDim.new(0, 10))

local labelJump = criar("TextLabel", {
	Name = "ValorJump",
	Size = UDim2.new(1, -20, 0, 30),
	Position = UDim2.fromOffset(10, 6),
	BackgroundTransparency = 1,
	Text = "Força do pulo: " .. tostring(PULO_INICIAL),
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	Parent = painelJump,
})

local btnMenosJump = criar("TextButton", {
	Name = "DiminuirJump",
	Size = UDim2.fromOffset(112, 38),
	Position = UDim2.fromOffset(10, 46),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "- Diminuir",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = painelJump,
})
arredondar(btnMenosJump, UDim.new(0, 8))

local btnMaisJump = criar("TextButton", {
	Name = "AumentarJump",
	Size = UDim2.fromOffset(112, 38),
	Position = UDim2.fromOffset(134, 46),
	BackgroundColor3 = COR_DESTAQUE,
	AutoButtonColor = false,
	Text = "+ Aumentar",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = painelJump,
})
arredondar(btnMaisJump, UDim.new(0, 8))

local botaoJump = criar("TextButton", {
	Name = "AlternarJump",
	Size = UDim2.new(1, 0, 0, 44),
	Position = UDim2.fromOffset(0, 108),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "SUPER JUMP: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	Parent = contJump,
})
arredondar(botaoJump, UDim.new(0, 10))

local botaoInfJump = criar("TextButton", {
	Name = "AlternarInfJump",
	Size = UDim2.new(1, 0, 0, 44),
	Position = UDim2.fromOffset(0, 160),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "PULO INFINITO: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	Parent = contJump,
})
arredondar(botaoInfJump, UDim.new(0, 10))

-- ABA MOV
local contMov = containersAbas.Mov

local painelFly = criar("Frame", {
	Name = "PainelFly",
	Size = UDim2.new(1, 0, 0, 84),
	Position = UDim2.fromOffset(0, 4),
	BackgroundColor3 = COR_BARRA,
	BorderSizePixel = 0,
	Parent = contMov,
})
arredondar(painelFly, UDim.new(0, 10))

local labelFly = criar("TextLabel", {
	Size = UDim2.new(1, -16, 0, 24),
	Position = UDim2.fromOffset(8, 4),
	BackgroundTransparency = 1,
	Text = "Voo Mobile: " .. tostring(FLY_VEL_INICIAL),
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	Parent = painelFly,
})

local btnMenosFly = criar("TextButton", {
	Size = UDim2.fromOffset(64, 34),
	Position = UDim2.fromOffset(8, 38),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "- Vel",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = painelFly,
})
arredondar(btnMenosFly, UDim.new(0, 8))

local btnMaisFly = criar("TextButton", {
	Size = UDim2.fromOffset(64, 34),
	Position = UDim2.fromOffset(78, 38),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "+ Vel",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = painelFly,
})
arredondar(btnMaisFly, UDim.new(0, 8))

local botaoFly = criar("TextButton", {
	Size = UDim2.fromOffset(100, 34),
	Position = UDim2.fromOffset(148, 38),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "FLY: OFF",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = painelFly,
})
arredondar(botaoFly, UDim.new(0, 8))

local botaoNoClip = criar("TextButton", {
	Name = "AlternarNoClip",
	Size = UDim2.new(1, 0, 0, 40),
	Position = UDim2.fromOffset(0, 94),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "NOCLIP: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = contMov,
})
arredondar(botaoNoClip, UDim.new(0, 9))

local painelGrav = criar("Frame", {
	Name = "PainelGravidade",
	Size = UDim2.new(1, 0, 0, 114),
	Position = UDim2.fromOffset(0, 140),
	BackgroundColor3 = COR_BARRA,
	BorderSizePixel = 0,
	Parent = contMov,
})
arredondar(painelGrav, UDim.new(0, 10))

local labelGrav = criar("TextLabel", {
	Size = UDim2.new(1, -16, 0, 24),
	Position = UDim2.fromOffset(8, 4),
	BackgroundTransparency = 1,
	Text = "Gravidade: " .. tostring(GRAVIDADE_INICIAL),
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	Parent = painelGrav,
})

local btnMenosGrav = criar("TextButton", {
	Size = UDim2.fromOffset(74, 32),
	Position = UDim2.fromOffset(10, 32),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "- Menos",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = painelGrav,
})
arredondar(btnMenosGrav, UDim.new(0, 8))

local btnPadraoGrav = criar("TextButton", {
	Size = UDim2.fromOffset(76, 32),
	Position = UDim2.fromOffset(90, 32),
	BackgroundColor3 = COR_CARD,
	AutoButtonColor = false,
	Text = "Padrão",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = painelGrav,
})
arredondar(btnPadraoGrav, UDim.new(0, 8))

local btnMaisGrav = criar("TextButton", {
	Size = UDim2.fromOffset(74, 32),
	Position = UDim2.fromOffset(172, 32),
	BackgroundColor3 = COR_DESTAQUE,
	AutoButtonColor = false,
	Text = "+ Mais",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = painelGrav,
})
arredondar(btnMaisGrav, UDim.new(0, 8))

local botaoGrav = criar("TextButton", {
	Size = UDim2.new(1, -20, 0, 36),
	Position = UDim2.fromOffset(10, 70),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "GRAVIDADE CUSTOM: OFF",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = painelGrav,
})
arredondar(botaoGrav, UDim.new(0, 8))
-- ABA CAM
local contCam = containersAbas.Cam

local botaoOlharAlvo = criar("TextButton", {
	Size = UDim2.new(1, 0, 0, 44),
	Position = UDim2.fromOffset(0, 4),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "BONECO OLHAR PRO ALVO: OFF",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = contCam,
})
arredondar(botaoOlharAlvo, UDim.new(0, 10))

local botaoFullbright = criar("TextButton", {
	Size = UDim2.new(1, 0, 0, 44),
	Position = UDim2.fromOffset(0, 54),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "FULLBRIGHT (CLAREAR): OFF",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = contCam,
})
arredondar(botaoFullbright, UDim.new(0, 10))

local painelFOV = criar("Frame", {
	Size = UDim2.new(1, 0, 0, 114),
	Position = UDim2.fromOffset(0, 106),
	BackgroundColor3 = COR_BARRA,
	BorderSizePixel = 0,
	Parent = contCam,
})
arredondar(painelFOV, UDim.new(0, 10))

local labelFOV = criar("TextLabel", {
	Size = UDim2.new(1, -16, 0, 24),
	Position = UDim2.fromOffset(8, 4),
	BackgroundTransparency = 1,
	Text = "Campo de visão (FOV): " .. tostring(FOV_INICIAL),
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	Parent = painelFOV,
})

local btnMenosFOV = criar("TextButton", {
	Size = UDim2.fromOffset(74, 32),
	Position = UDim2.fromOffset(10, 32),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "- Perto",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = painelFOV,
})
arredondar(btnMenosFOV, UDim.new(0, 8))

local btnPadraoFOV = criar("TextButton", {
	Size = UDim2.fromOffset(76, 32),
	Position = UDim2.fromOffset(90, 32),
	BackgroundColor3 = COR_CARD,
	AutoButtonColor = false,
	Text = "Padrão",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = painelFOV,
})
arredondar(btnPadraoFOV, UDim.new(0, 8))

local btnMaisFOV = criar("TextButton", {
	Size = UDim2.fromOffset(74, 32),
	Position = UDim2.fromOffset(172, 32),
	BackgroundColor3 = COR_DESTAQUE,
	AutoButtonColor = false,
	Text = "+ Longe",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = painelFOV,
})
arredondar(btnMaisFOV, UDim.new(0, 8))

local botaoFOV = criar("TextButton", {
	Size = UDim2.new(1, -20, 0, 36),
	Position = UDim2.fromOffset(10, 70),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "FOV CUSTOM: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = painelFOV,
})
arredondar(botaoFOV, UDim.new(0, 8))

-- ABA FUN
local contFun = containersAbas.Fun

local painelSpin = criar("Frame", {
	Name = "PainelSpin",
	Size = UDim2.new(1, 0, 0, 114),
	Position = UDim2.fromOffset(0, 4),
	BackgroundColor3 = COR_BARRA,
	BorderSizePixel = 0,
	Parent = contFun,
})
arredondar(painelSpin, UDim.new(0, 10))

local labelSpin = criar("TextLabel", {
	Size = UDim2.new(1, -16, 0, 24),
	Position = UDim2.fromOffset(8, 4),
	BackgroundTransparency = 1,
	Text = "Giro do Boneco: " .. tostring(SPIN_VEL_INICIAL),
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	Parent = painelSpin,
})

local btnMenosSpin = criar("TextButton", {
	Size = UDim2.fromOffset(112, 32),
	Position = UDim2.fromOffset(10, 32),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "- Mais Devagar",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = painelSpin,
})
arredondar(btnMenosSpin, UDim.new(0, 8))

local btnMaisSpin = criar("TextButton", {
	Size = UDim2.fromOffset(112, 32),
	Position = UDim2.fromOffset(134, 32),
	BackgroundColor3 = COR_DESTAQUE,
	AutoButtonColor = false,
	Text = "+ Mais Rápido",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = painelSpin,
})
arredondar(btnMaisSpin, UDim.new(0, 8))

local botaoSpinBoneco = criar("TextButton", {
	Size = UDim2.new(1, -20, 0, 36),
	Position = UDim2.fromOffset(10, 70),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "SPIN NO BONECO: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	Parent = painelSpin,
})
arredondar(botaoSpinBoneco, UDim.new(0, 8))

local botaoCongelar = criar("TextButton", {
	Size = UDim2.new(1, 0, 0, 44),
	Position = UDim2.fromOffset(0, 126),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "CONGELAR NO AR: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = contFun,
})
arredondar(botaoCongelar, UDim.new(0, 10))

local botaoSentar = criar("TextButton", {
	Size = UDim2.new(1, 0, 0, 44),
	Position = UDim2.fromOffset(0, 178),
	BackgroundColor3 = COR_DESTAQUE,
	AutoButtonColor = false,
	Text = "SENTAR / LEVANTAR",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = contFun,
})
arredondar(botaoSentar, UDim.new(0, 10))

-- ABA FPS
local contFPS = containersAbas.FPS

local descFPS = criar("TextLabel", {
	Size = UDim2.new(1, 0, 0, 56),
	Position = UDim2.fromOffset(0, 4),
	BackgroundColor3 = COR_BARRA,
	Text = "Otimiza o jogo no celular removendo\nsombras, partículas e suavizando texturas.",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.Gotham,
	TextSize = 11,
	Parent = contFPS,
})
arredondar(descFPS, UDim.new(0, 10))

local botaoFPS = criar("TextButton", {
	Name = "AlternarFPS",
	Size = UDim2.new(1, 0, 0, 46),
	Position = UDim2.fromOffset(0, 68),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "OTIMIZAR EFEITOS: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = contFPS,
})
arredondar(botaoFPS, UDim.new(0, 10))

local botaoModoLiso = criar("TextButton", {
	Name = "AlternarModoLiso",
	Size = UDim2.new(1, 0, 0, 46),
	Position = UDim2.fromOffset(0, 122),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "MODO LISO (MATERIAIS): DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = contFPS,
})
arredondar(botaoModoLiso, UDim.new(0, 10))

-- ABA UTIL
local contUtil = containersAbas.Util

local botaoAntiAFK = criar("TextButton", {
	Size = UDim2.new(1, 0, 0, 46),
	Position = UDim2.fromOffset(0, 4),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "ANTI-AFK: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	Parent = contUtil,
})
arredondar(botaoAntiAFK, UDim.new(0, 10))

local botaoRespawn = criar("TextButton", {
	Size = UDim2.new(1, 0, 0, 46),
	Position = UDim2.fromOffset(0, 58),
	BackgroundColor3 = COR_DESTAQUE,
	AutoButtonColor = false,
	Text = "RESPAWN RÁPIDO",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	Parent = contUtil,
})
arredondar(botaoRespawn, UDim.new(0, 10))

local botaoResetTudo = criar("TextButton", {
	Size = UDim2.new(1, 0, 0, 48),
	Position = UDim2.fromOffset(0, 112),
	BackgroundColor3 = COR_VERMELHO,
	AutoButtonColor = false,
	Text = "DESLIGAR TUDO (RESET GERAL)",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = contUtil,
})
arredondar(botaoResetTudo, UDim.new(0, 10))

-- ABA UI
local contUI = containersAbas.UI

local botaoTamBolinha = criar("TextButton", {
	Size = UDim2.new(1, 0, 0, 46),
	Position = UDim2.fromOffset(0, 4),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "BOLINHA: NORMAL (58px)",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = contUI,
})
arredondar(botaoTamBolinha, UDim.new(0, 10))

local botaoTravarMenu = criar("TextButton", {
	Size = UDim2.new(1, 0, 0, 46),
	Position = UDim2.fromOffset(0, 58),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "TRAVAR MENU: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = contUI,
})
arredondar(botaoTravarMenu, UDim.new(0, 10))

local botaoPosPadrao = criar("TextButton", {
	Size = UDim2.new(1, 0, 0, 46),
	Position = UDim2.fromOffset(0, 112),
	BackgroundColor3 = COR_DESTAQUE,
	AutoButtonColor = false,
	Text = "RESETAR POSIÇÃO NA TELA",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	Parent = contUI,
})
arredondar(botaoPosPadrao, UDim.new(0, 10))

-- TROCA DE ABAS
local function selecionarAba(nomeAba)
	for _, nome in ipairs(NOMES_ABAS) do
		local ativo = (nome == nomeAba)
		containersAbas[nome].Visible = ativo
		local btn = botoesAbas[nome]
		btn.BackgroundColor3 = ativo and COR_DESTAQUE or COR_ITEM
		btn.TextColor3 = ativo and COR_TEXTO or COR_TEXTO_FRACO
	end
end

for _, nome in ipairs(NOMES_ABAS) do
	guardarConexao(botoesAbas[nome].Activated:Connect(function()
		selecionarAba(nome)
	end))
end
local selecionado = nil

local function obterHumanoid(char)
	local alvoChar = char or LocalPlayer.Character
	return alvoChar and alvoChar:FindFirstChildOfClass("Humanoid")
end

local function obterRaiz(char)
	local alvoChar = char or LocalPlayer.Character
	return alvoChar and alvoChar:FindFirstChild("HumanoidRootPart")
end

local function obterPontoMira(char, usarCabeca)
	if not char then
		return nil
	end
	if usarCabeca then
		local cabeca = char:FindFirstChild("Head")
		if cabeca and cabeca:IsA("BasePart") then
			return cabeca.Position
		end
	end
	local raiz = obterRaiz(char)
	if raiz then
		return raiz.Position
	end
	local cabeca = char:FindFirstChild("Head")
	return cabeca and cabeca.Position or nil
end

-- AIM / MIRA / FOCO
local focoCamAtivo = false
local aimProximoAtivo = false
local aimFiltroTela = true
local aimMiraCabeca = true
local aimSuavidade = AIM_SUAVIDADE_INICIAL
local olharAlvoAtivo = false
local fovAtivo = false
local fovEscolhido = FOV_INICIAL
local conexaoCam = nil

local function encontrarMelhorAlvoMira(cam)
	local minhaRaiz = obterRaiz()
	local melhorPlr = nil
	local melhorScore = math.huge
	local centroTela = Vector2.new(cam.ViewportSize.X * 0.5, cam.ViewportSize.Y * 0.5)

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Parent == Players then
			local charAlvo = plr.Character
			local humAlvo = obterHumanoid(charAlvo)
			local ponto = obterPontoMira(charAlvo, aimMiraCabeca)

			if humAlvo and humAlvo.Health > 0 and ponto then
				if aimFiltroTela then
					local posTela, visivel = cam:WorldToViewportPoint(ponto)
					if visivel and posTela.Z > 0 then
						local distTela = (Vector2.new(posTela.X, posTela.Y) - centroTela).Magnitude
						if distTela < melhorScore then
							melhorScore = distTela
							melhorPlr = plr
						end
					end
				elseif minhaRaiz then
					local distMundo = (minhaRaiz.Position - ponto).Magnitude
					if distMundo < melhorScore then
						melhorScore = distMundo
						melhorPlr = plr
					end
				end
			end
		end
	end

	return melhorPlr
end

local function atualizarUIAim()
	labelAimSuav.Text = "Suavidade da Mira: " .. tostring(aimSuavidade)

	botaoAimModoFiltro.Text = aimFiltroTela and "PRIORIDADE: TELA (FOV)" or "PRIORIDADE: DISTÂNCIA (M)"
	botaoAimModoFiltro.TextColor3 = aimFiltroTela and COR_CIANO or COR_AMARELO

	botaoAimParte.Text = aimMiraCabeca and "ALVO DA MIRA: CABEÇA (HEAD)" or "ALVO DA MIRA: TORSO (ROOT)"
	botaoAimParte.TextColor3 = aimMiraCabeca and COR_AMARELO or COR_CIANO

	botaoFocoCam.Text = focoCamAtivo and "FOCO NO ALVO (TP): ON" or "FOCO NO ALVO (TP): OFF"
	botaoFocoCam.BackgroundColor3 = focoCamAtivo and COR_VERDE or COR_ITEM
	botaoFocoCam.TextColor3 = focoCamAtivo and COR_TEXTO or COR_TEXTO_FRACO

	botaoAimProximo.Text = aimProximoAtivo and "MIRA AUTOMÁTICA: ON" or "MIRA AUTOMÁTICA: OFF"
	botaoAimProximo.BackgroundColor3 = aimProximoAtivo and COR_VERDE or COR_ITEM
	botaoAimProximo.TextColor3 = aimProximoAtivo and COR_TEXTO or COR_TEXTO_FRACO
end

local function atualizarUICam()
	labelFOV.Text = "Campo de visão (FOV): " .. tostring(fovEscolhido)

	botaoOlharAlvo.Text = olharAlvoAtivo and "BONECO OLHAR PRO ALVO: ON" or "BONECO OLHAR PRO ALVO: OFF"
	botaoOlharAlvo.BackgroundColor3 = olharAlvoAtivo and COR_VERDE or COR_ITEM
	botaoOlharAlvo.TextColor3 = olharAlvoAtivo and COR_TEXTO or COR_TEXTO_FRACO

	botaoFOV.Text = fovAtivo and "FOV CUSTOM: LIGADO" or "FOV CUSTOM: DESLIGADO"
	botaoFOV.BackgroundColor3 = fovAtivo and COR_VERDE or COR_ITEM
	botaoFOV.TextColor3 = fovAtivo and COR_TEXTO or COR_TEXTO_FRACO
end

local function garantirLoopCam()
	if conexaoCam then
		return
	end
	conexaoCam = RunService.RenderStepped:Connect(function(dt)
		local cam = Workspace.CurrentCamera
		if not cam then
			return
		end

		if fovAtivo and cam.FieldOfView ~= fovEscolhido then
			cam.FieldOfView = fovEscolhido
		end

		local pontoMira = nil
		local alvoReferencia = nil

		if aimProximoAtivo then
			local plrProximo = encontrarMelhorAlvoMira(cam)
			if plrProximo and plrProximo.Character then
				pontoMira = obterPontoMira(plrProximo.Character, aimMiraCabeca)
				alvoReferencia = obterRaiz(plrProximo.Character)
			end
		elseif focoCamAtivo and selecionado and selecionado.Parent == Players and selecionado.Character then
			pontoMira = obterPontoMira(selecionado.Character, aimMiraCabeca)
			alvoReferencia = obterRaiz(selecionado.Character)
		end

		if pontoMira then
			local cfDesejado = CFrame.lookAt(cam.CFrame.Position, pontoMira)
			local alpha = math.clamp(aimSuavidade * dt, 0.05, 1)
			cam.CFrame = cam.CFrame:Lerp(cfDesejado, alpha)
		end

		if olharAlvoAtivo then
			local refPos = alvoReferencia and alvoReferencia.Position or pontoMira
			local minhaRaiz = obterRaiz()
			if refPos and minhaRaiz then
				local alvoPlano = Vector3.new(refPos.X, minhaRaiz.Position.Y, refPos.Z)
				minhaRaiz.CFrame = CFrame.lookAt(minhaRaiz.Position, alvoPlano)
			end
		end
	end)
end

local function pararLoopCamSeNecessario()
	if not focoCamAtivo and not aimProximoAtivo and not olharAlvoAtivo and not fovAtivo and conexaoCam then
		conexaoCam:Disconnect()
		conexaoCam = nil
	end
end

guardarConexao(btnMenosAim.Activated:Connect(function()
	aimSuavidade = math.clamp(aimSuavidade - PASSO_AIM_SUAVIDADE, AIM_SUAVIDADE_MIN, AIM_SUAVIDADE_MAX)
	atualizarUIAim()
end))

guardarConexao(btnMaisAim.Activated:Connect(function()
	aimSuavidade = math.clamp(aimSuavidade + PASSO_AIM_SUAVIDADE, AIM_SUAVIDADE_MIN, AIM_SUAVIDADE_MAX)
	atualizarUIAim()
end))

guardarConexao(botaoAimModoFiltro.Activated:Connect(function()
	aimFiltroTela = not aimFiltroTela
	atualizarUIAim()
	status.Text = aimFiltroTela and "Prioridade: mais próximo na tela" or "Prioridade: menor distância em studs"
end))

guardarConexao(botaoAimParte.Activated:Connect(function()
	aimMiraCabeca = not aimMiraCabeca
	atualizarUIAim()
	status.Text = aimMiraCabeca and "Mira focando na cabeça" or "Mira focando no torso"
end))

guardarConexao(botaoFocoCam.Activated:Connect(function()
	if not focoCamAtivo and not selecionado then
		status.Text = "Escolha um jogador na aba TP!"
		return
	end
	focoCamAtivo = not focoCamAtivo
	if focoCamAtivo then
		garantirLoopCam()
		status.Text = "Foco de câmera no alvo ligado"
	else
		pararLoopCamSeNecessario()
		status.Text = "Foco de câmera desligado"
	end
	atualizarUIAim()
end))

guardarConexao(botaoAimProximo.Activated:Connect(function()
	aimProximoAtivo = not aimProximoAtivo
	if aimProximoAtivo then
		garantirLoopCam()
		status.Text = "Mira automática ligada"
	else
		pararLoopCamSeNecessario()
		status.Text = "Mira automática desligada"
	end
	atualizarUIAim()
end))

guardarConexao(botaoOlharAlvo.Activated:Connect(function()
	if not olharAlvoAtivo and not selecionado and not aimProximoAtivo then
		status.Text = "Escolha um alvo na TP ou ligue a Mira!"
		return
	end
	olharAlvoAtivo = not olharAlvoAtivo
	if olharAlvoAtivo then
		garantirLoopCam()
		status.Text = "Boneco virando para o alvo"
	else
		pararLoopCamSeNecessario()
		status.Text = "Olhar do boneco desligado"
	end
	atualizarUICam()
end))

-- ESP E CONTORNOS
local espAtivo = false
local highlightAlvoAtivo = false
local highlightTodosAtivo = false
local espTags = {}
local espVersoes = {}
local conexoesESP = {}
local highlightsJogadores = {}

local function removerHighlightJogador(plr)
	local hl = highlightsJogadores[plr]
	if hl then
		pcall(function()
			hl:Destroy()
		end)
		highlightsJogadores[plr] = nil
	end
end

local function atualizarHighlights()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			removerHighlightJogador(plr)
			local charAlvo = plr.Character
			if charAlvo then
				local ehAlvo = (plr == selecionado)
				if (highlightAlvoAtivo and ehAlvo) or highlightTodosAtivo then
					highlightsJogadores[plr] = criar("Highlight", {
						Name = "HubHighlight",
						FillColor = ehAlvo and COR_AMARELO or COR_DESTAQUE,
						OutlineColor = COR_TEXTO,
						FillTransparency = 0.65,
						OutlineTransparency = 0.1,
						DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
						Adornee = charAlvo,
						Parent = charAlvo,
					})
				end
			end
		end
	end
end

local function removerEsp(plr)
	espVersoes[plr] = (espVersoes[plr] or 0) + 1
	local dados = espTags[plr]
	if dados then
		if dados.conexao then
			dados.conexao:Disconnect()
		end
		if dados.billboard then
			pcall(function()
				dados.billboard:Destroy()
			end)
		end
		espTags[plr] = nil
	end
end

local function criarEsp(plr)
	if plr == LocalPlayer or not espAtivo then
		return
	end

	removerEsp(plr)

	local versao = espVersoes[plr]
	local char = plr.Character
	if not char then
		return
	end

	task.spawn(function()
		local cabeca = char:WaitForChild("Head", 5)
		if not cabeca then
			return
		end

		if not espAtivo
			or plr.Parent ~= Players
			or plr.Character ~= char
			or espVersoes[plr] ~= versao then
			return
		end

		local billboard = criar("BillboardGui", {
			Name = "NomeESP",
			Size = UDim2.fromOffset(175, 50),
			StudsOffset = Vector3.new(0, 2.8, 0),
			AlwaysOnTop = true,
			Parent = cabeca,
		})

		local label = criar("TextLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = plr.DisplayName .. "\n(@" .. plr.Name .. ")",
			TextColor3 = COR_TEXTO,
			TextStrokeTransparency = 0.35,
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			Parent = billboard,
		})

		local conn = RunService.RenderStepped:Connect(function()
			if not espAtivo or not billboard.Parent then
				return
			end
			local minhaRaiz = obterRaiz()
			local raizAlvo = obterRaiz(plr.Character)
			local humAlvo = obterHumanoid(plr.Character)
			local hpTxt = humAlvo and string.format("HP %d/%d", math.floor(humAlvo.Health), math.floor(humAlvo.MaxHealth)) or ""

			if minhaRaiz and raizAlvo then
				local dist = math.floor((minhaRaiz.Position - raizAlvo.Position).Magnitude)
				label.Text = string.format("%s (@%s)\n%dm | %s", plr.DisplayName, plr.Name, dist, hpTxt)
			else
				label.Text = plr.DisplayName .. "\n(@" .. plr.Name .. ")"
			end
		end)

		espTags[plr] = {
			billboard = billboard,
			conexao = conn,
		}
	end)
end

local function configurarConexoesESP(plr)
	if plr == LocalPlayer or conexoesESP[plr] then
		return
	end

	local c1 = plr.CharacterAdded:Connect(function()
		if espAtivo then
			criarEsp(plr)
		end
		atualizarHighlights()
	end)

	local c2 = plr.CharacterRemoving:Connect(function()
		removerEsp(plr)
		removerHighlightJogador(plr)
	end)

	conexoesESP[plr] = { c1, c2 }
end

local function limparConexoesESP(plr)
	local listaConn = conexoesESP[plr]
	if listaConn then
		for _, c in ipairs(listaConn) do
			c:Disconnect()
		end
		conexoesESP[plr] = nil
	end
	removerEsp(plr)
	removerHighlightJogador(plr)
end

local function atualizarEspGeral()
	if espAtivo then
		botaoEsp.Text = "ESP TEXTO + HP: LIGADO"
		botaoEsp.BackgroundColor3 = COR_DESTAQUE
		botaoEsp.TextColor3 = COR_TEXTO
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				configurarConexoesESP(plr)
				criarEsp(plr)
			end
		end
	else
		botaoEsp.Text = "ESP TEXTO + HP: DESLIGADO"
		botaoEsp.BackgroundColor3 = COR_ITEM
		botaoEsp.TextColor3 = COR_TEXTO_FRACO
		for _, plr in ipairs(Players:GetPlayers()) do
			removerEsp(plr)
		end
	end

	botaoHighlight.Text = highlightAlvoAtivo and "CONTORNO NO ALVO: LIGADO" or "CONTORNO NO ALVO: DESLIGADO"
	botaoHighlight.BackgroundColor3 = highlightAlvoAtivo and COR_AMARELO or COR_ITEM
	botaoHighlight.TextColor3 = highlightAlvoAtivo and COR_FUNDO or COR_TEXTO_FRACO

	botaoHighlightTodos.Text = highlightTodosAtivo and "CONTORNO EM TODOS: LIGADO" or "CONTORNO EM TODOS: DESLIGADO"
	botaoHighlightTodos.BackgroundColor3 = highlightTodosAtivo and COR_DESTAQUE or COR_ITEM
	botaoHighlightTodos.TextColor3 = highlightTodosAtivo and COR_TEXTO or COR_TEXTO_FRACO

	atualizarHighlights()
end

guardarConexao(botaoEsp.Activated:Connect(function()
	espAtivo = not espAtivo
	atualizarEspGeral()
end))

guardarConexao(botaoHighlight.Activated:Connect(function()
	highlightAlvoAtivo = not highlightAlvoAtivo
	atualizarEspGeral()
end))

guardarConexao(botaoHighlightTodos.Activated:Connect(function()
	highlightTodosAtivo = not highlightTodosAtivo
	atualizarEspGeral()
end))
-- SPEED + CFRAME SPEED
local speedAtivo = false
local cframeSpeedAtivo = false
local velocidadeEscolhida = VELOCIDADE_INICIAL
local conexaoSpeed = nil
local velocidadesOriginais = setmetatable({}, { __mode = "k" })

local function atualizarUISpeed()
	labelSpeed.Text = "Velocidade: " .. tostring(velocidadeEscolhida)

	botaoSpeed.Text = speedAtivo and "WALKSPEED: LIGADO" or "WALKSPEED: DESLIGADO"
	botaoSpeed.BackgroundColor3 = speedAtivo and COR_VERDE or COR_ITEM
	botaoSpeed.TextColor3 = speedAtivo and COR_TEXTO or COR_TEXTO_FRACO

	botaoCFrameSpeed.Text = cframeSpeedAtivo and "CFRAME SPEED: LIGADO" or "CFRAME SPEED: DESLIGADO"
	botaoCFrameSpeed.BackgroundColor3 = cframeSpeedAtivo and COR_DESTAQUE or COR_ITEM
	botaoCFrameSpeed.TextColor3 = cframeSpeedAtivo and COR_TEXTO or COR_TEXTO_FRACO
end

local function garantirLoopSpeed()
	if conexaoSpeed then
		return
	end
	conexaoSpeed = RunService.Heartbeat:Connect(function(dt)
		if not speedAtivo and not cframeSpeedAtivo then
			return
		end
		local hum = obterHumanoid()
		local raiz = obterRaiz()
		if not hum then
			return
		end

		if speedAtivo then
			if velocidadesOriginais[hum] == nil then
				velocidadesOriginais[hum] = hum.WalkSpeed
			end
			if hum.WalkSpeed ~= velocidadeEscolhida then
				hum.WalkSpeed = velocidadeEscolhida
			end
		end

		if cframeSpeedAtivo and raiz and hum.MoveDirection.Magnitude > 0 then
			local extra = math.max(0, velocidadeEscolhida - VELOCIDADE_PADRAO)
			raiz.CFrame = raiz.CFrame + (hum.MoveDirection * extra * dt)
		end
	end)
end

local function pararLoopSpeedSePossivel()
	if not speedAtivo and not cframeSpeedAtivo and conexaoSpeed then
		conexaoSpeed:Disconnect()
		conexaoSpeed = nil
	end
end

local function pararWalkSpeed()
	speedAtivo = false
	local hum = obterHumanoid()
	if hum then
		hum.WalkSpeed = velocidadesOriginais[hum] or VELOCIDADE_PADRAO
	end
	pararLoopSpeedSePossivel()
	atualizarUISpeed()
end

local function pararCFrameSpeed()
	cframeSpeedAtivo = false
	pararLoopSpeedSePossivel()
	atualizarUISpeed()
end

guardarConexao(btnMenos.Activated:Connect(function()
	velocidadeEscolhida = math.clamp(velocidadeEscolhida - PASSO_VELOCIDADE, VELOCIDADE_MINIMA, VELOCIDADE_MAXIMA)
	atualizarUISpeed()
end))

guardarConexao(btnPadraoSpeed.Activated:Connect(function()
	velocidadeEscolhida = VELOCIDADE_PADRAO
	atualizarUISpeed()
end))

guardarConexao(btnMais.Activated:Connect(function()
	velocidadeEscolhida = math.clamp(velocidadeEscolhida + PASSO_VELOCIDADE, VELOCIDADE_MINIMA, VELOCIDADE_MAXIMA)
	atualizarUISpeed()
end))

guardarConexao(botaoSpeed.Activated:Connect(function()
	if speedAtivo then
		pararWalkSpeed()
		status.Text = "WalkSpeed desligado"
	else
		speedAtivo = true
		garantirLoopSpeed()
		atualizarUISpeed()
		status.Text = "WalkSpeed ativado (" .. tostring(velocidadeEscolhida) .. ")"
	end
end))

guardarConexao(botaoCFrameSpeed.Activated:Connect(function()
	if cframeSpeedAtivo then
		pararCFrameSpeed()
		status.Text = "CFrame Speed desligado"
	else
		cframeSpeedAtivo = true
		garantirLoopSpeed()
		atualizarUISpeed()
		status.Text = "CFrame Speed ativado"
	end
end))

-- SUPER JUMP + PULO INFINITO
local jumpAtivo = false
local infJumpAtivo = false
local forcaPulo = PULO_INICIAL
local conexaoJump = nil
local conexaoInfJump = nil
local dadosJumpOriginais = setmetatable({}, { __mode = "k" })

local function aplicarJump()
	local hum = obterHumanoid()
	if not hum then
		return
	end
	if dadosJumpOriginais[hum] == nil then
		dadosJumpOriginais[hum] = {
			JumpPower = hum.JumpPower,
			UseJumpPower = hum.UseJumpPower,
			JumpHeight = hum.JumpHeight,
		}
	end
	if jumpAtivo then
		hum.UseJumpPower = true
		hum.JumpPower = forcaPulo
	end
end

local function atualizarUIJump()
	labelJump.Text = "Força do pulo: " .. tostring(forcaPulo)
	botaoJump.Text = jumpAtivo and "SUPER JUMP: LIGADO" or "SUPER JUMP: DESLIGADO"
	botaoJump.BackgroundColor3 = jumpAtivo and COR_VERDE or COR_ITEM
	botaoJump.TextColor3 = jumpAtivo and COR_TEXTO or COR_TEXTO_FRACO

	botaoInfJump.Text = infJumpAtivo and "PULO INFINITO: LIGADO" or "PULO INFINITO: DESLIGADO"
	botaoInfJump.BackgroundColor3 = infJumpAtivo and COR_VERDE or COR_ITEM
	botaoInfJump.TextColor3 = infJumpAtivo and COR_TEXTO or COR_TEXTO_FRACO
end

local function pararJump()
	jumpAtivo = false
	if conexaoJump then
		conexaoJump:Disconnect()
		conexaoJump = nil
	end
	local hum = obterHumanoid()
	if hum and dadosJumpOriginais[hum] then
		local orig = dadosJumpOriginais[hum]
		hum.JumpPower = orig.JumpPower
		hum.UseJumpPower = orig.UseJumpPower
		hum.JumpHeight = orig.JumpHeight
	end
	atualizarUIJump()
end

local function pararInfJump()
	infJumpAtivo = false
	if conexaoInfJump then
		conexaoInfJump:Disconnect()
		conexaoInfJump = nil
	end
	atualizarUIJump()
end

guardarConexao(btnMenosJump.Activated:Connect(function()
	forcaPulo = math.clamp(forcaPulo - PASSO_PULO, PULO_MINIMO, PULO_MAXIMO)
	atualizarUIJump()
	if jumpAtivo then
		aplicarJump()
	end
end))

guardarConexao(btnMaisJump.Activated:Connect(function()
	forcaPulo = math.clamp(forcaPulo + PASSO_PULO, PULO_MINIMO, PULO_MAXIMO)
	atualizarUIJump()
	if jumpAtivo then
		aplicarJump()
	end
end))

guardarConexao(botaoJump.Activated:Connect(function()
	if jumpAtivo then
		pararJump()
		status.Text = "Super Jump desligado"
	else
		jumpAtivo = true
		aplicarJump()
		if not conexaoJump then
			conexaoJump = RunService.Heartbeat:Connect(function()
				if jumpAtivo then
					aplicarJump()
				end
			end)
		end
		atualizarUIJump()
		status.Text = "Super Jump ativado"
	end
end))

guardarConexao(botaoInfJump.Activated:Connect(function()
	if infJumpAtivo then
		pararInfJump()
		status.Text = "Pulo Infinito desligado"
	else
		infJumpAtivo = true
		if not conexaoInfJump then
			conexaoInfJump = UserInputService.JumpRequest:Connect(function()
				if not infJumpAtivo then
					return
				end
				local hum = obterHumanoid()
				if hum then
					hum:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
		end
		atualizarUIJump()
		status.Text = "Pulo Infinito ativado"
	end
end))

-- FLY MOBILE + NOCLIP + GRAVIDADE
local flyAtivo = false
local flyVel = FLY_VEL_INICIAL
local conexaoFly = nil
local bodyGyro = nil
local bodyVel = nil

local ativoTP = false
local tpCostasAtivo = false
local noClipAtivo = false
local conexaoNoClip = nil
local personagemComColisaoAlterada = nil
local colisaoOriginal = {}

local function restaurarColisao()
	for parte, valorOriginal in pairs(colisaoOriginal) do
		if parte and parte.Parent then
			pcall(function()
				parte.CanCollide = valorOriginal
			end)
		end
	end
	table.clear(colisaoOriginal)
	personagemComColisaoAlterada = nil
end

local function aplicarSemColisao(char)
	if not char then
		return
	end
	if personagemComColisaoAlterada ~= char then
		restaurarColisao()
		personagemComColisaoAlterada = char
	end
	for _, parte in ipairs(char:GetDescendants()) do
		if parte:IsA("BasePart") then
			if colisaoOriginal[parte] == nil then
				colisaoOriginal[parte] = parte.CanCollide
			end
			parte.CanCollide = false
		end
	end
end

local function atualizarUIMov()
	labelFly.Text = "Voo Mobile: " .. tostring(flyVel)
	botaoFly.Text = flyAtivo and "FLY: ON" or "FLY: OFF"
	botaoFly.BackgroundColor3 = flyAtivo and COR_VERDE or COR_ITEM
	botaoFly.TextColor3 = flyAtivo and COR_TEXTO or COR_TEXTO_FRACO

	botaoNoClip.Text = noClipAtivo and "NOCLIP: LIGADO" or "NOCLIP: DESLIGADO"
	botaoNoClip.BackgroundColor3 = noClipAtivo and COR_VERDE or COR_ITEM
	botaoNoClip.TextColor3 = noClipAtivo and COR_TEXTO or COR_TEXTO_FRACO
end

local function pararFly()
	flyAtivo = false
	if conexaoFly then
		conexaoFly:Disconnect()
		conexaoFly = nil
	end
	if bodyGyro then
		pcall(function() bodyGyro:Destroy() end)
		bodyGyro = nil
	end
	if bodyVel then
		pcall(function() bodyVel:Destroy() end)
		bodyVel = nil
	end
	local hum = obterHumanoid()
	if hum then
		hum.PlatformStand = false
	end
	atualizarUIMov()
end

local function iniciarFly()
	pararFly()
	local raiz = obterRaiz()
	local hum = obterHumanoid()
	if not (raiz and hum) then
		status.Text = "Personagem indisponível para voar"
		return
	end

	flyAtivo = true
	hum.PlatformStand = true

	bodyGyro = criar("BodyGyro", {
		MaxTorque = Vector3.new(9e9, 9e9, 9e9),
		P = 9e4,
		CFrame = raiz.CFrame,
		Parent = raiz,
	})

	bodyVel = criar("BodyVelocity", {
		MaxForce = Vector3.new(9e9, 9e9, 9e9),
		Velocity = Vector3.zero,
		Parent = raiz,
	})

	conexaoFly = RunService.RenderStepped:Connect(function()
		if not flyAtivo then
			return
		end
		local r = obterRaiz()
		local h = obterHumanoid()
		local cam = Workspace.CurrentCamera
		if not (r and h and cam and bodyGyro and bodyVel and bodyGyro.Parent and bodyVel.Parent) then
			pararFly()
			return
		end

		h.PlatformStand = true
		bodyGyro.CFrame = cam.CFrame

		local direcao = Vector3.zero
		if h.MoveDirection.Magnitude > 0 then
			local move = h.MoveDirection
			local frente = cam.CFrame.LookVector
			local direita = cam.CFrame.RightVector
			local frentePlana = Vector3.new(frente.X, 0, frente.Z)
			local direitaPlana = Vector3.new(direita.X, 0, direita.Z)

			local avanco = (frentePlana.Magnitude > 0.01) and move:Dot(frentePlana.Unit) or 0
			local lateral = (direitaPlana.Magnitude > 0.01) and move:Dot(direitaPlana.Unit) or 0
			direcao = (frente * avanco) + (direita * lateral)
		end

		bodyVel.Velocity = (direcao.Magnitude > 0) and (direcao.Unit * flyVel) or Vector3.zero
	end)

	atualizarUIMov()
	status.Text = "Modo Voo ativado (use o analógico)"
end

guardarConexao(btnMenosFly.Activated:Connect(function()
	flyVel = math.clamp(flyVel - PASSO_FLY, FLY_MIN, FLY_MAX)
	atualizarUIMov()
end))

guardarConexao(btnMaisFly.Activated:Connect(function()
	flyVel = math.clamp(flyVel + PASSO_FLY, FLY_MIN, FLY_MAX)
	atualizarUIMov()
end))

guardarConexao(botaoFly.Activated:Connect(function()
	if flyAtivo then
		pararFly()
		status.Text = "Modo Voo desligado"
	else
		iniciarFly()
	end
end))

local function pararNoClip()
	noClipAtivo = false
	if conexaoNoClip then
		conexaoNoClip:Disconnect()
		conexaoNoClip = nil
	end
	if not ativoTP and not tpCostasAtivo then
		restaurarColisao()
	end
	atualizarUIMov()
end

guardarConexao(botaoNoClip.Activated:Connect(function()
	if noClipAtivo then
		pararNoClip()
		status.Text = "NoClip desligado"
	else
		noClipAtivo = true
		if not conexaoNoClip then
			conexaoNoClip = RunService.Stepped:Connect(function()
				if noClipAtivo or ativoTP or tpCostasAtivo then
					aplicarSemColisao(LocalPlayer.Character)
				end
			end)
		end
		atualizarUIMov()
		status.Text = "NoClip ativado"
	end
end))

local gravAtivo = false
local gravidadeEscolhida = GRAVIDADE_INICIAL

local function atualizarUIGrav()
	labelGrav.Text = "Gravidade: " .. tostring(gravidadeEscolhida)
	botaoGrav.Text = gravAtivo and "GRAVIDADE CUSTOM: ON" or "GRAVIDADE CUSTOM: OFF"
	botaoGrav.BackgroundColor3 = gravAtivo and COR_VERDE or COR_ITEM
	botaoGrav.TextColor3 = gravAtivo and COR_TEXTO or COR_TEXTO_FRACO
end

local function aplicarGravidade()
	Workspace.Gravity = gravAtivo and gravidadeEscolhida or GRAVIDADE_PADRAO
end

guardarConexao(btnMenosGrav.Activated:Connect(function()
	gravidadeEscolhida = math.clamp(gravidadeEscolhida - PASSO_GRAVIDADE, GRAVIDADE_MINIMA, GRAVIDADE_MAXIMA)
	atualizarUIGrav()
	if gravAtivo then
		aplicarGravidade()
	end
end))

guardarConexao(btnPadraoGrav.Activated:Connect(function()
	gravidadeEscolhida = GRAVIDADE_PADRAO
	atualizarUIGrav()
	if gravAtivo then
		aplicarGravidade()
	end
end))

guardarConexao(btnMaisGrav.Activated:Connect(function()
	gravidadeEscolhida = math.clamp(gravidadeEscolhida + PASSO_GRAVIDADE, GRAVIDADE_MINIMA, GRAVIDADE_MAXIMA)
	atualizarUIGrav()
	if gravAtivo then
		aplicarGravidade()
	end
end))

guardarConexao(botaoGrav.Activated:Connect(function()
	gravAtivo = not gravAtivo
	aplicarGravidade()
	atualizarUIGrav()
	status.Text = gravAtivo and ("Gravidade: " .. tostring(gravidadeEscolhida)) or "Gravidade padrão restaurada"
end))

-- FULLBRIGHT, FOV E FUN
local fullbrightAtivo = false
local conexaoFullbright = nil
local luzOriginal = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
}

local function aplicarFullbright()
	Lighting.Brightness = 2
	Lighting.ClockTime = 14
	Lighting.FogEnd = 100000
	Lighting.Ambient = Color3.fromRGB(180, 180, 180)
	Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
end

local function desativarFullbright()
	fullbrightAtivo = false
	if conexaoFullbright then
		conexaoFullbright:Disconnect()
		conexaoFullbright = nil
	end
	pcall(function()
		Lighting.Brightness = luzOriginal.Brightness
		Lighting.ClockTime = luzOriginal.ClockTime
		Lighting.FogEnd = luzOriginal.FogEnd
		Lighting.Ambient = luzOriginal.Ambient
		Lighting.OutdoorAmbient = luzOriginal.OutdoorAmbient
	end)
end

local function atualizarUICamExtra()
	botaoFullbright.Text = fullbrightAtivo and "FULLBRIGHT (CLAREAR): ON" or "FULLBRIGHT (CLAREAR): OFF"
	botaoFullbright.BackgroundColor3 = fullbrightAtivo and COR_AMARELO or COR_ITEM
	botaoFullbright.TextColor3 = fullbrightAtivo and COR_FUNDO or COR_TEXTO_FRACO
end

guardarConexao(botaoFullbright.Activated:Connect(function()
	if fullbrightAtivo then
		desativarFullbright()
		status.Text = "Iluminação original restaurada"
	else
		fullbrightAtivo = true
		luzOriginal = {
			Brightness = Lighting.Brightness,
			ClockTime = Lighting.ClockTime,
			FogEnd = Lighting.FogEnd,
			Ambient = Lighting.Ambient,
			OutdoorAmbient = Lighting.OutdoorAmbient,
		}
		aplicarFullbright()
		conexaoFullbright = RunService.Heartbeat:Connect(function()
			if fullbrightAtivo then
				aplicarFullbright()
			end
		end)
		status.Text = "Fullbright ativado"
	end
	atualizarUICamExtra()
end))

guardarConexao(btnMenosFOV.Activated:Connect(function()
	fovEscolhido = math.clamp(fovEscolhido - PASSO_FOV, FOV_MINIMO, FOV_MAXIMO)
	atualizarUICam()
end))

guardarConexao(btnPadraoFOV.Activated:Connect(function()
	fovEscolhido = FOV_PADRAO
	atualizarUICam()
	if Workspace.CurrentCamera then
		Workspace.CurrentCamera.FieldOfView = FOV_PADRAO
	end
end))

guardarConexao(btnMaisFOV.Activated:Connect(function()
	fovEscolhido = math.clamp(fovEscolhido + PASSO_FOV, FOV_MINIMO, FOV_MAXIMO)
	atualizarUICam()
end))

guardarConexao(botaoFOV.Activated:Connect(function()
	fovAtivo = not fovAtivo
	if fovAtivo then
		garantirLoopCam()
		status.Text = "FOV customizado ligado"
	else
		if Workspace.CurrentCamera then
			Workspace.CurrentCamera.FieldOfView = FOV_PADRAO
		end
		pararLoopCamSeNecessario()
		status.Text = "FOV padrão restaurado"
	end
	atualizarUICam()
end))

local spinBonecoAtivo = false
local spinVel = SPIN_VEL_INICIAL
local conexaoSpinBoneco = nil
local congeladoAtivo = false

local function atualizarUIFun()
	labelSpin.Text = "Giro do Boneco: " .. tostring(spinVel)

	botaoSpinBoneco.Text = spinBonecoAtivo and "SPIN NO BONECO: LIGADO" or "SPIN NO BONECO: DESLIGADO"
	botaoSpinBoneco.BackgroundColor3 = spinBonecoAtivo and COR_VERDE or COR_ITEM
	botaoSpinBoneco.TextColor3 = spinBonecoAtivo and COR_TEXTO or COR_TEXTO_FRACO

	botaoCongelar.Text = congeladoAtivo and "CONGELAR NO AR: LIGADO" or "CONGELAR NO AR: DESLIGADO"
	botaoCongelar.BackgroundColor3 = congeladoAtivo and COR_AMARELO or COR_ITEM
	botaoCongelar.TextColor3 = congeladoAtivo and COR_FUNDO or COR_TEXTO_FRACO
end

local function pararSpinBoneco()
	spinBonecoAtivo = false
	if conexaoSpinBoneco then
		conexaoSpinBoneco:Disconnect()
		conexaoSpinBoneco = nil
	end
	atualizarUIFun()
end

local function definirCongelado(estado)
	congeladoAtivo = estado
	local raiz = obterRaiz()
	if raiz then
		raiz.Anchored = estado
	end
	atualizarUIFun()
end

guardarConexao(btnMenosSpin.Activated:Connect(function()
	spinVel = math.clamp(spinVel - PASSO_SPIN, SPIN_MIN, SPIN_MAX)
	atualizarUIFun()
end))

guardarConexao(btnMaisSpin.Activated:Connect(function()
	spinVel = math.clamp(spinVel + PASSO_SPIN, SPIN_MIN, SPIN_MAX)
	atualizarUIFun()
end))

guardarConexao(botaoSpinBoneco.Activated:Connect(function()
	if spinBonecoAtivo then
		pararSpinBoneco()
		status.Text = "Spin no boneco desligado"
	else
		spinBonecoAtivo = true
		conexaoSpinBoneco = RunService.Heartbeat:Connect(function(dt)
			if not spinBonecoAtivo then
				return
			end
			local raiz = obterRaiz()
			if raiz then
				raiz.CFrame = raiz.CFrame * CFrame.Angles(0, math.rad(spinVel * 30 * dt), 0)
			end
		end)
		atualizarUIFun()
		status.Text = "Spin no boneco ativado"
	end
end))

guardarConexao(botaoCongelar.Activated:Connect(function()
	definirCongelado(not congeladoAtivo)
	status.Text = congeladoAtivo and "Personagem congelado no ar" or "Personagem descongelado"
end))

guardarConexao(botaoSentar.Activated:Connect(function()
	local hum = obterHumanoid()
	if hum then
		hum.Sit = not hum.Sit
		status.Text = hum.Sit and "Personagem sentado" or "Personagem levantou"
	end
end))
-- FPS + MODO LISO
local otimizacaoAtiva = false
local modoLisoAtivo = false
local propriedadesOriginais = setmetatable({}, { __mode = "k" })
local materiaisOriginais = setmetatable({}, { __mode = "k" })
local conexoesOtimizacao = {}
local sombrasOriginais = Lighting.GlobalShadows

local function salvarEAlterar(obj, propriedade, valor)
	local sucesso, original = pcall(function()
		return obj[propriedade]
	end)
	if not sucesso then
		return
	end
	if not propriedadesOriginais[obj] then
		propriedadesOriginais[obj] = {}
	end
	if propriedadesOriginais[obj][propriedade] == nil then
		propriedadesOriginais[obj][propriedade] = original
	end
	pcall(function()
		obj[propriedade] = valor
	end)
end

local function otimizarObjeto(obj)
	if otimizacaoAtiva then
		if obj:IsA("BasePart") then
			salvarEAlterar(obj, "CastShadow", false)
		elseif obj:IsA("ParticleEmitter")
			or obj:IsA("Trail")
			or obj:IsA("Beam")
			or obj:IsA("Fire")
			or obj:IsA("Smoke")
			or obj:IsA("Sparkles")
			or obj:IsA("PostEffect") then
			salvarEAlterar(obj, "Enabled", false)
		end
	end

	if modoLisoAtivo and obj:IsA("BasePart") then
		if materiaisOriginais[obj] == nil then
			materiaisOriginais[obj] = obj.Material
		end
		pcall(function()
			obj.Material = Enum.Material.SmoothPlastic
		end)
	end
end

local function garantirListenerFPS()
	if #conexoesOtimizacao > 0 then
		return
	end
	table.insert(conexoesOtimizacao, Workspace.DescendantAdded:Connect(otimizarObjeto))
	table.insert(conexoesOtimizacao, Lighting.DescendantAdded:Connect(otimizarObjeto))
end

local function limparListenerFPSSePossivel()
	if not otimizacaoAtiva and not modoLisoAtivo then
		for _, c in ipairs(conexoesOtimizacao) do
			c:Disconnect()
		end
		table.clear(conexoesOtimizacao)
	end
end

local function atualizarUIFPS()
	botaoFPS.Text = otimizacaoAtiva and "OTIMIZAR EFEITOS: LIGADO" or "OTIMIZAR EFEITOS: DESLIGADO"
	botaoFPS.BackgroundColor3 = otimizacaoAtiva and COR_VERDE or COR_ITEM
	botaoFPS.TextColor3 = otimizacaoAtiva and COR_TEXTO or COR_TEXTO_FRACO

	botaoModoLiso.Text = modoLisoAtivo and "MODO LISO (MATERIAIS): LIGADO" or "MODO LISO (MATERIAIS): DESLIGADO"
	botaoModoLiso.BackgroundColor3 = modoLisoAtivo and COR_VERDE or COR_ITEM
	botaoModoLiso.TextColor3 = modoLisoAtivo and COR_TEXTO or COR_TEXTO_FRACO
end

local function desativarOtimizacao()
	otimizacaoAtiva = false
	pcall(function()
		Lighting.GlobalShadows = sombrasOriginais
	end)
	for obj, props in pairs(propriedadesOriginais) do
		if obj and obj.Parent then
			for prop, valOrig in pairs(props) do
				pcall(function()
					obj[prop] = valOrig
				end)
			end
		end
	end
	table.clear(propriedadesOriginais)
	limparListenerFPSSePossivel()
	atualizarUIFPS()
end

local function desativarModoLiso()
	modoLisoAtivo = false
	for obj, matOrig in pairs(materiaisOriginais) do
		if obj and obj.Parent then
			pcall(function()
				obj.Material = matOrig
			end)
		end
	end
	table.clear(materiaisOriginais)
	limparListenerFPSSePossivel()
	atualizarUIFPS()
end

guardarConexao(botaoFPS.Activated:Connect(function()
	if otimizacaoAtiva then
		desativarOtimizacao()
		status.Text = "Efeitos originais restaurados"
	else
		otimizacaoAtiva = true
		sombrasOriginais = Lighting.GlobalShadows
		pcall(function()
			Lighting.GlobalShadows = false
		end)
		for _, obj in ipairs(Workspace:GetDescendants()) do
			otimizarObjeto(obj)
		end
		for _, obj in ipairs(Lighting:GetDescendants()) do
			otimizarObjeto(obj)
		end
		garantirListenerFPS()
		atualizarUIFPS()
		status.Text = "Otimização de efeitos ativada"
	end
end))

guardarConexao(botaoModoLiso.Activated:Connect(function()
	if modoLisoAtivo then
		desativarModoLiso()
		status.Text = "Materiais originais restaurados"
	else
		modoLisoAtivo = true
		for _, obj in ipairs(Workspace:GetDescendants()) do
			otimizarObjeto(obj)
		end
		garantirListenerFPS()
		atualizarUIFPS()
		status.Text = "Modo liso ativado"
	end
end))

-- TP CAÓTICO, TP DIRETO E COSTAS
local conexaoTP = nil
local botoesJogadores = {}
local offsetAtual = Vector3.zero
local ultimoTempoTroca = 0

local function atualizarUI()
	local filtro = string.lower(caixaBusca.Text or "")
	local visiveis = 0

	for plr, btn in pairs(botoesJogadores) do
		if btn and btn.Parent then
			local textoBusca = string.lower(plr.DisplayName .. " " .. plr.Name)
			local mostra = (filtro == "") or (string.find(textoBusca, filtro, 1, true) ~= nil)
			btn.Visible = mostra
			if mostra then
				visiveis = visiveis + 1
			end
			btn.BackgroundColor3 = (plr == selecionado) and COR_DESTAQUE or COR_ITEM
		end
	end

	vazio.Visible = (visiveis == 0)
	status.TextColor3 = COR_TEXTO_FRACO

	botaoTPCostas.Text = tpCostasAtivo and "COSTAS: ON" or "COSTAS: OFF"
	botaoTPCostas.BackgroundColor3 = tpCostasAtivo and COR_VERDE or COR_ITEM
	botaoTPCostas.TextColor3 = tpCostasAtivo and COR_TEXTO or COR_TEXTO_FRACO

	if ativoTP and selecionado then
		status.Text = "Circulando: " .. selecionado.DisplayName
		botaoTP.Text = "DESATIVAR TP CAÓTICO"
		botaoTP.BackgroundColor3 = COR_VERMELHO
		bolinha.BackgroundColor3 = COR_VERDE
	elseif tpCostasAtivo and selecionado then
		status.Text = "Grudado nas costas: " .. selecionado.DisplayName
		botaoTP.Text = "ATIVAR TP CAÓTICO"
		botaoTP.BackgroundColor3 = COR_VERDE
		bolinha.BackgroundColor3 = COR_VERDE
	else
		if selecionado then
			status.Text = "Alvo: " .. selecionado.DisplayName
		else
			status.Text = "Escolha um jogador na aba TP"
		end
		botaoTP.Text = "ATIVAR TP CAÓTICO"
		botaoTP.BackgroundColor3 = COR_VERDE
		bolinha.BackgroundColor3 = COR_DESTAQUE
	end
end

guardarConexao(caixaBusca:GetPropertyChangedSignal("Text"):Connect(atualizarUI))

local function pararTodosLoopsTP()
	ativoTP = false
	tpCostasAtivo = false
	if conexaoTP then
		conexaoTP:Disconnect()
		conexaoTP = nil
	end
	if not noClipAtivo then
		restaurarColisao()
	end
	atualizarUI()
end

local function sortearNovaPosicao()
	local x = math.random(-RAIO_TP, RAIO_TP)
	local y = math.random(-RAIO_TP, RAIO_TP)
	local z = math.random(-RAIO_TP, RAIO_TP)
	if math.abs(x) < 1 then
		x = (x < 0) and -1.5 or 1.5
	end
	if math.abs(z) < 1 then
		z = (z < 0) and -1.5 or 1.5
	end
	offsetAtual = Vector3.new(x, y, z)
end

local function iniciarLoopTP(modoCostas)
	if not selecionado or selecionado == LocalPlayer or selecionado.Parent ~= Players then
		status.Text = "Escolha um jogador primeiro!"
		return
	end
	if conexaoTP then
		conexaoTP:Disconnect()
		conexaoTP = nil
	end

	ativoTP = not modoCostas
	tpCostasAtivo = modoCostas
	sortearNovaPosicao()
	ultimoTempoTroca = os.clock()

	conexaoTP = RunService.Heartbeat:Connect(function()
		if not ativoTP and not tpCostasAtivo then
			return
		end
		local alvo = selecionado
		if not alvo or alvo.Parent ~= Players then
			pararTodosLoopsTP()
			return
		end

		local minhaRaiz = obterRaiz()
		local raizAlvo = obterRaiz(alvo.Character)
		if not (minhaRaiz and raizAlvo) then
			return
		end

		aplicarSemColisao(LocalPlayer.Character)

		if tpCostasAtivo then
			minhaRaiz.CFrame = raizAlvo.CFrame * CFrame.new(0, 0, 2.6)
		else
			if os.clock() - ultimoTempoTroca >= TEMPO_TROCA_TP then
				ultimoTempoTroca = os.clock()
				sortearNovaPosicao()
			end
			local posAlvo = raizAlvo.Position + offsetAtual
			minhaRaiz.CFrame = CFrame.lookAt(posAlvo, raizAlvo.Position)
		end

		minhaRaiz.AssemblyLinearVelocity = Vector3.zero
		minhaRaiz.AssemblyAngularVelocity = Vector3.zero
	end)

	atualizarUI()
end

guardarConexao(botaoTPDireto.Activated:Connect(function()
	if not selecionado or selecionado.Parent ~= Players then
		status.Text = "Escolha um jogador primeiro!"
		return
	end
	local minhaRaiz = obterRaiz()
	local raizAlvo = obterRaiz(selecionado.Character)
	if minhaRaiz and raizAlvo then
		minhaRaiz.CFrame = raizAlvo.CFrame * CFrame.new(0, 0, 3)
		status.Text = "TP feito para " .. selecionado.DisplayName
	end
end))

guardarConexao(botaoTPCostas.Activated:Connect(function()
	if tpCostasAtivo then
		pararTodosLoopsTP()
	else
		iniciarLoopTP(true)
	end
end))

guardarConexao(botaoTP.Activated:Connect(function()
	if ativoTP then
		pararTodosLoopsTP()
	else
		iniciarLoopTP(false)
	end
end))

-- UTIL, UI E RESPAWN
local antiAfkAtivo = false
local conexaoAntiAfk = nil

local function atualizarUIUtil()
	botaoAntiAFK.Text = antiAfkAtivo and "ANTI-AFK: LIGADO" or "ANTI-AFK: DESLIGADO"
	botaoAntiAFK.BackgroundColor3 = antiAfkAtivo and COR_VERDE or COR_ITEM
	botaoAntiAFK.TextColor3 = antiAfkAtivo and COR_TEXTO or COR_TEXTO_FRACO
end

guardarConexao(botaoAntiAFK.Activated:Connect(function()
	antiAfkAtivo = not antiAfkAtivo
	if antiAfkAtivo then
		conexaoAntiAfk = LocalPlayer.Idled:Connect(function()
			pcall(function()
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end)
		end)
		status.Text = "Anti-AFK ativado"
	else
		if conexaoAntiAfk then
			conexaoAntiAfk:Disconnect()
			conexaoAntiAfk = nil
		end
		status.Text = "Anti-AFK desligado"
	end
	atualizarUIUtil()
end))

guardarConexao(botaoRespawn.Activated:Connect(function()
	local hum = obterHumanoid()
	if hum then
		hum.Health = 0
		status.Text = "Respawnando..."
	end
end))

local bolinhaCompacta = false

local function atualizarUIConfig()
	if bolinhaCompacta then
		bolinha.Size = UDim2.fromOffset(44, 44)
		bolinha.TextSize = 12
		botaoTamBolinha.Text = "BOLINHA: COMPACTA (44px)"
	else
		bolinha.Size = UDim2.fromOffset(58, 58)
		bolinha.TextSize = 15
		botaoTamBolinha.Text = "BOLINHA: NORMAL (58px)"
	end

	botaoTravarMenu.Text = menuTravado and "TRAVAR MENU: LIGADO" or "TRAVAR MENU: DESLIGADO"
	botaoTravarMenu.BackgroundColor3 = menuTravado and COR_AMARELO or COR_ITEM
	botaoTravarMenu.TextColor3 = menuTravado and COR_FUNDO or COR_TEXTO_FRACO
end

guardarConexao(botaoTamBolinha.Activated:Connect(function()
	bolinhaCompacta = not bolinhaCompacta
	atualizarUIConfig()
end))

guardarConexao(botaoTravarMenu.Activated:Connect(function()
	menuTravado = not menuTravado
	atualizarUIConfig()
	status.Text = menuTravado and "Posição do menu travada" or "Menu destravado"
end))

guardarConexao(botaoPosPadrao.Activated:Connect(function()
	bolinha.Position = POS_BOLINHA_PADRAO
	menu.Position = POS_MENU_PADRAO
	status.Text = "Posição resetada"
end))

guardarConexao(botaoResetTudo.Activated:Connect(function()
	pararTodosLoopsTP()
	pararFly()
	pararNoClip()
	pararWalkSpeed()
	pararCFrameSpeed()
	pararJump()
	pararInfJump()
	pararSpinBoneco()
	definirCongelado(false)

	gravAtivo = false
	aplicarGravidade()
	atualizarUIGrav()

	focoCamAtivo = false
	aimProximoAtivo = false
	olharAlvoAtivo = false
	fovAtivo = false
	if Workspace.CurrentCamera then
		Workspace.CurrentCamera.FieldOfView = FOV_PADRAO
	end
	pararLoopCamSeNecessario()
	desativarFullbright()
	atualizarUIAim()
	atualizarUICam()
	atualizarUICamExtra()

	espAtivo = false
	highlightAlvoAtivo = false
	highlightTodosAtivo = false
	atualizarEspGeral()

	desativarOtimizacao()
	desativarModoLiso()

	atualizarUI()
	status.Text = "Todas as funções foram desligadas!"
end))

guardarConexao(LocalPlayer.CharacterAdded:Connect(function(char)
	task.spawn(function()
		local hum = char:WaitForChild("Humanoid", 5)
		if not hum then
			return
		end

		velocidadesOriginais[hum] = hum.WalkSpeed
		if speedAtivo then
			hum.WalkSpeed = velocidadeEscolhida
		end

		if jumpAtivo then
			dadosJumpOriginais[hum] = {
				JumpPower = hum.JumpPower,
				UseJumpPower = hum.UseJumpPower,
				JumpHeight = hum.JumpHeight,
			}
			hum.UseJumpPower = true
			hum.JumpPower = forcaPulo
		end

		if flyAtivo then
			task.wait(0.2)
			iniciarFly()
		end

		if congeladoAtivo then
			local raiz = obterRaiz(char)
			if raiz then
				raiz.Anchored = true
			end
		end

		if ativoTP or tpCostasAtivo then
			restaurarColisao()
		end
	end)
end))

local function adicionarJogador(plr)
	if plr == LocalPlayer or botoesJogadores[plr] then
		return
	end

	local btn = criar("TextButton", {
		Name = string.lower(plr.Name),
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = COR_ITEM,
		AutoButtonColor = false,
		Text = plr.DisplayName .. "  (@" .. plr.Name .. ")",
		TextColor3 = COR_TEXTO,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = lista,
	})
	arredondar(btn, UDim.new(0, 6))
	botoesJogadores[plr] = btn

	guardarConexao(btn.Activated:Connect(function()
		if plr.Parent ~= Players then
			return
		end
		selecionado = plr
		atualizarUI()
		atualizarHighlights()
	end))

	configurarConexoesESP(plr)
	if espAtivo then
		criarEsp(plr)
	end

	atualizarUI()
end

local function removerJogador(plr)
	limparConexoesESP(plr)
	local btn = botoesJogadores[plr]
	if btn then
		btn:Destroy()
		botoesJogadores[plr] = nil
	end
	if selecionado == plr then
		selecionado = nil
		atualizarHighlights()
		pararTodosLoopsTP()
	else
		atualizarUI()
	end
end

guardarConexao(fechar.Activated:Connect(function()
	menu.Visible = false
end))

tornarArrastavel(barra, menu, nil, true)
tornarArrastavel(bolinha, bolinha, function()
	menu.Visible = not menu.Visible
end, false)

guardarConexao(gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	local tela = gui.AbsoluteSize
	bolinha.Position = UDim2.fromOffset(
		math.clamp(bolinha.Position.X.Offset, 0, math.max(0, tela.X - bolinha.AbsoluteSize.X)),
		math.clamp(bolinha.Position.Y.Offset, 0, math.max(0, tela.Y - bolinha.AbsoluteSize.Y))
	)
	menu.Position = UDim2.fromOffset(
		math.clamp(menu.Position.X.Offset, 0, math.max(0, tela.X - menu.AbsoluteSize.X)),
		math.clamp(menu.Position.Y.Offset, 0, math.max(0, tela.Y - menu.AbsoluteSize.Y))
	)
end))

for _, plr in ipairs(Players:GetPlayers()) do
	adicionarJogador(plr)
end

guardarConexao(Players.PlayerAdded:Connect(adicionarJogador))
guardarConexao(Players.PlayerRemoving:Connect(removerJogador))

atualizarUIAim()
atualizarUISpeed()
atualizarUIJump()
atualizarUIMov()
atualizarUIGrav()
atualizarUICam()
atualizarUICamExtra()
atualizarUIFun()
atualizarUIFPS()
atualizarUIUtil()
atualizarUIConfig()
selecionarAba("TP")
atualizarUI()
