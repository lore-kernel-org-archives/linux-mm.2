Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0039C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA7B76B008A; Thu, 27 Aug 2026 21:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D568E6B008C; Thu, 27 Aug 2026 21:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9156B0092; Thu, 27 Aug 2026 21:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2956B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:47:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16AE3160242
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:47:11 +0000 (UTC)
X-FDA: 85148990262.15.ADE2E6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 71075100003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:47:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ls40H+Ui;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787881629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRfutuzu05ykYxc/Mly0vRTBPzzKGyxJTyvmxyHFbck=;
	b=hZsiwvil75Gpih9KTVOzqPQMTbN/5ngFgQMjqTn8Tr5F92q3ypNuRBoH4lFfAk5NNgqWFs
	txCdCB5ewCYFubdjqdIbvGWUYK8cArCIDv8dvpYi8vfb8OHGfBkTwhPhZ1xEQH68TwT6g1
	+6JnZjoeCgcaHy06+u7M3+OaqgSz4OM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787881629;
	b=E6hqNRv71oQu4jpbZ/I9wqxniEntgxej4ALYEVFTtBnmG+f7u4sMbvwTs+PgpKcaTfdJtR
	U3UVf3fKwc9GhhWAY8Y2gXMGnkBVZkYSbv6LXqJxg41fsWVcOTS45C1fQ9b9z771crB9yP
	fNfMIEQtpniaOIlZfXXRZZVVK2tfJgg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ls40H+Ui;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6013742A19;
	Fri, 28 Aug 2026 01:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164491F00A3E;
	Fri, 28 Aug 2026 01:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787881628;
	bh=VRfutuzu05ykYxc/Mly0vRTBPzzKGyxJTyvmxyHFbck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ls40H+UikY24YXzGLtz8LM6CXyfz9UeGBPGKiq4mUB7b4bp0iZIar+rhXFGA+mu24
	 z/f89P1uaUxS/gS6zbm+uPHZCpcm4uFxvP1q7m4io11IVBMsQxbq9bp6JSISCSaMzU
	 qea+b5ybj4+B+Fy/Gg9qv+vh7YFcJeMMoW0vAoDvWM2nCNFWVsprZsSCxg22jh2a/W
	 G54eKpPe4VdQZFXQr5offUfJ1idEjXsZVDN8JYJgcDXN5+lPwVZE1+rm2cTOmHvMJZ
	 MTaLnlSL7VEF7jxG9MWhTdQVG+Bp6nfOs8XLRHlDHqmaU/BHrDAXYBeE6nZ+Yq0Jg+
	 k/taNyCv5R4hw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 2/4] mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Thu, 27 Aug 2026 18:46:56 -0700
Message-ID: <20260828014659.121058-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260828014659.121058-1-sj@kernel.org>
References: <20260828014659.121058-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 71075100003
X-Stat-Signature: dh8z6mk3txiagtx8f5ck9koapmrzzc13
X-HE-Tag: 1787881629-171511
X-HE-Meta: U2FsdGVkX19z/9OOClxjGo4RZaMBpehRNss/zUzcG9RbSHCX091d65DusRJ2VX+m9rm95GqctuJzOUrfqsRRYZdKa0rtbagNO080G2bRIIptN5bc/taeyOh/aPOKO0edkr4B4l/JmbhOgz8VWRUoKqG6GNWI2pQftrInfKmOcWNre4e76NfH9cbgrIPEXeTZvyQunDMmnFG6zOaZZnXOfKp/HNTkuu0JrkNq4OKA7diOW9zZap/C4KV3M/8168ZycAbca/ckyKjzMsqJv/fUxzueYKm+zLR6zdBtYq4uWFItqbfw/kAL3gLFl0dulrDy//XDZLVvT8HGHxcZeVinbKRuFVfi4WFeDbUYiw//ZcbcCXv2YsH4SiJh7FJADhAEAEgYvbVaBQjbegb+A6bPw2wrehyKmRBOOoCCxvbBZ0EukOJ0BTn447//bAJWCR5nWKCVIYoA/byv09BWMSPkXUZLf5TQo4/Zi0vbgM893uhPP42ZYWd55sTix/EZeInpH9B0SrXFKhfq4dXNu+4wuczXoHSX7zXQcGo+aizAibs9qsxaB1bnw8GJviN/sj9XYnPlDD7rkssoPDwwgrwD6mGcm3p/p5IOZLzUIB9KXzfhRN6oA83HMn8O9B6C81f864XW1D8ALmb012vb8fJgBOIsig7jPdGTKXJwWZyB4EszdU6ihPakeLOC+JXkDzOyGQmrG+L60gM/+dM7HVrE32rxJG3PIzsJSlz+Zv/nc16X4an+GEgtDtcbz4p6fgJ/7erw6oS7x6aRz4h5FD4rYo00PcjEwBJ6pdQyknZ+CpAlDOhVyBgtfBp6qW5IHPMF174vJ8C1sNX1Y1NTg2lHbQYZN4hYS6YbzKTceJ6V+oxwDP5GXaoKfj773xKANM7t0CNeGSSGds3CMDE9nN64T3EMj4eDLICZOfj4OJK3HG3W70GCC1pHaehE+Cpxe/wFjUyQ5+GgPxT9ppzj/JD
 jlkePSVG
 Xt0w+PxpB3fiFhIDovSitm9pYGnWk/CxXnLmQ1+8IwiWKmHjUddEqrIaZ1auc826kG4OUglKRPpZIIYdLR2KiUL83vFH72rzsagLwNnH7b93N0EGAVEyA7ekR8PU6ENsB4JVUpuot5TKoAY96xcWrb1hMJToExIrkOKYW8wJavLcZ7V4MNcrwfQPu77wp5h3tXEfo4g0LOpkO4LNZ8qHB1nYEQjZ36hsjd60MJ7diXKn7bd1V17Ee/+EH6SBa8zdPQdMM7S7bIdmtgpTHsOen/t6q5w==
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
 mm/damon/core.c             | 10 +++++++++-
 mm/damon/tests/core-kunit.h |  9 +++------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f8dddbff74a77..f7e66898aeb84 100644
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
 
@@ -3032,6 +3036,10 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 		break;
 	case DAMOS_QUOTA_SOME_MEM_PSI_US:
 		now_psi_total = damos_get_some_mem_psi_total();
+		/* uninitialized last_psi_total; make no effect this round */
+		if (goal->last_psi_total == U64_MAX)
+			goal->last_psi_total = now_psi_total +
+				goal->target_value;
 		goal->current_value = now_psi_total - goal->last_psi_total;
 		goal->last_psi_total = now_psi_total;
 		break;
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

