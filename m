Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24481C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84876B0088; Thu, 24 Sep 2026 02:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A34156B0095; Thu, 24 Sep 2026 02:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FCBE6B0096; Thu, 24 Sep 2026 02:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 573796B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:22:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C13991A024A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:22:32 +0000 (UTC)
X-FDA: 85247661744.09.B3BB1E4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id BF19E20008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:22:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=leqM5NGC;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790230951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fs4q4Eh2H/6RpwIuIhoGwdlr0fKzsfn+Khobf1Dpw3c=;
	b=Quw33FOb1L1uJvge0jLnz/i5YIN7zB4k0XIIt/VKt9erkr2fIKrNFeWtrwDO7wRXH4UVFi
	tuzuNPe/fqsDciL1sUsTET69QIVNLA6vE6Ff/tBzrMfc69ukZi6TSEJuWZkgSiTz7S/Vd3
	BiNjqm0t7ZMf8i2WYXn0A+WHh+MON+E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=leqM5NGC;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790230951;
	b=JItyoDAeHLlt03uYCOP1alQGhKLtBrgex3ekXYPOurGh0Aef33QNFsZDGMIloTRr82olcE
	Eeie2fUEJIyqfTbiuYJk8/26sFm//hW0zr85D7hBsWY3hVU8ojYLfW2cOnfWInuYcGRTq+
	J5lwtmIKKjZSlL6pxiXO5Nevf4kfvYc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9AFFD1516;
	Wed, 23 Sep 2026 23:22:26 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60B223F86C;
	Wed, 23 Sep 2026 23:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790230950; bh=It4nFYOWQrTcREnmA+umTClf9lhzbtVM+nYFpA3hDmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leqM5NGCeYm3VoU7xCCd/l+6BtTKxtY/iRZlgxhA9FRMpTgJhok+cFuzYo2K8MjUQ
	 DqCCPrDz7N+nPaGfhGAuVdxHSff5mEiFAMOV93x+1Ti7dUwFdS3ci1rrpiwPB99LP3
	 04wAMtbrH6hub3jJYOfn0HMFJMAiJScGKVWjVQh0=
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
Subject: [PATCH V3 2/4] arm64/mm: Use pudp_get() for PUD accesses
Date: Thu, 24 Sep 2026 11:52:12 +0530
Message-ID: <20260924062214.1635078-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924062214.1635078-1-anshuman.khandual@arm.com>
References: <20260924062214.1635078-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BF19E20008
X-Stat-Signature: 7mat8kfgmffpge346djpza9whq9n7mt4
X-HE-Tag: 1790230950-335177
X-HE-Meta: U2FsdGVkX1+JdWiRupBRSt+NLdojt70xTwLPyI0Cdm4ue+iGoVrnYyR1ovzryN42Zt1tbX1NmMY2g2cMbLnUGm/i47UIt25+av5yP3ueGbWxOL/qDCsyjPxLXjPa3Pvk2SbVgIp5XxJ3baCkNzS9/U45t8bEko1YSz/rsXXhegVhEDGWzr+nnoGZQtYs4+sFgi/ZhUusQrqyM8/O0LpmeOKvoyjr44E3Ys2DnMaZi5XozxYCABuGvev6iibWPB41G37lrmL5myfbU+dqWJYMfLkMucd4+fTCBaabfqI9pl/9brE9ENZivHElxEbxkNZiCFp98r1yyjnwjjSZNU126bDbxzLn11X//1OHeVZqTyy853lZH/orpcCBp2Db5B8hubiMK3S4Ogzg+kfm+eKlKllIifrvWQfGi3OQEyV13ZYUWPQd6yd51j7GwrEVPV7pjT8RWiCE6VPmJD7BQeL+DonVNc1MHVm5IWxr+dAQfbjy8cz5igH3lyebqJMtTVz9olDde1wAPIi8uueED7wn7ddp2oBCTUihF+824V47q55SKMEAsHmoHCaKksUux6hUBXZjgZiR2V4wWfNWeZTQOivyr/pBsjzEFQSUQn/ks/+9xkRwr+cT4Py70UAdZxJmWZLZsb7o1sWKTmX9YuoGWm2Lkiu87rwRQBw/ZJoOcELRcrnY08wqzI3vUl5cupqBOVaTUwvAi9LUcaYhLPAxrKIWSaOn9xp2xf8lENVOWXfTEybnY4PTCEZ+vHuxT5uJLVVILmg5PUSFy29bnZOdSJtwFsXemIctydU5Xl2X9ApqKUEiggbHoqS7P7PC7uJvoWeyeXEqYfWiWvijeArMbd+eC3KUnURcqZGwLG5ARCsbjtK9AnDR3dwZYEC2d+YCNd9Ics/yu/H70gZzCVmPXL+5mOJzWKgTAjiEChfIPeioAPzoSjk71KhMkZQYDI+elFQPPn/CmBZVZKvOW3R
 R9svq9GK
 6uNdqJhvAYLyM5yf7F7Qf6eJ10WvhxE4sYwN33T9QNSleaNdT2yxoXUkgYkZcAZEumTVqyqxsF1dDWucen2pXTdDoPHsVMpFHImiKbZKZdBh/hO1YUCKmGIFzkma4RdvjDYc0Sp+pFJ/Vod+B7YIRolfstlQMU8AxkFo7TVGu+39THThMOv2Qcw1bvkmDNEYo2dpoGlSZ4aEaZgRPJxsHsSYj64ZvSAEfkMZe3Rt6RhQl7fApt3HrEnEpxwT1aJGXQMw0Q/+XZJ8HHW1YOaaLthT0XEyz/73VCtSe07ikSCWmcW4Vh/frGoUtB8xxE7w8RCt5rTKimo2fb6pjO9eu8lSCvREpq3qgPV5/Fm5rCi7we1HJvEfo3SiStb45X2RrvQieIdV6SRf7rfovJK1W1YDBdVPzQ9BAEr6ex7CKWlmg1Wcaek0w0TVlfx46jwkMOmyY0BGfatf0mffavAcCc3FDrfZwL0pjGL03QbCxIRguSBE=
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
required.

For now override pudp_get() which is same as the generic memory default in
order to be consistent with similar helpers.

No functional change intended.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: kasan-dev@googlegroups.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V3

- Added platform override for pudp_get()

 arch/arm64/include/asm/pgtable.h |  9 ++++++++-
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/fixmap.c           |  2 +-
 arch/arm64/mm/hugetlbpage.c      |  4 ++--
 arch/arm64/mm/kasan_init.c       |  4 ++--
 arch/arm64/mm/mmu.c              | 20 ++++++++++----------
 arch/arm64/mm/pageattr.c         |  2 +-
 arch/arm64/mm/trans_pgd.c        |  4 ++--
 8 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 9ad2d03e86ad..b46930f844a2 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -90,6 +90,12 @@ static inline pmd_t pmdp_get(pmd_t *pmdp)
 	return READ_ONCE(*pmdp);
 }
 
+#define pudp_get pudp_get
+static inline pud_t pudp_get(pud_t *pudp)
+{
+	return READ_ONCE(*pudp);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
@@ -879,7 +885,8 @@ static inline pmd_t *pud_pgtable(pud_t pud)
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


