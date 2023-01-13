require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
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
end
