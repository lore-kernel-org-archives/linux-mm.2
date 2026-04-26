Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C018FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 12:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CE7A6B0093; Sun, 26 Apr 2026 08:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5F36B0095; Sun, 26 Apr 2026 08:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71FCE6B0096; Sun, 26 Apr 2026 08:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60D0C6B0093
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:57:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D62A160635
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:57:51 +0000 (UTC)
X-FDA: 84700709142.25.484A3E5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 01D4D1C0004
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:57:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf21.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777208269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BhJFrOuMpm/3UsgW/+8TM5V2bE1KOU+zDCK7VpePrUw=;
	b=omjNtCOP48vdwdjUqKRvELE4rfus/sjh3f3lmPq4AHR2sDkWPxI9CwQrx5fTj5V/r9y68X
	XIfVGAns8UuQxXCf/SUpZSO5VfshofQMevE1HgJ9C8Vb7efe0EF/3nb7HO5+MUOSPC3sEM
	FArQA4AQYqfR01X/arN9UjjpI5L+204=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777208269; a=rsa-sha256;
	cv=none;
	b=WJkmuTwGgxuVDlEyx+ipPxkXIqee/4olW1INvVGURxkeAubL0unqCiBk+Pw+GuQEPfgFMQ
	6KphjsOgtm1WeefvKsJMst5q69jEWfuXtudyje89X6CYpNTv13LeMvMsz6YxUNy4+xvIT7
	samFlCFEIjXukXyZlsv0FBA3R7eplTI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf21.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8EA3F6A7F6;
	Sun, 26 Apr 2026 12:57:41 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F6F3593B0;
	Sun, 26 Apr 2026 12:57:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EH2kBcUL7mmtRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sun, 26 Apr 2026 12:57:41 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>
Subject: [RFC PATCH v2 4/7] mm: Implement pt_range_walk
Date: Sun, 26 Apr 2026 14:57:16 +0200
Message-ID: <20260426125719.24698-5-osalvador@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260426125719.24698-1-osalvador@suse.de>
References: <20260426125719.24698-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 01D4D1C0004
X-Rspamd-Server: rspam04
X-Stat-Signature: ou43iz6fgkeshy6uzpijxdqye97g9sxn
X-HE-Tag: 1777208268-89624
X-HE-Meta: U2FsdGVkX1/sxd2hEZ6hqz8zRs9cThip/MR7Hlpy9V6bT619b/9YbwyeuSqfgWy5WJD11sO6J9PbqVUiMuV4maBH+QiAAiG3bfBesyiEcchsNCcb9O5AiSSQeoFEABqRa/8k4gk1hDS3bx35i9IurtTh5gUUmhM7q/gKAf4FAuu5y48N8hFFarrf+CR3u/bpbAIF71OSR69O47bJN4A7ZburWDCmlp4uXmCtq9YOMtbjyQheNkUH5fdIdxzgiGFPHQzp4QI5GVM7eSWi+wK9ercf9FRF0lUwHXVNbMk2PPEv2UT7yun020tbLk11s3dm3uA0WiRnfhZXOfZcrbCHB6usyddV8BAnyssWtpDjU28X04S6esaCEVCXvdIDbdRZHNnzE/+QSHw/I40Fo3iWKCY8xLZWNmi2xwEloOpwNlsUYS30tre6Ci7n7EaftFg25KPL3fiOSVcqfcK77LUe4aU12+HiutckkJDlBhw4Sh5x37SEXcgnV1fRm1/xNHAkaLOVpsRu9+Ya0jXHUS1t4v2ihakETHhtEGdQ1xw26RGrQX86thloGBiTUr+sucinf9xHg/QCVaTKTUdXewfJCX6jt6sraV1iIDqDp4HgqAks2ueScpjhD2UeNpD5ECagXJpGE07AHYPCIAwglAbCnQCheym+mrXKXr9Nb7YyCvMqpjB4Z2xpamBIBSHHYSRVZMCHMFhk9WnE7MbFnJSoGz9Ah5QsGT3+GSUowsDH7z5lXBU+eOLxJMQ3GzsaNFSZHa5rpPRr5olIWfAdNN1xATNckC2Rg0CtPtQNL88l7B27DQDKQM8uh9/pL0xRniSBSpzVNlgBQKX/IWBbPgGfHguIPqlSt9CoHQuNZsieshuLfpJFV3ktNVe8DnsxZmYwYDR9u7V70WMSw3BqZquft9yclYAg0m1s9Xr1LF6Mr9k5jgupMGG5UGq/L8BqZZMWFekZ0g1ZTLZCOo+8ukH
 DiVYLyu4
 4JWmNzx+hNHazoIufufvwVhch7kOAQ3MZ04bYSq2BHVeitQdIRz7ir94DN09ng63p6rq+kRSUgehgPC9PTJ4VF1b6fs770sjs8eGlWYvp1Sg6lk+jEmE/EmCmuTeTz+xRCLcAdUi/5vdpZRec89vvKaWwub6TEFtvORdnnXpEIaOfoE7l6mUqT1x91Gzw+hdL0ySQ2h2dziOGFKCjp0gMyl4C0cE12yFQd7Kb0k+vqU4BxUk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement pt_range_walk, which is a pagewalk API that implements locking
