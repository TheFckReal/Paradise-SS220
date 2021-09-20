/datum/world_topic_handler/instance_announce
	topic_key = "instance_announce"
	requires_commskey = TRUE

/datum/world_topic_handler/instance_announce/execute(list/input, key_valid)
	to_chat(world, "<center><span class='boldannounce'><big>Attention</big></span></center><hr>[input["msg"]]<hr>")
	SEND_SOUND(world, sound('sound/misc/notice2.ogg')) // Same as captains priority announce
