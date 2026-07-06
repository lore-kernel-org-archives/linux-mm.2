Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20CCAC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98AE76B00E2; Mon,  6 Jul 2026 10:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93C366B00E5; Mon,  6 Jul 2026 10:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802526B00E4; Mon,  6 Jul 2026 10:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9BE6B00E0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3F4F1C35B9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:24 +0000 (UTC)
X-FDA: 84958559448.21.119E48C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3F5151A000C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=abdllzGM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htrax+YEkIpwzkVsZ772n3CN6MFRqmzSggoIknmGl8o=;
	b=NjCcq40CzfnZH3u1gZp5NNT9h0Ve0aO5aDjI/tPOdC4kJ8lzTNfu5qY7jMsJXM6tgYIRMY
	WBney6rN0aRKcuAYOQroLQXA7hJMNcuU9VA7NfnJCtlJeFpyCKvmRfZHnXAWSsSb2tFrAF
	MFtsGpjFISC/lDCkojYtzfqsBGdsI0k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=abdllzGM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347563;
	b=ixznoGXvmcOr7YuJbGRTK5Lz7luvs58Gy+fDFrZs7RF8O6Gyd/cdzb/t6AeUyfqWWK2AaK
	P8DfmChcKzxqnJTctPNWBnqnkHn2wQFEok/x7MzL9AznoR0xUxt7B2VQLhsD36TQZKU8Dt
	wE/uymaJc9pVDtA45nczUFR9a4aLdT4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D503C60098;
	Mon,  6 Jul 2026 14:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821271F000E9;
	Mon,  6 Jul 2026 14:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347562;
	bh=htrax+YEkIpwzkVsZ772n3CN6MFRqmzSggoIknmGl8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abdllzGMprRVhyXUtpFPJEcWicX+eU6HU3SiBkcOnHwaCHRR1soSTh9WdrAZ7siXE
	 QneMpcepa2GRYJqrqzXAm/6lbfPjyLvxKaDbjvrQlRlS3R6dHwwlLo8ZXujIUpGpzC
	 4bS7UPGOp0DbFW583Mwo4JgYrYSJQtghkvMkgOSm31CWZWzb+RpgBtLwZJ+MLSN9HY
	 MCFsWgHel0ncyeTGo6MvGPxTwe0s9e8yrSKB5XuJm0Gf3+Rsc3OfFDtH8oTNKV0oS/
	 TrdWAs82CAMUCWnT4HVfwBrVVvQEzctimotqFpJtB92N0OekCwuNlHv3BmZ/kY9bO8
	 KB9dv4znKGlLQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 07/16] mm/damon/core: extend merge function to work with probe hits
Date: Mon,  6 Jul 2026 07:19:01 -0700
Message-ID: <20260706141912.88445-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8ghjgodow7rzuh97twfiomz3xbayq3nj
X-Rspamd-Queue-Id: 3F5151A000C
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783347563-584438
X-HE-Meta: U2FsdGVkX18mL1qmaLBlRVPtx0+2u8Txa2b6TGc3eDGj0zQdCaahldAhNLZDayQvmraTfxfqqgLXHHcjt0U7U5K8M3JRT8FnvobhVodaAiJ/IjiSMrZDndVRblD5uIKltvIPPwSY+KNUVMpGcrDt/XknJyKXsjlwDKOFjOId/OzGMT8tkodoGBwnqgH4mLMTdWgIkCW6XwC6g1ax8NDFDw5PmBrMS7lTnUHvE/8k8lU6ikqVkig/4ebjGJRPGxadOg2qptxGDLdrXgOcjN9DHduUmRVSR1i8JQFCm3/G1lBPIDzDvM+37908VdUxS2S1YKLPzdchBYJr5ibKbzJrcKN55Lz8+5UEDr0x2cCBqnM2qtTg399uEe9WnIekT3nhHV1rKQwsKWU7ixGSDJUDKz2YUhc5DitMe6rRIgXGLrNhGi2cX9Wu13jYVJP2MgO5EPCghJfZ7PHSn5I9avjqOcJko8aKzZayHLi14AO9lTONJ1CK+gOVgnAFCDLp81FxEC0HcWvK0O6yTg4mETeb25cNrhhlDsB9wdlihRjrqGV3FNSgyuRGHDzdd5ED/acvLAO/R+dEKY5vn5MtZT7ocmwgqZygF6hYCbyAaU3W0TPLG3SNFlDTP5AbQlWCAMJewVdmXvLlZwjrlcOcgyhwXiSrqe8vnbnBWDPOY+q528JY6ecYIiT+C/TXKC+YA15dk+RHuEQOSdTS88Wpaw8yu8WDJDUtu2lWd5OAVNLBdaI++RAmSuVoKITvzykXtSqOaYUZrWVDN3hC4py512cEAfb2YUV8ZL88NgwYWViEaklbWY3cTs8WJgdJdhT8D7LwB0/2X2dLOP88Ynyuxfmkhx2OozRuSXw2ho4iIhDCE36uQiBYOQPqTQJQzS12/bGnZZAn9vHFuGwY8Qoa6Zbm3lJmfs1dT/0ssyxGhVMqNyQaryCr8m1OZR2HXqqK9B2oLU4DSFnR4kuvqz4uggS
 YepG1Cvy
 R6wkyikpG360YalZmFYXge3SI2map4kSiRV8lf6H0OTL/lrvonA07xr7BJKAC33zEoz7oUkG8L7583k2scQlf74qE6C4bvxJAwkCqCBbrUFP2bWk4abllMf1lvHK8XdhIzmnkrk+tbu7pwtO6N9aol1SjGy4BIvJ5G0aRvYzMMD5qjoqo9pcsC8rTFSONcGkxslBmd5hU6uz59t0kYMPlCmNjkNH3OjJUaLa/su2I6gn1/gM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are set, users may want DAMON monitoring results to
