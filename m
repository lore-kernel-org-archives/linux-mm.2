Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62D4FC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DE546B0095; Fri, 18 Sep 2026 10:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78EF36B0096; Fri, 18 Sep 2026 10:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CC056B0098; Fri, 18 Sep 2026 10:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 384386B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:28:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 272031406B3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:38 +0000 (UTC)
X-FDA: 85227113958.05.CBF9007
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2716B40008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AmIvreAT;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789741717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEFjA8z+KJes+owFGdbLwOS9W6UIyuQasfZo8hVa5rw=;
	b=MVia9o8klcUB+P08Yw+3uOrc6RdobPjhNNvJcARtchs0PSI5hyJrtxQ8SgZD7oZnqn6gH8
	vN5Dr1WIP4v8LS5PLSu7UcA+rh9aCbE8QZkA00U7D+X0dh26OZYWnp2w38xGySGe1/WZEY
	gonzZUp6DATMxAvtJ+WupI1CPcsFEmY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789741717;
	b=etLNaWQLNnzJD4ZsOa1CE+dELck3BJFNHmikG0TZxWdxDtf1eFNF/YZN9HMmiCkMsWCDw+
	kdxPB3MXbg873BW2q6rneQiICSzkRro4j8xMEClicenD2sG4mC1PPbFdFoTH2DuONV7w6e
	/Crhriv484iaUF4TRmg4JJEERYrYjwc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AmIvreAT;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FE0A42EB0;
	Fri, 18 Sep 2026 14:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EB21F00898;
	Fri, 18 Sep 2026 14:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789741716;
	bh=hEFjA8z+KJes+owFGdbLwOS9W6UIyuQasfZo8hVa5rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmIvreATOgN8z2RKAyV2SGTl+crvAkb85W0y4EnHdkLp7cyBJ6u8lWCANkKXDQExR
	 q8UIKS7d35PuTNz94+KdA/7z5GHFeZT2hGOPWP+357LCvQ2fhzPwJ+l63dTw2fRQ+3
	 2hK3Xb2qWc34GXXhIvIsFMrSn20aStnCiHFN6E5e+o2g5Q7UaSl+Ja1gX1s/Bwaj1t
	 f6ozF0MUlZf6hOJsZ2przoFuX/IWEHir6dIKz7rTEAyXjDeZQKrHby0iIgv20AjnX9
	 fl9F+p+KJt9YxDgoVrXUn5aoNLDJI33RPFtNDpGWEffAJRUdt9MIDLOi7PiRf+Uh/K
	 /B8pUFzKyZO7Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/7] mm/damon: add complement argument to damos_new_quota_goal()
Date: Fri, 18 Sep 2026 07:28:21 -0700
Message-ID: <20260918142827.85303-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918142827.85303-1-sj@kernel.org>
References: <20260918142827.85303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: sdrbrfc87et9mwqfd9zxa7ox7pj4w9zi
X-Rspamd-Queue-Id: 2716B40008
X-HE-Tag: 1789741716-757229
X-HE-Meta: U2FsdGVkX1/9UGfQbf3c0/9fxMIUIEhg60Hs5/aAQi63bDVirTgwYjpkMi+j6LPje4QP0p3aYGwZLfSRYopdGhNlogcaAqcFPkPHLBciKHfE1wKNrZ5+Gjt568inHe3lVqtPiOzFRfJKDR7cMqiXEL9C90jlvvQd29BYeFm2/Erp+4wDQ/va/naL5tWNaucMqhSE8ibmgfuk15wKQYiO3gWGMiUBtAz3ce8CNPKLXWVTaY6PMm8Uwbz6dVkRHe6k8u7nfZK0+VoVYm+nZjcq+oWElqxiKWT8ub/G8UXdv8vDE7qV62tidBA+A/5w2xmG1k9rcxinU5Dim3n46gVVUDGzCjIBYS0fl94bSEhWgcRhwHtVvhOYkfeJ9KFl42s3MSoYfW0+em9+1EehCrDnfmJA/SUZBFzUzjQ7al7m6CCde2CWX39tVhwS+WD578/J6tZBO3c7QMVvY6ckEH0sbsltq4Q2aT4N7VSMuD/PjnSeDPCYzy1qHbiccKpjg7wJYE+tkYqGhz7UnbXV6d5uBB9RH65AF/cXELV7ltR909PV36Ws2ZSdHUh4kCFToBdWijmS9CHdg66YZBOw98acyCZCZly/jjH/UGI+pUj61nZ5vesMtw4omwa1inuRJJNYZrf3+OhP4zuRQn4/R1y8GIHeSEExTlDIj3mlnzqyPx35msl9y5FTxhWaUmCFfet7sSTHL9A2MbxHfKAL7kymmAlBstNw8wD2PvWuswpgqerEEeC3j2Ur/9+AZk3EKer19P/+OexEzIzK2BSuNopkfjIIOwku/vPLiueeMJRLGC2a7kKcATERJif3OsktZNLO76sTLVgTBXjcU+5pcDa/o+GwS7GrRtAnlC3baMSoZJqo6FLIv/ZyqLEs9KxAoqKMxgRRHYSo3dq+yyUykNmoNkBMG9ySbn2tVVW1/cXGbSioP3UT/cdPprpJtXV2dvlxN1sKIjszX0JUZDNDDy4
 wUqOIkHu
 YCGIwQx20UV50CaRpYCXlIFSYkS3o0OSUv6V28d8zKEsl5DMBom3TDXaGGzR/4+KPtuxyDuAd2zgvUI7MdM5RCsB1yrihLSFgefPTCYM0gHG4lya+4Wv1G9y+zXVuY2ec5bdFOS2j9ozi7Ee/0waibI+DN9BIE0MhKHCUeFOTSh6NCcG3JcYc97pbhp1CZfI8vE2sLXs+ZOQeNhWweUbIUJDtXmQiCpa3eb8Jd0AkBapubDM8eavLEJ3sPBMN8xDixX0h6gynaMKwBcP8tSqmWgNuqg==
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
 mm/damon/tests/core-kunit.h | 2 +-
 samples/damon/mtier.c       | 2 +-
 7 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 78b227875287d..b310c40d6cebd 100644
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
index 98cf6bab9fc6e..567db7e1f1d4d 100644
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
+		new_goal = damos_new_quota_goal(src_goal->metric, false,
+				src_goal->target_value);
 		if (!new_goal)
 			return -ENOMEM;
 		err = damos_commit_quota_goal(new_goal, src_goal);
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 273efa3c913ed..64e086985eb55 100644
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
index 42a2c9cb13431..014b0779ea6dd 100644
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
index bfb6f0bc3f213..06af417bc9a2f 100644
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
index df84d9cc7d204..e8290a2c6f343 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -929,7 +929,7 @@ static void damos_test_commit_quota_goals_for(struct kunit *test,
 		 * damos_commit_quota_goals() will kfree() the dst goals.
 		 * Make it kfree()-able.
 		 */
-		goal = damos_new_quota_goal(dst_goals[i].metric,
+		goal = damos_new_quota_goal(dst_goals[i].metric, false,
 				dst_goals[i].target_value);
 		if (!goal)
 			goto out;
diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 27dc88bdf7a0e..a2e311082cd4b 100644
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

