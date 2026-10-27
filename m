Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15A54606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 21:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lRpHIkQW
Received: by kanga.kvack.org (Postfix)
	id 0CF516B08F5; Tue, 27 Oct 2026 17:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7996B08F7; Tue, 27 Oct 2026 17:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFEB86B08F8; Tue, 27 Oct 2026 17:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C95176B08F5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:27:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38554140B10
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:27:29 +0000 (UTC)
X-FDA: 85369692618.17.42B52C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7A75640009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:27:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRpHIkQW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793136447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIdGfGk78bfglsNu6zDlyEATBzGyUL+pcizfgre/lSI=;
	b=aBDG0J1MUF91Wzy2PxlXXcOIfmjbO0HTJgLOhGOv8CuC72pgtRnd+SP670fTB4QNsN74S8
	HQUNkzdVn9AvqcNjescMd+6Nj3XOEbHe+g4zoB7rr3doF/dp1CBhCneetIYlidcJGL8c93
	G3KK5yFrt/4coqsVIJ4XOr6gGTzskRk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRpHIkQW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793136447;
	b=P2jd4+eGFnyh1tQS+rtIpCpV2v7sv7Gk4XTFB1K/iH4C5aSc4gfxWWKOZ2Zq/UsJq7zDBz
	wbhlhUeqKBELgGM3zK/sDUbAL41zpQAkujCaDh4vOn1Xsp9SoLk4Oj0o9uT+zNIZ+SwDNe
	QXd5qOnSqj95amiWI+C9zM+cUcOJ8Qc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4402860142;
	Tue, 27 Oct 2026 21:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB8E1F01825;
	Tue, 27 Oct 2026 21:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793136446;
	bh=aIdGfGk78bfglsNu6zDlyEATBzGyUL+pcizfgre/lSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRpHIkQWFRNurrVhjsPgALh9t20hxZewaZXFTrnBbqVoCqxvjkoa5UPVFhAluTcfd
	 AKrBFLD6WP9DDQbdMINiBRijGcZ6k8IGjAcLgsfuT4Wdhk7Flg7ZmB3bt1HQ5d65fL
	 ribps1QIl8kOIo+QU9VPKS/TUHVRP5bvOZKCmSgK34ElIJ25n9PxAnpcM+ed/DpXxg
	 wTJ9dwOFGp6+vsdTTm3LNFhSrdSQKItJnvVEoLa+4nXRd70m6IQXPjBF5SyoFKlCKq
	 XsL9dbp3wYyM7MPj7uOzvfB8wHBJiFdzw2B18pVKxBLn7NfJSHpAv0MH1QXZ6InclV
	 x8rkMO3GPeHzQ==
