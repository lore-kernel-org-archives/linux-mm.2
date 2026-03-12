Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9D54103E2FF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 02:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F25216B0088; Wed, 11 Mar 2026 22:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2AE6B0089; Wed, 11 Mar 2026 22:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB4376B008A; Wed, 11 Mar 2026 22:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CA3A76B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:30:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 703D914068A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:30:45 +0000 (UTC)
X-FDA: 84535832850.21.4D928F8
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id A15D280012
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:30:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YuxXe+Gp;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773282643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Qgm+4fBfeILAFrGgPSJQdkYHwRBAjotjsIQctASgY6U=;
	b=XOFMLlGJ0Yx4o6v3rKrkGaLSnEga9T9Ojs7eyr+D0pIOv50lJAaPorReLNIFZVFDH7Uvnf
	z3GIGVpdJZAd6fJahL53Fd3WclcdqC1Mlx3SIczcJeuyEQNvkoPb5K+VA6qyIXPTnbJcR+
	mP5kZvo1bqIKlbE4/vKKnZ10BVOV2xY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YuxXe+Gp;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773282643; a=rsa-sha256;
	cv=none;
	b=4OGJS5XvTasxL87jLzN9nUPkYt9Wgle5Gb295v6eTFeZvSMmGJNDStn3hgsf1PU7FkoHQu
	OZ1vXoMx6m0kcESgBAVOUQZEf+xgL9m+hKwdPMkRyAYzb2iNZV7sEutTYQc9NSp+TAg2xB
	uXt9S1y3qcfctFD0COMCXb2tTcicf6E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773282641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Qgm+4fBfeILAFrGgPSJQdkYHwRBAjotjsIQctASgY6U=;
	b=YuxXe+Gp80E4cwYpKmKe4p781rH+bTy7rSce3M6WPYkECWPC5k/3RYB7mXjIBEhJ9CFAxO
	s65Pb3EW5O6uN7yMZFcQBfWZb8loGQyAYOZQj2RH5D2kWWXF71+Ka0iGFRK6nu9nbW0elE
	suJ1NJDQtqjkjm9kMgRzSHmzGN56z1o=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Geliang Tang <geliang@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v5] mm/swap: strengthen locking assertions and invariants in cluster allocation
Date: Thu, 12 Mar 2026 10:30:24 +0800
Message-ID: <20260312023024.903143-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A15D280012
X-Rspamd-Server: rspam07
X-Stat-Signature: rdocguwqsgu3h1i637j85ijd1ieqdh9h
X-Rspam-User: 
X-HE-Tag: 1773282643-906662
X-HE-Meta: U2FsdGVkX1+0bAqYMruCXLhwSy65kkyBmFhKL62n35hwuSutE2u72EARilF0rS26mfg34nYwFQfwONX1Axnmw2EGZht4qqfTRg5MmSBqzP7HOBlAe+OnbLEIqjGgSh265H6ZTwYqOXnglRQDwk9fOFuCU7Dtd4erzzUt/j9hK/n2ObdISisgWUGWkFpZOKVdlvKwyqUEeCEbMS0lNo3SIDW4ulkoyEuwmr0uZnmFNch6ijlHqw0/bZErcFfw8XWvGEqTL7OhxdUidKBy1+mDUaxSGhVH+xMXnwg2nVYMT6fH1btvV6K7d7fEXk6KY9cy38nY2975jSCKoZ7z0qfZImSBuN3GihyH0VNqytY56PXpKc+nKO1M7dijjWY+q2yqN4o7uO6uVl+kHd4eF8RBiAicIzBC33jEe99WRfelnUYwOSWR5kj6+kXboYD8DExBZriG42Aj7d4cGFhe+k+ZhNs0gvbtZpiSw0d5RL/KjsPV+hJq8eP2x0kgMj2X3XVHwJEHMGi+HYXI/jk6MwA0o4vxSf6Rxrr6lQNTNoHp8IkyPNn6q52yZl1Fwd4IGCRItJRd/elLQOcsKaSsfaJGHa4svz/sBKNpRzVAy+SZRascK5pOKyuWti2jQdmVbjZc6BJ8L9k5um/gSSTbAuNw+eCNODpsVkNSSxVFjTIHwM8pGpG6qyavyI1eMJf0SLLqdQFaCzHKPjMhj1vcbVFJzSt+ULGMNKnW1c6EP2O5K9faZLBcUQDkraqzDpOGyfXFngB3XIg+v8jQkxzPgS8knqLSbUQX4SceWZX7z66QiGnwW+hqK+esOXGLSsBXIdlDQlur2zjuNKFcxrKKVFFl+3jXV4pTJMoNNvqmHcCY17UvtVaxaWJzZwqd7xZx+pZ3NWIE0tEChq9TlY2SKHQB8k2h/zQl1wxiRsc1/oudD1bIfHn/3BMW3zDfPJcsjBxyvaQIr/0/Horbwoj0g7O
 JrGWIg3i
 vEMjXpzzobX94UnWSpomrWouy/cbi7zKC7JtTIhSfxLoOQd6XEVe+iBburhVxL3mdJaIYEqM1o4YMYBNqkx3CyIQfhP7JZKG9WeOW0CPFw5DNJw0jLgDwdYbBenMdp/qVHBPUOvlz+xBInbATHO2yLK+wEPip3e6CjazNcUs5GwOdAFoxhqCkV15Akd1TjoRwj5S5+ul/AJLwY39FG1dd3Hd5jDxtBrBgK6BXI0Kr9trsfwZame6BbcK85A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

