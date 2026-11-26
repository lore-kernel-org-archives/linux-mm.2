Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C8E606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OliYZ3th
Received: by kanga.kvack.org (Postfix)
	id 9FF0A6B05E5; Thu, 26 Nov 2026 06:19:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6D26B05E6; Thu, 26 Nov 2026 06:19:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C64E6B05E7; Thu, 26 Nov 2026 06:19:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60D1C6B05E5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:19:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBFD68080A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:19:02 +0000 (UTC)
X-FDA: 85477023324.05.006CB60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 402108000D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:19:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OliYZ3th;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691941;
	b=kh6tDLHy48njTZy5ViKbvIWGzVpL4xAsmFn8HEA0lk7+a0OBiWJGNjR1kqIErzLbyrbooQ
	+zpokin9jwGXreepKu5QJ7bF/OJD+9TOeLN4xFxTHevtsqDcRSoeOtfh/jOqX6crQMoT7T
	3rAFoksNiGgjgFlVy18zaB4/u+ayH8I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZpzC6AEWFffJ1ENAPlWBpzT4glBvg4PYHI0q7nLbaA=;
	b=jQjqGJARd7rKBAsn2zrxnraQtf07hagagGZri6bAIgolS8KBFDMmiifSyeg/cmDK0RxAo1
	x6euzIJ6OfCBX7AowwPnHvox0fJQcysmqIOo+oZbU+lxEuiuHtQp8sSyqdTTOsJGW0q3Ef
	MYYqL31kX3XqFANxsX5mA7l6mwAUDOY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OliYZ3th;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BFB1A62E56;
	Thu, 26 Nov 2026 11:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B0E1F000EB;
	Thu, 26 Nov 2026 11:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691940;
	bh=HZpzC6AEWFffJ1ENAPlWBpzT4glBvg4PYHI0q7nLbaA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OliYZ3thwz5tNUe0UoiFi6zZWE4MJtpPw4TpdbRhN0w/r9t8U0TovUHjWJ5hjwYIC
	 0fGef0mHSRx6cXJFDYT9vuuzCISL92PtuxGsphhNgBFwI8xDUsaUUgw86ihiCF93f8
	 go6huVNdxw4kj1J+sOk2ZezlaJlZivDt0ErEdMx2cIRSEAArsCIpEMGVLfPzonsRWx
	 HicYlRnHBSxKXiRzxdlA7UsrH933IjDa43tgGyucoyEjjg8fVuXlusT0py1Ojgklx8
	 7pDkMkk+iSDy15TuUfBTG5jY/qft/qiwo6ICLixBghwnd/DqcrOojdmX+uhzIQt/Lq
	 Fkqld/9pIArhQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:41 +0200
