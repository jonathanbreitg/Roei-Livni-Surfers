extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var is_left = false
var is_mid = false
var dist = 8
var maxleft = -dist
var maxright = dist
var is_right = false
var speed = Vector3.ZERO
var val
var target = Vector3.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#print("spawned moving spike")
	#if abs(global_transform.origin.x) <abs(1):
	#	is_mid = true
	#elif abs(global_transform.origin.x - maxleft) < abs(1):
	#	is_left = true
	#elif abs(global_transform.origin.x - maxright) < abs(1):
	#	is_right = true
	#else:
	#	print("what how")
	speed.x = 10
	val = randi() % 2 
	if val == 1:
		is_left = true
	elif val == 2:
		is_right = true
	else:
		print("VAL IS 2 INCLUSIVE !!!")
	if is_left:
		speed.x = -10
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if abs(global_transform.origin.z - get_parent().get_parent().get_node("player/KinematicBody").global_transform.origin.z) < 25:
		move_and_slide(speed,Vector3.UP)
