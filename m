Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 130E5EFB7FB
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733226B0089; Tue, 24 Feb 2026 00:12:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70A546B008A; Tue, 24 Feb 2026 00:12:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B256B008C; Tue, 24 Feb 2026 00:12:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 529A46B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:12:33 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE9681A0188
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:12:32 +0000 (UTC)
X-FDA: 84478179744.16.7257210
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 36F02140007
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:12:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771909951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W2iPh1K2LTc1o70lQa7JOFynl3p68eA20V9ZtDN6OZM=;
	b=ZMqmws3vGwKlzAM2MO/udDkLmYyw9LQBVk0a8bzGzlawzoIyPiW/gWT7IAQD9udQgsUDAd
	cSFtCrDbkKB7Xy+h48PS0hOdgICrZORd1AIiZ59ebHmfCPDszQfpAf46P65CZSLYyYW86S
	wm8FdH18fkPb8TuuMHqlE9ql6EFLRZI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771909951; a=rsa-sha256;
	cv=none;
	b=MzAmUcbK1eLhMriUjHuEDSic/+faxUP13pQ9WLCwo6QX4NHSuF7HidE7CrzXSE0cd7sHpB
	vq8JX/g5gihT46j4SOIKS9mTX5+W9xC1fuEM4Oeeyj/pw7Pw83HYz4SFmRrkdJOWzA97V/
	9n6RyEBIzPBbM9Mq8HWIniAxIL2h2IQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D9552497;
	Mon, 23 Feb 2026 21:12:23 -0800 (PST)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0458E3F7BD;
	Mon, 23 Feb 2026 21:12:25 -0800 (PST)
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
Subject: [RFC V1 01/16] mm: Abstract printing of pxd_val()
Date: Tue, 24 Feb 2026 10:41:38 +0530
Message-ID: <20260224051153.3150613-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224051153.3150613-1-anshuman.khandual@arm.com>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 36F02140007
X-Stat-Signature: meuw7bh98q3mt66bb7gf6ikurasrugcz
X-HE-Tag: 1771909950-441154
X-HE-Meta: U2FsdGVkX1+M5UUGH2EsLaVB8+T+6nhsh0XmVP7XSN7uIx33PqBPqS4mQNOBXTwWF8907QsUJOytv0MB8EnaHo2ZGSjN8y6e06wD2SbGLjPl4QckYCPkNDKMyUD4peEQCzgtR+ss+JxC0KskFdzZg4K3xcZnsgjGpncHYwgYVKaOQOknvvXh04aKhw/68NutrLgy5+Etb3iG7NCTJgd3glYjfRLC0M31fu97U8VcZXEz1EdgPPVPFF1TaYka4ygVaK+OrV+FKrNsMl82HFgvNZMR4hcLjGRTwFHvF6jNSF8Aw0cJJI9MBB1pMtCW80A8ayWSu/XSbdFMfzi7kINo62tbJ0z0W8M72B97byOVAfLj3Gx8WezoEwD+jamDpe18yNGK0flfySxYlRtp31ZSS3VW8Vjvtn7TqXnaqkTrRDNauVPQyJuq+ecQd690SysR+ECVTtrExpz/OVdn1rLQbMUsco8j1Bmc6Wh12q5Nfs96V6rnJts/f5ozpMmZ5A4ULvbsjGpNfxz00yBRc12uAa39JY+r4Qd2SjspNLfbDyyJi0HWO6tlTws2YcTYnrm4cyh/u6t0PdtCXl3hWHvnAb4e7G9mQip0Je2GB+ZIQzTtgXKbA+ei7YfMnNwYz3T6M6rTehYS2+hbB42vpWe7QVZNW6GGgDyxiShe0pW1JYOoRILtuuHOEU6ZeZ0LE//t4tdNmHqAZM0dwP/NAMrsJLpay/Tisn6l9geQ8K/eB+y0Mr3POFMcn/ZWvWAkaFaJoGYNapYI/35NtPXqjgN86d4Nb13YV4VjrsRoh9PISI4/Z36jTXv5pAr1OgdA2C/XVttMGTnOwvett0mG2uOL+uA3sor500vOyg3aXI8Hm6G/yYf96ZFd4eDMODm7qn9HZ2nrMp09LtiOGMh96S56oVswRHekxwsnSz0FiWd14h0mJ4n6ZoRnMJzSYHQHJmaTNbKhfVF9Hb39Cz1NUOL
 CAj/PKPq
 IczVq0mOuqPoZ7i8Un2TCACrHwofJ262RYwqrJeFPAPARlHxvttOGUkJZiPvVjyd5WVlTxhmRLtDJDIyNwfpsVe5xitCyXd2Xqmj47Zx8eGAexzWBzECq7F6I4Ke3S2o/V2DyHKF1JJYfU4TQeWzqck9UYHU20Z4+sG6OK+U87dZI3b1ucnRHc6WCoqTpy0h4fCGr22n5gHhfuiR8f18jIvXuvktRN9ztqvErBDX1W9mShlprGT7Z53Uyw64diQjFVdoE6bsAzyiF93M0roQCDJoXW5NT9TQ2m917NPhosAEczCiqDMD7u2EPjU90UpkxCf4hF9Jp12XVYGJ8NDDhl/JUhJPu2Kk6L9EhIuA4th6h68Fm5JnrLDU+CjIp3qvaMhTZ1MwuTPn1+vC25MytqWmw5g==
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

