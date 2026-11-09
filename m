Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B5460A2623
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vbUKJvs3
Received: by kanga.kvack.org (Postfix)
	id 5F7EC6B05D2; Mon,  9 Nov 2026 11:02:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F716B05D5; Mon,  9 Nov 2026 11:02:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4745F6B05D2; Mon,  9 Nov 2026 11:02:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19A9A6B05D2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:02:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57A6BA0760
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:02:11 +0000 (UTC)
X-FDA: 85416047262.01.5F2295A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 792FB1C0012
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:02:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vbUKJvs3;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5aexMwK+2MFktlu7rHzowEh/NG7elaL0zrvutdRtI8=;
	b=meQLwanP0tNI3e4pWavNzpPzo6Ssw0VaYZt+VIeaXF3Xm/UzwYOpu02DIVQXZNy/cdJ/NB
	NuEuh6bIdXg4s5to2wDpLSZ5qL6PvVKfr7HyYZhKCq1vzOt31YcjKiU3fPpZqbwwW+HlHw
	cQRPTpmuJHQSEt8wThqBiCXM1KEaMvE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240129;
	b=FkUBG7coXPRbK1rzyjqW2F5GAJFPTxZKV1XrHM1Rizh/iY1drQbqje2dbTTI2teyJGW2lL
	lLtS1uCDHiBkrBY1PlpbRWdXG5IptgDh7jzsJlsLtObWVX/RW+MI+CSebY3nKxiSaOH1zT
	OF2Nv0GpPD/9olo1WThYbx4ETb8VS9Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vbUKJvs3;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ACD7B2F;
	Mon,  9 Nov 2026 08:02:05 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D04EF3F632;
	Mon,  9 Nov 2026 08:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240128; bh=cUlLtdPRs8XVu22eeE08h4AwX9MJVfNOjzEFNCjlLx0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=vbUKJvs3Qdz7D4NxK50Ih0d1cPV51KEXxUyloY50+aDWWwJhRrfUaay3bbH4LO0E2
	 APQBVrEsm5vFl4V6V0bWwOAUCk5yKdsCeDwjC/t4h18LBIMif9t/QoAkawW5pH8UD3
	 ap4+IAAV8sS/IJmkte/B7IjY3MHrIxVKHmz+wawE=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:43 +0000
