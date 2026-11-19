local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

-- CONFIGURAÇÕES
local RAIO_TP = 3
local TEMPO_TROCA_TP = 0.25

local VELOCIDADE_PADRAO = 16
local VELOCIDADE_INICIAL = 32
local PASSO_VELOCIDADE = 4
local VELOCIDADE_MINIMA = 8
local VELOCIDADE_MAXIMA = 120

-- SUPER JUMP
local PULO_INICIAL = 100
local PASSO_PULO = 10
local PULO_MINIMO = 10
local PULO_MAXIMO = 250

-- CORES
local COR_FUNDO = Color3.fromRGB(24, 24, 32)
local COR_BARRA = Color3.fromRGB(38, 38, 52)
local COR_ITEM = Color3.fromRGB(52, 52, 70)
local COR_DESTAQUE = Color3.fromRGB(88, 101, 242)
local COR_VERDE = Color3.fromRGB(46, 160, 90)
local COR_VERMELHO = Color3.fromRGB(200, 60, 60)
local COR_TEXTO = Color3.new(1, 1, 1)
local COR_TEXTO_FRACO = Color3.fromRGB(170, 170, 190)

-- CONEXÕES
local conexoesGerais = {}

local function guardarConexao(conexao)
	table.insert(conexoesGerais, conexao)
	return conexao
end

-- CRIAR OBJETOS
local function criar(classe, props)
	local obj = Instance.new(classe)
	local pai = props.Parent

	for nome, valor in pairs(props) do
		if nome ~= "Parent" then
			obj[nome] = valor
		end
	end

	if pai then obj.Parent = pai end
	return obj
end

local function arredondar(obj, raio)
	if obj then
		criar("UICorner", {
			CornerRadius = raio,
			Parent = obj
		})
	end
end

local playerGui = LocalPlayer:WaitForChild("PlayerGui")

local antigo = playerGui:FindFirstChild("GrudarMenu")
if antigo then antigo:Destroy() end

local gui = criar("ScreenGui", {
	Name = "GrudarMenu",
	Enabled = true,
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 9999,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = playerGui,
})

-- ARRASTAR ELEMENTOS
local function tornarArrastavel(alca, alvo, aoToque)
	local arrastando = false
	local entrada
	local inicioToque
	local inicioPos
	local moveu = false

	guardarConexao(alca.InputBegan:Connect(function(input)
		local tipo = input.UserInputType

		if tipo == Enum.UserInputType.Touch
			or tipo == Enum.UserInputType.MouseButton1 then
			arrastando = true
			moveu = false
			entrada = input
			inicioToque = input.Position
			inicioPos = alvo.Position
		end
	end))

	guardarConexao(UserInputService.InputChanged:Connect(function(input)
		if not arrastando then return end

		local mesmoToque = input == entrada
		local mesmoMouse =
			input.UserInputType == Enum.UserInputType.MouseMovement
			and entrada.UserInputType == Enum.UserInputType.MouseButton1

		if not (mesmoToque or mesmoMouse) then return end

		local delta = input.Position - inicioToque

		if delta.Magnitude > 8 then moveu = true end

		local tela = gui.AbsoluteSize
		local tam = alvo.AbsoluteSize

		local x = math.clamp(
			inicioPos.X.Offset + delta.X,
			0,
			math.max(0, tela.X - tam.X)
		)

		local y = math.clamp(
			inicioPos.Y.Offset + delta.Y,
			0,
			math.max(0, tela.Y - tam.Y)
		)

		alvo.Position = UDim2.fromOffset(x, y)
	end))

	guardarConexao(UserInputService.InputEnded:Connect(function(input)
		if not arrastando then return end

		local mesmoToque = input == entrada
		local mesmoMouse =
			input.UserInputType == Enum.UserInputType.MouseButton1
			and entrada.UserInputType == Enum.UserInputType.MouseButton1

		if mesmoToque or mesmoMouse then
			arrastando = false
			if not moveu and aoToque then aoToque() end
		end
	end))
end

-- BOTÃO FLUTUANTE
local bolinha = criar("TextButton", {
	Name = "Bolinha",
	Size = UDim2.fromOffset(58, 58),
	Position = UDim2.fromOffset(16, 110),
	BackgroundColor3 = COR_DESTAQUE,
	AutoButtonColor = false,
	Text = "TP",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 18,
	Visible = true,
	ZIndex = 20,
	Parent = gui,
})

arredondar(bolinha, UDim.new(1, 0))

