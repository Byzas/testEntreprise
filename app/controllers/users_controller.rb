class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
	api :POST, "/users/add_group", "add user in group"
	param :group, String, desc: "name of group", required: true
	param :idUser, Integer, desc: "Id of user", required: true
	def add_group
		if (curGroup = checkGroup()) == nil
			render json: '{"error" : "Error with group name"}'
			return
		end
		if params[:idUser] and !(params[:idUser.blank?])
			curUser = User.where(id: params[:idUser]).take
			if (link = Membership.where(organization_id: curGroup.id, user_id: idUser)) == nil
				_newLink = Membership.new(organization_id: curGroup.id, user_id: idUser)
				_newLink.save
				render json: '{"answer" : "Link is done"}'
				return
			else
				render json: '{"error" : "link is already existed"}'
				return
			end
		end
	end
	
	api :POST, "/users/delete_group", "delete user in group"
	param :group, String, desc: "name of group", required: true
	param :idUser, Integer, desc: "Id of user", required: true
	def del_group
		if (curGroup = checkGroup()) == nil
			render json: '{"error" : "Error with group name"}'
			return
		end
		if params[:idUser] and !(params[:idUser.blank?])
			curUser = User.where(id: params[:idUser]).take
			if (link = Membership.where(organization_id: curGroup.id, user_id: idUser)) != nil
				_newLink = Membership.destroy(link)
				_newLink.save
				render json: '{"answer" : "destroy link is done"}'
				return
			else
				render json: '{"error" : "link is not existed"}'
				return
			end
		end
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :gender, :phone_number)
    end
	
	
	
	# Check la clÃ© API pour connaitre le current user.
	def checkGroup
		if params[:group] and !(params[:group].blank?) 
			return Organization.where(name: params[:group]).take
		else
			return nil
		end
	end
end
