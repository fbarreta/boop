pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
centerx = 5
centery = 0
space = 2
size = 19
spr_k1 = 1
spr_c1 = 3
spr_cursor_k1 = 33
spr_cursor_c1 = 35
spr_cursor_k2 = 37
spr_cursor_c2 = 39
spr_k2 = 5
spr_c2 = 7
player = {
	x = 1,
	y = 0
}
player1 = {
	kittens = 8,
	cats = 0,
	cursortype = 'k'
}
player2 = {
	kittens = 8,
	cats = 0,
	cursortype = 'k'
}
mtx = {}
debug = ""
-->8
function _init()
	color(17)
	palt(0,true)
	fillmtx()
end

function _update()
	moveplayer()
end

function _draw()
	cls(7)
	drawgrid()
	drawplayer()
	drawui()
	//findboop()
	print(debug,0,122,8)
end
-->8
function drawplayer()
	local sprite = spr_cursor_c1;
	if player1.cursortype == 'k' then
		sprite = spr_cursor_k1
	else
		sprite = spr_cursor_c1
	end

	if mtx[player.x][player.y] == 0 then
		drawsprite(sprite,player.x,player.y)
	end
	rect(
	 centerx + space + (player.x*size) - 1,
		centery + space + (player.y*size) - 1,
		centerx + (player.x*size) + size + 1,
		centery + (player.y*size) + size + 1,
		8
	)
end

function drawgrid()
	rectfill(
	 centerx + space,
		centery + space,
		centerx + space + 112,
		centery + space + 112,
		1
	)
	rect(
	 centerx + space-1,
		centery + space-1,
		centerx + space + 113,
		centery + space + 113,
		1
	)
	for j = 0, 5 do
		for i = 0, 5 do
			rectfill(
			 centerx + space + (j*size),
				centery + space + (i*size),
				centerx + (j*size) + size,
				centery + (i*size) + size,
				12
			)
			if mtx[j][i] == 1 then
				drawsprite(spr_k1,j,i)
			end
		end
	end
end

function drawsprite(s, x, y)
	palt(3,true)
	palt(0,false)
	spr(
		s,
	 1 + centerx + space + (x*size),
		1 + centery + space + (y*size),
		2,
		2
	)
end

function drawui()
	local p1kittens = " kITTENS: ".. player1.kittens
	local p1cats = " cATS:    ".. player1.cats
	
	local p2kittens = " kITTENS: ".. player2.kittens
	local p2cats = " cATS:    ".. player2.cats

	print(p1kittens,2,117,9)
	print(p1cats,2,123,9)
	print(p2kittens,78,117,5)
	print(p2cats,78,123,5)
end
-->8
function moveplayer()
	if btnp(0) then
		if checkboundaries("l") then
			player.x -= 1
		end
	elseif btnp(1) then
		if checkboundaries("r") then
			player.x += 1
		end
	elseif btnp(2) then
		if checkboundaries("u") then
			player.y -= 1
		end
	elseif btnp(3) then
		if checkboundaries("d") then
			player.y += 1
		end
	end
	if btnp(4) then
		if canplace() then
			placepiece()
		end
	end
	if btnp(5) then
		changecursor()
	end
end

function changecursor()
	if player1.cursortype == 'k' then
		player1.cursortype = 'c'
	else
		player1.cursortype = 'k'
	end
end

function canplace()
	if player1.kittens > 0 then
		return true
	else
		return false
	end
end

function checkboundaries(dir)
	if (dir == "l") then
		if (player.x <= 0) then
			return false
		else
			//local fx = s.x - 1
			//if (mtx[fx][s.y] == -1) then
			//	return false
			//end
			return true
		end
	elseif (dir == "r") then
		if (player.x >= 5) then
			return false
		else
			//local fx = s.x + 1
			//if (mtx[fx][s.y] == -1) then
			//	return false
			//end
			return true
		end
	elseif (dir == "u") then
		if (player.y <= 0) then
			return false
		else
			//local fy = s.y - 1
			//if (mtx[s.x][fy] == -1) then
			//	return false
			//end
			return true
		end
	elseif (dir == "d") then
		if (player.y >= 5) then
			return false
		else
			//local fy = s.y + 1
			//if (mtx[s.x][fy] == -1) then
			//	return false
			//end
			return true
		end
	end
end
-->8
function fillmtx()
	for j = 0, 5 do
		mtx[j] = {}
		for i = 0, 5 do
			mtx[j][i] = 0
		end
	end
end

function placepiece()
	if mtx[player.x][player.y] == 0 then
		mtx[player.x][player.y] = 1
		removepiece()
		checkboop()
		local p = check3(1)
		if #p == 3 then
			promote(p)
		end
	end
end

function promote(p)
	for i = 1, #p do
		local x = p[i][1]
		local y = p[i][2]
		mtx[x][y] = 0
		player1.kittens += 1
	end
	player1.kittens -= 3
	player1.cats += 3