-- MENU PRINCIPAL
local menu = criar("Frame", {
	Name = "Menu",
	Size = UDim2.fromOffset(260, 360),
	Position = UDim2.fromOffset(85, 70),
	BackgroundColor3 = COR_FUNDO,
	BorderSizePixel = 0,
	Active = true,
	Visible = false,
	ZIndex = 15,
	Parent = gui,
})

arredondar(menu, UDim.new(0, 12))

local barra = criar("Frame", {
	Name = "Barra",
	Size = UDim2.new(1, 0, 0, 40),
	BackgroundColor3 = COR_BARRA,
	BorderSizePixel = 0,
	Active = true,
	Parent = menu,
})

arredondar(barra, UDim.new(0, 12))

criar("Frame", {
	Size = UDim2.new(1, 0, 0, 12),
	Position = UDim2.new(0, 0, 1, -12),
	BackgroundColor3 = COR_BARRA,
	BorderSizePixel = 0,
	Parent = barra,
})

criar("TextLabel", {
	Size = UDim2.new(1, -50, 1, 0),
	Position = UDim2.fromOffset(12, 0),
	BackgroundTransparency = 1,
	Text = "Hub Mobile",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = barra,
})

local fechar = criar("TextButton", {
	Name = "Fechar",
	Size = UDim2.fromOffset(30, 30),
	Position = UDim2.new(1, -36, 0, 5),
	BackgroundColor3 = COR_VERMELHO,
	Text = "X",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	Parent = barra,
})

arredondar(fechar, UDim.new(0, 8))

-- ABAS
local barraAbas = criar("ScrollingFrame", {
	Name = "Abas",
	Size = UDim2.new(1, -20, 0, 32),
	Position = UDim2.fromOffset(10, 46),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 0,
	ScrollingDirection = Enum.ScrollingDirection.X,
	CanvasSize = UDim2.fromOffset(240, 0),
	Parent = menu,
})

local function criarBotaoAba(texto, ordem)
	local largura = 44
	local espaco = 5

	local btn = criar("TextButton", {
		Name = "Aba_" .. texto,
		Size = UDim2.fromOffset(largura, 32),
		Position = UDim2.fromOffset((ordem - 1) * (largura + espaco), 0),
		BackgroundColor3 = COR_ITEM,
		AutoButtonColor = false,
		Text = texto,
		TextColor3 = COR_TEXTO_FRACO,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		Parent = barraAbas,
	})

	arredondar(btn, UDim.new(0, 8))
	return btn
end

local abaBtnTP = criarBotaoAba("TP", 1)
local abaBtnESP = criarBotaoAba("ESP", 2)
local abaBtnSpeed = criarBotaoAba("Speed", 3)
local abaBtnJump = criarBotaoAba("Jump", 4)
local abaBtnFPS = criarBotaoAba("FPS", 5)

-- STATUS
local status = criar("TextLabel", {
	Name = "Status",
	Size = UDim2.new(1, -20, 0, 20),
	Position = UDim2.fromOffset(10, 82),
	BackgroundTransparency = 1,
	Text = "Pronto",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.Gotham,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Parent = menu,
})-- CONTEÚDOS
local containerTP = criar("Frame", {
	Name = "ConteudoTP",
	Size = UDim2.new(1, -20, 0, 246),
	Position = UDim2.fromOffset(10, 104),
	BackgroundTransparency = 1,
	Visible = true,
	Parent = menu,
})

local containerESP = criar("Frame", {
	Name = "ConteudoESP",
	Size = UDim2.new(1, -20, 0, 246),
	Position = UDim2.fromOffset(10, 104),
	BackgroundTransparency = 1,
	Visible = false,
	Parent = menu,
})

local containerSpeed = criar("Frame", {
	Name = "ConteudoSpeed",
	Size = UDim2.new(1, -20, 0, 246),
	Position = UDim2.fromOffset(10, 104),
	BackgroundTransparency = 1,
	Visible = false,
	Parent = menu,
})

local containerJump = criar("Frame", {
	Name = "ConteudoJump",
	Size = UDim2.new(1, -20, 0, 246),
	Position = UDim2.fromOffset(10, 104),
	BackgroundTransparency = 1,
	Visible = false,
	Parent = menu,
})

local containerFPS = criar("Frame", {
	Name = "ConteudoFPS",
	Size = UDim2.new(1, -20, 0, 246),
	Position = UDim2.fromOffset(10, 104),
	BackgroundTransparency = 1,
	Visible = false,
	Parent = menu,
})

