Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5156AC44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38ED66B00B2; Tue,  7 Jul 2026 23:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33F7E6B00B4; Tue,  7 Jul 2026 23:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1016B00B5; Tue,  7 Jul 2026 23:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C154B6B00B2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4462516910C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:40 +0000 (UTC)
X-FDA: 84964134360.29.A383EF5
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id 95736120002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FJxehYmQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 36b9NagoKCPgoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=36b9NagoKCPgoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iCCmK+o9wKQf5+3Ew8M4Jk3nTsjcUPa/yWersiCGiuk=;
	b=0qDgncZsI/N6J7V7pfdL+dsUUyyBUgkX3dSTXzm9xzfs0YwNghgEfnAB0dbrU7DukfWKTt
	H1GGeqZI9IM+EgKnsa3dlwFOhCQnWnvGXxKFF0hLhuGBa4M1zeJa4grVRXDMF5OiUa9yZi
	+IWLcDM2x+HPJ25ICZBNi6MYWTxjPPg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FJxehYmQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 36b9NagoKCPgoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=36b9NagoKCPgoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480298;
	b=3nVdajhR1rGJ5NYMOcR1aa+l45xqzt9Hi1IZ/Y6V1wMWAsLqRXHSCP3MZ44buaPHhhjsSB
	eqVbVm63kEMT1m3Ql3fypiLpv9Oy/vxEFI4lEk59j/4ZzLfU8axC1TJP5lG+WHEKS51SlR
	AgNeOhFREefe5nHWu1P3l+wA+PTJKLQ=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ca0481106cso3703705ad.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480297; x=1784085097; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iCCmK+o9wKQf5+3Ew8M4Jk3nTsjcUPa/yWersiCGiuk=;
        b=FJxehYmQjEJQq/X6JBmoWYDJJVR38ZC+sunSi1TTf8NmerwoNOKE/2KnjbfDkMadnn
         QtIWRbz2VJOERYYrKQWslV5jYBTEpKEs/Z5omw/AbrYH29zCBguKASpC8lM6bn0r3elR
         AGZTBdgNcPIPgh1VGHYuF6cPQqlBdQLqITeUbf78mRRGJqHdVoZpAUXTnx9twDgtc0N3
         HEafA7vYCHVHjObF1Yb2VzbxMntiO21+AesfWm5lSMOQaSDZMYK8OkRt16lQpGxdvLgc
         7j/WJ+iVNltHYX+FILHR6KBLd+pW6KJ+R8IWCHFhDc2Fy4E6D6Ji1L/b5ImJus5UtmYS
         8ZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480297; x=1784085097;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iCCmK+o9wKQf5+3Ew8M4Jk3nTsjcUPa/yWersiCGiuk=;
        b=bg4uICQNw8QOkBvn0QnJ/JF2OvyL2lUZWtGv5xK6yzMuv1jbzygYYz4qY2eJQTt8WJ
         JUfY27+ttC/pzSlCrl23FoKPs439h0sKprzthlVka5sPSvabOXfWdlM3xec974xZqKsJ
         lUQ6o6EBU82fjh7AIf61Z3We8wV0+bOMoeeLUVlYytdltLHJu7YB6S9P9bDFFsdjFxbK
         Tc+bRReurpY7OtfxzgQflNvZksDpO+/2xrNuChDC3LQRm6eWi3yULcUpRgRYYdoVlNN+
         PPBaLqUOmaSgKgOGK5GhUMepY5GjkOo1eRCetWv9QXCKp3kSbIo0D9LR4pkgaqfbngyu
         Jhmg==
X-Forwarded-Encrypted: i=1; AHgh+RoaBXz3TZ6khhEyl2iluJs8tC6CIpQ90FjoKbNpOT6ASu4VKDAUL9HlNTGejS4ZZgzqUmIzrmBpow==@kvack.org
X-Gm-Message-State: AOJu0YwHrbzrYlDDLD11RRrAoW6nBnBU07zaIxSZs5jg4rkxA7WaBEq1
	ts0YbxhxheSJrS2CQhQv8VCmBZCjCtjFVaxOzT7Sjlin3XO0z0c2N28fWX3LdrssOqEKDpTrhl/
	Z3FZBvfe0Gvah9W4Id0+fUA==
