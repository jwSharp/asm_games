# Jacob Sharp
# jws146

# Directions
.eqv DIR_N 0
.eqv DIR_E 1
.eqv DIR_S 2
.eqv DIR_W 3

# Grid
.eqv GRID_CELL_SIZE 4 # pixels
.eqv GRID_WIDTH  16 # cells
.eqv GRID_HEIGHT 14 # cells
.eqv GRID_CELLS 224 # = GRID_WIDTH * GRID_HEIGHT

# Snake
.eqv SNAKE_MAX_LEN GRID_CELLS # max snake length
.eqv SNAKE_MOVE_DELAY 12 # frames between movements

# Apples
.eqv APPLES_NEEDED 20 # apples to win

# ------------------------------------------------------------------------------------------------

.data
	# Game State
	lost_game: .word 0 # 1 if player lost game
	
	# Snake Attributes
	snake_dir: .word DIR_N 				# the direction the snake is facing (# Directions)
	snake_len: .word 2 					# snake length in segments
	snake_x: .byte 0 : SNAKE_MAX_LEN
	snake_y: .byte 0 : SNAKE_MAX_LEN
	snake_move_timer: .word 0 			# pause before move
	snake_dir_changed: .word 0 			# 1 if the snake changed direction since last move
	
	# Apples
	apples_eaten: .word 0 				# how many apples have been eaten.
	apple_x: .word 3 					# coordinates of the (displayed) apple
	apple_y: .word 2
	
	# A pair of arrays, indexed by direction, to turn a direction into x/y deltas.
	# e.g. direction_delta_x[DIR_E] is 1, because moving east increments X by 1.
	#                         N  E  S  W
	direction_delta_x: .byte  0  1  0 -1
	direction_delta_y: .byte -1  0  1  0

.text

# ------------------------------------------------------------------------------------------------

# Display
.include "display_2211_0822.asm"
.include "textures.asm"
.text

# ------------------------------------------------------------------------------------------------

.globl main
main:
	jal setup_snake

	# pause for user to move
	jal wait_for_game_start

	_loop: # main game loop
		jal check_input
		jal update_snake
		jal draw_all
		jal display_update_and_clear
		jal wait_for_next_frame
		jal check_game_over
		
		beq v0, 0, _loop

	jal show_game_over_message
syscall_exit

# ------------------------------------------------------------------------------------------------
# Misc game logic
# ------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------------

# waits for the user to press a key to start the game
wait_for_game_start:
enter
	_loop: # while no keys are pressed
		jal draw_all
		jal display_update_and_clear
		jal wait_for_next_frame
		jal input_get_keys_pressed
		
		beq v0, 0, _loop
leave

# ------------------------------------------------------------------------------------------------

# returns 1 if the game is over
check_game_over:
enter
	li v0, 0

	# check if enough apples have been eaten
	lw t0, apples_eaten
	blt t0, APPLES_NEEDED, _endif
		li v0, 1
		j _return
	_endif:

	# update lost_game
	lw t0, lost_game
	beq t0, 0, _return
		li v0, 1
	
	_return: # return v0
leave

# ------------------------------------------------------------------------------------------------

show_game_over_message:
enter
	# clear display
	jal display_update_and_clear

	# check if game was lost
	lw t0, lost_game
	bne t0, 0, _lost # game won
		# display 1st line
		li   a0, 7
		li   a1, 25
		lstr a2, "yay! you"
		li   a3, COLOR_GREEN
		jal  display_draw_colored_text

		# display 2nd line
		li   a0, 12
		li   a1, 31
		lstr a2, "did it!"
		li   a3, COLOR_GREEN
		jal  display_draw_colored_text

		j _endif
	
	_lost: # game lost
		# display centered line
		li   a0, 5
		li   a1, 30
		lstr a2, "oh no :("
		li   a3, COLOR_RED
		jal  display_draw_colored_text
	
	_endif:

	jal display_update_and_clear
leave

# ------------------------------------------------------------------------------------------------
# Snake
# ------------------------------------------------------------------------------------------------

# sets up the snake so the first two segments are in the middle of the screen.
setup_snake:
enter
	# snake head in the middle, tail below it
	li  t0, GRID_WIDTH
	div t0, t0, 2
	sb  t0, snake_x
	sb  t0, snake_x + 1

	li  t0, GRID_HEIGHT
	div t0, t0, 2
	sb  t0, snake_y
	add t0, t0, 1
	sb  t0, snake_y + 1
leave

# ------------------------------------------------------------------------------------------------

# checks for the arrow keys to change the snake's direction.
check_input:
enter
	# TODO
leave

# ------------------------------------------------------------------------------------------------

update_snake:
enter
	# TODO
leave

# ------------------------------------------------------------------------------------------------

move_snake:
enter
	# TODO
leave

# ------------------------------------------------------------------------------------------------

shift_snake_segments:
enter
	# TODO
leave

# ------------------------------------------------------------------------------------------------

move_apple:
enter
	# TODO
leave

# ------------------------------------------------------------------------------------------------

compute_next_snake_pos:
enter
	lw t9, snake_dir

	# v0 = direction_delta_x[snake_dir]
	lb v0, snake_x
	lb t0, direction_delta_x(t9)
	add v0, v0, t0

	# v1 = direction_delta_y[snake_dir]
	lb v1, snake_y
	lb t0, direction_delta_y(t9)
	add v1, v1, t0
leave # return v0, v1

# ------------------------------------------------------------------------------------------------

# a0 = x, a1 = y
# returns if coordinate is on the snake
is_point_on_snake:
enter
	# for i = 0 to snake_len
	li t9, 0
	_loop:
		lb t0, snake_x(t9)
		bne t0, a0, _differ
		lb t0, snake_y(t9)
		bne t0, a1, _differ # check if on snake
			# coordinate on snake
			li v0, 1
			j _return

		_differ:
		
		# increment loop
		add t9, t9, 1
		lw  t0, snake_len
		blt t9, t0, _loop
	
	# coordinate not on snake
	li v0, 0
_return:
leave # return v0



# Drawing functions
# ------------------------------------------------------------------------------------------------

draw_all:
enter
	# check if lost
	lw t0, lost_game
	bne t0, 0, _return
		# draw
		jal draw_snake
		jal draw_apple
		jal draw_hud

_return:
leave

# ------------------------------------------------------------------------------------------------

draw_snake:
enter
	# TODO
leave

# ------------------------------------------------------------------------------------------------

draw_apple:
enter
	# apple coordinates
	lw t0, apple_x
	mul a0, t0, GRID_CELL_SIZE
	lw t0 apple_y
	mul a1, t0, GRID_CELL_SIZE

	# texture
	la a2, tex_apple
	
	jal display_blit_5x5_trans
leave

# ------------------------------------------------------------------------------------------------

draw_hud:
enter
	# draw a horizontal line above the HUD showing the lower boundary of the playfield
	li  a0, 0
	li  a1, GRID_HEIGHT
	mul a1, a1, GRID_CELL_SIZE
	li  a2, DISPLAY_W
	li  a3, COLOR_WHITE
	jal display_draw_hline

	# draw apples collected out of remaining
	li a0, 1
	li a1, 58
	lw a2, apples_eaten
	jal display_draw_int

	li a0, 13
	li a1, 58
	li a2, '/'
	jal display_draw_char

	li a0, 19
	li a2, 58
	li a2, APPLES_NEEDED
	jal display_draw_int
leave