Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D330D606A33B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=figfd3fx
Received: by kanga.kvack.org (Postfix)
	id 0437D6B0611; Thu, 26 Nov 2026 06:22:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B0A6B0612; Thu, 26 Nov 2026 06:22:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74066B0613; Thu, 26 Nov 2026 06:22:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4ED96B0611
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:22:22 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 34F141A0F9B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:22:22 +0000 (UTC)
X-FDA: 85477031724.08.1E488AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8533D140007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:22:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=figfd3fx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692140;
	b=OAoMzEo71CIKKDQEs1or2YlJ2LnE3EE2bFsUzbCOv5TCWY3eSR/s5dj+ooEwTlrn2vdX9L
	xuXklV1GTYs27kzGU5n9FUlhPwUq6munpSSwzL5RWaWPQpi/AHhbwyOQXhjBCaAr3GjWby
	ItTZkIZePN6bLdF38IwBkZz4Prpk3Io=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RHsZcGFHHORpSCEjNn8E8Q2ufv0UX5M3uRjs8u8EpXA=;
	b=ebwvSST7r+CSJYpd18T6KkmVOiW8ZUy4d8B08cqFIOtKAmqibkL+AOxcDrXwNVmItPh8XV
	N3HxI93MWXboOegonMAPPN0dkrb9L7Q8YhDQNiuf2/81b/ak/1HVsXK0HgXBmCCGo/sLi2
	sACz+h0jlb3XW9ed+P7yYgqIOKroe7s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=figfd3fx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01E5E63440;
	Thu, 26 Nov 2026 11:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E2D1F00A3D;
	Thu, 26 Nov 2026 11:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692139;
	bh=RHsZcGFHHORpSCEjNn8E8Q2ufv0UX5M3uRjs8u8EpXA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=figfd3fxv8brNBoXJh3GBvsyrUW879Fc/OGGgoULpsbzUWm/xERpvcOTMh4rOCkbN
	 9LyH02BeSv4GmU3Et2zH5B3cTxOpzRpRgMc0Iuf385p6Cun8u7wsLWWbug1PptSVbt
	 S6N77WW2fljQqVRrgHgYaBItpZXJSzavkuu2MdWfLQva2IpXzZ6eLnHxuMBin8h2n8
	 2ISpqPnNk4A6ryHTGIDY7pdYd5h+b8eGhX3F5UxAeAQ+Z6eAN0OSpj6Zls7YqXwX32
	 pUhlOUmKEIx7agVW5OxVXL/Aw+tx6pA7FjhQuJYFQlwO4mUn5/UuBLT3xO/B6nlhMd
	 Cr33daaPBar4Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:15:02 +0200
Subject: [PATCH RFC v2 49/54] arm64: mm: allocate page tables in the
 callers of split_p{mu}d()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-49-723f1e33c3d8@kernel.org>
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
X-Rspamd-Queue-Id: 8533D140007
X-Stat-Signature: 397hhds78r4ufwz5h5ajzcp646dtdbeu
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795692140-871142
X-HE-Meta: U2FsdGVkX18cNs3tyhpeiTBYgUgna8NUhrLka99098qMz3K1cAfYpmBA/M6Nf4pmBh7AMBQlxJeH8a6zH9nHu1BC6Ob1ZS4jHZ9fZqo2YPj5yk+XVVYX2YwzZX0emlXYRJGEVJQ6IX13vrdnwV/uUM9r4O7QAqz32hCwO2891evVISloaNaQWjRXxCPnaUHIB0AVL8rNxI8uxmGbwCb3D/lS205Qg18BVx2SId7gxzyqlPfQK2Ycgtix3HNCz0zadSUZBOWNokzC5xnEhHcN7BFJYUGmRXKV4SWn30Y9jwtjcSCQ4kh2e5HgVG/ng4gFONtFnNKAV47Tq9U+/9PE1yw6ZIIVp+EbbamTxheps1CqGv52u2ulKta78kFPK9+EL5uJYjsgMvuEqY+BXY4qq+5JqmJLrlYechcbEtvVV4n9cQvFYzFCWAe21ZZwu1TOw/bCZwPsdZHTQVn5V708iron3D3eQ7tThUYQdaRwxa2znH5JzHZLVqFXMhqYmodMvpt8rAhMw/TDTlD07NVGB1gV4yIsylC5GHpK8PjJOnorziKtpNgaMuNxu5+5fDlROR90BC6hcX3/w2lXKvc/YR6XpGAX7/za5jK/DHHo/ghQi/ZfMZ1Kn4AdQMv+ewju4cKmXGhH0yaExlnBfcworZtZuQOsYI8kpcUm3iFoCdO9hDnOHXlbs0/7orXtWxfXGNctzVUaXovEKPUfdOY/sbJVZDnQ6F+0G2vMgWGQkRpOhOwtXbKiCsYcTbROl9Lbc4VlaRAad3sJA8OIM5wvsFcBOUv4e90j5HTZrj7sBtvk4uWCPUlZtnhPHdJQ7ATOfyNzU75TKljL/W97AIaSVBsMz36zWvZ+CRjLUF4WggncNm+ITY2iPe+9qXDf10jqZ3fuLHrFRT73NOCxsxqcnZMuJZva5b7CPKc51kzg0Gv2x3Ep9vcCZ4+BXNnYdCUi4SjUlAZ2Ex4vDM/6alt
 X6s1BXl3
 yWxbxXzSBDnPdL06PvwGXPp0Y4Zb6wm2GjDnEgJffyaVZP2FxOpFaO4+REY7acoZAOAg/dAOkPdWmUVDkFxK/2HgXtEJLzqYc08l4MkRX4w0qpckMQU9uHlApKrRvqetYWlrY5g44Ad84FEm7qU+IE3/Rwccqc0a7b3Kx6F/RylWx98lv7VHNRc42ma4hX9HL0XE8M0pByYoc1UD+UZ0aVRJi2tC1WuZC7C6NmMPR7DQjSWm2JMyMyl4QL684YKUynQusW7yq5awraxtay4NW2WAXf+IY1rvUzsv8sRceiQgqkfioKRNIDtxq2kaTCDxzivXX1nN4BBTtg/Twh78+adCaPe2xX1IQs7A3teez3GjWlbwNARksJ2R4Q802pG2RI+J2OEG4gtCwChP6l12vYLG0e8rmORXMqVVMG/aPoMtCKCgcLYBktosVVN7PtKaQpXO8FgHxCglpkbA80PB1voUR5eBL7Bh5uWb2kLgZBzWwHqBphMfyeUJbeMvJmvdJcUrS2pGWwMMhfu4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The generic CPA core allocates the page table for a split before it takes
