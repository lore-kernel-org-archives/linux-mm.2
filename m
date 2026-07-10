Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52DE6C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61276B008C; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8326B0098; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2FD6B008C; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6C36B0095
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDDCE8E75A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:03 +0000 (UTC)
X-FDA: 84972993126.18.7888496
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 671EC2000F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eHxRw0gb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHaXMaSFXun98IM1jBEMd0RWTSLzKTXiprMB4wea88g=;
	b=IrKazTrMTxp7EOkZpdZguZrgqfYrUaJVybIA+8x1yj7hQtEEJLFF62+Xl+wglD0IHjustR
	/HnazUmh3nI6TlP3pCS0ySHkBOO7l2zTs9oFXU5Qa3+cjAF/gPveQE8kPP0rpoflcShMCX
	0HTmhe2+bxI/wocd+wDok/DEM0IlOoY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eHxRw0gb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691222;
	b=bomt0JKI2Godor7N4q06pTJ4eYBEQ14K1CRAuUECCaZNhGVmSkDAKi3pBtQ4nda92k8Oct
	picfj9Rb+XDlLFzF7BImHcCCe9Xj9+NbNO9vK5HYgU+/6X8ANNCpEAv2bJ5oeGKSBJK4nm
	rZcj6FOajfAqM/JCdv8/If81sPSpuS4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0984F60051;
	Fri, 10 Jul 2026 13:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D9C1F00A3D;
	Fri, 10 Jul 2026 13:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691221;
	bh=BHaXMaSFXun98IM1jBEMd0RWTSLzKTXiprMB4wea88g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eHxRw0gbEz2oo8IGMbq4HFpYn3QULBg5mOP1bP43qWUDI2fVVLfdMjpi+lCV4g/ph
	 V5F3g2pFhkAp3EwoLJMLJGxGpwXPYXFWm73RN1g3zMN9tmZLo3CI5mx2Yr4Lt2sWg2
	 z0M5wwDydnNkQtByBMGjdbCfuaQpte/h3ba38jYNHmOJZu1dyEI63y1svbm7zYsv8u
	 2n6JznenesYig83C1IedBKRsTzu3ZhJKS40Be4hdalr9vayM3DG5yen7nX0/94sGdX
	 eosUQWPioGHR9mjN8wBfwNn70Cxnc+CW8EQslecLxrv4ZVTL9sgAqKG7xu5tWIEMeT
	 jNTmxajOnKkWQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/19] mm/damon/core: ask apply_probe() to return max probe hits weighted sum
