Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD93C98332
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 17:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74946B009B; Sat, 17 Jan 2026 12:53:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09BD6B009D; Sat, 17 Jan 2026 12:53:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9352B6B009E; Sat, 17 Jan 2026 12:53:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6DA6B009F
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 12:53:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E18D14037B
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:10 +0000 (UTC)
X-FDA: 84342202140.28.9F96013
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 85819A0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=egHs3dir;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768672388; a=rsa-sha256;
	cv=none;
	b=ecWbEMUJmkdKDkg5Zqmt6737E4yC6nqRldGxoC+Vxzs9UtQnIAghUPKjQxfPxCIQXqwqSS
	uHBMIOa7YoUeoh//nacOOnpQ1ZSNSsaKwFAzSS1xInwtVtbDa95giOEUgkkh75P94FyVI4
	eevntmdP5byO/0eJPRN29Dy/I2wsKwE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=egHs3dir;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768672388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSJD1t1pob/PpOjXEkqz90gVULYT3l2jPVDwnv+4fTc=;
	b=q11+i0NvLI03US9xOl3pzofF0Vdw99jGcw4805LX7S7jz5ZtY2GZprsUKLBT4sz1ue1prD
	j5wnk+SRXnfeau0X3ZVcPcacbBNpJq6tCUP3HiI2ABAX3cuttsi5apOFMBjjz4//o0kZf0
	bjbjI3ElPOLd2U9+mkW6IRQZ3qMfbo4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 314A844513;
	Sat, 17 Jan 2026 17:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FA9C19423;
	Sat, 17 Jan 2026 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768672387;
	bh=eZLadMFQedwAgPWbni+zR0dV+mf8L1sym/xg/ZsD0/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egHs3dirRF59oNlIYE7tn5Q1hvvkWUAw0w2lN8id4ucjKdiBK1l52DipnrBUqbhSG
	 fs8aSqHBsNQkr5PBOQHb/u5jRiqT9z3dVTLMKs3uYG49dD51he3FYN2BUO0WafX2rJ
	 VH3jbV9+BWgsndWIyOD7dbC3iLZ7nq/bKnEOPgj8nFnr+hnC5NXG9zCqBPuxliUps7
	 vw21zpSlAkGnXKDQXhVpZsj3ZAo7m/v2Jzzkgc+eWYt6jkwfPohZpU2udwWOnxCj+l
	 IfnbwDvddBUx6TwkqOVFpxC9dxpqlrPlxmFp+yZsprkM6jljiNANlQqVOS4cdD+KRH
	 4fdYMRWResdPQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/8] mm/damon: rename min_sz_region of damon_ctx to min_region_sz
