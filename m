Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76C44E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 13:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76AE6B0095; Wed, 18 Feb 2026 08:06:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37896B0096; Wed, 18 Feb 2026 08:06:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D076B0098; Wed, 18 Feb 2026 08:06:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB92A6B0095
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:06:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AE151A0119
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:33 +0000 (UTC)
X-FDA: 84457601466.09.92E2333
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CA8F5180018
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SliiAj8d;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771419991; a=rsa-sha256;
	cv=none;
	b=8HuIQz56MoexZg7/LzJDiau8wzfArOPZmrXWjaPswmNWsnBnveEgUAkbXvj5Kv9Mcz4xJu
	t4O+EOoLJOKr+nY+FuPiXIpKyHLujCKDE9dXmfMCWUWN0ftT68Qx2w/EVQL4O2ObFn14I6
	T5YPrapsMHQ6cVYevPnVLYl9oWNCiJU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SliiAj8d;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771419991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYMadyw9Oisx7JvpaLo+POoVi3HmYmhrCq8poEzmXfg=;
	b=j76+ltPqTcDKubdxt28vXEIT5KdTltAYhcUihiBJiPiATq5Nqx3uduWlFdxtbSFF4aicEc
	H3zfVxQU7yo+e5oTFqgF2D0NSz4sfsFi1TKMKvhWG4JTVcKy3R9PROvljpdOfdYyGlX8Cb
	I30DTpMQP8j8yhzdOQdVZXejcZ4iqt4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DCF761857;
	Wed, 18 Feb 2026 13:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5F0C19421;
	Wed, 18 Feb 2026 13:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771419990;
	bh=qtazCUkOYOlScZhrhSiUD36Z6NbiWapLYHkDhdIiMZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SliiAj8dUMQfG3IHGC4btALtPmki0r+bCbMH5vtBfxFCPD9Z+a0YUaIOu3RlRym8p
	 AKF3fQd87fsmjkI1c4Kqc+2Apd9Bx5wHmIFltax6cn61OcIYSZzbusKBsUPQEa0IAP
	 N5s3cajxSH0Xa6Mw/oh+nadob+LWF6VsnVyP7wVn/IfSpLX3ZL1lPVql8i0IwUj6hh
	 lEt16BKcdkv/9PLZzox510ZJJmhbsjt+4JsnnNmP5uDSVBwP/ev4g0F8A5xA4OU80f
	 0PciqbNzZqhxElhqFr3/5zjv5+CF+u5NzVdgl6cSJidHC7m2QlGf+rQE5aDTZCqf14
	 RYcNLq08UBXkA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jann Horn <jannh@google.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 5.10.y 7/7] mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather
Date: Wed, 18 Feb 2026 14:05:52 +0100
Message-ID: <20260218130552.55727-8-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218130552.55727-1-david@kernel.org>
References: <2026012610-absolve-ducktail-3c64@gregkh>
 <20260218130552.55727-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CA8F5180018
