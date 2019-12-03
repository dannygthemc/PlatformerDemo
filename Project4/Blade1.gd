extends RigidBody2D

const speed = 300 #constant speed
const dmg = 1 #constant damage
var backwards # boolean to identify whether ennemy is move backwards or forwards
onready var sprite = get_node("Sprite") #reference to the player image, allows animation
var anim = "moving" #reference to animation

#gets damage value of enemy
func getDamage():
	return dmg
	
#identifies body as an enemy
func _isEnemy():
	return true
	
#identifies body as not part of the stage
func _isStage():
	return false
	
#returns true if moving backwards
#false otherwise
func getBackwards():
	return backwards
	
#sets the backwards boolean
func setBackwards(val):
	backwards = val

func _ready():
	backwards = true
	health = 10
	set_fixed_process(true)
	
	
func _fixed_process(delta):
	
	var speed_x = 0 #set x speed to 0, doesn't move left or right
	var speed_y = 1 #set y speed to 1, moves up and down
	if backwards:
		sprite.set_flip_h(false)
		var motion = Vector2(speed_x, -speed_y) * speed #create vector for movement
		set_pos(get_pos() + motion * delta) #apply the vector
	else:
		sprite.set_flip_h(true)
		var motion = Vector2(speed_x, speed_y) * speed #create vector for movement
		set_pos(get_pos() + motion * delta) #apply the vector
		
	sprite.play(anim)
	
	
#when enemy exits the area defined by 'Range'
#enemy switches direction
func _on_BladeRange1_body_exit( body ):
	if body._isEnemy():
		if body.getBackwards():
			body.setBackwards(false)
		else:
			body.setBackwards(true)
