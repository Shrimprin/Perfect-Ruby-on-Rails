class BooksController < ApplicationController
  protect_from_forgery except: [:destroy]
  before_action :set_book, only: [:show, :destroy]
  around_action :action_logger, only: [:destroy]

  def show
    @book = Book.find(params[:id])
    render :show

  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    respond_to do |format|
      format.html { redirect_to "/"}
      format.json { head :no_content }
    end
  end

  def set_book
    @book = Book.find(params[:id])
  end

  private
    def action_logger
      logger.info "around_before"
      yield # ここでもともと呼び出しているアクションを呼び出す
      logger.info "around_after"
    end

end
