Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85453CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF31900220; Fri, 15 Aug 2025 04:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF878E0002; Fri, 15 Aug 2025 04:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F8F900220; Fri, 15 Aug 2025 04:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9FA28E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:56:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C26801DE096
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:41 +0000 (UTC)
X-FDA: 83778386202.26.765E0B9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1BBA140008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8AfMJV8wA54NFmPOthPFDFuukDzQtMz5lbwOiWe+/DU=;
	b=yFZauGF0rHEwOFREFCfGf7A1J7FUbbd6BEjH2YXf0cGXrOb/prnjsubAbBMwISR57WXs0x
	+oiG6a81fCDNLJUftbXCWXR+AOdxYuPK2yJzxFPILDJKsFP/2XUctRw9Y41UMr73av3tWr
	phEexpr9u63/HKOIvsBUddZaQE6qh8k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248200; a=rsa-sha256;
	cv=none;
	b=O+t6VdQThmwEQKEXnbcMW/dxxYiO56YpzUT0t/Z89OTt5Ytk6RLXMJLArkSLms/ht7pvKE
	CgA/RVUF5CJIVd00j9Wtkeyz4qOA5vfiUSORh5ytqpRJk9wdhej4HH66CL1zqmtDUFh7D0
	I/5p0h6AE0qFnWlK/VeRtybriwNSsKM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1963E497;
	Fri, 15 Aug 2025 01:56:31 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B32173F63F;
	Fri, 15 Aug 2025 01:56:34 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v5 15/18] arm64: mm: Guard page table writes with kpkeys
Date: Fri, 15 Aug 2025 09:55:09 +0100
Message-ID: <20250815085512.2182322-16-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1BBA140008
X-Stat-Signature: cyzt5zajzxx9tnaok1a8ns65b16peadw
X-HE-Tag: 1755248199-933448
X-HE-Meta: U2FsdGVkX193twLlm3s6PVGsGZNMM5ep3O4j7wyuDY9AVCVfbiw5tGEDih2LFkpx9KaM83HIkXKYiUEpobUzIsA5tlnvm8DzU+vP7cHIxMpY+qeLUncleH9jpHnmeUktebnJLCgPh7Sbio8EfSSE1U9BJYaxon8/Bq8zBoIsSEuaNg3KUHWDE8A2cTnXbzez3O5QugjzyFZfGwtl87SEZhlx1eFiK/PgRFNEggodgE+svngfzGew/Pmbn3+6vMoodXW616sH3VcMYrGYM0bjL/IFV1uAffSMi+rUUhfDNyZeOIQym9SQpNCj9nPJ1t/mKEiJt2Z1sW9/XpxxjZswoMN3b4//rABVOHRbDyY7Y1Mo+Ni2CrAsJXPgfEdQXim4vPrltd7dPe6YK8Ub5h4iiXtIR7CPp4u3OZbnz4PDIduymdBrXbxRGqYoxXgOGthvFD8uPKa6Mgp1p8IpmIVK2LTtv1ccVNVLqPrId+EJ9ffxaUISh5QO1OzrLtZZcAwWePwq/bUt2+ZFwY5ZLrYZp3ni+uzvsQj0yls8f2qmXEGjqd1nOWxMcpadiJYlEcAoNvtSLVSMYPs9kFqahelE5ZU0Wz9O4SjziTV3p598yZncW2qqb1YINpnTr3mD6T+JFIR57jSkaI90oEeVIxtkLy0eY1f/z8yHaTHEX0OxoHS+OHsUKsBHRRpmGrISFYRA8fse7e7MQvK041k/eQa7qZoNE0eLlxc8YuyrwUAhMNljSmlE/9jOSB4DhYfJkn5/0xsGpHNhYQLQHhaMXYfLDbTzHZhCgSNE8h7PRO9/2YNBP8N7BbNUA7B4V1FV7Dx5PkiiW7YciuxpM/XamZyCtZ+QiXLt90Q5+QmM5LZLciptHx4k8pbVcvC4e1RRQFHJXBi52qScGdr10gCqPD83QbPlzjAQ1dVH3r17apPVV7lr3K5V0N2YYPqNDdwsGZDNxVli/dkQAW8hBMhuM2Y
 Zk3G45II
 HLsXALOFGmUBtnst1L7ZpSV649Kpn5z3lC2NU627NiaEYWhdRcUJEK/rJQmSLknVj1yvpv/UwT6VaoiQcVJJj0AsE98UQkyiJFPzKpPi/qGrsVa5ihw9ja0BclhoRCvMhG4CYtIcqZke0+J1gLxRX4h5l9GhQ/vQKivQxKwbCYxIkHXNGPFrNEuVlPxOgTwDcFUInu98GSxXyrGiJF4j8feBuJHIWg/MXZS9x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_KPKEYS_HARDENED_PGTABLES is enabled, page tables (both
user and kernel) are mapped with a privileged pkey in the linear
mapping. As a result, they can only be written at an elevated kpkeys
level.

