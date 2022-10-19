module Web.View.Posts.Show where
import Web.View.Prelude
import qualified Text.MMark as MMark


data ShowView = ShowView { post :: Include "comments" Post }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>{post.title}</h1>
        <p>{post.createdAt |> dateTime}  {post.createdAt |> timeAgo}</p>
        <div>{post.body |>renderMarkdown}</div>

        <a href ={NewCommentAction post.id}> Add comment</a>
        <div>{forEach post.comments renderComment}</div>
        

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Posts" PostsAction
                            , breadcrumbText "Show Post"
                            ]

renderMarkdown text =case text |> MMark.parse "" of
                    Left error -> "Something went Wrong"
                    Right markdown -> MMark.render markdown |>tshow |>preEscapedToHtml

renderComment comment = [hsx|
<div>
    
           <div style="width:80%;Text-align:left;float:left;">
           <b>{comment.author}</b></div>
           <div style="Text-align:right;Width:20%;float:right">
           <b>{comment.createdAt |>dateTime}</b></div>
    
    <p>{comment.body}</p>
    </div>
|]