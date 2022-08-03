extends KinematicBody2D

# declaracao de variaveis
var velocity = Vector2.ZERO
var move_speed = 100
var gravity = 1200
var jump_force = -720
var is_grounded
onready var raycasts = $raycasts 

# esta aqui eh uma funcao que compita a fisica do jogo
func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	# aqui ele chama a funcao que faz o personagem andar
	_get_input()
	
	velocity = move_and_slide(velocity)
	
	is_grounded = _check_is_ground()
	
	_set_animation()

# esta funcao eh para fazer o personagem andar 
func _get_input():
	velocity.x = 0
	var move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.x = move_speed * move_direction
	#isso eh para mudar a direcao que o personagem olha
	if move_direction !=0:
		$texture.scale.x = move_direction

# esta funcao conserta o erro do personagem pular infinito, so pula quando esta no chao
func _input(event):
	if event.is_action_pressed("jump") and is_grounded:
		velocity.y = jump_force / 2

# esta eh aux da anterior, verifica se o personagem esta no chao
func _check_is_ground():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true 
	return false		

# essa funcao define as animacoes
func _set_animation():
	var anim = "idle"
	
	if !is_grounded:
		anim = "jump"
	elif velocity.x != 0:
		anim = "run" 
		
	if $anim.assigned_animation != anim:
		$anim.play(anim)
