Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8960C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4B9A6B00AC; Tue, 21 Jul 2026 12:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A23586B00AE; Tue, 21 Jul 2026 12:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5776B00AF; Tue, 21 Jul 2026 12:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56B256B00AC
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:25:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D1C9B4022D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:59 +0000 (UTC)
X-FDA: 85013307918.22.3E08241
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2AEFC4000A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U0KPEcmx;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OoOStuo8KyKoTIeQ25xXx08RMnCDns0bk3l2m+n8rO0=;
	b=gfWFNKiYYwVuRUVRT3Q3UXbqWLNzDg8qhaZ48p1+Mvmc627F7cuptJy2RPQ89rgjXVb9s6
	3INBa101eBrkyHIVKDTQgME+8tU1UoBnQ+zKleqcrGR2qeaY3tCBy4yLXqCWa0jQHL6fqg
	sYbG7I+SQtD+BSme4Wk+R4ATwCa/+1U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U0KPEcmx;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651098;
	b=166I2IS5qMgou5hsFXQJHphbQJYOlodqqu42BRpV4meVBHs6A+O973G5O4KKdL+oPepZHC
	g3hIbEbC2bIp3Ah1Ll0DcnFC4Q2cITRzqSwbHInlYa19FYOvoh7P7UrJUrI2EE3avLhKJn
	3hymah+F55qvhgaGPEm86xveo9ED2BA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9497C600FC;
	Tue, 21 Jul 2026 16:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B171F000E9;
	Tue, 21 Jul 2026 16:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651097;
	bh=OoOStuo8KyKoTIeQ25xXx08RMnCDns0bk3l2m+n8rO0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=U0KPEcmxeIhpb5KkLNGFFb2n/jwhhJRa6GcBMYVeqWuOEMj3OusaJMo3L6MX7TRa8
	 CPCDL63C52AFB7ZksJuh0kL/pnCtxvzRVAW++yIwUvzh253Kk3OmekpJCsIu7EMjK/
	 X7U7/ph1GU8bVHbMayYjpHO02vObLH0n4jucsT4ic2CUwDqa9kQlpIjBcpFLj6ePcX
	 a9CR+IXYqEGCWY+BLQQW9NuBJViqRuNsqSr5chNl9ITquDMusqk965joSsQcbbns8X
	 iepUX9IvZ74TfufDXoYCPZUKBTY7kyb2q4Y+UIq6cNRTibIJB+T4A9hFzWa9nPp8ik
	 cL1tFUEdX9swg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:34 +0300
Subject: [PATCH RFC 11/18] x86/mm/pat, mm: set_memory: pull
 change_page_attr() core to mm/
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-11-2c1fc62306b3@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <jackmanb@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2AEFC4000A
X-Stat-Signature: 7on6t6rbjypcfzychck7zznqurpxqk31
X-HE-Tag: 1784651097-647354
X-HE-Meta: U2FsdGVkX187SSeoZrCufUiU25AnZoz6gl/b+86ov1EEIK76YPxjVwiyS2lzziRPe+ZclOLExxrK9yWVieJRZi8ZzU9iAUhETV5zDczjfGxkAwWgVBMoNuHRGKnZkSWh/Nsl/Bp7t6qbEt2bkTI8TBVaz5Xf5pENxJ/J5Kyo9vj4T1WvlAunYRv0YqHjQ+RiIhmgvwJtfUoYCKO9PUJh3SfVR0/X5Uc/YBm3tAQ/HrmDI+KajWC8zcuHSySkKV1eJKWCnecswu6FHWq2000audtmbg3zJVLVkg1cBuGaYRqsp2aXj5Id8mg+7zyG5zOYnxM1YE55cv2/x+yYxRXQryqoi6bNuiSgytlpv5nrpXPUJzmvhsqGARnCC9rGiujBGj02793P+Ky0X9H1Og4C7dFl1/OE6hkck7mkOs4ieDC+t+1dIUIZJtE5XcCB6ebdR4nntsu2gsIJtS7DyLAxbNCWCgjr/BHiTX5XsoEWlzJHjRbBVWRAtatEI0L3Y5uiPhZYJPGQcB547MI7pqkw3h5vckSVyxwpfP95KQrK+au/fPkxHnY6oqqSKFBFKpyZTyD4mk9MPJYvOhfORFQTmg9kkGnK9k1fSXzXworT7bF1lpIVbDt7FHDGHymsjqYzN+sy2aiLddYEbCHCy+V482eTmCiXSBdyS4AePuOASfVWwM1suRQf3NL0KPGnNkkVtVVE8yqGGzeAv6Otvi+iBsuph/b2oHRdFgM1sfC4nlsa3kVGxK3lkghynKSrofMaU1WGnhZDr0uGfgi7FZWQqNed/UT4aN2fjK67fBR6vBMsMX//aRxAb79ycCac6PuYSBAcKiBTvbQQIOfx0jOAhT9J2QoCdZmjhA5+BgC8F+l4RUkW+3exEDmwE74+xLXMPe1LBp+j+hL928S5FpRv0dTovaW71eB2hsPbYdGkedeAbU0IHbYQP77icCTaU25ufgewgzHh7E1y+5JVGZC
 Bb4ya/66
 xNdZoaPa5kZPna1wx88kcuK5sIH8LyUc87D4K/vIS/tsWrLCfV5ljqT/unahn708prlduSMxIVO/2xL6vs3VDEC1LfY2/0yIqvVnZlLpAJR+P/PXlP3/XxG935tCZ/2Ate7YdLyqvvxK80kwxWUjWUzkACcP1sdovgE9V9vTxLjWB3RigAz6kozVr+7q/bWZfKT7bHiDci3ajaRrTMkQzpwgLcTcBjszGrSFasMdLHIpy95UUBZafr410zXdAcr0Ul/t6gfqaKmKdJhSXkKpvGzySleWuedFIeueLACLlHkadBwJIBPwCxuAGUheVTQi4Hx6cZH2HcNaR8UEraKOxcqhlXBA3M1aJxs9MdKODv5YIQlY4M1aX5HLR+MsFfTU4R9pKeIK5iMda7K0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently there are 6 independent implementations for set_memory and
