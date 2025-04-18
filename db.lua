-- db.lua

local AceEvent = LibStub("AceEvent-3.0")
TrueRP_DB = TrueRP_DB or {}

local Events = TrueRP_Events

--- Module d'accès aux portraits personnalisés
local Module = {}

--- S'assure qu'une entrée existe dans la base de données pour un joueur
-- @param owner string
local function EnsureDBEntry(owner)
    TrueRP_DB[owner] = TrueRP_DB[owner] or { pets = {} }
end

--- Récupère une texture de portrait personnalisée depuis la base de données
-- @param owner string - nom du joueur
-- @param pet string|nil - nom du familier (optionnel)
-- @return string|nil - chemin vers la texture
function Module.GetPortraitFromDB(owner, pet)
    local data = TrueRP_DB[owner]
    if not data then return nil end
    return pet and data.pets and data.pets[pet] or data.portrait
end

--- Vérifie si un portrait personnalisé existe pour un joueur
-- @param owner string
-- @return boolean
function Module.HasPortrait(owner)
    return Module.GetPortraitFromDB(owner) ~= nil
end

--- Retourne la table des portraits de familiers pour un joueur donné
-- @param owner string
-- @return table|nil
function Module.GetPetPortraits(owner)
    local data = TrueRP_DB[owner]
    return data and data.pets or nil
end

--- Définit le portrait principal d’un joueur
-- @param owner string
-- @param path string
function Module.SetPortraitInDB(owner, path)
    EnsureDBEntry(owner)
    TrueRP_DB[owner].portrait = path
    Module.FirePortraitChanged(owner, nil)
end

--- Définit le portrait d’un familier pour un joueur
-- @param owner string
-- @param pet string
-- @param path string
function Module.SetPetPortraitInDB(owner, pet, path)
    EnsureDBEntry(owner)
    TrueRP_DB[owner].pets[pet] = path
    Module.FirePortraitChanged(owner, pet)
end

function Module.FirePortraitChanged(owner, pet)
    AceEvent:SendMessage("TRUERP_PORTRAIT_CHANGED", owner, pet)
end

-- Exporte le module dans l'environnement global
TrueRP_DBModule = Module