X-Received: from plmp1.prod.google.com ([2002:a17:903:f01:b0:2ca:eea9:9845])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e943:b0:2c9:2ee6:693e with SMTP id d9443c01a7336-2ccea3c1987mr5977265ad.18.1783480297144;
 Tue, 07 Jul 2026 20:11:37 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:14 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-5-jthoughton@google.com>
Subject: [PATCH 04/18] hugetlb_vmemmap: Use try_update_vmemmap_pte to update
 in-use PTEs
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 95736120002
X-Stat-Signature: 5tcij9ch9upo118dkf9pyx8potd3t97j
X-HE-Tag: 1783480298-911852
X-HE-Meta: U2FsdGVkX1+quR2Jw6Urjw2SkUWtdlcADu6Got5G07GBpgD+70mWEGB/9BP1cbqQFODjSLcKG5PKst0gMHNnJKKzFYFoAVog7mIeciJ/UWrkj7ooCRW7ERl7w4qpl7eLMVKrL2JDbKku0MzjLfygRWSMNC12dOqMdcyH2F8/dJ9hhDJbvcgqu0UPhC/rPhIBwRRNt38h5zlLxBziMs/CGuzzzWk4zLMfSJ1MO6sdpDMxScXKHaPjHgEnuAwd8p81ptbXlpGTi4O6Q/uv2Xlo3e2IhhxpAAQ0Ek4GkHVIn9JilT8E/9fDi4SCoOzq7TP5FHQmizTnbovwRg0KZueT+NaE7tJ/FGje/PvaYMkczi528wNIbmNJmEBfRLYl/A2t4jEAP+asjTl9Fw5kuExGEpSZLFHcDmMWeMJuJLYpc/NIwMUerjiBGBNWDh82xb8o6+nt7cV52AK8dOEOskMO8UctyAqAQ/gHXGptwfjTNC3mAwkK3oV1quVHcNFI/9rX95fhP0rBD1AxCN3jkZYDSczxSR4PoaZNuqV5eli51gyj+OM40T9Z9xEVPJsSPFa3Il10sncEiweoMOQj+ffTABO1Sw181yhP4OxzFm5F0PlY2ytMvWi70cu1WuigH2qQtpZKDGTQieLJbajpYdJxAITvQFHOzT8INowzn5w/GQQYhco5CWr33ZzjrUANCIzE9TDtBanCaGGFSZlk4S9fXohtmqipc9tyGRtg/DVAsf4ziMzLuuIAeukFtRb74wyq2MQCGma7W/4/5A+GRNnEFwmwMJXn4AaEd0amxOFPm9eUcRf29jnRRJVUyR015OsUDDSMLbMPpnDs/IuTpokQd2jQFQmiyGzRjlEQqNwr0S7eBpUBA9e+dHOBvAyWOqxMMI+OxzAGbdoYL9tZ28pCLiV/j5g8CZy81evM0FDQIeUynQnjgNDhdVGKF9RUXdZodwVWj7P2ZK4fRkulpeO
 6/OGp1FK
 L+IdbNmLMVIxO9pJkrKuhyQzLtz/qHVhjS+VEvr0UJZqJtlMyY6j0068Y7aprFYGEeuGy5Q9Gn7sXquweI1NbAxLegnTRoN+kzQyybdN4Qegif4pIJCzWJWrZsAgbS//JgrbO84lp8dvSsn8dxf1/KFlKZ4zgSMfTpkfwC5rJxDJHFbWnDqZGyVCCBHTs1wkwvkLBnfruQV9pFQA3kL8MIoMpcsJqjGmJjTnAB3bnaDXF04Xb3+0WucozaNpmPfIV2pHJvYDJw7A5uUGQLbbJRAqSrKMp6hwEDJLRrLAEf+blRR7PuCVlRMSLbiaCA/cd417bakjmy+VuYHLPM4etR/w2EhqaYH//nwtB1iTq/4dUV2cDud4U0VFu+ddyCGdQR7R2S+RDxLdcW8adF/5lly8d7yUivYdMbQM/ym4uRb9dI71JLe5PFNWP66iFMOM0Hk/Jm1HqmNUbwa3lgWn9qXgHpvo6oGfmrsDcjTrov3+0WMt12Cq6Z/vkWCdni3UisD/sBUnsQ5dmPV5fW/Gy373TEBqS3b49r4Gsym3sfSaELeMI8uSZgWvir7FeD+jQXxglKTTQ+dlveaMyDKOrpx3W2TaCKcyL19SLYj8Hagliud5IeVj9RFvaRMwTKCYpCYueHo1+vz+isc5n5FyPI7HPh4lHNtg2SN5G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

