Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63417CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 09:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC562900005; Thu, 11 Sep 2025 05:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37CD900006; Thu, 11 Sep 2025 05:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8878B900005; Thu, 11 Sep 2025 05:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 462CD94000A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:56:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 124501DE7F1
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:56:51 +0000 (UTC)
X-FDA: 83876515422.20.68A5810
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0CC5920004
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:56:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757584609; a=rsa-sha256;
	cv=none;
	b=Mr3JuMSB95XoqZQuq2VgZdqnp3zv63mexVs/sB4h0EBrFpgxDC3sxZmLXsfZvutAUrp1Kh
	uJGy5F/161Bt7mMfLv0WCHlB7E6Y1uEi2OtA29E5Xlm2IGIEEAS4lAFyKGxJMwNY/HxUze
	xuxhCT/hYEGtT7kArNeoeOcvn1H7YIM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757584609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tn1dtTbxDZHjyfO3c1YVzpDAFpChuqwI8MyTAbRVQXk=;
	b=0qYVjS8FgP4W7T+91qMFwBWL+C5d6nxAmTNqJ6ShTsTmQgemLLqdninvGfgvoLZjpZfsF0
	5zCU1o85wfI0gvASDdqMMA1OcNmwalslW+OYR0pUqdP4MWFnrUs9VclguUVvSmD6Tzluxf
	0JcYpMKR6/aD0DAwpBY6xhQLrv7/oO0=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowACH2IK5nMJoo6pCAg--.44660S3;
	Thu, 11 Sep 2025 17:56:11 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH v11 1/5] mm: softdirty: Add pgtable_soft_dirty_supported()
Date: Thu, 11 Sep 2025 17:55:58 +0800
Message-Id: <20250911095602.1130290-2-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250911095602.1130290-1-zhangchunyan@iscas.ac.cn>
References: <20250911095602.1130290-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACH2IK5nMJoo6pCAg--.44660S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtrWfArW7XF1UKF4UZr17trb_yoW3Wr4Dpa
	yrGa4Fq3y8JF1vgayfJF4qqryaqF1Sqa47JryfC348J3y5G345WF4vqFyFvF1SgFy8XayS
	vrsrta13Gwsrtr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmvb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUGwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE
	c7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I
	8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCF
	s4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x
	0262kKe7AKxVW8ZVWrXwCY02Avz4vE14v_GFWl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC
	6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWw
	C2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_
	JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr
	0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUv
	cSsGvfC2KfnxnUUI43ZEXa7IUYk-P5UUUUU==
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBwoCB2jCjnQ4OgAAsa
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0CC5920004
X-Stat-Signature: g9qexbb69p141gnwf9whgansy44xopt9
X-Rspam-User: 
X-HE-Tag: 1757584607-656611
X-HE-Meta: U2FsdGVkX1+thQULHeTAC7XjmU6UY8AjGZKIogFRCckTqGjbnaYXXUjYpSmw6n86X4L8lP+qcDrScP+KVrK3jvU30gznEGHxB4sNZGZt8G9u3F/RdDfJSUsM4CuWg7a6TVq4FA57WiFUSmeulWbyxCsVjcQMZkPmnWdiRghgKsXDs0piq8+WZ9Jfej4pchG8Ye8NhN9lRSMXI6oz8eWUgF75bLXZ2qYWJIazTa2oEy9ijjauJXt8L3/HAFv6uoYn56u7n5FH+Udd4glsEx4aMMJFb1Ys6vYpoxVWJS11LeuIg/vXkwXYgwgkiWqD9JBviT9AZkriAYRfnTWlrrtMsf8PB0hjf69MX00y9MCY3/MqaNoVq3JEh+sevoi4rZ56ksZoEikqhwawVvLKHjleU2066uVaJEdXJSuTxK6ZEf3B2g8FR5ywbfDQYGns3i9KevpUvgbszd8g//kpr26R5UYrjSv1zrp+qVP91fZWa/kG6SDC++eJ/GKGggVtektC7hJg7m/5FGzR3M6CpdUEpTtfKzjO1Du6UFr8EMDaolG861X5UnzUPnxoAytokSWFwRAq2nEySKtmQdfJabtSWn4IQCAYsAf/kyP3Mk/MYO46TYmikYEx2GUjeQkeX4YOaUodN/6LdNqcoPh1uY28KEen3+uNhucS4IsClhWpkxgaOdSa6jI5asy19pRT+tpOl8Kfa/58LwtbMw4PQVG4A4TtJHPu+ThY4U9pnePA+1xJLdRScJzNauIPu4qqIOtjTwKZczEpO+6FbRPPaM0NHa4foWl2MkgtxdZqkwCODURpNcUhNcjYtMHP73UKqObMbMypBQWobxRNisYQzRyg04q/LWqMICyZOoOOV8E6xI+DP4QOeC/Wmifca4iVUZ1+OcKXkFI5+7ku+9TCzpuYqojlKgMlvC9FxqWoXyLSvcnjkwXBJDZEmDBVCOIc7uQYe+iUJcFS9P515WVkp74
 s1/ijkXb
 bMhFTvrQXlu0snZNOUfNGNeW2AujzuVIpRsKk6zMSoq2UCjU=
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

Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 fs/proc/task_mmu.c      | 17 ++++++++++++++++-
 include/linux/pgtable.h | 12 ++++++++++++
 mm/debug_vm_pgtable.c   | 10 +++++-----
 mm/huge_memory.c        | 13 +++++++------
 mm/internal.h           |  2 +-
 mm/mremap.c             | 13 +++++++------
 mm/userfaultfd.c        | 10 ++++------
 7 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 29cca0e6d0ff..9e8083b6d4cd 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1058,7 +1058,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 	 * -Werror=unterminated-string-initialization warning
 	 *  with GCC 15
 	 */
