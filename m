Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A54C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1A290009E; Wed, 13 Aug 2025 10:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 271B5900088; Wed, 13 Aug 2025 10:56:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1623C90009E; Wed, 13 Aug 2025 10:56:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE83D900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:56:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C619B1A03F0
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:56:24 +0000 (UTC)
X-FDA: 83772035088.07.FC56920
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1827940004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:56:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of chaitanyas.prakash@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=chaitanyas.prakash@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755096983; a=rsa-sha256;
	cv=none;
	b=WXPwgN3Vg36symndmGYYc6aRy1uCRmBfTsrswSfOXHS+69YYKJBsih1qZe/p0JPx79vTRo
	/OaOxf5jO4qC97DJwA8gIldGqTyYVDawJB+/mDomrpsYuV4YPIp8gInZfzkr3N0GnrAs/N
	EkUPQ6wF24JntFau3ZeByrj/4LxQ7is=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of chaitanyas.prakash@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=chaitanyas.prakash@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755096983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gebmanlTn6wl4IuLzXs/lDFy+zTbdzxIjAieboFXA9Y=;
	b=3o0SYWKMc7ohjC83H3fD+D6kF5kO9NCoaZujYCTH1KpVg7a4+2wWQ6qscXs6FlgHVidFm/
	OIFeUsmP1297IoCUvSj1++e8wKGWDHpn0hwbl4lsLK8d2AOAe3JFxGMiVsDCwxjJNkfB0D
	VWgJOSbApHUin0qc+vFGZYg0lv0LXtc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE0A11A9A;
	Wed, 13 Aug 2025 07:56:13 -0700 (PDT)
Received: from a079125.blr.arm.com (a079125.arm.com [10.164.21.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5CC513F738;
	Wed, 13 Aug 2025 07:56:18 -0700 (PDT)
From: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zhenhua Huang <quic_zhenhuah@quicinc.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 1/2] arm64/mm: Allow __create_pgd_mapping() to propagate pgtable_alloc() errors
Date: Wed, 13 Aug 2025 20:26:06 +0530
Message-Id: <20250813145607.1612234-2-chaitanyas.prakash@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813145607.1612234-1-chaitanyas.prakash@arm.com>
References: <20250813145607.1612234-1-chaitanyas.prakash@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1827940004
X-Stat-Signature: dbpau1o3pqqnzrbqg6kcmm8n4wz1c4z9
X-Rspam-User: 
X-HE-Tag: 1755096982-988534
X-HE-Meta: U2FsdGVkX1/q4m2Mx7jPjrwey3Gi3haqDA8JLNeexWjWyKl9zpkycC6u1+T17kTo5nHeQCxXmgKVBMGBF5gaZiILyTShMmgm3/H09qZPlkw18bvFbsZ1C2qYePLtIHeHS/aJ/8gGU++a4e+T8i6NzUtE8pOK6pDQTQ9r6MUlCKzlg0wHCoKbZigtW2WidThJoubEjXmmcHZdaRjtC2NC52NF6eXsxYcdjV27cRgvjMCbRgaFemdFcsT8K8zqAgOHfjSJUVPy5n1okDKrwOdEUYhgbaucGQbdsJiRYmtHNXNNEUYBXkd9BofKnCs1Z7/PlvAJJWaXvvcHoMc3e/a3mileaNeuVZfBgTK7bXRpKA11Qjv8TGl3jSbwZruN04xApog5XMFf8NnoHimp1snenHctZL+roiV+GpX5LLzChhOWRcCUVC78lTjZMMzdVKgxZB+9VMyQgDCApVL0HQEXuhLR8+4HsTY+Suya0w9UTfN2DbsGhhbvt2LPHF3hz62pwY8v4sXXnkrlNbvFS1CRMd5qOnHhPFiPYgCK9FDfDqirxXwLrwVu8KAUrUgfFkhYytarCsXPsnSrhLnY6K+ggZVm7dGvZy8C4ZmDCh6ZhoimnX2cLsSK3uPzxaBPRkHblkM48S2UQF/STtBukULHynSuqk8zGXTIRHGzsk7+pkBOQCSXcQwzS3dcD+SbP6MBCS69vdRhupKr4UL24DsXs99uZG1apItqcJH6UDhxc1RUHFPi6oqodLeCzVX7dz+Xvktn3yjTfZKRkRGZ99eg0WcJRkYhUHAD0L/DdOC4yEsjag9qjg03SKFqaL2ihf9qkfL+ttiZqPuZezhb680s5TSz8LeUQOyGjEI8/sNJe5TMqwljj1iqEpOQCc6Arh1L3KqXRHsLpcqUJ1WW47FU0ns1I2QueqeKHtOlzpvuFGw8pqUIBYg9ni4tZ+u8cuNfUAfdpxvGyKkm1ai7smw
 v3oF2g+1
 v1FEkq29EG42wY3sN0fUJqgZbeL7yDgBO1KbqqFovQN/czfnOw7qoyCaahl7370DBxIK/DAacsRJGCHZgikQ+YMD6Z0OHEdUbXkvvRfEk7NTD0Ty3HWnPCso6Eb9htDloUBCVHI5RzcE5Vtl3yjrmHkQ3cigQbrk4WxNYJxXn+eRdls3DdbMV7pKCYj1mIUms10FsxmlEL8ossxc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

arch_add_memory() is used to hotplug memory into a system but as a part
of its implementation it calls __create_pgd_mapping(), which uses
pgtable_alloc() in order to build intermediate page tables. As this path
was initally only used during early boot pgtable_alloc() is designed to
BUG_ON() on failure. However, in the event that memory hotplug is
attempted when the system's memory is extremely tight and the allocation
were to fail, it would lead to panicking the system, which is not
desirable. Hence update __create_pgd_mapping and all it's callers to be
non void and propagate -ENOMEM on allocation failure to allow system to
fail gracefully.

But during early boot if there is an allocation failure, we want the
system to panic, hence create a wrapper around __create_pgd_mapping()
called ___create_pgd_mapping() which is designed to BUG_ON(ret), if ret
is non zero value. All the init calls are updated to use the wrapper
rather than the modified __create_pgd_mapping() to restore
functionality.

Signed-off-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
---
 arch/arm64/mm/mmu.c | 156 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 117 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 00ab1d648db62..db7f45ef16574 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -196,12 +196,13 @@ static void init_pte(pte_t *ptep, unsigned long addr, unsigned long end,
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
 }
 
-static void alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
+static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 				unsigned long end, phys_addr_t phys,
 				pgprot_t prot,
 				phys_addr_t (*pgtable_alloc)(enum pgtable_type),
 				int flags)
 {
+	int ret = 0;
 	unsigned long next;
 	pmd_t pmd = READ_ONCE(*pmdp);
 	pte_t *ptep;
@@ -215,6 +216,10 @@ static void alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 			pmdval |= PMD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
 		pte_phys = pgtable_alloc(TABLE_PTE);
+		if (!pte_phys) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		ptep = pte_set_fixmap(pte_phys);
 		init_clear_pgtable(ptep);
 		ptep += pte_index(addr);
@@ -246,12 +251,16 @@ static void alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 	 * walker.
 	 */
 	pte_clear_fixmap();
+
+out:
+	return ret;
 }
 
