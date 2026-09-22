Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 788C2C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 06:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716F56B00A9; Tue, 22 Sep 2026 02:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8106B00AA; Tue, 22 Sep 2026 02:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DE226B00AC; Tue, 22 Sep 2026 02:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B75C6B00A9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:16:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1E1B803CC
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:16:50 +0000 (UTC)
X-FDA: 85240389780.26.318CA29
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id BCB04A0004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:16:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZimIwZ5G;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790057809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iaWPybSJi+b7aH+ChC46PFisEK+Jg8r7NuMxKS6TBrs=;
	b=Fy40+on4Kx5Y5BZzQ4uPUdt1raPfp3U+SoxsiZswR+puGwgMV8S7MX7Vp67KDqBi1JZ8Xc
	PYPPIiQ8iMYAOILYwV1PP5CQVF1ukJdbeBoDEJmtnIr0vU0hxvhMKkNZHqlomAxV0bavD+
	zrP30Uxmxhruvl2CIomNJGEU34jMc3c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZimIwZ5G;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790057809;
	b=1Dbi2H0gQtrsqcbSIrzDA3wtUIBABwg0SRZEGhtEmi/icpBrkcyHQDUheREOsIsazZxYaJ
	Qa6k1tCJ08j2GEhFAI6MCswyRPCWJ2eLUdC0HcZ71Rd+SIIqeadfIJ5/didjlsKNv3/I/b
	I291AP5AEyJo7FaED5AoJjiDMOidz4o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 418041595;
	Mon, 21 Sep 2026 23:16:44 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F9353F632;
	Mon, 21 Sep 2026 23:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790057807; bh=pKNC4pJssJUy9F//HluyrY+c9OqIldQrDfXH15RXtSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZimIwZ5GXmjKnSTq+el2RiaDXGsmQviBAqWAjRnxJ9q788vA7UgWgY6+04Vlmqsjx
	 GNUqPDTPVkXJx9fxvEYYZVnFyT6WCL8UOSq6eKNwJ8hgKciIH8N+m+/1cM3q9Wj3On
	 LZu1MZXGRpUkmAaNqTnmVJDjwi2CjdWiIdYSA8fY=
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
	Mark Rtland <mark.rtland@arm.com>,
	linx-arm-kernel@lists.infradead.org,
	linx-kernel@vger.kernel.org,
	kasan-dev@googlegrops.com
