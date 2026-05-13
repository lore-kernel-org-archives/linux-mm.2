Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B39E7CD484C
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268856B008A; Wed, 13 May 2026 00:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23FD66B008C; Wed, 13 May 2026 00:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17D346B0092; Wed, 13 May 2026 00:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C2DC6B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:46:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D2D691A0721
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:46:20 +0000 (UTC)
X-FDA: 84761160120.24.A4268C1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 26A97180007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:46:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="JfI4UA/S";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778647579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ApRpJ5CgTvyAvUoBge/pm4gZOB0vW5sBGLScXsfmJtY=;
	b=p54FLVfWrETsHOhSOUpo22gCINCAOh8YsuQoRb4auARpQBImxHigcGOw+mJO7/nPbBFF57
	7ydDpYi8+ojrQraGJlL2N19OSDwoS2snAO8avjkmBxn0bWDIjQeZUGxbVIoTBid3/9T92Y
	KE+Pz6/8XLJW6nFUPJc/TX/4J4lF6Lk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778647579; a=rsa-sha256;
	cv=none;
	b=6uI8d6DHdf0pkNvGpCL1bsLA9YqF47f7KrOR0+IJ3qs8yR+b5Te1J+CFTe8/ct26su+Phu
	IflpU4m91xN3N1DGkYrlMB5A+TIOY+bPZzJI1A4Xc2+QX3hFhGjH19ePt4jIhLFVwUWMss
	kBqXDWSA8j95of9ko1uELv1rMHIgZ8s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="JfI4UA/S";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EDAA5153B;
	Tue, 12 May 2026 21:46:12 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7A6093F7B4;
	Tue, 12 May 2026 21:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778647578; bh=4xGOtuj2CVRhi0hzN+I2vi5eDNTXZt1P2D73d9+j0uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfI4UA/SaD7Ajfjfh8yxTqHtbVtcSTUAUubWw255DzWMMHIK+tDyVRDHMGgEPbThu
	 g5xJ1vn3PtBxTFINgPZVi4l1xZLWtu1ZEA4oSQ5YfFlKS2lFXww/XDbf/thYdJC3ps
	 e6KlfoTJccw+cNHmqIGPHxwbW4eztz0qPH5SFvQU=
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
Subject: [RFC V2 01/14] mm: Abstract printing of pxd_val()
Date: Wed, 13 May 2026 10:15:34 +0530
Message-ID: <20260513044547.4128549-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513044547.4128549-1-anshuman.khandual@arm.com>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 26A97180007
X-Stat-Signature: ysyb9nhqeyzwnhpqb8bay1ou7jk6cc8p
X-Rspam-User: 
X-HE-Tag: 1778647578-400973
X-HE-Meta: U2FsdGVkX1/dvoepPLm/roWrTtptv3vZLq2+e9irjazgWhosuPtUdp9kyhO/wZ45KWqACGHMnkOB+eYrORrLNvBVPzEoUdDSzTBGEFiZp1CJxbbGnegtXlO+ND+n5aL8+Qq8tc++R6B2RT0yuPrCySTg/zaVEAjHJzUhv06oPCTfr2+rIjFgd7mgbKGShuDIynG7/i7NoiBYLD9UzjNtK17Z180VCf70SkCsRlHOCyjiak4V/7iG3fQsQ1a4rGR3wwfqxB95sV0pz1vP8t6qYDDMdIfzeZJW5wzwo7TWVIuAfZkGs0YvycTejS5qA+PFYc4vWWdgA9QCerOAkL5UBS1hsZ9JJ7PmsTFmHotpNbVQB9zAv+GxPDj9ERrJYUPRkl78oBr/3nmBFf0cR08BhWVmdDeqbzISFqJxgVf59nwye26XHZANwH27V5oKa2sdRiHp7AxlKz3MEU9OACKXezRjgxd8aDWwwZvVHJw/5ZFBYLORYXU1LUijP/1RJM8T/V/mP66qB/L82bof6TpoxmeAROXeajvxpf0HROw5lna5gctKrpG6CAauPuP7zPWAhpdA2CzRVl1oS1Krw7ZzuMc9ped8zjcVh/MWu67IfGLOG8E9Zzbw03SO1QPRqIQbxGN/UTprm9tivmtoh/ApoS8wW1/5GZ7J2NBSaAQ5SFC2MnXTkE7K+hEW/8UALDn6DsueK+4RMA4cgJDGSQL0OVZGDffcmw2zhQqLIyzKl+t5qD0xHZuDM7NRnvwIi5lMrFUr3oGc+bL4HuFLgQ+vQ7sw3gN3uOpILO6y6ogHd6BUvySstF5ThQqdgVXoqpGuOaE48N5kbR3JWkO8/sJrRAkd68/nV9/gjPcAig7lJaJ3W1HUI89e/vsznDKoJt5IQ7lh1EKUqn1bbL1gtd8GQrOTGoRSh1jX2gREWhRbeKVZgY6rZrMHAvXWyU9fOB4kG4Fouqrt1IyOG/8SK1K
 EcV8WDeu
 tHeBJ02IuBQ2/dBHIbhhsoEdCY9+izhqmDXFDQv8lU3Iy/mT37DS/+vKjbUGsO17Xozvup4xqkOJPapdwEtrGVk+lmKSabhEBVgFUeuXO/Jes84xL3qW55d/FcfXb/kvPvxhp7WwYVwWUwwnCb9uimoaNlNrNwzOutdu6NpvcE998z2PgIK+uiqZ1fTYkonBPf57cr74rN09OzAGJmQlOSWt7fy3gqIDRIjzO34HTpCbnT4iF+pbuNEbC0PeiBCr5o+R0gYynBTrP1SGXk3M+SKer1kqerd3cUqK3Eo4mkjMEXoPOybOv7r5+qNQRkSJpUuTTZPRWWsNVyCQm4st4ccj26El/yAr0r9/2+e3xX+p7JZsLJy/KmwgicqMMljrtVC5bYnWrFaSCSs0AawuDh3EXcCDPsc965jUos50NGd0J4eHOiYjzmCU7UZinhLEm+lAdaSpHVppDh5LRRO5MuinmZiF1iXFlqAFSJgiCIcc6mHQ=
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
Changes in RFC V2:

