#Ember-Cli-Admin

[![Build Status](https://travis-ci.org/ember-admin/ember-cli-admin.svg?branch=master)](https://travis-ci.org/ember-admin/ember-cli-admin)

Ember-cli-admin is a powerful admin dashboard for ember-cli projects that is built on ideas of [ActiveAdmin][2] and [AbAdmin][3].

##Version

0.1.1

##Installation

```
npm install ember-cli-admin --save-dev
```

##Setup

###In your app.js


Add ```AdminResolver```:
```
...
#app/app.js
import AdminResolver from 'ember-cli-admin/admin-resolver';
App = Ember.Application.extend({
  Resolver: AdminResolver
});
...

export default App;
```

###In your router.js

```
#app/router.js
---
import MetaRoute from 'ember-cli-admin/dsl/meta-route';
var Router;

Router = Ember.Router.extend({
  ...
});

Router.map(function() {
  return this.route("dashboard", {path: "/"});
});

MetaRoute.map(Router, function() {
  # we'll add routes for our resources here in the next step
});

export default Router;
```

###Now let's set up resources

For example, if we have the following model:

```
#app/models/user.js
import DS from 'ember-data';

export default DS.Model.extend({
  email: DS.attr('string'),
  name: DS.attr('string'),
  updated_at: DS.attr('string'),
  created_at: DS.attr('string')
});

```
To add users resource to admin dashboard, just setup users controller like this:

```
#app/controllers/users.js
import TableViewController from 'ember-cli-admin/mixins/controllers/table-view';

export default Ember.ObjectController.extend(TableViewController);

```
And add resources to your router:

```
#app/router.js
...
MetaRoute.map(Router, function() {
  this.resources("users");
});
...
```

You'll also need to add Navigation initializer to set up your navigation bar:

```
#app/initializers/navigation.js

import Navigation from 'ember-cli-admin/dsl/navigation';

export default {
  name: 'navigation',
  initialize: function(container, app) {
    return Navigation.map(function() {
        //Dashboard page
        //You can override this if you don't use dashboard
      this.navigate("Dashboard", { route: "dashboard" });
      this.navigate("Admin", function() {
        return this.navigate("Users");
      });
    });
  }
};

```
###Form fields

You can specify the attributes to use in admin form with ```formFields``` property in the model:

```
#app/models/user.js
...
export default DS.Model.extend({
  ...
  formFields: ['email', 'name']
});  
```
###Ember-cli-admin also uses [ember-cli-map][4]

We currently support ```google-map``` component which can be added to your resource form with the following simple setup

```
#app/models/user.js
...
export default DS.Model.extend({
  ...
  lat:                        DS.attr('number')
  long:                       DS.attr('number')
  zoom:                       DS.attr('number')

  asGoogleMap: ['lat', 'long', 'zoom']
 
});
```

And don't forget to add Google Maps to your ```index.html```
```
  <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&key={your API key}&libraries=places">
  </script>
```

For more info see [ember-cli-map README][4].

###Fileuploads

Say, our user has one main avatar and/or many avatar pictures.

To display and upload them in admin interface, do the following setup.

First, add avatar model extending it from ember-cli-admin Asset:

```
#app/models/avatar.js
import Asset from 'ember-cli-admin/logics/asset';
import DS from 'ember-data';

export default Asset.extend();
```

Add avatar/avatars to User model, and specify them on ```fileuploads``` property:

```
#app/models/user.js
...
export default DS.Model.extend({
  ...
  avatar:                     DS.belongsTo('avatar'),
  avatars:                    DS.hasMany('avatar', {async: true}),
  
  fileuploads: ["avatar", "avatars"]
});
```
That's it!



##License


[Licensed under MIT license] [1]

[1]:http://opensource.org/licenses/mit-license.php
[2]:https://github.com/activeadmin/activeadmin
[3]:https://github.com/leschenko/ab_admin
[4]:https://github.com/ember-admin/ember-cli-map