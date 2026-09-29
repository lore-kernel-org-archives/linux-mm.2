Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A69E9C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02D36B00B1; Tue, 29 Sep 2026 04:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDD0B6B00B2; Tue, 29 Sep 2026 04:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C187C6B00B3; Tue, 29 Sep 2026 04:01:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1A606B00B1
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:01:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B9A4A0424
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:26 +0000 (UTC)
X-FDA: 85266054972.18.08C5A07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 044A940009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8VqEHIO;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+pBfIL6+7Lh9hILC6grocKJLJ3Eo5uNEhvSaEi8lwI=;
	b=gw8vt/ukFQkGWxJpgN0fU0eEbBcJp8FnSXtMzXbnxHW7D5i5PZhZgeUq3gOF9fpXDZn15T
	ovpAENZ3Y9NUXmFqA58XUq5Xn7nVotgbykSoagzw80/8B9q9PAblzPsL0IeOfSOyxjFueB
	4h+8AVN1p0BFuFfW85E9ZULfYrQ4CNU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8VqEHIO;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668885;
	b=iYU80tSZcf5G7rZsG6dWL0WoprWcifmp0Yy7seWanaS3bJBLrnuUKm1koQOU6miL3hnfEo
	HqR6w1+RXJqRhpKmZS5u9zmw+/oRzAbIocukRNSoexaw+QqkmQnbsWES/ztL/3sB++wlgY
	xzlDy2ZHY1KqqGb/4k7Tpu92VbmfG7I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4589E40ABD;
	Tue, 29 Sep 2026 08:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DE51F000FF;
	Tue, 29 Sep 2026 08:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790668884;
	bh=G+pBfIL6+7Lh9hILC6grocKJLJ3Eo5uNEhvSaEi8lwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8VqEHIOd5TgU0w3JvIuS2olrK/CDvaHeOovCvA54w/iNr+3jRaU/mGAclyOdJgcB
	 kHqSrjVMile1MhLpASSeVL1j5ci+IX+2UVXLmUSLGnJaGdKZiTeRTe7NQU6xhoFsiF
	 NfO50hLeFMDD9jfuoMxMsTB3ESqXzBdacCps0VikRFAQ6wPQkYyctf7xTgSVaDgsO7
	 kTgGFIPVTGbHYvJ8FvwEIcvl9GfaGeDUzzcpOaikXqg/eCaTT8BDUeb9VQJ+Aadkrk
	 j8OztPuKbDf39TeR4K3LkcOlpk1NFPY7x700QaWAFQUShfO/ZEmWxRYPf7RM055cic
	 qO7hjMwQQGXww==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/8] mm/damon/core: add complement argument to damos_new_quota_goal()
Date: Tue, 29 Sep 2026 01:01:05 -0700
Message-ID: <20260929080113.41708-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929080113.41708-1-sj@kernel.org>
References: <20260929080113.41708-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ndkfp15grc9ixy85uy1wbd9nu4zqesd7
X-Rspamd-Queue-Id: 044A940009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790668884-693402
X-HE-Meta: U2FsdGVkX1+cMN+6wW9gVFGehIL4FYcvVeALPWnqxVTnZOatxUSupkCbnE5I7kX4dMstdifO/sPMI44QDfVXkmusyvSQSbsK91XJSoq2/FYR9uLnChI4jS3O1xewCWn35BOjQxooo+ZVFbtISk6QuPQ1n4YESsZM8fi3TFVc4FK0VaqW01YcJ9x/vkDkNUjpUeDBf1uDdbrmQPhRUaJf33qzi5QdPNsKcUXkK13xT4+sUr23s/+EHaOXwnY6tpBO6qmv5vlwccmmX4FYK50+yPrmgBcZBl//q8FN2dzFRfnaghKREmrKwQCuLIYWMzylyjK6wrShSq8stdl9xe5VaPeyanHMX9EVXRFrkSr08+3fRyYXBeO++KlSCseAQ9DACB4TSvG04RAgesj+vJhqs6dWt7cbpGCyVXPR4V1nl0P3+Uf0VMYEL3F23oTguKKQPFUelVEoW3znehUuZMyg4ynVk1XUgH63dsrjwh47r4wJVAvjNgeEDovGAdRsYNBELhiBid6UgCOMGG3JILMVVhPCYwiw7TaodyIcIus/UXpOF0H9nJZxBx2g/VcuObW5PX1ift8t7V16XXEww1KF/fjgN+XNt1owhkNz3QePduCwSZND7LezK34WOLSWNXDqkyHgg4gIL2Or/Z0tsmXEUzqdSYbVgkGnIdhPtxuz+obxPf0GG5zQEAYzHrwUvJWcXR2+OuEg3w/OCLsmkV1nxjc0L3k/WoNLvIioE2fkPZ18OMeElN7Zn6vdRcZ3sh9Iddf9L+jcK6np9sbm3XePZTKdSSRApcwQ0ABOtX0qcPYbLmvM7mvrJ7F/GHRqP6eOjB1tfsTF016K064tKBhZJJadjLQimaaAOtGFb65DMgMq4qNFu0dBg+9iYNuXFFwHsaTGNvvWYTHfS8zH89+Kv8RMldolRFQjQBC+QtpIK66N775JkwnjQRsl+myApEZ/1PjbR6xuhLWTpMX8xNU
 oudN7P9e
 T/+BPeoVElv89gQc7FYDQlhe+YowtXooCUmHdEnSzSiTcU9NeCZk2vmcLJa1AZmH2zjYehY/EhuxvRdS4C+sIRROYBXSaODsHg6VFFNWjglnAmeX9+BDHyAbG6PWK81+GdMRBNcqeY9rrXGJbIZ/lPJibpml48oDRJt/rmEA+MbROMnjNhS8nKfJh2rpJkyIX1imKywTQm3pi4oxXintif0TovstN1/104qhvkBCCglxJMpz6eWM9SDzr5GgSKCu+X0wsoeOm7flfcBbSxitldEYD1w==
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
 mm/damon/tests/core-kunit.h | 3 ++-
 samples/damon/mtier.c       | 2 +-
 7 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 42234839ce29..63050eb2206a 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1090,7 +1090,7 @@ bool damos_filter_for_ops(enum damos_filter_type type);
 void damos_destroy_filter(struct damos_filter *f);
 
 struct damos_quota_goal *damos_new_quota_goal(
-		enum damos_quota_goal_metric metric,
+		enum damos_quota_goal_metric metric, bool complement,
 		unsigned long target_value);
 void damos_add_quota_goal(struct damos_quota *q, struct damos_quota_goal *g);
 void damos_destroy_quota_goal(struct damos_quota_goal *goal);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 1ab5154511e6..86fee9ca03a4 100644
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
index 2111faa58153..5a924edb171f 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1014,6 +1014,7 @@ static void damos_test_commit_quota_goals_for(struct kunit *test,
 		 * Make it kfree()-able.
 		 */
 		goal = damos_new_quota_goal(dst_goals[i].metric,
+				dst_goals[i].complement,
 				dst_goals[i].target_value);
 		if (!goal)
 			goto out;
@@ -2411,7 +2412,7 @@ static void damos_test_esz_goal_temporal(struct kunit *test)
 	}
 	damon_add_scheme(ctx, s);
 
-	goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
+	goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, false, 10000);
 	if (!goal) {
 		damon_destroy_ctx(ctx);
 		kunit_skip(test, "quota goal alloc fail");
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

