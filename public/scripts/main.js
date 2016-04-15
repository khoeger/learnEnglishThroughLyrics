placeText = function() {
  var word = document.getElementById('word').value;
  document.getElementById('songTitle').innerHTML = title;
  document.getElementById('songArtist').innerHTML = artist;
  document.getElementById('playingTitle').innerHTML = title;
}

var highlights = function() {
  var word = document.getElementById('word').innerHTML;
  alert(word);
  var lyrics = document.getElementById('lyrics').innerHTML;
  lyrics.replace(word, "<span id=\"highlight\">" + word + "</span>");
}
