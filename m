Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84CE5606A337
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=E+Rl3xAD
Received: by kanga.kvack.org (Postfix)
	id D1AF56B05B8; Sun, 22 Nov 2026 13:45:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1E76B05B9; Sun, 22 Nov 2026 13:45:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBA7A6B05BA; Sun, 22 Nov 2026 13:45:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 857B76B05B8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:07 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 074C91C413C
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:07 +0000 (UTC)
X-FDA: 85463632254.13.0284ACB
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4235E40003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=E+Rl3xAD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3LzgDawoKCAwv5t06st50zs00sxq.o0yxuz69-yyw7mow.03s@flex--jthoughton.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3LzgDawoKCAwv5t06st50zs00sxq.o0yxuz69-yyw7mow.03s@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373105;
	b=HslAUpeNzN7+rNcg+xgIRYLddHxDCN1PvM4mPVeX8om8RK9OWqgBlRTBB4iwotkWVqWqK4
	GCZCUPz5+xMHIHAWJd4XdIlQXj+BnZptBMKD5QREDzIE+td3zOZinM1JT+sFzjHQINemtp
	lD2jV0PHnx+Rs2wyQtc3WUxHMbTPjaE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1tWrOtic/buTkSk/2DlTQdnpgTD163OrV0WQJdUCLJE=;
	b=Ob8RbC1DzHOFjn5Iq9mjksWK00N93193Tpo3MfzWJ1S0AfehNIxjvviPzdP0QZXZ0CLUqd
	METuLu+R5juzuCfz0Yu5Ek0ZYFTMSaRn/0XoVDeES/uSqp83yjdlSzdAMZKK8u6Qnnc/KR
	fiXmXquDxGCjn7CRkzetCHvbBJ/BjgQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=E+Rl3xAD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3LzgDawoKCAwv5t06st50zs00sxq.o0yxuz69-yyw7mow.03s@flex--jthoughton.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3LzgDawoKCAwv5t06st50zs00sxq.o0yxuz69-yyw7mow.03s@flex--jthoughton.bounces.google.com
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2f02c63901aso24278385ad.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373104; x=1795977904; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1tWrOtic/buTkSk/2DlTQdnpgTD163OrV0WQJdUCLJE=;
        b=E+Rl3xAD9PnI4lRZxQ+3dcafVDSzYui+OHGo79YNbJr1xus66Q5iDjw7rAXPV6ZHHK
         VwHyqU69jtLleaiF6qwP3/R7jE0lVY65qAA9s5T8G649BCrxGwt4Vch9PXcV1c4so4Aa
         MqLLgXomSaEiQZnJUyHSpK0tfbbz5ykmLGaH9osEcufU/Ys/WF5BqOvNsKmGQcbRBaph
         OP7ujS+hgHsNUF1vAwxO0CbgHy1djE+5djyPIB98pHkMk9vffeXXvRXSJKBGCkrtjV5T
         W3xpA0dmwXQArWozsZ41hEyFoqrBwIFJ2PTahDLWD+FerhobZYdhQBjtdIlzflflThdL
         NYzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373104; x=1795977904;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1tWrOtic/buTkSk/2DlTQdnpgTD163OrV0WQJdUCLJE=;
        b=kkhj44BnoGvdZB0OyTp3RrkL3N2/eMh9Xryq5hLWpZOAR8bFhQ2007Ye1EuPCIyh09
         HEO/Bcmu/M2fliRR87zsNNnenSjYPhq6uwbr4nU4zUgNjdzezvmZLepM4OyOb24cZ+Em
         wAHLs2CfZl9R72GNocGbfky7KGfxqbny4HfhqMc5zVIa1kYYE4QrVNalYN6MehNWpNWp
         xNVrj9pXB7bCCNuI3UECnJn6FVNUNDqZsxndZ3xRJhX5sJzfRqGHJKn+VIB2iRvTI1cd
         Zgw5BAuwznOT7BbJsbhJLPeN37Qt5Q2XhUzTYfpmjFNPeDfLkMlvnCa55AYjw63z1ale
         3WpA==
X-Forwarded-Encrypted: i=1; AL+hErFBNrLY9hWzcXQH6OsMRa12uJM6NgQQhKG6yEN3NOlQ4jU2itVbvdhx19g4WRlvCG8+9IHTIdjKyg==@kvack.org
X-Gm-Message-State: APuU4Z+DB0+FybhmGMz8ADgLJKVAdga85mmjU5rgd7iLHdOSkrrOZx50
	7Sj/2xK5iJdI7P22Jf6988ATDmqxP9NXr/vgNOrAE/0Jb/mXETDthsx4vsEAEV3PXRrz1VUL6Lw
	bGqavHKFIG0UCJvDUWg1mNA==
