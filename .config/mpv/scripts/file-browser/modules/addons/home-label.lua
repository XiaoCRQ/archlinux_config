--[[
    An addon for mpv-file-browser which displays ~/ for the home directory instead of the full path
]]--

local mp = require "mp"
local fb = require "file-browser"

local home = fb.fix_path(mp.command_native({"expand-path", "~/"}) --[[@as string]], true)

---@type ParserConfig
local home_label = {
    priority = 100,
    api_version = "1.0.0"
}

function home_label:can_parse(directory)
    if not fb.get_opt('home_label') then return false end
    return directory:sub(1, home:len()) == home
end

---@async
function home_label:parse(directory)
    local list, opts = self:defer(directory)
    if not opts then opts = {} end
    if (not opts.directory or opts.directory == directory) and not opts.directory_label then
        opts.directory_label = "~/"..(directory:sub(home:len()+1) or "")
    end
    return list, opts
end

return home_label