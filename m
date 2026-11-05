Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CBA6606A332
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UaGdclpy
Received: by kanga.kvack.org (Postfix)
	id 375406B05B1; Wed,  4 Nov 2026 23:34:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34CA66B05B2; Wed,  4 Nov 2026 23:34:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213ED6B05B3; Wed,  4 Nov 2026 23:34:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0FEB6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:34:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1118E1A0957
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:34:16 +0000 (UTC)
X-FDA: 85399798512.06.ACE6881
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0FED240007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:34:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UaGdclpy;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793853254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vyS6xSlDbYOGiiXh5xmPZrNdNpNKTJvlE/qJrSnWFhs=;
	b=75SlUljENoIc9MvASzFUUCbjU2z27KE1rAhhlZOuHX8h1py34KPEPjpcYFuT4kGR25vYXx
	y7rCBTg+iBQxTn7q4Dt5Ssj1E997yjEtwWeGksSXUZhti/NCJ9GSYjd0waobD8tNVAlysK
	6sAx+NkfXGT46SkR0V3gZApFBbi1Z8I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UaGdclpy;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793853254;
	b=xO3eFQUY0OMmLe5be3rTY5gn5+hZvNCl6K/eSr9Rc+aTFb1W4H/bsgfTqlDCujWlNgqfZe
	8FRCPl+fuHyQf7yEJG0RXXvNDsNsJEvMSqaVa8h0msBjqv89u7wW8PbaGh+NfdAbMHstvP
	0e3cmESPyIOYXzZeVQtnrz96swRaILg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB67B1A25;
	Wed,  4 Nov 2026 20:34:09 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2CF4B3F673;
	Wed,  4 Nov 2026 20:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793853252; bh=+kCnaaxwWclGrlw3AQYUpKZAAwQWc5N/YC7deD1gZDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UaGdclpyPlZdMhGQA8Bhz6x7rI0yMD9uVux8yk+PxVFsVJQqpfn5KNMUL32yZWpAM
	 z1vVgiFqf0IaJoiMDBX7rxlBpG5oNfbIFNYGzlAx2JJIeqXEFodL5KH7ghZ+SwucFd
	 3QN3DBSrQNWQ1xukhbMDu0icrksv2DZdejetDzrw=
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
Subject: [PATCH V4 1/4] arm64/mm: Use pmdp_get() for PMD accesses
Date: Thu,  5 Nov 2026 10:04:00 +0530
Message-ID: <20261105043403.3326445-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105043403.3326445-1-anshuman.khandual@arm.com>
References: <20261105043403.3326445-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8pw8p5pkjfee5nfbhu5j6u513epz6xpq
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0FED240007
X-HE-Tag: 1793853253-96373
X-HE-Meta: U2FsdGVkX1+MyaVPP2Qb5L5Yg2wR9wR7M/FT5dB98euVV2sQ39mmFGRViYC/JmX2j7+xEk2t2bjNjoIiwzMDdN9//1xf2djX52m0paIZnrAe5Ojans63VvljVFXOqD9f6NETCchuHudvUZuBhE1EeYyDv6+RCgaZcRnjDQ0Z6jfn7U9+vs0JMHVEYjIPvjed2A9HHN9Z/h2Sk4OfD74Iuf2l+w2tvHRpnVn84jSxIDMXXCSbtCM5ydh9aaJp6PbgpFbUyaQ/hhZ5/zv9bw9oKFOLyX3F2amK/7WnTDCTYvdDlM/c346786LPhMNURo2NxYb7XATjRhH8m2sfoOPU0xP0APiXnUEB6JIlq1t61xe9LQwKHHn+wx6IhbhkcQ32FQBxROp4bjnUlOT/AWjWSqAlcRx62agXQIE3PXAI52QTv5VHQxsuKFewFmr6XW9o3YCO/s8t7NkB+0gQlWSUywZ5M2itioXMStie2pjIzruEAzKRiKKDIZo6RfGUCfIfmijZr7DsjJBYkeswL4bFsCX48ta0aeMd/OBxFV7NuU+YjUtsNJN/6s0o/yoSrhLmqpqx62Xn4+h10gbMBRFb/wgDqwUjKCmIPzQjfEJ0B1K/7xvY9exma37epWEsjlWS8jp4/oILnYTzOD7tqaaIXdAW4rJPlmy27OACTHHetgk80I2TDsmzoZa0MDBdeGE0PfUQogdBFUWzi99DnY7UjeFTwvHyhNuGHW6SDKbK4oLyruOP0MmYabWc7XRMMMwTSiYF/G9qdAyUMps2Ytx+dn3+J/ns56uFt2uKNHHjSHN0j3/AYyZbnJCnzOwUEP8rqJWyjAjlSxjbo7jnO8QkOpND3nYl5TMujUZU/D50Pxp0FuyBlTxgvPI2b4M2i9jM++x73Q+zjQ6gpolE9AzHE1aI3mllGYMxwHgd8n/mF6zURW1WEUeuAUF0d7hnXTtkbvAsvl7vOAFlQ3dfvy2
 7HpeXO0h
 i0puT7AjIIrLhWq3CLICwl4b5jg4sftp7OtGTWmwUxVovwkHOaFgN4cyykI0s6bmgWNpqn+ZqdWjqW22BnuOy2BhVIIENsrcAJwP8vjMUKtD/McO3e5Z7m8lRyNXuHrUU1yF1ukODEmlRAiDT5q2BjFlNJqiipUAnIqbpgGM5reveMeAKX6Myqs35vGmjGqSl9DVcP1oAfit711kciyNrNjUk8dCE6jVPC08JiQlSk9mLgBqtZSzmAPgVHu/V4gdty/E/cFZF+ZxXoO5QGEOCxxzV2SuVDYOfv003E4dd23Vdl/Fse3F8uhchbEImqOGCdwj3QLQqKvlrPh8dWxomlcre3MYfn5GfvRFHNdFSfv/b7YXbIXdCn+aL1SJbipup9rwfnlM7MILdAgPYKzlvt1lcBIFR8i4X6MR2r8OHt5eGf0/9VT0M/pZzubwfJVYoCOGLI42x3mVHapsVmFfgctB19GavZ5hutbMyJKm/OC/dsYI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