-- ABA TP
local lista = criar("ScrollingFrame", {
	Name = "Lista",
	Size = UDim2.new(1, 0, 0, 192),
	Position = UDim2.fromOffset(0, 0),
	BackgroundColor3 = COR_BARRA,
	BorderSizePixel = 0,
	ScrollBarThickness = 4,
	ScrollingDirection = Enum.ScrollingDirection.Y,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	Parent = containerTP,
})

arredondar(lista, UDim.new(0, 8))

criar("UIListLayout", {
	Padding = UDim.new(0, 4),
	SortOrder = Enum.SortOrder.Name,
	Parent = lista,
})

criar("UIPadding", {
	PaddingTop = UDim.new(0, 4),
	PaddingBottom = UDim.new(0, 4),
	PaddingLeft = UDim.new(0, 4),
	PaddingRight = UDim.new(0, 8),
	Parent = lista,
})

local vazio = criar("TextLabel", {
	Name = "Vazio",
	Size = lista.Size,
	Position = lista.Position,
	BackgroundTransparency = 1,
	Text = "Nenhum outro jogador\nno servidor",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.Gotham,
	TextSize = 13,
	Parent = containerTP,
})

local botaoTP = criar("TextButton", {
	Name = "AlternarTP",
	Size = UDim2.new(1, 0, 0, 44),
	Position = UDim2.fromOffset(0, 202),
	BackgroundColor3 = COR_VERDE,
	Text = "ATIVAR TP",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	Parent = containerTP,
})

arredondar(botaoTP, UDim.new(0, 10))

-- ABA ESP
local descESP = criar("TextLabel", {
	Size = UDim2.new(1, 0, 0, 56),
	Position = UDim2.fromOffset(0, 8),
	BackgroundColor3 = COR_BARRA,
	Text = "Mostra o nome e @usuário acima\nda cabeça dos outros jogadores\npara facilitar achar no mapa.",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.Gotham,
	TextSize = 12,
	Parent = containerESP,
})

arredondar(descESP, UDim.new(0, 8))

local botaoEsp = criar("TextButton", {
	Name = "AlternarESP",
	Size = UDim2.new(1, 0, 0, 46),
	Position = UDim2.fromOffset(0, 78),
	BackgroundColor3 = COR_ITEM,
	Text = "ESP: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	Parent = containerESP,
})

arredondar(botaoEsp, UDim.new(0, 10))

-- ABA SPEED
local painelSpeed = criar("Frame", {
	Name = "PainelSpeed",
	Size = UDim2.new(1, 0, 0, 96),
	Position = UDim2.fromOffset(0, 8),
	BackgroundColor3 = COR_BARRA,
	BorderSizePixel = 0,
	Parent = containerSpeed,
})

arredondar(painelSpeed, UDim.new(0, 8))

local labelSpeed = criar("TextLabel", {
	Name = "ValorSpeed",
	Size = UDim2.new(1, -20, 0, 32),
	Position = UDim2.fromOffset(10, 8),
	BackgroundTransparency = 1,
	Text = "Velocidade: " .. tostring(VELOCIDADE_INICIAL),
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	Parent = painelSpeed,
})

local btnMenos = criar("TextButton", {
	Name = "DiminuirSpeed",
	Size = UDim2.fromOffset(100, 40),
	Position = UDim2.fromOffset(12, 46),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "- Diminuir",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	Parent = painelSpeed,
})

arredondar(btnMenos, UDim.new(0, 8))

local btnMais = criar("TextButton", {
	Name = "AumentarSpeed",
	Size = UDim2.fromOffset(100, 40),
	Position = UDim2.fromOffset(128, 46),
	BackgroundColor3 = COR_DESTAQUE,
	AutoButtonColor = false,
	Text = "+ Aumentar",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	Parent = painelSpeed,
})

arredondar(btnMais, UDim.new(0, 8))

local botaoSpeed = criar("TextButton", {
	Name = "AlternarSpeed",
	Size = UDim2.new(1, 0, 0, 46),
	Position = UDim2.fromOffset(0, 118),
	BackgroundColor3 = COR_ITEM,
	Text = "SPEED: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	Parent = containerSpeed,
})

arredondar(botaoSpeed, UDim.new(0, 10))

-- ABA SUPER JUMP
local painelJump = criar("Frame", {
	Name = "PainelJump",
	Size = UDim2.new(1, 0, 0, 96),
	Position = UDim2.fromOffset(0, 8),
	BackgroundColor3 = COR_BARRA,
	BorderSizePixel = 0,
	Parent = containerJump,
})

arredondar(painelJump, UDim.new(0, 8))

