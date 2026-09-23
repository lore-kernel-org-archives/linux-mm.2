Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4060C98308
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 05:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609E76B0088; Wed, 23 Sep 2026 01:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1696B008A; Wed, 23 Sep 2026 01:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51DA76B0092; Wed, 23 Sep 2026 01:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2937D6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:51:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACD2C806FC
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:51:47 +0000 (UTC)
X-FDA: 85243955454.03.C978D9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1C16F40005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:51:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="e+L1P/dh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790142706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uqgctrpnFzYOtbOt5wZGBlKqk7cGr2WeKbcX5dCUKD4=;
	b=uWcvvKn+XrIcv+CR4gBR87Iap7EdovOweHevHHQJzaP/e3LMGygzpsJC6R8J/7Zi5lNAd5
	6w0vWIUG1PrWKdcDulEAOkcVLHmDyEE4UmiDF686Jqb6NskxW8h4wnKA4LzSmISa9imIKQ
	SAUgeOd/NVx7krQi6LPGQWZVgtEbXng=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="e+L1P/dh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790142706;
	b=H79hmcyfDR/Y4eK8/vgGRYDWJUl0ou5/lhPn029D3B0yIzGa+sFpVO8AGwKx/k4LBlYMJL
	xpje8YRHu2wkLhW9MXrL3wKzk6hz6kntatCiH1xZOYfn+bbmyd6moaPJln1zPYJB3wSW7l
	dHwcgcSpywqdJceZ4DFABR21znVA0zM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 70E1843C40;
	Wed, 23 Sep 2026 05:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0421F00893;
	Wed, 23 Sep 2026 05:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790142704;
	bh=uqgctrpnFzYOtbOt5wZGBlKqk7cGr2WeKbcX5dCUKD4=;
	h=From:To:Cc:Subject:Date;
	b=e+L1P/dhR24eSLFlOTson5Yi/0/8uoPtR9P4xlGDvFJ1hRE5HBfmlRYmtmgBRZc83
	 GQ4h253+BzvB7O/Q1WJx+uk0UcoAFDyeI+HB9xYjDrgAayPLJxAtLGzxmY9qJgKTEA
	 Of3wjRxTN3wZzfYYHaJCh36Cf8L1dH0BbzkgXMqhVf9wLOrsFehMQUE6xyeIAHXIFQ
	 gSNWV87N3n4eVef6VVrnrCUqMZT2PA9ZQ4D0uMErG9v6Ve0JZt6dDrn5KwBxTSytR+
	 BDBDYA69md4T5reqcZ3B+btSCkCRXDLF9cb5HuF4HcnfkTbhhcBrMlojMnLnKuoDKX
	 UDxMLcR2VubAQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 mm-unstable] mm/damon/core: keep the temporal tuner quota over an unmeasured PSI round
Date: Tue, 22 Sep 2026 22:51:37 -0700
Message-ID: <20260923055139.2982-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: guxotpfhx9tqbfbft486bf8szy47gxqs
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1C16F40005
X-HE-Tag: 1790142705-823719
X-HE-Meta: U2FsdGVkX19vEs4Xa4XEPnu9XXJuEpv2XboZ2O+iK8UgBnS4jTf6JzxNShGnGMpeJxngoLvZsTwvzabhgNf0D/dSZB0oLRRGi2kd3Z7pQUPP1zPi0ICIs6uuMOFRIe6uOzqk81gZHO8C1qPScaMPeGx1V27VhhjNtu/MDbmDEovoRJQ2kYo7f6FgFDzekMTtnRCHK7GmPQ6qxnDv5ubO4VB3H4HQ22sYHKSaGZmGREpBzE5DFqkSewPcc/+hGVkLeCzEqY2IGX4HLRjXg+IQv0oGQ/vnNYUrxpWpdkV1qEX3T28vYQg7kXZDGD8nbCkN1S7iV7vi+ee2AaSbEMCEOJmFrF3/BltvT8syFfa8zk9sjtktIOsG6RpeQVjdCIqu7TiUeZRLxYywTsToNX7pp4KLmRx4XYvPX9oLMQoH/UiftYdirLE5FzUt6QpfpdJmIPBqS5vB/RGXhFRcm3StRa7VTGUWH0O9Vwy25XD4meUuRv1r2pjo6pJQx6wUfm9PEEriVoBJwyKL1Jt22f+h7iWC1LvDiTh3MlFSSgJKpzZvyCNI+1aJqy6veckhff+1sPjLf9GLJ2rfKpoqwJQVEJ4UPhDCWkxQOp3F5cG6WJT0e3GuHuFGvlxs6iA56pGmIw3EqcYn9B6eN502nEu/NQ3w7yeFO/krc0zghyrZWzhX9sDbxHGUDxxcjnA/eo5ISRhvsbk9FvKdv+L+cEsBCWFY0wGxBCRf2J7KkFyd+vv0RauqgQ8JqazRzQlDN2F25xjZoTdbJwNbg7tY00NJIrRPSJlgi1NWFZX+W3B5LG0UxO5MvrKzD7VVl8mrX8PjB3sSUf5NM4AwxEVR/1VUr9F8x5nw0PQ2EIqTbeF0MxgZ5kyOPlid7xsWGIp7JFtiK+vbjCUZORqqyVBInuUaxgeNFiPqYbOTTUDvXsMIn3bhq7DhXOLPNRDEdkEDLZ9hIuOqM3/vEMQzJd6HcVL
 jCSuXjH+
 /3VVKXIbls1AtUXhXvljVm7wJNahltbFUjjqIol+KuStaY+xLBJdSlkMQyVu5qqUQPtYyoPUJYU7LDgY1wtiPOCjVm45+oelPIT9fjwh0x2LuQVSrsxiJ5rWUpxfDprnkreI/XCDjRrd/9VkybBWx4DDVYCSDFuCisfkkriUhCJHWm6ScMuD7XU6mQt8BqhQPt8uBmiJJmNfkfqq5o2UwdQk9kO5hKdP+yfhQjp6pFxDwL71wjkjES3qdscHu3fwaKNr/VuJKfSP1F7IUFQm17sSLP5eJmO0AYIBeVNWOJ22NtmCsMvYh8cB2Co9t2hA+hwxeJ/yjw1OJynQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Karl Mehltretter <kmehltretter@gmail.com>