From: Imre Kaloz <kaloz@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Magnus Lindholm <linmag7@gmail.com>
Subject: Re: [PATCH v3 4/4] mm: pass the number of PTEs to move_pte()
Date: Tue, 27 Oct 2026 22:26:09 +0100
Message-ID: <20261027212610.6798-1-kaloz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <409079fe-ab52-4389-9fe0-d7246eb27bad@kernel.org>
References: <cover.1792609488.git.kaloz@kernel.org> <2bc50d2a6829b49ee909e5bb943244859661a40b.1792609488.git.kaloz@kernel.org> <409079fe-ab52-4389-9fe0-d7246eb27bad@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7A75640009
X-Stat-Signature: actry5ngi1azn6nx8md68k4r3wbnaaa8
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793136447-432973
X-HE-Meta: U2FsdGVkX1958jIjCiimx2EUC2L0RsMTrTNf3Jl/zj1RjTeo8uwfMIUioGzeYftfDW5l4eOzJtSxg2KtGpTVfS94LLnjCS4P3dljrqyL0K1xw7BpSTwIQCk7QSm6Tdmgalr9WCmvtVHFxfP4ALYTAQe5ti8ZBwVnOp3Z1bIIOI2hs3PJk7O/TzeDiFj0hsi+5VuAODREISPkx0gimOGj+HVmi8kAf+HgtNVHVFDSWrJ2c0GLTD/HQuZ6UVGyEBKN5f4JRfErCtSx7Al1qYDn1Px0wvU47BL2Z0LsDiCJTiijHPmWA1HtokvXToIUTfGMFbmSQAfzBE2VZheRhR6iZbtvLc24qbBM3SSh6s2CftRrfbgbeUUOjj/NCg6lY1/xrgT5JvoUx0iVIC8oHjI5lyeR+bB0y9bDQH6guSOcRvf703rwo+NWzvI5BysdSG5N/+hc2KNI5ymvbpKfMcF9wd9jBRgGPUOxEsKJtJWTtUVxImJDZd2PGcAPKFO7OKfNSdGHufJnT+mrpO5WTRCwsnDEemZFujiM14+mkRf+VXgsRRLCQf/7c1DtXvsR5XekOw0opuUCCpJH7fOXShCYS1hVN+Ow32QZmFXKZYMRbRq/RWYooZzvjcx6xJSj6wo0aqvXCH7aJntjis8xDtu9BfG4p8xX3SW2K1ySKtMD9z0W+6ghXEFFtm+M9yZiy4/9F3UVFSZsC5sro22rME0UHZT/mckTG6vHSmdGpC4AjZY+Xk7IslgxWcy8Off8CoJ83Mv2c2nBNcWNC9fIA1K8+Sj4ptJ7HPL/5kLnkx3MlaD7/ZdNBZfr0Sw4eka6ccualuv97srUeIwqt6GhyqTY0swuplD6tiGpAVD0UQCtLjpbyraqX5fZxOq85+yhXzr2Qt8zhabWVjfNxgQmfB00tlqe/oMfENID0D1gp6LbKyE7tlRP8WNvrVAmAPpLyW7bUXKmRhrDuM3Lz/qTo8S
 8amLoHr0
 L8aiwvCF/ppd2LE7rnMJUf72EJBw65NNfLMpNEclwPHOzZOhsTfq8zx6roRyDLS/83wcUDfykddwZBw3Jrl57sqchHMOUqCKHGWaIE+4SsWBAUtBcPBbiiwaNIsCJVzhRnyGaz66DMndArcediE0ZxMcr1bNvVSAREEGMaYMSBoprv2YXWa8NwvU/ELIBCvuMcK/x9pQcRnwJEQZcGk8vGypyhHZDwMsupuDbMj13EBlbllCy9yBWMO6DqY4o+1RoKaG5FIrUnzpZFI4cWBfGIkS7blRlj3fRHbjq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On 10/23/26 22:53, David Hildenbrand (Arm) wrote:
> Is there some way we can avoid this
> helper-that-shouldn't-exist-but-someone-hacked-it-in entirely?
> If it makes sparc64 slightly slower #dontcare.

I tried three ways of doing that on an Ultra 45 (UltraSPARC IIIi, two
CPUs), all with move_pte() removed entirely:

 A) sparc64's flush_cache_range() flushes every present page in the
    range from the D-cache;
 B) sparc64's flush_cache_range() flushes the whole D-cache;
 C) A for ranges of up to 10 pages, B above that.

All three pass a test that moves pages between cache colors with
mremap() and checks for stale data. With no flush at all the same test
finds about 15 million stale words per run, so it does catch the
problem.

Medians of 20 runs over two boots per kernel, against this series'
move_pte() as the baseline:

                            move_pte()        A          B          C
  apt-cache gencaches           6.63 s     +0.2%      +0.3%      +0.1%
  fork+exec                                +0.7%      +3.1%      -0.6%
  mremap 8K, same color          14 us      20 us      43 us      20 us
  mremap 8K, other color         21 us      20 us      43 us      20 us
  mremap 1M, same color          30 us     524 us      60 us      59 us
  mremap 8M, same color         209 us    4152 us     229 us     227 us
  mremap 8M, other color       4176 us    4166 us     236 us     233 us
  mremap 8M THP, same color      14 us    3933 us      43 us      42 us

flush_cache_range() has more callers than mremap(), mostly in rmap,
so I also timed reclaim, migration and writeback (medians of 5):

                                  A          B          C
  MADV_PAGEOUT to swap          +0.4%     +12.9%      -1.3%
  reclaim under memory.max      +1.9%     +17.7%      +2.0%
  msync of shared file mappings -4.4%      -3.4%      -0.4%
  compaction, move_pages()      within 3% for all three

So A pays on large moves, B on reclaim, and C on neither: it costs
the same as A on small ranges and the same as B on large ones. I'd go
with C. It would only flush on Spitfire and Cheetah, which have the
aliasing D-cache, so sun4v and the SPARC64 VII in Magnus's M3000
series skip it.

If that works for you, I'd suggest dropping 4/4 and using C as its
replacement; it's below the scissors, on top of 1/4-3/4.

Pedro, that would also settle the naming and the nr question, since
move_pte() goes away.


Best,
Imre

-- >8 --
Subject: [PATCH] sparc64: replace move_pte() with a flush in flush_cache_range()

mremap() can move a page to an address of the other D-cache color,
leaving lines of the old color in the virtually indexed D-cache of
Spitfire and Cheetah.  move_pte() flushed the page for each PTE moved,
which is only correct while move_ptes() handles one PTE at a time.

