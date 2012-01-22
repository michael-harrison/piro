root = global ? window

root.PivotalRocketOptions =
  background_page: chrome.extension.getBackgroundPage()
  # templates
  templates: {}
  # init options
  init: ->
    PivotalRocketOptions.init_templates()
    PivotalRocketOptions.init_bindings()
    PivotalRocketOptions.init_view()
  # init templates
  init_templates: ->
    PivotalRocketOptions.templates.account = Hogan.compile($('#account_template').html())
  # init bindings
  init_bindings: ->
    # add accounts
    $('#addAccount').click (event) => 
      $('#pivotalAddError').hide()
      $('#accountBox').addClass('adding')
      return false
    $('#cancelAddAccount').click (event) => 
      $('#accountBox').removeClass('adding')
      return false
    $('#pivotalEmail, #pivotalPassword, #pivotalCompanyName').keydown (event) => 
      PivotalRocketOptions.add_account() if 13 == event.keyCode
    $('#confirmAddAccount').click (event) => 
      PivotalRocketOptions.add_account()
      return false
    # edit account
    $('#accountList').on "click", "a.edit_account", (event) =>
      $(event.target).parents('li.account').removeClass('deleting').addClass('editing')
      $(event.target).parents('li.account').find('input.company_name').focus()
      return false
    $('#accountList').on "click", "a.cancel_edit_account", (event) =>
      $(event.target).parents('li.account').removeClass('editing')
      return false
    $('#accountList').on "keydown", "input.company_name", (event) =>
      PivotalRocketOptions.update_account(event) if 13 == event.keyCode
    $('#accountList').on "click", "a.confirm_edit_account", (event) =>
      PivotalRocketOptions.update_account(event)
      return false
    # delete account
    $('#accountList').on "click", "a.delete_account", (event) =>
      $(event.target).parents('li.account').removeClass('editing').addClass('deleting')
      return false
    $('#accountList').on "click", "a.cancel_delete_account", (event) =>
      $(event.target).parents('li.account').removeClass('deleting')
      return false
    $('#accountList').on "click", "a.confirm_delete_account", (event) =>
      PivotalRocketOptions.delete_account(event)
      return false
    # update options
    $('#updateOptions').click (event) => 
      PivotalRocketOptions.update_options()
      return false
  init_sort_accounts: ->
    $("#accountList").sortable
      placeholder: "ui-state-highlight"
      dropOnEmpty: true
      handle: "div.sortable_link"
      update: (event, ui) ->
        account_ids = $("#accountList").sortable('toArray')
        accounts = ($("##{object_id}").data("accountId") for object_id in account_ids)
        PivotalRocketStorage.sort_accounts(accounts)
    $("#accountList").disableSelection();
  # init option view
  init_view: ->
    PivotalRocketOptions.account_list()
    PivotalRocketOptions.init_options_view()
  # account list
  account_list: ->
    # init account list
    $('#accountList').empty()
    if PivotalRocketStorage.get_accounts().length > 0
      for account in PivotalRocketStorage.get_accounts()
        $('#accountList').append(PivotalRocketOptions.templates.account.render(account))
    # bind sorting
    PivotalRocketOptions.init_sort_accounts()
  # init options block
  init_options_view: ->
    $('#updateInterval').val(PivotalRocketStorage.get_update_interval())
  # update options
  update_options: ->
    $('#updateInterval').val(PivotalRocketStorage.set_update_interval($('#updateInterval').val()))
    PivotalRocketOptions.background_page.PivotalRocketBackground.updated_options()
  # add acoount
  add_account: ->
    username = $('#pivotalEmail').val()
    password = $('#pivotalPassword').val()
    if username.length > 0 && password.length > 0
      pivotal_auth_lib = new PivotalAuthLib
        username: username
        password: password
        success: (data, textStatus, jqXHR) ->
          account = XML2JSON.parse(data, true)
          account = account.person if account.person?
          company_name = $('#pivotalCompanyName').val()
          account.company_name = company_name if company_name.length > 0
          PivotalRocketStorage.save_account(account)
          $('#pivotalEmail, #pivotalPassword, #pivotalCompanyName').val('')
          $('#pivotalAddError').empty()
          $('#accountBox').removeClass('adding')
          PivotalRocketOptions.account_list()
          $('#loginSpinner').hide()
          # notify background page
          PivotalRocketOptions.background_page.PivotalRocketBackground.updated_accounts()
          if !PivotalRocketOptions.background_page.PivotalRocketBackground.is_loading
            PivotalRocketOptions.background_page.PivotalRocketBackground.initial_sync(account)
        error: (jqXHR, textStatus, errorThrown) ->
          $('#pivotalAddError').show().text(errorThrown)
          $('#loginSpinner').hide()
        beforeSend: (jqXHR, settings) ->
          $('#loginSpinner').show()
          $('#pivotalAddError').hide()
  # update account
  update_account: (event) ->
    li_object = $(event.target).parents('li.account')
    account_id = li_object.data("accountId")
    account = PivotalRocketStorage.find_account(account_id)
    if account?
      company_name = li_object.find('input.company_name').val()
      if company_name.length > 0
        account.company_name = company_name
      else
        account.company_name = null
      PivotalRocketStorage.save_account(account)
    li_object.find('.company_name_text').text(account.company_name || 'Not set')
    li_object.removeClass('editing')
  # delete account
  delete_account: (account_id) ->
    li_object = $(event.target).parents('li.account')
    account_id = li_object.data("accountId")
    PivotalRocketStorage.delete_account(account_id)
    PivotalRocketOptions.account_list()
    # notify background page
    PivotalRocketOptions.background_page.PivotalRocketBackground.updated_accounts()
    
$ ->
  PivotalRocketOptions.init()