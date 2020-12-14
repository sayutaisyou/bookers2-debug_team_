require 'rails_helper'

describe 'ユーザー権限のテスト'  do
  let!(:user) { create(:user) }
  let!(:book) { create(:book, user: user) }
  # let! を使うと example の実行前に let! で定義した値がダミーデータとして作られる
  # rails_helper.rbに RSpec.configure do |config|
  #                     config.include FactoryBot::Syntax::Methods
  #                   end
  # があるので、上記の省略形で記述可能となった。
  # 省略ナシの場合、@user = FactoryBot.create(:user)
  #                 @book = FactoryBot.create(:book)
  # と記述する必要がある。また、!がつかないletの挙動となる？？？？？
  
  describe 'ログインしていない場合' do                  # 対象指定の説明
    context '投稿関連のURLにアクセス' do                # 動作条件の説明
      it '一覧画面に遷移できない' do                    # 期待される結果の説明
      # ここで始めに、let!で定義しておいた値が作られる
        visit books_path                                # visit パス名 で、そのパスに進む命令
        expect(current_path).to eq('/users/sign_in')    # expect().to　の()の中身が、ep() の()の中身と等しい
        # book_pathに進んだ時、URLが/users/sign_inになったらtrueを返す
      end
      it '編集画面に遷移できない' do
        # ここで始めに、let!で定義しておいた値が作られる
        visit edit_book_path(book.id)
        expect(current_path).to eq('/users/sign_in')
        # edit_book_pathに進んだ時、URLが/users/sign_inになったらtrueを返す
      end
      it '詳細画面に遷移できない' do
        # ここで始めに、let!で定義しておいた値が作られる
        visit book_path(book.id)
        expect(current_path).to eq('/users/sign_in')
        # book_path(book.id)に進んだ時、URLが/users/sign_inになったらtrueを返す
      end
    end
  end
  describe 'ログインしていない場合にユーザー関連のURLにアクセス' do
    context 'ユーザー関連のURLにアクセス' do
      it '一覧画面に遷移できない' do
        # ここで始めに、let!で定義しておいた値が作られる
        visit users_path
        expect(current_path).to eq('/users/sign_in')
        # user_pathに進んだ時、URLが/users/sign_inになったらtrueを返す
      end
      it '編集画面に遷移できない' do
        # ここで始めに、let!で定義しておいた値が作られる
        visit edit_user_path(user.id)
        expect(current_path).to eq('/users/sign_in')
        # edit_user_pathに進んだ時、URLが/users/sign_inになったらtrueを返す
      end
      it '詳細画面に遷移でない' do
        # ここで始めに、let!で定義しておいた値が作られる
        visit user_path(user.id)
        expect(current_path).to eq('/users/sign_in')
        # user_path(user.id)に進んだ時、URLが/users/sign_inになったらtrueを返す
      end
    end
  end
end