Drop move_pte(), which no other architecture defines, and flush the
old range in flush_cache_range(), which mremap() calls before moving
the PTEs.  Flush each mapped page, or the whole D-cache for a range of
more than ten pages, where one whole-cache flush costs about as much
as ten page flushes.

Signed-off-by: Imre Kaloz <kaloz@kernel.org>
---
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
index 1430489b9ac5..2452d959aac1 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -945,27 +945,6 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
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
index d1f94b8d6312..466a4aa1be60 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -3115,6 +3115,95 @@ void flush_cache_vmap(unsigned long start, unsigned long end)
 #endif
 }
 
+static void flush_dcache_pfns(struct mm_struct *mm, unsigned long pfn,
+			      unsigned long nr)
+{
+	for (; nr; nr--, pfn++)
+		if (pfn_valid(pfn))
+			flush_dcache_page_all(mm, pfn_to_page(pfn));
+}
+
+/* A whole-cache flush costs about as much as this many page flushes. */
+#define FLUSH_CACHE_RANGE_ALL_PAGES	10
+
+/*
+ * mremap() moves the PTEs of [start, end) to addresses that may have the
+ * other color, and calls this on the old range first.  Flush every page
+ * mapped in the range from the D-cache, so no line of the old color
+ * outlives the move; a larger range is flushed whole without a walk.
+ * The walk takes no page table lock: mremap() holds the mmap_lock for
+ * writing, and other callers at worst miss a PTE that changes under it.
+ */
+void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
+		       unsigned long end)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long addr, next;
+
+	/* flush_cache_mm() spills the user register windows. */
+	flush_cache_mm(mm);
+#ifdef DCACHE_ALIASING_POSSIBLE
+	/* The D-cache is virtually indexed on Spitfire and Cheetah. */
+	if (tlb_type != spitfire && tlb_type != cheetah &&
+	    tlb_type != cheetah_plus)
+		return;
+
+	if (((end - start) >> PAGE_SHIFT) > FLUSH_CACHE_RANGE_ALL_PAGES) {
+		flush_dcache_all();
+		return;
+	}
+
+	for (addr = start; addr < end; addr = next) {
+		pgd_t *pgd = pgd_offset(mm, addr);
+		p4d_t *p4d;
+		pud_t *pud, pudval;
+		pmd_t *pmd, pmdval;
+		pte_t *start_pte, *ptep, pte;
+
+		next = pgd_addr_end(addr, end);
+		if (pgd_none(pgdp_get(pgd)))
+			continue;
+		p4d = p4d_offset(pgd, addr);
+		next = p4d_addr_end(addr, end);
+		if (p4d_none(p4dp_get(p4d)))
+			continue;
+		pud = pud_offset(p4d, addr);
+		pudval = pudp_get(pud);
+		next = pud_addr_end(addr, end);
+		if (pud_none(pudval))
+			continue;
+		if (pud_leaf(pudval)) {
+			if (pte_present(__pte(pud_val(pudval))))
+				flush_dcache_pfns(mm, pud_pfn(pudval) +
+						  ((addr & ~PUD_MASK) >> PAGE_SHIFT),
+						  (next - addr) >> PAGE_SHIFT);
+			continue;
+		}
+		pmd = pmd_offset(pud, addr);
+		pmdval = pmdp_get_lockless(pmd);
+		next = pmd_addr_end(addr, end);
+		if (pmd_none(pmdval))
+			continue;
+		if (pmd_leaf(pmdval)) {
+			if (pte_present(__pte(pmd_val(pmdval))))
+				flush_dcache_pfns(mm, pmd_pfn(pmdval) +
+						  ((addr & ~PMD_MASK) >> PAGE_SHIFT),
+						  (next - addr) >> PAGE_SHIFT);
+			continue;
+		}
+		start_pte = pte_offset_map(pmd, addr);
+		if (!start_pte)
+			continue;
+		for (ptep = start_pte; addr < next; addr += PAGE_SIZE, ptep++) {
+			pte = ptep_get(ptep);
+			if (pte_present(pte))
+				flush_dcache_pfns(mm, pte_pfn(pte), 1);
+		}
+		pte_unmap(start_pte);
+	}
+#endif
+}
+
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 {
 	if (start < HI_OBP_ADDRESS && end > LOW_OBP_ADDRESS) {
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a..b95eea612261 100644
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
index e8df5cdb0ac9..2257e3010f41 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -289,7 +289,6 @@ static int move_ptes(struct pagetable_move_control *pmc,
 			force_flush = true;
 		}
 		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
-		pte = move_pte(pte, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
 
 		if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte))

