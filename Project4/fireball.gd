extends RigidBody2D

const FIREBALL_SPEED = 200 #set constant for speed
const FIREBALL_DMG = 2 #set constant for damage
var backwards #boolean to identify which direction fireball is aimed
onready var sprite = get_node("fireSprite") #reference to the image, allows manipulation


func _ready():
	set_process(true)
	
#functions to update backwards boolean
#utilized by player class
func _isBackwards():
	backwards = true
func _notBackwards():
	backwards = false


func _process(delta):
	
	var speed_x = 1 #set x speed to 1, moves along x axis
	var speed_y = 0 #set y speed to 0, doesn't move up or down
	#var motion = Vector2(speed_x, speed_y) * FIREBALL_SPEED #create vector for movement
	
	#if character is facing backwards, flip the sprite and direct the vector to the left
	if backwards:
		sprite.set_flip_h(true)
		var motion = Vector2(-speed_x, speed_y) * FIREBALL_SPEED #create vector for movement
		set_pos(get_pos() + motion * delta) #apply the vector
		
	#otherwise, keep sprite unflipped and direct vector to the right
	else:
		sprite.set_flip_h(false)
		var motion = Vector2(speed_x, speed_y) * FIREBALL_SPEED #create vector for movement
		set_pos(get_pos() + motion * delta) #apply the vector
	

#fireball has come in contact with some object
func _on_fireball_body_enter( body ):
	if body._isStage(): #if part of the stage, fireball dissapears
		self.queue_free()
	elif body._isEnemy():
		self.queue_free()
		body.takeDamage(FIREBALL_DMG)
		
		
	
