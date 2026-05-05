Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81951CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 14:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B180C6B0005; Tue,  5 May 2026 10:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9436B0088; Tue,  5 May 2026 10:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DEF06B008A; Tue,  5 May 2026 10:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90B0C6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:52:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2AC641C042E
	for <linux-mm@kvack.org>; Tue,  5 May 2026 14:52:40 +0000 (UTC)
X-FDA: 84733657680.18.6D5FB55
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf22.hostedemail.com (Postfix) with ESMTP id 50564C0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 14:52:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eEwWLdGj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777992758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/qYbOqwzvJhVN5qobkl6zlo7YylDwVXFMPy6LUei4rk=;
	b=nPO/F2600mLXWVvGpQv6RNF1VZka38KU0UuJFzlTtHDsoFoQ/SSj+niO9UiYIiTLjKEJNd
	TwoLmPV5GW+vG6LZIirrl3d+aFgtH6XyGLSdeRIajRdNjCfsGZ2OT2x1dUGFw+zFp53hth
	YuhG1ellsoUr3XEMaUh2i7q9obl4NKs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777992758; a=rsa-sha256;
	cv=none;
	b=1SkxuJQPD33uIPinX0y+YSAHbz7AzLZIadgUjVA6+rteFdoqcEMstXsidh4uL/E94THrZg
	oRJfp+VzhHgI0WeEH7b1ZcVcOLggR1GJ1y2q/gXazD0dzQLvIscEGkAomuOwSVorPHEPgJ
	wyajfyh8E6a5+qWRnjksREyOWwD4vw8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eEwWLdGj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777992756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/qYbOqwzvJhVN5qobkl6zlo7YylDwVXFMPy6LUei4rk=;
	b=eEwWLdGjA6Z2uHnNOosl4OQMRmYt/g5NPLqtLe2Xk7Ahw96kBv41+N5b+vAPshGPjgisWP
	aohj/qoj/b5X26CbDYxrtzlHbGXXAiHK7VIcXM7xDlF2vAMYslYopPP05d9gRMWtJ5za3h
	G6UDo7tZoCyLB2I4Eda3SPXYtR5NfIU=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: damon@lists.linux.dev
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shu Anzai <shu17az@gmail.com>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/damon: replace damon_rand() with a per-ctx lockless PRNG
Date: Tue,  5 May 2026 22:52:06 +0800
Message-ID: <20260505145212.108644-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 50564C0005
X-Stat-Signature: nb4oib3bkzs5w6y75k6uu61e1eixy47x
X-Rspam-User: 
X-HE-Tag: 1777992758-11373
X-HE-Meta: U2FsdGVkX19koSqWwKn9RnUp8x9DLFsgb2BlokZEzkMN/DMIrmcN7Qkm1g7Q49Zj7NCf73WsX7xX4cJ7Cqk9KDlALtDfy0V2WNh5WA1L46Fry8yGHq8EFJfPq8QUQHfYWPw5Nb4nWKPeaiiVU4ApxuxH/oo1Y6pFjaFAi5BcD0foXErTZeNJuPuGyxrz5z1qJdXu8WLFW1flOVumBszLN2ghxyt/pCY60HLiICvvc65JpK9KSP39Uf7m5f/xe69B/0swLwBzBMZXj8ffrqPhjND8/XmSl7WUJ3d9virhfAVxhpQQRcmn0ssL9nPYfGMgxEuZjg7x+hm/jdwbhcZ0IGd+4Zy2arR9qXqQEHeke5zE+MlpmShXKZXIX+wQ/xKB6V5como0Y8RTT4RLpec25Hb6G6d/LWXbYs3wtdTahWuHHzUDD89Zam66shWIalawKCwscbJsPG/1JMwG83cNlMdW37Wylzj6eZmONP7dnxDAVjQneJwe3Pu/Le7dJE3SlsRSg8L/cGQtbe7f2YLl20UiQ159MdLu7vjWQsZes7FQMPNGjBYowKiIAIhP7ewfgMHLXAYT0B1Na5x65BwHiRPSO3wiLDC6evkeP4t21ZpKSRv+pjXj72grppwlSQPAOneH+FuIkm9NQP5uhY3c9Elcr7qFAz7chMEmKbMUACUpa1DK+vTh6i/oYoXEwIFue6x/IsotSI0fRKmRArQUqnPEsn5LkKZfDf2Vaj12GP6ZDobtOgXgAXCgiJcUu5xCqJbB1680IpP6mVNkSx5/7eAqMeWN2Pjyaf1I09jJoOU236iFFNgv/1jlJn7ZgDTcKrREXVfmjGhQrPfpUQZs+qHc1uAXcfQ6qsz/xrE3CuKXIBdeK6y2qmagg1034b6hoGFNRC2uWv+nHA8NpbXFIIXQkKgR+oJStwmiJqvhY9g9fw8SHxvKAK0rvTnj96vhJLENipx7Ro5uuDM+Y0r
 BYDm6Ih9
 OipRU1hxu4G9ibkApSRT+ZzaX4UY3/y2w3rC44WeWyfM8/zNWdQy/SGCyrA+2JsXz1paiMd8x1yvp0S78LhG3vsA5+Rpb1PnkvjCiQwMeibevgkC3aCG5PM5xN6mIccPODRVgU9HG6T56H/83kP/k6ZiVrZ/rt+v80xEPFn2xjS1+wZg51emYYeFM9goordqr4lvuvpekUZtt3efQyDGdpXZh28jC6MgHckOKISxpB1M0T5gavunLrhK60TQ7ATydRT4evkzRYNIPFuzcmLvah5tX2V+bsOTvGhmFMMAqgo9PQ1rToDUy04vvBbSSGBNhREf8sZpI8LZzzMt0NiK4Cs/3gwXG/L/nLZ1hEDXtHMVG+S0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

