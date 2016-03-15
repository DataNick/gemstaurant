class StatsController < ApplicationController
  def index
    render json: {
      orders: orders,
      customers: customers,
      orders_by_month: orders_by_month
    }
  end

  private
  def orders
    @orders ||= Order.all
  end

  def customers
    # orders.map{|order| order.name}
    orders.group_by(&:name).map{ |name, orders| [ name, orders.count ] }
  end

  def orders_by_month
    orders.group_by{ |order| order.created_at.beginning_of_month }.map{ |month, orders| [ month, orders.count ] }
    # Jan => [Jan 4, Jan 6], Feb => [Feb 19]
  end
end