set_direct_map APIs.

With increasing demand for kernel page table manipulations, for example
"Direct Map Removal Support for guest_memfd" [1] and "mm: ASI direct map
management" [2], it makes sense to have a generic core for kernel page
table manipulation in mm/ with helpers in the architecture specific
code.

x86's implementation is the most versatile and most battle tested and as
such it is the best base for the generic implementation.

Pull change_page_attr() core that loops over memory ranges and updates
their attributes in the page tables from arch/x86 to mm/.

Add GENERIC_SET_MEMORY Kconfig option to let architectures opt-in for
the generic implementation and enable it on x86.

Define architecture hooks in include/linux/set_memory.h and rename x86
functions that implement them to match the generic declarations.

At this point the generic implementation still includes x86 specifics,
particularly pgd_lock. This will be abstracted in the upcoming changes.

[1] https://lore.kernel.org/all/20260410151746.61150-1-kalyazin@amazon.com
[2] https://lore.kernel.org/all/20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com/

No functional change intended.

Assisted-by: Copilot:claude-opus-4.8
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/Kconfig             |   1 +
 arch/x86/mm/pat/set_memory.c | 502 ++++---------------------------------------
 include/linux/pgtable.h      |   4 +
 include/linux/set_memory.h   |  91 ++++++++
 mm/Kconfig                   |   3 +
 mm/Makefile                  |   1 +
 mm/set_memory.c              | 370 +++++++++++++++++++++++++++++++
 7 files changed, 513 insertions(+), 459 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bdad90f210e4..e1f105e52d6a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -336,6 +336,7 @@ config X86
 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
 	select ARCH_SUPPORTS_SCHED_MC		if SMP
 	select HAVE_SINGLE_FTRACE_DIRECT_OPS	if X86_64 && DYNAMIC_FTRACE_WITH_DIRECT_CALLS
+	select GENERIC_SET_MEMORY
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 56676d4cf510..5109139a2d31 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -38,35 +38,6 @@
 /*
  * The current flushing context - we pass it instead of 5 arguments:
  */
