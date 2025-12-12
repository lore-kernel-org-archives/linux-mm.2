Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9C89D4336E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 07:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BDB56B000A; Fri, 12 Dec 2025 02:10:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 195246B000C; Fri, 12 Dec 2025 02:10:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0834A6B000D; Fri, 12 Dec 2025 02:10:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E813A6B000A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:10:47 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81BD716042D
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:10:47 +0000 (UTC)
X-FDA: 84209946534.13.49C508E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C8FCC180012
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:10:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lAEJTvdW;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765523446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=omjjR7kTg/zY5TMUIvaV9UkdRXIyNi2xDRH4RMZzXAk=;
	b=B9385shWBJee7x7YlgTX+gidPaqrECvAQpaNYOH0+NMr8mD4aWwwfXuv7t+CONTIoArZYU
	iOi6CQu74EQwD9ZEliFt3QqLaREJfSIDcajDcF+ruE8FEsMFVyKllbkv3ZaO5qWbUd1Rc2
	DDV/ShAjw+i583BM6CF91Oz7bxlVPz4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lAEJTvdW;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765523446; a=rsa-sha256;
	cv=none;
	b=6Mu5Nx0iGBOISSgObeiDu7KmFI2RjWX/stKKUvHg0PN4n4LdR/cUDlcm6k61I5K5QjdESX
	Z8PhHi1upMMTte+ze4elv7G26xhdP4Q1ArL0pdUIuGtkw8WewC0HeuvkNb6nhIwDuxdxSn
	ZMpfNMCpUmzxh4E68jDXwLhSu2Fil6E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A3C3443BB;
	Fri, 12 Dec 2025 07:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFA3C4CEF1;
	Fri, 12 Dec 2025 07:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765523444;
	bh=rkJpLHgmqqeuJF0nqKl7Wz4acVFPVHqhxsJrCNx1jfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAEJTvdWetyuXNF2MDUn0EL/roK/A5tftE0u31z0vsowQnIJt2VYgyn/9Otwi4p+k
	 Y4QoFAqRoKjphuufdyipK+oUNf1MXklkmpa8zGYnFmwVfU0Tkl4dPb5s60aJHlQh2O
	 o4zpwW9l0o0f10XIuRzq7xw8m5r+7hh7gq7P9bQFKJ0PgaP9HYmqlenbQFB56Tjrsv
	 tmpeqvRo7Ii83FUtnUoWxAULFuPywiaWHnRwlmU84ZvqdAhApk73UEBUTqWArPXxU6
	 WSCRURI5nIRiOAENcCx3V4agMlhly6r7RziHss47I6Hq8OTVZf1qDkUwuN0nA1R+VC
	 pLqDJc6ybP3WQ==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 4/4] mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather
