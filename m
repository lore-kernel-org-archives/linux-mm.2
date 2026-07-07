Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45864C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 04:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5586B009D; Tue,  7 Jul 2026 00:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275726B009E; Tue,  7 Jul 2026 00:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C536B009F; Tue,  7 Jul 2026 00:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE4326B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:17:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4068FC19AF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:17:26 +0000 (UTC)
X-FDA: 84960671292.21.BB64709
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 27B5880004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:17:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=h82mKNCw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783397844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LVyGN/WRl7ojPa3+EKkt8JGw1OdAI+cWZZCsrkjKLFI=;
	b=fd2XK6dBTpAWyUAbwoaUkPR/aY/90YMBq09SXzfeklYYLEtW2z6BkoyufhaVFxF1rEk5OX
	wyIfkqX5uVqnghvOxRdWCn1/WGFRyY1xu8sbI3NbFuvscVtR4Su9E+qb8+Fr0SJEHWvmBQ
	/B9ATp7Myeyc/w9C/Rzj/nx52zwxyA0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=h82mKNCw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783397844;
	b=OHHpBCTL9m4W8XUOTRyVcbfITBxNSzG5qeM1nsFaTB0tbLYvhc+kgJgWEiULq7v7dn13V+
	lNt4KJMpzDoAyftFKIZduyXKkb9fCv9aLsBgNwmjC904qz79xq07yGncEAjxIi+GEK5uXh
	2GYE6nwjmf2xvjnhrFjK2MTkW8MUy60=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A596822FC;
	Mon,  6 Jul 2026 21:17:18 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5E9173F85F;
	Mon,  6 Jul 2026 21:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783397843; bh=LAPcZjMUiw+dmAMgk2njrVFJSSkQhTT9c8eQh46CbX4=;
	h=From:To:Cc:Subject:Date:From;
	b=h82mKNCw2SI/fzFZeSp9zdpWkx4XUD4wIiiuS5Pc3clPXlOdIPTYmLQjD15tBCjkX
	 Ncbu9j2InpmYk69DluBSMKVRDkQRwUZJ2xcY/R4qMDy8Gn0Is7Z4gEWPZxFiMA2vX7
	 /ZmbhJvAbzkTXDQaD0fJR6S1NTHrm3cj9KC/Nivg=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: andriy.shevchenko@linux.intel.com,
	usama.arif@linux.dev,
	hughd@google.com,
	willy@infradead.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH] mm: Standardize printing for pgtable entries
Date: Tue,  7 Jul 2026 09:47:03 +0530
Message-ID: <20260707041703.658021-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 27B5880004
X-Stat-Signature: ccgehuo9sa9aan8fzg7uc4n8ryq3fauz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783397844-261661
X-HE-Meta: U2FsdGVkX19dY49WFPsUf2RR5r0l37BFQ63fCtBIv6SRo6p7h/jSlNLiTaOjgt18cjek3BGHVzgDxM0Hc+0HEciUyzzEYVhFvorNRdln1RVsm9e3nqPgn6Za2SqaaaC40lBle3h9/7B2yLwYjPbY+PLSwWoIJgwSRVIYHjIR3kd2wc6XQLaNVS65R2AIE7VH3tHAE3B42TT4YC9TSeKQN9Sfn2emG1WgYnlRMcMhCynoY1jw34Bm6DbGdELRaWEfJQhxD5Dl4ABeYxqFcK3jIxpj5i9yH6wcHSCDQ063ngHkgkRwDAq2D4CS/7q4Q4szXQYqPqIvgrLJZHlQVtOju8rzT73iLR/7omyOx1qAEoPBW8WASYcNsnEekseLLVFaRA70NSGm3n4s8aa+Va8TpHxlqU5nScCxs3GiJr3atfLERuXITHRkqtr+hknUVVu6V0XR9C8/K241oAMh+N8gjnaT6KOrkB6+mgbxsvr0XqmrnMuTYdrAO2MqrbRpgRIboGYGZYjDtrDQQBd3PUFcjoCP4nLx+g5hcBUwIFGZR7F7DRddIlV8uApTqYEEpaRQXeGBJ5NlqbU1j4E4AvNr7Mab34Z5vzcv2XjQ9jeCqEZNb4LywkXFav1zO5AoQjTLTW7mNH8HL9qGD2akMCZ2XenswWcLAhMv1eHRFkPVUdMoESRcRQQAtKg4FYSKqaYahm5+wex7BhDkNfSQqkiTQdL5AvtBpJkGCXNlFCa3km2b4X1SjYWEfoeI9Fn1nDgJjCX5mksxxK8R6LiHuEe7NfqJaLZqc2DzLinG3TFgmp8W7ha6PMybqY18EoSZ2dQMrqLbgdgpYwF3+aJO1SXu+pywHmKlTvYHzSLKXCNdYqIpCsbaJWZH3BZmdCQ/KtgcmNiOadE9gs/3NfMKix/eswYP8XKMOZqotLCeBJE/jUKxfIkhifzpKZKotLAoKBOKSjyvT7k/oRj8rW4dVZk
 KNArNhes
 UJPzbwvXMT8pGcW0iAl9SpOKkqZBigy5wIJoR5YsXH/VIDA5b+/gN7yjsMB9JrGtj1/awcEQr5d/et3p8CCZ1C1DlLs+Jow2dHIZA/yJPjSoRNSmLNyqnIN9Yi2SjW0b0KmDCzFtjyKsPVG3E3y3E1vcPExWiU/EnHKcx7tykN1E7zZK5/ze3D78CLmJ/+st81Cv2iXu7ohzIuYWUFcE9TLFH4KR+4WCWBfs+XVAkri7HHbspc3cZNyd82b0lx+Zg84NydsyZylPkE9lFsC6n5kyDKbQ30M8BOafdLY5WTQ3P9ShRB3ahgxbT/yxgrW/RdJVAyuh5dZUbFd5Xie7Wv2yW0bd2vGTLyDg2kG0IX06dyt5iQ4a3+i4vBeANMy2LzkKL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Bad page map reporting currently stores page table entry values in an