Subject: [PATCH RFC v2 28/54] x86/mm/pat: separate the generic part of CPA
 from the x86 hooks
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-28-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 402108000D
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: aqqjau6tb9apjtj3aq5f9ept6o9kqjwt
X-HE-Tag: 1795691941-239942
X-HE-Meta: U2FsdGVkX1824GKkqDXzEh34VDouEhzFC9vWHa5aZdmZ92V4VjOHbKlAj2/HRfVtGtb9bmrZNuneO88xVFEgW2+f1xXer7VBsz2bZPYeUB4FF/jXpLvHwsrVaMHamI/HPcPuyB5Vf682eD+tSXU4lbnPKBNH0BzClPD8wShwdTOo0SPfbXC+BJ48KkTpxHgX3VEHv3O9WdoA6b8bNOa9hoxidR/YXuucrelkgxTon0iZDNeuMI0WQczUuAY66PQarJV2FrPj4xiXAQU868IAJ71y1CLiSEou4KY9nltRUYs0yaKWs4anykjgK8hhPQkBvVd4a+LCV3/YxhDMULRVdZ0d20DMFkDoZHoJTpVbLpUvJz3zcUw/iL514ugkGmZKWBaOVo+NMduGRDsCAVKLmWhkcTXCgZqiCKiY/FfHfQ1Dt/G4Oq1mwCEdoLl3W0caD4IqFtbS5ON9/9EJCrny5Te2ulRhs0xiwdq6yzHLpy237Qc9FUAmatl4sFR5bQQIZHkCprjFBL7x3z7J3F/OIIpIM8R0mEcRl+ezPhqkOmBL0OzFopmhUFIzYCnFgP7weeJVtrgvVUxtJx7CW16gV9/u5us7RGDl4SGunYb7IJGk1wS5PageQhOIe35jTwUYX66RuEY5IPLTsclUSXJVuFbiVcv+XmaeWwBdaELK5t1XfhUlP9656nu/FRd8zn+07XJPy3A2Bb6f6xRpfEsxNJ7ousupmdJJFsIRcyOg9HqNFirLWMK3NIZrUhdkZ/w356hL0FvgUkXzghLdiJlZt3FW59aG0ChGMHljnx4QvQ7h54T+/XLhoi8XWPoeVySDEXNAyDV7GBKw9g0P3IpxjCX2Iiea31aZTBxRRu5V7B63z4Mt/rMYFhdYfMO2oVte1y4oSskhI58aX95WWQ1Vig+6HrackW+XUYd8gKuF+Q/998BbNa1GrRHblBP3g2Paynu8CnNzDHDzEL8p8Ga
 phBhTQtJ
 eCOuXIKfnTIzz7gReJgeHI9HTBwAEFU/wyRMZnkWfF4zhvK57qNDYw3XFwSWWrXdgy+TTZa++NCUWroOsmnxP5PbOIVJa5DuXZjg3xr1Coo814rjp5tHAHPvKgYBu5GOd4DL4f3iu5QSJFUjA64McqZRklwArah4I11G8YnsZmkTQluSaQy2RpqVqvl2LarEDzTtyS/sHaEb8n+yyIBjVfG0lotThxj+2k/xTufgCH8S+zrgOFy7Blyw5i3WLig3p9JcJ4ovElW+OY7j3iZ6XztfiTY0b4MtgWNwDGLkYWt+nOxY5fPnQWqQC59+ljX1khtqIHeKVdiGQyEn7GhD93927mIldirXhvlFjQ2Cit2SF1HzkVMdf10cFr3wpIa4jazKAxbmUroZwmfNdyTH/Ru47IUho5mxkk2Vl7vo6wANb1KCn+B74QjDrAXrUOdSCJ+g6P2O/ZY8sLKBu3E1dcn+O+4+8sxAqBbPc2yZpewvcej5SKuezaMyrXNUca2OFsOljYfLK2dEtX4EDBAB1fuFPAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The core CPA logic is going to move to mm/pageattr.c.

Draw the line between the generic and the x86 code in place first, so that
the move will be purely mechanical.

The page table walk and cpa_lookup(), the decision whether to keep or split
a large page, the handling of holes, the set_memory_*() and
set_direct_map_*_noflush() entry points and the direct map counters are
going to become generic.

x86 provides hooks for everything that depends on the page table format,
the static protections, the definition of alias mapping ranges, the TLB
flush and the collapse of large pages.

Which aliases a mapping has and what they may change is up to the
architecture. Walking an alias and propagating its TLB flush to the request
is not, so that will move to the generic part.

Split the hooks out of the functions that mix both and put them next to the
code they come from.

Rename the hooks to arch_cpa_*() and __change_page_attr_set_clr() to
change_page_attr_noflush().

Split change_page_attr(), which takes a request, out of
change_page_attr_set_clr() and use it for the operations of set_memory_*().

Reword the comment of the large page check, which names the static
protections of x86, and drop the history of the check.

No functional change.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 285 ++++++++++++++++++++++++-------------------
 1 file changed, 158 insertions(+), 127 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 36d63119df71..34c58c7da4e3 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -345,7 +345,7 @@ static pgd_t *cpa_pgd(struct cpa_data *cpa, unsigned long address)
 	return cpa->pgd + pgd_index(address);
 }
 
