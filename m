Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9E9CC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3856B0098; Fri, 28 Aug 2026 14:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BAE96B0099; Fri, 28 Aug 2026 14:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9006B009D; Fri, 28 Aug 2026 14:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB3106B0098
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:37:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 613491C1BE9
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:01 +0000 (UTC)
X-FDA: 85151535042.28.ED0A9C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C8ACC140006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:36:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IMSACD1G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILg2MhhSKzgWHRltlNiHRKhJSlsLIqjHOT6/IdLHUBo=;
	b=pLT5k49D5M61Kc56X4WUkNVlzDyGkAi0vT7KFLdLNb20o7MIi+BJfDuBVS4CNcchXqEo0O
	bVGBPgAoaaaFEXRQJA3GeWlA4wJ+PNCvbhzhh39o8SvKknGDomI8tPMi47BvWFCuiUcTQ9
	WPFuP0Pr5tqq3T+iX7Aatncz2h4O2OM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IMSACD1G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942219;
	b=iMyVNyLrkuR2Tbc/7mymeNi+o8RTUQKzWWFtoxBOfGuV7gBgz7MX1SkZGaZYASAlmik5ul
	zkk0+bQZv65cUxNWkDRoitcUgiChTjJfmtGzDp8rD2i7MH/H7HHKExUMlg4brtedinOu0C
	qcR78zQpyymUJTbmy87bEGXgJkB5iXI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C65B6020D;
	Fri, 28 Aug 2026 18:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DB71F00A3E;
	Fri, 28 Aug 2026 18:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787942219;
	bh=ILg2MhhSKzgWHRltlNiHRKhJSlsLIqjHOT6/IdLHUBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IMSACD1Gr+V+IdheVn8p1p0px7uNJyYwB8E3M8zhJRcnRIDJhGr6bCsbHlnSott92
	 mfy/kQF5Y5TYRvNPGXrMkzMa4YRbIfTD6siueBaTJ/5gFDdhSG2vlddpxHRsMxnz/Z
	 TBXuTGEdx7yBV/dhx/eoJ9F6aG5HNdo8oJJzS84847cqo410rVZ/zriXvpdtJ3NIZn
	 16iM9DsuN50Wxw82IgD8/NcOUVixXiRV/IZrkM4GcsxUOcq5+UIYdUU770MZj/aFWa
	 PbnBalsqnUqpYMz8KkKGPgVmHI8GbnWG+mrLGVApmIltzMOUrS+8mnk7/N0NmFfjlC
	 q3lJnlwsL91tg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 2/4] mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Fri, 28 Aug 2026 11:36:46 -0700
Message-ID: <20260828183649.71192-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260828183649.71192-1-sj@kernel.org>
References: <20260828183649.71192-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ui4ht7sodpjumoh6ojkjzsxioay6441n
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C8ACC140006
X-Rspam-User: 
X-HE-Tag: 1787942219-101932
X-HE-Meta: U2FsdGVkX19QC6xVT80/KzDe4k7BTuE9tm1/FsGWYB298h1d2phx4xBUEtBkx2K7pvTrKywrmkOCzsaiuxPApX/icnIV/Xu5EVC4yGqg5NA3y0//RqEFDORFKI9UijwGob3vfOEbCJoGsPX5vZdUEzOwT4WURM9MxFMUAplV2mHp2Zns2dzT+ON+zVEKLuD7y5OsCjNawjJmPFjPzTWp5JHKVtgTUBK1Djm+YsjE5/2t/E9cVejrV1gKH1BMkvFpAhDhNrlWDEaeUoFv57Ox0Fu3gjWTvwqo0d3d78Fs02ZOS/Q6QA+j1Kw+fsfuJJPFdp5kVXfVIiiGgjOhQq1MF6prr/uft8KSGnRhVZYCQD6oLLvEBuSiw+m0iAY0wcM72e+mB/jdWXQvS9DxnOzD+hGvRMbWqybVlmpsDFwkGesTcjUD1qifDwUxhlHJ+Wds/+m8c1osikqo7ab+T9T1ZFDXJbo1Pks/Stian9FW+AI6473PYhZiZ01N7bzy5zM1xnwm+Jz7Gl/I1v54Tq60jBsBUd0ewZkWm05ejWgV9jTcYIFnA12o3t3W+MRFBcJiwC9jtiLSPoupU7/Rx9UAYpaVcAOREegRmVDUiHogHfDoaSQexHnmxq/ieanFyQyq0nADbQGaFxIIKUnsnqn6v1KhVHrwM22D4icqai6hdRCVkYu5kKq4lNJEbAnNdDG5JViLRjNL7nvacnr6bLnS7neQVX+uYSmEGzpZ8VomzPyNzxNVaAi4L8QwaDtRK7i9NuFpTqe7/6XHpCywuNPHJrrN0SAE0LdqeRoOI0M2Afd6WP7Wq0Uow/qu+PChyYO1ojHliGCB+kT9463mH7Oopj/GEmwmlq/3zK/yy/qQ80GeQLPVa9QmB/Fm1Yp5tIKHnMEUNinUdhM4pBasZilpVC9oYg40GZGyF2/BhMNghnMBknkQyOFCSBodWhIY9bIiYwxBzmf1kPQwsDthCx/
 LBWucEQI
 lRspgrEXjwhmB/p42Uf46rxc/8+JyOzJe5WznGQU3qdko2ilDuUA4/LhNN5DkFzv0Tb/j322kqmB7aIMsc6Pu3Fsq1oxo3+6qp5DopUug6mvFVrOY0kUKHTllMSkT3Doai+X1MvwrqLNMFsLsboNppXhQK9bAfO01oUX4YlUXbVEsd8ye/Q971XoZzCknXWPrF+6VeV0AkNzktE9TYfPRrjaeK6xukuOLzE1CugTtiFKKmQ+5QnwGRGp66Kp73ezPyd/fw/MbLq6eHgDNQfS991j7VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When DAMOS_QUOTA_SOME_MEM_PSI_US metric damos quota goal is set, the PSI
