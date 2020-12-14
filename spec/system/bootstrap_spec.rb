require 'rails_helper'

describe 'bootstrapのテスト' do
	# 遅延評価されるlet
	# 実行タイミング：代入した変数が参照されたタイミング(で評価される)
	# デメリット：User.find 1のように代入した変数を使わずにActive Recordにアクセスする場合、letだとエラーが発生
	# 構文：let(:変数名) { ... }    { ... } の中の値が 変数名(ローカル変数/インスタンス変数)として参照できる
	let(:user) { create(:user) }
	# 遅延評価をしないlet!
  # 実行タイミング:テストを行う前(before doと同じタイミング)に実行
  # 自分と他人でリンク先が違う場合などを判定(showページなど)するために2つずつデータを作成している
	let!(:book) { create(:book, user: user) }
	describe 'グリッドシステムのテスト' do
		before do
			# 指定したパスに移動
      # 構文：visit xxxxx_path
			visit new_user_session_path
			# カラムに値を代入
      # 構文：fill_in 'カラム名(を指定)', with: カラムに入れる事柄(を指定)
			fill_in 'user[name]', with: user.name
			fill_in 'user[name]', with: user.name
			fill_in 'user[password]', with: user.password
			# ボタン(submitボタンやbuttonタグ)をクリックする
      # 構文：click_button 'ボタン名'
			click_button 'Log in'
		end
		context 'ユーザー関連画面' do
			it '一覧画面' do
				visit users_path
				# 特定のタグやCSS要素に特定の文字列が表示されていることを検証する
        # expect(page).to have_selector(要素/CSSクラス/ID)
				expect(page).to have_selector('.container .row .col-xs-3')
				expect(page).to have_selector('.container .row .col-xs-9')
			end
			it '詳細画面' do
				visit user_path(user)
				expect(page).to have_selector('.container .row .col-xs-3')
				expect(page).to have_selector('.container .row .col-xs-9')
			end
		end
		context '投稿関連画面' do
			it '一覧画面' do
				visit books_path
				expect(page).to have_selector('.container .row .col-xs-3')
				expect(page).to have_selector('.container .row .col-xs-9')
			end
			it '詳細画面' do
				visit book_path(book)
				expect(page).to have_selector('.container .row .col-xs-3')
				expect(page).to have_selector('.container .row .col-xs-9')
			end
		end
	end
end


