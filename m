Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 395BBCD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09B56B0092; Wed, 13 May 2026 00:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0F46B0093; Wed, 13 May 2026 00:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91E186B0095; Wed, 13 May 2026 00:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8231F6B0092
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:46:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F0481C05E0
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:46:36 +0000 (UTC)
X-FDA: 84761160792.16.51F38BF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2806AC0007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:46:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rpSYCVJk;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778647594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69/TV5C0bE7swjnMa976sMHJX+yxPUaCtZOsaj7800s=;
	b=CPFRC7RPakj7l16tghNwclsfgTpbUJwbrqQftAtx7J/ed0rXL9cpg7oFrAuBtu47U9EMXb
	hPAjuJZ5IJ6xp9nxFbCGZyKfuCHVpifj7EiWRbA6Av2TKgCKa7xq7QcqHNDnVsMEJ74Ibh
	1qDRmhxbNvo8ITgEjC1tfWgDDj/441c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778647594; a=rsa-sha256;
	cv=none;
	b=Tq7/AqDnSgxh9JkZOC53hbccnm56cZs/wBkRhHN3rgvTRIPO6xeQikgyhbkJdV9qMh16dD
	J74Z1ZXbQyW6J2oqE/sa8RYokw8b7Gkr97U19/prLQ5vespXG/q0DhI6/L0TA28OL67m5W
	sk+uYZlnPeo8nD96zZHNNZ5jweWTF/E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rpSYCVJk;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB311153B;
	Tue, 12 May 2026 21:46:27 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BF5633F7B4;
	Tue, 12 May 2026 21:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778647593; bh=58UezpxqMICj0tqLQQJ4WXN24ANPrVfVWi9qmhrMAmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpSYCVJk7S9em1ayLWeDsoJW4G53wQjcP+A0UFqLsms/IAeqbxI5x1jFNXuX2vLPN
	 SX0511cpyaWZ86SuJcWYS8lwxel1oiiYIlKg0Nfa5owoLBG9sP3W6QRcPtaBnfN5Wr
	 am97JKLDucTKI3ph0X1sPbrs35XLci6vcLIQg27k=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Mark Rtland <mark.rtland@arm.com>,
	linx-arm-kernel@lists.infradead.org,
	linx-kernel@vger.kernel.org,
	kasan-dev@googlegrops.com
