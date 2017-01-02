
--Begin supergrpup.lua
--Check members #Add supergroup
local function check_member_super(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  if success == 0 then
	send_large_msg(receiver, "Promote me to admin first!")
  end
  for k,v in pairs(result) do
    local member_id = v.peer_id
    if member_id ~= our_id then
      -- SuperGroup configuration
      data[tostring(msg.to.id)] = {
        group_type = 'SuperGroup',
		long_id = msg.to.peer_id,
		moderators = {},
        set_owner = member_id ,
        settings = {
          set_name = string.gsub(msg.to.title, '_', ' '),
		  lock_arabic = '🔓',
		  lock_link = "🔐",
                  flood = '🔐',
                  lock_media = '🔓',
                  lock_share = '🔓',
		  lock_bots = '🔐',
		  lock_number = '🔓',
		  lock_poker = '🔓',
		  lock_audio = '🔓',
		  lock_photo = '🔓',	
		  lock_video = '🔓',
		  lock_documents = '🔓',	
		  lock_text = '🔓',
		  lock_all = '🔓',	
		  lock_gifs = '🔓',	
		  lock_inline = '🔐',	
		  lock_cmd = '🔓',	
		  lock_spam = '🔐',
		  lock_sticker = '🔓',
		  member = '🔓',
		  public = '🔓',
		  lock_rtl = '🔓',
		  lock_tgservice = '🔓',
		  lock_contacts = '🔓',
		  lock_tag = '🔓',
		  lock_webpage = '🔐',
		  lock_fwd = '🔓',
		  lock_emoji = '🔓',
		  lock_eng = '🔓',
		  strict = '🔓',
		  lock_badw = '🔐'
        }
      }
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
	  local text = '<i>✨SuperGroup has been added!(8)✨\n✨white wolf 7✨</i>'
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

--Check Members #rem supergroup
local function check_member_superrem(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result) do
    local member_id = v.id
    if member_id ~= our_id then
	  -- Group configuration removal
      data[tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
	  local text = '<i>✨SuperGroup has been removed!(5.3)✨</i>'
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

--Function to Add supergroup
local function superadd(msg)
	local data = load_data(_config.moderation.data)
	local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_super,{receiver = receiver, data = data, msg = msg})
end

--Function to remove supergroup
local function superrem(msg)
	local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_superrem,{receiver = receiver, data = data, msg = msg})
end

--Get and output admins and bots in supergroup
local function callback(cb_extra, success, result)
local i = 1
local chat_name = string.gsub(cb_extra.msg.to.print_name, "_", " ")
local member_type = cb_extra.member_type
local text = member_type.." for "..chat_name..":\n"
for k,v in pairsByKeys(result) do
if not v.first_name then
	name = " "
else
	vname = v.first_name:gsub("‮", "")
	name = vname:gsub("_", " ")
	end
		text = text.."\n"..i.." - "..name.."["..v.peer_id.."]"
		i = i + 1
	end
    send_large_msg(cb_extra.receiver, text)
end

local function callback_clean_bots (extra, success, result)
	local msg = extra.msg
	local receiver = 'channel#id'..msg.to.id
	local channel_id = msg.to.id
	for k,v in pairs(result) do
		local bot_id = v.peer_id
		kick_user(bot_id,channel_id)
	end
end
--Get and output info about supergroup
local function callback_info(cb_extra, success, result)
local title ="<i>🔨Info for SuperGroup >> ["..result.title.."]\n\n</i>"
local admin_num = "<i>🔱Admin count >> "..result.admins_count.."\n</i>"
local user_num = "<i>🔅User count >> "..result.participants_count.."\n</i>"
local kicked_num = "<i>🚫Kicked user count >> "..result.kicked_count.."\n</i>"
local channel_id = "<i>💠ID >> "..result.peer_id.."\n</i>"
if result.username then
	channel_username = "🔹Username >> @"..result.username
else
	channel_username = ""
end
local text = title..admin_num..user_num..kicked_num..channel_id..channel_username
    send_large_msg(cb_extra.receiver, text)
end

--Get and output members of supergroup
local function callback_who(cb_extra, success, result)
local text = "<i>💠Members for</i> "..cb_extra.receiver
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		username = " @"..v.username
	else
		username = ""
	end
	text = text.."\n"..i.." - "..name.." "..username.." [ "..v.peer_id.." ]\n"
	--text = text.."\n"..username
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./groups/lists/supergroups/"..cb_extra.receiver..".txt", ok_cb, false)
	post_msg(cb_extra.receiver, text, ok_cb, false)
end

--Get and output list of kicked users for supergroup
local function callback_kicked(cb_extra, success, result)
--vardump(result)
local text = "<i>🚫Kicked Members for SuperGroup</i>"..cb_extra.receiver.."\n\n> "
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		name = name.." @"..v.username
	end
	text = text.."\n"..i.." - "..name.." [ "..v.peer_id.." ]\n"
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", ok_cb, false)
	--send_large_msg(cb_extra.receiver, text)
end