Date: Fri, 12 Dec 2025 08:10:19 +0100
Message-ID: <20251212071019.471146-5-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251212071019.471146-1-david@kernel.org>
References: <20251212071019.471146-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8FCC180012
X-Stat-Signature: xdta3o6cgobisfqdy5fb7txmrz9c9yg3
X-HE-Tag: 1765523445-929155
X-HE-Meta: U2FsdGVkX1/GcZKAwsdUIAfeFinbwAB8bvgWC0e9xhWDH2fl6z/LFpCfhsfdp3+viUYEcKeBjxHY6m1bTQ1d5EGfpTsWletAxyVE7r9jW7p6NVkONbHDTw1H3scO9PhRBGAz3QbNG9EynGQlY6P5snOtgLa39kwEqPV0GSB/kB6pUziWxpn1rykxKIdeMjC3e8Pz06Sr9d+PKbmlD+j34svLsvFuV7Ded2TuwSKySlTbHQ84oMtktzCoIjHTouh+2HHJaq74ewSAoVoXZHZER3NWrJ3S4bpLWl5QY4OLh36BaA27cDY4dTsrZozXqz/KHn5CFtxocvJjbQQqgjhDeEqY29Hxhvfg/0ypoduYKXCvvyIrY/e00au9QCKLK3Wu6Gcd5JL6WJwQe4/+mFIgWXLXsIChrB0VHIH8Ua1/QgPiL3mjCQUrT1lBs1ByLvG8AR8SKdN9W3ahAL97nahGLx0l2HTN9u2lPQ7Ubyn6gklOX1JIxGn52kn2oQIH/B5HAwvlP0oWBrGqewRWql61gpf0i96UiTIcIiv3W1Yz917TH+0qOg13UmUZUeobBcvrvTrdBEWy9twTHHrAsPmxS/g1cYq4Z11qNmj83kGkb9hCF5IdR3o+CCHtQQ9dyo/dGU6o4fGzegVnq7l/6M1azZRs4WNkkKRQASBGwFfcf3jG0NjhM++ueQ+mWsrJ52bRf2HyU/fmXxeOBi8UMjJIKR55ZhiZy9KJUvvzfsleRNiAFjh7diTPq2nfiSudaICuqm+lxYPupuXLUlRSGXVW4dRukdHTRLMufSwBzrt7rxLIZRM+Q1oj6R3X2zWVD3X1BjITAQyIifpTIebNMaJY2UFWyXtU0CQrlw8X+N7Zv50FKevAoWcAlURoXagKzzpsPUV6YRN+JpkmkE0qvoCa2lKZ8MqFL+tlIEDu508thdlDWLudb4nLTUxFbxBrw1FDCL6DVqnYp70i3BHxbcA
 UyY//S6J
 VcCfHGDnIDOzvg3HZg1fXe5OJf0Wx6BmZgX1avAmjzx3PLmtRrhWE1Vtl/h6hPgAuqzJKdEo+5kYsc6DwUxLKh81UZ+hr3vugpPCcPNZxipBSi8sKIS1gt8E3hc/k7IDpJCiGsky3GhQpxkDCWZOTDdpWvp4W+lYJUcMfpSvuILciZVHlvOfkwi8CRCaHdqmAXms3/QEALqEMUHYlzXj46cx29e16T0Hl4b4G88cfMIZLea8GHSS75QU7Q5GOuT/H4J0KpduYlNcPW+dA8FX0YVN1oSzME+CEodMTqFP8prLikYm5dTZWtuZzcUcPisH1Y0pYv2inf7OBCsGTDoLQEIBv8TeN4t0604Yar8gLuYS0r4h/r13+nAUaCfK6ctFB0nD0csAQbPq2y2wckPphgXxujg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

    Locking prevents that any of these PMD tables could get reuse before
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

Further note that the ptdesc_pmd_pts_dec() in huge_pmd_share() is not a
concern, as we are holding the i_mmap_lock the whole time, preventing
concurrent unsharing. That ptdesc_pmd_pts_dec() usage will be removed
separately as a cleanup later.

There are plenty more cleanups to be had, but they have to wait until
this is fixed.

Fixes: 1013af4f585f ("mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race")
Reported-by: Uschakow, Stanislav" <suschako@amazon.de>
Closes: https://lore.kernel.org/all/4d3878531c76479d9f8ca9789dc6485d@amazon.de/
Tested-by: Laurence Oberman <loberman@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/asm-generic/tlb.h |  74 ++++++++++++++++++++++-
 include/linux/hugetlb.h   |  19 +++---
 mm/hugetlb.c              | 121 ++++++++++++++++++++++----------------
 mm/mmu_gather.c           |   7 +++
 mm/mprotect.c             |   2 +-
 mm/rmap.c                 |  25 +++++---
 6 files changed, 179 insertions(+), 69 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 1fff717cae510..706416babb3d6 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -364,6 +364,20 @@ struct mmu_gather {
 	unsigned int		vma_huge : 1;
 	unsigned int		vma_pfn  : 1;
 
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
@@ -400,6 +414,7 @@ static inline void __tlb_reset_range(struct mmu_gather *tlb)
 	tlb->cleared_pmds = 0;
 	tlb->cleared_puds = 0;
 	tlb->cleared_p4ds = 0;
+	tlb->unshared_tables = 0;
 	/*
 	 * Do not reset mmu_gather::vma_* fields here, we do not
 	 * call into tlb_start_vma() again to set them if there is an
@@ -484,7 +499,7 @@ static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
 	 * these bits.
 	 */
 	if (!(tlb->freed_tables || tlb->cleared_ptes || tlb->cleared_pmds ||
-	      tlb->cleared_puds || tlb->cleared_p4ds))
+	      tlb->cleared_puds || tlb->cleared_p4ds || tlb->unshared_tables))
 		return;
 
 	tlb_flush(tlb);
