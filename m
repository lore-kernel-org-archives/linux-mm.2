Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3E76CD4F3D
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 22:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5232A6B0095; Sat, 16 May 2026 18:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA1E6B0096; Sat, 16 May 2026 18:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263A76B0098; Sat, 16 May 2026 18:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 162296B0095
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:34:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D11A31A0448
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:53 +0000 (UTC)
X-FDA: 84774739266.12.8EB4037
Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	by imf23.hostedemail.com (Postfix) with ESMTP id E162B140009
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WlDnOv5h;
	spf=pass (imf23.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778970891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V8+0GSDgF6eaqM7aU4GbWIS0I2DgBkn1ubqIjVsKT2c=;
	b=ifyZaJQWpxlzUJsfGqNpSlI8YXCS5UxS+vAFQq76kWItiERv+LQv+0IHZRGJRPraKLjb1T
	Ur4Es5geBGcAVnEe0/NwuKRbpCwogrZkEbPuTfCvKsACSH+JQ5HBMgYuG+Qh5XUy7Uy0rw
	oxgWRiQtEErg7ImYKMv80tOczAvLRf8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WlDnOv5h;
	spf=pass (imf23.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778970891; a=rsa-sha256;
	cv=none;
	b=jxq8WCW9fwqOmJuu7aRW9TZNZzi7T2wpnsxI/Fk/uhK/zZEqyTlVsQ5bQbvdJXNKNpWqEw
	LofzIOvLu7UOAivHJyQxmfyk9pXGaal81RtLoawIH2Is0efZXU8Tv4lOmbTjUZtH8M32Fr
	LXQTxfgzaWl5GFQvSu/TygSHDwztkX8=
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-7b41fdf9de2so3959687b3.0
        for <linux-mm@kvack.org>; Sat, 16 May 2026 15:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778970891; x=1779575691; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V8+0GSDgF6eaqM7aU4GbWIS0I2DgBkn1ubqIjVsKT2c=;
        b=WlDnOv5hADVvYYSsD0w3tJiFcUZrmIYMEf6/9woQ/k8f5j7Rbrlnws9X8mPgwvULF8
         YgX/CYcRkpymWzs4myRxVmhRz39Oe5MUo8Srjgg2/aR2jusnEc/t4ok5lmaMrM6vo41N
         NT7mkvd3Q4VZly/GRONL7UdMoW2tSSXiuL1CNjdNZtTkgSOKk+hpa4dql6jiJiUAoOKa
         8abPNAJGJo0NOAz43BAQw+Yydya6HxotYXGtYiiYplxcDP1qAMKNCLH32b0SHmhahGgg
         2muCcJAzQjjmUtVZZHigZQxQTDnMkNIDx2UmqCSR/v24MuhcUFc8n/pfuGvNtBrxBODl
         nTaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778970891; x=1779575691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V8+0GSDgF6eaqM7aU4GbWIS0I2DgBkn1ubqIjVsKT2c=;
        b=s1BLZAlG4kejihrbhsVqm291irmJNdxMvhFex+dW4IRsG8Y6uymuC1WOWd105LywST
         TZWI4nlzQm3M4YgfUZ6LpDsbqWKxzUdV53MtGVL4XHiuJEUjXWS8Z3YvDtvFrW2cfDtX
         fsU1SU5OQild5vq4rRobPhG6ZPAQwnjBWQTNj1S2xk+jrTkFqrZ5lSh0OhbxKcdL7TQK
         oU1rACWq/sMBGN77PDgnnzYoCcOMki+TdaFGYDOAKWEHzfYuuvK6qpoyBx0rTcYL23tB
         jVs9hwvl6ehigAWdzSdD4OuRtBCVgEl26WbZa1xXUhdjq3s1YsmDFbyUuPBjLQSz0DoX
         XmXg==
X-Forwarded-Encrypted: i=1; AFNElJ8AlhsSGk5mHvqqlvk7mibJX/dnY1OmzSkkJ74aUPXOtpSqmurUpSlYP9AXYAnDnvP1UGCXXi40zw==@kvack.org
X-Gm-Message-State: AOJu0Yx5D9sGZJoiyg9y59Y94HbxlDnoitjuWyacjhNjXca51UcyEMgU
	YOmfjCjiVIw7hVRrAD1AG7Zm/fNyi4LyUI+LZDCAyctB2vGQ49D3rcw=
X-Gm-Gg: Acq92OEJ0Bq0Nm7116ibFibU42hBDhW0Ry20ltxAdrPxaCZcWMlT+WF88QgYT6249gr
	iWLnS3x+Dl96ZlIEOzcZm7umT4cJltf/o7c7sYgD9PAJ6fIh+t5znrPRyGf9y6qQD0VksQuQjVX
	IMOEikwdowTnqh1mWW5UmO0NMafSwpImNyVdEIJ7Xc5eH9WQl0tiiNn+JVvw2robhv48Q883ek+
	Epc+1Sy5b41SIjh7dhjS5ukKofItJP2RrNPGE2ByFgwkZGq4mrJ/CR4fgeNYX66qZtPo41GRQrW
	mjJys5kLDm9IRnynrtaISKVt7zrQ2VeUU8y1dPezt/rvSucKRJu/YOexfbGTQ16773qQVOETv9p
	jWoLMYpzYaURrH7xz1RdNWYxOHYOu/hu1HP8QEf4iqpEQRbGZ+OOot184CGSy/2mvqnFV7MS2b1
	EU3jOUyFMop8Ju/92WRQwQ/F49dT7MVEN3t1RTTtrASQRljHCeVQuvbebrNXe5NyP9z46+1bB0h
	Q==
X-Received: by 2002:a05:690c:4a01:b0:79a:b440:5c77 with SMTP id 00721157ae682-7c959e890bfmr110956107b3.17.1778970890889;
        Sat, 16 May 2026 15:34:50 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7cc9d18c769sm641257b3.47.2026.05.16.15.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 15:34:50 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com,
	bharata@amd.com
Subject: [RFC PATCH 4/7] mm/damon/core: flat-array snapshot + bsearch in ring-drain loop
Date: Sat, 16 May 2026 15:34:29 -0700
Message-ID: <20260516223439.4033-5-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516223439.4033-1-ravis.opensrc@gmail.com>
References: <20260516223439.4033-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: thqrddjtjetq6srgxnge1kjbx3bzwih4
X-Rspamd-Queue-Id: E162B140009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778970891-353502
X-HE-Meta: U2FsdGVkX1/sOHgXOGbaLv/CHFDJme4AQNewUTJJJobEsgAWso5GQfk1tjS0+02Dhckeg5rhyxDtY8pB5bgsxYX8JkS6mM5ZrzlWFyJzWIMOiqbZ3kasSUWAi5Ljwn+MAHaaXRfB9FLGg35RoL3tfe1bGKF+CPwAH6Tr4TQSw4DCb1bUS2lvsOmO8MjJ1b+WRzCL46CLx9aDpSHoN9PqRA0DxNP1F2Uvqq3JpEVztdK0MnjlQzv34nEaTF/eMFqi57jXhTlR5p49frtXVNqtSK7hkqi58ouNyVWnJBBe0YC7YtwitB0osG2lHXzceFaooru6g00xoPkA5BnrejWyGI96OiZzc7E/e9ziIx7q+I3FY0T9mbqUoju6Fyuq07JunUcxSZpOlex+G+0nqnYyGNMZeiEvCyoFAIOsLBW5mXk9L+Oi9RZewHx3DrnAdEH2XIrOvL2uhDr5l/wgs3b13MCRB8v49pDeuhOMVkAKHOjE8JQcvVMDgo/W5aiH0QdebZupA+g7IFz8e7yRnFwOzHaylMxzX3nU/nzUPu5kDoQ6DaSUx20xhXiIkoiDQkUjvQ6G2X/DrGpUdDJ8AfODYvuk59gboVkI1yD9/doAXuCRUEUz2e2edOj/HplsyrfsRSHYNS/NIieaigOe8IBZrTM2U7ZAZV+Z3ZMB8Gz6nxw5rFuTI4AmCAirF37ZSEpRlij2dLb1d9zf5NsLZ4VUPbHzD/WcYPBWTrhx79A2AJTYkbAQqS9dgxwZEWlQ8wkKkjfyJKK/LwOCYdXuYtDOhsv56Tp6MVmtD1heecN8Hm9VQlQ8P2DmtcZPoer8Rng4WRWqQ+Lrbn/EfVqlDd/8kqVYg2CWW5pkcLh27DvkDyVkNBHBdWkWK1x2OTBYaKWWPhnd5MorwZfHAN5V3fVAA5msXYJbfdXftBLNnUZZWDp15vpFaPt/tY+evz5xNg8ojXI4Z1tS39rfqRPmTYA
 5+Sh66qS
 oGypAHsSTKHNnZvifEZUh8958AL/VjumJm3bpdiMI91dXza/O86Lll1pxxhTP3jPLcSXKkpyiy504zPdQEX1W5VdWOLAE+tEo48wk9PVvoU/g4H2m5H2kNcAQH+bGds76P3xlMFO+0gqt4iiR8wu8UTeQtUPuGQk+OslsoBFVJpjB6cDkeBzIujYDNlnwCp+3zmS8UgCbh/gHmdDHWllECSXbYuGQAGBfoZEQuSwibnQL/VLgmctcYvcB/K8ov9Vnf9YYmol+GABPbomCzPSOReEBW20cKZMjh1QQli0y2gm8G9obfG/QKoFLlTlvhzkWpoAfNkzxlTsQ3/sBoNdiiTylt1/ta7GEdSwIE8oH42mo0GQY9Bibv054+vr1QayFjmhZjNW7RdavEKw4Ob8Sj1WIcGmjL11xu5RNjqaLwVh+Kt0yXd188mHhGmgiGVT9glINpfV7xABXge6+zYEA9aPwdpl++O3gzAcy8PmjorpHcqWeYT9U7eGv1IOURF6DTP11s4RiTfKCoyrOWhsVEWXZGkF/SIIfdY/1eEHduPsij85Ovtm2O4RlyayJm/siqnYNt+yp91NaYhhKM++uWeIUV7hXzKh6DD2W9HI0w3RZFbqhaAPIlEQM7Us60iiM8TVCp6l577vAsy8eN7S0grIFHu10m77X8zcOrX/igcHpkXrt4ensrCp9Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The drain loop is O(reports x regions) when matching each ring entry
back to a region.  At sufficiently large CPU x region products the
linear scan exceeds the sample interval, producing unbounded backlog.

At drain start, snapshot each target's regions into a flat array
(struct damon_target_lookup), already sorted by ascending r->ar.start.
Replace the linear lookup with binary search over the snapshot,
reducing the drain to O(reports x log2(regions)).

Reject reports that straddle a region boundary
(addr + report->size > r->ar.end) so partial-region accesses are
not credited to the lower region.

If the snapshot allocation fails under memory pressure, log
ratelimited and fall through to zero-access reporting; the next
tick retries.

Hoist the per-report damon_sample_filter_out() check out of the
per-target loop so it runs once per ring entry rather than N times.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h |   7 +++
 mm/damon/core.c       | 137 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 126 insertions(+), 18 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 8e6e1cd89e551..35cc3d42fcba8 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1045,6 +1045,13 @@ struct damon_ctx {
 
 	/* Per-ctx PRNG state for damon_rand(); kdamond is the sole consumer. */
 	struct rnd_state rnd_state;
+	/* Reusable drain-loop snapshot buffer (avoids per-tick kmalloc) */
+	struct {
+		struct damon_target_lookup *lookups;
+		unsigned int nr_lookups;
+		struct damon_region **region_buf;
+		unsigned int region_buf_cap;
+	} drain_snapshot;
 };
 
 /* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9ed789e932ebd..03f9c671e8bc9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -29,6 +29,13 @@
 #define DAMON_REPORT_RING_SIZE	256
 #define DAMON_REPORT_RING_MASK	(DAMON_REPORT_RING_SIZE - 1)
 
+/* Per-target region lookup for drain loop */
+struct damon_target_lookup {
+	struct damon_region **regions;
+	unsigned int nr_regions;
+};
+
+
 struct damon_report_ring {
 	unsigned int head;	/* written by producer (NMI) */
 	unsigned int tail	/* written by consumer (kdamond) */
@@ -855,6 +862,7 @@ struct damon_ctx *damon_new_ctx(void)
 	INIT_LIST_HEAD(&ctx->schemes);
 
 	prandom_seed_state(&ctx->rnd_state, get_random_u64());
+	/* drain_snapshot zero-initialized by kzalloc — no explicit init */
 
 	return ctx;
 }
@@ -884,6 +892,8 @@ void damon_destroy_ctx(struct damon_ctx *ctx)
 	damon_for_each_sample_filter_safe(f, next_f, &ctx->sample_control)
 		damon_destroy_sample_filter(f, &ctx->sample_control);
 
+	kfree(ctx->drain_snapshot.lookups);
+	kfree(ctx->drain_snapshot.region_buf);
 	module_put(ctx->ops.owner);
 	kfree(ctx);
 }
@@ -3806,27 +3816,44 @@ static bool damon_sample_filter_out(struct damon_access_report *report,
 	return !filter->allow;
 }
 
+
 static void kdamond_apply_access_report(struct damon_access_report *report,
-		struct damon_target *t, struct damon_ctx *ctx)
+		struct damon_region **regions, unsigned int nr_regions,
+		struct damon_ctx *ctx)
 {
 	struct damon_region *r;
 	unsigned long addr;
+	int left, right, mid;
 
-	if (damon_sample_filter_out(report, &ctx->sample_control))
-		return;
 	if (damon_target_has_pid(ctx))
 		addr = report->vaddr;
 	else
 		addr = report->paddr;
 
-	/* todo: make search faster, e.g., binary search? */
-	damon_for_each_region(r, t) {
-		if (addr < r->ar.start)
-			continue;
-		if (r->ar.end < addr + report->size)
-			continue;
-		if (!r->access_reported)
-			damon_update_region_access_rate(r, true, &ctx->attrs);
+	/* Binary search the snapshot for the region containing addr. */
+	left = 0;
+	right = nr_regions - 1;
+	r = NULL;
+	while (left <= right) {
+		/* Avoid (left + right) overflow at large nr_regions. */
+		mid = left + (right - left) / 2;
+		if (addr < regions[mid]->ar.start)
+			right = mid - 1;
+		else if (addr >= regions[mid]->ar.end)
+			left = mid + 1;
+		else {
+			r = regions[mid];
+			break;
+		}
+	}
+
+	if (!r)
+		return;
+	/* Reject reports straddling a region boundary. */
+	if (addr + report->size > r->ar.end)
+		return;
+	if (!r->access_reported) {
+		damon_update_region_access_rate(r, true, &ctx->attrs);
 		r->access_reported = true;
 	}
 }
@@ -3850,10 +3877,79 @@ static unsigned int kdamond_apply_zero_access_report(struct damon_ctx *ctx)
 	return max_nr_accesses;
 }
 
