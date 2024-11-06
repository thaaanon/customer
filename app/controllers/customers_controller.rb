class CustomersController < ApplicationController
  before_action :set_customer, only: [:edit, :update, :destroy]

  def index
    @customers = Customer.all
  end

  def alphabetized
    @customers = Customer.order(:full_name)
  end

  def missing_email
    @customers = Customer.where(email_address: [nil, ''])
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to customers_path, notice: 'Customer was successfully created.'
    else
      render :new
    end
  end  

  def edit
  end

  def update
    # Check if remove_image checkbox is checked and purge the image
    if params[:customer][:remove_image] == "1" && @customer.image.attached?
      @customer.image.purge # This removes the image from ActiveStorage if it's attached
    end
  
    # Now, attempt to update the customer
    if @customer.update(customer_params)
      redirect_to customers_path, notice: 'Customer was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @customer.destroy
    redirect_to customers_path, notice: 'Customer deleted successfully.'
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:full_name, :phone_number, :email_address, :notes, :image)
  end
end
