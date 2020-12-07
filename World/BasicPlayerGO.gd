extends KinematicBody2D
var velocity=500

puppetsync func sync_pos_rot(pos:Vector2,rot:float,vel:Vector2):
	position=pos
	rotation=rot
	return move_and_slide(vel)
	
master func got_pierced():
	get_tree().emit_signal('kill_me')
	

func _on_needle_enter_body(body):
	if get_tree().get_network_unique_id() != self.get_network_master():
		return
	
	if body.is_in_group('Player'):
		print("preparing to kill")
		rpc_id(body.get_network_master(),"got_pierced")


