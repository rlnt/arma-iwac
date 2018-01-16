// ===========================================================================
// [IWAC] IBEN WAI AUTOCLAIM >> find_position.sqf
// ===========================================================================
// [last update: 2018-01-13]
// ===========================================================================
// Extended for IWAC by @iben for WAI, DayZ Epoch 1.0.6.2
// ===========================================================================
// :: Original source: 'dayz_server\WAI\compile\find_position.sqf'
// ===========================================================================
if (isServer) then {
  // -------------------------------------------------------------------------
  #include "defines.hpp"

  // -------------------------------------------------------------------------
  DBG("find_position.sqf",FSTR1("'iben_wai_ACcoordProtectorTimer' active (%1s) >> Initialising custom position FNC for mission coord protection...",iben_wai_ACcoordProtectorTimer));

  // -------------------------------------------------------------------------
  private ["_validspot","_attempt"];
  markerready = false;
  _validspot  = false;
  if (isNil "iben_waiACfindPosLimiter") then {iben_waiACfindPosLimiter = 500};
  _attempt = 0;

  // -------------------------------------------------------------------------
  // :: Static method
  if (use_staticspawnpoints) exitWith {
    // -----------------------------------------------------------------------
    private ["_i","_position"];
    for "_i" from 1 to iben_waiACfindPosLimiter do {
      _position = staticspawnpoints call BIS_fnc_selectRandom;
      _validspot = true;
      // ---------------------------------------------------------------------
      if (_validspot && {wai_avoid_missions != 0}) then {
        // WBG("find_position.sqf",FSTR1("Checking nearby mission markers >> wai_mission_markers >> %1",wai_mission_markers));
        // -------------------------------------------------------------------
        {
          if ((getMarkerColor _x != "") && {(_position distance (getMarkerPos _x)) < wai_avoid_missions}) exitWith {
            WBG("find_position.sqf",FSTR1("Invalid Position >> Marker >> %1",_x));
            _validspot = false;
          };
        } count wai_mission_markers;
        // -------------------------------------------------------------------
        if ((count iben_wai_ACprotectedCoord) > 0) then {
          if (_validspot && {(call IBEN_fnc_cleanProtectedCoord) > 0}) then {
            WBG("find_position.sqf",FSTR1("Spot found. Checking if spot is in protected coordinates >> iben_wai_ACprotectedCoord >> %1",iben_wai_ACprotectedCoord));
            {
              if ((_position distance (_x select 1)) < wai_avoid_missions) exitWith {
                WBG("find_position.sqf",FSTR2("Invalid Position >> Spot [%1] protected for next >> %2s",(_x select 2),(diag_tickTime - (_x select 0))));
                _validspot = false;
              };
            } count iben_wai_ACprotectedCoord;
          };
        };
      };
      // ---------------------------------------------------------------------
      if (_validspot) exitWith {
        WBG("find_position.sqf",FSTR3("Loop complete, valid position >> %1 >> in %2/%3 attempts",_position,_i,iben_waiACfindPosLimiter));
      };
      // ---------------------------------------------------------------------
      if (!_validspot && {_i == iben_waiACfindPosLimiter}) exitWith {
        WBG("find_position.sqf",FSTR1("You have reached max attempts (%1) to find mission spawn point. Consider to adjust these variables: iben_wai_ACdistance, wai_avoid_missions, wai_avoid_traders, wai_avoid_town, wai_avoid_road and wai_avoid_water. Think about all traders, water, roads etc.",iben_waiACfindPosLimiter));
      };
      // ---------------------------------------------------------------------
    };
    _position set [2, 0];
    _position
  };


  // -------------------------------------------------------------------------
  // :: Dynamic method
  private ["_safepos","_position","_y"];
  _safepos = [
     [getMarkerPos "center",0,8500,(_this select 0),0,0.5,0]
    ,[getMarkerPos "center",0,8500,(_this select 0),0,0.5,0,blacklist]
  ] select (use_blacklist);

  // -------------------------------------------------------------------------
  for "_y" from 1 to iben_waiACfindPosLimiter do {
    _position = _safepos call BIS_fnc_findSafePos;
    _validspot  = true;
    // -----------------------------------------------------------------------
    if (_position call inDebug) then {
      WBG("find_position.sqf",FSTR1("%1","Invalid Position >> Debug"));
      _validspot = false;
    };
    // -----------------------------------------------------------------------
    if(_validspot && {wai_avoid_water != 0}) then {
      if ([_position,wai_avoid_water] call isNearWater) then {
        WBG("find_position.sqf",FSTR1("%1","Invalid Position >> Water"));
        _validspot = false;
      };
    };
    // -----------------------------------------------------------------------
    if (_validspot && {isNil "infiSTAR_LoadStatus1"} && {wai_avoid_town != 0}) then {
      if ([_position,wai_avoid_town] call isNearTown) then {
        WBG("find_position.sqf",FSTR1("%1","Invalid Position >> Town"));
        _validspot = false;
      };
    };
    // -----------------------------------------------------------------------
    if(_validspot && {wai_avoid_road != 0}) then {
      if ([_position,wai_avoid_road] call isNearRoad) then {
        WBG("find_position.sqf",FSTR1("%1","Invalid Position >> Road"));
        _validspot = false;
      };
    };
    // -----------------------------------------------------------------------
    if (_validspot && {wai_avoid_missions != 0}) then {
      // WBG("find_position.sqf",FSTR1("Checking nearby mission markers >> wai_mission_markers >> %1",wai_mission_markers));
      // -------------------------------------------------------------------
      {
        if ((getMarkerColor _x != "") && {(_position distance (getMarkerPos _x)) < wai_avoid_missions}) exitWith {
          WBG("find_position.sqf",FSTR1("Invalid Position >> Marker >> %1",_x));
          _validspot = false;
        };
      } count wai_mission_markers;
      // -------------------------------------------------------------------
      if ((count iben_wai_ACprotectedCoord) > 0) then {
        if (_validspot && {(call IBEN_fnc_cleanProtectedCoord) > 0}) then {
          WBG("find_position.sqf",FSTR1("Spot found. Checking if spot is in protected coordinates >> iben_wai_ACprotectedCoord >> %1",iben_wai_ACprotectedCoord));
          {
            if ((_position distance (_x select 1)) < wai_avoid_missions) exitWith {
              WBG("find_position.sqf",FSTR2("Invalid Position >> Spot [%1] protected for next >> %2s",(_x select 2),(diag_tickTime - (_x select 0))));
              _validspot = false;
            };
          } count iben_wai_ACprotectedCoord;
        };
      };
    };
    // -----------------------------------------------------------------------
    if (_validspot && {wai_avoid_traders != 0}) then {
      WBG("find_position.sqf",FSTR1("Checking nearby trader markers >> trader_markers >> %1",trader_markers));
      {
        if ((getMarkerColor _x != "") && {(_position distance (getMarkerPos _x)) < wai_avoid_traders}) exitWith {
          WBG("find_position.sqf",FSTR1("Invalid Position >> Trader Marker >> %1",_x));
          _validspot = false;
        };
      } count trader_markers;
    };
    // -----------------------------------------------------------------------
    if (_validspot) exitWith {
      WBG("find_position.sqf",FSTR3("Loop complete, valid position >> %1 >> in %2/%3 attempts",_position,_y,iben_waiACfindPosLimiter));
    };
    // ---------------------------------------------------------------------
    if (!_validspot && {_y == iben_waiACfindPosLimiter}) exitWith {
      WBG("find_position.sqf",FSTR1("You have reached max attempts (%1) to find mission spawn point. Consider using option use_staticspawnpoints in your config.sqf, or adjust these variables: iben_wai_ACdistance, wai_avoid_missions, wai_avoid_traders, wai_avoid_town, wai_avoid_road and wai_avoid_water. Remember: maps such as napf cannot use iben_wai_ACdistance = 1200. This map is not big enough (measure it yourself and then consider all traders, water, roads etc. Think about it!)",iben_waiACfindPosLimiter));
    };
    // -----------------------------------------------------------------------
  };

  // -------------------------------------------------------------------------
  _position set [2, 0];
  _position
};
