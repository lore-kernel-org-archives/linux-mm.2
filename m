Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B00606A325
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aBOiiwUW
Received: by kanga.kvack.org (Postfix)
	id 0EA876B05CE; Wed, 28 Oct 2026 16:16:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09AE36B05CF; Wed, 28 Oct 2026 16:16:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECCA46B05D0; Wed, 28 Oct 2026 16:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B127E6B05CE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:16:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 35EF640177
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:16:24 +0000 (UTC)
X-FDA: 85373142288.15.E462DE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 59DA61C000E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:16:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aBOiiwUW;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zVNhQTz4P8YErSCLT2d+RLkWNh4QNHlHkejr3ylktPI=;
	b=2PYmHH8vsMFT0bmHUlQwjns8413RUZg6XoaZD4tEmpq7ZoaWypHCMnZ72xFNVVuj1A3Lv+
	djzcMIRdeqAZ4DDs3csxk64haGF8fBUIo/Ef7StDYyOtetR/dWNCF911GOfSklvFEE2EK3
	ZZ10hqaPMj7GeHVgthj/rYdfva5ypg8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aBOiiwUW;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218582;
	b=ASa59LaRtedC8wsRNZ3LabbfvnFon+fkyHu4roUX5ju6TC0cmwA18BBWosgVIZeRF6cGvK
	QcNpI8tURh/o7oMAwN1KCnJCcuLp2tqhzh67AFxJSLIlHOZL2oFQumlQN8aG7vyD6NNICj
	6mgMK0UpjKlIK2MSDeE7o87P5a1oBxo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A05C1404AC;
	Wed, 28 Oct 2026 20:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7093F1F031E1;
	Wed, 28 Oct 2026 20:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218581;
	bh=zVNhQTz4P8YErSCLT2d+RLkWNh4QNHlHkejr3ylktPI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aBOiiwUW+1oShy4wpMapm/OmigTyXlwV71WiJYy0joVOtsxscBOIh4CrTbWU1y26E
	 Qh3SXfmyynsjDqDUS6VO6r1Zl30nflHLTpUKvNpO/qRhf2L8YmTPAiO9JbqvWqfIIt
	 +DEk91d75sdTgp90FOhuSDercjGUai18sC4+wzlPGJ3JX76YdAsk5rbRUZoLnYnsIr
	 oUfB7DdLNNmG7sl+ro6ef45/wlEP0aibZihxpe8RR5fU/Ub1zfHen4T8csLBShjybg
	 I8HWXXX9nNakee72T/ztM4cVghmeWufhV6OmujHWMoeP0+28u2AsMibCrw5JZ96zKQ
	 oFZRrmQ2gOozQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 21:13:43 +0100
Subject: [PATCH 15/15] RFC: mm/hugetlb: delay anon folio rmap removal until
 after the TLB flush
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_hugetlb-v1-15-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
In-Reply-To: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9027; i=david@kernel.org;
 h=from:subject:message-id; bh=/QKVObd/U9vskx+gsp/U8jaY46gGzOnFlcmK4jcuyIA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehZcda+TP28LS9rxom+I+lpQZ+1Lv6eTwHtRuZjo/9
 cahH0xKHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExE5BQjw8F1rYf0c+2X8tYl
 Vs75/fEDM7/IzIOS55yzm6JEFz57WM3IML1RYF2DX9DUsjen9mY+1tWXeHpR6Wny0xcHavb6tXt
 I8QEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 59DA61C000E
