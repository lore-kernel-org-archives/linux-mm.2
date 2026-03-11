Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F1AFFD88D8
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 02:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767E06B0088; Tue, 10 Mar 2026 22:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720206B0089; Tue, 10 Mar 2026 22:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639726B008A; Tue, 10 Mar 2026 22:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39B596B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:23:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A06C8BA2B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:23:03 +0000 (UTC)
X-FDA: 84532184646.01.E9D57C9
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id B22FCC0004
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:23:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k1dTD+6f;
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773195782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=l3bn/m31byp+qpEOiKGJpiuvrWWhUbwbTqaydo34cqg=;
	b=Fi17mMgvS6d167Hwl+gjEljCehyd9D0QFLLRqyTtjJYYIjaj9sBJEhgg89V9nZA5dyjtix
	I4QHb9e2bEMWRtu7e3rxGQwq3IhNTo8hOkKgdF/Gpk5lGpzSuXxTBiKtNFQ2XwKP7hHrea
	OPGSaNbL4K9aFfKD9Hg+GDdXUEEHDqA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k1dTD+6f;
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773195782; a=rsa-sha256;
	cv=none;
	b=exkIPGcW46eG1FtDwGrcG/jKCY6Qlg/nfpLq+1uVi1TmZJq/j8sP79dnl+nxWWjP/Q6R+D
	mksckkOsknkMjqkibIkiKZV+HznjmMTm9cTGYPzHdbOqdHyAnBTd4ZYaZCnbO8sNxecuVi
	Nqta9+GuJCzTh9jozktBpBeM8rZOWYg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773195779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=l3bn/m31byp+qpEOiKGJpiuvrWWhUbwbTqaydo34cqg=;
	b=k1dTD+6f/jmD5TGwctUYoDgtbZlOQSFL2mijBoSPhV9LyGnSl/86xnHHI1zOU2ps3rox/7
	AoPOT02+tYhzREC7wkzxpjGgWfcZKIwZupfrWxlGR3DYLPhx5e+N6pGtSQtFchqlQ3kCal
	t/sRDjK5eD0tu59nN5K/0cB8HsTNMMU=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v4] mm/swap: strengthen locking assertions and invariants in cluster allocation
Date: Wed, 11 Mar 2026 10:22:41 +0800
Message-ID: <20260311022241.177801-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: wanz1ndxpzcxninn946xz99rcpdp45xi
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B22FCC0004
X-HE-Tag: 1773195781-400413
X-HE-Meta: U2FsdGVkX18ms1ogZueR09SIuYbRLGDkgAycDRkKVaToj/DRs5/gAEOr9ix5Y3qmwpJHZl4kLVxqqwyEU7WH08w39u5p8NMrym1p4TU+lpalZgCbvBC2w/qa5NI/HwbVcUrnCSvDpeejKeffoWdZ1bcWiNlkdEEKzEPOdS0tG9C1FmH3QW1tJeKpoTzCbN8uwBN+zHg7Oz2G3VW2mOJyTU7vbHz5+iu5oHJE5h1hIlRd5cpeGz1wPRNta81Vym+5eWZvxHLkFIuP4U//1azRCU0coMmqSo+jCtS8x7xCx5LDDcyeYJ3erqQlclmdyXqMf1IVbsUCvAuHiQtjvRh2b+ZmL7u4TJpEDBXNmzz1NWUAPIWQr6uuRoXsN92jYegF+VPkha8f8frNK625z77pwRe4qdxJqtZB3FZHF3IERgWKBoMYujb2Tjr6y7CTjr3BE/dShfGtsvWAD2mIYQaJGXqxmyVdXKBQmtmROzRf35v9HiCDgo0Rtd2imLnvzp8a73vs6s6lIRl76urSVC6d+b1zqpSBx2SKmq2FDkDofkG5jeBLLX0T+KNe2dSfheLToSkBTJEZfvzVbKLmgGWwNM+4ptSuwPvXM+KO+/hjhY27Ntt9uCJctv3AM0TBD3DtkT7L3Vx351l+t/SKf41mrkazYOhvdWjYPZeSoODSKY+jhpPb3BFKcoOr3XeKbJ4L9xLentiXqDhhk3pDlMlw1guyhYmULyNUuoVQML2iWWUvMQ/V4o0Gc6Rh1ionwsAbB1p7GHuUH9ZNTQKkcX1h2YW8AloaQhzoDF0A32dreub4QU2/NO2Nbk6cEeguJ6ja4KFc7sstMEjIwdirwQZomU+vrxIkerArgpDgV69r9Ksz7sITY+XkkB42ew8QiuY9bto8JBYa0fofTZAek9yGZS5uJ/XCg0N5DlBcfdqQkwSl8Zqqlz0mHtgwTiTRk6j59VUIWCQ5RlQJwICBEWr
 RMkmWrM9
 pGFQuKFdcRdwY/y5vvJmJk6BpOH4XN200i5KNIouiMs30nzmW6ZKhcMIvN6L/o0yhbQor1hlHO2/Q+bTJQoP4qm0wg3UViFl4wAwsTCgrSiNQ5oChUJaUZlOgjiR+miP7O99WwQ5skSt/wXbYwesD3CKd1md76K10WG4SM/FG4poeTgh/qIl+SIResQrRF+9W3kzjzkaAXHky/5qQuNRkNQYKWJpCy9Wq8ai7/3TX1qXoBa3G5G68qZzPBA==
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
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/swapfile.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 94af29d1de88..e25cdb0046d8 100644
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
+	u8 flags;
 
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


