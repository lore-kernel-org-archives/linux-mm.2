Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDB39CCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 00:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FDE68E0006; Sun, 19 Oct 2025 20:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286DD8E0002; Sun, 19 Oct 2025 20:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E478E0006; Sun, 19 Oct 2025 20:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE1678E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:35:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AACCC1606A4
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:35:05 +0000 (UTC)
X-FDA: 84016622970.05.821C9B9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 22CD2100005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:35:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=t7yakUmz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760920504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3UQ6jAEP3SX6IXT3X18CrBZ4z0NlXZkfS3SMDZ6huk=;
	b=qItSdjSYUank3j4EgZTEuzR3r2b6y+tk2Nd6geZPUV5Zv0hOuvxL8/fWp+3EcgmzmYT0VT
	KI1N4n2WK4osnBSMWvkWS0Cv7aH6PT9LKA70VIp7bUG7UiJco8j76+zlWz5wOnYVVScdKr
	iGV8Ts8VY2Ju+i8yFQm6/HzKE3mdM2Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=t7yakUmz;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760920504; a=rsa-sha256;
	cv=none;
	b=bTwo6hQr+h241CQAfTOI9SzE5U09xO3LIyL2llglMUki43ZhhYeITRtXcse5Z+0OWK7jzU
	6QDzHKbGMW7b57r3VN0rmLE5b0sLX9NzzpwhnZbfjGWC8EN1lOAyyaM0UICKxpHso9ekRs
	40LXQwLrtfaMBLVOay74U8myJ09Yql4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=H3UQ6jAEP3SX6IXT3X18CrBZ4z0NlXZkfS3SMDZ6huk=; b=t7yakUmzHFRLv8o3YsybnFEFbk
	ie7ielkHa9pj2nR7/k0OPEk2Ra2w9FehMbJ4m4cc+Xi1wmCPzRFA3x5YmL0xeXYbNEWwjrWwG/lH6
	UlZy1p7bvASUfeeGAnwD9lpR5AJ0pa9Uj6faj9s2M19xaD6oRW4fY3oMyU6Mldrdj1VW2MLxwSOEs
	WiyzsRxOtZfwjSMNvpQrlkS9r7GygQn7hpZf/XyVnhcpFrxphzZgj73afL1LGglHHHkpuLIqBbC6W
	8SohX2EU0Q3+xmHRI/w0dEHBqiTFrwDnUrIfXQ8ODkTU+op5CfeP7CBKtFqzXTdVHVX4b/Guhulj7
	ao3+xl6Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAda8-00000008tEl-1s8U;
	Mon, 20 Oct 2025 00:17:00 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: [RFC PATCH 7/7] mm: Allocate ptdesc from slab