-static unsigned long __cpa_addr(struct cpa_data *cpa, unsigned long idx)
+static unsigned long cpa_addr(struct cpa_data *cpa, unsigned long idx)
 {
 	return cpa->addr + idx * PAGE_SIZE;
 }
@@ -460,14 +460,14 @@ static void __cpa_flush_tlb(void *data)
 
 static int collapse_large_pages(unsigned long addr, struct list_head *pgtables);
 
-static void cpa_collapse_large_pages(struct cpa_data *cpa)
+static void arch_cpa_collapse(struct cpa_data *cpa)
 {
 	unsigned long start, addr, end;
 	struct ptdesc *ptdesc, *tmp;
 	LIST_HEAD(pgtables);
 	int collapsed = 0;
 
-	addr = __cpa_addr(cpa, 0);
+	addr = cpa_addr(cpa, 0);
 	start = addr & PMD_MASK;
 	end = addr + PAGE_SIZE * cpa->numpages;
 
@@ -540,6 +540,17 @@ static void cpa_flush(struct cpa_data *cpa, int cache)
 	__cpa_flush(&req, cache);
 }
 
+static void arch_cpa_flush(struct cpa_data *cpa)
+{
+	/*
+	 * No need to flush, when we did not set any of the caching
+	 * attributes:
+	 */
+	int cache = !!pgprot2cachemode(cpa->mask_set);
+
+	cpa_flush(cpa, cache);
+}
+
 static bool overlaps(unsigned long r1_start, unsigned long r1_end,
 		     unsigned long r2_start, unsigned long r2_end)
 {
@@ -910,7 +921,7 @@ static pte_t *cpa_lookup_in_pgd(pgd_t *pgdp, unsigned long address,
 	return pte_offset_kernel(pmdp, address);
 }
 
-static void cpa_decode_leaf(struct cpa_leaf *leaf)
+static void arch_cpa_decode_leaf(struct cpa_leaf *leaf)
 {
 	enum pgtable_level level = leaf->level;
 	pte_t *kpte = leaf->kpte;
@@ -954,7 +965,7 @@ static pte_t *cpa_lookup(struct cpa_data *cpa, unsigned long address,
 
 	leaf->size = pgtable_level_size(leaf->level);
 	leaf->addr = address & pgtable_level_mask(leaf->level);
-	cpa_decode_leaf(leaf);
+	arch_cpa_decode_leaf(leaf);
 
 	return leaf->kpte;
 }
@@ -1099,6 +1110,22 @@ static pte_t cpa_pte(enum pgtable_level level, unsigned long pfn, pgprot_t prot)
 	return pfn_pte(pfn, prot);
 }
 
+static void arch_cpa_modify_leaf(struct cpa_leaf *leaf, pgprot_t prot)
+{
+	enum pgtable_level level = leaf->level;
+	unsigned long lpaddr = leaf->addr;
+	unsigned long pfn = leaf->pfn;
+	pte_t *kpte = leaf->kpte;
+	pte_t pte;
+
+	pte = cpa_pte(level, pfn, prot);
+
+	if (level == PGTABLE_LEVEL_PTE)
+		set_pte_atomic(kpte, pte);
+	else
+		__set_pmd_pte(kpte, lpaddr, pte);
+}
+
 static pgprot_t cpa_req_prot(const struct cpa_data *cpa,
 			     const struct cpa_leaf *leaf)
 {
@@ -1106,7 +1133,7 @@ static pgprot_t cpa_req_prot(const struct cpa_data *cpa,
 			pgprot_val(cpa->mask_set));
 }
 
-static pgprot_t cpa_new_prot(struct cpa_data *cpa, struct cpa_leaf *leaf)
+static pgprot_t arch_cpa_new_prot(struct cpa_data *cpa, struct cpa_leaf *leaf)
 {
 	pgprot_t prot = cpa_req_prot(cpa, leaf);
 	enum pgtable_level level = leaf->level;
@@ -1133,7 +1160,7 @@ static pgprot_t cpa_new_prot(struct cpa_data *cpa, struct cpa_leaf *leaf)
 
 static int should_split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf)
 {
-	unsigned long address = __cpa_addr(cpa, cpa->curpage);
+	unsigned long address = cpa_addr(cpa, cpa->curpage);
 	enum pgtable_level level = leaf->level;
 	unsigned long lpaddr = leaf->addr;
 	unsigned long old_pfn = leaf->pfn;
@@ -1141,8 +1168,6 @@ static int should_split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf)
 	pgprot_t old_prot = leaf->prot;
 	unsigned long numpages, pfn;
 	pgprot_t new_prot, req_prot;
-	pte_t *kpte = leaf->kpte;
-	pte_t new_pte;
 
 	if (cpa->flags & CPA_REQ_SPLIT)
 		return 1;
@@ -1189,41 +1214,33 @@ static int should_split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf)
 		return 1;
 
 	/*
-	 * Check whether the requested pgprot is conflicting with a static
-	 * protection requirement in the large page.
+	 * Check whether the architecture allows the requested protection for
+	 * the whole large page.
 	 */
