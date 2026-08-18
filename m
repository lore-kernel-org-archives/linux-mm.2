Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 942C3C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93126B07ED; Tue, 18 Aug 2026 10:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A42E46B07EE; Tue, 18 Aug 2026 10:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959146B07EF; Tue, 18 Aug 2026 10:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75D8B6B07ED
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:13:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15DF44029F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:13:14 +0000 (UTC)
X-FDA: 85114582308.21.30436CC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 47F131C000D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:13:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=peqnBzB2;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8M15HWAvwg8z6AB7gQntXqDZQew0QizjzDdyqXfZfs=;
	b=N5Y1zikq06/DgsMgSUMz8YWn2gvUkChqsUAEfieiear/4P8Q1+G/gUOmIo7zix+FvdhSCJ
	56gVtTKtAN8FErKPmpT5ZUlRJqnKePUju5YhR4dQ9q98Sb8I2nNi7m8uruuh+yDTzSsa4V
	/mmC0TQry7gUT4lNztpQSpETrJV9P3o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=peqnBzB2;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062392;
	b=TU0UZ8SRx9pIHsGKb9yHxooMKU16MyPDkssv9/XZBDEqVeVkLT6E8zDRIaCO8nH7PDYlFO
	WQAKq8I6Q4SY/AOWMymTfDuIby7nY3UHxiRcXuVUCxuwUd8XZnx8pmD2T6sYcYeQBoya3e
	0Rrx2/8r41mtRq5gg2RK3gTa5xZJtZk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4AC919F6;
	Tue, 18 Aug 2026 07:13:07 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1C933F85F;
	Tue, 18 Aug 2026 07:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062391; bh=7oXOYiAopMb592CjcVSVS05/25guZDYn9RWg7atibJM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=peqnBzB2hpT5Eu08tZxPbOvN5sTec4CjG4yjdO9pyBW6tJjS4FrSNf23X6nDFoFXv
	 vjprPTlKzduz82VjH4V3lzakzUc4r/piEBYnI3vzuAKDdtvZn+/e/PR1M8WBr523wJ
	 eHoNMYKRLmtmyl6OOG/JLMu+G45WE3Ndtm1DZQkk=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:09:04 +0100
Subject: [PATCH RFC v9 22/25] arm64: kpkeys: Guard page table writes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-22-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062277; l=4674;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=7oXOYiAopMb592CjcVSVS05/25guZDYn9RWg7atibJM=;
 b=CHcCdECE9mm2G2OZx9nbwi5LJRy1qsZmidqWUdLW1JWUqYOzHsOZLw6y2YnjEHhiQ7v3mziwd
 MR7fJZ7gPlvDXHaqSAFcOS9enkzIN/bncCDgitRaCDIkVCyO67kqHPK
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: ykd4xdr4zojyzspihcfxfrbcqeug8ny5
X-Rspamd-Queue-Id: 47F131C000D
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787062392-820777
X-HE-Meta: U2FsdGVkX18BnNp/OB3kYAoJDHS7sopUxW8luqnZEyJB1PKeWzwnjg+Irj2k/1Rj994qh/gXoptQijnvEQWhg9zhKDtrpgHCeA2CRaqscla5GiRJHk3YyExzGw4fWSbvZ1QO7sfMQa9wGpJKUhTysVBQay9/qV1Y8GFfoHIeOunId6qp//eKcW3TBQIv6KSi86x4OnaLNASLnSajPHLAExTJIDn4oNOe+MqhjuhQZiOtFxQTJZ4lpu2MI4zBYltkVvij60ibl3kZxAPfGmetlGOY596MOUV/xL6myVxNBFp5xiBOG6x5qGlnuthL1GavGK9Wjkmcqdr+ciRYPLtc0Q9z+5hwZi4UOO1qbxImnRpAyyt8xXiZGnme4YqGLvKAZBu9iGGTEvIdFqJBn9KOYhWYN6Ms3oxiXWcf2RhQitpwGL31o/DYfoiOzTGqkp4MWPyDUohUkkgobHt0fjUD3goTVfqmr8IRstlCmWDX7ruLXBZRyCsan3LX5QOSMc2sQsoFl+R06BYsTiggivk03PZkJV1MZ8/S3yPWDvOqRs5ylB3k9S8Rj6L7de8gWptqV3R3+LNjucACkM9odjjLJJOS5OqB4emUGG+cHkA6YfovzSstu4AsInQzBkZvZnXBQ+L1neoG9tobB4QO5e3PMUiOIqouF5p9S9FObqDHj0kl5ruPRkvsXJ4Yc5YjqvFqvWC83vVdM1qL1U1YUIkr1HJBawn9+UftDNVKdOrCTsp+Ns4j8pObl4ZAxRyBsBobMNicsfCR8TUIVDwsDWWxUjHvPVsnYykKO5kKYMilm1XjpIvkbJHVqoLlHpix3uJVlmMBNCqGK0S7CPoHRxGJsnrWjcmrorMgTRa4D90JyP3JJt7xZCIcnZSf0yDXcqmYaSbI2rrLUkghRXiQ6wlBo9xs1kQXSasSqsC0h4IGT0/Xs+TG1Y3MQhqY6FkLJGs1R5nOStKP1HxZFUr/ljT
 JcHTi7r9
 l7mtxVbcGGS72L8vS7WDqHwq+6Uxer5OWHXFvd4I2WU7xP45Kdu1gKeR8rwNN2ik0F8kYunnTyF/Kyzt7osvRVIWVd4ph4cyAiOLfDF7OAUqRY/aej+xHn1NMMJCSZCsbci9h//2cWk2uw1fMbAR4PMaFPV0in8Hjef/IE2chCeDHkHTMSp0DRCMbyDBe7js5gZRWRMdFKO3PRVzXNsN86LGFBkYeXZB1tnQajCa1PlZAGYVnMFf6ojNpdH2n8Qe3hOUeJS44y0Q+5iyU+etjC8cKALN//PcXJGtLK7097XhyfhMvOKYTfhRXyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_KPKEYS_HARDENED_PGTABLES is enabled, page tables (both
