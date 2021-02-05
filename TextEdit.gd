extends Control

onready var textEdit = $TextEdit
onready var vBox = $VBox

var data = {}
var itemsDictionary = {}
var buttonsArray = []


func _ready():
	var resultJson
	var jsonPath = "res://published_episodes.json"
	var file = File.new()
	file.open(jsonPath , file.READ)
	var text = file.get_as_text()
	file.close()
	resultJson = JSON.parse(text)
	data = resultJson.result
	data = data["episodes"]


func _on_TextEdit_text_changed():
	for i in data:
		if data[i].find(textEdit.text,0) != -1:
			if itemsDictionary.has(i) == false:
				var button = preload("res://Button.tscn").instance(PackedScene.GEN_EDIT_STATE_DISABLED)
				vBox.add_child(button)
				button.connect("pressed",self,"_on_Button_pressed",[data[i]])
				button.add_to_group("buttons")
				vBox.rect_size.y += button.rect_size.y
				button.text = data[i]
				itemsDictionary[i] = button
		else:
			if itemsDictionary.has(i):
				var b = itemsDictionary[i]
				b.queue_free()
				itemsDictionary.erase(i)
	if textEdit.text == "":
		itemsDictionary.clear()

func _on_Button_pressed(value):
	textEdit.text = value
	get_tree().call_group("buttons","queue_free")
	itemsDictionary.clear()
