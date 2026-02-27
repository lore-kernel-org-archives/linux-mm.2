Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9614CFEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0291B6B00C9; Fri, 27 Feb 2026 12:57:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 000136B00CB; Fri, 27 Feb 2026 12:57:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7276B00CC; Fri, 27 Feb 2026 12:57:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CAA256B00C9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:57:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A13D6160824
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:52 +0000 (UTC)
X-FDA: 84490994784.13.03C3984
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id F1A7D20004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zKM07wpCFZuWX9df85Y87z5KfAMgvecnaARgkSGdnI0=;
	b=Y1Ke+HctGMCYGIURywP3SkWkE09lCm76vhvTrm6mUddMIcOAKTx4OYZmAD8nYHhMQpPYQY
	ip0iwuBJ5FHA1b0Z07ohD+DtJDRSmlD8+9Co7RiDIXd5QJDSt33j1KhYLNoeEMUKFLOb5s
	t/iP4yU4VuZV5NY6VJQtrICSzKQwFjw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215071; a=rsa-sha256;
	cv=none;
	b=ptoSLKi72Rr+dE3Yl1wOfJ5FmlOHLCCFlOL58Feg/kH32v8DNrmVcONpVxK5U4ISpGZrqi
	0t75albw+lEsapq4USEjdIRBsSmpZ2uLxLKh5Py7pxPHSudCu8hA0W1CCd1iwfNQIuk1HP
	eTkXXKjv7Dgpz7TIdGbk181j96ZXapg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D969F1516;
	Fri, 27 Feb 2026 09:57:43 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C7D9C3F73B;
	Fri, 27 Feb 2026 09:57:45 -0800 (PST)
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
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 27/30] arm64: kpkeys: Guard page table writes
Date: Fri, 27 Feb 2026 17:55:15 +0000
Message-ID: <20260227175518.3728055-28-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F1A7D20004
X-Rspamd-Server: rspam07
X-Stat-Signature: jwamrjg8n1aogkip4s1xatwkrn7gk876
X-Rspam-User: 
X-HE-Tag: 1772215070-28531
X-HE-Meta: U2FsdGVkX1+h2ItzDyb7Pj8XIkUELV5a8rDyy+Yvx/28rMgyJUUZdcl1flB9ztGE3A6khIU7ys7iJYFnLz4ww67rMwus6AcQZQ60teKRpVI1a4M7X75lKsg4kGjmACTEtT+6zqr1pA2Asz/XQoOKmGYrWec9uGF1snQHWFzwzIWm9VM8MWE9MamrUMx5n+j8xWQWYZlGhQ6nkbnojm/WZcTTdcoGXvcA2X2aVEZEXb+px+UpSZVYuhuev6oSZNaXgGXWMqYVFvUYN6q5ecAIEFaVmep4FDfDwlO8nlJ93t2flAuiivmjGgmu16WQsIayKKlDTfc73e1MjVZ2IVSxwBTrMc1swxFIOgtRDBIad01EQFHRBMlDfbYFo4LaKf8ON+XSdB8Y3/TkUdIX+HNG4ZlvqsHr5XENgFiI6pghgqwv7MOwg6IRuSjwHJ588oNrVh07mDZYVZkj66twmYoVI3E7cyV3FrJeFRBYrYraoqQ7KXviu6+H+B1MJ0XXxTKbC/ls3oz9LLWy6QUuGV9Mv5q7VFOLKIP5c4nWZ+sDdlitw9Abh5rW6PfFuHEPa3NZPKKGDnJtNNlJ8GGFhIHrWRWMy/WV6qe88zf217875QhXpJ5tuqg6j7E1spNACZdDV3FucPkEwzwAfl4ZfQXWZ5FGi+1GFr+zlwWnOOZo5I0WOKqUeJSlPvXvTrJMDN6jE4u5RFueEnbggDbGP2RHW7UuavzCuNpBZUp8xJU2k8ubrtHipuJkbNz/UkDVAqGUe7/nMZHHtrtLUOzaYQCz1vbrSVYJsOO9BTcyflqcvmbT5Yk1LRmefB2fYdCSl8bKLUYYeVUFZqiwRy00MSUgj0pcxFv6LbbL2Yx4W3X82kc8Iw12ciyL+H739aY0QQGC5FH1W+N3Y9Ax4YVgjDnaHXBRbKuPkUT7lqP/EI2QJFhSRcyP32/QEYtfKGtyrJWh2SvjH0fDn9E2oHUfQVs
 5+LjL1Q/
 WkmwkzTj2KA3xgC1lppvzphFeC64qYRQryA5/Um6s+StuXOhUkmEYJx7ciIG0dlI2L3ljUxyG/tsVXrgaejPhXHh63/k2xDKLIZirWA6Pd8PlT7SnFe467VbUXpHNbni4/M6GrVHdNaKSJhDzBxropp1RDzZ5P/+KgK3lIaRk2iEXBZqlpoCo0tkRmyKTrSZ55AXwn7IHws2WvvB+XbIWje1iZRtXOckPynaE
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
index b3e58735c49b..8c85e23223da 100644
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
@@ -363,6 +371,7 @@ static inline pte_t pte_clear_uffd_wp(pte_t pte)
 
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
@@ -890,6 +900,7 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
 		return;
 	}
 
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*pudp, pud);
 
 	if (pud_valid(pud))
@@ -971,6 +982,7 @@ static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
 		return;
 	}
 
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*p4dp, p4d);
 	queue_pte_barriers();
 }
@@ -1099,6 +1111,7 @@ static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
 		return;
 	}
 
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*pgdp, pgd);
 	queue_pte_barriers();
 }
@@ -1295,6 +1308,7 @@ static inline int __ptep_test_and_clear_young(struct vm_area_struct *vma,
 {
 	pte_t old_pte, pte;
 
+	guard(kpkeys_hardened_pgtables)();
 	pte = __ptep_get(ptep);
 	do {
 		old_pte = pte;
@@ -1343,7 +1357,10 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
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
@@ -1416,6 +1433,7 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
 {
 	pte_t old_pte;
 
+	guard(kpkeys_hardened_pgtables)();
 	do {
 		old_pte = pte;
 		pte = pte_wrprotect(pte);
@@ -1449,6 +1467,7 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
 {
 	pte_t old_pte;
 
+	guard(kpkeys_hardened_pgtables)();
 	do {
 		old_pte = pte;
 
@@ -1496,6 +1515,7 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
 	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
+	guard(kpkeys_hardened_pgtables)();
 	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
 #endif
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index be9dab2c7d6a..7e230499f7fe 100644
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
2.51.2