-struct cpa_data {
-	unsigned long	*vaddr;
-	pgd_t		*pgd;
-	pgprot_t	mask_set;
-	pgprot_t	mask_clr;
-	unsigned long	numpages;
-	unsigned long	curpage;
-	unsigned long	pfn;
-	unsigned int	flags;
-	unsigned int	force_split		: 1,
-			force_static_prot	: 1,
-			force_flush_all		: 1;
-	struct page	**pages;
-};
-
-/*
- * context for checking for a split a large page and splitting it if required.
- */
-struct cpa_split_data {
-	unsigned long	address;
-	unsigned long	psize;
-	unsigned long	pmask;
-	pte_t		*kpte;
-	struct ptdesc	*ptdesc;
-	enum pgtable_level level;
-	bool		nx;
-	bool		rw;
-};
-
 enum cpa_warn {
 	CPA_CONFLICT,
 	CPA_PROTECT,
@@ -75,19 +46,6 @@ enum cpa_warn {
 
 static const int cpa_warn_level = CPA_PROTECT;
 
-/*
- * Serialize cpa() using cpa_lock so that we don't allow any other cpu, with
- * stale large tlb entries, to change the page attribute in parallel to some
- * other cpu splitting a large page entry along with changing the attribute.
- */
-static DEFINE_SPINLOCK(cpa_lock);
-
-#define CPA_FLUSHTLB 1
-#define CPA_ARRAY 2
-#define CPA_PAGES_ARRAY 4
-#define CPA_NO_CHECK_ALIAS 8 /* Do not search for aliases */
-#define CPA_COLLAPSE 16 /* try to collapse large pages */
-
 static inline pgprot_t cachemode2pgprot(enum page_cache_mode pcm)
 {
 	return __pgprot(cachemode2protval(pcm));
@@ -261,23 +219,6 @@ static inline unsigned long fix_addr(unsigned long addr)
 #endif
 }
 
-static unsigned long __cpa_addr(struct cpa_data *cpa, unsigned long idx)
-{
-	if (cpa->flags & CPA_PAGES_ARRAY) {
-		struct page *page = cpa->pages[idx];
-
-		if (unlikely(PageHighMem(page)))
-			return 0;
-
-		return (unsigned long)page_address(page);
-	}
-
-	if (cpa->flags & CPA_ARRAY)
-		return cpa->vaddr[idx];
-
-	return *cpa->vaddr + idx * PAGE_SIZE;
-}
-
 /*
  * Flushing functions
  */
@@ -363,7 +304,7 @@ static void __cpa_flush_tlb(void *data)
 	unsigned int i;
 
 	for (i = 0; i < cpa->numpages; i++)
-		flush_tlb_one_kernel(fix_addr(__cpa_addr(cpa, i)));
+		flush_tlb_one_kernel(fix_addr(cpa_addr(cpa, i)));
 }
 
 static int collapse_large_pages(unsigned long addr, struct list_head *pgtables);
@@ -378,10 +319,10 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 
 	if (cpa->flags & (CPA_PAGES_ARRAY | CPA_ARRAY)) {
 		for (i = 0; i < cpa->numpages; i++)
-			collapsed += collapse_large_pages(__cpa_addr(cpa, i),
+			collapsed += collapse_large_pages(cpa_addr(cpa, i),
 							  &pgtables);
 	} else {
-		addr = __cpa_addr(cpa, 0);
+		addr = cpa_addr(cpa, 0);
 		start = addr & PMD_MASK;
 		end = addr + PAGE_SIZE * cpa->numpages;
 
@@ -421,7 +362,7 @@ static void cpa_flush(struct cpa_data *cpa, int cache)
 
 	mb();
 	for (i = 0; i < cpa->numpages; i++) {
-		unsigned long addr = __cpa_addr(cpa, i);
+		unsigned long addr = cpa_addr(cpa, i);
 		unsigned int level;
 
 		pte_t *pte = lookup_address(addr, &level);
@@ -667,104 +608,6 @@ static inline pgprot_t verify_rwx(pgprot_t old, pgprot_t new, unsigned long star
 	return new;
 }
 
-/*
- * Lookup the page table entry for a virtual address in a specific pgd.
- * Return a pointer to the entry (or NULL if the entry does not exist),
- * the level of the entry, and the effective NX and RW bits of all
- * page table levels.
- */
-pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
-				  unsigned int *level, bool *nx, bool *rw)
-{
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-
-	*level = PGTABLE_LEVEL_PGD;
-	*nx = false;
-	*rw = true;
-
-	if (pgd_none(*pgd))
-		return NULL;
-
-	*level = PGTABLE_LEVEL_P4D;
-	*nx |= !pgd_exec(*pgd);
-	*rw &= !!(pgd_write(*pgd));
-
-	p4d = p4d_offset(pgd, address);
-	if (p4d_none(*p4d))
-		return NULL;
-
-	if (p4d_leaf(*p4d) || !p4d_present(*p4d))
-		return (pte_t *)p4d;
-
-	*level = PGTABLE_LEVEL_PUD;
-	*nx |= !p4d_exec(*p4d);
-	*rw &= !!(p4d_write(*p4d));
-
-	pud = pud_offset(p4d, address);
-	if (pud_none(*pud))
-		return NULL;
-
-	if (pud_leaf(*pud) || !pud_present(*pud))
-		return (pte_t *)pud;
-
-	*level = PGTABLE_LEVEL_PMD;
-	*nx |= !pud_exec(*pud);
-	*rw &= !!(pud_write(*pud));
-
-	pmd = pmd_offset(pud, address);
-	if (pmd_none(*pmd))
-		return NULL;
-
-	if (pmd_leaf(*pmd) || !pmd_present(*pmd))
-		return (pte_t *)pmd;
-
-	*level = PGTABLE_LEVEL_PTE;
-	*nx |= !pmd_exec(*pmd);
-	*rw &= !!(pmd_write(*pmd));
-
-	return pte_offset_kernel(pmd, address);
-}
-
-/*
- * Lookup the page table entry for a virtual address in a specific pgd.
- * Return a pointer to the entry and the level of the mapping.
- */
-pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
-			     unsigned int *level)
-{
-	bool nx, rw;
-
-	return lookup_address_in_pgd_attr(pgd, address, level, &nx, &rw);
-}
-
-/*
- * Lookup the page table entry for a virtual address. Return a pointer
- * to the entry and the level of the mapping.
- *
- * Note: the function returns p4d, pud or pmd either when the entry is marked
- * large or when the present bit is not set. Otherwise it returns NULL.
- */
-pte_t *lookup_address(unsigned long address, unsigned int *level)
-{
-	return lookup_address_in_pgd(pgd_offset_k(address), address, level);
-}
-EXPORT_SYMBOL_GPL(lookup_address);
-
-static pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
-				  unsigned int *level, bool *nx, bool *rw)
-{
-	pgd_t *pgd;
-
-	if (!cpa->pgd)
-		pgd = pgd_offset_k(address);
-	else
-		pgd = cpa->pgd + pgd_index(address);
-
-	return lookup_address_in_pgd_attr(pgd, address, level, nx, rw);
-}
-
 /*
  * Lookup the PMD entry for a virtual address. Return a pointer to the entry
  * or NULL if not present.
@@ -883,8 +726,8 @@ static pgprot_t pgprot_clear_protnone_bits(pgprot_t prot)
 	return prot;
 }
 
-static int __should_split_large_page(struct cpa_data *cpa,
-				     struct cpa_split_data *sd)
+int arch_should_split_large_page(struct cpa_data *cpa,
+				 struct cpa_split_data *sd)
 {
 	pgprot_t old_prot, new_prot, req_prot, chk_prot;
 	unsigned long numpages, lpaddr, pfn, old_pfn;
@@ -1015,31 +858,6 @@ static int __should_split_large_page(struct cpa_data *cpa,
 	return 0;
 }
 
-static int should_split_large_page(struct cpa_data *cpa,
-				   struct cpa_split_data *sd)
-{
-	enum pgtable_level level = sd->level;
-	unsigned long address = sd->address;
-	unsigned long numpages, lpaddr;
-
-	if (cpa->force_split)
-		return 1;
-
-	sd->psize = pgtable_level_size(level);
-	sd->pmask = pgtable_level_mask(level);
-
-	/*
-	 * Calculate the number of pages, which fit into this large
-	 * page starting at address:
-	 */
-	lpaddr = (address + sd->psize) & sd->pmask;
-	numpages = (lpaddr - address) >> PAGE_SHIFT;
-	if (numpages < cpa->numpages)
-		cpa->numpages = numpages;
-
-	return __should_split_large_page(cpa, sd);
-}
-
 static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 			  pgprot_t ref_prot, unsigned long address,
 			  unsigned long size)
@@ -1076,7 +894,7 @@ static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 	set_pte(pte, pfn_pte(pfn, ref_prot));
 }
 
