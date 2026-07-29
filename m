Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3149C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11A296B0137; Wed, 29 Jul 2026 10:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09C956B013B; Wed, 29 Jul 2026 10:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF4596B0137; Wed, 29 Jul 2026 10:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB2516B0139
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:52:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85503120693
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:36 +0000 (UTC)
X-FDA: 85041735072.22.7BC99E7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id DFA3E1A0002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Et2KNFEU;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dzfuAiojxIRT14nkeyZSYjMfkdqqBZ0WWWMYkB5WjKU=;
	b=K0h/wudbLeJ9mhRm+X1yWp8uI7nTMW8s4N6gwTURzZ/TafY3BB5EJZ9NNwtYVaEfkIOAYG
	95zBJAiBfYMQd8Dq8madVRJ5VYYS4hfUvk/Tx6/yaScMfAonAElO2Ty7H3lqIutSBWucBu
	7LfX6QhqPnTQrl2QMyCf0ZNY9YMfPNY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Et2KNFEU;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327935;
	b=jZfTNkWH31+e3yfDdAYnyfeRPFThQOYb3xh0Vs5JvYZanTTHTUn07SGd4ob1LzXEbzvD+8
	l+r5DixJy42i83KitCMZ3wfVKQ9oBTxqw+T4IkecS0MbMLrcovdmSHSv2ChpBBuUeqcbyS
	EHFLv8168SXvV1uHPu4AZj3uefacdoY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EAC251688;
	Wed, 29 Jul 2026 05:25:29 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 73A213F66F;
	Wed, 29 Jul 2026 05:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327934; bh=Qe1wG0sX1xsnA7mZ1SYAhqpb+0SAcw2BMXi9YHuEvg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Et2KNFEUQ88mYWV0Ul/x6FObG1/KXAKqa1OvU/ceqAZzHINXk/qrl4PyTwmxxch3V
	 NQIfUUW3im5lgc/f3SdENndOMuCnf54Kqvbdu280aS3aw3XU/j0WaNuoORhsVNi5Mi
	 By/WbUwtrgyYZW9dG43NrtCNRdE2QBINrj1W24IA=
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
	linux-kernel@vger.kernel.org
Subject: [PATCH 06/17] arm64/mm: Route all pgtable reads via ptval_get()
Date: Wed, 29 Jul 2026 17:54:41 +0530
Message-ID: <20260729122452.3797443-7-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DFA3E1A0002
X-Stat-Signature: jdmq9k3d7mse38cmri5okemsd764erzp
X-HE-Tag: 1785327934-798462
X-HE-Meta: U2FsdGVkX19j7kYQSDd6ml2RzA5FCYWFVFF1Py1G0cvYGAO6o2+UyMdYB3o8z5IvKQ2tRR0K9njdtgAIgtGJANMtDteIFQo4hbQ8nVoD0ClDLnujqTRLE95vnPYuuBCyKQEMHpVDwdI7i1LobrKq/spzCtW9MSXpqZm5dm98VFZtRLQNeN2SH7+vKBVifVqrWiEhBIulTnIbwHff6eRq0YgTXvxH0XV2iYkfBWyD9qXniBBd/bqrZifXwNH6ZZAe6+SpWdXqV38pMtmx+2wNj+dq7Slx9qn7w4Vr/x3j6gne5JHS6sm0ZfN28yepY6QqGkpkqc8C1DiuiA7cjLis3PEi2SMHnzvIz1nNxrTYZwOvV6Wc81uScQ2Jvpd7c6/sjZS/B/1MdzidqMofOUoEvTo8zRnc7H8x9jBKoUmHUuVLNvkq8Ko0GA3jXglHJubNgi1uxQ/tXTZ4cPrFEDwT/c1l6e0XRJmR6AGHN779d0ZZGPRzgpyZYACrioMmKRjQIvmxabOsOXWU5KwAz4mnFF8KBtUDN0Em7E2AmVdbuu0bIlNqgoPflYmxJBvK3980aCVCprAQXbNE/DZltOsHYUbw217q9cR6pTZ5rFsJluW0vDHEgv19V7Dislfkp7ydDM8Z7ML1P/b3rZbbytAFg1OWaYLcrMoaAfCg8A4Iv9VNQjNbnTbW9Hd1zEDD+rcOvR+vUBtYOdUuS8Bs8bOJCeoVQXYJ6dEnWHHCSxdq4RjI7F4qR9LXCW5SwQJUrtnVKJVrUntRPPiTFae+XMC5OkpmyOXtuam9qAVqe03kn+EkLTJk259qV8ubHwWxUSrS+rWTV4v2MT2P54Lj0rpKtQvtwaqI7L0kRhf5ivExxrKJixI31r30kOADRbdrnS+QaA5swVLjlMea1Prxn+1fjVsAo41I+EivxNIfEaMfj4cpTwnNogGESfVO54BwnlL6aQwju7SSNvH6iSj5YDP
 e+b8X4DD
 lJ6zO98KRNQIJs/6h3nf9ofMgMSTOMVG3UQKBGOtDOGtP/LaOMQaUxMqxkIh+308ESpHmWZPeBvr6dykOrCrYDsuNCZxBdVJ5jJ3aER6HBpykCEbZIPGd2ezIN2Q7pk9xfCba6bWtIhecZZmWBEiQKnyZR4CI36s/pl3JBKxrTRrREzecifCm7L+4fqtVXUnKqOfQRELbPgdSBJs10/X81jWAF10bHy9/0Zq1yqI2gFJhyQemuusvHtd03Q0oi8GzZyVOiATDhn7ToOU9PVHFTHJJbXCT/HxOGQ4wvskMau+xfjMZFURyZAw0c8WC2tG9oPKRlv/2U6P8hGJYyDtxjE3878Kn+WgwJJ5tpADtd+rn5zpcicre+OdwfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define arm64 platform specific implementations for new pxdp_get() helpers.