@@ -773,6 +788,63 @@ static inline bool huge_pmd_needs_flush(pmd_t oldpmd, pmd_t newpmd)
 }
 #endif
 
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+static inline void tlb_unshare_pmd_ptdesc(struct mmu_gather *tlb, struct ptdesc *pt,
+					  unsigned long addr)
+{
+	/*
+	 * The caller must make sure that concurrent unsharing + exclusive
+	 * reuse is impossible until tlb_flush_unshared_tables() was called.
+	 */
+	VM_WARN_ON_ONCE(!ptdesc_pmd_is_shared(pt));
+	ptdesc_pmd_pts_dec(pt);
+
+	/* Clearing a PUD pointing at a PMD table with PMD leaves. */
+	tlb_flush_pmd_range(tlb, addr & PUD_MASK, PUD_SIZE);
+
+	/*
+	 * If the page table is now exclusively owned, we fully unshared
+	 * a page table.
+	 */
+	if (!ptdesc_pmd_is_shared(pt))
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
+#endif /* CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING */
+
 #endif /* CONFIG_MMU */
 
 #endif /* _ASM_GENERIC__TLB_H */
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 03c8725efa289..63b248c6bfd47 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -240,8 +240,9 @@ pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz);
 unsigned long hugetlb_mask_last_page(struct hstate *h);
-int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep);
+int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep);
+void huge_pmd_unshare_flush(struct mmu_gather *tlb, struct vm_area_struct *vma);
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end);
 
@@ -271,7 +272,7 @@ void hugetlb_vma_unlock_write(struct vm_area_struct *vma);
 int hugetlb_vma_trylock_write(struct vm_area_struct *vma);
 void hugetlb_vma_assert_locked(struct vm_area_struct *vma);
 void hugetlb_vma_lock_release(struct kref *kref);
-long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot,
 		unsigned long cp_flags);
 void hugetlb_unshare_all_pmds(struct vm_area_struct *vma);
@@ -300,13 +301,17 @@ static inline struct address_space *hugetlb_folio_mapping_lock_write(
 	return NULL;
 }
 
-static inline int huge_pmd_unshare(struct mm_struct *mm,
-					struct vm_area_struct *vma,
-					unsigned long addr, pte_t *ptep)
+static inline int huge_pmd_unshare(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
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
@@ -432,7 +437,7 @@ static inline void move_hugetlb_state(struct folio *old_folio,
 {
 }
 
-static inline long hugetlb_change_protection(
+static inline long hugetlb_change_protection(struct mmu_gather *tlb,
 			struct vm_area_struct *vma, unsigned long address,
 			unsigned long end, pgprot_t newprot,
 			unsigned long cp_flags)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3c77cdef12a32..7fef0b94b5d1e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5096,8 +5096,9 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 	unsigned long last_addr_mask;
 	pte_t *src_pte, *dst_pte;
 	struct mmu_notifier_range range;
-	bool shared_pmd = false;
+	struct mmu_gather tlb;
 
+	tlb_gather_mmu(&tlb, vma->vm_mm);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, old_addr,
 				old_end);
 	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
@@ -5122,12 +5123,12 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 		if (huge_pte_none(huge_ptep_get(mm, old_addr, src_pte)))
 			continue;
 
-		if (huge_pmd_unshare(mm, vma, old_addr, src_pte)) {
-			shared_pmd = true;
+		if (huge_pmd_unshare(&tlb, vma, old_addr, src_pte)) {
 			old_addr |= last_addr_mask;
 			new_addr |= last_addr_mask;
 			continue;
 		}
+		tlb_remove_huge_tlb_entry(h, &tlb, src_pte, old_addr);
 
 		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
 		if (!dst_pte)
@@ -5136,13 +5137,13 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 		move_huge_pte(vma, old_addr, new_addr, src_pte, dst_pte, sz);
 	}
 
-	if (shared_pmd)
-		flush_hugetlb_tlb_range(vma, range.start, range.end);
-	else
-		flush_hugetlb_tlb_range(vma, old_end - len, old_end);
+	tlb_flush_mmu_tlbonly(&tlb);
+	huge_pmd_unshare_flush(&tlb, vma);
+
 	mmu_notifier_invalidate_range_end(&range);
 	i_mmap_unlock_write(mapping);
 	hugetlb_vma_unlock_write(vma);
+	tlb_finish_mmu(&tlb);
 
 	return len + old_addr - old_end;
 }
@@ -5161,7 +5162,6 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	unsigned long sz = huge_page_size(h);
 	bool adjust_reservation;
 	unsigned long last_addr_mask;
-	bool force_flush = false;
 
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
@@ -5184,10 +5184,8 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		}
 
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, vma, address, ptep)) {
+		if (huge_pmd_unshare(tlb, vma, address, ptep)) {
 			spin_unlock(ptl);
-			tlb_flush_pmd_range(tlb, address & PUD_MASK, PUD_SIZE);
-			force_flush = true;
 			address |= last_addr_mask;
 			continue;
 		}
@@ -5303,14 +5301,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	}
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
 
 void __hugetlb_zap_begin(struct vm_area_struct *vma,
@@ -6399,7 +6390,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 }
 #endif /* CONFIG_USERFAULTFD */
 
