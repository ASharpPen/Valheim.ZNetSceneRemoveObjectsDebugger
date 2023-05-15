using BepInEx;
using HarmonyLib;

namespace ZnetSceneDebugger;

[BepInPlugin("asharppen.valheim.ZNetSceneRemoveObjectsDebugger", "ZNetSceneDebugger", "1.0.1")]
public class Plugin : BaseUnityPlugin
{
    // Awake is called once when both the game and the plug-in are loaded
    void Awake()
    {
        Log.Logger = Logger;

        new Harmony("mod.ZNetSceneRemoveObjectsDebugger").PatchAll();
    }
}
