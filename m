Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 251DFC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 976666B0131; Wed, 29 Jul 2026 10:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928D76B0133; Wed, 29 Jul 2026 10:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815DA6B0134; Wed, 29 Jul 2026 10:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 432796B0131
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:52:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F181D1C0E5D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:52 +0000 (UTC)
X-FDA: 85041735744.26.23B0F6C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 598BFC0003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rUpYNz0T;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FKguTFCsnOFkdkjIncE9Q6Ef3LOicIIJB0oiH7LdGs4=;
	b=8HTGF5SxNVuWfLDv+BFMVZvi5XlffoK5HayaScYADr2T4mCL8j098+8SBKglzQvHedJLga
	+KINsevPU0+b5BCxgvTtBQSNbwh7UBGr6sSewnoLVmjFqRSBVyjWR/IVwjW5PEZFpHkqr6
	KMaxmnEZzc/yrdFgUGnx+qGwt6MdxCQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rUpYNz0T;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327951;
	b=pwzzebQCK7WsfYta+U76OrFN5odOOybB7LDV1QNHH7ecStqm//LnInzIweqeuiqLsZuVd1
	sH5FpBSGUlAy9qrzwGsQQgXd2FWgbwKh/xZPat4WVMVa0oNxBYhIVHQMm2wozhe3FdFwfr
	YEdSp6+W5qX8RwBYctX3aCarjwcOYq8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BCFE1688;
	Wed, 29 Jul 2026 05:25:46 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 11C0C3F66F;
	Wed, 29 Jul 2026 05:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327950; bh=a14FrpmvTbkDM2WM1GK+a6PKnmX488cSGRU0OuH2A+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUpYNz0TZDJalHchPWZr0GzI+IPFYH2IZ7AYb7yJq9q3hCGk1lweeXfMuebRxY9KN
	 iNN4REnvWhAPql4rKCN/s2BojEptfQQmrNjOCFBHtHLUsYhNJVWWH2yXJ8nhjpbOBy
	 G1KfwUu7eCP136o7y+kFgYCnTN3OWCsgfXEnzfNU=
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
Subject: [PATCH 10/17] arm64/mm: Standardize printing for pgtable entries
Date: Wed, 29 Jul 2026 17:54:45 +0530
Message-ID: <20260729122452.3797443-11-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 598BFC0003
X-Stat-Signature: ugmhmq5g4pby69ejnbox3o17rfjgaq99
X-HE-Tag: 1785327951-364996
X-HE-Meta: U2FsdGVkX1/f92jNpZyJxZ3UP7NiBpAUWYlfFWsb8umJzvwdnqkZqYYiu83TI7rImRdCVpAywusGCO+hkeU0LLckW8b2pEShsKh1AL8vHpyNjvtNSEqWAOugQ5z9Yd5k/R22HDGGjNeiksYaJSxdjoEIRjdU4JtVbtjbw6qH135cvXdVcd01XdwfTi10a9ua+54AlQWEOHTEh7QFLS+HCwUty460Fap0DlKMxsXvLAE5kCPzia6A79lGMbHGYvhLwIvU/Ix+yiSA87SXABLM2Ba7/IpmBTatA0D61G/HXDLAQlj+Dfb+pa7rmR7LkkXgWATBUqr9iTiX7waKeujQAUtzjunQTiUv734WT0UBP5czWhxuGmP8251NIzF20cjsfx2c4tYVx/Y9lxd/2oXD5roj/o5Sl0vDcejtHVdaT4R6G/LnMNGNd6Fgb/7Iic9vKdMRKQaZOSbhkb0X8KZDoajLe+PeYuGbr5i11/BKbqUO7cS9bi2ALAPkYq77ADd9P8FGjb8Ag17m2sd8Yax71bvZrp2KtcJpzvIbkWmuiFxa+JEzi47bfdwUBu3n6DnQCYiwpl0091ugvGPyNTG7LcppMmd6+IQLS2IOobF3XkNkazoU0n2Co5K4IhTB+jVxePoQSZmiG7lqSYpbr/EQgJLcOC9/APggRArW2iK1LtmY0xjbSreuJA1Nc0CYxgS+GpFvg7wFmNdiM3cH/XfsXnVkhhQVWCWAuvkOUz5sqoNXeQ02WXuyE5Hs7ELzNbbHUca/hp/gJHeVlYF5KL80zcujISO+GKBym59ybvRik6HU0uKj3MljhjvKfeYugBa5yts/9rbbahwrusOYex3j7uzcgagirGtKjzlmttK/LXMk08YCJJ2RPmYylstxzLQ6sDD1K+bHk7QceOruBajQGk20uTK1vLCnjr15zH5HGmmG8mzroGWdZxb3MacGHamp120BaLUG83LE641+Lnh
 8k3nCKRd
 UWtYBMAIPsmBv/32KgDI11JDuhd1fWAhhOTr4MR/nGKyr5zwowkEGhLCEhFzOgyb/7UgciUoal6ZWX6cJEq2FEVw4HphK4xqXqukia0LIb53Qqt4nvcNgXOaxeQ3c2urh8HpQ9T80R6CKWZNt1CcHuo78XTrzMIXdvojMyg3Pr1I6CLNfGSCV5+v9wk+F2hLFsdQhAzcJYtF+H4BnTMjMJzfvzXtJaSjAJwZuZVjBx+bYVRDfCe/Bp+WbzFQOyeabgVHLvJflFEUPgmDjjW9iqrhuY3ZeYVtFx7Zs707qy02Pto5avBgQqMMZ8QrVJ+WDAwIpF8tDxzVHvaaDOjx6MFa2dWm/3hL7Lz4YDu6fIy5WbWS6ckrL9QGHPRqGKmPYbgBChSNIcUpcibsyiIQvXGK/ckIoQuluyPlJlv6X4CH3zh238V70ocqsmacO0F2Tx22j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Standardize printing for pgtable entries using recently introduced generic