set_pte_at() cannot be used to replace in-use vmemmap PTEs on arm64, so
replace it with a more specific routine, try_update_vmemmap_pte().

try_update_vmemmap_pte() is used for modifying page table entries such
that there is a guarantee that no fault will be taken.

For the x86, riscv, and loongarch implementations, please note one
difference: set_pte() does not invoke page_table_check_ptes_set(), but
set_pte_at(), the call we are about to replace, does. However, this is a
functional no-op because page_table_check_ptes_set() does nothing for
init_mm PTEs, which vmemmap PTEs are.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/loongarch/include/asm/pgtable.h |  8 ++++
 arch/riscv/include/asm/pgtable.h     |  8 ++++
 arch/x86/include/asm/pgtable.h       |  8 ++++
 include/linux/pgtable.h              | 21 +++++++++++
 mm/hugetlb_vmemmap.c                 | 56 +++++++++++++++++++---------
 5 files changed, 84 insertions(+), 17 deletions(-)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 223528c04d73..e7b65056ef73 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -638,6 +638,14 @@ static inline long pmd_protnone(pmd_t pmd)
 #define pmd_leaf(pmd)		((pmd_val(pmd) & _PAGE_HUGE) != 0)
 #define pud_leaf(pud)		((pud_val(pud) & _PAGE_HUGE) != 0)
 
