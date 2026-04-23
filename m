Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6806EF589AD
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDF0B6B008A; Thu, 23 Apr 2026 08:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90D26B008C; Thu, 23 Apr 2026 08:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5906B0092; Thu, 23 Apr 2026 08:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A81F86B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:23:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BB591A0135
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:23:59 +0000 (UTC)
X-FDA: 84689737398.16.E44DFC5
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf13.hostedemail.com (Postfix) with ESMTP id 75CC520003
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:23:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vJQehRic;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776947038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9HHheyubYHNtwYDlBDwk1vL1ZesRzJTzCNuH8uQVt7c=;
	b=8RVxSQ+oKUkHzIk47Bm+fTwVetfj2S/Xt8Ls9GiwpRriBywWq7mYj/0zcPv7GytF7QQk66
	dM9XH4jBGPhyjJgJfidHYgqLt1j553Rk0tzSqEJ3VVVQPnt5EPpAPsP477rRDOxAL6zF/X
	zzAauLgidbvrFX8jFL0m0l3HL1pWq/8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vJQehRic;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776947038; a=rsa-sha256;
	cv=none;
	b=xL2sNG+TxbY4mNjn8kGArqoY4qp2M3QBRy6W853ElX9DamDjT6sMIhpDadfH7c3kk7NnaU
	6JYZSaZzNb1/7YQBmKNyJnbJQgmetm8zXgymL4LCkU3jBPaDiyKBYXJumasiD9Tdk7yb8e
	g9y7yHspk3Q1nX8uAtfGjibVRYK4PpY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776947035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9HHheyubYHNtwYDlBDwk1vL1ZesRzJTzCNuH8uQVt7c=;
	b=vJQehRicMhgAhQdXdxNyu6owWRyeyTuDctl2aSxFB4G9d11PJViHkFBimbloLLQnnxQe8i
	s8WLRRqLrQJn2ZGAsZ5GSC56yXRfsag5L64IulT/5GMR0VCe8MnRtj4XNyU/uLZ6/V4OLK
	YNfNgrstc7I4cFiiB0sTY49a0e+z/dM=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: damon@lists.linux.dev
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm/damon: introduce damon_rand_fast() for per-ctx PRNG
Date: Thu, 23 Apr 2026 20:23:36 +0800
Message-ID: <20260423122340.138880-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 75CC520003
X-Stat-Signature: f8187wqgszc9h3idm787epwsr9knf8wu
X-Rspam-User: 
X-HE-Tag: 1776947037-126557
X-HE-Meta: U2FsdGVkX1903t0aSNFE/uxvFjEMsePsHrvmOjxtfhDGg2NrHuan2jBYbOfc5bNinjJK5EVE6ccODnembPgCNDnxe40fjjtjh38FfF7MA+BsRKGxJxnteDGW5JVO6FmOqopB4FpbXt3alJfN0tfq2K/N6GoFtHiaQFhJnOog30z2RgJ6C3nDdYswlSLO59lVaGyOwk+/cFTSq1JDS5iYhHGneR6t+pAXoLROL70BMy37UUcZ06E6Tbx2ZHDberOyDoDzKxZVXJ0YuDTkYVf9ByB7zWY3KbDVgVUuL7RbDcdcxbbhi1aYShSlEyPbNa4g1UuzKREMmOeJrg6g6hVo8sTy+n1EhSN3LU4OBdBFVqA3qiaOO9wagJzpOKlhjucrF5bZ6N8IDs4VZIQT0jTi5BCHCv5T56mb8hg8j+B3VdIcf1/Gr3t/jTSYe56hWEuvFBAyVZsFflYEvxiYnW6U2OWtINDmwbmbsZY9IyWBYfMtGCgh+dc3Bh0HyXYOZ4pi69JoJqqlmv31d6iepuYbjKILde9U/uvYUKTmrtbZo+jQjBQifyscNibhgqROME+bvk4HCSz0KioXXak3Lj42fhymfJ5/HGeWp9eWmyiIMOF/b+AKj9g1JF/AYezjpZhxilbA2pF6G+dB8IW4nnH4ZBJNBALTk2du+ywY1m7F7kkyD8Ve3DQMpPRahi11KS9AwVsqpOzn7NYSbyHL8RP1InYjdIz11S4p2jqkeC/CKdU1qBsMiaD1tjpdj1MbaEQlILtYGOYn5lgPKw+KESr2mMZpvHyW/uvfzidUiyGF+Gz29NDpzzfzvjsScOI+0fBdk2NTTSIP3LwuEies5q04kTMgr1/aNabPkBlEauXJWWsGVNTNfqfbl2Q6FeTv68uxsjWnAG6edpom2CpNg7YC6YXiyq6D6Wl/oHm0vA7veOhW9K1xOQCiELkRoVhktizjfgtkaNiZgPcIWbqQR/E
 ycQOrt0+
 KHjJI2QDMcUDICWBLCqURAXMGesJB0umMsJuCn4LahlrBy7cd3wQlvnvqqbYonKDjH9j0uiTprtpwyJdslLpUQ5YcjIfLEMTU+IoOaKuLotECB6FPxtnKZtyNrRWssIHL7wfTfZUjuB6u14Ia9vjMVYzGQpNvyfrdJSFcgb4bV2TUP8TVXzzYO7KUE58ElZka7jVtxp1wWxIGGOlwDXU3/+i/23JW8t6ZeYslZ8bCSxvFgUlxC9UFYfqBv/UmU7JxKXzYmI4LLE6nxqJ13W+ZKmtdG96AwvVSDojKbDB89eKF4vsXtrhTW+wlAJBShuNw8NSc18xzWUxjpaYVtAFdwr8i+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

