class EtherpadsController < ApplicationController
  before_action :set_etherpad, only: [:show, :edit, :update, :destroy]

  # /etherpad
  def index
    # Your users are probably members of some kind of groups.
    # These groups can be mapped to EtherpadLite Groups. List all the user's groups.
    @app_groups = current_user.groups
    @etherpads = Etherpad.all
  end

  # /etherpad/groups/:id
  def group
    ether = EtherpadLite.connect(9001, File.new('../../etherpad-lite/APIKEY.txt'))
    @app_group = YourAppGroup.find(params[:id])
    # Map your app's group to an EtherpadLite Group, and list all its pads
    group = ether.group("my_app_group_#{@app_group.id}")
    @pads = group.pads
  end

  # /etherpad/pads/:ep_group_id/:ep_pad_name
  def pad
    ether = EtherpadLite.connect(9001, File.new('../../etherpad-lite/APIKEY.txt'))
    # Get the EtherpadLite Group and Pad by id
    @group = ether.get_group(params[:ep_group_id])
    @pad = @group.pad(params[:ep_pad_name])
    # Map the user to an EtherpadLite Author
    author = ether.author("my_app_user_#{current_user.id}", :name => current_user.name)
    # Get or create an hour-long session for this Author in this Group
    sess = session[:ep_sessions][@group.id] ? ether.get_session(session[:ep_sessions][@group.id]) : @group.create_session(author, 60)
    if sess.expired?
      sess.delete
      sess = @group.create_session(author, 60)
    end
    session[:ep_sessions][@group.id] = sess.id
    # Set the EtherpadLite session cookie. This will automatically be picked up by the jQuery plugin's iframe.
    cookies[:sessionID] = {:value => sess.id, :domain => "localhost"}
  end


  # C/Pd stuff from groups_controller


  # GET /etherpads/1
  # GET /etherpads/1.json
  def show
  end

  # GET /etherpads/new
  def new
    @etherpad = Etherpad.new
  end

  # GET /etherpads/1/edit
  def edit
  end

  # POST /etherpads
  # POST /etherpads.json
  def create
    @etherpad = Etherpad.new(etherpad_params)

    respond_to do |format|
      if @etherpad.save
        format.html { redirect_to @etherpad, notice: 'Etherpad was successfully created.' }
        format.json { render action: 'show', status: :created, location: @etherpad }
      else
        format.html { render action: 'new' }
        format.json { render json: @etherpad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /etherpads/1
  # PATCH/PUT /etherpads/1.json
  def update
    respond_to do |format|
      if @etherpad.update(etherpad_params)
        format.html { redirect_to @etherpad, notice: 'Etherpad was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @etherpad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /etherpads/1
  # DELETE /etherpads/1.json
  def destroy
    @etherpad.destroy
    respond_to do |format|
      format.html { redirect_to etherpads_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_etherpad
      @etherpad = Etherpad.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def etherpad_params
      params.require(:etherpad).permit(:name)
    end
end
