Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FE42C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EFBA6B0092; Thu,  9 Jul 2026 20:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BE846B0093; Thu,  9 Jul 2026 20:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC126B0095; Thu,  9 Jul 2026 20:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC2D76B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3951D8D284
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:02 +0000 (UTC)
X-FDA: 84970969524.18.8033920
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id AE932120008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlPeBOmP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHaXMaSFXun98IM1jBEMd0RWTSLzKTXiprMB4wea88g=;
	b=VKQfCj8onnpcPN3Kv+rPLDGv7Z96DbgmJ2ww05ouXD18t7ZykFe1KPYiL5UMLPZ+UJ8rhb
	oG+BoXYSGdUacuKG/J4/BkHuAwYgBk1mPTavyr2EK3vI6etvCzblIia/ACsmanUDBJ6Z58
	0IZgi1nweomET6vwW+FWPN+UfZ+TCCA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlPeBOmP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643040;
	b=HE0WAnbcxfrrjOncORmIFJOXcBiv7vuUiWW58udSQfQOnlXVgrQFEkvbJycQ717amBfMyW
	yDmxubla4+Uf/ob3YGjvughu7jtoPEvtaz6E/y//Rs3QIDonXeBq3DUCGAX+3v7PO2zb1P
	o8iLnbSkJlhqBAy6mbjYcwCpeOhLYCU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5771C61386;
	Fri, 10 Jul 2026 00:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE891F00A3D;
	Fri, 10 Jul 2026 00:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643040;
	bh=BHaXMaSFXun98IM1jBEMd0RWTSLzKTXiprMB4wea88g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlPeBOmP7VrmWxAsPH0AVL/fTuec/ABwje3Atq55LH8/QOgdA9eHYpQUneA1dDIEy
	 Vqh036et1+wffuKOl7wjVzEVUbB1kVEJBjLwH19R/V0gsXEygKsfUyldVSihx5iyE1
	 pdb8DnxelviLdiQ5lWnDPzwtrqtyzN2YKVcJXmZ6faFa/dd6fAyWQvcjxRUNDtOZZd
	 ME2O3Tabm3VCKJW6K7ASPJrTFFUcMGlBDqlzNbC3P3qE3fHrnUtt4g9xyH8L/Yn0s6
	 z6aI+/BcFgHc3Y+3pi/yPm5GgaYT+auyxcHxYW5UCqKXjKgqHj/g1R4iH6Zu6cp+sd
	 TeukYMSVTUOfg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 04/19] mm/damon/core: ask apply_probe() to return max probe hits weighted sum
Date: Thu,  9 Jul 2026 17:23:30 -0700
Message-ID: <20260710002349.111414-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AE932120008
X-Stat-Signature: 3xfjdpzyg1g6k55ihr6uqdo13h9kimhw
X-Rspam-User: 
X-HE-Tag: 1783643040-944422
X-HE-Meta: U2FsdGVkX18F+XFTL+KJG6kK0bo5bbRHdBAtwOttH7pPGDyY95u0sfF24JxD9zGobpAcqDOL7xe8QoNpIhL/+c7jOwvbJNQKym/B/CoJ3WBl0GhwzixXnm9XJvkNobngECFwlDximQyOq+63Ibx4RsszTbHEhQUMEnatG/HGuiJ4CyFg5T7bVndH1gMBw3pT97lipo1wAixISwqUjO08XGIPpTrcRsbY8d5rPII3dxmEfRE3LHJ86QjIQLzm+DydO+O/f2+6ZOegtb9STLHprGlriHfUQbOo08QVsYpSUGeLGIhj54aKxoPLCLiCmyFLEe4hy/ULEPezrnttWh4q0uKL208vlZ+cvnLSlVyTUM2q82Qz1fC7ggYxjnHyMcbK18ovrvmkeToNBYplzhXychVrQA+Av+2WysEsw/AEVTiwzq3bFYY2FVuIecMDPn01oZcW7sCF4UrVpP4hVa3Wv3Vv5Src36B2tfdWK/97wucQ0BUOfSn6ScbPuBlcOrQLOy/3fpHK7DPLVK6cAin+DRZMoBcuXTc3dRxdjfS2KY8n0jzJZbls6ShXnL5f0/TNpEe+qz75dL7uzFIqDc+dSznCefL5Yg1xF8WJjnmkXi3FpbNHD7eC2R3UGUeX9ldmhwZz62HhiYOd3arBeghETJdRPLVem9qO80nZAfkzAgnXGuWgSxiaupOgBTP1eSL+wUkK/1Khtqi3A2Vb6V7xGgg38K0ntPuQqbwyQ+J1A52vEGfjg9suhU0H5P8W37PI1wlUhD7mlk6THZ/P1kllIQcJH8EwbPGrY/CpsbkjdlFSg4cFpSlydKqP7DYWBdFFcQ+iNNz5rX7tpJw9HInl1TJxF8xh8mkP1wtG7OgNYWm4oIOY9Sih9m2jWySxBiY72R9yguGRVUlr83rWUYuQG4uSpF0jAb6P3QL8bhIpDJPPXWcu2gTyAr4DjQqgAyxWd12gEtdC45SWBUL/4Jb
 mA5N8+TD
 lTeUzNvOiJ+2MpZ7PU4zS8EzN8B1m0s3FTrZquzpuriMXOPz94Xdiv26gYYGj1G0faLix2snED1AoTlQYVQbpDv5DnC7/c7GakUhhaGubedE+SnGsOlh3K8U8Jkkt3bdfO6CCDY6V8oorgT0FdZTXuY4ZLq5uWBXhX/+NJ0OSKBWKADqEFQ3OfH0M2fj3oPOQlZBCkPYW+xJgvX95OKuRHVE7PBASzjASSlg1AheENXCaZSl2sX8esXwkIYQfufrSSQ6HovUUgiGXShMfPVWdbqPI8w==
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

