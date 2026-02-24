Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ABC5EFB7FA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B276B00A4; Tue, 24 Feb 2026 00:13:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011676B00A6; Tue, 24 Feb 2026 00:13:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D3E6B00A7; Tue, 24 Feb 2026 00:13:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D38E46B00A4
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:13:18 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 768978993C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:18 +0000 (UTC)
X-FDA: 84478181676.13.B30BFBB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id B75E41C0014
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771909997; a=rsa-sha256;
	cv=none;
	b=aCWMrm/gsWwPGQx/NLialm+/gd4BQmFkOf6+4h1z0yGKmXbxTjDKaFiWEELmtMXNKp7/UC
	0sgo+aW1orTO31zPIEZw7bIKnRjtTxJlv89W0BRQGEAwOrU5XTbprePKb9e5db9k4yskc6
	DrlPCSbe/6y2RoSyh3DxEvLlm7tS4Fc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771909997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=al0CxO/T+3Vzo6bAStDPqo5GOdTHNtQ67l/V+ahAuFM=;
	b=ONi23ILgO6pLEAg94QeZyiqwwSPxxVaDCi6l1YYJ2os8MiNHrVsTXiGGQJITTeJcPXb6nR
	dtExF3HTXGPRpEpzm2FhwxJAeJ9z1ckvackVndA0arNt9adqjLfnRrluyy2tdQbfzSmcFH
	ujs30NfVTOeZmNCdshk3XfCnXl/iM/c=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8440B497;
	Mon, 23 Feb 2026 21:13:09 -0800 (PST)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A0BB83F7BD;
	Mon, 23 Feb 2026 21:13:11 -0800 (PST)
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
	linux-mm@kvack.org
Subject: [RFC V1 10/16] arm64/mm: Route all pgtable writes via ptdesc_set()
Date: Tue, 24 Feb 2026 10:41:47 +0530
Message-ID: <20260224051153.3150613-11-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224051153.3150613-1-anshuman.khandual@arm.com>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5kp3a43kyfui6ctw7cn7w77zdw857y64
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B75E41C0014
X-HE-Tag: 1771909996-68888
X-HE-Meta: U2FsdGVkX191d0bAFXdJ4TTm6ifZp4jYjRyUojZ0A9aTZ9VQHpTeA432QC73C9Wk93MQZbEm6n3YIWnymLC6MD9RVlvYU1CRSRst6x/zkoeVu8B3Bne7oQviJXFYxcWWG50Ze96zZG4FTfpK4NUBoCOnRvD1eBwLHh4fZlvFB7JiCvhzdzE0Ouo2F2fl/c8wqiRfU2QsLqPYXx2uJ9+d7xOVEZV8wA8kBZVJCXgs9xkgmDSo7i/Wg+QifAC7vLsYzRyLlfhBP5v0koSjfPzlOpnySM6wmjOzXihI4TJUhvEiygX+S6Sa8UjdL0MjFN4K85ILZk991bZZYrMYMtzCK1/NiOYL2HgDNK9Y6fCkI52W3nJoYCsktqn/EqBKE5MIRq307XqfX7eRXBktQ6iqablV3mz/Yl8H3NRBnmbl01OL9TyFlaNueQur4RDN/is/safvoDvCdmxglHGgpTmBy+4z1CPfSalf5O+mMaEQP2wssZZE6m7QpWcMX26ah5SDvArukGRUgJgppGYIfMOcYeiPGPA2K3PRrwdvxQxfFf9wxXOlU1AF8mHpoiK5WaSNqdxINeVIwdugsvkZQx19JKmkW9miDo//EW50ivwzIooTo1O2HLTFwrznOxO3SgSdiiDOBtFy+Ca8HJOM/z2ESNW6RgXHB3mCl5E84mDWoe0S1xACSL5VJNiQ3y05nwX+fal8bWSTmzregk3LmxBxHpMkg0UX4ZKcLhHFX5sVCC9j1q+Ljfoy23XpZ+xzCmcJy6Z64IWxOpHHdyxAHIQSSVgxyU9mXr9wz+3+IO2ilwojRjHFE1HEYVp98LlJyJOfjFNZhHeBHyISrPOevdHnwIKwN6tQ6mB87twABcXhhPF5LfFEqqbIHeOTPQ/UzQ+lz149T448TXVffm/0/2cME+oSWY6Znn2dnCUiIyb69MxHzSKz3VTkabmpZwccRrMetnSUYvMQQ3Tyag9CAV6
 rb8TMBYR
 hTS5YYCPzhOzRyyDaC9lIgC/PM9EqPu/R5bq0XAONdx0uRdJN4UQbuXzSYtlI4q1BsUZ9POy22K3el8XmZgykFUm/OWkzR01HgHpUW0Ifd5p+thAZPpD3ccIgL08itBvsYn3M4tz4XjQ2hMPxawCmuc0s5VellEUenjI9hAitWipA+HJfJJ/2rFQc1BJ0dW0kFBs+c+8ePbP5rgRHotf2Pee0SmbGyQRExv9f3G22hNYG92thRc2LuSYUYPTRC2C/5O3z2uHFXnlVdX+LmGVokecBasY4V91oslo4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently ptdesc_set() is defined as WRITE_ONCE() but this will change for