X-Stat-Signature: irk56d4zxqrcxpzebb3qbuq7t8hyfqe1
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771419991-284253
X-HE-Meta: U2FsdGVkX18pFKLDJvUK+U3OA5oy27rgjNN8niUuBFFQ62pnSUiJsjCc/RsX9kSQnQfQBGxxT7G7KSeaMbGUS6EZHCb4APl3V9LCEnYndzC315TOu+QZnF7vk57ypbFaKVeuO8zIZc9qG/H9rXg9RWg/ell7TMdunApbM7KS9YLHQV6uWmpJZYH4Earc2TsqFI47HsyUsL+nG4e6t4U5TCdyd4+eykpEhORH9ujghrbG4BeEyiddMc7q4+Nnu0unbrt0qtimipngLsJ8bYzN3kJ7WG9ErQ7IEFkKtS21t+SIbzOBPEL5ngEQTfAdNEymtue8Ctu27aLk+qKPqHauN+iGkMHnDc8ULDkQeCf08H18Aign/JgYrxuEWbELPfqhjrbjcwW+T1TzZDsqpx/HJTn3pWGazgi2fRKEa0Q6xuNhe/Q4B5d5vkRuTXynVdB0LJZaIXE5ZxPbvU5B3LiupeIjH5FQbe3fiMRFHK/HnL5i9aZAa4heAUEvVTSgmMr1vR7fhNY8Obkw+cJ1VlZlpQRFSeWPSv2AGXLlM68r+ajNbQrnKQpmCHn0sLTn0/q+blAnji7G7dQ4LttxA7hudq1bTZEQXLXLqIvd5zJGpjyuej624y8NbLGtzZlVOzdhHd3tvo6/8p5q4btCiRQXV1I+RE8weu9NvhDARTTfggO1AE3LmIXugQU5pReGdZMWMk3Vz/ZPl7wwUpXpnE3uSZuHo3Z0Y5j6Ogmmkw20N00ttlAQmJ8WHEKPjFHHgiO52aeiqCRqpnWKHfPseDrJjZYcfyk5pB0usQMI0cKiV0+URkHZVsVJkno723OOcskM7W/9zqeEOAGf1VD4B6Ae84r9Qk9O2vp590f7PqDvf8II70fc6Z4hy8UhOC51NGHeHoKIykJjn9yG/pA8ekqBGgUqYOg1IVkIehcSXRT57AVV7/Q/R5Mdz66bctFeFSnA4PMEZF4t1/JSFeCfj69
 n4GKZwNn
 L/qmdpfNZsWiHyiBHBmnTKnDlynFcJm+Caa2QQeN7bB6I+i2VZgaq4sMXaKIY7mXu2kAiSyv+bXMSyz64eMpWv5SJ+hlXfbzGHO4y6EvQyW4Se4C9LgiVXVs36J4FnXOsIV0TXL8xXJOaaFV47XOHM+rI4VjDK7cI9jA1hYVaJBczuNBJ0A/HUS29MN8M9pWrG7HaPW8Zsrhel9NSTntFAeh2dLCV8M4V6IXs/YYkwoEKdiD2bqWhNJPfwdIrx6sAiWJwWvBEuxw35NtntDa2QQ/1eDOxVFviIXUDdYWzG/N4cDrwsSOkErr3cwHxGDP/DkzCdACMmdxMHEfy713xciDn85ruG9g6zNIo6gpxsDwyT3CJf9+RnzKPVD+5B5ptaTTmpbMqz0QDJozWAuD3IRfgN9ndy7DxGgQKf99GGGFs8e54mC9DOjGyAy4/U5DAgNN+hwa0kloRd5c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Red Hat)" <david@kernel.org>

