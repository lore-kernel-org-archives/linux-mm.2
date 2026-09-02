Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2F33C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 00:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F9A6B008A; Tue,  1 Sep 2026 20:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A6DE6B0095; Tue,  1 Sep 2026 20:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC3B6B0096; Tue,  1 Sep 2026 20:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3845E6B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:27:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8C6280592
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:27:35 +0000 (UTC)
X-FDA: 85166933670.03.55D5DC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 231C2180005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:27:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JfbAthgR;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788308854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfHgIbwjiDjLtKHgMa5uADWtbVJn1DArTTqrj0I3xWc=;
	b=ypdgvbpUu6iJeUwotJ2adYLfBuOmmMrAduiDauESZGV9uuwbVtA+1stOZtJ28sZ4pTk78W
	QDjCcPjolY2ho7UdmqieC99pEoA9Rle5yuWHrEvQfc5ctxDnoyDiHRR+77fJ+KczuHnjjk
	hVDbsDLVuHsoLVRWtRWBZdd2nF3mvSs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JfbAthgR;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788308854;
	b=I/6U1NC2pJV0x3JsgyZH4Ta6nHqAdDfu3M6uph11g5czXutOQ2CQkMRRaybSQ4fZ/V+X2r
	+Vb0YPyyjgGraAq5cCyWiIpqE4S/lo+OQ/ni9/rzyONSMLIB8iecdl7cU5Nj19KSnK4AmB
	MgQtxpAc+oEuLwZSo734wKe6La18FIA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0641600D1;
	Wed,  2 Sep 2026 00:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6761F00A3E;
	Wed,  2 Sep 2026 00:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788308853;
	bh=SfHgIbwjiDjLtKHgMa5uADWtbVJn1DArTTqrj0I3xWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfbAthgRBHPFv6T+0PEu95zWODpJg5fDB1H2k4FMhtqoOLLiMJ4WncB991oUR7IWf
	 PoEHUuFwqVCyxHyCL43BD+vOyEpBvs28GJTuudj+0ff3DSz0+Dgu0iSVUMwCy548zs
	 cJLGko83qIa5PJGO1P43gFkkaWELE0yLE3f/ahXTI7H0q5aktc2lqymNmsMj3sUQAa
	 pda74jc/AR36HHSFZbxGYMpD0BsZdmOVaz7k/ukUl9MuCMk5AbBdPpMMjoqC5M4iTd
	 oYpbZcwwvb3q+cyDnq78rT+bjfGcIGO1tgnkphsdm5oDM8p62PWmXdMR1uu8BQk1Ud
	 2FeKTaWhFO7/w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/4] mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Tue,  1 Sep 2026 17:27:21 -0700
Message-ID: <20260902002725.108635-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902002725.108635-1-sj@kernel.org>
References: <20260902002725.108635-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3xxegz4e19cwbmwt6ca5yu56ndxed7nc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 231C2180005
X-Rspam-User: 
X-HE-Tag: 1788308853-856707
X-HE-Meta: U2FsdGVkX19+l3CNRIxVMzoElDSkiR0CnaB0VuFJBTFLcdbXHAbCDy/Rlp20u+G/9RVvfAxeNbl8RfGgo/r6Nvjgbkk7TJ4XKigVtqBiy7Ugd1z+ipVgzTeJ1g23Z0J35slD/pCmhpWvWWSXM9FKIag5FyVPcYo8WU4MyoprPlIAVMR4VH6Ox0fOW8NO2pAd+s6nNT3gYi/3AM6evyAMvbjQ49fb9Xz3lfEttMKpy44SX96zm4jAIrMXOPk+gKZ4L5HFWRQv3S7d3oKR3FXOxRMkphlNXSC1DMNu4c6xBLNzd+FQCTq8vE0kOnlkLFSKc0J2M67uWGmRHjj9uP05+9dl8t/Jmkq5iMOF0/cm+Jwj2hxUefhVe0stH7cfrwPAul8VzSqrYpUPNhzYIxTbSnLmXvHGk4dzllOMKaySHZ0Qqliq55dXr2tZab9eptkQHm0Q1EtJ36cwvIhjS2sgm3pyyScW11uSY2CETzlW4mDiO8HujBGUBHAIoZgLWp6ymSWWeK0ufjz5BrwjtrfQeWNNBBUnDfgmOc7ShFZ4+5UIjr/nifAoFfjd+KWucA/JkGnZjI8hSftJFrPlyR60a/ri1QqsjYfPs2PwilrpXjDps7AhR+g7abSYxjEe1bXiLMt+HXdKkp4T+wZrBud1GqH1kP4OudbkmK7PHnlR3e1ZK0ahNifh9okrv2+ePb3G0DFy4T73BhQex4vFHpMA4ivDLDm+TsKB7gK0rjeRPbKD7nGYtJKCgkaDmwcut5+99VJEX3ylXQ8CkM6zdnwrhQcFkCl2bA7tDmZUbYg7xb/oQ70xB+aA9mUpiL8wJA0FnMR8bRKSSh/YF4CstYPfAS3MeQnrqNlOi0Poza60CA4BRwNzTl8BDDU/2V441GgX7vBrA22ZokBsAKbUYCEmwDG6uT19sz946no0Gy03MYTuiTTI0JNn8vNyBBWBM62nWGFPiRq3CXtTE9e0PF7
 EL1Bb/5o
 +JMiFCoUZ2nXM7WYJ3NLat7eNTGPsdBfIS2tsxHZ2TmN9ZUOfbuFh1HrShRKl0VWr0BeNN9r1f3ZF7MMmMijPXkXh4k5+qrBFl03oSFDnKij2MBa6bUm7pnpSRD8a17a9Ctub/oUVS0+ukYfMTAxX5+vKMslgySZ9lNOazerOjszyb4Oyf1okmJK9ORIQPecJK8ok83OIOkyDZ19uPvHyRGXZyEI7peEN/LH6G2veaF1+SVpQwWZ6Vcv2KJfAPemOgZ8OOugx9iuT4xkPLXspjHAizA==
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
index 0df785e72438f..20748b0a71026 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -636,6 +636,8 @@ struct damos_quota_goal *damos_new_quota_goal(
 		return NULL;
 	goal->metric = metric;
 	goal->target_value = target_value;
+	if (metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		goal->last_psi_total = U64_MAX;
 	INIT_LIST_HEAD(&goal->list);
 	return goal;
 }
@@ -1129,6 +1131,9 @@ static void damos_commit_quota_goal_union(
 		struct damos_quota_goal *dst, struct damos_quota_goal *src)
 {
 	switch (dst->metric) {
+	case DAMOS_QUOTA_SOME_MEM_PSI_US:
+		dst->last_psi_total = U64_MAX;
+		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 		dst->nid = src->nid;
@@ -1150,7 +1155,6 @@ static void damos_commit_quota_goal(
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
-	/* keep last_psi_total as is, since it will be updated in next cycle */
 	damos_commit_quota_goal_union(dst, src);
 }
 
@@ -3039,7 +3043,12 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
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
index f1e11548c771b..af26b3d60957b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -757,19 +757,16 @@ static void damos_test_commit_quota_goal_for(struct kunit *test,
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

