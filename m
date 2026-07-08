Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9792C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1CAD6B008C; Tue,  7 Jul 2026 23:29:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5876B0095; Tue,  7 Jul 2026 23:29:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A94E26B0098; Tue,  7 Jul 2026 23:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71CEC6B008C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:29:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E791E4064F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:29:05 +0000 (UTC)
X-FDA: 84964178250.22.9F2FE2D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id D4EE1C0007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:29:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="GKzR1/xE";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783481344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xkp5rPsf/crnxe0vFMwNK+XTExiLU5KbMRVb0x6svII=;
	b=BNVUkfiiNZ6CORdFMHnz2FwXWLIY/lBQKUcw8epAos/HBoGb/WCoI2Rx4kDBK13KM54Agc
	Acg6U2jsMENz+9n0m7s//r09SRamWUUZLwEaV6hDdYJmpPF0yhUX546uKEBg+2dsP2NNPI
	6xrO0y28oWpD0ovDxETIzLN392wI9N4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="GKzR1/xE";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783481344;
	b=cMPtft2l8gG6NKsAOsLNydnar8N5oGeDkg4kdew912fv3m+hSc34hUoWCtbJQtZ4CZt3wz
	19EA5Xui/WEfLLZfc2L/YP6i9XwDO7o/BfPSPNMgSSkyH21mYZ3OzOTOJqqZfj1uCa3tQz
	4BtbwWQXZU8NF2iqu4ge2yJqIfVrpjc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B4D41756;
	Tue,  7 Jul 2026 20:28:58 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 189373F85F;
	Tue,  7 Jul 2026 20:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783481342; bh=4TIAlQv334ljPLbnknbq5JYXaVq+Wblh0B3t2vyqqzk=;
	h=From:To:Cc:Subject:Date:From;
	b=GKzR1/xEw0z+DPwg4wQvnGuNzRvdVO0i/TfIqwJ/DNKg8vrOb04w5CpVQdHgQauam
	 AV8QAQ3oUeU7JLHT/IzqTNh3ULN4Tg5/9kOe8fWf/FvBC2vYORTqOhE4EKn1j/9k0s
	 +56jALBV0zEFo1dthBLqO1lqOLttKzP1hruIwdGA=
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
Subject: [PATCH V2] mm: Standardize printing for pgtable entries
Date: Wed,  8 Jul 2026 08:58:23 +0530
Message-ID: <20260708032824.969752-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D4EE1C0007
X-Stat-Signature: mrptwjpnmc1taergn4miwcwpg8sr75ky
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783481343-988529
X-HE-Meta: U2FsdGVkX1/HH/tSezqHLesQOjXyAk5a7OiRYKy53NPQ+rgqNZHlvonKxliE1APbZwbccskkf0H7Dly0qyts35oaPQWVWxBBs2CYs8SSxFWmZa/e6EacWs6QD9Z5ZjmJ4rDpc7iRiC6WjweWg1rRcnFVM0WudCoUUgYbH7Xn6zTtaRFlY/ICx+C2y1RgkP00mBtTn5TPLr1DdeiaEn7gJLSvo0jiEh/PCmD7AMm5WS+7vEBxWJwWG9T9lwqMDEQcFlDo0CnDILQYLX5bv3Vqo3O4TNnHFxno1MZjhGOVJwKxNQ0znEGeOjORejUNCNhJXoOVoOH5GEvxxSd3ht10c4uaRMz0y6Z0y9ZTRhzZ/oGly0SUwghoCG+Zg5J522keblFbfzCppClkgcag3ZjUqGrfNsxDbVnDVX8XDqgGg3aQcUx9IStcCF7jgIEH/vSdQW/NMdvEJIF1jOv4SQloFgLhoXd/O49h5L68aZaNuNtutr+UKundtldg9z7hK5VI2sA+vnw8md1cmdKCphYmddFkh9ZWtLFN8vXZeDPG7MznimX9QXahdDeMrrr9DEKdoxKP6AfFMGdGfPnRrutmIXhcDbC+o9J/jlPNuNx7SOleaItIb6d4Knv1gnkA/Nsu7nWanRYcevtjEadMdLqAv4D9iRzcuwqDSM2zTwQgTRIIJVJSRYKPyGqFb3szzi67YP22uifxn7tGNZKZ9Njmwjw8M9gQ39u/zSRlMxpszYwHsElN9T7pRCmsjR9aH8irlKFhNBOGL4QTBOdNBUhHxmc4N4NLx6PysepZtcmgRq+LY22aPmVi8sgT9pdN3gAYy8AWLDN9+olhb8p9vmaFfOWgFWIlnWwZs2FbcRcK2BYH++pHBR4Ajma/pWH1GJzaz4s2KXtk4pq5crQ/Yn+iEjavd7l3WMzTViY4CjLSa5p8RcCWlk15YGTnEDm9UBqUN8kdkyqni91DhCaoy2Q
 75jdsQoo
 T65X2FEvqOXF+INY41KaEzGx25IjB0eruM690r6rLwpTd5OoeTFbQ79zE6QuyFwLeXAIyuYH25+zualI37H8u9czzvL5/3255RNCqRqFMJIXgYP+RsPh+kBtf8UkEEUA45SXz1Nv1br42WxHPpZVWWrzlRRWxWTI73h94CipMVsmZ6OdtyP4TqL1bDhFL2mSTb+SjRG5yW7tDrc1xiv5Rqh3D+K9Tj1z6IsDry4hIaeC9dSratYpSv29pphe75WYD4nNlQE4GcaMVdup9vmOMpWZC8cFyFb0UdnBqwC1AI9cg4oSTSrgY8paUBc7lfslMhz3DGxCcUPtwHVc7I72jMjXMSt/aU0mwUxOTO3Nit75d+L3dCvYmFTZcXNYUwfxbFZr1Q0I26d/yZ2c=
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

