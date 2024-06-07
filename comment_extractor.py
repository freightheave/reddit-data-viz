import praw
import csv

reddit = praw.Reddit(
    client_id="OBFUSCATED", #remember to obfuscate/revoke before pushing!
    client_secret="OBFUSCATED", #remember to obfuscate/revoke before pushing!
    user_agent="OBFUSCATED"
)

file = open("new_urls.csv", "r", newline = '')
commentString = list(csv.reader(file,quotechar='"', delimiter=',', skipinitialspace = True))
file.close()

cleaned_commentString = [row[0] for row in commentString]

for i in range(len(cleaned_commentString)): 

    print(commentString[i])
    submission = reddit.submission(cleaned_commentString[i])
    submission.comments.replace_more(limit=0)
    #comment_struct = submission.comments.list() #Storing the comments in a struct but not actually needed as comments are being read directly from submission.comments method.

    def comment_writer(comment_arg, fileName_arg, level = 0):
        #defining indent level per child comment:
        indent = ' ' * (level * 4)
        #encoded_body = comment.body.encode('utf-8', errors='replace').decode('utf-8')
        file.write(f"{indent}{comment_arg.body}\n")

        for reply in comment_arg.replies:
            comment_writer(reply, fileName_arg, level + 1)

    fileName = str(cleaned_commentString[i]) + ".txt"

    with open (fileName, "w", encoding="utf-8") as file:
        for comment in submission.comments:
            comment_writer(comment, file)
            #file.write("---\n")

    print(str(submission.comments.__len__()) + ' ' + f"top level comments have been written to {fileName}")