Date: Sat, 17 Jan 2026 09:52:55 -0800
Message-ID: <20260117175256.82826-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260117175256.82826-1-sj@kernel.org>
References: <20260117175256.82826-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 85819A0005
X-Stat-Signature: 47u1yc9rfcjdxfpqiqb8ih8em4u7c9qw
X-Rspam-User: 
X-HE-Tag: 1768672388-560702
X-HE-Meta: U2FsdGVkX1+ExkLHRj+2tkPXSevinysRWIV77pqclypd8Kzt9uF4eeqazPOxoxNBHgERoHfRigdSMcNeXoOsOY6KoyomQA9lRCzPcNzuabB7fwJjQgTVevXh1bGvjrkoa+88HMzn+5PH+iyKSdMY+838PlJAZidjcK18BkR4SGJOZtFQJXPsD/ZXJyi4bf7qO+Be9NRTN5APbV2x1uI1rzI7Lt/g4N3CDr4iLpVBzrm+hwY3DUv1O17vC4JQaoAee9oVLDZufZdpbFdGvOp/mD2AC85c4YqdvjJ/6sopkGW6Zpt1vw7dWBoS/BSx8zmuSI9pPkoHWafr8Yy9g2zNtKfq2YplafVEiTIwKjh1zf+t7e09Rhx4JHoDIyiTo7RUNIx1B5U99yq058wm0HKO/vfhQdbtvWCIewiTe1PeZvHPv4hxgykf0EbNDGL+GLVL2O17HPTlr6FnoIwjHlz4jvuGVJNhVLYC7RP2PrjMrsKVJ0lbqCF7e7sOkabRJCBdWkkIHSEdyVoB7f/R6fcoLPcuYlPB/Ayow3V/lcxiTSMO94OCloukOb1lAwnjOQ5k3ftQM4FkZIqixNFfQIZqm3mU85hyu4MuIhYjNRQL1W5TlOs8c7BT/SRkrZrmPcoPgyqZAxt6ibvmemV42C6uV9zcHYZiXoe7bQOhAewehkErZPk9r42eZIrhaOTYTJYJBa/NbU9Yj3ReXhPKOx0jD/9V3ykFdpgA5exwCZHp9lHGb27VOAyPu8nQs54MDJaAD6unp1qjrAlUJ+Xzsr14juiGjJs76oNbyUDzlJkYQbAgc5D6UTCu38hHPpDKahvZXXKNDBKenEkuvgru79kaJ7FCiPbxjLx/6K0LLUlgU5IsXD/K/AqPSYHddo3W2E8CLrUWLqHCyGSLcmIECSgmubRvmCOi8Ry6iFCTh5cq3cPtOgfOTHwc4eDTxR/Ycsxugb3Qe7hOAnJfkK29Jf+
 umiuqd3Y
 S//fzqxPaqRbx5FU/vT3AhgOTfWd2TUtaHDtCmAg6Mx31lkxJrgcgtDl6FJH4JGw/CI/czUCI/lP11bmVbXnmuLqQaoMfd8b6sAJ+7kei2AQ/YXkRGIEOMwGtNaxvcgJUV+jQD6TXZ34Bc5dwrvS9gFUgwk7ubUoc+LUG3RDTSNoI9HlQvN8p+AYafNli7xunot8Sbe1C8uexsatJGkvtEHY0ZN4gjUMhpURErt03CZnkY9vqDbsEDyLP5be2wwyCHwp/ZfOJFKkJdgT/MwtOL6wd4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'min_sz_region' field of 'struct damon_ctx' represents the minimum size
of each DAMON region for the context.  'struct damos_access_pattern' has
a field of the same name.  It confuses readers and makes 'grep' less
optimal for them.  Rename it to 'min_region_sz'.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  8 ++---
 mm/damon/core.c       | 69 ++++++++++++++++++++++---------------------
 mm/damon/lru_sort.c   |  4 +--
 mm/damon/reclaim.c    |  4 +--
 mm/damon/stat.c       |  2 +-
 mm/damon/sysfs.c      |  9 +++---
 6 files changed, 49 insertions(+), 47 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 5bf8db1d78fe..a4fea23da857 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -773,7 +773,7 @@ struct damon_attrs {
  *
  * @ops:	Set of monitoring operations for given use cases.
  * @addr_unit:	Scale factor for core to ops address conversion.
- * @min_sz_region:		Minimum region size.
+ * @min_region_sz:	Minimum region size.
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
  */
@@ -818,7 +818,7 @@ struct damon_ctx {
 /* public: */
 	struct damon_operations ops;
 	unsigned long addr_unit;
-	unsigned long min_sz_region;
+	unsigned long min_region_sz;
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
@@ -907,7 +907,7 @@ static inline void damon_insert_region(struct damon_region *r,
 void damon_add_region(struct damon_region *r, struct damon_target *t);
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
-		unsigned int nr_ranges, unsigned long min_sz_region);
+		unsigned int nr_ranges, unsigned long min_region_sz);
 void damon_update_region_access_rate(struct damon_region *r, bool accessed,
 		struct damon_attrs *attrs);
 
@@ -975,7 +975,7 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
-				unsigned long min_sz_region);
+				unsigned long min_region_sz);
 
 #endif	/* CONFIG_DAMON */
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5508bc794172..70efbf22a2b4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -203,7 +203,7 @@ static int damon_fill_regions_holes(struct damon_region *first,
  * @t:		the given target.
  * @ranges:	array of new monitoring target ranges.
  * @nr_ranges:	length of @ranges.
- * @min_sz_region:	minimum region size.
+ * @min_region_sz:	minimum region size.
  *
  * This function adds new regions to, or modify existing regions of a
  * monitoring target to fit in specific ranges.
@@ -211,7 +211,7 @@ static int damon_fill_regions_holes(struct damon_region *first,
  * Return: 0 if success, or negative error code otherwise.
  */
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
-		unsigned int nr_ranges, unsigned long min_sz_region)
+		unsigned int nr_ranges, unsigned long min_region_sz)
 {
 	struct damon_region *r, *next;
 	unsigned int i;
@@ -248,16 +248,16 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 			/* no region intersects with this range */
 			newr = damon_new_region(
 					ALIGN_DOWN(range->start,
-						min_sz_region),
-					ALIGN(range->end, min_sz_region));
+						min_region_sz),
+					ALIGN(range->end, min_region_sz));
 			if (!newr)
 				return -ENOMEM;
 			damon_insert_region(newr, damon_prev_region(r), r, t);
 		} else {
 			/* resize intersecting regions to fit in this range */
 			first->ar.start = ALIGN_DOWN(range->start,
-					min_sz_region);
-			last->ar.end = ALIGN(range->end, min_sz_region);
+					min_region_sz);
+			last->ar.end = ALIGN(range->end, min_region_sz);
 
 			/* fill possible holes in the range */
 			err = damon_fill_regions_holes(first, last, t);