As reported, ever since commit 1013af4f585f ("mm/hugetlb: fix
huge_pmd_unshare() vs GUP-fast race") we can end up in some situations
where we perform so many IPI broadcasts when unsharing hugetlb PMD page
tables that it severely regresses some workloads.

In particular, when we fork()+exit(), or when we munmap() a large
area backed by many shared PMD tables, we perform one IPI broadcast per
unshared PMD table.

There are two optimizations to be had:

(1) When we process (unshare) multiple such PMD tables, such as during
    exit(), it is sufficient to send a single IPI broadcast (as long as
    we respect locking rules) instead of one per PMD table.

    Locking prevents that any of these PMD tables could get reused before
    we drop the lock.

(2) When we are not the last sharer (> 2 users including us), there is
    no need to send the IPI broadcast. The shared PMD tables cannot
    become exclusive (fully unshared) before an IPI will be broadcasted
    by the last sharer.

    Concurrent GUP-fast could walk into a PMD table just before we
    unshared it. It could then succeed in grabbing a page from the
    shared page table even after munmap() etc succeeded (and supressed
    an IPI). But there is not difference compared to GUP-fast just
    sleeping for a while after grabbing the page and re-enabling IRQs.

    Most importantly, GUP-fast will never walk into page tables that are
    no-longer shared, because the last sharer will issue an IPI
    broadcast.

    (if ever required, checking whether the PUD changed in GUP-fast
     after grabbing the page like we do in the PTE case could handle
     this)

So let's rework PMD sharing TLB flushing + IPI sync to use the mmu_gather
infrastructure so we can implement these optimizations and demystify the
code at least a bit. Extend the mmu_gather infrastructure to be able to
deal with our special hugetlb PMD table sharing implementation.

To make initialization of the mmu_gather easier when working on a single
VMA (in particular, when dealing with hugetlb), provide
tlb_gather_mmu_vma().

We'll consolidate the handling for (full) unsharing of PMD tables in
tlb_unshare_pmd_ptdesc() and tlb_flush_unshared_tables(), and track
in "struct mmu_gather" whether we had (full) unsharing of PMD tables.

Because locking is very special (concurrent unsharing+reuse must be
prevented), we disallow deferring flushing to tlb_finish_mmu() and instead
require an explicit earlier call to tlb_flush_unshared_tables().

From hugetlb code, we call huge_pmd_unshare_flush() where we make sure
that the expected lock protecting us from concurrent unsharing+reuse is
still held.

Check with a VM_WARN_ON_ONCE() in tlb_finish_mmu() that
tlb_flush_unshared_tables() was properly called earlier.

Document it all properly.

Notes about tlb_remove_table_sync_one() interaction with unsharing:

There are two fairly tricky things:

(1) tlb_remove_table_sync_one() is a NOP on architectures without
    CONFIG_MMU_GATHER_RCU_TABLE_FREE.

    Here, the assumption is that the previous TLB flush would send an
    IPI to all relevant CPUs. Careful: some architectures like x86 only
    send IPIs to all relevant CPUs when tlb->freed_tables is set.

    The relevant architectures should be selecting
    MMU_GATHER_RCU_TABLE_FREE, but x86 might not do that in stable
    kernels and it might have been problematic before this patch.

    Also, the arch flushing behavior (independent of IPIs) is different
    when tlb->freed_tables is set. Do we have to enlighten them to also
    take care of tlb->unshared_tables? So far we didn't care, so
    hopefully we are fine. Of course, we could be setting
    tlb->freed_tables as well, but that might then unnecessarily flush
    too much, because the semantics of tlb->freed_tables are a bit
    fuzzy.

    This patch changes nothing in this regard.

(2) tlb_remove_table_sync_one() is not a NOP on architectures with
    CONFIG_MMU_GATHER_RCU_TABLE_FREE that actually don't need a sync.

    Take x86 as an example: in the common case (!pv, !X86_FEATURE_INVLPGB)
    we still issue IPIs during TLB flushes and don't actually need the
    second tlb_remove_table_sync_one().

    This optimized can be implemented on top of this, by checking e.g., in
    tlb_remove_table_sync_one() whether we really need IPIs. But as
    described in (1), it really must honor tlb->freed_tables then to
    send IPIs to all relevant CPUs.

Notes on TLB flushing changes:

(1) Flushing for non-shared PMD tables

    We're converting from flush_hugetlb_tlb_range() to
    tlb_remove_huge_tlb_entry(). Given that we properly initialize the
    MMU gather in tlb_gather_mmu_vma() to be hugetlb aware, similar to
    __unmap_hugepage_range(), that should be fine.

(2) Flushing for shared PMD tables

    We're converting from various things (flush_hugetlb_tlb_range(),
    tlb_flush_pmd_range(), flush_tlb_range()) to tlb_flush_pmd_range().

    tlb_flush_pmd_range() achieves the same that
    tlb_remove_huge_tlb_entry() would achieve in these scenarios.
    Note that tlb_remove_huge_tlb_entry() also calls
    __tlb_remove_tlb_entry(), however that is only implemented on
    powerpc, which does not support PMD table sharing.

    Similar to (1), tlb_gather_mmu_vma() should make sure that TLB
    flushing keeps on working as expected.

Further, note that the ptdesc_pmd_pts_dec() in huge_pmd_share() is not a
concern, as we are holding the i_mmap_lock the whole time, preventing
concurrent unsharing. That ptdesc_pmd_pts_dec() usage will be removed
separately as a cleanup later.

There are plenty more cleanups to be had, but they have to wait until
this is fixed.

[david@kernel.org: fix kerneldoc]
  Link: https://lkml.kernel.org/r/f223dd74-331c-412d-93fc-69e360a5006c@kernel.org
