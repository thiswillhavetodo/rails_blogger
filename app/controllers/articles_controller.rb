class ArticlesController < ApplicationController
	include ArticlesHelper
	before_filter :require_login, except: [:show, :index, :archive, :popular, :feed]

	def index
		@articles = Article.all
	end

	def archive
		@articles = Article.all
		@articles_by_year = Article.all.group_by { |article| article.created_at.strftime("%Y") }
		@articles_by_month = Article.all.group_by { |article| article.created_at.strftime("%B") }
	end

	def popular
		@popular = Article.order('articles.viewcount DESC').limit(3)
	end

	def feed
		@articles = Article.all
		respond_to do |format|
			format.rss { render :layout => false }
		end
	end

	def show
		@article = Article.find(params[:id])
		@comment = Comment.new
		@comment.article_id = @article.id
		@article.viewcount = @article.viewcount.to_i + 1
		@article.save
	end

	def new
		@article = Article.new
	end

	def create
		@article = Article.new(article_params)
		@article.save

		flash.notice = "Article '#{@article.title}' Created! Well Done!"

		redirect_to article_path(@article)
	end

	def destroy
		@article = Article.find(params[:id])
		@article.destroy

		flash.notice = "Article '#{@article.title}' Deleted! It's gone forever!"

		redirect_to articles_path
	end

	def edit
		@article = Article.find(params[:id])
	end

	def update
		@article = Article.find(params[:id])
		@article.update(article_params)

		flash.notice = "Article '#{@article.title}' Updated!"

		redirect_to article_path(@article)
	end

end
