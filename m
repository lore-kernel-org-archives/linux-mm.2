Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A70CFF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2AC6B0092; Mon, 27 Apr 2026 21:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0D36B0093; Mon, 27 Apr 2026 21:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E79F06B0095; Mon, 27 Apr 2026 21:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA5586B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:34:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99F8E1C05D7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:33 +0000 (UTC)
X-FDA: 84706244826.17.543798D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E2A2680003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pZnje0PN;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777340072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXxXvkBYs7IWVMCFCpSGY93DtrKN0YTHX7cnYV5v70Y=;
	b=O88508nON5Q85ohfePvIOsig3O7IKUyLXZaolSBWAPYzFrsfFXjHi/+kbHiFcwuCL0ZqVK
	7cx3KdNKmjTNLWenNCrudSJ/Q7xrTDo/lep9dafa6tJQFMtNlwRzaAO+mnGrJ+XsF3GU/s
	3HDfOwCZEcouDxjFImONJ8GKUeZGqK8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pZnje0PN;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777340072; a=rsa-sha256;
	cv=none;
	b=M7OpBWAqTxeKxbaMtWn4fBziNc9HmkgnlTQpU20gKrkOMA6UPT4xWFiWOLl6L13J53q1aG
	jL1d4208OCSS75ObLZuMoZwrF/bEZrTeau3cKo4eYcZTo//S6z3u7ENdpFJtVdOQgYnUFW
	xCCtAWIC3Iy2eePu0ovfZGM0XOU43Nk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E1C0143B02;
	Tue, 28 Apr 2026 01:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FD0C2BCB7;
	Tue, 28 Apr 2026 01:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777340070;
	bh=oUVSmzA1QnUOhVFyi70XbY1RxoyA2hU186/ok/tQ2C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZnje0PNOJUjxyLt6qxARKQQ7kOtrUjKBO5YFGVBiieSLjylDO59j9Y2+17irktFP
	 2w1DLbbVQv4BgyR4rD2C6aSd7IbV1NSA6vpWgfKAXjGrlWj8zhjjgCXbtO1gMCkk8f
	 eJm+nzo+ioEySefRXBGJye/xjwQLeHIGVMhxLI2VM78j88Ku+RJbYiBBsjao0eqyc9
	 H1iKh5Ijj1nRvKpHR5KA1YcDkeSDUCL/g4biC2+uGsGJWtG/wkmp97LwZCyrdqywEy
	 3zb78YD/Z6+fVY0MPXAiMYE4O5T6nUSyURKJoF29kEP/NtQilnaxoYB1jA4gsS9tJ5
	 nKbx40LQ3pEGg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/11] mm/damon/core: introduce failed region quota charge ratio
Date: Mon, 27 Apr 2026 18:33:52 -0700
Message-ID: <20260428013402.115171-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428013402.115171-1-sj@kernel.org>
References: <20260428013402.115171-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E2A2680003
X-Rspamd-Server: rspam06
X-Stat-Signature: e3mz17abo8ntefuioaxdx3fheb3yyzy5
X-HE-Tag: 1777340071-849918
X-HE-Meta: U2FsdGVkX18FXDyRahRjdd1Z7JuFHhLWpvmglLzvILT/SvnxKdqsd9g1XjYl0XHhqECKv9Wp0xdDTX9UCMXXErRme1xwDcpclnyODzkWoOJQjG+br8SqB2xtngf2yZnk/BQssmhwVN68ohRf29yaks2WiWfWAf7vBIMCdHi7FwEb9VxknDvwyv5qf1ySdR/Zg6Q7dJF+hFCiISYMAd/ZQxrMmGK+fKa2IKbhNsWfgW0FbqDvEJJW5U9j1A/a4kwJ2tV8cB7futSwRvCn8ce9GjILyz08jtfxcJZgqHoecPNbIe+OqNXWlnGRACLnTCDb/Rc9FkA0S0m+988UAmoPseh6HePyqQDqe+dbJHKDFkzhA59cNY1WN5bpKQOxDQAhT6cHkgsAbTL81bzJfaK04xRmJvT+3oqDSaGHIVarL69HP3z4AKnL/40SHPMe3wgw5SP3Dd82HB5E8RrR+YMlKcxPwPIwG/2hMUGcS9dxySEHIYbStAM+6c5BnR6hWnW5HwGzDBT8UOQj9q870MW9gn2T4pf0j27RiGZkgOAwYBw/3Fr/UHeAMrXHPuTBxjBnO4IxNCSesmbU0J3OVFWxnH6j2b7Ub0yd3W4OQXZoVdDoHqQafgWlyQdYYrVLTUsiNb9d3rbv/PhtaSJpIE5P2Elp3ECsvlp2bIFsoNuuALxxZl5atWGzd0OkS/KwtUB4rmaZ1qkuOY0fP7hIaK3IGJKThFZXjQTtXbEMa9plX3VDlloWxYTgDcCuwYnVxDWu6BqqNFWeVlQrAfubxJX6eWE5XaqaItrOhANOt/nFVUZhxwqvAyzoxvrEi4YDCXArDoLPNEVsqY16o/39tg9KFnLk6664tcclUqCxVl9xAwleMLz4RsHTz5VwZUedZXba8nDlzPs42zG4sTa9fLCJ4THoKOKlR18/BrWM2ODtJDoeYNY3f0h1MK9uKktelj6x+0kAf2usxZREgbfIHfs
 OR0trucj
 X8gXMSgK1kQ+3yVP/b4z0qWwhU//RymSRhbPmQMj4XP/Vgm11tZtkDzguQkXeKlwlcbltE9ZUD7kbcMSovCGecO++FZruMV/6Y3N1lU+DML8Fdcgq+rhrJJSXFtcyvdVmijZuFrD46rvzHd5AEghtjXhrctCGgako9npAqu3M19amORE+ZgsWPwEwN7jPDe3O3bMMd+EGjCiKvLMxgg2H6lDFmpLON+Ref2jpzUUpO4rCUJs=
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
index 8e1e19611c387..b20544314ba55 100644
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

