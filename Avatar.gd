extends Node

func set_name(name):
	.set_name(name)
	$VBoxContainer/Name.text=name

master func master_test(msg):
	var sender_id=get_tree().get_rpc_sender_id()
	display_message("master["+str(sender_id)+"->"+str(get_network_master())+"]:"+msg)
	

puppet func puppet_test(msg):
	var sender_id=get_tree().get_rpc_sender_id()
	display_message("puppet["+str(sender_id)+"->"+str(get_network_master())+"]:"+msg)


func _on_SendButton_pressed():
	rpc('master_test',$VBoxContainer/MessageInput.text)
	rpc('puppet_test',$VBoxContainer/MessageInput.text)
	

func display_message(msg):
	print(msg)
	$VBoxContainer/AvatarLog.add_item(msg)
