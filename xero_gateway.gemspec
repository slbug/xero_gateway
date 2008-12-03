Gem::Specification.new do |s|
  s.name     = "xero_gateway"
  s.version  = "1.0.2"
  s.date     = "2008-12-04"
  s.summary  = "Enables ruby based applications to communicate with the Xero API"
  s.email    = "tlconnor@gmail.com"
  s.homepage = "http://github.com/tlconnor/xero_gateway"
  s.description = "Enables ruby based applications to communicate with the Xero API"
  s.has_rdoc = false
  s.authors  = ["Tim Connor"]
  s.add_dependency('builder', '>= 2.1.2')
  s.files    = ["CHANGELOG.textile",
    "init.rb",
    "LICENSE",
    "Rakefile",
    "README.textile", 
    "lib/xero_gateway.rb",
    "lib/xero_gateway/account.rb",
    "lib/xero_gateway/address.rb",
    "lib/xero_gateway/contact.rb",
    "lib/xero_gateway/dates.rb",
    "lib/xero_gateway/gateway.rb",
    "lib/xero_gateway/http.rb",
    "lib/xero_gateway/invoice.rb",
    "lib/xero_gateway/line_item.rb",
    "lib/xero_gateway/money.rb",
    "lib/xero_gateway/phone.rb",
    "lib/xero_gateway/response.rb",
    "lib/xero_gateway/tracking_category.rb",
    "lib/xero_gateway/messages/account_message.rb",
    "lib/xero_gateway/messages/contact_message.rb",
    "lib/xero_gateway/messages/invoice_message.rb",
    "lib/xero_gateway/messages/tracking_category_message.rb",
    "test/test_helper.rb",
    "test/integration/create_contact_test.rb",
    "test/integration/create_invoice_test.rb",
    "test/integration/get_accounts_test.rb",
    "test/integration/get_contact_test.rb",
    "test/integration/get_contacts_test.rb",
    "test/integration/get_invoice_test.rb",
    "test/integration/get_invoices_test.rb",
    "test/integration/get_tracking_categories_test.rb",
    "test/integration/integration_test_methods.rb",
    "test/integration/stub_responses/accounts.xml",
    "test/integration/stub_responses/contact.xml",
    "test/integration/stub_responses/contacts.xml",
    "test/integration/stub_responses/invoice.xml",
    "test/integration/stub_responses/invoices.xml",
    "test/integration/stub_responses/tracking_categories.xml",
    "test/integration/update_contact_test.rb",
    "test/unit/messages/account_message_test.rb",
    "test/unit/messages/contact_message_test.rb",
    "test/unit/messages/invoice_message_test.rb",
    "test/unit/messages/tracking_category_message_test.rb",
    "test/xsd/README",
    "test/xsd/create_contact.xsd",
    "test/xsd/create_invoice.xsd",
    "xero_gateway.gemspec"]
end