Date: Fri, 10 Jul 2026 06:46:33 -0700
Message-ID: <20260710134651.18084-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 671EC2000F
X-Stat-Signature: nhfndwtxxynsma44ira5bkr4mejc5mdo
X-Rspam-User: 
X-HE-Tag: 1783691222-644591
X-HE-Meta: U2FsdGVkX18ypwRP+HanQ2ARq5NzO7D9HzvqRWbVp587udJmkLa6Cc/sF138QBBl3kuJuitfAvgAXkbsJ/Lb+LIZL08tYOSHO2iV3V8ev7FGu3VZKmbCQeT680RdCtNlJ+6AaJXh0hmiXqX0VhDOaBhErUv53dCoGgwrk0adJOnWnePPNtxuLv1tB8rrGwzTt8QlMKYGduLzxhbetTXM+gypBtmaVWIFwl1h6G9v/kE8NcdyXMHXfZcbn4LDYVStKKXSRmmCkah6ADvW70ydd20D1fz1WRcskFBXnCS3378VRKfH27ISn4R2llpglO1SYvm+A/3ynHK1XBNJ6Cp2nym0drfBwnPHYiT0uaoziq/p1ycTk1zNlWs2zVbJkigtcBr9A7MmpJ0M679nMyj6RK9v5CLnveNYMfy9eHr0zUiFoJkaPkfOaGDWMtBZzk00jgRDE+aMG16A9l2XUb8z2i38NSnr969+kXjWlW0F1Dcu5/g/d1ZKlKcJpIQr4EtSc+B8cHPS2N81oDkjCcowKSwpvF1Ys6vgBMwac3DryrMM0skezu8kvvdhxpXCFsKHPton2BzdvYHYHJxuiLXFU81qPhMaUnQdPQeoznoFzV/mGGBYyjJ7Wmsbxe0HudKHhH9dkkgKxeNWx0QQtNExnkCwlVIXQx6p/ChtHaOfNO2XH6bus1VomTl5JRM9GweeZ1vw7to4HqfLs8Un64W9a7cYSQ7Z40rtsqG1xQjfwjeoZJJJt1x09SciChQHSol/FaYscWzyZCATNYSFKOYQQUl7svG+ymJxpamlwEKC2fGuS6EzryVbQ1k1dUuWi80m7vIOweFEE3YgEoxXof6paacp18JldWvxOpqtgeYaVmt6V58+fuS+Vi3wiqFX8YDbCjNj/F6riKpYakQx9dAQrlB/9fAfwvoljuF5wY5JqSr+kQLnhdE13FgRFHFtShguSCtQUDubNP6lPs2JR76
 rKTB72DJ
 9LJvzlRltRYpcBBM9rddkfqusR92UVqaVuergTDrq4CPDBrcPjWf3KOycg8gH0s33vk6wt3xlG9egi8sQl0fDSBxDCFlwpMYkd9YZvCw1cn6YEY0PeHkHRQ+wqR6aZaO3sMsW2wCygJdUdqScKe9gHFLVypao+1S3ft5wa1myp1MKENpuZne1s8U/+X+oTdp3SvJidnUqETZSYum3ARDRhRLOJCwZnHmxVskp9CXUZ+qbN4l4myw6ib23rJgBPr5Z7IwDZqRXCUyrcZeMcz+6GI7jXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_accesses() DAMON ops callback returns the maximum nr_accesses of
regions.  DAMON core uses it to calculate a reasonable region merge
threshold.  The core will need to adjust regions for not nr_accesses but
probe hits weighted sum in future.  For that, the core needs to know the
maximum weighted sum of the regions.  Update the protocol for the task.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 5 ++++-
 mm/damon/core.c       | 2 +-
 mm/damon/paddr.c      | 4 +++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index aee28b05acc6c..e7acd8e610a64 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -649,6 +649,8 @@ enum damon_ops_id {
  * @apply_probes should apply the data attribute probes to each region and
  * accordingly update the probe hits counter of the region.  It should also
  * set &damon_region->sampling_addr of each region if ``set_samples`` is true.
+ * It should also return maximum probe hits weighted sum of regions if
+ * ``return_max_wsum`` is true.
  * @get_scheme_score should return the priority score of a region for a scheme
  * as an integer in [0, &DAMOS_MAX_SCORE].
  * @apply_scheme is called from @kdamond when a region for user provided
@@ -666,7 +668,8 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
-	void (*apply_probes)(struct damon_ctx *context, bool set_samples);
+	unsigned int (*apply_probes)(struct damon_ctx *context,
+			bool set_samples, bool return_max_wsum);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9fbea6204520b..9f6cdd810bd8a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3692,7 +3692,7 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx, false);
+			ctx->ops.apply_probes(ctx, false, false);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index ff4fcca949660..3eba3564a31fc 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -166,7 +166,8 @@ static bool damon_pa_filter_pass(phys_addr_t pa, struct folio *folio,
 	return pass;
 }
 
-static void damon_pa_apply_probes(struct damon_ctx *ctx, bool set_samples)
+static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
+		bool set_samples, bool return_max_wsum)
 {
 	struct damon_target *t;
 	struct damon_region *r;
@@ -194,6 +195,7 @@ static void damon_pa_apply_probes(struct damon_ctx *ctx, bool set_samples)
 				folio_put(folio);
 		}
 	}
+	return 0;
 }
 
 /*
-- 
2.47.3

