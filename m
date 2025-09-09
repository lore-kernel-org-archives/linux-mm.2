Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68BF1CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 10:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8297D8E001A; Tue,  9 Sep 2025 06:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8013F8E0013; Tue,  9 Sep 2025 06:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73E198E001A; Tue,  9 Sep 2025 06:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 631FA8E0013
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:04:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1926BB98BF
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:04:48 +0000 (UTC)
X-FDA: 83869277856.16.F53B5D1
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf17.hostedemail.com (Postfix) with ESMTP id 208C740010
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:04:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757412286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l+hDs/RQUGqBwYvOss16JAczPj6Kji5uyPB/mJgAeD8=;
	b=soABU2cIP6a622zbc1asu8MKhOo9Saxp2QkTgShA7AvjGEpbbuUs1FWIa8akh/DjxtmGbx
	qWW11Umi+XQOMm5xndkZSfgiiLO+0T9Y76U6Hvrr14/kYA0KUuvOiRXFpPKwRxZoR36I8C
	EmdgZ7f4d2JGoyLD1lwMG+Koxr3fuzk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757412286; a=rsa-sha256;
	cv=none;
	b=pzJ4kgVXDAM4Bt8IRAd6r4CV9NH8b9WmTsJYumaZoBID8ylT4hJUEzvtTssd5p31yQVQuw
	ulEOLcBIciSLNS4QmxjCDSc/J8AOW8ZFnEnuGNHjB7Gku+cclg+HljYDpKpLuacNKIXWpL
	lIkPmU3ADKIOhM/RY+/Vl4rVvqG8xfs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
Received: from ubt.. (unknown [210.73.43.101])
	by APP-01 (Coremail) with SMTP id qwCowADHHqHO+b9oWh7qAQ--.61766S3;
	Tue, 09 Sep 2025 17:56:32 +0800 (CST)
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
Subject: [PATCH V10 1/5] mm: softdirty: Add pte_soft_dirty_available()
Date: Tue,  9 Sep 2025 17:56:07 +0800
Message-Id: <20250909095611.803898-2-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250909095611.803898-1-zhangchunyan@iscas.ac.cn>
References: <20250909095611.803898-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADHHqHO+b9oWh7qAQ--.61766S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Wry5Xr4UJFy7tFyrJFWrXwb_yoW3XFWfpF
	WfG3WFq3y8JF1vgayfJr4qqryaqF4Sga4UGryfC348Xw43G398WFsYqFyFvF1SgFy8Jaya
	vFsFyw43CrZrtr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmmb7Iv0xC_KF4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUGwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv
	6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJwAm72CE
	4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7
	CjxVAaw2AFwI0_GFv_Wrylc2xSY4AK67AK6r4fMxAIw28IcxkI7VAKI48JMxC20s026xCa
	FVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
	Wlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j
	6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r
	1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1U
	YxBIdaVFxhVjvjDU0xZFpf9x07jBuWdUUUUU=
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAUAB2i-53NJcwAAs3
X-Stat-Signature: i7fqkw81h9mizibukqs9dq1qbofc1rs3
X-Rspam-User: 
X-Rspamd-Queue-Id: 208C740010
X-Rspamd-Server: rspam10
X-HE-Tag: 1757412284-355525
X-HE-Meta: U2FsdGVkX19TWgF1IsxYViJ7Np54RMbcU6Irp8LoIky26msdmd7Iqcoil3CdyHJEPPCsBfpCC1chmhsMNSY9W+fDEjQCKpsR8FUbjKTdUV48L4JeiiQCeedUamPa+miEWqfO3z7UMWdfSUqPYD+kPp8FlHbNwti31w7sOlVDmcxkeAbdt3AcBJLr9ubPTYw2Y2SkLuCJYY4eHeT5Dxe0BpFJk7/0UdfeUN7JwHMrqF/ylsZ1uQRHrxkbsK+eK+vA9XMj7PpwvuR500pdHQO5ETZhNUlRX5Ks/KMj7FlH/3ZPypSMY7K/D5zFKl7EWXVrMetCw7651lGBA4ZSSMx9/vZa9W1ckDpdWPUV/qYpWZJ5U0n04FiL54JC4YqSETr+SNFnIEOvlSWOYhJso5d1PHHVyP4FSbnR421Ay5jhy2bTtwoiFWsIMUUH8tP5i9P6ehZpIP52egY4g9rBHK3rsjfbQVTBM2wzmNjUxJLm8tpHclrWcXY1Hd1z1EktOxydyBeuK1lUY3pvx2mFt4flSmD2ZU+G/4/q5UWS9ImDBrIwF3uod71TaS31K3YPI52epd1EsEyLdXR/VVyEServRbi/GQ3EUMwu4cFSaOjaARQJ8Wn+Xop2HL7PvhnwxjtNFSfiirs2PcjPyRCZvo8RKuqU33kJGlo2/26sMTW/dLiDSs8/otWhvp13gIPWosHFEmbUDohk7ompbKKvnFY0AvNYj0t3xWZabDHSv2yqd0EFdEqTPgQZIggeWkH3wmD0SyJBNE7OivzhzP+ZV1XGZZqI2+ZP2lR0v+vAp++5u6yj9iaKOD8hMN09hBPe5FYl8JrIfYPb04ZsZqPJaYcUD26TpLpgTM3yKjUMfUTaEIv4CZ5NFXsznUe8ts1hLq5qmYZ36Afh8x0ahpCR52ougtad3njjlSiRb1K/uLelhZtL9YcKjEjL36uNdTwwqGVrKtYuIFfM418bzidmgMZ
 /l/pu21D
 wS3Qh+Pbhda8RxHU7IO0Vds75sQA4D9RQ5AJ4hxilT/te9lyKvx6thcW6Te8ZqWiC1jooJaOnqGm+4bnC3ZkEmgx19nZC2/z8XqYGFUhxLMg9vHQscRq5ClM5vpxg8hYwjrjWqMLg1dsc07/QR0bVRVj99WsnYotF+1Ye1/P6cLIrml5VWSK8slzZy5lymJqwc8sSmJ5LnhralwQ2ogo4HcvDmh/5WBCT5SWvv6zDRqTCyQpWzcaKG3LZOP7GAudXO0c3k6Ejc6MrixEFMR/l4Qe2RJyukCuTJsrAz0cab0WqFp4egNmnX0X036r4NdOKpHBo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some platforms can customize the PTE soft dirty bit and make it unavailable