Subject: [PATCH V2 1/4] arm64/mm: Use pmdp_get() for PMD accesses
Date: Tue, 22 Sep 2026 11:46:35 +0530
Message-ID: <20260922061638.3967467-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922061638.3967467-1-anshuman.khandual@arm.com>
References: <20260922061638.3967467-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: euq1ko8gb1xbq4g3ugddzq1qrspn3aib
X-Rspamd-Queue-Id: BCB04A0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1790057808-772384
X-HE-Meta: U2FsdGVkX1/EleSNw0IwbdnKyPA5rALHyGgVV+Ajze1S3cNIN/37Y+kJ9CGiSLgOR56SuyT9GbldM+8Dqp5DjnJRg1XKsYcv1nRlDzQDeygolUyV+XVjIg0XtlHflHxC+FI0NOOlk9rOzfxu488uKah3ZQfL4HodZEEEhyhs7DpG88WV4Bb2R4twkOUw1KO6BbP25JtklQc0Ss2sCHd5F8dq+oPfp2u5Y5o6XEMiYxrJojobop4p8av3q+3rh8k83qE4LldCRYGdv+8RWsWq/5lx1vMZ0D7hfWthOIokGVx48iR0+NglaY7DZZNaLR+HeZqz78v7evPoC5+/TbgTptG2hcrNUTFp85zs7g8FkN/YBl5JUbfGIlLoVbq80djaGRNjI8RFv8R6EseWtaF75rRypOkUD0v0v2f4cLnjSyDmzmQpnG/6KMiVwLzRK8xZJbazWHKzOohKFsEnudBd72JIuNTfDYZSQRHOAMd7OnJ4wR36eIBSYwsZe5sbllSDLnpFHP44XYM5FEiZ56ic7eiyedULvPVQwfqHnR+LaRttcF5TgGY9tMUSH4CN7wJN/7u0KgpIu1SQYgf7GIUsCBeF1qsDWx8TLRGKoXkXOp9rMgCl6LipFlEMiX6a0zo+dib2dJf6w/aGVnenq+ZPi3NLvJ4Yprkj5cWjJspfQOHVsFShBvW2tQpvrjoW1mwnDFkZsjX5V71H8y+HoSLPirtTduWjxkYuZfw4xw9FFWKiDlMuZZ+1x3gU86T5o25IISWTS0fjjopj3m9S4UmkaOPZ53WMxklbKe34VyIg/Vzkr5m8MxF8bilS8ldzsOjMcJaspc3YFeGJGpC8DOSlgjZjhFSr1LqbG0ePPo039DU3axDw5Z7PE3vjVJM2kdce/xATKxMso1rmYrP5H485v6PCmRtCsYHY97cVacFnkC/ucAqMQ72i785tcN6T4SsOGwk+z8Hh/BgX2vkmnWI
 Yc/N7bJq
 oJQlzU8udV7LIay9U95Cnji0iR2Gq5KWMr9EjHVSIrJF/6nxriwwsIzOP2TLCcL0B/D+FEgHx8axzjewyZSvaqjpzVl3ByL2ASCmmCO8DLkmqs8ndp8yJ5e2PKutCoqAzvc5E50oguG0psICx63RuYotM6/K0Qo2SBXaoXfmfqTvUOx5F4prGGAcggBAsgvMP7q1zA0FZTcvgZ8NryXxA0D0fZDrGajSB7ZYwg5cLx9mtRzsZY97I5OhpgeyVPUy+5HY+jtC43LWQR2eto5BykUIY06Dtp2D8ndiNAnBnR4eE9a5DFnurq1APkU2rjtY6krxKhd4uWSRiSRp+bUT+PqXof6vleDK2x7XzXc3ZQVxzlVF7Y30VKTHKj5Dhe94pK8Conr+OWYcZn+l6KtQVykM1Zu2Dp2mVPCV1cZ6DM/KcY8TSFMQsKGGHIHliLC/6iO7DIN6sly84RTLk5Vm2OoAf4RjW0fOcv/vwQQCXc4jSqfk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace READ_ONCE() with pmdp_get() for PMD accesses in preparation for
supporting both D64 and D128 translation table formats.

READ_ONCE() cannot currently be used for 128-bit page table entries on
arm64 because it does not provide the required 128-bit single-copy
atomicity, causing builds to fail for accesses wider than 64 bits.

Although LDP/STP provide the required atomicity when FEAT_LSE is
available (as required by FEAT_D128), extending READ_ONCE() to support
128-bit accesses is undesirable. READ_ONCE() is a general-purpose API,
so doing so could encourage other 128-bit users that would either fail
to build in configurations without D128 support or, if D128 becomes a
runtime option, silently permit tearing on systems without the required
hardware support.

Instead, standardize PMD accesses on the existing page-table helpers.
These can be overridden on arm64 to provide 128-bit single-copy
atomicity when required. No functional change intended.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rtland <mark.rtland@arm.com>
Cc: linx-arm-kernel@lists.infradead.org
Cc: linx-kernel@vger.kernel.org
Cc: kasan-dev@googlegrops.com
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h |  3 ++-
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/fixmap.c           |  2 +-
 arch/arm64/mm/hugetlbpage.c      |  2 +-
 arch/arm64/mm/kasan_init.c       |  4 ++--
 arch/arm64/mm/mmu.c              | 22 +++++++++++-----------
 arch/arm64/mm/pageattr.c         |  2 +-
 arch/arm64/mm/trans_pgd.c        |  2 +-
 8 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 763c5a411d64..b953ea0ba3ed 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -811,7 +811,8 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 }
 
 /* Find an entry in the third-level page table. */
