Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F232C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 06:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468866B00AD; Thu,  3 Sep 2026 02:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F2376B00AE; Thu,  3 Sep 2026 02:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32EDC6B00AF; Thu,  3 Sep 2026 02:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 086746B00AD
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:07:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F085C045A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:07:08 +0000 (UTC)
X-FDA: 85171418136.11.0C04038
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 983E5C0003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:07:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=siJNcOZN;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788415627;
	b=CL5T4MWcXLJ39Ll+z8lzgtXxKhsa4rGOrnai6rBGhokgqBi3XKrwWsMNXPHvEGYWscAbtA
	onpQ6BQzg9OVeNq2Tp0BKpYYR6SnXiNduelvs+Ee0VCe2MzCbHSr8lp9k38a42c2zBydvw
	5+rTnNBnnFcEBpV9gR7wGtJvyO9Hs64=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=siJNcOZN;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788415627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PeivBWUmvyhnelr5V5fpNCHXzHisPt7k+l0flEWUYcE=;
	b=AjzO7H18WzrEgp1fv87O9eTkKJlVrWAbVouCjWMQQT0CjgbtoGVfwMB9qXT4RTdg9nkX8+
	6K86RSi1DtpacoCJgWJa4PyJtPmODuhcBsoTWdokIzk7wRROegMovutC46vDb1iJb9UA5+
	ru259MBUjJKPjS3eBwvOFrwP+Sy4gDQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3DEF1682;
	Wed,  2 Sep 2026 23:07:01 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9D7F3F673;
	Wed,  2 Sep 2026 23:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788415625; bh=e0K8xOtqBeGx4lAEQyBohm7XHFu4Den9c9wf7atdv8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=siJNcOZNMhQYFwn/xphmLnRr8Xbq+prunkGCK+9yZW/Crwt4osUkCLna/m6t8JqlT
	 MZrksgATbTjBPRQS62ugKWFHMZCimj73MFiOYoQG5w/yydGGP8nYg45FMkjY5BN4FR
	 N2NG3EtK8EMRjqTgjBKsniUGFlNxhAyvwFg53Fao=
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
Subject: [PATCH 1/4] arm64/mm: Convert READ_ONCE() as pmdp_get() while accessing PMD
Date: Thu,  3 Sep 2026 11:36:54 +0530
Message-ID: <20260903060657.2717457-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260903060657.2717457-1-anshuman.khandual@arm.com>
References: <20260903060657.2717457-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 983E5C0003
X-Stat-Signature: f41f1ccmsxqswaccj84ksdsji1obmb9o
X-HE-Tag: 1788415626-21280
X-HE-Meta: U2FsdGVkX19SwcKLdu2hb1JAlhm3XNJqju9iivj2aiYsspCYVDIcwgJnghtXyU37JlXWbv1/I+rIRsqU1kZolXdPj9Xu2ZA89Ip578fDgfRp1VlMGsy+XpUOKe63KPxebmCbGsgnH7m1YWd2h8yK3WFTlUVjEf6m6nxAHl016e+CPn6nqleyf8UBjjqfNtcungirntR0f63bX3+Px0g4eEP9BHpB+kUUUhnuafy5KifelBBiuMgtA34qf9i0Ba/T2VzIPqXMRQqW+EoiKZP6KA9iaINFeMJkZ7E06q4BBYlAha0xEE2NbjVQjlZaTG5i1UeAygyAjKC/IjJ3YYXWmm4dm3a9PEN3asoB9ySyibNKAHAyv+oGozTB5SrU8Nm/G/Ox0NHN+KgLbRXoHsUZCP7SkUlOhzom8bQsfovptNSj7DcopW+20fqybSUMR4wi4Rb73ljhXJKEINuV0NWmp4PbLrr83/NXYYw4Mzal7PxaU352TPxsqDmVZYlGYB02NCAFVGStoAPK86iVTBw4u/+/TsUNrQgxp6AGbDRgsXQjtjDFV0YcAASm6e7r7VaS2M9jfBda7yzAxpMFSwEtizKLNSPwy9q1hBkhlwZCu1IgZcQJFZb8CFAtueD3gS/jNaqPitGZ0RNqsAEYsgzW+bSE2hRh9slLPIZea+v4womFSPL6MEtwERev25yOzEucAxbX/AJTxOB2vtgwLRjdCY2/ZirKbKCl9+wY69zIM8TUOfMupgQmYovvntmJFj/GQKFLweS65TIJtboliGxzJtPi4jX14ozWFU36DIZUPy1XVwIm97KlAl+jV/9qMpapWZzA+P9JCkBHj0G8Bomst5/vraP10dFWOMALeZ/0DO6WXqRk4oJ0pt+4LPGKv9eXFwL+E2WD6pOB9MAtGEQpIia6Bo4tULch0H6C72vWj7zVVPaqoU9ZlHnz2AMrrF/QJ4/ucwGT81L41scZo/+
 B4D2N7qr
 HR4z57JbyaHVcXR1M3SYb9L6BVjIV+Uw7yjCMKa6DH3ccrOt9YXrlbdO/n/v7trkmLEymzLVN4nPgT5/dVlYA2OBqjm02C7l8bB6zI8HMimzZ509264muANt45WYbdUYuOJTY9kPKCYyIAXKsQB1Ow4AcutMIT99MDTw3BVxif2Jd0z/daN2KZantyrFUWPvQGI30u0XdzUho8lfQzaNCV3hU5XnASjpQIxdR6eTQmPFnFEqiCqf3xUC//giznhG+DaJpUnxqt+J9hEX6D1cZ2N/+7dntKxX+l4ePpOlMJjGkqVOFPYJ7LFGg0u7PNGUpF65hOiWIx6lDw4T7FDLhLwhn72Bt3UWWi3Nd3HTa0UuxBGrAgrMRQC+KS5zdDloD5Ge7mIkzLCjmVzRN0uL3t+jtKN3ScVJgOclmUxHkEC6Xl2Pwh2BY7lZ9O1mro7HNdqZSnPmZTAyGHGWn40nMcIFRgZjOV/dKlLQsUuiG1cCn8PU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert all READ_ONCE() based PMD accesses as pmdp_get() instead which will
