Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C10BCD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A318F6B009F; Wed, 13 May 2026 00:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A08816B00A0; Wed, 13 May 2026 00:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91EC16B00A1; Wed, 13 May 2026 00:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 849876B009F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:47:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4FB991C179F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:47:03 +0000 (UTC)
X-FDA: 84761161926.17.F4303A3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id A454340007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:47:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=if20+fKx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778647621; a=rsa-sha256;
	cv=none;
	b=gDB1vpvdp4rGDb0N77VDsM2hS3H41earpegd13z05bbDwdMaaCm9OxZLRQd47r26+Kou2Z
	avoV2Jjpa2Htucg5C5+t2oUMOodoj7lIxOvtYJjgTo9ewtBA+f6Nv31xWOjQAumeI3TmHk
	aU6dp9Ow9LMR08urzl5k1a5fsGdfQWw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=if20+fKx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778647621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4W0ksk2N6Sxx4T5iD7tqAk5YQ1Y0ArLsN/Knf2DuCL8=;
	b=kJXJSjJndiKxbkqSyXjyLfvQDo5GS1gEzn3LMUewPtDPqfUL4O3sCGl22MVAvYy3YmU1pY
	mxl9LYpEagNzP90efAZwbMmZ3vlJMIxKO0769hUqCKhXkiVtFeGcC2YatYOg7riu90wtch
	7bGXtLFj1GLbcfWV706sFbyvCoFHcl0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB10E1CE0;
	Tue, 12 May 2026 21:46:55 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E9A343F7B4;
	Tue, 12 May 2026 21:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778647620; bh=/GMPc1AS+V+v7u9/Jk3AwDNanWjzLJC2yvA5U4is97w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=if20+fKxOp+HGZ9DVFqI3N11g3mzKyuHRrvDN8t0MQ3KFfdBdiiEO5bAf62FSaxDO
	 MPU02UKq4gLzH0A2mtyGLn/s3gOQOtU72EVcgUkL6r5TM+RbUegjq1KZ9myWHkkpWe
	 tQROjEgSz9oFAZXZOO3p8BRsy4a7HETbgrzlhqqU=
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
	linux-mm@kvack.org
Subject: [RFC V2 07/14] arm64/mm: Route all pgtable reads via pxxval_get()
Date: Wed, 13 May 2026 10:15:40 +0530
Message-ID: <20260513044547.4128549-8-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513044547.4128549-1-anshuman.khandual@arm.com>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b3k8tuwkzkufz1ck558q5fniie6gdrkx
X-Rspam-User: 
X-Rspamd-Queue-Id: A454340007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778647621-612635
X-HE-Meta: U2FsdGVkX1+CNdHlS8MX2MGPlauQdaGDPxKHo/l0wygeUTU6YxmgckQ6dgdt/QmCh5Dp9APlSE+eY6quso1R/4IAJPS4wjguuRJKxT3P/3dkymUWP173yDKWa2xL4X+t7xxmwNrj/sQd4ad/5xVXEV5Kk7Kq6F0madiICvyFN2cGxEP7Bop9W5g4fmu89VUDWdl1mDIbykC2D9C5kBXQfcMmRQV4viK6xdoietH23XX4moCq60vP7dPIABAhsBMG/BKU/5z8Fri844oXHCejhHPsYgrqF/8fkyRuEiEhpMLwo3wqidqzN2ckC/FLNt+57zVrRPbAhdjZoWYyEDbqf4p72MI9Dv8LJX8b0Ly6I91uoHbuqTFiNxTVYHk7eoYwZhIN5X3uw9mJVIxuqFXZu2RD7iAeZl/LOOub87Qbv8YfGwA8BOfcAuZznb2NXJVkTITWsM1o/4YBbOOL0RPGRwWg1xcGI5MMDnjEtZVvRwEm9fvg1VTQYRlMZBU9yf/upgxzwhG6clkoS9CjDefwDq1UhsLrtkq9BeHFMl9HDOIgWQo8PP5iYUWnbFr0hHYQt8VUMFGgY1+fJ0f2tgb/6ywJ6VoHwdX6+pxi+5lSKZV0WIfq8tmIsvzCI/9Pss/QWax7mGSGFeTBRYhvBG8rEzpYFCaVnqrSF3TSEqqow/6xIhBCH7gLuhCEoBSg9aU9rIQbU0lIrmxlL16HNR5uKGK0biuoA6jTIkb0e9ctgUFcSOMCLr+KPykZf8zvlF/xhzLAP2zbBXmxxmnvbeqJxMF20vXn3gd2iW/J0NR0qBcQ0agVAzd2TyNsCgEA+CrSTQVBlghB0C+GXH8T/f7O6Ghl4Jdx9Vm6vcQwnsoBtiBe+Kf4EtyToV1THwVv2pcKXg1imXcL2wI4jLrpxuL0cWGJgUBN6jVswvUViHbNV/h2kxliggbbsqUFwiql3XNhE5RtchNOjEk7i2z/4vT
 sAnu/J1H
 kkqbCOv07RVAEfXhVNldI6MaG9FFNCouNwXGIp77f2jh05MuCgC385cQUBwYfd3WIp+ER+Zh9uNk2SVJNZL+2C64g5LVSpn4E8RkuNC6AMTlaFQskZCKnmWy/sjK8b4wuA7eAITi7+pzbSiaCNmAquTUkeCGvBHsBCKKtl5cQPpqeH01D1shQfTlhKdJxWv/PviU+lEec+KzKNq2XCKjoku7fVSeRn8jYyVPh/c+TT0SIJb5ZBYYFR0Wal0LQN64p/xr3QWvQY/rq+1qhAz0TFd8S1V2RW2WznhrcEGZ5954RNjazLhoPg/EcE+SfVqgweh8xh7PteYQoNFSbwxnIx56L1PCQ42phCd8AoIlkMvTnSAeBxIY3DamPZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define arm64 platform specific implementations for new pXdp_get() helpers.
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
Changes in RFC V2:

- Renamed all ptdesc_ instances as pxxval_ instead
- Moved arm64 pgtable header READ_ONCE() replacements here in this patch

 arch/arm64/include/asm/pgtable.h | 38 +++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index cefe8ab86acd..72da582e8d12 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -84,6 +84,32 @@ static inline void arch_leave_lazy_mmu_mode(void)
 	arch_flush_lazy_mmu_mode();
 }
 
+#define pxxval_get(x)		READ_ONCE(x)
+
+#define pmdp_get pmdp_get
+static inline pmd_t pmdp_get(pmd_t *pmdp)
+{
+	return pxxval_get(*pmdp);
+}
+
+#define pudp_get pudp_get
+static inline pud_t pudp_get(pud_t *pudp)
+{
+	return pxxval_get(*pudp);
+}
+
+#define p4dp_get p4dp_get
+static inline p4d_t p4dp_get(p4d_t *p4dp)
+{
+	return pxxval_get(*p4dp);
+}
+
+#define pgdp_get pgdp_get
+static inline pgd_t pgdp_get(pgd_t *pgdp)
+{
+	return pxxval_get(*pgdp);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
@@ -380,7 +406,7 @@ static inline void __set_pte(pte_t *ptep, pte_t pte)
 
 static inline pte_t __ptep_get(pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	return pxxval_get(*ptep);
 }
 
 extern void __sync_icache_dcache(pte_t pteval);
@@ -1011,7 +1037,7 @@ static inline phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
 {
 	BUG_ON(!pgtable_l4_enabled());
 
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
 	BUG_ON(!pgtable_l5_enabled());
 
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


