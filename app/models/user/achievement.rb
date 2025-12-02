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


class User::Achievement < ApplicationRecord
  Emoji = Data.define(:emoji, :border_color, :background_color)
  AchievementKind = Data.define(:slug, :name, :description, :icon, :criterion, :reward_chips, :mystery, :mystery_icon) do
    def earned?(user) = self.criterion&.call(user) || false

    def initialize(slug:, name:, description:, icon:, criterion:, reward_chips: 0, mystery: false, mystery_icon:)
      super(slug:, name:, criterion:, description:, icon:, reward_chips:, mystery:, mystery_icon:)
    end

    def mystery? = !!mystery
  end


  #######################################

  # okay so!
  # AchievementKind[
  #   unique slug,
  #   name,
  #   description,
  #   icon (Emoji or path in app/assets/images/achievements/*)
  #   lambda to be called with user (or nil if you'll award it manually),
  #   optional chips to be awarded upon achievement,
  #   mysterious mode (hide until you earn it?),
  #   blacked out icon file
  # ]

  ACHIEVEMENTS = [
    AchievementKind[:signup, "Join up!", "if you're reading this, you're there :-)", Emoji["🧑‍🍳", "#FF0000", "#FFFF00"], ->(u) { true }, 10]
  ].index_by(&:slug).freeze

  #######################################

  belongs_to :user
  validates_inclusion_of :slug, in: ACHIEVEMENTS.keys.map(&:to_s).freeze

  def self.by_slug(slug) = ACHIEVEMENTS.fetch(slug.to_sym)

  def data = self.class.by_slug slug

  delegate :name, :description, :icon, :criterion, :reward_chips, :mystery?, to: :data

  after_commit :create_payout

  private

  def create_payout
    return unless reward_chips > 0


  end
end
