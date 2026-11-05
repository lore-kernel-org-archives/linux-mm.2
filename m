Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86E7A606A33C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JQ/hqvTH
Received: by kanga.kvack.org (Postfix)
	id C75AF6B05B2; Wed,  4 Nov 2026 23:34:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C255A6B05B3; Wed,  4 Nov 2026 23:34:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C236B05B4; Wed,  4 Nov 2026 23:34:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 724696B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:34:21 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5FBF31608ED
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:34:19 +0000 (UTC)
X-FDA: 85399798638.16.B86BC32
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9D76240007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:34:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="JQ/hqvTH";
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793853257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbiMm9IkcQKltaeHCoPL+dwaH/UIt2WQ7KbmP1IQQxQ=;
	b=CY5wlln0colxdkwR7UJIW3G6UEDDpGuObdbeZmTJiAqo6x/MrdKwr7480Kp372vO6HKBfA
	oz0Qon4nwLAUrxAFTWaoMWE/31s7WOYRm1dh0b7Py4ot1Keh9+7W6uWjv8aXnlMKHm/b7w
	E1BFaq9ElUep+WHppS6EyPvmRKAXeYM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="JQ/hqvTH";
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793853257;
	b=xjhKMXBaWAXRmPGic6ucZ9qm3Yz/1YOrlqzGnaJW9blAGlibPeSSft3wL4gIoVabyXxxLh
	AUaC5eUWPG8ymYvMRxijGjOW9njIpz4hMfyHXvUEacVp29eKbFUDw7jwCsAKA0v8g9Wo2v
	+OunxwB1/QSe7d+NQztBQh5954mdm6I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9954E2944;
	Wed,  4 Nov 2026 20:34:13 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF2C83F673;
	Wed,  4 Nov 2026 20:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793853256; bh=fV6HPGJUWhktXmPowKeH5cvTaXorVoFH2iZgjxs5r8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQ/hqvTHQ6l39HlU8xgxuAIVGHRykeQHhT3Qh07nfN84RtJpfbHvqDZaB4V2vnBYc
	 x73umtbfJnuQkVtf5JJn+n0MikmoBBNEDF+ACCxXaCfMJ++jY1Vkyb41VKSkPTiXPe
	 1ACeUUw6UaFMlYLVMtltv03q6R+//D0ziMy0YBOI=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com
