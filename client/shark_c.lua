QBCore = exports['qb-core']:GetCoreObject()

local AnyPlayerNearShark = nil
local isSharkAttack = false

Citizen.CreateThread(function()
		while true do
        Citizen.Wait(180000)
		local ped = PlayerPedId()
		local pedcoords = GetEntityCoords(ped, true)		
		local InWater = IsEntityInWater(ped)
		local name = GetNameOfZone(pedcoords.x, pedcoords.y, pedcoords.z)
			if name == 'OCEANA' or name == 'PALCOV' then
				if InWater then
				 --print('saldırıyor')
					SpawnShark()
					else
		--		 print('saldırmıyor')
			    end
			end
	    end
end)

function SpawnShark()

    local model = 0x06C3F072
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end

    local pCoords = GetEntityCoords(PlayerPedId())
	local EnemyShark = CreatePed(1, model, pCoords.x+10, pCoords.y+10, pCoords.z-2, 100, true, false)
	
	-- AddBlipForEntity(EnemyShark)
	
	SetPedSeeingRange(EnemyShark, 100.0)
	SetPedHearingRange(EnemyShark, 80.0)
	SetPedCombatAttributes(EnemyShark, 46, 1)
	SetPedFleeAttributes(EnemyShark, 0, 0)
	SetPedCombatRange(EnemyShark,2)
	SetPedDiesInWater(EnemyShark, false)
	TaskCombatPed(EnemyShark, GetPlayerPed(-1), 0, 16)
	
	isSharkAttack = true

    if not NetworkGetEntityIsNetworked(EnemyShark) then
        NetworkRegisterEntityAsNetworked(EnemyShark)
    end

	SetPedRelationshipGroupHash(EnemyShark, GetHashKey("HATES_PLAYER"))
	SetRelationshipBetweenGroups(5,GetHashKey("PLAYER"),GetHashKey("SHARK"))
	SetRelationshipBetweenGroups(5,GetHashKey("SHARK"),GetHashKey("PLAYER"))
	
end