damon_rand() on the sampling_addr hot path called
get_random_u32_below(), which takes a local_lock_irqsave() around a
per-CPU batched entropy pool and periodically refills it with
ChaCha20.  At elevated nr_regions counts (20k+), the lock_acquire /
local_lock pair plus __get_random_u32_below() dominate kdamond perf
profiles.

Replace the helper with a lockless lfsr113 generator (struct rnd_state)
held per damon_ctx and seeded from get_random_u64() in damon_new_ctx().
kdamond is the single consumer of a given ctx, so no synchronization
is required.  Range mapping uses Lemire's (u64)rnd * span >> 32 on the
fast path; for spans larger than U32_MAX (only reachable on 64-bit) the
slow path combines two u32 outputs and uses mul_u64_u64_shr() at 64-bit
width.  On 32-bit the slow path is dead code and gets eliminated by
the compiler.

The new helper takes a ctx parameter; damon_split_regions_of() and
the kunit tests that call it directly are updated accordingly.

lfsr113 is a linear PRNG and MUST NOT be used for anything
security-sensitive.  DAMON's sampling_addr is not exposed to userspace
and is only consumed as a probe point for PTE accessed-bit sampling,
so a non-cryptographic PRNG is appropriate here.

Tested with paddr monitoring and max_nr_regions=20000: kdamond CPU
usage reduced from ~72% to ~50% of one core.

Link: https://lore.kernel.org/damon/20260426173346.86238-1-sj@kernel.org/T/#m4f1fd74112728f83a41511e394e8c3fef703039c
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 include/linux/damon.h       | 27 +++++++++++++++++++++------
 mm/damon/core.c             | 12 ++++++++----
 mm/damon/paddr.c            |  8 ++++----
 mm/damon/tests/core-kunit.h | 28 ++++++++++++++++++++++------
 mm/damon/vaddr.c            |  7 ++++---
 5 files changed, 59 insertions(+), 23 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f2cdb7c3f5e6..e16012a7f41a 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -8,8 +8,10 @@
 #ifndef _DAMON_H_
 #define _DAMON_H_
 
