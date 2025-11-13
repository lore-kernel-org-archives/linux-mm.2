Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4587CCD4F28
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 07:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3995C8E000C; Thu, 13 Nov 2025 02:28:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 337DB8E0008; Thu, 13 Nov 2025 02:28:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02A5F8E000C; Thu, 13 Nov 2025 02:28:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CDD418E000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:28:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 832FDBBB32
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:28:36 +0000 (UTC)
X-FDA: 84104756232.25.CDBE9E3
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	by imf19.hostedemail.com (Postfix) with ESMTP id EBB9A1A0008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:28:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763018914; a=rsa-sha256;
	cv=none;
	b=E7jq8RDgVUWkm4/YEkgIozPzlIJuIOSiWG8bxI4Z//5IgB7KJM1pzyAABAqxXwS71b+dxn
	745aMTIvVdMAp6BZxLA1ra9x0GLow+hYAIC+dDATT3mSoT8lOy570oeUFHqHLVUOJG9xHN
	N96baRQ2b8ZvONXdYYhAm9jgGTnTRRQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763018914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KnEAb2DucAjI7cmEH8YxMebpNNLhSlDLnQDNvBNQzME=;
	b=78yX4F5H76lD1BJeuEjTrVdXB72Bxx7wBms3T/n0kNuPIBQtVI9Jkzt3kHfOPe9vENR049
	TfT2VIXE0BCuw5qe3pGgHsUFXDWibU5C62ofS+ysvgQ6I03fZKxm6ZNHhBJoWaz9JXBGWY
	opgeRcyySDDkUYrQQc7jmRBqEtNpppo=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowABnbG2RiBVpVTOWAA--.33691S3;
	Thu, 13 Nov 2025 15:28:21 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: Andrew Morton <akpm@linux-foundation.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org,
	Peter Xu <peterx@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	linux-riscv@lists.infradead.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	devicetree@vger.kernel.org,
	Conor Dooley <conor@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH V15 1/6] mm: softdirty: Add pgtable_supports_soft_dirty()
