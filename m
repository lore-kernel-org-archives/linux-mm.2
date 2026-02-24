Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA61EFB7FB
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA476B0096; Tue, 24 Feb 2026 00:13:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7B06B0098; Tue, 24 Feb 2026 00:13:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E46F6B0099; Tue, 24 Feb 2026 00:13:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2ACE16B0096
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:13:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB9A18B4F6
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:03 +0000 (UTC)
X-FDA: 84478181046.21.2AD7F6D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 199FAC000B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771909982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FW2CMNtGRcpGXEixEdNqZypEhSH+CeHAB0KU0mw6C7M=;
	b=wzkTsTqXjvuKtzGDbZY/7axE/k3ZxISlT77Kk00uc5FiAUb7TmvEyMTkPJTO98K3VkJyu/
	xx2GcfVd2e4scH04U1TfuUE7iVRJhZFnJ9zUPBW9AR2HjvZPtDrxtLRr5HgRRiRAZ+JfN7
	DzCAs9dEzIEtJB/f+oVCU2ikwqCNNtc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771909982; a=rsa-sha256;
	cv=none;
	b=sCdBmLXbYzmNBKxEhSxH7ThE5JPOuilQ/tjf0icDgsYsGVc0RFKYBK7lW6ER0I/sS4dOgD
	zHRCHQkFHLLj7n05BsLXF3WX/8orwQ6bjlkvkdqhQcFqilBRwRnhu1T11zBgDLB2pBpeLc
	OF0FB5nx2inGRcX8qNcP8Eq3VbSIodM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB93D497;
	Mon, 23 Feb 2026 21:12:54 -0800 (PST)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B3EC13F7BD;
	Mon, 23 Feb 2026 21:12:56 -0800 (PST)
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
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com
Subject: [RFC V1 07/16] arm64/mm: Convert READ_ONCE() as p4dp_get() while accessing P4D
Date: Tue, 24 Feb 2026 10:41:44 +0530
Message-ID: <20260224051153.3150613-8-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224051153.3150613-1-anshuman.khandual@arm.com>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 199FAC000B
X-Stat-Signature: htip3pdfu3qbngpcn86xataaq6jrgzx9
X-Rspam-User: 
X-HE-Tag: 1771909981-668132
X-HE-Meta: U2FsdGVkX1/RXesXsEpvS3jEGir8jLgR5lVz+GsZlSGoPTSkHuBErifsB1e1qv5/kvnlvagGc55RA/SS9Uta3PsnOswk1cFPxVSm/tN7Q1X6iZz/c//Nla05s5u4Ll0q2jVFRhQelNAbKD+6511KAr0GIhaZKm+w1u6L17DpzeP4LR8jh41RQm9pVE9qMj+Kp/Z6N5HSIzIr8TaSO4OdwkR5+Udv1e16uRDK0H1gzRWJ7Rxnm7tU6w4Ebnowm8iKh+7uHtCN6EwWmFlyTATVLyilzV0f1lNicbogcl+WMTTpkJYyJqUXiW3w9PVPXMQKBDMzRYquUuA16RPnR9eiak2Zo6thpF4HExy5BaBdEfefTbm6WgS8Jjr1XbKYOjokMJPkXoWd1InMGe7s3NsZ0m17+jywLwlvk+MMN//8z27PZmt10onu5sZEUVjgprA3weToAZpZrlvRvCh7cx5gTk/bSyEvJFlYz9c4z0hLaX6SdJP0bquXqgwe++aKQCE2fPap3Xxh32UFQmKrLGS1e99CN6iqdE95rvhzgqdA9n58M93psCzfOjh0Mniw7+MgU9+9uBSKYvYRvaqdLyTPi1TB7b4P8ACGmphlpqS51ovrgJW7wvRmoItDPIRM0iNnVQgS5oysrxQvuqHM7kGxPR9AvCRAN/WB0Iv7nS+zoeYkHNQbtkW6jsX+M3jUUsEZ1h8sGXO//QwPlN77xNrK88eNvey112xiIWPPgS6xFbRyEJ7dmmAqANF8ckYXrPiwiRAhu9b01ZUJVRqii0kt3egVOXX34Puzq4b+fFaWdb5I8lpj1XTFYMTBvGU04lT71YCAAv68APts6nqbVXvCvMx5gvthmT25lLWCVjKxsOhXU+oqoK5ilwkP0vDRAvO4bPaBiuWBAfADx91PoqVhlGbMRNtJw6VHmuGpAWYvOhFWhsQXS2U866v/7U7iAVcj5RYzR5Ve2fJyb1vNxsK
 yiCemvP9
 m0GSmReD49p9tZ0y06EIdalqQF4cr8uz9aFKE/4AarNkdjgddlL3eyl+XNPi+ATAx4iKAnaGsX/SQd9hy5YSyWD4BTlZkNR4uqMZhdUV8MwXCkKjFcO1gQaGiGsK9u6Hg3i9fmnsNIJ80UCnpmZiIyRi1Pb/8lDow7LRr5RuRqh8mO3LzbOSmDJupmNIGrS2ry+wtyqnyJpx3HQLQ6vSVxHt8vfV7l8WILqG14zsjqlUDxTFfQMt5BFd1MZAYblpXP/P8va6koiOfsylo5jOB0I4yB3gyTX1/6mEotH3c6reWzQ66gfNpujChbZxRyGwWeZbNAL1GqQpUC3+7thB3uRAD+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert all READ_ONCE() based P4D accesses as p4dp_get() instead which will
