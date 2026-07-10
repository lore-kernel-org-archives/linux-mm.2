Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F33B8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19A7D6B009B; Fri, 10 Jul 2026 09:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FD826B009E; Fri, 10 Jul 2026 09:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0129A6B009D; Fri, 10 Jul 2026 09:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE99E6B0099
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 777BE1C8917
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:05 +0000 (UTC)
X-FDA: 84972993210.19.A6928F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BF24B14000B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ibhPBefF;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ywtTSlgg2gQ8bR9Osnueml1K534EMkMwLNfCemx+LA=;
	b=wwfq37njvF7kh/Fj/8YObas8kk5tRBmw10fz//9l8O4eLPdH5N5snSODGFfmzm5a2GFhbG
	G8nIXTACy4Kj0EU9FwLFutaLAos85e8TU/678NB8oo/fUpWonsQHeCZyMBW5zj9rxLtG4j
	48z0im9V7YRa87zE49RoM2ztVsC2+bc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ibhPBefF;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691223;
	b=0uyvSCZs+UhR/69kAVjXhA3C+Hk5NKqbPrc3YMzwgMIuqYq2QhkW/mJPp64d/ts0hlxFAv
	Pa6MvJVhP/KOis2SZkNS6RHMFucmb9VRRWzpPbwDDwftB1PRW9hVRfDcyU6LCWRcsENp+O
	gDsltODEy1hm2j0oA+SchKqgAwNc4Io=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F87B43F3C;
	Fri, 10 Jul 2026 13:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D198F1F00A3E;
	Fri, 10 Jul 2026 13:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691223;
	bh=7ywtTSlgg2gQ8bR9Osnueml1K534EMkMwLNfCemx+LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibhPBefFgQqQWXV2JLPyiAOg/LJ+OFQrg4mGoBe9NBdXQPUMFxKQ+lQV3e9NXU+J7
	 1cQlsYhOeRFc+HXEH+wzoJt9rDTcZUK9JiV8UFlHglWpfGMjp6GTLGrZ1s9sv5Qk1z
	 1hnmYARF+MOLZ5TmrquzFXyk6Yy16WrbXLFToGL/gDzLv/sKJegD6hmOL9Eq3cVqb3
	 BZdtAUqFQ7g1z53jWhjT1M0JoGAX5cZwciBZc77BERcLzbUorVmGEHD0lZot7QH9/Q
	 4K5hEUpmcT/OqjYEIZgZ0YiirAWC/0mk9d83f2AiuMJt6IpfYjc3ZHhiwycVZk56KK
	 38HKK6QYMREXA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/19] mm/damon/core: extend merge function to work with probe hits
