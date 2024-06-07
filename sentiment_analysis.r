# Libs
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(stopwords)
library(syuzhet)
library(lubridate)
library(ggplot2)
library(scales)
library(reshape2)
library(dplyr)

# Open doc and convert text into corpus
text = readLines(file.choose())
docs = Corpus(VectorSource(text))

# Get stopwords dict
stopwords_smart = stopwords(source = "smart")
stopwords_snowball = stopwords(source = "snowball")
stopwords_iso = stopwords(source = "stopwords-iso")

# toSpace = content_transformer
# (function (x, pattern)
#   gsub(pattern, " ", x))

# docs1 = tm_map(docs, toSpace, "/")
# docs1 = tm_map(docs, toSpace, "@")
# docs1 = tm_map(docs, toSpace, "#")

# Convert to lowercase
docs1 = tm_map(docs,  content_transformer(tolower))

# Remove numbers
# docs1 = tm_map(docs, removeNumbers)

# Remove white spaces
docs1 = tm_map(docs, stripWhitespace)

# Remove stopwords
docs1 = tm_map(docs, removeWords, stopwords_smart)

# Remove stopwords pass2
docs2 = tm_map(docs1, removeWords, c("tinker", "---", "hero","play", "heroes", "people", "playing", "the", "dota"))

# typeof(docs2)

# Convert to character vector
docs2=unlist(docs2)

dtm = TermDocumentMatrix(docs2)
m = as.matrix(dtm)
v = sort(rowSums(m), decreasing = TRUE)
d = data.frame(word = names(v), freq = v)
head(d, 100)

# Actual sentiment analysis
s <- get_nrc_sentiment(docs2)
View(s)

s2 <- colSums(s)
View(s2)

df_s2_list <- data.frame(as.list(s2))
View(df_s2_list)

# Create the list with the given data
# emotion_data <- list(
#   anger = 394,
#   anticipation = 315,
#   disgust = 251,
#   fear = 381,
#   joy = 216,
#   sadness = 355,
#   surprise = 165,
#   trust = 365,
#   negative = 742,
#   positive = 699
# )

# # Convert the list into a data frame
# emotion_df <- data.frame(
#   emotion = names(emotion_data),
#   count = unlist(emotion_data)
# )
# 
# # Print the data frame to check the data
# View(emotion_df)

# Create the bar chart using ggplot2
ggplot(df_s2_list, aes(x = emotion, y = count)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  theme_minimal() +
  labs(
    title = "Emotion Counts",
    x = "Emotion",
    y = "Count"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


 
# barplot(colSums(s),
#         las = 2,
#         col = rainbow(10),
#         ylab = 'Count',
#         main = 'Sentiment Scores Tweets')
# 

# wordcloud(words = d$word, 
#           freq = d$freq,
#           min.freq = 1, 
#           max.words = 200,
#           random.order = FALSE, 
#           rot.per = 0.35, 
#           colors = brewer.pal(8, "Dark2"))