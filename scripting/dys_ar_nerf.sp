#include <sourcemod>
#include <sdkhooks>

#pragma semicolon 1
#pragma newdecls required

static bool _late_load;

public Plugin myinfo = {
	name = "Dys AR Nerf",
	description = "Nerfs Dystopia's Assault Rifle secondary fire",
	author = "Rain, bauxite",
	version = "0.1.7",
	url = "https://github.com/bauxiteDYS/SM-DYS-AR-Nerf",
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	_late_load = late;
	return APLRes_Success;
}

public void OnPluginStart()
{
	if (_late_load)
	{
		for (int client = 1; client <= MaxClients; ++client)
		{
			if (!IsClientInGame(client))
			{
				continue;
			}
			if (!SDKHookEx(client, SDKHook_OnTakeDamage, OnTakeDamage))
			{
				ThrowError("Failed to SDKHook");
			}
			else
			{
				PrintToServer("Hook ok!");
			}
		}
	}
}

public void OnClientPutInServer(int client)
{
	if (!SDKHookEx(client, SDKHook_OnTakeDamage, OnTakeDamage))
	{
		ThrowError("Failed to SDKHook");
	}
}

public Action OnTakeDamage(int victim, int& attacker, int& inflictor, float& damage, int& damagetype, int& weapon, float damageForce[3], float damagePosition[3])
{	

	if (damage != 6.000000 && damage != 9.000000)
	{
		return Plugin_Continue;
	}
	
	if (!IsValidEntity(inflictor))
	{
		return Plugin_Continue;
	}

	char sWeapon[14 + 1];

	if (!GetEntityClassname(inflictor, sWeapon, sizeof(sWeapon)))
	{
		return Plugin_Continue;
	}

	// The damage numbers here don't seem to always appear as expected in the game for some reason.
	// Probably due to some rounding or other things in the game.
	
	if (StrEqual(sWeapon,"weapon_assault"))
	{
		if (damage == 9.000000)
		{
			damage = 7.000000;
			return Plugin_Changed;
		}
		else
		{
			damage = 4.950000;
			return Plugin_Changed;
		}
  
    	}	

	return Plugin_Continue;
}