-static void init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
+static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 		     phys_addr_t phys, pgprot_t prot,
 		     phys_addr_t (*pgtable_alloc)(enum pgtable_type), int flags)
 {
+	int ret = 0;
 	unsigned long next;
 
 	do {
@@ -271,22 +280,27 @@ static void init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
 						      READ_ONCE(pmd_val(*pmdp))));
 		} else {
-			alloc_init_cont_pte(pmdp, addr, next, phys, prot,
-					    pgtable_alloc, flags);
+			ret = alloc_init_cont_pte(pmdp, addr, next, phys, prot,
+						  pgtable_alloc, flags);
+			if (ret)
+				break;
 
 			BUG_ON(pmd_val(old_pmd) != 0 &&
 			       pmd_val(old_pmd) != READ_ONCE(pmd_val(*pmdp)));
 		}
 		phys += next - addr;
 	} while (pmdp++, addr = next, addr != end);
+
+	return ret;
 }
 
-static void alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
+static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 				unsigned long end, phys_addr_t phys,
 				pgprot_t prot,
 				phys_addr_t (*pgtable_alloc)(enum pgtable_type),
 				int flags)
 {
+	int ret = 0;
 	unsigned long next;
 	pud_t pud = READ_ONCE(*pudp);
 	pmd_t *pmdp;
@@ -303,6 +317,10 @@ static void alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 			pudval |= PUD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
 		pmd_phys = pgtable_alloc(TABLE_PMD);
+		if (!pmd_phys) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		pmdp = pmd_set_fixmap(pmd_phys);
 		init_clear_pgtable(pmdp);
 		pmdp += pmd_index(addr);
@@ -322,20 +340,26 @@ static void alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 		    (flags & NO_CONT_MAPPINGS) == 0)
 			__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
 
-		init_pmd(pmdp, addr, next, phys, __prot, pgtable_alloc, flags);
+		ret = init_pmd(pmdp, addr, next, phys, __prot, pgtable_alloc, flags);
+		if (ret)
+			break;
 
 		pmdp += pmd_index(next) - pmd_index(addr);
 		phys += next - addr;
 	} while (addr = next, addr != end);
 
 	pmd_clear_fixmap();
+
+out:
+	return ret;
 }
 
