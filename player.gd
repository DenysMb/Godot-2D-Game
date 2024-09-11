extends Area2D

signal hit

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tween = get_tree().create_tween()
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
		var angle = velocity.angle() + PI / 2
		
		tween.tween_property($AnimatedSprite2D, "rotation", angle, 0.15)
		
		$AnimatedSprite2D.play()
	else:
		tween.tween_property($AnimatedSprite2D, "rotation", 0, 0.15)
		
		$AnimatedSprite2D.stop()
	
	var player_size = $CollisionShape2D.shape.get_rect().size
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO + player_size / 2, screen_size - player_size / 2)
	

func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
