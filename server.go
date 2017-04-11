package main

import (
	"bytes"
	"image"
	"image/png"
	"log"
	"net/http"
	"os"
	"strconv"
)

func imageHandler(w http.ResponseWriter, r *http.Request) {
	//	http.FileServer(http.Dir("/tmp"))

	img, err := os.Open("/tmp/gopher.png")
	defer img.Close()
	if err != nil {
		log.Println("error opening image: ", err)
	}
	decodedImg, _ := png.Decode(img)
	imageWriter(w, &decodedImg)

}

func imageWriter(w http.ResponseWriter, img *image.Image) {

	buffer := new(bytes.Buffer)
	if err := png.Encode(buffer, *img); err != nil {
		log.Println("error encoding image: ", err)
	}

	w.Header().Set("Content-Type", "image/png")
	w.Header().Set("Content-Length", strconv.Itoa(len(buffer.Bytes())))
	_, err := w.Write(buffer.Bytes())
	if err != nil {
		log.Println("error writing image: ", err)
	}

}

func main() {
	http.HandleFunc("/", imageHandler)
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal("ListenAndServe Error: ", err)
	}
	log.Println("Now listening on 8080")
}
