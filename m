Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3437EC982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 06:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91986B00AA; Tue, 22 Sep 2026 02:16:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42536B00AC; Tue, 22 Sep 2026 02:16:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09B66B00AD; Tue, 22 Sep 2026 02:16:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8F536B00AA
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:16:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4BD58A603D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:16:54 +0000 (UTC)
X-FDA: 85240389948.14.595FC1E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8D475C0003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:16:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KrSj76Tl;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790057812;
	b=3M72CMMdplDaeiEgr+PxQ/edDoJbYuhGFBVqAnctKzRcMcw/o27wjTimaCP56LO264KyWc
	gkbqf0xKTmkmfy0zqy07q+wqzBYOIorHu/Qsbdyl+YUDcF/Uht7OS+Us/+ZXiWzF38m/Lb
	+GQTHfF75LCdhAjcT9exNWucpyepn/w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KrSj76Tl;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790057812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/wMiI6hWwl8Fc1Ou1HqgnsEZRlf7JR8IzVIn4azC5Y=;
	b=Q3htmiaum/3djQMIsF5Iom0Yhao0fY1wJRIz977IPdNdmDcQpimq0xaLu5pfN64Fwnu8oP
	E2/PNm3fB6z1ANL2AUqSVHdIxIEJv3za/vzJ16dJKP8LNQKDDXMY8lRmQkErfTKhpC9BKY
	teZm1WCsC0dx/w0uANZ2eQcvOipp56Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1267E152B;
	Mon, 21 Sep 2026 23:16:48 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D1FFE3F632;
	Mon, 21 Sep 2026 23:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790057811; bh=YY1OaMPb64xJn1b27visI3ZEml4aTTF4OARXpGvoiBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrSj76Tl2tA6GkRkFYOY4euoKjudnSXomBvK8dIRRdxQ/KkBQHRk9plGZDshFnNOy
	 dCH8xiR1sBwE1P1qOb6AYtcp9WOdcy7jf35iblUwnpMW4lOQ4CJ1628Hq+GlIf2bnl
	 uyr9KnU84Nr/g7Z/LQKSptCA5ti32TFEFiKr4CEo=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
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
Subject: [PATCH V2 2/4] arm64/mm: Use pudp_get() for PUD accesses
Date: Tue, 22 Sep 2026 11:46:36 +0530
Message-ID: <20260922061638.3967467-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922061638.3967467-1-anshuman.khandual@arm.com>
References: <20260922061638.3967467-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8D475C0003
X-Stat-Signature: 851h1k3bzouutrpfjmg8j4ddkf8ie415
X-HE-Tag: 1790057812-932564
X-HE-Meta: U2FsdGVkX1+4OWs8zxkpxhjAopQ7as7zKawAhcvb5AylTyni+IfBhIshg/T9cRQ2mAD7PojLvnQpTfbFA96wXtnh6G7fsjGL+jHnkOmDE2vizfZbGdX92/Nu7lhqPAhqxTJyLTtY8Vh0iet4EGeseQhc3uowoNSLJTWuzM57PeXEJN7hu4wnbIRkAR+g1EkvHymdacRfhZYsZz8GKzToVg3gYwPe8JzxVA2EMh+tt7Rxxp3EzLlykWY3mj8c2MzPclx0ZvUh74cXLFQkSbeYcmZAtuZ554SwoxvD2dB19qjdLd4M0MRxIoXtbPB5AfmjFwa3RlY+ZYr6yqFV0bp5z18C6dOhlmxCK+4eeTVpK4L1wO8FyFtZJW3O1yN5NG8Sr391pOAU3s/ipdNlZAxj1lrN/vBUhcbg9Az/x8go9VZrjjS3Crn4a2dSixLTMBv0kNrgFa+AaWC8kwDuyzUu3gTyF1C72JGUYsdgEGnD3uE001rxPfuZOKEzN/Nj8sDU7e/GY+NVi0vqAuxDtfBT6lZ/JQ+ahecWZ2jSuTaeCqcbIV7Oa+TczpIY4QTdLbtAjipaVE6xs8vDfeV7Pg4M+JeSmQxX7b/weXfS3daVPMT/TeukKUJV/zV0NYcntvQmghP1q4BAf6RJLA2pcrGBra9Yh++BnMte+rhejkp0y8nNgryO+O0TOwP62anBAgQAZO8EXaRv2FfS714MZWCnY73dKWo9kdMg69YPepSg2RQCTWrENDL2C7bSF4TFw3bI5mAo7otKtDo8G+I+5EF6aT6sVxeq+d4LPuQMDGb9a+Y19AcWs/8T8onrNgQSfyZJGyrl9e+ycXJmRsVskASqs9MDUiPyVYFrzbdaxo4BOA4i2Ou87rpw8Wn7QuqR7AuiV1KosUWXPQXv4xi5t2eMW88LdfBJBisePb00s6CJFf+NzcRqZRttJ0zOmXDWaubfpHKy+4LegeV4kdnAQ1B
 PwNVOKnt
 RlW0qb0AC4/Li5lGxGk9y1/2NYc9A+u2sh7keK6uYmv2fpzNGwl7MupphiZEfeqGt85LfAuYkmk7Q99QHgN+zpwmDqwyGXYpbYlBgNAH+Jv40+JA5/hF3CtOyJanjZ9xZIYhVXHXNFj2y3qjXF+q5ebQ32CkreJUe8ATe8NuhvBbO+0kkBD2QDe2mSdihJ4RwMwY5DohOjyjTF8M/wpfMQaAz6fFNouEeqA7fUCGlQnK8uFKleKnUPNLM8BOlM+RqTfdQVPHZMFhn5qGhdHa3qiLsV8W7sW4xhHI6EuqtZzXIyC6A1+RoNxHf7qp7mh7je7DA7m2ruU9IglDmLNTIZdfktUSzenCaG9uR4hGNjBuBTc6OVtxXkzBL3hQhzicUBUHa9B+1WjSXdOPTdUaMUBTuNMHuinI41NzRUNOzvjUR8HcOfJHAvHQIevHN9yzkaF0oghYw6kvbxmZ0ZEA4IZbwc2r+PVCoHCGxc8R7OiQn1fs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
required. No functional change intended.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: kasan-dev@googlegroups.com
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
index b953ea0ba3ed..ae41946c54f2 100644
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
index 2757ee0c4300..435e2e14c070 100644
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
index 95621913679e..22efaee79293 100644
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
index 0ca07bd5ded9..07b2fa4de57f 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -407,7 +407,7 @@ bool kernel_page_present(struct page *page)
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