-static void alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
+static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 			   phys_addr_t phys, pgprot_t prot,
 			   phys_addr_t (*pgtable_alloc)(enum pgtable_type),
 			   int flags)
 {
+	int ret = 0;
 	unsigned long next;
 	p4d_t p4d = READ_ONCE(*p4dp);
 	pud_t *pudp;
@@ -348,6 +372,10 @@ static void alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 			p4dval |= P4D_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
 		pud_phys = pgtable_alloc(TABLE_PUD);
+		if (!pud_phys) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		pudp = pud_set_fixmap(pud_phys);
 		init_clear_pgtable(pudp);
 		pudp += pud_index(addr);
@@ -377,8 +405,10 @@ static void alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 			BUG_ON(!pgattr_change_is_safe(pud_val(old_pud),
 						      READ_ONCE(pud_val(*pudp))));
 		} else {
-			alloc_init_cont_pmd(pudp, addr, next, phys, prot,
-					    pgtable_alloc, flags);
+			ret = alloc_init_cont_pmd(pudp, addr, next, phys, prot,
+						  pgtable_alloc, flags);
+			if (ret)
+				break;
 
 			BUG_ON(pud_val(old_pud) != 0 &&
 			       pud_val(old_pud) != READ_ONCE(pud_val(*pudp)));
@@ -387,13 +417,17 @@ static void alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 	} while (pudp++, addr = next, addr != end);
 
 	pud_clear_fixmap();
+
+out:
+	return ret;
 }
 
-static void alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
+static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 			   phys_addr_t phys, pgprot_t prot,
 			   phys_addr_t (*pgtable_alloc)(enum pgtable_type),
 			   int flags)
 {
+	int ret = 0;
 	unsigned long next;
 	pgd_t pgd = READ_ONCE(*pgdp);
 	p4d_t *p4dp;
@@ -406,6 +440,10 @@ static void alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 			pgdval |= PGD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
 		p4d_phys = pgtable_alloc(TABLE_P4D);
+		if (!p4d_phys) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		p4dp = p4d_set_fixmap(p4d_phys);
 		init_clear_pgtable(p4dp);
 		p4dp += p4d_index(addr);
@@ -420,8 +458,10 @@ static void alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 
 		next = p4d_addr_end(addr, end);
 
-		alloc_init_pud(p4dp, addr, next, phys, prot,
-			       pgtable_alloc, flags);
+		ret = alloc_init_pud(p4dp, addr, next, phys, prot,
+				     pgtable_alloc, flags);
+		if (ret)
+			break;
 
 		BUG_ON(p4d_val(old_p4d) != 0 &&
 		       p4d_val(old_p4d) != READ_ONCE(p4d_val(*p4dp)));
@@ -430,14 +470,18 @@ static void alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 	} while (p4dp++, addr = next, addr != end);
 
 	p4d_clear_fixmap();
+
+out:
+	return ret;
 }
 
-static void __create_pgd_mapping_locked(pgd_t *pgdir, phys_addr_t phys,
+static int __create_pgd_mapping_locked(pgd_t *pgdir, phys_addr_t phys,
 					unsigned long virt, phys_addr_t size,
 					pgprot_t prot,
 					phys_addr_t (*pgtable_alloc)(enum pgtable_type),
 					int flags)
 {
+	int ret = 0;
 	unsigned long addr, end, next;
 	pgd_t *pgdp = pgd_offset_pgd(pgdir, virt);
 
@@ -445,8 +489,10 @@ static void __create_pgd_mapping_locked(pgd_t *pgdir, phys_addr_t phys,
 	 * If the virtual and physical address don't have the same offset
 	 * within a page, we cannot map the region as the caller expects.
 	 */
-	if (WARN_ON((phys ^ virt) & ~PAGE_MASK))
-		return;
+	if (WARN_ON((phys ^ virt) & ~PAGE_MASK)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	phys &= PAGE_MASK;
 	addr = virt & PAGE_MASK;
@@ -454,22 +500,44 @@ static void __create_pgd_mapping_locked(pgd_t *pgdir, phys_addr_t phys,
 
 	do {
 		next = pgd_addr_end(addr, end);
-		alloc_init_p4d(pgdp, addr, next, phys, prot, pgtable_alloc,
-			       flags);
+		ret = alloc_init_p4d(pgdp, addr, next, phys, prot, pgtable_alloc,
+				     flags);
+		if (ret)
+			break;
 		phys += next - addr;
 	} while (pgdp++, addr = next, addr != end);
+
+out:
+	return ret;
 }
 
-static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
+static int __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 				 unsigned long virt, phys_addr_t size,
 				 pgprot_t prot,
 				 phys_addr_t (*pgtable_alloc)(enum pgtable_type),
 				 int flags)
 {
+	int ret = 0;
+
 	mutex_lock(&fixmap_lock);
-	__create_pgd_mapping_locked(pgdir, phys, virt, size, prot,
-				    pgtable_alloc, flags);
+	ret = __create_pgd_mapping_locked(pgdir, phys, virt, size, prot,
+					  pgtable_alloc, flags);
 	mutex_unlock(&fixmap_lock);
+
+	return ret;
+}
+
+static void ___create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
+				  unsigned long virt, phys_addr_t size,
+				  pgprot_t prot,
+				  phys_addr_t (*pgtable_alloc)(enum pgtable_type),
+				  int flags)
+{
+	int ret = 0;
+
+	ret = __create_pgd_mapping(pgdir, phys, virt, size, prot, pgtable_alloc,
+				   flags);
+	BUG_ON(ret);
 }
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
@@ -485,9 +553,11 @@ static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm,
 {
 	/* Page is zeroed by init_clear_pgtable() so don't duplicate effort. */
 	struct ptdesc *ptdesc = pagetable_alloc(GFP_PGTABLE_KERNEL & ~__GFP_ZERO, 0);
-	phys_addr_t pa;
+	phys_addr_t pa = 0;
+
+	if (!ptdesc)
+		goto out;
 
-	BUG_ON(!ptdesc);
 	pa = page_to_phys(ptdesc_page(ptdesc));
 
 	switch (pgtable_type) {
@@ -505,6 +575,7 @@ static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm,
 		break;
 	}
 
+out:
 	return pa;
 }
 
@@ -533,8 +604,8 @@ void __init create_mapping_noalloc(phys_addr_t phys, unsigned long virt,
 			&phys, virt);
 		return;
 	}
-	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
-			     NO_CONT_MAPPINGS);
+	___create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
+			      NO_CONT_MAPPINGS);
 }
 
 void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