@@ -553,7 +553,7 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.max_nr_regions = 1000;
 
 	ctx->addr_unit = 1;
-	ctx->min_sz_region = DAMON_MIN_REGION_SZ;
+	ctx->min_region_sz = DAMON_MIN_REGION_SZ;
 
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
@@ -1142,7 +1142,7 @@ static struct damon_target *damon_nth_target(int n, struct damon_ctx *ctx)
  * If @src has no region, @dst keeps current regions.
  */
 static int damon_commit_target_regions(struct damon_target *dst,
-		struct damon_target *src, unsigned long src_min_sz_region)
+		struct damon_target *src, unsigned long src_min_region_sz)
 {
 	struct damon_region *src_region;
 	struct damon_addr_range *ranges;
@@ -1159,7 +1159,7 @@ static int damon_commit_target_regions(struct damon_target *dst,
 	i = 0;
 	damon_for_each_region(src_region, src)
 		ranges[i++] = src_region->ar;
-	err = damon_set_regions(dst, ranges, i, src_min_sz_region);
+	err = damon_set_regions(dst, ranges, i, src_min_region_sz);
 	kfree(ranges);
 	return err;
 }
@@ -1167,11 +1167,11 @@ static int damon_commit_target_regions(struct damon_target *dst,
 static int damon_commit_target(
 		struct damon_target *dst, bool dst_has_pid,
 		struct damon_target *src, bool src_has_pid,
-		unsigned long src_min_sz_region)
+		unsigned long src_min_region_sz)
 {
 	int err;
 
-	err = damon_commit_target_regions(dst, src, src_min_sz_region);
+	err = damon_commit_target_regions(dst, src, src_min_region_sz);
 	if (err)
 		return err;
 	if (dst_has_pid)
@@ -1198,7 +1198,7 @@ static int damon_commit_targets(
 			err = damon_commit_target(
 					dst_target, damon_target_has_pid(dst),
 					src_target, damon_target_has_pid(src),
-					src->min_sz_region);
+					src->min_region_sz);
 			if (err)
 				return err;
 		} else {
@@ -1225,7 +1225,7 @@ static int damon_commit_targets(
 			return -ENOMEM;
 		err = damon_commit_target(new_target, false,
 				src_target, damon_target_has_pid(src),
-				src->min_sz_region);
+				src->min_region_sz);
 		if (err) {
 			damon_destroy_target(new_target, NULL);
 			return err;
@@ -1272,7 +1272,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	}
 	dst->ops = src->ops;
 	dst->addr_unit = src->addr_unit;
-	dst->min_sz_region = src->min_sz_region;
+	dst->min_region_sz = src->min_region_sz;
 
 	return 0;
 }
@@ -1305,8 +1305,8 @@ static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
 
 	if (ctx->attrs.min_nr_regions)
 		sz /= ctx->attrs.min_nr_regions;
-	if (sz < ctx->min_sz_region)
-		sz = ctx->min_sz_region;
+	if (sz < ctx->min_region_sz)
+		sz = ctx->min_region_sz;
 
 	return sz;
 }
@@ -1696,7 +1696,7 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_target *t,
  * @t:	The target of the region.
  * @rp:	The pointer to the region.
  * @s:	The scheme to be applied.
- * @min_sz_region:	minimum region size.
+ * @min_region_sz:	minimum region size.
  *
  * If a quota of a scheme has exceeded in a quota charge window, the scheme's
  * action would applied to only a part of the target access pattern fulfilling
