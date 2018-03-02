function ulx.screengrab(calling_ply,target_ply,quality)
	if not quality then
		quality = 80
	end
	target_ply.SG = {}
	target_ply.SG.INIT = calling_ply
	target_ply.SG.LEN = 0
	target_ply.SG.COUNT = 0
	net.Start("screengrab_start")
		net.WriteUInt( quality, 32 )
	net.Send( target_ply )
	calling_ply:SendLua([[SetClipboardText( "]] .. target_ply:SteamID() .. [[" )
        chat.AddText( Color(0, 200, 0), "[SG] SteamID игрока ", "]] .. target_ply:Name() .. [[", " скопирован в буфер обмена." )
	]])

	ulx.fancyLogAdmin( calling_ply,true, "#A Grabbed A ScreenShot From #s",target_ply)
end
local screengrab = ulx.command("Screengrab", "ulx screengrab", ulx.screengrab, "!sg",true)
screengrab:addParam{ type=ULib.cmds.PlayerArg }
screengrab:addParam{ type=ULib.cmds.NumArg, hint="quality", min=10,max=80,default=70,ULib.cmds.optional }
screengrab:defaultAccess( ULib.ACCESS_ADMIN )
screengrab:help( "Grabs A ScreenShot Of Targets Screen" )