-static int __split_large_page(struct cpa_data *cpa, struct cpa_split_data *sd)
+int arch_split_large_page(struct cpa_data *cpa, struct cpa_split_data *sd)
 {
 	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
 	struct ptdesc *ptdesc = sd->ptdesc;
@@ -1170,68 +988,6 @@ static int __split_large_page(struct cpa_data *cpa, struct cpa_split_data *sd)
 	return 0;
 }
 
-static int split_large_page(struct cpa_data *cpa, struct cpa_split_data *sd)
-{
-	return __split_large_page(cpa, sd);
-}
-
-static int cpa_handle_large_page(struct cpa_data *cpa, pte_t *kpte,
-				  unsigned long address)
-{
-	struct cpa_split_data sd = {
-		.address = address,
-		.kpte = kpte,
-	};
-	int do_split, ret = 1;
-	pte_t *tmp;
-
-	spin_unlock(&cpa_lock);
-	sd.ptdesc = pagetable_alloc(GFP_KERNEL, 0);
-	spin_lock(&cpa_lock);
-	if (!sd.ptdesc)
-		return -ENOMEM;
-
-	spin_lock(&pgd_lock);
-
-	/*
-	 * Check for races, another CPU might have split this page
-	 * up already:
-	 */
-	tmp = _lookup_address_cpa(cpa, address, &sd.level, &sd.nx, &sd.rw);
-	if (tmp != kpte)
-		goto out_free_ptdesc;
-
-	/*
-	 * Check, whether we can keep the large page intact
-	 * and just change the pte:
-	 */
-	do_split = should_split_large_page(cpa, &sd);
-	ret = do_split;
-	/*
-	 * When the range fits into the existing large page, no split is
-	 * required.
-	 * should_split_large_page() updated the large page attributes and
-	 * cpa->numpages and cpa->pfn.
-	 */
-	if (do_split <= 0)
-		goto out_free_ptdesc;
-
-	/*
-	 * We have to split the large page:
-	 */
-	ret = split_large_page(cpa, &sd);
-	if (ret)
-		goto out_free_ptdesc;
-
-	spin_unlock(&pgd_lock);
-	return do_split;
-
-out_free_ptdesc:
-	spin_unlock(&pgd_lock);
-	pagetable_free(sd.ptdesc);
-	return ret;
-}
-
 static int collapse_pmd_page(pmd_t *pmd, unsigned long addr,
 			     struct list_head *pgtables)
 {
@@ -1783,8 +1539,8 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	return 0;
 }
 
-static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
-			       int primary)
+int arch_cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
+			   int primary)
 {
 	if (cpa->pgd) {
 		/*
@@ -1828,75 +1584,45 @@ static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
 	}
 }
 
-static int __change_page_attr(struct cpa_data *cpa, int primary)
+void arch_change_pte(struct cpa_data *cpa, unsigned long address,
+		     pte_t *kpte, pte_t old_pte, bool nx, bool rw)
 {
-	unsigned long address;
-	int split_res;
-	unsigned int level;
-	pte_t *kpte, old_pte;
-	bool nx, rw;
-
-	address = __cpa_addr(cpa, cpa->curpage);
-repeat:
-	kpte = _lookup_address_cpa(cpa, address, &level, &nx, &rw);
-	if (!kpte)
-		return __cpa_process_fault(cpa, address, primary);
-
-	old_pte = *kpte;
-	if (pte_none(old_pte))
-		return __cpa_process_fault(cpa, address, primary);
-
-	if (level == PGTABLE_LEVEL_PTE) {
-		pte_t new_pte;
-		pgprot_t old_prot = pte_pgprot(old_pte);
-		pgprot_t new_prot = pte_pgprot(old_pte);
-		unsigned long pfn = pte_pfn(old_pte);
+	pte_t new_pte;
+	pgprot_t old_prot = pte_pgprot(old_pte);
+	pgprot_t new_prot = pte_pgprot(old_pte);
+	unsigned long pfn = pte_pfn(old_pte);
 
-		pgprot_val(new_prot) &= ~pgprot_val(cpa->mask_clr);
-		pgprot_val(new_prot) |= pgprot_val(cpa->mask_set);
+	pgprot_val(new_prot) &= ~pgprot_val(cpa->mask_clr);
+	pgprot_val(new_prot) |= pgprot_val(cpa->mask_set);
 
-		cpa_inc_4k_install();
-		/* Hand in lpsize = 0 to enforce the protection mechanism */
-		new_prot = static_protections(new_prot, address, pfn, 1, 0,
-					      CPA_PROTECT);
+	cpa_inc_4k_install();
+	/* Hand in lpsize = 0 to enforce the protection mechanism */
+	new_prot = static_protections(new_prot, address, pfn, 1, 0,
+				      CPA_PROTECT);
 
-		new_prot = verify_rwx(old_prot, new_prot, address, pfn, 1,
-				      nx, rw);
+	new_prot = verify_rwx(old_prot, new_prot, address, pfn, 1, nx, rw);
 
-		new_prot = pgprot_clear_protnone_bits(new_prot);
+	new_prot = pgprot_clear_protnone_bits(new_prot);
 
-		/*
-		 * We need to keep the pfn from the existing PTE,
-		 * after all we're only going to change its attributes
-		 * not the memory it points to
-		 */
-		new_pte = pfn_pte(pfn, new_prot);
-		cpa->pfn = pfn;
-		/*
-		 * Do we really change anything ?
-		 */
-		if (pte_val(old_pte) != pte_val(new_pte)) {
-			set_pte_atomic(kpte, new_pte);
-			cpa->flags |= CPA_FLUSHTLB;
-		}
-		cpa->numpages = 1;
-		return 0;
+	/*
+	 * We need to keep the pfn from the existing PTE, after all we're only
+	 * going to change its attributes not the memory it points to
+	 */
+	new_pte = pfn_pte(pfn, new_prot);
+	cpa->pfn = pfn;
+	/*
+	 * Do we really change anything ?
+	 */
+	if (pte_val(old_pte) != pte_val(new_pte)) {
+		set_pte_atomic(kpte, new_pte);
+		cpa->flags |= CPA_FLUSHTLB;
 	}
-
-	/* Update large page or split it */
-	split_res = cpa_handle_large_page(cpa, kpte, address);
-	if (split_res > 0)
-		goto repeat;
-
-	return split_res;
 }
 
-static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary);
-
 /*
  * Check the directmap and "high kernel map" 'aliases'.
  */
