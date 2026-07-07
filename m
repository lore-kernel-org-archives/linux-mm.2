Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE97C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 04:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A87DF6B00A1; Tue,  7 Jul 2026 00:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17826B00A2; Tue,  7 Jul 2026 00:39:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9547D6B00A3; Tue,  7 Jul 2026 00:39:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65CE56B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:39:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFE358CD32
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:39:05 +0000 (UTC)
X-FDA: 84960725850.25.ADDD7F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3A82040003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:39:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q/aHaq+O";
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783399144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZVvyX+i9YcLqEI8iUP4HbyOAHEh9sHxlQLlUbuG5jmU=;
	b=hhlPmRGqjOV3R51Bn8R0d1AD5jpJo9nPckBHFUYpQ5lkgY7UvZyLRxJdhdztG1V7K5dQgn
	MGdU4koSZUm1EXYWm6MX7cIjVBaInmiuXNA/k6L/Kxm25Xzd4tAEtg4uPy8vKV4RGelGFE
	9Jjaa44vfCWMiJuxangqcnq4QRSFI74=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783399144;
	b=TOiiEb2Y+6Wj77MHSHK2baf/6RPty8qJAYGBHZlhKzRwfB9FQNe4S2ENPYD/+RIcGTNB5U
	lW3lkBwzsN2SwR3V/wGxEcmjJVnu+ARJ731NcVvoVDWkMFo0brTQzJs2HYFD86u45cvV94
	zpxIpLG3bw0hybtAGPsvFqmevhKk85U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q/aHaq+O";
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C57D3618A7;
	Tue,  7 Jul 2026 04:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D285A1F000E9;
	Tue,  7 Jul 2026 04:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783399143;
	bh=ZVvyX+i9YcLqEI8iUP4HbyOAHEh9sHxlQLlUbuG5jmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/aHaq+Oq59ENwXN1PSrrleajOoCVvnhCLjcreyOXd1DAVEfnapa2aTv80PrsuAea
	 KWV/VLnGtFuYtyepU7XkL1YqNvYvyY6hs0WkCit7ck1sH0CEY8M4hjMBu6UKTRfOUg
	 rPlMb83mqr4PnCrEK5F3iCl2kwmgavBNqfBuV4KYx2s1C2Z3Wtj7HWo04kThNAevIM
	 08b8JoqL79+Yz6lj0FbfSJe+Mp24tdc/y5CMeDWhEHekjSfw2Yj1GSbiyl/w2HMZhA
	 zRTNXzC7KAOO0hd4v+p5i29LdKwzKDeoM+vSykmnhPuFU8u3Ke5Y8UX3W3/1YRfPzK
	 o9n+pAby5fZTQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/6] mm/damon/core: s/nr_accesses_to_accesses_bp/sample_count_to_bp/
Date: Mon,  6 Jul 2026 21:38:23 -0700
Message-ID: <20260707043828.97900-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260707043828.97900-1-sj@kernel.org>
References: <20260707043828.97900-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3A82040003
X-Stat-Signature: qgr49asi39qwnepysbret911p8ibkfa9
X-HE-Tag: 1783399144-465664
X-HE-Meta: U2FsdGVkX18KfA/RlDW/UvJ6dQNlJ/ati8Fzsr/69pllgDFMrUxaSqYWtht2QHESBnGlKG1vk7Rj1yXJtYLDAFufLW82xlZkvbamx8iIRH7nQdWNLWVOupTu4QMspvzmF09554syFZEjFnt4+yJLG066EmeVIIy2xVkejTtfatytMEKMULMeaFbfyWMrEG/kZ6p8SBj655Y+Je0AkYhxheffcmWAdEoL+vwu8Qv1a730OoeZOPmVQDP1qZNrQUC7DiD4nmfwBBsfVTQXkSLmZMEFUiaTDl+dHyZfYT37t8NPkR+GIwZuME9Vk8EhsmFDHlvHG+s+oKgKf6/7lkVrWcU9F5fWszxvNT+RxLq3ZFYy6LqBnZ7nY2GkrApwvpwDdS2qzBoAPXClILdgnPIJcbgZcsCqPYbzcTtiXO+tKW81bKSaiYIn+9TNrhyZC0JxE8qcf6DhzVeRvPFFDI/FVSZChQfArHh9kzd/EQoNBtVoYkPCbWkR/klp38MOAYEugx6YEIDYGLR9J4sV6a2fNrjDG5fL45RBxcwwIFfvSOp6+jl9zPyHJsSJiY1hG9OtACNtXpbdmZSeiIXxwzFVmFjuHt1xQgeQjmKOmXPw37/09xfpTZA0wuYrPkGtresjwoAVthUErqq87Z2s4YkdAMWs5YMLK6akef96gZJ386heJ7JFgFwTd03bWHP7sM9wl4segkGrGmkAxhfJgAOkjX6DItYWxaQPPcMkGLzJHYQZT8deVii4tCYKQtSFkXPq3EXGiQHOY+CVuZVlqkfjJ8ia1KqA0jU6GwN5y35Bs1S0PnOoSCGxtT1nKd5ntJ166SOUZb3V28tKQpXVQhZryy80PuTLg1nx65JKKKUyYfYmoJy8UzOpqic6nZm03lzVckRlDLkZh8k7yCDLSEWcyw2YtfVLBFYH0oVExfmN9pflM7LxfsRppCkx0l64b8p6F7zihN2KIdTm1St19se
 m1zdBDmA
 l/xSGMRnpK4k2lFdHzABttQgiPuTksLIe2xnv4AQfOnmsyEsVumS9OdROaxe8T7GqsZT4xmm7ctrl/lE46J3RFVL5vh58rSWzjRIUaXMazczqxJULJvJn7JiwitiDVsouz25E0khJ2be196u3j0Or0OCD46pIYsuuzH2Xa9KFOzykMulpt5bjMfNhqFA/YLYXX6Kq8QrhE5tmNakW3urYbcmkEnPhYY6znTplgo+Gy9FOSOUsZvhs2+2/oDhgEbq2hR4uC6UFpXrWc2bgB4sJ82aknw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_to_accesses_bp() actually converts a positive sample
