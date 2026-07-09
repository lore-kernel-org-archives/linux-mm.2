Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DBC7C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE94F6B0093; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42E26B0099; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76B86B0093; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EBBF6B0098
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA499401D1
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:07 +0000 (UTC)
X-FDA: 84969412374.02.2C29017
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1C36C1C0002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wf8IEfuR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAUgZZ3SWrIGgoijnllQjqFZihl0bkx/8MfT/CIerVU=;
	b=2fhWlUD9CTHmAt2f0twsWav0Nhcf7v0dV7PJzpk7odUDQzXMRwpNHOP/+7rxkeNCSa2EHj
	mjdC+dHBKtoVQOCYBmCRZnegePEXz8aeLV8sGR0wCvaBkG/SA3KbmCMcQEORIfB6miadcs
	RbVIJtEGeF/aW/6D3pst1IIYKsvZovM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wf8IEfuR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605966;
	b=513Xs4VQwdExTFlhVX0U0jahlX3OufIw2NztHyXaIR9T48jNmSk/0TvaZEaN+Z892xvzYJ
	n4h+yBCgjnwrwExndiv8dkO1QbT6ZS4i6MrlPro/rVz3/Bc91UgrIWCGJgk77udR9IQ3mq
	7e201TSIPgFFpkNYbSnUg/Cej/B8zUE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 666CF42D89;
	Thu,  9 Jul 2026 14:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245371F00A3F;
	Thu,  9 Jul 2026 14:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605965;
	bh=EAUgZZ3SWrIGgoijnllQjqFZihl0bkx/8MfT/CIerVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wf8IEfuRhf2ecTkelQp+n69tNYlsE6nuD8zt/Sr6MTHtE3waC0OwlYp4vY9wkeaB+
	 DxI9LI/915IRsqV/LB6AI43V9aRGkRFO3KVJ7gKn3jdWVBDU+DX7GYKfMsIz8DYI5w
	 bDhyNF89KjWPaUNQbVBDy4+9V3xO9VPwfXFvPSVUk/Lxw0KIKYxh/lo6p0wUzYHj2w
	 ZiweLpHhIofQ20dqaeo6crq00ij/Qh8kJ4CzyxbtVDkPnFqrCvPl6Du5YBFoIL/fGt
	 pvLss5te/FMIxKh6u/Cinqrdvp4Gm8LNFVRKEJiqVd1FZSLpAIuj1/mVYaB250U4z2
	 Ppn5LxE2VYKsA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 04/19] mm/damon/core: ask apply_probe() to return max probe hits weighted sum
Date: Thu,  9 Jul 2026 07:05:42 -0700
Message-ID: <20260709140600.90950-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1C36C1C0002
X-Stat-Signature: 7tmyerwaduyzywy6sxn3rjpx8bxghbqm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783605965-902631
X-HE-Meta: U2FsdGVkX1/fXRof9TcMvXHbQzJ+1m5OI/Ja/BW6FuazH96MzV3M73WnwJIh+f7JpSfRV0Rgfk/xS5JaiuxEZU/L7zbXEfW66dLahYcKYYnJDbBszjl2z4T3uqc53UZCLqv2n8+sn3l2m9v7p2OyGmeZxtLENNXeQQWE9jmMuQpcCb3CvgUuRrAqu63jJF4v1B9qsqDQd+rt8YyKJfXcK149PaSjNAPjcdF60tlDeyggF+Xk+zvE7GZYtpnfoxsvq9ChHfPVBhiifsmxvQmLNChGDdoJaOYGOtrUNjm/AYNXRjmiIcA/LZPmXe3V6SkDA8QOcKUPLM5i4eh4Ryt8r31N2wF7f4APDUBDlJxhgbauWwrP+LkzzMfarz5osUu/ODwGwTasbJRZaJ+LorS+iW78ypuj7KG/dJrmsh02rUjmrUPKbDY5XGenFauZ4/83Q6a4JDLnMhbpyuVO1cwHG9SsF9tSJqIU07eP985t7cGG8ostWfsww+svmqfhkXmKwiNAwQwfbe1/V66lp/pBQ7hPJ8MEIQHQKn43zN37yjooHw3+9ZYM8q/IF8FuNk9cDI3Pxltzm5HyyILtlVfCF8WlAH58DP5uPnKvbByh21UHTcDQevzCDPpZjkM24UTR+j8Icxo4PzJJ4uG8sYF7LjEC9PhQzJytOXXwCMPI9Tokx0cBxpnVI8D1n6ggfMCCnvrx1c3GkwOUJ5dK6uxLGzbWJ2xeHlIcncFO4Bm0nV+30h/EreX9BWoNhMkRqlV8zr99l0R2jSqJydXHKFi/29Dbs1LHaqRgfWuXhg3Fajz1EHKa0J2w8QHmzV8rzcn2QmDGXzE5EUSaf4V0BmeFQ4eeYN6NqqfWvnLPdLF2DGZQT49mB7w6XYKBbh7q1bxzPqM+fAyGW0SJ+D0bDp4nyoZ4M/7/7Tqb1rYysYWXsWAPwkTD77aZ3EP6hj0mjEinKJzyH1i0YQV76nY14ak
 FrgzMElR
 xeYelj38qYulAa79eIu7i2eE9uDsit6xUOAh0jAksCe4VHTsK4IHrNCbYDWf0JB9gowDkt7WtQkP/1ndvorIHVpNGOasKewGE/8RfZr6dfW1jiCUAPAwxMB4aS4gLtu11DTFTzDdugYlasSVCSIS3bIapk582ZRYaubHnMYOqcPzDt+PephPVIFTFurUjKlSgZ+5iAVXsdfe1mBQhKp0tQ4vLseIBcdCJs5xhfOSrkv4SdMrq/zKWpSsj8ujX9Qhfhpuclppiwl3hi2obAHYSdnJoYA==
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
index 3c2a4d673bf62..4e1845ce83870 100644
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

