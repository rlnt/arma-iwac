// ===========================================================================
// [IWAC] IBEN WAI AUTOCLAIM >> CfgSounds.hpp
// ===========================================================================
// [last update: 2018-01-13]
// ===========================================================================
// created by @iben for WAI, DayZ Epoch 1.0.6.2
// ===========================================================================
class CfgSounds
{
  sounds[] =
  {
   // Radio_Message_Sound
  ,IWAC_Message_Sound
  };
  // class Radio_Message_Sound
  // {
    // name="Radio_Message_Sound";
    // sound[] = {dayz_sfx\sounds\radio.ogg,0.4,1};
    // titles[] = {};
  // };
  class IWAC_Message_Sound
  {
    name="IWAC_Message_Sound";
    sound[] = {dayz_sfx\sounds\IWACsound.ogg,0.4,1};
    titles[] = {};
  };
};
