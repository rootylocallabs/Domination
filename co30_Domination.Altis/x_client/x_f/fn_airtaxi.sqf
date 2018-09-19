// by Xeno
#define THIS_FILE "fn_airtaxi.sqf"
#include "..\..\x_setup.sqf"

if (isNil "d_heli_taxi_available") then {d_heli_taxi_available = true};

if (!d_heli_taxi_available) exitWith {[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_139")};

if (d_FLAG_BASE distance2D player < 500) exitWith {[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_140")};

private _exitj = false;
if (d_with_ranked || {d_database_found}) then {
	if (score player < (d_ranked_a # 15)) exitWith {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_1424", score player, d_ranked_a # 15];
		_exitj = true;
	};
	[player, (d_ranked_a # 15) * -1] remoteExecCall ["addScore", 2];
};

if (_exitj) exitWith {};

if (isNil "d_AISPAWN" || {isNull d_AISPAWN}) then {
	d_AISPAWN = createVehicle [d_HeliHEmpty, d_pos_ai_hut # 0, [], 0, "NONE"];
	publicVariable "d_AISPAWN";
};

d_x_taxi_target_pos = getPos d_AISPAWN;
d_x_do_call_taxi = false;

d_x_airtaximarker = "d_air_taxi_" + str _player;
[d_x_airtaximarker, d_x_taxi_target_pos, "ICON", "ColorBlue", [0.8,0.8], localize "STR_DOM_MISSIONSTRING_1882", 0, "mil_dot"] call d_fnc_CreateMarkerLocal;

createDialog "D_AirTaxiDialog";
waitUntil {!isNil "d_airdtaxi_dialog_open" && {d_x_do_call_taxi || {!d_airdtaxi_dialog_open || {!alive player || {player getVariable ["xr_pluncon", false] || {player getVariable ["ace_isunconscious", false]}}}}}};

if (!d_x_do_call_taxi) exitWith {
	player sideChat (localize "STR_DOM_MISSIONSTRING_1881");
};

d_x_taxi_target_pos set [2, 0];

player sideChat (localize "STR_DOM_MISSIONSTRING_141");

[netId player, getPos player, d_x_taxi_target_pos] remoteExec ["d_fnc_airtaxiserver", 2];