-static int cpa_process_alias(struct cpa_data *cpa)
+int arch_cpa_process_alias(struct cpa_data *cpa)
 {
 	struct cpa_data alias_cpa;
 	unsigned long laddr = (unsigned long)__va(cpa->pfn << PAGE_SHIFT);
@@ -1910,7 +1636,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	 * No need to redo, when the primary call touched the direct
 	 * mapping already:
 	 */
-	vaddr = __cpa_addr(cpa, cpa->curpage);
+	vaddr = cpa_addr(cpa, cpa->curpage);
 	if (!(within(vaddr, PAGE_OFFSET,
 		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))) {
 
@@ -1968,167 +1694,25 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	return 0;
 }
 
-static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
-{
-	unsigned long numpages = cpa->numpages;
-	unsigned long rempages = numpages;
-	int ret = 0;
-
-	/*
-	 * No changes, easy!
-	 */
-	if (!(pgprot_val(cpa->mask_set) | pgprot_val(cpa->mask_clr)) &&
-	    !cpa->force_split)
-		return ret;
-
-	while (rempages) {
-		/*
-		 * Store the remaining nr of pages for the large page
-		 * preservation check.
-		 */
-		cpa->numpages = rempages;
-		/* for array changes, we can't use large page */
-		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
-			cpa->numpages = 1;
-
-		spin_lock(&cpa_lock);
-		ret = __change_page_attr(cpa, primary);
-		spin_unlock(&cpa_lock);
-		if (ret)
-			goto out;
-
-		if (primary && !(cpa->flags & CPA_NO_CHECK_ALIAS) &&
-		    cpa_should_update_alias(__cpa_addr(cpa, cpa->curpage), cpa->pfn)) {
-			ret = cpa_process_alias(cpa);
-			if (ret)
-				goto out;
-		}
-
-		/*
-		 * Adjust the number of pages with the result of the
-		 * CPA operation. Either a large page has been
-		 * preserved or a single page update happened.
-		 */
-		BUG_ON(cpa->numpages > rempages || !cpa->numpages);
-		rempages -= cpa->numpages;
-		cpa->curpage += cpa->numpages;
-	}
-
-out:
-	/* Restore the original numpages */
-	cpa->numpages = numpages;
-	return ret;
-}
-
-static int change_page_attr_set_clr(unsigned long *addr, int numpages,
-				    pgprot_t mask_set, pgprot_t mask_clr,
-				    int force_split, int in_flag,
-				    struct page **pages)
+void arch_cpa_flush(struct cpa_data *cpa, int err)
 {
-	struct cpa_data cpa;
-	int ret, cache;
-
-	memset(&cpa, 0, sizeof(cpa));
-
-	/*
-	 * Check, if we are requested to set a not supported
-	 * feature.  Clearing non-supported features is OK.
-	 */
-	mask_set = canon_pgprot(mask_set);
-
-	if (!pgprot_val(mask_set) && !pgprot_val(mask_clr) && !force_split)
-		return 0;
-
-	/* Ensure we are PAGE_SIZE aligned */
-	if (in_flag & CPA_ARRAY) {
-		int i;
-		for (i = 0; i < numpages; i++) {
-			if (addr[i] & ~PAGE_MASK) {
-				addr[i] &= PAGE_MASK;
-				WARN_ON_ONCE(1);
-			}
-		}
-	} else if (!(in_flag & CPA_PAGES_ARRAY)) {
-		/*
-		 * in_flag of CPA_PAGES_ARRAY implies it is aligned.
-		 * No need to check in that case
-		 */
-		if (*addr & ~PAGE_MASK) {
-			*addr &= PAGE_MASK;
-			/*
-			 * People should not be passing in unaligned addresses:
-			 */
-			WARN_ON_ONCE(1);
-		}
-	}
-
-	/* Must avoid aliasing mappings in the highmem code */
-	kmap_flush_unused();
-
-	vm_unmap_aliases();
-
-	cpa.vaddr = addr;
-	cpa.pages = pages;
-	cpa.numpages = numpages;
-	cpa.mask_set = mask_set;
-	cpa.mask_clr = mask_clr;
-	cpa.flags = in_flag;
-	cpa.curpage = 0;
-	cpa.force_split = force_split;
-
-	ret = __change_page_attr_set_clr(&cpa, 1);
-
-	/*
-	 * Check whether we really changed something:
-	 */
-	if (!(cpa.flags & CPA_FLUSHTLB))
-		goto out;
+	int cache;
 
 	/*
 	 * No need to flush, when we did not set any of the caching
 	 * attributes:
 	 */
-	cache = !!pgprot2cachemode(mask_set);
+	cache = !!pgprot2cachemode(cpa->mask_set);
 
 	/*
 	 * On error; flush everything to be sure.
 	 */
-	if (ret) {
+	if (err) {
 		cpa_flush_all(cache);
-		goto out;
+		return;
 	}
 
-	cpa_flush(&cpa, cache);
-out:
-	return ret;
-}
-
-static inline int change_page_attr_set(unsigned long *addr, int numpages,
-				       pgprot_t mask, int array)
-{
-	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0), 0,
-		(array ? CPA_ARRAY : 0), NULL);
-}
-
-static inline int change_page_attr_clear(unsigned long *addr, int numpages,
-					 pgprot_t mask, int array)
-{
-	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask, 0,
-		(array ? CPA_ARRAY : 0), NULL);
-}
-
-static inline int cpa_set_pages_array(struct page **pages, int numpages,
-				       pgprot_t mask)
-{
-	return change_page_attr_set_clr(NULL, numpages, mask, __pgprot(0), 0,
-		CPA_PAGES_ARRAY, pages);
-}
-
-static inline int cpa_clear_pages_array(struct page **pages, int numpages,
-					 pgprot_t mask)
-{
-	return change_page_attr_set_clr(NULL, numpages, __pgprot(0), mask, 0,
-		CPA_PAGES_ARRAY, pages);
+	cpa_flush(cpa, cache);
 }
 
 int _set_memory_uc(unsigned long addr, int numpages)
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 9eb00ad6d5d2..d1df8345852b 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1782,6 +1782,10 @@ void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
  * because these macros can be used even if CONFIG_MMU is not defined.
  */
 
