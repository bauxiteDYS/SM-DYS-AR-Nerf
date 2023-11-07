#include <sourcemod>
#include <sdkhooks>

#pragma semicolon 1
#pragma newdecls required

static bool _late_load;

public Plugin myinfo = {
	name = "Dys AR Nerf",
	description = "Nerfs Dystopia's Assault Rifle secondary fire",
	author = "Rain, bauxite",
	version = "0.1.3",
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
  
  /* Quickly use switch to check if damage is equal to a bodyshot or headshot from AR Secondary fire 
  ** Which is what we want to modify. If the damage is 6 or 9, it should then check if it's from the AR
  ** And then change it to something else. If not, then it will not do anything more.
  ** Using the OnTakeDamageAlive hook seems to produce even more unexpected results.
  */
  
	switch (damage)
	{
	  	case 6.000000:
		{
		  // is this okay?
		}
		case 9.000000:
		{
		  // is this okay?
		}
		default:
		{
			return Plugin_Continue;
		}
	}
	
	char sWeapon[32];
	
	if (IsValidEntity(inflictor))
	{
		GetEntityClassname(inflictor, sWeapon, sizeof(sWeapon));
	}
	
	// The damage numbers here don't seem to always appear as expected in the game for some reason.
	
	if (StrEqual(sWeapon,"weapon_assault"))
	{
		if (damage == 6.000000)
		{
			damage = 5.000000;
			//damage = damage * 0.83;
			return Plugin_Changed;
		}
		else if (damage == 9.000000)
		{
			damage = 7.000000;
			//damage = damage * 0.77;
			return Plugin_Changed;
		}
		else
		{
			damage = 5.000000;
			PrintToServer(" damage was not 6 or 9 ");
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}
