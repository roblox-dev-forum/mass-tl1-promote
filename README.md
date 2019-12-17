# Plugin: `mass-tl1-promote`

Manually promoting large lists of users from trust level 0 to trust level 1.

---

## Features

- Adds an admin widget on the plugin page at `%BASEURL%/admin/plugins/mass-tl1-promote` that allows an admin user to feed a list of line-separated usernames. When the operation is submitted, the system will then attempt to promote each user in the list to trust level 1.

  <img src=docs/mass-tl1-promote.png width=80%>

  - If a user in the list is already trust level 1 or higher, the system will not modify the user.

  - If a user in the list is suspended, silenced, or has their trust level locked to trust level 0, the system will not modify the user either.

  - The results of the operation (including cases of the two types above) will be reported upon completion to the acting user.

---

## Impact

### Community

No effect.

### Internal

It is easier to perform tactical recruitment on the forum. Instead of needing to go into the admin window and manually promote each user on a large list to trust level 1, forum staff can do this automatically over large amounts of users in a much smaller time span.

### Resources

Some minor performance impact whenever a large operation is performed.

There is no performance impact when the widget is not in use.

### Maintenance

No manual maintenance needed.

---

## Technical Scope

A rails engine is defined to create new endpoints that can be used by the plugin. Standard functionality is used to route the endpoints to the right methods in the engine. The rails engine is constrained to only accept requests sent from forum sessions by an admin user.

The standard recommended functionality is used to add the widget for this plugin to the admin panel for plugins.