+#ifndef canon_pgprot
+#define canon_pgprot(prot)	(prot)
+#endif
+
 #ifndef pgprot_nx
 #define pgprot_nx(prot)	(prot)
 #endif
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..86a7bef7cbca 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -84,4 +84,95 @@ static inline int set_memory_decrypted(unsigned long addr, int numpages)
 }
 #endif /* CONFIG_ARCH_HAS_MEM_ENCRYPT */
 
+#ifdef CONFIG_GENERIC_SET_MEMORY
+
+#include <linux/pgtable.h>
+
+#define CPA_FLUSHTLB 1
+#define CPA_ARRAY 2
+#define CPA_PAGES_ARRAY 4
+#define CPA_NO_CHECK_ALIAS 8 /* Do not search for aliases */
+#define CPA_COLLAPSE 16 /* try to collapse large pages */
+
+/*
+ * The current flushing context - we pass it instead of 5 arguments:
+ */
+struct cpa_data {
+	unsigned long	*vaddr;
+	pgd_t		*pgd;
+	pgprot_t	mask_set;
+	pgprot_t	mask_clr;
+	unsigned long	numpages;
+	unsigned long	curpage;
+	unsigned long	pfn;
+	unsigned int	flags;
+	unsigned int	force_split		: 1,
+			force_static_prot	: 1,
+			force_flush_all		: 1;
+	struct page	**pages;
+};
+
+/*
+ * context for checking for a split a large page and splitting it if required.
+ */
+struct ptdesc;
+struct cpa_split_data {
+	unsigned long	address;
+	unsigned long	psize;
+	unsigned long	pmask;
+	pte_t		*kpte;
+	struct ptdesc	*ptdesc;
+	enum pgtable_level level;
+	bool		nx;
+	bool		rw;
+};
+
+unsigned long cpa_addr(struct cpa_data *cpa, unsigned long idx);
+
+int arch_cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
+			   int primary);
+int arch_cpa_process_alias(struct cpa_data *cpa);
+int arch_should_split_large_page(struct cpa_data *cpa,
+				 struct cpa_split_data *sd);
+int arch_split_large_page(struct cpa_data *cpa, struct cpa_split_data *sd);
+void arch_change_pte(struct cpa_data *cpa, unsigned long address,
+		     pte_t *kpte, pte_t old_pte, bool nx, bool rw);
+void arch_cpa_flush(struct cpa_data *cpa, int err);
+
+int __change_page_attr_set_clr(struct cpa_data *cpa, int primary);
+int change_page_attr_set_clr(unsigned long *addr, int numpages,
+			     pgprot_t mask_set, pgprot_t mask_clr,
+			     int force_split, int in_flag,
+			     struct page **pages);
+
+static inline int change_page_attr_set(unsigned long *addr, int numpages,
+				       pgprot_t mask, int array)
+{
+	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0), 0,
+		(array ? CPA_ARRAY : 0), NULL);
+}
+
+static inline int change_page_attr_clear(unsigned long *addr, int numpages,
+					 pgprot_t mask, int array)
+{
+	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask, 0,
+		(array ? CPA_ARRAY : 0), NULL);
+}
+
+static inline int cpa_set_pages_array(struct page **pages, int numpages,
+				      pgprot_t mask)
+{
+	return change_page_attr_set_clr(NULL, numpages, mask, __pgprot(0), 0,
+		CPA_PAGES_ARRAY, pages);
+}
+
+static inline int cpa_clear_pages_array(struct page **pages, int numpages,
+					pgprot_t mask)
+{
+	return change_page_attr_set_clr(NULL, numpages, __pgprot(0), mask, 0,
+		CPA_PAGES_ARRAY, pages);
+}
+
+#endif /* CONFIG_GENERIC_SET_MEMORY */
+
 #endif /* _LINUX_SET_MEMORY_H_ */
