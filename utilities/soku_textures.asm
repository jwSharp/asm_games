# author Jacob Sharp

.data
tex_player: .byte
	13  3 13  3 13
	13 13 13 13 13
	3  13 13 13  3
	13  3  3  3 13
	13 13 13 13 13

tex_wall: .byte
	9  10 10  9  9
	9   9 10 10  9
	9   9  9 10 10
	10  9  9  9 10
	10 10  9  9  9

tex_block_on_target: .byte
	6  6  6  6  6
	6  6 -1  6  6
	6 -1  6 -1  6
	6  6 -1  6  6
	6  6  6  6  6

tex_block: .byte
	8  8  8  8  8
	8  8 -1  8  8
	8 -1  8 -1  8
	8  8 -1  8  8
	8  8  8  8  8

tex_target: .byte
	-1 -1 -1 -1 -1
	-1  3 -1  3 -1
	-1 -1  3 -1 -1
	-1  3 -1  3 -1
	-1 -1 -1 -1 -1