-long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		unsigned long address, unsigned long end,
 		pgprot_t newprot, unsigned long cp_flags)
 {
@@ -6409,7 +6400,6 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 	pte_t pte;
 	struct hstate *h = hstate_vma(vma);
 	long pages = 0, psize = huge_page_size(h);
-	bool shared_pmd = false;
 	struct mmu_notifier_range range;
 	unsigned long last_addr_mask;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
@@ -6452,7 +6442,7 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 			}
 		}
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, vma, address, ptep)) {
+		if (huge_pmd_unshare(tlb, vma, address, ptep)) {
 			/*
 			 * When uffd-wp is enabled on the vma, unshare
 			 * shouldn't happen at all.  Warn about it if it
@@ -6461,7 +6451,6 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 			WARN_ON_ONCE(uffd_wp || uffd_wp_resolve);
 			pages++;
 			spin_unlock(ptl);
-			shared_pmd = true;
 			address |= last_addr_mask;
 			continue;
 		}
@@ -6522,22 +6511,16 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 				pte = huge_pte_clear_uffd_wp(pte);
 			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
 			pages++;
+			tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
 		}
 
 next:
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
+	tlb_flush_mmu_tlbonly(tlb);
+	huge_pmd_unshare_flush(tlb, vma);
 	/*
 	 * No need to call mmu_notifier_arch_invalidate_secondary_tlbs() we are
 	 * downgrading page table protection not changing it to point to a new
@@ -6904,18 +6887,27 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 	return pte;
 }
 
-/*
- * unmap huge page backed by shared pte.
+/**
+ * huge_pmd_unshare - Unmap a pmd table if it is shared by multiple users
+ * @tlb: the current mmu_gather.
+ * @vma: the vma covering the pmd table.
+ * @addr: the address we are trying to unshare.
+ * @ptep: pointer into the (pmd) page table.
+ *
+ * Called with the page table lock held, the i_mmap_rwsem held in write mode
+ * and the hugetlb vma lock held in write mode.
  *
- * Called with page table lock held.
+ * Note: The caller must call huge_pmd_unshare_flush() before dropping the
+ * i_mmap_rwsem.
  *
- * returns: 1 successfully unmapped a shared pte page
- *	    0 the underlying pte page is not shared, or it is the last user
+ * Returns: 1 if it was a shared PMD table and it got unmapped, or 0 if it
+ *	    was not a shared PMD table.
  */
-int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
-					unsigned long addr, pte_t *ptep)
+int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
 	unsigned long sz = huge_page_size(hstate_vma(vma));
+	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd = pgd_offset(mm, addr);
 	p4d_t *p4d = p4d_offset(pgd, addr);
 	pud_t *pud = pud_offset(p4d, addr);
@@ -6927,18 +6919,36 @@ int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
 	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
 	hugetlb_vma_assert_locked(vma);
 	pud_clear(pud);
-	/*
-	 * Once our caller drops the rmap lock, some other process might be
-	 * using this page table as a normal, non-hugetlb page table.
-	 * Wait for pending gup_fast() in other threads to finish before letting
-	 * that happen.
-	 */
-	tlb_remove_table_sync_one();
-	ptdesc_pmd_pts_dec(virt_to_ptdesc(ptep));
+
+	tlb_unshare_pmd_ptdesc(tlb, virt_to_ptdesc(ptep), addr);
+
 	mm_dec_nr_pmds(mm);
 	return 1;
 }
 
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
 #else /* !CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING */
 
 pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -6947,12 +6957,16 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 	return NULL;
 }
 
-int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep)
+int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
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
@@ -7219,6 +7233,7 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 	unsigned long sz = huge_page_size(h);
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_notifier_range range;
+	struct mmu_gather tlb;
 	unsigned long address;
 	spinlock_t *ptl;
 	pte_t *ptep;
@@ -7229,6 +7244,7 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 	if (start >= end)
 		return;
 