unsigned long long and prints them with fixed 64-bit-oriented format
strings. This is inconsistent across call sites and does not work well for
architectures where page table entry values are not naturally represented
as 64-bit values, such as 32-bit or 128-bit entries.

Introduce a common helper to convert raw page table entry values into a
fixed-width hexadecimal string based on the actual entry size. Use it for
bad page map reporting and for dumping the page table walk in
__print_bad_page_map_pgtable().

Pass page table entry values to the reporting path as raw bytes together
with their size, instead of forcing them through an unsigned long long.
It keeps the printed output consistent and avoids truncation or misleading
formatting for non-64-bit page table entries.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
This patch applies on v7.2-rc2

 mm/memory.c | 102 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 79 insertions(+), 23 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..f0c3478f1a63 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -519,9 +519,52 @@ static bool is_bad_page_map_ratelimited(void)
 	return false;
 }
 
+#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
+
+static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
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
+	case sizeof(u128): {
+		const u64 *val = entry;
+
+		if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
+			snprintf(buf, buf_size, "%016llx%016llx", val[0], val[1]);
+		else
+			snprintf(buf, buf_size, "%016llx%016llx", val[1], val[0]);
+		break;
+	}
+#endif
+	default:
+		snprintf(buf, buf_size, "unsupported");
+		break;
+	}
+}
+
+#define ptval_to_str(buf, val)								\
+	do {										\
+		__auto_type __val = (val);						\
+											\
+		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
+	} while (0)
+
 static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
 {
-	unsigned long long pgdv, p4dv, pudv, pmdv;
+	char pgd_str[PTVAL_STR_MAX];
+	char p4d_str[PTVAL_STR_MAX];
+	char pud_str[PTVAL_STR_MAX];
+	char pmd_str[PTVAL_STR_MAX];
 	p4d_t p4d, *p4dp;
 	pud_t pud, *pudp;
 	pmd_t pmd, *pmdp;
@@ -532,34 +575,34 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
 	 * see locking requirements for print_bad_page_map().
 	 */
 	pgdp = pgd_offset(mm, addr);
-	pgdv = pgd_val(*pgdp);
+	ptval_to_str(pgd_str, pgd_val(*pgdp));
 
 	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
-		pr_alert("pgd:%08llx\n", pgdv);
+		pr_alert("pgd: %s\n", pgd_str);
 		return;
 	}
 
 	p4dp = p4d_offset(pgdp, addr);
 	p4d = p4dp_get(p4dp);
-	p4dv = p4d_val(p4d);
+	ptval_to_str(p4d_str, p4d_val(p4d));
 
 	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
-		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
+		pr_alert("pgd: %s p4d: %s\n", pgd_str, p4d_str);
 		return;
 	}
 
 	pudp = pud_offset(p4dp, addr);
 	pud = pudp_get(pudp);
-	pudv = pud_val(pud);
+	ptval_to_str(pud_str, pud_val(pud));
 
 	if (!pud_present(pud) || pud_leaf(pud)) {
-		pr_alert("pgd:%08llx p4d:%08llx pud:%08llx\n", pgdv, p4dv, pudv);
+		pr_alert("pgd: %s p4d: %s pud: %s\n", pgd_str, p4d_str, pud_str);
 		return;
 	}
 
 	pmdp = pmd_offset(pudp, addr);
 	pmd = pmdp_get(pmdp);
-	pmdv = pmd_val(pmd);
+	ptval_to_str(pmd_str, pmd_val(pmd));
 
 	/*
 	 * Dumping the PTE would be nice, but it's tricky with CONFIG_HIGHPTE,
@@ -567,8 +610,7 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
 	 * doing another map would be bad. print_bad_page_map() should
 	 * already take care of printing the PTE.
 	 */