-	new_prot = cpa_new_prot(cpa, leaf);
+	new_prot = arch_cpa_new_prot(cpa, leaf);
 
-	/*
-	 * If there is a conflict, split the large page.
-	 *
-	 * There used to be a 4k wise evaluation trying really hard to
-	 * preserve the large pages, but experimentation has shown, that this
-	 * does not help at all. There might be corner cases which would
-	 * preserve one large page occasionally, but it's really not worth the
-	 * extra code and cycles for the common case.
-	 */
+	/* If there is a conflict, split the large page. */
 	if (pgprot_val(req_prot) != pgprot_val(new_prot))
 		return 1;
 
 	/* All checks passed. Update the large page mapping. */
-	new_pte = cpa_pte(level, old_pfn, new_prot);
-	__set_pmd_pte(kpte, address, new_pte);
+	arch_cpa_modify_leaf(leaf, new_prot);
 	cpa->state |= CPA_ST_FLUSHTLB;
 	cpa_inc_pxd_preserved(level);
 	return 0;
 }
 
-static int
-__split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf, pte_t *pbase)
+static int arch_cpa_split_leaf(struct cpa_data *cpa, struct cpa_leaf *leaf,
+			       void *table)
 {
-	unsigned long address = __cpa_addr(cpa, cpa->curpage);
-	struct page *base = virt_to_page(pbase);
+	unsigned long address = cpa_addr(cpa, cpa->curpage);
+	struct page *base = virt_to_page(table);
 	enum pgtable_level level = leaf->level;
 	unsigned long pfn = leaf->pfn;
 	pgprot_t prot = leaf->prot;
 	pte_t *kpte = leaf->kpte;
 	unsigned long pfninc;
+	pte_t *pbase = table;
 	unsigned int i;
 
 	if (level != PGTABLE_LEVEL_PMD && level != PGTABLE_LEVEL_PUD)
@@ -1238,9 +1255,6 @@ __split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf, pte_t *pbase)
 	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
 		set_pte(pbase + i, cpa_pte(level - 1, pfn, prot));
 
