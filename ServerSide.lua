-- Simple CurrencyManager for Demo (Server-Side)
-- Gives players their starting money

game.Players.PlayerAdded:Connect(function(player)
	-- Wait for the player's character to load
	player:WaitForChild("PlayerGui")

	-- Create the leaderstats folder
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	-- Create the Coins value and set it to 150
	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = 150
	coins.Parent = leaderstats

	-- Create the Gems value and set it to 20
	local gems = Instance.new("IntValue")
	gems.Name = "Gems"
	gems.Value = 20
	gems.Parent = leaderstats

	print("Loaded currency for " .. player.Name .. ": " .. coins.Value .. " Coins, " .. gems.Value .. " Gems")
end)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GiveMoneyEvent = ReplicatedStorage:WaitForChild("GiveMoneyEvent")

GiveMoneyEvent.OnServerEvent:Connect(function(player, amount)
	local coins = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Coins")
	if coins and typeof(amount) == "number" then
		coins.Value = coins.Value + amount
		print(player.Name .. " received " .. amount .. " Coins. Total: " .. coins.Value)
	end
end)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ConvertGemEvent = ReplicatedStorage:WaitForChild("ConvertGemEvent")

ConvertGemEvent.OnServerEvent:Connect(function(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return end

	local Gems = leaderstats:FindFirstChild("Gems")
	local Coins = leaderstats:FindFirstChild("Coins")
	if not Gems or not Coins then return end

	if Gems.Value >= 1 then
		Gems.Value = Gems.Value - 1
		Coins.Value = Coins.Value + 50
	else
		-- Optional: send message back to client
		ConvertGemEvent:FireClient(player, "Not enough Gems!")
	end
end)