cpa_lock and hands it to the architecture hook that splits a large mapping.

Let the callers of split_pmd() and split_pud() allocate the table, so that
the arm64's hook can use the helpers as they are.

No functional change.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm64/mm/mmu.c | 93 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 54 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 140520b351e2..0f96efea9057 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -601,20 +601,14 @@ static void split_contpte(pte_t *ptep)
 		__set_pte(ptep, pte_mknoncont(__ptep_get(ptep)));
 }
 
-static int split_pmd(pmd_t *pmdp, pmd_t pmd, gfp_t gfp, bool to_cont)
+static void split_pmd(pmd_t *pmdp, pmd_t pmd, pte_t *ptep, bool to_cont)
 {
 	pmdval_t tableprot = PMD_TYPE_TABLE | PMD_TABLE_UXN | PMD_TABLE_AF;
+	phys_addr_t pte_phys = virt_to_phys(ptep);
 	unsigned long pfn = pmd_pfn(pmd);
 	pgprot_t prot = pmd_pgprot(pmd);
-	phys_addr_t pte_phys;
-	pte_t *ptep;
 	int i;
 
-	pte_phys = pgd_pgtable_alloc_init_mm_gfp(PGTABLE_LEVEL_PTE, gfp);
-	if (pte_phys == INVALID_PHYS_ADDR)
-		return -ENOMEM;
-	ptep = (pte_t *)phys_to_virt(pte_phys);
-
 	if (pgprot_val(prot) & PMD_SECT_PXN)
 		tableprot |= PMD_TABLE_PXN;
 
@@ -634,8 +628,6 @@ static int split_pmd(pmd_t *pmdp, pmd_t pmd, gfp_t gfp, bool to_cont)
 	 */
 	dsb(ishst);
 	__pmd_populate(pmdp, pte_phys, tableprot);
-
-	return 0;
 }
 
 static void split_contpmd(pmd_t *pmdp)
@@ -647,21 +639,15 @@ static void split_contpmd(pmd_t *pmdp)
 		set_pmd(pmdp, pmd_mknoncont(pmdp_get(pmdp)));
 }
 
-static int split_pud(pud_t *pudp, pud_t pud, gfp_t gfp, bool to_cont)
+static void split_pud(pud_t *pudp, pud_t pud, pmd_t *pmdp, bool to_cont)
 {
 	pudval_t tableprot = PUD_TYPE_TABLE | PUD_TABLE_UXN | PUD_TABLE_AF;
 	unsigned int step = PMD_SIZE >> PAGE_SHIFT;
+	phys_addr_t pmd_phys = virt_to_phys(pmdp);
 	unsigned long pfn = pud_pfn(pud);
 	pgprot_t prot = pud_pgprot(pud);
-	phys_addr_t pmd_phys;
-	pmd_t *pmdp;
 	int i;
 
-	pmd_phys = pgd_pgtable_alloc_init_mm_gfp(PGTABLE_LEVEL_PMD, gfp);
-	if (pmd_phys == INVALID_PHYS_ADDR)
-		return -ENOMEM;
-	pmdp = (pmd_t *)phys_to_virt(pmd_phys);
-
 	if (pgprot_val(prot) & PMD_SECT_PXN)
 		tableprot |= PUD_TABLE_PXN;
 
@@ -681,8 +667,17 @@ static int split_pud(pud_t *pudp, pud_t pud, gfp_t gfp, bool to_cont)
 	 */
 	dsb(ishst);
 	__pud_populate(pudp, pmd_phys, tableprot);
+}
 
