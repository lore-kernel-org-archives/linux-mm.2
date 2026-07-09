Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A56DC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 04:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B81026B0088; Thu,  9 Jul 2026 00:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31476B008A; Thu,  9 Jul 2026 00:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A231D6B008C; Thu,  9 Jul 2026 00:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6807B6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:43:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFEC1A03A3
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:43:52 +0000 (UTC)
X-FDA: 84967995504.29.14C553A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 04C52140004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:43:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZqP2fAh7;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783572231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wbkXSaRIDJifaJLQNLOUH1eTHKVzyIzQV3F/ZP3iV/0=;
	b=5J/pTWTKXCUPHozNMUfoOH+j4lBburpcctE1MJEfpZj+tRWDl5ViO5U0pPqEfiSrzWTjtG
	otAkVw0KVJ1hTe7+5jFOhS8oSiuwVIzs8UcxqAFuoFo2koyiytZQglxZzvzMojdj0HqK5A
	+HDoz8AVxKkorZ6tfEpS09x+MCHLw5s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZqP2fAh7;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783572231;
	b=6qtElw6nO/jMC3+cmaatd9DIzC7XvXlPc5mnXri6FUpXXbLbXzgyoJ8yviRxu3FciENl0o
	QhBOGsg8d0DiZHyFnFMknOTJ/XQcnFsSllFt7GDNIi2vB1niBj4pGIi3Sc4xJvTD8jwDkH
	dqXzW3qyIJsajbnjdnpVSBJsTdauHsc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 968D11684;
	Wed,  8 Jul 2026 21:43:45 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0DB7E3F7B4;
	Wed,  8 Jul 2026 21:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783572229; bh=mD+nrT8/9X0MW7Uq+ioEFOEUot5exy78uod7gguIxbU=;
	h=From:To:Cc:Subject:Date:From;
	b=ZqP2fAh7O1/aAQd0VGUPCUBCOtW0HJ0U9uxVbx1SpfH4akq8l//RZzWwLMdvPP/JU
	 EqdpO0Ofje35hj3KuvDLkbHeMp89gz+C4+mF+FMBqjDo2wSM6cI6Qk6lg9OO5M5LqV
	 TrNXk+KEX8rZGI84B3FCgUzxhe0Xg1EvaRBttLTk=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: andriy.shevchenko@linux.intel.com,
	usama.arif@linux.dev,
	hughd@google.com,
	willy@infradead.org,
	ryan.roberts@arm.com,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH V3] mm: Standardize printing for pgtable entries