and batching itself, and returns a struct containing information
about the address space which is backed by the vma.
It goes through the address range provided, and returns whatever it
find there, softleaf entries, folios, etc. and information about the entry
itself like whether it is dirty, shared, present, size of the entry, pagetable
level of the entry, number of batched entries, etc.

It defines the following types:

    #define PT_TYPE_NONE
    #define PT_TYPE_FOLIO
    #define PT_TYPE_MARKER
    #define PT_TYPE_PFN
    #define PT_TYPE_SWAP
    #define PT_TYPE_MIGRATION
    #define PT_TYPE_DEVICE
    #define PT_TYPE_HWPOISON
    #define PT_TYPE_ALL

and it lets the caller be explicit about what types it is interested in.
If it finds a type, but the caller stated it is not of importance, it keeps
scanning the address range till the next type is found, or till we exhaust
the range.

We have three functions:

    .pt_range_walk_start()
    .pt_range_walk_next()
    .pt_range_walk_done()

pt_range_walk_start() starts scanning the range and it returns the
first type it finds, then we keep calling pt_range_walk_next() until
we get PTW_DONE, which means we exhausted the range, and once that
happens we have to call pt_range_walk_done() in order to cleanup the
pt_range_walk internal state, like locking.

An example below:

     ´´´´
     pt_type_flags_t flags = PT_TYPE_ALL;

     type = pt_range_walk_start(&ptw, vma, start, vma->vm_end, flags);
     while (type != PTW_DONE) {
           do_something
           type = pt_range_walk_next(&ptw, vma, start, vma->vm_end, flags);
     }
     pt_range_walk_done(&ptw);
     ´´´´

The API manages locking within the interface, and also batching, which means
that it can handle contiguous ptes (or pmds in the case of hugetlb)
itself.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
 arch/arm64/include/asm/pgtable.h |   1 +
 include/linux/mm.h               |   2 +
 include/linux/pagewalk.h         | 106 ++++++++
 mm/memory.c                      |  22 ++
 mm/pagewalk.c                    | 400 +++++++++++++++++++++++++++++++
 5 files changed, 531 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 5b5490505b94..9f8cca8880e0 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -642,6 +642,7 @@ static inline pmd_t pmd_mkspecial(pmd_t pmd)
 #define pmd_pfn(pmd)		((__pmd_to_phys(pmd) & PMD_MASK) >> PAGE_SHIFT)
 #define pfn_pmd(pfn,prot)	__pmd(__phys_to_pmd_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
+#define pud_dirty(pud)         pte_dirty(pud_pte(pud))
 #define pud_young(pud)		pte_young(pud_pte(pud))
 #define pud_mkyoung(pud)	pte_pud(pte_mkyoung(pud_pte(pud)))
 #define pud_write(pud)		pte_write(pud_pte(pud))
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..c4e7fc558476 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2829,6 +2829,8 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
 				  unsigned long addr, pmd_t pmd);
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd);
+struct folio *vm_normal_folio_pud(struct vm_area_struct *vma,
+				  unsigned long addr, pud_t pud);
 struct page *vm_normal_page_pud(struct vm_area_struct *vma, unsigned long addr,
 		pud_t pud);
 
diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index 88e18615dd72..f46780c0310f 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -204,4 +204,110 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 	vma_pgtable_walk_end(__vma); \
 } while (0)
 
+typedef int __bitwise pt_type_flags_t;
+
+/*
+ * Types we are interested in returning. Those which are not explicitly set
+ * will be silently ignored by keep walking the page tables.
+ */
+#define PT_TYPE_NONE		((__force pt_type_flags_t)BIT(0))
+#define PT_TYPE_FOLIO		((__force pt_type_flags_t)BIT(1))
+#define PT_TYPE_MARKER		((__force pt_type_flags_t)BIT(2))
+#define PT_TYPE_PFN		((__force pt_type_flags_t)BIT(3))
+#define PT_TYPE_SWAP		((__force pt_type_flags_t)BIT(4))
+#define PT_TYPE_MIGRATION	((__force pt_type_flags_t)BIT(5))
+#define PT_TYPE_DEVICE		((__force pt_type_flags_t)BIT(6))
+#define PT_TYPE_HWPOISON	((__force pt_type_flags_t)BIT(7))
+#define PT_TYPE_ALL		(PT_TYPE_NONE | PT_TYPE_FOLIO | PT_TYPE_MARKER | \
+				 PT_TYPE_PFN | PT_TYPE_SWAP | PT_TYPE_MIGRATION | \
+				 PT_TYPE_DEVICE | PT_TYPE_HWPOISON)
+
+enum pt_range_walk_level {
+	PTW_PUD_LEVEL,
+	PTW_PMD_LEVEL,
+	PTW_PTE_LEVEL,
+};
+
+enum pt_range_walk_type {
+	PTW_ABORT,
+	PTW_DONE,
+	PTW_NONE,
+	PTW_FOLIO,
+	PTW_MARKER,
+	PTW_PFN,
+	PTW_SWAP,
+	PTW_MIGRATION,
+	PTW_DEVICE,
+	PTW_HWPOISON,
+};
+
+/**
+ * struct pt_range_walk - pt_range_walk()
+ * @page:       exact folio page referenced (if applicable)
+ * @folio:	folio mapped (if any)
+ * @nr_entries:	number of contiguous entries of the same type
+ * @size:	stores nr_batched * entry_size
+ * @softleaf_entry:	softleaf entry (if any)
+ * @writable:	whether it is writable
+ * @young:	whether it is young
+ * @dirty:	whether it is dirty
+ * @present:	whether it is present in the page tables
+ * @vma_locked: whether we are holding the vma lock
+ * @pmd_shared: only used for hugetlb
+ * @curr_addr:	current addr we are operating on
+ * @next_addr:	next addr to be used walk the page tables
+ * @level:      page table level
+ * @pte:        copy of the entry value (PTW_PTE_LEVEL).
+ * @pmd:        copy of the entry value (PTW_PMD_LEVEL).
+ * @pud:        copy of the entry value (PTW_PUD_LEVEL).
+ * @mm:		the mm_struct we are walking
+ * @vma:	the vma we are walking
+ * @ptl:        pointer to the page table lock.
+ */
+
+struct pt_range_walk {
+	struct page *page;
+	struct folio *folio;
+	int nr_entries;
+	unsigned long size;
+	softleaf_t softleaf_entry;
+	bool writable;
+	bool young;
+	bool dirty;
+	bool present;
+	bool vma_locked;
+	bool pmd_shared;
+	bool lock_i_mmap;
+	bool i_mmap_locked;
+	unsigned long curr_addr;
+	unsigned long next_addr;
+	enum pt_range_walk_level level;
+	union {
+		pte_t *ptep;
+		pud_t *pudp;
+		pmd_t *pmdp;
+	};
+	union {
+		pte_t pte;
+		pud_t pud;
+		pmd_t pmd;
+	};
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;
+	spinlock_t *ptl;
+};
+
+enum pt_range_walk_type pt_range_walk(struct pt_range_walk *ptw,
+				      struct vm_area_struct *vma,
+				      unsigned long addr, unsigned long end,
+				      pt_type_flags_t flags);
+enum pt_range_walk_type pt_range_walk_start(struct pt_range_walk *ptw,
+					    struct vm_area_struct *vma,
+					    unsigned long addr, unsigned long end,
+					    pt_type_flags_t flags);
+enum pt_range_walk_type pt_range_walk_next(struct pt_range_walk *ptw,
+					   struct vm_area_struct *vma,
+					   unsigned long addr, unsigned long end,
+					   pt_type_flags_t flags);
+void pt_range_walk_done(struct pt_range_walk *ptw);
 #endif /* _LINUX_PAGEWALK_H */
