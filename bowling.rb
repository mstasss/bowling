require 'rspec/autorun'

class BowlingGame
  attr_accessor :score, :max

  MAX = 10

  def initialize(*args)
    @all_frames = [*args]
    @score = 0

  end

  def calculate_score
    return 300 if perfect_score?
    @all_frames.each_with_index do |frame, index|
      if index < MAX - 1
        if strike?(frame)
          calculate_strike(frame,index)
        elsif spare?(frame)
          calculate_spare(frame,index)
        else
          @score += frame[0].to_i + frame[1].to_i
        end
      else
        calculate_last_frame(frame,index)
      end
    end

    @score
  end


  def perfect_score?
    @all_frames.all? { |frame| frame.include?('X') }
  end

  def strike?(frame)
    frame[0] == 'X'
  end

  def spare?(frame)
    frame[1] == '/'
  end

  def calculate_spare(frame,index)
    @score += 10
    if index + 1 < MAX
      next_frame = @all_frames[index + 1]
      @score += next_frame[0] == 'X' ? 10 : next_frame[0].to_i
    else
      @score += frame[0].to_i + frame[1].to_i
    end
  end

  def calculate_strike(frame,index)
    @score += 10
    if index + 1 < MAX
    next_frame = @all_frames[index + 1]
      if next_frame[0] == 'X'
        @score += 10
          if index + 2 < MAX
            next_next_frame = @all_frames[index + 2]
            @score += next_next_frame[0] == 'X' ? 10 : next_next_frame[0].to_i
           else
            @score += next_frame[1].to_i
          end
      else
        @score += next_frame[0].to_i + (next_frame[1] == '/' ? 10 - next_frame[0].to_i : next_frame[1].to_i)
      end
    end
  end

  def calculate_last_frame(frame,index)
    if strike?(frame)
        @score += 10
        @score += frame[1] == 'X' ? 10 : frame[1].to_i
        @score += frame[2] == '/' ? 10 - frame[1].to_i : (frame[2] == 'X' ? 10 : frame[2].to_i)
    elsif spare?(frame)
        @score += 10
        @score += frame[2] == 'X' ? 10 : frame[2].to_i
    else
        @score += frame[0].to_i + frame[1].to_i
    end
  end

end


describe 'BowlingGame' do
  it 'handles simple scores' do
    expect(
      BowlingGame.new(
        ['4', '3'], ['2', '1'], ['2', '3'], ['7', '1'], ['3', '6'], ['2', '2'], ['8', '1'], ['6', '3'], ['2', '3'], ['1', '1']
      ).calculate_score
    ).to eq 61
  end
  it 'handles zeroes' do
    expect(
      BowlingGame.new(
        ['4', '3'], ['-', '1'], ['2', '-'], ['7', '1'], ['-', '6'], ['2', '-'], ['8', '-'], ['6', '-'], ['-', '-'], ['-', '-']
      ).calculate_score
    ).to eq 40
  end
  it 'handles spares' do
    expect(
      BowlingGame.new(
        ['4', '3'], ['9', '/'], ['2', '-'], ['7', '/'], ['-', '6'], ['2', '/'], ['8', '-'], ['6', '-'], ['-', '-'], ['-', '-']
      ).calculate_score
    ).to eq 69
  end
  it 'handles strikes' do
    expect(
      BowlingGame.new(
        ['X', '-'], ['2', '6'], ['X', '-'], ['7', '2'], ['X', '-'], ['-', '3'], ['X', '-'], ['-', '-'], ['3', '2'], ['1', '1']
      ).calculate_score
    ).to eq 87
  end
  it 'handles spares followed by a strike' do
    expect(
      BowlingGame.new(
        ['4', '3'], ['2', '6'], ['6', '/'], ['X', '-'], ['3', '3'], ['7', '/'], ['2', '1'], ['7', '/'], ['X', '-'], ['3', '2']
      ).calculate_score
    ).to eq 112
  end
  it 'handles strikes followed by a spare' do
    expect(
      BowlingGame.new(
        ['4', '3'], ['2', '6'], ['X', '-'], ['3', '/'], ['3', '3'], ['X', '-'], ['2', '/'], ['7', '/'], ['3', '6'], ['3', '2']
      ).calculate_score
    ).to eq 118
  end
  it 'handles consecutive strikes' do
    expect(
      BowlingGame.new(
        ['X', '-'], ['X', '-'], ['6', '3'], ['X', '-'], ['X', '-'], ['7', '/'], ['2', '1'], ['7', '2'], ['2', '3'], ['3', '2']
      ).calculate_score
    ).to eq 135
  end
  it 'handles a spare in the last frame' do
    expect(
      BowlingGame.new(
        ['X', '-'], ['X', '-'], ['6', '3'], ['X', '-'], ['X', '-'], ['7', '/'], ['2', '1'], ['7', '2'], ['2', '3'], ['3', '/', '6']
      ).calculate_score
    ).to eq 146
  end
  it 'handles a strike in the last frame' do
    expect(
      BowlingGame.new(
        ['X', '-'], ['X', '-'], ['6', '3'], ['X', '-'], ['X', '-'], ['7', '/'], ['2', '1'], ['7', '2'], ['2', '3'], ['X', '7', '2']
      ).calculate_score
    ).to eq 149
  end
  it 'handles a strike followed by a spare in the last frame' do
    expect(
      BowlingGame.new(
        ['X', '-'], ['X', '-'], ['6', '3'], ['X', '-'], ['X', '-'], ['7', '/'], ['2', '1'], ['7', '2'], ['2', '3'], ['X', '7', '/']
      ).calculate_score
    ).to eq 150
  end
  it 'handles a perfect game' do
    expect(
      BowlingGame.new(
        ['X', '-'], ['X', '-'], ['X', '-'], ['X', '-'], ['X', '-'], ['X', '-'], ['X', '-'], ['X', '-'], ['X', '-'], ['X', 'X', 'X']
      ).calculate_score
    ).to eq 300
  end
end