Date: Mon, 20 Oct 2025 01:16:42 +0100
Message-ID: <20251020001652.2116669-8-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020001652.2116669-1-willy@infradead.org>
References: <20251020001652.2116669-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 22CD2100005
X-Stat-Signature: pycmu6ijddc7iemg736x7887byzftxx9
X-Rspam-User: 
X-HE-Tag: 1760920503-585617
X-HE-Meta: U2FsdGVkX18UXJILoj+NWwBBss4Nyg4usZOoy73wYPJ+TZYXGWQ5xNulVEVBMyfIPp+l0ZEKjFr1WyywGMIA46aiDtcbIRdJfPaIzQ1MfwkjvUj5tspdzp4xWoum0Oyn9Q1UTNW2jp14DEOsSD8NoA7GbWfaBn/PCl55PH1HmgjJGF69cTsPX3A6ZwIyufv9NCT0mHAAZjxTtagra9lkkhMKhr3wItjy5u9TErswOzy287khKikueNFHXYXsgotTN/Hd/pA3WUMSOaUfYo81uYMaDRotRJTzaf/ZlducA2wlSoET03K9HyiGSTqDgvpIyV6tgih9oKBKm5J9CWUmeM/rS4OPs/Coj/z+l2CF8Q5npykEYwRMga8Xmhu4st91o6ox/xZRYWuAi1Jt4UNqpc2UzTgsrm6QpjbDDY5X9JBV1ZTl2SEMNjBsC1nljbV5Iy9DXpKkCSvIrTB2lbzRuRORYuMVZ4veXvHj631bDUjOkZgOfjTVWfpoOLD5COWpiqffY/0lBu+w1UN4Ph1sz6/w4OdDFn9abcD1Rriz11900mvlY4e7VCJrrhlHJsObwUi8R1+NQ1t7DI9vwyeOdYn770qKOlCHsNHhO95eUGxUcpmZdRGTlXY85xBLrycbprNAoPdrwZd1TY56a/OEjYZs4vU4sG/DZrv/YjXDL3zXXuwTI29Xzd+nt8Ib7N973MHRqLmsSvENTw/BWg7n65pXa55N1xKAAwrzgbDoKFPzypHZMD0+DO6uRQFrOc0QwDBsY2P1j2/zi6YzzBy/FePdoHaInyoxQzg4o3GDytFw4NXBDH3eVkq6/rBvx/Caw5crESChJ+6Srw9Z/hfXTIHgQB0svpgI0S7jWAzYclWBeJdm5NiQ87nDDtyAcKmSPX20DlAnU1CC12Wy3dmra+UIEApbh/M5cGs4IokfoptkzdpqWi5/vIRfHRGMbO0EAYzLWmhHzj0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create a slab cache for ptdescs and point to the struct page from the
ptdesc.  Remove all the padding from ptdesc that makes it line up with
struct page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h       |  1 +
 include/linux/mm_types.h | 50 ++++------------------------------------
 mm/internal.h            |  1 +
 mm/memory.c              | 35 ++++++++++++++++++++++++----
 mm/mm_init.c             |  1 +
 5 files changed, 37 insertions(+), 51 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e60b181da3df..e8bb52061b0c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2970,6 +2970,7 @@ static inline struct ptdesc *page_ptdesc(const struct page *page)
  * The high bits are used for information like zone/node/section.
  */
 enum pt_flags {
+	/* Bits 0-3 used for pt_order */
 	PT_reserved = PG_reserved,
 };
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index f5d9e0afe0fa..efdf29b8b478 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -548,38 +548,30 @@ FOLIO_MATCH(compound_head, _head_3);
 /**
  * struct ptdesc -    Memory descriptor for page tables.
  * @pt_flags: enum pt_flags plus zone/node/section.
+ * @pt_page: page allocated to store page table entries.
  * @pt_rcu_head:      For freeing page table pages.
  * @pt_list:          List of used page tables. Used for s390 gmap shadow pages
  *                    (which are not linked into the user page tables) and x86
  *                    pgds.
- * @_pt_pad_1:        Padding that aliases with page's compound head.
  * @pmd_huge_pte:     Protected by ptdesc->ptl, used for THPs.
- * @__page_mapping:   Aliases with page->mapping. Unused for page tables.
  * @pt_index:         Used for s390 gmap.
  * @pt_mm:            Used for x86 pgds.
  * @pt_frag_refcount: For fragmented page table tracking. Powerpc only.
  * @pt_share_count:   Used for HugeTLB PMD page table share count.
- * @_pt_pad_2:        Padding to ensure proper alignment.
  * @ptl:              Lock for the page table.
- * @__page_type:      Same as page->page_type. Unused for page tables.
- * @__page_refcount:  Same as page refcount.
- * @pt_memcg_data:    Memcg data. Tracked for page tables here.
  *
  * This struct overlays struct page for now. Do not modify without a good
  * understanding of the issues.
  */
 struct ptdesc {
 	memdesc_flags_t pt_flags;
+	struct page *pt_page;
 
 	union {
 		struct rcu_head pt_rcu_head;
 		struct list_head pt_list;
-		struct {
-			unsigned long _pt_pad_1;
-			pgtable_t pmd_huge_pte;
-		};
+		pgtable_t pmd_huge_pte;
 	};
-	unsigned long __page_mapping;
 
 	union {
 		pgoff_t pt_index;
@@ -591,47 +583,13 @@ struct ptdesc {
 	};
 
 	union {
-		unsigned long _pt_pad_2;
 #if ALLOC_SPLIT_PTLOCKS
 		spinlock_t *ptl;
 #else
 		spinlock_t ptl;
 #endif
 	};
-	unsigned int __page_type;
-	atomic_t __page_refcount;
-#ifdef CONFIG_MEMCG
-	unsigned long pt_memcg_data;
-#endif
-};
-
-#define TABLE_MATCH(pg, pt)						\
-	static_assert(offsetof(struct page, pg) == offsetof(struct ptdesc, pt))
-TABLE_MATCH(flags, pt_flags);
-TABLE_MATCH(compound_head, pt_list);
-TABLE_MATCH(compound_head, _pt_pad_1);
-TABLE_MATCH(mapping, __page_mapping);
-TABLE_MATCH(__folio_index, pt_index);
-TABLE_MATCH(rcu_head, pt_rcu_head);
-TABLE_MATCH(page_type, __page_type);
-TABLE_MATCH(_refcount, __page_refcount);
-#ifdef CONFIG_MEMCG
-TABLE_MATCH(memcg_data, pt_memcg_data);
-#endif
-#undef TABLE_MATCH
-static_assert(sizeof(struct ptdesc) <= sizeof(struct page));
-
-#define ptdesc_page(pt)			(_Generic((pt),			\
-	const struct ptdesc *:		(const struct page *)(pt),	\
-	struct ptdesc *:		(struct page *)(pt)))
-
-#define ptdesc_folio(pt)		(_Generic((pt),			\
-	const struct ptdesc *:		(const struct folio *)(pt),	\
-	struct ptdesc *:		(struct folio *)(pt)))
-
-#define page_ptdesc(p)			(_Generic((p),			\
-	const struct page *:		(const struct ptdesc *)(p),	\
-	struct page *:			(struct ptdesc *)(p)))
+} __aligned(16);
 
 #ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
 static inline void ptdesc_pmd_pts_init(struct ptdesc *ptdesc)
