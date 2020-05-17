extends Node2D

func _process(_delta):
	$controls/record.text= str(get_node('../data')['record'])
	$controls/moves.text= ' IN '+str(get_node('../data')['moves'])+' MOVES'

func _ready():
	$menu.hide()
	$rules.hide()
	
#	$controls.margin_top= get_viewport().size.y*976/1280
	
	$controls/columns/add_columns.connect('pressed', get_node('../board'), 'rearrange', ['columns', 1])
	$controls/columns/remove_columns.connect('pressed', get_node('../board'), 'rearrange', ['columns', -1])
	$controls/rows/add_rows.connect('pressed', get_node('../board'), 'rearrange', ['rows', 1])
	$controls/rows/remove_rows.connect('pressed', get_node('../board'), 'rearrange', ['rows', -1])
	$controls/restart.connect('pressed', get_node('../board'), 'rearrange')
	$menu/save.connect('pressed', get_node('../board'), 'save_board')
	$menu/style_checkers.connect('pressed', get_node('../board'), 'style', ['checkers'])
	$menu/style_soldiers.connect('pressed', get_node('../board'), 'style', ['soldiers'])
	$menu/style_cats.connect('pressed', get_node('../board'), 'style', ['cats'])

func rules():
	$rules.visible= not $rules.visible
	if $rules.visible:
		get_tree().paused= true
	else:
		get_tree().paused= false

func menu():
	get_tree().paused= not get_tree().paused
	$menu.visible= not $menu.visible
	$menu/confirmation.hide()

func delete_a():
	$menu/confirmation.show()

func delete_b():
	get_tree().paused= false
	$menu.hide()
	$menu/confirmation.hide()
	get_node('../data').wipe_data()
