require 'rails_helper'
# $ rails g rspec:install した際に生成された spec/rails_helper.rb を読み込む為の設定。
# spec/rails_helper.rb に Rails 特有の設定
# spec/spec_helper.rbには RSpec の全体的な設定を書く


RSpec.describe 'Bookモデルのテスト', type: :model do
  
  describe 'バリデーションのテスト' do
  # describe（テストの大きなくくりを示します：必須）
  
    let(:user) { create(:user) }
    # create
      # DB上にインスタンスを永続化する。
      # DB上にデータを作成する。
      # DBにアクセスする処理のときは必須。（何かの処理の後、DBの値が変更されたのを確認する際は必要）
    # @user = FactoryBot.create(:user)  ←  (before内で書き換えた場合)
      # FactoryBot = データ(モデルインスタンス)生成のためのライブラリ。主にテストデータの生成に利用する
    
    let!(:book) { build(:book, user_id: user.id) }
    # build
      # メモリ上にインスタンスを確保する。
      # DB上にはデータがないので、DBにアクセスする必要があるテストのときは使えない。
      # DBにアクセスする必要がないテストの時には、インスタンスを確保する時にDBにアクセスする必要がないので処理が比較的軽くなる。
    # @book = FactoryBot.build(:book, user_id:id)  ←  (before内で書き換えた場合)
    
    


    context 'titleカラム' do
    # context（describeより詳細に分ける場合にのみ使用します）  
      
      it '空欄でないこと' do
      # it（具体的なテストの内容を示します：必須）

        book.title = ''
        #bookのtitleカラムが空欄

        expect(book.valid?).to eq false;
        # bookモデル内のvalidationが動いた結果、上記「book.title = ''」がfalse出力されることが期待される。
          #expect 'expectは処理内容などを記述する'
          # to '期待している値が「~であること」を意味しています。(逆の場合はnot_toを使用します)'
          # eq 'eq(イコール)は期待している内容を記述する'
        
      end
    end
    
    
    context 'bodyカラム' do
      # book.bodyのvalidationは2つあるためitが以下2つに分けてある。
      
      it '空欄でないこと' do
        book.body = ''
        expect(book.valid?).to eq false;
        # bookモデル内のvalidationが動いた結果、上記「book.body = ''」がfalse出力されることが期待される。
        
      end
      
      it '200文字以下であること' do
        book.body = Faker::Lorem.characters(number:201)
        #bookのbodyカラムが201字記述がある。
          #Fakerはダミーデータを作成する。
          #loremは出版やグラフィックデザインなどに用いられるダミーテキスト「lorem ipsum」の略。(wikipedia)
            # 他の例、Faker::Code.ean #=> EANコード、Faker::Name.name #=> 氏名
        
        expect(book.valid?).to eq false;
        # bookモデル内のvalidationが動いた結果、上記「book.body = Faker::Lorem.characters(number:201)」がfalse出力されることが期待される。
        
      end
    end
  end
  
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Book.reflect_on_association(:user).macro).to eq :belongs_to
        # reflect_on_associationで対象のクラスbookと引数で指定するクラスuserの関連を返す。
        
      end
    end
  end
end




# before（itの内容を実行する前に必要であれば使用します）