Date: Thu, 13 Nov 2025 15:28:01 +0800
Message-Id: <20251113072806.795029-2-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251113072806.795029-1-zhangchunyan@iscas.ac.cn>
References: <20251113072806.795029-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABnbG2RiBVpVTOWAA--.33691S3
X-Coremail-Antispam: 1UD129KBjvJXoW3CFWUJF1xAr1kAr1kXr1rXrb_yoWkCrW7pF
	WkG3W5J3y8JF92grWxJr4qv343KrZaga4UCr13u348Aay5t345XF1rJFWrZFnIqry8ua4f
	ZFsFyw43C39rKr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmmb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUGwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv
	6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE
	4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7
	CjxVAaw2AFwI0_GFv_Wrylc2xSY4AK67AK6r4xMxAIw28IcxkI7VAKI48JMxC20s026xCa
	FVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
	Wlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j
	6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r
	1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1U
	YxBIdaVFxhVjvjDU0xZFpf9x07baxRDUUUUU=
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBwwFB2kVabByUgAAsM
X-Rspamd-Queue-Id: EBB9A1A0008
X-Rspamd-Server: rspam07
X-Stat-Signature: 8o5tgxy1kf935j7csks4f7851ig1mmdi
X-Rspam-User: 
X-HE-Tag: 1763018912-814361
X-HE-Meta: U2FsdGVkX1+cdE5+VOON6xNpTTqlxJhBPSZ7TmplFN1jLrEYCfliUP4NccdRQijJm94m5e+Kv4cSrn5oduG46mo3WF+Q8L6iE1plEEHVoPhVMYddksbFYBd/LcPLejoXXaGx66iDBL6p2bX7j3FjsUAw6nQ9eK1vseETBZA/4OsRzGnAcyswPMleFaG3wmTKZCpCtje0jl7sNuQfbx+3OGvoThDjNS9XdmvtzFF7XaUneOubPaCaL3ZmSwEJ2JlFCKvDSGJbEzWg+7y6FktsYhJyspcKEXG6kvnOdbl9Rs9lW/bPt1El7jiiNevIKJ0PnpZm8HHVhD2cyeEBy7T3Uz3PySQds8rCnZkCCUvTGg7sL0MyM5WwYwk8GL5gcbP2NWKWa/h0NgotJAH878UBBrrgtQ1GfheNlInSc1eL9j8MwWuHXXiwZrUq8ZNCMw+ItBnfF+GIoAcngdrr1mQn+4tFR4l5/nj12A4ib7M2xhMd2M7ZHawW8DN0HhLql9mjSL/pULb9/+NMxpngKVhV2LvxLy1j/tunn3bDlHbso00ylEfpy46kjDhs77bjPYf1MrVo8v0mmSfrU1mOTgWV9wk85yPPVXh9kKvue71jLnh+Ve7YYz5QDWncgKcV50rBUktOmkSsUtSU0vH1Oa4zmm1bdk5FPn8dSbDR+V4cLl26Lrb8tk9KawNPM3jBr8Bt/MwBKXEef2qcRjLsufGGmlKXQIKrh3icuszmuS7dDzHCxxaZX74O0S6ooPDaPzIWJQBEjl2YCyZYh27nYYoKCHT5BoDL6pKFIEKW78GxTUy8b5L9RB6fp5YFVr0klaUGcUltX9w1BTD5hS1RAQ0UfwsidIqy0GStKJ1Bd6rp2qKwc0ql/9lUAkXA7w07JuUhan1dDidqgSZ6C3cBVUKnpZEymtG3lW6Z5efCv0vVHQGcIUy6ke2GQz4/vB2b0rufkCCeXVJbI0OIhuUv/I1
 XApzs2Ei
 Y3iRrIhvPzU3EzlnefzD4JSFw1gGxCeIYi6aUGX0QMN6SODN3iTkHHavUF7rlT9FC7C4IheDZIzFz+jEy+DOzuYKl41CG61xfTIeHCHucVxL/j7fgjI/2GR8lpEjR5wpOF3Ejwf61B9/4wvGfwDO/rJNoeDQlDNadv1mFjK5TGBUlDn06W1TaswmGOPaAzAaa38A9aCFSQMdsfXOkwaShXCUK+ybfNHxEH8xAsejHkOenWWnSaV3e2cE70l7jQ0WNbqQyM+E1Ov/wHYzoqSuPBBtMD46b+Z1YsWw5M/2tGcAgrUuu7/L2rzmrklCcgW+/hwZ/zUeg2Z6EZ7U3peKSPwU/2x9TJkKJVYoX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some platforms can customize the PTE PMD entry soft-dirty bit making it
unavailable even if the architecture provides the resource.

Add an API which architectures can define their specific implementations
to detect if soft-dirty bit is available on which device the kernel is
running.

This patch is removing "ifdef CONFIG_MEM_SOFT_DIRTY" in favor of
pgtable_supports_soft_dirty() checks that defaults to
IS_ENABLED(CONFIG_MEM_SOFT_DIRTY), if not overridden by
the architecture, no change in behavior is expected.

We make sure to never set VM_SOFTDIRTY if !pgtable_supports_soft_dirty(),
so we will never run into VM_SOFTDIRTY checks.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 fs/proc/task_mmu.c      | 15 ++++++---------
 include/linux/mm.h      |  3 +++
 include/linux/pgtable.h | 12 ++++++++++++
 mm/debug_vm_pgtable.c   | 10 +++++-----
 mm/huge_memory.c        | 13 +++++++------
 mm/internal.h           |  2 +-
 mm/mmap.c               |  6 ++++--
 mm/mremap.c             | 13 +++++++------
 mm/userfaultfd.c        | 10 ++++------
 mm/vma.c                |  6 ++++--
 mm/vma_exec.c           |  5 ++++-
 11 files changed, 57 insertions(+), 38 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 41b062ce6ad8..2b4ab5718ab5 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1584,8 +1584,6 @@ struct clear_refs_private {
 	enum clear_refs_types type;
 };
 
