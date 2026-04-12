Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05A3CE937E9
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A64F6B0092; Sun, 12 Apr 2026 12:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02EC56B0095; Sun, 12 Apr 2026 12:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC53E6B0098; Sun, 12 Apr 2026 12:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B0C416B0092
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:20:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B2FDC36D2
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:05 +0000 (UTC)
X-FDA: 84650415570.21.78726B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AB48C40002
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FO14dbmL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776010803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2P8fv+TiIHsRwxYhhIPAni9KIHLJCogSsbG2zUdfP/Y=;
	b=fDWDn5CZ1XprERvBlnxXNXuHm0UrYOktNqiETc3NSTl5hmP+rzn4wOVXuMTEFwNlEpXVvT
	CBjDXDaI2l38y1THJMB2VJA0Q5tTovGPMqjH9S+l2ZvGFuTSpNRWi3+bFqEBF65xCpjTbl
	QFQKvaYehBpqHSCgeNXU6knTkN5ewFU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776010803; a=rsa-sha256;
	cv=none;
	b=mUFdfaXGa1qtI7ZpepFyVvfcshCAN/okLz8S9CckWqWNP/dTZLegZQsk+zaWuoBgfKzXWq
	3lrt0sj0MTe37BPDZAM9OtZp6zXaNEBd61vHMul1sCqlqEik9EFFJNT+Ur7XIxm702CCRe
	oQgS9rHulAo7+kWjS5jtYegCnpXqaGA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FO14dbmL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D7C4E445A0;
	Sun, 12 Apr 2026 16:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915C9C2BCB1;
	Sun, 12 Apr 2026 16:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776010802;
	bh=lVvvJyXXUULYKYNrOl6GeL91WhrIsl7oASNCEnlmdDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FO14dbmLsSeIyks0o1fyBOx0o6ED0i+x/tg7Dv/bLqHGRpVQXmHnigqT572YdYGqR
	 u/jsRXM3ZcRziNURVJb4yzmEcXAELby6RsT8/y0f/8lBYJLmGrObZVp5fLxrOduOKk
	 c1dWf317Foejk2icmKjgb0BBB6iNZWPuJV9SagzZhDhZ3NjQ94tdZcLp9/vLq6M/A5
	 EdzWESLSBa3e5kZgcHLsFdcjmUFM++iPhHBGiW+kmEUh3M/Wuc/0dRB//qU5cssSuP
	 4L6ZsbOcXBjwN44Oi4tmkXs+EINs2mn3K91o7CnTX1dAyOwHG4gRIYuYW1SuLeMvGM
	 FW24Mmg6QOt1w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.2 03/11] mm/damon/core: introduce failed region quota charge ratio
Date: Sun, 12 Apr 2026 09:19:46 -0700
Message-ID: <20260412161957.82835-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260412161957.82835-1-sj@kernel.org>
References: <20260412161957.82835-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AB48C40002
X-Stat-Signature: hco7o89s17y9ay7tb9fzcr47sgcm6qup
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776010803-667499
X-HE-Meta: U2FsdGVkX197pvcwsUE/5/8ZpmbEQvD4L3YLIVtp7A3GkSMzV6DSb5rQJh+1AnEdXmzUIlDD2ydKG+0Ey/YROvgITm6jE8PMQr5ivP8NIqQhpGO5OSxP9dqcBTj0ms5J7Wh+bjk1ez+BxkyiwaHiwZrCfW5Qjx0MJy1nRlqcxA/okJuFg6baW1ZNoiaa92HwIo7DE6tWjdMLEaPdbmVUBtmEgzBI7ojBTY4Nh2s/Knt/FTD8MdFYFrDR3UrXh198b2Ade76QCJyYVwMpi/WHtZTkZ7qixDvahxWvZMR8bdRxVMBlDqydhFvISzXfCYjrtOxKRfB8BYwk/her6OnT3KLGqUNSIZEI/71LTt3Fy9+kJ74SOJoP57KR1eMN7zN5nBuTzYfXxFTlee/23LmOk8BKQNm/f6yR0HBiT5mZF0Dh8CfZca5CSS2nHWSnz/6knD/ghBZPjV5nRc30H/aIOTd1PrmZCNOXZxIdqtXbuwsKOZ7fb1fu/z41s5XweB7aZKOTR3GbfhPjn+bBLHZMpwRoLPHscQK1jql1BOGmWH97uLV84W0bncINIR7idmf4YRr6rx+P3yS6v4Xg2cAQdFMe3fMJLXz5cjGLyJF8JSkpS/8wlQ8CqX7MqWuMdag9SwytpO4ZfJGnWJJaLOKoKaKyAVkdEhNwBh5AdXbajRXWdt5lqOrr6fXkHuUa61grosgEuSrNWc9cyO4InE/HbH0QXUbv9almXjOXoANKMYBmIaNPmkrKbdRn9SPa8XoDxnFRJs/5dAc7ttHBkWD+h4CRG6oJSNf/5khI0Z5m+jVtX1yV7wuH4CfdacSPywCGOIZ/m7oP9rkqweDchizV7AeYmoeB0+mevY16PTnvWU43V1ktR4KTLLnUQl+WdxotkxpBYFfchqfY4egWGak7DKppsM/TPopi5GCl4AQBQWIB3EHl0eNlG2KiAPGL6xzc4swuVw1vfAjokk283RS
 QT1s1j1D
 ovJobNG32bmOuyRyKjemZo3csHaQKtuobCbFn0IXPxJRqmC0Md9HKWUOB7cc1kHqBnVp/t62rt2QSXVNK4YUhFphvKl3fNbHPUtV0NE2WKDePpgPhaD/WSQrpqUwbymA9jHqb3RY21mRQ7xbNI5XDJp1ODDqr07HeMqOtH2F2H5oZtfdlJsS2PsC9gxWR41qKBaxGFqNNUm/B7p5cphvFCu98HJkLn56BwFKg1aXXWm8KWSA=
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
index 0654caa904c8c..48633da449104 100644
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
@@ -2047,6 +2049,23 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
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
@@ -2117,7 +2136,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
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