X-Stat-Signature: p4xgac115tnbm3y57ihooji9pbkaknmb
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793218582-290509
X-HE-Meta: U2FsdGVkX1/17PAF3QNU5HYUch5BU/9WAtJ72x0Cd8wjb5Bh1WItqQ+/gr8mLo/JEAMiBaRNttUdfwF7/KzcI1hl4JEt8ttLjIw813uLoPcvyAaBVy1zxRuCOVCGz3OmBh+bAi5QymJ1uPWpa8qFkpKZhYpcINSW749l7e7cm63GF+vLXtBwlftuQvkE/gHEM2POkiPhP2PDGJRU26ctrkkTRD6dZY+s4K7B6/rTfbLnQ7SyHiYnfcPHpVoOua/IIhBTb1ziiQm7gI++dyrlpcw708XOyarb3iLSACtqeIPW9Q+OWm1h2akKRN+g9r1x6Wtsf0reUFy1rF/tytZ0VBjAmzTcTPYylWUsSgHAxof6uWomDWV+aR59wgq1V1oKZPrfFY7VVTNWJe9/GYmtU6jQruoMsoNqHbRAHhh760iC1SrGF3owYPPojOwWuWMrasAU+A2PhAXUPglMxI3v/mWvJpDaTcfxuT9TanQXj1ayKWH03yPn2SH/sFBiYGecSCGA+VVYA/QopR2ptzgDxD7JshE8p3/VI59yC3wrbODaqqNCvTpkBnIgCELEzdx3bSSxPoG4Wji3MNg6HkcPMya8ESXr/Gc9tiW7hMDSQW+qJhAK/yJLKwZW9N2xDXFaM3Ne4T2PFJtdW3kHs/C2G0xKbd7pGvmdXVr4LugA1QAYypBFZS3SL7gmzCx/9WKhfaf+wuke/8ZyYtMwnfIrU8BRMN2Xn9/4Q540jT5UZ2n/8Jufs6qwD1ShveQu9nFYGri4IgTcCeJm7FK2iz/tnKQ9jI/8Guml8THSLooKKb9ef5nPV1YrMOF5TZ4XHBsUVnaZsRG1ylYDbr6IU0KlG/0cHm/oQf/52/CCZpC5DC3abXdY+Ef2NMZEu2JxR/Pp0+o/jlT5ztydUH5sgHdKSwE8EfIywWBUaEE2pdvhQOn43aYDAJvvUl1wcQKyjlNZoqg6ql0/gxGgwvVcUsq
 VJIIM0ZI
 ADKiTa3JTQdcyGIURr9FlatvFEVMn2BijxpGynuGflhJXFzi3SyCeJHAgcZeeDEPrsuQUYtn1+/NxIoWW0wQVP2jUOUGH6BWwV4ouk7Ufvb3+tLPhumuZrudGeza9verVIX7h7OguNFCj6ZYRGO+qiwktwES5CUJG2rp7ro+ATaapz6KA+Fpb9zEpjFNQvg+GsMDeQ2EGYoiBQDGhgYXOC8dbZhYYilmcw9VcmH4VwOJteU3bYsd2qj/WJELXBFCgWHf3ebLidTAdqgnPn+yzLQgQrmOs+s5lRQ1PSr0tCCcosRQsGTukuboprTuTGmFSlzfY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

After fork(), parent and child map anonymous folios read-only shared
by CoW. On a write fault, hugetlb_wp() reuses an anonymous page instead of
copying it if its mapcount is 1. As documented, switching to the safer
refcount would cause more harm than help with these scarce resources.

munmap() and MADV_DONTNEED unmap such folios and decrement the mapcount
before the TLB is flushed. Until then, another thread of the process can
still read the page through a stale TLB entry:

    child: reader        child: munmap()       parent: writer
    =============        ===============       ==============
    reads the page
                         clears the entry
                         mapcount drops to 1
                                               store to the page
                                                 hugetlb_wp() reuses it
    reads the store
      /* leak */
                         flushes the TLB

Similar observations are also known and possible with things like
vmsplice().

Extend the mmu_gather delayed-rmap machinery to handle hugetlb folios.
Defer anonymous hugetlb rmap removal until after the batched TLB flush.

Flush the TLB and remove pending rmaps when the batch fills and before
leaving the VMA, then drain the batch so later rmap flushes cannot process
the same entries again. This is very similar to how zap_present_ptes()
operates.

