extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var startpos = 0
var dist = 8
var maxleft = -dist
var maxright = dist
var speed = -7
var decel = 1.3
var jump_boost = 50
var pulldown_const = 60
var raw_score = 0
var score = 0
var vel = Vector3.ZERO
onready var score_label = $score_num
var move = Vector3.ZERO
var cam_offset = 18.3
var speed_up_const = 0.02
onready var cam = $Camera
# Called when the node enters the scene tree for the first time.
func _ready():
	startpos = global_transform.origin
	maxleft = startpos.x - dist
	maxright = startpos.x + dist
	move.z = speed
	cam.global_transform.origin.y = cam_offset
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move.z = speed
	if Input.is_action_just_pressed("ui_left"):
		print("left")
		Input.action_release("ui_left")
		if !global_transform.origin.x <= maxleft:
			#vel.x = -dist
			#translate(vel)
			print(global_transform.origin.x)
			if global_transform.origin.x < abs(1):
				global_transform.origin.x = maxleft
			elif abs(global_transform.origin.x - maxright) < abs(1):
				global_transform.origin.x = 0
			else:
				global_transform.origin.x = 0
	if Input.is_action_just_pressed("ui_right"):
		print("right")
		Input.action_release("ui_right")
		if !global_transform.origin.x >= maxright:
			#vel.x = -dist
			#translate(vel)
			print(global_transform.origin.x)
			if abs(global_transform.origin.x) < abs(1):
				global_transform.origin.x = maxright
				print("move to far right")
			elif abs(global_transform.origin.x - maxleft) < abs(1):
				print("move to mid")
				global_transform.origin.x = 0
			else:
				global_transform.origin.x = 0
	if Input.is_action_just_pressed("ui_up"):
		print("up")
		Input.action_release("ui_up")
		if is_on_floor():
			move.y = jump_boost
	if Input.is_action_just_pressed("ui_down"):
		print("down")
		Input.action_release("ui_down")
		if !is_on_floor() && move.y > -40:
			move.y -= pulldown_const
	move_and_slide(move,Vector3.UP)
	print(is_on_floor())
	if global_transform.origin.y < 1.2:
		global_transform.origin.y = 1.25106
	if !is_on_floor():
		move.y -= decel
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "spike_body":
			print("collided with spike?")
			get_tree().change_scene("res://death_screen.tscn")
		elif collision.collider.name == "floor":
			pass
		else:
			print(collision.collider.name)
	cam.global_transform.origin.y = cam_offset
	speed -= speed_up_const
	print(move.y)
	raw_score += 1 / delta
	if raw_score > score * 500:
		score += 1
	score_label.text = str(score)
	print(global_transform.origin.y)
	
