extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var startpos = 0
var dist = 8
var maxleft = -dist
var maxright = dist
var speed = -7
var decel = 78
var jump_boost = 50
var pulldown_const = 3600
var raw_score = 0
var score = 0
var just_started = true
var global_transform_origin_copy

var moving_far_left = false
var moving_left = false
var moving_far_right = false
var moving_right
var moving = false
var t_right = 0.0
var t_left = 0.0

var vel = Vector3.ZERO
onready var score_label = $score_num
var move = Vector3.ZERO
var cam_offset = 18.3
var speed_up_const = 1.2
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
				#global_transform.origin.x = maxleft
				moving_far_left = true
				moving_left = false
				moving_right = false
				moving_far_right = false
				t_right = 0
				t_left = 0
			elif abs(global_transform.origin.x - maxright) < abs(1):
				#global_transform.origin.x = 0
				moving_left = true
				moving_far_left = false
				moving_far_right = false
				t_right = 0
				t_left = 0
			else:
				global_transform.origin.x = 0
	if Input.is_action_just_pressed("ui_right"):
		print("right")
		Input.action_release("ui_right")
		if !global_transform.origin.x >= maxright:
			#vel.x = -dist
			#translate(vel)
			if abs(global_transform.origin.x) < abs(1):
				moving_far_right = true
				moving_left = false
				moving_far_left = false
				moving_right = false
				t_left = 0
				t_right = 0
			elif abs(global_transform.origin.x - maxleft) < abs(1):
				#global_transform.origin.x = 0
				moving_right = true
				moving_left = false
				moving_far_left = false
				moving_far_right = false
				t_left = 0
				t_right = 0
			else:
				global_transform.origin.x = 0
	if Input.is_action_just_pressed("ui_up"):
		Input.action_release("ui_up")
		if is_on_floor():
			move.y = jump_boost
	if Input.is_action_just_pressed("ui_down"):
		Input.action_release("ui_down")
		if !is_on_floor() && move.y > -40:
			move.y -= pulldown_const * delta
	move_and_slide(move,Vector3.UP)
	if global_transform.origin.y < 1.2:
		global_transform.origin.y = 1.25106
	if !is_on_floor():
		move.y -= decel * delta
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "spike_body" && !just_started:
			print("collided with spike?")
			$Control.is_paused = true
		elif collision.collider.name == "floor":
			pass
		else:
			print(collision.collider.name)
	if moving_far_right:
		print("moving right")
		t_right += delta * 5.2
		global_transform_origin_copy = global_transform.origin
		global_transform_origin_copy.x = maxright
		global_transform.origin = global_transform.origin.linear_interpolate(global_transform_origin_copy, t_right)
		if t_right >= 1:
			t_right = 0
			moving_far_right = false
	if moving_far_left:
		print("moving far left")
		t_left += delta * 6
		global_transform_origin_copy = global_transform.origin
		global_transform_origin_copy.x = maxleft
		global_transform.origin = global_transform.origin.linear_interpolate(global_transform_origin_copy, t_left)
		if t_left >= 1:
			t_left = 0
			moving_far_left = false
	if moving_left:
		print("moving left")
		t_left += delta * 6
		global_transform_origin_copy = global_transform.origin
		global_transform_origin_copy.x = 0
		global_transform.origin = global_transform.origin.linear_interpolate(global_transform_origin_copy, t_left)
		if t_left >= 1:
			t_left = 0
			moving_left = false
	if moving_right:
		print("moving right")
		t_right += delta * 5.2
		global_transform_origin_copy = global_transform.origin
		global_transform_origin_copy.x = 0
		global_transform.origin = global_transform.origin.linear_interpolate(global_transform_origin_copy, t_right)
		if t_right >= 1:
			t_right = 0
			moving_right = false
	cam.global_transform.origin.y = cam_offset
	speed -= speed_up_const * delta
	raw_score += 1 * delta
	print(raw_score)
	score = raw_score * 8
	score = int(score)
	if score == 20:
		just_started = false
	score_label.text = str(score)
	
