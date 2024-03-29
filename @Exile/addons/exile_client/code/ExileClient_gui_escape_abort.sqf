/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_display","_controlAbort","_controlSuicide","_controlTitle","_controlFiledShit","_abortTime"];
disableSerialization;
waitUntil {!isNull (findDisplay 49)};
_display = findDisplay 49;
_controlAbort = _display displayCtrl 104;
_controlSuicide = _display displayCtrl 1337;
_controlTitle = _display displayCtrl 523;
_controlFiledShit = _display displayCtrl 122;
_abortTime = diag_tickTime + 10;
_controlFiledShit ctrlEnable false;
_controlFiledShit ctrlCommit 0;
_controlTitle ctrlSetText "exilemod.com";
_controlTitle ctrlCommit 0;
if !(alive player) then
{
	_controlAbort ctrlEnable true;
	_controlAbort ctrlSetText "Abort to Lobby";
	_controlAbort ctrlCommit 0;
	_controlSuicide ctrlEnable true;
	_controlSuicide ctrlSetText "Respawn";
	_controlSuicide ctrlSetEventHandler ["ButtonClick", "[] call ExileClient_gui_escape_respawn"];
	_controlSuicide ctrlCommit 0;
}
else 
{
	if ( ExileClientPlayerIsInCombat || (vehicle player != player)) then
	{
		_controlAbort ctrlEnable false;
		_controlAbort ctrlSetText "Abort to Lobby";
		_controlAbort ctrlCommit 0;
		_controlSuicide ctrlEnable false;
		_controlSuicide ctrlSetText "Respawn";
		_controlSuicide ctrlCommit 0;
	}
	else 
	{
		ExileClientConnection = false; 
		["connectionTest", [false]] call ExileClient_system_network_send;
		_controlSuicide ctrlEnable true;
		_controlSuicide ctrlSetText "Commit Suicide";
		_controlSuicide ctrlSetEventHandler ["ButtonClick", "[] spawn ExileClient_gui_escape_suicide"];
		_controlSuicide ctrlCommit 0;
		while {!isNull _display} do
		{
			_controlAbort ctrlEnable false;
			_controlAbort ctrlSetText format ["(Please wait (%1s)", ceil(_abortTime - diag_tickTime)];
			_controlAbort ctrlCommit 0;
			if (diag_tickTime > _abortTime) exitWith
			{
					_controlAbort ctrlEnable true;
					_controlAbort ctrlSetText "Abort to Lobby";
					_controlAbort ctrlCommit 0;
			};
		};
	};
};
true