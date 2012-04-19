jQuery ->
	window.Github = {
		Model: {}
		View: {}
		Collection: {}
	}

	class Github.Model.User extends Backbone.Model

	class Github.Collection.Users extends Backbone.Collection
		model: Github.Model.User

	class Github.View.Viewer extends Backbone.View
		el: 'body'
		initialize: ->
			gitUsers.on 'add', @test
			@render()
		render: ->
			$(@el).append '<button id="add-user">Add User</button>'
		showPrompt: ->
			userName = prompt "Enter Username:" 
			githubUser = new Github.Model.User
			githubUser.url = "https://api.github.com/users/#{userName}"
			githubUser.fetch
				success: ->
					gitUsers.add githubUser

		test: (model) ->
			$("#user-list").append("<img src=#{model.get('avatar_url')} />");
		events:
			"click #add-user": "showPrompt"

	window.gitUsers = new Github.Collection.Users
	viewer = new Github.View.Viewer

