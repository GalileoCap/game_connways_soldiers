extends Node2D

var data

var height
var base

var record
var columns
var rows

var selected= null
var n= 0

func win():
	record+= 1
	data['record']+= 1
	data.save_data()	
	set_rc()
	rearrange()

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		for child in get_children():
			if 'square' in child.name and child.get_rect().has_point(child.to_local(event.position)):
				if selected == null:
					for i in get_children():
						if child.column == i.column and child.row == i.row and not child == i:
							print('SELECTED ', i.name)
							selected= i
				elif child.column == selected.column and child.row == selected.row and not child == selected:
					print('UNSELECT ', selected.name)
					selected= null
				else:
					var move= true
					for i in get_children():
						if child.column == i.column and child.row == i.row and not child == i:
							move= false

					var d_c= abs(child.column - selected.column)
					var d_r= abs(child.row - selected.row)
					if move and ((d_c == 2 and d_r == 0) or (d_c == 0 and d_r == 2)):
						for i in get_children():
							if i.column == selected.column+(child.column - selected.column)/2 and i.row == selected.row+(child.row-selected.row)/2 and not i == selected and not 'square' in i.name:
								print('MOVE ', selected.name)
								remove_child(i)

								selected.position= child.position
								selected.column= child.column
								selected.row= child.row

								if selected.row == 1:
									win()

								selected= null

								return
					else:
						for i in get_children():
							if child.column == i.column and child.row == i.row and not child == i:
								print('SELECTED ', i.name)
								selected= i

func set_rc():
	if record == 0:
		columns= 1
		rows= 3
	elif record == 1:
		columns= 3
		rows= 4
	elif record == 2:
		columns= 5
		rows= 5
	else:
		columns= 8
		rows= 10

func _start(d, r, f):
	height= get_node('../ui/panel').margin_top
	base= get_viewport().size.x
	
	data= d
	if f:
		data.first= false
		data.save_data()
	get_node('../ui').start(f, self)
	
	record= r
	
	set_rc()
	rearrange()

func instance_square(column, row):
	if record+1 < row:
		add_child(load('res://scenes/soldier.tscn').instance())
		var this_soldier= get_node('soldier')
		this_soldier.name= 'soldier_'+str(n)
		this_soldier.column= column
		this_soldier.row= row

	add_child(load('res://scenes/square.tscn').instance())
	var this_square= get_node('square')
	this_square.name= 'square_'+str(n)
	this_square.column= column
	this_square.row= row

	n+= 1

func rearrange(which= null, change= 0):
	n= 0
	for i in get_children():
		remove_child(i)

	if not which == null and ((which == 'rows' and 3 <= (rows+change)) or (which == 'columns' and 1 <= (columns+change))):
		print('CHANGE %s by %s' % [which, change])
		self[which]+= change

	for i in range(columns):
		for j in range(rows):
			instance_square(i+1, j+1)

	var d_h= height / rows
	var d_b= base / columns
	for child in get_children():
		child.position= Vector2((2*child.column-1)*base/(2*columns), (2*child.row-1)*height/(2*rows))
		var org_size= child.get_texture().get_size().x
		var scale= Vector2(d_b/org_size, d_h / org_size)
		if 'soldier' in child.name:
			scale= scale/2
		child.set_scale(scale)

	selected= null
