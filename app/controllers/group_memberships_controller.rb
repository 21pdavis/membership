class GroupMembershipsController < ApplicationController
  before_action :find_group
  before_action :authenticate_roleholder, only: [:index]
  before_action :authenticate_can_manage_members, only: [:edit, :update]

  def index
    @memberships = @group.group_memberships
    @addable_members = Member.all - @group.members
  end

  def edit
    @group_membership = @group.group_memberships.find(params[:id])
  end

  def update
    @group_membership = @group.group_memberships.find(params[:id])
    @group_membership.update_attributes(group_member_params)
    redirect_to group_group_memberships_path(@group)
  end

  def create
    if current_user.admin?
      @group.group_memberships.create!(group_member_params)
      redirect_to group_group_memberships_path(@group)
    else
      @group.group_memberships.create!(member: current_user.member)
      flash[:notice] = "You are now a member of #{@group.name}"
      redirect_to group_path(@group)
    end
  end

  def destroy
    if current_user.can_manage_members_of?(@group)
      @group_membership = @group.group_memberships.find(params[:id])
      @group_membership.destroy
      redirect_to group_group_memberships_path(@group)
    else
      @group_membership = @group.group_memberships.where(member: current_user.member).first
      @group_membership.destroy
      flash[:notice] = "You have left #{@group.name}"
      redirect_to group_path(@group)
    end
  end

  private
  def find_group
    @group = Group.find(params[:group_id])
  end

  def authenticate_roleholder
    unless current_user.is_roleholder_of?(@group)
      render template: 'shared/not_permitted', status: :forbidden and return
    end
  end

  def authenticate_can_manage_members
    unless current_user.can_manage_members_of?(@group)
      render template: 'shared/not_permitted', status: :forbidden and return
    end
  end

  def group_member_params
    params.require(:group_membership).permit(
      :member_id,
      :roleholder,
      :role_name,
      :can_manage_members,
      :is_public,
      :can_manage_group,
    )
  end
end
