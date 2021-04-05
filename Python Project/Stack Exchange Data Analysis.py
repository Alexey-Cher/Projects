#!/usr/bin/env python
# coding: utf-8

# In[135]:


import pandas as pd
import numpy as np
import datetime as dt
import matplotlib.pyplot as plt


# In[134]:


comments = pd.read_csv(r'C:\Users\alexe\Desktop\Stack Exchange\comments.csv',parse_dates = ['CreationDate'])
votes = pd.read_csv(r'C:\Users\alexe\Desktop\Stack Exchange\votes.csv',parse_dates = ['CreationDate'])
posts = pd.read_csv(r'C:\Users\alexe\Desktop\Stack Exchange\posts.csv',parse_dates = ['CreationDate'])
users = pd.read_csv(r'C:\Users\alexe\Desktop\Stack Exchange\users.csv')


# In[40]:


comments.head(1)


# In[6]:


votes.head(1)


# In[94]:


posts.head(1)


# In[15]:


users.head(1)


# # Basic Analysis

# 1.How many post were made each year?

# In[24]:


posts['Year'] = posts['CreationDate'].dt.year
posts.groupby('Year')['Id'].count().to_frame().rename(columns={'Id':'Posts'})


# In[92]:


#Visualization

posts['Year'] = posts['CreationDate'].dt.year
posts['Posts'] = posts.groupby('Year')['Id'].count().to_frame().rename(columns={'Id':'Posts'})

x = posts['Year']
y = posts['Posts']

plt.bar(x.index,y,label="Post",color='Silver')

plt.xlabel('Years')
plt.ylabel('Posts')
plt.title('Posts by years')
plt.legend()
plt.show()


# 2.How many votes were made in each day of the week (Sunday,Monday,Tuesday...)?

# In[161]:


votes['day_week']=votes['CreationDate'].dt.weekday

def weekday_func(day_week):
    if day_week == 6:
        output = 'Sunday'
    elif day_week == 0:
        output = 'Monday'
    elif day_week == 1:
        output = 'Tuesday'
    elif day_week == 2:
        output = 'Wednesday'
    elif day_week == 3:
        output = 'Thursday'
    elif day_week == 4:
        output = 'Friday'
    else:
        output = 'Saturday'
    return output

votes['Day'] = votes['day_week'].apply(weekday_func)

votes.groupby('Day')['Id'].count().to_frame().rename(columns={'Id':'Votes'}).sort_values('Votes', ascending = False)


# 3.List all comments created on September 19th, 2012

# In[97]:


comments['CreationDate'] = pd.to_datetime(comments['CreationDate'])
comments['CreationDate_justdate'] = comments['CreationDate'].dt.floor('d')

date_filter = comments['CreationDate_justdate'] == '2012-09-19'

comments[date_filter]


# 4.List all users under the age of 33, living in London

# In[72]:


filter_1 = users['Age'].notnull()
filter_2 = users['Location'].notnull()

filter_notnull = filter_1 & filter_2
filter_age_loc = users['Location'].str.contains('London') & (users['Age'] < 33)

users[filter_notnull & filter_age_loc].head(3)


# # Advanced Analysis

# 1.Display the number of votes for each post title

# In[94]:


my_join = votes.merge(posts,
                      how = 'right',
                      left_on = 'PostId',
                      right_on = 'Id')

my_join.groupby('Title')['Id_x'].count().to_frame().rename(columns={'Id_x':'Votes'}).head(3)


# 2.Display posts with comments created by users living in the same location as the post creator

# In[222]:


join_1 = comments.merge(users,
                        how = 'inner',
                        left_on = 'UserId',
                        right_on = 'Id')

join_2 = join_1.merge(posts,
                     how = 'inner',
                     left_on = 'UserId',
                     right_on = 'Id')

filter_loc = join_1['Location'] == join_2['Location']
join_1[['Location','Text']][filter_loc].head(3)


# 3.How many users have never voted?

# In[87]:


join_uv = users.merge(votes,
                how = 'left',
                left_on = 'Id',
                right_on = 'UserId')

filter_null = join_uv['PostId'].isnull()
never_voted = join_uv[filter_null]['Id_x'].count()
num_users = users['Id'].count()

"From {} users of Movies & TV Stack Exchange {} users have never voted".format(num_users,never_voted)


# 4.Display all posts having the highest amount of comments

# In[56]:


join_pc = posts.merge(comments,
                     how = 'inner',
                     left_on = 'Id', 
                     right_on = 'PostId')

join_pc.groupby('Title')['Id_y'].count().to_frame().sort_values('Id_y',ascending = False).rename(columns = {'Id_y':'Amount_of_comments'}).head(3)


# 5.For each post, how many votes are coming from users living in Canada? 
# 
# What’s their percentage of the total number of votes?

# In[66]:


join_vp = votes.merge(posts,
                    how = 'inner',
                    left_on = 'PostId',
                    right_on = 'Id')
                    
join_vpu = join_vp.merge(users,
                      how = 'inner',
                      left_on = 'UserId',
                      right_on = 'Id')


# In[67]:


filter_notnull = ~ join_vpu['Location'].isnull()
join_vpu = join_vpu[filter_notnull]


# In[68]:


country_filter = join_vpu['Location'].str.contains('Canada')

votes_canada = join_vpu[country_filter].groupby('Title')['Location'].count().to_frame().rename(columns={'Location':'Votes_Canada'})


# In[69]:


votes_all = join_vpu.groupby('Title')['Location'].count().to_frame().rename(columns={'Location': 'Votes_Global'})


# In[70]:


join_all_canada = votes_all.merge(votes_canada,
                                   how = 'left',
                                   left_on = 'Title',
                                   right_on = 'Title')

join_all_canada['Percentage'] = join_all_canada['Votes_Canada']/join_all_canada['Votes_Global']*100

join_all_canada.head(3)


# 6.How many hours in average, it takes to the first comment to be posted after a creation of a new post?

# In[59]:


comments_min = comments.groupby('PostId')['CreationDate'].min()

my_join = posts.merge(comments_min,
                     how = 'inner',
                     left_on = 'Id',
                     right_on = 'PostId')


my_join['Time_reaction'] = (my_join['CreationDate_y'] - my_join['CreationDate_x'])
reaction_time = my_join['Time_reaction'].mean()

'{} it is average time, what takes to the first comment to be posted after a creation of a new post'.format(reaction_time)


# 7.Whats the most common post tag?

# In[64]:


tag_list = list(posts['Tags'].str.split('><'))
my_list  = list()


for tags in tag_list:
    for tag in tags:
        my_list.append(tag)
        
count_list = [[my_list.count(tag),tag] for tag in set(my_list)]

count_list.sort(reverse=True)
tag = count_list[0]

'The number of uses, and the most common post tag {}'.format(tag)


# 8.Create a pivot table displaying how many posts were created for each year (Y axis) and
# each month (X axis)

# In[149]:


posts['Year'] = posts['CreationDate'].dt.year
posts['Month'] = posts['CreationDate'].dt.month

posts.pivot_table(index = 'Year', columns ='Month', values='Id', aggfunc='count')

