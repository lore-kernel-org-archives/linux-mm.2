Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E25606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=NZvillLN
Received: by kanga.kvack.org (Postfix)
	id CF0326B071E; Tue, 27 Oct 2026 09:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C762C6B0720; Tue, 27 Oct 2026 09:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3EA46B072E; Tue, 27 Oct 2026 09:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 730886B071E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:59:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E62DAA09E4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:59:43 +0000 (UTC)
X-FDA: 85368564246.11.B42905F
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0075F4000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:59:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NZvillLN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of charsyam@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=charsyam@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ql43MqEJknME13oyH0mE3lrKnV2gOIDFu0p5gqyqxnE=;
	b=3BehW5B29KnXrts5wpttKhZsScwffXTAXBxskwF/VMEcOGCLMR6XjX/m3s+72vLfZb2abM
	MWZ1qTP1IVqn7XuURVMGJ64K19ctofTfzeu2JyYHOl8k693kHrYYi1mcJPl+YOGoirO0kz
	ur0vHgfRAbyXcWQLAo7yPsT1CylaV7k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NZvillLN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of charsyam@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=charsyam@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109582;
	b=Y0OMLociywCbnIttjQARdHyKY0hPRibWR2RqmRDZflmTqNcMMvICK+KiWzrLgqpH3YkO72
	+cxOkC9ZgHIMbbIhVCOMenhgF8VW1JfYqn2KXhUOTn395vRi//ueAvwX4tbJpYOiNWXtdW
	j3tPL5g7lZMXKid6WNFXHksNM32Axt0=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ab3f899c8aso745354a91.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793109581; x=1793714381; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ql43MqEJknME13oyH0mE3lrKnV2gOIDFu0p5gqyqxnE=;
        b=NZvillLNUAMVXYGcoWbrgEqlJrIQgOidcHkKSUoRaTQlmV3uatrWmjXjki5w3hdOtH
         Ey9Gu2fdIJK2jW6b2qxSm9z8Wiu4H08QNPSXykfaG8LAxN8jIvUiUqTuyQxHGgwkita/
         Jg6ONR5Qu9FMuEcAM+Cj2BjryYq8z7vd4zsJ9pfk3UYaB6SbelsTfJ+47z4pom+cDuCQ
         6bvQQQUYXpJ0ED0ZYLudcRum4e6cHbQm5OURFWMdAcarmdMfgGb0JmjnLEHr6HGAJN1x
         yeqi69NFtvrvt7MK2AwmTPCZkrasxl3PlMgfW48mG0sN8y1vmB/GqXmQJeNVUAF9bQ/l
         b9tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109581; x=1793714381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ql43MqEJknME13oyH0mE3lrKnV2gOIDFu0p5gqyqxnE=;
        b=TmHMsCmcYc3gSPBL+x2eymIkZex0Dq9vyRdf1KxfpbWd+t5JTQC6rRmPi9V2qEqgfx
         HILPTBGiN+wweQ3n+2mzfAHAPiPQi5qVfwQUJikKrVNedgkSyI084ctnnc6fSydmnKLd
         Ef35kaVxMS1fsbWprD4TPjSEAlxCi0BZrNCmn7ZQhALILKs1ABpAPjkiGOVqzi6w62Rt
         XxEF2UZM42b0P7HKYbQ+69W2m1w6zWYl0miCpJ7eI6YpJxs41ocF56YG4Qep3kZ6k+ek
         W8djniSDSFP9J7i0FZw90LWtT5+/gxxhkWMUU84C7Z7L7sGQVsPIqL9zOulgg7p8lH7u
         nePg==
X-Forwarded-Encrypted: i=1; AKwUvBwhzVqqWIHEknnndO1rMNb90KafipvjUn5dMtWP340a18JG83RyfK8vbL8aIUjLcZukQwj4IslBLA==@kvack.org
X-Gm-Message-State: AFq9FYKY/OakogYP2Qr+1SfNgBNZmcHif7H0taieW8P1ax5gu5wIvb9n
	yb8uX5eM2Ba3+UmHmE4EBIEPf8tX+c6/aUyJ38ysRgMGKbIgbF1Xdh4c
