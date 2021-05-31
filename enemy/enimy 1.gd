extends KinematicBody2D
export var graviti = 28 

export var ground_speed= 100
const UP = Vector2(0, -1)
var motion = Vector2()
var walking_diretion = 1
var health = 1

func do_bullet_damage(dmg):
	health = health - dmg
	if health <= 0:
		print("gonner")
		$en_icon.visible = false
		queue_free()

func flip_diretion():
	walking_diretion *= -1
	$en_floor_sensor.position.x *= -1

func _physics_process(delta):
	motion.y += graviti
	if is_on_floor():
		motion.x = lerp(motion.x, walking_diretion * ground_speed, 0.5)
	motion = move_and_slide(motion, UP)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var collider = collision.collider
		if collider.has_method("do_damage"):
			print("Collided with something that takes damage: ", collider.name)
			collider.do_damage(5)
	# If the agent is touching a wall or the sensor is not touching a floor (cliff) flip
	if is_on_wall() || $en_floor_sensor.is_colliding() == false:
		flip_diretion()

#func do_hit(damage):
#	print("Damage: ", damage, ", Health: ", helth)
#	invulnerable_time = 1
#	helth -= damage
#	if helth <= 0:
#		get_node("your_rigid_body").free()
