extends KinematicBody2D
var velocity=500


#func _process(delta):
#	if Input.is_action_pressed("ui_down"):
#		movement(Vector2(0,1),delta)
#	elif Input.is_action_pressed('ui_up'):
#		movement(Vector2(0,-1),delta)
#	elif Input.is_action_pressed("ui_left"):
#		movement(Vector2(-1,0),delta)
#	elif Input.is_action_pressed("ui_right"):
#		movement(Vector2(1,0),delta)

#func movement(direction,delta):
#	apply_impulse(Vector2.ZERO, direction*velocity*delta)


puppet func kill():
	print('killed')
	self.visible=false
	self.queue_free()

master func got_pierced():
	rpc('kill')
	kill()

func _on_needle_enter_body(body):
	if get_tree().get_network_unique_id() != self.get_network_master():
		return
	
	if body.is_in_group('Player'):
		print("preparing to kill")
		rpc_id(body.get_network_master(),"got_pierced")


