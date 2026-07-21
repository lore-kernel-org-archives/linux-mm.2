Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 820CEC44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845F16B00A1; Tue, 21 Jul 2026 09:56:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81DAA6B00A2; Tue, 21 Jul 2026 09:56:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A4C6B00A3; Tue, 21 Jul 2026 09:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FD036B00A1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:56:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4FEA120196
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:56:22 +0000 (UTC)
X-FDA: 85012933404.21.A628D0B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3D5E010000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:56:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E1MxEouC;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784642181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wx1gw6+GLyRkHpuisMzwe8oKVgfcuzn07HyWYBTylME=;
	b=G2g87muS8Fhewd1tyskWSwWb2oGDoMq2FfRiYSLMr3QSkW7K6Y4Nsp7PgRauPSCYPAUlks
	Hk5PbPXD5k3Q0jkGxQq2b0Y65c4g6CiYqv+aDCkj+jG4tdpN1q9pCZHFOpY0j0wzIKx24t
	pUZ9/w7kQee88yNSSg9Q1D159hT2zRM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784642181;
	b=h2jCj0VimLzEhT9romBIkeKaqOsmZl/yKe4w4B6XpVKSYiKkXThBeQd1Y8tNR6RuHuBbF3
	M+ybDROTsFH+CrCQEZzPsbOzRP2TQ+l9wvG7IyITLXl1TR2UjFxEG9wNVc17Pj4FAoeNmD
	oaxPpw/d7fmvXed3o03yRdL2aAPidBE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E1MxEouC;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CCBC760204;
	Tue, 21 Jul 2026 13:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F521F000E9;
	Tue, 21 Jul 2026 13:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784642180;
	bh=wx1gw6+GLyRkHpuisMzwe8oKVgfcuzn07HyWYBTylME=;
	h=From:To:Cc:Subject:Date;
	b=E1MxEouCn0tQO0qIvUIxCc4Srw81qZl/tXHF42jtBKAUf3G6f1MyWjNpVxJFaiR1q
	 03z3tjrgIzEgkzBe+dYBDRWKqaL6K/VMb5p8bRJN68W1riaM5QtBNetqwbOOTUt6Xc
	 NcRstO2h6xuU3y8NkSSK2ouVf6Ixg37uwVMZcR4xwITYgSgtb0XEyCsyZh0su974Y0
	 4W01kYWVpC6kywRwk8SMwi6EZ24+KALq0zLZTLiE3X/ngMGG9h4jZY4cjcgyzPSIWT
	 2wyxcYbQQam46KtdRw9OmbPGoSKsS8IPjUMgp/a6yGZzYcDZZbcuosxCJ24wuAtxcs
	 srkR/GMEzelOQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiahui Zhang <jiahuitry@outlook.com>,
	Honggyu Kim <honggyu.kim@sk.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3] mm/damon/ops-common: prevent migration fallback to non-target nodes
Date: Tue, 21 Jul 2026 06:56:05 -0700
Message-ID: <20260721135607.251869-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 59cmfx3bhmtqoz6txrfhur597iar5xda
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3D5E010000C
X-HE-Tag: 1784642181-182516
X-HE-Meta: U2FsdGVkX197EMjorMyL9GvBuFFyY7IqDLqyorHAXEBTkBwIsRZpqforKTEb7n1RmgG1Q89Ys8TsL7nc1pA8Ka+XLR8tueoH1BvXKRH49A2loJbKXmQatXqSb1BGen1Mng7UIOGEA1LlRicAkn3QO2Cf2rVZrRSwT+6J6vxTzHadMkCjBoYAQdBuV91mRr33UvIeCPr0444Qhx1NCRI7N05ekPL2t78Jbi9PIVNSLAxElEY1YviA4fDgxIWHeQlqQ5/xOXJm2f98mDaNrLHBsFB53T2efR488kXyoklprlBlJz4WF2IEF7bLRX1u2GS6mDrxBLWFaK4plBXxF/9HDJaKKQqL8PFf1xIoih3C40JcYjo5ILU4INW0Bfn1b91qL+Mu3k+lc0oR6jzvftlndbHno3McJAsmJEEj9ECRNoyG1bp2lJV2iB8nZTfeBpxI6O3qI/siyy3buL1NFYFyAyLDyFd7hyvXpyvsqLDL/52hHXTSJ5Sk7B9sDl/6JzM8MA6pZOHDI+1QJwXjKUoqUtZXeAYpCqdfiBuQ+zLocd5+TLG8lVzm/r1KTEZRuWofACHq6Gk+urq25PmODeD8ugGeIfemsTOm15d4L0iQhnl7U5M7HSctlmLT8+8N/8qNYNT/S+IsB35DrtYEQvF/aQa28APu2S+PIu4mHplrKymSyMeMlUUAoVjUajh/USFYVMlbyh0P6PuxTPxs8QhYgZXzCzlZ+9ilpqmUUTNLK8PBZvyZsRxww9PXkHyLCSy+i6tAc1DROQTD0YbKpz0G29yszLgkdBCeaZDgRWBcFl+tC1o8WPvHhlRiBP7VS2OpAslw7CXl9kNSO+lz493LU71T4yYfZktEhRidR+Rm1RWHbwaEMdcJKXYvHScnUkJWqM0Ozz606/dN1ATGD6lE1iv5WLrYoje5qFSpUVBMu/wKXn208Q4tUATnQ2WynswGDHZewl2eVjgpKfCXBCQ
 +k8iTi6T
 QU1aCjTGYrncS8hybJpdLyJxfKeyz2VXC1Rb5BYGAJn/o8EW78mAnp2Xis4dIx6bPThPR26jHimxRh56Hz+zrv9zZBoJVYPErmLbrMsvZJnocSFGkszIgs+N6swS89GmE8/aKUQyvqrkLK3N1RAMFvhdVm6XOCzdggnhKwbZiVyWPu0aBV0XPOPlUe2nDuemg61poBMh8GQH1klBuAiaRi/R4qjFl95H4GIQuLs8VsaSFApMRkSjkK2RLbIvfk3aLSI4EwxyIhYnmfBP7YlmVs+AdDqssEUOnkbdVAzEk0bLcPj2I17pH2xKLxtQT5qqXiGJOLFyNxlb1vzBuLiNT3jYCSTLNZlhOTnZSgsXH+KN9m2BaY1grdqhvDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiahui Zhang <jiahuitry@outlook.com>