-#ifdef CONFIG_MEM_SOFT_DIRTY
-
 static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 {
 	struct folio *folio;
@@ -1605,6 +1603,8 @@ static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr,
 static inline void clear_soft_dirty(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *pte)
 {
+	if (!pgtable_supports_soft_dirty())
+		return;
 	/*
 	 * The soft-dirty tracker uses #PF-s to catch writes
 	 * to pages, so write-protect the pte as well. See the
@@ -1630,19 +1630,16 @@ static inline void clear_soft_dirty(struct vm_area_struct *vma,
 		set_pte_at(vma->vm_mm, addr, pte, ptent);
 	}
 }
-#else
-static inline void clear_soft_dirty(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *pte)
-{
-}
-#endif
 
-#if defined(CONFIG_MEM_SOFT_DIRTY) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE)
 static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
 	pmd_t old, pmd = *pmdp;
 
+	if (!pgtable_supports_soft_dirty())
+		return;
+
 	if (pmd_present(pmd)) {
 		/* See comment in change_huge_pmd() */
 		old = pmdp_invalidate(vma, addr, pmdp);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 43eec43da66a..687c462f2a71 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -861,6 +861,7 @@ static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
 static inline void vm_flags_init(struct vm_area_struct *vma,
 				 vm_flags_t flags)
 {
+	VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
 	ACCESS_PRIVATE(vma, __vm_flags) = flags;
 }
 
@@ -879,6 +880,7 @@ static inline void vm_flags_reset(struct vm_area_struct *vma,
 static inline void vm_flags_reset_once(struct vm_area_struct *vma,
 				       vm_flags_t flags)
 {
+	VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
 	vma_assert_write_locked(vma);
 	WRITE_ONCE(ACCESS_PRIVATE(vma, __vm_flags), flags);
 }
@@ -886,6 +888,7 @@ static inline void vm_flags_reset_once(struct vm_area_struct *vma,
 static inline void vm_flags_set(struct vm_area_struct *vma,
 				vm_flags_t flags)
 {
+	VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
 	vma_start_write(vma);
 	ACCESS_PRIVATE(vma, __vm_flags) |= flags;
 }
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 32e8457ad535..b13b6f42be3c 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1553,6 +1553,18 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 #define arch_start_context_switch(prev)	do {} while (0)
 #endif
 
+/*
+ * Some platforms can customize the PTE soft-dirty bit making it unavailable
+ * even if the architecture provides the resource.
+ * Adding this API allows architectures to add their own checks for the
+ * devices on which the kernel is running.
+ * Note: When overriding it, please make sure the CONFIG_MEM_SOFT_DIRTY
+ * is part of this macro.
+ */
+#ifndef pgtable_supports_soft_dirty
+#define pgtable_supports_soft_dirty()	IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 #ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
 static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 1eae87dbef73..ae9b9310d96f 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -704,7 +704,7 @@ static void __init pte_soft_dirty_tests(struct pgtable_debug_args *args)
 {
 	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
 
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!pgtable_supports_soft_dirty())
 		return;
 
 	pr_debug("Validating PTE soft dirty\n");
@@ -717,7 +717,7 @@ static void __init pte_swap_soft_dirty_tests(struct pgtable_debug_args *args)
 	pte_t pte;
 	softleaf_t entry;
 
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!pgtable_supports_soft_dirty())
 		return;
 
 	pr_debug("Validating PTE swap soft dirty\n");
@@ -734,7 +734,7 @@ static void __init pmd_soft_dirty_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!pgtable_supports_soft_dirty())
 		return;
 
 	if (!has_transparent_hugepage())
@@ -750,8 +750,8 @@ static void __init pmd_leaf_soft_dirty_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) ||
-		!IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
+	if (!pgtable_supports_soft_dirty() ||
+	    !IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
 		return;
 
 	if (!has_transparent_hugepage())
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0184cd915f44..d04fedbbf799 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2427,12 +2427,13 @@ static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
 
 static pmd_t move_soft_dirty_pmd(pmd_t pmd)
 {
-#ifdef CONFIG_MEM_SOFT_DIRTY
-	if (unlikely(pmd_is_migration_entry(pmd)))
-		pmd = pmd_swp_mksoft_dirty(pmd);
-	else if (pmd_present(pmd))
-		pmd = pmd_mksoft_dirty(pmd);
-#endif
+	if (pgtable_supports_soft_dirty()) {
+		if (unlikely(pmd_is_migration_entry(pmd)))
+			pmd = pmd_swp_mksoft_dirty(pmd);
+		else if (pmd_present(pmd))
+			pmd = pmd_mksoft_dirty(pmd);
+	}
+
 	return pmd;
 }
 
diff --git a/mm/internal.h b/mm/internal.h
index 929bc4a5dd98..04c307ee33ae 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1554,7 +1554,7 @@ static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
 	 * VM_SOFTDIRTY is defined as 0x0, then !(vm_flags & VM_SOFTDIRTY)
 	 * will be constantly true.
 	 */
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!pgtable_supports_soft_dirty())
 		return false;
 
 	/*
diff --git a/mm/mmap.c b/mm/mmap.c
index dc51680824ec..4bdb9ffa9e25 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1448,8 +1448,10 @@ static struct vm_area_struct *__install_special_mapping(
 		return ERR_PTR(-ENOMEM);
 
 	vma_set_range(vma, addr, addr + len, 0);
-	vm_flags_init(vma, (vm_flags | mm->def_flags |
-		      VM_DONTEXPAND | VM_SOFTDIRTY) & ~VM_LOCKED_MASK);
+	vm_flags |= mm->def_flags | VM_DONTEXPAND;
+	if (pgtable_supports_soft_dirty())
+		vm_flags |= VM_SOFTDIRTY;
+	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
 	vma->vm_ops = ops;
diff --git a/mm/mremap.c b/mm/mremap.c
index fdb0485ede74..672264807db6 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -165,12 +165,13 @@ static pte_t move_soft_dirty_pte(pte_t pte)
 	 * Set soft dirty bit so we can notice
 	 * in userspace the ptes were moved.
 	 */
-#ifdef CONFIG_MEM_SOFT_DIRTY
-	if (pte_present(pte))
-		pte = pte_mksoft_dirty(pte);
-	else
-		pte = pte_swp_mksoft_dirty(pte);
-#endif
+	if (pgtable_supports_soft_dirty()) {
+		if (pte_present(pte))
+			pte = pte_mksoft_dirty(pte);
+		else
+			pte = pte_swp_mksoft_dirty(pte);
+	}
+
 	return pte;
 }
 
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index bd1f74a7a5ac..e6dfd5f28acd 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1119,9 +1119,8 @@ static long move_present_ptes(struct mm_struct *mm,
 
 		orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
 		/* Set soft dirty bit so userspace can notice the pte was moved */
-#ifdef CONFIG_MEM_SOFT_DIRTY
-		orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
-#endif
+		if (pgtable_supports_soft_dirty())
+			orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
 		if (pte_dirty(orig_src_pte))
 			orig_dst_pte = pte_mkdirty(orig_dst_pte);
 		orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
@@ -1208,9 +1207,8 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	}
 
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
-#ifdef CONFIG_MEM_SOFT_DIRTY
-	orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
-#endif
+	if (pgtable_supports_soft_dirty())
+		orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
diff --git a/mm/vma.c b/mm/vma.c
index 6cb082bc5e29..ad3d905a81db 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2555,7 +2555,8 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
 	 * then new mapped in-place (which must be aimed as
 	 * a completely new data area).
 	 */
