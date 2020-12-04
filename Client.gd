extends Control

export(String) var ip
export(String) var port
export(PackedScene) var AvatarScene
export(PackedScene) var PlayerGOScene
var my_id=-1
var peer:NetworkedMultiplayerENet = null
var lobby_reg={}

func start_client():
	if $VBoxContainer/server_ip.text.is_valid_ip_address() and $VBoxContainer/server_port.text.is_valid_integer():
		ip=$VBoxContainer/server_ip.text
		port=int($VBoxContainer/server_port.text)
	display_message("Connecting...")

	if !ip.is_valid_ip_address():
		display_message("IP is invalid!")
		return

	peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, int(port))
	get_tree().set_network_peer(peer)
	

func _ready():
	get_tree().set_auto_accept_quit(false)
	# Connecting network and button events
	var _player_connected = get_tree().connect("network_peer_connected", self, "_on_player_connected")
	var _player_disconnected = get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	var _connected_to_server = get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	var _connection_failed = get_tree().connect("connection_failed", self, "_on_connection_failed")
	var _server_disconnected = get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	

func _on_connection_failed():
	display_message("Connection failed!")
	print("Connection failed!")
	get_tree().set_network_peer(null)
	

func _on_connected_to_server():
	var ch=$VBoxContainer/Avatars.get_children()
	for index in lobby_reg:
		remove_avatar(index)
		
	my_id = get_tree().get_network_unique_id()
	display_message("Connection established. Your id is " + str(my_id))
	print("Connection established. Your id is " + str(my_id))
	add_avatar(my_id)
#	var my_avatar=AvatarScene.instance()
#	my_avatar.set_name(str(my_id))
#	my_avatar.set_network_master(my_id)
#	$VBoxContainer/Avatars.add_child(my_avatar)
#	lobby_reg[str(my_id)]=my_avatar

	

func _on_server_disconnected():
	display_message("Server disconnected.")
	
	# Invalidate all connections
	for index in lobby_reg:
		remove_avatar(index)
#	#delete all avatars
#	var ch=$VBoxContainer/Avatars.get_children()
#	for i in ch:
#		$VBoxContainer/Avatars.remove_child(i)
#		(i as Node).free()
	
func _on_player_connected(id):
	display_message('Player' + str(id) + 'connected')
	#produce its avatar.
	if id != 1:
		add_avatar(id)
	
func _on_player_disconnected(id):
	display_message('Player' + str(id) + 'disconnected')
	remove_avatar(id)

func _on_connect_pressed():
#	$ui/button.visible = false
	if $VBoxContainer/server_ip.text.is_valid_ip_address() and $VBoxContainer/server_port.text.is_valid_integer():
		ip=$VBoxContainer/server_ip.text
		port=int($VBoxContainer/server_port.text)
	display_message("Connecting...")

	if !ip.is_valid_ip_address():
		display_message("IP is invalid!")

	var _client_created = peer.create_client(ip, port)
	get_tree().set_network_peer(peer)

func add_avatar(id:int):
	var avatar=AvatarScene.instance()
	var pl=PlayerGOScene.instance()
	
	avatar.set_name(str(id))
	pl.set_name(str(id))
	
	avatar.set_network_master(id)
	pl.set_network_master(id)
	
	$VBoxContainer/Avatars.add_child(avatar)
	$BattleField/PlayerGOHolder.add_child(pl)
	lobby_reg[str(id)]={
		'avatar':avatar,
		'player':pl
	}

func remove_avatar(id):
	$VBoxContainer/Avatars.remove_child(lobby_reg[str(id)]['avatar'])
	$BattleField/PlayerGOHolder.remove_child(lobby_reg[str(id)]['player'])
	for node in lobby_reg[str(id)]:
		lobby_reg[str(id)][node].queue_free()
	lobby_reg.erase(str(id))

func display_message(t:String):
	$VBoxContainer/incoming.add_item(t)
	print(t)


puppet func say_hello():
	display_message('puppet_func')
	
	
master func say_zzz():
	display_message('master_func')

func _on_DisconnectButton_pressed():
	peer.close_connection()
	_on_server_disconnected()


