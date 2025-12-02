class CreateUserAchievements < ActiveRecord::Migration[8.1]
  def change
    create_table :user_achievements do |t|
      t.string :slug
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
