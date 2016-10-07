-- Attendance Decider
-- jmont

module Main (main) where

import Data.List.Split

-- Member

data AttendanceStatus = Going | NotGoing deriving (Show, Eq, Ord)

data Member = Member {
    date :: String,
    lastName :: String,
    firstName :: String,
    email :: String,
    status :: AttendanceStatus
}

mkMember :: String -> Member
mkMember row =
    let [date, last, first, email, status] = splitOn "," $ init row -- have weird tabs at end of line
        attending = if status == "Attending" then Going else NotGoing
     in Member date last first email attending

instance Show Member where
    show m = firstName m ++ " " ++ lastName m ++ " (" ++ email m ++ ") - " ++ show (status m)

sieveByAttendance :: [Member] -> ([Member], [Member])
sieveByAttendance = foldr (\m (going, notGoing) -> if status m == Going then (m:going, notGoing) else (going, m:notGoing)) ([], [])

-- Main

main = do
    sampleCSVFile <- readFile "src/data/orgSyncSample.csv"
    let (header:rows) = lines sampleCSVFile
    let members = map mkMember rows
    let (going, notGoing) = sieveByAttendance members
    putStrLn "~~ Going ~~"
    putStrLn $ unlines $ map show going
    putStrLn "~~ Not Going ~~"
    putStrLn $ unlines $ map show notGoing
    return ()