+#include <linux/math64.h>
 #include <linux/memcontrol.h>
 #include <linux/mutex.h>
+#include <linux/prandom.h>
 #include <linux/time64.h>
 #include <linux/types.h>
 #include <linux/random.h>
@@ -19,12 +21,6 @@
 /* Max priority score for DAMON-based operation schemes */
 #define DAMOS_MAX_SCORE		(99)
 
-/* Get a random number in [l, r) */
-static inline unsigned long damon_rand(unsigned long l, unsigned long r)
-{
-	return l + get_random_u32_below(r - l);
-}
-
 /**
  * struct damon_addr_range - Represents an address region of [@start, @end).
  * @start:	Start address of the region (inclusive).
@@ -843,8 +839,27 @@ struct damon_ctx {
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
+
+	/* Per-ctx PRNG state for damon_rand(); kdamond is the sole consumer. */
+	struct rnd_state rnd_state;
 };
 
+/* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
+static inline unsigned long damon_rand(struct damon_ctx *ctx,
+				       unsigned long l, unsigned long r)
+{
+	unsigned long span = r - l;
+	u64 rnd;
+
+	if (span <= U32_MAX) {
+		rnd = prandom_u32_state(&ctx->rnd_state);
+		return l + (unsigned long)((rnd * span) >> 32);
+	}
+	rnd = ((u64)prandom_u32_state(&ctx->rnd_state) << 32) |
+	      prandom_u32_state(&ctx->rnd_state);
+	return l + mul_u64_u64_shr(rnd, span, 64);
+}
+
 static inline struct damon_region *damon_next_region(struct damon_region *r)
 {
 	return container_of(r->list.next, struct damon_region, list);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3dbbbfdeff71..cbbb35a72b18 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -607,6 +607,8 @@ struct damon_ctx *damon_new_ctx(void)
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
 
+	prandom_seed_state(&ctx->rnd_state, get_random_u64());
+
 	return ctx;
 }
 
@@ -2715,8 +2717,9 @@ static void damon_split_region_at(struct damon_target *t,
 }
 
 /* Split every region in the given target into 'nr_subs' regions */
-static void damon_split_regions_of(struct damon_target *t, int nr_subs,
-				  unsigned long min_region_sz)
+static void damon_split_regions_of(struct damon_ctx *ctx,
+				   struct damon_target *t, int nr_subs,
+				   unsigned long min_region_sz)
 {
 	struct damon_region *r, *next;
 	unsigned long sz_region, sz_sub = 0;
@@ -2731,7 +2734,7 @@ static void damon_split_regions_of(struct damon_target *t, int nr_subs,
 			 * Randomly select size of left sub-region to be at
 			 * least 10 percent and at most 90% of original region
 			 */
-			sz_sub = ALIGN_DOWN(damon_rand(1, 10) *
+			sz_sub = ALIGN_DOWN(damon_rand(ctx, 1, 10) *
 					sz_region / 10, min_region_sz);
 			/* Do not allow blank region */
 			if (sz_sub == 0 || sz_sub >= sz_region)
@@ -2772,7 +2775,8 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 		nr_subregions = 3;
 
 	damon_for_each_target(t, ctx)
-		damon_split_regions_of(t, nr_subregions, ctx->min_region_sz);
+		damon_split_regions_of(ctx, t, nr_subregions,
+				       ctx->min_region_sz);
 
 	last_nr_regions = nr_regions;
 }
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5cdcc5037cbc..c4738cd5e221 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -49,11 +49,11 @@ static void damon_pa_mkold(phys_addr_t paddr)
 }
 
 static void __damon_pa_prepare_access_check(struct damon_region *r,
-		unsigned long addr_unit)
+		struct damon_ctx *ctx)
 {
-	r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
+	r->sampling_addr = damon_rand(ctx, r->ar.start, r->ar.end);
 
-	damon_pa_mkold(damon_pa_phys_addr(r->sampling_addr, addr_unit));
+	damon_pa_mkold(damon_pa_phys_addr(r->sampling_addr, ctx->addr_unit));
 }
 
 static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