-	static const char mnemonics[BITS_PER_LONG][3] = {
+	static char mnemonics[BITS_PER_LONG][3] = {
 		/*
 		 * In case if we meet a flag we don't know about.
 		 */
@@ -1129,6 +1129,16 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 		[ilog2(VM_SEALED)] = "sl",
 #endif
 	};
+/*
+ * We should remove the VM_SOFTDIRTY flag if the soft-dirty bit is
+ * unavailable on which the kernel is running, even if the architecture
+ * provides the resource and soft-dirty is compiled in.
+ */
+#ifdef CONFIG_MEM_SOFT_DIRTY
+	if (!pgtable_soft_dirty_supported())
+		mnemonics[ilog2(VM_SOFTDIRTY)][0] = 0;
+#endif
+
 	size_t i;
 
 	seq_puts(m, "VmFlags: ");
@@ -1531,6 +1541,8 @@ static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr,
 static inline void clear_soft_dirty(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *pte)
 {
+	if (!pgtable_soft_dirty_supported())
+		return;
 	/*
 	 * The soft-dirty tracker uses #PF-s to catch writes
 	 * to pages, so write-protect the pte as well. See the
@@ -1566,6 +1578,9 @@ static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 {
 	pmd_t old, pmd = *pmdp;
 
+	if (!pgtable_soft_dirty_supported())
+		return;
+
 	if (pmd_present(pmd)) {
 		/* See comment in change_huge_pmd() */
 		old = pmdp_invalidate(vma, addr, pmdp);
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 4c035637eeb7..2a3578a4ae4c 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1537,6 +1537,18 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 #define arch_start_context_switch(prev)	do {} while (0)
 #endif
 
+/*
+ * Some platforms can customize the PTE soft-dirty bit making it unavailable
+ * even if the architecture provides the resource.
+ * Adding this API allows architectures to add their own checks for the
+ * devices on which the kernel is running.
+ * Note: When overiding it, please make sure the CONFIG_MEM_SOFT_DIRTY
+ * is part of this macro.
+ */
+#ifndef pgtable_soft_dirty_supported
+#define pgtable_soft_dirty_supported()	IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 #ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
 static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 830107b6dd08..b32ce2b0b998 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -690,7 +690,7 @@ static void __init pte_soft_dirty_tests(struct pgtable_debug_args *args)
 {
 	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
 
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!pgtable_soft_dirty_supported())
 		return;
 
 	pr_debug("Validating PTE soft dirty\n");
@@ -702,7 +702,7 @@ static void __init pte_swap_soft_dirty_tests(struct pgtable_debug_args *args)
 {
 	pte_t pte;
 
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!pgtable_soft_dirty_supported())
 		return;
 
 	pr_debug("Validating PTE swap soft dirty\n");
@@ -718,7 +718,7 @@ static void __init pmd_soft_dirty_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!pgtable_soft_dirty_supported())
 		return;
 
 	if (!has_transparent_hugepage())
@@ -734,8 +734,8 @@ static void __init pmd_swap_soft_dirty_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) ||
-		!IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
+	if (!pgtable_soft_dirty_supported() ||
+	    !IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
 		return;
 
 	if (!has_transparent_hugepage())
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9c38a95e9f09..218d430a2ec6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2271,12 +2271,13 @@ static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
 
 static pmd_t move_soft_dirty_pmd(pmd_t pmd)
 {
-#ifdef CONFIG_MEM_SOFT_DIRTY
-	if (unlikely(is_pmd_migration_entry(pmd)))
-		pmd = pmd_swp_mksoft_dirty(pmd);
-	else if (pmd_present(pmd))
-		pmd = pmd_mksoft_dirty(pmd);
-#endif
+	if (pgtable_soft_dirty_supported()) {
+		if (unlikely(is_pmd_migration_entry(pmd)))
+			pmd = pmd_swp_mksoft_dirty(pmd);
+		else if (pmd_present(pmd))
+			pmd = pmd_mksoft_dirty(pmd);
+	}
+
 	return pmd;
 }
 
diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc03..c6ca62f8ecf3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1538,7 +1538,7 @@ static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
 	 * VM_SOFTDIRTY is defined as 0x0, then !(vm_flags & VM_SOFTDIRTY)
 	 * will be constantly true.
 	 */
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!pgtable_soft_dirty_supported())
 		return false;
 
 	/*
diff --git a/mm/mremap.c b/mm/mremap.c
index e618a706aff5..7beb3114dbf5 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -162,12 +162,13 @@ static pte_t move_soft_dirty_pte(pte_t pte)
 	 * Set soft dirty bit so we can notice
 	 * in userspace the ptes were moved.
 	 */
