Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D6CCD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F24F86B008A; Thu, 21 May 2026 00:53:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5976B0092; Thu, 21 May 2026 00:53:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEBBB6B0093; Thu, 21 May 2026 00:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D24926B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:53:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A15D28DB51
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:53:02 +0000 (UTC)
X-FDA: 84790207404.20.B8605D5
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id F1E2D20005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:53:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nYn1BTHX;
	spf=pass (imf31.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779339181; a=rsa-sha256;
	cv=none;
	b=E/mAPb2UGv63YWfxGSpHT2+vkDl/y+LNBB2zYtHXvxToxRBlh4sKKMtVqM4qVFZ4FLzQQ7
	YOEvs73AtedF86e1hpFyu8vDbxsAMxoPGYK8ikY9nbXthaF6Xr8OXYWQQZSzQkQ7h7Val+
	kofgj5gE6456vTUMrYE1BAG3DcmJeLA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nYn1BTHX;
	spf=pass (imf31.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779339181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ihrvNaIXgM84SacKpF3s4jv+T6hZY9k+429hTF/wmxo=;
	b=J91qWweXGql3VSDFtaiaZC6fnp/BhtoULjEkByYMVW4xEbYCbmYqHs/vxTSEswr9PhIMdu
	krsEVPRqTefXFVdSZs0giZVGt5s+EdxymkY1t4Vj8pdgHA3hDEgE5ckYw7M6aH+CnsqqWV
	W2fmkctV+UzI0afAtURqYGEajRZ4zUA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779339179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ihrvNaIXgM84SacKpF3s4jv+T6hZY9k+429hTF/wmxo=;
	b=nYn1BTHXkkqEjDgxljj9bDe0WsfSvO90O7O5eLgE5ADHDmQIk0G1lF9ndyAgb4SBD+BF/0
	AWZSrY5kzkRHp1hpEAMdArAoK4YUnIbPi6iUYhVBqHh8mhGwflzQ3Ef9TwvzZumdHX62aM
	ZKTUcyi7PoolOGHSSVAvyCCdP+DFgtY=
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
Subject: [PATCH 1/2] mm/damon/core: split age==0 regions when nr_regions exceeds max/2
Date: Thu, 21 May 2026 12:52:23 +0800
Message-ID: <20260521045236.115749-2-jiayuan.chen@linux.dev>
In-Reply-To: <20260521045236.115749-1-jiayuan.chen@linux.dev>
References: <20260521045236.115749-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: F1E2D20005
X-Rspamd-Server: rspam03
X-Stat-Signature: kzbzjwqj57s9aubo3q6xdnsk6js5e358
X-HE-Tag: 1779339180-636891
X-HE-Meta: U2FsdGVkX19prPE3od6oLpx0QgUyxEs8CkItTXeIRbV+Qzl1U5U77DCUnoz4PmipVmuaKHKDFsrkFCHZ/KBwjRizfFytGilb5odcEa9/meWeYAcTv+aFN+x8KlLC5jOKFICkiyprPda05GCJJ7XxsMYt6M3WajbStvMkpOQQ2yy2vA10jZioM0wZsXGXsAzeUHAYixRyKxG+BITiAaOpQajxLSE2pqalyOG+IbQtnkolNebXVHkL9kcnb326AhH+v4R1xqq3HPh4tEiCWqhO2S1EX/+gs/KTs6iPvEL8ejf48nf1GlPE9LosM094s2EIP6JC3w/oAXesnKHoSTPG80rwOY1K77Ka/QfIsNto81O2F2Z71Lpw7UJMxo8THbgQhx9rzwqhpVan8Y1sOeiFxeCcgQxqACkuwQqzb7yizpZscWOBs/Jh1WErBq+icM1QvTSxxmWtAMizBeaNR5tCEfyRaUcdPIJdEvxVbL/viCC+z1a0Ri1GXq9B9Wz0r6nzAL5Qx3tIV6gFlqON4KEy/1WwCRfnV6Ax/BX4fWz8b2klDuIx81LCniedwiB/bMnxcCsjkkvJDlSKvW5mDi+zkIMA2cl+82fsuRm95gRCq9W5zkNuRyct4Nilyjn0QV4KstYfVUnLB/r0euUkXH2mrI96IjH74G6IRJE8s2nt+1/KxATFKZBEsN/RjMIH4qZ7YVKEGRhbejkTafBS5pY7rRzv3xPUEXVYsR6vGB4XI/OrdJawSb02nkBg65ad+78oB54wHpzpj97GFrCqipB55/wDB44K7DRQiaVG1Bpe4gEtpV8+v4Wys/ZyI9gmSS43/IJjznvungROU6+SCXH+BTgAP4kQeE6nho7uCXqCFBVRmYQ6rFFEr6DjlnMiJlE7OooOUAjcKaprgsCEe8QatyR1lQpH3l76O5opAvpaA+hXd2KqM7CMAjS3PRR0lFHH7PZLwicOglEhLgZgqX5
 VzUQO0wh
 ijNtrmzieZ3LZvaRhTGQPZMR9RikOOBOfNYU+SuhoZx1AMxrJ4sNyk6Fhuj79uvqcgIBYYF626rz+cWf7UgAcd8soVtWynDxum3jR1/DXgVwKzArzHJqxiktcRRm3M5R9jcpjRhapCit+oiar0p3FQ33ksh3bUXWRFj0aWDzbOA1hBJgbBCpqq4eOD6uOtPtovJOxH3odr9+NkEovZpU7WODcebc/NZTjaa3RWWXfRVNH+oWxAR6sFFJEoERmGlu4g+iF4PCMxxfp+bG3MDH951umV15VJjCbjyWuBTXhlRmuKmg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

kdamond_split_regions() returns early when nr_regions is above
max_nr_regions / 2, leaving internal access variation inside a large
region undetected.

Such a layout is common with damon-paddr on hugepage workloads or
damon-vaddr on processes with a large anonymous mmap.

For example, with max_nr_regions == 1500, a target may end up with
799 small alternating-temperature regions plus one large region that
absorbed a uniformly-accessed range during an earlier merge:

H:hot
C:cold

      r1     r2     r3                 r800
    HHHHHH|CCCCCC|HHHHHH|...|HHHHHH..........................|

    nr_regions = 800  >  max_nr_regions / 2 = 750

If a cold subarea later emerges inside r800:

      r1     r2     r3                 r800
    HHHHHH|CCCCCC|HHHHHH|...|HHHHHH........CCCCCC.............|

The small regions cannot merge with each other (different access
counts), so the budget stays full.  r800 cannot be split because
nr_regions > max_nr_regions / 2 causes an early return.  The cold
subarea is never discovered.

Split regions whose access pattern has just changed (age == 0) on
this path, up to the remaining budget against max_nr_regions.  An
unnecessary split is reverted by the next kdamond_merge_regions().

Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/damon/core.c | 68 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 56 insertions(+), 12 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6b8af7f956b7..442a6c323aeb 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3452,37 +3452,81 @@ static void damon_split_regions_of(struct damon_ctx *ctx,
 }
 
 /*
- * Split every target region into randomly-sized small regions
+ * Split each region whose access pattern has just changed (age == 0)
+ * into two, until @budget new regions have been produced or no eligible
+ * region remains.
+ */
+static void damon_split_zero_age_regions(struct damon_ctx *ctx,
+					 unsigned long budget)
+{
+	struct damon_target *t;
+	struct damon_region *r, *next;
+
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region_safe(r, next, t) {
+			unsigned long sz_region, sz_sub;
+
+			if (!budget)
+				return;
+			if (r->age != 0)
+				continue;
+			sz_region = damon_sz_region(r);
+			if (sz_region < 2 * ctx->min_region_sz)
+				continue;
+
+			sz_sub = ALIGN_DOWN(damon_rand(ctx, 1, 10) *
+					sz_region / 10, ctx->min_region_sz);
+			/* Do not allow blank region */
+			if (sz_sub == 0 || sz_sub >= sz_region)
+				continue;
+
+			damon_split_region_at(t, r, sz_sub);
+			budget--;
+		}
+	}
+}
+
+/*
+ * Split target regions to refine the monitoring resolution under
+ * dynamically changing access patterns.
  *
- * This function splits every target region into random-sized small regions if
- * current total number of the regions is equal or smaller than half of the
- * user-specified maximum number of regions.  This is for maximizing the
- * monitoring accuracy under the dynamically changeable access patterns.  If a
- * split was unnecessarily made, later 'kdamond_merge_regions()' will revert
- * it.
+ * When the total region count leaves room for a blanket doubling
+ * (nr_regions <= max_nr_regions / 2), every region is randomly split.
+ * Otherwise, only regions whose access pattern has just changed
+ * (age == 0) are split, up to the remaining budget against
+ * max_nr_regions.
+ *
+ * Unnecessary splits are reverted by a later kdamond_merge_regions().
  */
 static void kdamond_split_regions(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
-	unsigned int nr_regions = 0;
-	static unsigned int last_nr_regions;
+	unsigned long nr_regions = 0;
+	unsigned long max_nr_regions = ctx->attrs.max_nr_regions;
+	static unsigned long last_nr_regions;
 	int nr_subregions = 2;
 
 	damon_for_each_target(t, ctx)
 		nr_regions += damon_nr_regions(t);
 
-	if (nr_regions > ctx->attrs.max_nr_regions / 2)
-		return;
+	if (nr_regions >= max_nr_regions)
+		goto done;
+
+	if (nr_regions > max_nr_regions / 2) {
+		damon_split_zero_age_regions(ctx, max_nr_regions - nr_regions);
+		goto done;
+	}
 
 	/* Maybe the middle of the region has different access frequency */
 	if (last_nr_regions == nr_regions &&
-			nr_regions < ctx->attrs.max_nr_regions / 3)
+			nr_regions < max_nr_regions / 3)
 		nr_subregions = 3;
 
 	damon_for_each_target(t, ctx)
 		damon_split_regions_of(ctx, t, nr_subregions,
 				       ctx->min_region_sz);
 
+done:
 	last_nr_regions = nr_regions;
 }
 
-- 
2.43.0