helper ptval_bytes_to_hex_str() in core MM which automatically enables 128
bits entries later when required. While here also drop unused pte_ERROR().

First move all required helpers in core MM into a common header file which
could then be used in platforms.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 40 ++++++++++++++------------------
 arch/arm64/mm/fault.c            | 21 +++++++++++++----
 arch/arm64/mm/mmu.c              | 16 +++++++++++++
 include/linux/mm_types.h         | 40 ++++++++++++++++++++++++++++++++
 mm/memory.c                      | 40 --------------------------------
 5 files changed, 90 insertions(+), 67 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 39635f9550c2..2270a3e4cc13 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -157,9 +157,6 @@ static inline void pgprot_write(pgprot_t *prot, pgprot_t val)
 	__flush_tlb_range(vma, address, address + PMD_SIZE, PMD_SIZE, 2,	\
 			  TLBF_NOBROADCAST | TLBF_NONOTIFY | TLBF_NOWALKCACHE)
 
-#define pte_ERROR(e)	\
-	pr_err("%s:%d: bad pte %016llx.\n", __FILE__, __LINE__, pte_val(e))
-
 #ifdef CONFIG_ARM64_PA_BITS_52
 static inline phys_addr_t __pte_to_phys(pte_t pte)
 {
@@ -455,6 +452,8 @@ bool pgattr_change_is_safe(pteval_t old, pteval_t new);
 static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep,
 					   pte_t pte)
 {
+	char pte_str_old[PTVAL_STR_MAX];
+	char pte_str[PTVAL_STR_MAX];
 	pte_t old_pte;
 
 	if (!IS_ENABLED(CONFIG_DEBUG_VM))
@@ -472,15 +471,17 @@ static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep,
 	 * (__ptep_set_access_flags safely changes valid ptes without going
 	 * through an invalid entry).
 	 */
+	ptval_to_str(pte_str, pte_val(pte));
+	ptval_to_str(pte_str_old, pte_val(old_pte));
 	VM_WARN_ONCE(!pte_young(pte),
-		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: racy access flag clearing: %s -> %s",
+		     __func__, pte_str_old, pte_str);
 	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
-		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: racy dirty state clearing: %s -> %s",
+		     __func__, pte_str_old, pte_str);
 	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
-		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: unsafe attribute change: %s -> %s",
+		     __func__, pte_str_old, pte_str);
 }
 
 static inline void __sync_cache_and_tags(pte_t pte, unsigned int nr_pages)
@@ -901,6 +902,10 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 	return (unsigned long)__va(pmd_page_paddr(pmd));
 }
 
+enum pgtable_level;
+
+void ptval_ERROR(const char *file, int line, enum pgtable_level level, ptval_t val);
+
 /* Find an entry in the third-level page table. */
 #define pte_offset_phys(dir, addr)	(pmd_page_paddr(pmdp_get(dir)) + \
 					 pte_index(addr) * sizeof(pte_t))
@@ -915,10 +920,7 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 #define pte_offset_kimg(dir,addr)	((pte_t *)__phys_to_kimg(pte_offset_phys((dir), (addr))))
 
 #if CONFIG_PGTABLE_LEVELS > 2
