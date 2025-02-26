require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:richi)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    post login_path, params: { session: { email: @admin.email,
                                      password: 'password',
                                      remember_me: '0' } }
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a.btn-outline-secondary'
    end
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a.btn-outline-secondary'
      unless user == @admin
        assert_select 'a.btn-outline-secondary'
      end
    end
    assert_difference 'User.count', -1 do
    delete user_path(@non_admin)
    assert_response :see_other
    assert_redirected_to users_url
  end
    
  end
end
