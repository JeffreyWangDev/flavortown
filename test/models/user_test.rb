# == Schema Information
#
# Table name: users
#
#  id                                        :bigint           not null, primary key
#  display_name                              :string
#  email                                     :string
#  hack_club_account_access_token_bidx       :string
#  hack_club_account_access_token_ciphertext :text
#  has_gotten_free_stickers                  :boolean          default(FALSE)
#  has_roles                                 :boolean          default(TRUE), not null
#  magic_link_token                          :string
#  magic_link_token_expires_at               :datetime
#  projects_count                            :integer
#  region                                    :string
#  verification_status                       :string           default("needs_submission"), not null
#  votes_count                               :integer
#  ysws_verified                             :boolean
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  hack_club_account_id                      :string
#  slack_id                                  :string
#
# Indexes
#
#  index_users_on_hack_club_account_access_token_bidx  (hack_club_account_access_token_bidx)
#  index_users_on_hack_club_account_id                 (hack_club_account_id) UNIQUE
#  index_users_on_magic_link_token                     (magic_link_token) UNIQUE
#  index_users_on_region                               (region)
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