@@ -63,7 +63,7 @@ static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t)
-			__damon_pa_prepare_access_check(r, ctx->addr_unit);
+			__damon_pa_prepare_access_check(r, ctx);
 	}
 }
 
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 9e5904c2beeb..ee0a58eeb25c 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -273,54 +273,70 @@ static void damon_test_merge_regions_of(struct kunit *test)
 
 static void damon_test_split_regions_of(struct kunit *test)
 {
+	struct damon_ctx *c;
 	struct damon_target *t;
 	struct damon_region *r;
 	unsigned long sa[] = {0, 300, 500};
 	unsigned long ea[] = {220, 400, 700};
 	int i;
 
+	c = damon_new_ctx();
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
 	t = damon_new_target();
-	if (!t)
+	if (!t) {
+		damon_destroy_ctx(c);
 		kunit_skip(test, "target alloc fail");
+	}
 	r = damon_new_region(0, 22);
 	if (!r) {
 		damon_free_target(t);
+		damon_destroy_ctx(c);
 		kunit_skip(test, "region alloc fail");
 	}
 	damon_add_region(r, t);
-	damon_split_regions_of(t, 2, 1);
+	damon_split_regions_of(c, t, 2, 1);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 2u);
 	damon_free_target(t);
 
 	t = damon_new_target();
-	if (!t)
+	if (!t) {
+		damon_destroy_ctx(c);
 		kunit_skip(test, "second target alloc fail");
+	}
 	r = damon_new_region(0, 220);
 	if (!r) {
 		damon_free_target(t);
+		damon_destroy_ctx(c);
 		kunit_skip(test, "second region alloc fail");
 	}
 	damon_add_region(r, t);
-	damon_split_regions_of(t, 4, 1);
+	damon_split_regions_of(c, t, 4, 1);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
 	damon_free_target(t);
 
 	t = damon_new_target();
-	if (!t)
+	if (!t) {
+		damon_destroy_ctx(c);
 		kunit_skip(test, "third target alloc fail");
+	}
 	for (i = 0; i < ARRAY_SIZE(sa); i++) {
 		r = damon_new_region(sa[i], ea[i]);
 		if (!r) {
 			damon_free_target(t);
+			damon_destroy_ctx(c);
 			kunit_skip(test, "region alloc fail");
 		}
 		damon_add_region(r, t);
 	}
-	damon_split_regions_of(t, 4, 5);
+	damon_split_regions_of(c, t, 4, 5);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 12u);
 	damon_for_each_region(r, t)
 		KUNIT_EXPECT_GE(test, damon_sz_region(r) % 5ul, 0ul);
 	damon_free_target(t);
+
+	damon_destroy_ctx(c);
 }
 
 static void damon_test_ops_registration(struct kunit *test)
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index b069dbc7e3d2..2e936f04de3d 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -333,9 +333,10 @@ static void damon_va_mkold(struct mm_struct *mm, unsigned long addr)
  */
 
 static void __damon_va_prepare_access_check(struct mm_struct *mm,
-					struct damon_region *r)
+					struct damon_region *r,
+					struct damon_ctx *ctx)
 {
-	r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
+	r->sampling_addr = damon_rand(ctx, r->ar.start, r->ar.end);
 
 	damon_va_mkold(mm, r->sampling_addr);
 }
@@ -351,7 +352,7 @@ static void damon_va_prepare_access_checks(struct damon_ctx *ctx)
 		if (!mm)
 			continue;
 		damon_for_each_region(r, t)
-			__damon_va_prepare_access_check(mm, r);
+			__damon_va_prepare_access_check(mm, r, ctx);
 		mmput(mm);
 	}
 }
-- 
2.43.0


