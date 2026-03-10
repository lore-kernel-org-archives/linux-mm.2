Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17DD0FCC9A8
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 337986B0088; Mon,  9 Mar 2026 21:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F1F6B0089; Mon,  9 Mar 2026 21:57:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B9F6B008A; Mon,  9 Mar 2026 21:57:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 131316B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:57:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5F01B7E92
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:57:33 +0000 (UTC)
X-FDA: 84528491586.02.8ED044C
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE89EC0003
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:57:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pu+L5Eyv;
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773107852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lhCendF1ag04y4ryVwjZ9A46FeZAk4/uF0tZKAzQtkA=;
	b=IaWoO2LoA1iXh4emZrxoHzwL9BW4Jae6b4UcNmTWDcfsDOy734RryQvm6VBPQaWgW1HcKn
	BKV4l0n6HDJdhgen/APzSSQbcb7OwceTximIL/F+RWGYX5VPnoTFDmJc2M1r966aVRuZ7U
	JgGqHQ6CtkfGl7ajOOBetxuXSprKHHo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pu+L5Eyv;
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773107852; a=rsa-sha256;
	cv=none;
	b=R/2yDGpKscVNARS6y9uW+Fj9QW/zronBbvpPgeMvpTMZyhJTsWKvPepQ6lcMj2Hs7hsLfm
	yAtOAsFdOi3ZFJmsjXvjozGaiWojiEXMbUPkkNd9R9u2DG+szVBqxdocx6PIuA9oFVogrd
	4D0eeT1eqvmMPdjsWTLbx6zQRlF5D0o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773107849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lhCendF1ag04y4ryVwjZ9A46FeZAk4/uF0tZKAzQtkA=;
	b=pu+L5EyvyIEt9aADEo2n5oxPSahSV9YISkB8IMQrCs8Rp8h0v+wS19M9b+mNf5A74plZp+
	RZ+XCj7DLtGy6TkyavFIo8QiwLAMnigUE1YErLrg3H4YZwBo9wpXdGh68jIfRY9oPAwXor
	HRhL5Dl0XMW6YtY7I8Qe7WrYL6yZpQY=
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
Subject: [PATCH v3] mm/swap: strengthen locking assertions and invariants in cluster allocation
Date: Tue, 10 Mar 2026 09:56:57 +0800
Message-ID: <20260310015657.42395-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CE89EC0003
X-Stat-Signature: 97aqojxfxd473zjbmjy4x5e6wek5izis
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773107851-558557
X-HE-Meta: U2FsdGVkX1/Cf0xn5GHH5oLWUmcdPoXRXTFEnR176ia8kzT+HcD6mGDINWwFbny9wyHjWGVWzY7ozKrGnLCkON0Y3Jsi4DyWw29D1DUck4qyRNifKIhPPKJ9wwDh/GQdG7c23nFikblefS7geHcaJGygSTx/e1i7fKTpOvhxVmFOZUU425inzV9VD2pMtoBWCS7X7C2uit93cuo0shL3drYTOvm13zPEgJRWkGCtQDsXj5FG7MpSRVraG+MmW7VO9m+RMjqdXKSngHFrG+PymzlB0j/bICtYrgLag9gyvxDL1xMdSrkzvndxtwrEWzL5yP9DKfCzgRzhKA9UH8LxJOCxg+nsStpzhpcVe+rV1PbUlfXYf1meQtAe/xJm2tauiFwCORukijVAY7kxYiJ7ROkHG4/v30TO34PTEezTJqBLKVbBbFya+6R+uRTF+3AnE1znxeBDsx4xfg0D7BcDv6px0JfwdjXrBHsr7rCBmgST2EnDFz1lvl/ro1iIh4n2Vh+wX6XCZdHkrU6tX5Z7fsrOSbXXN5zAyqnWEBK26roGqNr2HPdiVrMBjhnyPXBEuNjD4VyEx6ywN6aUBJ8PAwhDq5omktPV/Ac9ziRJ8ZTb4z8HXWCHRlFgf1p44VA0voIMJNeEF+wU3cXuYsKSTntybFOVsjPH+NtBX5Qcw/HQqYettQVQdtm46IZl+ZQfybGIj2d49LgjhlN85ycCH7pK2WU0y8bxHAxlFqXqSHqIBXyatEBldlxwOvCvCAD8FN5fcG3HwfEGojbqfiAIRtCPZgCiZnchqu7HgOGTQAHdsAX7FP1im9bQsFAqwNipJ9zNl/r2wHemRUurtWEAAAbD/NKnR8SoR35K2nKhXeMU9eC75qwaf55b7Pf+aytncPJxXMyFh/q8DIgdd2F22tJAQmSTVbLozUCNc1uR77AD9XIwYrAHuY0YSM9FuB0E86XQ++sKCK/T3jB+X28
 mcSbaFP8
 HrqQ5wzSdLdI3+E5X5ezw4gmvupH8zp4CT6VHm39KP3Gg/bUAL+9wEE3GkM5Z1euZbU7Mr96FwTWxzcWJiBCbNdSPTaZoTqdXI3EKoGwNKFOzKK3adSWFMx/5imP6hFXhIUUGmLNX3GQELut5g/37ihaR4WWWQgr6yiBVmhodHzA7JOiOV2PYP7vfXO4CyBBsVs1LMxY0BbhVLkdlg2y5V/66hT5q6HC1YWYY
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
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/swapfile.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 94af29d1de88..4e0fb1ce5245 100644
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
@@ -596,6 +600,9 @@ static struct swap_cluster_info *isolate_lock_cluster(
 	spin_unlock(&si->lock);
 
 	if (found && !cluster_table_is_alloced(found)) {
+		/* Table of non-free cluster must be allocated. */
+		VM_WARN_ON_ONCE(flags != CLUSTER_FLAG_FREE);
+
 		/* Only an empty free cluster's swap table can be freed. */
 		VM_WARN_ON_ONCE(list != &si->free_clusters);
 		VM_WARN_ON_ONCE(!cluster_is_empty(found));
-- 
2.43.0


