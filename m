Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 734ECC9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5EE6B0092; Mon, 28 Sep 2026 05:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16FC56B0093; Mon, 28 Sep 2026 05:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2CD56B0095; Mon, 28 Sep 2026 05:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C48AA6B0092
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:33:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37425120136
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:33:57 +0000 (UTC)
X-FDA: 85262659314.26.AED8D70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 90599A0005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:33:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=okilBTTT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790588035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NpMGCOOM925wo0xqKha1bWNA/zDBBFGTTeCY9T1jWc=;
	b=272LBccvXmySLni3dbPy946bC7Wo/5K0JrSEoayDg4gJwcq0Uky3+QiEiVNo4hUqzeoa5r
	mgFoHpQ1YUfeVNZx4jlbRKyNr5hA6fQaKoAJN6ja+byJS8bavX2xJSOLOklmCIMM5+UGFi
	BoFePzOD5EaZIw+aFhQGoDLq1u8yr6w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=okilBTTT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790588035;
	b=oeI1QehE556vhiHU0K9gbTVgJsntH2CsgtmXmW7fpZQ8R5PScZOFXef7ISCMpQJrA0Te8g
	q2AwTyetb8mzovs0q7xu7OQTffj2/OT5pRS3E1VHd4xt5n+3Z70UQbKTD8Rur5CYvm4BF2
	SltNExEHw2VTqWgmo57N+xpYbZRByzY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E49DC43E86;
	Mon, 28 Sep 2026 09:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628891F00898;
	Mon, 28 Sep 2026 09:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790588034;
	bh=2NpMGCOOM925wo0xqKha1bWNA/zDBBFGTTeCY9T1jWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=okilBTTTlyeMkcAeyZsb82XvRio2JEg+ow7QSFIa7rQXced2fGDORyZP3V1/oKHDx
	 +rA8MtPGBU7pIX2Aojm8BAh/0kSfgFzwMO4CeJqwPgAppWoH16DSCawz3O2yr8Dfi/
	 rr8H9mq4l6NWTQjG5FWc04lrI+Od4P30c32ah1prxTKzkncdiARbMiwRemRIYi7PL4
	 X2gt4usaC94YM9b0No5O7iDqHek0RXtWtkWKqxpYfngixFd5z8JoBu9pHoJYc+rJPH
	 BWLrcD1sMx2ksWrlt/UYyQ2W20UVFhgBT914BEM52gE0Rza6Zs3HOh2AcsiD3AOXYc
	 gpDzGuUeUHNjg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 2/8] mm/damon/core: add complement argument to damos_new_quota_goal()
Date: Mon, 28 Sep 2026 02:33:34 -0700
Message-ID: <20260928093342.16584-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928093342.16584-1-sj@kernel.org>
References: <20260928093342.16584-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mei67de1xcjj83yipwt3kypmi9pf5eg9
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 90599A0005
X-HE-Tag: 1790588035-416496
X-HE-Meta: U2FsdGVkX18By462RkpWPZesQzuTTNyxIphbabSSh9cIxHHR6vUl6WXMhiYDTkA8PAnrf98KbxwiUkcjzrE3W5UjpV6lEmkcsA58NsIW+rhNN8LWyzwjsHd6pcJi9aNsHaLe83/5lR81Jsk6gLoNGZ5I0+Sr5IgNuKi16f8pX1zi5ioiJTx8nJFSoliWMqrcxV6tBNX2YQoUdkY/3xOXSwBrquguDvIyXTEwRT6b12psW2/vijnPyArRfZ3ODSDX5LxVTrOK3ZV7XOsUa2LCMWaaNzZdZi8c+Ex8Phs+mSzAWGf9Oo6z3Z+0XcJoeVzecGpi2XrdsGMs/yT8oOInbR9lkajf5qz424cg9AqTudnWc7qlkdquV4H/B6rBVGqL+OMlWwrrXQEETn9TtWQ+Nr+hPfW14XnBXzA6Cl7udd05uzzQwZAkAmDpMqkQauLoqKIM2q4JIMqZRFzcUB3igeLgG1TtSDmXkPKaYR4kpja7JVkseUasa8ZHA/InmvCBYzYsvfOCY3naHxF1jLjq0QsDqE7uygMqOxMG2AW89V6C+iaLWXEzunhlQ4q0KfDaqihrrEV7BG2EizmUteh8u1u8661cBCCFCaAieXjVBrjf3zmDMs7vBIAr+ZYP1iMlInZALLKDMTgWmCArS1wIkw2g0I4oZDEmMk0QlkdxmFCg8tla8uUKRss3uxReUnpDUHZ4fWCXBZYopahJdLQ2rYjmXK2I1oLMO7ECLp/vbDztYgHpBpMtM+pezeKnW8hVACrVWyELywLVaLT7vKpbyUMWYY3ReGQt5nUje0IhQif9E8A6L+/KSezEhr2kOQbw3FQ6dP4wlsTF/fYleXvp/wkbILXcrs0Y5XHwtH8sSYv92ts8Y1ItY8ycYbm+3N/EgxWhfUdZnnugNoSHz4Ml0Jpw67IWvhCnSdvYCn7pxmfNNQpzihDDCbB1dPTmEvo51kRLYmlG9op62Y8NodA
 uDlkqVoL
 TxT/3smP/0LYr6x/uSj8mlh/VlkRfkbAiq9hc4IIGSDmegUHS53LATe7bOz3FD+Y7dHOWy4Vs+4r8WDVrL6uSNDQqJgIwBADHrEqgR9vAoXnUEBKzJHK70QybT/9HUvLlHHxNI8Z3XpAC2Ztl7v4hpq826IImqXpg9YL+33iyc6edRnPRf88b6LxfmuHtozmmBy53WDQGBX8SBERZFipa7AIBD2Te8M24/CndJh1nnKpBx/44Y0GSs3rBnUez1Loy6sV3eKINSal4eE3ZFNtu/i+jpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_quota_goal->complement needs to be manually set by each API
