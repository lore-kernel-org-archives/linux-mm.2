Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07BADFF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 718D86B00E9; Tue,  5 May 2026 12:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9566B00EA; Tue,  5 May 2026 12:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8366B00EB; Tue,  5 May 2026 12:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 444516B00E9
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:08:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 067F11A0591
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:40 +0000 (UTC)
X-FDA: 84733849242.14.D62259E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3155340016
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Yu3zLptz;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hTggG4h6MAmpTYSVulIxjgEJ+gnrcs7gm6wOFcSREg=;
	b=BJBoElykJxHsnexlqm73zu5beENS+6SPS1Tnc+6uE86Jn8UpEj1i4+vzka8xSAsAnkk3bX
	QjB/4aH8T6OldhSAM6cxHHMFdKVjvXrIRj7E5TzrKkat8LEzD/7hWUSyD/KoaaEyDJAtq5
	Jy69E0VzRAQfx8k0CExhpkNbQ0DRP6M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Yu3zLptz;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997319; a=rsa-sha256;
	cv=none;
	b=DiZtIXNLIkT2Ovk2M4H4Nm9HSdLq38XEzZV/jehDHLbF8NmvlFOzMCQM/XQgbrVpkYTXfV
	jL6zqOIVRkyvP82fBImviLNLMoYzZzdk1arF/bZwERJ7SJidAC5n3JJFBg8F23wNRayI0V
	BmFD9cQvLxqKFr2b1tBKRtZZJo55RhI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0BF2714BF;
	Tue,  5 May 2026 09:08:33 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 47D613F763;
	Tue,  5 May 2026 09:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997318; bh=EySxOil8TcwYwuEGrwoYGjRX1REQ6GfG8Z5Pa273DNk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Yu3zLptzCPLqvH8Q+sqa85JAVjpLwPQbG+OrPDX/KS8hogd41ekg7h6crakPjmpTP
	 Ku9IYp3fgjgPyxdJNPDSBF8daqF1TwN29q45z9YMD/uBuVQz7gAeTh6JYGL+Nv70LQ
	 G4Sp3UZIpY0k6OvcGBMLg4rsfaNYhxFbPLZEUqfc=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:06:10 +0100
Subject: [PATCH RFC v7 21/24] arm64: kpkeys: Guard page table writes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-21-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=4227;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=EySxOil8TcwYwuEGrwoYGjRX1REQ6GfG8Z5Pa273DNk=;
 b=mRcytsacp6RNX+Hj6r9mKLTM3GOBVXID2ixTkPwGAnuh7HX9DpNNqWA8cg4SGJhhJl7bEh0zm
 1Jw6+Pn/60MCHN6q6Oe4v/RN3AvQYzLlIvhzlxWAB1KFdXTIH/hF8uY
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: g853rq64j1uez3q8mfsppzkrgremn876
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3155340016
X-Rspam-User: 
X-HE-Tag: 1777997318-130717
X-HE-Meta: U2FsdGVkX1/TfCBut/vLz3sR6lcxkLVms0FRQzR3TVGz2yl7L02q/J4BhHS9rtN8f7cmPB7Gzuty8ZZhcsDfKYmsYg5Q7XIiEjYd35YQ339ZbW3TAB3+YIfNAY82ZNniLamf1kKp9LpMtqRwb2urzRGInu7MiUPOkYTCXxIUFRnOyODsi0uFybvJi8pxihD4VaGqczilWDvCIvlHa6n9tqRIwLqJQoqNNsvgkPmz9v81DaEkpbhzxxyrKEqOB3VvEW7EHSNV52aoCsyxtvyEwp26hcyJkQ6roeEjDfrptEjpwOEHEBncN6AZbGW4x71X0ImTmYoAqc56sYTib06RtyWmSZpnJW7mcAmds9cwAlYskMoltrXpFPy+40n7exAmugsKh175/Sf8xkncpM3b8CP4BT1UzhhxPMUa/iNtEVN9XKdxfvKDmQhXC3yLjf5bM+lGf/EfNhQyzZ1x2+xZ3cLugDDLm5PVMCqfe7HDV/OuACtkDHXI2Brl7rwOw9DfAQxBkgM8fLh5h5CZP0W3Ur+p5eRkd5P3Y4PZRELmxjDhyZFMUIuTxbMReOEgZcYPK+/Anc4j/g/DVliyf4YiNov7mrGxxFUhXOuFyLhyFSQFsHY1krALPe+n7r+nKtzsT9W9MoCQx96BRaGA857BZRL/n9Vu8lvBcI4OELklAhqae59pBfCTNg3x2SKw9BnfL9dX9s0LNDf0Cgarbqo7J0pw68zJ3KY9WZvJnwnWLdxhr1nfJstZU/nHdvfdP0Nqwd+GrEhSPZpVrsRUeBGPkLjcwB86ARcdbg3kfhmF/Cu6MtxJZZRjZ9HZgToA0E9fe8yj99u//7ObVauVXtZuT2GQW1Dm4hfb0kq8VYOLQKIuVxD1zkIG+QDSbboWIfTkd/+2uRAxNq9eN/U9SygwT/vPUmkEAoRQDaUpru0oHm60qnvwxiDmXdmAV3bEgy8urNIeonWlhJxvlAbOZPQ
 aQzR9x+O
 1SrZcFQr/7Av/exzcdgTJqtN/pCVnL230rqDyTgESVpW2uaZUh40czadD6UTUoEfEANoXEinm2RLCVKUR+Kb6hI6s9GhQb7qzdL7BjpBs0VdD19SCTmWPjnqa05UfPD/huBTZV6BIio93uw147LR7Qtim1OTo1wltgm77rmXQdqsE34/WXc2muUIoLOgpNXN47s9EXaUafkEhwfm8FsWv9iYZDRiWYGwPYE+E1L6AqUYwYQp7eVO6IkP9TIelA/GLMwYO5PuJC1bSO/k2G5dJCMBxnKH+OEKa1iUfkEyELadVvyluhk+8tUlcUJRoMcU+b3cOvwy1M23pSsc=
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
 arch/arm64/mm/fault.c            |  2 ++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4dfa42b7d053..20072f32677d 100644
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
index 0f3c5c7ca054..858f5d3e8f22 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -216,6 +216,8 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
 	if (pte_same(pte, entry))
 		return 0;
 
+	guard(kpkeys_hardened_pgtables)();
+
 	/* only preserve the access flags and write permission */
 	pte_val(entry) &= PTE_RDONLY | PTE_AF | PTE_WRITE | PTE_DIRTY;
 

-- 
2.51.2