even if the architecture allows providing the PTE resource.

Add an API which architectures can define their specific implementations
to detect if the PTE soft-dirty bit is available, on which the kernel
is running.

Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 fs/proc/task_mmu.c      | 17 ++++++++++++++++-
 include/linux/pgtable.h | 10 ++++++++++
 mm/debug_vm_pgtable.c   |  9 +++++----
 mm/huge_memory.c        | 10 ++++++----
 mm/internal.h           |  2 +-
 mm/mremap.c             | 10 ++++++----
 mm/userfaultfd.c        |  6 ++++--
 7 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 29cca0e6d0ff..20a609ec1ba6 100644
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
+ * We should remove the VM_SOFTDIRTY flag if the PTE soft-dirty bit is
+ * unavailable on which the kernel is running, even if the architecture
+ * allows providing the PTE resource and soft-dirty is compiled in.
+ */
+#ifdef CONFIG_MEM_SOFT_DIRTY
+	if (!pte_soft_dirty_available())
+		mnemonics[ilog2(VM_SOFTDIRTY)][0] = 0;
+#endif
+
 	size_t i;
 
 	seq_puts(m, "VmFlags: ");
@@ -1531,6 +1541,8 @@ static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr,
 static inline void clear_soft_dirty(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *pte)
 {
+	if (!pte_soft_dirty_available())
+		return;
 	/*
 	 * The soft-dirty tracker uses #PF-s to catch writes
 	 * to pages, so write-protect the pte as well. See the
@@ -1566,6 +1578,9 @@ static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 {
 	pmd_t old, pmd = *pmdp;
 
+	if (!pte_soft_dirty_available())
+		return;
+
 	if (pmd_present(pmd)) {
 		/* See comment in change_huge_pmd() */
 		old = pmdp_invalidate(vma, addr, pmdp);
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 4c035637eeb7..c0e2a6dc69f4 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1538,6 +1538,15 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
+
+/*
+ * Some platforms can customize the PTE soft dirty bit and make it unavailable
+ * even if the architecture allows providing the PTE resource.
+ */
+#ifndef pte_soft_dirty_available
+#define pte_soft_dirty_available()	(true)
+#endif
+
 #ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
 static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
 {
@@ -1555,6 +1564,7 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 }
 #endif
 #else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
+#define pte_soft_dirty_available()	(false)
 static inline int pte_soft_dirty(pte_t pte)
 {
 	return 0;
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 830107b6dd08..98ed7e22ccec 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -690,7 +690,7 @@ static void __init pte_soft_dirty_tests(struct pgtable_debug_args *args)
 {
 	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
 
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) || !pte_soft_dirty_available())
 		return;
 
 	pr_debug("Validating PTE soft dirty\n");
@@ -702,7 +702,7 @@ static void __init pte_swap_soft_dirty_tests(struct pgtable_debug_args *args)
 {
 	pte_t pte;
 
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) || !pte_soft_dirty_available())
 		return;
 
 	pr_debug("Validating PTE swap soft dirty\n");