+	tlb_gather_mmu(&tlb, mm);
 	flush_cache_range(vma, start, end);
 	/*
 	 * No need to call adjust_range_if_pmd_sharing_possible(), because
@@ -7248,10 +7264,10 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		if (!ptep)
 			continue;
 		ptl = huge_pte_lock(h, mm, ptep);
-		huge_pmd_unshare(mm, vma, address, ptep);
+		huge_pmd_unshare(&tlb, vma, address, ptep);
 		spin_unlock(ptl);
 	}
-	flush_hugetlb_tlb_range(vma, start, end);
+	huge_pmd_unshare_flush(&tlb, vma);
 	if (take_locks) {
 		i_mmap_unlock_write(vma->vm_file->f_mapping);
 		hugetlb_vma_unlock_write(vma);
@@ -7261,6 +7277,7 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 	 * Documentation/mm/mmu_notifier.rst.
 	 */
 	mmu_notifier_invalidate_range_end(&range);
+	tlb_finish_mmu(&tlb);
 }
 
 /*
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 247e3f9db6c7a..030a162a263ba 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -426,6 +426,7 @@ static void __tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm,
 #endif
 	tlb->vma_pfn = 0;
 
+	tlb->fully_unshared_tables = 0;
 	__tlb_reset_range(tlb);
 	inc_tlb_flush_pending(tlb->mm);
 }
@@ -468,6 +469,12 @@ void tlb_gather_mmu_fullmm(struct mmu_gather *tlb, struct mm_struct *mm)
  */
 void tlb_finish_mmu(struct mmu_gather *tlb)
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
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 283889e4f1cec..5c330e817129e 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -652,7 +652,7 @@ long change_protection(struct mmu_gather *tlb,
 #endif
 
 	if (is_vm_hugetlb_page(vma))
-		pages = hugetlb_change_protection(vma, start, end, newprot,
+		pages = hugetlb_change_protection(tlb, vma, start, end, newprot,
 						  cp_flags);
 	else
 		pages = change_protection_range(tlb, vma, start, end, newprot,
diff --git a/mm/rmap.c b/mm/rmap.c
index 748f48727a162..d6799afe11147 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -76,7 +76,7 @@
 #include <linux/mm_inline.h>
 #include <linux/oom.h>
 
-#include <asm/tlbflush.h>
+#include <asm/tlb.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/migrate.h>
@@ -2008,13 +2008,17 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 * if unsuccessful.
 			 */
 			if (!anon) {
+				struct mmu_gather tlb;
+
 				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
 				if (!hugetlb_vma_trylock_write(vma))
 					goto walk_abort;
-				if (huge_pmd_unshare(mm, vma, address, pvmw.pte)) {
+
+				tlb_gather_mmu(&tlb, mm);
+				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
 					hugetlb_vma_unlock_write(vma);
-					flush_tlb_range(vma,
-						range.start, range.end);
+					huge_pmd_unshare_flush(&tlb, vma);
+					tlb_finish_mmu(&tlb);
 					/*
 					 * The PMD table was unmapped,
 					 * consequently unmapping the folio.
@@ -2022,6 +2026,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 					goto walk_done;
 				}
 				hugetlb_vma_unlock_write(vma);
+				tlb_finish_mmu(&tlb);
 			}
 			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
 			if (pte_dirty(pteval))
@@ -2398,17 +2403,20 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 * fail if unsuccessful.
 			 */
 			if (!anon) {
+				struct mmu_gather tlb;
+
 				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
 				if (!hugetlb_vma_trylock_write(vma)) {
 					page_vma_mapped_walk_done(&pvmw);
 					ret = false;
 					break;
 				}
-				if (huge_pmd_unshare(mm, vma, address, pvmw.pte)) {
-					hugetlb_vma_unlock_write(vma);
-					flush_tlb_range(vma,
-						range.start, range.end);
 
+				tlb_gather_mmu(&tlb, mm);
+				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
+					hugetlb_vma_unlock_write(vma);
+					huge_pmd_unshare_flush(&tlb, vma);
+					tlb_finish_mmu(&tlb);
 					/*
 					 * The PMD table was unmapped,
 					 * consequently unmapping the folio.
@@ -2417,6 +2425,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 					break;
 				}
 				hugetlb_vma_unlock_write(vma);
+				tlb_finish_mmu(&tlb);
 			}
 			/* Nuke the hugetlb page table entry */
 			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
-- 
2.52.0