-	if (cpa_is_direct_map(address))
-		direct_map_count_split(level);
-
 	/*
 	 * Install the new, split up pagetable.
 	 *
@@ -1273,7 +1287,7 @@ __split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf, pte_t *pbase)
 	return 0;
 }
 
-static void *cpa_alloc_pgtable(struct cpa_leaf *leaf)
+static void *arch_cpa_alloc_pgtable(struct cpa_leaf *leaf)
 {
 	if (leaf->level == PGTABLE_LEVEL_PMD)
 		return pte_alloc_one_kernel(&init_mm);
@@ -1281,7 +1295,7 @@ static void *cpa_alloc_pgtable(struct cpa_leaf *leaf)
 	return pmd_alloc_one(&init_mm, leaf->addr);
 }
 
-static void cpa_free_pgtable(struct cpa_leaf *leaf, void *table)
+static void arch_cpa_free_pgtable(struct cpa_leaf *leaf, void *table)
 {
 	if (leaf->level == PGTABLE_LEVEL_PMD)
 		pte_free_kernel(&init_mm, table);
@@ -1291,14 +1305,14 @@ static void cpa_free_pgtable(struct cpa_leaf *leaf, void *table)
 
 static int split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf)
 {
-	unsigned long address = __cpa_addr(cpa, cpa->curpage);
+	unsigned long address = cpa_addr(cpa, cpa->curpage);
 	pte_t *kpte = leaf->kpte;
 	struct cpa_leaf tmp;
 	void *table;
 	int ret = 0;
 
 	spin_unlock(&cpa_lock);
-	table = cpa_alloc_pgtable(leaf);
+	table = arch_cpa_alloc_pgtable(leaf);
 	spin_lock(&cpa_lock);
 	if (!table)
 		return -ENOMEM;
@@ -1311,14 +1325,17 @@ static int split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf)
 		goto out;
 	*leaf = tmp;
 
-	ret = __split_large_page(cpa, leaf, table);
+	ret = arch_cpa_split_leaf(cpa, leaf, table);
 	if (ret)
 		goto out;
 
+	if (cpa_is_direct_map(address))
+		direct_map_count_split(leaf->level);
+
 	return 0;
 
 out:
-	cpa_free_pgtable(leaf, table);
+	arch_cpa_free_pgtable(leaf, table);
 	return ret;
 }
 
@@ -1872,16 +1889,9 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	return 0;
 }
 
-static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr)
+static int cpa_process_fault(struct cpa_data *cpa)
 {
-	if (cpa->pgd) {
-		/*
-		 * Right now, we only execute this code path when mapping
-		 * the EFI virtual memory map regions, no other users
-		 * provide a ->pgd value. This may change in the future.
-		 */
-		return populate_pgd(cpa, vaddr);
-	}
+	unsigned long vaddr = cpa_addr(cpa, cpa->curpage);
 
 	/*
 	 * Ignore all non primary paths.
@@ -1896,23 +1906,41 @@ static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr)
 	 * to have holes.
 	 * Also set numpages to '1' indicating that we processed cpa req for
 	 * one virtual address page and its pfn. TBD: numpages can be set based
-	 * on the initial value and the level returned by lookup_address().
+	 * on the initial value and the level returned by cpa_lookup().
 	 */
 	if (cpa_is_direct_map(vaddr)) {
 		cpa->numpages = 1;
 		cpa->pfn = __pa(vaddr) >> PAGE_SHIFT;
 		return 0;
+	}
 
-	} else if (__cpa_pfn_in_highmap(cpa->pfn)) {
-		/* Faults in the highmap are OK, so do not warn: */
-		return -EFAULT;
-	} else {
-		WARN(1, "CPA: called for zero pte. "
-			"vaddr = %lx cpa->addr = %lx\n", vaddr,
-			cpa->addr);
+	WARN(1, "CPA: called for zero pte. "
+		"vaddr = %lx cpa->addr = %lx\n", vaddr, cpa->addr);
 
-		return -EFAULT;
+	return -EFAULT;
+}
+
+static int arch_cpa_process_fault(struct cpa_data *cpa)
+{
+	unsigned long vaddr = cpa_addr(cpa, cpa->curpage);
+
+	if (cpa->pgd) {
+		/*
+		 * Right now, we only execute this code path when mapping
+		 * the EFI virtual memory map regions, no other users
+		 * provide a ->pgd value. This may change in the future.
+		 * This happens only at boot, before the scheduler starts,
+		 * so populate_pgd() may allocate with cpa_lock held.
+		 */
+		return populate_pgd(cpa, vaddr);
 	}
+
+	/* Faults in the highmap are OK, so do not warn: */
+	if (!(cpa->state & CPA_ST_ALIAS) && !cpa_is_direct_map(vaddr) &&
+	    __cpa_pfn_in_highmap(cpa->pfn))
+		return -EFAULT;
+
+	return cpa_process_fault(cpa);
 }
 
 static int __change_page_attr(struct cpa_data *cpa)
