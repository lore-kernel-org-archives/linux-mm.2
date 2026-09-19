Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF85C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 01:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7FD96B00EB; Fri, 18 Sep 2026 21:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2A146B00EC; Fri, 18 Sep 2026 21:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1E06B00ED; Fri, 18 Sep 2026 21:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 911476B00EB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:14:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05C6B80176
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:11 +0000 (UTC)
X-FDA: 85228740702.16.8D2BECC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 714BD40003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JqO4ICle;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789780449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3raBbLeFpTIEpJmm1pMj76F/nXAbwXFIKp8E2V5BGiA=;
	b=N3qwOLhwpHXJJlX6CvTvdeRjFDXUB/nVBJfTj/yKfoVLfe52KvkNjG0ZqefKX9rtBC1Lp6
	pQUgD7Yoj4/bc0DGB1aGl3ZjNr+z1nmTcInGpT6ceCANcODuD2Jy3jjh9UC4Z/UINKUbwA
	QA81SRquzzKei+eXVI37xtm0X7ycusw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JqO4ICle;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789780449;
	b=OVLJW3jGoNKTro+c1+rqhCBAIEoM6A2TNyZ43gtfrADeyh4xBc3ZnUxbj7CanqCUgE+hRH
	wcDu49GDgbrekiBj+mT5nV3y6+UvtSb4L9GqDpcqfDGIW8wbOSk/EViIacevrnL/VN27P0
	tX8zEH/kEyDk5v9SDNzSOAXaUnTS/tA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0117F60A5F;
	Sat, 19 Sep 2026 01:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D5B1F00898;
	Sat, 19 Sep 2026 01:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789780448;
	bh=3raBbLeFpTIEpJmm1pMj76F/nXAbwXFIKp8E2V5BGiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JqO4ICleDn04jVg5zhWHwehwHDU0WF2G/I+I0ErBEEf+c7KVG6T43uwRsFl3jzFZ0
	 9CL8SlLYi0AfO2OQHJGTIWZa3yLiCGfLr8clgSBSkLpdiKkiYjoNbviz7FlZaQrlJs
	 APO4es4P8iEKKBcCjItp1v7O79fsuZblBr53gAh9rig/Bxv4QGswkWbR6nOW6YLVRW
	 kKpvMt2thVVecm6WSu4IFidy3ELN2M1Hamfg7ehvYshfQFmJTDxZszsYH1CB/U+bUc
	 CLswOk8SJSlAJ0r9UM5MDI32EDnkBKB0xAt43vcU1//ozNxaEP3BwufV+CnzeIhOx9
	 4+YSIX4R3EwMQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 2/7] mm/damon: add complement argument to damos_new_quota_goal()
Date: Fri, 18 Sep 2026 18:13:51 -0700
Message-ID: <20260919011359.88921-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260919011359.88921-1-sj@kernel.org>
References: <20260919011359.88921-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 714BD40003
X-Stat-Signature: d6gk8t4scijydk7nxtqszi16t7jbr7qm
X-Rspam-User: 
X-HE-Tag: 1789780449-969631
X-HE-Meta: U2FsdGVkX19vmHHhx8mFGt+2YaKMCBP7Dt8F4zX/IYSFMAooxqAeOZ3gWkLLdS5kP/7/hYFwY8OjxP1MznsM28ARbfBFzBe9H2Ml4eFBWUxD29NZ+WPq5AZJOZ1gq2aA/kqx1aO3MGqK6KY24FdCoT7tZzJG7JoYnUlP46FjSUIo4QaGVY1lNnK4gsv5LWcX540GDq+s8q6aiIaYc8JeySu2JzyzFxS/i3fIf9zk9avabQZRfb0AcXgJd4J1ZeA8FRdW1ORYXyHo0ANYnl8GXXhwku08N7CkWBVzlUeF1o2qgky+gUTEaB9YghA7aBNczM8hmCnXEHx3vWhynuZ+ueGjyXadtatWIC1K6D4QUucE7ilrWcVOzHw7xz7JFCl+Z9Kp5nj/+AsSZKLdj7JUoJcrsHjhwFl5Dgc6nBZOtMeM751tNbQzgpJvCyg6jism8+vgCwF0Zj7DOsVM7NBo2b4soPQC2ScogY4Jr5Kjps1iuBin+huaAUGSjTC3fRaVkZ3kcOmkCohaZjfZf3/b0mVHiqRXX1wIAONrLy5jqnh8KHu6qah03WKBz65VMW0QL5Rdr4CSb53CWY1xyF0hc9oWaqL4UXlmpD+WjXd1MCmxdTXFSCeeeB/lcD9pTyH5g1fu5iTWlFE+lXYHGeFDUuBcEvcNtkxAtfb+XGegcJMu9nNPwBIzmvO3N1vGFKPRykvR6ZPaLbd38xG6bOR0752+K2UUl+jN/1IbwD3NQBZ+n65vC65W9tsXLV4jkDD9WW5rIV8gtOFs6265j1oJHX+vx4myXGEbyvB0znO2TaN6i24L1R7gDuQIVYhM2cZLhGjvwyB3Jp+u9u+haMM7zUeW2+JJOVNHycO4Veaq2uy5b1ZohGAC8s5NqG5MhoiPbAnVjZdZaU9oRejMnP4msPOof0pGh2XZexeLQl8kzpr7TQeYtIBd+vpfjuW3Qe4Yng01PFzdk+HX2wda7j6
 lOjpeUf8
 OSrVnStdCi4qnbWmsePPoKFhdrYGOP69fWCcF1wIPvqMR8iGSWJzpokVr0yblI0SULkJ762SALbQjsWPV3vSnl5Rq4D5Scl8toyZAfPieik935HEuKJHkxFdCZZlOe8Vij0K8HSkfHBz8FkLRpbT/R8jGZKFoABVbsjHdAN+/Qy69rr5hegCo1D3Yim1x0r9nAi2IK6/6NemcQiSSQ3voqvDfWrge2Ci+7WYPL+29G53N400oBvf5qYtq2zKD/9zX1iJ2cvelFYNUjckqqEObe4Y43g==
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
index 05d1df3746e83..570891a15e2f8 100644
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