X-Gm-Gg: AYBFou0H0/DnWOFW7QkN7Ipl4WbIKlJePBRh5RV/nIKzgMEWAAAeUY1tGNDyysYAN7K
	dbhtRrVffBlXCuiq5EzoVPkc/Ed95nl4M7paw/rXhw+bI23RkWZtnKt1cblcu3723EAm1CWZkk3
	uWIQWT2m+5QvRHldIYFanR1ZGI8TbtPyjzshaqnEDvlFOVkpFJ587+xjyyjDVqbf1Z66Zkih/Vx
	xj0lkF3Oac5/CFnmPtXxQNB96OT1MRubF3zStLqdxUwb6vqakSqR2Vspgi1imaZpPZx4+ZETZCq
	+j9uKdJbb+JfUpox5K7XeMu+rVPLOYnG0spA1CqSMcmus7GfR3zpdlM59FygN6uhn+vudJRrfeO
	7nSdA5gscKhXdMLMCZFl0Ki5hdmpZsa6UhlkudWirxknUuE+PA0qMBuKZaT5X92pDswNFxzjwXN
	GT84ERJudFZrVEHfuC5LhYKUtdBr5dVaGuDuj37z4ePd0DhtxREO8BZw9wWHHqspReIfyLuBn7v
	9Be4tBMqUi74yllbSodmrgFpmfKwta/UN26RcGi2IDOZdeM
X-Received: by 2002:a17:90b:1c88:b0:3ac:9e5e:d1a5 with SMTP id 98e67ed59e1d1-3adeb173881mr13849327a91.6.1793109580732;
        Tue, 27 Oct 2026 06:59:40 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae404432a5sm4243466a91.9.2026.10.27.06.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:59:40 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [RFC PATCH 2/3] mm/damon/core: avoid overflows in monitoring results calculations
Date: Tue, 27 Oct 2026 22:59:31 +0900
Message-ID: <20261027135932.2301646-3-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261027135932.2301646-1-charsyam@gmail.com>
References: <20261027135932.2301646-1-charsyam@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0075F4000B
X-Rspam-User: 
X-Stat-Signature: 3ufyi9rqgtud95n9nujrxn9zar491pfj
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793109581-396094
X-HE-Meta: U2FsdGVkX1/TvQDPV5qp3cLxT9CyL49UlbADaa91HdgRC1FBsXSaI+L/wukmcoS4ahGWfyiKzsz/nCyjhxp6RRLLtLK1mNNCgPbku2ZPhPPV//ZsUhkF0JiLON/LaEopu7YY4/msWlm2G74Z+nOmA6p6O/woy8Lqe/Ie2MmGfOguOZsmBZU7QHMqR2r0YCIER3HPKsAV6knnP6FgoKlIqX6l4LLfPCTt8y6zNQUJz8xKG9bM89QtFbPRgyeXNgZHjKEeIk7/7uS3D+f7Wzl1ywvxcmF0mUWBJY+q9LmL4VDzKJZLACE7fu/GXcWH/eoh6PqJkdjORVTh7M5nLlvK9KdArJmdROFmEl0/2bG1nSe0N5GQRGWgbNPrf+4M99K7DAsw/vwdLdK7hBFYtttwCgNNkEGUsfCVsfZCN7v44hWUn3C4yDrjfOwgnGRL9+wVDlCZ6Asa0/cjpHz2zagZVzqeP6HLmMygpeVGR9B3IJd1AyexmfAe0ZbJuefK0R3ssBRr/w8Q2hbCwZHtp4VDYL45cM9HSZIgUPW8LoQdmclcydDbsso8hjHXymOXXr82nk/ZPDQpgdbpk9akXpzZukUoW4AoLfN5gOfvKYJ2lFY5djl/CiPpka0GSzzdBDL7Fgqwi6DBNkDMY/nZmhAec8Ih9H1xRnsFjy5TjmyHtqXBND06EeUOfPTWkPMRUTcz5TtPSVxTX8nVU3zDk35XesOidwIbXD0MXv7vNm19ohCbTh0jCp4y7MBfsU6znT2RUF7ECKme9aPp/pxFc/WrU0ZOM8xL4jTYF+rXXJFYxbIKAlcCFojaBzM+cDe3EwIrrNu2SP+lRB9AJSCBeTVdvEErmS4sAFgBMlDxrfABioRSRAjbGIP9HDl3Ce6rOT6AcH20rrtHHx0AY8VCOHQUNjCOdngN359uPXPB9sgan3BLB5eQbMfLNRRr4MjNxx6cG2dTNiUmVNSzzLv1qX1
 v1ruKLjK
 ld0EIuRMqWNdiLmjYYej4Uf37OVWzyz3q2XZ6UN7k7GCepTLDFAUnjkNi7A7omveASK6IZfG37Rmyv8pcSCFuFBrTI2S4cUvCG65jTmimti8Rr8nM2wLx65occDg8OPG/ygtP4eo22qlkR1JNM9oL0+ygw9sFxlpo1OCh8aArD7oZrLUe5NRNHBTVneA6nNHKE10EwB9OoW2ao1QhDQqHhv0gm4qo7FLS0iSl1+TK2vAASldHGhrZ1dLpkl31e3fVOUTigKiGmUMCfYgDa0SvQ0ekjWa2rmFNf6tU/fBpTBzpUWQIdC00SjY7LdKJIhAf21PxgpAwVGO/DuMR1g2QaIhRIblHOmnrI1PKpEEt2FSn8VFxOKDMQ1us13RbdSQSdwZ1ZcOBTrwfIn3yNOWkEZZyjL4g+EvnBapOsAjiQF1/0ugeoGNm0yvdWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When monitoring intervals change, DAMON converts region ages and sample
