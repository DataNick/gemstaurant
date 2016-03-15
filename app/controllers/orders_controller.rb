class OrdersController < ApplicationController


  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all

    render json: @orders
  end

  # POST /orders
  # POST /orders.json
  def create
    @table = Table.find(params[:table_id])
    @order = @table.orders.build(order_params)

    if @order.save
      render json: @order, status: :created #, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def add
    @order = Order.find(params[:id])
    order_item = OrderItem.where(order_id: @order.id, item_id: params[:item_id]).first.increment(:quantity) rescue
      @order.order_items.build(item_id: params[:item_id]) #build a new order item if first instruction fails

     #take items id and build a new order_item into the order
    if order_item.save
      render json: order_item, status: :created
    else
      render json: order_item.errors, status: :unprocessable_entity
    end

  end

  def pay
    @order = Order.find(params[:id])
    if @order.total_amount == params[:amount].to_i
      @receipt = Receipt.new(order: @order, payment_method: params[:payment_method])
      if @receipt.save
        render json: @receipt, root: true, status: 201 #instead of no content
      else
        render json: @receipt.errors, status: 422
      end
    else
      render json: { "message": "You didn't pay for the exact amount #{@order.total_amount}."}, status: 422
    end
  end


  private

    def order_params
      params.require(:order).permit(:name, :email, :table_id)
    end
end