+/*
+ * Build a snapshot of the ctx's targets and their region arrays for
+ * use by the ring drain loop.
+ *
+ * The two-pass walk over adaptive_targets is safe even though
+ * krealloc_array() may sleep: target list mutation is funneled
+ * through damon_call onto the kdamond itself, so no other thread
+ * can mutate the list while kdamond is running this function.
+ */
+static struct damon_target_lookup *damon_build_target_lookup(
+		struct damon_ctx *ctx, unsigned int *nr_targets_out)
+{
+	struct damon_target *t;
+	struct damon_target_lookup *tbl;
+	unsigned int nr_targets = 0, total_regions = 0, ti = 0, ri = 0;
+
+	damon_for_each_target(t, ctx) {
+		nr_targets++;
+		total_regions += damon_nr_regions(t);
+	}
+
+	/* Realloc lookups array if needed */
+	if (nr_targets > ctx->drain_snapshot.nr_lookups) {
+		tbl = krealloc_array(ctx->drain_snapshot.lookups,
+				nr_targets, sizeof(*tbl), GFP_KERNEL);
+		if (!tbl)
+			return NULL;
+		ctx->drain_snapshot.lookups = tbl;
+		ctx->drain_snapshot.nr_lookups = nr_targets;
+	}
+	tbl = ctx->drain_snapshot.lookups;
+
+	/* Realloc contiguous region_buf if needed */
+	if (total_regions > ctx->drain_snapshot.region_buf_cap) {
+		struct damon_region **buf;
+
+		buf = krealloc_array(ctx->drain_snapshot.region_buf,
+				total_regions, sizeof(*buf), GFP_KERNEL);
+		if (!buf)
+			return NULL;
+		ctx->drain_snapshot.region_buf = buf;
+		ctx->drain_snapshot.region_buf_cap = total_regions;
+	}
+
+	/* Fill lookup table, slicing region_buf across targets */
+	ri = 0;
+	damon_for_each_target(t, ctx) {
+		struct damon_region *r;
+
+		tbl[ti].regions = &ctx->drain_snapshot.region_buf[ri];
+		tbl[ti].nr_regions = damon_nr_regions(t);
+		damon_for_each_region(r, t)
+			ctx->drain_snapshot.region_buf[ri++] = r;
+		ti++;
+	}
+
+	*nr_targets_out = nr_targets;
+	return tbl;
+}
+
 static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
 {
 	int cpu;
-	struct damon_target *t;
+	struct damon_target_lookup *tbl;
+	unsigned int nr_targets = 0;
+	unsigned int i;
+
+	tbl = damon_build_target_lookup(ctx, &nr_targets);
+	if (!tbl) {
+		pr_warn_ratelimited(
+			"damon: target-lookup alloc failed; ring drain skipped this tick\n");
+		return kdamond_apply_zero_access_report(ctx);
+	}
 
 	for_each_cpu(cpu, &damon_rings_pending) {
 		struct damon_report_ring *ring =
@@ -3881,14 +3977,19 @@ static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
 		while (tail != head) {
 			struct damon_access_report *report =
 				&ring->entries[tail];
-
-			if (!time_before(report->report_jiffies,
+			if (time_before(report->report_jiffies,
 					jiffies - usecs_to_jiffies(
-						ctx->attrs.sample_interval))) {
-				damon_for_each_target(t, ctx)
-					kdamond_apply_access_report(
-							report, t, ctx);
+						ctx->attrs.sample_interval)))
+				goto next;
+			if (damon_sample_filter_out(report,
+					&ctx->sample_control))
+				goto next;
+			for (i = 0; i < nr_targets; i++) {
+				kdamond_apply_access_report(report,
+						tbl[i].regions,
+						tbl[i].nr_regions, ctx);
 			}
+next:
 			tail = (tail + 1) & DAMON_REPORT_RING_MASK;
 		}
 		WRITE_ONCE(ring->tail, tail);
-- 
2.43.0


