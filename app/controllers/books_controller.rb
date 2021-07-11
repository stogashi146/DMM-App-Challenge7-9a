class BooksController < ApplicationController
  before_action :ensure_current_user,{only:[:edit,:update]}

  def ensure_current_user
    @book = Book.find(params[:id])
    unless @book.user === current_user
      redirect_to books_path
    end
  end

  def show
    @book_new= Book.new
    @book = Book.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id,book_id:@book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
    @user = @book.user
    @book_comment = PostComment.new
  end

  def index
    # @books = Book.left_joins(:favorites).group(:book_id).order("count(user_id)desc")
    @books = Book.all
    @method = "new"
    @method = params[:method]
      if @method == "new"
    		Book.all.order(created_at: "asc")
    	elsif @method == "rate"
    		Book.all.order(rate: "desc")
    	else
  	  	now = Time.current
  	  	from = now.ago(6.day)
  	  	# book_idがfa
  	  	Book.includes(:fav_users).
  	  		sort{|a,b|
  	  					b.fav_users.includes(:favorites).where(created_at: from...now).size <=>
  	  					a.fav_users.includes(:favorites).where(created_at: from...now).size
  	  		}
  	  end
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    # binding.pry
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    # if current_user
      @book = Book.find(params[:id])
    # end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title,:body,:rate)
  end

end