counts for the new intervals.  The conversions overflow before division:

- damon_age_for_new_attrs() multiplies the age by the old aggregation
  interval in unsigned long.  On 32-bit kernels, the default 100 ms
  interval makes this overflow after about 72 minutes.
- The sample ratio conversions multiply unsigned int values.  They can
  overflow on every architecture when an aggregation has more than
  429,496 samples, such as a 1 ms sample interval and a 430 second
  aggregation interval.

The moving sums also use mult_frac() for the fraction of an aggregation
window that remains and for the previous window's contribution.  On
32-bit kernels, both can overflow with long aggregation intervals.  For
example, 500,000 remaining samples of a 600,000-sample window are
8,333 bp, but the first calculation returns 1,175 bp.

Add damon_mult_frac(), which preserves mult_frac() results when its
intermediates fit, calculates larger remainder products in full width,
and saturates results that exceed unsigned long.  Use it for the
conversions and the moving sums.  Saturate the unsigned int conversion
results at UINT_MAX.

Add KUnit coverage for the helper, the conversions, and the moving sums.

The conversion issues were discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260708140944.F26821F000E9@smtp.kernel.org

Fixes: 2f5bef5a590b ("mm/damon/core: update monitoring results for new monitoring attributes")
Fixes: 9f3786d8602f ("mm/damon/core: introduce damon_nr_accesses_mvsum()")
Fixes: 2ec26dd341d1 ("mm/damon/core: introduce damon_probe_hits_mvsum()")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 mm/damon/core.c             | 41 +++++++++++++++++---
 mm/damon/tests/core-kunit.h | 74 +++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 73b571b429cb..5cd4007cc370 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -281,6 +281,32 @@ static bool damon_has_probe_weights(struct damon_ctx *c)
 	return false;
 }
 
