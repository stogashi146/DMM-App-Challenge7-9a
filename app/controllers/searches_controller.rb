class SearchesController < ApplicationController
  before_action :authenticate_user!
  def search
    # 検索対象：User/Book
    @model = params["model"]
    # 検索条件：完全一致/部分一致
    @method = params["method"]
    # 検索ワード：検索窓の値
    @content = params["content"]
    if @model == "user"
      @records = User.search_for(@content,@method)
    else
      @records = Book.search_for(@content,@method)
    end
  end
end
