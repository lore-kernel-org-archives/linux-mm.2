Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8FE1F3ED5B
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24646B0093; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4016B0095; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11316B0096; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB7D16B0093
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 762031B8AC8
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:30 +0000 (UTC)
X-FDA: 84646860900.04.49B1952
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B7CDD40005
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n6jsKCKG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775926168; a=rsa-sha256;
	cv=none;
	b=3h5L6Ar4DZPizYqIFMNH8xZwyTDufzQXuq50MyX6Gc9Js6hR5bt8R6RbGwfF7OKuqCRei/
	X0tZ361+IbbIkduWYgJtDy79/WANIm2q6gJI5d0AqtyHNHwnhic6tsylT8+JKLvk0y1ZGL
	rPVSUTvPr3R3FG+jzcOMykr4VnjaS0s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n6jsKCKG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775926168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fFe4/RxrJg5fb0drY/88AadMU0zOuhOPDfpWq5SkSpI=;
	b=0vVyrXisF8Y0Yi8MehQI/aT3JCT1NmvPJjfnq0d9cHpzZGzcHkEfiLFfAFIKEi1eUKQsw3
	HfKKpYliCzvIrFMswEF0V/hnIm+zUlStDvF7bD7NJSpG3/O82KnJ9w40pFuCsiCpFIolnR
	aNXuIOweGT4Q+DJzZPl/qRKAIXuBLPM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D3B0D44511;
	Sat, 11 Apr 2026 16:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842A1C4CEF7;
	Sat, 11 Apr 2026 16:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775926167;
	bh=y2+7TlID8I4e4NckV6NUmS0r8+x6xhdPoBNX5myI8Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6jsKCKG2SV2ekH6vQxHLC/2fQkrK7HZusN2hPGKnzWlb5XpWxr1yVVC93SZfWHyA
	 IDU/QqHitziHS42AHzU6TSEsyurNR6P1nU/UPL4p12t9jzGrBUb4W2y7g4j1OS5AUq
	 WH21fTMMqi8kB+sgzGVPJAnCLQiZPjXlmBEADpQ4E3AQEhPLIkGW1gvv2f5FgrOJLH
	 CO7EDCAiV43v9ixvu27YoUKIb/ARJsHhuclRh6ljnUE0j0xTmdyKgEraLzwzAzfCw5
	 OQpuuS45gBKKzA2xf6NzQoXdMfoTn5N09t4umF49bNXH0++mlLPIx80Qid7r6ejdq7
	 mTzkyuKLj7INQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.1 03/11] mm/damon/core: introduce failed region quota charge ratio
Date: Sat, 11 Apr 2026 09:48:56 -0700
Message-ID: <20260411164908.77189-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411164908.77189-1-sj@kernel.org>
References: <20260411164908.77189-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4otqbu8b7wrez85tzxaf5nqtpjhoaku1
X-Rspamd-Queue-Id: B7CDD40005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775926168-785133
X-HE-Meta: U2FsdGVkX18KcIyQb0zf1WhwhuT2LGwusntjt2BZj98xBLL08XgMFBCx1bWkl2lSLFMEO+lQiDHYrWJvvciCvm/Uey5r3ccpAZ16HTGWP1rl2X8WOvmYd52+zvRw5+mKId6O5Q4A9H3lueWLKI63mHeOQx1cePvxbU1PVVrSg3qXfVluAM6dnvlr0sjA0jC7YePQDYdhsyG+i0Mg5a8T8QD7hp0pEQCymtwGs1AYCwVh36/30Q9SIYnZS6oZvYY+MfvmV55yg7O4JtKNsEn7OHtim7CX0eCATGsVQ17Bj+gMtlzmCERBUh2gTHGUX2chw0XVNTjcH5CLG79RP4QrbHW+muDnd43YzqGeKxnmgq+sW1ayRJ77hXzFuwchI2JvhucWSkvUUIvBUBbryix+VHm7ekW/rzAJP+PiLn6hIwcDNknn+CXbDHgQkMcWpvjfrcCeJPddbuUaMShnhaW10wuglA9WI4qEABQvQS4FIkDtaKhVewqLoHGfQgOdfRRF2S8OKfuMnwieh2rUb6GoibIs4QoYqBSA4bhgdF89f8Ruf39iJr6EiPYYNQaOmLcVdTMPGxxnbo6105U3pwYqjRRBG8Xgd1rytSDWqoVG+VP7h6hnHLK+3L75ZS2AoJX/TZ9oxgk+9+oZ5+VaKUeIDcWrhFf4Cu8UWhlT1YiuXZI35UeDkGMta/yw/SFWarpyBQpx4lTITAB+/E5DhmE3WU3y7aZfEUGqE4W7S1Wj2hGS4gvFZTWFQghgB0PTxVjci7v+1PueR2HNhJN7AT47CzNl+zVeFg3HCTUxI6Sf4CCoq3l7r4oRg0d0f4FZBQEt7uK9XYLHoeeXD3D/tIVOO+zLWeq2rc9pp2o82yTqTQ3yeDbW73zj+zhFg5ZipXvwgz7+1pnZ353K9Q/mPoS76KQX0/1aEhPRogamvLWISR7Ea/cMrx6m/HLGiMVmWJw8VrCBAWzy7hsTyOlFkJz
 GuwsV8pI
 Q/9eXW9DYMXPrefferMLakyJ5scxYSjAG4VnZhe2GcINHNlp0U4K/5eA5xt+4y7SNtf9u8yQ/65l4SmMd386KGW4JZLnyuwZcsyYyofCS/hb2LmCvR+vSYjv+iyZIuOLHA+HOYPjNswcKWotUEpYlGQGYrDxQqMzmm18LJQMPK339OZa0aQ/5WA4Oi76TWQO7hcT+CYLs/Jg7xjE3sdb0Uk/7s+ThMcpIHeK3FFh+APvFuAA=
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
index d3054af1d964f..5fb1dc585658b 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -235,6 +235,8 @@ enum damos_quota_goal_tuner {
  * @goals:		Head of quota tuning goals (&damos_quota_goal) list.
  * @goal_tuner:		Goal-based @esz tuning algorithm to use.
  * @esz:		Effective size quota in bytes.
+ * @fail_charge_num:	Failed regions charge rate numerator.
+ * @fail_charge_denom:	Failed regions charge rate denominator.
  *
  * @weight_sz:		Weight of the region's size for prioritization.
  * @weight_nr_accesses:	Weight of the region's nr_accesses for prioritization.
@@ -264,6 +266,10 @@ enum damos_quota_goal_tuner {
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
@@ -278,6 +284,9 @@ struct damos_quota {
 	enum damos_quota_goal_tuner goal_tuner;
 	unsigned long esz;
 
+	unsigned int fail_charge_num;
+	unsigned int fail_charge_denom;
+
 	unsigned int weight_sz;
 	unsigned int weight_nr_accesses;
 	unsigned int weight_age;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index fea1b0722c6bf..d82430fefcd46 100644
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