-#define pte_offset_phys(dir,addr)	(pmd_page_paddr(READ_ONCE(*(dir))) + pte_index(addr) * sizeof(pte_t))
+#define pte_offset_phys(dir, addr)	(pmd_page_paddr(pmdp_get(dir)) + \
+					 pte_index(addr) * sizeof(pte_t))
 
 #define pte_set_fixmap(addr)		((pte_t *)set_fixmap_offset(FIX_PTE, addr))
 #define pte_set_fixmap_offset(pmd, addr)	pte_set_fixmap(pte_offset_phys(pmd, addr))
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 2cecf6ba6df7..2757ee0c4300 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -188,7 +188,7 @@ static void show_pte(unsigned long addr)
 			break;
 
 		pmdp = pmd_offset_lockless(pudp, pud, addr);
-		pmd = READ_ONCE(*pmdp);
+		pmd = pmdp_get(pmdp);
 		ptval_to_str(pxd_str, pmd_val(pmd));
 		pr_cont(", pmd=%s", pxd_str);
 		if (pmd_none(pmd) || pmd_bad(pmd))
diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index f66a0016dd02..3cdac8021d4f 100644
--- a/arch/arm64/mm/fixmap.c
+++ b/arch/arm64/mm/fixmap.c
@@ -42,7 +42,7 @@ static inline pte_t *fixmap_pte(unsigned long addr)
 
 static void __init early_fixmap_init_pte(pmd_t *pmdp, unsigned long addr)
 {
-	pmd_t pmd = READ_ONCE(*pmdp);
+	pmd_t pmd = pmdp_get(pmdp);
 	pte_t *ptep;
 
 	if (pmd_none(pmd)) {
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 8e799c1fe0aa..cdaa4500faf9 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -304,7 +304,7 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
 		addr &= CONT_PMD_MASK;
 
 	pmdp = pmd_offset(pudp, addr);
-	pmd = READ_ONCE(*pmdp);
+	pmd = pmdp_get(pmdp);
 	if (!(sz == PMD_SIZE || sz == CONT_PMD_SIZE) &&
 	    pmd_none(pmd))
 		return NULL;
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index 45fbdce684c8..7ca833c5de5e 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -62,7 +62,7 @@ static phys_addr_t __init kasan_alloc_raw_page(int node)
 static pte_t *__init kasan_pte_offset(pmd_t *pmdp, unsigned long addr, int node,
 				      bool early)
 {
-	if (pmd_none(READ_ONCE(*pmdp))) {
+	if (pmd_none(pmdp_get(pmdp))) {
 		phys_addr_t pte_phys = early ?
 				__pa_symbol(kasan_early_shadow_pte)
 					: kasan_alloc_zeroed_page(node);
@@ -138,7 +138,7 @@ static void __init kasan_pmd_populate(pud_t *pudp, unsigned long addr,
 	do {
 		next = pmd_addr_end(addr, end);
 		kasan_pte_populate(pmdp, addr, next, node, early);
-	} while (pmdp++, addr = next, addr != end && pmd_none(READ_ONCE(*pmdp)));
+	} while (pmdp++, addr = next, addr != end && pmd_none(pmdp_get(pmdp)));
 }
 
 static void __init kasan_pud_populate(p4d_t *p4dp, unsigned long addr,
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index e589fb00d1e3..95621913679e 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -200,7 +200,7 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 			       int flags)
 {
 	unsigned long next;
-	pmd_t pmd = READ_ONCE(*pmdp);
+	pmd_t pmd = pmdp_get(pmdp);
 	pte_t *ptep;
 
 	BUG_ON(pmd_leaf(pmd));
@@ -257,7 +257,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 	unsigned long next;
 
 	do {
-		pmd_t old_pmd = READ_ONCE(*pmdp);
+		pmd_t old_pmd = pmdp_get(pmdp);
 
 		next = pmd_addr_end(addr, end);
 
@@ -272,7 +272,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			 * only allow updates to the permission attributes.
 			 */
 			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
-						      READ_ONCE(pmd_val(*pmdp))));
+						      pmd_val(pmdp_get(pmdp))));
 		} else {
 			int ret;
 
@@ -282,7 +282,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 				return ret;
 
 			VM_WARN_ON_ONCE(pmd_val(old_pmd) != 0 &&
-					pmd_val(old_pmd) != READ_ONCE(pmd_val(*pmdp)));
+					pmd_val(old_pmd) != pmd_val(pmdp_get(pmdp)));
 		}
 		phys += next - addr;
 	} while (pmdp++, addr = next, addr != end);
