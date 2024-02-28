extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

const speed = 300
const jump_power = -1300
const acceleration = 50
const friction = 70
const gravity = 100
const max_jumps = 2
var current_jump = 1

func _physics_process(_delta):
	var input_dir: Vector2 = input()
	
	if input_dir != Vector2.ZERO:
		accelerate(input_dir)
	else:
		add_friction()
	
	player_moviment()
	play_animation()
	jump()
	
func input() -> Vector2:
	var input_dir = Vector2.ZERO
	
	input_dir.x = Input.get_axis("left", "right")
	input_dir = input_dir.normalized()
	return input_dir
	
func accelerate(direction):
	velocity = velocity.move_toward(speed * direction, acceleration)
	
func add_friction():
	velocity = velocity.move_toward(Vector2.ZERO, friction)
	
func player_moviment():
	move_and_slide()
	
func jump():
	if Input.is_action_just_pressed("up"):
		if current_jump < max_jumps:
			velocity.y = jump_power
			current_jump += 1
	else:
		velocity.y += gravity
		
	if is_on_floor():
		current_jump = 1
	
func play_animation():
	if Input.is_action_pressed("up"):
		_animated_sprite.play("long_jump")
		
	if Input.is_action_pressed("up") and current_jump == 2:
		_animated_sprite.play("double_jump")
		
	elif Input.is_action_pressed("down"):
		_animated_sprite.play("crouch")
		
	elif Input.is_action_pressed("right"):
		_animated_sprite.flip_h = false
		_animated_sprite.play("run")
		
	elif Input.is_action_pressed("left"):
		_animated_sprite.flip_h = true
		_animated_sprite.play("run")
	else:
		_animated_sprite.play("idle")
		
	if Input.is_action_pressed("sword_attack"):
		_animated_sprite.play("sword_attack_1")
	elif Input.is_action_pressed("punch"):
		_animated_sprite.play("punch_attack_1")
	elif Input.is_action_pressed("kick"):
		_animated_sprite.play("kick")
