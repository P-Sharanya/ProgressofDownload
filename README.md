# ProgressofDownload

📥 URLSession Download Manager – SwiftUI POC

This project is in SwiftUI that demonstrates how to download files using URLSession while showing real-time progress to the user. 
The app supports downloading PDFs, images, and videos, and provides common download controls such as Start, Pause, Resume, Cancel, and Restart.

The main purpose of this project is to understand how file downloads work in iOS and how SwiftUI reacts to state changes during navigation.

---

## Features

* Download files using `URLSessionDownloadTask`
* Supports multiple file types (PDF, image, video)
* Shows:
    * Download progress percentage
    * Downloaded size and total size
    * Current download status
* Pause and resume downloads using resume data
* Cancel downloads while downloading or paused
* Restart download after completion
* Persist download completion state using `UserDefaults`
* Display Downloaded badge only after navigating back to the list screen

---

## App Flow

App launches with a list of downloadable items

User selects an item and navigates to the download screen

User starts the download and views real-time progress

User can pause, resume, or cancel the download

After download completes, a Restart option is shown

When user navigates back, completed items show a Downloaded badge

---

## Architecture & Key Components

* #### DownloadItem
    Model representing a file with a title and URL
* #### DownloadListView
    Displays available downloads and navigation to the progress screen
* #### DownloadProgressView
    Shows progress UI and action buttons based on download state
* #### DownloadViewModel
    Handles download logic using `URLSession` and tracks progress
* #### DownloadStorage
    Uses `UserDefaults` to store titles of completed downloads

---

## How Downloads Work

* The app uses URLSessionDownloadTask, which is suitable for large files. Progress is tracked using URLSessionDownloadDelegate. The app calculates percentage only when the server provides file size. Some servers may not send size information.

* Pause and resume work using resume data provided by the system. Cancel stops the active or paused download and resets the state.

## File Storage Note

Downloaded files are stored in a temporary system location. This project focuses on download tracking, not permanent file storage, so files may not appear in the Files app.

## Conclusion

This project provides a beginner-friendly introduction to downloading files in SwiftUI using URLSession. It demonstrates real-world download behavior, proper state handling, and navigation-based UI updates, making it a solid foundation for building a full download manager.
