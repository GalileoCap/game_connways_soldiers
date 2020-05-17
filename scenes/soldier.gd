extends Sprite

var column
var row

func style(which):
	var ab
	if (column % 2 == 0 and row % 2 == 1) or (column % 2 == 1 and row % 2 == 0):
		ab= 'a'
	else:
		ab= 'b'
	set_texture(load('res://resources/'+which+'/soldier_'+ab+'.png'))
