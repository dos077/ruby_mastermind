function listenSelectOptions() {
  document.querySelectorAll(".options").forEach(function(e) {
     e.addEventListener("click", function() { toggleOpenOptions(e); }, false);
  });
}

function listenSelectColors() {
  document.querySelectorAll(".options div").forEach(function(e) {
     e.addEventListener("click", function() { toggleSelection(e); }, false);
  });
}

function toggleOpenOptions(element) {
  element.classList.toggle('open');
}

function toggleSelection(element) {
  if(element.parentNode.classList.contains('open')) {
      element.parentNode.querySelectorAll("div").forEach( function(e) {
          e.classList.remove('selected')
      } );
      element.classList.add('selected')
  }
}

function submitForm() {
  selections = document.querySelectorAll('.selected')
  if (selections.length == 4) {
    document.querySelector("#guess").value = "";
      selections.forEach( function(e) {
          document.querySelector("#guess").value += e.textContent;
      } );
      document.getElementById("form").submit();
  } else {
      return false;
  }
}