Subject: [PATCH V4 2/4] arm64/mm: Use pudp_get() for PUD accesses
Date: Thu,  5 Nov 2026 10:04:01 +0530
Message-ID: <20261105043403.3326445-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105043403.3326445-1-anshuman.khandual@arm.com>
References: <20261105043403.3326445-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ut4x1uuwxx9zoxh4j67dfrqu5wtxxtu1
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9D76240007
X-HE-Tag: 1793853257-58386
X-HE-Meta: U2FsdGVkX1/fuq5WJmkS8yzCS6RobI5DLzAtQKHwCuyIF8clTjVJnHYizzeWbsqzzjl3BVe0o971hLKnYDt7QNlS7Fzsk030my4o8U9C3WCRm0qcOjEqv+5aO0xny+0IhGQMbt4nPo6SlcDByTjwNZ1Cafb29gcRbEd2QOux01bpBGnhal04W/GqckSB1HS3CRMXpUy+yuzRrZ74UknGYTClDkVhhiomjYmhVXlS/8h12gLLrAyepJFTsNwU5lV5+h1OP6khyviACQ7KJDCiwf4F3+A/YqWvr1cfwhHvIZ8rvDZDq6ZJhbyUR6i2hrT4pRiW6j8u/qb4oyv9B7Tjunmm4rMDcdYTMz4754P01J6obmI1bVBGg/EgOXCqfA17hrUDzr/IX/Bv/KpnZmwepTSSkEJ61qtkxhtDwD83IE+RsxJtpCncXmTlgZ9bZ0iuPUNYuoLvXauP0sy9XyS++jmlgd1t23TWdJg/e4bg+8RcUT87imjRRVPRKMddgbNCkKRjkDz8NJYEwbeeaJDU4jTzs19E2GFlCvjNEyLrwlDrnLaGsx87WocVDXeY8FlXkugMer0uMukmpjP9GzVgONr8vDcObJCh7rUDiQTG3Zm0CuZRWZjMI7nXpNmuoTf7jyoYWA2XXH/4wGu2iWSL/rzErXT/DKh9VS/gTW0AJ0rEzsym3CRvqPL5czLgNP36cDDAn9w43PIOWOFyX5P6Aa0kpYUtyZOa2IGE21KksrMbMLu7ntQzjWNHp5Ge6AjhlXVT+lqbBdezwPG12T12pYwuq5B9JNE4c7GacbxlYysLWWoun2AbQ6NNhCmhXFscevdrkIBiIPob+0U+A+qYjH5nQJKWRg2DOHTJOHK2CLak4O6HHg1vZO8RNUXgDgamJKF01LEXnYzeaw8z84Vh76rddhVetZDRpLcBxzZ9t0xn/Ti9zzUx6I8whepBIXXh8vXGzuBcaHLNYumosq+
 yClNxPKE
 ZG0CXURBQEe/lW2rnFGawwajcThSt/+/LeJ7N56OV7X6j5L6+4oBmq9FfaZVi6iDGioQUsplduJPRkO0ainhoV4B3uLblIuu9qKZPQ0d/1RMtV0IkhyT2UaiXibeUwUSoi+OpyDHiWMuEYpM/TaKSVzODl7BJelNyeKxoyoEisH7owQziPZQVy9U7KzNa9HmBQF71/3e+9jv8YjWOkC3lnYqjBX84nrPufeO/w/2R0HtbaHVe6HS3LJXo5ed3F6fTUQM5+gb7JLzpg48du49PbwKcXotSmaHoK+1UC5/SN77ecDGtel3i7BFXm1mW2IAkM7pUa3b0Y4FHwdSX3fLTRWYREWv/P4i3YRWC8JWqRWyMN4lKVfqZfbmsq06qxxxmZECmIn6EIfWvW7hNRZQQ2SmP7/QqTuzc6iETcGfPdsnyffoPnYTagt6XIRz+aRoXJMWjsWI1HdIOEGzyDaeK6zuUJp0vSJSY4SBMwM7CQo3hwfY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace READ_ONCE() with pudp_get() for PUD accesses in preparation for
supporting both D64 and D128 translation table formats.

READ_ONCE() cannot currently be used for 128-bit page table entries on
arm64 because it does not provide the required 128-bit single-copy
atomicity, causing builds to fail for accesses wider than 64 bits.

Although LDP/STP provide the required atomicity when FEAT_LSE is available
(as required by FEAT_D128), extending READ_ONCE() to support 128-bit
accesses is undesirable. READ_ONCE() is a general-purpose API, so doing so
could encourage other 128-bit users that would either fail to build in
configurations without D128 support or, if D128 becomes a runtime option,
silently permit tearing on systems without the required hardware support.

Instead, standardize PUD accesses on the existing page-table helpers. These
can be overridden on arm64 to provide 128-bit single-copy atomicity when
required.

No functional change intended.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: kasan-dev@googlegroups.com
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h |  3 ++-
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/fixmap.c           |  2 +-
 arch/arm64/mm/hugetlbpage.c      |  4 ++--
 arch/arm64/mm/kasan_init.c       |  4 ++--
 arch/arm64/mm/mmu.c              | 20 ++++++++++----------
 arch/arm64/mm/pageattr.c         |  2 +-
 arch/arm64/mm/trans_pgd.c        |  4 ++--
 8 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index f619fa74da3c..96cfcc70acaa 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -873,7 +873,8 @@ static inline pmd_t *pud_pgtable(pud_t pud)
 }
 
 /* Find an entry in the second-level page table. */
-#define pmd_offset_phys(dir, addr)	(pud_page_paddr(READ_ONCE(*(dir))) + pmd_index(addr) * sizeof(pmd_t))
+#define pmd_offset_phys(dir, addr)	(pud_page_paddr(pudp_get(dir)) + \
+					 pmd_index(addr) * sizeof(pmd_t))
 
 #define pmd_set_fixmap(addr)		((pmd_t *)set_fixmap_offset(FIX_PMD, addr))
 #define pmd_set_fixmap_offset(pud, addr)	pmd_set_fixmap(pmd_offset_phys(pud, addr))
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 33b05a9f13d7..ea0cdc730768 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -181,7 +181,7 @@ static void show_pte(unsigned long addr)
 			break;
 
 		pudp = pud_offset_lockless(p4dp, p4d, addr);
