# Roblox Currency System Demo

A simple demo of a currency system in Roblox with coins, gems, and a shop UI.

---

## Features

### Client-Side
- Display coins and gems.
- Buttons for:
  - Giving coins
  - Converting gems to coins
  - Opening a shop with a single sample item
- Hover and click animations using TweenService.
- Dynamic feedback labels for actions like purchases or errors.

### Server-Side
- Adds `leaderstats` for coins and gems on player join.
- Handles:
  - Giving coins
  - Converting gems into coins
- Sends client feedback when an action fails (e.g., not enough gems).

---

## Setup

1. Insert the RemoteEvents in `ReplicatedStorage`:
   - `GiveMoneyEvent`
   - `ConvertGemEvent`
2. Place the server script in `ServerScriptService`.
3. Place the client script in `StarterPlayerScripts` or GUI container.
4. Play and test the buttons.

---

## File Structure Example

RobloxCurrencySystem/
├── Client/
│ └── CurrencyGUI.lua
├── Server/
│ └── CurrencyManagerServer.lua


---

## Notes

- This is **not a basic static UI**; the UI is dynamic, procedural, and functional.
- Hover and click effects are handled programmatically.
- Feedback labels are generated dynamically using `Debris:AddItem` for automatic cleanup.
- Can be expanded into a full shop system with multiple items.

---

## License

This project is for demo and educational purposes.
