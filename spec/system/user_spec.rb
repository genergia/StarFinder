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
end