delta for the feedback loop is calculated using
damos_quota_goal->last_psi_total.  However, it is initialized only after
the first feedback loop.  The first iteration of the loop uses the
uninitialized value.  As a result, the feedback loop can change the
effective quota in an unexpected way at the first iteration.

The user impact of the issue is not big, because the issue impacts only
the first iteration of the feedback loop.  The feedback loop also has an
internal cap of the quota adjustment.  The wrong adjustment will soon be
corrected over a few iterations.  For this reason, doing no
initialization at commit time was intentional.  It is also explicitly
commented.  That said, nobody likes behaviors that are unexpected or
difficult to be expected.

Check last_psi_total initialization and skip the tuning round when it is
not initialized.  For this, initialize last_psi_total with U64_MAX in
the goal creation and the goal commit time.  U64_MAX means the field is
not initialized.  The tuning round shows the value and adjusts it to
guarantee the current quota is maintained for the round, and
last_psi_total is correctly initialized on the next round.

Before this change, committing a new PSI goal on an existing PSI goal
with goal-only DAMON sysfs command (commit_schemes_quota_goals) just
worked.  After this change, the tuning round right after the commit will
be unnecessarily skipped, because last_psi_total is unconditionally
marked as not initialized in the damos_commit_quota_goal_union().  This
is an intended tradeoff for simplicity.  Skipping just one round of
tuning is no problem.  Meanwhile it makes both the code and the behavior
simple to understand.

Also update the quota goal commit unit test for changed last_psi_total
setup behavior.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org

Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Cc: <stable@vger.kernel.org> # 6.9.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             | 13 +++++++++++--
 mm/damon/tests/core-kunit.h |  9 +++------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f8dddbff74a77..39605e64dabf2 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -635,6 +635,8 @@ struct damos_quota_goal *damos_new_quota_goal(
 		return NULL;
 	goal->metric = metric;
 	goal->target_value = target_value;
+	if (metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		goal->last_psi_total = U64_MAX;
 	INIT_LIST_HEAD(&goal->list);
 	return goal;
 }
@@ -1122,6 +1124,9 @@ static void damos_commit_quota_goal_union(
 		struct damos_quota_goal *dst, struct damos_quota_goal *src)
 {
 	switch (dst->metric) {
+	case DAMOS_QUOTA_SOME_MEM_PSI_US:
+		dst->last_psi_total = U64_MAX;
+		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 		dst->nid = src->nid;
@@ -1143,7 +1148,6 @@ static void damos_commit_quota_goal(
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
-	/* keep last_psi_total as is, since it will be updated in next cycle */
 	damos_commit_quota_goal_union(dst, src);
 }
 
@@ -3032,7 +3036,12 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 		break;
 	case DAMOS_QUOTA_SOME_MEM_PSI_US:
 		now_psi_total = damos_get_some_mem_psi_total();
-		goal->current_value = now_psi_total - goal->last_psi_total;
+		/* uninitialized last_psi_total; make no effect this round */
+		if (goal->last_psi_total == U64_MAX)
+			goal->current_value = goal->target_value;
+		else
+			goal->current_value = now_psi_total -
+				goal->last_psi_total;
 		goal->last_psi_total = now_psi_total;
 		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index b643f9a83f14a..65443aba03300 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -751,19 +751,16 @@ static void damos_test_commit_quota_goal_for(struct kunit *test,
 		struct damos_quota_goal *dst,
 		struct damos_quota_goal *src)
 {
-	u64 dst_last_psi_total = 0;
-
-	if (dst->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
-		dst_last_psi_total = dst->last_psi_total;
 	damos_commit_quota_goal(dst, src);
 
 	KUNIT_EXPECT_EQ(test, dst->metric, src->metric);
 	KUNIT_EXPECT_EQ(test, dst->target_value, src->target_value);
 	if (src->metric == DAMOS_QUOTA_USER_INPUT)
 		KUNIT_EXPECT_EQ(test, dst->current_value, src->current_value);
-	if (dst_last_psi_total && src->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
-		KUNIT_EXPECT_EQ(test, dst->last_psi_total, dst_last_psi_total);
 	switch (dst->metric) {
+	case DAMOS_QUOTA_SOME_MEM_PSI_US:
+		KUNIT_EXPECT_EQ(test, dst->last_psi_total, U64_MAX);
+		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 		KUNIT_EXPECT_EQ(test, dst->nid, src->nid);
-- 
2.47.3

