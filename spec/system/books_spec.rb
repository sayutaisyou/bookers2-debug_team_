require 'rails_helper'

describe '投稿のテスト' do
	# 遅延評価されるlet
	# 実行タイミング：代入した変数が参照されたタイミング(で評価される)
	# デメリット：User.find 1のように代入した変数を使わずにActive Recordにアクセスする場合、letだとエラーが発生
	# 構文：let(:変数名) { ... }    { ... } の中の値が 変数名(ローカル変数/インスタンス変数)として参照できる
	let(:user) { create(:user) }
  let(:user) { create(:user) }
  # 遅延評価をしないlet!
  # 実行タイミング:テストを行う前(before doと同じタイミング)に実行
  # 自分と他人でリンク先が違う場合などを判定(showページなど)するために2つずつデータを作成している
  let!(:user2) { create(:user) }
  let!(:book) { create(:book, user: user) }
  let!(:book2) { create(:book, user: user2) }
  before do
  	# 指定したパスに移動
    # 構文：visit xxxxx_path
  	visit new_user_session_path
  	# カラムに値を代入
    # 構文：fill_in 'モデル名[カラム名]', with: カラムに入れる事柄(を指定)
  	fill_in 'user[name]', with: user.name
  	fill_in 'user[password]', with: user.password
  	# ボタン(submitボタンやbuttonタグ)をクリックする
    # 構文：click_button 'ボタン名'
  	click_button 'Log in'
  end
  describe 'サイドバーのテスト' do
		context '表示の確認' do
		  it 'New bookと表示される' do
		  	# ページ内に特定の文字列が表示されていることを検証する
        # 構文：expect(page).to have_content '指定の文字列'
	    	expect(page).to have_content 'New book'
		  end
		  it 'titleフォームが表示される' do
		  	# フォームが表示されることを検証する
        # 構文：expect(page).to have_field '送信先モデル名[カラム名]'
		  	expect(page).to have_field 'book[title]'
		  end
		  it 'opinionフォームが表示される' do
		  	expect(page).to have_field 'book[body]'
		  end
		  it 'Create Bookボタンが表示される' do
		  	expect(page).to have_button 'Create Book'
		  end
		  it '投稿に成功する' do
		  	# Faker  ライブラリ/Rubyでダミーデータを生成/日本語対応あり
		  	fill_in 'book[title]', with: Faker::Lorem.characters(number:5)
		  	fill_in 'book[body]', with: Faker::Lorem.characters(number:20)
		  	click_button 'Create Book'
		  	# ページ内に特定の文字列が表示されていることを検証する
        # 構文：expect(page).to have_content '指定の文字列'
		  	expect(page).to have_content 'successfully'
		  end
		  it '投稿に失敗する' do
		  	click_button 'Create Book'
		  	expect(page).to have_content 'error'
		  	# 現在のページが特定のパスであることを検証する
		  	# 構文：expect(current_path).to eq('URL')
		  	# パスでの指定も可能：expect(current_path).to eq new_user_path　等
		  	expect(current_path).to eq('/books')
		  end
		end
  end

  describe '編集のテスト' do
  	context '自分の投稿の編集画面への遷移' do
  	  it '遷移できる' do
	  		visit edit_book_path(book)
	  		expect(current_path).to eq('/books/' + book.id.to_s + '/edit')
	  	end
	  end
		context '他人の投稿の編集画面への遷移' do
		  it '遷移できない' do
		    visit edit_book_path(book2)
		    expect(current_path).to eq('/books')
		  end
		end
		context '表示の確認' do
			before do
				visit edit_book_path(book)
			end
			it 'Editing Bookと表示される' do
				expect(page).to have_content('Editing Book')
			end
			it 'title編集フォームが表示される' do
				# テキストボックスに特定の値が入っていることを検証する
				# 構文：expect(page).to have_field 'モデル名[カラム名]', with: テキストボックス内に表示されているはずの特定の値
				expect(page).to have_field 'book[title]', with: book.title
			end
			it 'opinion編集フォームが表示される' do
				expect(page).to have_field 'book[body]', with: book.body
			end
			it 'Showリンクが表示される' do
				# 特定のパスへのリンクを検証する/クリックする
				# ページ内に同じようなリンクが複数あり、特定のリンクだけにフォーカスしたい場合は具体的なパス（a要素のhref属性）で絞り込むことができろ
				# expect(page).to have_link 'リンク文字列', href: リンク先パス
				expect(page).to have_link 'Show', href: book_path(book)
			end
			it 'Backリンクが表示される' do
				expect(page).to have_link 'Back', href: books_path
			end
		end
		context 'フォームの確認' do
			it '編集に成功する' do
				visit edit_book_path(book)
				click_button 'Update Book'
				expect(page).to have_content 'successfully'
				expect(current_path).to eq '/books/' + book.id.to_s
			end
			it '編集に失敗する' do
				visit edit_book_path(book)
				# カラムに値を代入
  			# 構文：fill_in 'モデル名[カラム名]', with: カラムに入れる事柄(を指定)/今回はカラムが空のケース
				fill_in 'book[title]', with: ''
				click_button 'Update Book'
				expect(page).to have_content 'error'
				expect(current_path).to eq '/books/' + book.id.to_s
			end
		end
	end

  describe '一覧画面のテスト' do
  	before do
  		visit books_path
  	end
  	context '表示の確認' do
  		it 'Booksと表示される' do
  			expect(page).to have_content 'Books'
  		end
  		it '自分と他人の画像のリンク先が正しい' do
  			# 特定のパスへのリンクを検証する/クリックする
  			# リンク文字列がない場合（アイコンが表示されている場合など）はhrefだけで絞り込むことができる
  			# 下記以外の書き方：expect(page).to have_link nil, href: edit_contact_path(contact)
  			expect(page).to have_link '', href: user_path(book.user)
  			expect(page).to have_link '', href: user_path(book2.user)
  		end
  		it '自分と他人のタイトルのリンク先が正しい' do
  			expect(page).to have_link book.title, href: book_path(book)
  			expect(page).to have_link book2.title, href: book_path(book2)
  		end
  		it '自分と他人のオピニオンが表示される' do
  			expect(page).to have_content book.body
  			expect(page).to have_content book2.body
  		end
  	end
  end

  describe '詳細画面のテスト' do
  	context '自分・他人共通の投稿詳細画面の表示を確認' do
  		it 'Book detailと表示される' do
  			visit book_path(book)
  			expect(page).to have_content 'Book detail'
  		end
  		it 'ユーザー画像・名前のリンク先が正しい' do
  			visit book_path(book)
  			expect(page).to have_link book.user.name, href: user_path(book.user)
  		end
  		it '投稿のtitleが表示される' do
  			visit book_path(book)
  			expect(page).to have_content book.title
  		end
  		it '投稿のopinionが表示される' do
  			visit book_path(book)
  			expect(page).to have_content book.body
  		end
  	end
  	context '自分の投稿詳細画面の表示を確認' do
  		it '投稿の編集リンクが表示される' do
  			visit book_path book
  			expect(page).to have_link 'Edit', href: edit_book_path(book)
  		end
  		it '投稿の削除リンクが表示される' do
  			visit book_path book
  			expect(page).to have_link 'Destroy', href: book_path(book)
  		end
  	end
  	context '他人の投稿詳細画面の表示を確認' do
  		it '投稿の編集リンクが表示されない' do
  			# リンクが表示されないことを検証する
				# expect(page).to have_no_link 'リンク文字列', href: リンク先パス
  			visit book_path(book2)
  			expect(page).to have_no_link 'Edit', href: edit_book_path(book2)
  		end
  		it '投稿の削除リンクが表示されない' do
  			visit book_path(book2)
  			expect(page).to have_no_link 'Destroy', href: book_path(book2)
  		end
  	end
  end
end




