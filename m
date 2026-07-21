Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F3D2C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B843E6B0096; Tue, 21 Jul 2026 12:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5AC86B0098; Tue, 21 Jul 2026 12:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A496D6B0099; Tue, 21 Jul 2026 12:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69D816B0096
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:24:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB73A1C00B8
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:04 +0000 (UTC)
X-FDA: 85013305608.04.9CB0CEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 294F440011
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OagJFoho;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651043;
	b=3dnUsIKaMhvStTckWwLbOuPIkTaQE9yigW67jsC+U8C9HAV2SGh41edstuA5tLfQQOqk6E
	8zzRqPYTRFsZQDinUr5gXrY9qcUCqRh0kDeeJSvjQLIwvX8EV4B2qphEwA503hdBXRBwqr
	0J+oNtRZ4Icax1KgBloMW9f4bVQqavw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OagJFoho;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xk984xOoqHMYWzEeWbOiQPapcatMtu1dDjm87+skU/Y=;
	b=X7et+bC8/7Zh1cs57bDTY2eWN7SO2+PEWM7peU039LSb7LtLZTX0WRHubzImyYj6rD4dO1
	Q9ALT52ZIDloFCaB6ZE7CZyoULbfziAJO4d6qXQUYWisBmR4r3YnPgBODhsfirGqDGyl2M
	jVDnt/UiOltO69jrOrnCjrMYcCnjrLw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EF2A42446;
	Tue, 21 Jul 2026 16:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAEA1F00A3E;
	Tue, 21 Jul 2026 16:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651042;
	bh=Xk984xOoqHMYWzEeWbOiQPapcatMtu1dDjm87+skU/Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OagJFoho19cpqfub1YzwifiMSzRiR5VDkq3B6CG5fhiGVNucRrJC9v/boWxUZ4IKX
	 x3HDSiSIeHuFOOQy6XsOuSLjb9UH6xir61/MHkon9lam+5gE5Sa0nF8aMp4ZsPwak4
	 atvmfVNHOgmY3KUPbJeyndZjS3lC6/PcYuyQ2GAC3deN9e0i98UH77TfAmHZEZL6Mx
	 Kqhl+ymRDX0urq264d8/ZXaI6mTPLwEgo8pg2Qp98TupRP8jSaWlVxcbrt6po5lmcA
	 NII7NONcyf3G4BB3sg9MFdexEV9HpcRvLR2sqIWtQNghuQJzMdxTN/NulqmVQ4EnjI
	 R3jz6uliLQd7g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:26 +0300
Subject: [PATCH RFC 03/18] x86/mm/pat: replace x86-speficic pg_level with
 generic pgtable_level
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-3-2c1fc62306b3@kernel.org>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 294F440011
X-Stat-Signature: jdjag514biwcqitgr5nmz1d67wdofpqs
X-Rspam-User: 
X-HE-Tag: 1784651042-902338
X-HE-Meta: U2FsdGVkX18jxpEU8LP5Rzc/JV+e09NWjQECgNwHW0WPeuRKnllkZI/vUlx9ojPIWZTslSPs/5/vdf7EfuVDrs0LCuSb4zQLZG+hrSIYPBqxKO0dMGBiyltG54vDucecyyXRSPHecwyybZ+UpJYelhSvgi8yUIrkWk1cR/I83YBOo1naC6GeLTfALxm2Bp2d8EmR/nyXYEcVkAcmJ/QUKePcZkZqzIxQxVYwQjW+lVE1AjLji5Fo5KOd1L37bCRyJIdfaMt3XUSd0p91sd+qz8GPUPz123SOkGceDJ4W9hGZYkO2AIYv/QZ/z7WgemE7pRMEEc7Yeejee+FYVj/IcG1b7tgb40b0H2GCy5/GFATevTKnzoL/QcQvjZApEJUP8n+0Njsl3lgpzweDJPdZgwGa2VHchVI40HCPbQ+eYUuPul8Yj6lZ8Ty4n5mMNxFsMl9uOl6uu7pfcsWTVmW9xSe6RmtKiM9F5qWUdO04B+hVvWlMy+vHnd3ybbipCe3rmYMcEf5M7+5mBHDiO5JKyiA0huXL3btMBaOsfyYDZuTb6BE3aie3d/Mxa5OMUtr8Q+0Y4tzdqazLqPsel+3oIRiCM2v1KdHmMkdXnUFdsfjsiSoEWUrNxQ5v6uYDBPi1SWHpXFTRro7Eu0yCiFKpWkLdSafsKtX7a/GlsPICznXhKiEdq6x7ed1osJSLluyZAaKbiIrQ4g4LVKpKb3v958mOCzVT1hWKWbzreE/YYOlKYJH3se3Tup+CTv+7sX7FThU9jOqgE/jTx3jA++8z47BMkHzFr/JpaQ55zZ/9s70zAZd28J5inW4h0NCbVN2H+4dztBcoI5+KaGfg0iF6r6mfFmUVcqEXi7IgrqV2MRhvyv2ALzw94a7EFw4vFcj2NHkD3Oe5FHDKbo2cfPoh8CnhsiVzPwhFpDqJuuCGFKX5IWSWDz/Ijsd8w7vi9j7iVmcvGAskynaGEqQWtqI
 +LdHmX3E
 gSs9SHD5DaB0PkC+ucFI+mCwLm8hpB4Lga8CmYra+/MYOMqUhkIUqylrOsd/wEvHKuDoN8v2J1CDmk1zRlfh51+xCQFdLGg+4sZqJgeZoeCGvvf0e77vLZjAOnn92gq3vQncpIhlww0R/KQqsn+3e2hf+BYy3l+TDWKPo3jHOvwFJaI0LUjRz7XNUNTnOqdXSJZKeqn4dnzdrtMI+d0DPliF+5pxO1w4gi+JzgKAuSzeUGUGD7COjXg7rdG27YV7fdAMWJ61JorDr1eNTmNiSUSp4K54tPRU9QF9l0bnb+8wUR0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