Introduce a kpkeys guard that sets POR_EL1 appropriately to allow
writing to page tables, and use this guard wherever necessary. The
scope is kept as small as possible, so that POR_EL1 is quickly reset
to its default value. Where atomics are involved, the guard's scope
encompasses the whole loop to avoid switching POR_EL1 unnecessarily.

This patch is a no-op if CONFIG_KPKEYS_HARDENED_PGTABLES is disabled
(default).

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 22 +++++++++++++++++++++-
 arch/arm64/mm/fault.c            |  2 ++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index abd2dee416b3..1694fb839854 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -39,6 +39,14 @@
 #include <linux/mm_types.h>
 #include <linux/sched.h>
 #include <linux/page_table_check.h>
+#include <linux/kpkeys.h>
+
+#ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
+KPKEYS_GUARD_COND(kpkeys_hardened_pgtables, KPKEYS_LVL_PGTABLES,
+		  kpkeys_hardened_pgtables_enabled())
+#else
+KPKEYS_GUARD_NOOP(kpkeys_hardened_pgtables)
+#endif
 
 static inline void emit_pte_barriers(void)
 {
@@ -390,6 +398,7 @@ static inline pte_t pte_clear_uffd_wp(pte_t pte)
 
 static inline void __set_pte_nosync(pte_t *ptep, pte_t pte)
 {
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*ptep, pte);
 }
 
@@ -858,6 +867,7 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 	}
 #endif /* __PAGETABLE_PMD_FOLDED */
 
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*pmdp, pmd);
 
 	if (pmd_valid(pmd))
@@ -918,6 +928,7 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
 		return;
 	}
 
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*pudp, pud);
 
 	if (pud_valid(pud))
@@ -999,6 +1010,7 @@ static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
 		return;
 	}
 
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*p4dp, p4d);
 	queue_pte_barriers();
 }
@@ -1127,6 +1139,7 @@ static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
 		return;
 	}
 
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*pgdp, pgd);
 	queue_pte_barriers();
 }
@@ -1316,6 +1329,7 @@ static inline int __ptep_test_and_clear_young(struct vm_area_struct *vma,
 {
 	pte_t old_pte, pte;
 
+	guard(kpkeys_hardened_pgtables)();
 	pte = __ptep_get(ptep);
 	do {
 		old_pte = pte;
@@ -1363,7 +1377,10 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 					       pte_t *ptep,
 					       unsigned long pgsize)
 {
-	pte_t pte = __pte(xchg_relaxed(&pte_val(*ptep), 0));
+	pte_t pte;
+
+	scoped_guard(kpkeys_hardened_pgtables)
+		pte = __pte(xchg_relaxed(&pte_val(*ptep), 0));
 
 	switch (pgsize) {
 	case PAGE_SIZE:
@@ -1436,6 +1453,7 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
 {
 	pte_t old_pte;
 
+	guard(kpkeys_hardened_pgtables)();
 	do {
 		old_pte = pte;
 		pte = pte_wrprotect(pte);
@@ -1469,6 +1487,7 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
 {
 	pte_t old_pte;
 
+	guard(kpkeys_hardened_pgtables)();
 	do {
 		old_pte = pte;
 
@@ -1516,6 +1535,7 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
 	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
+	guard(kpkeys_hardened_pgtables)();
 	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
 #endif
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index d816ff44faff..c4ab361bba72 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -214,6 +214,8 @@ int __ptep_set_access_flags(struct vm_area_struct *vma,
 	if (pte_same(pte, entry))
 		return 0;
 
+	guard(kpkeys_hardened_pgtables)();
+
 	/* only preserve the access flags and write permission */
 	pte_val(entry) &= PTE_RDONLY | PTE_AF | PTE_WRITE | PTE_DIRTY;
 
-- 
2.47.0


