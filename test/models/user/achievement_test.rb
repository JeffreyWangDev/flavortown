# == Schema Information
#
# Table name: user_achievements
#
#  id         :bigint           not null, primary key
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_achievements_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class User::AchievementTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