-
-#define pmd_ERROR(e)	\
-	pr_err("%s:%d: bad pmd %016llx.\n", __FILE__, __LINE__, pmd_val(e))
-
+#define pmd_ERROR(e)		ptval_ERROR(__FILE__, __LINE__, PGTABLE_LEVEL_PMD, pmd_val(e))
 #define pud_none(pud)		(!pud_val(pud))
 #define pud_bad(pud)		((pud_val(pud) & PUD_TYPE_MASK) != \
 				 PUD_TYPE_TABLE)
@@ -1011,9 +1013,7 @@ static inline bool mm_pud_folded(const struct mm_struct *mm)
 }
 #define mm_pud_folded  mm_pud_folded
 
-#define pud_ERROR(e)	\
-	pr_err("%s:%d: bad pud %016llx.\n", __FILE__, __LINE__, pud_val(e))
-
+#define pud_ERROR(e)		ptval_ERROR(__FILE__, __LINE__, PGTABLE_LEVEL_PUD, pud_val(e))
 #define p4d_none(p4d)		(pgtable_l4_enabled() && !p4d_val(p4d))
 #define p4d_bad(p4d)		(pgtable_l4_enabled() && \
 				((p4d_val(p4d) & P4D_TYPE_MASK) != \
@@ -1139,9 +1139,7 @@ static inline bool mm_p4d_folded(const struct mm_struct *mm)
 }
 #define mm_p4d_folded  mm_p4d_folded
 
