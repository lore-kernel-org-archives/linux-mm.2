Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D378C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402C36B0099; Tue, 11 Aug 2026 16:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DA626B009B; Tue, 11 Aug 2026 16:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317A66B009D; Tue, 11 Aug 2026 16:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 111786B0099
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:32:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 077011C0852
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:31 +0000 (UTC)
X-FDA: 85090136502.17.B69124D
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 68A77140004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jnixA1Lb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786480349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iz9pq9nN+pdRG2ifYD8weZHP3Mu9osKE7mH+dgefD54=;
	b=3Z7OhF2IuLn1Qz2EJtQWjm+eg+ri/IbCRNJGcObxLuk0adW1waPI0ssPlxZmtOnFNEE7uv
	QfFTHwDqvIHu4r0RCMHsB/SoAHToxSZtragfzHDDCIluLF1gPdS14JEq3WYz4xR5JZdkCa
	ZnzeufzHZEsbfFgPFd0n5gAqv21mmnU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jnixA1Lb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786480349;
	b=GJCTycmF/0eWcNrdBZJWv/FN6tZEkwdVgpGCl+VbK++I3IZy23VXdAYzh1HbKwZVidMsGj
	VlfXw3vyftBdsPfhYBxTX/7HgF9VM4gp6gbnl1Z9b0LwRo8JW2Ex/KGX67j/zuqevw+IiB
	uGMWbLAUJhVkwjMEiyaVhrbbrt7K5Ac=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iz9pq9nN+pdRG2ifYD8weZHP3Mu9osKE7mH+dgefD54=;
	b=jnixA1LbmTaxkzgar3JKuaJ4k1vUWWyf7VEGK8rae8kCoq1f3oexACKpQ7r+bDe6+dKL3K
	RqBk78yFC/7Y/qhBF1y28UcuSmr0hRfRkmOknSvcbVpGSio38zp8SRfhMHhp6BWZSAcSu7
	1Am0QQuHpJuo03Fodg5Ph06odqaUi/c=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] memcg: remove mem_cgroup_shrink_node()
Date: Tue, 11 Aug 2026 13:31:57 -0700
Message-ID: <20260811203203.3456029-4-shakeel.butt@linux.dev>
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 68A77140004
X-Stat-Signature: zurd3h7sa61uhh9bbuoe3jnt49eipt9a
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786480349-671283
X-HE-Meta: U2FsdGVkX19CsHZLNv89zV3499W/zZdVXSgmR6UPGKK+wypIsFY0WHXCth/FEjYju4LYG19NMx6Hx3NnJQn4CKFAfhbr7YecUyKfebKPoY26bdlRRtj8SdmUzNIurdyfqby+ZFCu6YmmTm5A2aTe24ZaCAUfGVv4i/ufQQ8xf8EXgcnhx/V/9pZNPxhMqbKbkfKKk/b0CmxoOtA0ExfrHA7XTUSa8yQsHOMRmG32NNqB1Vk/rJGwOWXWlWx2y8BcuJbIZ8GmNwAZ/SW1VXuB/IVVFRp+ONlYK9+EuAE0dOV0uCacmQ1GE6i8NFEbh4rmHgAHzUVm/KREDsgW9Tir5H6n1yYFKxzPqn6gMitXY1XY6kyB3K+FDui00lYVKeQ/BhOXlCMb7fnXAf0infZ7xfJg7mG2uNx9mH61ud96Wai8BSuB+fTJC1lJyMmUyjI3fuclLSuBtZCeIEYwjZxpM9oIVyKqvx2SGnbUvJ+hR5Ukuyvcu3STCbJSdh+kKwYXXuvPwe1WJm+GuO251SVD3L3VjbWEC6r6700P4w81nvh9dDdOTtbbKehE/6hn2eSkUgzTDwlx+WGqM9R9MW7IBDxCQHqYEKuzV88PXpe+n1tPojLy/thatg5pUU0vFzUuMjquYxNJ/vhX8y6yT2NGSoVwSANsBjCuumYPnXAuMoiHWHcZ+qx/QRpjtdNjfrOQzKUYf183NOK/dD3JewWJk1V3pG3lrZQSM3qUanhvNSWidq69iYcdGthxiZWO+L9mQGOAaYUVK2nw/0eW1DYzBXvaFJEGo5WDTL+ZZLbi9wzFpVTNoLp5W4FckOE+ZEp9/bem4tu87l4r4h29LKJW5+C/A/+YDX9erRnBM3qF2qhcnqL917qO6aSHbzac8d6YczuhLrzKcHFRCsTbHJWAixIsoa/RTus++h8aS9Sh0w/2vKQ4HyRLcY5tHRzjkmIl+U2SMBjP1yJc5AMXJ2A
 reoXaJd1
 jnGcIHCyOp/8Gck8B9j+o+WUukxf+INm0prCAQEaUXya5TT1LhAM828G5gEPu9zLQsxe+S+EskZXyaS+4EnDjT9ncqf511g9FvcebyRUo2lEz/HKRPVsSYR71I0NjX/q8RRqqqMG8IKY+9TfCLkIW8GjwtrMvPO6sCjc0+qvD7hhK4bQ69sWkP+k2qMxmaCrenoaFtFbLTboiBLmLQ/kiKmDIstzDAUY5+FWf47vyVxtW9h05JV+oJi4HGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Its only caller was soft limit reclaim, which is gone.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/internal.h |  4 ----
 mm/vmscan.c   | 41 -----------------------------------------
 2 files changed, 45 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 678ce8d03515..b2315bdb7350 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -85,10 +85,6 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
 					   int *swappiness);
-unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
-				     gfp_t gfp_mask, bool noswap,
-				     pg_data_t *pgdat,
-				     unsigned long *nr_scanned);
 
 #ifdef CONFIG_NUMA
 extern int sysctl_min_unmapped_ratio;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 032b14793d91..790b50c78a2e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6795,47 +6795,6 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 
 #ifdef CONFIG_MEMCG
 
-/* Only used by soft limit reclaim. Do not reuse for anything else. */
-unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
-						gfp_t gfp_mask, bool noswap,
-						pg_data_t *pgdat,
-						unsigned long *nr_scanned)
-{
-	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	struct scan_control sc = {
-		.nr_to_reclaim = SWAP_CLUSTER_MAX,
-		.target_mem_cgroup = memcg,
-		.may_writepage = 1,
-		.may_unmap = 1,
-		.reclaim_idx = MAX_NR_ZONES - 1,
-		.may_swap = !noswap,
-	};
-
-	WARN_ON_ONCE(!current->reclaim_state);
-
-	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
-			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
-
-	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.gfp_mask,
-						      sc.order,
-						      memcg);
-
-	/*
-	 * NOTE: Although we can get the priority field, using it
-	 * here is not a good idea, since it limits the pages we can scan.
-	 * if we don't reclaim here, the shrink_node from balance_pgdat
-	 * will pick up pages from other mem cgroup's as well. We hack
-	 * the priority and make it zero.
-	 */
-	shrink_lruvec(lruvec, &sc);
-
-	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed, memcg);
-
-	*nr_scanned = sc.nr_scanned;
-
-	return sc.nr_reclaimed;
-}
-
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
-- 
2.53.0-Meta


