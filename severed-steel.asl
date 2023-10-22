// autosplitter and layout by nyutie
// first time doin any of this :3_:

state("ThankYouVeryCool-Win64-Shipping", "4.27.2.0") {
    // float levelTimer: 0x05B0F540, 0x118, 0xB54;
    float fullTimer: 0x05B0F540, 0x118, 0xB58;
    bool isOnMainMenu: 0x05935BC0, 0x18, 0x48; // alt 0x05AA1660, 0x118, 0x5E8, 0x110
}

init
{
    vars.SaveOffsetPath = new DeepPointer(0x5B0B178, 0x130, 0x38, 0x70, 0x459);
}

startup
{
    vars.MapReferences = new List<string>() {
        "/Game/Campaign/Trash/CDA_Trash.CDA_Trash_C",
        "/Game/Campaign/TrashDiveTut/CDA_TrashDive.CDA_TrashDive_C",
        "/Game/Campaign/AboveTrash/CDA_AboveTrash.CDA_AboveTrash_C",
        "/Game/Campaign/Trash_turrets/CDA_Turrets.CDA_Turrets_C",
        "/Game/Campaign/trash_combat/CDA_TrashCombat.CDA_TrashCombat_C",
        "/Game/Campaign/TrashControlRoom/CDA_WasteManagement.CDA_WasteManagement_C",
        "/Game/Campaign/MeatPlant/CDA_RedHouse.CDA_RedHouse_C",
        "/Game/Campaign/MeatProc/CDA_RedProc.CDA_RedProc_C",
        "/Game/Campaign/HospitlCafe/CDA_Cafeteria.CDA_Cafeteria_C",
        "/Game/Campaign/Labs/CDA_Labs.CDA_Labs_C",
        "/Game/Campaign/LabBasement/CDA_LabBasement.CDA_LabBasement_C",
        "/Game/Campaign/HospitalCare/CDA_CyberHospital.CDA_CyberHospital_C",
        "/Game/Campaign/Corridor/CDA_Corridor.CDA_Corridor_C",
        "/Game/Campaign/Vents1/CDA_Vents1.CDA_Vents1_C",
        "/Game/Campaign/Vents_two/CDA_Vents2.CDA_Vents2_C",
        "/Game/Campaign/Oxygenate/CDA_Oxygenate.CDA_Oxygenate_C",
        "/Game/Campaign/TrainStation/CDA_SubwayStation.CDA_SubwayStation_C",
        "/Game/Campaign/Train0/CDA_Train0.CDA_Train0_C",
        "/Game/Campaign/TrainOne/CDA_TrainOne.CDA_TrainOne_C",
        "/Game/Campaign/Checkpoint/CDA_Checkoint.CDA_Checkoint_C",
        "/Game/Campaign/Intelligence/CDA_Intel.CDA_Intel_C",
        "/Game/Campaign/DataPrism/CDA_DataPrism.CDA_DataPrism_C",
        "/Game/Campaign/ServerRoom/CDA_Serveroom.CDA_Serveroom_C",
        "/Game/Campaign/Armory/CDA_Armory.CDA_Armory_C",
        "/Game/Campaign/Prison/CDA_Prison.CDA_Prison_C",
        "/Game/Campaign/Vents3/CDA_Vents3.CDA_Vents3_C",
        "/Game/Campaign/Anxiety/CDA_Anxiety.CDA_Anxiety_C",
        "/Game/Campaign/Reception/CDA_Reception.CDA_Reception_C",
        "/Game/Campaign/LowerAdmin/CDA_LowerAdmin.CDA_LowerAdmin_C",
        "/Game/Campaign/MiddleAdmin/CDA_MiddleAdmin2.CDA_MiddleAdmin2_C",
        "/Game/Campaign/UpperAdmin/CDA_UpperAdmin.CDA_UpperAdmin_C",
        "/Game/Campaign/TeleportingLab/CDA_Teleporter.CDA_Teleporter_C",
        "/Game/Campaign/Barraks/CDA_Barracks.CDA_Barracks_C",
        "/Game/Campaign/Apartments/CDA_Apartments.CDA_Apartments_C",
        "/Game/Campaign/Mall/CDA_Mall.CDA_Mall_C",
        "/Game/Campaign/Asention/CDA_Asention.CDA_Asention_C",
        "/Game/Campaign/GlassMoon/CDA_GlassMoon.CDA_GlassMoon_C",
        "/Game/Campaign/Nightclub/CDA_Nightclub.CDA_Nightclub_C",
        "/Game/Campaign/ceooffice/CDA_ceooffice.CDA_ceooffice_C",
        "/Game/Campaign/Penthouse/CDA_Penthouse.CDA_Penthouse_C",
        "/Game/Campaign/Museum1/CDA_Gallery.CDA_Gallery_C",
        "/Game/Campaign/Museum/CDA_Museum.CDA_Museum_C",
        "/Game/Campaign/Garden/CDA_Garden.CDA_Garden_C",
        "/Game/Campaign/Mansion/CDA_Mansion.CDA_Mansion_C",
        "/Game/Campaign/TheWall/CDA_TheWall.CDA_TheWall_C",
        "/Game/Campaign/Cage/CDA_Cage.CDA_Cage_C",
        "/Game/Campaign/Escapism/CDA_Escapism.CDA_Escapism_C"
    };

    vars.CurrentMapIndex = -2;
}

update
{
    IntPtr resolvedSavePath = IntPtr.Zero;
    vars.SaveOffsetPath.DerefOffsets(game, out resolvedSavePath);
    vars.SaveOffset = resolvedSavePath;
    IntPtr saveOffset = vars.SaveOffset;
    int campaignLevelReferenceStringLength = game.ReadValue<int>(saveOffset + 130);
    vars.campaignLevelReferenceString = game.ReadString(saveOffset + 130 + 4, campaignLevelReferenceStringLength);
}

start
{
    if (!current.isOnMainMenu && vars.campaignLevelReferenceString == vars.MapReferences[0] && current.fullTimer == 0f)
    {
        vars.CurrentMapIndex = 0;
        return true;
    }
}

split
{
    int nowCurrentMapIndex = vars.MapReferences.IndexOf(vars.campaignLevelReferenceString);
    if (nowCurrentMapIndex == vars.CurrentMapIndex + 1)
    {
        vars.CurrentMapIndex = nowCurrentMapIndex;
        return true;
    }
    if (nowCurrentMapIndex == vars.MapReferences.Count && current.fullTimer == old.fullTimer) // last map
    {
        return true;
    }
}

reset
{
    if (current.isOnMainMenu)
    {
        vars.CurrentMapIndex = -2;
        return true;
    }
}

// isLoading
// {
//     if (!current.isOnMainMenu && current.levelTimer == old.levelTimer)
//     {
//         return true;
//     }
//     return false;
// }

gameTime
{
    return TimeSpan.FromSeconds(current.fullTimer);
}

// CurrentCampaignAsset - important, find memory region by doing a string search for this