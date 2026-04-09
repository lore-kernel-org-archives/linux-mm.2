Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42298F31E22
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F6C6B008A; Thu,  9 Apr 2026 10:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7C936B0092; Thu,  9 Apr 2026 10:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91AD06B008A; Thu,  9 Apr 2026 10:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5766B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:22:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D4081A07F6
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:01 +0000 (UTC)
X-FDA: 84639231642.30.147E2B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8402214000B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:21:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IeXv2CNY;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775744519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5ZMexBUSdWKHXALMNO0i29+Ixar6JrM7d3Fs++hF0Y=;
	b=zw9K0A14lx8cbUg/Qkk6IGQG7q8w8BYvxq0yqAiKwCr8iRO95j+7IVLArj1db01AkL58XG
	CBi4YUoze650QEN2LHO3Uk+43UfjBm5Et+tkxquI6jgF8NllZdS4V7WmQhtT0ohtCWjOia
	sMEuSPFs7irrAY1T44td8mvnNZISQr8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775744519; a=rsa-sha256;
	cv=none;
	b=Us32hTmh5bJCYpJxezEzVkDLYK9DR66Mar41TP/+FzSbTxlwvJE630X+KSPfU62rk0aKTe
	oHwQKtZeVZXbC+g4fJ4jJHXrBg5NuirdbXR7jJcLkOmmOUnslfP4pRlv6l5GpkdqDCzmOP
	FSJYX9f6irEFq+MftrGgsb8EVvHnAW0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IeXv2CNY;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A976744559;
	Thu,  9 Apr 2026 14:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6303BC116C6;
	Thu,  9 Apr 2026 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775744518;
	bh=Ua5QdDPSrmF7qk60x9qhk5zPOg78lHW5pfwnkyXM7Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeXv2CNYnBymqV+fpSFzyT4/4/w06i1mXTdL6/tP0eLlH4uv/x7n048JoXB/vjcuI
	 ITigxTa1/MmtPmZsKoOC1vTjdOdldl7ZsVda5Hn3/ctFGcXK0NEouzcpsEyaD7jNHk
	 1WGULZOOj27jCjMcwIKCliaHrgcWbb+9FjkcWkxQgRofA1GEqjwyfc6hpTpEa0xR0B
	 uAlrr0A6aGFk5+B5qHMtZIieqT5dwrb6SX59wT7au5LCP81hXtinRnOogm5HzTzxFa
	 oLA9OnUs4XwCA+qPW39tkNtsaqaf7D/CY+ki1U6o1X0hN3D6QL/mC1W5cKnBAZVxWO
	 BYQRY+p6wmnQQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 03/11] mm/damon/core: introduce failed region quota charge ratio
Date: Thu,  9 Apr 2026 07:21:38 -0700
Message-ID: <20260409142148.60652-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409142148.60652-1-sj@kernel.org>
References: <20260409142148.60652-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 3z4axdiw7csk3conzywdyuykryg4ct6w
X-Rspamd-Queue-Id: 8402214000B
X-Rspam-User: 
X-HE-Tag: 1775744519-334404
X-HE-Meta: U2FsdGVkX18cVNE5NfMrHw94yU2wc3BZVARsGCiRxri1xwTeeLgrm7H7UQpuMnA3Gz2fzJHnj8iPilJTuOEcp7Bfglq5UqJ5Asiph7oaTVbN60w+cdSO77RlvOYr7Zursr1qRd4oNpyNT/CM8Ee1nNpvMkWA4JLnFvyXO2Tno5nFCZLbn+bxyUZ+LeO28hk8i83h1HvYf8k7NwBWP2zWW/DAY0M69rO885jbiYJumYvV+Qi+9/o+bGqvkUEYVm/aEU5UzjXhilrNg+dbZ6PgpQd5o1zyvYveY1+2iJZGcWf7+nWVjMcvy0egXVOlHuK3dvOG5mkojqJy99Zt39gtQT38Wc5fOaRBTNERqWfqKaCqlp8TY/uwUZKyTTqlR3lmKj2CKArUoo30+rkYaaxHwczf7a8Xyyu20nIlvul1DsaPStHHiAIPcePMArVMW3TH8xwP+Gjers2gjt+1yifVxIejinDYmOgM7fobByO0vs6nSAXsuGC+KSC2DKjVPL5qHoDXKud6X2que0E2BbP59shop+o/YUAaVKO3/ksCj3fs7xHECChdNhDewUQG9TKQDOQaIbxi6VkuuLtT30vLUvTHadR59wkZTMBq8pnOB/hW2CgY9PKBDtb80QsUIFqRarDqGnSS/9Ula8WnlYor3vQ07de2xe4OieG1SXUyD8V2O8hc41G193cNOrOzv4yEaWGHGch+BYPRVs2TOGK53pjytllbmZPMjm1wwexuYLq3+sZn7vAL3F9VOxHoiUWXX1E+RbRRyUnbVX881k62as3B1PdeMHIV4u2HIFLbJFcT0waKelCU8qLjEg3SEZ/zdqw8yQbkoMdbeDKiyRWt2ZJOYajXuZ+URsVjJMCRbfqvvndxG7de83Y4TmevyYFsxXdIIHN+TZT9MEmtMHpqQ/SBVtzM5DbOZ1izUlBThuIuKdFGBuXjQ4bKsBsvhU89ANpziIuUF/Uey8YrFBe
 kYouqyim
 iGkF6yF0eR3w1Dakobld8SOp4s3f0R5ydOfikjtfyp3Q8g5yic9bSP0hcYB0aD/6tSlEdgNGxT3zuO4U5ZLYXnA7fZDtMbNd6qtfFoD1kAr1Eq3dmY0/lTpvO6UU23h7UYrN3HqZVf60J0+JOiBv25VvbVDmLpsKdndARtYO4LJ5M1PZgZmCV2CgLOfvrYu2jtxiJpNZMhTEMv2mMfyZzJybYGFkJIAsp4aBzm+smkkPFUsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS quota is charged to all DAMOS action application attempted memory,