support both D64 and D128 translation regime going forward. That is because
READ_ONCE() would need 128 bit single copy atomic guarantees, while reading
128 bit page table entries which is currently not supported on arm64. Build
fails for READ_ONCE() while accessing beyond 64 bits.

Load Pair/Store Pair (ldp/stp) are only single copy atomic if FEAT_LSE1
is supported (which is required when FEAT_D128 is supported). Currently 128
bit pgtables is a compile time decision - so we could have chosen to extend
READ_ONCE()/WRITE_ONCE() to allow 128 bit for this configuration. But then
it's a general purpose API and we were concerned that other users might
eventually creep in that expect 128 and then fail to compile in the other
configs.

But worse, we are considering eventually making D128 a boot time option, at
which point we'd have to make READ_ONCE() always allow 128 bit at compile
time but then it might silently tear at runtime.

So our preference is to standardize on these existing helpers, which we can
override in arm64 to give the 128 bit single copy guarantee when required.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rtland <mark.rtland@arm.com>
Cc: linx-arm-kernel@lists.infradead.org
Cc: linx-kernel@vger.kernel.org
Cc: kasan-dev@googlegrops.com
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
index 61fbfab3e06e..51f55498d43d 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -805,7 +805,8 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 }
 
 /* Find an entry in the third-level page table. */
-#define pte_offset_phys(dir,addr)	(pmd_page_paddr(READ_ONCE(*(dir))) + pte_index(addr) * sizeof(pte_t))
+#define pte_offset_phys(dir, addr)	(pmd_page_paddr(pmdp_get(dir)) + \
+					 pte_index(addr) * sizeof(pte_t))
 
 #define pte_set_fixmap(addr)		((pte_t *)set_fixmap_offset(FIX_PTE, addr))
 #define pte_set_fixmap_offset(pmd, addr)	pte_set_fixmap(pte_offset_phys(pmd, addr))
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index c75bab3c2f4b..cb25cb130e83 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -188,7 +188,7 @@ static void show_pte(unsigned long addr)
 			break;
 
 		pmdp = pmd_offset(pudp, addr);
-		pmd = READ_ONCE(*pmdp);
+		pmd = pmdp_get(pmdp);
 		ptval_to_str(pmd_str, pmd_val(pmd));
 		pr_cont(", pmd=%s", pmd_str);
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
index b5de4095d650..32daaa547d09 100644
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