damon_rand() on the sampling_addr hot path calls get_random_u32_below(),
which takes a local_lock_irqsave() around a per-CPU batched entropy pool
and periodically refills it with ChaCha20.  On workloads with large
nr_regions (20k+), this shows up as a large fraction of kdamond CPU
time: the lock_acquire / local_lock pair plus __get_random_u32_below()
dominate perf profiles.

Introduce damon_rand_fast(), which uses a lockless lfsr113 generator
(struct rnd_state) held per damon_ctx and seeded from get_random_u64()
in damon_new_ctx().  kdamond is the sole consumer of a given ctx, so no
synchronization is required.  Range mapping uses Lemire's
(u64)rnd * span >> 32 to avoid a 64-bit division; residual bias is
bounded by span / 2^32, negligible for statistical sampling.

The new helper is intended for the sampling-address hot path only.
damon_rand() is kept for call sites that run outside the kdamond loop
and/or have no ctx available (damon_split_regions_of(), kunit tests).

Convert the two hot callers:

  - __damon_pa_prepare_access_check()
  - __damon_va_prepare_access_check()

lfsr113 is a linear PRNG and MUST NOT be used for anything
security-sensitive.  DAMON's sampling_addr is not exposed to userspace
and is only consumed as a probe point for PTE accessed-bit sampling, so
a non-cryptographic PRNG is appropriate here.

Tested with paddr monitoring and max_nr_regions=20000: kdamond CPU
usage reduced from ~72% to ~50% of one core.

Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 include/linux/damon.h | 28 ++++++++++++++++++++++++++++
 mm/damon/core.c       |  2 ++
 mm/damon/paddr.c      | 10 +++++-----
 mm/damon/vaddr.c      |  9 +++++----
 4 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f2cdb7c3f5e6..0afdc08119c8 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -10,6 +10,7 @@
 
 #include <linux/memcontrol.h>
 #include <linux/mutex.h>
+#include <linux/prandom.h>
 #include <linux/time64.h>
 #include <linux/types.h>
 #include <linux/random.h>
@@ -843,8 +844,35 @@ struct damon_ctx {
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
+
+	/*
+	 * Per-ctx lockless PRNG state for damon_rand_fast(). Seeded from
+	 * get_random_u64() in damon_new_ctx(). Owned exclusively by the
+	 * kdamond thread of this ctx, so no locking is required.
+	 */
+	struct rnd_state rnd_state;
 };
 
+/*
+ * damon_rand_fast - per-ctx PRNG variant of damon_rand() for hot paths.
+ *
+ * Uses the lockless lfsr113 state kept in @ctx->rnd_state. Safe because
+ * kdamond is the single consumer of a given ctx, so no synchronization
+ * is required. Quality is sufficient for statistical sampling; do NOT
+ * use for any security-sensitive randomness.
+ *
+ * Range mapping uses Lemire's (u64)rnd * span >> 32 to avoid a division;
+ * bias is bounded by span / 2^32, negligible for DAMON.
+ */
+static inline unsigned long damon_rand_fast(struct damon_ctx *ctx,
+					    unsigned long l, unsigned long r)
+{
+	u32 rnd = prandom_u32_state(&ctx->rnd_state);
+	u32 span = (u32)(r - l);
+
+	return l + (unsigned long)(((u64)rnd * span) >> 32);
+}
+
 static inline struct damon_region *damon_next_region(struct damon_region *r)
 {
 	return container_of(r->list.next, struct damon_region, list);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3dbbbfdeff71..c3779c674601 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -607,6 +607,8 @@ struct damon_ctx *damon_new_ctx(void)
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
 
+	prandom_seed_state(&ctx->rnd_state, get_random_u64());
+
 	return ctx;
 }
 
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5cdcc5037cbc..b5e1197f2ba2 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -48,12 +48,12 @@ static void damon_pa_mkold(phys_addr_t paddr)
 	folio_put(folio);
 }
 
-static void __damon_pa_prepare_access_check(struct damon_region *r,
-		unsigned long addr_unit)
+static void __damon_pa_prepare_access_check(struct damon_ctx *ctx,
+					    struct damon_region *r)
 {
-	r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
+	r->sampling_addr = damon_rand_fast(ctx, r->ar.start, r->ar.end);
 
-	damon_pa_mkold(damon_pa_phys_addr(r->sampling_addr, addr_unit));
+	damon_pa_mkold(damon_pa_phys_addr(r->sampling_addr, ctx->addr_unit));
 }
 
 static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
@@ -63,7 +63,7 @@ static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t)
-			__damon_pa_prepare_access_check(r, ctx->addr_unit);
+			__damon_pa_prepare_access_check(ctx, r);
 	}
 }
 
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index b069dbc7e3d2..6cf06ffdf880 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -332,10 +332,11 @@ static void damon_va_mkold(struct mm_struct *mm, unsigned long addr)
  * Functions for the access checking of the regions
  */
 
-static void __damon_va_prepare_access_check(struct mm_struct *mm,
-					struct damon_region *r)
+static void __damon_va_prepare_access_check(struct damon_ctx *ctx,
+					    struct mm_struct *mm,
+					    struct damon_region *r)
 {
-	r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
+	r->sampling_addr = damon_rand_fast(ctx, r->ar.start, r->ar.end);
 
 	damon_va_mkold(mm, r->sampling_addr);
 }
@@ -351,7 +352,7 @@ static void damon_va_prepare_access_checks(struct damon_ctx *ctx)
 		if (!mm)
 			continue;
 		damon_for_each_region(r, t)
-			__damon_va_prepare_access_check(mm, r);
+			__damon_va_prepare_access_check(ctx, mm, r);
 		mmput(mm);
 	}
 }
-- 
2.43.0


