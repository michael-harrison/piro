((function(){var a;a=typeof global!="undefined"&&global!==null?global:window,a.PivotalRocketStorage={set:function(a,b){return window.localStorage.setItem(a,JSON.stringify(b)),b},get:function(a){var b,c;return c=window.localStorage.getItem(a),b=c!=null?JSON.parse(c):null,b},delete_by_key:function(a){return window.localStorage.removeItem(a)},get_accounts:function(){return PivotalRocketStorage.get("accounts")||[]},find_account:function(a){var b,c,d,e;e=PivotalRocketStorage.get_accounts();for(c=0,d=e.length;c<d;c++){b=e[c];if(parseInt(b.id)===parseInt(a))return b}return null},save_account:function(a){var b,c,d;return b=!1,c=function(){var c,e,f,g;f=PivotalRocketStorage.get_accounts(),g=[];for(c=0,e=f.length;c<e;c++)d=f[c],d.email!=null?d.email===a.email?(b=!0,g.push(a)):g.push(d):g.push(void 0);return g}(),b===!1&&c.push(a),PivotalRocketStorage.set_accounts(c),a},set_accounts:function(a){return PivotalRocketStorage.set("accounts",a)},delete_account:function(a){var b,c,d,e,f,g,h,i,j,k;c=PivotalRocketStorage.find_account(a),f=PivotalRocketStorage.get_projects(c);if(f!=null)for(g=0,i=f.length;g<i;g++)e=f[g],PivotalRocketStorage.delete_stories(e),PivotalRocketStorage.delete_stories(e,!0);PivotalRocketStorage.delete_project(c),d=[],k=PivotalRocketStorage.get_accounts();for(h=0,j=k.length;h<j;h++)b=k[h],b.id!=null&&parseInt(b.id)!==parseInt(c.id)&&d.push(b);return PivotalRocketStorage.set_accounts(d)},set_projects:function(a,b){return PivotalRocketStorage.set("projects_"+a.id,b)},get_projects:function(a){return PivotalRocketStorage.get("projects_"+a.id)},delete_project:function(a){return PivotalRocketStorage.delete_by_key("projects_"+a.id)},set_stories:function(a,b,c){var d;return c==null&&(c=!1),d=c?"stories_"+a.id:"requester_stories_"+a.id,PivotalRocketStorage.set(d,b)},get_stories:function(a,b){var c;return b==null&&(b=!1),c=b?"stories_"+a.id:"requester_stories_"+a.id,PivotalRocketStorage.get(c)},delete_stories:function(a,b){var c;return b==null&&(b=!1),c=b?"stories_"+a.id:"requester_stories_"+a.id,PivotalRocketStorage.delete_by_key(c)},get_status_stories:function(a,b){var c,d,e,f,g,h,i;b==null&&(b=!1),f=PivotalRocketStorage.get_stories(a,b);if(f!=null){c=[],d=[],e=[];for(h=0,i=f.length;h<i;h++)g=f[h],"unscheduled"===g.current_state?(g.box_class="icebox",e.push(g)):"accepted"===g.current_state?(g.box_class="done",d.push(g)):(g.box_class="current",c.push(g));return{current:c,done:d,icebox:e}}return null},find_story:function(a,b,c){var d,e,f,g,h;c==null&&(c=!1),d=c?"stories_"+a:"requester_stories_"+a,e=PivotalRocketStorage.get(d);if(e!=null)for(g=0,h=e.length;g<h;g++){f=e[g];if(parseInt(f.id)===parseInt(b))return f}return null},get_update_interval:function(){var a;return a=PivotalRocketStorage.get("update_interval"),a==null&&(a=10),a}}})).call(this)