-#ifdef CONFIG_MEM_SOFT_DIRTY
-	if (pte_present(pte))
-		pte = pte_mksoft_dirty(pte);
-	else if (is_swap_pte(pte))
-		pte = pte_swp_mksoft_dirty(pte);
-#endif
+	if (pgtable_soft_dirty_supported()) {
+		if (pte_present(pte))
+			pte = pte_mksoft_dirty(pte);
+		else if (is_swap_pte(pte))
+			pte = pte_swp_mksoft_dirty(pte);
+	}
+
 	return pte;
 }
 
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 45e6290e2e8b..85f43479b67a 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1065,9 +1065,8 @@ static int move_present_pte(struct mm_struct *mm,
 
 	orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
 	/* Set soft dirty bit so userspace can notice the pte was moved */
-#ifdef CONFIG_MEM_SOFT_DIRTY
-	orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
-#endif
+	if (pgtable_soft_dirty_supported())
+		orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
 	if (pte_dirty(orig_src_pte))
 		orig_dst_pte = pte_mkdirty(orig_dst_pte);
 	orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
@@ -1134,9 +1133,8 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	}
 
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
-#ifdef CONFIG_MEM_SOFT_DIRTY
-	orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
-#endif
+	if (pgtable_soft_dirty_supported())
+		orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
-- 
2.34.1


