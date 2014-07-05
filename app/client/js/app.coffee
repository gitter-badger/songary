goog.provide 'App'

class App

  ###*
    @param {este.Router} router
    @param {app.Routes} routes
    @param {app.react.App} reactApp
    @param {Element} element
    @param {app.Title} appTitle
    @param {app.songs.Store} songsStore
    @constructor
  ###
  constructor: (router, routes, reactApp, element, appTitle,
      songsStore) ->

    routes.addToEste router
    router.listen 'error', (e) ->
      # PATTERN(steida): Here we can handle various errors.
      # For server error, alert something like "Try it later...".
      # For client error, log it.
      # We can decide by: e.reason
      alert e.reason
      # TODO(steida): For client-side error, show popup link to reload app.
      # Don't reload automatically since it can cause loop.

    # PATTERN(steida): Listen all listenables representing app state here.
    # Don't worry about performance, all data should be fetched already.
    # Only data supposed to be shown are processed with React DOM diff.
    for listenable in [
      # TODO(steida): Check, what if store dispatches before routes.
      routes
      songsStore
    ]
      listenable.listen 'change', ->
        document.title = appTitle.get()
        if !@component
          @component = React.renderComponent reactApp.create(), element
          return

        # PATTERN(steida): Since React component is already rendered, all we
        # need is forceUpdate. Remember this article?
        # http://swannodette.github.io/2013/12/17/the-future-of-javascript-mvcs/
        # Om is using props, so it needs to deal with http://facebook.github.io/react/docs/component-specs.html#updating-shouldcomponentupdate.
        # Este.js does not use React props nor state, because app state is
        # stored in app stores. Therefore we can update DOM via forceUpdate
        # super fastly, because forceUpdate skips shouldComponentUpdate method.
        # React props and state are nice and all, but for Este.js, it's better
        # to store app state out of React components, because isomorphic-ness.
        @component.forceUpdate()

    router.start()