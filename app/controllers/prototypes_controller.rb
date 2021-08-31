class PrototypesController < ApplicationController
  before_action :set_prototype, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show, :index] 
  before_action :contributor_confirmation, only: [:edit, :update, :destroy]

  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototypes_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comment.includes(:user)
  end

  def edit
  end

  def update
    if @prototype.update(prototypes_params)
      redirect_to prototype_path(@prototype)
    else
      render :edit
    end
  end

  def destroy
    if @prototype = Prototype.find(params[:id])
      @prototype.destroy
      redirect_to root_path
    else
      redirect_to root_path
    end
  end



private

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end     
  end

  def prototypes_params
    params.require(:prototype).permit(:image, :title, :catch_copy, :concept ).merge(user_id: current_user.id)
  end



 def set_prototype
  @prototype = Prototype.find(params[:id])
 end

 def contributor_confirmation
  redirect_to root_path unless current_user == @prototype.user
 end
end