Link: https://lkml.kernel.org/r/20251223214037.580860-5-david@kernel.org
Fixes: 1013af4f585f ("mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reported-by: Uschakow, Stanislav" <suschako@amazon.de>
Closes: https://lore.kernel.org/all/4d3878531c76479d9f8ca9789dc6485d@amazon.de/
Tested-by: Laurence Oberman <loberman@redhat.com>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 8ce720d5bd91e9dc16db3604aa4b1bf76770a9a1)
[ David: We don't have ptdesc and the wrappers, so work directly on
  page->pt_share_count and pass "struct page" instead of "struct ptdesc".
  CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING is still called
  CONFIG_ARCH_WANT_HUGE_PMD_SHARE and is set even without
  CONFIG_HUGETLB_PAGE. We don't have 550a7d60bd5e ("mm, hugepages: add
  mremap() support for hugepage backed vma"), so move_hugetlb_page_tables()
  does not exist. We don't have 40549ba8f8e0 ("hugetlb: use new vma_lock
  for pmd sharing synchronization") and a98a2f0c8ce1 ("mm/rmap: split
  migration into its own so changes in mm/rmap.c looks quite different. We
  don't have 4ddb4d91b82f ("hugetlb: do not update address
  in huge_pmd_unshare"), so huge_pmd_unshare() still gets a pointer to
  an address. tlb_gather_mmu() + tlb_finish_mmu() still consume ranges, so
  also teach tlb_gather_mmu_vma() to forward ranges.  Some smaller
  contextual stuff, in particular, around tlb_gather_mmu_full(). ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/tlb.h |  77 ++++++++++++++++++++++++++-
 include/linux/hugetlb.h   |  15 ++++--
 include/linux/mm_types.h  |   2 +
 mm/hugetlb.c              | 108 ++++++++++++++++++++++----------------
 mm/mmu_gather.c           |  36 +++++++++++++
 mm/rmap.c                 |  11 ++--
 6 files changed, 195 insertions(+), 54 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index f40c9534f20b..a80accdbcd25 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -46,7 +46,8 @@
  *
  * The mmu_gather API consists of:
  *
- *  - tlb_gather_mmu() / tlb_finish_mmu(); start and finish a mmu_gather
+ *  - tlb_gather_mmu() / tlb_gather_mmu_vma() / tlb_finish_mmu(); start and
+ *    finish a mmu_gather
  *
  *    Finish in particular will issue a (final) TLB invalidate and free
  *    all (remaining) queued pages.
@@ -291,6 +292,20 @@ struct mmu_gather {
 	unsigned int		vma_exec : 1;
 	unsigned int		vma_huge : 1;
 
+	/*
+	 * Did we unshare (unmap) any shared page tables? For now only
+	 * used for hugetlb PMD table sharing.
+	 */
+	unsigned int		unshared_tables : 1;
+
+	/*
+	 * Did we unshare any page tables such that they are now exclusive
+	 * and could get reused+modified by the new owner? When setting this
+	 * flag, "unshared_tables" will be set as well. For now only used
+	 * for hugetlb PMD table sharing.
+	 */
+	unsigned int		fully_unshared_tables : 1;
+
 	unsigned int		batch_count;
 
 #ifndef CONFIG_MMU_GATHER_NO_GATHER
@@ -327,6 +342,7 @@ static inline void __tlb_reset_range(struct mmu_gather *tlb)
 	tlb->cleared_pmds = 0;
 	tlb->cleared_puds = 0;
 	tlb->cleared_p4ds = 0;
+	tlb->unshared_tables = 0;
 	/*
 	 * Do not reset mmu_gather::vma_* fields here, we do not
 	 * call into tlb_start_vma() again to set them if there is an
@@ -422,7 +438,7 @@ static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
 	 * these bits.
 	 */
 	if (!(tlb->freed_tables || tlb->cleared_ptes || tlb->cleared_pmds ||
-	      tlb->cleared_puds || tlb->cleared_p4ds))
+	      tlb->cleared_puds || tlb->cleared_p4ds || tlb->unshared_tables))
 		return;
 
 	tlb_flush(tlb);
