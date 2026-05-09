# Lab 2 Short Response — Group Report

## Results Summary

All metrics below are from Logistic Regression models trained on the recidivism dataset.

| Feature Set | Accuracy | F1 | FNR | FPR |
|---|---|---|---|---|
| all | 0.677 | 0.634 | 0.359 | 0.295 |
| large (|w| > 0.3) | 0.664 | 0.629 | 0.379 | 0.299 |
| non-protected | 0.649 | 0.597 | 0.387 | 0.324 |
| large positive (w > 0.3) | 0.648 | 0.598 | 0.389 | 0.323 |
| large negative (w < -0.3) | 0.630 | 0.594 | 0.418 | 0.328 |
| small (-0.3 < w < 0.3) | 0.611 | 0.519 | 0.420 | 0.371 |
| protected only | 0.609 | 0.556 | 0.437 | 0.357 |

---

## Q1

**The data we used includes protected attributes. Does that mean that the base model we created from it (using all the features) is inherently biased? Can you prove that model using all the data is or is not biased?**

Using protected attributes does not automatically make a model biased, but it is a strong signal worth investigating. In our base model, "Race = African American" carries a positive weight of 0.1908, meaning the model directly uses race to increase predicted recidivism probability. "Age < 25" is the second-highest weighted feature (0.6222), also a protected attribute.

However, proving bias requires more than looking at weights. We would need to compute fairness metrics broken down by protected group — for example, comparing the FPR for African-American defendants versus Caucasian defendants. If those group-level FPRs differ significantly, that constitutes disparate impact (the same finding ProPublica reported for COMPAS). We cannot fully prove or disprove bias from aggregate statistics alone; group-stratified evaluation is required.

---

## Q2

**In this dataset, we saw that using only non-protected attributes only slightly impacted our performance metrics. Assuming that the differences we saw are statistically significant, do we need to use protected attributes? Justify your answer.**

No, we do not need to use protected attributes. The non-protected model achieved accuracy = 0.649 and F1 = 0.597, compared to 0.677 and 0.634 for the full model — a difference of roughly 3–4 percentage points. That modest gain does not justify encoding race, gender, and age directly into a model that affects incarceration decisions.

The more concerning tradeoff is FNR: the non-protected model rises to 0.632 (vs. 0.559 for all features), meaning it misses more actual recidivists. Still, the ethical cost of explicitly discriminating by race or age outweighs this performance difference. Non-protected features alone provide a reasonable basis for prediction without the legal and ethical risks of using protected attributes.

---

## Q3

**If using protected attributes did create a substantially better model (and there were no legal issues), should we include the protected attributes in our model? Justify your answer.**

No. Even if protected attributes produced a substantially better model, including them in criminal justice predictions would mean directly encoding race, gender, and age into decisions about sentencing, bail, and parole. That is discrimination — the model would systematically treat individuals differently based on characteristics beyond their control. The fact that historical data shows correlations between race and recidivism rates does not mean race *causes* recidivism; those correlations reflect systemic inequalities in policing and prosecution. Using them perpetuates those inequalities rather than addressing them.

Performance alone cannot justify fairness violations when the stakes are a person's liberty.

---

## Q4

**Can data that has no protected attributes still be biased? Why or why not.**

Yes. Features that appear neutral can act as proxies for protected attributes. In this dataset, "Prior conviction count" is the strongest predictor (weight 0.8783), but prior conviction rates are themselves shaped by where and how heavily law enforcement operates. Communities that have historically faced over-policing accumulate higher conviction counts not purely from higher crime rates but from greater exposure to the criminal justice system. Similarly, "Charge description = drug related" reflects enforcement patterns that vary heavily by neighborhood and race.

Removing race from the feature list does not remove the racial signal — it is embedded in the other features. This is why even the non-protected model may still produce disparate outcomes across racial groups.

---

## Q5

**What type of error (False Negative vs False Positive) is more harmful in this setting? Justify your answer.**

False Positives are more harmful to individuals. A false positive means predicting that someone will recidivate when they will not, which leads to harsher sentencing, denied parole, or higher bail for a person who posed no future risk. This is a direct injustice — the individual pays the price of incarceration for something they would not have done.

Our base model has a FPR of 0.295, meaning roughly 30% of people who would not have reoffended were still labeled high-risk. The protected-only model has the highest FNR (0.437) and FPR (0.357) of any model — both errors are amplified when only demographic features are used.

A false negative does carry societal risk if the person reoffends, but the principle that punishment should follow demonstrated harm — not predicted harm — supports treating false positives as the more serious error. Incarcerating someone who would have been law-abiding is an irreversible injustice.

---

## Q6

**After doing this lab, what are your views on the COMPAS model with respect to bias and racism? Do you believe that a machine learning model should be used to predict criminal recidivism? Why or why not? Does the context matter?**

Our results support ProPublica's concerns. In our logistic regression model trained on the same Broward County data, "Race = African American" carries a positive weight (0.1908), directly associating race with predicted recidivism. This means the model encodes race as a risk factor, regardless of whether NorthPoint claims predictive parity across groups. Predictive parity and equal FPR/FNR cannot both be satisfied simultaneously in most real-world distributions — and when the base rates differ across groups, achieving one fairness criterion typically violates another.

On the broader question of using ML for criminal recidivism: we are skeptical. The stakes — loss of liberty — are too high for a model operating at 67–68% accuracy with a 42% false positive rate. The data itself is biased by historical disparities in policing and prosecution, so any model trained on it inherits those biases. Additionally, the model captures correlations, not causes, and treating statistical risk as grounds for punishment conflicts with the presumption of innocence.

Context does matter. Using a recidivism score as one input among many, with human oversight and transparency, is different from using it as a primary determinant. Mandatory disclosure of the model's limitations and regular auditing for disparate impact would be minimum requirements. But given the difficulty of satisfying multiple fairness criteria simultaneously — and the real human cost of errors — the bar for deploying such a system should be very high.