@@ -1921,24 +1949,23 @@ static int __change_page_attr(struct cpa_data *cpa)
 	struct cpa_leaf leaf;
 	int do_split, ret;
 
-	address = __cpa_addr(cpa, cpa->curpage);
+	address = cpa_addr(cpa, cpa->curpage);
 repeat:
 	if (!cpa_lookup(cpa, address, &leaf))
-		return __cpa_process_fault(cpa, address);
+		return arch_cpa_process_fault(cpa);
 
 	if (leaf.level == PGTABLE_LEVEL_PTE) {
 		pgprot_t new_prot;
 		unsigned long pfn = leaf.pfn;
 
 		cpa_inc_pte_install();
-		new_prot = cpa_new_prot(cpa, &leaf);
+		new_prot = arch_cpa_new_prot(cpa, &leaf);
 		cpa->pfn = pfn;
 		/*
 		 * Do we really change anything ?
 		 */
 		if (pgprot_val(new_prot) != pgprot_val(leaf.prot)) {
-			set_pte_atomic(leaf.kpte,
-				       cpa_pte(leaf.level, pfn, new_prot));
+			arch_cpa_modify_leaf(&leaf, new_prot);
 			cpa->state |= CPA_ST_FLUSHTLB;
 		}
 		cpa->numpages = 1;
@@ -1952,8 +1979,8 @@ static int __change_page_attr(struct cpa_data *cpa)
 	do_split = should_split_large_page(cpa, &leaf);
 	/*
 	 * When the range fits into the existing large page,
-	 * return. cp->numpages and cpa->tlbflush have been updated in
-	 * try_large_page:
+	 * return. cpa->numpages and cpa->state have been updated in
+	 * should_split_large_page():
 	 */
 	if (do_split <= 0)
 		return do_split;
@@ -1968,12 +1995,27 @@ static int __change_page_attr(struct cpa_data *cpa)
 	return ret;
 }
 
-static int __change_page_attr_set_clr(struct cpa_data *cpa);
+static int change_page_attr_noflush(struct cpa_data *cpa);
+
+static int cpa_change_alias(struct cpa_data *cpa, struct cpa_data *alias)
+{
+	int ret;
+
+	alias->state &= ~CPA_ST_FLUSHTLB;
+	alias->state |= CPA_ST_ALIAS;
+	alias->curpage = 0;
+
+	ret = change_page_attr_noflush(alias);
+	if (alias->state & CPA_ST_FLUSHTLB)
+		cpa->state |= CPA_ST_FLUSHTLB | CPA_ST_FLUSH_ALL;
+
+	return ret;
+}
 
 /*
  * Check the directmap and "high kernel map" 'aliases'.
  */