-	pr_alert("pgd:%08llx p4d:%08llx pud:%08llx pmd:%08llx\n", pgdv,
-		 p4dv, pudv, pmdv);
+	pr_alert("pgd: %s p4d: %s pud: %s pmd: %s\n", pgd_str, p4d_str, pud_str, pmd_str);
 }
 
 /*
@@ -584,10 +626,11 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
  * page table lock.
  */
 static void print_bad_page_map(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long long entry, struct page *page,
-		enum pgtable_level level)
+		unsigned long addr, const void *entry, size_t entry_size,
+		struct page *page, enum pgtable_level level)
 {
 	struct address_space *mapping;
+	char entry_str[PTVAL_STR_MAX];
 	pgoff_t index;
 
 	if (is_bad_page_map_ratelimited())
@@ -596,8 +639,9 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
 
-	pr_alert("BUG: Bad page map in process %s  %s:%08llx", current->comm,
-		 pgtable_level_to_str(level), entry);
+	ptval_bytes_to_hex_str(entry_str, sizeof(entry_str), entry, entry_size);
+	pr_alert("BUG: Bad page map in process %s  %s: %s", current->comm,
+		 pgtable_level_to_str(level), entry_str);
 	__print_bad_page_map_pgtable(vma->vm_mm, addr);
 	if (page)
 		dump_page(page, "bad page map");
@@ -627,8 +671,13 @@ static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
 	}
 }
 
-#define print_bad_pte(vma, addr, pte, page) \
-	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
+static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
+			  pte_t pte, struct page *page)
+{
+	__auto_type entry = pte_val(pte);
+
+	print_bad_page_map(vma, addr, &entry, sizeof(entry), page, PGTABLE_LEVEL_PTE);
+}
 
 /**
  * __vm_normal_page() - Get the "struct page" associated with a page table entry.
@@ -636,8 +685,9 @@ static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
  * @addr: The address where the page table entry is mapped.
  * @pfn: The PFN stored in the page table entry.
  * @special: Whether the page table entry is marked "special".
- * @level: The page table level for error reporting purposes only.
  * @entry: The page table entry value for error reporting purposes only.
+ * @entry_size: The size of @entry.
+ * @level: The page table level for error reporting purposes only.
  *
  * "Special" mappings do not wish to be associated with a "struct page" (either
  * it doesn't exist, or it exists but they don't want to touch it). In this
@@ -697,7 +747,7 @@ static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
  */
 static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long pfn, bool special,
-		unsigned long long entry, enum pgtable_level level)
+		const void *entry, size_t entry_size, enum pgtable_level level)
 {
 	if (pgtable_level_has_pxx_special(level)) {
 		if (unlikely(special)) {
@@ -710,7 +760,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 			if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
 				return NULL;
 
-			print_bad_page_map(vma, addr, entry, NULL, level);
+			print_bad_page_map(vma, addr, entry, entry_size, NULL, level);
 			return NULL;
 		}
 		/*
@@ -741,7 +791,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 
 	if (unlikely(pfn > highest_memmap_pfn)) {
 		/* Corrupted page table entry. */
-		print_bad_page_map(vma, addr, entry, NULL, level);
+		print_bad_page_map(vma, addr, entry, entry_size, NULL, level);
 		return NULL;
 	}
 	/*
@@ -767,8 +817,10 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 			    pte_t pte)
 {
+	__auto_type entry = pte_val(pte);
+
 	return __vm_normal_page(vma, addr, pte_pfn(pte), pte_special(pte),
-				pte_val(pte), PGTABLE_LEVEL_PTE);
+				&entry, sizeof(entry), PGTABLE_LEVEL_PTE);
 }
 
 /**
@@ -809,8 +861,10 @@ struct folio *vm_normal_folio(struct vm_area_struct *vma, unsigned long addr,
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd)
 {
+	__auto_type entry = pmd_val(pmd);
+
 	return __vm_normal_page(vma, addr, pmd_pfn(pmd), pmd_special(pmd),
-				pmd_val(pmd), PGTABLE_LEVEL_PMD);
+				&entry, sizeof(entry), PGTABLE_LEVEL_PMD);
 }
 
 /**
@@ -850,8 +904,10 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
 struct page *vm_normal_page_pud(struct vm_area_struct *vma,
 		unsigned long addr, pud_t pud)
 {
+	__auto_type entry = pud_val(pud);
+
 	return __vm_normal_page(vma, addr, pud_pfn(pud), pud_special(pud),
-				pud_val(pud), PGTABLE_LEVEL_PUD);
+				&entry, sizeof(entry), PGTABLE_LEVEL_PUD);
 }
 #endif
 
-- 
2.43.0