DAMOS_MIGRATE_{HOT,COLD} passes a target NUMA node to migrate_pages().
But alloc_migration_target() only treats mtc->nid as a preferred node
unless __GFP_THISNODE is set.  Hence target allocation can fall back
to another node, and migrate_pages() can report success without placing
the folio on the requested target node.

Consider a two-node tiered system where node 0 is a fast tier and node 1
is a CPU-less slow tier such as CXL memory, and the user wants to promote
hot regions from node 1 to node 0 with a command like:

  sudo damo start --ops vaddr --target_pid ${workload_pid} \
      --damos_action migrate_hot 0 \
      --damos_access_rate 70% max

Without the __GFP_THISNODE flag, when the memory allocator finds that
node 0 is nearly full, it can fall back to node 1 without waking up
kswapd.  Then the pages allocated for migrate_pages() are still on node 1,
and the regions that are expected to be promoted to node 0 are only moved
to different physical pages on node 1.

Meanwhile, both the mm_migrate_pages tracepoint and DAMOS's own
sz_applied statistics (reported via the damos_stat_after_apply_interval
tracepoint) show the migrations as successful, which makes the failure
practically invisible and hard to investigate.

Running a demotion-purpose DAMOS scheme alongside the promotion scheme
does not fully avoid this either. If demotion cannot keep up with the
promotion rate, allocation can still fall back to node 1 during
promotion, and the same misleading statistics show up.

Make DAMON's migration target allocation strict by setting
__GFP_THISNODE, so that a failed allocation on the target node is
reported as a failure instead of silently landing on a different node.
This is consistent with alloc_misplaced_dst_folio(), alloc_demote_folio(),
and with do_move_pages_to_node(), which all use __GFP_THISNODE for
migrations to an explicit destination node.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Jiahui Zhang <jiahuitry@outlook.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v2
- v2: https://lore.kernel.org/ <MN2PR02MB665479119535A1235D69F125B5F92@MN2PR02MB6654.namprd02.prod.outlook.com>
- Collect R-b: from SJ.
- Rebase to the latest mm-new.
Changes since v1:
- Use the mm/damon/ops-common subject prefix.
- Describe the observed misleading migration accounting and how strict
  target-node allocation resolves it.
- Use the formal author name.
- No functional/code change from v1
- Link to v1: https://lore.kernel.org/damon/BY5PR02MB6642F4D1A8BA92BFF3A034B4B5FF2@BY5PR02MB6642.namprd02

 mm/damon/ops-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index d7d7f100389b0..e59f77eca83b2 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -312,7 +312,7 @@ static unsigned int __damon_migrate_folio_list(
 		 * instead of migrated.
 		 */
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
-			__GFP_NOMEMALLOC | GFP_NOWAIT,
+			__GFP_NOMEMALLOC | GFP_NOWAIT | __GFP_THISNODE,
 		.nid = target_nid,
 	};
 

base-commit: 86e9ddaf85a3e872e81e1946ed410ef7f5341e16
-- 
2.47.3

