import pandas as pd
import plotly.graph_objects as go

# Load the CSV
df = pd.read_csv("C:/Users/kelgr/Desktop/MSc/Dissertation/Sankey/Sankey_Buffer.csv")

# Strip '%' and convert to float
df['Area_clean'] = df['Area'].str.rstrip('%').astype(float)
df = df[df['Area_clean'] > 0.0001]  # Remove zero flows

# Drop rows with missing essential values
df.dropna(subset=['SourcePeriod', 'TargetPeriod', 'SourceClass', 'TargetClass'], inplace=True)

# Class names and colors
class_labels = {
    1: "Forest",
    2: "Cropland",
    3: "Shrubland",
    4: "Grassland",
    5: "Built-Up",
    6: "Water",
    7: "Barren"
}

class_colours = {
    "Forest": "#006400",
    "Cropland": "#C8A2C8",
    "Shrubland": "#FCBA03",
    "Grassland": "#FFFF00",
    "Built-Up": "#E30000",
    "Water": "#3A06C9",
    "Barren": "#808080"
}

# Ensure correct types
df['SourcePeriod'] = df['SourcePeriod'].astype(int)
df['TargetPeriod'] = df['TargetPeriod'].astype(int)
df['SourceClass'] = df['SourceClass'].astype(int)
df['TargetClass'] = df['TargetClass'].astype(int)

# Filter valid classes
valid_classes = set(class_labels.keys())
df = df[
    (df['SourceClass'].isin(valid_classes)) &
    (df['TargetClass'].isin(valid_classes))
]

# Label each node before appending %
df['SourceLabelRaw'] = df['SourcePeriod'].astype(str) + " " + df['SourceClass'].map(class_labels)
df['TargetLabelRaw'] = df['TargetPeriod'].astype(str) + " " + df['TargetClass'].map(class_labels)

# Build label map: 1987 = outflow %, others = inflow %
def get_node_total(label):
    year = int(label.split()[0])
    if year == 1987:
        return round(df[df['SourceLabelRaw'] == label]['Area_clean'].sum(), 4)
    else:
        return round(df[df['TargetLabelRaw'] == label]['Area_clean'].sum(), 4)

# Combine labels into a pandas Series before calling pd.unique to avoid FutureWarning
combined_labels = pd.Series(df['SourceLabelRaw'].tolist() + df['TargetLabelRaw'].tolist())
unique_labels = pd.unique(combined_labels)

label_map = {label: f"{label} ({get_node_total(label):.1f}%)" for label in unique_labels}

# Final node list and label-index mappings
nodes = sorted(label_map.keys())  # Full labels before %
node_labels = [label_map[label] for label in nodes]
node_indices = {label_map[label]: i for i, label in enumerate(nodes)}

# Build links
source = df['SourceLabelRaw'].map(lambda x: node_indices[label_map[x]]).tolist()
target = df['TargetLabelRaw'].map(lambda x: node_indices[label_map[x]]).tolist()
value = df['Area_clean'].tolist()

# Extract class from node label for colours
node_colours = [
    class_colours[label.split(" ", 1)[1].split(" (")[0]]
    for label in node_labels
]

# Create Sankey diagram
fig = go.Figure(data=[go.Sankey(
    arrangement='snap',
    textfont=dict(size=16, color='black'),
    node=dict(
        label=node_labels,
        pad=10,
        thickness=25,
        color=node_colours
    ),
    link=dict(
        source=source,
        target=target,
        value=value
    )
)])

# Save to HTML
output_path = "C:/Users/kelgr/Desktop/MSc/Dissertation/Sankey/sankey_buffer_v2.html"
fig.write_html(output_path)
print(f"Sankey diagram saved to {output_path}")