Skip deferral at exit. On UP, flush before removing the rmap. With
MMU_GATHER_NO_GATHER, clearing the entry already flushes the TLB.

Restore reservations after the actual rmap removal, preserving the existing
mapcount check.

This is very likely not stable-worthy, as hugetlb is commonly not used
for applications with different parent vs. child trust boundaries.

Fixes: 24669e58477e ("hugetlb: use mmu_gather instead of a temporary linked list for accumulating pages")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/s390/include/asm/tlb.h |  5 +++--
 include/asm-generic/tlb.h   |  5 +++--
 include/linux/hugetlb.h     |  7 +++++++
 mm/hugetlb.c                | 38 +++++++++++++++++++++++++++++++++-----
 mm/mmu_gather.c             | 14 ++++++++++----
 5 files changed, 56 insertions(+), 13 deletions(-)

diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index 619fd41e710e..3408ee400d23 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -24,7 +24,7 @@
 
 static inline void tlb_flush(struct mmu_gather *tlb);
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
-		struct page *page, int page_size);
+		struct page *page, int page_size, bool delay_rmap);
 static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
 		struct page *page, unsigned int nr_pages, bool delay_rmap);
 
@@ -45,8 +45,9 @@ static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
  * s390 doesn't delay rmap removal.
  */
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
-		struct page *page, int page_size)
+		struct page *page, int page_size, bool delay_rmap)
 {
+	VM_WARN_ON_ONCE(delay_rmap);
 	free_folio_and_swap_cache(page_folio(page));
 	return false;
 }
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index fbe1114e9a44..0fd51970a87e 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -245,7 +245,8 @@ struct mmu_gather_batch {
  */
 #define MAX_GATHER_BATCH_COUNT	(10000UL/MAX_GATHER_BATCH)
 
-extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_size);
+bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
+		int page_size, bool delay_rmap);
 bool __tlb_remove_folio_pages(struct mmu_gather *tlb, struct page *page,
 		unsigned int nr_pages, bool delay_rmap);
 
@@ -465,7 +466,7 @@ static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
 static inline void tlb_remove_page_size(struct mmu_gather *tlb,
 					struct page *page, int page_size)
 {
-	if (__tlb_remove_page_size(tlb, page, page_size))
+	if (__tlb_remove_page_size(tlb, page, page_size, false))
 		tlb_flush_mmu(tlb);
 }
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index badb8790653e..96a83fe0b7d6 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -275,6 +275,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long cp_flags);
 void hugetlb_unshare_all_pmds(struct vm_area_struct *vma);
 void fixup_hugetlb_reservations(struct vm_area_struct *vma);
+void hugetlb_folio_restore_rsv_on_unmap(struct vm_area_struct *vma,
+		struct folio *folio);
 void hugetlb_split(struct vm_area_struct *vma, unsigned long addr);
 
 unsigned int arch_hugetlb_cma_order(void);
@@ -460,6 +462,11 @@ static inline void fixup_hugetlb_reservations(struct vm_area_struct *vma)
 {
 }
 
+static inline void hugetlb_folio_restore_rsv_on_unmap(struct vm_area_struct *vma,
+		struct folio *folio)
+{
+}
+
 static inline void hugetlb_split(struct vm_area_struct *vma, unsigned long addr) {}
 
 #endif /* !CONFIG_HUGETLB_PAGE */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 06ef8ba41df7..c8e3b8a6421a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5310,7 +5310,7 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 }
 
 /* Must be called after rmap removal. */
