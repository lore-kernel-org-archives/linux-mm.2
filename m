Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1312CD3445
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 01:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 545546B02E1; Fri,  8 May 2026 21:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51C3E6B02E3; Fri,  8 May 2026 21:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4591B6B02E4; Fri,  8 May 2026 21:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 32A3C6B02E1
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:18:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2E6F16043C
	for <linux-mm@kvack.org>; Sat,  9 May 2026 01:18:27 +0000 (UTC)
X-FDA: 84746121054.22.CAC8359
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 23E7E140004
	for <linux-mm@kvack.org>; Sat,  9 May 2026 01:18:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i3JYY6Y8;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778289506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FJflsr/luLNuF5LhVLsxgHwWHwJD47Ni4u3xtNngNG8=;
	b=xN7aMrK1wvhmfKCFQ+noSUizkomFB9zJYTmSNktB+P7Grx4piRyKOSv6YAa98g24ZVoKF1
	WD7TvZXRe3ast8O3FFjRngAPwPTuD2Rn2kU/nTrzXx33CuTJsQW6pLzlujTW6B3KeEFxz9
	M1M/OMjhjKD1SgYLZEfAYGL43CQtZaU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i3JYY6Y8;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778289506; a=rsa-sha256;
	cv=none;
	b=gTH/IBNkFZsWsG8jWstD38u8+6G7GqXeNKNYQfSO/52BR93EI8UufDEIeZtB/miutLn4dy
	3HYkiTAyo2H5G3whAQ5Bj5HBcDXoVjihC793fDMQEO3GYifNzkhR9IICyiv8OgBLJ0lg4F
	CP9CwptWJM8/l1np4lzuiHB8ueVoWmc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 34A3340B76;
	Sat,  9 May 2026 01:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10F5C2BCB0;
	Sat,  9 May 2026 01:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778289505;
	bh=xnmsr/Nd7n0lanXDorJh5z++yFtc+HIinq9wc7XSMTE=;
	h=From:To:Cc:Subject:Date:From;
	b=i3JYY6Y8yezXCPrNoU7F6PsUJnwML+g5tI4ynHIZRCtm0eWBUKSrr6/zcmZg8MEBQ
	 Mp6niETJpOxsiMFTOAAPBEsU1s1GwnA3MFIGvSDBNuuIUgMzkrDaGMlLSKo6MAmmos
	 zy7Xy0QSG+o5MG2cbdxuw6Q/8sYpc0B3VWrBd86S5A5bglhgi0qFepivRMoYxk6qwY
	 bprVf6KsIaqfTshvO6QlCC2sam9/Sm+c0AH07kQW1zcmJ4jZTRQ1ExHmn1nyGGZhd9
	 /tgU7OLpbxVnz4RV1aPMalXbWvRyvDzv6k0NCiotHqOfc84Okh6u3Hf4oO3yWufk63
	 EQ5B1/5zStugA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	SeongJae Park <sj@kernel.org>,
	Shu Anzai <shu17az@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3] mm/damon: replace damon_rand() with a per-ctx lockless PRNG
Date: Fri,  8 May 2026 18:18:15 -0700
Message-ID: <20260509011816.85145-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 23E7E140004
X-Rspamd-Server: rspam06
X-Stat-Signature: 7kqyftyifihezix7txj9ozdy69c8mrex
X-HE-Tag: 1778289505-302118
X-HE-Meta: U2FsdGVkX19doO5NVFU8s01HaMpr7vr8x3gVg8YKnSWcP72FwpL9aD/T0iT3c7gPnfhnGiPeC1hvxAQBOnvebJv1ybvF3PBQ34YQ7f7Lb6pTwr6GzpjEyHJF0WVpVqS0QX4PpSLOk/aQO71IZTVfyjpkaE7FGNVpoRR2vsqisUV6EgEiAlYVjIcfWcUuAP1vlWpZczwQsuFUtZ/n4yBKLUXO6LU88FOkzulxtJGSt8FGoU4BQSN1rQyf8FiduYAZULwgm9HINk4OX/LHHx3NJOkT1kp7AdJBVGVwFhCVnooQp/WPNTEILqfbi/cv8RA9fGWKC++xJa4H7HXfnHBLWPsBDd+b+AfVYTs5CVW9/0ibs4inSQgU/3DFULYaI1XxqapHu9YWbFawI610CnYnWnG6859ykjBsK23VJ6IcSkiMQWE8A7/H9kVpdHX2shV855zi0f0ENg4Q5KhPwY5y7ColslcdIID/omeew6ozeIZdY+RF9T43npMID4qfobFDrxQBO5HGl7UuMj9ZAbm5sSxa0m5qMBThEFAjmfPSTQnrLstYmF6BhzKzFpPP9AYyz9F7IdmF+CV7s6rvBXZ3ciytnXr2CIRrpl50sLZBkkYmFhq/HGaV3Ls3lBVK70/yPQou30MuRfrOGAla/5f5d+erbqA8wZa0N9c8+zDssVRl3mTTaohWonudsthgvtoUiL0jAswku6OUpdU5109BJccCMwde+Tt2GfZhrOrPJxWyXE5YO4YEeupiAu9HSTdF0DLCzV1MWmPRSJ+PSLkklEjAgg8MvfZ3q4B1aFxlCRDs5+nszLHhMq6xhNML4GH3X7V5zvIfQwd0/6ndGrt9JNdvp6AoS6JMmRt0rgkxHKodChXCGuRyFbZHylc9+VGxCeFcbQ7UFFcuBg/iJMv+brGIfc8G5tpIlGcBItpQ24W6KvnOgzx2J0bNFUHOUKQRtZnPGhjltw5HcbDPKSb
 Mxrg6F2Z
 04rXRUAnoXFnCjfauyCepHx9mFNXzwwSc3iWxhjI4cC2Viek76x4kiLle7EhMmIdIlgi6PrAld5t3t09Az/Us57yzRTz3xA0kXtrQG6AYsj3nYtSkmJQUMpI08NteXPCJaEwxRoVrIx/fFFsk4lSktEzBYNY0CW+Lgz5BKyHyXMYEOg/nUnN2LdB5IIoxQRd8kfjpTuXIfJ/JEUt7TSaUwpgKyiODlFi/kMlnSNLlvAZVboNYxdJ/X5AIEIVQVTbcRAuxH9OSyFsTsLiAeDOzjnIDgaRNL8nGEnIhmPWFNFvG7XZpcOoNs0lncIOUJ2vvVigIGP+Ty/0RNxZIU7ZUxzYdpV0iWU29HatWp5xm4td1PUU5YTbncKGTSHedJ/3WO/V0yr+P16Ntw+bdTFRRTPLKYgM6qMhU0zGobyY2Uc8UMhoRrNvI/O/tw2KMCbUcTfor
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
is required.  Range mapping uses traditional reciprocal multiplication,
similar as get_random_u32_below(); for spans larger than U32_MAX (only
reachable on 64-bit) the slow path combines two u32 outputs and uses
mul_u64_u64_shr() at 64-bit width.  On 32-bit the slow path is dead code
and gets eliminated by the compiler.

