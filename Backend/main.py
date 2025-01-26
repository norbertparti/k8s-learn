from fastapi import FastAPI

app = FastAPI(title="Sample REST API",
             description="A sample REST API built with FastAPI",
             version="1.0.0")

@app.get("/")
async def root():
    return {"message": "Welcome to the FastAPI REST API"}
