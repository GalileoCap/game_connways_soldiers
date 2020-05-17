extends Node2D

func start(f, b):
	$panel/columns/add_columns.connect('pressed', b, 'rearrange', ['columns', 1])
	$panel/columns/remove_columns.connect('pressed', b, 'rearrange', ['columns', -1])
	$panel/rows/add_rows.connect('pressed', b, 'rearrange', ['rows', 1])
	$panel/rows/remove_rows.connect('pressed', b, 'rearrange', ['rows', -1])
	$panel/restart.connect('pressed', b, 'rearrange')
	
	if f:
		rules()

func rules():
	print('IMPLEMENT RULES')


func menu():
	print('IMPLEMENT MENU')