--Begin supergroup locks
local function lock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == '🔐' then
    return reply_msg(msg.id,">><i> ✨#Link posting is #already locked✨✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_link'] = '🔐'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">> <i>✨#Link posting has been #locked✨</i>", ok_cb, false)
  end
end

local function unlock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == '🔓' then
    return reply_msg(msg.id,">><i> ✨#Link posting is #not locked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_link'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">> <i>✨#Link posting has been #unlocked✨</i>", ok_cb, false)
  end
end

	local function lock_group_media(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_media_lock = data[tostring(target)]['settings']['lock_media']
  if group_media_lock == '🔐' then
    return 'Media posting is already locked'
  else
    data[tostring(target)]['settings']['lock_media'] = '🔐'
    save_data(_config.moderation.data, data)
    return 'Media posting has been locked'
  end
end

local function unlock_group_media(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_media_lock = data[tostring(target)]['settings']['lock_media']
  if group_media_lock == '🔓' then
    return 'Media posting is not locked'
  else
    data[tostring(target)]['settings']['lock_media'] = '🔓'
    save_data(_config.moderation.data, data)
    return 'Media posting has been unlocked'
  end
end
    
local function lock_group_share(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_share_lock = data[tostring(target)]['settings']['lock_share']
  if group_share_lock == '🔐' then
    return 'share posting is already locked'
  else
    data[tostring(target)]['settings']['lock_share'] = '🔐'
    save_data(_config.moderation.data, data)
    return 'share posting has been locked'
  end
end

local function unlock_group_share(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_share_lock = data[tostring(target)]['settings']['lock_share']
  if group_share_lock == '🔓' then
    return 'share posting is not locked'
  else
    data[tostring(target)]['settings']['lock_share'] = '🔓'
    save_data(_config.moderation.data, data)
    return 'share posting has been unlocked'
  end
end

local function lock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == '🔐' then
    return 'bots is already locked'
  else
    data[tostring(target)]['settings']['lock_bots'] = '🔐'
    save_data(_config.moderation.data, data)
    return 'bots has been locked'
  end
end

local function unlock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == '🔓' then
    return 'bots is not locked'
  else
    data[tostring(target)]['settings']['lock_bots'] = '🔓'
    save_data(_config.moderation.data, data)
    return 'bots has been unlocked'
  end
end

local function lock_group_number(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_number_lock = data[tostring(target)]['settings']['lock_number']
  if group_number_lock == '🔐' then
    return 'number posting is already locked'
  else
    data[tostring(target)]['settings']['lock_number'] = '🔐'
    save_data(_config.moderation.data, data)
    return 'number posting has been locked'
  end
end

local function unlock_group_number(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_number_lock = data[tostring(target)]['settings']['lock_number']
  if group_number_lock == '🔓' then
    return 'number posting is not locked'
  else
    data[tostring(target)]['settings']['lock_number'] = '🔓'
    save_data(_config.moderation.data, data)
    return 'number posting has been unlocked'
  end
end

local function lock_group_poker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_poker_lock = data[tostring(target)]['settings']['lock_poker']
  if group_poker_lock == '🔐' then
    return 'poker posting is already locked'
  else
    data[tostring(target)]['settings']['lock_poker'] = '🔐'
    save_data(_config.moderation.data, data)
    return 'poker posting has been locked'
  end
end

local function unlock_group_poker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_poker_lock = data[tostring(target)]['settings']['lock_poker']
  if group_poker_lock == '🔓' then
    return 'poker posting is not locked'
  else
    data[tostring(target)]['settings']['lock_poker'] = '🔓'
    save_data(_config.moderation.data, data)
    return 'poker posting has been unlocked'
  end
end

	local function lock_group_audio(msg, data, target)
		local msg_type = 'Audio'
		local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_audio_lock = data[tostring(target)]['settings']['lock_audio']
  if group_audio_lock == '🔐' and is_muted(chat_id, msg_type..': yes') then
    return 'audio posting is already locked'
  else
    if not is_muted(chat_id, msg_type..': yes') then
		mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_audio'] = '🔐'
    save_data(_config.moderation.data, data)
    return 'audio posting has been locked'
    end
  end
end

local function unlock_group_audio(msg, data, target)
	local chat_id = msg.to.id
	local msg_type = 'Audio'
  if not is_momod(msg) then
    return
  end
  local group_audio_lock = data[tostring(target)]['settings']['lock_audio']
  if group_audio_lock == '🔓' and not is_muted(chat_id, msg_type..': yes') then
    return 'audio posting is not locked'
  else
  	if is_muted(chat_id, msg_type..': yes') then
		unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_audio'] = '🔓'
    save_data(_config.moderation.data, data)
    return 'audio posting has been unlocked'
    end
  end
end

	local function lock_group_photo(msg, data, target)
		local msg_type = 'Photo'
		local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
  if group_photo_lock == '🔐' and is_muted(chat_id, msg_type..': yes') then
    return 'photo posting is already locked'
  else
    if not is_muted(chat_id, msg_type..': yes') then
		mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_photo'] = '🔐'
    save_data(_config.moderation.data, data)
    return 'photo posting has been locked'
    end
  end
end

local function unlock_group_photo(msg, data, target)
	local chat_id = msg.to.id
	local msg_type = 'Photo'
  if not is_momod(msg) then
    return
  end
  local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
  if group_photo_lock == '🔓' and not is_muted(chat_id, msg_type..': yes') then
    return 'photo posting is not locked'
  else
  	if is_muted(chat_id, msg_type..': yes') then
		unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_photo'] = '🔓'
    save_data(_config.moderation.data, data)
    return 'photo posting has been unlocked'
    end
  end
end

	local function lock_group_video(msg, data, target)
		local msg_type = 'Video'
		local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_video_lock = data[tostring(target)]['settings']['lock_video']
  if group_video_lock == '🔐' and is_muted(chat_id, msg_type..': yes') then
    return 'video posting is already locked'
  else
    if not is_muted(chat_id, msg_type..': yes') then
		mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_video'] = '🔐'
    save_data(_config.moderation.data, data)
    return 'video posting has been locked'
    end
  end
end

local function unlock_group_video(msg, data, target)
	local chat_id = msg.to.id
	local msg_type = 'Video'
  if not is_momod(msg) then
    return
  end
  local group_video_lock = data[tostring(target)]['settings']['lock_video']
  if group_video_lock == '🔓' and not is_muted(chat_id, msg_type..': yes') then
    return 'video posting is not locked'
  else
  	if is_muted(chat_id, msg_type..': yes') then
		unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_video'] = '🔓'
    save_data(_config.moderation.data, data)
    return 'video posting has been unlocked'
    end
  end
end

	local function lock_group_documents(msg, data, target)
		local msg_type = 'Documents'
		local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_documents_lock = data[tostring(target)]['settings']['lock_documents']
  if group_documents_lock == '🔐' and is_muted(chat_id, msg_type..': yes') then
    return 'documents posting is already locked'
  else
    if not is_muted(chat_id, msg_type..': yes') then
		mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_documents'] = '🔐'
    save_data(_config.moderation.data, data)
    return 'documents posting has been locked'
    end
  end
end

local function unlock_group_documents(msg, data, target)
	local chat_id = msg.to.id
	local msg_type = 'Documents'
  if not is_momod(msg) then
    return
  end
  local group_documents_lock = data[tostring(target)]['settings']['lock_documents']
  if group_documents_lock == '🔓' and not is_muted(chat_id, msg_type..': yes') then
    return 'documents posting is not locked'
  else
  	if is_muted(chat_id, msg_type..': yes') then
		unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_documents'] = '🔓'
    save_data(_config.moderation.data, data)
    return 'documents posting has been unlocked'
    end
  end
end

	local function lock_group_text(msg, data, target)
		local msg_type = 'Text'
		local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_text_lock = data[tostring(target)]['settings']['lock_text']
  if group_text_lock == '🔐' and is_muted(chat_id, msg_type..': yes') then
    return 'text posting is already locked'
  else
    if not is_muted(chat_id, msg_type..': yes') then
		mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_text'] = '🔐'
    save_data(_config.moderation.data, data)
    return 'text posting has been locked'
    end
  end
end

local function unlock_group_text(msg, data, target)
	local chat_id = msg.to.id
	local msg_type = 'Text'
  if not is_momod(msg) then
    return
  end
  local group_text_lock = data[tostring(target)]['settings']['lock_text']
  if group_text_lock == '🔓' and not is_muted(chat_id, msg_type..': yes') then
    return 'text posting is not locked'
  else
  	if is_muted(chat_id, msg_type..': yes') then
		unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_text'] = '🔓'
    save_data(_config.moderation.data, data)
    return 'text posting has been unlocked'
    end
  end
end

	local function lock_group_all(msg, data, target)
		local msg_type = 'All'
		local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['lock_all']
  if group_all_lock == '🔐' and is_muted(chat_id, msg_type..': yes') then
    return 'all posting is already locked'
  else
    if not is_muted(chat_id, msg_type..': yes') then
		mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_all'] = '🔐'
    save_data(_config.moderation.data, data)
    return 'all posting has been locked'
    end
  end
end

local function unlock_group_all(msg, data, target)
	local chat_id = msg.to.id
	local msg_type = 'All'
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['lock_all']
  if group_all_lock == '🔓' and not is_muted(chat_id, msg_type..': yes') then
    return 'all posting is not locked'
  else
  	if is_muted(chat_id, msg_type..': yes') then
		unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_all'] = '🔓'
    save_data(_config.moderation.data, data)
    return 'all posting has been unlocked'
    end
  end
end

	local function lock_group_gifs(msg, data, target)
		local msg_type = 'Gifs'
		local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_gifs_lock = data[tostring(target)]['settings']['lock_gifs']
  if group_gifs_lock == '🔐' and is_muted(chat_id, msg_type..': yes') then
    return 'gifs posting is already locked'
  else
    if not is_muted(chat_id, msg_type..': yes') then
		mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_gifs'] = '🔐'
    save_data(_config.moderation.data, data)
    return 'gifs posting has been locked'
    end
  end
end

local function unlock_group_gifs(msg, data, target)
	local chat_id = msg.to.id
	local msg_type = 'Gifs'
  if not is_momod(msg) then
    return
  end
  local group_gifs_lock = data[tostring(target)]['settings']['lock_gifs']
  if group_gifs_lock == '🔓' and not is_muted(chat_id, msg_type..': yes') then
    return 'gifs posting is not locked'
  else
  	if is_muted(chat_id, msg_type..': yes') then
		unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_gifs'] = '🔓'
    save_data(_config.moderation.data, data)
    return 'gifs posting has been unlocked'
    end
  end
end

local function lock_group_inline(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_inline_lock = data[tostring(target)]['settings']['lock_inline']
  if group_inline_lock == '🔐' then
    return 'inline posting is already locked'
  else
    data[tostring(target)]['settings']['lock_inline'] = '🔐'
    save_data(_config.moderation.data, data)
    return 'inline posting has been locked'
  end
end

local function unlock_group_inline(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_inline_lock = data[tostring(target)]['settings']['lock_inline']
  if group_inline_lock == '🔓' then
    return 'inline posting is not locked'
  else
    data[tostring(target)]['settings']['lock_inline'] = '🔓'
    save_data(_config.moderation.data, data)
    return 'inline posting has been unlocked'
  end
end

local function lock_group_cmd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_cmd_lock = data[tostring(target)]['settings']['lock_cmd']
  if group_cmd_lock == '🔐' then
    return 'cmd posting is already locked'
  else
    data[tostring(target)]['settings']['lock_cmd'] = '🔐'
    save_data(_config.moderation.data, data)
    return 'cmd posting has been locked'
  end
end

local function unlock_group_cmd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_cmd_lock = data[tostring(target)]['settings']['lock_cmd']
  if group_cmd_lock == '🔓' then
    return 'cmd posting is not locked'
  else
    data[tostring(target)]['settings']['lock_cmd'] = '🔓'
    save_data(_config.moderation.data, data)
    return 'cmd posting has been unlocked'
  end
end

local function is_cmd(jtext)
    if jtext:match("^[/#!](.*)$") then
        return true
    end
    return false
end

    local function isABotBadWay (user)
      local username = user.username or ''
      return username:match("[Bb]ot$")
    end

local function lock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  if not is_owner(msg) then
    return reply_msg(msg.id,"<i>✨*Owners only!✨</i>", ok_cb, false)
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == '🔐' then
    return reply_msg(msg.id,">> <i>✨SuperGroup #spam is #already locked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_spam'] = '🔐'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">> <i>✨SuperGroup #spam has been #locked✨</i>", ok_cb, false)
  end
end

local function unlock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == '🔓' then
    return reply_msg(msg.id,">> <i>✨SuperGroup #spam is #not locked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_spam'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">> <i>✨SuperGroup #spam has been #unlocked✨</i>", ok_cb, false)
  end
end

local function lock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == '🔐' then
    return reply_msg(msg.id,">> <i>✨#Spamming is #already locked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['flood'] = '🔐'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">> <i>✨#Spamming has been #locked✨</i>", ok_cb, false)
  end
end

local function unlock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == '🔓' then
    return reply_msg(msg.id,">> <i>✨#Spamming is #not locked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['flood'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i> ✨#Spamming has been #unlocked✨</i>", ok_cb, false)
  end
end

local function lock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == '🔐' then
    return reply_msg(msg.id,">> <i>✨#Arabic/Persian is #already locked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_arabic'] = '🔐'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i> ✨#Arabic/Persian has been #locked✨</i>", ok_cb, false)
  end
end

local function unlock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == '🔓' then
    return reply_msg(msg.id,">> <i>✨#Arabic/Persian is #already unlocked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_arabic'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#Arabic/Persian has been #unlocked✨</i>", ok_cb, false)
  end
end
-- Tag Fanction by MehdiHS!
local function lock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == '🔐' then
    return reply_msg(msg.id,">><i> ✨#Tag is #already locked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_tag'] = '🔐'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#Tag has been #locked✨</i>", ok_cb, false)
  end
end

local function unlock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == '🔓' then
    return reply_msg(msg.id,">><i>✨#Tag is #already unlocked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_tag'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#Tag has been #unlocked✨</i>", ok_cb, false)
  end
end
-- WebPage Fanction by MehdiHS!
local function lock_group_webpage(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_webpage_lock = data[tostring(target)]['settings']['lock_webpage']
  if group_webpage_lock == '🔐' then
    return reply_msg(msg.id,">> <i>✨#WebLink Posting is #already locked!✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_webpage'] = '🔐'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#WebLink posting has been #locked✨</i>", ok_cb, false)
  end
end

local function unlock_group_webpage(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_webpage_lock = data[tostring(target)]['settings']['lock_webpage']
  if group_webpage_lock == '🔓' then
    return reply_msg(msg.id,">><i>✨#WebLink Posting is #already unlocked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_webpage'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">> <i>✨#WebLink posting has been #unlocked✨</i>", ok_cb, false)
  end
end
-- Anti Fwd Fanction by MehdiHS!
local function lock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['lock_fwd']
  if group_fwd_lock == '🔐' then
    return reply_msg(msg.id,">><i>✨#Forward Msg is #already locked!✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_fwd'] = '🔐'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#Forward Msg has been #locked✨</i>", ok_cb, false)
  end
end

local function unlock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['lock_fwd']
  if group_fwd_lock == '🔓' then
    return reply_msg(msg.id,">><i>✨#Forward Msg is #already unlocked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_fwd'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">> <i>✨#Forward Msg has been #unlocked✨</i>", ok_cb, false)
  end
end
-- lock badword Fanction by MehdiHS!
local function lock_group_badw(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_badw_lock = data[tostring(target)]['settings']['lock_badw']
  if group_badw_lock == '🔐' then
    return reply_msg(msg.id,">><i>✨#Badwords is #already locked!✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_badw'] = '🔐'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">> <i>✨#Badwords Has been #locked!✨</i>", ok_cb, false)
  end
end

local function unlock_group_badw(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_badw_lock = data[tostring(target)]['settings']['lock_badw']
  if group_badw_lock == '🔓' then
    return reply_msg(msg.id,">><i>✨#Badwords is #already unlocked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_badw'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">> <i>✨#Badwords has been #unlocked✨</i>", ok_cb, false)
  end
end
-- lock emoji Fanction by MehdiHS!
local function lock_group_emoji(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_emoji_lock = data[tostring(target)]['settings']['lock_emoji']
  if group_emoji_lock == '🔐' then
    return reply_msg(msg.id,">><i>✨#Emoji is #already locked!✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_emoji'] = '🔐'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">> <i>✨#Emoji Has been #locked!✨</i>", ok_cb, false)
  end
end

local function unlock_group_emoji(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_emoji_lock = data[tostring(target)]['settings']['lock_emoji']
  if group_emoji_lock == '🔓' then
    return reply_msg(msg.id,">><i>✨#Emoji is #already unlocked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_emoji'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#Emoji has been #unlocked✨</i>", ok_cb, false)
  end
end
-- lock English Fanction by MehdiHS!
local function lock_group_eng(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_eng_lock = data[tostring(target)]['settings']['lock_eng']
  if group_eng_lock == '🔐' then
    return reply_msg(msg.id,">> <i>✨#English is #already locked!✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_eng'] = '🔐'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#English Has been #locked!✨</i>", ok_cb, false)
  end
end

local function unlock_group_eng(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_eng_lock = data[tostring(target)]['settings']['lock_eng']
  if group_eng_lock == '🔓' then
    return reply_msg(msg.id,">> <i>✨#English is #already unlocked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_eng'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#English has been #unlocked✨</i>", ok_cb, false)
  end
end
local function unlock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == '🔓' then
    return reply_msg(msg.id,">> <i>✨SuperGroup #members are #not locked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_member'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨SuperGroup #members has been #unlocked✨</i>", ok_cb, false)
  end
end

local function lock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == '🔐' then
    return reply_msg(msg.id,">><i>✨#RTL is #already locked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_rtl'] = '🔐'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#RTL has been #Locked✨</i>", ok_cb, false)
  end
end

local function unlock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == '🔓' then
    return reply_msg(msg.id,">><i>✨#RTL is #already unlocked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_rtl'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#RTL has been #unlocked✨</i>", ok_cb, false)
  end
end

local function lock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == '🔐' then
    return reply_msg(msg.id,">><i>✨#TgService is #already locked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_tgservice'] = '🔐'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#TGservice has been #locked✨</i>", ok_cb, false)
  end
end

local function unlock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == '🔓' then
    return reply_msg(msg.id,">><i> ✨#TgService Is #Not Locked!✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_tgservice'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i> ✨#TGservice has been #unlocked✨</i>", ok_cb, false)
  end
end

local function lock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == '🔐' then
    return reply_msg(msg.id,">> <i>✨#Sticker posting is #already locked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_sticker'] = '🔐'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#Sticker posting has been #locked✨</i>", ok_cb, false)
  end
end

local function unlock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == '🔓' then
    return reply_msg(msg.id,">><i>✨#Sticker posting is #already unlocked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_sticker'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#Sticker posting has been #unlocked✨</i>", ok_cb, false)
  end
end

local function lock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == '🔐' then
    return reply_msg(msg.id,">><i>✨#Contact posting is #already locked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_contacts'] = '🔐'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#Contact posting has been #locked✨</i>", ok_cb, false)
  end
end

local function unlock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == '🔓' then
    return reply_msg(msg.id,">> <i>✨#Contact posting is #already unlocked✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_contacts'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#Contact posting has been #unlocked✨</i>", ok_cb, false)
  end
end

local function enable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == '🔐' then
    return reply_msg(msg.id,">><i>✨#Settings are #already strictly enforced✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['strict'] = '🔐'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#Settings will be #strictly_enforced✨</i>", ok_cb, false)
  end
end

local function disable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == '🔓' then
    return reply_msg(msg.id,">><i>✨#Settings are #not strictly enforced✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['strict'] = '🔓'
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,">><i>✨#Settings will #not be strictly enforced✨</i>", ok_cb, false)
  end
end
--End supergroup locks

--'Set supergroup rules' function
local function set_rulesmod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local data_cat = 'rules'
  data[tostring(target)][data_cat] = rules
  save_data(_config.moderation.data, data)
  return reply_msg(msg.id,"<i>✨*SuperGroup rules set✨</i>", ok_cb, false)
end

--'Get supergroup rules' function
local function get_rules(msg, data)
  local data_cat = 'rules'
  if not data[tostring(msg.to.id)][data_cat] then
    return reply_msg(msg.id,"<i>✨*No rules available.✨</i>", ok_cb, false)
  end
  local rules = data[tostring(msg.to.id)][data_cat]
  local group_name = data[tostring(msg.to.id)]['settings']['set_name']
  local rules = group_name..' <i>✨Rules✨:\n\n</i>'..rules:gsub("/n", " ")
  return rules
end

--Set supergroup to public or not public function
local function set_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return reply_msg(msg.id,"<i>✨*For moderators only!✨</i>", ok_cb, false)
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == '🔐' then
    return reply_msg(msg.id,"<i>✨*Group is already public✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['public'] = '🔐'
    save_data(_config.moderation.data, data)
  end
  return reply_msg(msg.id,"<i>✨*SuperGroup is now: #Public✨</i>", ok_cb, false)
end

local function unset_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == '🔓' then
    return reply_msg(msg.id,"<i>✨*Group is not public✨</i>", ok_cb, false)
  else
    data[tostring(target)]['settings']['public'] = '🔓'
	data[tostring(target)]['long_id'] = msg.to.long_id
    save_data(_config.moderation.data, data)
    return reply_msg(msg.id,"<i>✨*SuperGroup is now: not public✨</i>",ok_cb,false)
  end
end

--Show supergroup settings; function
function show_supergroup_settingsmod(msg, target)
 	if not is_momod(msg) then
    	return
  	end
	local data = load_data(_config.moderation.data)
    if data[tostring(target)] then
     	if data[tostring(target)]['settings']['flood_msg_max'] then
        	NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['flood_msg_max'])
        	print('custom'..NUM_MSG_MAX)
      	else
        	NUM_MSG_MAX = 5
      	end
    end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['public'] then
			data[tostring(target)]['settings']['public'] = '🔓'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_tag'] then
			data[tostring(target)]['settings']['lock_tag'] = '🔓'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_rtl'] then
			data[tostring(target)]['settings']['lock_rtl'] = '🔓'
		end
end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_webpage'] then
			data[tostring(target)]['settings']['lock_webpage'] = '🔐'
		end
end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_emoji'] then
			data[tostring(target)]['settings']['lock_emoji'] = '🔓'
		end
end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_eng'] then
			data[tostring(target)]['settings']['lock_eng'] = '🔓'
		end
end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_badw'] then
			data[tostring(target)]['settings']['lock_badw'] = '🔐'
		end
end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_photo'] then
			data[tostring(target)]['settings']['lock_photo'] = '🔓'
		end
end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_gif'] then
			data[tostring(target)]['settings']['lock_gif'] = '🔓'
		end
end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_video'] then
			data[tostring(target)]['settings']['lock_video'] = '🔓'
		end
end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_document'] then
			data[tostring(target)]['settings']['lock_document'] = '🔓'
		end
end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_audio'] then
			data[tostring(target)]['settings']['lock_audio'] = '🔓'
		end
end
      if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_tgservice'] then
			data[tostring(target)]['settings']['lock_tgservice'] = '🔓'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_member'] then
			data[tostring(target)]['settings']['lock_member'] = '🔓'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_fwd'] then
			data[tostring(target)]['settings']['lock_fwd'] = '🔓'
		end
	end
						if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_media'] then
			data[tostring(target)]['settings']['lock_media'] = '🔓'
		end
	end
		if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_share'] then
			data[tostring(target)]['settings']['lock_share'] = '🔓'
		end
	end
		if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_bots'] then
			data[tostring(target)]['settings']['lock_bots'] = '🔐'
		end
	end
		if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_number'] then
			data[tostring(target)]['settings']['lock_number'] = '🔓'
		end
	end
		if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_poker'] then
			data[tostring(target)]['settings']['lock_poker'] = '🔓'
		end
	end
		if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_audio'] then
			data[tostring(target)]['settings']['lock_audio'] = '🔓'
		end
	end
		if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_photo'] then
			data[tostring(target)]['settings']['lock_photo'] = '🔓'
		end
	end	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_video'] then
			data[tostring(target)]['settings']['lock_video'] = '🔓'
		end
	end	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_documents'] then
			data[tostring(target)]['settings']['lock_documents'] = '🔓'
		end
	end	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_text'] then
			data[tostring(target)]['settings']['lock_text'] = '🔓'
		end
	end	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_all'] then
			data[tostring(target)]['settings']['lock_all'] = '🔓'
		end
	end
		if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_gifs'] then
			data[tostring(target)]['settings']['lock_gifs'] = '🔓'
		end
	end
			if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_inline'] then
			data[tostring(target)]['settings']['lock_inline'] = '🔓'
		end
	end
			if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_cmd'] then
			data[tostring(target)]['settings']['lock_cmd'] = '🔓'
		end
	end
  local settings = data[tostring(target)]['settings']
local text = "<i>✨تنظیمات سوپر گروه✨</i>:\n➖➖➖➖➖➖➖➖\n\n<i>وایت ولف 8\n«قفل لینک»» "..settings.lock_link.."\n«قفل وب لینک»» "..settings.lock_webpage.."\n«قفل تگ»» "..settings.lock_tag.."\n«قفل شکلک»» "..settings.lock_emoji.."\n«قفل انگلیسی»» "..settings.lock_eng.."\n«قفل کلمات زشت»» "..settings.lock_badw.."\n«قفل حساسیت»» "..settings.flood.."\n«مقدار حساسیت»» 🔅"..NUM_MSG_MAX.."🔅\n«قفل اسپم»» "..settings.lock_spam.."\n«قفل مخاطب»» "..settings.lock_contacts.."\n«قفل فارسی»» "..settings.lock_arabic.."\n«قفل اعضا»» "..settings.lock_member.."\n«قفل راستچین»» "..settings.lock_rtl.."\n«قفل فروارد»» "..settings.lock_fwd.."\n«قفل اعلان»» "..settings.lock_tgservice.."\n«قفل استیکر»» "..settings.lock_sticker.."\n«قفل رسانه»» "..settings.lock_media.."\n«قفل ربات ها»» "..settings.lock_bots.."\n«قفل اشتراک گذاری»»"..settings.lock_share.."\n«قفل شماره»»"..settings.lock_number.."\n«قفل پوکر»» "..settings.lock_poker.."\n«قفل صدا»» "..settings.lock_audio.."\n«قفل عکس»» "..settings.lock_photo.."\n«قفل فیلم»» "..settings.lock_video.."\n«قفل فایل»» "..settings.lock_documents.."\n«قفل متن»» "..settings.lock_text.."\n«قفل همه»» "..settings.lock_all.."\n«قفل گیف»» "..settings.lock_gifs.."\n«قفل لینک شیشه ای(اینلاین)»» "..settings.lock_inline.."\n«قفل دستورات(cmd)»» "..settings.lock_cmd.."\n«عمومی»» "..settings.public.."\n«قفل سختگیرانه»» "..settings.strict.."</i>\n\n➖➖➖➖➖➖➖➖➖\n✨<i>✨</i>"	
  reply_msg(msg.id, text, ok_cb, false)
end

local function promote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  if not data[group] then
    return
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..' <i>is already a ✨moderator✨.</i>')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
end

local function demote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_tag_username..' <i>is not a ✨moderator✨.</i>')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
end

local function promote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  if not data[group] then
    return send_large_msg(receiver, '<i>✨SuperGroup is not added✨.</i>')
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..' <i>is already a ✨moderator✨.</i>')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username..' <i>has been ✨promoted✨.</i>')
end

local function demote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return send_large_msg(receiver, '<i>✨Group is not added✨.</i>')
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_tag_username..'<i> is not a ✨moderator✨.</i>')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username..' <i>has been ✨demoted✨.</i>')
end

local function modlist(msg)
  local data = load_data(_config.moderation.data)
  local groups = "groups"
  if not data[tostring(groups)][tostring(msg.to.id)] then
    return '<i>✨*SuperGroup is not added.✨</i>'
  end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['moderators']) == nil then
    return '<i>✨*No moderator in this group.✨</i>'
  end
  local i = 1
  local message = '<i>\n✨List of moderators for </i>' .. string.gsub(msg.to.print_name, '_', ' ') .. '✨:\n> '
  for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
    message = message ..i..' - '..v..' [' ..k.. '] \n'
    i = i + 1
  end
  return message
end

-- Start by reply actions
function get_message_callback(extra, success, result)
	local get_cmd = extra.get_cmd
	local msg = extra.msg
	local data = load_data(_config.moderation.data)
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
    if get_cmd == "id" and not result.action then
		local channel = 'channel#id'..result.to.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id for: ["..result.from.peer_id.."]")
		id1 = send_large_msg(channel, result.from.peer_id)
	elseif get_cmd == 'id' and result.action then
		local action = result.action.type
		if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
			if result.action.user then
				user_id = result.action.user.peer_id
			else
				user_id = result.peer_id
			end
			local channel = 'channel#id'..result.to.peer_id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id by service msg for: ["..user_id.."]")
			id1 = send_large_msg(channel, user_id)
		end
    elseif get_cmd == "idfrom" then
		local channel = 'channel#id'..result.to.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id for msg fwd from: ["..result.fwd_from.peer_id.."]")
		id2 = send_large_msg(channel, result.fwd_from.peer_id)
    elseif get_cmd == 'channel_block' and not result.action then
		local member_id = result.from.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "<i>✨Leave using kickme command✨</i>")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "<i>✨You can't kick mods/owner/admins✨</i>")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "<i>✨You can't kick other admins✨</i>")
    end
		--savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..user_id.."] by reply")
		kick_user(member_id, channel_id)
	elseif get_cmd == 'channel_block' and result.action and result.action.type == 'chat_add_user' then
		local user_id = result.action.user.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "<i>✨Leave using kickme command✨</i>")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "<i>✨You can't kick mods/owner/admins✨</i>")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "<i>✨You can't kick other admins✨</i>")
    end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..user_id.."] by reply to sev. msg.")
		kick_user(user_id, channel_id)
	elseif get_cmd == "del" then
		delete_msg(result.id, ok_cb, false)
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] deleted a message by reply")
	elseif get_cmd == "setadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		channel_set_admin(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = "✨<i> @"..result.from.username.." set as an admin✨</i>"
		else
			text = "<i>✨[ "..user_id.." ]set as an admin✨</i>"
		end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] set: ["..user_id.."] as admin by reply")
		send_large_msg(channel_id, text)
	elseif get_cmd == "demoteadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		if is_admin2(result.from.peer_id) then
			return send_large_msg(channel_id, "<i>✨You can't demote global admins!✨</i>")
		end
		channel_demote(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = "<i>✨ @"..result.from.username.." has been demoted from admin✨</i>"
		else
			text = "<i>✨[ "..user_id.." ] has been demoted from admin✨</i>"
		end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted: ["..user_id.."] from admin by reply")
		send_large_msg(channel_id, text)
	elseif get_cmd == "setowner" then
		local group_owner = data[tostring(result.to.peer_id)]['set_owner']
		if group_owner then
		local channel_id = 'channel#id'..result.to.peer_id
			if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
				local user = "user#id"..group_owner
				channel_demote(channel_id, user, ok_cb, false)
			end
			local user_id = "user#id"..result.from.peer_id
			channel_set_admin(channel_id, user_id, ok_cb, false)
			data[tostring(result.to.peer_id)]['set_owner'] = tostring(result.from.peer_id)
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set: ["..result.from.peer_id.."] as owner by reply")
			if result.from.username then
				text = "<i>✨ @"..result.from.username.." [ "..result.from.peer_id.." ] added as owner✨</i>"
			else
				text = "<i>✨[ "..result.from.peer_id.." ] added as owner</i>"
			end
			send_large_msg(channel_id, text)
		end
	elseif get_cmd == "promote" then
		local receiver = result.to.peer_id
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
		if result.from.username then
			member_username = '@'.. result.from.username
		end
		local member_id = result.from.peer_id
		if result.to.peer_type == 'channel' then
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted mod: @"..member_username.."["..result.from.peer_id.."] by reply")
		promote2("channel#id"..result.to.peer_id, member_username, member_id)
	    --channel_set_mod(channel_id, user, ok_cb, false)
		end
	elseif get_cmd == "demote" then
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
    if result.from.username then
		member_username = '@'.. result.from.username
    end
		local member_id = result.from.peer_id
		--local user = "user#id"..result.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted mod: @"..member_username.."["..user_id.."] by reply")
		demote2("channel#id"..result.to.peer_id, member_username, member_id)
		--channel_demote(channel_id, user, ok_cb, false)
	elseif get_cmd == 'mute_user' then
		if result.service then
			local action = result.action.type
			if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
				if result.action.user then
					user_id = result.action.user.peer_id
				end
			end
			if action == 'chat_add_user_link' then
				if result.from then
					user_id = result.from.peer_id
				end
			end
		else
			user_id = result.from.peer_id
		end
		local receiver = extra.receiver
		local chat_id = msg.to.id
		print(user_id)
		print(chat_id)
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "<i>✨["..user_id.."] removed from the muted user list✨</i>")
		elseif is_admin1(msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, "<i>✨ ["..user_id.."] added to the muted user list✨</i>")
		end
	end
end
-- End by reply actions

--By ID actions
local function cb_user_info(extra, success, result)
	local receiver = extra.receiver
	local user_id = result.peer_id
	local get_cmd = extra.get_cmd
	local data = load_data(_config.moderation.data)
	--[[if get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		channel_set_admin(receiver, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been set as an admin"
		else
			text = "[ "..result.peer_id.." ] has been set as an admin"
		end
			send_large_msg(receiver, text)]]
	if get_cmd == "demoteadmin" then
		if is_admin2(result.peer_id) then
			return send_large_msg(receiver, "<i>✨You can't demote global admins!✨</i>")
		end
		local user_id = "user#id"..result.peer_id
		channel_demote(receiver, user_id, ok_cb, false)
		if result.username then
			text = "<i>✨ @"..result.username.." has been demoted from admin✨</i>"
			send_large_msg(receiver, text)
		else
			text = "<i>✨[ "..result.peer_id.." ] has been demoted from admin✨</i>"
			send_large_msg(receiver, text)
		end
	elseif get_cmd == "promote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		promote2(receiver, member_username, user_id)
	elseif get_cmd == "demote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		demote2(receiver, member_username, user_id)
	end
end

-- Begin resolve username actions
local function callbackres(extra, success, result)
  local member_id = result.peer_id
  local member_username = "@"..result.username
  local get_cmd = extra.get_cmd
	if get_cmd == "res" then
		local user = result.peer_id
		local name = string.gsub(result.print_name, "_", " ")
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user..'\n'..name)
		return user
	elseif get_cmd == "id" then
		local user = result.peer_id
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user)
		return user
  elseif get_cmd == "invite" then
    local receiver = extra.channel
    local user_id = "user#id"..result.peer_id
    channel_invite(receiver, user_id, ok_cb, false)
	--elseif get_cmd == "channel_block" then
		local user_id = result.peer_id
		local channel_id = extra.channelid
    local sender = extra.sender
    if member_id == sender then
      return send_large_msg("channel#id"..channel_id, "<i>✨Leave using kickme command✨</i>")
    end
		if is_momod2(member_id, channel_id) and not is_admin2(sender) then
			   return send_large_msg("channel#id"..channel_id, "<i>✨You can't kick mods/owner/admins✨</i>")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "<i>✨You can't kick other admins✨</i>")
    end
		kick_user(user_id, channel_id)
	elseif get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		channel_set_admin(channel_id, user_id, ok_cb, false)
	    if result.username then
			text = "<i>✨ @"..result.username.." has been set as an admin✨</i>"
			send_large_msg(channel_id, text)
		else
			text = "<i>✨ @"..result.peer_id.." has been set as an admin✨</i>"
			send_large_msg(channel_id, text)
		end
	elseif get_cmd == "setowner" then
		local receiver = extra.channel
		local channel = string.gsub(receiver, 'channel#id', '')
		local from_id = extra.from_id
		local group_owner = data[tostring(channel)]['set_owner']
		if group_owner then
			local user = "user#id"..group_owner
			if not is_admin2(group_owner) and not is_support(group_owner) then
				channel_demote(receiver, user, ok_cb, false)
			end
			local user_id = "user#id"..result.peer_id
			channel_set_admin(receiver, user_id, ok_cb, false)
			data[tostring(channel)]['set_owner'] = tostring(result.peer_id)
			save_data(_config.moderation.data, data)
			savelog(channel, name_log.." ["..from_id.."] set ["..result.peer_id.."] as owner by username")
		if result.username then
			text = member_username.."><i>✨ [ "..result.peer_id.." ] added as owner✨</i>"
		else
			text = "><i>✨[ "..result.peer_id.." ] added as owner✨</i>"
		end
		send_large_msg(receiver, text)
  end
	elseif get_cmd == "promote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		--local user = "user#id"..result.peer_id
		promote2(receiver, member_username, user_id)
		--channel_set_mod(receiver, user, ok_cb, false)
	elseif get_cmd == "demote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		local user = "user#id"..result.peer_id
		demote2(receiver, member_username, user_id)
	elseif get_cmd == "demoteadmin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		if is_admin2(result.peer_id) then
			return send_large_msg(channel_id, "<i>✨You can't demote global admins!✨</i>")
		end
		channel_demote(channel_id, user_id, ok_cb, false)
		if result.username then
			text = "<i>✨ @"..result.username.." has been demoted from admin✨</i>"
			send_large_msg(channel_id, text)
		else
			text = "<i>✨ @"..result.peer_id.." has been demoted from admin✨</i>"
			send_large_msg(channel_id, text)
		end
		local receiver = extra.channel
		local user_id = result.peer_id
		demote_admin(receiver, member_username, user_id)
	elseif get_cmd == 'mute_user' then
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "<i>✨ ["..user_id.."] removed from muted user list✨</i>")
		elseif is_owner(extra.msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, "<i>✨ ["..user_id.."] added to muted user list✨</i>")
		end
	end
end
--End resolve username actions

--Begin non-channel_invite username actions
local function in_channel_cb(cb_extra, success, result)
  local get_cmd = cb_extra.get_cmd
  local receiver = cb_extra.receiver
  local msg = cb_extra.msg
  local data = load_data(_config.moderation.data)
  local print_name = user_print_name(cb_extra.msg.from):gsub("‮", "")
  local name_log = print_name:gsub("_", " ")
  local member = cb_extra.username
  local memberid = cb_extra.user_id
  if member then
    text = '<i>✨*No user @'..member..' in this SuperGroup.✨</i>'
  else
    text = '<i>✨*No user ['..memberid..'] in this SuperGroup.✨</i>'
  end
if get_cmd == "channel_block" then
  for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
     local user_id = v.peer_id
     local channel_id = cb_extra.msg.to.id
     local sender = cb_extra.msg.from.id
      if user_id == sender then
        return send_large_msg("channel#id"..channel_id, "<i>✨Leave using kickme command✨</i>")
      end
      if is_momod2(user_id, channel_id) and not is_admin2(sender) then
        return send_large_msg("channel#id"..channel_id, "<i>✨You can't kick mods/owner/admins✨</i>")
      end
      if is_admin2(user_id) then
        return send_large_msg("channel#id"..channel_id, "<i>✨You can't kick other admins✨</i>")
      end
      if v.username then
        text = ""
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: @"..v.username.." ["..v.peer_id.."]")
      else
        text = ""
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..v.peer_id.."]")
      end
      kick_user(user_id, channel_id)
      return
    end
  end
elseif get_cmd == "setadmin" then
   for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
      local user_id = "user#id"..v.peer_id
      local channel_id = "channel#id"..cb_extra.msg.to.id
      channel_set_admin(channel_id, user_id, ok_cb, false)
      if v.username then
        text = "<i>✨ @"..v.username.." ["..v.peer_id.."] has been set as an admin✨</i>"
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin @"..v.username.." ["..v.peer_id.."]")
      else
        text = "><i>✨ ["..v.peer_id.."] has been set as an admin✨</i>"
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin "..v.peer_id)
      end
	  if v.username then
		member_username = "@"..v.username
	  else
		member_username = string.gsub(v.print_name, '_', ' ')
	  end
		local receiver = channel_id
		local user_id = v.peer_id
		promote_admin(receiver, member_username, user_id)

    end
    send_large_msg(channel_id, text)
    return
 end
 elseif get_cmd == 'setowner' then
	for k,v in pairs(result) do
		vusername = v.username
		vpeer_id = tostring(v.peer_id)
		if vusername == member or vpeer_id == memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
					local user_id = "user#id"..v.peer_id
					channel_set_admin(receiver, user_id, ok_cb, false)
					data[tostring(channel)]['set_owner'] = tostring(v.peer_id)
					save_data(_config.moderation.data, data)
					savelog(channel, name_log.."["..from_id.."] set ["..v.peer_id.."] as owner by username")
				if result.username then
					text = member_username.."<i>✨ ["..v.peer_id.."] added as owner✨</i>"
				else
					text = "><i>✨ ["..v.peer_id.."] added as owner✨</i>"
				end
			end
		elseif memberid and vusername ~= member and vpeer_id ~= memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
				data[tostring(channel)]['set_owner'] = tostring(memberid)
				save_data(_config.moderation.data, data)
				savelog(channel, name_log.."["..from_id.."] set ["..memberid.."] as owner by username")
				text = "><i>✨ ["..memberid.."] added as owner✨</i>"
			end
		end
	end
 end
send_large_msg(receiver, text)
end
--End non-channel_invite username actions

--'Set supergroup photo' function
local function set_supergroup_photo(msg, success, result)
  local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)] then
      return
  end
  local receiver = get_receiver(msg)
  if success then
    local file = 'data/photos/channel_photo_'..msg.to.id..'.jpg'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    channel_set_photo(receiver, file, ok_cb, false)
    data[tostring(msg.to.id)]['settings']['set_photo'] = file
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, '<i>✨Photo saved✨!</i>', ok_cb, false)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, '<i>✨*Failed, please try again!✨</i>', ok_cb, false)
  end
end

--Run function
local function run(msg, matches)
	if msg.to.type == 'chat' then
		if matches[1] == 'upchat' then
			if not is_admin1(msg) then
				return
			end
			local receiver = get_receiver(msg)
			chat_upgrade(receiver, ok_cb, false)
		end
	elseif msg.to.type == 'channel'then
		if matches[1] == 'upchat' then
			if not is_admin1(msg) then
				return
			end
			return "<i>✨Already a SuperGroup✨</i>"
		end
	end
	if msg.to.type == 'channel' then
	local support_id = msg.from.id
	local receiver = get_receiver(msg)
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
	local data = load_data(_config.moderation.data)
		if matches[1] == 'add' and not matches[2] then
			if not is_admin1(msg) and not is_support(support_id) then
				return
			end
			if is_super_group(msg) then
				return reply_msg(msg.id, '<i>✨SuperGroup is already added.✨</i>', ok_cb, false)
			end
			print("<i>✨SuperGroup "..msg.to.print_name.."("..msg.to.id..") added✨</i>")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] added SuperGroup")
			superadd(msg)
			set_mutes(msg.to.id)
			channel_set_admin(receiver, 'user#id'..msg.from.id, ok_cb, false)
		end

		if matches[1] == 'rem' and is_admin1(msg) and not matches[2] then
			if not is_super_group(msg) then
				return reply_msg(msg.id, '<i>✨SuperGroup is not added.✨</i>', ok_cb, false)
			end
			print("<i>✨SuperGroup "..msg.to.print_name.."("..msg.to.id..") removed✨</i>")
			superrem(msg)
			rem_mutes(msg.to.id)
		end

		if not data[tostring(msg.to.id)] then
			return
		end
		if matches[1] == "info" then
			if not is_owner(msg) then
				return
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup info")
			channel_info(receiver, callback_info, {receiver = receiver, msg = msg})
		end

		if matches[1] == "admins" then
			if not is_owner(msg) and not is_support(msg.from.id) then
				return
			end
			member_type = 'Admins'
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup Admins list")
			admins = channel_get_admins(receiver,callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1] == "owner" then
			local group_owner = data[tostring(msg.to.id)]['set_owner']
			if not group_owner then
				return "<i>✨*no owner,ask admins in support groups to set owner for your SuperGroup✨</i>"
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] used /owner")
			return "<i>✨SuperGroup owner✨</i> is >> ["..group_owner..']'
		end

		if matches[1] == "modlist" then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group modlist")
			return modlist(msg)
			-- channel_get_admins(receiver,callback, {receiver = receiver})
		end

		if matches[1] == "bots" and is_momod(msg) then
			member_type = 'Bots'
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup bots list")
			channel_get_bots(receiver, callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1] == "who" and not matches[2] and is_momod(msg) then
			local user_id = msg.from.peer_id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup users list")
			channel_get_users(receiver, callback_who, {receiver = receiver})
		end

		if matches[1] == "kicked" and is_momod(msg) then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested Kicked users list")
			channel_get_kicked(receiver, callback_kicked, {receiver = receiver})
		end

		if matches[1] == 'del' and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'del',
					msg = msg
				}
				delete_msg(msg.id, ok_cb, false)
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			end
		end

		if matches[1] == 'kick' and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'channel_block',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'kick' and string.match(matches[2], '^%d+$') then
				local user_id = matches[2]
				local channel_id = msg.to.id
				if is_momod2(user_id, channel_id) and not is_admin2(user_id) then
					return send_large_msg(receiver, "<i>✨You can't kick mods/owner/admins✨</i>")
				end
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: [ user#id"..user_id.." ]")
				kick_user(user_id, channel_id)
				local	get_cmd = 'channel_block'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif msg.text:match("@[%a%d]") then
			local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'channel_block',
					sender = msg.from.id
				}
			    local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: @"..username)
				resolve_username(username, callbackres, cbres_extra)
			local get_cmd = 'channel_block'
			local msg = msg
			local username = matches[2]
			local username = string.gsub(matches[2], '@', '')
			channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'id' then
			if type(msg.reply_id) ~= "nil" and is_momod(msg) and not matches[2] then
				local cbreply_extra = {
					get_cmd = 'id',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif type(msg.reply_id) ~= "nil" and matches[2] == "from" and is_momod(msg) then
				local cbreply_extra = {
					get_cmd = 'idfrom',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif msg.text:match("@[%a%d]") then
				local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'id'
				}
				local username = matches[2]
				local username = username:gsub("@","")
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested ID for: @"..username)
				resolve_username(username,  callbackres, cbres_extra)
			else
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup ID")
				return reply_msg(msg.id, "<i> «✨ُSuperGroup ID»: </i><b>"..msg.to.id.."</b>\n<i> «🔰SuperGroup Name»: "..msg.to.title.."</i>\n<i> «🔹First Name»: "..(msg.from.first_name or '').."</i>\n<i> «🔸Last Name»: "..(msg.from.last_name or '').."</i>\n <i>«🚩Your ID»:</i><b> "..msg.from.id.." </b>\n <i>«🔆Your UserName»: @"..(msg.from.username or '').."</i>\n <i>«📞Phone Number»:</i><b> +"..(msg.from.phone or '').." </b>\n <i>«💭Your Link»: Telegram.Me/"..(msg.from.username or '').."</i>\n <i>«📝Group Type»:</i><b> #SuperGroup</b>\n <i>«buy this bot: @white_wolf_ch</i>", ok_cb, false)		end
		end

		if matches[1] == 'kickme' then
			if msg.to.type == 'channel' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] left via kickme")
				channel_kick("channel#id"..msg.to.id, "user#id"..msg.from.id, ok_cb, false)
			end
		end

		if matches[1] == 'newlink' and is_momod(msg)then
			local function callback_link (extra , success, result)
			local receiver = get_receiver(msg)
				if success == 0 then
					send_large_msg(receiver, '✨*Error✨ \n✨Reason: Not creator✨ \n ✨please use /setlink to set it💠')
					data[tostring(msg.to.id)]['settings']['set_link'] = nil
					save_data(_config.moderation.data, data)
				else
					send_large_msg(receiver, "Created a new link")
					data[tostring(msg.to.id)]['settings']['set_link'] = result
					save_data(_config.moderation.data, data)
				end
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] attempted to create a new SuperGroup link")
			export_channel_link(receiver, callback_link, false)
		end

		if matches[1] == 'setlink' and is_owner(msg) then
			data[tostring(msg.to.id)]['settings']['set_link'] = 'waiting'
			save_data(_config.moderation.data, data)
			return '<i>✨Please send the new group link now!✨</i>'
		end

		if msg.text then
			if msg.text:match("^(https://telegram.me/joinchat/%S+)$") and data[tostring(msg.to.id)]['settings']['set_link'] == 'waiting' and is_owner(msg) then				data[tostring(msg.to.id)]['settings']['set_link'] = msg.text
				data[tostring(msg.to.id)]['settings']['set_link'] = msg.text
				save_data(_config.moderation.data, data)
				return "<i>✨New link set !✨</i>"
			end
		end

		if matches[1] == 'link' then
			if not is_momod(msg) then
				return
			end
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if not group_link then
				return ">> ✨Create a link using /newlink first!✨\n\n✨Or if I am not creator use /setlink to set your link✨"
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group link ["..group_link.."]")
			return "<i>✨SuperGroup link✨:\n></i> "..group_link
		end

		if matches[1] == "invite" and is_sudo(msg) then
			local cbres_extra = {
				channel = get_receiver(msg),
				get_cmd = "invite"
			}
			local username = matches[2]
			local username = username:gsub("@","")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] invited @"..username)
			resolve_username(username,  callbackres, cbres_extra)
		end

		if matches[1] == 'res' and is_owner(msg) then
			local cbres_extra = {
				channelid = msg.to.id,
				get_cmd = 'res'
			}
			local username = matches[2]
			local username = username:gsub("@","")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] resolved username: @"..username)
			resolve_username(username,  callbackres, cbres_extra)
		end

		if matches[1] == 'kick' and is_momod(msg) then
			local receiver = channel..matches[3]
			local user = "user#id"..matches[2]
			chaannel_kick(receiver, user, ok_cb, false)
		end

			if matches[1] == 'setadmin' then
				if not is_support(msg.from.id) and not is_owner(msg) then
					return
				end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setadmin',
					msg = msg
				}
				setadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'setadmin' and string.match(matches[2], '^%d+$') then
			--[[]	local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'setadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})]]
				local	get_cmd = 'setadmin'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1] == 'setadmin' and not string.match(matches[2], '^%d+$') then
				--[[local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'setadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin @"..username)
				resolve_username(username, callbackres, cbres_extra)]]
				local	get_cmd = 'setadmin'
				local	msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'demoteadmin' then
			if not is_support(msg.from.id) and not is_owner(msg) then
				return
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demoteadmin',
					msg = msg
				}
				demoteadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'demoteadmin' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demoteadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'demoteadmin' and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demoteadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted admin @"..username)
				resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == 'setowner' and is_owner(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setowner',
					msg = msg
				}
				setowner = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'setowner' and string.match(matches[2], '^%d+$') then
			local group_owner = data[tostring(msg.to.id)]['set_owner']
				if group_owner then
					local receiver = get_receiver(msg)
					local user_id = "user#id"..group_owner
					if not is_admin2(group_owner) and not is_support(group_owner) then
						channel_demote(receiver, user_id, ok_cb, false)
					end
					local user = "user#id"..matches[2]
					channel_set_admin(receiver, user, ok_cb, false)
					data[tostring(msg.to.id)]['set_owner'] = tostring(matches[2])
					save_data(_config.moderation.data, data)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set ["..matches[2].."] as owner")
					local text = "<i>✨ [ "..matches[2].." ] added as owner✨</i>"
					return text
				end
				local	get_cmd = 'setowner'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1] == 'setowner' and not string.match(matches[2], '^%d+$') then
				local	get_cmd = 'setowner'
				local	msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'promote' then
		  if not is_momod(msg) then
				return
			end
			if not is_owner(msg) then
				return reply_msg(msg.id,"<i>✨*Error✨ \n✨Only owner/admin can promote✨</i>",ok_cb,false)
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'promote',
					msg = msg
				}
				promote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'promote' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'promote'
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'promote' and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'promote',
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted @"..username)
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == 'mp' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_set_mod(channel, user_id, ok_cb, false)
			return "<i>✨Done✨</i>"
		end
		if matches[1] == 'md' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_demote(channel, user_id, ok_cb, false)
			return "<i>✨Done✨</i>"
		end

		if matches[1] == 'demote' then
			if not is_momod(msg) then
				return
			end
			if not is_owner(msg) then
				return reply_msg(msg.id,"<i>✨*Error✨ \n✨Only owner/support/admin can promote✨</i>",ok_cb,false)
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demote',
					msg = msg
				}
				demote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'demote' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demote'
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demote'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted @"..username)
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == "setname" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local set_name = string.gsub(matches[2], '_', '')
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] renamed SuperGroup to: "..matches[2])
			rename_channel(receiver, set_name, ok_cb, false)
		end

		if msg.service and msg.action.type == 'chat_rename' then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] renamed SuperGroup to: "..msg.to.title)
			data[tostring(msg.to.id)]['settings']['set_name'] = msg.to.title
			save_data(_config.moderation.data, data)
		end

		if matches[1] == "setabout" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local about_text = matches[2]
			local data_cat = 'description'
			local target = msg.to.id
			data[tostring(target)][data_cat] = about_text
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup description to: "..about_text)
			channel_set_about(receiver, about_text, ok_cb, false)
			return "<i>✨Description has been set.✨\n\n✨Select the chat again to see the changes.✨</i>"
		end

		if matches[1] == "setusername" and is_admin1(msg) then
			local function ok_username_cb (extra, success, result)
				local receiver = extra.receiver
				if success == 1 then
					send_large_msg(receiver, "<i>✨SuperGroup username Set.✨\n\n✨Select the chat again to see the changes.✨</i>")
				elseif success == 0 then
					send_large_msg(receiver, "<i>✨Failed to set SuperGroup username.✨\n✨Username may already be taken✨.\n\n✨Note: Username can use a-z, 0-9 and underscores.✨\n✨Minimum length is 5 characters.✨</i>")
				end
			end
			local username = string.gsub(matches[2], '@', '')
			channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
		end

		if matches[1] == 'setrules' and is_momod(msg) then
			rules = matches[2]
			local target = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] has changed group rules to ["..matches[2].."]")
			return set_rulesmod(msg, data, target)
		end

		if msg.media then
			if msg.media.type == 'photo' and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_momod(msg) then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set new SuperGroup photo")
				load_photo(msg.id, set_supergroup_photo, msg)
				return
			end
		end
		if matches[1] == 'setphoto' and is_momod(msg) then
			data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] started setting new SuperGroup photo")
			return '>><i>✨Please send the new group photo now!✨</i>'
		end

		if matches[1] == 'clean' then
			if not is_momod(msg) then
				return
			end
			if not is_momod(msg) then
				return reply_msg(msg.id,"<i>✨Only owner can clean✨</i>", ok_cb,false)
			end
			if matches[2] == 'modlist' then
				if next(data[tostring(msg.to.id)]['moderators']) == nil then
					return reply_msg(msg.id,"<i>✨No moderator(s) in this SuperGroup!✨</i>", ok_cb,false)
				end
				for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
					data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned modlist")
				return reply_msg(msg.id,"<i>✨Modlist has been cleaned!✨</i>", ok_cb,false)
			end
			if matches[2] == 'banlist' and is_owner(msg) then
		    local chat_id = msg.to.id
            local hash = 'banned:'..chat_id
            local data_cat = 'banlist'
            data[tostring(msg.to.id)][data_cat] = nil
            save_data(_config.moderation.data, data)
            redis:del(hash)
			return reply_msg(msg.id,"<i>✨Banlist have been Cleaned.✨</i>",ok_cb, false)
			end
			if matches[2] == 'rules' then
				local data_cat = 'rules'
				if data[tostring(msg.to.id)][data_cat] == nil then
					return reply_msg(msg.id,"<i>✨Rules have not been set✨</i>", ok_cb,false)
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned rules")
				return reply_msg(msg.id,"<i>✨Rules have been cleaned✨</i>", ok_cb,false)
			end
			if matches[2] == 'about' then
				local receiver = get_receiver(msg)
				local about_text = ' '
				local data_cat = 'description'
				if data[tostring(msg.to.id)][data_cat] == nil then
					return reply_msg(msg.id,"<i>✨About is not set✨</i>", ok_cb,false)
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned about")
				channel_set_about(receiver, about_text, ok_cb, false)
				return reply_msg(msg.id,"<i>✨About has been Cleaned✨", ok_cb,false)
			end
			if matches[2] == 'mutelist' then
				chat_id = msg.to.id
				local hash =  'mute_user:'..chat_id
					redis:del(hash)
				return reply_msg(msg.id,"<i>✨Mutelist Cleaned✨</i>", ok_cb,false)
			end
			if matches[2] == 'username' and is_admin1(msg) then
				local function ok_username_cb (extra, success, result)
					local receiver = extra.receiver
					if success == 1 then
						send_large_msg(receiver, "<i>✨SuperGroup username cleaned.✨</i>")
					elseif success == 0 then
						send_large_msg(receiver, "<i>✨Failed to clean SuperGroup username.✨</i>")
					end
				end
				local username = ""
				channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
			end
		    if matches[2] == "bots" and is_momod(msg) then
            savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked all SuperGroup bots")
				channel_get_bots(receiver, callback_clean_bots, {msg = msg})
				return reply_msg(msg.id,"<i>✨All Bots Are Removed✨ From</i> " ..string.gsub(msg.to.print_name, "_", " "), ok_cb,false)
			end
			if matches[2] == 'gbanlist' and is_sudo then 
            local hash = 'gbanned'
                local data_cat = 'gbanlist'
                data[tostring(msg.to.id)][data_cat] = nil
                save_data(_config.moderation.data, data)
                redis:del(hash)
			return reply_msg(msg.id,"<i>✨GbanList Have Been Cleaned!✨</i>", ok_cb,false)
		end
	end
		if matches[1] == 'lock' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'links' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked link posting ")
				return lock_group_links(msg, data, target)
			end
			if matches[2] == 'spam' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked spam ")
				return lock_group_spam(msg, data, target)
			end
			if matches[2] == 'flood' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked flood ")
				return lock_group_flood(msg, data, target)
			end
			if matches[2] == 'arabic' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked arabic ")
				return lock_group_arabic(msg, data, target)
			end
			if matches[2] == 'tag' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked Tag ")
				return lock_group_tag(msg, data, target)
			end
			if matches[2] == 'webpage' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked WebLink ")
				return lock_group_webpage(msg, data, target)
			end
			if matches[2] == 'forward' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked Forward Msg ")
				return lock_group_fwd(msg, data, target)
			end
			if matches[2] == 'badword' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked Badwords ")
				return lock_group_badw(msg, data, target)
			end
			if matches[2] == 'emoji' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked Emoji ")
				return lock_group_emoji(msg, data, target)
			end
			if matches[2] == 'english' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked English ")
				return lock_group_eng(msg, data, target)
			end
			if matches[2] == 'member' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked member ")
				return lock_group_membermod(msg, data, target)
			end
			if matches[2]:lower() == 'rtl' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked rtl chars. in names")
				return lock_group_rtl(msg, data, target)
			end
			if matches[2] == 'tgservice' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked Tgservice Actions")
				return lock_group_tgservice(msg, data, target)
			end
			if matches[2] == 'sticker' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked sticker posting")
				return lock_group_sticker(msg, data, target)
			end
			if matches[2] == 'contacts' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked contact posting")
				return lock_group_contacts(msg, data, target)
			end
			if matches[2] == 'strict' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked enabled strict settings")
				return enable_strict_rules(msg, data, target)
			end
			if matches[2] == 'media' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked media posting")
				return lock_group_media(msg, data, target)
			end
			if matches[2] == 'share' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked share posting")
				return lock_group_share(msg, data, target)
			end
			if matches[2] == 'bots' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked bots")
				return lock_group_bots(msg, data, target)
			end
			if matches[2] == 'number' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked number posting")
				return lock_group_number(msg, data, target)
			end
			if matches[2] == 'poker' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked poker posting")
				return lock_group_poker(msg, data, target)
			end
			if matches[2] == 'audio' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked voice posting")
				return lock_group_audio(msg, data, target)
			end
			if matches[2] == 'photo' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked photo posting")
				return lock_group_photo(msg, data, target)
			end
			if matches[2] == 'video' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked video posting")
				return lock_group_video(msg, data, target)
			end
			if matches[2] == 'documents' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked documents posting")
				return lock_group_documents(msg, data, target)
			end
			if matches[2] == 'text' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked text posting")
				return lock_group_text(msg, data, target)
			end
			if matches[2] == 'all' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked all posting")
				return lock_group_all(msg, data, target)
			end
			if matches[2] == 'gifs' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked gifs posting")
				return lock_group_gifs(msg, data, target)
			end
			if matches[2] == 'inline' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked inline posting")
				return lock_group_inline(msg, data, target)
			end
			if matches[2] == 'cmd' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked cmd posting")
				return lock_group_cmd(msg, data, target)
			end
		end
        if matches[1] == 'mte' and is_momod(msg) then
		local target = msg.to.id
				if matches[2] == 'photo' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked photo posting")
				return lock_group_photo(msg, data, target)
			end
				if matches[2] == 'video' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked video posting")
				return lock_group_video(msg, data, target)
			end
				if matches[2] == 'gif' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked gif posting")
				return lock_group_gif(msg, data, target)
			end
				if matches[2] == 'audio' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked audio posting")
				return lock_group_audio(msg, data, target)
			end
				if matches[2] == 'document' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked document posting")
				return lock_group_document(msg, data, target)
			end
		end
		if matches[1] == 'unlock' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'links' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked link posting")
				return unlock_group_links(msg, data, target)
			end
			if matches[2] == 'spam' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked spam")
				return unlock_group_spam(msg, data, target)
			end
			if matches[2] == 'flood' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked flood")
				return unlock_group_flood(msg, data, target)
			end
			if matches[2] == 'arabic' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked Arabic")
				return unlock_group_arabic(msg, data, target)
			end
			if matches[2] == 'tag' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked Tag")
				return unlock_group_tag(msg, data, target)
			end
			if matches[2] == 'webpage' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked WebLink")
				return unlock_group_webpage(msg, data, target)
			end
			if matches[2] == 'emoji' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked Emoji")
				return unlock_group_emoji(msg, data, target)
			end
			if matches[2] == 'english' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked English")
				return unlock_group_eng(msg, data, target)
			end
			if matches[2] == 'forward' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked Forward Msg")
				return unlock_group_fwd(msg, data, target)
			end
			if matches[2] == 'badword' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked Badwords")
				return unlock_group_badw(msg, data, target)
			end
			if matches[2] == 'photo' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked photo")
				return unlock_group_photo(msg, data, target)
			end
			if matches[2] == 'member' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked member ")
				return unlock_group_membermod(msg, data, target)
			end
			if matches[2]:lower() == 'rtl' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked RTL chars. in names")
				return unlock_group_rtl(msg, data, target)
			end
				if matches[2] == 'tgservice' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked tgservice actions")
				return unlock_group_tgservice(msg, data, target)
			end
			if matches[2] == 'sticker' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked sticker posting")
				return unlock_group_sticker(msg, data, target)
			end
			if matches[2] == 'contacts' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked contact posting")
				return unlock_group_contacts(msg, data, target)
			end
			if matches[2] == 'strict' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked disabled strict settings")
				return disable_strict_rules(msg, data, target)
			end
			if matches[2] == 'media' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked contact media")
				return unlock_group_media(msg, data, target)
			end
			if matches[2] == 'share' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked share posting")
				return unlock_group_share(msg, data, target)
			end
			if matches[2] == 'bots' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked bots")
				return unlock_group_bots(msg, data, target)
			end
			if matches[2] == 'number' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked number posting")
				return unlock_group_number(msg, data, target)
			end
			if matches[2] == 'poker' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked poker posting")
				return unlock_group_poker(msg, data, target)
			end
			if matches[2] == 'audio' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked voice posting")
				return unlock_group_audio(msg, data, target)
			end
			if matches[2] == 'photo' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked photo posting")
				return unlock_group_photo(msg, data, target)
			end
			if matches[2] == 'video' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked video posting")
				return unlock_group_video(msg, data, target)
			end
			if matches[2] == 'documents' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked documents posting")
				return unlock_group_documents(msg, data, target)
			end
			if matches[2] == 'text' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked text posting")
				return unlock_group_text(msg, data, target)
			end
			if matches[2] == 'all' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked all posting")
				return unlock_group_all(msg, data, target)
			end
			if matches[2] == 'gifs' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked gifs posting")
				return unlock_group_gifs(msg, data, target)
			end
			if matches[2] == 'inline' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked inline posting")
				return unlock_group_inline(msg, data, target)
			end
			if matches[2] == 'cmd' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked cmd posting")
				return unlock_group_cmd(msg, data, target)
			end
		end
		if matches[1] == 'unmte' and is_momod(msg) then
			local target = msg.to.id
				if matches[2] == 'photo' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked photo posting")
				return unlock_group_photo(msg, data, target)
		    end
				if matches[2] == 'video' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked video posting")
				return unlock_group_video(msg, data, target)
		    end
				if matches[2] == 'gif' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked gif posting")
				return unlock_group_gif(msg, data, target)
		    end
				if matches[2] == 'audio' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked audio posting")
				return unlock_group_audio(msg, data, target)
		    end
			    if matches[2] == 'document' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked document posting")
				return unlock_group_document(msg, data, target)
		    end
		end
		if matches[1] == 'setflood' then
			if not is_momod(msg) then
				return
			end
			if tonumber(matches[2]) < 2 or tonumber(matches[2]) > 50 then
				return "💠Wrong number,range is [5-20]💠"
			end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['flood_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set flood to ["..matches[2].."]")
			return '💠Flood has been set to💠: '..matches[2]
		end
		if matches[1] == 'public' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == '🔐' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set group to: public")
				return set_public_membermod(msg, data, target)
			end
			if matches[2] == '🔓' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: not public")
				return unset_public_membermod(msg, data, target)
			end
		end

		if matches[1] == 'mute' and is_momod(msg) then
			local chat_id = msg.to.id
			if matches[2] == 'audio' then
			local msg_type = 'Audio'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return "<i>✨Audio has been muted✨</i>"
				else
					return "<i>✨SuperGroup mute Audio is already on✨</i>"
				end
			end
			if matches[2] == 'photo' then
			local msg_type = 'Photo'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return "<i>✨Photo has been muted✨</i>"
				else 
					return "<i>✨Mute Photo is already on✨</i>"
				end
			end
			if matches[2] == 'video' then
			local msg_type = 'Video'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return "<i>✨Video has been muted✨</i>"
				else
					return "<i>✨SuperGroup mute Video is already on✨</i>"
				end
			end
			if matches[2] == 'gifs' then
			local msg_type = 'Gifs'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return "<i>✨Gifs have been muted✨</i>"
				else
					return "<i>✨SuperGroup mute Gifs is already on✨</i>"
				end
			end
			if matches[2] == 'documents' then
			local msg_type = 'Documents'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return "<i>✨Documents have been muted✨</i>"
				else
					return "<i>✨SuperGroup mute Documents is already on✨</i>"
				end
			end
			if matches[2] == 'text' then
			local msg_type = 'Text'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return "<i>✨Text has been muted✨</i>"
				else
					return "<i>✨Mute Text is already on✨</i>"
				end
			end
			if matches[2] == 'all' then
			local msg_type = 'All'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return "<i>✨Mute ALL  has been enabled✨</i>"
				else
					return "<i>✨Mute ALL is already on✨</i>"
				end
			end
		end
		if matches[1] == 'unmute' and is_momod(msg) then
			local chat_id = msg.to.id
			if matches[2] == 'audio' then
			local msg_type = 'Audio'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return "<i>✨Audio has been unmuted✨</i>"
				else
					return "<i>✨Mute Audio is already off✨</i>"
				end
			end
			if matches[2] == 'photo' then
			local msg_type = 'Photo'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return "<i>✨Photo has been unmuted✨</i>"
				else
					return "<i>✨Mute Photo is already off✨</i>"
				end
			end
			if matches[2] == 'video' then
			local msg_type = 'Video'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return "<i>✨Video has been unmuted✨</i>"
				else
					return "<i>✨Mute Video is already off✨</i>"
				end
			end
			if matches[2] == 'gifs' then
			local msg_type = 'Gifs'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return "<i>✨Gifs have been unmuted✨</i>"
				else
					return "<i>✨Mute Gifs is already off✨</i>"
				end
			end
			if matches[2] == 'documents' then
			local msg_type = 'Documents'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return "<i>✨Documents have been unmuted✨</i>"
				else
					return "<i>✨Mute Documents is already off✨</i>"
				end
			end
			if matches[2] == 'text' then
			local msg_type = 'Text'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute message")
					unmute(chat_id, msg_type)
					return "<i>✨Text has been unmuted✨</i>"
				else
					return "<i>✨Mute Text is already off✨</i>"
				end
			end
			if matches[2] == 'all' then
			local msg_type = 'All'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return ">><i> ✨Mute ALL has been disabled✨</i>"
				else
					return ">> <i>✨Mute ALL is already disabled✨</i>"
				end
			end
		end


		if matches[1] == "muteuser" and is_momod(msg) then
			local chat_id = msg.to.id
			local hash = "mute_user"..chat_id
			local user_id = ""
			if type(msg.reply_id) ~= "nil" then
				local receiver = get_receiver(msg)
				local get_cmd = "mute_user"
				muteuser = get_message(msg.reply_id, get_message_callback, {receiver = receiver, get_cmd = get_cmd, msg = msg})
			elseif matches[1] == "muteuser" and string.match(matches[2], '^%d+$') then
				local user_id = matches[2]
				if is_muted_user(chat_id, user_id) then
					unmute_user(chat_id, user_id)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] removed ["..user_id.."] from the muted users list")
					return ">> <i>✨["..user_id.."] removed from the muted users list✨</i>"
				elseif is_momod(msg) then
					mute_user(chat_id, user_id)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] added ["..user_id.."] to the muted users list")
					return reply_msg(msg.id,">><i> ✨["..user_id.."] added to the muted user list✨</i>",ok_cb,false)
				end
			elseif matches[1] == "muteuser" and not string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local get_cmd = "mute_user"
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, callbackres, {receiver = receiver, get_cmd = get_cmd, msg=msg})
			end
		end

		if matches[1] == "muteslist" and is_momod(msg) then
			local chat_id = msg.to.id
			if not has_mutes(chat_id) then
				set_mutes(chat_id)
				return mutes_list(chat_id)
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup muteslist")
			return mutes_list(chat_id)
		end
		if matches[1] == "mutelist" and is_momod(msg) then
			local chat_id = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup mutelist")
			return muted_user_list(chat_id)
		end

		if matches[1] == 'settings' and is_momod(msg) then
			local target = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup settings ")
			return show_supergroup_settingsmod(msg, target)
		end

		if matches[1] == 'rules' then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group rules")
			return get_rules(msg, data)
		end

		if matches[1] == '/help' and not is_momod(msg) then
                        text = ""
			reply_msg(msg.id, text, ok_cb, false)
		elseif matches[1] == 'help' and is_momod(msg) then
                        text = ""
			reply_msg(msg.id, text, ok_cb, false)
		end
		
	if matches[1] == 'superhelp' and is_momod(msg) then
                       text = ""
                       reply_msg(msg.id, text, ok_cb, false)
	end
	if matches[1] == 'superhelp' and msg.to.type == "user" then
			text = ""
			reply_msg(msg.id, text, ok_cb, false)
	end

		if matches[1] == 'peer_id' and is_admin1(msg)then
			text = msg.to.peer_id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		if matches[1] == 'msg.to.id' and is_admin1(msg) then
			text = msg.to.id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		--Admin Join Service Message
		if msg.service then
		local action = msg.action.type
			if action == 'chat_add_user_link' then
				if is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					savelog(msg.to.id, name_log.." Admin ["..msg.from.id.."] joined the SuperGroup via link")
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.from.id) and not is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					savelog(msg.to.id, name_log.." Support member ["..msg.from.id.."] joined the SuperGroup")
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
			if action == 'chat_add_user' then
				if is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					savelog(msg.to.id, name_log.." Admin ["..msg.action.user.id.."] added to the SuperGroup by [ "..msg.from.id.." ]")
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.action.user.id) and not is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					savelog(msg.to.id, name_log.." Support member ["..msg.action.user.id.."] added to the SuperGroup by [ "..msg.from.id.." ]")
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
		end
		if matches[1] == 'msg.to.peer_id' then
			post_large_msg(receiver, msg.to.peer_id)
		end
	end
