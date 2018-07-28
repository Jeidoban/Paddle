extends CanvasLayer
signal exit_pressed
signal start_pressed

func _ready():
	$ScoreCounter.hide()
	$ExitButton.hide()
	$BeginText.hide()
	$HighScore.hide()
	
func change_score(score):
	$ScoreCounter.set_text(str(score))
	
func change_high_score(score):
	$HighScoreMainCounter.set_text(str(score))

func _on_ExitButton_pressed():
	emit_signal("exit_pressed")

func _on_StartButton_pressed():
	emit_signal("start_pressed")
