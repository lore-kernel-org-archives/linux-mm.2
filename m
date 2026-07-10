Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB943C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A5B46B0095; Thu,  9 Jul 2026 20:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F5F6B0099; Thu,  9 Jul 2026 20:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86BE26B009D; Thu,  9 Jul 2026 20:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D36A6B0095
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BAECA1C87E4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:03 +0000 (UTC)
X-FDA: 84970969566.02.A528DFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2528620009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iKL+7zeL;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643042;
	b=OiRBMgGujzFdSB22ePSrrr5AY3os2+r8GmogSJ5whrsKnAM4XT2kwiGCos8qOp73dfWu1H
	ZXuzRg54r+EkrZlJUI9bk4bBFbTFQDx1glqSmmvlb9IP+5U4weXv7iO0JMdUKxl+Ho3dV5
	LIHKnAIxDNKAQ6VAT9F9grroN+nf/n8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iKL+7zeL;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ywtTSlgg2gQ8bR9Osnueml1K534EMkMwLNfCemx+LA=;
	b=p4K6OkTzpZgSGAkBJ5T8hdM07iIuQcGDCvoTAs7KmpAm5U1sHcEBSoqS2LCQBRFxe45NgZ
	P0go4iWs15QEw3P65QkPXDOlPHfVu1e/BhMWW0t5DJKUmXR7+xa2oBFQ240Xe9ApxCESqd
	W+kYvSuLOIHrb2Z6Eot078ZODg9Sf/w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76BE544FB5;
	Fri, 10 Jul 2026 00:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F47E1F00A3E;
	Fri, 10 Jul 2026 00:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643041;
	bh=7ywtTSlgg2gQ8bR9Osnueml1K534EMkMwLNfCemx+LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKL+7zeL8+ZL+GjUzfwQqm3Ct7BGBlRgX4ZKsDixFpponI4Tok+9YZzpNFHP3Mk+f
	 aXSRxRNLkABQHOM1rw7VYwt+PJQvWuk69He9ZU+ckmNGJTzdWawTy1xMi0ooQFomOd
	 qx+7C7tpAyrqb7OkfTfkOvAIjXZhShImnG26Md8SHsalxrNzTzMaBUww5vtoLZkmfh
	 bp/nZ3TOFN99T/Sp+uXJSfTbgQyM2VLyIo6U5kBqRo1mzoARm8uVmNjRe8HhRSyO+q
	 RaMZj8UTZooroWJq04ITWaEfucF8co4B9gyL/Ba6AClWueU9jbG+2tmYXmHOaEL1uy
	 yPpmVLEByYzfQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 08/19] mm/damon/core: extend merge function to work with probe hits
Date: Thu,  9 Jul 2026 17:23:34 -0700
Message-ID: <20260710002349.111414-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2528620009
X-Stat-Signature: imi7epuuz9j4s78fqzb4957ejfqydmnx
X-HE-Tag: 1783643041-508748
X-HE-Meta: U2FsdGVkX199EvoF9nkhz4JLxcA2y/8S1D4VsVBQUSM3gjSVuwZDwb9K0/vkyl+ToSlPpOm0OFQS1S19Q1VWD4rYObUvHQL4XnYSZwmN49rDMAwiXXjNWbX0nEYkvT2IRSX32i7gJ1AhB8Oz0uMdslj0NIbpX2+CguexQYqfcyEfn9CqFiOBHg9LTyxkibuRffcZP1qWEUT6o6SJZWW2I/oARMBCVqD0P4JlgyAbGV5IJlG5a2Et/byHPYqRmrUfDyvNk4ZueG/74S0RhaUULUyJVefiLUxZG8pt8J5xhnBkBLusiC5egGbZU7ZImSLh5di+HgPXx7El5XswXE44gXK1GcKcC0TRHW6psEtB9YVLDDZKeIdzCMxInsewl0FZ6PO5zhu6X3Qe1Qp0byZJ1Z2mmdmD6hymLO4rPkbcGpN2e0s2EFmL0eJCuZYPCxJ4+LfsxAe+IoJC5QLD6JzdpU6wo/iFBU/prVFHD4K/MKq2e3d2tKIUdXB1Bh0rug9j6AjrnF6pB0QHBQIId9eo/hTpdkYemIO6cavisG0QHGRo/UD9NwMwt+IdaNussusNWGY51M1caW9PwcStJSMdLKuku4O0P/WiRqlcuSJcyuudcATANozUpvk+nvMZTizt+/5UI2Fx6FxmhMZJ8x3y4bXRKi1uoo0xrWLRhAMlyXhA0E+lwAk5RVbYmRBdjvJ151DkYMIw1/E1FBUyUlnpM9HfGewcbNxdnmS2NKWUYiqKf5AXUYaxxV3X8R7O3NcQ0/bum2K/rLJUUeeeWb4W93oV8UUHELTZLdGinf46u8PH++L3QgglkkJwzEbvyfNGuvQ2LQjyazvwTtKaXXD8w51DI8xhx/d9ZIssDqWlQB6BTvhfvNKZj/RejmU7bOFpLXchxXCI3Y7sgQPoUp38AuB2l9sWTy/gxV5DW4kL/6ehbjYeqwjGEUBnSbYDhu1srjWoSDB3bhEr3nxRZ1a
 hLn7QUdh
 tlnAVZDr/fXmfWtmSvtG8s6YovdIOUD/uDd6k8pUrsOpmkYKUZwnT3L+thdjcO39yaT+UYLOlEqwOIB9qDZC25DACsH62sVU4JdLA6rCdAr5qLNf2+2VOtcGSJb6UNXRl0ttkSL2bIBFL1YTX1IblyipN3i8GTuxHhQRmYXKEBswijMuccQO0LQhfmVD4GroRkOwT+wBvHLNJLLnrxPT1tkVSajp6kK2ZFkHhbgEBWBq++Xg=
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