+/*
+ * damon_mult_frac() - calculate @x * @n / @d without overflowing.
+ *
+ * Same as mult_frac(), but the intermediate product of the remainder does not
+ * overflow, and a result that does not fit in unsigned long is saturated to
+ * ULONG_MAX.  Returns the same value as mult_frac() when mult_frac() does not
+ * overflow.  @d must not be zero.
+ */
+static unsigned long damon_mult_frac(unsigned long x, unsigned long n,
+		unsigned long d)
+{
+	unsigned long q = x / d, r = x % d;
+	unsigned long frac;
+
+	if (n && q > ULONG_MAX / n)
+		return ULONG_MAX;
+	if (!n || r <= ULONG_MAX / n)
+		frac = r * n / d;
+	else
+		/* r < d, so the quotient is smaller than n */
+		frac = mul_u64_u64_div_u64(r, n, d);
+	if (frac > ULONG_MAX - q * n)
+		return ULONG_MAX;
+	return q * n + frac;
+}
+
 /*
  * damon_mvsum() - Returns pseudo moving sum value for a time window.
  * @current_nr:		The value of the current aggregation window.
@@ -305,7 +331,7 @@ static bool damon_has_probe_weights(struct damon_ctx *c)
 static unsigned long damon_mvsum(unsigned long current_nr,
 		unsigned long last_nr, unsigned long left_window_bp)
 {
-	return current_nr + mult_frac(last_nr, left_window_bp, 10000);
+	return current_nr + damon_mult_frac(last_nr, left_window_bp, 10000);
 }
 
 /**
@@ -337,7 +363,7 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 	else
 		left_window = ctx->next_aggregation_sis -
 			ctx->passed_sample_intervals;
-	left_window_bp = mult_frac(left_window, 10000, window_len);
+	left_window_bp = damon_mult_frac(left_window, 10000, window_len);
 
 	if (left_window_bp == 10000)
 		return r->last_nr_accesses;
@@ -361,7 +387,7 @@ unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 	else
 		left_window = ctx->next_aggregation_sis -
 			ctx->passed_sample_intervals;
-	left_window_bp = mult_frac(left_window, 10000, window_len);
+	left_window_bp = damon_mult_frac(left_window, 10000, window_len);
 
 	if (left_window_bp == 10000)
 		return r->last_probe_hits[probe_idx];
@@ -990,21 +1016,24 @@ static bool damon_attrs_equals(const struct damon_attrs *attrs1,
 static unsigned int damon_age_for_new_attrs(unsigned int age,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
-	return age * old_attrs->aggr_interval / new_attrs->aggr_interval;
+	return min(damon_mult_frac(age, old_attrs->aggr_interval,
+				new_attrs->aggr_interval), UINT_MAX);
 }
 
 /* convert sample ratio in bp (per 10,000) to count */
 static unsigned int damon_sample_bp_to_count(
 		unsigned int bp, struct damon_attrs *attrs)
 {
-	return bp * damon_nr_samples_per_aggr(attrs) / 10000;
+	return min(damon_mult_frac(bp, damon_nr_samples_per_aggr(attrs),
+				10000), UINT_MAX);
 }
 
 /* convert sample count to ratio in bp (per 10,000) */
 static unsigned int damon_sample_count_to_bp(
 		unsigned int count, struct damon_attrs *attrs)
 {
-	return mult_frac(count, 10000, damon_nr_samples_per_aggr(attrs));
+	return min(damon_mult_frac(count, 10000,
+				damon_nr_samples_per_aggr(attrs)), UINT_MAX);
 }
 
 static unsigned int damon_nr_samples_for_new_attrs(unsigned int nr,
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 43e2f950f8ff..e71e60d59400 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -698,6 +698,64 @@ static void damon_test_update_monitoring_result(struct kunit *test)
 	damon_destroy_ctx(ctx);
 }
 