end

local function pre_process(msg)
  if not msg.text and msg.media then
    msg.text = '['..msg.media.type..']'
  end
  return msg
end

return {
  patterns = {
	"^[#!/]([Aa]dd)$",
	"^[#!/]([Rr]em)$",
	"^[#!/]([Mm]ove) (.*)$",
	"^[#!/]([Ii]nfo)$",
	"^[#!/]([Aa]dmins)$",
	"^[#!/]([Oo]wner)$",
	"^[#!/]([Mm]odlist)$",
	"^[#!/]([Bb]ots)$",
	"^[#!/]([Ww]ho)$",
	"^[#!/]([Kk]icked)$",
    "^[#!/]([Kk]ick) (.*)",
	"^[#!/]([Kk]ick)",
	"^[#!/]([Uu]pchat)$",
	"^[#!/]([Ii][Dd])$",
	"^[#!/]([Ii][Dd]) (.*)$",
	"^[#!/]([Kk]ickme)$",
	"^[#!/]([Kk]ick) (.*)$",
	"^[#!/]([Nn]ewlink)$",
	"^[#!/]([Ss]etlink)$",
	"^[#!/]([Ll]ink)$",
	"^[#!/]([Rr]es) (.*)$",
	"^[#!/]([Ss]etadmin) (.*)$",
	"^[#!/]([Ss]etadmin)",
	"^[#!/]([Dd]emoteadmin) (.*)$",
	"^[#!/]([Dd]emoteadmin)",
	"^[#!/]([Ss]etowner) (.*)$",
	"^[#!/]([Ss]etowner)$",
	"^[#!/]([Pp]romote) (.*)$",
	"^[#!/]([Pp]romote)",
	"^[#!/]([Dd]emote) (.*)$",
	"^[#!/]([Dd]emote)",
	"^[#!/]([Ss]etname) (.*)$",
	"^[#!/]([Ss]etabout) (.*)$",
	"^[#!/]([Ss]etrules) (.*)$",
	"^[#!/]([Ss]etphoto)$",
	"^[#!/]([Ss]etusername) (.*)$",
	"^[#!/]([Dd]el)$",
	"^[#!/]([Ll]ock) (.*)$",
	"^[#!/]([Uu]nlock) (.*)$",
	"^[#!/]([Mm]ute) ([^%s]+)$",
	"^[#!/]([Uu]nmute) ([^%s]+)$",
	"^[#!/]([Mm]uteuser)$",
	"^[#!/]([Mm]uteuser) (.*)$",
	"^[#!/]([Pp]ublic) (.*)$",
	"^[#!/]([Ss]ettings)$",
	"^[#!/]([Rr]ules)$",
	"^[#!/]([Ss]etflood) (%d+)$",
	"^[#!/]([Cc]lean) (.*)$",
	"^[#!/]([Mm]uteslist)$",
	"^[#!/]([Mm]utelist)$",
	"^([Aa]dd)$",
	"^([Rr]em)$",
	"^([Mm]ove) (.*)$",
	"^([Ii]nfo)$",
	"^([Aa]dmins)$",
	"^([Oo]wner)$",
	"^([Mm]odlist)$",
	"^([Bb]ots)$",
	"^([Ww]ho)$",
	"^([Kk]icked)$",
    "^([Kk]ick) (.*)",
	"^([Kk]ick)",
	"^([Uu]pchat)$",
	"^([Ii][Dd])$",
	"^([Ii][Dd]) (.*)$",
	"^([Kk]ickme)$",
	"^([Kk]ick) (.*)$",
	"^([Nn]ewlink)$",
	"^([Ss]etlink)$",
	"^([Ll]ink)$",
	"^([Rr]es) (.*)$",
	"^([Ss]etadmin) (.*)$",
	"^([Ss]etadmin)",
	"^([Dd]emoteadmin) (.*)$",
	"^([Dd]emoteadmin)",
	"^([Ss]etowner) (.*)$",
	"^([Ss]etowner)$",
	"^([Pp]romote) (.*)$",
	"^([Pp]romote)",
	"^([Dd]emote) (.*)$",
	"^([Dd]emote)",
	"^([Ss]etname) (.*)$",
	"^([Ss]etabout) (.*)$",
	"^([Ss]etrules) (.*)$",
	"^([Ss]etphoto)$",
	"^([Ss]etusername) (.*)$",
	"^([Dd]el)$",
	"^([Ll]ock) (.*)$",
	"^([Uu]nlock) (.*)$",
	"^([Mm]ute) ([^%s]+)$",
	"^([Uu]nmute) ([^%s]+)$",
	"^([Mm]uteuser)$",
	"^([Mm]uteuser) (.*)$",
	"^([Pp]ublic) (.*)$",
	"^([Ss]ettings)$",
	"^([Rr]ules)$",
	"^([Ss]etflood) (%d+)$",
	"^([Cc]lean) (.*)$",
	"^([Mm]uteslist)$",
	"^([Mm]utelist)$",
    "([Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)",
	"msg.to.peer_id",
	"%[(document)%]",
	"%[(photo)%]",
	"%[(video)%]",
	"%[(audio)%]",
	"%[(contact)%]",
	"^!!tgservice (.+)$",
  },
  run = run,
  pre_process = pre_process
}
--By @behzad_ds   <behzad jafarpour> :)
----Ready For white wolf 8