Subject: [PATCH RFC v10 18/22] arm64: kpkeys: Guard page table writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-18-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
In-Reply-To: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
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
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=4952;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=cUlLtdPRs8XVu22eeE08h4AwX9MJVfNOjzEFNCjlLx0=;
 b=MLBX1RjqBqwxlpGOI54Mr1paZcEmc9jPld6P5zWRz+PnxFR1FQTc2xDmuz69qpttX6tNinCHn
 5BEIdJg46dPCu+KVbvQiJPmvNs4SJAjCE4dVZM5yyeijEXoc3MIqP4j
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 792FB1C0012
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cj5ysswc1x1cecaptki9o5p3jc3kecc4
X-Rspam-User: 
X-HE-Tag: 1794240129-171458
X-HE-Meta: U2FsdGVkX1/qJHbC7W0nZycRwbSlgqMAsvVtNTzFIktncZBDzEBrrqT+k2eCywlhvssdF/G5AaoeXRsSdazxRCNZFiR+PXBqdOBhF5h4rhiXDCKmvt1N+SVXGIx+yABl9uatwDXMNjCo9d4CFmFmEyZSx9yA/MqIFfr2vMRrrB/9KoilUmULAt28gVLNgXQKiF+zbi1FhOhrDNcg8botrIW8ErSVTkY1mW62U/a6RO8HoK2MajUO6G97OLPzZahAze8fwRE6cZwiCEi+LJMveVMnHbZsKjj+8QcB3jYssa+jWlv/+aPRZfdbl7OfF71/0bawfrol/qWgoie+pV1TlrZMsGuxXsgs2fyfy597dZQEbkwmF1d01j+dXekx3UtD8FxTDHE22hsMbh8D/bKQRaQ0pu8shmjpgu7BEF5Bo/o51wgKjcwk4X1A8Z+ouLWUQ5HC+ePNUHzJ8KSGTncJTo7uSBTFjNHYHMcOKq+mN4AXngRFQLk/S28KA92gNyls3qfxeUd3K6UoYZkToddAa770lVgqvStHQGBWQg8YnqS5ayPuJjYwaFVKqidX5WtB1mGA7kK0O9vg7t9GimP9AVAk1SBpZMshlTUi+7gy45++bNnF5V8H+UAkV6sEbJ9X7XuoOieHt0uX5gQCh2ozXImB+/TPNUDppM7vD58rD7G33w5ED0+PAnAz+3/k4HISsaAjfi17ByJCApxxbbgJe2AgoK+cSiVUnvGM4N1voMMhSulLKAKM3tqwF4sI6ZVWsCCyM5NoUEymTs+P31ERNkCxWDBvdk7ZJvYmG4jylaIFX4X4LZ6dL653FVv+aSQpQP3NJyWJzR9AXEGQ/6PIoGg5EvNugWLyrMOJkPpu3VuDrm9P8stFGKgK3JdZTxrg72iWLdrMKpkkLvckFDQm+O2XieBGDGxFi7EhRP3KgsWr4Fni7sGEXLDAgJ8DnMvrawRW1ZNnP53sb+zoGmF
 Ip8tC092
 dMeFRViP7SYVgYhI5Hg5iMOApndDo8FVJR72IUcxzdhgTOJgeTKj1BqXkiSP8qAS1PbC40vyQS/mmOhTNV1JhA+5f+LiAMNyIdYtvePQfEgs4OQtngM/JMbCTutUoryudldHHqMb8QaYIJXNKSFQbdOx4E83nQ45KLDv4AaknM0Qu2E5Zgu/bKRH5WDpZucM98xa1lX4uBDSkiLNYJ71jpof39pnO3wUnica/uhuGx8YxuMKaSusEgnsRRtjc3H8c60vnfx7XQ6DjdFsNpkbWt3+adksQ45OgevYgz2aMQ9yItecT6s3hahscYu+7wXkBBdD+g212Tcs72BoiU4wosEClml/HHDV0YahFiZIVVKI9tlM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 23 ++++++++++++++++++++++-
 arch/arm64/mm/fault.c            | 17 ++++++++++-------
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a474c9fb485a..5f46d4cb3882 100644
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
@@ -360,6 +368,7 @@ static inline pte_t pte_clear_uffd(pte_t pte)
 
 static inline void __set_pte_nosync(pte_t *ptep, pte_t pte)
 {
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*ptep, pte);
 }
 
@@ -789,6 +798,7 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 	}
 #endif /* __PAGETABLE_PMD_FOLDED */
 
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*pmdp, pmd);
 
 	if (pmd_valid(pmd))
@@ -850,6 +860,7 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
 		return;
 	}
 
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*pudp, pud);
 
 	if (pud_valid(pud))
@@ -928,6 +939,7 @@ static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
 		return;
 	}
 
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*p4dp, p4d);
 	queue_pte_barriers();
 }
@@ -1053,6 +1065,7 @@ static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
 		return;
 	}
 
+	guard(kpkeys_hardened_pgtables)();
 	WRITE_ONCE(*pgdp, pgd);
 	queue_pte_barriers();
 }
@@ -1254,6 +1267,7 @@ static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
 {
 	pte_t old_pte, pte;
 
+	guard(kpkeys_hardened_pgtables)();
 	pte = __ptep_get(ptep);
 	do {
 		old_pte = pte;
@@ -1301,7 +1315,10 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
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
@@ -1374,6 +1391,7 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
 {
 	pte_t old_pte;
 
+	guard(kpkeys_hardened_pgtables)();
 	do {
 		old_pte = pte;
 		pte = pte_wrprotect(pte);
@@ -1407,6 +1425,7 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
 {
 	pte_t old_pte;
 
+	guard(kpkeys_hardened_pgtables)();
 	do {
 		old_pte = pte;
 
@@ -1454,6 +1473,7 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
 	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
+	guard(kpkeys_hardened_pgtables)();
 	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
 #endif
@@ -1784,6 +1804,7 @@ static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
 {
 	pteval_t old = 0;
 
+	guard(kpkeys_hardened_pgtables)();
 	if (!try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte)))
 		return false;
 
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index b22736853fcd..37a4d8187aa1 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -239,13 +239,16 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
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
2.56.0


