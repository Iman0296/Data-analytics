import matplotlib.pyplot as plt

# Skills and their frequency (for this role, each appears once)
skills = ["SQL", "Python", "R", "Azure", "Databricks", "AWS", "Pandas", "PySpark", "Jupyter", "Excel"]
frequency = [1]*len(skills)  # each skill appears once

# Create horizontal bar chart
plt.figure(figsize=(10,6))
bars = plt.barh(skills, frequency, color="#4C72B0")
plt.xlabel("Occurrences in Job Posting")
plt.title("Key Skills for Associate Director - Data Insights (Remote)")

# Add labels on bars
for bar, freq in zip(bars, frequency):
    plt.text(bar.get_width() + 0.05, bar.get_y() + bar.get_height()/2,
             f"{freq}", va='center', fontsize=9)

plt.tight_layout()

# Save chart as image
plt.savefig("top_skills_chart.png", dpi=300, bbox_inches='tight')

# Display chart
plt.show()
