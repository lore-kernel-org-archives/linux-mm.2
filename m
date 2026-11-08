Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3F0606A322
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=izPXfjvc
Received: by kanga.kvack.org (Postfix)
	id 1FFE56B05BD; Sun,  8 Nov 2026 14:22:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 191B46B05BE; Sun,  8 Nov 2026 14:22:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33586B05BB; Sun,  8 Nov 2026 14:22:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A11C36B05BC
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:22:33 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C4FCA04D0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:22:32 +0000 (UTC)
X-FDA: 85412923344.03.633D82A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id CF67140004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:22:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=izPXfjvc;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794165751;
	b=YCXcZYQxNJoGEzuawGagFue6ngqe14dItkvgUbhCJezem+sBq0Pb19BzcKO8CbI4kFVNBQ
	8UO6ZPi2UZauUZ46PV93K9Yav+XyD2ENMWFsWjvjct7QyWYbU2GBRDPIlCiWixJhc+g/KZ
	6oHqFu9mv964uFGnP0nrSK4DbyJlRls=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=izPXfjvc;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794165751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7U2bcNPCrBwzjsXKuwnPci/B9bQIw0g0WjpcO31XJk=;
	b=TI7kXdovNN5mcsOPh5FYqjMTT5F4ukTVgmPQR3DfNsQGPPgUDXm+UqRNWsGNxWn6cZQONS
	r92dcKLRfGlnghduwy+fxoiv6HrnoM5TetRatOEKbN2QYPsDbD5a+TA7ePHfAmuvlESIKv
	3KEgSdu2d4S+33dOC6BtOZeASIFBSB0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2886043CCC;
	Sun,  8 Nov 2026 19:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46B81F008A3;
	Sun,  8 Nov 2026 19:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794165750;
	bh=/7U2bcNPCrBwzjsXKuwnPci/B9bQIw0g0WjpcO31XJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izPXfjvcy5Z5PTMH38DwbpHy37MdWD/Gkhk88EhMJudxjjtACII+bs3s6zLOwJ3sv
	 Zt26IeV1JBnt5IwNa+m8IUZaiwVSM6O/QW9ZFUx/jdpqbBpaDRc9LrQQ+REej01Ky9
	 FNBqLnGlV8lRntIiftb8DB2J2MfN49oh4h7HNs/GZnioMOBqmLKnWPIks506lDy+CR
	 2McJfG0wkVATLszyZJzDBguxvFLYME7B9GnJbf31jM8QmsBCPTwDwcDAaL5pXCH1oP
	 KC/x4lmo4TFG6LeBToeURAVFZisqeC6lLAC/bpSNgseI8pLyYEpVqrIk0hgerVE3mp
	 h716kC/xToSqg==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [PATCH 6.18.y 2/5] mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Sun,  8 Nov 2026 11:22:17 -0800