@@ -660,6 +676,63 @@ static inline void tlb_flush_p4d_range(struct mmu_gather *tlb,
 	} while (0)
 #endif
 
+#if defined(CONFIG_ARCH_WANT_HUGE_PMD_SHARE) && defined(CONFIG_HUGETLB_PAGE)
+static inline void tlb_unshare_pmd_ptdesc(struct mmu_gather *tlb, struct page *pt,
+					  unsigned long addr)
+{
+	/*
+	 * The caller must make sure that concurrent unsharing + exclusive
+	 * reuse is impossible until tlb_flush_unshared_tables() was called.
+	 */
+	VM_WARN_ON_ONCE(!atomic_read(&pt->pt_share_count));
+	atomic_dec(&pt->pt_share_count);
+
+	/* Clearing a PUD pointing at a PMD table with PMD leaves. */
+	tlb_flush_pmd_range(tlb, addr & PUD_MASK, PUD_SIZE);
+
+	/*
+	 * If the page table is now exclusively owned, we fully unshared
+	 * a page table.
+	 */
+	if (!atomic_read(&pt->pt_share_count))
+		tlb->fully_unshared_tables = true;
+	tlb->unshared_tables = true;
+}
+
+static inline void tlb_flush_unshared_tables(struct mmu_gather *tlb)
+{
+	/*
+	 * As soon as the caller drops locks to allow for reuse of
+	 * previously-shared tables, these tables could get modified and
+	 * even reused outside of hugetlb context, so we have to make sure that
+	 * any page table walkers (incl. TLB, GUP-fast) are aware of that
+	 * change.
+	 *
+	 * Even if we are not fully unsharing a PMD table, we must
+	 * flush the TLB for the unsharer now.
+	 */
+	if (tlb->unshared_tables)
+		tlb_flush_mmu_tlbonly(tlb);
+
+	/*
+	 * Similarly, we must make sure that concurrent GUP-fast will not
+	 * walk previously-shared page tables that are getting modified+reused
+	 * elsewhere. So broadcast an IPI to wait for any concurrent GUP-fast.
+	 *
+	 * We only perform this when we are the last sharer of a page table,
+	 * as the IPI will reach all CPUs: any GUP-fast.
+	 *
+	 * Note that on configs where tlb_remove_table_sync_one() is a NOP,
+	 * the expectation is that the tlb_flush_mmu_tlbonly() would have issued
+	 * required IPIs already for us.
+	 */
+	if (tlb->fully_unshared_tables) {
+		tlb_remove_table_sync_one();
+		tlb->fully_unshared_tables = false;
+	}
+}
+#endif
+
 #endif /* CONFIG_MMU */
 
 #endif /* _ASM_GENERIC__TLB_H */
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 0d3fece27031..dfb1afa3d282 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -166,8 +166,9 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 			unsigned long addr, unsigned long sz);
 pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz);
-int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
-				unsigned long *addr, pte_t *ptep);
+int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		unsigned long *addr, pte_t *ptep);
+void huge_pmd_unshare_flush(struct mmu_gather *tlb, struct vm_area_struct *vma);
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end);
 struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
@@ -208,13 +209,17 @@ static inline struct address_space *hugetlb_page_mapping_lock_write(
 	return NULL;
 }
 
-static inline int huge_pmd_unshare(struct mm_struct *mm,
-					struct vm_area_struct *vma,
-					unsigned long *addr, pte_t *ptep)
+static inline int huge_pmd_unshare(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long *addr, pte_t *ptep)
 {
 	return 0;
 }
 
+static inline void huge_pmd_unshare_flush(struct mmu_gather *tlb,
+		struct vm_area_struct *vma)
+{
+}
+
 static inline void adjust_range_if_pmd_sharing_possible(
 				struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b6cf570dc98c..00a85b64e524 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -610,6 +610,8 @@ static inline cpumask_t *mm_cpumask(struct mm_struct *mm)
 struct mmu_gather;
 extern void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm,
 				unsigned long start, unsigned long end);
