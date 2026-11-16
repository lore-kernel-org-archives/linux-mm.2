Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9691606A332
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oT+R11gA
Received: by kanga.kvack.org (Postfix)
	id F0C356B05C1; Mon, 16 Nov 2026 07:49:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC736B05C2; Mon, 16 Nov 2026 07:49:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9CA6B05C3; Mon, 16 Nov 2026 07:49:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDD686B05C1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:49:39 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3EFCD1401F9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:39 +0000 (UTC)
X-FDA: 85440963678.25.9AEC03B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 875691C000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oT+R11gA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qoB7g+eS1ylSOIwCWgqOZHTyzN8hCooYymexDoSw87s=;
	b=hYGRQU65Vlta3As0vQ408LaiMCRak7jqzY6fsQFONm+WLRSVJCIeyN9p97+hOX6px3sW+9
	yHh1BCIQX4sNBaYEdM5u4r3+FrI0byLKwIzmhk1BuzZAYZu2Da9FgOwrNasPkpQ7r8RbRT
	YSpG/PxKda53IPUmJzTt4NgUGbvssuk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833377;
	b=Hx3F9iDRO1tJlLA+tjY4BLGo2n5NkaBEDf3dkqtwSrA4pCC32yvaobDieLYO4IOE2QJAXg
	S6W7+pr5EC5bJ3YdiHCXC3BLzruQKTg9WlY5gKljE0lLYhIO6mG/Hhw2iSGhf4Tr+O89qP
	3x9HvZL0QiNHOxrPLiPfcTzHjzPI81o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oT+R11gA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 23542623F3;
	Mon, 16 Nov 2026 12:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370C91F000C9;
	Mon, 16 Nov 2026 12:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794833376;
	bh=qoB7g+eS1ylSOIwCWgqOZHTyzN8hCooYymexDoSw87s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oT+R11gAH0vSoXIiJOgzL5DZMmDQu0VBOCSu1NCF69MwsOaOw3S5H6STg2aurkm0c
	 vCW0onxviZL+52Xf8/hkUgFDwBhS+P/Xdk8+xVC+TqH3AjBlK2cn2o8M59Bk35+/D+
	 HyuNnlNXE+gcEo2hmCEL4ySU52WuasJXDzj+2Cg9Xso1he/SYgpAqBCZzh6vXCs+Sz
	 tiNjF2YDbfxn06+Z5wAHK6xzHxQ+nicz9fLY2nmzj4XZNUMisfcXrk6CFuCxd/4ztr
	 z8CFOOoCbzImh3vqm+Una6IOlMn+BUfRY0PB69xSwdMElN+DfbcNrS/qi5HthWGdKL
	 mbMs0PLz9MS/w==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linusw@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Lucas Stach <l.stach@pengutronix.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Nishanth Menon <nm@ti.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH v3 09/10] mm: drop HIGHPTE support altogether
