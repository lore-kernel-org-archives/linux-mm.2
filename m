Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77F61C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD4BF6B0093; Wed, 23 Sep 2026 06:15:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2A06B009E; Wed, 23 Sep 2026 06:15:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA326B009F; Wed, 23 Sep 2026 06:15:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6C93D6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:15:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0420120732
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:08 +0000 (UTC)
X-FDA: 85244619096.08.7AF173A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2AEA940008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mRtnpVrO;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790158507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEuyieJBBXR7WJiAJGyTdd6YUGmVUYQh7HDuCpd0o2w=;
	b=1yk3BEidNQWa7aRtHZ1fGVjMNM38BlUYcjaJtkLwvMoukDIPCcWARUycfUMgdK/zoueK2L
	s9bK7/CVSAnjndsLSJ1yNeyy4lZ2JrOxo+GfJW6J3CGF/11/60fIfWb4nPiQzmKQqD9Y2p
	GtU9Jfw5zDcCM6cPvI4d39xBUHo3qnY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mRtnpVrO;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790158507;
	b=t0LIh/GgsSXju1lvzKY1ebx+/u3WgOZx9H8p7pt92rNilTzKVTwERsuOJFGiMYYhAS//ex
	oIhDkQcsuY9AgwCMUIDR9dwe0iOxTXkdRADYtjaPgBgJhwd1Xtc6YOlcpkL7rQd0z9mRO6
	N4zs6x8poZBL7OfUiarzyJRNIzPoOKs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B27741B29;
	Wed, 23 Sep 2026 10:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B93D1F00898;
	Wed, 23 Sep 2026 10:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790158506;
	bh=WEuyieJBBXR7WJiAJGyTdd6YUGmVUYQh7HDuCpd0o2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mRtnpVrOhhAfIZMikXbAAB1clrMbd3FSeLHUsKfGyP0cRd2z90unaewZ9bRcqe44H
	 flTJBLNkv60xldmCTvk7KdPnr+FZyuhc5J5oNj/JLwjkbh8S+nrwe36t60FcDOSYoC
	 0CiDhAH3AkIfp49OxfJv9YH9hd4DIwbrpqPRZl/bh7hnHtjsR9XD26PF1+VH6xsNWq
	 M9TNvMzLKYZrRU2sDgu67AjKNUmKpA7TagEYqYV9fpXtEewFMnXVg4iLzz+cvm+AsA
	 LkyNKYC9sIG47zzduRUm3u/3mMoSPJ4qWhH3mVuH46t8a6FHoz8R/sZdTPHYyUVqyb
	 Wlf1y/zzwQ+Dw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 2/7] mm/damon/core: add complement argument to damos_new_quota_goal()
Date: Wed, 23 Sep 2026 03:14:47 -0700
Message-ID: <20260923101454.5748-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260923101454.5748-1-sj@kernel.org>
References: <20260923101454.5748-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: es6mosb46rw77cxk84h76w6o5crupo44
X-Rspamd-Queue-Id: 2AEA940008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790158507-286075
X-HE-Meta: U2FsdGVkX1+BLmZOIPB+Xd2CMS2pirv1uTcyA14b7AoJu2yzq6brgbKimeVVORYBU4HmhzkdOdLXb/zNngjlbtEmaBG5UNAF4vy9K4981t5sWadZM8gWWIY3VojukgpD2k5UoOg4HDK0NYamBEUYMiqaBysZpdobRsxbSbU3qiv2eRSntuS9kxNASrZfZLvhUW+jgA6xL7kq56LfomVH/u3waPE8CcMc2v/vrtzHlpSizY4Qi/1DYAJ1CkgOb+7T6VkPofrp5Wo7Ty0JwAINSmRf8jVIQrAFZNmAlXE+OBaBYWgvzvxHv4dda3Xfp/zyTq0BljYWBVEm/rHU3HefjPzVTQGWADoMKSWeqggsBROx1kR81XKd+h8LOk0u0pHOY+Z1Q6Ip6OejJYUwzSeKz0xSE/zNejyALNSv4MOOO0VPRD2YULBNTY8sIYtiLKXY2//7A8G0EMZW69shW8eav0PXJnob3bjPrwAk0eXvfJA0OP4XANNblwR3KdnReNT16CGwxJFjFrI921t8vSfUnMvSmmX9C59aEUm6vMA08azrnARf5WV2yFPQBeb8qr+1pp/CN2zxtBPr+KfQbNyxZ+kQ37z8kQABYZ5FVzBatQkvNuW7hlSunKBisr2C1H8YbQzDWqpZnyyOF/spS6kijndAta1OswOW8gEPdhXk1NMAM9RlSA1IfMLHQz+uiakqXBZzBQewfylOOH6QTRakXJn3WLt4l8g2O9Zes8+hVXTQHwL4kCyM5D3DrjJ7usdPM9yW4e0N5rVzSWexsykTigUYOpH3x0qzUEf49qE3KpqMsJsuj+lHQ1cGEYTYg4OqcSTJbaMD80RzRwi7m/ww3Ntdt0CP0dTKCPKna0GM044BfAzz6QatmIZvatTgZ8N5nyNLVYGvqJ0mTrCvIjlqX4RSvsSIWJ95hc7e9glZmS4yJXRaNlBCeWDomRrBp3hV51F5QN48JUW6g6dJP0i
 vzzvIcev
 Rt/E6Lw3PKNRmUTe/DgX4+xUfNSJJzvAQ8TNF4bgnYLWWnsvlX/UNDF5dM4JRYLk8DRewluOuLzfXOHgh9e9R5DWtUq8u7r9ORp8oWFSK6PXOKvk1aiqp9cXaLikM8yloM80000kgGuf+B3wEH9VqJat5G30kgP34o0pAoIRuyp9nk+EO6ODut2SLAoJ++d0XlsiwfJ5C3Gmz7UtO7Ov88cdebR9pOoBAt+zD7fAz16FpJ1O16f2yGnD5P7vUt+hQg3Byh4k9husSWllOk2G2JSBqWTcmBzL/g1Xk
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
index 836cf0d0de6f..2dc7031a5672 100644
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
index caf582882f5f..72dfb9c595a4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -972,6 +972,7 @@ static void damos_test_commit_quota_goals_for(struct kunit *test,
 		 * Make it kfree()-able.
 		 */
 		goal = damos_new_quota_goal(dst_goals[i].metric,
+				dst_goals[i].complementfalse,
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

