extends StaticBody2D


func _ready():
	pass
	
#function to identify object as part of the stage
func _isStage():
	return true
#identifies object as not being the player
func _isPlayer():
	return false
#identifies object as not being an enemy
func _isEnemy():
	return false