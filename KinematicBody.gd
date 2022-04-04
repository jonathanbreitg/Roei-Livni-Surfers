extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var maxleft = 0
var maxright = 0
var startpos = 0
var dist = 4
var speed = 3
var decel = 0.8
var jump_boost = 33
var pulldown_const = 50
var vel = Vector3.ZERO
var move = Vector3.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	startpos = global_transform.origin
	maxleft = startpos.x - dist
	maxright = startpos.x + dist
	#move.z = speed
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		print("left")
		Input.action_release("ui_left")
		if !global_transform.origin.x <= maxleft:
			vel.x = -dist
			translate(vel)
	if Input.is_action_just_pressed("ui_right"):
		print("right")
		Input.action_release("ui_right")
		if !global_transform.origin.x >= maxright:
			vel.x = dist
			translate(vel)
	if Input.is_action_just_pressed("ui_up"):
		print("up")
		Input.action_release("ui_up")
		if is_on_floor():
			move.y = jump_boost
	if Input.is_action_just_pressed("ui_down"):
		print("down")
		Input.action_release("ui_down")
		move.y -= pulldown_const
	move_and_slide(move,Vector3.UP)
	if !is_on_floor():
		move.y -= decel