atomicity when required.

READ_ONCE() instance in pmdp_test_and_clear_young() could not be converted
into pmpd_get() because of cyclic dependency between <linux/pgtable.h> and
<asm/pgtable.h>. Move the function inside <arch/arm64/mm/mmu.c> instead to
workaround the problem.

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
Changes in V4:

- Dropped pmdp_get() platform override
- Moved pmdp_test_and_clear_young() inside arch/arm64/mm/mmu.c

 arch/arm64/include/asm/pgtable.h | 11 +++--------
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/fixmap.c           |  2 +-
 arch/arm64/mm/hugetlbpage.c      |  2 +-
 arch/arm64/mm/kasan_init.c       |  4 ++--
 arch/arm64/mm/mmu.c              | 31 ++++++++++++++++++++-----------
 arch/arm64/mm/pageattr.c         |  2 +-
 arch/arm64/mm/trans_pgd.c        |  2 +-
 8 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a474c9fb485a..f619fa74da3c 100644
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
@@ -1287,13 +1288,7 @@ static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
-		unsigned long address, pmd_t *pmdp)
-{
-	/* Operation applies to PMD table entry only if FEAT_HAFT is enabled */
-	VM_WARN_ON(pmd_table(READ_ONCE(*pmdp)) && !system_supports_haft());
-	return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
-}
+bool pmdp_test_and_clear_young(struct vm_area_struct *vma, unsigned long address, pmd_t *pmdp);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
 
 static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index b22736853fcd..33b05a9f13d7 100644
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
index 140520b351e2..c998310406f9 100644
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
@@ -2441,3 +2441,12 @@ void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
 		     __func__, pte_str_old, pte_str);
 }
 #endif /* CONFIG_DEBUG_VM */
+
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
+bool pmdp_test_and_clear_young(struct vm_area_struct *vma, unsigned long address, pmd_t *pmdp)
+{
+	/* Operation applies to PMD table entry only if FEAT_HAFT is enabled */
+	VM_WARN_ON(pmd_table(pmdp_get(pmdp)) && !system_supports_haft());
+	return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index de7bf95003ea..bf1fd1258a75 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -362,7 +362,7 @@ bool kernel_page_present(struct page *page)
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