change_page_attr() implementation uses x86-specific enum pg_level to
track page table levels.

In preparation to moving core parts of change_page_attr() to common
code, replace usage of enum pg_level and it's values with the generic
enum pgtable_level and the values it defines.

Extend the generic enum pgtable_level with PGTABLE_LEVEL_NONE and
PGTABLE_LEVEL_NUM to match the numeric values from enum pg_level. This
is safe because nothing relies on the numeric values of PGTABLE_LEVEL_*
constants.

No functional change intended.

Assisted-by: Copilot:claude-opus-4.8
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 56 ++++++++++++++++++++++----------------------
 include/linux/pgtable.h      |  6 ++++-
 2 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 9382f1d6194f..328805933d4d 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -80,7 +80,7 @@ static inline pgprot_t cachemode2pgprot(enum page_cache_mode pcm)
 }
 
 #ifdef CONFIG_PROC_FS
-static unsigned long direct_pages_count[PG_LEVEL_NUM];
+static unsigned long direct_pages_count[PGTABLE_LEVEL_NUM];
 
 void update_page_count(int level, unsigned long pages)
 {
@@ -97,9 +97,9 @@ static void split_page_count(int level)
 
 	direct_pages_count[level]--;
 	if (system_state == SYSTEM_RUNNING) {
-		if (level == PG_LEVEL_2M)
+		if (level == PGTABLE_LEVEL_PMD)
 			count_vm_event(DIRECT_MAP_LEVEL2_SPLIT);
-		else if (level == PG_LEVEL_1G)
+		else if (level == PGTABLE_LEVEL_PUD)
 			count_vm_event(DIRECT_MAP_LEVEL3_SPLIT);
 	}
 	direct_pages_count[level - 1] += PTRS_PER_PTE;
@@ -109,9 +109,9 @@ static void collapse_page_count(int level)
 {
 	direct_pages_count[level]++;
 	if (system_state == SYSTEM_RUNNING) {
-		if (level == PG_LEVEL_2M)
+		if (level == PGTABLE_LEVEL_PMD)
 			count_vm_event(DIRECT_MAP_LEVEL2_COLLAPSE);
-		else if (level == PG_LEVEL_1G)
+		else if (level == PGTABLE_LEVEL_PUD)
 			count_vm_event(DIRECT_MAP_LEVEL3_COLLAPSE);
 	}
 	direct_pages_count[level - 1] -= PTRS_PER_PTE;
@@ -120,17 +120,17 @@ static void collapse_page_count(int level)
 void arch_report_meminfo(struct seq_file *m)
 {
 	seq_printf(m, "DirectMap4k:    %8lu kB\n",
-			direct_pages_count[PG_LEVEL_4K] << 2);
+			direct_pages_count[PGTABLE_LEVEL_PTE] << 2);
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 	seq_printf(m, "DirectMap2M:    %8lu kB\n",
-			direct_pages_count[PG_LEVEL_2M] << 11);
+			direct_pages_count[PGTABLE_LEVEL_PMD] << 11);
 #else
 	seq_printf(m, "DirectMap4M:    %8lu kB\n",
-			direct_pages_count[PG_LEVEL_2M] << 12);
+			direct_pages_count[PGTABLE_LEVEL_PMD] << 12);
 #endif
 	if (direct_gbpages)
 		seq_printf(m, "DirectMap1G:    %8lu kB\n",
-			direct_pages_count[PG_LEVEL_1G] << 20);
+			direct_pages_count[PGTABLE_LEVEL_PUD] << 20);
 }
 #else
 static inline void split_page_count(int level) { }
