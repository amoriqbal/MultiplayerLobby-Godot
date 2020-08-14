extends Control

export(String) var ip
export(String) var port
var my_id=-1
var peer = null

func start_client():
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
	my_id = get_tree().get_network_unique_id()
	display_message("Connection established. Your id is " + str(my_id))
	print("Connection established. Your id is " + str(my_id))
	# Upon successful connection create a player instance and set it's camera to active
	

func _on_server_disconnected():
	display_message("Server disconnected.")
	print("Server disconnected.")

func _on_player_connected(id):
	display_message('Player' + str(id) + 'connected')
	print('Player' + str(id) + 'connected')

func _on_player_disconnected(id):
	display_message('Player' + str(id) + 'disconnected')
	print('Player' + str(id) + 'disconnected')

func _on_connect_pressed():
#	$ui/button.visible = false
	display_message("Connecting...")
	print("Connecting...")
	if !ip.is_valid_ip_address():
		display_message("IP is invalid!")
		print("IP is invalid!")
	var _client_created = peer.create_client(ip, port)
	get_tree().set_network_peer(peer)

func display_message(text : String):
	$VBoxContainer/Label.text = text

remotesync func say_hello():
	display_message('HELLO')
	print('HELLO')
	
remote func say_zzz():
	print('zzzzzz')
