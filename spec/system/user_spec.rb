require 'rails_helper'
RSpec.describe 'ユーザー機能', type: :system do
  describe '新規登録機能' do
    context 'ユーザーを新規登録した場合' do
      it 'フラッシュメッセージが表示される' do
        visit new_user_registration_path
        fill_in 'user_name', with: 'test_user'  
        fill_in 'user_email', with: 'user@test.com'
        fill_in 'user_password', with: 111111 
        fill_in 'user_password_confirmation', with: 111111 
        click_on 'commit'
        expect(page).to have_content 'アカウント登録が完了しました'
      end
    end
  end
  describe 'ログイン機能' do
    context 'ユーザーがログインした場合' do
      it 'フラッシュメッセージが表示される' do
        @user = FactoryBot.create(:user)
        visit new_user_session_path
        fill_in 'user_email', with: 'user1@test.com'
        fill_in 'user_password', with: 111111 
        click_on 'commit'
        expect(page).to have_content 'ログインしました。'
      end
    end
    context '管理者がログインした場合' do
      it 'フラッシュメッセージが表示される' do
        @user = FactoryBot.create(:admin)
        visit new_user_session_path
        fill_in 'user_email', with: 'admin@test.com'
        fill_in 'user_password', with: 111111 
        click_on 'commit'
        expect(page).to have_selector '#admin-screen-btn'
      end
    end
  end
  describe 'ログアウト機能' do
    context 'ユーザーがログアウトした場合' do
      it 'フラッシュメッセージが表示される' do
        @user = FactoryBot.create(:user)
        visit new_user_session_path
        fill_in 'user_email', with: 'user1@test.com'
        fill_in 'user_password', with: 111111 
        click_on 'commit'
        click_on 'ログアウト'
        expect(page).to have_content 'ログアウトしました。'
      end
    end
  end
  describe '管理者機能' do
    before do
      @user = FactoryBot.create(:user)
      @admin = FactoryBot.create(:admin)
        visit new_user_session_path
        fill_in 'user_email', with: 'admin@test.com'
        fill_in 'user_password', with: 111111 
        click_on 'commit'
    end
    context 'ユーザーの作成をした場合' do
      it 'フラッシュメッセージが表示される' do
        visit "/admin/user/new"
        fill_in 'user_name', with: 'テストユーザー'
        fill_in 'user_email', with: 'test@test.com'
        fill_in 'user_password', with: 111111 
        fill_in 'user_password_confirmation', with: 111111 
        click_on '_save'
        expect(page).to have_content 'ユーザーの作成に成功しました'
      end
    end
    context 'ユーザーの編集をした場合' do
      it 'フラッシュメッセージが表示される' do
        visit "/admin/user/#{@user.id}/edit"
        fill_in 'user_name', with: 'テストユーザー'
        fill_in 'user_email', with: 'test@test.com'
        fill_in 'user_password', with: 111111 
        fill_in 'user_password_confirmation', with: 111111 
        click_on '_save'
        expect(page).to have_content 'ユーザーの更新に成功しました'
      end
    end
    context 'ユーザーの削除をした場合' do
      it 'フラッシュメッセージが表示される' do
        visit "/admin/user/#{@user.id}/delete"
        click_on '実行する'
        expect(page).to have_content 'ユーザーの削除に成功しました'
      end
    end
  end
  describe 'アクセス制限' do
    context '未ログイン者が新規投稿画面にアクセスした場合' do
      it 'ログイン画面に遷移する' do
        visit new_post_path
        expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      end
    end
    context '一般ユーザが他人の投稿編集画面にアクセスした場合' do
      it 'フラッシュメッセージが表示される' do
        user = FactoryBot.create(:user)
        user2 = FactoryBot.create(:user_2)
        post = FactoryBot.create(:post, user: user2)
        visit new_user_session_path
        fill_in 'user_email', with: 'user1@test.com'
        fill_in 'user_password', with: 111111 
        click_on 'commit'
        visit edit_post_path(post)
        expect(page).to have_content '権限がありません'
      end
    end
    context '一般ユーザが他人のマイページ編集画面にアクセスした場合' do
      it 'フラッシュメッセージが表示される' do
        user = FactoryBot.create(:user)
        user2 = FactoryBot.create(:user_2)
        visit new_user_session_path
        fill_in 'user_email', with: 'user1@test.com'
        fill_in 'user_password', with: 111111 
        click_on 'commit'
        visit edit_my_page_path(user2)
        expect(page).to have_content '権限がありません'
      end
    end
  
  end
end