local labelJump = criar("TextLabel", {
	Name = "ValorJump",
	Size = UDim2.new(1, -20, 0, 32),
	Position = UDim2.fromOffset(10, 8),
	BackgroundTransparency = 1,
	Text = "Força do pulo: " .. tostring(PULO_INICIAL),
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	Parent = painelJump,
})

local btnMenosJump = criar("TextButton", {
	Name = "DiminuirJump",
	Size = UDim2.fromOffset(100, 40),
	Position = UDim2.fromOffset(12, 46),
	BackgroundColor3 = COR_ITEM,
	AutoButtonColor = false,
	Text = "- Diminuir",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	Parent = painelJump,
})

arredondar(btnMenosJump, UDim.new(0, 8))

local btnMaisJump = criar("TextButton", {
	Name = "AumentarJump",
	Size = UDim2.fromOffset(100, 40),
	Position = UDim2.fromOffset(128, 46),
	BackgroundColor3 = COR_DESTAQUE,
	AutoButtonColor = false,
	Text = "+ Aumentar",
	TextColor3 = COR_TEXTO,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	Parent = painelJump,
})

arredondar(btnMaisJump, UDim.new(0, 8))

local botaoJump = criar("TextButton", {
	Name = "AlternarJump",
	Size = UDim2.new(1, 0, 0, 46),
	Position = UDim2.fromOffset(0, 118),
	BackgroundColor3 = COR_ITEM,
	Text = "SUPER JUMP: DESLIGADO",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	Parent = containerJump,
})

arredondar(botaoJump, UDim.new(0, 10))

-- ABA FPS
local descFPS = criar("TextLabel", {
	Size = UDim2.new(1, 0, 0, 65),
	Position = UDim2.fromOffset(0, 8),
	BackgroundColor3 = COR_BARRA,
	Text = "Reduz efeitos visuais e sombras\npara tentar melhorar o desempenho\ne a estabilidade do FPS.",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.Gotham,
	TextSize = 12,
	Parent = containerFPS,
})

arredondar(descFPS, UDim.new(0, 8))

local botaoFPS = criar("TextButton", {
	Name = "AlternarFPS",
	Size = UDim2.new(1, 0, 0, 46),
	Position = UDim2.fromOffset(0, 86),
	BackgroundColor3 = COR_ITEM,
	Text = "OTIMIZAÇÃO: DESLIGADA",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	Parent = containerFPS,
})

arredondar(botaoFPS, UDim.new(0, 10))

local avisoFPS = criar("TextLabel", {
	Size = UDim2.new(1, 0, 0, 45),
	Position = UDim2.fromOffset(0, 142),
	BackgroundTransparency = 1,
	Text = "As alterações visuais podem variar\nconforme o jogo e o dispositivo.",
	TextColor3 = COR_TEXTO_FRACO,
	Font = Enum.Font.Gotham,
	TextSize = 11,
	Parent = containerFPS,
})-- SELEÇÃO DE ABAS
local function selecionarAba(nomeAba)
	containerTP.Visible = nomeAba == "TP"
	containerESP.Visible = nomeAba == "ESP"
	containerSpeed.Visible = nomeAba == "Speed"
	containerJump.Visible = nomeAba == "Jump"
	containerFPS.Visible = nomeAba == "FPS"

	local abasMap = {
		{btn = abaBtnTP, ativo = nomeAba == "TP"},
		{btn = abaBtnESP, ativo = nomeAba == "ESP"},
		{btn = abaBtnSpeed, ativo = nomeAba == "Speed"},
		{btn = abaBtnJump, ativo = nomeAba == "Jump"},
		{btn = abaBtnFPS, ativo = nomeAba == "FPS"},
	}

	for _, item in ipairs(abasMap) do
		item.btn.BackgroundColor3 =
			item.ativo and COR_DESTAQUE or COR_ITEM

		item.btn.TextColor3 =
			item.ativo and COR_TEXTO or COR_TEXTO_FRACO
	end
end

guardarConexao(abaBtnTP.Activated:Connect(function()
	selecionarAba("TP")
end))

guardarConexao(abaBtnESP.Activated:Connect(function()
	selecionarAba("ESP")
end))

guardarConexao(abaBtnSpeed.Activated:Connect(function()
	selecionarAba("Speed")
end))

guardarConexao(abaBtnJump.Activated:Connect(function()
	selecionarAba("Jump")
end))

guardarConexao(abaBtnFPS.Activated:Connect(function()
	selecionarAba("FPS")
end))

-- ESP
local espAtivo = false
local espTags = {}
local espVersoes = {}
local conexoesESP = {}

