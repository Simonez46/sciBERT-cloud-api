from fastapi import FastAPI, Request
from pydantic import BaseModel
from transformers import AutoTokenizer, AutoModel
import torch

app = FastAPI()

# Load SciBERT
tokenizer = AutoTokenizer.from_pretrained("allenai/scibert_scivocab_uncased")
model = AutoModel.from_pretrained("allenai/scibert_scivocab_uncased")

class Question(BaseModel):
    text: str

@app.post("/ask")
def ask_scibert(question: Question):
    inputs = tokenizer(question.text, return_tensors="pt", truncation=True, max_length=512)
    with torch.no_grad():
        outputs = model(**inputs)
    cls_embedding = outputs.last_hidden_state[:, 0, :].squeeze().tolist()
    return {
        "message": "Input ricevuto e analizzato da SciBERT.",
        "embedding_preview": cls_embedding[:5]  # Mostra solo primi 5 valori per esempio
    }