be optimized for the weights.  For that, regions adjustment should work
for the weighted sum of probe hits.  Extend damon_merge_regions_of() to
detect if the weights are set, and work with probe hits in the case.

The weights setup detection function is incomplete.  It always returns
false.  It is intentional, so that more changes to completely support
weights can be made in an incremental but safe way.  Until the function
is completed, all changes depend on it is no-op, so DAMON works in the
current mode.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             | 48 +++++++++++++++++++++++++++++--------
 mm/damon/tests/core-kunit.h | 13 ++++++++--
 2 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index d7d1e27d767eb..9bb884ab135ec 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -209,6 +209,11 @@ static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
 	return NULL;
 }
 
+static bool damon_has_probe_weights(struct damon_ctx *c)
+{
+	return false;
+}
+
 /*
  * damon_mvsum() - Returns pseudo moving sum value for a time window.
  * @current_nr:		The value of the current aggregation window.
@@ -3231,6 +3236,16 @@ static void damon_merge_two_regions(struct damon_target *t,
 	damon_destroy_region(r, t);
 }
 
+static unsigned int damon_merge_score(struct damon_region *r, bool last,
+		struct damon_ctx *ctx, bool use_probe_hits)
+{
+	if (use_probe_hits)
+		return damon_probe_hits_wsum(r, last, ctx);
+	if (last)
+		return r->last_nr_accesses;
+	return r->nr_accesses;
+}
+
 /*
  * Merge adjacent regions having similar access frequencies
  *
@@ -3239,24 +3254,37 @@ static void damon_merge_two_regions(struct damon_target *t,
  * sz_limit	size upper limit of each region
  */
 static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
-				   unsigned long sz_limit)
+		unsigned long sz_limit, struct damon_ctx *ctx)
 {
 	struct damon_region *r, *prev = NULL, *next;
+	bool use_probe_hits = damon_has_probe_weights(ctx);
 
 	damon_for_each_region_safe(r, next, t) {
-		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
+		unsigned int score, last_score;
+
+		score = damon_merge_score(r, false, ctx, use_probe_hits);
+		last_score = damon_merge_score(r, true, ctx, use_probe_hits);
+
+		if (abs(score - last_score) > thres)
 			r->age = 0;
-		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
+		else if ((score == 0) != (last_score == 0))
 			r->age = 0;
 		else
 			r->age++;
 
-		if (prev && prev->ar.end == r->ar.start &&
-		    abs(prev->nr_accesses - r->nr_accesses) <= thres &&
-		    damon_sz_region(prev) + damon_sz_region(r) <= sz_limit)
-			damon_merge_two_regions(t, prev, r);
-		else
-			prev = r;
+		if (!prev)
+			goto set_prev_continue;
+		if (prev->ar.end != r->ar.start)
+			goto set_prev_continue;
+		if (abs(damon_merge_score(prev, false, ctx, use_probe_hits) -
+					score) > thres)
+			goto set_prev_continue;
+		if (damon_sz_region(prev) + damon_sz_region(r) > sz_limit)
+			goto set_prev_continue;
+		damon_merge_two_regions(t, prev, r);
+		continue;
+set_prev_continue:
+		prev = r;
 	}
 }
 
@@ -3289,7 +3317,7 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 	do {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
-			damon_merge_regions_of(t, threshold, sz_limit);
+			damon_merge_regions_of(t, threshold, sz_limit, c);
 			nr_regions += damon_nr_regions(t);
 		}
 		threshold = max(1, threshold * 2);
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0124f83b39b83..fe948000b72cf 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -226,6 +226,7 @@ static struct damon_region *__nth_region_of(struct damon_target *t, int idx)
 
 static void damon_test_merge_regions_of(struct kunit *test)
 {
+	struct damon_ctx *ctx;
 	struct damon_target *t;
 	struct damon_region *r;
 	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184, 230};
@@ -236,20 +237,27 @@ static void damon_test_merge_regions_of(struct kunit *test)
 	unsigned long eaddrs[] = {112, 130, 156, 170, 230, 10170};
 	int i;
 
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+
 	t = damon_new_target();
-	if (!t)
+	if (!t) {
+		damon_destroy_ctx(ctx);
 		kunit_skip(test, "target alloc fail");
+	}
 	for (i = 0; i < ARRAY_SIZE(sa); i++) {
 		r = damon_new_region(sa[i], ea[i]);
 		if (!r) {
 			damon_free_target(t);
+			damon_destroy_ctx(ctx);
 			kunit_skip(test, "region alloc fail");
 		}
 		r->nr_accesses = nrs[i];
 		damon_add_region(r, t);
 	}
 
-	damon_merge_regions_of(t, 9, 9999);
+	damon_merge_regions_of(t, 9, 9999, ctx);
 	/* 0-112, 114-130, 130-156, 156-170, 170-230, 230-10170 */
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 6u);
 	for (i = 0; i < 6; i++) {
@@ -258,6 +266,7 @@ static void damon_test_merge_regions_of(struct kunit *test)
 		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);
 	}
 	damon_free_target(t);
+	damon_destroy_ctx(ctx);
 }
 
 static void damon_test_split_regions_of(struct kunit *test)
-- 
2.47.3

