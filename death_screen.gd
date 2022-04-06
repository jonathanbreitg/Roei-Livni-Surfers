extends Control
var is_paused = false setget set_is_paused
var mouse_sensitivity = 0.3
var high_score = 0
var curr_score = 0
var username = ""
var leaderboard = []
var leaderboard_str = ""
export(int) var LIMIT = 10
var current_text = ''
var cursor_line = 0
var cursor_column = 0
var text_to_enter = ""
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		self.is_paused = !is_paused


func set_is_paused(value):
	is_paused = value
	$ColorRect2/leaderboard_Text.text = "connecting to server..."
	get_tree().paused = is_paused
	visible = is_paused
	leaderboard = []
	leaderboard_str = ""
	$ColorRect2/Trophy.visible = false
	$ColorRect2/Multiplayer.visible = true
	curr_score = get_parent().score
	print(curr_score)
	$score.text = str(curr_score)
	print(username)
	$HTTPRequest.request("https://roei-livni-surfers-server2.jonathanbreitg.repl.co/get_leaderboard")
	if curr_score > high_score:
		print("NEW HIGHSCORE!")
		high_score = curr_score
		$high_score.text = str(high_score)
		if username == "":
			$text_label2/set_username_text.visible = true
		else:
			var data_to_send = {"data" : [username,high_score]}
			var query = JSON.print(data_to_send)
			print("query is",query)
			var headers = ["Content-Type: application/json","Access-Control-Allow-Credentials: true","Access-Control-Allow-Origin: *"]
			$HTTPRequest_post.request("https://roei-livni-surfers-server2.jonathanbreitg.repl.co/upload_score",headers,false, HTTPClient.METHOD_POST, query)




func _on_Button_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	self.is_paused = false
	get_parent().global_transform.origin.x = 0
	get_parent().global_transform.origin.y = 5.864
	get_parent().global_transform.origin.z = 0
	get_parent().get_parent().get_parent().reset_level()
	get_parent().score = 0
	get_parent().raw_score = 0
	get_parent().speed = -7


func dict_to_array(dic):
	var dictionary = dic# someDictionary
	var arrayOfKeyValuePairs: Array = [] # array of pairs, each pair is an array with 2 elements: [key, value]
	for key in dictionary:
		var keyValuePair: Array = [key, dictionary[key]]
		arrayOfKeyValuePairs.append(keyValuePair)
	return arrayOfKeyValuePairs


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print("GOT BACK REQUEST/REPONSE")
	print(response_code)
	if response_code == 200:
		print(json)
		print(json.result)
		leaderboard = dict_to_array(json.result)
		print(leaderboard)
		leaderboard.sort_custom(self,"custom_comparison")
		print(leaderboard)
		for pair in leaderboard:
			leaderboard_str += str(pair[0]) + ": " + str(pair[1]) + "\n"
		$ColorRect2/leaderboard_Text.text = str(leaderboard_str)
		$ColorRect2/Trophy.visible = true
		$ColorRect2/Multiplayer.visible = false
	else:
		$ColorRect2/leaderboard_Text.text = "problems connecting to the server....."
	$HTTPRequest.cancel_request()


func custom_comparison(a,b):
	if a[1] > b[1]:
		return a > b
	else:
		return b > a
	


func _on_HTTPRequest_post_request_completed(result, response_code, headers, body):
	leaderboard= []
	leaderboard_str = ""
	var json = JSON.parse(body.get_string_from_utf8())
	print("GOT BACK REQUEST/REPONSE")
	print(response_code)
	if response_code == 200:
		print(json)
		print(json.result)
		leaderboard = dict_to_array(json.result)
		print(leaderboard)
		leaderboard.sort_custom(self,"custom_comparison")
		print(leaderboard)
		for pair in leaderboard:
			leaderboard_str += str(pair[0]) + ": " + str(pair[1]) + "\n"
		$ColorRect2/leaderboard_Text.text = str(leaderboard_str)
	else:
		$ColorRect2/leaderboard_Text.text = "problems connecting to the server....."


func _on_change_username_button_pressed():
	$change_username_button.visible = false
	$text_label2/Label.visible = false
	$text_label2/TextEdit.visible = false
	print("changed username")
	if !$text_label2/TextEdit.text == "":
		username = $text_label2/TextEdit.text
	var data_to_send = {"data" : [username,high_score]}
	var query = JSON.print(data_to_send)
	print("query is",query)
	var headers = ["Content-Type: application/json","Access-Control-Allow-Credentials: true","Access-Control-Allow-Origin: *"]
	$HTTPRequest_post.request("https://roei-livni-surfers-server2.jonathanbreitg.repl.co/upload_score",headers,false, HTTPClient.METHOD_POST, query)

func _on_TextEdit_text_changed():
	$change_username_button.visible = true
	$text_label2/set_username_text.visible = false

	var new_text : String = $text_label2/TextEdit.text
	if new_text.length() > LIMIT:
		$text_label2/TextEdit.text = current_text
		# when replacing the text, the cursor will get moved to the beginning of the
		# text, so move it back to where it was 
		$text_label2/TextEdit.cursor_set_line(cursor_line)
		$text_label2/TextEdit.cursor_set_column(cursor_column)

	current_text = $text_label2/TextEdit.text
	# save current position of cursor for when we have reached the limit
	cursor_line = $text_label2/TextEdit.cursor_get_line()
	cursor_column = $text_label2/TextEdit.cursor_get_column()





func _on_TextEdit_focus_entered():
	text_to_enter = JavaScript.eval("prompt('%s', '%s');" % ["Please enter text:", text_to_enter], true)
	release_focus()
	print(text_to_enter)
	username = text_to_enter
	$change_username_button.visible = true
