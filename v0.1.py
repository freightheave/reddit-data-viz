import praw

reddit = praw.Reddit(
    client_id="OBFUSCATED", #remember to obfuscate/revoke before pushing!
    client_secret="OBFUSCATED", #remember to obfuscate/revoke before pushing!
    user_agent="OBFUSCATED"
)
print(reddit.read_only)

for submission in reddit.subreddit("Dota2").hot(limit=10):
    print(submission.title)