Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3883C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB25A6B008A; Thu,  9 Jul 2026 20:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63456B0092; Thu,  9 Jul 2026 20:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA00C6B0093; Thu,  9 Jul 2026 20:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB096B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EAD988D25E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:01 +0000 (UTC)
X-FDA: 84970969482.04.DF7C518
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4B107120007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e8yqmZjT;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643040;
	b=VtHGPBeyzOlTCNaS9uNFy0eCYiSKyXBMm5ic2WVTww1UueHeArfKkEc2x8w1CCYZkrWMRX
	OEZdQisTqpdKA7o0JMutqyvWUBGu/dXF4jrEpXdqn91aKypxLLJvv06jSbIikecVGpFtYs
	uuaAy0SIniZZWFtA6tEbiMU7femVY0g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e8yqmZjT;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQG5oz4wU5m7lLv6nGv8jRYxqbEgbwiFogSXia05QXQ=;
	b=MnzSExSL2ipB8Xf8HbdNfgTt3m82NmCXvHOzcYLNrf28td/V8jVoiwKbgbd/8sMgoQC90k
	o4/pxlcvtpwNS2sHTHGydt05XQ51nKncdaA5vexJwmBaXnHljkn6rLvgqbG5ny3gvSr2of
	m3h3IkN56PxjUJPy3Y7FDDeSWaob4dA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4238E43FE9;
	Fri, 10 Jul 2026 00:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D574D1F00A3A;
	Fri, 10 Jul 2026 00:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643039;
	bh=xQG5oz4wU5m7lLv6nGv8jRYxqbEgbwiFogSXia05QXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e8yqmZjTc50JUEQg8thjVPpN+oNdUpYfsEzoLhQSc5tmlvCGwJlHDexGc7QhVCxhF
	 Xx7Zc40GV12X1bzDBVqPf6HuF2BF5M3hPYxTp04xuyvtR1FIZrktVgbtV9MmX/ozai
	 ERZdpSUqZbgYVAZ5SwNBHGtY65gjgIsQN8WLKSOfJXbfJPgfzAZ5pIJt9jH8LfliIM
	 OIW6l1CrkN1BhG/wKSDv9bWWrTqkrRUQXP+zM7nLcqh8YtlmIFjrC7LD/mOVvJx/JC
	 RfRaKUOT8qQqM6Y+WBaVv69t6vaJ99GT2M9Zaojxma+/ThXHxEs6gHuslrXcKL/9Or
	 RJjmvPGGFqmfg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 02/19] mm/damon/core: ask apply_probes() ops callback to set sampling address
Date: Thu,  9 Jul 2026 17:23:28 -0700
Message-ID: <20260710002349.111414-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4B107120007
X-Stat-Signature: 4ap5hmm96kqtou17fum49okigg3h9i77
X-HE-Tag: 1783643040-547218
X-HE-Meta: U2FsdGVkX1+4/bXrpIOPHpf5HWB8Wv/OXOfYkpIBMyXrEiYMp5MoiNKAt2TTMos7mTI7/vzYDnBkUvu0lUxZ0dZhjvKOgoh8nh8LQxB7p4p5OPCZle0I4jUiOa2FLReXtFp2qo2mjfRhQdAlQP59BR4dd0z9ba0nl/7FbnmFcYc82FjlF3ANVa2x5yP7P/teoml0WDm3XjAji08GO5CarcOwpTm/pyC26o5Scy7gnX0eIpxdApNwq80dHHawfPT/uucpuiSlI5sKPGDUvTUfjvER0pKjacEZaJcZjg5136kK1bPYr6F4LbrclKLQI+NfSO4eWMnJGWjyF6JJF9trIE9VP5XSGBpsHfNM/75xJK1FmEYBnDbIt0c9gDemD3vONV5KRqp+7c7W6Oqd/hKz1aCkYQfwKG1ZBSfzIf+9IqIgsjKC5+IoP//3OfEyTN88Go8DAs5d4PkRKkkcbju0KGVoxZvkaFE0iaFvI8QQQ4VIvXDEtTrFTLeFMxDZNNfFHITR3IdcVUs/PK/UpZ/fc4/5LqzDhPOdyD6B74iOOaHJvauonA6tHCWX0bfCWPyBrACvTFDyqi3JJ3Uk1sgddZ3Vj3kLj3d70lF+bQUY5jp0DhtHR74wZsNYyNrc9oSOt6TkQHSED5TeEMOC06Lwn+5RacBEWu2O3S49k/iR05sVAQ/CDWtK40jjEYu8BeGGUZyq2/RcKyllOM/obkPxb7eD8oz5CqvxI7nj4sHgp25TeEo8CqROk0kr0ZZPlU03+VZ2rB42OtLKCqtcl7a0Sd+/ZxV6SQhUeGGL2sQPAmm6+1qMNVeUl13A7UQgofM8mBsS5REglMKZF9HNeO3vBWjGD2UYTJCGE0SFVt10CoAlV8y0e9O6LKR2fULnbtVEp5ry0HIS//uPvYxmR0Z+VbAbfFtBLxCapMqow5kJniGJ12neTe+/T7e4w0LPn3T1Fdj8zu7tRgcoSptrLzG
 9fv2w+Uv
 5kcpJW63Oa1BJlpiV13v8XxkO3v9wbXL4xsQdoe3cgom9frmFlnjqjTJoCtxpUMQh4yEnSrNcXR3LrO+gYGfaYQN4ygA3t/ttgNBMrayN0T0fiJ/KyevKS9FGmgjGHJzsCijmv+VEyPkdnvQ9KMkLrDlJjOXTcBF+0wEIb+3x0lZHZUgWjKXRxuNzS+CclXby12G18BPjkuoLj4GwlDE6qRvEb2eoGeRAwM9l05zOAWH6F8XgCi1Qfp0/T1+ELy6Xfn/QE93afGXraiGQXTk+rs3jsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

prepare_access_checks() DAMON ops callback sets the monitoring sampling
address per region.  In future, DAMON will be able to call only
apply_probes().  In this case, applyy_probes() may need to do the
sampling address setup, to minimize unnecessary regions iteration.
Update the protocol for the request.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 5 +++--
 mm/damon/core.c       | 2 +-
 mm/damon/paddr.c      | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d8251c83e6e55..aee28b05acc6c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -647,7 +647,8 @@ enum damon_ops_id {
  * It should also return max number of observed accesses that made as a result
  * of its update.  The value will be used for regions adjustment threshold.
  * @apply_probes should apply the data attribute probes to each region and
- * accordingly update the probe hits counter of the region.
+ * accordingly update the probe hits counter of the region.  It should also
+ * set &damon_region->sampling_addr of each region if ``set_samples`` is true.
  * @get_scheme_score should return the priority score of a region for a scheme
  * as an integer in [0, &DAMOS_MAX_SCORE].
  * @apply_scheme is called from @kdamond when a region for user provided
@@ -665,7 +666,7 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
-	void (*apply_probes)(struct damon_ctx *context);
+	void (*apply_probes)(struct damon_ctx *context, bool set_samples);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 327398fa4ee56..9fbea6204520b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3692,7 +3692,7 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx);
+			ctx->ops.apply_probes(ctx, false);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 6172464981730..b13bf7c6eade3 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -166,7 +166,7 @@ static bool damon_pa_filter_pass(phys_addr_t pa, struct folio *folio,
 	return pass;
 }
 
-static void damon_pa_apply_probes(struct damon_ctx *ctx)
+static void damon_pa_apply_probes(struct damon_ctx *ctx, bool set_samples)
 {
 	struct damon_target *t;
 	struct damon_region *r;
-- 
2.47.3

