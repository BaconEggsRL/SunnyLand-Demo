extends Node


const SAVE_PATH = "res://savegame.bin"

func resetGame():
	var hp = 10
	var gold = 0
	saveGame(hp, gold)
	loadGame()

func saveGame(hp:int = Game.playerHP, gold:int = Game.playerGold):
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerHP": hp,
		"playerGold": gold,
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)
	
func loadGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH):
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line: # returns null if parsing failed
				Game.playerHP = current_line["playerHP"]
				Game.playerGold = current_line["playerGold"]
