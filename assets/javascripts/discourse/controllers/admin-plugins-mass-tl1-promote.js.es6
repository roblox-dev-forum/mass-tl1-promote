import { ajax } from "discourse/lib/ajax"
import { popupAjaxError } from "discourse/lib/ajax-error";

export default Ember.Controller.extend({
  loading: false,
  deny: null,
  success: null,

  actions: {
    promote(usernamesText) {
      this.set("loading", true)

      ajax("/admin/plugins/mass-tl1-promote.json", {
        type: "POST",
        data: {
          usernames: usernamesText.split("\n"),
        },
      }).then(result => {
        console.log(result)
        this.set("deny", result.deny)
        this.set("success", result.success)
      }).catch(popupAjaxError).finally(() => {
        this.set("loading", false)
      })
    }
  }
})
