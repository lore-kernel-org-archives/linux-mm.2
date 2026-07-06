Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F966C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AC776B00DD; Mon,  6 Jul 2026 10:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25CE26B00E0; Mon,  6 Jul 2026 10:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A1A6B00E2; Mon,  6 Jul 2026 10:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3AA26B00DD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7023D1C7D92
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:24 +0000 (UTC)
X-FDA: 84958559448.16.B8C1317
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id B26952000F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ei4293xT;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347562;
	b=cD1iIXHLs9z8Q3Qo1a9LXfCyBz99h0aAA46UrmHC1xhqGFJuAotaMVZ8Nexz+T2r3lrCvB
	c+Z0D/2a1ruLXFkNrbwbLAdPpo8nLmVeB2UJyG2kZeiokBmFoeQk5l235ehh/7CnfrNrih
	PC1D5o8Gh/rUv3dq+2YU3aHM6k/o7Nw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ei4293xT;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cv5oEs/jNtwylkKDIq4ZcvCWk/PMjMsIoTMy1Mh6PPg=;
	b=dR9t+afLfu7vjjdX/Nb9+lBjqWQevAeWxD8q2P6NeeurUDDTnS3H09q1KphhHYWHJ8YyJq
	Ne+Njee7zUz9upURhCXFeS7hjzLFSEnlcdQM8zLRDRkLU9G1XUptXpSbSbJv7uhIM2/h9v
	bnNuUn5QG53frQds97a58jp++azEFiw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D6E4B4336D;
	Mon,  6 Jul 2026 14:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947351F00AC4;
	Mon,  6 Jul 2026 14:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347561;
	bh=cv5oEs/jNtwylkKDIq4ZcvCWk/PMjMsIoTMy1Mh6PPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ei4293xTnK6S99aqrp8NkSCMvnf5eNiTow/907Jyk2MxHToCfPDYwP7wp2PnK/Peb
	 VSsHgD+T8/OVMmy0kEdnH7WruSv0fysW2kSzrFIYSRYgIZKLWMsj4fbZWp1zMvz7zP
	 2TmHLvjjgn9xdyTXyY355/kJ+L0xVqp8An0OxUKrvQotbp7+9Q8VHM41NKSxSpO8ZR
	 GtcYQitLRW5aA+iXFd9lK4+IA8MRJpSFA+xL84yvJmg0qzM7BoeLYkTNVqz7qgzJfc
	 Z2ik3nJ5dVRHqsHOU21/T0BYoq+lEH0F5kZsGeB5/XYApV+UYl4psWi+9tX+ffJllK
	 76oNZLVarnhPw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 04/16] mm/damon/core: ask apply_probe() to return max probe hits weighted sum
Date: Mon,  6 Jul 2026 07:18:58 -0700
Message-ID: <20260706141912.88445-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B26952000F
X-Stat-Signature: szje3ireoetg6ctuic47n19gdf1nxcnt
X-HE-Tag: 1783347562-224941
X-HE-Meta: U2FsdGVkX19NF5vHwBOh1AB2Q/cutGmCyEKEGEpnfMUmg64hYq7Ey9SoSHrXuyUXS5luJT8Z7Lq79JTp8wFJG/ychZuSi93TiV2GSjQtHWfnjgdfsCyX7JJlQQFCXKcc7xfiDlYL0nfBdXWA1LBoeuwxJrNYoUwYa+qLUL5vCxm1bBacHgNLzX0LEn0P2WAFMvD8IbzVdtfi0eW7LfnYAGX3UilcUiaxIWGJI2G+J8MblB3PdAwGvdhIIFQQn3ovkwWHuWeRKD7k3ROvGR5mUGALkUp36BOVlXk2GdkwJcn8kaKzayLzImme2XBJu9VRQj6S2nXeR73sZdcuCIDyL3S2w3ccy87soTQVT1ISVrvIOX8XRUPDoWNa33D+RBaEa6HMjRtwt7VaWCAvaHJaCj/VAamKkDDXZMuQ/ksynr+AGGp0haMNGNumAGT2loGoMDeRe5QiAnT6AaALqG/ca5N/LROp2VKN1TS+2ysN5JTw/w+Vg4HTTlQfv+/22q5Lj4cZLifcvwDHxSp7sWxgMRtanmSHfFpQuHZTHYGEPyE1EEaIb0yAMTXATg9Eg5Yxe0XkEIt2r8tV9y126UIVkhcmV1wHL3a/i+ZvibZ7w5gVudzX/snk0of8iQhXp1/6R+FZBZB7oupShrcG+0xfhLbqJEciOcblyeUlx9k+kojBt7XKEn4LLr3TEnvC5FBjPzMXHZMh5a962D4macz3oWTn2u1dnX5ZZCGqphO33zQ7Nq0Y7OyYldpOUIRieforYfKbLyKbvqCzC5TVi5oUeq86uiAMWwH3HXdA1C1gX0R3dClkN82j4GFL7hN3V53653RoR2lPnNHA54bbiSFwn3S3BllQ5tBCfkcvlAeUNJbiDgdD9QYOonrQg8pSwIBcPcfbaMK4RD0sMqfhyN+9v6VhOCO7FnH5SsvKgrBeB83ZdHBOx0PILP6thHVOEgUWO8jKIfaK4JHK+4bOm89
 GTHziFV+
 UdIuBGN3YRTu+2RVK1dnDf3Nf0ufRVvgAE82t1PL12FXD4qRPOxqz7NQsb5XAld7CRN6oozJys45VSPw5A6fZYncjus91/6jQ730A6NQndork72niXGsxTuDaGpZ7BLug6ilUiXHZ7zKs6ACPg5KZ6ErCg5PHCRkNOtdZ+6/g2RtDZ0lRQF1xzrwR1pxXy8yYZ5OGqJLDeUeIYSOMC8JuVcJ7ZtMsJ8kd2Ugy+q0VfH41GJtlphuEjaameGc6USSmZlDLbUN3rdBi3ikgaJhBlNGQYQ==
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
 include/linux/damon.h | 7 +++++--
 mm/damon/core.c       | 2 +-
 mm/damon/paddr.c      | 4 +++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4aa606f691f28..e1244a06ac7e4 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -648,7 +648,9 @@ enum damon_ops_id {
  * of its update.  The value will be used for regions adjustment threshold.
  * @apply_probes should apply the data attribute probes to each region and
  * accordingly update the probe hits counter of the region.  It should also
- * &set sampling_addr of each region if ``set_samples`` is true.
+ * &set sampling_addr of each region if ``set_samples`` is true.  It should
+ * also return maximum probe hits weighted sum of regions if
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
index 7c0184cb78a50..e42f512d87a11 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3675,7 +3675,7 @@ static int kdamond_fn(void *data)
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