end

function removepiece()
	player1.kittens -= 1
end

function addpiece()
	player1.kittens += 1
end

function checkboop()
	if
		player.x <= 4 and
		mtx[player.x+1][player.y] == 1 then
			boop('r',player.x+1, player.y)
	end
	if
		player.x > 0 and
		mtx[player.x-1][player.y] == 1 then
			boop('l',player.x-1, player.y)
	end
	if
		player.y <= 4 and
		mtx[player.x][player.y+1] == 1 then
			boop('d',player.x, player.y+1)
	end
	if
		player.y >= 0 and
		mtx[player.x][player.y-1] == 1 then
			boop('u',player.x, player.y-1)
	end
	if
		player.y >= 0 and
		player.x <= 4 and
		mtx[player.x+1][player.y-1] == 1 then
			boop('ur',player.x+1, player.y-1)
	end
	if
		player.y >= 0 and
		player.x > 0 and
		mtx[player.x-1][player.y-1] == 1 then
			boop('ul',player.x-1, player.y-1)
	end
	if
		player.y <= 4 and
		player.x <= 4 and
		mtx[player.x+1][player.y+1] == 1 then
			boop('dr',player.x+1, player.y+1)
	end
	if
		player.y <= 4 and
		player.x > 0 and
		mtx[player.x-1][player.y+1] == 1 then
			boop('dl',player.x-1, player.y+1)
	end
end

function findboop()
	
	local rx = player.x + 1
	local ry = player.y
	rect(
	 center + space + (rx*size) - 1,
		center + space + (ry*size) - 1,
		center + (rx*size) + size + 1,
		center + (ry*size) + size + 1,
		10
	)
end

function boop(dir,x,y)
	if dir == 'r' then
		local fx = x + 1
		if	x < 5 then
			if mtx[fx][y] == 0 then
					mtx[x][y] = 0
					mtx[fx][y] = 1
			end
		elseif x == 5 then
			mtx[x][y] = 0
			addpiece()
		end
	end
	if dir == 'l' then
		local fx = x - 1
		if	x > 0 then
			if mtx[fx][y] == 0 then
					mtx[x][y] = 0
					mtx[fx][y] = 1
			end
		elseif x == 0 then
			mtx[x][y] = 0
			addpiece()
		end
	end
	if dir == 'd' then
		local fy = y + 1
		if	y < 5 then
			if mtx[x][fy] == 0 then
					mtx[x][y] = 0
					mtx[x][fy] = 1
			end
		elseif y == 5 then
			mtx[x][y] = 0
			addpiece()
		end
	end
	if dir == 'u' then
		local fy = y - 1
		if	y > 0 then
			if mtx[x][fy] == 0 then
					mtx[x][y] = 0
					mtx[x][fy] = 1
			end
		elseif y == 0 then
			mtx[x][y] = 0
			addpiece()
		end
	end
	if dir == 'ur' then
		local fy = y - 1
		local fx = x + 1
		if	y > 0 and x < 5 then
			if mtx[fx][fy] == 0 then
					mtx[x][y] = 0
					mtx[fx][fy] = 1
			end
		elseif fy <= 0 or fx >= 5 then
			mtx[x][y] = 0
			addpiece()
		end
	end
	if dir == 'ul' then
		local fy = y - 1
		local fx = x - 1
		if	y > 0 and x > 0 then
			if mtx[fx][fy] == 0 then
					mtx[x][y] = 0
					mtx[fx][fy] = 1
			end
		elseif fy <= 0 or fx >= 0 then
			mtx[x][y] = 0
			addpiece()
		end
	end
	if dir == 'dr' then
		local fy = y + 1
		local fx = x + 1
		if	y > 0 and x < 5 then
			if mtx[fx][fy] == 0 then
					mtx[x][y] = 0
					mtx[fx][fy] = 1
			end
		elseif fy >= 5 or fx >= 5 then
			mtx[x][y] = 0
			addpiece()
		end
	end
	if dir == 'dl' then
		local fy = y + 1
		local fx = x - 1
		if	y > 0 and x > 0 then
			if mtx[fx][fy] == 0 then
					mtx[x][y] = 0
					mtx[fx][fy] = 1
			end
		elseif fy >= 5 or fx <= 0 then
			mtx[x][y] = 0
			addpiece()
		end
	end
