local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local AIM_STRENGTH = 1 -- 1 = súper fuerte (tipo aimbot)

-- Obtener target más cercano a la mira
function getTarget()
    local closest = nil
    local shortestDistance = math.huge

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)

            if onScreen then
                local mousePos = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
                local targetPos = Vector2.new(pos.X, pos.Y)

                local distance = (mousePos - targetPos).Magnitude

                if distance < shortestDistance then
                    shortestDistance = distance
                    closest = v
                end
            end
        end
    end

    return closest
end

-- Ver si hay pared (raycast)
function canSee(target)
    local origin = camera.CFrame.Position
    local direction = (target.Character.HumanoidRootPart.Position - origin)

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(origin, direction, raycastParams)

    if result then
        return result.Instance:IsDescendantOf(target.Character)
    end

    return true
end

-- FUNCIÓN PRINCIPAL
function AimAssistDirection()
    local target = getTarget()

    if target and target.Character and canSee(target) then
        local origin = camera.CFrame.Position
        local targetPos = target.Character.HumanoidRootPart.Position

        local direction = (targetPos - origin).Unit

        local finalDirection = (camera.CFrame.LookVector:Lerp(direction, AIM_STRENGTH)).Unit

        return finalDirection
    end

    return camera.CFrame.LookVector
end