diff --git a/mm/memory.c b/mm/memory.c
index 07778814b4a8..e016bc7a49d9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -850,6 +850,28 @@ struct page *vm_normal_page_pud(struct vm_area_struct *vma,
 	return __vm_normal_page(vma, addr, pud_pfn(pud), pud_special(pud),
 				pud_val(pud), PGTABLE_LEVEL_PUD);
 }
+
+/**
+ * vm_normal_folio_pud() - Get the "struct folio" associated with a PUD
+ * @vma: The VMA mapping the @pud.
+ * @addr: The address where the @pud is mapped.
+ * @pud: The PUD.
+ *
+ * Get the "struct folio" associated with a PUD. See __vm_normal_page()
+ * for details on "normal" and "special" mappings.
+ *
+ * Return: Returns the "struct folio" if this is a "normal" mapping. Returns
+ *         NULL if this is a "special" mapping.
+ */
+struct folio *vm_normal_folio_pud(struct vm_area_struct *vma,
+				  unsigned long addr, pud_t pud)
+{
+	struct page *page = vm_normal_page_pud(vma, addr, pud);
+
+	if (page)
+		return page_folio(page);
+	return NULL;
+}
 #endif
 
 /**
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index a94c401ab2cf..b71c2d48acd9 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -1029,3 +1029,403 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 	fw->ptl = ptl;
 	return page_folio(page);
 }
+
+enum pt_range_walk_type pt_range_walk(struct pt_range_walk *ptw,
+				      struct vm_area_struct *vma,
+				      unsigned long addr, unsigned long end,
+				      pt_type_flags_t flags)
+{
+	pgd_t *pgdp;
+	p4d_t *p4dp;
+	pud_t *pudp, pud;
+	pmd_t *pmdp, pmd;
+	pte_t *ptep, pte;
+	int nr_batched = 1;
+	spinlock_t *ptl = NULL;
+	unsigned long entry_size;
+	struct page *page;
+	struct folio *folio;
+	enum pt_range_walk_type ret_type = PTW_DONE;
+	bool writable, young, dirty;
+	unsigned long curr_addr, next_addr = ptw->next_addr ? ptw->next_addr : addr;
+
+	if (WARN_ON_ONCE(next_addr < vma->vm_start || next_addr >= vma->vm_end))
+		return ret_type;
+
+	mmap_assert_locked(ptw->mm);
+
+	if (ptw->ptl) {
+		spin_unlock(ptw->ptl);
+		ptw->ptl = NULL;
+	}
+
+	if (ptw->level == PTW_PTE_LEVEL && ptw->ptep) {
+		pte_unmap(ptw->ptep);
+		ptw->ptep = NULL;
+	}
+
+	if (!ptw->vma_locked) {
+		vma_pgtable_walk_begin(vma);
+		ptw->vma_locked = true;
+		ptw->vma = vma;
+	}
+
+keep_walking:
+	ret_type = PTW_DONE;
+	folio = NULL;
+	page = NULL;
+	writable = young = dirty = false;
+	ptw->present = false;
+	ptw->pmd_shared = false;
+	ptw->folio = NULL;
+	ptw->page = NULL;
+
+	curr_addr = next_addr;
+	if (ptl) {
+		spin_unlock(ptl);
+		ptl = NULL;
+	}
+	/*
+	 * If we keep walking the page tables because we are not interested
+	 * in the type we found, make sure to check whether we reached the end.
+	 */
+	if (curr_addr >= end) {
+		ptw->next_addr = next_addr;
+		return ret_type;
+	}
+again:
+	pgdp = pgd_offset(ptw->mm, curr_addr);
+	next_addr = pgd_addr_end(curr_addr, end);
+
+	if (pgd_none_or_clear_bad(pgdp))
+		/* PTW_ABORT? */
+		goto keep_walking;
+
+	next_addr = p4d_addr_end(curr_addr, end);
+	p4dp = p4d_offset(pgdp, curr_addr);
+	if (p4d_none_or_clear_bad(p4dp))
+		/* PTW_ABORT? */
+		goto keep_walking;
+
+	entry_size = PUD_SIZE;
+	ptw->level = PTW_PUD_LEVEL;
+	next_addr = pud_addr_end(curr_addr, end);
+	pudp = pud_offset(p4dp, curr_addr);
+	pud = pudp_get(pudp);
+	if (pud_none(pud)) {
+		if (!(flags & PT_TYPE_NONE))
+			goto keep_walking;
+		ret_type = PTW_NONE;
+		goto found;
+	}
+	/*
+	 * For now, there are no architectures which supports pgd or p4d
+	 * leafs, pud is the first level that can be a leaf.
+	 */
+	if (IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) &&
+	    (!pud_present(pud) || pud_leaf(pud))) {
+		ptl = pud_huge_lock(pudp, vma);
+		if (!ptl)
+			goto again;
+
+		pud = pudp_get(pudp);
+		ptw->pudp = pudp;
+		ptw->pud = pud;
+		if (pud_none(pud)) {
+			if (!(flags & PT_TYPE_NONE))
+				goto keep_walking;
+			ret_type = PTW_NONE;
+		} else if (pud_present(pud) && !pud_leaf(pud)) {
+			spin_unlock(ptl);
+			ptl = NULL;
+			goto pmd_table;
+		} else if (pud_present(pud)) {
+			/*
+			 * We do not support PUD-device or pud-PFNMAP, so
+			 * if it is present, we must have a folio (Tm).
+			 */
+			page = vm_normal_page_pud(vma, curr_addr, pud);
+			if (!page || !(flags & PT_TYPE_FOLIO))
+				goto keep_walking;
+
+			ret_type = PTW_FOLIO;
+			folio = page_folio(page);
+			ptw->present = true;
+			dirty = !!pud_dirty(pud);
+			young = !!pud_young(pud);
+			writable = !!pud_write(pud);
+		} else if (!pud_none(pud)) {
+			/* PUD-hugetlbs can have special swap entries */
+			const softleaf_t entry = softleaf_from_pud(pud);
+
+			ptw->softleaf_entry = entry;
+
+			if (softleaf_is_marker(entry)) {
+				if (!(flags & PT_TYPE_MARKER))
+					goto keep_walking;
+				ret_type = PTW_MARKER;
+			} else if (softleaf_has_pfn(entry)) {
+				if (softleaf_is_migration(entry)) {
+					if (!(flags & PT_TYPE_MIGRATION))
+						goto keep_walking;
+					ret_type = PTW_MIGRATION;
+				} else if (softleaf_is_hwpoison(entry)) {
+					if (!(flags & PT_TYPE_HWPOISON))
+						goto keep_walking;
+					ret_type = PTW_HWPOISON;
+				}
+
+				page = softleaf_to_page(entry);
+				if (page)
+					folio = page_folio(page);
+			}
+		} else {
+			/* We found nothing, keep going */
+			goto keep_walking;
+		}
+
+		/* We found a type */
+		goto found;
+	}
+pmd_table:
+	entry_size = PMD_SIZE;
+	ptw->level = PTW_PMD_LEVEL;
+	next_addr = pmd_addr_end(curr_addr, end);
+	pmdp = pmd_offset(pudp, curr_addr);
+	pmd = pmdp_get_lockless(pmdp);
+	if (pmd_none(pmd)) {
+		if (!(flags & PT_TYPE_NONE))
+			goto keep_walking;
+		ret_type = PTW_NONE;
+		goto found;
+	}
+
+	if (IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) &&
+	    (!pmd_present(pmd) || pmd_leaf(pmd))) {
+		ptl = pmd_huge_lock(pmdp, vma);
+		if (!ptl)
+			goto again;
+
+		pmd = pmdp_get(pmdp);
+		ptw->pmdp = pmdp;
+		ptw->pmd = pmd;
+		if (pmd_none(pmd)) {
+			if (!(flags & PT_TYPE_NONE))
+				goto keep_walking;
+			ret_type = PTW_NONE;
+		} else if (pmd_present(pmd) && !pmd_leaf(pmd)) {
+			spin_unlock(ptl);
+			ptl = NULL;
+			goto pte_table;
+		} else if (pmd_present(pmd)) {
+			page = vm_normal_page_pmd(vma, curr_addr, pmd);
+			if (page) {
+				if (!(flags & PT_TYPE_FOLIO))
+					goto keep_walking;
+				ret_type = PTW_FOLIO;
+				folio = page_folio(page);
+				if (folio_size(folio) > entry_size) {
+					/* We can batch */
+					int max_nr = folio_size(folio) / entry_size;
+
+					nr_batched = folio_pmd_batch(folio, pmdp, &pmd,
+								     max_nr, 0,
+								     &writable,
+								     &young,
+								     &dirty);
+				} else {
+					dirty = !!pmd_dirty(pmd);
+					young = !!pmd_young(pmd);
+					writable = !!pmd_write(pmd);
+				}
+			} else if (!page && (is_huge_zero_pmd(pmd) ||
+			    vma->vm_flags & VM_PFNMAP)) {
+				if (!(flags & PT_TYPE_PFN))
+					goto keep_walking;
+				/* Create a subtype to differentiate them? */
+				ret_type = PTW_PFN;
+			} else if (!page) {
+				goto keep_walking;
+			}
+			ptw->present = true;
+			next_addr += (nr_batched * entry_size) - entry_size;
+		} else if (!pmd_none(pmd)) {
+			const softleaf_t entry = softleaf_from_pmd(pmd);
+
+			ptw->softleaf_entry = entry;
+
+			if (softleaf_is_marker(entry)) {
+				if (!(flags & PT_TYPE_MARKER))
+					goto keep_walking;
+				ret_type = PTW_MARKER;
+			} else if (softleaf_has_pfn(entry)) {
+				if (softleaf_is_migration(entry)) {
+					if (!(flags & PT_TYPE_MIGRATION))
+						goto keep_walking;
+					ret_type = PTW_MIGRATION;
+				} else if (softleaf_is_hwpoison(entry)) {
+					if (!(flags & PT_TYPE_HWPOISON))
+						goto keep_walking;
+					ret_type = PTW_HWPOISON;
+				} else if (softleaf_is_device_private(entry) ||
+					   softleaf_is_device_exclusive(entry)) {
+					if (!(flags & PT_TYPE_DEVICE))
+						goto keep_walking;
+					ptw->present = true;
+					ret_type = PTW_DEVICE;
+				}
+				page = softleaf_to_page(entry);
+				if (page)
+					folio = page_folio(page);
+			}
+		} else {
+			/* We found nothing, keep going */
+			goto keep_walking;
+		}
+
+		if (ret_type != PTW_NONE && is_vm_hugetlb_page(vma) &&
+		    hugetlb_pmd_shared((pte_t *)pmdp))
+			ptw->pmd_shared = true;
+
+		goto found;
+	}
+pte_table:
+	entry_size = PAGE_SIZE;
+	ptw->level = PTW_PTE_LEVEL;
+	next_addr = curr_addr + PAGE_SIZE;
+	ptep = pte_offset_map_lock(vma->vm_mm, pmdp, curr_addr, &ptl);
+	if (!ptep)
+		goto again;
+
+	pte = ptep_get(ptep);
+	ptw->ptep = ptep;
+	ptw->pte = pte;
+	if (pte_none(pte)) {
+		if (!(flags & PT_TYPE_NONE))
+			goto not_found;
+		ret_type = PTW_NONE;
+	} else if (pte_present(pte)) {
+		page = vm_normal_page(vma, curr_addr, pte);
+		if (page) {
+			if (!(flags & PT_TYPE_FOLIO))
+				goto not_found;
+			ret_type = PTW_FOLIO;
+			folio = page_folio(page);
+			if (folio_test_large(folio)) {
+				/* We can batch */
+				unsigned long end_addr = pmd_addr_end(curr_addr, end);
+				int max_nr = (end_addr - curr_addr) >> PAGE_SHIFT;
+
+				nr_batched = folio_pte_batch_flags(folio, vma, ptep, &pte, max_nr,
+								   FPB_MERGE_WRITE | FPB_MERGE_YOUNG_DIRTY);
+			}
+		} else if (!page && (is_zero_pfn(pte_pfn(pte)) ||
+			   vma->vm_flags & VM_PFNMAP)) {
+			if (!(flags & PT_TYPE_PFN))
+				goto not_found;
+			ret_type = PTW_PFN;
+		}
+
+		dirty = !!pte_dirty(pte);
+		young = !!pte_young(pte);
+		writable = !!pte_write(pte);
+		ptw->present = true;
+		next_addr += (nr_batched * entry_size) - entry_size;
+	} else if (!pte_none(pte)) {
+		const softleaf_t entry = softleaf_from_pte(pte);
+
+		ptw->softleaf_entry = entry;
+
+		if (softleaf_is_marker(entry)) {
+			if (!(flags & PT_TYPE_MARKER))
+				goto not_found;
+			ret_type = PTW_MARKER;
+		} else if (softleaf_is_swap(entry)) {
+			unsigned long end_addr = pmd_addr_end(curr_addr, end);
+			int max_nr = (end_addr - curr_addr) >> PAGE_SHIFT;
+
+			if (!(flags & PT_TYPE_SWAP))
+				goto not_found;
+
+			nr_batched = swap_pte_batch(ptep, max_nr, pte);
+			next_addr += (nr_batched * entry_size) - entry_size;
+			ret_type = PTW_SWAP;
+		} else if (softleaf_has_pfn(entry)) {
+			if (softleaf_is_migration(entry)) {
+				if (!(flags & PT_TYPE_MIGRATION))
+					goto not_found;
+				ret_type = PTW_MIGRATION;
+			} else if (softleaf_is_hwpoison(entry)) {
+				if (!(flags & PT_TYPE_HWPOISON))
+					goto not_found;
+				ret_type = PTW_HWPOISON;
+			} else if (softleaf_is_device_private(entry) ||
+				   softleaf_is_device_exclusive(entry)) {
+				if (!(flags & PT_TYPE_DEVICE))
+					goto not_found;
+				ptw->present = true;
+				ret_type = PTW_DEVICE;
+			}
+			page = softleaf_to_page(entry);
+			if (page)
+				folio = page_folio(page);
+		}
+	} else {
+not_found:
+		/* We found nothing, keep going */
+		pte_unmap_unlock(ptep, ptl);
+		ptw->ptep = NULL;
+		ptl = NULL;
+		goto keep_walking;
+	}
+
+found:
+	/* Fill in remaining ptw struct before returning */
+	ptw->ptl = ptl;
+	ptw->curr_addr = curr_addr;
+	ptw->next_addr = next_addr;
+	ptw->writable = writable;
+	ptw->young = young;
+	ptw->dirty = dirty;
+	ptw->nr_entries = nr_batched;
+	ptw->size = nr_batched * entry_size;
+	if (folio) {
+		ptw->folio = folio;
+		ptw->page = page + ((curr_addr & (entry_size - 1)) >> PAGE_SHIFT);
+	}
+	return ret_type;
+}
+
+enum pt_range_walk_type pt_range_walk_start(struct pt_range_walk *ptw,
+					    struct vm_area_struct *vma,
+					    unsigned long addr, unsigned long end,
+					    pt_type_flags_t flags)
+{
+	if (!ptw->mm)
+		return PTW_DONE;
+	if (addr >= end)
+		return PTW_DONE;
+	return pt_range_walk(ptw, vma, addr, end, flags);
+}
+
+enum pt_range_walk_type pt_range_walk_next(struct pt_range_walk *ptw,
+					    struct vm_area_struct *vma,
+					    unsigned long addr, unsigned long end,
+					    pt_type_flags_t flags)
+{
+	/* We went through the complete range */
+	if (ptw->next_addr >= end)
+		return PTW_DONE;
+	return pt_range_walk(ptw, vma, addr, end, flags);
+}
+
+void pt_range_walk_done(struct pt_range_walk *ptw)
+{
+	if (ptw->ptl)
+		spin_unlock(ptw->ptl);
+	if (ptw->level == PTW_PTE_LEVEL && ptw->ptep)
+		pte_unmap(ptw->ptep);
+	if (ptw->vma_locked)
+		vma_pgtable_walk_end(ptw->vma);
+	cond_resched();
+}
-- 
2.35.3