local function removerEsp(plr)
	espVersoes[plr] = (espVersoes[plr] or 0) + 1

	local tag = espTags[plr]

	if tag then
		pcall(function() tag:Destroy() end)
		espTags[plr] = nil
	end
end

local function criarEsp(plr)
	if plr == LocalPlayer or not espAtivo then return end

	removerEsp(plr)

	local versao = espVersoes[plr]
	local char = plr.Character

	if not char then return end

	task.spawn(function()
		local cabeca = char:WaitForChild("Head", 5)

		if not cabeca then return end

		if not espAtivo
			or plr.Parent ~= Players
			or plr.Character ~= char
			or espVersoes[plr] ~= versao then
			return
		end

		local billboard = criar("BillboardGui", {
			Name = "NomeESP",
			Size = UDim2.new(0, 150, 0, 40),
			StudsOffset = Vector3.new(0, 2.5, 0),
			AlwaysOnTop = true,
			Parent = cabeca,
		})

		criar("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = plr.DisplayName .. "\n(@" .. plr.Name .. ")",
			TextColor3 = COR_TEXTO,
			TextStrokeTransparency = 0.5,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			Parent = billboard,
		})

		espTags[plr] = billboard
	end)
end

local function configurarConexoesESP(plr)
	if plr == LocalPlayer or conexoesESP[plr] then return end

	local conexaoAdicionada = plr.CharacterAdded:Connect(function()
		if espAtivo then criarEsp(plr) end
	end)

	local conexaoRemovida = plr.CharacterRemoving:Connect(function()
		removerEsp(plr)
	end)

	conexoesESP[plr] = {
		conexaoAdicionada,
		conexaoRemovida,
	}
end

local function limparConexoesESP(plr)
	local conexoes = conexoesESP[plr]

	if conexoes then
		for _, conexaoESP in ipairs(conexoes) do
			conexaoESP:Disconnect()
		end

		conexoesESP[plr] = nil
	end

	removerEsp(plr)
end

local function atualizarEspGeral()
	if espAtivo then
		botaoEsp.Text = "ESP: LIGADO"
		botaoEsp.BackgroundColor3 = COR_DESTAQUE
		botaoEsp.TextColor3 = COR_TEXTO

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				configurarConexoesESP(plr)
				criarEsp(plr)
			end
		end
	else
		botaoEsp.Text = "ESP: DESLIGADO"
		botaoEsp.BackgroundColor3 = COR_ITEM
		botaoEsp.TextColor3 = COR_TEXTO_FRACO

		for _, plr in ipairs(Players:GetPlayers()) do
			removerEsp(plr)
		end
	end
end

guardarConexao(botaoEsp.Activated:Connect(function()
	espAtivo = not espAtivo
	atualizarEspGeral()
end))

-- SPEED
local speedAtivo = false
local velocidadeEscolhida = VELOCIDADE_INICIAL
local conexaoSpeed = nil

local velocidadesOriginais = setmetatable({}, {
	__mode = "k"
})

local function obterHumanoid()
	local char = LocalPlayer.Character
	return char and char:FindFirstChildOfClass("Humanoid")
end

local function aplicarWalkSpeed()
	local hum = obterHumanoid()
	if not hum then return end

	if velocidadesOriginais[hum] == nil then
		velocidadesOriginais[hum] = hum.WalkSpeed
	end

	if speedAtivo then
		hum.WalkSpeed = velocidadeEscolhida
	end
end

local function atualizarUISpeed()
	labelSpeed.Text = "Velocidade: " .. tostring(velocidadeEscolhida)

	if speedAtivo then
		botaoSpeed.Text = "SPEED: LIGADO"
		botaoSpeed.BackgroundColor3 = COR_VERDE
		botaoSpeed.TextColor3 = COR_TEXTO
	else
		botaoSpeed.Text = "SPEED: DESLIGADO"
		botaoSpeed.BackgroundColor3 = COR_ITEM
		botaoSpeed.TextColor3 = COR_TEXTO_FRACO
	end
end

local function alterarVelocidade(delta)
	velocidadeEscolhida = math.clamp(
		velocidadeEscolhida + delta,
		VELOCIDADE_MINIMA,
		VELOCIDADE_MAXIMA
	)

	atualizarUISpeed()

	if speedAtivo then
		aplicarWalkSpeed()
		status.Text = "WalkSpeed: " .. tostring(velocidadeEscolhida)
	end
end

guardarConexao(btnMenos.Activated:Connect(function()
	alterarVelocidade(-PASSO_VELOCIDADE)
end))

