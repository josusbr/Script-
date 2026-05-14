local Model = "rbxassetid://78573618395334"
local spawnCount = 0

local function getRandomPosition()
    local x = math.random(-500, 500)
    local z = math.random(-500, 500)
    local rayOrigin = Vector3.new(x, 500, z)
    local rayDirection = Vector3.new(0, -1000, 0)
    local raycastParams = RaycastParams.new()
    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if result and result.Instance then
        if result.Normal.Y > 0.9 then
            return result.Position
        end
    end
    return nil
end

local function teleportEffect(player)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local hrp = character.HumanoidRootPart
        for i = 1, 9 do
            local randomDirection = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
            hrp.CFrame = hrp.CFrame + (randomDirection * 90)
            task.wait(0.074)
        end
    end
end

local function spawnModel()
    local pos = nil
    while not pos do
        pos = getRandomPosition()
        task.wait(0.1)
    end

    local success, modelList = pcall(function()
        return game:GetObjects(Model)
    end)

    if success and modelList and modelList[1] then
        local model = modelList[1]
        model.Parent = workspace
        model:MoveTo(pos)
        
        spawnCount = spawnCount + 1
        print("Spawned " .. spawnCount)

        local hitbox = model:FindFirstChild("Hitbox", true)
        if hitbox and hitbox:IsA("BasePart") then
            hitbox.Touched:Connect(function(hit)
                local player = game.Players:GetPlayerFromCharacter(hit.Parent)
                if player then
                    teleportEffect(player)
                end
            end)
        end
    end
end

task.spawn(function()
    while true do
        task.wait(math.random(60, 120))
        spawnModel()
    end
end)
