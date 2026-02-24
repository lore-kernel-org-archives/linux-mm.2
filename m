Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDDC5EFB7FB
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7C86B0088; Tue, 24 Feb 2026 00:13:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5252A6B00A8; Tue, 24 Feb 2026 00:13:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44AB16B00AA; Tue, 24 Feb 2026 00:13:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E1F76B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:13:28 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0005B8333
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:27 +0000 (UTC)
X-FDA: 84478182054.14.6D4EE91
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 220F0120007
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771910006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SvxlyZtgiqH5Fz5dg9B/zrxmBO2XFEwZx9yF3JTWM30=;
	b=DuKjwODmi2sJZKAakm2UpUuKw3mPHyToTQ29sDoqW84QHIIVTAS4ojQvZgZvvm0x7aOpoF
	X6W32hIGiXmkzZH7TI8G59hERgvRhZZ/sbENQ/TCnN8Xo+ASzvKLlnD6AxeAByb7aVVrCk
	faY8hMDFT1VhhrOVC7MHIPw7ATLWJ4s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771910006; a=rsa-sha256;
	cv=none;
	b=tm8kzBXx28/g5aMqpfFezDWeh97k8KjLxVdcf0Witlkx31RW1qCtmub5kwJavd2liHMwl3
	p7L12Xl3X1xjyN1eubkaJ35Yq500VBAH3boFeGNJQTLtRjBwacdafDLH8kQBhKaQ4ekZ4S
	umSfLlPNJa3GP7x2g2rWJUHyWMQewBY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B0F3497;
	Mon, 23 Feb 2026 21:13:19 -0800 (PST)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3838E3F7BD;
	Mon, 23 Feb 2026 21:13:20 -0800 (PST)
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
Subject: [RFC V1 12/16] arm64/mm: Abstract printing of pxd_val()
Date: Tue, 24 Feb 2026 10:41:49 +0530
Message-ID: <20260224051153.3150613-13-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224051153.3150613-1-anshuman.khandual@arm.com>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 220F0120007
X-Stat-Signature: jgmbccuhms1sebyrbw5wxaa11hajhqzb
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771910005-518181
X-HE-Meta: U2FsdGVkX1/G+vkZ8keRCSnbh4k+PoSQdKsteUC0HhOfvAgdY0a6rNqjHd7Lfl71MM6+r6Da675ywGMMoynofYbTJyUuhrMmNYOdgk3SxmHBBhQ2j4r0vi4HmhTLzeuvT3DSWZsoHUyvfphUuUo4R5waseIzNL8kQq7NEzwOjt8OFYyCHdeP+5B9lY+ViSzbUIM7EvkJ+rvTroZZV20/NNwXsus3gi4qOe1fotSYwdMsKeKbn1bRPrAYjqlm4VYfhVo5Hij+Dfes1om0zYWyEwurjJSpN8DSwECZyUc7AOSctDcHlRPTjX5PHxfTNjQGDlyh5kXYqOfd8GvkhKNMiyBYwu++NSa77Rryo7BiZnG8sm7eTLkq0woG9Cc1SpsnAyGX1KvY8djFXczQM6GVQfNlIVTNXuB3cOGbSThOK5H1VNa/nE2idFGCWrMYDRCZJBC/0OYtm2g9Sj/i/O5VJnToQ/EHSm3+gDR2DwwABZ5H0f8HJ0eX6RTeQXHfDKWf3TcVRR3AozLCqoEzVfUwV/L5uQSaDpjNwMweC4yhWhlZj7y6WfmELz3DssD63kAfjXA94YA4+Lmy33EkgQyWjMdQYvIbINft4E+F56cRM6VIBliA2RPqeZSbdznEJmPr1NCL7f6vBeJa0W7S0qr2Z+yqWi3ieOujJmxjTWZdYuvD2Ysv7tqYa2E6jWIuwDB4rytnEx+uW8Zpq20M9MaNF7ROi7y6J4za4mnKAgC1XjoiodiX47i2lnk+1qUAAhLohd6Zr/o+Q3WArYfoJeBTZW8S1XeTie6yrn7wGRb5iSXiR7tVQgslRSTIeKy6oSlG0+96Dnui4KLvvukC0TPKDo43FNZwgSRxNIzBEznMXgN91UqgPcf0+J+njho+mFZNOYiWwCVFUmvqfym82pTTGSL922831mBfPOEiAaCKV+BQxknZKeQujGiF7sOcHAeTj6sbi5v/Wxuhw4e78AO
 8y13YYz6
 CE0s7cuTzYIKz5ChnvM+t9uFUrYOgHkfo76LhH//Ikl3vynD5AADjKuOqxT0/6BHUNEd6Rj56siZM7gXdVCQBm6rEcyuDmr9YYTochte+wBq2sA3qzP/EWqzgTRQeVeizY5zrN9L+IxRuQQZPXNBOF1j+wOrFh7rDf+CU1ryBjIFC4I45CV6h9HTmjNdLgTPn0SoCwpeWmPdcArjQar6XjfhJM21j81wpkqCi6VOIkVqU87CEpJwpRnNnponhah0h7gX6BxxNMCf2NSfFsRYh28UDkV/jlWW1BecM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ahead of adding support for D128 pgtables, refactor places that print