@@ -293,7 +293,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 static bool pmd_range_has_valid_noncont(pmd_t *pmdp)
 {
 	for (int i = 0; i < CONT_PMDS; i++) {
-		pte_t pte = pmd_pte(READ_ONCE(pmdp[i]));
+		pte_t pte = pmd_pte(pmdp_get(pmdp + i));
 
 		if (pte_valid(pte) && !pte_cont(pte))
 			return true;
@@ -1553,7 +1553,7 @@ static void unmap_hotplug_pmd_range(pud_t *pudp, unsigned long addr,
 	do {
 		next = pmd_addr_end(addr, end);
 		pmdp = pmd_offset(pudp, addr);
-		pmd = READ_ONCE(*pmdp);
+		pmd = pmdp_get(pmdp);
 		if (pmd_none(pmd))
 			continue;
 
@@ -1708,7 +1708,7 @@ static void free_empty_pmd_table(pud_t *pudp, unsigned long addr,
 	do {
 		next = pmd_addr_end(addr, end);
 		pmdp = pmd_offset(pudp, addr);
-		pmd = READ_ONCE(*pmdp);
+		pmd = pmdp_get(pmdp);
 		if (pmd_none(pmd))
 			continue;
 
@@ -1729,7 +1729,7 @@ static void free_empty_pmd_table(pud_t *pudp, unsigned long addr,
 	 */
 	pmdp = pmd_offset(pudp, 0UL);
 	for (i = 0; i < PTRS_PER_PMD; i++) {
-		if (!pmd_none(READ_ONCE(pmdp[i])))
+		if (!pmd_none(pmdp_get(pmdp + i)))
 			return;
 	}
 
@@ -1881,7 +1881,7 @@ int pmd_set_huge(pmd_t *pmdp, phys_addr_t phys, pgprot_t prot)
 	pmd_t new_pmd = pfn_pmd(__phys_to_pfn(phys), mk_pmd_sect_prot(prot));
 
 	/* Only allow permission changes for now */
-	if (!pgattr_change_is_safe(READ_ONCE(pmd_val(*pmdp)),
+	if (!pgattr_change_is_safe(pmd_val(pmdp_get(pmdp)),
 				   pmd_val(new_pmd)))
 		return 0;
 
@@ -1906,7 +1906,7 @@ int pud_clear_huge(pud_t *pudp)
 
 int pmd_clear_huge(pmd_t *pmdp)
 {
-	if (!pmd_leaf(READ_ONCE(*pmdp)))
+	if (!pmd_leaf(pmdp_get(pmdp)))
 		return 0;
 	pmd_clear(pmdp);
 	return 1;
@@ -1917,7 +1917,7 @@ int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
 	pte_t *table;
 	pmd_t pmd;
 
-	pmd = READ_ONCE(*pmdp);
+	pmd = pmdp_get(pmdp);
 
 	if (!pmd_table(pmd)) {
 		VM_WARN_ON(1);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index bbe98ac9ad8c..0ca07bd5ded9 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -414,7 +414,7 @@ bool kernel_page_present(struct page *page)
 		return pud_valid(pud);
 
 	pmdp = pmd_offset(pudp, addr);
-	pmd = READ_ONCE(*pmdp);
+	pmd = pmdp_get(pmdp);
 	if (pmd_none(pmd))
 		return false;
 	if (pmd_leaf(pmd))
diff --git a/arch/arm64/mm/trans_pgd.c b/arch/arm64/mm/trans_pgd.c
index cca9706a875c..b27b2d2c20c3 100644
--- a/arch/arm64/mm/trans_pgd.c
+++ b/arch/arm64/mm/trans_pgd.c
@@ -74,7 +74,7 @@ static int copy_pmd(struct trans_pgd_info *info, pud_t *dst_pudp,
 
 	src_pmdp = pmd_offset(src_pudp, start);
 	do {
-		pmd_t pmd = READ_ONCE(*src_pmdp);
+		pmd_t pmd = pmdp_get(src_pmdp);
 
 		next = pmd_addr_end(addr, end);
 		if (pmd_none(pmd))
-- 
2.43.0


