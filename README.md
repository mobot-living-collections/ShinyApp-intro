# Shiny App tutorial in R

https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/index.html

# How to share a Shiny App

from https://shiny.posit.co/r/getstarted/shiny-basics/lesson7/

**When it comes to sharing Shiny apps, you have two basic options:**

- Share your Shiny app as R scripts. This is the simplest way to share an app, but it works only if your users have R on their own computer (and know how to use it). Users can use these scripts to launch the app from their own R session, just like you’ve been launching the apps so far in this tutorial.

- Share your Shiny app as a web page. This is definitely the most user friendly way to share a Shiny app. Your users can navigate to your app through the internet with a web browser. They will find your app fully rendered, up to date, and ready to go.

Anyone with R can run your Shiny app. They will need a copy of your app.R file, as well as any supplementary materials used in your app (e.g., www folders or helpers.R files).
library(shiny)
runApp("census-app")

Shiny has three built in commands that make it easy to use files that are hosted online: runUrl, runGitHub, and runGist.

# runUrl
runUrl will download and launch a Shiny app straight from a weblink.
- Save your Shiny app’s directory as a zip file
- Host that zip file at its own link on a web page. Anyone with access to the link can launch the app from inside R by running:
  library(shiny)
  runUrl( "<the weblink>")

# runGitHub
To share an app through GitHub, create a project repository on GitHub. Then store your app.R file in the repository, along with any supplementary files that the app uses.
runGitHub( "<your repository name>", "<your user name>")

# runGist
If you want an anonymous way to post files online, GitHub offers a pasteboard service for sharing files at gist.github.com. You don’t need to sign up for a GitHub account to use this service. Even if you have a GitHub account, gist can be a simple, quick way to share Shiny projects.
To share your app as a gist:
- Copy and paste your app.R files to the gist web page.
- Note the URL that GitHub gives the gist.
Once you’ve made a gist, your users can launch the app with runGist("<gist number>") where "<gist number>" is the number that appears at the end of your Gist’s web address.
runGist("eb3470beb1c0252bd0289cbc89bcf36f")

# Other resources
- https://shiny.posit.co/
- https://shiny.posit.co/r/gallery/
