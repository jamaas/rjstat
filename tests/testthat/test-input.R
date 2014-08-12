context("Input")

oecd <- readLines("oecd-canada.json")
non_unique <- data.frame(V1 = c("a", "a"), V2 = c("b", "b"), value = 1:2)

test_that("wrong input fails", {
    expect_that(fromJSONstat(1), throws_error("is not a character vector"))
    expect_that(fromJSONstat(character(0)), throws_error("not greater than 0"))
    expect_that(fromJSONstat(oecd, 1), throws_error("is not a string"))
    expect_that(fromJSONstat(oecd, letters), throws_error("is not a string"))
    expect_that(fromJSONstat(oecd, "a"),
                throws_error("naming must be \"label\" or \"id\""))
    expect_that(toJSONstat(1),
                throws_error("(?:.*is not a data frame)(?:.* is not a list)"))
    expect_that(toJSONstat(fromJSONstat(oecd), letters),
                throws_error("is not a string"))
    expect_that(toJSONstat(list(1)), throws_error("is not a data frame"))
    expect_that(toJSONstat(non_unique),
                throws_error("non-value columns must constitute a unique ID"))
})

test_that("correct input doesn't fail", {
    expect_that(fromJSONstat(oecd, naming = "label", use_factors = F),
                not(throws_error()))
    expect_that(fromJSONstat(oecd, naming = "label", use_factors = T),
                not(throws_error()))
    expect_that(fromJSONstat(oecd, naming = "id", use_factors = F),
                not(throws_error()))
    expect_that(fromJSONstat(oecd, naming = "id", use_factors = T),
                not(throws_error()))
})

test_that("round-trip works", {
    df1 <- fromJSONstat(oecd, use_factors = T)
    df2 <- fromJSONstat(toJSONstat(df1, digits = 8), use_factors = T)
    expect_that(df1, equals(df2))
})