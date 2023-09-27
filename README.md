# AI Python Service

## Configuration

The configuration is done via environment variables stored in the `config.txt` file.

For local development, copy the `config.txt.sample` file to `config.txt` to have a
starting point. Then set the `OPENAI_API_KEY` variable to a valid OpenAI API key to
enable that service.

## Building Docker Container

The server is contained entirely within a [Docker](https://www.docker.com/) container that
installs Python 3.11, the Python libraries within `requirements.txt`, and prepares it so
that a subsequent `docker run` command will spawn a webserver.

```
docker build . -f service.Dockerfile -t cdo-ai-py-service
```

## Running Docker Locally

Once you have build the Docker container, and assuming you kept the name
`cdo-ai-py-service`, then you can run the container locally using this
command:

```
docker run -p 8080:8080 --env-file config.txt --rm -it cdo-ai-py-service
```

This, as seen with the `-p` argument, will run a webserver accessible
at [[http://localhost:8080]]. Updating the left-hand side of that
argument will move the port you use to access the webserver.

**Note**: You need to provide the API keys in the `config.txt` file
before the service runs. See the above "Configuration" section.

## Developing

All of our server code is written using [Flask](https://flask.palletsprojects.com/en/2.3.x/) and contained within the `app` directory.

When you make changes, you need to rebuild the docker container before you run it again.

## Testing

You can issue a "test" rubric assessment using hard-coded content that is found in the
`test/data` path by using the `/assessment/test` URL. Here, I'm using `curl` to show
me the headers and send a `POST` to that route (assuming I have the server running):

```
curl localhost:8080/assessment/test -i --header "Content-Type:multipart/form-data" --form "num-responses=3"
```

This gives me this response:

```
HTTP/1.1 200 OK
Content-Length: 2123
Content-Type: text/html; charset=utf-8
Date: Wed, 27 Sep 2023 10:48:36 GMT
Server: waitress

[{"Key Concept": "Program Development 2", "Observations": "The program uses whitespace (e.g., lines 19, 23, 27, 31, 35, 39, 43, 47, 51, 55, 59, 63), good naming conventions (e.g., \"player\", \"burger\", \"sword\", \"sword2\"), indentation (e.g., lines 20-22, 24-26, 28-30, 32-34, 36-38, 40-42, 44-46, 48-50, 52-54, 56-58, 60-62), and comments (e.g., lines 2, 16, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62). The code is easily readable.", "Grade": "Extensive Evidence", "Reason": "The program code effectively uses whitespace, good naming conventions, indentation and comments to make the code easily readable."}, {"Key Concept": "Algorithms and Control Structures", "Observations": "Sprite interactions occur at lines 48-50 (player touches burger), 52 (sword displaces player), and 53 (sword2 displaces player). The program responds to user input at lines 24-26 (up key), 28-30 (left key), and 32-34 (right key).", "Grade": "Extensive Evidence", "Reason": "The game includes multiple different interactions between sprites, responds to multiple types of user input (e.g. different arrow keys)."}, {"Key Concept": "Position and Movement", "Observations": "The program generates movement at lines 14 (sword), 15 (sword2), 20 (player falling), 24-26 (player moving up), 28-30 (player moving left), 32-34 (player moving right). The movement involves acceleration at lines 20, 24-26, 28-30, 32-34.", "Grade": "Extensive Evidence", "Reason": "Complex movement such as acceleration, moving in a curve, or jumping is included in multiple places in the program."}, {"Key Concept": "Variables", "Observations": "The program updates sprite properties inside the draw loop at lines 20 (player.velocityY), 24-26 (player.velocityY), 28-30 (player.velocityX), 32-34 (player.velocityX), 48-50 (burger.x, burger.y). These updates affect the user's experience of playing the game by controlling the player's movement and the burger's position.", "Grade": "Extensive Evidence", "Reason": "The game includes multiple variables or sprite properties that are updated during the game and affect the user's experience of playing the game."}]
```