The patch in mm-unstable of subject "mm/damon/core: handle uninitialized
damos_quota_goal->last_psi_total" scores a PSI quota goal without a
previous sample as achieved. This leaves the consist tuner's input
unchanged, but the temporal tuner sets its quota to zero for an achieved
goal. A running scheme with a nonzero temporal quota therefore loses a
charge window after a quota-goal commit.

Use the effective quota to preserve the temporal tuner's previous
goal-achievement state during an unmeasured round, as SJ suggested [1].
Score the goal as achieved when the effective quota is zero and as not
achieved otherwise. A new scheme's initially zero quota stays zero, and
the consist tuner's behavior is unchanged.

Move the PSI current-value calculation and last_psi_total update into a
helper that takes the current PSI total. This lets a unit test cover the
unmeasured and measured rounds without depending on system memory
pressure.

Link: https://lore.kernel.org/damon/20260916001311.101024-1-sj@kernel.org/ [1]
Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Cc: <stable@vger.kernel.org> # 6.9.x
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Suggested-by: SJ Park <sj@kernel.org>
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
This is a fixup of a patch [1] that is still in mm-unstable tree.

[1] https://lore.kernel.org/20260902002725.108635-3-sj@kernel.org

Changes from v2
- v2: https://lore.kernel.org/20260921020013.33105-1-kmehltretter@gmail.com
- Split out of the series for squashing into the broken patch.
- Collect R-b: from SJ.
- Update commit message to make clear this is a fixup of a patch in
  mm-unstable.
Changes since v1
 - v1: https://lore.kernel.org/20260915060937.3423-1-kmehltretter@gmail.com/
 - Use the previous effective quota for the temporal decision, including
   when it is zero. Keep resetting last_psi_total for new and updated
   goals.
 - Move the current-value calculation and last_psi_total update into a
   helper. Test both tuners with explicit samples and check
   last_psi_total after each call.

 mm/damon/core.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4687b909d42c..733025b36745 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2956,6 +2956,28 @@ static inline u64 damos_get_some_mem_psi_total(void)
 
 #endif	/* CONFIG_PSI */
 
+static void damos_set_psi_current_val(u64 now_psi_total,
+		struct damos_quota_goal *goal, struct damos *s)
+{
+	u64 last_psi_total = goal->last_psi_total;
+
+	goal->last_psi_total = now_psi_total;
+	if (last_psi_total != U64_MAX) {
+		goal->current_value = now_psi_total - last_psi_total;
+		return;
+	}
+	/* uninitialized last_psi_total; make no effect this round */
+	if (s->quota.goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST) {
+		goal->current_value = goal->target_value;
+		return;
+	}
+	/* let temporal tuner show the same achievement as in the last round */
+	if (!s->quota.esz)
+		goal->current_value = goal->target_value;
+	else
+		goal->current_value = 0;
+}
+
 #ifdef CONFIG_NUMA
 static bool invalid_mem_node(int nid)
 {
@@ -3208,13 +3230,7 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 		break;
 	case DAMOS_QUOTA_SOME_MEM_PSI_US:
 		now_psi_total = damos_get_some_mem_psi_total();
-		/* uninitialized last_psi_total; make no effect this round */
-		if (goal->last_psi_total == U64_MAX)
-			goal->current_value = goal->target_value;
-		else
-			goal->current_value = now_psi_total -
-				goal->last_psi_total;
-		goal->last_psi_total = now_psi_total;
+		damos_set_psi_current_val(now_psi_total, goal, s);
 		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:

base-commit: 4b811cf44e3dd87981f18631be832027385f7d4f
-- 
2.47.3

