#******************************************************************************
#CONFIG
extends Node
const data_path= 'user://connway_data.cfg'

#******************************************************************************
#DATA
var first= true
var record= 0

#******************************************************************************
#UTILS
func get_data():
	var r= {
		'data': {
			'first': first,
			'record': record
			},
	}
	return r

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		save_data()
		get_tree().quit()

#******************************************************************************
#CODE
func _ready():
	load_data()
	get_node('../board')._start(self, record, first)

func save_data():
	print('SAVING DATA')
	var config= ConfigFile.new()
	var data_to_save= get_data()
	for i in data_to_save.keys():
		for j in data_to_save[i].keys():
			config.set_value(i, j, data_to_save[i][j])
	config.save(data_path)

func load_data():
	var config= ConfigFile.new()
	var err= config.load(data_path)
	print(err)
	if not err == OK:
		print('CREATING SAVEFILE')
		save_data()
		load_data()
	else:
		print('LOADING DATA')
		var data_to_save= get_data()
		for i in data_to_save.keys():
			for j in data_to_save[i].keys():
				self[j]= config.get_value(i, j)

func wipe_data():
	print('WIPING DATA')
	var dir= Directory.new()
	dir.remove(data_path)
	
	first= true
	record= 0
	
	_ready()