diff --git a/mm/Kconfig b/mm/Kconfig
index 9e0ca4824905..541edd1e11b6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1509,6 +1509,9 @@ config LAZY_MMU_MODE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config GENERIC_SET_MEMORY
+	bool
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index eff9f9e7e061..e3f6c39c2ba9 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
+obj-$(CONFIG_GENERIC_SET_MEMORY) += set_memory.o
diff --git a/mm/set_memory.c b/mm/set_memory.c
new file mode 100644
index 000000000000..712264de8e9b
--- /dev/null
+++ b/mm/set_memory.c
@@ -0,0 +1,370 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/highmem.h>
+#include <linux/vmalloc.h>
+#include <linux/pgtable.h>
+#include <linux/export.h>
+
+#include <linux/set_memory.h>
+
+/*
+ * Serialize cpa() so that we don't allow any other cpu, with stale large tlb
+ * entries, to change the page attribute in parallel to some other cpu
+ * splitting a large page entry along with changing the attribute.
+ */
+static DEFINE_SPINLOCK(cpa_lock);
+
+unsigned long cpa_addr(struct cpa_data *cpa, unsigned long idx)
+{
+	if (cpa->flags & CPA_PAGES_ARRAY) {
+		struct page *page = cpa->pages[idx];
+
+		if (unlikely(PageHighMem(page)))
+			return 0;
+
+		return (unsigned long)page_address(page);
+	}
+
+	if (cpa->flags & CPA_ARRAY)
+		return cpa->vaddr[idx];
+
+	return *cpa->vaddr + idx * PAGE_SIZE;
+}
+
+/*
+ * Lookup the page table entry for a virtual address in a specific pgd.
+ * Return a pointer to the entry (or NULL if the entry does not exist),
+ * the level of the entry, and the effective NX and RW bits of all
+ * page table levels.
+ */
+pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
+				  unsigned int *level, bool *nx, bool *rw)
+{
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	*level = PGTABLE_LEVEL_PGD;
+	*nx = false;
+	*rw = true;
+
+	if (pgd_none(*pgd))
+		return NULL;
+
+	*level = PGTABLE_LEVEL_P4D;
+	*nx |= !pgd_exec(*pgd);
+	*rw &= !!(pgd_write(*pgd));
+
+	p4d = p4d_offset(pgd, address);
+	if (p4d_none(*p4d))
+		return NULL;
+
+	if (p4d_leaf(*p4d) || !p4d_present(*p4d))
+		return (pte_t *)p4d;
+
+	*level = PGTABLE_LEVEL_PUD;
+	*nx |= !p4d_exec(*p4d);
+	*rw &= !!(p4d_write(*p4d));
+
+	pud = pud_offset(p4d, address);
+	if (pud_none(*pud))
+		return NULL;
+
+	if (pud_leaf(*pud) || !pud_present(*pud))
+		return (pte_t *)pud;
+
+	*level = PGTABLE_LEVEL_PMD;
+	*nx |= !pud_exec(*pud);
+	*rw &= !!(pud_write(*pud));
+
+	pmd = pmd_offset(pud, address);
+	if (pmd_none(*pmd))
+		return NULL;
+
+	if (pmd_leaf(*pmd) || !pmd_present(*pmd))
+		return (pte_t *)pmd;
+
+	*level = PGTABLE_LEVEL_PTE;
+	*nx |= !pmd_exec(*pmd);
+	*rw &= !!(pmd_write(*pmd));
+
+	return pte_offset_kernel(pmd, address);
+}
+
+/*
+ * Lookup the page table entry for a virtual address in a specific pgd.
+ * Return a pointer to the entry and the level of the mapping.
+ */
+pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
+			     unsigned int *level)
+{
+	bool nx, rw;
+
+	return lookup_address_in_pgd_attr(pgd, address, level, &nx, &rw);
+}
+
+/*
+ * Lookup the page table entry for a virtual address. Return a pointer
+ * to the entry and the level of the mapping.
+ *
+ * Note: the function returns p4d, pud or pmd either when the entry is marked
+ * large or when the present bit is not set. Otherwise it returns NULL.
+ */
+pte_t *lookup_address(unsigned long address, unsigned int *level)
+{
+	return lookup_address_in_pgd(pgd_offset_k(address), address, level);
+}
+EXPORT_SYMBOL_GPL(lookup_address);
+
+static pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
+			   unsigned int *level, bool *nx, bool *rw)
+{
+	pgd_t *pgd;
+
+	if (!cpa->pgd)
+		pgd = pgd_offset_k(address);
+	else
+		pgd = cpa->pgd + pgd_index(address);
+
+	return lookup_address_in_pgd_attr(pgd, address, level, nx, rw);
+}
+
+static int should_split_large_page(struct cpa_data *cpa,
+				   struct cpa_split_data *sd)
+{
+	enum pgtable_level level = sd->level;
+	unsigned long address = sd->address;
+	unsigned long numpages, lpaddr;
+
+	if (cpa->force_split)
+		return 1;
+
+	sd->psize = pgtable_level_size(level);
+	sd->pmask = pgtable_level_mask(level);
+
+	/*
+	 * Calculate the number of pages, which fit into this large
+	 * page starting at address:
+	 */
+	lpaddr = (address + sd->psize) & sd->pmask;
+	numpages = (lpaddr - address) >> PAGE_SHIFT;
+	if (numpages < cpa->numpages)
+		cpa->numpages = numpages;
+
+	return arch_should_split_large_page(cpa, sd);
+}
+
+static int cpa_handle_large_page(struct cpa_data *cpa, pte_t *kpte,
+				  unsigned long address)
+{
+	struct cpa_split_data sd = {
+		.address = address,
+		.kpte = kpte,
+	};
+	int do_split, ret = 1;
+	pte_t *tmp;
+
+	spin_unlock(&cpa_lock);
+	sd.ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	spin_lock(&cpa_lock);
+	if (!sd.ptdesc)
+		return -ENOMEM;
+
+	spin_lock(&pgd_lock);
+
+	/*
+	 * Check for races, another CPU might have split this page
+	 * up already:
+	 */
+	tmp = _lookup_address_cpa(cpa, address, &sd.level, &sd.nx, &sd.rw);
+	if (tmp != kpte)
+		goto out_free_ptdesc;
+
+	/*
+	 * Check, whether we can keep the large page intact
+	 * and just change the pte:
+	 */
+	do_split = should_split_large_page(cpa, &sd);
+	ret = do_split;
+	/*
+	 * When the range fits into the existing large page, no split is
+	 * required.
+	 * should_split_large_page() updated the large page attributes and
+	 * cpa->numpages and cpa->pfn.
+	 */
+	if (do_split <= 0)
+		goto out_free_ptdesc;
+
+	/*
+	 * We have to split the large page:
+	 */
+	ret = arch_split_large_page(cpa, &sd);
+	if (ret)
+		goto out_free_ptdesc;
+
+	spin_unlock(&pgd_lock);
+	return do_split;
+
+out_free_ptdesc:
+	spin_unlock(&pgd_lock);
+	pagetable_free(sd.ptdesc);
+	return ret;
+}
+
+static int __change_page_attr(struct cpa_data *cpa, int primary)
+{
+	unsigned long address;
+	int split_res;
+	unsigned int level;
+	pte_t *kpte, old_pte;
+	bool nx, rw;
+
+	address = cpa_addr(cpa, cpa->curpage);
+repeat:
+	kpte = _lookup_address_cpa(cpa, address, &level, &nx, &rw);
+	if (!kpte)
+		return arch_cpa_process_fault(cpa, address, primary);
+
+	old_pte = *kpte;
+	if (pte_none(old_pte))
+		return arch_cpa_process_fault(cpa, address, primary);
+
+	if (level == PGTABLE_LEVEL_PTE) {
+		arch_change_pte(cpa, address, kpte, old_pte, nx, rw);
+		cpa->numpages = 1;
+		return 0;
+	}
+
+	/*
+	 * The address maps a large page. Try to keep it, otherwise split it
+	 * up and retry on the freshly installed smaller mapping.
+	 */
+	split_res = cpa_handle_large_page(cpa, kpte, address);
+	if (split_res > 0)
+		goto repeat;
+
+	return split_res;
+}
+
+int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
+{
+	unsigned long numpages = cpa->numpages;
+	unsigned long rempages = numpages;
+	int ret = 0;
+
+	/*
+	 * No changes, easy!
+	 */
+	if (!(pgprot_val(cpa->mask_set) | pgprot_val(cpa->mask_clr)) &&
+	    !cpa->force_split)
+		return ret;
+
+	while (rempages) {
+		/*
+		 * Store the remaining nr of pages for the large page
+		 * preservation check.
+		 */
+		cpa->numpages = rempages;
+		/* for array changes, we can't use large page */
+		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
+			cpa->numpages = 1;
+
+		spin_lock(&cpa_lock);
+		ret = __change_page_attr(cpa, primary);
+		spin_unlock(&cpa_lock);
+		if (ret)
+			goto out;
+
+		if (primary && !(cpa->flags & CPA_NO_CHECK_ALIAS) &&
+		    cpa_should_update_alias(cpa_addr(cpa, cpa->curpage), cpa->pfn)) {
+			ret = arch_cpa_process_alias(cpa);
+			if (ret)
+				goto out;
+		}
+
+		/*
+		 * Adjust the number of pages with the result of the
+		 * CPA operation. Either a large page has been
+		 * preserved or a single page update happened.
+		 */
+		BUG_ON(cpa->numpages > rempages || !cpa->numpages);
+		rempages -= cpa->numpages;
+		cpa->curpage += cpa->numpages;
+	}
+
+out:
+	/* Restore the original numpages */
+	cpa->numpages = numpages;
+	return ret;
+}
+
+int change_page_attr_set_clr(unsigned long *addr, int numpages,
+			     pgprot_t mask_set, pgprot_t mask_clr,
+			     int force_split, int in_flag,
+			     struct page **pages)
+{
+	struct cpa_data cpa;
+	int err;
+
+	memset(&cpa, 0, sizeof(cpa));
+
+	/*
+	 * Check, if we are requested to set a not supported
+	 * feature.  Clearing non-supported features is OK.
+	 */
+	mask_set = canon_pgprot(mask_set);
+
+	if (!pgprot_val(mask_set) && !pgprot_val(mask_clr) && !force_split)
+		return 0;
+
+	/* Ensure we are PAGE_SIZE aligned */
+	if (in_flag & CPA_ARRAY) {
+		int i;
+
+		for (i = 0; i < numpages; i++) {
+			if (addr[i] & ~PAGE_MASK) {
+				addr[i] &= PAGE_MASK;
+				WARN_ON_ONCE(1);
+			}
+		}
+	} else if (!(in_flag & CPA_PAGES_ARRAY)) {
+		/*
+		 * in_flag of CPA_PAGES_ARRAY implies it is aligned.
+		 * No need to check in that case
+		 */
+		if (*addr & ~PAGE_MASK) {
+			*addr &= PAGE_MASK;
+			/*
+			 * People should not be passing in unaligned addresses:
+			 */
+			WARN_ON_ONCE(1);
+		}
+	}
+
+	/* Must avoid aliasing mappings in the highmem code */
+	kmap_flush_unused();
+
+	vm_unmap_aliases();
+
+	cpa.vaddr = addr;
+	cpa.pages = pages;
+	cpa.numpages = numpages;
+	cpa.mask_set = mask_set;
+	cpa.mask_clr = mask_clr;
+	cpa.flags = in_flag;
+	cpa.curpage = 0;
+	cpa.force_split = force_split;
+
+	err = __change_page_attr_set_clr(&cpa, 1);
+
+	/*
+	 * Check whether we really changed something:
+	 */
+	if (!(cpa.flags & CPA_FLUSHTLB))
+		goto out;
+
+	arch_cpa_flush(&cpa, err);
+
+out:
+	return err;
+}

-- 
2.53.0