-static int cpa_process_alias(struct cpa_data *cpa)
+static int arch_cpa_process_alias(struct cpa_data *cpa)
 {
 	struct cpa_data alias_cpa;
 	unsigned long vaddr;
@@ -1986,14 +2028,11 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	 * No need to redo, when the primary call touched the direct
 	 * mapping already:
 	 */
-	vaddr = __cpa_addr(cpa, cpa->curpage);
+	vaddr = cpa_addr(cpa, cpa->curpage);
 	if (!cpa_is_direct_map(vaddr)) {
 
 		alias_cpa = *cpa;
 		alias_cpa.addr = (unsigned long)__va(cpa->pfn << PAGE_SHIFT);
-		alias_cpa.state &= ~CPA_ST_FLUSHTLB;
-		alias_cpa.state |= CPA_ST_ALIAS;
-		alias_cpa.curpage = 0;
 
 		/* Directmap always has NX set, do not modify. */
 		if (__supported_pte_mask & _PAGE_NX) {
@@ -2001,9 +2040,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 			alias_cpa.mask_set.pgprot &= ~_PAGE_NX;
 		}
 
-		ret = __change_page_attr_set_clr(&alias_cpa);
-		if (alias_cpa.state & CPA_ST_FLUSHTLB)
-			cpa->state |= CPA_ST_FLUSHTLB | CPA_ST_FLUSH_ALL;
+		ret = cpa_change_alias(cpa, &alias_cpa);
 		if (ret)
 			return ret;
 	}
@@ -2019,9 +2056,6 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		alias_cpa = *cpa;
 		alias_cpa.addr = (cpa->pfn << PAGE_SHIFT) +
 				 __START_KERNEL_map - phys_base;
-		alias_cpa.state &= ~CPA_ST_FLUSHTLB;
-		alias_cpa.state |= CPA_ST_ALIAS;
-		alias_cpa.curpage = 0;
 
 		/*
 		 * [_text, _brk_end) also covers data, do not modify NX except
@@ -2036,16 +2070,14 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		 * The high mapping range is imprecise, so ignore the
 		 * return value.
 		 */
-		__change_page_attr_set_clr(&alias_cpa);
-		if (alias_cpa.state & CPA_ST_FLUSHTLB)
-			cpa->state |= CPA_ST_FLUSHTLB | CPA_ST_FLUSH_ALL;
+		cpa_change_alias(cpa, &alias_cpa);
 	}
 #endif
 
 	return 0;
 }
 
-static int __change_page_attr_set_clr(struct cpa_data *cpa)
+static int change_page_attr_noflush(struct cpa_data *cpa)
 {
 	unsigned long numpages = cpa->numpages;
 	unsigned long rempages = numpages;
@@ -2072,7 +2104,7 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa)
 
 		if (!(cpa->state & CPA_ST_ALIAS) &&
 		    !(cpa->flags & CPA_REQ_NO_CHECK_ALIAS)) {
-			ret = cpa_process_alias(cpa);
+			ret = arch_cpa_process_alias(cpa);
 			if (ret)
 				goto out;
 		}
@@ -2096,28 +2128,13 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa)
 	return ret;
 }
 
-static int change_page_attr_set_clr(unsigned long addr, int numpages,
-				    pgprot_t mask_set, pgprot_t mask_clr,
-				    int in_flag)
+static int change_page_attr(struct cpa_data *cpa)
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
-	if (!pgprot_val(mask_set) && !pgprot_val(mask_clr) &&
-	    !(in_flag & CPA_REQ_SPLIT))
-		return 0;
+	int ret;
 
 	/* Ensure we are PAGE_SIZE aligned */