Changes in V2:

- Dropped space after ":" during print per Matthew
- Dropped CONFIG_CPU_BIG_ENDIAN per David

Changes in V1:

https://lore.kernel.org/all/20260707041703.658021-1-anshuman.khandual@arm.com/

 mm/memory.c | 98 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 75 insertions(+), 23 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..a2b63af82792 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -519,9 +519,48 @@ static bool is_bad_page_map_ratelimited(void)
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
@@ -532,34 +571,34 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
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
@@ -567,8 +606,7 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
 	 * doing another map would be bad. print_bad_page_map() should
 	 * already take care of printing the PTE.
 	 */
-	pr_alert("pgd:%08llx p4d:%08llx pud:%08llx pmd:%08llx\n", pgdv,
-		 p4dv, pudv, pmdv);
+	pr_alert("pgd:%s p4d:%s pud:%s pmd:%s\n", pgd_str, p4d_str, pud_str, pmd_str);
 }
 
 /*
@@ -584,10 +622,11 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
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
@@ -596,8 +635,9 @@ static void print_bad_page_map(struct vm_area_struct *vma,
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
@@ -627,8 +667,13 @@ static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
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
@@ -636,8 +681,9 @@ static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
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
@@ -697,7 +743,7 @@ static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
  */
 static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long pfn, bool special,
-		unsigned long long entry, enum pgtable_level level)
+		const void *entry, size_t entry_size, enum pgtable_level level)
 {
 	if (pgtable_level_has_pxx_special(level)) {
 		if (unlikely(special)) {
@@ -710,7 +756,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 			if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
 				return NULL;
 
-			print_bad_page_map(vma, addr, entry, NULL, level);
+			print_bad_page_map(vma, addr, entry, entry_size, NULL, level);
 			return NULL;
 		}
 		/*
@@ -741,7 +787,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 
 	if (unlikely(pfn > highest_memmap_pfn)) {
 		/* Corrupted page table entry. */
-		print_bad_page_map(vma, addr, entry, NULL, level);
+		print_bad_page_map(vma, addr, entry, entry_size, NULL, level);
 		return NULL;
 	}
 	/*
@@ -767,8 +813,10 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
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
@@ -809,8 +857,10 @@ struct folio *vm_normal_folio(struct vm_area_struct *vma, unsigned long addr,
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
@@ -850,8 +900,10 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
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


