// ===========================================================================
// [IWAC] IBEN WAI AUTOCLAIM >> remote_message.sqf
// ===========================================================================
// [last update: 2018-01-13]
// ===========================================================================
// Original file source: ZSC by @salival
// Original file link :https://github.com/oiad/ZSC/blob/master/dayz_code/compile/remote_message.sqf
// Extended by @iben for WAI, DayZ Epoch 1.0.6.2
// ===========================================================================
fnc_remote_message = {
  private ["_type","_message"];
  _type = _this select 0;
  _message = _this select 1;
  call {
    if (_type == "radio") exitWith {
      if (player hasWeapon "ItemRadio") then {
        if (player getVariable["radiostate",true]) then {
          systemChat _message;
          playSound "Radio_Message_Sound";
        };
      };
    };
    // -----------------------------------------------------------------------
    if (_type == "IWAC") exitWith {
      if (getPlayerUID player == (_message select 0)) then {
        if (player hasWeapon "ItemRadio") then {
          if (player getVariable["radiostate",true]) then {
            (_message select 1) call dayz_rollingMessages;
            playSound "IWAC_Message_Sound";
          };
        };
      };
    };
    // -----------------------------------------------------------------------
    if (_type == "private") exitWith {if(getPlayerUID player == (_message select 0)) then {systemChat (_message select 1);};};
    if (_type == "global") exitWith {systemChat _message;};
    if (_type == "hint") exitWith {hint _message;};
    if (_type == "titleCut") exitWith {titleCut [_message,"PLAIN DOWN",3];};
    if (_type == "titleText") exitWith {titleText [_message, "PLAIN DOWN"]; titleFadeOut 10;};
    if (_type == "rollingMessages") exitWith {_message call dayz_rollingMessages;};
    if (_type == "dynamic_text") exitWith {
      [
        format["<t size='0.40' color='#FFFFFF' align='center'>%1</t><br /><t size='0.70' color='#d5a040' align='center'>%2</t>",_message select 0,_message select 1],
        0,
        0,
        10,
        0.5
      ] spawn BIS_fnc_dynamicText;
    };
  };
};

"RemoteMessage" addPublicVariableEventHandler {(_this select 1) spawn fnc_remote_message;};
