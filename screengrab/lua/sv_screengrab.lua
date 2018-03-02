util.AddNetworkString("screengrab_start")
util.AddNetworkString("screengrab_part")
util.AddNetworkString("screengrab_fwd_init")
util.AddNetworkString("screengrab_fwd")


net.Receive("screengrab_start", function(x,ply)
	-- Readying the transfer 
	if !IsValid( ply ) then
		print("player isnt valid")
		return 
	end
	MsgN("Starting screencap on "..ply:Name())
	local numparts = net.ReadUInt( 32 )

	ply.SG.LEN = numparts

	if IsValid( ply.SG.INIT ) then
		net.Start("screengrab_fwd_init")
			net.WriteEntity( ply )
			net.WriteUInt( numparts, 32 )
		net.Send( ply.SG.INIT )
	else
		MsgN("Caller of SG is now nonvalid")
		--Welp, the caller is gone. Not much point now.
		--I'll probably make it save to text files in a later version
		return
	end

	--Tell them to initiate the transfer
	net.Start("screengrab_part")
	net.Send( ply )

end)

net.Receive("screengrab_part", function( x, ply )
	if !IsValid( ply ) then return end
	if !IsValid( ply.SG.INIT ) then return end
	if ply.SG.LEN == 0 then return end
	
	local len = net.ReadUInt( 32 )
	local data = net.ReadData( len )

	net.Start("screengrab_fwd")
		net.WriteEntity( ply )
		net.WriteUInt( len, 32 )
		net.WriteData( data, len )
	net.Send( ply.SG.INIT )

	ply.SG.COUNT = ply.SG.COUNT + 1 
	if ply.SG.COUNT == ply.SG.LEN then
		MsgN("Finished SG")
		ply.SG = nil
	else
		net.Start("screengrab_part")
		net.Send( ply )
	end


end)