end
-->8
function check3(p)
	local cols, rows = 5, 5
	for x = 0, rows do
		for y = 0, cols do
			if y + 2 < cols then
				if mtx[x][y] == p and
							mtx[x][y+1] == p and
							mtx[x][y+2] == p then
								return {{x, y},{x,y+1},{x,y+2}}
				end
			end
			if x + 2 < rows then
				if mtx[x][y] == p and
							mtx[x+1][y] == p and
							mtx[x+2][y] == p then
								return {{x, y},{x+1,y},{x+2,y}}
				end
			end
			if x + 2 < rows and y + 2 < cols then
				if mtx[x][y] == p and
							mtx[x+1][y+1] == p and
							mtx[x+2][y+2] == p then
								return {{x, y},{x+1,y+1},{x+2,y+2}}
				end
			end
			if x + 2 < rows and y - 2 >= 0 then
				if mtx[x][y] == p and
							mtx[x+1][y-1] == p and
							mtx[x+2][y-2] == p then
								return {{x, y},{x+1,y-1},{x+2,y-2}}
				end
			end
		end
	end
	return {{9,8}}
end
__gfx__
00000000303333303333333333330333333033333033333033333333333303333330333300000000000000000000000000000000000000000000000000000000
000000000f03330f033333333330f033330f03330603330603333333333060333306033300000000000000000000000000000000000000000000000000000000
007007000f90009f033333333330f900009f03330650005603333333333065000056033300000000000000000000000000000000000000000000000000000000
000770000ff999ff033300333309ff9999ff90330665556603330033330566555566503300000000000000000000000000000000000000000000000000000000
000770000fffffff03307703330ffffffffff0330666666603307703330666666666603300000000000000000000000000000000000000000000000000000000
00700700090fff0903307ff0309f0ffffff0f9030506660503307660305606666660650300000000000000000000000000000000000000000000000000000000
000000000fff0fff03330f9030fefff00fffef030666066603330650306e66600666e60300000000000000000000000000000000000000000000000000000000
0000000009f070f9033330f030ffff0ff0ffff030560706503333060306666066066660300000000000000000000000000000000000000000000000000000000
00000000309ffff003333090099ffffffffff9903056666003333050055666666666655000000000000000000000000000000000000000000000000000000000
0000000033099999f03330f009fffff77fffff903305555560333060056666677666665000000000000000000000000000000000000000000000000000000000
00000000330f99f9f90009f00fffff7777fffff03306556565000560066666777766666000000000000000000000000000000000000000000000000000000000
00000000330fff9f9f90ff0309ffff7777ffff903306665656506603056666777766665000000000000000000000000000000000000000000000000000000000
00000000330ffffff9f000333099fff77fff99033306666665600033305566677666550300000000000000000000000000000000000000000000000000000000
00000000330ff0ff0ff03333309ffffffffff9033306606606603333305666666666650300000000000000000000000000000000000000000000000000000000
000000003307707707703333330770ffff0770333307707707703333330770666607703300000000000000000000000000000000000000000000000000000000
00000000330000000000333333000000000000333300000000003333330000000000003300000000000000000000000000000000000000000000000000000000
000000003f33333f333333333333f333333f33333633333633333333333363333336333300000000000000000000000000000000000000000000000000000000
00000000fff333fff3333333333fff3333fff3336663336663333333333666333366633300000000000000000000000000000000000000000000000000000000
00000000fffffffff3333333333ffffffffff3336666666663333333333666666666633300000000000000000000000000000000000000000000000000000000
00000000fffffffff333ff3333ffffffffffff336666666663336633336666666666663300000000000000000000000000000000000000000000000000000000
00000000fffffffff33ffff333ffffffffffff336666666663366663336666666666663300000000000000000000000000000000000000000000000000000000
00000000fffffffff33fffff3ffffffffffffff36666666663366666366666666666666300000000000000000000000000000000000000000000000000000000
00000000fffffffff333ffff3ffffffffffffff36666666663336666366666666666666300000000000000000000000000000000000000000000000000000000
00000000fffffffff3333fff3ffffffffffffff36666666663333666366666666666666300000000000000000000000000000000000000000000000000000000
000000003ffffffff3333fffffffffffffffffff3666666663333666666666666666666600000000000000000000000000000000000000000000000000000000
0000000033ffffffff333fffffffffffffffffff3366666666333666666666666666666600000000000000000000000000000000000000000000000000000000
0000000033ffffffffffffffffffffffffffffff3366666666666666666666666666666600000000000000000000000000000000000000000000000000000000
0000000033fffffffffffff3ffffffffffffffff3366666666666663666666666666666600000000000000000000000000000000000000000000000000000000
0000000033ffffffffffff333ffffffffffffff33366666666666633366666666666666300000000000000000000000000000000000000000000000000000000
0000000033ffffffffff33333ffffffffffffff33366666666663333366666666666666300000000000000000000000000000000000000000000000000000000
0000000033ffffffffff333333ffffffffffff333366666666663333336666666666663300000000000000000000000000000000000000000000000000000000
0000000033ffffffffff333333ffffffffffff333366666666663333336666666666663300000000000000000000000000000000000000000000000000000000
__sfx__
0001000000000010500405007050090500c0500f05011050140501605018050190501a0501c050000001d0501f050200501f0501d0501b0500000019050160501305010050000000000000000000000000000000