Date: Fri, 10 Jul 2026 06:46:37 -0700
Message-ID: <20260710134651.18084-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zhjac7h5icr91cs36bwnstgrw15pr7w5
X-Rspamd-Queue-Id: BF24B14000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783691223-402641
X-HE-Meta: U2FsdGVkX18JU4wVttVZfKkAcLNjazJW0UcXBvKHdJ9vQZx28d2AwHTLid9G17PMFaplpwtrGh9dRW8KKzPOCXQvzGAqlQBD92BYtcClZJVcz350ZDwMl/vkV19Q8cAWbL8z/q34hDMJDVSU2260e4/igCgFnsEkcnq7RUNsvCI6vN4mu7wDGswU2xE041HZgrG6tiZQO+LRTSmQic7vaBQfOPTmZs5IrNV9FBnNmn/j0AP8lj0Cr6/JjyKxf0pVKvCWzf0EvTEUCaaDJS/yucO71/lZGZS+n0Vm/KiIdrsM1jCTzLHRWQ6kjYJRH1EAV6CJ3JT3EdWshB7/QpWr3m2fQFPLmeR+ai9wWrsoaU6gbcWHu/lJx1xkcwQxPRISH2Khax6ctHo3IIzrteu+ziDJoFVx9JkAsd7PrKv3JrZSPw/JVCTrt2DDUNiKufIu0KlFWciZzdn1uyCZp934JysDnNJ2ltPcjROoBT/EgWOE6y7wQbwqpfKbNCtaMATDZngR/Der0KaPq4HC2BddK79I8pkbh2d4lJ6z9I6dmL5b529NGtYL0q0zKqykcmnfT5qoDUOTmpAniAIEV3//MWn161p/3SsVqdZ+F3dJYUDYs3CYSYfLHKo3Opxy2rSHqWIkHHCOTGlpfaQ+ae24Ya4WE4MAm7uIZVF0Zy77aYeku8HScLEgZpwttY5rFri+PU01gKd+lCE0D+1U7225ZyNFghG6tjfYtpW8t1H+9OmWvsz63bniZ3TZDKdNeo//Vvm3l60QhPQhLFdwAmWm796aaAuMhyl3gsSOKDQLuyMP5jcdOJnoIOIy8Naq22oNLY/pczn78q/Z+TULX7sEesMTs/dUho3CCnVS4U8aGQT2E/3i16/G078IbIMYa4x4lgHmgTfP+sMXt0SUKzm9Bn8DmyRkGQhFD3jGMyK4CHZ8f6wRsl7BhQi9OTYN0JHAVVw+t9bQfU1LL4LYDoQ
 qXM6vpyI
 c6dKdpfPPSGXTSMI9LyNDH00/fsRdNqOUUWGHBUdR7BYhir2nU443zlUir6eZPXYaAa+SPWYAqFp0MpP8Ie/s8xIqOhloRlyYY5ilhyq5UgUf/44z72CHn+NAbQ+DdwoPelMEwd7xrHhcDBMLJgRS2glGLkLNeF6Ff0zVSgavmUDY35AaF6HqOjM9kngkm8+G6duGhuAb+hIYKHCJWbsmFuiO+etto24eAYo4iBLUfVNaO8YMmomqRXGlELhhQzwx2iBB+CQC5ePRfVEjeLfCX9MsGzmqK4U8theHnxIrRrwvSPUKZEyU7uGuU6dlNM9Q5Y/i
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
 mm/damon/core.c             | 49 +++++++++++++++++++++++++++++--------
 mm/damon/tests/core-kunit.h | 13 ++++++++--
 2 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4c7e8a12a9b67..7d49420ea26c4 100644
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
@@ -3248,6 +3253,16 @@ static void damon_merge_two_regions(struct damon_target *t,
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
@@ -3256,24 +3271,38 @@ static void damon_merge_two_regions(struct damon_target *t,
  * sz_limit	size upper limit of each region
  */
 static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
-				   unsigned long sz_limit)
+		unsigned long sz_limit, struct damon_ctx *ctx)
 {
 	struct damon_region *r, *prev = NULL, *next;
+	bool use_probe_hits = damon_has_probe_weights(ctx);
 
 	damon_for_each_region_safe(r, next, t) {
-		if (abs_diff(r->nr_accesses, r->last_nr_accesses) > thres)
+		unsigned int score, last_score, diff;
+
+		score = damon_merge_score(r, false, ctx, use_probe_hits);
+		last_score = damon_merge_score(r, true, ctx, use_probe_hits);
+
+		if (abs_diff(score, last_score) > thres)
 			r->age = 0;
-		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
+		else if ((score == 0) != (last_score == 0))
 			r->age = 0;
 		else
 			r->age++;
 
-		if (prev && prev->ar.end == r->ar.start &&
-		    abs_diff(prev->nr_accesses, r->nr_accesses) <= thres &&
-		    damon_sz_region(prev) + damon_sz_region(r) <= sz_limit)
-			damon_merge_two_regions(t, prev, r);
-		else
-			prev = r;
+		if (!prev)
+			goto set_prev_continue;
+		if (prev->ar.end != r->ar.start)
+			goto set_prev_continue;
+		diff = abs_diff(score, damon_merge_score(prev, false, ctx,
+					use_probe_hits));
+		if (diff > thres)
+			goto set_prev_continue;
+		if (damon_sz_region(prev) + damon_sz_region(r) > sz_limit)
+			goto set_prev_continue;
+		damon_merge_two_regions(t, prev, r);
+		continue;
+set_prev_continue:
+		prev = r;
 	}
 }
 
@@ -3306,7 +3335,7 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 	do {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
-			damon_merge_regions_of(t, threshold, sz_limit);
+			damon_merge_regions_of(t, threshold, sz_limit, c);
 			nr_regions += damon_nr_regions(t);
 		}
 		threshold = max(1, threshold * 2);
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index d97280270c27b..6ad73559dd8ea 100644
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

