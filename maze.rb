class Maze

  # x and y are stored as maze[y][x]
  def initialize(n ,m)
    @n = n
    @m = m
    # @maze = Array.new(n) {Array.new(m, 1)}
  end

  def load(arg)
    if(arg.length != (2*@n + 1)*(2*@m + 1))
      -1
    else
      @maze = arg.split("").each_slice(2*@n + 1).to_a
    end
  end

  def display
    if(@maze.nil?)
      puts "No maze was initialized"
    else
      display_maze(@maze)
    end
  end

  def display_maze(maze)
    maze.length.times do |i|
      row = maze[i]
      display_row(row, i.even?)
    end
  end

  def display_row(row, even_row)
    row_display = ""
    row.each_with_index do |cell, j|
      if cell == '0'
        row_display << " "
      elsif cell == '*'
        row_display << '*'
      else
        if even_row
          if j.even?
            row_display << '+'
          else
            row_display << '-'
          end
        else
          row_display << '|'
        end
      end
    end
    puts row_display
  end

  def solve(begX, begY, endX, endY)
    solution(begX, begY, endX, endY, false)
  end

  def trace(begX, begY, endX, endY)
    solution(begX, begY, endX, endY, true)
  end

  def solution(begX, begY, endX, endY, trace)
    m = Marshal.load(Marshal.dump(@maze))

    return false if(m[begY][begX] == '1' || m[endY][endX] == '1')

    return true if searchForPath(begX, begY, endX, endY, m, trace)

    return false
  end

  def searchForPath(curX, curY, endX, endY, maze, trace)
    maze[curY][curX] = '*'

    if trace
      # puts "#{curX}, #{curY}, #{endX}, #{endY}"
      display_maze(maze)
    end

    return true if(curX == endX && curY == endY)

    return true if searchForPath(curX - 2, curY, endX, endY, maze, trace) if(curX > 1 && maze[curY][curX - 1] == '0' && maze[curY][curX - 2] == '0')
    return true if searchForPath(curX + 2, curY, endX, endY, maze, trace) if(curX < (2*@n + 1) - 1 && maze[curY][curX + 1] == '0' && maze[curY][curX + 2] == '0')
    return true if searchForPath(curX, curY - 2, endX, endY, maze, trace) if(curY > 2 && maze[curY - 1][curX] == '0' && maze[curY - 2][curX] == '0')
    return true if searchForPath(curX, curY + 2, endX, endY, maze, trace) if(curY < (2*@m + 1) - 1 && maze[curY + 1][curX] == '0' && maze[curY + 2][curX] == '0')
  end

  def redesign()
    @maze = Array.new(2*@m+1) {Array.new(2*@n+1, 1)}
    (1..(2*@n-1)).each do |i|
      (1..(2*@m-1)).each do |j|
        if(i.odd? && j.odd?)
          @maze[j][i] = "0"
        elsif((j.even? && i.odd?) || (j.odd? && i.even?))
          @maze[j][i] = rand(2).to_s
        end
      end
    end
  end

end

puts "Initialize"
m = Maze.new(4, 4)
puts m.inspect
puts "Load"
m.load("111111111100010001111010101100010101101110101100000101111011101100000101111111111")
m.display
puts "Solve"
puts m.solve(1, 1, 7, 7)
puts "Trace"
m.trace(1, 1, 7, 7)
5.times do
  puts "Redesign"
  m.redesign
  m.display
end