The new helper takes a ctx parameter; damon_split_regions_of() and
the kunit tests that call it directly are updated accordingly.

lfsr113 is a linear PRNG and MUST NOT be used for anything
security-sensitive.  DAMON's sampling_addr is not exposed to userspace
and is only consumed as a probe point for PTE accessed-bit sampling,
so a non-cryptographic PRNG is appropriate here.

Tested with paddr monitoring and max_nr_regions=20000: kdamond CPU
usage reduced from ~72% to ~50% of one core.

Link: https://lore.kernel.org/20260505145212.108644-1-jiayuan.chen@linux.dev
Link: https://lore.kernel.org/damon/20260426173346.86238-1-sj@kernel.org/T/#m4f1fd74112728f83a41511e394e8c3fef703039c
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shu Anzai <shu17az@gmail.com>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v2
- v2: https://lore.kernel.org/d053e344-7643-4504-b766-a04f2b4a6569@linux.dev
- Comment the range mapping uses traditional recoprocal multiplication.
- Remove include random.h
Changes from v1
- v1: https://lore.kernel.org/20260423122340.138880-1-jiayuan.chen@linux.dev
- Drop prefetch optimization.
- Replace damon_rand() instead of adding a faster variant.
- Cover >4 GiB range.

 include/linux/damon.h       | 28 +++++++++++++++++++++-------
 mm/damon/core.c             | 12 ++++++++----
 mm/damon/paddr.c            |  8 ++++----
 mm/damon/tests/core-kunit.h | 28 ++++++++++++++++++++++------
 mm/damon/vaddr.c            |  7 ++++---
 5 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index c7a31572689be..4d4f031bcb453 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -8,23 +8,18 @@
 #ifndef _DAMON_H_
 #define _DAMON_H_
 
+#include <linux/math64.h>
 #include <linux/memcontrol.h>
 #include <linux/mutex.h>
+#include <linux/prandom.h>
 #include <linux/time64.h>
 #include <linux/types.h>
-#include <linux/random.h>
 
 /* Minimal region size.  Every damon_region is aligned by this. */
 #define DAMON_MIN_REGION_SZ	PAGE_SIZE
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
@@ -859,8 +854,27 @@ struct damon_ctx {
 
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
index 9f38deddcb30e..3a8725e400c6b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -611,6 +611,8 @@ struct damon_ctx *damon_new_ctx(void)
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
 
+	prandom_seed_state(&ctx->rnd_state, get_random_u64());
+
 	return ctx;
 }
 
@@ -2939,8 +2941,9 @@ static void damon_split_region_at(struct damon_target *t,
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
@@ -2955,7 +2958,7 @@ static void damon_split_regions_of(struct damon_target *t, int nr_subs,
 			 * Randomly select size of left sub-region to be at
 			 * least 10 percent and at most 90% of original region
 			 */
-			sz_sub = ALIGN_DOWN(damon_rand(1, 10) *
+			sz_sub = ALIGN_DOWN(damon_rand(ctx, 1, 10) *
 					sz_region / 10, min_region_sz);
 			/* Do not allow blank region */
 			if (sz_sub == 0 || sz_sub >= sz_region)
@@ -2996,7 +2999,8 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 		nr_subregions = 3;
 
 	damon_for_each_target(t, ctx)
-		damon_split_regions_of(t, nr_subregions, ctx->min_region_sz);
+		damon_split_regions_of(ctx, t, nr_subregions,
+				       ctx->min_region_sz);
 
 	last_nr_regions = nr_regions;
 }
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5cdcc5037cbc1..c4738cd5e221e 100644
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
index 1b23a22ac04c4..866f716e5760d 100644
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
index dd5f2d7027ac4..1b0ebe3b6951e 100644
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

base-commit: c9b732885a16d2e79810049ddde3c46bee02dd53
-- 
2.47.3