user and kernel) are mapped with a privileged pkey in the linear
mapping. As a result, they can only be written in a privileged
kpkeys context.

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
 arch/arm64/mm/fault.c            | 17 ++++++++++-------
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 27689c62bd25..b4e52d6bb6ba 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -39,6 +39,14 @@
 #include <linux/mm_types.h>
 #include <linux/sched.h>
 #include <linux/page_table_check.h>
+#include <linux/kpkeys.h>
+
+#ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
+KPKEYS_GUARD_COND(kpkeys_hardened_pgtables, KPKEYS_CTX_PGTABLES,
+		  kpkeys_hardened_pgtables_enabled())
+#else
+KPKEYS_GUARD_NOOP(kpkeys_hardened_pgtables)
+#endif
 
 static inline void emit_pte_barriers(void)
 {
@@ -359,6 +367,7 @@ static inline pte_t pte_clear_uffd_wp(pte_t pte)
 
 static inline void __set_pte_nosync(pte_t *ptep, pte_t pte)
 {
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*ptep, pte);
 }
 
@@ -830,6 +839,7 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 	}
 #endif /* __PAGETABLE_PMD_FOLDED */
 
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*pmdp, pmd);
 
 	if (pmd_valid(pmd))
@@ -894,6 +904,7 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
 		return;
 	}
 
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*pudp, pud);
 
 	if (pud_valid(pud))
@@ -975,6 +986,7 @@ static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
 		return;
 	}
 
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*p4dp, p4d);
 	queue_pte_barriers();
 }
@@ -1103,6 +1115,7 @@ static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
 		return;
 	}
 
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*pgdp, pgd);
 	queue_pte_barriers();
 }
@@ -1307,6 +1320,7 @@ static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
 {
 	pte_t old_pte, pte;
 
+	guard(kpkeys_hardened_pgtables)();
 	pte = __ptep_get(ptep);
 	do {
 		old_pte = pte;
@@ -1354,7 +1368,10 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
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
@@ -1427,6 +1444,7 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
 {
 	pte_t old_pte;
 
+	guard(kpkeys_hardened_pgtables)();
 	do {
 		old_pte = pte;
 		pte = pte_wrprotect(pte);
@@ -1460,6 +1478,7 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
 {
 	pte_t old_pte;
 
+	guard(kpkeys_hardened_pgtables)();
 	do {
 		old_pte = pte;
 
@@ -1507,6 +1526,7 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
 	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
+	guard(kpkeys_hardened_pgtables)();
 	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
 #endif
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 0b52557652be..a853a8d4e61a 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -229,13 +229,16 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
 	 */
 	pte_val(entry) ^= PTE_RDONLY;
 	pteval = pte_val(pte);
-	do {
-		old_pteval = pteval;
-		pteval ^= PTE_RDONLY;
-		pteval |= pte_val(entry);
-		pteval ^= PTE_RDONLY;
-		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
-	} while (pteval != old_pteval);
+	scoped_guard(kpkeys_hardened_pgtables) {
+		do {
+			old_pteval = pteval;
+			pteval ^= PTE_RDONLY;
+			pteval |= pte_val(entry);
+			pteval ^= PTE_RDONLY;
+			pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval,
+						 pteval);
+		} while (pteval != old_pteval);
+	}
 
 	/*
 	 * Invalidate the local stale read-only entry.  Remote stale entries

-- 
2.51.2