Date: Mon, 16 Nov 2026 13:48:31 +0100
Message-ID: <20261116124832.662455-10-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116124832.662455-1-arnd@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ts5zgdgsnigwf6jrnzbuuionywn57g5
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 875691C000B
X-HE-Tag: 1794833377-544560
X-HE-Meta: U2FsdGVkX1/psApzjupGrzxRkAiywVKZMUx7x4pUWAwbl48kapPwgZJavK77x4CKcKHkbu4OSNUawmDv7IOjwq7bQAl4KjhGwiU5RjpEgyJX9WGpg8UucSpR3NnVTeDmaK4zJLjGoc8TMyMs9hdH2TOJpSSCx1Agdw5kFtLLJgWOth3SAO4XWqlUSuxgd2uNTloLYpL+IfugQZPB8U9wwLcF4J1ftmZEAho+7GeTdrkfRi6tPZO2Dc7TNSfJzsPpoM7Iy7WNfxbPkbA0Yn0A74LXdtMP1+mA6jjCYtqJpTvIQqOkgPWydZF7YPOoVveEI/DmR2twRezEf1XSkVMc8w7SPM2LxrDoTQsDoGjQCHZw5qVOSIeay3rwM4NuVFkxyD7gLkckT+xgfWl9xYUhTzRkXOnZRei1giUZ1GZEeZc/bk+OZnsnVZrBok/AaWaKB6Z6VTcKLZG5C6chcbokZbNjHuVKTyOXQ7lK/t2pMl6wlPrKRHe1KDTRxxwaNMbc6uNPOKu3xzrPrVuK5JBgX1z5JDkZR8L/w8pdo7dY5c4st8jaiW/MVT8aGCoU54IffAL1IoG7HzgYzv2GuvCLfnreBc47gHKm5PeI0r7h9LgDIJFFwcQHJiLt0KhSOqdXNvvcX0+MpUijuMJf7DjJEkUetwhJLnIjX+8qL7vq5OWO9O9LKXKdfY8Du4rkcDack+eYgDVGIRSS+Q0sNokjJkQazCi8e06EN1Vx6TGaj8OJ6qekcmBKzFZRfS7Qpd1PeBjDXXcPy8q6mqrFmOOJ35ntiRF1e1+AblF7s6gtB1wbSo1LIy8DxD0GC5AWNu7dDlb17sKncXdMtnUwUWBFA2CVBStZbPZV/5UHry3n4PW+SmH+n0CAQw0MHNBcoDr6j2SSoElumTL+jxoUKqzP9T8spqxkH2SJfp1I8wKoYGNUuiqDlFxWAZQva0jqGz6q3aTKPCt1eEnNusTQxdm
 QJMVapO+
 sbhiUciuRBxRHdmug36PfvsPhKAVgsPl0H1+UqsFIILFJ4VyXZZwJm5eOtvUwIBnJ5gbjZzWfEQm7EyolJfPoVJExe19mgqpoikFHCgzA0ykEUTMDnx7x/e/RFWSypKiDyGagzRumfwA2NKurLAhyyc7rhfBt67Dv+y+OYwe6BOe83+16kMePfTNZ7YpXViH1wNo/xgZCBJJoLnblkXHdU73lgja/1RiVWII1Qm1MmCVD16M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

With both x86 and arm having dropped CONFIG_HIGHPTE support, no
architecture is left using it, so remove the remnants in common code.

It is likely that further cleanups are possible in the page table
code but those are not obvious from the config options.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/hugetlb.h |  5 +----
 include/linux/mm.h      |  1 -
 include/linux/pgtable.h | 13 -------------
 mm/pgtable-generic.c    | 25 ++++++++++++-------------
 mm/userfaultfd.c        |  6 +-----
 5 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 58f755e70e96..7c6d191fdf50 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -178,7 +178,6 @@ void hugetlb_bootmem_set_nodes(void);
 
 /* arch callbacks */
 
-#ifndef CONFIG_HIGHPTE
 /*
  * pte_offset_huge() and pte_alloc_huge() are helpers for those architectures
  * which may go down to the lowest PTE level in their huge_pte_offset() and
@@ -193,7 +192,6 @@ static inline pte_t *pte_alloc_huge(struct mm_struct *mm, pmd_t *pmd,
 {
 	return pte_alloc(mm, pmd) ? NULL : pte_offset_huge(pmd, address);
 }
-#endif
 
 pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long addr, unsigned long sz);
@@ -1047,9 +1045,8 @@ static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 	 */
 	if (size >= PUD_SIZE)
 		return pud_lockptr(mm, (pud_t *) pte);
-	else if (size >= PMD_SIZE || IS_ENABLED(CONFIG_HIGHPTE))
+	else if (size >= PMD_SIZE)
 		return pmd_lockptr(mm, (pmd_t *) pte);
-	/* pte_alloc_huge() only applies with !CONFIG_HIGHPTE */
 	return ptep_lockptr(mm, pte);
 }
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6af3b7008f1a..019de55bd796 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4025,7 +4025,6 @@ static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pmd_t *pmd)
 
 static inline spinlock_t *ptep_lockptr(struct mm_struct *mm, pte_t *pte)
 {
-	BUILD_BUG_ON(IS_ENABLED(CONFIG_HIGHPTE));
 	BUILD_BUG_ON(MAX_PTRS_PER_PTE * sizeof(pte_t) > PAGE_SIZE);
 	return ptlock_ptr(virt_to_ptdesc(pte));
 }
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 780fe849ff8b..594c309b1475 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -100,23 +100,10 @@ static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address)
 #define pte_offset_kernel pte_offset_kernel
 #endif
 
