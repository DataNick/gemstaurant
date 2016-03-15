class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.send_receipt.subject
  #
  def send_receipt(order)
    @order = order
    mail to: "to@example.org", subject: "Receipt for order: #{order.id}"
  end
end