-#define p4d_ERROR(e)	\
-	pr_err("%s:%d: bad p4d %016llx.\n", __FILE__, __LINE__, p4d_val(e))
-
+#define p4d_ERROR(e)		ptval_ERROR(__FILE__, __LINE__, PGTABLE_LEVEL_P4D, p4d_val(e))
 #define pgd_none(pgd)		(pgtable_l5_enabled() && !pgd_val(pgd))
 #define pgd_bad(pgd)		(pgtable_l5_enabled() && \
 				((pgd_val(pgd) & PGD_TYPE_MASK) != \
@@ -1268,9 +1266,7 @@ p4d_t *p4d_offset_lockless_folded(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
 
 #endif  /* CONFIG_PGTABLE_LEVELS > 4 */
 
-#define pgd_ERROR(e)	\
-	pr_err("%s:%d: bad pgd %016llx.\n", __FILE__, __LINE__, pgd_val(e))
-
+#define pgd_ERROR(e)		ptval_ERROR(__FILE__, __LINE__, PGTABLE_LEVEL_PGD, pgd_val(e))
 #define pgd_set_fixmap(addr)	((pgd_t *)set_fixmap_offset(FIX_PGD, addr))
 #define pgd_clear_fixmap()	clear_fixmap(FIX_PGD)
 
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 7aff70c5479e..a38f4f1eacc4 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -14,6 +14,7 @@
 #include <linux/kfence.h>
 #include <linux/signal.h>
 #include <linux/mm.h>
+#include <linux/memory.h>
 #include <linux/hardirq.h>
 #include <linux/init.h>
 #include <linux/kasan.h>
@@ -130,6 +131,11 @@ static inline unsigned long mm_to_pgd_phys(struct mm_struct *mm)
  */
 static void show_pte(unsigned long addr)
 {
+	char pgd_str[PTVAL_STR_MAX];
+	char p4d_str[PTVAL_STR_MAX];
+	char pud_str[PTVAL_STR_MAX];
+	char pmd_str[PTVAL_STR_MAX];
+	char pte_str[PTVAL_STR_MAX];
 	struct mm_struct *mm;
 	pgd_t *pgdp;
 	pgd_t pgd;
@@ -156,7 +162,8 @@ static void show_pte(unsigned long addr)
 		 vabits_actual, mm_to_pgd_phys(mm));
 	pgdp = pgd_offset(mm, addr);
 	pgd = pgdp_get(pgdp);
-	pr_alert("[%016lx] pgd=%016llx", addr, pgd_val(pgd));
+	ptval_to_str(pgd_str, pgd_val(pgd));
+	pr_alert("[%016lx] pgd=%s", addr, pgd_str);
 
 	do {
 		p4d_t *p4dp, p4d;
@@ -169,19 +176,22 @@ static void show_pte(unsigned long addr)
 
 		p4dp = p4d_offset(pgdp, addr);
 		p4d = p4dp_get(p4dp);
-		pr_cont(", p4d=%016llx", p4d_val(p4d));
+		ptval_to_str(p4d_str, p4d_val(p4d));
+		pr_cont(", p4d=%s", p4d_str);
 		if (p4d_none(p4d) || p4d_bad(p4d))
 			break;
 
 		pudp = pud_offset(p4dp, addr);
 		pud = pudp_get(pudp);
-		pr_cont(", pud=%016llx", pud_val(pud));
+		ptval_to_str(pud_str, pud_val(pud));
+		pr_cont(", pud=%s", pud_str);
 		if (pud_none(pud) || pud_bad(pud))
 			break;
 
 		pmdp = pmd_offset(pudp, addr);
 		pmd = pmdp_get(pmdp);
-		pr_cont(", pmd=%016llx", pmd_val(pmd));
+		ptval_to_str(pmd_str, pmd_val(pmd));
+		pr_cont(", pmd=%s", pmd_str);
 		if (pmd_none(pmd) || pmd_bad(pmd))
 			break;
 
@@ -190,7 +200,8 @@ static void show_pte(unsigned long addr)
 			break;
 
 		pte = __ptep_get(ptep);
-		pr_cont(", pte=%016llx", pte_val(pte));
+		ptval_to_str(pte_str, pte_val(pte));
+		pr_cont(", pte=%s", pte_str);
 		pte_unmap(ptep);
 	} while(0);
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 1127917c554b..fd2db5f2e6a5 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2337,6 +2337,22 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
 	cpu_uninstall_idmap();
 }
 
+static const char * const pgtable_level_name[] = {
+	[PGTABLE_LEVEL_PTE] = "pte",
+	[PGTABLE_LEVEL_PMD] = "pmd",
+	[PGTABLE_LEVEL_PUD] = "pud",
+	[PGTABLE_LEVEL_P4D] = "p4d",
+	[PGTABLE_LEVEL_PGD] = "pgd",
+};
+
+void ptval_ERROR(const char *file, int line, enum pgtable_level level, ptval_t val)
+{
+	char str[PTVAL_STR_MAX];
+
+	ptval_to_str(str, val);
+	pr_err("%s:%d: bad %s %s.\n", file, line, pgtable_level_name[level], str);
+}
+
 #ifdef CONFIG_ARCH_HAS_PKEYS
 int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 {
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b18c2b2e7d2c..1025b9140c0b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -2001,4 +2001,44 @@ static inline unsigned long mmf_init_legacy_flags(unsigned long flags)
 	return flags & MMF_INIT_LEGACY_MASK;
 }
 
+static inline void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
+{
+	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
+		snprintf(buf, buf_size, "overflow");
+		return;
+	}
+
+	switch (entry_size) {
+	case sizeof(u32):
+		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
+		break;
+	case sizeof(u64):
+		snprintf(buf, buf_size, "%016llx", *(const u64 *)entry);
+		break;
+#if defined(__SIZEOF_INT128__)
+	case sizeof(u128):
+		snprintf(buf, buf_size, "%016llx%016llx",
+			 (unsigned long long)(*(const u128 *)entry >> 64),
+			 (unsigned long long)*(const u128 *)entry);
+		break;
+#endif
+	default:
+		snprintf(buf, buf_size, "unsupported");
+		break;
+	}
+}
+
+#define ptval_to_str(buf, val)								\
+	do {										\
+		auto __val = (val);							\
+											\
+		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
+	} while (0)
+
+#if defined(__SIZEOF_INT128__)
+#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
+#else
+#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
+#endif
+
 #endif /* _LINUX_MM_TYPES_H */
diff --git a/mm/memory.c b/mm/memory.c
index 598d0e588e9a..253db4143f9c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -519,46 +519,6 @@ static bool is_bad_page_map_ratelimited(void)
 	return false;
 }
 
-static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
-{
-	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
-		snprintf(buf, buf_size, "overflow");
-		return;
-	}
-
-	switch (entry_size) {
-	case sizeof(u32):
-		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
-		break;
-	case sizeof(u64):
-		snprintf(buf, buf_size, "%016llx", *(const u64 *)entry);
-		break;
-#if defined(__SIZEOF_INT128__)
-	case sizeof(u128):
-		snprintf(buf, buf_size, "%016llx%016llx",
-			 (unsigned long long)(*(const u128 *)entry >> 64),
-			 (unsigned long long)*(const u128 *)entry);
-		break;
-#endif
-	default:
-		snprintf(buf, buf_size, "unsupported");
-		break;
-	}
-}
-
-#define ptval_to_str(buf, val)								\
-	do {										\
-		auto __val = (val);							\
-											\
-		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
-	} while (0)
-
-#if defined(__SIZEOF_INT128__)
-#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
-#else
-#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
-#endif
-
 static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
 {
 	char pgd_str[PTVAL_STR_MAX];
-- 
2.43.0