-#ifdef CONFIG_HIGHPTE
-#define __pte_map(pmd, address) \
-	((pte_t *)kmap_local_page(pmd_page(*(pmd))) + pte_index((address)))
-#define pte_unmap(pte)	do {	\
-	kunmap_local((pte));	\
-	rcu_read_unlock();	\
-} while (0)
-#else
-static inline pte_t *__pte_map(pmd_t *pmd, unsigned long address)
-{
-	return pte_offset_kernel(pmd, address);
-}
 static inline void pte_unmap(pte_t *pte)
 {
 	rcu_read_unlock();
 }
-#endif
 
 void pte_free_defer(struct mm_struct *mm, pgtable_t pgtable);
 
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 6e83ce3801b8..f78b9d874b93 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -314,7 +314,7 @@ pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
 		pmd_clear_bad(pmd);
 		goto nomap;
 	}
-	return __pte_map(&pmdval, addr);
+	return pte_offset_kernel(&pmdval, addr);
 nomap:
 	rcu_read_unlock();
 	return NULL;
@@ -353,11 +353,11 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
  * for read (or for write). In a few cases, it may be used with pmd pointing to
  * a pmd_t already copied to or constructed on the stack.
  *
- * When successful, it returns the pte pointer for addr, with its page table
- * kmapped if necessary (when CONFIG_HIGHPTE), and locked against concurrent
- * modification by software, with a pointer to that spinlock in ptlp (in some
- * configs mm->page_table_lock, in SPLIT_PTLOCK configs a spinlock in table's
- * struct page).  pte_unmap_unlock(pte, ptl) to unlock and unmap afterwards.
+ * When successful, it returns the pte pointer for addr, locked against
+ * concurrent modification by software, with a pointer to that spinlock in ptlp
+ * (in some configs mm->page_table_lock, in SPLIT_PTLOCK configs a spinlock in
+ * table's struct page).  pte_unmap_unlock(pte, ptl) to unlock and unmap
+ * afterwards.
  *
  * But it is unsuccessful, returning NULL with *ptlp unchanged, if there is no
  * page table at *pmd: if, for example, the page table has just been removed,
@@ -366,13 +366,12 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
  * page table can be safely removed or replaced by THP while holding its lock.)
  *
  * pte_offset_map(pmd, addr), and its internal helper __pte_offset_map() above,
- * just returns the pte pointer for addr, its page table kmapped if necessary;
- * or NULL if there is no page table at *pmd.  It does not attempt to lock the
- * page table, so cannot normally be used when the page table is to be updated,
- * or when entries read must be stable.  But it does take rcu_read_lock(): so
- * that even when page table is racily removed, it remains a valid though empty
- * and disconnected table.  Until pte_unmap(pte) unmaps and rcu_read_unlock()s
- * afterwards.
+ * just returns the pte pointer for addr, or NULL if there is no page table at
+ * *pmd.  It does not attempt to lock the page table, so cannot normally be
+ * used when the page table is to be updated, or when entries read must be
+ * stable.  But it does take rcu_read_lock(): so that even when page table is
+ * racily removed, it remains a valid though empty and disconnected table.
+ * Until pte_unmap(pte) unmaps and rcu_read_unlock()s afterwards.
  *
  * pte_offset_map_ro_nolock(mm, pmd, addr, ptlp), above, is like pte_offset_map();
  * but when successful, it also outputs a pointer to the spinlock in ptlp - as
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 169f681f9849..f6bf476abdcd 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1696,11 +1696,7 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 		folio_unlock(src_folio);
 		folio_put(src_folio);
 	}
-	/*
-	 * Unmap in reverse order (LIFO) to maintain proper kmap_local
-	 * index ordering when CONFIG_HIGHPTE is enabled. We mapped dst_pte
-	 * first, then src_pte, so we must unmap src_pte first, then dst_pte.
-	 */
+
 	if (src_pte)
 		pte_unmap(src_pte);
 	if (dst_pte)
-- 
2.53.0


