def sign_in_as(email)
  visit "/"
  fill_in "Email", :with => email
  fill_in "Password", :with => "password"
  click_button "Log in"
end

def create_fixtures
  @admin_member = create(:member, email_address: 'admin@abscond.org', first_name: 'Admin', last_name: 'Person')
  @admin = create(:user, email: 'admin@abscond.org', role: 'admin')
  @james1 = create(:member, email_address: 'james@abscond.org', first_name: 'James', last_name: 'Darling')
  @james1_account = create(:user, email: 'james@abscond.org', role: '')
  @james2 = create(:member, first_name: 'James', last_name: 'Smith')
  @sarah = create(:member, first_name: 'Sarah')
  @jon = create(:member, first_name: 'Jon')
  @group1 = Group.create!(members: [])
  @group2 = Group.create!(members: [@jon, @james1])
  @priveleged_roleholding = create(:group_membership, member: @james1, group: @group1, roleholder: true, role_name: 'Chair', can_manage_members: true, is_public: true, can_manage_group: true)
end
