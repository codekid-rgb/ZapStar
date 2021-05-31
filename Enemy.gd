extends Node2D


var sprite = null;
				
var speed = 100
onready var explode = preload("res://Explosion.tscn").instance()

func _ready():
	speed = speed + (globals.currentStage * 10)

func _process(delta):
	move_local_x(-delta*speed)

func _on_Area2D_area_entered(area):
	#Hit by bullet
	if(area.get_collision_layer_bit(3)):
		
		explode.set_position(self.get_position())
		get_parent().add_child(explode)
		globals.kills = globals.kills + 1
		queue_free()