Subject: [RFC V2 03/14] arm64/mm: Convert READ_ONCE() as pmdp_get() while accessing PMD
Date: Wed, 13 May 2026 10:15:36 +0530
Message-ID: <20260513044547.4128549-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513044547.4128549-1-anshuman.khandual@arm.com>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2806AC0007
X-Stat-Signature: ajowrz5qw4mbcgjhpsoee6t3jaoaux61
X-Rspam-User: 
X-HE-Tag: 1778647593-815762
X-HE-Meta: U2FsdGVkX1/IJFAoRUZ240Jb1NdDCd1DvGDcOZ3iNyF7BA/+ssOxYFrC/EPAWN0beYx6BlAL/bwHZ5fbxcFoCouxcVkmLimC+lbh8do8JNNwgtTuW8CMwaCbDJafeuQE/iPhKF8RutQ+5J0+uK+BPsZAI0sWK5M/0IHGVhRFo+St7lwIFTE+lQkjZ2v9qOCscHRmJOcP64mqZvd9+i+TV9awk1mGgmj34qcCJNqGS4nli8x1XH2vnersBV//uX9HaETKVCpmkDRNYsDQGjPlfh552v5s6M37+5y+8w8tFY2C5FLgI3n5ZQzDEvBO9r3ZemkF3swNLyu5o0g28di5Y08a6/iln5ha7HIg9wK2xLedkXqgaun+IQxZsIaBC/6GwCWPN1roW99sl1I75Jz6Znk8vxFiNPHp0Odermy2YG5f3Gn+WV6cCrKbH7Y0uo7uh+3SlEpSoFvKSb0VkP5KnFYVoO7XsfgRjr4RgozJtrISmPc6Ss00lHaqesQvBQ62wgBnGW4IN6CqUiFibTG0rIy57J8bJkxG/Dkdi2JIYKgJhOR2lTdTLQl9XyJPyvpH9J4M2chk8Lrp0spWE5wlcfP7yM+wON2apgjktaZGRRmsb6WlR9xCXfCty2o6ODQr8Cm9QG6X9/plMoQl6Vx5Ts3g2lwumwDoVUu7z9fyNTfzAgRa98VNDDgUNdP8lotcakhU0hhBrvxP+nFqyWw+JA2jIPo0oXGpFOq6rt7XEv57BkFb+r7HfTOKqjvm6vZQC9s4Z0a1JC7EQW16/i5qR4pPY8xSQo3kNhGPZ+YMCp80RcfhlcoNTc8LcdCAIC1221lOjzKOb5yEFQBmZYwQuNvyiA92vMihijJJmRZ2cx4L64eBCzcuWU4dsuCmMFxAFpnasrwfycMlBDJlMJKmUs1oEc2V4oGzuMPIjqdJ1C30JEkTN/oAmsUoxv8FEllcbIGOAY2XN7mLmBkSMqh
 q0ssWfez
 g0EcYffkLXox8GYjRtq/PpNPNWzYHleqhZfX9BQ6QV0SAodQS/2lPOboa80HvG+hCKUp8HG6I5NcrofsUWIuG2EyCBm6tQOFfueo50u1rj9EkJnqaMLI3PdYd6NLutKQaYoeIdFpjU+x4VvRrl0eFz13ji+8LoGVSWsEkXzr8HrSkC6XbJasc680GEOylaFnYpfDQHSQgo/SUsJSpWOg3/C6jQWMCpWHTdigSSG2k4QwhqsTOUfKh1KqcCUmhZJ7UdQIMdZXf342J8fUIR2SX6HTV389L6mcfZ435II3MPtNZiSLb5h7aWmP8qd6lVXIdfg0AKpsvN6KXUadPTi0VxfjDPd4dd5zFzBk77EgDmcBiVxlB0r/rvCja3ZdH/SVq6FKDXRzglrYol8upWTg87xnCm/zwUMEWmgwIc7JHVzYlQMd8ppFjyXcsNw==
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
is supported (which is required when FEAT_D129 is supported). Currently 128
bit pgtables is a compile time decision - so we cold have chosen to extend
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
Changes in RFC V2

- Moved back helpers back from arch/arm64/mm/mmu.c into the header

 arch/arm64/include/asm/pgtable.h |  3 ++-
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/fixmap.c           |  2 +-
 arch/arm64/mm/hugetlbpage.c      |  2 +-
 arch/arm64/mm/kasan_init.c       |  4 ++--
 arch/arm64/mm/mmu.c              | 23 ++++++++++++-----------
 arch/arm64/mm/pageattr.c         |  2 +-
 arch/arm64/mm/trans_pgd.c        |  2 +-
 8 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4dfa42b7d053..2100ead01750 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -852,7 +852,8 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 }
 
 /* Find an entry in the third-level page table. */
-#define pte_offset_phys(dir,addr)	(pmd_page_paddr(READ_ONCE(*(dir))) + pte_index(addr) * sizeof(pte_t))
+#define pte_offset_phys(dir, addr)	(pmd_page_paddr(pmdp_get(dir)) + \
+					 pte_index(addr) * sizeof(pte_t))
 
 #define pte_set_fixmap(addr)		((pte_t *)set_fixmap_offset(FIX_PTE, addr))
 #define pte_set_fixmap_offset(pmd, addr)	pte_set_fixmap(pte_offset_phys(pmd, addr))
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 0f3c5c7ca054..330eb314d956 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -178,7 +178,7 @@ static void show_pte(unsigned long addr)
 			break;
 
 		pmdp = pmd_offset(pudp, addr);
-		pmd = READ_ONCE(*pmdp);
+		pmd = pmdp_get(pmdp);
 		pr_cont(", pmd=%016llx", pmd_val(pmd));
 		if (pmd_none(pmd) || pmd_bad(pmd))
 			break;
diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index c5c5425791da..7a4bbcb39094 100644
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
index 30772a909aea..ffaa65ff55b4 100644
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
index abeb81bf6ebd..709e8ad15603 100644
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
index dd85e093ffdb..c6300a1dc36a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -194,7 +194,7 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 			       int flags)
 {
 	unsigned long next;
-	pmd_t pmd = READ_ONCE(*pmdp);
+	pmd_t pmd = pmdp_get(pmdp);
 	pte_t *ptep;
 
 	BUG_ON(pmd_leaf(pmd));
@@ -250,7 +250,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 	unsigned long next;
 
 	do {
-		pmd_t old_pmd = READ_ONCE(*pmdp);
+		pmd_t old_pmd = pmdp_get(pmdp);
 
 		next = pmd_addr_end(addr, end);
 
@@ -264,7 +264,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			 * only allow updates to the permission attributes.
 			 */
 			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
-						      READ_ONCE(pmd_val(*pmdp))));
+						      pmd_val(pmdp_get(pmdp))));
 		} else {
 			int ret;
 
@@ -274,7 +274,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 				return ret;
 
 			BUG_ON(pmd_val(old_pmd) != 0 &&
-			       pmd_val(old_pmd) != READ_ONCE(pmd_val(*pmdp)));
+			       pmd_val(old_pmd) != pmd_val(pmdp_get(pmdp)));
 		}
 		phys += next - addr;
 	} while (pmdp++, addr = next, addr != end);
@@ -1498,7 +1498,7 @@ static void unmap_hotplug_pmd_range(pud_t *pudp, unsigned long addr,
 	do {
 		next = pmd_addr_end(addr, end);
 		pmdp = pmd_offset(pudp, addr);
-		pmd = READ_ONCE(*pmdp);
+		pmd = pmdp_get(pmdp);
 		if (pmd_none(pmd))
 			continue;
 
@@ -1646,7 +1646,7 @@ static void free_empty_pmd_table(pud_t *pudp, unsigned long addr,
 	do {
 		next = pmd_addr_end(addr, end);
 		pmdp = pmd_offset(pudp, addr);
-		pmd = READ_ONCE(*pmdp);
+		pmd = pmdp_get(pmdp);
 		if (pmd_none(pmd))
 			continue;
 
@@ -1667,7 +1667,7 @@ static void free_empty_pmd_table(pud_t *pudp, unsigned long addr,
 	 */
 	pmdp = pmd_offset(pudp, 0UL);
 	for (i = 0; i < PTRS_PER_PMD; i++) {
-		if (!pmd_none(READ_ONCE(pmdp[i])))
+		if (!pmd_none(pmdp_get(pmdp + i)))
 			return;
 	}
 
@@ -1786,7 +1786,7 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 {
 	vmemmap_verify((pte_t *)pmdp, node, addr, next);
 
-	return pmd_leaf(READ_ONCE(*pmdp));
+	return pmd_leaf(pmdp_get(pmdp));
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
@@ -1833,7 +1833,7 @@ int pmd_set_huge(pmd_t *pmdp, phys_addr_t phys, pgprot_t prot)
 	pmd_t new_pmd = pfn_pmd(__phys_to_pfn(phys), mk_pmd_sect_prot(prot));
 
 	/* Only allow permission changes for now */
-	if (!pgattr_change_is_safe(READ_ONCE(pmd_val(*pmdp)),
+	if (!pgattr_change_is_safe(pmd_val(pmdp_get(pmdp)),
 				   pmd_val(new_pmd)))
 		return 0;
 
@@ -1858,7 +1858,7 @@ int pud_clear_huge(pud_t *pudp)
 
 int pmd_clear_huge(pmd_t *pmdp)
 {
-	if (!pmd_leaf(READ_ONCE(*pmdp)))
+	if (!pmd_leaf(pmdp_get(pmdp)))
 		return 0;
 	pmd_clear(pmdp);
 	return 1;
@@ -1870,7 +1870,7 @@ static int __pmd_free_pte_page(pmd_t *pmdp, unsigned long addr,
 	pte_t *table;
 	pmd_t pmd;
 
-	pmd = READ_ONCE(*pmdp);
+	pmd = pmdp_get(pmdp);
 
 	if (!pmd_table(pmd)) {
 		VM_WARN_ON(1);
@@ -2376,4 +2376,5 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 
 	return 0;
 }
+
 #endif
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index ce035e1b4eaf..c0d7404c687a 100644
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