guardarConexao(btnMais.Activated:Connect(function()
	alterarVelocidade(PASSO_VELOCIDADE)
end))

local function iniciarSpeed()
	speedAtivo = true
	aplicarWalkSpeed()

	if not conexaoSpeed then
		conexaoSpeed = RunService.Heartbeat:Connect(function()
			if not speedAtivo then return end

			local hum = obterHumanoid()

			if hum then
				if velocidadesOriginais[hum] == nil then
					velocidadesOriginais[hum] = hum.WalkSpeed
				end

				if hum.WalkSpeed ~= velocidadeEscolhida then
					hum.WalkSpeed = velocidadeEscolhida
				end
			end
		end)
	end

	atualizarUISpeed()
	status.Text = "WalkSpeed ativado (" .. tostring(velocidadeEscolhida) .. ")"
end

local function pararSpeed()
	speedAtivo = false

	if conexaoSpeed then
		conexaoSpeed:Disconnect()
		conexaoSpeed = nil
	end

	local hum = obterHumanoid()

	if hum then
		local original = velocidadesOriginais[hum]
		hum.WalkSpeed = original or VELOCIDADE_PADRAO
	end

	atualizarUISpeed()
	status.Text = "WalkSpeed desligado"
end

guardarConexao(botaoSpeed.Activated:Connect(function()
	if speedAtivo then
		pararSpeed()
	else
		iniciarSpeed()
	end
end))-- SUPER JUMP
local jumpAtivo = false
local forcaPulo = PULO_INICIAL
local conexaoJump = nil

local dadosJumpOriginais = setmetatable({}, {
	__mode = "k"
})

local function aplicarJump()
	local hum = obterHumanoid()
	if not hum then return end

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

	if jumpAtivo then
		botaoJump.Text = "SUPER JUMP: LIGADO"
		botaoJump.BackgroundColor3 = COR_VERDE
		botaoJump.TextColor3 = COR_TEXTO
	else
		botaoJump.Text = "SUPER JUMP: DESLIGADO"
		botaoJump.BackgroundColor3 = COR_ITEM
		botaoJump.TextColor3 = COR_TEXTO_FRACO
	end
end

local function alterarPulo(delta)
	forcaPulo = math.clamp(
		forcaPulo + delta,
		PULO_MINIMO,
		PULO_MAXIMO
	)

	atualizarUIJump()

	if jumpAtivo then
		aplicarJump()
		status.Text = "Força do pulo: " .. tostring(forcaPulo)
	end
end

local function iniciarJump()
	jumpAtivo = true
	aplicarJump()

	if not conexaoJump then
		conexaoJump = RunService.Heartbeat:Connect(function()
			if jumpAtivo then aplicarJump() end
		end)
	end

	atualizarUIJump()
	status.Text = "Super Jump ativado"
end

local function pararJump()
	jumpAtivo = false

	if conexaoJump then
		conexaoJump:Disconnect()
		conexaoJump = nil
	end

	local hum = obterHumanoid()

	if hum then
		local original = dadosJumpOriginais[hum]

		if original then
			hum.JumpPower = original.JumpPower
			hum.UseJumpPower = original.UseJumpPower
			hum.JumpHeight = original.JumpHeight
		end
	end

	atualizarUIJump()
	status.Text = "Super Jump desligado"
end

guardarConexao(btnMenosJump.Activated:Connect(function()
	alterarPulo(-PASSO_PULO)
end))

guardarConexao(btnMaisJump.Activated:Connect(function()
	alterarPulo(PASSO_PULO)
end))

guardarConexao(botaoJump.Activated:Connect(function()
	if jumpAtivo then
		pararJump()
	else
		iniciarJump()
	end
end))

-- OTIMIZAÇÃO DE FPS
local otimizacaoAtiva = false

local propriedadesOriginais = setmetatable({}, {
	__mode = "k"
})

local conexoesOtimizacao = {}
local sombrasOriginais = Lighting.GlobalShadows

local function salvarEAlterar(obj, propriedade, valor)
	local sucesso, original = pcall(function()
		return obj[propriedade]
	end)

	if not sucesso then return end

	if not propriedadesOriginais[obj] then
		propriedadesOriginais[obj] = {}
	end

	local dados = propriedadesOriginais[obj]

	if dados[propriedade] == nil then
		dados[propriedade] = original
	end

	pcall(function()
		obj[propriedade] = valor
	end)
end

