Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A468CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5AE6B00AA; Fri,  2 Oct 2026 20:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CC26B00AC; Fri,  2 Oct 2026 20:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45E186B00AB; Fri,  2 Oct 2026 20:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19B056B00AB
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9E684A781B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:41 +0000 (UTC)
X-FDA: 85279411602.11.5834661
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf27.hostedemail.com (Postfix) with ESMTP id EFF7140005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UXva5cvC;
	spf=pass (imf27.hostedemail.com: domain of 3kkrAagoKCIUs2qx3pq2xwpxxpun.lxvurw36-vvt4jlt.x0p@flex--jthoughton.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3kkrAagoKCIUs2qx3pq2xwpxxpun.lxvurw36-vvt4jlt.x0p@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CW0PrPzO/He6EZ9NlACY98E/BL7OIKImRa0WQareyfQ=;
	b=XF/vzVGXR91CeapHTQuQZQ33cmiaaSueC1Zcsq5739bMzkSCcDK/E7mJ4omTSAHHOmnPh8
	qKC/XCNJS42p5r7JC43mMsHHHJwio6w1r+I10dTWxL0FTmCH8EoFR68g67EhIVkZ16nm+D
	gyBBz4BkEOkTIwujGUSly/8etHTozI4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UXva5cvC;
	spf=pass (imf27.hostedemail.com: domain of 3kkrAagoKCIUs2qx3pq2xwpxxpun.lxvurw36-vvt4jlt.x0p@flex--jthoughton.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3kkrAagoKCIUs2qx3pq2xwpxxpun.lxvurw36-vvt4jlt.x0p@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986900;
	b=PxWHfCK+NdFA4d9zlngiPhaLiLu23CIWjGzxEwEmxkZjRsjsBgp9mkdsEQOgy7ATL2P/ta
	9ZfbHd3iZLW4h4KVURX4IZXTzXajnC3ZCi/727ba49vyfuFC/qtrQLTCEU2EKY9CO6t1J3
	YyhLNaytfZgp2aCA6j2erRZEhcgKGJ8=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39533bb224cso392301a91.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986899; x=1791591699; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CW0PrPzO/He6EZ9NlACY98E/BL7OIKImRa0WQareyfQ=;
        b=UXva5cvC5/sicsFRFLNsBJGSdG2ZDPC+guEDg1smsieit3D+bOCrjVSnInj0zOml/Z
         aw3pn1teq3LncjyP0Fk7xoM7xEauyiraNoXWM+2UQ9ksPrFjp1uhdEiJdKzYGTt9UHsr
         /GUaa42oLAIRZIJGx52X9KpRclh7jzhF9bicQlSyc1x+haFoXRX97e+WzZCkKgHdqmWD
         Mr9d+k0K/uOD+CvcEHUzoNyib8WmbQvLeUZcO+sL1F0G5Zo9Wbze2YWebA0+WEkhltT4
         cJJ11AoJg+iEbUJEaJ9qkflfQVOfpZbnytJovIQMCUVmrMGiYOhteFmKbIytdicmDQYN
         gTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986899; x=1791591699;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CW0PrPzO/He6EZ9NlACY98E/BL7OIKImRa0WQareyfQ=;
        b=0iBLqC5aJQiUFU1fqJPlupzEbiAAeY9YnTLNDiCFVE0RFqz3RpvkCIJdiVEaEpluTS
         p1zPI7nifFHNnl4BW+d6pPmedjWE85bIObJycdgfe0nTFY0DlfQ6Rr4PMAy8DBZ1qaWu
         7zLrDYd5Hj8UNxtzkXX32w0vaJlGhCavwfa/QzG63k3USS3OXrLMznJuwVg2QIVT6ENG
         iTi6t1B8LpFvrs7xSZV/PjmSlaaHYnQKQ9lLTa6+zuVSVGoRW4vjy7cZtz2ZrlLu2KFE
         UJA6A+gCsisr99JhoZa2QWQryjBzSaJlqPQ+wjD+FEQ2+aDKDAQAH+WTXGS9q+fckjm9
         48Sg==
X-Forwarded-Encrypted: i=1; AKwUvBzPmNfO1d8Qwg4t7LQon665oQV/OrtzQnhFylmj0eTq5Mb9tqycwjI7xB3l5arFAsCBKFcNI44AzA==@kvack.org
X-Gm-Message-State: AFq9FYI6RhPXQ1qfwzxcQzgSzisMPijWrOCFJ+fUodLYLgTls+k4Qt2z
	9b2wK+tlDllmz85lN6fTQU3UFea5yQ9hYsPM96NpvSGJRIOZWZ9Gz+HiEOBms6nSpcBgdastw07
	ZApa3HZxfcBoMTUFFeLIjKg==
X-Received: from pgby27-n2.prod.google.com ([2002:a05:6a02:651b:20b0:cc7:d8ea:a7b5])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:134c:b0:39e:6a7e:ee1b with SMTP id 98e67ed59e1d1-3a6ce7db233mr2804158a91.39.1790986898532;
 Fri, 02 Oct 2026 17:21:38 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:08 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-6-jthoughton@google.com>
Subject: [PATCH v2 05/20] hugetlb_vmemmap: Use try_update_vmemmap_pte to
 update in-use PTEs
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EFF7140005
X-Stat-Signature: 3zzdiijrkprfu37tsdm4tiu1yy7dai77
X-Rspam-User: 
X-HE-Tag: 1790986899-844940
X-HE-Meta: U2FsdGVkX1/5Gg4xo+6l+WMSWoXzSVX68qpRiF9+9jBIPkZ8t3RqpIa1QoGwcRFFhCxhpt5ru6bafSXIBN6NCj9sSurMwWmnrnUT4qtJFuSf3Y5WNfMJnLRzpq0bTYt1gtVQnq6sv15fF5vxL/4Dv5YtG+pMglpjo4R+zmRFQBEfoJ/wsh7gwzfOV3AzhM4uv/TKbr8b1iDO1GTdOTNxd6MqD5FWogzXu1VIqh7gMxgn3oHhUUC+Rw0ti+klzWcQ/0+DMKQC7P7LmRNjyRWegR6Rzb9/PnX7PTA05iv2t5gxDV6f7tyOt59q+lvqhZjWQrURpiuQKNpvxTVK+EB9YVT14w+4RxD6XKptGo/HoRg9ExCI+oRDhYMXeP/G76pXkCHK++tk31LfXDN8lJR5xHvKxLIVcBGOootofM8Fs0hU8fdIWPCHl6APWyug9dp9d25sctzv3NMiVJLQQvkxhpx4agG78p3rnw/O1gsotlMlNKaEu8hkjzSPH447vIxOasB3/gSWRg3Ar1IHXN1Q8KTvbCjRlffnYI9L80V9QMjFjMULGZaxRc0SyuzLRYgplbt9QtE73YFkwsnlFNVJkkX+FPu7Z1rSn+0SkMKgsJyj+z8MrOFXH/OZfs/We7+SWiSBqo91rWSSY4lF7Xj//BIHYCRIcj59+17k/WKCVgyiYyLyg1q03VCrzsv8alMn7OMpKeK+LiNLt7B5FHxruqNNh2HEQw5ZYJC+Ec/dG7H44Qu0a36Ih17C/txaGR+kMdC9USQBUxxUqCNnyEO9za3vmwvahYHmdqf6ayYyalhgU3k5hIuiREzO9V+pZ5WeRDGSAVp/3DZKDJziJqn1nt6ebl/bDNXu5K0piUaKUmq3qvT4kuyTHTRhSS04HUfnsvI/IBQkVB+YvrEFkTQ+09oV9Ko8S/3vvbnHpRVruVMqukr4QO1YzKsS9npCAaTs4J4kIERRMQ0J43WzrAN
 +fxBwW9I
 xh8KvIMgmJz+YxyOgcCvXejM4eRKlgiLnxZG/DpWqA/mYlQfJ0EbTOhQw6QdovjDN8jagAIDRhRqWOs3htJRKb5GHnI1rFHdTjoF+QjRJAXItVoPokIWlu1gPwX9QcatSpKJQ/+bgV/l7zvYFLdvXHkRmYSf8rSHPDEZGrvpS1aEy043x4+NK5hcEHn4zq684QA5a49oZT6hym69FagV8lfh+as+vZ+Cn5ANqJFgDUlVcskOVkr/u7+j/+atK73zTNbJsJXdd4+kHquiHm8+EgOqzquEyZpRFbSqNQFi9X/Tujx+jndGlLwRnXdcTis9u3cqRUZ8M9RDpRlzdIQWleFTB7NgFY6KieM/to5eOStfzm3WUElC3GJFhL1E1t2DqumIaBhrNyjCC0Ys7YeLp1TIDYU714O1JOh6eDjpW17NHu5HXtkm5XtNT9EDM9v5mLckKYHc6fPnJ4q5lESKDKukIJOHVr46Gn7x0EGsEp6JoBakAksz5uBlfuuhQTUnEL0up8LYmKY4qXCAONWJToLZvGEv+8WRxrSbCotZPBTSkHC0kLUeDI1uHMA8KzdRNgZkMgrhkC88QzhdZ90xX+nEINhlCwGp3mDZwwkK4MRtD74VG73d1Wv1cwWhtsqhpGDIzFLMBMm9m+1z5KKJnBSzeJJIipn23xPnB
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

For the generic implementation, please note one difference: set_pte()
does not invoke page_table_check_ptes_set(), but set_pte_at(), the call
we are about to replace, does. However, this is a functional no-op
because page_table_check_ptes_set() does nothing for init_mm PTEs, which
vmemmap PTEs are.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/loongarch/include/asm/pgtable.h |  2 +
 arch/riscv/include/asm/pgtable.h     |  2 +
 arch/x86/include/asm/pgtable.h       |  2 +
 include/linux/pgtable.h              | 22 +++++++++++
 mm/hugetlb_vmemmap.c                 | 56 +++++++++++++++++++---------
 5 files changed, 67 insertions(+), 17 deletions(-)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index f87603135131..123eda3f6035 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -633,6 +633,8 @@ static inline long pmd_protnone(pmd_t pmd)
 #define pmd_leaf(pmd)		((pmd_val(pmd) & _PAGE_HUGE) != 0)
 #define pud_leaf(pud)		((pud_val(pud) & _PAGE_HUGE) != 0)
 
+#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
+
 /*
  * We provide our own get_unmapped area to cope with the virtual aliasing
  * constraints placed on us by the cache architecture.
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 4c8fc6845503..6cfae7720882 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1165,6 +1165,8 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
+
 /*
  * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
  * are !pte_none() && !pte_present().
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index ef0252a09c28..f60c09cdf1ec 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1368,6 +1368,8 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 }
 #endif
 
+#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
+
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static inline pud_t pudp_establish(struct vm_area_struct *vma,
 		unsigned long address, pud_t *pudp, pud_t pud)
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 780fe849ff8b..59ab7ca93548 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -457,6 +457,28 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 #endif
 #define set_pte_at(mm, addr, ptep, pte) set_ptes(mm, addr, ptep, pte, 1)
 
+#ifdef ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
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
+	set_pte(ptep, pte);
+	return 0;
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pte_t *ptep,
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 90db4d069ff6..3fdb1e4ce1a1 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -33,7 +33,7 @@
  *			operations.
  */
 struct vmemmap_remap_walk {
-	void			(*remap_pte)(pte_t *pte, unsigned long addr,
+	int			(*remap_pte)(pte_t *pte, unsigned long addr,
 					     struct vmemmap_remap_walk *walk);
 
 	unsigned long		nr_walked;
@@ -140,11 +140,13 @@ static int vmemmap_pte_entry(pte_t *pte, unsigned long addr,
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
@@ -196,18 +198,20 @@ static void free_vmemmap_page_list(struct list_head *list)
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
@@ -226,17 +230,30 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
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
@@ -244,20 +261,25 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
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
2.56.0.rc1.315.gc6ed9934b7-goog


