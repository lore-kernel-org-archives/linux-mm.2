Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ED10C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4717A6B0145; Wed, 29 Jul 2026 10:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449886B0147; Wed, 29 Jul 2026 10:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35EE16B0148; Wed, 29 Jul 2026 10:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0471A6B0145
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:54:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1574C064E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:25 +0000 (UTC)
X-FDA: 85041734610.03.77DC2D5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 070D1C000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eM0OXzRV;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHIF/aT1O3EUVM+gwRc5yndgIL250Z4yq+9OlldutD4=;
	b=hDJ1cNMqL5kerKCK3qCLOyrUHON9HCpvvY1B6kz31ndKJ1muc4fVMZzKoiemJ35FUS1PIe
	jySx40Mg+TqtOXVRxxa8IO/JbVJXYFcvKQcDxK5hXwZbCaaQ/OY8P5p71pcp9xkf0s5hx4
	3UFd7xgsqy/L8t0Pie1Hl4bRzwWecl0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eM0OXzRV;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327924;
	b=aNbdyUAzsb6OMJ2DJv8vbz84e9230PDinBbltVAU/+rB7maZkqt4Ufc1oZzOBeh75WVMzl
	HAd3BhuPBPIUJ6cwgoVYP7RlMKpwGj4rxWl8F1a1p37HTdAeiLjnfhQzCCsXeCWAUdgRuY
	T0xmW0cfkwmr0KS+Q+AxLwYZ1lNKDRY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1393E169C;
	Wed, 29 Jul 2026 05:25:17 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 519D83F66F;
	Wed, 29 Jul 2026 05:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327921; bh=C1DQWx7VYKRGPi4zlsQhkY9GTpNb1XhVXT0s7ZGILy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eM0OXzRVsZRl28AEv9J7yGGxyMutjplqRdkVX42NdjtAGm/nUOIEwIE9P0bRTQQyi
	 ViKCtdN6sgKO9di0A0OvX/UZjeQistd+PQfT2ANH7hnWowGhn6vOrMByd2X+smkYjf
	 TAIjRoKjpWuvaRMiuTPwUm2SdLl56CFH/MVsf97M=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org
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
	kasan-dev@googlegroups.com
Subject: [PATCH 03/17] arm64/mm: Convert READ_ONCE() as pudp_get() while accessing PUD
Date: Wed, 29 Jul 2026 17:54:38 +0530
Message-ID: <20260729122452.3797443-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 070D1C000B
X-Rspamd-Server: rspam01
X-Stat-Signature: 5cnfkpxrp6s9ktzog8qtpcenxrx66x7o
X-HE-Tag: 1785327923-52270
X-HE-Meta: U2FsdGVkX1+HQnGuISavNvfCr7enRzVN3SCHRh/q+55Amyvy9Nk/NP8ZLYNRn50+PQ+F7N1EgEbHTiKuP8xvmOmbf3W/Zgl0oYRx9BsGT4wFW8guXaoEbPHQ7Djd1+e5MXRTboQPhatCxn/VbvBOC4rNaL2ClBot/98NIwj0KH5MpvoACvbL6xeUzdfUEFnMQ4e/sTOsNRtZgujjZsyUnrMQU3AVAzZzC3lHLVWV+WvlHr0po5vBulVh1x+YNRxg1kC+jmnsTcpO7t7qxabs6gwpWHKh/eIhRRtK1N2pT41VI31u4txgH4jmRzZ7r0dD2bxUAM0dczk8s/lHqeFL2tC3I0aQnOLGbHuquIsEDRzinep6YGrOpaGpcE1IDXwdLMrdRJnAKeS9ZLB9tHoBVgZdv5+NM/DNlvjIZ292HiJP6O3dEpjiYObAmIzr4MfAz0euXbIv+ewnmpgBDiaU1dfy5YGmyeFDDvXUoq026Q2oAL8naynG2YDOjqL4bDTDvWsEYhmyoiLvifESMLlDeej8j1lFGZ2N2WkL56/qiGVpv+qh9iqDwD0AG/6uLr0Uh8sebmfeBmiKMMS6NYZGwyh0+xWJEIYXY34f9aTHnUUhMuph86qUVSTvDJhLHrt9RztWMFmQSuRPeNjzizTfd98iWOoNKsKCVlv5tTuAkhwequG4r9FdUAohtEAVZN6mybhp0+QgUjxA+3AASC0g6zajm4NZoYknwyl/rYZRf5Rah5VEDUtkZ46CLYKYRAvexM3xwTxvV34DXx5c83AtCmO1rMTl6X9Lw6nPqnIUoIH0vPP6Oycrp0xfLWVOUuz0Jjcr3b6uhB4V2nTo9imSvwvHMS/OV5HvEmqY3uimVfU4GAtGV0A/GTd8J8xEFTaAXmqMwYJfXaAYc6SdMZOihi9/Y+RuBusfTH2k8L2wqU6GaK4fToYT4Nkowk/JGXeTHv85tpmnxPCOaBvzZYX
 bRNRw6wo
 jeDRmHaSjMm/SeSs4EaFD+BHl2HscyWfgIVhgLvuk+sJzZZccn0PDqrSqOZtgkPxHamEljksEqwTzaB2O6RVHGNYJmsaoC2QrNxcLOFaoDE50qh9YHLP0FpoM5jZzFp5w6K5gUhTuoo5UYi0+496kD0oOo3hXIUJk6fISHcEPWgo2Jm/sELgcVilQcW/JSE95lE8fhdvMtOylAHhzMjOdlfgr4sxwHletaSq3TfLr+a6rMdsfIWL3Cr4l4GMAI3jXNH0DR2Z1r4DD2eLOW4qcD8YWz1FzN8X/rx611c/oHP2bD501imE4HbagfYGs2eiPv5Of/ArOkxm63a6HHnjjJM8YWNDWx76JPQu+BGFhFCC8cje9p61Z6JMFIfbHhOzWe/li3sEseUer6BbknyVoRd2gZQlcZMEw4fr2E9WMW+dJBrkEEZQOgQ/egQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert all READ_ONCE() based PUD accesses as pudp_get() instead which will