@@ -548,8 +619,8 @@ void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 	if (page_mappings_only)
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
-	__create_pgd_mapping(mm->pgd, phys, virt, size, prot,
-			     pgd_pgtable_alloc_special_mm, flags);
+	___create_pgd_mapping(mm->pgd, phys, virt, size, prot,
+			      pgd_pgtable_alloc_special_mm, flags);
 }
 
 static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
@@ -561,7 +632,7 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 		return;
 	}
 
-	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
+	___create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
 			     NO_CONT_MAPPINGS);
 
 	/* flush the TLBs after updating live kernel mappings */
@@ -571,8 +642,8 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 static void __init __map_memblock(pgd_t *pgdp, phys_addr_t start,
 				  phys_addr_t end, pgprot_t prot, int flags)
 {
-	__create_pgd_mapping(pgdp, start, __phys_to_virt(start), end - start,
-			     prot, early_pgtable_alloc, flags);
+	___create_pgd_mapping(pgdp, start, __phys_to_virt(start), end - start,
+			      prot, early_pgtable_alloc, flags);
 }
 
 void __init mark_linear_text_alias_ro(void)
@@ -761,9 +832,9 @@ static int __init map_entry_trampoline(void)
 
 	/* Map only the text into the trampoline page table */
 	memset(tramp_pg_dir, 0, PGD_SIZE);
-	__create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS,
-			     entry_tramp_text_size(), prot,
-			     pgd_pgtable_alloc_init_mm, NO_BLOCK_MAPPINGS);
+	___create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS,
+			      entry_tramp_text_size(), prot,
+			      pgd_pgtable_alloc_init_mm, NO_BLOCK_MAPPINGS);
 
 	/* Map both the text and data into the kernel page table */
 	for (i = 0; i < DIV_ROUND_UP(entry_tramp_text_size(), PAGE_SIZE); i++)
@@ -1369,23 +1440,30 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	if (can_set_direct_map())
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
-	__create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
-			     size, params->pgprot, pgd_pgtable_alloc_init_mm,
-			     flags);
+	ret = __create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
+				   size, params->pgprot, pgd_pgtable_alloc_init_mm,
+				   flags);
+
+	if (ret)
+		goto out;
 
 	memblock_clear_nomap(start, size);
 
 	ret = __add_pages(nid, start >> PAGE_SHIFT, size >> PAGE_SHIFT,
 			   params);
-	if (ret)
-		__remove_pgd_mapping(swapper_pg_dir,
-				     __phys_to_virt(start), size);
-	else {
+	if (ret) {
+		goto out;
+	} else {
 		/* Address of hotplugged memory can be smaller */
 		max_pfn = max(max_pfn, PFN_UP(start + size));
 		max_low_pfn = max_pfn;
 	}
 
+	return 0;
+
+out:
+	__remove_pgd_mapping(swapper_pg_dir,
+			      __phys_to_virt(start), size);
 	return ret;
 }
 
-- 
2.34.1