support both D64 and D128 translation regime going forward.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: kasan-dev@googlegroups.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 13 +++----------
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/fixmap.c           |  2 +-
 arch/arm64/mm/hugetlbpage.c      |  2 +-
 arch/arm64/mm/kasan_init.c       |  4 ++--
 arch/arm64/mm/mmu.c              | 29 +++++++++++++++++++++++------
 arch/arm64/mm/pageattr.c         |  2 +-
 arch/arm64/mm/trans_pgd.c        |  4 ++--
 8 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 93d06b5de34b..24ea4e04e9a1 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1003,12 +1003,7 @@ static inline pud_t *p4d_pgtable(p4d_t p4d)
 	return (pud_t *)__va(p4d_page_paddr(p4d));
 }
 
-static inline phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
-{
-	BUG_ON(!pgtable_l4_enabled());
-
-	return p4d_page_paddr(READ_ONCE(*p4dp)) + pud_index(addr) * sizeof(pud_t);
-}
+phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr);
 
 static inline
 pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d, unsigned long addr)
@@ -1019,10 +1014,8 @@ pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d, unsigned long addr)
 }
 #define pud_offset_lockless pud_offset_lockless
 
-static inline pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
-{
-	return pud_offset_lockless(p4dp, READ_ONCE(*p4dp), addr);
-}
+pud_t *pud_offset(p4d_t *p4dp, unsigned long addr);
+
 #define pud_offset	pud_offset
 
 static inline pud_t *pud_set_fixmap(unsigned long addr)
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 64836bc14798..f41f4c628d22 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -165,7 +165,7 @@ static void show_pte(unsigned long addr)
 			break;
 
 		p4dp = p4d_offset(pgdp, addr);
-		p4d = READ_ONCE(*p4dp);
+		p4d = p4dp_get(p4dp);
 		pr_cont(", p4d=%016llx", p4d_val(p4d));
 		if (p4d_none(p4d) || p4d_bad(p4d))
 			break;
diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index dd58af6561e0..4c2f71929777 100644
--- a/arch/arm64/mm/fixmap.c
+++ b/arch/arm64/mm/fixmap.c
@@ -74,7 +74,7 @@ static void __init early_fixmap_init_pmd(pud_t *pudp, unsigned long addr,
 static void __init early_fixmap_init_pud(p4d_t *p4dp, unsigned long addr,
 					 unsigned long end)
 {
-	p4d_t p4d = READ_ONCE(*p4dp);
+	p4d_t p4d = p4dp_get(p4dp);
 	pud_t *pudp;
 
 	if (CONFIG_PGTABLE_LEVELS > 3 && !p4d_none(p4d) &&
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index b229c05bfbb6..15241307baec 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -288,7 +288,7 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
 		return NULL;
 
 	p4dp = p4d_offset(pgdp, addr);
-	if (!p4d_present(READ_ONCE(*p4dp)))
+	if (!p4d_present(p4dp_get(p4dp)))
 		return NULL;
 
 	pudp = pud_offset(p4dp, addr);
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index 19492ef5940a..e50c40162bce 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -89,7 +89,7 @@ static pmd_t *__init kasan_pmd_offset(pud_t *pudp, unsigned long addr, int node,
 static pud_t *__init kasan_pud_offset(p4d_t *p4dp, unsigned long addr, int node,
 				      bool early)
 {
-	if (p4d_none(READ_ONCE(*p4dp))) {
+	if (p4d_none(p4dp_get(p4dp))) {
 		phys_addr_t pud_phys = early ?
 				__pa_symbol(kasan_early_shadow_pud)
 					: kasan_alloc_zeroed_page(node);
@@ -162,7 +162,7 @@ static void __init kasan_p4d_populate(pgd_t *pgdp, unsigned long addr,
 	do {
 		next = p4d_addr_end(addr, end);
 		kasan_pud_populate(p4dp, addr, next, node, early);
-	} while (p4dp++, addr = next, addr != end && p4d_none(READ_ONCE(*p4dp)));
+	} while (p4dp++, addr = next, addr != end && p4d_none(p4dp_get(p4dp)));
 }
 
 static void __init kasan_pgd_populate(unsigned long addr, unsigned long end,
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a80d06db4de6..16ae11b29f66 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -354,7 +354,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 {
 	int ret = 0;
 	unsigned long next;
-	p4d_t p4d = READ_ONCE(*p4dp);
+	p4d_t p4d = p4dp_get(p4dp);
 	pud_t *pudp;
 
 	if (p4d_none(p4d)) {
@@ -443,7 +443,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 	}
 
 	do {
-		p4d_t old_p4d = READ_ONCE(*p4dp);
+		p4d_t old_p4d = p4dp_get(p4dp);
 
 		next = p4d_addr_end(addr, end);
 
@@ -453,7 +453,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 			goto out;
 
 		BUG_ON(p4d_val(old_p4d) != 0 &&
-		       p4d_val(old_p4d) != READ_ONCE(p4d_val(*p4dp)));
+		       p4d_val(old_p4d) != (p4d_val(p4dp_get(p4dp))));
 
 		phys += next - addr;
 	} while (p4dp++, addr = next, addr != end);
@@ -1541,7 +1541,7 @@ static void unmap_hotplug_p4d_range(pgd_t *pgdp, unsigned long addr,
 	do {
 		next = p4d_addr_end(addr, end);
 		p4dp = p4d_offset(pgdp, addr);
-		p4d = READ_ONCE(*p4dp);
+		p4d = p4dp_get(p4dp);
 		if (p4d_none(p4d))
 			continue;
 
@@ -1703,7 +1703,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
 	do {
 		next = p4d_addr_end(addr, end);
 		p4dp = p4d_offset(pgdp, addr);
-		p4d = READ_ONCE(*p4dp);
+		p4d = p4dp_get(p4dp);
 		if (p4d_none(p4d))
 			continue;
 
@@ -1724,7 +1724,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
 	 */
 	p4dp = p4d_offset(pgdp, 0UL);
 	for (i = 0; i < PTRS_PER_P4D; i++) {
-		if (!p4d_none(READ_ONCE(p4dp[i])))
+		if (!p4d_none(p4dp_get(p4dp + i)))
 			return;
 	}
 
@@ -2258,4 +2258,21 @@ int pmdp_test_and_clear_young(struct vm_area_struct *vma,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
 
+#if CONFIG_PGTABLE_LEVELS > 3
+phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
+{
+	p4d_t p4d = p4dp_get(p4dp);
+
+	BUG_ON(!pgtable_l4_enabled());
+
+	return p4d_page_paddr(p4d) + pud_index(addr) * sizeof(pud_t);
+}
+
+pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
+{
+	p4d_t p4d = p4dp_get(p4dp);
+
+	return pud_offset_lockless(p4dp, p4d, addr);
+}
+#endif
 #endif
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 581b461d4d15..b45190507e59 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -397,7 +397,7 @@ bool kernel_page_present(struct page *page)
 		return false;
 
 	p4dp = p4d_offset(pgdp, addr);
-	if (p4d_none(READ_ONCE(*p4dp)))
+	if (p4d_none(p4dp_get(p4dp)))
 		return false;
 
 	pudp = pud_offset(p4dp, addr);
diff --git a/arch/arm64/mm/trans_pgd.c b/arch/arm64/mm/trans_pgd.c
index 71f489d439ef..75f0a6a5a43a 100644
--- a/arch/arm64/mm/trans_pgd.c
+++ b/arch/arm64/mm/trans_pgd.c
@@ -126,7 +126,7 @@ static int copy_pud(struct trans_pgd_info *info, p4d_t *dst_p4dp,
 	unsigned long next;
 	unsigned long addr = start;
 
-	if (p4d_none(READ_ONCE(*dst_p4dp))) {
+	if (p4d_none(p4dp_get(dst_p4dp))) {
 		dst_pudp = trans_alloc(info);
 		if (!dst_pudp)
 			return -ENOMEM;
@@ -173,7 +173,7 @@ static int copy_p4d(struct trans_pgd_info *info, pgd_t *dst_pgdp,
 	src_p4dp = p4d_offset(src_pgdp, start);
 	do {
 		next = p4d_addr_end(addr, end);
-		if (p4d_none(READ_ONCE(*src_p4dp)))
+		if (p4d_none(p4dp_get(src_p4dp)))
 			continue;
 		if (copy_pud(info, dst_p4dp, src_p4dp, addr, next))
 			return -ENOMEM;
-- 
2.43.0