@@ -1714,7 +1714,8 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_target *t,
  * Return: true if the region should be entirely skipped, false otherwise.
  */
 static bool damos_skip_charged_region(struct damon_target *t,
-		struct damon_region **rp, struct damos *s, unsigned long min_sz_region)
+		struct damon_region **rp, struct damos *s,
+		unsigned long min_region_sz)
 {
 	struct damon_region *r = *rp;
 	struct damos_quota *quota = &s->quota;
@@ -1736,11 +1737,11 @@ static bool damos_skip_charged_region(struct damon_target *t,
 		if (quota->charge_addr_from && r->ar.start <
 				quota->charge_addr_from) {
 			sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
-					r->ar.start, min_sz_region);
+					r->ar.start, min_region_sz);
 			if (!sz_to_skip) {
-				if (damon_sz_region(r) <= min_sz_region)
+				if (damon_sz_region(r) <= min_region_sz)
 					return true;
-				sz_to_skip = min_sz_region;
+				sz_to_skip = min_region_sz;
 			}
 			damon_split_region_at(t, r, sz_to_skip);
 			r = damon_next_region(r);
@@ -1766,7 +1767,7 @@ static void damos_update_stat(struct damos *s,
 
 static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos_filter *filter,
-		unsigned long min_sz_region)
+		unsigned long min_region_sz)
 {
 	bool matched = false;
 	struct damon_target *ti;
@@ -1783,8 +1784,8 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		matched = target_idx == filter->target_idx;
 		break;
 	case DAMOS_FILTER_TYPE_ADDR:
-		start = ALIGN_DOWN(filter->addr_range.start, min_sz_region);
-		end = ALIGN_DOWN(filter->addr_range.end, min_sz_region);
+		start = ALIGN_DOWN(filter->addr_range.start, min_region_sz);
+		end = ALIGN_DOWN(filter->addr_range.end, min_region_sz);
 
 		/* inside the range */
 		if (start <= r->ar.start && r->ar.end <= end) {
@@ -1820,7 +1821,7 @@ static bool damos_core_filter_out(struct damon_ctx *ctx, struct damon_target *t,
 
 	s->core_filters_allowed = false;
 	damos_for_each_core_filter(filter, s) {
-		if (damos_filter_match(ctx, t, r, filter, ctx->min_sz_region)) {
+		if (damos_filter_match(ctx, t, r, filter, ctx->min_region_sz)) {
 			if (filter->allow)
 				s->core_filters_allowed = true;
 			return !filter->allow;
@@ -1955,7 +1956,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 	if (c->ops.apply_scheme) {
 		if (quota->esz && quota->charged_sz + sz > quota->esz) {
 			sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
-					c->min_sz_region);
+					c->min_region_sz);
 			if (!sz)
 				goto update_stat;
 			damon_split_region_at(t, r, sz);
@@ -2003,7 +2004,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (quota->esz && quota->charged_sz >= quota->esz)
 			continue;
 
-		if (damos_skip_charged_region(t, &r, s, c->min_sz_region))
+		if (damos_skip_charged_region(t, &r, s, c->min_region_sz))
 			continue;
 
 		if (s->max_nr_snapshots &&
@@ -2496,7 +2497,7 @@ static void damon_split_region_at(struct damon_target *t,
 
 /* Split every region in the given target into 'nr_subs' regions */
 static void damon_split_regions_of(struct damon_target *t, int nr_subs,
-				  unsigned long min_sz_region)
+				  unsigned long min_region_sz)
 {
 	struct damon_region *r, *next;
 	unsigned long sz_region, sz_sub = 0;
@@ -2506,13 +2507,13 @@ static void damon_split_regions_of(struct damon_target *t, int nr_subs,
 		sz_region = damon_sz_region(r);
 
 		for (i = 0; i < nr_subs - 1 &&
-				sz_region > 2 * min_sz_region; i++) {
+				sz_region > 2 * min_region_sz; i++) {
 			/*
 			 * Randomly select size of left sub-region to be at
 			 * least 10 percent and at most 90% of original region
 			 */
 			sz_sub = ALIGN_DOWN(damon_rand(1, 10) *
-					sz_region / 10, min_sz_region);
+					sz_region / 10, min_region_sz);
 			/* Do not allow blank region */
 			if (sz_sub == 0 || sz_sub >= sz_region)
 				continue;
@@ -2552,7 +2553,7 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 		nr_subregions = 3;
 
 	damon_for_each_target(t, ctx)
-		damon_split_regions_of(t, nr_subregions, ctx->min_sz_region);
+		damon_split_regions_of(t, nr_subregions, ctx->min_region_sz);
 
 	last_nr_regions = nr_regions;
 }
@@ -2902,7 +2903,7 @@ static bool damon_find_biggest_system_ram(unsigned long *start,
  * @t:		The monitoring target to set the region.
  * @start:	The pointer to the start address of the region.
  * @end:	The pointer to the end address of the region.
- * @min_sz_region:	Minimum region size.
+ * @min_region_sz:	Minimum region size.
  *
  * This function sets the region of @t as requested by @start and @end.  If the
  * values of @start and @end are zero, however, this function finds the biggest
@@ -2914,7 +2915,7 @@ static bool damon_find_biggest_system_ram(unsigned long *start,
  */
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 			unsigned long *start, unsigned long *end,
-			unsigned long min_sz_region)
+			unsigned long min_region_sz)
 {
 	struct damon_addr_range addr_range;
 
@@ -2927,7 +2928,7 @@ int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 
 	addr_range.start = *start;
 	addr_range.end = *end;
-	return damon_set_regions(t, &addr_range, 1, min_sz_region);
+	return damon_set_regions(t, &addr_range, 1, min_region_sz);
 }
 
 /*
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 9dde096a9064..7bc5c0b2aea3 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -298,7 +298,7 @@ static int damon_lru_sort_apply_parameters(void)
 	if (!monitor_region_start && !monitor_region_end)
 		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
-	param_ctx->min_sz_region = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
+	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
@@ -345,7 +345,7 @@ static int damon_lru_sort_apply_parameters(void)
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
-					param_ctx->min_sz_region);
+					param_ctx->min_region_sz);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index c343622a2f52..43d76f5bed44 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -208,7 +208,7 @@ static int damon_reclaim_apply_parameters(void)
 	if (!monitor_region_start && !monitor_region_end)
 		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
-	param_ctx->min_sz_region = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
+	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
@@ -251,7 +251,7 @@ static int damon_reclaim_apply_parameters(void)
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
-					param_ctx->min_sz_region);
+					param_ctx->min_region_sz);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 5e18b164f6d8..536f02bd173e 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -181,7 +181,7 @@ static struct damon_ctx *damon_stat_build_ctx(void)
 		goto free_out;
 	damon_add_target(ctx, target);
 	if (damon_set_region_biggest_system_ram_default(target, &start, &end,
-							ctx->min_sz_region))
+							ctx->min_region_sz))
 		goto free_out;
 	return ctx;
 free_out:
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 57d36d60f329..b7f66196bec4 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1365,7 +1365,7 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 
 static int damon_sysfs_set_regions(struct damon_target *t,
 		struct damon_sysfs_regions *sysfs_regions,
-		unsigned long min_sz_region)
+		unsigned long min_region_sz)
 {
 	struct damon_addr_range *ranges = kmalloc_array(sysfs_regions->nr,
 			sizeof(*ranges), GFP_KERNEL | __GFP_NOWARN);
@@ -1387,7 +1387,7 @@ static int damon_sysfs_set_regions(struct damon_target *t,
 		if (ranges[i - 1].end > ranges[i].start)
 			goto out;
 	}
-	err = damon_set_regions(t, ranges, sysfs_regions->nr, min_sz_region);
+	err = damon_set_regions(t, ranges, sysfs_regions->nr, min_region_sz);
 out:
 	kfree(ranges);
 	return err;
@@ -1409,7 +1409,8 @@ static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
 			return -EINVAL;
 	}
 	t->obsolete = sys_target->obsolete;
-	return damon_sysfs_set_regions(t, sys_target->regions, ctx->min_sz_region);
+	return damon_sysfs_set_regions(t, sys_target->regions,
+			ctx->min_region_sz);
 }
 
 static int damon_sysfs_add_targets(struct damon_ctx *ctx,
@@ -1469,7 +1470,7 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 	ctx->addr_unit = sys_ctx->addr_unit;
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
 	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
-		ctx->min_sz_region = max(
+		ctx->min_region_sz = max(
 				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
-- 
2.47.3