callers.  It is easy to make mistakes.  Extend the quota goal
constructor, damos_new_quota_goal() to receive and set the complement
flag value. Also update all callers to use the new signature.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h       | 2 +-
 mm/damon/core.c             | 7 ++++---
 mm/damon/lru_sort.c         | 5 +++--
 mm/damon/reclaim.c          | 5 +++--
 mm/damon/sysfs-schemes.c    | 2 +-
 mm/damon/tests/core-kunit.h | 1 +
 samples/damon/mtier.c       | 2 +-
 7 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 78b227875287..b310c40d6ceb 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1098,7 +1098,7 @@ bool damos_filter_for_ops(enum damos_filter_type type);
 void damos_destroy_filter(struct damos_filter *f);
 
 struct damos_quota_goal *damos_new_quota_goal(
-		enum damos_quota_goal_metric metric,
+		enum damos_quota_goal_metric metric, bool complement,
 		unsigned long target_value);
 void damos_add_quota_goal(struct damos_quota *q, struct damos_quota_goal *g);
 void damos_destroy_quota_goal(struct damos_quota_goal *goal);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 270ce9c85a2c..86f13411b91f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -691,7 +691,7 @@ void damos_destroy_filter(struct damos_filter *f)
 }
 
 struct damos_quota_goal *damos_new_quota_goal(
-		enum damos_quota_goal_metric metric,
+		enum damos_quota_goal_metric metric, bool complement,
 		unsigned long target_value)
 {
 	struct damos_quota_goal *goal;
@@ -700,6 +700,7 @@ struct damos_quota_goal *damos_new_quota_goal(
 	if (!goal)
 		return NULL;
 	goal->metric = metric;
+	goal->complement = complement;
 	goal->target_value = target_value;
 	if (metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
 		goal->last_psi_total = U64_MAX;
@@ -1262,8 +1263,8 @@ int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src)
 	damos_for_each_quota_goal_safe(src_goal, next, src) {
 		if (j++ < i)
 			continue;
-		new_goal = damos_new_quota_goal(
-				src_goal->metric, src_goal->target_value);
+		new_goal = damos_new_quota_goal(src_goal->metric,
+				src_goal->complement, src_goal->target_value);
 		if (!new_goal)
 			return -ENOMEM;
 		err = damos_commit_quota_goal(new_goal, src_goal);
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 273efa3c913e..64e086985eb5 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -233,12 +233,13 @@ static int damon_lru_sort_add_quota_goals(struct damos *hot_scheme,
 
 	if (!active_mem_bp)
 		return 0;
-	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
+	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, false,
+			active_mem_bp);
 	if (!goal)
 		return -ENOMEM;
 	damos_add_quota_goal(&hot_scheme->quota, goal);
 	/* aim 0.2 % goal conflict, to keep little ping pong */
-	goal = damos_new_quota_goal(DAMOS_QUOTA_INACTIVE_MEM_BP,
+	goal = damos_new_quota_goal(DAMOS_QUOTA_INACTIVE_MEM_BP, false,
 			10000 - active_mem_bp + 2);
 	if (!goal)
 		return -ENOMEM;
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 42a2c9cb1343..014b0779ea6d 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -233,7 +233,7 @@ static int damon_reclaim_apply_parameters(void)
 	damon_set_schemes(param_ctx, &scheme, 1);
 
 	if (quota_mem_pressure_us) {
-		goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US,
+		goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US, false,
 				quota_mem_pressure_us);
 		if (!goal)
 			goto out;
@@ -241,7 +241,8 @@ static int damon_reclaim_apply_parameters(void)
 	}
 
 	if (quota_autotune_feedback) {
-		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
+		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, false,
+				10000);
 		if (!goal)
 			goto out;
 		goal->current_value = quota_autotune_feedback;
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index bfb6f0bc3f21..06af417bc9a2 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2869,7 +2869,7 @@ static int damos_sysfs_add_quota_score(
 		if (!sysfs_goal->target_value)
 			continue;
 
-		goal = damos_new_quota_goal(sysfs_goal->metric,
+		goal = damos_new_quota_goal(sysfs_goal->metric, false,
 				sysfs_goal->target_value);
 		if (!goal)
 			return -ENOMEM;
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index df84d9cc7d20..945037fe4be9 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -930,6 +930,7 @@ static void damos_test_commit_quota_goals_for(struct kunit *test,
 		 * Make it kfree()-able.
 		 */
 		goal = damos_new_quota_goal(dst_goals[i].metric,
+				dst_goals[i].complement,
 				dst_goals[i].target_value);
 		if (!goal)
 			goto out;
diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 27dc88bdf7a0..a2e311082cd4 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -163,7 +163,7 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 	damon_set_schemes(ctx, &scheme, 1);
 	quota_goal = damos_new_quota_goal(
 			promote ? DAMOS_QUOTA_NODE_MEM_USED_BP :
-			DAMOS_QUOTA_NODE_MEM_FREE_BP,
+			DAMOS_QUOTA_NODE_MEM_FREE_BP, false,
 			promote ? node0_mem_used_bp : node0_mem_free_bp);
 	if (!quota_goal)
 		goto free_out;
-- 
2.47.3