PTE values to use the new __PRIpte format specifier and __PRIpte_args()
macro to prepare the argument(s). When using D128 pgtables in future,
we can simply redefine __PRIpte and __PTIpte_args().

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable-types.h |  3 +++
 arch/arm64/include/asm/pgtable.h       | 22 +++++++++++-----------
 arch/arm64/mm/fault.c                  | 10 +++++-----
 3 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-types.h b/arch/arm64/include/asm/pgtable-types.h
index 265e8301d7ba..dc3791dc9f14 100644
--- a/arch/arm64/include/asm/pgtable-types.h
+++ b/arch/arm64/include/asm/pgtable-types.h
@@ -11,6 +11,9 @@
 
 #include <asm/types.h>
 
+#define __PRIpte		"016llx"
+#define __PRIpte_args(val)	((u64)val)
+
 /*
  * Page Table Descriptor
  *
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index cf69ce68f951..c4142b734112 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -152,7 +152,7 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
 #define ZERO_PAGE(vaddr)	phys_to_page(__pa_symbol(empty_zero_page))
 
 #define pte_ERROR(e)	\
-	pr_err("%s:%d: bad pte %016llx.\n", __FILE__, __LINE__, pte_val(e))
+	pr_err("%s:%d: bad pte %" __PRIpte ".\n", __FILE__, __LINE__, __PRIpte_args(pte_val(e)))
 
 #ifdef CONFIG_ARM64_PA_BITS_52
 static inline phys_addr_t __pte_to_phys(pte_t pte)
@@ -465,14 +465,14 @@ static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep,
 	 * through an invalid entry).
 	 */
 	VM_WARN_ONCE(!pte_young(pte),
-		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: racy access flag clearing: 0x%" __PRIpte " -> 0x%" __PRIpte,
+		     __func__, __PRIpte_args(pte_val(old_pte)), __PRIpte_args(pte_val(pte)));
 	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
-		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: racy dirty state clearing: 0x%" __PRIpte " -> 0x%" __PRIpte,
+		     __func__, __PRIpte_args(pte_val(old_pte)), __PRIpte_args(pte_val(pte)));
 	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
-		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: unsafe attribute change: 0x%" __PRIpte " -> 0x%" __PRIpte,
+		     __func__, __PRIpte_args(pte_val(old_pte)), __PRIpte_args(pte_val(pte)));
 }
 
 static inline void __sync_cache_and_tags(pte_t pte, unsigned int nr_pages)
@@ -905,7 +905,7 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 #if CONFIG_PGTABLE_LEVELS > 2
 
 #define pmd_ERROR(e)	\
-	pr_err("%s:%d: bad pmd %016llx.\n", __FILE__, __LINE__, pmd_val(e))
+	pr_err("%s:%d: bad pmd %" __PRIpte ".\n", __FILE__, __LINE__, __PRIpte_args(pmd_val(e)))
 
 #define pud_none(pud)		(!pud_val(pud))
 #define pud_bad(pud)		((pud_val(pud) & PUD_TYPE_MASK) != \
