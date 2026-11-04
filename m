Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB9B7606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 10:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E5JLGxhF
Received: by kanga.kvack.org (Postfix)
	id BDDD66B00EF; Wed,  4 Nov 2026 05:54:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8576B05B4; Wed,  4 Nov 2026 05:54:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4746B05B5; Wed,  4 Nov 2026 05:54:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8BBB66B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:54:22 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12B99C06A8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:54:22 +0000 (UTC)
X-FDA: 85397127564.30.3DDC7D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 72D3A100004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:54:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E5JLGxhF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793789660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=q1WatbcgkUw8K3+oMM+B9PLqn14NjJO7D6DOhhw+67c=;
	b=cbKYk9y6c+FAzAU7lsnAkaUrMZndbuD/7VVOKI9d50vWGvHSvX7/tgVTrCxu61tpFNLvDQ
	lf4llZYMRv9WGdQqfTMScvpmX76G4a2BmJJnJoM2QGIbQpjyrFaefQEImdM7uELR8dTnrq
	tkwMqFE98O73d8Rl/GEfZaEYDQbd8yo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E5JLGxhF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793789660;
	b=VAkOyALgiuBgrpe5VcSI7Y2aB+amlNrh5/9wsgYUyeUquo4Lfdsq3gmkyivxfohGHp5K+X
	H6hJeYyDIts2GUAM7VfiPxOt3PKm0wwOZVNRqkGob5f31P7OWK23UudKm9iTeHWiRSIUpb
	RVmuPB8Tr5vW1HUGjVvizt2itW9ZKNo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B48EB42B8F;
	Wed,  4 Nov 2026 10:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD2D1F000C1;
	Wed,  4 Nov 2026 10:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793789659;
	bh=q1WatbcgkUw8K3+oMM+B9PLqn14NjJO7D6DOhhw+67c=;
	h=From:To:Cc:Subject:Date;
	b=E5JLGxhFshDJsH7jtdhBf7Q09tJ70fjxu/TJdoeOyy47tA+x92PQGVxmIWH013sTg
	 K4Tj+bJ87bdXAh2fC3PLPk1xYaMn/7EJ+0oP6HxdADwTV7ZVIM0teDQTVUomziuLkT
	 KjfJCP+Uq781fJA1IXxmPmG5Jx4SS54y8MB//p7fwdnomhKVQzc3AZYRIMH/URFBMv
	 vYocFAj8rj/qgko9XtavbvYgo3+5W/5IIv9luH4h35b8bwyEBl6Xz0YHMwj7ihIBMm
	 JR3ff4Gn7d0kaLjhL6uIwtlfnwYOQ6nHGJ0ulNiiJHg1Rwk7z+Mj9UILA4//67HSB7
	 nOJ1v1cI4pB0g==
From: Imre Kaloz <kaloz@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] sparc64: replace move_pte() with a D-cache flush in flush_cache_range()
Date: Wed,  4 Nov 2026 11:52:58 +0100
Message-ID: <20261104105300.16260-1-kaloz@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 72D3A100004
X-Stat-Signature: hz8un4ehp7faqo8cxxefzwtq8ntztjcj
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793789660-792703
X-HE-Meta: U2FsdGVkX1/QQB4/xYloGe3de6GHuHyV9imryEK2VLTRpZ4ZtBMVsyW+1QSVlVygMmGCws+op3kWK3ZDiOhbmkkvt4SBTFsDCBN+1i5YIehIFHP0LGHcoT5cAan8C6jHYdn9gVu0cVWdt0IOvEz1vmVOerxdJnVl1AyJDya898qrpmCqPJKa/b5bot+HqkEWXzy/Js71dsOFk+Ett2MXXyxUBZ/q0pj1LKl8fABqqPoJ3kwKYG+C9DvgMZbWCbaTaJZppxZPge90CFdqh2LvBAMP1KNvPQvPRWcnB+Nq/xafn0pIi8YWUgcES1kOViOp2ZX1Ptk+8dupP/Yu3zV5k/p4OAofnQK0vLST6XQKn3h/SBUeW166Af5npDCldboUx1eHZmh+IWiVyjXg4d94F5ctVO1Ll7Ouv30LSKHMpoMfELD94mjfRQnGI3VZg+zb32mfUKYAjR/zsVdrU+FkbEF3hHvBv/iULgIQ0Ha3g9MNqd+IhxRQ5A8aAeybXQLWFFFdXqUm6CrXuwL5To7J5k5O7tWyCsLVW/SQ0Drnzs1n21FfVgptDu0KfjMFrMSxlg+wMVUFKPxYpQbuhbQ3z4jczx3A0r/snmPDftPbeausFeMAJKBSMaHD11hLqtsULToEIaKpK+6iumlTzZFrt+XzTtQPv7fRq/kmp2LehyvuDyf8CtDkK5k5+SCS/GMHivGG8U/IT+xaUqDRE8jHCUmq306ktmtuI+8lC65HCJDSl4w23PMsKOWLf4ZYLOgYVPfUYf7SU1+txvow/ivy7RnXNc6Yi/f9kWDn1r/cQYnjpzmHnR1nCEKNo182G4ELSPER9yhhKeO8d9NClH3Bu75ghW5hHcWoJmxRoGXitMqQFAds5aUYp6D+DVfCeXZ4OTvMzAO0LG4LMI54l2CPoPNjuhaMXXihksknGBgKGDJ4bNfMpuxdnKrqOsa6O7W8p2jd4vjnTQwCra0hFTf
 IE/9Lyaa
 0kAuexO+kl7wBGyWGCvL0fhZ1kk0+lqZ1hK60BZNWh7jk/opirYB0MSd67S6iJFLUcL2psatY8rqrtLiAPLw69HpCCg8DxeapyFjytAJURAmkPkSTb8ZOC3//ZtkW9cgf7GiDnwh7ftxItHEx81n7aon7Z1RJlGv8nhR/PTaXKvoCTU0wzmwZ+1pMuFbm1utrUa8/fmRHfa0FTqUpAI9T8LLzkHFzGhjmyiaYg0puqR1pCDc2664NedPKnMxbKqa7MQNcBSq9YTE9x1vZW5GjXEP5KS4gUC7JUiiDz9MQBYSP40OMc/TjV9KKj7RE+G4vf6SfjrN6bF+skhw1zZ8qMWdvhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mremap() can move a page to an address of the other D-cache color,