D128 pgtable builds, for which WRITE_ONCE() is not sufficient for single
copy atomicity.

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
 arch/arm64/include/asm/pgtable.h | 11 ++++++-----
 arch/arm64/mm/mmu.c              |  4 ++--
 mm/debug_vm_pgtable.c            |  4 ++--
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 804ef49aea88..42124d2f323d 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -85,6 +85,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
 }
 
 #define ptdesc_get(x)		READ_ONCE(x)
+#define ptdesc_set(x, val)	WRITE_ONCE(x, val)
 
 #define pmdp_get pmdp_get
 static inline pmd_t pmdp_get(pmd_t *pmdp)
@@ -389,7 +390,7 @@ static inline pte_t pte_clear_uffd_wp(pte_t pte)
 
 static inline void __set_pte_nosync(pte_t *ptep, pte_t pte)
 {
-	WRITE_ONCE(*ptep, pte);
+	ptdesc_set(*ptep, pte);
 }
 
 static inline void __set_pte_complete(pte_t pte)
@@ -856,7 +857,7 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 	}
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-	WRITE_ONCE(*pmdp, pmd);
+	ptdesc_set(*pmdp, pmd);
 
 	if (pmd_valid(pmd))
 		queue_pte_barriers();
@@ -917,7 +918,7 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
 		return;
 	}
 
-	WRITE_ONCE(*pudp, pud);
+	ptdesc_set(*pudp, pud);
 
 	if (pud_valid(pud))
 		queue_pte_barriers();
@@ -999,7 +1000,7 @@ static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
 		return;
 	}
 
-	WRITE_ONCE(*p4dp, p4d);
+	ptdesc_set(*p4dp, p4d);
 	queue_pte_barriers();
 }
 
@@ -1120,7 +1121,7 @@ static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
 		return;
 	}
 
-	WRITE_ONCE(*pgdp, pgd);
+	ptdesc_set(*pgdp, pgd);
 	queue_pte_barriers();
 }
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index bcf32d1a92de..ffd307c546f5 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -83,7 +83,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
 	 * writable in the kernel mapping.
 	 */
 	if (rodata_is_rw) {
-		WRITE_ONCE(*pgdp, pgd);
+		ptdesc_set(*pgdp, pgd);
 		dsb(ishst);
 		isb();
 		return;
@@ -91,7 +91,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
 
 	spin_lock(&swapper_pgdir_lock);
 	fixmap_pgdp = pgd_set_fixmap(__pa_symbol(pgdp));
-	WRITE_ONCE(*fixmap_pgdp, pgd);
+	ptdesc_set(*fixmap_pgdp, pgd);
 	/*
 	 * We need dsb(ishst) here to ensure the page-table-walker sees
 	 * our new entry before set_p?d() returns. The fixmap's
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 83cf07269f13..faf6a19a89a1 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -445,7 +445,7 @@ static void __init pmd_huge_tests(struct pgtable_debug_args *args)
 	 * X86 defined pmd_set_huge() verifies that the given
 	 * PMD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*args->pmdp, __pmd(0));
+	ptdesc_set(*args->pmdp, __pmd(0));
 	WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn), args->page_prot));
 	WARN_ON(!pmd_clear_huge(args->pmdp));
 	pmd = pmdp_get(args->pmdp);
@@ -465,7 +465,7 @@ static void __init pud_huge_tests(struct pgtable_debug_args *args)
 	 * X86 defined pud_set_huge() verifies that the given
 	 * PUD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*args->pudp, __pud(0));
+	ptdesc_set(*args->pudp, __pud(0));
 	WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
 	WARN_ON(!pud_clear_huge(args->pudp));
 	pud = pudp_get(args->pudp);
-- 
2.43.0