+void tlb_gather_mmu_vma(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end);
 extern void tlb_finish_mmu(struct mmu_gather *tlb,
 				unsigned long start, unsigned long end);
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 33302279ab5f..27fe947b8c69 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3938,7 +3938,6 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
 	struct mmu_notifier_range range;
-	bool force_flush = false;
 
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
@@ -3965,10 +3964,8 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			continue;
 
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, vma, &address, ptep)) {
+		if (huge_pmd_unshare(tlb, vma, &address, ptep)) {
 			spin_unlock(ptl);
-			tlb_flush_pmd_range(tlb, address & PUD_MASK, PUD_SIZE);
-			force_flush = true;
 			continue;
 		}
 
@@ -4026,14 +4023,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_end_vma(tlb, vma);
 
-	/*
-	 * There is nothing protecting a previously-shared page table that we
-	 * unshared through huge_pmd_unshare() from getting freed after we
-	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
-	 * succeeded, flush the range corresponding to the pud.
-	 */
-	if (force_flush)
-		tlb_flush_mmu_tlbonly(tlb);
+	huge_pmd_unshare_flush(tlb, vma);
 }
 
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
@@ -5043,8 +5033,8 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 	pte_t pte;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long pages = 0;
-	bool shared_pmd = false;
 	struct mmu_notifier_range range;
+	struct mmu_gather tlb;
 
 	/*
 	 * In the case of shared PMDs, the area to flush could be beyond
@@ -5057,6 +5047,7 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 
 	BUG_ON(address >= end);
 	flush_cache_range(vma, range.start, range.end);
+	tlb_gather_mmu_vma(&tlb, vma, range.start, range.end);
 
 	mmu_notifier_invalidate_range_start(&range);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
@@ -5066,10 +5057,9 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 		if (!ptep)
 			continue;
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, vma, &address, ptep)) {
+		if (huge_pmd_unshare(&tlb, vma, &address, ptep)) {
 			pages++;
 			spin_unlock(ptl);
-			shared_pmd = true;
 			continue;
 		}
 		pte = huge_ptep_get(ptep);
@@ -5100,21 +5090,15 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 			pte = arch_make_huge_pte(pte, vma, NULL, 0);
 			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
 			pages++;
+			tlb_remove_huge_tlb_entry(h, &tlb, ptep, address);
 		}
 		spin_unlock(ptl);
 
 		cond_resched();
 	}
-	/*
-	 * There is nothing protecting a previously-shared page table that we
-	 * unshared through huge_pmd_unshare() from getting freed after we
-	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
-	 * succeeded, flush the range corresponding to the pud.
-	 */
-	if (shared_pmd)
-		flush_hugetlb_tlb_range(vma, range.start, range.end);
-	else
-		flush_hugetlb_tlb_range(vma, start, end);
+
+	tlb_flush_mmu_tlbonly(&tlb);
+	huge_pmd_unshare_flush(&tlb, vma);
 	/*
 	 * No need to call mmu_notifier_invalidate_range() we are downgrading
 	 * page table protection not changing it to point to a new page.
@@ -5123,6 +5107,7 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 	 */
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
 	mmu_notifier_invalidate_range_end(&range);
+	tlb_finish_mmu(&tlb, range.start, range.end);
 
 	return pages << h->order;
 }
@@ -5449,18 +5434,27 @@ pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 	return pte;
 }
 
-/*
- * unmap huge page backed by shared pte.
+/**
+ * huge_pmd_unshare - Unmap a pmd table if it is shared by multiple users
+ * @tlb: the current mmu_gather.
+ * @vma: the vma covering the pmd table.
+ * @addr: pointer to the address we are trying to unshare.
+ * @ptep: pointer into the (pmd) page table.
  *
- * Called with page table lock held.
+ * Called with the page table lock held, the i_mmap_rwsem held in write mode
+ * and the hugetlb vma lock held in write mode.
  *
- * returns: 1 successfully unmapped a shared pte page
- *	    0 the underlying pte page is not shared, or it is the last user
+ * Note: The caller must call huge_pmd_unshare_flush() before dropping the
+ * i_mmap_rwsem.
+ *
+ * Returns: 1 if it was a shared PMD table and it got unmapped, or 0 if it
+ *	    was not a shared PMD table.
  */
