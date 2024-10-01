# https://dmitrytsepelev.dev/terminal-game

require_relative 'level_builder'
require_relative 'screen'

class Game
  SLEEP_INTERVAL = 0.2

  def run
    screen = Screen.new

    @level = LevelBuilder.new("./map.txt").build

    loop do
      move_enemies
      screen.render_level(@level)

      case check_collision(@level.player.row_idx, @level.player.col_idx, @level.enemies)
      when :enemy
        screen.render_death_message
        break
      end

      new_player_position = DynamicObject.new(@level.player.row_idx, @level.player.col_idx)
      new_player_position.move(get_pressed_key)

      case check_collision(new_player_position.row_idx, new_player_position.col_idx, @level.enemies + [@level.door])
      when :door
        screen.render_level_passed_message
        break
      when :enemy
        screen.render_death_message
        break
      when nil
        @level.player = new_player_position
      end

      sleep SLEEP_INTERVAL
    end
  end

  private

  def move_enemies
    @level.enemies.each_with_index do |enemy, idx|
      next if rand(1) > 0.8

      new_enemy = DynamicObject.new(enemy.row_idx, enemy.col_idx, :enemy)
      new_enemy.move([RIGHT, LEFT, UP, DOWN].sample)
      @level.enemies[idx] = new_enemy if check_collision(new_enemy.row_idx, new_enemy.col_idx, [@level.door, @level.player]).nil?
    end
  end

  def check_collision(row_idx, col_idx, objects)
    return :out_of_border if row_idx < 0 || row_idx >= @level.map.length || col_idx < 0 || col_idx >= @level.map[0].length
    return :tree if @level.map[row_idx][col_idx] == TREE
    objects.find { _1.row_idx == row_idx && _1.col_idx == col_idx }&.kind
  end

  def get_pressed_key
    begin
      system('stty raw -echo')
      (STDIN.read_nonblock(4).ord rescue nil)
    ensure
      system('stty -raw echo')
    end
  end

  def draw_screen
    system "clear"
  
    @level.map.each_with_index do |row, row_idx|
      row.each_with_index do |cell, col_idx|
        if @level.player.row_idx == row_idx && @level.player.col_idx == col_idx
          print PLAYER
        elsif @level.door.row_idx == row_idx && @level.door.col_idx == col_idx
          print DOOR
        elsif @level.enemies.find { |enemy| enemy.row_idx == row_idx && enemy.col_idx == col_idx }
          print ENEMY
        else
          print cell
        end
      end
      puts "\n"
    end
  end
end

Game.new.run