support both D64 and D128 translation regime going forward. That is because
READ_ONCE() would need 128 bit single copy atomic guarantees, while reading
128 bit page table entries which is currently not supported on arm64. Build
fails for READ_ONCE() while accessing beyond 64 bits.

Load Pair/Store Pair (ldp/stp) are only single copy atomic if FEAT_LSE128
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
index 5c0cc7c676fa..c9eef353455f 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -917,7 +917,8 @@ static inline pmd_t *pud_pgtable(pud_t pud)
 }
 
 /* Find an entry in the second-level page table. */
-#define pmd_offset_phys(dir, addr)	(pud_page_paddr(READ_ONCE(*(dir))) + pmd_index(addr) * sizeof(pmd_t))
+#define pmd_offset_phys(dir, addr)	(pud_page_paddr(pudp_get(dir)) + \
+					 pmd_index(addr) * sizeof(pmd_t))
 
 #define pmd_set_fixmap(addr)		((pmd_t *)set_fixmap_offset(FIX_PMD, addr))
 #define pmd_set_fixmap_offset(pud, addr)	pmd_set_fixmap(pmd_offset_phys(pud, addr))
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 30f8b3872331..ccfd4ff76f88 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -174,7 +174,7 @@ static void show_pte(unsigned long addr)
 			break;
 
 		pudp = pud_offset(p4dp, addr);
-		pud = READ_ONCE(*pudp);
+		pud = pudp_get(pudp);
 		pr_cont(", pud=%016llx", pud_val(pud));
 		if (pud_none(pud) || pud_bad(pud))
 			break;
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
index 8cb440379f17..b1926b661efe 100644
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
index 85b2e2f9ea3e..fd1ce8649686 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -310,7 +310,7 @@ static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 {
 	int ret;
 	unsigned long next;
-	pud_t pud = READ_ONCE(*pudp);
+	pud_t pud = pudp_get(pudp);
 	pmd_t *pmdp;
 
 	/*
@@ -391,7 +391,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 	}
 
 	do {
-		pud_t old_pud = READ_ONCE(*pudp);
+		pud_t old_pud = pudp_get(pudp);
 
 		next = pud_addr_end(addr, end);
 
@@ -409,7 +409,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 			 * only allow updates to the permission attributes.
 			 */
 			BUG_ON(!pgattr_change_is_safe(pud_val(old_pud),
-						      READ_ONCE(pud_val(*pudp))));
+						      pud_val(pudp_get(pudp))));
 		} else {
 			ret = alloc_init_cont_pmd(pudp, addr, next, phys, prot,
 						  pgtable_alloc, flags);
@@ -417,7 +417,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 				goto out;
 
 			VM_WARN_ON_ONCE(pud_val(old_pud) != 0 &&
-					pud_val(old_pud) != READ_ONCE(pud_val(*pudp)));
+					pud_val(old_pud) != pud_val(pudp_get(pudp)));
 		}
 		phys += next - addr;
 	} while (pudp++, addr = next, addr != end);
@@ -1543,7 +1543,7 @@ static void unmap_hotplug_pud_range(p4d_t *p4dp, unsigned long addr,
 	do {
 		next = pud_addr_end(addr, end);
 		pudp = pud_offset(p4dp, addr);
-		pud = READ_ONCE(*pudp);
+		pud = pudp_get(pudp);
 		if (pud_none(pud))
 			continue;
 
@@ -1700,7 +1700,7 @@ static void free_empty_pud_table(p4d_t *p4dp, unsigned long addr,
 	do {
 		next = pud_addr_end(addr, end);
 		pudp = pud_offset(p4dp, addr);
-		pud = READ_ONCE(*pudp);
+		pud = pudp_get(pudp);
 		if (pud_none(pud))
 			continue;
 
@@ -1721,7 +1721,7 @@ static void free_empty_pud_table(p4d_t *p4dp, unsigned long addr,
 	 */
 	pudp = pud_offset(p4dp, 0UL);
 	for (i = 0; i < PTRS_PER_PUD; i++) {
-		if (!pud_none(READ_ONCE(pudp[i])))
+		if (!pud_none(pudp_get(pudp + i)))
 			return;
 	}
 
@@ -1819,7 +1819,7 @@ int pud_set_huge(pud_t *pudp, phys_addr_t phys, pgprot_t prot)
 	pud_t new_pud = pfn_pud(__phys_to_pfn(phys), mk_pud_sect_prot(prot));
 
 	/* Only allow permission changes for now */
-	if (!pgattr_change_is_safe(READ_ONCE(pud_val(*pudp)),
+	if (!pgattr_change_is_safe(pud_val(pudp_get(pudp)),
 				   pud_val(new_pud)))
 		return 0;
 
@@ -1850,7 +1850,7 @@ void p4d_clear_huge(p4d_t *p4dp)
 
 int pud_clear_huge(pud_t *pudp)
 {
-	if (!pud_leaf(READ_ONCE(*pudp)))
+	if (!pud_leaf(pudp_get(pudp)))
 		return 0;
 	pud_clear(pudp);
 	return 1;
@@ -1903,7 +1903,7 @@ int pud_free_pmd_page(pud_t *pudp, unsigned long addr)
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


