import requests
import urllib.request
import time
from bs4 import BeautifulSoup

url = "https://azure.microsoft.com/en-us/services/"
response = requests.get(url)
html = BeautifulSoup(response.text, "html.parser")

for service in html.findAll(True, {"data-event":["area-products-index-clicked-product"]}):
    item = service.parent
    # cat = item.parent.h2.text
    # print(cat)
    title = item.span.text
    desc = item.p.text
    print(title + '|' + desc)