local function otimizarObjeto(obj)
	if not otimizacaoAtiva then return end

	if obj:IsA("BasePart") then
		salvarEAlterar(obj, "CastShadow", false)

	elseif obj:IsA("ParticleEmitter")
		or obj:IsA("Trail")
		or obj:IsA("Beam")
		or obj:IsA("Fire")
		or obj:IsA("Smoke")
		or obj:IsA("Sparkles") then

		salvarEAlterar(obj, "Enabled", false)

	elseif obj:IsA("PostEffect") then
		salvarEAlterar(obj, "Enabled", false)
	end
end

local function atualizarUIFPS()
	if otimizacaoAtiva then
		botaoFPS.Text = "OTIMIZAÇÃO: LIGADA"
		botaoFPS.BackgroundColor3 = COR_VERDE
		botaoFPS.TextColor3 = COR_TEXTO
	else
		botaoFPS.Text = "OTIMIZAÇÃO: DESLIGADA"
		botaoFPS.BackgroundColor3 = COR_ITEM
		botaoFPS.TextColor3 = COR_TEXTO_FRACO
	end
end

local function ativarOtimizacao()
	if otimizacaoAtiva then return end

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

	table.insert(conexoesOtimizacao,
		Workspace.DescendantAdded:Connect(otimizarObjeto)
	)

	table.insert(conexoesOtimizacao,
		Lighting.DescendantAdded:Connect(otimizarObjeto)
	)

	atualizarUIFPS()
	status.Text = "Otimização ativada"
end

local function desativarOtimizacao()
	if not otimizacaoAtiva then return end

	otimizacaoAtiva = false

	for _, conexaoFPS in ipairs(conexoesOtimizacao) do
		conexaoFPS:Disconnect()
	end

	table.clear(conexoesOtimizacao)

	pcall(function()
		Lighting.GlobalShadows = sombrasOriginais
	end)

	for obj, propriedades in pairs(propriedadesOriginais) do
		if obj and obj.Parent then
			for propriedade, valorOriginal in pairs(propriedades) do
				pcall(function()
					obj[propriedade] = valorOriginal
				end)
			end
		end
	end

	table.clear(propriedadesOriginais)

	atualizarUIFPS()
	status.Text = "Otimização desligada"
end

guardarConexao(botaoFPS.Activated:Connect(function()
	if otimizacaoAtiva then
		desativarOtimizacao()
	else
		ativarOtimizacao()
	end
end))

-- RESPAWN E SPEED/JUMP
guardarConexao(LocalPlayer.CharacterAdded:Connect(function(char)
	task.spawn(function()
		local hum = char:WaitForChild("Humanoid", 5)
		if not hum then return end

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
	end)
end))-- TP
local selecionado = nil
local ativo = false
local conexao = nil
local botoes = {}

local offsetAtual = Vector3.zero
local ultimoTempoTroca = 0

-- COLISÃO ORIGINAL
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

local function definirColisao(char)
	if not char then return end

	if personagemComColisaoAlterada ~= char then
		restaurarColisao()
		personagemComColisaoAlterada = char

		for _, parte in ipairs(char:GetDescendants()) do
			if parte:IsA("BasePart") then
				colisaoOriginal[parte] = parte.CanCollide
				parte.CanCollide = false
			end
		end
	else
		for _, parte in ipairs(char:GetDescendants()) do
			if parte:IsA("BasePart")
				and colisaoOriginal[parte] == nil then

				colisaoOriginal[parte] = parte.CanCollide
				parte.CanCollide = false
			end
		end
	end
end

local function atualizarUI()
	for plr, btn in pairs(botoes) do
		if btn and btn.Parent then
			btn.BackgroundColor3 =
				(plr == selecionado) and COR_DESTAQUE or COR_ITEM
		end
	end

	vazio.Visible = next(botoes) == nil
	status.TextColor3 = COR_TEXTO_FRACO

	if ativo and selecionado then
		status.Text = "Circulando: " .. selecionado.DisplayName
		botaoTP.Text = "DESATIVAR TP"
		botaoTP.BackgroundColor3 = COR_VERMELHO
		bolinha.BackgroundColor3 = COR_VERDE
	else
		if selecionado then
			status.Text = "Alvo: " .. selecionado.DisplayName
		elseif not speedAtivo then
			status.Text = "Escolha um jogador na aba TP"
		end

		botaoTP.Text = "ATIVAR TP"
		botaoTP.BackgroundColor3 = COR_VERDE
		bolinha.BackgroundColor3 = COR_DESTAQUE
	end
end

local function pararLoop()
	ativo = false

	if conexao then
		conexao:Disconnect()
		conexao = nil
	end

	restaurarColisao()
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