-	if (addr & ~PAGE_MASK) {
-		addr &= PAGE_MASK;
+	if (cpa->addr & ~PAGE_MASK) {
+		cpa->addr &= PAGE_MASK;
 		/*
 		 * People should not be passing in unaligned addresses:
 		 */
@@ -2129,40 +2146,27 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 
 	vm_unmap_aliases();
 
-	cpa.addr = addr;
-	cpa.numpages = numpages;
-	cpa.mask_set = mask_set;
-	cpa.mask_clr = mask_clr;
-	cpa.flags = in_flag;
-	cpa.curpage = 0;
-
-	ret = __change_page_attr_set_clr(&cpa);
+	ret = change_page_attr_noflush(cpa);
 
 	/*
 	 * Check whether we really changed something:
 	 */
-	if (!(cpa.state & CPA_ST_FLUSHTLB))
-		goto out;
-
-	/*
-	 * No need to flush, when we did not set any of the caching
-	 * attributes:
-	 */
-	cache = !!pgprot2cachemode(mask_set);
+	if (!(cpa->state & CPA_ST_FLUSHTLB))
+		return ret;
 
 	/*
 	 * On error; flush everything to be sure.
 	 */
 	if (ret)
-		cpa.state |= CPA_ST_FLUSH_ALL;
+		cpa->state |= CPA_ST_FLUSH_ALL;
 
-	cpa_flush(&cpa, cache);
+	arch_cpa_flush(cpa);
 
 	if (ret)
-		goto out;
+		return ret;
 
-	if (!(cpa.flags & CPA_REQ_COLLAPSE))
-		goto out;
+	if (!(cpa->flags & CPA_REQ_COLLAPSE))
+		return 0;
 
 	/*
 	 * Take the mmap write lock on init_mm to avoid a use-after-free if
@@ -2172,12 +2176,36 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 	 */
 	scoped_guard(mmap_write_lock, &init_mm) {
 		guard(spinlock)(&cpa_lock);
-		cpa_collapse_large_pages(&cpa);
+		arch_cpa_collapse(cpa);
 	}
-out:
+
 	return ret;
 }
 
+static int change_page_attr_set_clr(unsigned long addr, int numpages,
+				    pgprot_t mask_set, pgprot_t mask_clr,
+				    int in_flag)
+{
+	struct cpa_data cpa = {
+		.addr = addr,
+		.numpages = numpages,
+		.mask_clr = mask_clr,
+		.flags = in_flag,
+	};
+
+	/*
+	 * Check, if we are requested to set a not supported
+	 * feature.  Clearing non-supported features is OK.
+	 */
+	cpa.mask_set = canon_pgprot(mask_set);
+
+	if (!pgprot_val(cpa.mask_set) && !pgprot_val(mask_clr) &&
+	    !(in_flag & CPA_REQ_SPLIT))
+		return 0;
+
+	return change_page_attr(&cpa);
+}
+
 static inline int change_page_attr_set(unsigned long addr, int numpages,
 				       pgprot_t mask)
 {
@@ -2235,7 +2263,7 @@ static int change_page_attr_pages(struct page **pages, int numpages,
 		cpa.numpages = n;
 		cpa.curpage = 0;
 		cpa.state = 0;
-		ret = __change_page_attr_set_clr(&cpa);
+		ret = change_page_attr_noflush(&cpa);
 		req.state |= cpa.state;
 		if (ret)
 			break;
@@ -2465,8 +2493,11 @@ static int set_memory_op(unsigned long addr, int numpages, enum cpa_op op)
 	if (ret)
 		return ret;
 
-	return change_page_attr_set_clr(addr, numpages, cpa.mask_set,
-					cpa.mask_clr, cpa.flags);
+	if (!pgprot_val(cpa.mask_set) && !pgprot_val(cpa.mask_clr) &&
+	    !(cpa.flags & CPA_REQ_SPLIT))
+		return 0;
+
+	return change_page_attr(&cpa);
 }
 
 int set_memory_x(unsigned long addr, int numpages)
@@ -2561,7 +2592,7 @@ static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
 	if (ret)
 		goto vmm_fail;
 
-	ret = __change_page_attr_set_clr(&cpa);
+	ret = change_page_attr_noflush(&cpa);
 
 	/*
 	 * After changing the encryption attribute, we need to flush TLBs again
@@ -2773,7 +2804,7 @@ static int set_direct_map(struct page *page, unsigned int nr, enum cpa_op op)
 	 * set_direct_map_*_noflush() change only the direct map, not its
 	 * aliases.
 	 */
-	return __change_page_attr_set_clr(&cpa);
+	return change_page_attr_noflush(&cpa);
 }
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)
@@ -2883,7 +2914,7 @@ int __init kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 
 	cpa.mask_set = __pgprot(_PAGE_PRESENT | page_flags);
 
-	retval = __change_page_attr_set_clr(&cpa);
+	retval = change_page_attr_noflush(&cpa);
 	__flush_tlb_all();
 
 out:
@@ -2918,7 +2949,7 @@ int __init kernel_unmap_pages_in_pgd(pgd_t *pgd, unsigned long address,
 
 	WARN_ONCE(num_online_cpus() > 1, "Don't call after initializing SMP");
 
-	retval = __change_page_attr_set_clr(&cpa);
+	retval = change_page_attr_noflush(&cpa);
 	__flush_tlb_all();
 
 	return retval;

-- 
2.53.0