X-Received: from plbmq8.prod.google.com ([2002:a17:902:fd48:b0:2f0:4f32:d57d])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ef45:b0:2ef:d7ed:80dc with SMTP id d9443c01a7336-2f03f1e0d55mr91461845ad.49.1795373103813;
 Sun, 22 Nov 2026 10:45:03 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:38 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-5-jthoughton@google.com>
Subject: [PATCH v3 04/19] hugetlb_vmemmap: Use try_update_vmemmap_pte to
 update in-use PTEs
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: erjmxqdnkkx8gmkf5n41id9nabacco8d
X-Rspam-User:
X-Rspamd-Queue-Id: 4235E40003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795373105-606811
X-HE-Meta: U2FsdGVkX18BkKzlYJrsDtnhMfPgeMvjRKbzC1e7Ls/Hm1obcP6+JiUkRDE316jMjMOa0eyaVFDpHwxoCpkKCvd4avjjzPXk/iYKOstW76pHpndkb7e8tlkyIKSwmYvLovbqK/jCpKbfof/dSX4d9GFV1gwLAFyp/l2MzXh1D0JCUsTT7qTCdn8JFK5UJMcS6anY2wmQTLwd6ZsFhxTePTEe6Ukzu2dlI6MGhJFo69IIvLhsInbdWdUVC/0XO9N+AQ6WRWM9b1rpFKvB/kqWoJnEphvwwa3E+t8/5gZPrbazgQDIF47gw37SFARWQD7Y2G9GbxP1ikTrHUO34kCsr899D7KYONDr+pq69cl3k0yem+7pK/GRlyzi5miDXYyAYFG2Rm1dHnWii74pmVlmAzhznBECuitOryYeZr1ApJ5whDG3i1ksfJ2GWxUOGlVyuTV5i5ktt7gv8ZVUnxTuG+b0Ps1zE9d0FA82rfHjkG3nxK0iesKhgrOjeQY6dnyRrWOXeXuzprcAG8gQ8pfQ2AhpGKPFMWfvCyvyoaXuFGsy2tPgFpMvkPvlybMCn3SbHa+hzD0hz/Ppu+NfLD5gMfVXEHApezrW8a/Fue//cIWb0jpPRNPCBOMb8t7TNdmdE3lda8TqLmsjqD9DCNC5DEtcoGDB1dVgTDw8bcoAsuYQhpBkv7KoJg0dD/iV90OOig956iNQlx6jL1B3owLVWTMAwYl0WcdtThG/BzHWOkzR+FfsHSfiaQ6P3b37PoxvuprgW0ppIm9EeTElewhlcJRJAJu2gfCzfQXctc2uGk6oNUq69cOkc8Fvv2hkmMOLnRwFCnVPmiQGsLPeqrN5XJr4IXj5McMbR7W2wIBAgqcxGGS/IM+iASwOWP92mcE1Uw5wb4FFdR/jBPpJttSIceinTd0GkFOuq8oSCPciecbz6eUr9n0gQ/wZFk/AN5640ZzDC0qHt6a7BBfH5sM
 ag4ByRQt
 Hpbk7zNzs9pWFdNTSEM4VBBOimFwH47DWUeAETfUrnUMiHAgnTtxuiLYH9Timvq1wIzyIY1eF+yER/H1RAe8/o1kYYo79YGp828FKmlwFHfkHhKPIH/LwI8f37Y9vi7egSXFhNeha4EbAIgogbrsvbwjt0ikLPXgNRom9xAmQ+rQNDXAxsmQWD2eW/0VgpDZa8CC8YA14/1AfzWSfX0EVBrpWQG9NmRFrwCugXMXa1A6GlRmOj4u6H+dWlf2hEaB7toXvqwRrbwYH6a4RiY58tzeYpyCmaXfnQZVb6A6TLdvr5M4vDMwH0LMtD3nfC8lSb/TbNo3YyjbL+PRqjoNZmnSvsMWTsDjSNR1chWLkSjTDZtFnF+9x1GTskZwYTC/ErW5XLf4YkjBHcME0jv6p6k7hwDuAiYhn3ueAzGv4wwG0jOX0NCiU3iGMPazrtPxWX37K+MJUEV4EFmkAWtcHMaDcxu6Cr9G/NjRid8rSHJshoq3Hee4yd2JZN5nlT0KfKIfDTq/sHKohhERA+AbVYxmum7AnK8hthvjiBNutK4w3cA0f1T1uajHkCfqO+mubhXnM6QTTspD+0/T4G1LD+9sYicNhEDq58yG5shb/NJmvKaBvqpAFQqdJoYzLEA6c1PqA3xeL0NJVxrL+mc3k0PfC0KvU9Vf6Wt9B5ep9eUvrOmjDTfk62rTiK0unWh64kRTMCHzE9ZS8ug/WfFMw+mEGn2ViuM2LZ8ezzkj5McREqs90Nuk4/N/REXCYm8MHt+g0idUNvBPfPdm4lZ4r8L23JzPTrmWgssP7sFNROIlJeLsZjRFd4WvrMJGgaTgRNI2ZoV8KbyGPD3vFbq6R0HLntFWVNN/VIL+q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
 arch/loongarch/include/asm/pgtable.h |  2 ++
 arch/riscv/include/asm/pgtable.h     |  2 ++
 arch/x86/include/asm/pgtable.h       |  2 ++
 include/linux/pgtable.h              | 22 +++++++++++++++++++
 mm/hugetlb_vmemmap.c                 | 32 +++++++++++++++++++++++-----
 5 files changed, 55 insertions(+), 5 deletions(-)

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
index 2ebd5fa5adc5..c8d05bc12cc8 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1172,6 +1172,8 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
+
 /*
  * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
  * are !pte_none() && !pte_present().
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 000fc6c1ca37..271cdc61de3a 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1372,6 +1372,8 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 }
 #endif
 
+#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
+
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static inline pud_t pudp_establish(struct vm_area_struct *vma,
 		unsigned long address, pud_t *pudp, pud_t pud)
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index bc1353f03b08..ab33df268955 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -458,6 +458,28 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
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
index 2e9cf8d39c89..b4d0311bcc4a 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -218,15 +218,19 @@ static int alloc_vmemmap_page_list(struct list_head *head,
 	return -ENOMEM;
 }
 
+/*
+ * Copy @src into the first page on @vmemmap_pages and return it. The page is
+ * left on the list; the caller must remove it only once it has successfully
+ * been installed in the vmemmap.
+ */
 static struct page *vmemmap_dup_page_from_list(const struct page *src,
 		struct list_head *vmemmap_pages)
 {
 	struct page *dst = list_first_entry(vmemmap_pages, struct page, lru);
 
-	list_del(&dst->lru);
 	copy_page(page_address(dst), page_address(src));
 
-	/* Ensure updates to @dst page are visible before set_pte_at(). */
+	/* Ensure updates to @dst page are visible before try_update_vmemmap_pte(). */
 	smp_wmb();
 
 	return dst;
@@ -248,6 +252,8 @@ static int vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
 	const struct page *page = (const struct page *)addr;
 	const struct folio *folio = page_folio(page);
 	struct page *src = pte_page(ptep_get(pte)), *dst;
+	bool dup = false;
+	int ret;
 
 	if (likely(vmemmap_optimizable_pfn(page_to_pfn(page), folio_order(folio)))) {
 		dst = folio_vmemmap_shared_tail_page(folio);
@@ -255,16 +261,27 @@ static int vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
 			return -ENOMEM;
 	} else {
 		dst = vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
+		dup = true;
 	}
 
-	list_add(&src->lru, walk->vmemmap_pages);
 	/*
 	 * Map the shared tail page writable intentionally. A lockless get that
 	 * read a non-zero refcount before the remap can still do its cmpxchg
 	 * after it. The refcount is zero, so the cmpxchg fails and leaves the
 	 * page unchanged.
 	 */
-	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
+	ret = try_update_vmemmap_pte(addr, pte, mk_pte(dst, PAGE_KERNEL));
+	if (ret)
+		return ret;
+
+	/*
+	 * We successfully overwrote the vmemmap PTE, so the page that was just
+	 * unmapped can be freed, and if we mapped a duplicated page, remove it
+	 * from the list so that it doesn't get freed later.
+	 */
+	if (dup)
+		list_del(&dst->lru);
+	list_add(&src->lru, walk->vmemmap_pages);
 
 	return 0;
 }
@@ -275,6 +292,7 @@ static int vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 	const struct page *page = (const struct page *)addr;
 	const struct folio *folio = page_folio(page);
 	struct page *src = pte_page(ptep_get(pte)), *dst, *tail;
+	int ret;
 
 	if (unlikely(!vmemmap_optimizable_pfn(page_to_pfn(page), folio_order(folio))))
 		return 0;
@@ -291,7 +309,11 @@ static int vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 		return 0;
 
 	dst = vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
-	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
+	ret = try_update_vmemmap_pte(addr, pte, mk_pte(dst, PAGE_KERNEL));
+	if (ret)
+		return ret;
+
+	list_del(&dst->lru);
 
 	return 0;
 }
-- 
2.56.1.809.ga0b61035b5-goog


