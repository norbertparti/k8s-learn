from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional
import uvicorn

app = FastAPI(title="Sample REST API",
             description="A sample REST API built with FastAPI",
             version="1.0.0")

# Pydantic models for request/response
class Item(BaseModel):
    id: Optional[int] = None
    name: str
    description: str
    price: float

# In-memory storage
items_db = []

@app.get("/")
async def root():
    return {"message": "Welcome to the FastAPI REST API"}

@app.get("/items", response_model=List[Item])
async def get_items():
    return items_db

@app.get("/items/{item_id}")
async def get_item(item_id: int):
    item = next((item for item in items_db if item.id == item_id), None)
    if item is None:
        raise HTTPException(status_code=404, detail="Item not found")
    return item

@app.post("/items", response_model=Item)
async def create_item(item: Item):
    # Generate ID for new item
    item.id = len(items_db) + 1
    items_db.append(item)
    return item

@app.put("/items/{item_id}", response_model=Item)
async def update_item(item_id: int, updated_item: Item):
    item_idx = next((idx for idx, item in enumerate(items_db) if item.id == item_id), None)
    if item_idx is None:
        raise HTTPException(status_code=404, detail="Item not found")
    
    updated_item.id = item_id
    items_db[item_idx] = updated_item
    return updated_item

@app.delete("/items/{item_id}")
async def delete_item(item_id: int):
    item_idx = next((idx for idx, item in enumerate(items_db) if item.id == item_id), None)
    if item_idx is None:
        raise HTTPException(status_code=404, detail="Item not found")
    
    items_db.pop(item_idx)
    return {"message": "Item deleted successfully"}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