func _on_HideButton_pressed():
	$VBoxContainer.hide()
	$HUD.show()
	$BattleField.show()


func _on_ShowLobbyButton_pressed():
	$HUD.hide()
	$BattleField.hide()
	$VBoxContainer.show()
func is_player_ready():
	if get_tree().network_peer == null:
		return false
	if not str(get_tree().get_network_unique_id()) in lobby_reg:
		return false
	return true
	 
func _process(delta):
	if not is_player_ready():
		return
	
	var my_player=lobby_reg[str(get_tree().get_network_unique_id())]['player']
	if Input.is_action_just_pressed('ui_up'):
		print("UP_PRESSED")
		my_player.rpc( "player_accelerate",Vector2(0,-1))
	if Input.is_action_just_pressed('ui_down'):
		print("DOWN_PRESSED")
		my_player.rpc( "player_accelerate",Vector2(0,1))
	if Input.is_action_just_pressed('ui_left'):
		print("LEFT_PRESSED")
		my_player.rpc( "player_accelerate",Vector2(-1,0))
	if Input.is_action_just_pressed('ui_right'):
		print("RIGHT_PRESSED")
		my_player.rpc( "player_accelerate",Vector2(1,0))		
	if Input.is_action_just_released('ui_up'):
		print("UP_RELEASED")
		my_player.rpc( "player_accelerate",Vector2(0,1))
	if Input.is_action_just_released('ui_down'):
		print("DOWN_RELEASED")
		my_player.rpc( "player_accelerate",Vector2(0,-1))
	if Input.is_action_just_released('ui_left'):
		print("LEFT_RELEASED")
		my_player.rpc( "player_accelerate",Vector2(1,0))
	if Input.is_action_just_released('ui_right'):
		print("RIGHT_RELEASED")
		my_player.rpc( "player_accelerate",Vector2(-1,0))
	
	if Input.is_key_pressed(KEY_SPACE):
		_on_flip_pressed()


func _on_flip_pressed():
	if not is_player_ready():
		return
	(lobby_reg[str(get_tree().get_network_unique_id())]['player'] as Node2D).rotate(PI/2)

func _on_up_button_down():
	if not is_player_ready():
		return
	var my_player=lobby_reg[str(get_tree().get_network_unique_id())]['player']
	print("UP_PRESSED")
	my_player.rpc( "player_accelerate",Vector2(0,-1))
func _on_down_button_down():
	if not is_player_ready():
		return
	var my_player=lobby_reg[str(get_tree().get_network_unique_id())]['player']
	print("DOWN_PRESSED")
	my_player.rpc( "player_accelerate",Vector2(0,1))
func _on_left_button_down():
	if not is_player_ready():
		return
	var my_player=lobby_reg[str(get_tree().get_network_unique_id())]['player']
	print("LEFT_PRESSED")
	my_player.rpc( "player_accelerate",Vector2(-1,0))
func _on_right_button_down():
	if not is_player_ready():
		return
	var my_player=lobby_reg[str(get_tree().get_network_unique_id())]['player']
	print("RIGHT_PRESSED")
	my_player.rpc( "player_accelerate",Vector2(1,0))
func _on_up_button_up():
	if not is_player_ready():
		return
	var my_player=lobby_reg[str(get_tree().get_network_unique_id())]['player']
	print("UP_RELEASED")
	my_player.rpc( "player_accelerate",Vector2(0,1))
func _on_down_button_up():
	if not is_player_ready():
		return
	var my_player=lobby_reg[str(get_tree().get_network_unique_id())]['player']
	print("DOWN_RELEASED")
	my_player.rpc( "player_accelerate",Vector2(0,-1))
func _on_left_button_up():
	if not is_player_ready():
		return
	var my_player=lobby_reg[str(get_tree().get_network_unique_id())]['player']
	print("LEFT_RELEASED")
	my_player.rpc( "player_accelerate",Vector2(1,0))
func _on_right_button_up():
	if not is_player_ready():
		return
	var my_player=lobby_reg[str(get_tree().get_network_unique_id())]['player']
	print("RIGHT_RELEASED")
	my_player.rpc( "player_accelerate",Vector2(-1,0))