-		pud = READ_ONCE(*pudp);
+		pud = pudp_get(pudp);
 		ptval_to_str(pxd_str, pud_val(pud));
 		pr_cont(", pud=%s", pxd_str);
 		if (pud_none(pud) || pud_bad(pud))
diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index 3cdac8021d4f..d9a870836faf 100644
--- a/arch/arm64/mm/fixmap.c
+++ b/arch/arm64/mm/fixmap.c
@@ -56,7 +56,7 @@ static void __init early_fixmap_init_pmd(pud_t *pudp, unsigned long addr,
 					 unsigned long end)
 {
 	unsigned long next;
-	pud_t pud = READ_ONCE(*pudp);
+	pud_t pud = pudp_get(pudp);
 	pmd_t *pmdp;
 
 	if (pud_none(pud))
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index cdaa4500faf9..c9ad5e75b073 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -262,7 +262,7 @@ pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 		WARN_ON(addr & (sz - 1));
 		ptep = pte_alloc_huge(mm, pmdp, addr);
 	} else if (sz == PMD_SIZE) {
-		if (want_pmd_share(vma, addr) && pud_none(READ_ONCE(*pudp)))
+		if (want_pmd_share(vma, addr) && pud_none(pudp_get(pudp)))
 			ptep = huge_pmd_share(mm, vma, addr, pudp);
 		else
 			ptep = (pte_t *)pmd_alloc(mm, pudp, addr);
@@ -292,7 +292,7 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
 		return NULL;
 
 	pudp = pud_offset(p4dp, addr);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (sz != PUD_SIZE && pud_none(pud))
 		return NULL;
 	/* hugepage or swap? */
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index 7ca833c5de5e..aad29bcc7622 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -76,7 +76,7 @@ static pte_t *__init kasan_pte_offset(pmd_t *pmdp, unsigned long addr, int node,
 static pmd_t *__init kasan_pmd_offset(pud_t *pudp, unsigned long addr, int node,
 				      bool early)
 {
-	if (pud_none(READ_ONCE(*pudp))) {
+	if (pud_none(pudp_get(pudp))) {
 		phys_addr_t pmd_phys = early ?
 				__pa_symbol(kasan_early_shadow_pmd)
 					: kasan_alloc_zeroed_page(node);
@@ -150,7 +150,7 @@ static void __init kasan_pud_populate(p4d_t *p4dp, unsigned long addr,
 	do {
 		next = pud_addr_end(addr, end);
 		kasan_pmd_populate(pudp, addr, next, node, early);
-	} while (pudp++, addr = next, addr != end && pud_none(READ_ONCE(*pudp)));
+	} while (pudp++, addr = next, addr != end && pud_none(pudp_get(pudp)));
 }
 
 static void __init kasan_p4d_populate(pgd_t *pgdp, unsigned long addr,
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index c998310406f9..7aa8793f13c5 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -309,7 +309,7 @@ static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 {
 	int ret;
 	unsigned long next;
-	pud_t pud = READ_ONCE(*pudp);
+	pud_t pud = pudp_get(pudp);
 	pmd_t *pmdp;
 
 	/*
@@ -390,7 +390,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 	}
 
 	do {
-		pud_t old_pud = READ_ONCE(*pudp);
+		pud_t old_pud = pudp_get(pudp);
 
 		next = pud_addr_end(addr, end);
 
@@ -408,7 +408,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 			 * only allow updates to the permission attributes.
 			 */
 			BUG_ON(!pgattr_change_is_safe(pud_val(old_pud),
-						      READ_ONCE(pud_val(*pudp))));
+						      pud_val(pudp_get(pudp))));
 		} else {
 			ret = alloc_init_cont_pmd(pudp, addr, next, phys, prot,
 						  pgtable_alloc, flags);
@@ -416,7 +416,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 				goto out;
 
 			VM_WARN_ON_ONCE(pud_val(old_pud) != 0 &&
-					pud_val(old_pud) != READ_ONCE(pud_val(*pudp)));
+					pud_val(old_pud) != pud_val(pudp_get(pudp)));
 		}
 		phys += next - addr;
 	} while (pudp++, addr = next, addr != end);
@@ -1591,7 +1591,7 @@ static void unmap_hotplug_pud_range(p4d_t *p4dp, unsigned long addr,
 	do {
 		next = pud_addr_end(addr, end);
 		pudp = pud_offset(p4dp, addr);
-		pud = READ_ONCE(*pudp);
+		pud = pudp_get(pudp);
 		if (pud_none(pud))
 			continue;
 
@@ -1748,7 +1748,7 @@ static void free_empty_pud_table(p4d_t *p4dp, unsigned long addr,
 	do {
 		next = pud_addr_end(addr, end);
 		pudp = pud_offset(p4dp, addr);
-		pud = READ_ONCE(*pudp);
+		pud = pudp_get(pudp);
 		if (pud_none(pud))
 			continue;
 
@@ -1769,7 +1769,7 @@ static void free_empty_pud_table(p4d_t *p4dp, unsigned long addr,
 	 */
 	pudp = pud_offset(p4dp, 0UL);
 	for (i = 0; i < PTRS_PER_PUD; i++) {
-		if (!pud_none(READ_ONCE(pudp[i])))
+		if (!pud_none(pudp_get(pudp + i)))
 			return;
 	}
 
@@ -1867,7 +1867,7 @@ int pud_set_huge(pud_t *pudp, phys_addr_t phys, pgprot_t prot)
 	pud_t new_pud = pfn_pud(__phys_to_pfn(phys), mk_pud_sect_prot(prot));
 
 	/* Only allow permission changes for now */
-	if (!pgattr_change_is_safe(READ_ONCE(pud_val(*pudp)),
+	if (!pgattr_change_is_safe(pud_val(pudp_get(pudp)),
 				   pud_val(new_pud)))
 		return 0;
 
@@ -1898,7 +1898,7 @@ void p4d_clear_huge(p4d_t *p4dp)
 
 int pud_clear_huge(pud_t *pudp)
 {
-	if (!pud_leaf(READ_ONCE(*pudp)))
+	if (!pud_leaf(pudp_get(pudp)))
 		return 0;
 	pud_clear(pudp);
 	return 1;
@@ -1938,7 +1938,7 @@ int pud_free_pmd_page(pud_t *pudp, unsigned long addr)
 	pud_t pud;
 	unsigned long next, end;
 
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 
 	if (!pud_table(pud)) {
 		VM_WARN_ON(1);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index bf1fd1258a75..c544a61a5afd 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -355,7 +355,7 @@ bool kernel_page_present(struct page *page)
 		return false;
 
 	pudp = pud_offset(p4dp, addr);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (pud_none(pud))
 		return false;
 	if (pud_leaf(pud))
diff --git a/arch/arm64/mm/trans_pgd.c b/arch/arm64/mm/trans_pgd.c
index b27b2d2c20c3..d119119455f1 100644
--- a/arch/arm64/mm/trans_pgd.c
+++ b/arch/arm64/mm/trans_pgd.c
@@ -64,7 +64,7 @@ static int copy_pmd(struct trans_pgd_info *info, pud_t *dst_pudp,
 	unsigned long next;
 	unsigned long addr = start;
 
-	if (pud_none(READ_ONCE(*dst_pudp))) {
+	if (pud_none(pudp_get(dst_pudp))) {
 		dst_pmdp = trans_alloc(info);
 		if (!dst_pmdp)
 			return -ENOMEM;
@@ -109,7 +109,7 @@ static int copy_pud(struct trans_pgd_info *info, p4d_t *dst_p4dp,
 
 	src_pudp = pud_offset(src_p4dp, start);
 	do {
-		pud_t pud = READ_ONCE(*src_pudp);
+		pud_t pud = pudp_get(src_pudp);
 
 		next = pud_addr_end(addr, end);
 		if (pud_none(pud))
-- 
2.43.0


