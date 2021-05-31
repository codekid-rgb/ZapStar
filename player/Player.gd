extends KinematicBody2D

export(String, FILE, "*.tscn") var world_scene
export var RESPAWN_HEIGHT = 1000

signal spawn_bullet(direction,gloabal_postion)
signal fell

const UP = Vector2(0, -1)
const acceleration = 50
const MAX_SPEED = 700
const jump_hight = -890
var motion = Vector2()
var Gravity = 20
var invulnerable_time = 0
var reload_time = 0
var helth = 20
var direction = 0
var life = 5


onready var did_fall = false
onready var tens_place = $"player_camera/tens place"
onready var ones_place = $"player_camera/ones place"
onready var sprite = $sprite










func ones_place(x):
	return x % 10

func tens_place(x):
	return (x/10) % 10
	
func digit_to_region(digit):
	match digit:
		0: return Rect2(82+16,226+16+16,16,16)
		1: return Rect2(82,226,16,16)
		2: return Rect2(82+16,226,16,16)
		3: return Rect2(82+16+16,226,16,16)
		4: return Rect2(82+16+16+16,226,16,16)
		5: return Rect2(82,226+16,16,16)
		6: return Rect2(82+16,226+16,16,16)
		7: return Rect2(82+16+16,226+16,16,16)
		8: return Rect2(82+16+16+16,226+16,16,16)
		9: return Rect2(82,226+16+16,16,16)
	return Rect2(59,232,16,16)

	
	
func reset_player(newPosition):
	did_fall = false
	invulnerable_time = 0
	position = newPosition
	helth = 20
	life = life -1
	print("life -1")

func reset_player_and_warp():
	helth = 20
	did_fall = true
	emit_signal("fell")
	

func do_damage(damage):
	if invulnerable_time <= 0:
		print("Damage: ", damage, ", Health: ", helth)
		invulnerable_time = 1
		helth -= damage
		if helth <= 0:
			reset_player_and_warp()

func _physics_process(delta):
	if helth <= 0:
		life -1
		

	var tens_reg = digit_to_region(tens_place(helth))
	tens_place.texture.set_region(tens_reg)
	var ones_reg = digit_to_region(ones_place(helth))
	ones_place.texture.set_region(ones_reg)
#warning-ignore:unused_variable
	var place = get_global_transform()
	


	
	if reload_time > 0:
		reload_time -= delta
		

	motion.y += Gravity
	if invulnerable_time > 0:
		invulnerable_time -= delta
	var frction = false
	if Input.is_action_pressed("ui_right"):
		direction = +1
		motion.x += acceleration
		motion.x = min(motion.x+acceleration, MAX_SPEED)
		sprite.flip_h = false
		sprite.play("run")
		
	elif Input.is_action_pressed("ui_left"):
		direction = -1
		direction = -1
		motion.x = max(motion.x -acceleration, -MAX_SPEED)
		sprite.flip_h = true
		sprite.play("run")
		
	else:
		sprite.play("idle")
		frction = true

	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = jump_hight
		if frction == true:
			motion.x = lerp(motion.x, 0,0.5)
		
	else:
		if motion.y < 0:
			sprite.play("jump")
			
		else:
			sprite.play("fall")
		if frction == true:
			motion.x = lerp(motion.x, 0,0.05)
		
	if Input.is_action_pressed("ui_select"):
		
			if reload_time <= 0:
				reload_time = 0.25
				var pos
				if direction < 0:
					pos = $"gun spawn2".get_global_position()
					sprite.play("shoot")
				else:
					pos = $"gun spawn".get_global_position()
				emit_signal("spawn_bullet",direction,pos)
				sprite.play("shoot")
	motion = move_and_slide(motion, UP)


	if !did_fall && position.y > RESPAWN_HEIGHT:
		did_fall = true
		emit_signal("fell")
		
		
	if life <= 0:

		get_tree().change_scene("res://game over.tscn")
		
		
		
func _on_quit_pressed():
	
	
#warning-ignore:return_value_discarded
	get_tree().change_scene(world_scene)
