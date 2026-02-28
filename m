Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0120BFD0047
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 22:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78F0A6B008A; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7315B6B008C; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E066B008A; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4B77D6B0089
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 145A51C29D
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:28:43 +0000 (UTC)
X-FDA: 84495306126.02.5AFD229
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6D33714000A
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:28:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pt2gpgN0;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772317721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ms8CVxKsnsRmtckJ1ZNKJRGEX2OIQmzXsg3MctehWQQ=;
	b=orN1NN1ppP4NWqxOczlyrq0sxxBjQ1yVKdNoV6Cn9pFKcjZcouO/8djE4ae1SR/WVLRk8v
	sHd9GgBWxubc9zoXcAENsoAwmn8REGd9oaRa1o1H1rdVtYcbg47MHE/+CNbikiQdh5uMVI
	FOkyUkJb4+v5VhiHecnnn+HTRPE5A/E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pt2gpgN0;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772317721; a=rsa-sha256;
	cv=none;
	b=fMmPXPuDs6ABgDK/SgWoia8yVeC9o4/7TqK5ufGjCZ0lQG9vDvqQJ6JpMbAAntYf76QOEY
	OxHpNfHtITkKtWI9F3B/PLZF8LWAf9obfN7TSJhiIvsqoMWs4/pr1OzU1UY+gPPqlkvlfM
	yb2KOlNUSv6aLXCCYDVM72Ec2/2tLZc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FF13600AA;
	Sat, 28 Feb 2026 22:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05A9C19424;
	Sat, 28 Feb 2026 22:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772317720;
	bh=+qqd/MjUtEwjncKaZxgDH9DLW9LHMFD6sPqL4L5XCQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pt2gpgN0mkOfMZvN5XWX4QOywu+PYFU7KTUXBQII6/p15kbbSFLDVYGGrye7EQaR2
	 ooqTABJLu+MAxKxHuyqSepIbWFdrta8ka2ydL+bSNFijGR+GBXR9YDJf1EFCqVkqA+
	 3flOYHpgqPJhwsxc180u0/nik5xlRvyVbSppjOTKo9rz8GU7vhmJ0dxl93bi1Y6X8H
	 Yy+98YLMoh04UWo8KOHyWamh0t8tMtgP1SJvaf3c4n4JZCQkw3ZLgyYLjgFgfGLGlg
	 05WhwDBcFxwRR1Hsng0knE/Ew+E8ZJMBI8aJtv77EazGj7H4YlgANY42g5CvqBqCTP
	 LDw7jKCmTu3gg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] mm/damon/core: split regions for min_nr_regions
Date: Sat, 28 Feb 2026 14:28:25 -0800
Message-ID: <20260228222831.7232-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260228222831.7232-1-sj@kernel.org>
References: <20260228222831.7232-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6D33714000A
X-Stat-Signature: dud6rq7qwsey731sk7mtc3uikwtqxsyg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772317721-646541
X-HE-Meta: U2FsdGVkX1+XcCZw0q+h+ndtmSOReUEfTEmx2JT32OGs8d0WUE4dKylqtJcIWmpQXHQr29rMkX4aJZVROKekoLqDb1+GRms1s8CB40y9U77/phIF0HxS8gKWjBT8KkSx9/NPaKXRvU1ImTngrn900ueBVk20CS7kYvZwJHFmiRTNLQS7tF+meITD6hAFRlZGO2d9DzgCskk5hjQ6vsERg3fayYxfAzK+44qFpsS8H3ng6n8yenni3iPXckYd1vMeDYVnTakzV/n+MZgUer52rr3UxcZJsxdhRJBEtfLcKWfeM5IFCGsaaKYkaZYKZk+8joSA+lmVNMPqRY70im/kWekDH7HnE1gy0aVTgyfV1tdyeiMdqwP8AltKdoyt6p/YIaou7NVPgT79pd5I8RKpnlnXJvvcdXfMJ7qDVtQLjmKdJA1xlvLqRM1JHXQW2yAzAcqdbHw+OmQANcxJ8Y2MHvTMiv5giFj28GchA4MldpLgohAzsFCF5OiwNh6wF4NkVtAVnPhtr8IkU581Z3ZkL8x42NLQagzgyajyUH9/DOgMPHdvKGjl5XC1E8vpg21HvwwswZ3WMxB5Ksl1euNpZ1o3Ad1ls8hjflfJrhP3bdGOKZJdxLFs9d6Muk2YCCYsSW8Br2fEKXl4wQPayVhknWl2LhpFYdCil84U2MKq73EqCm7bjsTDK0ahJSHCCbYb118IsL89nrcyKSBgxsh9M9FGk1IHW8ATkpxXuDDAhNo2oPyJOlIaxvQUHCvvL//P/kQPlaw67nICIqLOfjGAhe+2CQBmEz1rwZW+Cn51Tz7JdBtOmlQrODq6aNKDsv/2ok9SXhzCCkctmFF1h8GR2bcs6PNIkq02vufTFE7qbEv4/WLuvAnj5MEX9FV9LzKGVV/kmNGcQUJep4ixb3DqEkyHyiE9BsgymV4QBCB9slky8ytZRz2b7GIVOAZ1OjytgDet8N6fITfUlbMf+fB
 88z0CcwU
 s0Wt63PyGfEMetBKFySd0QyvzK7fM7YucLTCO1hYD3b7aWyt2V+OHa8dwyXFXgEQR57lj5uhuMG6eY+Kddy3ShZeiK6xx3T5CTGOiKmFBX3iLX1XLuY3R3T1BMCAGb4G/AoIvstOlKOxRe3ZNcI3XfPN1uXNPNShQSJwtwtd4IdAZPD6JHVv0H70fTF75R0DhoI9hJHNcbqwgK5yRDQ9FoQhb8/8ia+vg5l3bwdI3PEh3+CTIPCXeHqK61znTyCvvF7nDSit4qZoE/gYnp/X7FR3ST8Rxv8aSDiwynnCtKIJAtRxGu+LBNmfmP70nhTkSS9MVjuhdsPYC/y7CdvYijixxKqVjeOohpGFhonKyPPglfXZat16MfXx4Na9x3Y15IscYaVRR9UJMBWl1cMjQIiWXCNJNZlxAAA2i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core layer respects the min_nr_regions parameter by setting the
