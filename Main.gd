extends Node

export (PackedScene) var Ball
var in_game = false # To prevent resetting in main screen.
var score_counter = 0 
var high_score = 0 # high score of the player.
var high_score_shown = false # This makes the high score message only
							 # appear once per rally.

func _ready():
	high_score = load_game()
	$GUI.change_high_score(high_score)

# Starts the game from the start button as well as the game resets.
func start_game():
	in_game = true
	if !$Ball: # If the Ball node hasn't been created yet...
		$GUI/StartButton.hide()
		$GUI/MainText.hide()
		$GUI/ExitButton.show()
		$GUI/ScoreCounter.show()
		$GUI/HighScoreMainCounter.hide()
		$Paddle.show()
	else:
		$GameOver.play()
	high_score_shown = false
	score_counter = 0
	$GUI.change_score(score_counter)
	$GUI/BeginText.show()
	$ResetTimer.start() # Start reset timer, this will display begin message
	
# Called when user hits exit
func exit_game():
	in_game = false
	score_counter = 0
	$GUI.change_high_score(high_score)
	$GUI.change_score(score_counter)
	if $Ball: remove_node($Ball)
	$GUI/StartButton.show()
	$GUI/MainText.show()
	$GUI/HighScoreMainCounter.show()
	$GUI/ExitButton.hide()
	$GUI/ScoreCounter.hide()
	$GUI/BeginText.hide()
	$Paddle.hide()
	
func remove_node(node):
	node.queue_free()
	remove_child(node)
	
func reset_game():
	if $Ball: remove_node($Ball)
	var ball = Ball.instance()
	ball.position = $Position2D.position
	ball.name = "Ball"
	add_child(ball)
	
func _on_Paddle_hit():
	$Boop.play()
	score_counter += 1
	if score_counter > high_score:
		high_score = score_counter
		save()
		if high_score_shown == false:	
			$GUI/HighScore.show()
			$HighScoreCounter.start()
			high_score_shown = true
	$GUI.change_score(score_counter)

func _on_ResetTimer_timeout():
	if in_game:	
		reset_game()
	$GUI/BeginText.hide()

func _on_HighScoreCounter_timeout():
	$GUI/HighScore.hide()

func save():
	var save_dict = {
		"high_score": high_score	
	}
	
	var save_game = File.new()
	save_game.open("user://high_score.save", File.WRITE)
	save_game.store_line(to_json(save_dict))
	save_game.close()

func load_game():
	var save_game = File.new()
	if !save_game.file_exists("user://high_score.save"):
        return 0
	save_game.open("user://high_score.save", File.READ)
	var current_line = parse_json(save_game.get_line())
	save_game.close()
	return current_line["high_score"]
	
	
