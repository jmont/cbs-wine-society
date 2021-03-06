-- Attendance Decider
-- jmont

module Main (main) where

import Data.List.Split
import System.Random

-- Shuffle

shuffle :: [a] -> IO [a]
shuffle [] = return []
shuffle xs = do
    randomPosition <- getStdRandom (randomR (0, length xs - 1))
    let (left, (a:right)) = splitAt randomPosition xs
     in fmap (a:) (shuffle (left ++ right))

-- Member

data AttendanceStatus = Going | NotGoing deriving (Show, Eq, Ord)

data Member = Member {
    date :: String,
    lastName :: String,
    firstName :: String,
    email :: String,
    status :: AttendanceStatus
}

kEventMax = 40

mkMember :: String -> Member
mkMember row =
    let [date, last, first, email, status] = splitOn "," $ init row -- have weird tabs at end of line
        attending = if status == "Attending" then Going else NotGoing
     in Member date last first email attending

instance Show Member where
    show m = firstName m ++ " " ++ lastName m ++ " (" ++ email m ++ ") - " ++ show (status m)

sieveByAttendance :: [Member] -> ([Member], [Member])
sieveByAttendance = foldr (\m (going, notGoing) -> if status m == Going then (m:going, notGoing) else (going, m:notGoing)) ([], [])

takeDrop :: Int -> [a] -> ([a], [a])
takeDrop n xs = (take n xs, drop n xs)

-- Main

main = do
    sampleCSVFile <- readFile "src/data/orgSyncSample.csv"
    let (header:rows) = lines sampleCSVFile
    let members = map mkMember rows
    let (going, notGoing) = sieveByAttendance members
    shuffled <- shuffle going
    let (chosen, waitlist) = takeDrop kEventMax shuffled
    putStrLn "~~ Going ~~"
    putStrLn $ unlines $ map show chosen
    putStrLn "~~ Waitlist ~~"
    putStrLn $ unlines $ map show waitlist
    putStrLn "~~ Not Going ~~"
    putStrLn $ unlines $ map show notGoing
    return ()