-	vm_flags_set(vma, VM_SOFTDIRTY);
+	if (pgtable_supports_soft_dirty())
+		vm_flags_set(vma, VM_SOFTDIRTY);
 
 	vma_set_page_prot(vma);
 }
@@ -2860,7 +2861,8 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	mm->data_vm += len >> PAGE_SHIFT;
 	if (vm_flags & VM_LOCKED)
 		mm->locked_vm += (len >> PAGE_SHIFT);
-	vm_flags_set(vma, VM_SOFTDIRTY);
+	if (pgtable_supports_soft_dirty())
+		vm_flags_set(vma, VM_SOFTDIRTY);
 	return 0;
 
 mas_store_fail:
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index 922ee51747a6..8134e1afca68 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -107,6 +107,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 			  unsigned long *top_mem_p)
 {
+	unsigned long flags = VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;
 	int err;
 	struct vm_area_struct *vma = vm_area_alloc(mm);
 
@@ -137,7 +138,9 @@ int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 	BUILD_BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
 	vma->vm_end = STACK_TOP_MAX;
 	vma->vm_start = vma->vm_end - PAGE_SIZE;
-	vm_flags_init(vma, VM_SOFTDIRTY | VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP);
+	if (pgtable_supports_soft_dirty())
+		flags |= VM_SOFTDIRTY;
+	vm_flags_init(vma, flags);
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
 	err = insert_vm_struct(mm, vma);
-- 
2.34.1


