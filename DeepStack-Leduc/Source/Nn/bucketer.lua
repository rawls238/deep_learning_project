--- Assigns hands to buckets on the given board.
-- 
-- For the Leduc implementation, we simply assign every possible set of
-- private and board cards to a unique bucket.
-- @classmod bucketer
local game_settings = require 'Settings.game_settings'
local card_tools = require 'Game.card_tools'
local bucketer = torch.class('Bucketer')

--- Gives the total number of buckets across all boards.
-- @return the number of buckets
function bucketer:get_bucket_count()

	-- For Leduc, bucket count = 36
  return game_settings.card_count * card_tools:get_boards_count()

end

--- Gives a vector which maps private hands to buckets on a given board.
-- @param board a non-empty vector of board cards
-- @return a vector which maps each private hand to a bucket index
function bucketer:compute_buckets(board)

	-- Create scalar shift value based on the board index
  --    Board Index from 1 to 6, thus Shift Value from 0 to 30
  local shift = (card_tools:get_board_index(board) - 1) * game_settings.card_count

  -- Create a 1x6 tensor with float values 1.0 through 6.0
  --		Then add scalar shift value to each element
  local buckets = torch.range(1, game_settings.card_count):float():add(shift)

  -- Impossible hands will have bucket number -1
  for i = 1,board:size(1) do 
    buckets[board[i]] = -1
  end
  return buckets
end