+static void damon_test_mult_frac(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test, damon_mult_frac(7, 3, 2), 10ul);
+	KUNIT_EXPECT_EQ(test, damon_mult_frac(ULONG_MAX, 0, 1), 0ul);
+	/* the remainder product overflows on 32-bit */
+	KUNIT_EXPECT_EQ(test, damon_mult_frac(524288, 10000, 786432), 6666ul);
+	KUNIT_EXPECT_EQ(test, damon_mult_frac(500000, 10000, 1000000), 5000ul);
+	/* the remainder product overflows even on 64-bit */
+	KUNIT_EXPECT_EQ(test, damon_mult_frac(ULONG_MAX - 1, ULONG_MAX,
+				ULONG_MAX), ULONG_MAX - 1);
+	/* the quotient product overflows */
+	KUNIT_EXPECT_EQ(test, damon_mult_frac(ULONG_MAX, 10000, 1), ULONG_MAX);
+	/* the largest representable result, and one beyond it */
+	KUNIT_EXPECT_EQ(test, damon_mult_frac(ULONG_MAX - ULONG_MAX / 10000,
+				10000, 9999), ULONG_MAX);
+	KUNIT_EXPECT_EQ(test, damon_mult_frac(ULONG_MAX - ULONG_MAX / 10000 + 1,
+				10000, 9999), ULONG_MAX);
+}
+
+static void damon_test_age_for_new_attrs_large_value(struct kunit *test)
+{
+	struct damon_attrs old_attrs = {.aggr_interval = 100000};
+	struct damon_attrs new_attrs = {.aggr_interval = 50000};
+	unsigned int age;
+
+	age = damon_age_for_new_attrs(50000, &old_attrs, &new_attrs);
+	KUNIT_EXPECT_EQ(test, age, 100000u);
+
+	new_attrs.aggr_interval = 1;
+	age = damon_age_for_new_attrs(UINT_MAX, &old_attrs, &new_attrs);
+	KUNIT_EXPECT_EQ(test, age, UINT_MAX);
+
+	old_attrs.aggr_interval = ULONG_MAX;
+	age = damon_age_for_new_attrs(UINT_MAX, &old_attrs, &new_attrs);
+	KUNIT_EXPECT_EQ(test, age, UINT_MAX);
+}
+
+static void damon_test_sample_ratio_large_value(struct kunit *test)
+{
+	struct damon_attrs attrs = {
+		.sample_interval = 1000,
+		.aggr_interval = 600000000,
+	};
+
+	KUNIT_EXPECT_EQ(test, damon_sample_bp_to_count(10000, &attrs),
+			600000u);
+	KUNIT_EXPECT_EQ(test, damon_sample_count_to_bp(600000, &attrs),
+			10000u);
+	KUNIT_EXPECT_EQ(test, damon_sample_count_to_bp(500000, &attrs),
+			8333u);
+	KUNIT_EXPECT_EQ(test, damon_sample_bp_to_count(UINT_MAX, &attrs),
+			UINT_MAX);
+
+	attrs.aggr_interval = attrs.sample_interval;
+	KUNIT_EXPECT_EQ(test, damon_sample_count_to_bp(UINT_MAX, &attrs),
+			UINT_MAX);
+}
+
 static void damon_test_set_attrs(struct kunit *test)
 {
 	struct damon_ctx *c = damon_new_ctx();
@@ -735,6 +793,7 @@ static void damon_test_mvsum(struct kunit *test)
 		3, 10, 5000, 8,		/* 3 + 10 * 0.5 */
 		32, 100, 1000, 42,	/* 32 + 100 * 0.1 */
 		42, 49, 0, 42,		/* 42 + 49 * 0 */
+		0, 600000, 8333, 499980, /* 32-bit remainder product overflow */
 	};
 
 	int i;
@@ -794,6 +853,18 @@ static void damon_test_nr_accesses_mvsum(struct kunit *test)
 				damon_nr_accesses_mvsum(r, c));
 	}
 
+	c->attrs.sample_interval = 1000;
+	c->attrs.aggr_interval = 600000000;
+	c->passed_sample_intervals = 100000;
+	c->next_aggregation_sis = 600000;
+	r->nr_accesses = 100000;
+	r->last_nr_accesses = 600000;
+	KUNIT_EXPECT_EQ(test, damon_nr_accesses_mvsum(r, c), 599980u);
+
+	r->probe_hits[0] = 0;
+	r->last_probe_hits[0] = 100;
+	KUNIT_EXPECT_EQ(test, damon_probe_hits_mvsum(0, r, c), 83);
+
 	damon_free_region(r);
 	damon_destroy_ctx(c);
 }
@@ -2494,6 +2565,9 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_set_regions),
 	KUNIT_CASE(damon_test_nr_samples_per_aggr),
 	KUNIT_CASE(damon_test_update_monitoring_result),
+	KUNIT_CASE(damon_test_mult_frac),
+	KUNIT_CASE(damon_test_age_for_new_attrs_large_value),
+	KUNIT_CASE(damon_test_sample_ratio_large_value),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_mvsum),
 	KUNIT_CASE(damon_test_nr_accesses_mvsum),
-- 
2.43.0


