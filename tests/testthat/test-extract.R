context("extract")

test_that("extract_title works as expected", {
  s1in <- "## My Title\n"
  s1out <- "My Title"
  s2in <- "\n## My Title\n"
  s2out <- "My Title"
  s3in <- "\n## My Title\nSomeMoreText"
  s3out <- "My Title"
  expect_equal(extract_title(s1in), s1out)
  expect_equal(extract_title(s2in), s2out)
  expect_equal(extract_title(s3in), s3out)
  expect_error(extract_title("Nothing"))
  expect_error(extract_title("##WrongFormat"))
  expect_error(extract_title("## T1\n## T2"))
})

test_that("extract_html works as expected", {
  s1in <- "Just some text"
  s1out <- "<p>Just some text</p>\n"
  s1out2 <- "Just some text"
  s2in <- "\n## Title\nAnd some text"
  s2out <- "<p>And some text</p>\n"
  s2out2 <- "\nAnd some text"
  s3in <- "\n## Title\n\n\nLonely Text\n\n\n"
  s3out <- "<p>Lonely Text</p>\n"
  s3out2 <- "\n\n\nLonely Text\n\n\n"
  expect_equal(extract_html(s1in, TRUE), s1out)
  expect_equal(extract_html(s2in, TRUE), s2out)
  expect_equal(extract_html(s3in, TRUE), s3out)
  expect_equal(extract_html(s1in, FALSE), s1out2)
  expect_equal(extract_html(s2in, FALSE), s2out2)
  expect_equal(extract_html(s3in, FALSE), s3out2)
})

test_that("extract_code works as expected", {
  s1in <- "```{r}\nsome_code_here\n```\n"
  s1out <- "some_code_here"
  s2in <- "```{r}\n```\n"
  s2out <- ""
  s3in <- "```{r}\nsome_code_here\n```\n\n```{r}\nmore_code_here\n```\n"
  s4in <- "```{r}\nsome_string<-\"abc\"\n```\n"
  s4out <- "some_string<-\"abc\""
  expect_equal(extract_code(s1in), s1out)
  expect_equal(extract_code(s2in), s2out)
  expect_error(extract_code(s3in))
  expect_equal(extract_code(s4in), s4out)
  
  s1in <- "```{python}\nsome_code_here\n```\n"
  s1out <- "some_code_here"
  s2in <- "```{py}\n```\n"
  s2out <- ""
  s3in <- "```{python}\nsome_code_here\n```\n\n```{python}\nmore_code_here\n```\n"
  s4in <- "```{python}\nsome_string<-\"abc\"\n```\n"
  s4out <- "some_string<-\"abc\""
  expect_equal(extract_code(s1in), s1out)
  expect_equal(extract_code(s2in), s2out)
  expect_error(extract_code(s3in))
  expect_equal(extract_code(s4in), s4out)
  
})

test_that("extract_as_* works as expected", {
  s1in <- "\n- a\n- b\n- c\n- d"
  s1out <- c("a","b","c","d")
  s2in <- "\n- a\n- b\n   - sub-a\n   - sub-b\n- c"
  s2out <- c("a", "b\n\n<ul>\n<li>sub-a</li>\n<li>sub-b</li>\n</ul>", "c")
  s3in <- "\n-blereasdfasdf\n-asdfasdf\n"
  s4in <- ""
  s5in <- NULL
  
  expect_equal(extract_as_vec(s1in), s1out)
  expect_equal(gsub("\n", "", extract_as_vec(s2in)), gsub("\n", "", s2out))
  expect_error(extract_as_vec(s3in))
  expect_equal(extract_as_vec(s4in), "empty")
  expect_equal(extract_as_vec(s5in), "empty")
  
  expect_equal(extract_as_list(s1in), as.list(s1out))
})

test_that("extract_markdown works as expected", {
  s0in <- "\n\nsome text here\n\n\n"
  expect_error(extract_markdown(s0in))
  s1in <- "\n{{{testname}}}\nsome text here\n\n\n"
  expect_equal(extract_markdown(s1in), toJSON(c(testname = "some text here")))
  s2in <- "{{{my_doc.Rmd}}}\nsome text here\n"
  expect_equal(extract_markdown(s2in), toJSON(c(my_doc.Rmd = "some text here")))
  s3in <- "{{{my_doc.Rmd}}}\n\n\nsome_code_here\n\n\n{{{my_doc_2.Rmd}}}\n\n\nmore_code_here\n\n"
  expect_equal(extract_markdown(s3in), toJSON(c(my_doc.Rmd = "some_code_here", my_doc_2.Rmd = "more_code_here")))
  s4in <- "\n{{{my_doc.Rmd}}}\nsome_code_here\n```\n\n{{{my_doc_2.Rmd}}}\nmore_code_here\n***\n"
  expect_equal(extract_markdown(s4in,"testname"), toJSON(c(my_doc.Rmd = "some_code_here\n```", my_doc_2.Rmd = "more_code_here\n***")))
})

test_that("extract_skills works as expected", {
  s1in <- "1,2,3"
  s1out <- list("1","2","3")
  s2in <- "1,2,3"
  s2out <- s1out
  s3in <- list(content = "1,2")
  s3out <- list("1","2")
  s4in <- list(content = "1")
  s4out <- list("1")
  s5in <- list(content = "10,1")
  s6in <- "10,1"
  s7in <- list(content = "9")
  s8in <- "9"
  s9in <- list(content = "0")
  s10in <- "0"
  expect_equal(extract_skills(s1in), s1out)
  expect_equal(extract_skills(s2in), s2out)
  expect_equal(extract_skills(s3in), s3out)
  expect_equal(extract_skills(s4in), s4out)
  expect_error(extract_skills(s5in))
  expect_error(extract_skills(s6in))
  expect_error(extract_skills(s7in))
  expect_error(extract_skills(s8in))
  expect_error(extract_skills(s9in))
  expect_error(extract_skills(s10in))
})

test_that("extract_link works as expected", {
  s1in <- "//player.vimeo.com/video/144351865"
  s2in <- "\n//player.vimeo.com/video/144351865\n\n"
  s3in <- "```{r,eval=FALSE}\n//player.vimeo.com/video/144351865\n```\n"
  s4in <- "\n\n```{r,eval=FALSE}\n//player.vimeo.com/video/144351865\n```\n"
  s5in <- "```{python,eval=FALSE}\n//player.vimeo.com/video/144351865\n```\n"
  s6in <- "\n\n```{python,eval=FALSE}\n//player.vimeo.com/video/144351865\n```\n"
  sout <- "//player.vimeo.com/video/144351865"
  expect_equal(extract_link(s1in), sout)
  expect_equal(extract_link(s2in), sout)
  expect_equal(extract_link(s3in), sout)
  expect_equal(extract_link(s4in), sout)
  expect_equal(extract_link(s5in), sout)
  expect_equal(extract_link(s6in), sout)
})