Message-ID: <20261108192221.114362-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108192221.114362-1-sj@kernel.org>
References: <20261108192221.114362-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jdmdjgzwpyrg9omwt6874izjtxaest73
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CF67140004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794165750-2748
X-HE-Meta: U2FsdGVkX181SpbO4YPrULw1YIK3+Jyw1mgyKGIGvcbz3+DpIVCcitPyU+XeeQI6cHvN2Xc6wFJOG7kcDga+YL8M7D7jslFbnhyfd6UJdjsnuISOXrYwlYPp/6y9B84JixbMX5wBgB5CmXSnNUsvorfQm0wZbpNRw73Tmfb7M1oCziZFzN8dIH1++UcBWcSOclnpb3hPpOkuHXZgPcXsRq3ZNs561vFoA8nBgCWyNg7fecQuEY7t3+GpuncBWNa4n30f4LR9EH2tVP9Ty/QbxBSeFTY30r35qDh8Eh4yDaaef7Z7OqCmJJ6EvLU4Svc9aiCiPFfkMolayM/p5IUr53/DLqm0dDKCYCgxZuO45dfnTlAzXZmlSeEriZnTIDItEynVDJ+DDtB+vfbnpPqbEMedriHJssk9ytdATH4KOUACtLR8s4VbaUlJPz/Oy+dR1j2quECHjdrtmfSgnmKkqn0whPHNNU/14pHC/jSm10YHyR+dqS2+0KYseV/ZlEe6EyvpBzI+oWU0ipdzstAUDrX+gtCBVJLKz1Q7fDYy7woilV0hAmmbWcPvnoJvpDnE5k7kkN1tfQ+M3ixzjvtQMGTjlcr2cAg9/SoJHJnJmJecxOxw05drynRAadUj8n597qHtAbfmJar3fX7nkFPxa6aj6lnroN5CgnCcCumdjwW3VG8xbig9gAj8Bkn9wqQAkPl+6RmAB65XQyyYv5AKnP4jb8pVsQs2TLL7cIlkqbZq8LhA+liS2sc6qL8HQcifBtBQQ59nZl1GQKCKB2edNN66zxIEbGy0gVzkaw7861aH35bWXB0O6aBemHgcvuV6GTN4xYqmBMpEmvUO/4dtBGeB6vLcD4V/E5QUDnEu+wv/WQR8dIKAVefe/SqumDWiDFQdfmpWw4v0ShiqX1U+/IdH3GS3pr8/mQihaF9401r0l/VUYilxES9zvy4b9fpqaDDvnGdd8S1jUzwz2J8
 u7fCYHt9
 arkxTS7l1B6TMwCuf0OOxskPhAMJJ6ZawW2YW/gU9xEHcZ0WE8pk2rCklXZ+9cUrApsfHkuJtgM5MdQcieQCl9C5yWw0CrVkC69iU5Ksqd3EctQ+HJy5y4WXMFJYoJm/7EIlsfUJU+LH1qPYjm4Bgc/3A/Opc3QbcfxJIXjPspNtIcNbXNXl7+VWWzkqwu7MNmT+YgE9UN27OyoZyy7S066LDa7eVnNs7v4IKr07DQVnarDmv2CQId/ue2PKuyQqcRUPgJXqdbBviwNjawlSznoto/vmAFtt+T1RbrKdtN+DDxUysgeoAp7X3wi87USLf663s925aVavPMnLCY+STV1yIjy5oz0aOMguLN2t7UtylqRWXw5s7vr+NSjCgvL8Pca4U4AZsrnLSCIOyN5KS79ia2I5jVsY+G6HZzegwKLjanJuqINsilvPJJKPQUYCLaBKlfiPvmRjPhYVKiyRO7vWkUL0pabgWxwX4UMsbwcT40oR2uxqIxEmazYf0QBzTZhCQ/i8SPOkkb5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When DAMOS_QUOTA_SOME_MEM_PSI_US metric damos quota goal is set, the PSI
delta for the feedback loop is calculated using
damos_quota_goal->last_psi_total.  However, it is initialized only after
the first feedback loop.  The first iteration of the loop uses the
uninitialized value.  As a result, the feedback loop can change the
effective quota in an unexpected way at the first iteration.

The user impact of the issue is not big, because the issue impacts only
the first iteration of the feedback loop.  The feedback loop also has an
internal cap of the quota adjustment.  The wrong adjustment will soon be
corrected over a few iterations.  For this reason, doing no initialization
at commit time was intentional.  It is also explicitly commented.  That
said, nobody likes behaviors that are unexpected or difficult to be
expected.

Check last_psi_total initialization and skip the tuning round when it is
not initialized.  For this, initialize last_psi_total with U64_MAX in the
goal creation and the goal commit time.  U64_MAX means the field is not
initialized.  The tuning round shows the value and adjusts it to guarantee
the current quota is maintained for the round, and last_psi_total is
correctly initialized on the next round.

Before this change, committing a new PSI goal on an existing PSI goal with
goal-only DAMON sysfs command (commit_schemes_quota_goals) just worked.
After this change, the tuning round right after the commit will be
unnecessarily skipped, because last_psi_total is unconditionally marked as
not initialized in the damos_commit_quota_goal_union().  This is an
intended tradeoff for simplicity.  Skipping just one round of tuning is no
problem.  Meanwhile it makes both the code and the behavior simple to
understand.

Also update the quota goal commit unit test for changed last_psi_total
setup behavior.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260902002725.108635-3-sj@kernel.org
Link: https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org [1]
Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Tested-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org> # 6.9.x
(cherry picked from commit 29c6084658af41b5b1fefd873d26d441830ced34)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4c536a9b958e4..f2666770b5436 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -348,6 +348,8 @@ struct damos_quota_goal *damos_new_quota_goal(
 		return NULL;
 	goal->metric = metric;
 	goal->target_value = target_value;
+	if (metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		goal->last_psi_total = U64_MAX;
 	INIT_LIST_HEAD(&goal->list);
 	return goal;
 }
@@ -798,6 +800,9 @@ static void damos_commit_quota_goal_union(
 		struct damos_quota_goal *dst, struct damos_quota_goal *src)
 {
 	switch (dst->metric) {
+	case DAMOS_QUOTA_SOME_MEM_PSI_US:
+		dst->last_psi_total = U64_MAX;
+		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 		dst->nid = src->nid;
@@ -816,7 +821,6 @@ static int damos_commit_quota_goal(
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
-	/* keep last_psi_total as is, since it will be updated in next cycle */
 	damos_commit_quota_goal_union(dst, src);
 	return 0;
 }
@@ -2171,7 +2175,12 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
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
-- 
2.47.3

