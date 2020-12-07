extends Control

const MAX_PLAYERS=5
const SERVER_PORT=5000

func start_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	display_message("Server Listening on "+str(IP.get_local_addresses()[0])+":"+str(SERVER_PORT))
	#$VBoxContainer/Label.text="Running on " + String(peer.get_peer_address(1))+ " "+ String(peer.get_peer_port(1))
	

func show_conns(id):
#	var peer=get_tree().network_peer
#	var incoms=peer.get_incoming_connections()
#	for i in incoms:
#		$VBoxContainer/incoming.text+=String()
	$VBoxContainer/incoming.text="connected "+String(id)

func _ready():
	var _client_connected = get_tree().connect("network_peer_connected", self, "_on_client_connected")
	var _client_disconnected = get_tree().connect("network_peer_disconnected", self, "_on_client_disconnected")

func _on_client_connected(id):
	display_message("Client " + str(id) + " connected.")
	# Creating a player and setting its name to the ID given by the network API
	
	rpc_id(id, "say_hello")
	rpc_id(id, "say_zzz")

func _on_client_disconnected(id):
	display_message("Client " + str(id) + " disconnected.")
	
func display_message(t:String):
	$VBoxContainer/incoming.add_item(t)
	print(t)

