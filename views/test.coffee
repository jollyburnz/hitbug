jQuery ->
	window.Github = {
		Model: {}
		View: {}
		Collection: {}
		Router: {}
	}

	class Github.Model.User extends Backbone.Model

	class Github.Collection.Users extends Backbone.Collection
		model: Github.Model.User

	class Github.View.HomeView extends Backbone.View
		tagName: "div"
		id: "document-row"
		console.log(@el)

		initialize: ->
			console.log('render homeview')
			gitUsers.on 'add', @test
			@render()
		render: ->
			$(@el).append '<button id="add-user">Add User</button>'
			$(@el).append "<div id='user-list'></div>"
			$(@el).append "<a href='/#!/tester'>Go to Test</a>"
		showPrompt: ->
			console.log('showPrompt clicked')
			userName = prompt "Enter Username:" 
			githubUser = new Github.Model.User
			githubUser.url = "https://api.github.com/users/#{userName}"
			githubUser.fetch
				success: ->
					gitUsers.add githubUser
		test: (model) ->
			$("#user-list").append("<img src=#{model.get('avatar_url')} />")
			console.log('hit')

		events:
			"click #add-user": "showPrompt"
	
	class Github.View.TestView extends Backbone.View
		initialize: ->
			@render()
		render: ->
			$(@el).append '<p>Test View</p>'
			$(@el).append "<a href='/#!/'>Go to Main</a>"


	class Github.Router.Route extends Backbone.Router
		routes :
			"!/": "home"
			"!/tester": "tester"

		home: ->
			@homeView = new Github.View.HomeView
			$("#content").html @homeView.el
			console.log(@homeView.el)
		tester: ->
			unless @testView
				@testView = new Github.View.TestView
			$("#content").html @testView.el
			console.log(@testView.el)

	window.gitUsers = new Github.Collection.Users
	route = new Github.Router.Route

	Backbone.history.start()