local function iniciarLoop()
	if not selecionado or selecionado == LocalPlayer then return end
	if selecionado.Parent ~= Players then return end

	if conexao then
		conexao:Disconnect()
		conexao = nil
	end

	ativo = true
	sortearNovaPosicao()
	ultimoTempoTroca = os.clock()

	conexao = RunService.Heartbeat:Connect(function()
		local alvo = selecionado

		if not ativo then return end

		if not alvo or alvo.Parent ~= Players then
			pararLoop()
			return
		end

		local meuChar = LocalPlayer.Character
		local charAlvo = alvo.Character

		local minhaRaiz = meuChar
			and meuChar:FindFirstChild("HumanoidRootPart")

		local raizAlvo = charAlvo
			and charAlvo:FindFirstChild("HumanoidRootPart")

		if not (minhaRaiz and raizAlvo) then return end

		definirColisao(meuChar)

		if os.clock() - ultimoTempoTroca >= TEMPO_TROCA_TP then
			ultimoTempoTroca = os.clock()
			sortearNovaPosicao()
		end

		local posAlvo = raizAlvo.Position + offsetAtual

		minhaRaiz.CFrame = CFrame.lookAt(
			posAlvo,
			raizAlvo.Position
		)

		minhaRaiz.AssemblyLinearVelocity = Vector3.zero
		minhaRaiz.AssemblyAngularVelocity = Vector3.zero
	end)

	atualizarUI()
end

-- JOGADORES
local function adicionarJogador(plr)
	if plr == LocalPlayer or botoes[plr] then return end

	local btn = criar("TextButton", {
		Name = string.lower(plr.Name),
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = COR_ITEM,
		AutoButtonColor = false,
		Text = plr.DisplayName .. "  (@" .. plr.Name .. ")",
		TextColor3 = COR_TEXTO,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = lista,
	})

	arredondar(btn, UDim.new(0, 6))
	botoes[plr] = btn

	guardarConexao(btn.Activated:Connect(function()
		if plr.Parent ~= Players then return end
		selecionado = plr
		atualizarUI()
	end))

	configurarConexoesESP(plr)

	if espAtivo then
		criarEsp(plr)
	end

	atualizarUI()
end

local function removerJogador(plr)
	limparConexoesESP(plr)

	local btn = botoes[plr]

	if btn then
		btn:Destroy()
		botoes[plr] = nil
	end

	if selecionado == plr then
		selecionado = nil
		pararLoop()
	else
		atualizarUI()
	end
end

guardarConexao(botaoTP.Activated:Connect(function()
	if ativo then
		pararLoop()
	elseif selecionado then
		iniciarLoop()
	else
		status.Text = "Escolha um jogador primeiro!"

		task.delay(1.5, function()
			if gui.Parent then atualizarUI() end
		end)
	end
end))

-- RESPAWN DURANTE TP
guardarConexao(LocalPlayer.CharacterAdded:Connect(function()
	if ativo then
		restaurarColisao()
	end
end))

-- FECHAR E ARRASTAR
guardarConexao(fechar.Activated:Connect(function()
	menu.Visible = false
end))

tornarArrastavel(barra, menu)

tornarArrastavel(bolinha, bolinha, function()
	menu.Visible = not menu.Visible
end)

-- LIMITES DA TELA
guardarConexao(gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	local tela = gui.AbsoluteSize

	bolinha.Position = UDim2.fromOffset(
		math.clamp(
			bolinha.Position.X.Offset,
			0,
			math.max(0, tela.X - bolinha.AbsoluteSize.X)
		),
		math.clamp(
			bolinha.Position.Y.Offset,
			0,
			math.max(0, tela.Y - bolinha.AbsoluteSize.Y)
		)
	)

	menu.Position = UDim2.fromOffset(
		math.clamp(
			menu.Position.X.Offset,
			0,
			math.max(0, tela.X - menu.AbsoluteSize.X)
		),
		math.clamp(
			menu.Position.Y.Offset,
			0,
			math.max(0, tela.Y - menu.AbsoluteSize.Y)
		)
	)
end))

-- INICIALIZAÇÃO
for _, plr in ipairs(Players:GetPlayers()) do
	adicionarJogador(plr)
end

guardarConexao(Players.PlayerAdded:Connect(adicionarJogador))
guardarConexao(Players.PlayerRemoving:Connect(removerJogador))

atualizarUISpeed()
atualizarUIJump()
atualizarUIFPS()
selecionarAba("TP")
atualizarUI()