These resolve into READ_ONCE(), thus ensuring required single copy atomic
semantics for the page table entry reads.

In future this infrastructure can be used for D128 to maintain single copy
atomicity semantics with inline asm blocks.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 38 +++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index c9eef353455f..030ec3582a0d 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -84,6 +84,32 @@ static inline void arch_leave_lazy_mmu_mode(void)
 	arch_flush_lazy_mmu_mode();
 }
 
+#define ptval_get(x)		READ_ONCE(x)
+
+#define pmdp_get pmdp_get
+static inline pmd_t pmdp_get(pmd_t *pmdp)
+{
+	return ptval_get(*pmdp);
+}
+
+#define pudp_get pudp_get
+static inline pud_t pudp_get(pud_t *pudp)
+{
+	return ptval_get(*pudp);
+}
+
+#define p4dp_get p4dp_get
+static inline p4d_t p4dp_get(p4d_t *p4dp)
+{
+	return ptval_get(*p4dp);
+}
+
+#define pgdp_get pgdp_get
+static inline pgd_t pgdp_get(pgd_t *pgdp)
+{
+	return ptval_get(*pgdp);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
@@ -380,7 +406,7 @@ static inline void __set_pte(pte_t *ptep, pte_t pte)
 
 static inline pte_t __ptep_get(pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	return ptval_get(*ptep);
 }
 
 extern void __sync_icache_dcache(pte_t pteval);
@@ -1011,7 +1037,7 @@ static inline phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
 {
 	VM_WARN_ON_ONCE(!pgtable_l4_enabled());
 
-	return p4d_page_paddr(READ_ONCE(*p4dp)) + pud_index(addr) * sizeof(pud_t);
+	return p4d_page_paddr(p4dp_get(p4dp)) + pud_index(addr) * sizeof(pud_t);
 }
 
 static inline
@@ -1025,7 +1051,7 @@ pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d, unsigned long addr)
 
 static inline pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
 {
-	return pud_offset_lockless(p4dp, READ_ONCE(*p4dp), addr);
+	return pud_offset_lockless(p4dp, p4dp_get(p4dp), addr);
 }
 #define pud_offset	pud_offset
 
@@ -1134,7 +1160,7 @@ static inline phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr)
 {
 	VM_WARN_ON_ONCE(!pgtable_l5_enabled());
 
-	return pgd_page_paddr(READ_ONCE(*pgdp)) + p4d_index(addr) * sizeof(p4d_t);
+	return pgd_page_paddr(pgdp_get(pgdp)) + p4d_index(addr) * sizeof(p4d_t);
 }
 
 static inline
@@ -1148,7 +1174,7 @@ p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
 
 static inline p4d_t *p4d_offset(pgd_t *pgdp, unsigned long addr)
 {
-	return p4d_offset_lockless(pgdp, READ_ONCE(*pgdp), addr);
+	return p4d_offset_lockless(pgdp, pgdp_get(pgdp), addr);
 }
 
 static inline p4d_t *p4d_set_fixmap(unsigned long addr)
@@ -1346,7 +1372,7 @@ static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp)
 {
 	/* Operation applies to PMD table entry only if FEAT_HAFT is enabled */
-	VM_WARN_ON(pmd_table(READ_ONCE(*pmdp)) && !system_supports_haft());
+	VM_WARN_ON(pmd_table(pmdp_get(pmdp)) && !system_supports_haft());
 	return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
-- 
2.43.0


