extends CharacterBody2D

@export var speed = 300 # How fast the player will move (pixels/sec).

@onready var navigation_agent_2d = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D

var screen_size # Size of the game window.
var last_direction = "down" # Dirección por defecto para la animación de reposo

# Called when the node enters the scene tree for the first time.
func _ready():
	# We get the size of the screen like this
	# screen_size = get_viewport_rect().size
	call_deferred("actor_setup")
	animated_sprite.animation = "rest down" # Animación inicial
	# pass # 

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	navigation_agent_2d.set_target_position(get_global_mouse_position())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var movement_velocity = Vector2.ZERO # The player's movement vector. (0, 0)
	
	# Capturar entrada del usuario y actualizar la dirección
	if Input.is_action_pressed("move_right"):
		movement_velocity.x += 1
		last_direction = "right"
	elif Input.is_action_pressed("move_left"):
		movement_velocity.x -= 1
		last_direction = "left"
	elif Input.is_action_pressed("move_down"):
		movement_velocity.y += 1
		last_direction = "down"
	elif Input.is_action_pressed("move_up"):
		movement_velocity.y -= 1
		last_direction = "up"
	
	if movement_velocity.length() > 0:
		# To avoid the player from moving faster diagonally we normalize 
		# the velocity meaning we set the length to 1 
		movement_velocity= movement_velocity.normalized() * speed
		
		#Now we check if the player moves to animate the sprites 
		# $AnimatedSprite2D.play()
		animated_sprite.play()
	else: 
		# Cambia a la animación de reposo basada en la última dirección 
		animated_sprite.animation = "rest " + last_direction
		# $AnimatedSprite2D.stop()
		animated_sprite.stop()
	
	# Update the player's position 
	# position += velocity * delta
	# And to prevent it from leaving the screen we use clamp()
	# position = position.clamp(Vector2.ZERO, screen_size)
	
	# Now we change the animation based on the direction the player moves 
	#if movement_velocity.x != 0: 
		## walk sprite looks to the right so when player moves to the left 
		## we flip the sprite using flip horizontally
		#$AnimatedSprite2D.animation = "walk right"
		## $AnimatedSprite2D.flip_v = false
		#
		## This boolean assignment is a shorthand for programming 
		#$AnimatedSprite2D.flip_h = movement_velocity.x < 0
		## It has the same purpose as the next code 
		## if velocity.x < 0:
			## $AnimatedSprite2D.flip_h = true
		## else:
			## $AnimatedSprite2D.flip_h = false
	#elif movement_velocity.y > 0:
		## Now for the down animation, since we have the upwards direction, 
		## We flip vertically to make it looks like it goes down 
		#$AnimatedSprite2D.animation = "walk down"
	#else:
		#$AnimatedSprite2D.animation = "walk up"
	
	# Asignar animación de caminata solo si hay movimiento
	if movement_velocity.x > 0:
		animated_sprite.animation = "walk right"
		# animated_sprite.flip_h = false
	elif movement_velocity.x < 0:
		animated_sprite.animation = "walk left" 
		# animated_sprite.flip_h = false
	elif movement_velocity.y > 0:
		animated_sprite.animation = "walk down"
	elif movement_velocity.y < 0:
		animated_sprite.animation = "walk up"
		
		# $AnimatedSprite2D.flip_v = velocity.y > 0
		# Same for this shorthand method  
		# if velocity.y > 0:
			# $AnimatedSprite2D.flip_v = true
		# else:
			# $AnimatedSprite2D.flip_v = false
	# pass
	# Actualiza la posición del personaje
	# movement_velocity = move_and_collide(movement_velocity * delta)
	
	# Ajustar la rotación del RayCast2D basado en la dirección del movimiento
	match last_direction:
		"right":
			$RayCast2D.rotation_degrees = -90  # Derecha (por defecto)
		"left":
			$RayCast2D.rotation_degrees = 90  # Izquierda
		"down":
			$RayCast2D.rotation_degrees = 0  # Abajo
		"up":
			$RayCast2D.rotation_degrees = 180  # Arriba
	
	# Aplicar movimiento
	velocity = movement_velocity
	move_and_slide() 