@@ -996,7 +996,7 @@ static inline bool mm_pud_folded(const struct mm_struct *mm)
 #define mm_pud_folded  mm_pud_folded
 
 #define pud_ERROR(e)	\
-	pr_err("%s:%d: bad pud %016llx.\n", __FILE__, __LINE__, pud_val(e))
+	pr_err("%s:%d: bad pud %" __PRIpte ".\n", __FILE__, __LINE__, __PRIpte_args(pud_val(e)))
 
 #define p4d_none(p4d)		(pgtable_l4_enabled() && !p4d_val(p4d))
 #define p4d_bad(p4d)		(pgtable_l4_enabled() && \
@@ -1117,7 +1117,7 @@ static inline bool mm_p4d_folded(const struct mm_struct *mm)
 #define mm_p4d_folded  mm_p4d_folded
 
 #define p4d_ERROR(e)	\
-	pr_err("%s:%d: bad p4d %016llx.\n", __FILE__, __LINE__, p4d_val(e))
+	pr_err("%s:%d: bad p4d %" __PRIpte ".\n", __FILE__, __LINE__, __PRIpte_args(p4d_val(e)))
 
 #define pgd_none(pgd)		(pgtable_l5_enabled() && !pgd_val(pgd))
 #define pgd_bad(pgd)		(pgtable_l5_enabled() && \
@@ -1238,7 +1238,7 @@ p4d_t *p4d_offset_lockless_folded(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
 #endif  /* CONFIG_PGTABLE_LEVELS > 4 */
 
 #define pgd_ERROR(e)	\
-	pr_err("%s:%d: bad pgd %016llx.\n", __FILE__, __LINE__, pgd_val(e))
+	pr_err("%s:%d: bad pgd %" __PRIpte ".\n", __FILE__, __LINE__, __PRIpte_args(pgd_val(e)))
 
 #define pgd_set_fixmap(addr)	((pgd_t *)set_fixmap_offset(FIX_PGD, addr))
 #define pgd_clear_fixmap()	clear_fixmap(FIX_PGD)
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 21964a387bf8..9e44c84734f1 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -153,7 +153,7 @@ static void show_pte(unsigned long addr)
 		 vabits_actual, mm_to_pgd_phys(mm));
 	pgdp = pgd_offset(mm, addr);
 	pgd = pgdp_get(pgdp);
-	pr_alert("[%016lx] pgd=%016llx", addr, pgd_val(pgd));
+	pr_alert("[%016lx] pgd=%" __PRIpte, addr, __PRIpte_args(pgd_val(pgd)));
 
 	do {
 		p4d_t *p4dp, p4d;
@@ -166,19 +166,19 @@ static void show_pte(unsigned long addr)
 
 		p4dp = p4d_offset(pgdp, addr);
 		p4d = p4dp_get(p4dp);
-		pr_cont(", p4d=%016llx", p4d_val(p4d));
+		pr_cont(", p4d=%" __PRIpte, __PRIpte_args(p4d_val(p4d)));
 		if (p4d_none(p4d) || p4d_bad(p4d))
 			break;
 
 		pudp = pud_offset(p4dp, addr);
 		pud = pudp_get(pudp);
-		pr_cont(", pud=%016llx", pud_val(pud));
+		pr_cont(", pud=%" __PRIpte, __PRIpte_args(pud_val(pud)));
 		if (pud_none(pud) || pud_bad(pud))
 			break;
 
 		pmdp = pmd_offset(pudp, addr);
 		pmd = pmdp_get(pmdp);
-		pr_cont(", pmd=%016llx", pmd_val(pmd));
+		pr_cont(", pmd=%" __PRIpte, __PRIpte_args(pmd_val(pmd)));
 		if (pmd_none(pmd) || pmd_bad(pmd))
 			break;
 
@@ -187,7 +187,7 @@ static void show_pte(unsigned long addr)
 			break;
 
 		pte = __ptep_get(ptep);
-		pr_cont(", pte=%016llx", pte_val(pte));
+		pr_cont(", pte=%" __PRIpte, __PRIpte_args(pte_val(pte)));
 		pte_unmap(ptep);
 	} while(0);
 
-- 
2.43.0