+#define __HAVE_ARCH_TRY_UPDATE_VMEMMAP_PTE
+static inline int try_update_vmemmap_pte(unsigned long addr, pte_t *ptep,
+					 pte_t pte)
+{
+	set_pte(ptep, pte);
+	return 0;
+}
+
 /*
  * We provide our own get_unmapped area to cope with the virtual aliasing
  * constraints placed on us by the cache architecture.
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 5d5756bda82e..a11c569ee2f0 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1162,6 +1162,14 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#define __HAVE_ARCH_TRY_UPDATE_VMEMMAP_PTE
+static inline int try_update_vmemmap_pte(unsigned long addr, pte_t *ptep,
+					 pte_t pte)
+{
+	set_pte(ptep, pte);
+	return 0;
+}
+
 /*
  * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
  * are !pte_none() && !pte_present().
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index ac295ca6c92f..974151564071 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1372,6 +1372,14 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 }
 #endif
 
+#define __HAVE_ARCH_TRY_UPDATE_VMEMMAP_PTE
+static inline int try_update_vmemmap_pte(unsigned long addr, pte_t *ptep,
+					 pte_t pte)
+{
+	set_pte(ptep, pte);
+	return 0;
+}
+
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static inline pud_t pudp_establish(struct vm_area_struct *vma,
 		unsigned long address, pud_t *pudp, pud_t pud)
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 2981e386da7b..e1abccf76bb4 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -457,6 +457,27 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 #endif
 #define set_pte_at(mm, addr, ptep, pte) set_ptes(mm, addr, ptep, pte, 1)
 
+#ifndef __HAVE_ARCH_TRY_UPDATE_VMEMMAP_PTE
+/*
+ * try_update_vmemmap_pte - Remap PTEs used by the vmemmap.
+ * @addr: Base address of the remapped PTE.
+ * @ptep: Page table pointer to be overwritten.
+ * @pte: Page table entry to write.
+ *
+ * This function is only to be used to update PTEs that map the vmemmap. The
+ * only valid transitions supported by this function are: leaf-level
+ * (PAGE_SIZE), valid-to-valid. The pfn and prot bits may be changed.
+ *
+ * Implementations of this function must ensure that, while the update is taking
+ * place, CPUs will not fault on the remapped virtual address.
+ */
+static inline int try_update_vmemmap_pte(unsigned long addr, pte_t *ptep,
+					 pte_t pte)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pte_t *ptep,
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 5fee01bf5b34..3951c043164a 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -34,7 +34,7 @@
  *			operations.
  */
 struct vmemmap_remap_walk {
-	void			(*remap_pte)(pte_t *pte, unsigned long addr,
+	int			(*remap_pte)(pte_t *pte, unsigned long addr,
 					     struct vmemmap_remap_walk *walk);
 
 	unsigned long		nr_walked;
@@ -141,11 +141,13 @@ static int vmemmap_pte_entry(pte_t *pte, unsigned long addr,
 			     unsigned long next, struct mm_walk *walk)
 {
 	struct vmemmap_remap_walk *vmemmap_walk = walk->private;
+	int ret = 0;
 
-	vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
-	vmemmap_walk->nr_walked++;
+	ret = vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
+	if (!ret)
+		vmemmap_walk->nr_walked++;
 
-	return 0;
+	return ret;
 }
 
 static const struct mm_walk_ops vmemmap_remap_ops = {
@@ -197,18 +199,20 @@ static void free_vmemmap_page_list(struct list_head *list)
 		free_vmemmap_page(page);
 }
 
-static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
-			      struct vmemmap_remap_walk *walk)
+static int vmemmap_remap_pte(pte_t *pte, unsigned long addr,
+			     struct vmemmap_remap_walk *walk)
 {
 	struct page *page = pte_page(ptep_get(pte));
 	pte_t entry;
+	bool head;
+	int ret;
+
+	head = walk->nr_walked == 0 && walk->vmemmap_head;
 
 	/* Remapping the head page requires r/w */
-	if (unlikely(walk->nr_walked == 0 && walk->vmemmap_head)) {
+	if (unlikely(head)) {
 		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
 
-		list_del(&walk->vmemmap_head->lru);
-
 		/*
 		 * Makes sure that preceding stores to the page contents from
 		 * vmemmap_remap_free() become visible before the set_pte_at()
@@ -227,17 +231,30 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL_RO);
 	}
 
+	ret = try_update_vmemmap_pte(addr, pte, entry);
+	if (ret)
+		return ret;
+
+	/* We successfully overwrote the vmemmap PTE, so we can free
+	 * the vmemmap page that was just unmapped, and if we mapped
+	 * the new head page, remove it from the list so that it
+	 * doesn't get freed later.
+	 */
 	list_add(&page->lru, walk->vmemmap_pages);
-	set_pte_at(&init_mm, addr, pte, entry);
+	if (head)
+		list_del(&walk->vmemmap_head->lru);
+
+	return 0;
 }
 
-static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
-				struct vmemmap_remap_walk *walk)
+static int vmemmap_restore_pte(pte_t *pte, unsigned long addr,
+			       struct vmemmap_remap_walk *walk)
 {
 	struct page *src = pte_page(ptep_get(pte)), *dst;
+	int ret;
 
 	if (WARN_ON_ONCE(!walk->vmemmap_tail))
-		return;
+		return -EINVAL;
 
 	/*
 	 * When restoring a partially-HVOed page, keep the copied head page
@@ -245,20 +262,25 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 	 * page.
 	 */
 	if (walk->vmemmap_tail != src)
-		return;
+		return 0;
 
 	VM_WARN_ON_ONCE(PageHead((const struct page *)addr));
 
 	dst = list_first_entry(walk->vmemmap_pages, struct page, lru);
-	list_del(&dst->lru);
 	copy_page(page_to_virt(dst), page_to_virt(src));
 
 	/*
 	 * Makes sure that preceding stores to the page contents become visible
-	 * before the set_pte_at() write.
+	 * before the try_update_vmemmap_pte() write.
 	 */
 	smp_wmb();
-	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
+
+	ret = try_update_vmemmap_pte(addr, pte, mk_pte(dst, PAGE_KERNEL));
+	if (ret)
+		return ret;
+
+	list_del(&dst->lru);
+	return 0;
 }
 
 /**
-- 
2.55.0.795.g602f6c329a-goog