- Moved pxdval_t definition inside generic page table header per Mike
- Restored print format in __print_bad_page_map_pgtable() per Usama
- Renamed __PRIpte as __PRIpxx per David

 include/linux/pgtable.h | 11 +++++++++++
 mm/memory.c             | 23 +++++++++++++----------
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..a738048128e7 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -17,6 +17,17 @@
 #include <asm-generic/pgtable_uffd.h>
 #include <linux/page_table_check.h>
 
+#ifdef __SIZEOF_INT128__
+typedef u128 pxdval_t;
+#else
+typedef unsigned long long pxdval_t;
+#endif
+
+#ifndef __PRIpxx
+#define __PRIpxx		"016llx"
+#define __PRIpxx_args(val)	((u64)val)
+#endif
+
 #if 5 - defined(__PAGETABLE_P4D_FOLDED) - defined(__PAGETABLE_PUD_FOLDED) - \
 	defined(__PAGETABLE_PMD_FOLDED) != CONFIG_PGTABLE_LEVELS
 #error CONFIG_PGTABLE_LEVELS is not consistent with __PAGETABLE_{P4D,PUD,PMD}_FOLDED
diff --git a/mm/memory.c b/mm/memory.c
index ea6568571131..7b6ee3b847a0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -521,7 +521,7 @@ static bool is_bad_page_map_ratelimited(void)
 
 static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
 {
-	unsigned long long pgdv, p4dv, pudv, pmdv;
+	pxdval_t pgdv, p4dv, pudv, pmdv;
 	p4d_t p4d, *p4dp;
 	pud_t pud, *pudp;
 	pmd_t pmd, *pmdp;
@@ -535,7 +535,7 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
 	pgdv = pgd_val(*pgdp);
 
 	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
-		pr_alert("pgd:%08llx\n", pgdv);
+		pr_alert("pgd:%" __PRIpxx "\n", __PRIpxx_args(pgdv));
 		return;
 	}
 
@@ -544,7 +544,8 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
 	p4dv = p4d_val(p4d);
 
 	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
-		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
+		pr_alert("pgd:%" __PRIpxx " p4d:%" __PRIpxx "\n",
+			 __PRIpxx_args(pgdv), __PRIpxx_args(p4dv));
 		return;
 	}
 
@@ -553,7 +554,8 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
 	pudv = pud_val(pud);
 
 	if (!pud_present(pud) || pud_leaf(pud)) {
-		pr_alert("pgd:%08llx p4d:%08llx pud:%08llx\n", pgdv, p4dv, pudv);
+		pr_alert("pgd:%" __PRIpxx " p4d:%" __PRIpxx " pud:%" __PRIpxx "\n",
+			 __PRIpxx_args(pgdv), __PRIpxx_args(p4dv), __PRIpxx_args(pudv));
 		return;
 	}
 
@@ -567,8 +569,9 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
 	 * doing another map would be bad. print_bad_page_map() should
 	 * already take care of printing the PTE.
 	 */
-	pr_alert("pgd:%08llx p4d:%08llx pud:%08llx pmd:%08llx\n", pgdv,
-		 p4dv, pudv, pmdv);
+	pr_alert("pgd:%" __PRIpxx " p4d:%" __PRIpxx " pud:%" __PRIpxx " pmd:%" __PRIpxx "\n",
+		 __PRIpxx_args(pgdv), __PRIpxx_args(p4dv),
+		 __PRIpxx_args(pudv), __PRIpxx_args(pmdv));
 }
 
 /*
@@ -584,7 +587,7 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
  * page table lock.
  */
 static void print_bad_page_map(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long long entry, struct page *page,
+		unsigned long addr, pxdval_t entry, struct page *page,
 		enum pgtable_level level)
 {
 	struct address_space *mapping;
@@ -596,8 +599,8 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
 
-	pr_alert("BUG: Bad page map in process %s  %s:%08llx", current->comm,
-		 pgtable_level_to_str(level), entry);
+	pr_alert("BUG: Bad page map in process %s  %s:%" __PRIpxx, current->comm,
+		 pgtable_level_to_str(level), __PRIpxx_args(entry));
 	__print_bad_page_map_pgtable(vma->vm_mm, addr);
 	if (page)
 		dump_page(page, "bad page map");
@@ -682,7 +685,7 @@ static void print_bad_page_map(struct vm_area_struct *vma,
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