regardless of how much of the memory the action was successful and
failed.  This makes understanding quota behavior without DAMOS stat but
only with end level metrics (e.g., increased amount of free memory for
DAMOS_PAGEOUT action) difficult.  Also, charging action-failed memory
same as action-successful memory is somewhat unfair, as successful
action application will induce more overhead in most cases.

Introduce DAMON core API for setting the charge ratio for such
action-failed memory.  It allows API callers to specify the ratio in a
flexible way, by setting the numerator and the denominator.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  9 +++++++++
 mm/damon/core.c       | 21 ++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4b69f4553267d..9ab7331775b9e 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -233,6 +233,8 @@ enum damos_quota_goal_tuner {
  * @goals:		Head of quota tuning goals (&damos_quota_goal) list.
  * @goal_tuner:		Goal-based @esz tuning algorithm to use.
  * @esz:		Effective size quota in bytes.
+ * @fail_charge_num:	Failed regions charge rate numerator.
+ * @fail_charge_denom:	Failed regions charge rate denominator.
  *
  * @weight_sz:		Weight of the region's size for prioritization.
  * @weight_nr_accesses:	Weight of the region's nr_accesses for prioritization.
@@ -262,6 +264,10 @@ enum damos_quota_goal_tuner {
  *
  * The resulting effective size quota in bytes is set to @esz.
  *
+ * For DAMOS action applying failed amount of regions, charging those same to
+ * those that the action has successfully applied may be unfair.  For the
+ * reason, 'the size * @fail_charge_num / @fail_charge_denom' is charged.
+ *
  * For selecting regions within the quota, DAMON prioritizes current scheme's
  * target memory regions using the &struct damon_operations->get_scheme_score.
  * You could customize the prioritization logic by setting &weight_sz,
@@ -276,6 +282,9 @@ struct damos_quota {
 	enum damos_quota_goal_tuner goal_tuner;
 	unsigned long esz;
 
+	unsigned int fail_charge_num;
+	unsigned int fail_charge_denom;
+
 	unsigned int weight_sz;
 	unsigned int weight_nr_accesses;
 	unsigned int weight_age;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 98ee776d98cd0..9b9b124e867d5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -918,6 +918,8 @@ static int damos_commit_quota(struct damos_quota *dst, struct damos_quota *src)
 	if (err)
 		return err;
 	dst->goal_tuner = src->goal_tuner;
+	dst->fail_charge_num = src->fail_charge_num;
+	dst->fail_charge_denom = src->fail_charge_denom;
 	dst->weight_sz = src->weight_sz;
 	dst->weight_nr_accesses = src->weight_nr_accesses;
 	dst->weight_age = src->weight_age;
@@ -2042,6 +2044,23 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
 	mutex_unlock(&ctx->walk_control_lock);
 }
 
+static void damos_charge_quota(struct damos_quota *quota,
+		unsigned long sz_region, unsigned long sz_applied)
+{
+	/*
+	 * sz_applied could be bigger than sz_region, depending on ops
+	 * implementation of the action, e.g., damos_pa_pageout().  Charge only
+	 * the region size in the case.
+	 */
+	if (!quota->fail_charge_denom || sz_applied > sz_region)
+		quota->charged_sz += sz_region;
+	else
+		quota->charged_sz += sz_applied + mult_frac(
+				(sz_region - sz_applied),
+				quota->fail_charge_num,
+				quota->fail_charge_denom);
+}
+
 static bool damos_quota_is_full(struct damos_quota *quota,
 		unsigned long min_region_sz)
 {
@@ -2112,7 +2131,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		ktime_get_coarse_ts64(&end);
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
-		quota->charged_sz += sz;
+		damos_charge_quota(quota, sz, sz_applied);
 		if (damos_quota_is_full(quota, c->min_region_sz)) {
 			quota->charge_target_from = t;
 			quota->charge_addr_from = r->ar.end + 1;
-- 
2.47.3

