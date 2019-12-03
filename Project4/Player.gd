extends RigidBody2D


#int representing hit points
var health = 3

#constant int for player's speed
const player_speed = 200

#constant int for knockback speed
const knockback = 70

#constant int for player's jump speed
const player_jump = 300

#boolean identifies when player has been hit
var hit =false

#int identifies damage taken from hit
var damageTaken = 0

#x value of enemy who hit
var enemyLoc = 0

#booleans representing whether or not buttons have been pressed
var btn_right
var btn_left
var btn_up

#array of objects being collided with
var collisions

onready var sprite = get_node("Sprite") #reference to the player image, allows animation
const fireball = preload("fireball.tscn") #reference to fireball scene, allows instancing


var anim = "idle" #identifies which animation should be used. idle to start
	
#updates health in response to taking damage
func takeDamage(dam):
	health = health - dam
	
#identifies body as player
func _isPlayer():
	return true
    
func _ready():
	set_fixed_process(true)
	set_process_input(true)
	
#event signal checker for attack and jump keys
#used so that actions are not echoed
func _input(event):
	if event.is_action_pressed("ui_select"):
		fireBall()
	elif event.is_action_pressed("ui_up"):
		collisions = get_colliding_bodies()
		if collisions.size() > 0:
			set_linear_velocity(Vector2(get_linear_velocity().x, -player_jump) )
		
		
#function defines action-states which are updated every frame
func _fixed_process(delta):
	
	#check if buttons have been pressed
	#used here so that actions are echoed
	btn_right = Input.is_action_pressed("ui_right")
	btn_left = Input.is_action_pressed("ui_left")
	
	#check for hit first, damage taken animation first priority
	#if not hit, do desired actions
	if !hit:
		#establish controls to move player left and right
		#when left or right arrow key is pressed.
		#reduces movement to zero when key is released
		if btn_left:
			set_linear_velocity(Vector2(-player_speed,get_linear_velocity().y) )
		elif btn_right:
			set_linear_velocity(Vector2(player_speed,get_linear_velocity().y) )
		else:
			set_linear_velocity(Vector2(0,get_linear_velocity().y) )
		#set animations for movement
		#if character is moving up or down, that animation takes priority
		if get_linear_velocity().y <-10 || get_linear_velocity().y >10 :
			#set jump animation based on movement and driection
			if get_linear_velocity().y < -10: #jumping up
				anim = "jumpUp"
			elif get_linear_velocity().y > 10: #falling down
				anim = "jumpDown"
		else: #otherwise, use running animations
			#set running animation based on movement and direction
			if get_linear_velocity().x == 0: #standing still
				anim = "idle"
			else: #moving
				anim = "running"
		#flip spriite to correspond to appropriate direction
		if get_linear_velocity().x > 0: #moving right
			sprite.set_flip_h(false)
		elif get_linear_velocity().x < 0: #moving left
			sprite.set_flip_h(true)
			
		sprite.play(anim) #play selected animation
		
	#if body-enter-signal identified a hit
	else:
		takeDamage(damageTaken) #take damage
		sprite.play("dmgTaken")
		#determine direction of knockback
		var loc = enemyLoc #get x location of enemy
		var dif = loc - get_global_pos().x #get difference between player and enemy loc
		if dif < 0: #if enemy is to the right
			set_linear_velocity(Vector2(-knockback,get_linear_velocity().y) ) #knockback to the left
		else: #if to the left
			set_linear_velocity(Vector2(knockback,get_linear_velocity().y) ) #knockback to the right
			
			
	
	
#gameover
func gameOver():
	sprite.play("faint")
	
#creates a new instance of the fireball class
#identifies whether fireball should be directed forwards or backwards
func fireBall():
	#only creates a new fireball if there isn't already one in use
	var fbList = get_tree().get_nodes_in_group("fireballs")
	if fbList.size() == 0:
		var fb = fireball.instance()
		#if player is facing backwards, use alternate start point for fireball
		if sprite.is_flipped_h():
			fb.set_pos(get_node("fireballStart2").get_global_pos() )
			fb._isBackwards()
		else:
			fb.set_pos(get_node("fireballStart").get_global_pos() )
			fb._notBackwards()
			
		get_parent().add_child(fb) #adds fireball to the main node
		

#once a fireball leaves the area set by 'Range'
#it is removed from play
func _on_Range_body_exit( body ):
	if body.is_in_group("fireballs"):
		body.queue_free()

#player has come in contact with some body object
func _on_Player_body_enter( body ):
	if body._isEnemy(): #if object is an enemy
		self.hit = true #set hit to true
		self.damageTaken = body.getDamage() #identify damage taken
		self.enemyLoc = body.get_global_pos().x #get x location of enemy
		
#player has come out of contact with some body object
func _on_Player_body_exit( body ):
	if body._isEnemy(): #if object was an enemy, reset values
		self.hit = false
		self.damageTaken = 0
		self.enemyLoc = 0
