-- Attendance Decider
-- jmont

module Main (main) where

import Data.List.Split

-- Date,Last Name,First Name,Email Address,Status

data AttendanceStatus = Going | NotGoing deriving (Show)

data Member = Member {
    date :: String,
    lastName :: String,
    firstName :: String,
    email :: String,
    status :: AttendanceStatus
} deriving (Show)

mkMember :: String -> Member
mkMember row =
    let [date, last, first, email, status] = splitOn "," row
        attending = if status == "Attending" then Going else NotGoing
     in Member date last first email attending

main = do
    sampleCSVFile <- readFile "src/data/orgSyncSample.csv"
    let (header:rows) = lines sampleCSVFile
    let members = map mkMember rows
    putStrLn $ unlines $ map show members
    return ()