leaving lines of the old color in the virtually indexed D-cache of
Spitfire and Cheetah CPUs.  move_pte() flushed the page for each PTE
moved, which is only correct while move_ptes() handles one PTE at a
time.

Drop move_pte(), which no other architecture defines, and flush the
whole D-cache in flush_cache_range(), which mremap() calls on the old
range before moving the PTEs.  This keeps the fix in sparc64 without
a page table walk.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://lore.kernel.org/all/409079fe-ab52-4389-9fe0-d7246eb27bad@kernel.org/
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
---
Andreas asked for this as a separate patch once the merge window was
over [1]. It applies on top of sparc for-next.

[1] https://lore.kernel.org/all/4fba060e-c4f4-4d73-8efe-dbed0b5a7bc3@gaisler.com/

 arch/sparc/include/asm/cacheflush_64.h |  4 ++--
 arch/sparc/include/asm/pgtable_64.h    | 21 ---------------------
 arch/sparc/mm/init_64.c                | 18 ++++++++++++++++++
 include/linux/pgtable.h                |  4 ----
 mm/mremap.c                            |  1 -
 5 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/arch/sparc/include/asm/cacheflush_64.h b/arch/sparc/include/asm/cacheflush_64.h
index 54a2d37008e6..1a116b288816 100644
--- a/arch/sparc/include/asm/cacheflush_64.h
+++ b/arch/sparc/include/asm/cacheflush_64.h
@@ -21,8 +21,8 @@ void __flushw_user(void);
 #define flush_cache_mm(__mm) \
 	do { if ((__mm) == current->mm) flushw_user(); } while(0)
 #define flush_cache_dup_mm(mm) flush_cache_mm(mm)
-#define flush_cache_range(vma, start, end) \
-	flush_cache_mm((vma)->vm_mm)
+void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
+		       unsigned long end);
 #define flush_cache_page(vma, page, pfn) \
 	flush_cache_mm((vma)->vm_mm)
 
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index c26f2888aa18..310b66459521 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -935,27 +935,6 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 #define pte_clear(mm,addr,ptep)		\
 	set_pte_at((mm), (addr), (ptep), __pte(0UL))
 
-#ifdef DCACHE_ALIASING_POSSIBLE
-/* This flushes only the page the PTE maps, so it relies on move_ptes()
- * calling it for one PTE at a time, which the default pte_batch_hint()
- * guarantees.
- */
-#define __HAVE_ARCH_MOVE_PTE
-#define move_pte(pte, old_addr, new_addr)				\
-({									\
-	pte_t newpte = (pte);						\
-	if (tlb_type != hypervisor && pte_present(pte)) {		\
-		unsigned long this_pfn = pte_pfn(pte);			\
-									\
-		if (pfn_valid(this_pfn) &&				\
-		    (((old_addr) ^ (new_addr)) & (1 << 13)))		\
-			flush_dcache_page_all(current->mm,		\
-					      pfn_to_page(this_pfn));	\
-	}								\
-	newpte;								\
-})
-#endif
-
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
 void paging_init(void);
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 6a0ba9a01a21..a1ab1eacbf33 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -3115,6 +3115,24 @@ void flush_cache_vmap(unsigned long start, unsigned long end)
 #endif
 }
 
+/*
+ * mremap() moves the PTEs of [start, end) to addresses that may have the
+ * other color, and calls this on the old range first.  Flush the whole
+ * D-cache so no line of the old color outlives the move.
+ */
+void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
+		       unsigned long end)
+{
+	/* flush_cache_mm() spills the user register windows. */
+	flush_cache_mm(vma->vm_mm);
+#ifdef DCACHE_ALIASING_POSSIBLE
+	/* The D-cache is virtually indexed on Spitfire and Cheetah. */
+	if (tlb_type == spitfire || tlb_type == cheetah ||
+	    tlb_type == cheetah_plus)
+		flush_dcache_all();
+#endif
+}
+
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 {
 	if (start < HI_OBP_ADDRESS && end > LOW_OBP_ADDRESS) {
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 780fe849ff8b..c729c3cc8bda 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1470,10 +1470,6 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 }
 #endif
 
-#ifndef __HAVE_ARCH_MOVE_PTE
-#define move_pte(pte, old_addr, new_addr)	(pte)
-#endif
-
 #ifndef pte_accessible
 # define pte_accessible(mm, pte)	((void)(pte), 1)
 #endif
diff --git a/mm/mremap.c b/mm/mremap.c
index 0d06d7f37f19..87cb15027bfd 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -289,7 +289,6 @@ static int move_ptes(struct pagetable_move_control *pmc,
 			force_flush = true;
 		}
 		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
-		pte = move_pte(pte, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
 
 		if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte))

base-commit: c95443b98771a74c6689f5e7bbc56794fe95f550
-- 
2.47.3