@@ -718,7 +718,7 @@ static void __init pmd_soft_dirty_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) || !pte_soft_dirty_available())
 		return;
 
 	if (!has_transparent_hugepage())
@@ -735,7 +735,8 @@ static void __init pmd_swap_soft_dirty_tests(struct pgtable_debug_args *args)
 	pmd_t pmd;
 
 	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) ||
-		!IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
+	    !pte_soft_dirty_available() ||
+	    !IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
 		return;
 
 	if (!has_transparent_hugepage())
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9c38a95e9f09..4e4fd56c0c18 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2272,10 +2272,12 @@ static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
 static pmd_t move_soft_dirty_pmd(pmd_t pmd)
 {
 #ifdef CONFIG_MEM_SOFT_DIRTY
-	if (unlikely(is_pmd_migration_entry(pmd)))
-		pmd = pmd_swp_mksoft_dirty(pmd);
-	else if (pmd_present(pmd))
-		pmd = pmd_mksoft_dirty(pmd);
+	if (pte_soft_dirty_available()) {
+		if (unlikely(is_pmd_migration_entry(pmd)))
+			pmd = pmd_swp_mksoft_dirty(pmd);
+		else if (pmd_present(pmd))
+			pmd = pmd_mksoft_dirty(pmd);
+	}
 #endif
 	return pmd;
 }
diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc03..8a5b20fac892 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1538,7 +1538,7 @@ static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
 	 * VM_SOFTDIRTY is defined as 0x0, then !(vm_flags & VM_SOFTDIRTY)
 	 * will be constantly true.
 	 */
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) || !pte_soft_dirty_available())
 		return false;
 
 	/*
diff --git a/mm/mremap.c b/mm/mremap.c
index e618a706aff5..788dd8aaae47 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -163,10 +163,12 @@ static pte_t move_soft_dirty_pte(pte_t pte)
 	 * in userspace the ptes were moved.
 	 */
 #ifdef CONFIG_MEM_SOFT_DIRTY
-	if (pte_present(pte))
-		pte = pte_mksoft_dirty(pte);
-	else if (is_swap_pte(pte))
-		pte = pte_swp_mksoft_dirty(pte);
+	if (pte_soft_dirty_available()) {
+		if (pte_present(pte))
+			pte = pte_mksoft_dirty(pte);
+		else if (is_swap_pte(pte))
+			pte = pte_swp_mksoft_dirty(pte);
+	}
 #endif
 	return pte;
 }
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 45e6290e2e8b..94f159a680a4 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1066,7 +1066,8 @@ static int move_present_pte(struct mm_struct *mm,
 	orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
 	/* Set soft dirty bit so userspace can notice the pte was moved */
 #ifdef CONFIG_MEM_SOFT_DIRTY
-	orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
+	if (pte_soft_dirty_available())
+		orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
 #endif
 	if (pte_dirty(orig_src_pte))
 		orig_dst_pte = pte_mkdirty(orig_dst_pte);
@@ -1135,7 +1136,8 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
 #ifdef CONFIG_MEM_SOFT_DIRTY
-	orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
+	if (pte_soft_dirty_available())
+		orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
 #endif
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
-- 
2.34.1