diff --git a/mm/internal.h b/mm/internal.h
index 15d64601289b..d57487ba443d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -100,6 +100,7 @@ struct pagetable_move_control {
 	unlikely(__ret_warn_once);					\
 })
 
+void __init ptcache_init(void);
 void page_writeback_init(void);
 
 /*
diff --git a/mm/memory.c b/mm/memory.c
index 47eb5834db23..331582bec495 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7267,10 +7267,17 @@ long copy_folio_from_user(struct folio *dst_folio,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
+static struct kmem_cache *ptcache;
+
+void __init ptcache_init(void)
+{
+	ptcache = KMEM_CACHE(ptdesc, 0);
+}
+
 /**
  * pagetable_alloc - Allocate pagetables
  * @gfp:    GFP flags
- * @order:  desired pagetable order
+ * @order:  pagetable order
  *
  * pagetable_alloc allocates memory for page tables as well as a page table
  * descriptor to describe that memory.
@@ -7279,16 +7286,34 @@ long copy_folio_from_user(struct folio *dst_folio,
  */
 struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
 {
-	struct page *page = alloc_frozen_pages_noprof(gfp | __GFP_COMP, order);
+	struct page *page;
 	pg_data_t *pgdat;
+	struct ptdesc *ptdesc;
+
+	BUG_ON(!ptcache);
 
-	if (!page)
+	ptdesc = kmem_cache_alloc(ptcache, gfp);
+	if (!ptdesc)
 		return NULL;
 
+	page = alloc_pages_memdesc(gfp, order,
+			memdesc_create(ptdesc, MEMDESC_TYPE_PAGE_TABLE));
+	if (!page) {
+		kmem_cache_free(ptcache, ptdesc);
+		return NULL;
+	}
+
+	VM_BUG_ON_PAGE(memdesc_type(page->memdesc) != MEMDESC_TYPE_PAGE_TABLE, page);
 	pgdat = NODE_DATA(page_to_nid(page));
 	mod_node_page_state(pgdat, NR_PAGETABLE, 1 << order);
 	__SetPageTable(page);
-	return page_ptdesc(page);
+	page->__folio_index = (unsigned long)ptdesc;
+
+	ptdesc->pt_flags = page->flags;
+	ptdesc->pt_flags.f |= order;
+	ptdesc->pt_page = page;
+
+	return ptdesc;
 }
 
 /**
@@ -7302,7 +7327,7 @@ void pagetable_free(struct ptdesc *pt)
 {
 	pg_data_t *pgdat = NODE_DATA(memdesc_nid(pt->pt_flags));
 	struct page *page = ptdesc_page(pt);
-	unsigned int order = compound_order(page);
+	unsigned int order = pt->pt_flags.f & 0xf;
 
 	mod_node_page_state(pgdat, NR_PAGETABLE, -(1L << order));
 	__ClearPageTable(page);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 3db2dea7db4c..dc6d2f81b692 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2712,6 +2712,7 @@ void __init mm_core_init(void)
 	 */
 	page_ext_init_flatmem_late();
 	kmemleak_init();
+	ptcache_init();
 	ptlock_cache_init();
 	pgtable_cache_init();
 	debug_objects_mem_init();
-- 
2.47.2