Besides there is also an assumption about pxd_val() being always capped
at 'unsigned long long' size but that will not work for D128 pgtables.
Just increase its size to u128 if the compiler supports via a separate
data type pxdval_t which also defaults to existing 'unsigned long long'.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 include/linux/pgtable.h |  5 +++++
 mm/memory.c             | 29 +++++++++++++++++++----------
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index a50df42a893f..da17139a1279 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -17,6 +17,11 @@
 #include <asm-generic/pgtable_uffd.h>
 #include <linux/page_table_check.h>
 
+#ifndef __PRIpte
+#define __PRIpte		"016llx"
+#define __PRIpte_args(val)	((u64)val)
+#endif
+
 #if 5 - defined(__PAGETABLE_P4D_FOLDED) - defined(__PAGETABLE_PUD_FOLDED) - \
 	defined(__PAGETABLE_PMD_FOLDED) != CONFIG_PGTABLE_LEVELS
 #error CONFIG_PGTABLE_LEVELS is not consistent with __PAGETABLE_{P4D,PUD,PMD}_FOLDED
diff --git a/mm/memory.c b/mm/memory.c
index 07778814b4a8..cfc3077fc52f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -532,9 +532,15 @@ static bool is_bad_page_map_ratelimited(void)
 	return false;
 }
 
+#ifdef __SIZEOF_INT128__
+	typedef u128 pxdval_t;
+#else
+	typedef unsigned long long pxdval_t;
+#endif
+
 static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
 {
-	unsigned long long pgdv, p4dv, pudv, pmdv;
+	pxdval_t pgdv, p4dv, pudv, pmdv;
 	p4d_t p4d, *p4dp;
 	pud_t pud, *pudp;
 	pmd_t pmd, *pmdp;
@@ -548,7 +554,7 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
 	pgdv = pgd_val(*pgdp);
 
 	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
-		pr_alert("pgd:%08llx\n", pgdv);
+		pr_alert("pgd:%" __PRIpte "\n", __PRIpte_args(pgdv));
 		return;
 	}
 
@@ -557,7 +563,8 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
 	p4dv = p4d_val(p4d);
 
 	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
-		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
+		pr_alert("pgd:%" __PRIpte "p4d:%" __PRIpte "\n",
+			 __PRIpte_args(pgdv), __PRIpte_args(p4dv));
 		return;
 	}
 
@@ -566,7 +573,8 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
 	pudv = pud_val(pud);
 
 	if (!pud_present(pud) || pud_leaf(pud)) {
-		pr_alert("pgd:%08llx p4d:%08llx pud:%08llx\n", pgdv, p4dv, pudv);
+		pr_alert("pgd:%" __PRIpte "p4d:%" __PRIpte "pud:%" __PRIpte "\n",
+			 __PRIpte_args(pgdv), __PRIpte_args(p4dv), __PRIpte_args(pudv));
 		return;
 	}
 
@@ -580,8 +588,9 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
 	 * doing another map would be bad. print_bad_page_map() should
 	 * already take care of printing the PTE.
 	 */
-	pr_alert("pgd:%08llx p4d:%08llx pud:%08llx pmd:%08llx\n", pgdv,
-		 p4dv, pudv, pmdv);
+	pr_alert("pgd:%" __PRIpte "p4d:%" __PRIpte "pud:%" __PRIpte "pmd:%" __PRIpte "\n",
+		 __PRIpte_args(pgdv), __PRIpte_args(p4dv),
+		 __PRIpte_args(pudv), __PRIpte_args(pmdv));
 }
 
 /*
@@ -597,7 +606,7 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
  * page table lock.
  */
 static void print_bad_page_map(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long long entry, struct page *page,
+		unsigned long addr, pxdval_t entry, struct page *page,
 		enum pgtable_level level)
 {
 	struct address_space *mapping;
@@ -609,8 +618,8 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
 
-	pr_alert("BUG: Bad page map in process %s  %s:%08llx", current->comm,
-		 pgtable_level_to_str(level), entry);
+	pr_alert("BUG: Bad page map in process %s  %s:%" __PRIpte, current->comm,
+		 pgtable_level_to_str(level), __PRIpte_args(entry));
 	__print_bad_page_map_pgtable(vma->vm_mm, addr);
 	if (page)
 		dump_page(page, "bad page map");
@@ -695,7 +704,7 @@ static void print_bad_page_map(struct vm_area_struct *vma,
  */
 static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long pfn, bool special,
-		unsigned long long entry, enum pgtable_level level)
+		pxdval_t entry, enum pgtable_level level)
 {
 	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
 		if (unlikely(special)) {
-- 
2.43.0