The swap_cluster_alloc_table() function requires several locks to be held
by its callers: ci->lock, the per-CPU swap_cluster lock, and, for
non-solid-state devices (non-SWP_SOLIDSTATE), the si->global_cluster_lock.

While most call paths (e.g., via cluster_alloc_swap_entry() or
alloc_swap_scan_list()) correctly acquire these locks before invocation,
the path through swap_reclaim_work() -> swap_reclaim_full_clusters() ->
isolate_lock_cluster() is distinct. This path operates exclusively on
si->full_clusters, where the swap allocation tables are guaranteed to be
already allocated. Consequently, isolate_lock_cluster() should never
trigger a call to swap_cluster_alloc_table() for these clusters.

Strengthen the locking and state assertions to formalize these invariants:

1. Add a lockdep_assert_held() for si->global_cluster_lock in
   swap_cluster_alloc_table() for non-SWP_SOLIDSTATE devices.
2. Reorder existing lockdep assertions in swap_cluster_alloc_table() to
   match the actual lock acquisition order (per-CPU lock, then global lock,
   then cluster lock).
3. Add a VM_WARN_ON_ONCE() in isolate_lock_cluster() to ensure that table
   allocations are only attempted for clusters being isolated from the
   free list. Attempting to allocate a table for a cluster from other
   lists (like the full list during reclaim) indicates a violation of
   subsystem invariants.

These changes ensure locking consistency and help catch potential
synchronization or logic issues during development.

Changelog:
v5:
According to the comments of Chris Li, add the initialization code
of flags.
v4:
According to the comments of Barry Song, remove redundant comment.
v3:
According to the comments of Kairui Song, squash patches and fix logic
bug in isolate_lock_cluster() where flags were cleared before check.
v2:
According to the comments of YoungJun Park, Kairui Song and Chris Li,
change acquire locks in swap_reclaim_work() to adds a VM_WARN_ON in
isolate_lock_cluster().
According to the comments of YoungJun Park, add code in patch 2 to Change
the order of lockdep_assert_held() to match the actual lock acquisition
order.

Reviewed-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/swapfile.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 94af29d1de88..de1c2203436e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -476,8 +476,10 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	 * Only cluster isolation from the allocator does table allocation.
 	 * Swap allocator uses percpu clusters and holds the local lock.
 	 */
-	lockdep_assert_held(&ci->lock);
 	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
+	if (!(si->flags & SWP_SOLIDSTATE))
+		lockdep_assert_held(&si->global_cluster_lock);
+	lockdep_assert_held(&ci->lock);
 
 	/* The cluster must be free and was just isolated from the free list. */
 	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
@@ -577,6 +579,7 @@ static struct swap_cluster_info *isolate_lock_cluster(
 		struct swap_info_struct *si, struct list_head *list)
 {
 	struct swap_cluster_info *ci, *found = NULL;
+	u8 flags = CLUSTER_FLAG_NONE;
 
 	spin_lock(&si->lock);
 	list_for_each_entry(ci, list, list) {
@@ -589,6 +592,7 @@ static struct swap_cluster_info *isolate_lock_cluster(
 			  ci->flags != CLUSTER_FLAG_FULL);
 
 		list_del(&ci->list);
+		flags = ci->flags;
 		ci->flags = CLUSTER_FLAG_NONE;
 		found = ci;
 		break;
@@ -597,6 +601,7 @@ static struct swap_cluster_info *isolate_lock_cluster(
 
 	if (found && !cluster_table_is_alloced(found)) {
 		/* Only an empty free cluster's swap table can be freed. */
+		VM_WARN_ON_ONCE(flags != CLUSTER_FLAG_FREE);
 		VM_WARN_ON_ONCE(list != &si->free_clusters);
 		VM_WARN_ON_ONCE(!cluster_is_empty(found));
 		return swap_cluster_alloc_table(si, found);
-- 
2.43.0