maximum size of each region as total monitoring region size divided by
the parameter value.  And the limit is applied by preventing merge of
regions that result in a region larger than the maximum size.  The limit
is updated per ops update interval, because vaddr updates the monitoring
regions on the ops update callback.

It does nothing for the beginning state.  That's because the users can
set the initial monitoring regions as they want.  That is, if the users
really care about the min_nr_regions, they are supposed to set the
initial monitoring regions to have more than min_nr_regions regions.
The virtual address space operation set, vaddr, has an exceptional case.
Users can ask the ops set to configure the initial regions on its own.
For the case, vaddr sets up the initial regions to meet the
min_nr_regions.  So, vaddr has exceptional support, but basically users
are required to set the regions on their own if they want min_nr_regions
to be respected.

When 'min_nr_regions' is high, such initial setup is difficult.  If
DAMON sysfs interface is used for that, the memory for saving the
initial setup is also a waste.

Even if the user forgives the setup, DAMON will eventually make more
than min_nr_regions regions by splitting operations.  But it will take
time.  If the aggregation interval is long, the delay could be
problematic.  There was actually a report [1] of the case.  The reporter
wanted to do page granular monitoring with a large aggregation interval.

Also, DAMON is doing nothing for online changes on monitoring regions
and min_nr_regions.  For example, the user can remove a monitoring
region or increase min_nr_regions while DAMON is running.

Split regions larger than the size at the beginning of the kdamond main
loop, to fix the initial setup issue.  Also do the split every
aggregation interval, for online changes.  This means the behavior is
slightly changed.  It is difficult to imagine a use case that actually
depends on the old behavior, though.  So this change is arguably fine.

Note that the size limit is aligned by damon_ctx->min_region_sz and
cannot be zero.  That is, if min_nr_region is larger than the total size
of monitoring regions divided by ->min_region_sz, that cannot be
respected.

[1] https://lore.kernel.org/CAC5umyjmJE9SBqjbetZZecpY54bHpn2AvCGNv3aF6J=1cfoPXQ@mail.gmail.com

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index dcf7027637550..f1a97e85824ac 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1314,6 +1314,40 @@ static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
 	return sz;
 }
 
+static void damon_split_region_at(struct damon_target *t,
+				  struct damon_region *r, unsigned long sz_r);
+
+/*
+ * damon_apply_min_nr_regions() - Make effect of min_nr_regions parameter.
+ * @ctx:	monitoring context.
+ *
+ * This function implement min_nr_regions (minimum number of damon_region
+ * objects in the given monitoring context) behavior.  It first calculates
+ * maximum size of each region for enforcing the min_nr_regions as total size
+ * of the regions divided by the min_nr_regions.  After that, this function
+ * splits regions to ensure all regions are equal to or smaller than the size
+ * limit.  Finally, this function returns the maximum size limit.
+ *
+ * Returns: maximum size of each region for convincing min_nr_regions.
+ */
+static unsigned long damon_apply_min_nr_regions(struct damon_ctx *ctx)
+{
+	unsigned long max_region_sz = damon_region_sz_limit(ctx);
+	struct damon_target *t;
+	struct damon_region *r, *next;
+
+	max_region_sz = ALIGN(max_region_sz, ctx->min_region_sz);
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region_safe(r, next, t) {
+			while (damon_sz_region(r) > max_region_sz) {
+				damon_split_region_at(t, r, max_region_sz);
+				r = damon_next_region(r);
+			}
+		}
+	}
+	return max_region_sz;
+}
+
 static int kdamond_fn(void *data);
 
 /*
@@ -1670,9 +1704,6 @@ static void kdamond_tune_intervals(struct damon_ctx *c)
 	damon_set_attrs(c, &new_attrs);
 }
 
-static void damon_split_region_at(struct damon_target *t,
-				  struct damon_region *r, unsigned long sz_r);
-
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
 {
 	unsigned long sz;
@@ -2757,7 +2788,7 @@ static int kdamond_fn(void *data)
 	if (!ctx->regions_score_histogram)
 		goto done;
 
-	sz_limit = damon_region_sz_limit(ctx);
+	sz_limit = damon_apply_min_nr_regions(ctx);
 
 	while (!kdamond_need_stop(ctx)) {
 		/*
@@ -2782,10 +2813,13 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 
-		if (ctx->passed_sample_intervals >= next_aggregation_sis)
+		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
 			kdamond_merge_regions(ctx,
 					max_nr_accesses / 10,
 					sz_limit);
+			/* online updates might be made */
+			sz_limit = damon_apply_min_nr_regions(ctx);
+		}
 
 		/*
 		 * do kdamond_call() and kdamond_apply_schemes() after
@@ -2842,7 +2876,6 @@ static int kdamond_fn(void *data)
 				sample_interval;
 			if (ctx->ops.update)
 				ctx->ops.update(ctx);
-			sz_limit = damon_region_sz_limit(ctx);
 		}
 	}
 done:
-- 
2.47.3

