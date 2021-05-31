extends Node2D

onready var right_bullet_scene = preload("res://player/bulet root.tscn")
onready var left_bullet_scene = preload("res://player/left bulet.tscn")	

func _on_Player_spawn_bullet(direction,pos):
	var scene_instance
	if direction < 0:
		scene_instance = left_bullet_scene.instance()
		scene_instance.set_name("bullet_scene")
		scene_instance.set_position(pos)
	else:
		scene_instance = right_bullet_scene.instance()
		scene_instance.set_name("bullet_scene")
		scene_instance.set_position(pos)
	add_child(scene_instance)


func _ready():
	$Player.reset_player($spawn.position)
	
func _on_Player_fell():
	$Player.reset_player($spawn.position)