-int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
-					unsigned long *addr, pte_t *ptep)
+int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		unsigned long *addr, pte_t *ptep)
 {
 	unsigned long sz = huge_page_size(hstate_vma(vma));
+	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd = pgd_offset(mm, *addr);
 	p4d_t *p4d = p4d_offset(pgd, *addr);
 	pud_t *pud = pud_offset(p4d, *addr);
@@ -5472,14 +5466,8 @@ int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
 		return 0;
 
 	pud_clear(pud);
-	/*
-	 * Once our caller drops the rmap lock, some other process might be
-	 * using this page table as a normal, non-hugetlb page table.
-	 * Wait for pending gup_fast() in other threads to finish before letting
-	 * that happen.
-	 */
-	tlb_remove_table_sync_one();
-	atomic_dec(&virt_to_page(ptep)->pt_share_count);
+	tlb_unshare_pmd_ptdesc(tlb, virt_to_page(ptep), *addr);
+
 	mm_dec_nr_pmds(mm);
 	/*
 	 * This update of passed address optimizes loops sequentially
@@ -5491,6 +5479,30 @@ int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
 	*addr |= PUD_SIZE - PMD_SIZE;
 	return 1;
 }
+
+/*
+ * huge_pmd_unshare_flush - Complete a sequence of huge_pmd_unshare() calls
+ * @tlb: the current mmu_gather.
+ * @vma: the vma covering the pmd table.
+ *
+ * Perform necessary TLB flushes or IPI broadcasts to synchronize PMD table
+ * unsharing with concurrent page table walkers.
+ *
+ * This function must be called after a sequence of huge_pmd_unshare()
+ * calls while still holding the i_mmap_rwsem.
+ */
+void huge_pmd_unshare_flush(struct mmu_gather *tlb, struct vm_area_struct *vma)
+{
+	/*
+	 * We must synchronize page table unsharing such that nobody will
+	 * try reusing a previously-shared page table while it might still
+	 * be in use by previous sharers (TLB, GUP_fast).
+	 */
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+
+	tlb_flush_unshared_tables(tlb);
+}
+
 #define want_pmd_share()	(1)
 #else /* !CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
@@ -5498,12 +5510,16 @@ pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 	return NULL;
 }
 
-int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
-				unsigned long *addr, pte_t *ptep)
+int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		unsigned long *addr, pte_t *ptep)
 {
 	return 0;
 }
 
+void huge_pmd_unshare_flush(struct mmu_gather *tlb, struct vm_area_struct *vma)
+{
+}
+
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end)
 {
@@ -5745,6 +5761,7 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 	unsigned long sz = huge_page_size(h);
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_notifier_range range;
+	struct mmu_gather tlb;
 	unsigned long address;
 	spinlock_t *ptl;
 	pte_t *ptep;
@@ -5756,6 +5773,8 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		return;
 
 	flush_cache_range(vma, start, end);
+	tlb_gather_mmu_vma(&tlb, vma, start, end);
+
 	/*
 	 * No need to call adjust_range_if_pmd_sharing_possible(), because
 	 * we have already done the PUD_SIZE alignment.
@@ -5776,10 +5795,10 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 			continue;
 		ptl = huge_pte_lock(h, mm, ptep);
 		/* We don't want 'address' to be changed */
-		huge_pmd_unshare(mm, vma, &tmp, ptep);
+		huge_pmd_unshare(&tlb, vma, &tmp, ptep);
 		spin_unlock(ptl);
 	}
-	flush_hugetlb_tlb_range(vma, start, end);
+	huge_pmd_unshare_flush(&tlb, vma);
 	if (take_locks) {
 		i_mmap_unlock_write(vma->vm_file->f_mapping);
 	}
@@ -5788,6 +5807,7 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 	 * Documentation/mm/mmu_notifier.rst.
 	 */
 	mmu_notifier_invalidate_range_end(&range);
