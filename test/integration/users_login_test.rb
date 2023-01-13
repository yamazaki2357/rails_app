require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_path # ログイン用のパスを開く
    assert_template 'sessions/new' # 新しいセッションのフォームが正しく表示されたことを確認する
    post login_path, params: { session: { email: " ", password: " " } } # わざと無効なparamsハッシュを使ってセッション用パスにPOSTする
    assert_response :unprocessable_entity # 新しいセッションのフォームが正しいステータスを返し、再度表示されることを確認する
    assert_template 'sessions/new'
    assert_not flash.empty? # フラッシュメッセージが表示されることを確認する
    get root_path # 別ページにいったん移動する
    assert flash.empty? # 移動先のページでフラッシュメッセージが表示されていないことを確認する
  end

  test "login with valid information" do
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } } # ログイン用のパスを開く# セッション用パスに有効な情報をPOSTする
    assert_redirected_to @user # リダイレクト先が正しいかどうかチェック
    follow_redirect! # ページに実際に移動する
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0 # ログアウト用リンクが表示されなくなったことを確認する
    assert_select "a[href=?]", logout_path # ログアウト用リンクが表示されていることを確認する
    assert_select "a[href=?]", user_path(@user) # プロフィール用リンクが表示されていることを確認する
  end

  test "login with valid email/invalid password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email:    "abc@example.com",
                                          password: "invalid" } }
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
