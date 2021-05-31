extends Node2D

func _process(delta):
	move_local_x(delta * -800)

func _on_bullet_body_entered(collider):
	
	queue_free()
	if collider.has_method("do_bullet_damage"):
		print("Collided with something that takes damage from bullet: ", collider.name)
		collider.do_bullet_damage(1) 
