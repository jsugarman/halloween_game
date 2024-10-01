class Screen
  def render_level(level)
    system "clear"

    level.map.each_with_index do |row, row_idx|
      row.each_with_index do |cell, col_idx|
        if level.player.row_idx == row_idx && level.player.col_idx == col_idx
          print PLAYER
        elsif level.door.row_idx == row_idx && level.door.col_idx == col_idx
          print DOOR
        elsif level.enemies.find { |enemy| enemy.row_idx == row_idx && enemy.col_idx == col_idx }
          print ENEMY
        else
          print cell
        end
      end
      puts "\n"
    end
  end

  def render_death_message = puts "☠️ You died ☠️"
  def render_level_passed_message = puts "🎉 Level passed 🎉"
end