Date: Thu,  9 Jul 2026 10:13:34 +0530
Message-ID: <20260709044334.1741263-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 04C52140004
X-Stat-Signature: gn4fzzmgrodiu9e3cc9jgx5tbny81bxr
X-HE-Tag: 1783572230-27667
X-HE-Meta: U2FsdGVkX1/d8QZZ58k5CBENTJapHjOjlsBwTWoTLx0ojxl2+aMiWcFNtZSiPRfdIUtRfg6q0ufkGeeeH4UpT0hAPUOMXBAyIRJtqRpq3LqOiTkb1xaa6qfVQJrYLMBnbqJ7aBlZS39wsG6OHiMt5hMM+GdC5GPGUY3z94Fv6j5zhr+66iHx0M2urhJHC77Qs43gITkzjw4aZeDGSr5qItawhe6ZD6+eDxiv8JYof5mUOVKbivqK+LqBaw3oKQ8R+byv0mgvnAZ+Kb5i+SdtaOs3Vp/+LvSAyY4dPYajlieJwAzts4PACQoypoOI/ZG+X65cjW/4OctpqefZ6fHpSzP8DKCrrCj81RDtgEt5WyACYx00PDNt33d0KNNIhO80eWYHeYzyBw3bXcagsVcezwu3k0SUNO50I1JmvShB6yzbq2k0MVBzh5AaBLiiUPTn5USyvAVKpWxp3WYPhiX3Oo1mDf91H24Ulb2rpgFHqv4cdNN9/s8FEEc1H7U1fjQrZszxR1HO2eoHU4MXyfbtUCkvok+jYL/uwlkPq/uIViyATKWk+AViIUKyaXylk66To1UJat/P9I/525+kFcnT+DyziBUZVSLNkhHCVt6Wt/e3lObXlc9yCceEsBnW3UbDmdIcX+F6AhrhQ0nkzqZUnDe7PGAf5Ypn7jchgU+lmyD0Kwt8keDh2ijOrGpWDukPxThmTmLT/ev6Zi136MKVMsWLIOb3m9CBGEOJFKX+W1EPJUTgMk5cM0xHUkEVANmRtUcjU7RW1kl2qfecRW9YfTZp2EYvWrF3EZf8NHX9WqDzHdvVOE3g1AGZxSH//43B1k2DLXMZ0e+0B2xIUohdthI5X8gWjv+R69EdghCNd9cat5pehXjxRBzSqt/4TPijEKmIMSajg/xiPWjCjCtW+WUnCT+Yo8UcCGSUAzr3lbt6oQDPZmoz7VPtemzUehAdxiSQuckiIin3YJyib9V
 4DddHwEL
 Ch7jdm0VMoR/g4PWrXulTTDjW3ZQB6aDv3NbIWd7ODFFySl3VPgydmslt+KdmYHKaBfpjzyrSZ7+Q60isu3Xeg/EGqNapp9e9mxTltvMjIAKiBio718GHMEAV7C9c2bMlTRgeOWUQU1ykdbEwgpdCCx5cJ4LFdXMzwXOUAfbwb4OLPwDQITlXv9Vd/gI2/MAVa6mhN326hRz8B3jBIgkkFCRqIuJg4pCxj3RZAkncUI/7ucIdO5VYK/ldgGrL5RbmA0u82yDmVWwBMYbvdE4KTPchfttkIbry8wdKZfPfEuUkUf2F2okq1pGB9qWSmDMHH5YvUOPTpAEoQ7xaxeFnj8u3rh2WxoZ1XJfF1d6+aIaVryU10V4DVmXCIvOi8bXj3welqfeBMvKA3ew=
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
Co-developed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
This patch applies on v7.2-rc2

Changes in V3:

- Replaced __auto_type with auto per Andy
- Added Co-developed-by:

Changes in V2:

https://lore.kernel.org/all/20260708032824.969752-1-anshuman.khandual@arm.com/

- Dropped space after ":" during print per Matthew
- Dropped CONFIG_CPU_BIG_ENDIAN per David

Changes in V1:

https://lore.kernel.org/all/20260707041703.658021-1-anshuman.khandual@arm.com/

 mm/memory.c | 102 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 79 insertions(+), 23 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..c8fe2f373fd2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -519,9 +519,52 @@ static bool is_bad_page_map_ratelimited(void)
 	return false;
 }
 
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
+		pr_alert("pgd:%s\n", pgd_str);
 		return;
 	}
 
 	p4dp = p4d_offset(pgdp, addr);
 	p4d = p4dp_get(p4dp);
-	p4dv = p4d_val(p4d);
+	ptval_to_str(p4d_str, p4d_val(p4d));
 
 	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
-		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
+		pr_alert("pgd:%s p4d:%s\n", pgd_str, p4d_str);
 		return;
 	}
 
 	pudp = pud_offset(p4dp, addr);
 	pud = pudp_get(pudp);
-	pudv = pud_val(pud);
+	ptval_to_str(pud_str, pud_val(pud));
 
 	if (!pud_present(pud) || pud_leaf(pud)) {
-		pr_alert("pgd:%08llx p4d:%08llx pud:%08llx\n", pgdv, p4dv, pudv);
+		pr_alert("pgd:%s p4d:%s pud:%s\n", pgd_str, p4d_str, pud_str);
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
+	pr_alert("pgd:%s p4d:%s pud:%s pmd:%s\n", pgd_str, p4d_str, pud_str, pmd_str);
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
+	pr_alert("BUG: Bad page map in process %s  %s:%s", current->comm,
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
+	auto entry = pte_val(pte);
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
+	auto entry = pte_val(pte);
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
+	auto entry = pmd_val(pmd);
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
+	auto entry = pud_val(pud);
+
 	return __vm_normal_page(vma, addr, pud_pfn(pud), pud_special(pud),
-				pud_val(pud), PGTABLE_LEVEL_PUD);
+				&entry, sizeof(entry), PGTABLE_LEVEL_PUD);
 }
 #endif
 
-- 
2.43.0