@@ -164,7 +164,7 @@ static inline void cpa_inc_4k_install(void)
 
 static inline void cpa_inc_lp_sameprot(int level)
 {
-	if (level == PG_LEVEL_1G)
+	if (level == PGTABLE_LEVEL_PUD)
 		cpa_1g_sameprot++;
 	else
 		cpa_2m_sameprot++;
@@ -172,7 +172,7 @@ static inline void cpa_inc_lp_sameprot(int level)
 
 static inline void cpa_inc_lp_preserved(int level)
 {
-	if (level == PG_LEVEL_1G)
+	if (level == PGTABLE_LEVEL_PUD)
 		cpa_1g_preserved++;
 	else
 		cpa_2m_preserved++;
@@ -577,7 +577,7 @@ static pgprotval_t protect_kernel_text_ro(unsigned long start,
 	 * so the protections for kernel text and identity mappings have to
 	 * be the same.
 	 */
-	if (lookup_address(start, &level) && (level != PG_LEVEL_4K))
+	if (lookup_address(start, &level) && (level != PGTABLE_LEVEL_PTE))
 		return _PAGE_RW;
 	return 0;
 }
@@ -721,14 +721,14 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 	pud_t *pud;
 	pmd_t *pmd;
 
-	*level = PG_LEVEL_256T;
+	*level = PGTABLE_LEVEL_PGD;
 	*nx = false;
 	*rw = true;
 
 	if (pgd_none(*pgd))
 		return NULL;
 
-	*level = PG_LEVEL_512G;
+	*level = PGTABLE_LEVEL_P4D;
 	*nx |= pgd_flags(*pgd) & _PAGE_NX;
 	*rw &= !!(pgd_flags(*pgd) & _PAGE_RW);
 
@@ -739,7 +739,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 	if (p4d_leaf(*p4d) || !p4d_present(*p4d))
 		return (pte_t *)p4d;
 
-	*level = PG_LEVEL_1G;
+	*level = PGTABLE_LEVEL_PUD;
 	*nx |= p4d_flags(*p4d) & _PAGE_NX;
 	*rw &= !!(p4d_flags(*p4d) & _PAGE_RW);
 
@@ -750,7 +750,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 	if (pud_leaf(*pud) || !pud_present(*pud))
 		return (pte_t *)pud;
 
-	*level = PG_LEVEL_2M;
+	*level = PGTABLE_LEVEL_PMD;
 	*nx |= pud_flags(*pud) & _PAGE_NX;
 	*rw &= !!(pud_flags(*pud) & _PAGE_RW);
 
@@ -761,7 +761,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 	if (pmd_leaf(*pmd) || !pmd_present(*pmd))
 		return (pte_t *)pmd;
 
-	*level = PG_LEVEL_4K;
+	*level = PGTABLE_LEVEL_PTE;
 	*nx |= pmd_flags(*pmd) & _PAGE_NX;
 	*rw &= !!(pmd_flags(*pmd) & _PAGE_RW);
 
@@ -849,9 +849,9 @@ pmd_t *lookup_pmd_address(unsigned long address)
 phys_addr_t slow_virt_to_phys(void *__virt_addr)
 {
 	unsigned long virt_addr = (unsigned long)__virt_addr;
+	enum pgtable_level level;
 	phys_addr_t phys_addr;
 	unsigned long offset;
-	enum pg_level level;
 	pte_t *pte;
 
 	pte = lookup_address(virt_addr, &level);
@@ -863,11 +863,11 @@ phys_addr_t slow_virt_to_phys(void *__virt_addr)
 	 * make 32-PAE kernel work correctly.
 	 */
 	switch (level) {
-	case PG_LEVEL_1G:
+	case PGTABLE_LEVEL_PUD:
 		phys_addr = (phys_addr_t)pud_pfn(*(pud_t *)pte) << PAGE_SHIFT;
 		offset = virt_addr & ~PUD_MASK;
 		break;
-	case PG_LEVEL_2M:
+	case PGTABLE_LEVEL_PMD:
 		phys_addr = (phys_addr_t)pmd_pfn(*(pmd_t *)pte) << PAGE_SHIFT;
 		offset = virt_addr & ~PMD_MASK;
 		break;
@@ -929,8 +929,8 @@ static int __should_split_large_page(pte_t *kpte, unsigned long address,
 {
 	unsigned long numpages, pmask, psize, lpaddr, pfn, old_pfn;
 	pgprot_t old_prot, new_prot, req_prot, chk_prot;
+	enum pgtable_level level;
 	pte_t new_pte, *tmp;
-	enum pg_level level;
 	bool nx, rw;
 
 	/*
@@ -942,12 +942,12 @@ static int __should_split_large_page(pte_t *kpte, unsigned long address,
 		return 1;
 
 	switch (level) {
-	case PG_LEVEL_2M:
+	case PGTABLE_LEVEL_PMD:
 		old_prot = pmd_pgprot(*(pmd_t *)kpte);
 		old_pfn = pmd_pfn(*(pmd_t *)kpte);
 		cpa_inc_2m_checked();
 		break;
-	case PG_LEVEL_1G:
+	case PGTABLE_LEVEL_PUD:
 		old_prot = pud_pgprot(*(pud_t *)kpte);
 		old_pfn = pud_pfn(*(pud_t *)kpte);
 		cpa_inc_1g_checked();
@@ -1148,7 +1148,7 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 	paravirt_alloc_pte(&init_mm, page_to_pfn(base));
 
 	switch (level) {
-	case PG_LEVEL_2M:
+	case PGTABLE_LEVEL_PMD:
 		ref_prot = pmd_pgprot(*(pmd_t *)kpte);
 		/*
 		 * Clear PSE (aka _PAGE_PAT) and move
@@ -1160,7 +1160,7 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 		lpinc = PAGE_SIZE;
 		break;
 
-	case PG_LEVEL_1G:
+	case PGTABLE_LEVEL_PUD:
 		ref_prot = pud_pgprot(*(pud_t *)kpte);
 		ref_pfn = pud_pfn(*(pud_t *)kpte);
 		pfninc = PMD_SIZE >> PAGE_SHIFT;
@@ -1311,7 +1311,7 @@ static int collapse_pmd_page(pmd_t *pmd, unsigned long addr,
 	}
 
 	if (virt_addr_valid(addr) && pfn_range_is_mapped(pfn, pfn + 1))
-		collapse_page_count(PG_LEVEL_2M);
+		collapse_page_count(PGTABLE_LEVEL_PMD);
 
 	return 1;
 }
@@ -1358,7 +1358,7 @@ static int collapse_pud_page(pud_t *pud, unsigned long addr,
 	set_pud(pud, pfn_pud(pfn, pmd_pgprot(first)));
 
 	if (virt_addr_valid(addr) && pfn_range_is_mapped(pfn, pfn + 1))
-		collapse_page_count(PG_LEVEL_1G);
+		collapse_page_count(PGTABLE_LEVEL_PUD);
 
 	return 1;
 }
@@ -1860,7 +1860,7 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 	if (pte_none(old_pte))
 		return __cpa_process_fault(cpa, address, primary);
 
-	if (level == PG_LEVEL_4K) {
+	if (level == PGTABLE_LEVEL_PTE) {
 		pte_t new_pte;
 		pgprot_t old_prot = pte_pgprot(old_pte);
 		pgprot_t new_prot = pte_pgprot(old_pte);
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 2981e386da7b..3889bc2a1f76 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2295,16 +2295,20 @@ static inline bool arch_has_pfn_modify_check(void)
 typedef unsigned int pgtbl_mod_mask;
 
 enum pgtable_level {
-	PGTABLE_LEVEL_PTE = 0,
+	PGTABLE_LEVEL_NONE = 0,
+	PGTABLE_LEVEL_PTE,
 	PGTABLE_LEVEL_PMD,
 	PGTABLE_LEVEL_PUD,
 	PGTABLE_LEVEL_P4D,
 	PGTABLE_LEVEL_PGD,
+	PGTABLE_LEVEL_NUM,
 };
 
 static inline const char *pgtable_level_to_str(enum pgtable_level level)
 {
 	switch (level) {
+	case PGTABLE_LEVEL_NONE:
+		return "none";
 	case PGTABLE_LEVEL_PTE:
 		return "pte";
 	case PGTABLE_LEVEL_PMD:

-- 
2.53.0