-static void hugetlb_folio_restore_rsv_on_unmap(struct vm_area_struct *vma,
+void hugetlb_folio_restore_rsv_on_unmap(struct vm_area_struct *vma,
 		struct folio *folio)
 {
 	struct hstate *h = hstate_vma(vma);
@@ -5377,6 +5377,8 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	last_addr_mask = hugetlb_mask_last_page(h);
 	address = start;
 	for (; address < end; address += sz) {
+		bool delay_rmap = false;
+
 		ptep = hugetlb_walk(vma, address, sz);
 		if (!ptep) {
 			address |= last_addr_mask;
@@ -5449,19 +5451,45 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 					make_pte_marker(PTE_MARKER_UFFD_WP),
 					sz);
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
-		hugetlb_remove_rmap(folio);
+		/*
+		 * hugetlb_wp() uses mapcount to decide whether an anonymous
+		 * folio can be reused. Delay rmap removal until stale TLB
+		 * entries are gone, unless the mm has no users left.
+		 */
+		if (folio_test_anon(folio) && !tlb->fullmm) {
+			delay_rmap = tlb_delay_rmap(tlb);
+			/*
+			 * Without delay-rmap support, just flush before
+			 * dropping the PTL. Except with MMU_GATHER_NO_GATHER
+			 * where clearing already flushed the TLB.
+			 */
+			if (!delay_rmap && !IS_ENABLED(CONFIG_MMU_GATHER_NO_GATHER))
+				flush_hugetlb_tlb_range(vma, address, address + sz);
+		}
+		if (!delay_rmap)
+			hugetlb_remove_rmap(folio);
 		spin_unlock(ptl);
 
-		hugetlb_folio_restore_rsv_on_unmap(vma, folio);
+		if (!delay_rmap)
+			hugetlb_folio_restore_rsv_on_unmap(vma, folio);
 
-		tlb_remove_page_size(tlb, folio_page(folio, 0),
-				     folio_size(folio));
+		if (__tlb_remove_page_size(tlb, folio_page(folio, 0), sz,
+					   delay_rmap)) {
+			tlb_flush_mmu_tlbonly(tlb);
+			tlb_flush_rmaps(tlb, vma);
+			tlb_flush_mmu(tlb);
+		}
 		/*
 		 * If we were instructed to unmap a specific folio, we're done.
 		 */
 		if (folio_provided)
 			break;
 	}
+	if (tlb->delayed_rmap) {
+		tlb_flush_mmu_tlbonly(tlb);
+		tlb_flush_rmaps(tlb, vma);
+		tlb_flush_mmu(tlb);
+	}
 	tlb_end_vma(tlb, vma);
 
 	huge_pmd_unshare_flush(tlb, vma);
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 9f353f0e2ef4..b1f9f935e3b1 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -59,14 +59,19 @@ static void tlb_flush_rmap_batch(struct mmu_gather_batch *batch, struct vm_area_
 
 		if (encoded_page_flags(enc) & ENCODED_PAGE_BIT_DELAY_RMAP) {
 			struct page *page = encoded_page_ptr(enc);
+			struct folio *folio = page_folio(page);
 			unsigned int nr_pages = 1;
 
 			if (unlikely(encoded_page_flags(enc) &
 				     ENCODED_PAGE_BIT_NR_PAGES_NEXT))
 				nr_pages = encoded_nr_pages(pages[++i]);
 
-			folio_remove_rmap_ptes(page_folio(page), page, nr_pages,
-					       vma);
+			if (folio_test_hugetlb(folio)) {
+				hugetlb_remove_rmap(folio);
+				hugetlb_folio_restore_rsv_on_unmap(vma, folio);
+			} else {
+				folio_remove_rmap_ptes(folio, page, nr_pages, vma);
+			}
 		}
 	}
 }
@@ -211,9 +216,10 @@ bool __tlb_remove_folio_pages(struct mmu_gather *tlb, struct page *page,
 					     PAGE_SIZE);
 }
 
-bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_size)
+bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
+		int page_size, bool delay_rmap)
 {
-	return __tlb_remove_folio_pages_size(tlb, page, 1, false, page_size);
+	return __tlb_remove_folio_pages_size(tlb, page, 1, delay_rmap, page_size);
 }
 
 #endif /* MMU_GATHER_NO_GATHER */

-- 
2.43.0


