--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

--// PLAYER & GUI
local player = Players.LocalPlayer
local playergui = player:WaitForChild("PlayerGui")
local UI = playergui:WaitForChild("UI")


--// Currency
local currencyGui = UI:WaitForChild("CurrencyGUI")
local currencyBar = currencyGui:WaitForChild("CurrencyBar")
local giveMoneyButton = currencyGui:WaitForChild("GiveMoneyButton")
local shopButton = currencyGui:WaitForChild("ShopButton")
local convertButton = currencyGui:WaitForChild("ConversionButton")

local coinFrame = currencyBar:WaitForChild("CoinFrame")
local gemFrame = currencyBar:WaitForChild("GemFrame")
local coinLabel = coinFrame:WaitForChild("CoinsLabel")
local gemLabel = gemFrame:WaitForChild("GemsLabel")

local coins = player:WaitForChild("leaderstats"):WaitForChild("Coins")
local gems = player:WaitForChild("leaderstats"):WaitForChild("Gems")

--// shop 
local shopGui = UI:WaitForChild("ShopGUI")
local shopFrame = shopGui:WaitForChild("ShopFrame")
local Frame = shopFrame:WaitForChild("ImageLabel"):WaitForChild("Frame")
local ItemButton = Frame:WaitForChild("TextButton")
--// OPTIONAL SCREEN TOGGLE -- example
shopGui.Enabled = false
--// FUNCTION TO UPDATE CURRENCY DISPLAY
local function updateCurrencyDisplay()
	coinLabel.Text = "Coins: "..tostring(coins.Value)
	gemLabel.Text = "Gems: "..tostring(gems.Value)
end

updateCurrencyDisplay()
coins.Changed:Connect(updateCurrencyDisplay)
gems.Changed:Connect(updateCurrencyDisplay)

--// BUTTONS

--// HOVER AND CLICK STYLE FUNCTION
local function setupButton(button, normalColor, hoverColor, clickFunc, StrokeModify)
	local originalSize = button.Size
	local hoverSize = UDim2.new(originalSize.X.Scale + 0.02, originalSize.X.Offset, originalSize.Y.Scale + 0.02, originalSize.Y.Offset)
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	-- UICorner & UIStroke
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,12)
	corner.Parent = button
	
	if StrokeModify then 
		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 0
		stroke.Color = Color3.new(0,0,0)
		stroke.Parent = button
		local strokethickness = tonumber(stroke.Thickness)
		print("StrokeModify boolean in action " .. strokethickness)
	else
		local border = Instance.new("UIStroke")
		border.Thickness = 2
		border.Color = Color3.new(0,0,0)
		border.Parent = button
	end

	button.BackgroundColor3 = normalColor
	button.AnchorPoint = Vector2.new(0.5,0.5)

	button.MouseEnter:Connect(function()
		TweenService:Create(button, tweenInfo, {Size = hoverSize, BackgroundColor3 = hoverColor}):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, tweenInfo, {Size = originalSize, BackgroundColor3 = normalColor}):Play()
	end)

	button.MouseButton1Click:Connect(function()
		if clickFunc then clickFunc() end

		local clickShrink = UDim2.new(originalSize.X.Scale - 0.02, originalSize.X.Offset, originalSize.Y.Scale - 0.02, originalSize.Y.Offset)
		local shrinkTween = TweenService:Create(button, tweenInfo, {Size = clickShrink})
		shrinkTween:Play()
		shrinkTween.Completed:Wait()

		local expandTween = TweenService:Create(button, tweenInfo, {Size = originalSize})
		expandTween:Play()
	end)
end

--// CONVERT GEM BUTTON
local convertEvent = ReplicatedStorage:WaitForChild("ConvertGemEvent")
setupButton(convertButton, Color3.fromRGB(0,255,0), Color3.fromRGB(0,170,0), function()
	convertEvent:FireServer()
end)

convertEvent.OnClientEvent:Connect(function(msg)
	if msg then
		local feedbackLabel = Instance.new("TextLabel")
		feedbackLabel.Text = msg
		feedbackLabel.TextColor3 = Color3.fromRGB(255,0,0)
		feedbackLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
		feedbackLabel.TextStrokeTransparency = 0
		feedbackLabel.TextScaled = true
		feedbackLabel.Size = UDim2.new(0.5,0,0.2,0)
		feedbackLabel.Position = UDim2.new(0.5,0,0.5,0)
		feedbackLabel.AnchorPoint = Vector2.new(0.5,0.5)
		feedbackLabel.BackgroundTransparency = 1
		feedbackLabel.Parent = currencyGui

		Debris:AddItem(feedbackLabel, 2)
	end
end)

--// GIVE MONEY BUTTON
local giveMoneyEvent = ReplicatedStorage:WaitForChild("GiveMoneyEvent")
setupButton(giveMoneyButton, Color3.fromRGB(0,170,0), Color3.fromRGB(0,85,0), function()
	giveMoneyEvent:FireServer(50)
end)

--// SHOP BUTTON
setupButton(shopButton, Color3.fromRGB(0,170,255), Color3.fromRGB(0,100,255), function()
	shopFrame.Visible = true
	shopGui.Enabled = true
	local originalSize = shopFrame.Size
	shopFrame.Size = UDim2.new(0,0,0,0)

	local tweenInfoFrame = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local tween = TweenService:Create(shopFrame, tweenInfoFrame, {Size = originalSize})
	tween:Play()
	setupButton(ItemButton, Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 170, 255), function()
		
		local feedbackLabel = Instance.new("TextLabel")
		feedbackLabel.Text = "Purchased Successfully"
		feedbackLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
		feedbackLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
		feedbackLabel.TextStrokeTransparency = 0
		feedbackLabel.TextScaled = true
		feedbackLabel.Size = UDim2.new(1,0,0.3,0)
		feedbackLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		feedbackLabel.AnchorPoint = Vector2.new(0.5,0.5)
		feedbackLabel.BackgroundTransparency = 1
		feedbackLabel.Parent = Frame
		
	end, true)
end, true)