+	tlb_finish_mmu(&tlb, start, end);
 }
 
 #ifdef CONFIG_CMA
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 205fdbb5792a..298972351a60 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -7,6 +7,7 @@
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
 #include <linux/swap.h>
+#include <linux/hugetlb.h>
 
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
@@ -281,10 +282,39 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm,
 	tlb->page_size = 0;
 #endif
 
+	tlb->fully_unshared_tables = 0;
 	__tlb_reset_range(tlb);
 	inc_tlb_flush_pending(tlb->mm);
 }
 
+/**
+ * tlb_gather_mmu_vma - initialize an mmu_gather structure for operating on a
+ *			single VMA
+ * @tlb: the mmu_gather structure to initialize
+ * @vma: the vm_area_struct
+ * @start: start of the region that will be removed from the page-table
+ * @end: end of the region that will be removed from the page-table
+ *
+ * Called to initialize an (on-stack) mmu_gather structure for operating on
+ * a single VMA. In contrast to tlb_gather_mmu(), calling this function will
+ * not require another call to tlb_start_vma(). In contrast to tlb_start_vma(),
+ * this function will *not* call flush_cache_range().
+ *
+ * For hugetlb VMAs, this function will also initialize the mmu_gather
+ * page_size accordingly, not requiring a separate call to
+ * tlb_change_page_size().
+ *
+ */
+void tlb_gather_mmu_vma(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end)
+{
+	tlb_gather_mmu(tlb, vma->vm_mm, start, end);
+	tlb_update_vma_flags(tlb, vma);
+	if (is_vm_hugetlb_page(vma))
+		/* All entries have the same size. */
+		tlb_change_page_size(tlb, huge_page_size(hstate_vma(vma)));
+}
+
 /**
  * tlb_finish_mmu - finish an mmu_gather structure
  * @tlb: the mmu_gather structure to finish
@@ -297,6 +327,12 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm,
 void tlb_finish_mmu(struct mmu_gather *tlb,
 		unsigned long start, unsigned long end)
 {
+	/*
+	 * We expect an earlier huge_pmd_unshare_flush() call to sort this out,
+	 * due to complicated locking requirements with page table unsharing.
+	 */
+	VM_WARN_ON_ONCE(tlb->fully_unshared_tables);
+
 	/*
 	 * If there are parallel threads are doing PTE changes on same range
 	 * under non-exclusive lock (e.g., mmap_lock read-side) but defer TLB
diff --git a/mm/rmap.c b/mm/rmap.c
index 315d7ceb573a..a5da7abd15d3 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -73,7 +73,7 @@
 #include <linux/memremap.h>
 #include <linux/userfaultfd_k.h>
 
-#include <asm/tlbflush.h>
+#include <asm/tlb.h>
 
 #include <trace/events/tlb.h>
 
@@ -1470,13 +1470,16 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		address = pvmw.address;
 
 		if (PageHuge(page) && !PageAnon(page)) {
+			struct mmu_gather tlb;
+
 			/*
 			 * To call huge_pmd_unshare, i_mmap_rwsem must be
 			 * held in write mode.  Caller needs to explicitly
 			 * do this outside rmap routines.
 			 */
 			VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
-			if (huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
+			tlb_gather_mmu_vma(&tlb, vma, range.start, range.end);
+			if (huge_pmd_unshare(&tlb, vma, &address, pvmw.pte)) {
 				/*
 				 * huge_pmd_unshare unmapped an entire PMD
 				 * page.  There is no way of knowing exactly
@@ -1485,9 +1488,10 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 				 * already adjusted above to cover this range.
 				 */
 				flush_cache_range(vma, range.start, range.end);
-				flush_tlb_range(vma, range.start, range.end);
+				huge_pmd_unshare_flush(&tlb, vma);
 				mmu_notifier_invalidate_range(mm, range.start,
 							      range.end);
+				tlb_finish_mmu(&tlb, range.start, range.end);
 
 				/*
 				 * The PMD table was unmapped,
@@ -1496,6 +1500,7 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
+			tlb_finish_mmu(&tlb, range.start, range.end);
 		}
 
 		if (IS_ENABLED(CONFIG_MIGRATION) &&
-- 
2.43.0