-	return 0;
+static void *split_pgtable_alloc(enum pgtable_level level, gfp_t gfp)
+{
+	phys_addr_t phys;
+
+	phys = pgd_pgtable_alloc_init_mm_gfp(level, gfp);
+	if (phys == INVALID_PHYS_ADDR)
+		return NULL;
+
+	return phys_to_virt(phys);
 }
 
 static int split_kernel_leaf_mapping_locked(unsigned long addr)
@@ -692,6 +687,7 @@ static int split_kernel_leaf_mapping_locked(unsigned long addr)
 	pud_t *pudp, pud;
 	pmd_t *pmdp, pmd;
 	pte_t *ptep, pte;
+	void *table;
 	int ret = 0;
 
 	/*
@@ -728,9 +724,13 @@ static int split_kernel_leaf_mapping_locked(unsigned long addr)
 	if (!pud_present(pud))
 		goto out;
 	if (pud_leaf(pud)) {
-		ret = split_pud(pudp, pud, GFP_PGTABLE_KERNEL, true);
-		if (ret)
+		table = split_pgtable_alloc(PGTABLE_LEVEL_PMD,
+					    GFP_PGTABLE_KERNEL);
+		if (!table) {
+			ret = -ENOMEM;
 			goto out;
+		}
+		split_pud(pudp, pud, table, true);
 	}
 
 	/*
@@ -753,9 +753,13 @@ static int split_kernel_leaf_mapping_locked(unsigned long addr)
 		 */
 		if (ALIGN_DOWN(addr, PMD_SIZE) == addr)
 			goto out;
-		ret = split_pmd(pmdp, pmd, GFP_PGTABLE_KERNEL, true);
-		if (ret)
+		table = split_pgtable_alloc(PGTABLE_LEVEL_PTE,
+					    GFP_PGTABLE_KERNEL);
+		if (!table) {
+			ret = -ENOMEM;
 			goto out;
+		}
+		split_pmd(pmdp, pmd, table, true);
 	}
 
 	/*
@@ -874,12 +878,18 @@ static int split_to_ptes_pud_entry(pud_t *pudp, unsigned long addr,
 {
 	gfp_t gfp = *(gfp_t *)walk->private;
 	pud_t pud = pudp_get(pudp);
-	int ret = 0;
+	pmd_t *pmdp;
 
-	if (pud_leaf(pud))
-		ret = split_pud(pudp, pud, gfp, false);
+	if (!pud_leaf(pud))
+		return 0;
 
-	return ret;
+	pmdp = split_pgtable_alloc(PGTABLE_LEVEL_PMD, gfp);
+	if (!pmdp)
+		return -ENOMEM;
+
+	split_pud(pudp, pud, pmdp, false);
+
+	return 0;
 }
 
 static int split_to_ptes_pmd_entry(pmd_t *pmdp, unsigned long addr,
@@ -887,21 +897,26 @@ static int split_to_ptes_pmd_entry(pmd_t *pmdp, unsigned long addr,
 {
 	gfp_t gfp = *(gfp_t *)walk->private;
 	pmd_t pmd = pmdp_get(pmdp);
-	int ret = 0;
+	pte_t *ptep;
 
-	if (pmd_leaf(pmd)) {
-		if (pmd_cont(pmd))
-			split_contpmd(pmdp);
-		ret = split_pmd(pmdp, pmd, gfp, false);
+	if (!pmd_leaf(pmd))
+		return 0;
 
-		/*
-		 * We have split the pmd directly to ptes so there is no need to
-		 * visit each pte to check if they are contpte.
-		 */
-		walk->action = ACTION_CONTINUE;
-	}
+	ptep = split_pgtable_alloc(PGTABLE_LEVEL_PTE, gfp);
+	if (!ptep)
+		return -ENOMEM;
 
-	return ret;
+	if (pmd_cont(pmd))
+		split_contpmd(pmdp);
+	split_pmd(pmdp, pmd, ptep, false);
+
+	/*
+	 * We have split the pmd directly to ptes so there is no need to
+	 * visit each pte to check if they are contpte.
+	 */
+	walk->action = ACTION_CONTINUE;
+
+	return 0;
 }
 
 static int split_to_ptes_pte_entry(pte_t *ptep, unsigned long addr,

-- 
2.53.0


