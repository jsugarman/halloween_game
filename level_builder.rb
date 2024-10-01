PLAYER, ENEMY, DOOR, TREE, SPACE = '🧙', '👻', '🚪', '🌲', "・"

Level = Struct.new(:map, :enemies, :player, :door)

UP, DOWN, RIGHT, LEFT = 119, 115, 100, 97

DynamicObject = Struct.new(:row_idx, :col_idx, :kind) do
  def move(dir)
    case dir
    when RIGHT then self.col_idx += 1
    when LEFT then self.col_idx -= 1
    when UP then self.row_idx -= 1
    when DOWN then self.row_idx += 1
    end
  end
end

class LevelBuilder
  def initialize(filepath)
    @filepath = filepath
  end

  MAPPING = { 't' => TREE, 's' => SPACE }

  def build
    Level.new.tap do |level|
      level.enemies = []

      level.map = File.readlines(@filepath).map.with_index do |line, row_idx|
        line.chars.map.with_index do |c, col_idx|
          case c
          when 'e'
            level.enemies << DynamicObject.new(row_idx, col_idx, :enemy)
            SPACE
          when 'p'
            level.player = DynamicObject.new(row_idx, col_idx, :player)
            SPACE
          when 'd'
            level.door = DynamicObject.new(row_idx, col_idx, :door)
            SPACE
          else
            MAPPING[c]
          end
        end
      end
    end
  end
end