count to the ratio.  Rename it to better describe what it really does
and not confusing for more general uses.

Also remove the obsolete comment about division-by-zero.  Commit
35d4a3cf70a8 ("mm/damon/ops-common: handle extreme intervals in
damon_hot_score()") modified damon_nr_samples_per_aggr() to always
return non-zero.  Hence no division-by-zero of the note can happen.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             | 17 +++++------------
 mm/damon/tests/core-kunit.h |  8 ++++----
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ca530faaa4f83..718268df27fa7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -883,25 +883,18 @@ static unsigned int damon_sample_bp_to_count(
 	return bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
-/*
- * Convert nr_accesses to access ratio in bp (per 10,000).
- *
- * Callers should ensure attrs.aggr_interval is not zero, like
- * damon_update_monitoring_results() does .  Otherwise, divide-by-zero would
- * happen.
- */
-static unsigned int damon_nr_accesses_to_accesses_bp(
-		unsigned int nr_accesses, struct damon_attrs *attrs)
+/* convert sample count to ratio in bp (per 10,000) */
+static unsigned int damon_sample_count_to_bp(
+		unsigned int count, struct damon_attrs *attrs)
 {
-	return mult_frac(nr_accesses, 10000, damon_nr_samples_per_aggr(attrs));
+	return mult_frac(count, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
 	return damon_sample_bp_to_count(
-			damon_nr_accesses_to_accesses_bp(
-				nr_accesses, old_attrs),
+			damon_sample_count_to_bp(nr_accesses, old_attrs),
 			new_attrs);
 }
 
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0124f83b39b83..86eae3a590354 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -575,7 +575,7 @@ static void damon_test_set_regions(struct kunit *test)
 			}, 3);
 }
 
-static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
+static void damon_test_sample_count_to_bp(struct kunit *test)
 {
 	struct damon_attrs attrs = {
 		.sample_interval = 10,
@@ -585,7 +585,7 @@ static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
 	/*
 	 * In some cases such as 32bit architectures where UINT_MAX is
 	 * ULONG_MAX, attrs.aggr_interval becomes zero.  Calling
-	 * damon_nr_accesses_to_accesses_bp() in the case will cause
+	 * damon_sample_count_to_bp() in the case will cause
 	 * divide-by-zero.  Such case is prohibited in normal execution since
 	 * the caution is documented on the comment for the function, and
 	 * damon_update_monitoring_results() does the check.  Skip the test in
@@ -594,7 +594,7 @@ static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
 	if (!attrs.aggr_interval)
 		kunit_skip(test, "aggr_interval is zero.");
 
-	KUNIT_EXPECT_EQ(test, damon_nr_accesses_to_accesses_bp(123, &attrs), 0);
+	KUNIT_EXPECT_EQ(test, damon_sample_count_to_bp(123, &attrs), 0);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
@@ -1572,7 +1572,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_split_above_half_progresses),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
-	KUNIT_CASE(damon_test_nr_accesses_to_accesses_bp),
+	KUNIT_CASE(damon_test_sample_count_to_bp),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_mvsum),
-- 
2.47.3

