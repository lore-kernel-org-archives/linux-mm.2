Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4514CD6E6C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 14:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D175E8E0016; Thu, 13 Nov 2025 09:04:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC70D8E0015; Thu, 13 Nov 2025 09:04:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5508E0016; Thu, 13 Nov 2025 09:04:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E1778E0015
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:04:56 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53494BC5E0
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:04:56 +0000 (UTC)
X-FDA: 84105754992.26.F8FDD39
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id A070FC0012
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:04:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pHlttIg5;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763042694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1QxitBCAvEEi8mX/GXYAG3wFMLd58WAqDa4SbtWZMM=;
	b=fdDO4GPw/WggeMMJwuQF/RlEZmpQNEF36RKbBNS/XT7prKr2VobTzgEt9Y1YDylA4n/Qii
	4LBWmd/7CqVzS0oi6/TIIKirAELBn/8vh1xrr0QConwm7sBerFpEA5Y1xD7GUJWrG5TLGF
	RcDQj+JIFuooXqKt5wV3VOsciB33UeQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763042694; a=rsa-sha256;
	cv=none;
	b=c90eLop9j3QITIQrdKbGvxIVnakX3jZladV3fQ7am9uEe7eGXVtlzOaTcKMEVExZW9M1sF
	KDKe/8hmsLcwanMClfsMhcfv98LlGY9j21FZGyBI4s+I7v9EzZm7ELHiNvL4AyN3qRH/Bg
	/K9WkOqDUUKZiV59V54ylpnmUp++KaE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pHlttIg5;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=B1QxitBCAvEEi8mX/GXYAG3wFMLd58WAqDa4SbtWZMM=; b=pHlttIg54kzDVzo0V9Z582K0VN
	DdFETLvnTinQmxB/iVyKAtwe1Ero+VxemeBp5LVwtl0OD+kcLe4G6UrWR6oBnFxCRdPYspA6+G9I0
	3olSzCGC2sYkX6o3+pbxUOROy4HaWrGAgpjoka168+/4jTnX7OzySSoUGa2XBp8M9NDSWBKOgnKye
	L3AtCWuMeHF60JWem3Twxt+llaL32iLVx1Jn7XODjqgTdIph/prFz7wTmFeia6oQ03h98tO/wHMtL
	e0Jseq7bdMRCXZL+b4XgLyb6XzvNQ5Il8FTMr2gtSvhehjTitL/04pkxNs7OxCME8G0mDly3/6oa2
	wudMLx7A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJXwQ-00000007c8D-15pg;
	Thu, 13 Nov 2025 14:04:50 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	linux-mm@kvack.org
Subject: [PATCH 1/4] mm: Use frozen pages for page tables
Date: Thu, 13 Nov 2025 14:04:43 +0000
Message-ID: <20251113140448.1814860-2-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113140448.1814860-1-willy@infradead.org>
References: <20251113140448.1814860-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wc3g9bis4zohyjaqnepqxxe6m9hqncey
X-Rspam-User: 
X-Rspamd-Queue-Id: A070FC0012
X-Rspamd-Server: rspam01
X-HE-Tag: 1763042694-56098
X-HE-Meta: U2FsdGVkX1/GjemjmNVQvklshzNDn5Y5VWRfLJ8NGve5RQ3qzB6N4UrtkJgrrj5PxUF2IN7IztoI0kzDLFfz56g8wDsrb6rW8WeaeQwelXrrKm+lcD819uBMRx9VmV5Mn3Btzr2qRQDii4BpdrBvYhm/x6i0zlDslKyQmvTY7VAjpvp/xMeGoJHDP/ugOZlMCYgjoKuwDFe2voKMoZrA5UexeJHrunG9CEyDvXIzi8auGBhj+M4C7f1I6Qi7TiPe/iQttiYdMpCub4VKJL1/O1uZIXKWJ4t5v5Ai8LVa3pJvRN/BlQLTDjfxmusj4weYCBdJtW9R6kFtL9/5qI8dtlggehLhlYteunlt55P9vs6SuAdSF7zJoSURL7oPDnz66oCFQ1L/vWjj54WKNVzSCA2MIjv+XuX40csEdTLD9lnTtcX5b9H+qwL+DsIbv/ASUloe9vlFlHOKnzxyPILcoZIkSxujLGQm6LRdpa8M69CzojITSpy9GFUXD6WHVaLNYKG5S1EDRtUIfMv4QMyByEElajQMkRO/fEHHolz1gy0Y5hStfRWxP3ARO4a2lYtMlr6lcdVFVvA3J96+b15KzNeEHy7e+gv8TeCHsoIKo5i5KJnQFeVCUJV+fskoHMmMa5DAbx19+x1pceKDFxcW3o3VBpuJhDya+6iTwXKXwkmY21zOKg78H8rCvadh2FxmtlRawNDfGwFXKJ+oNioFzAeYRBcYOPpLigMslKqqTmQNJZzcWZkD7o+QS6USUuW9PZnc+dCxhQxrsxOgWN+q2vjqoNXgxVZa95DfkVw1r5UtDWhoek3+KNBHZE2/eHgvfm7oqi8aBEXJrvlBaZ6ZdpMCgs5ox9iDWK75Uak0HrPndOsLbY6IjioRap5i4e4mzAWdzfYNqcihkJjQ+B6M++Jp4N4aaz/uqckRpbpCGCq/m53a4D5uYIALj4y9YkCpGrXMav5rvIDiiI4iL38
 7Pq2h/9+
 kf1dk3fITXoGWTo/LC8G0TIgG38AYiF465NLMj39UOXjAWkInwGA/gNU2MWd/FojncIJBiKYqnbmlOXbscopMnexcDVbRJ8tcbgf3WRm6CeHoiNoboc/t41+ZO8W4GDVHd1+t37DXUz1ES2wR3fkq5uNkGKiYsrrTt/afVvJ5o9Mj/L4o2d4YMeOanGgWI1mOIx5JVkfAFtACADUsM3ZcULvJ16zedKPWD2bJAsB/LXTf6CyHDzez2LBpoozGFOAVFRsFnjCzzI5EmqfDobeWhFvL33OlOy/YiTojBrF92zkRXZUy8XgW7xH/QFocsQFRMudtdlIBrTGut2BoL8qlPnRLIzzy9qD6RY1Na3+E6Bx3liA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Page tables do not use the reference count.  That means we can avoid
two atomic operations (one on alloc, one on free) by allocating frozen
pages here.  This does not interfere with compaction as page tables are
non-movable allocations.

pagetable_alloc() and pagetable_free() need to move out of line to make
this work as alloc_frozen_page() and free_frozen_page() are not exported
outside the mm for now.  We'll want them out of line anyway soon.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h   | 53 +++++---------------------------------------
 mm/memory.c          | 34 ++++++++++++++++++++++++++++
 mm/pgtable-generic.c |  3 ++-
 3 files changed, 42 insertions(+), 48 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5087deecdd9c..e168ee23091e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2995,58 +2995,17 @@ static inline void ptdesc_clear_kernel(struct ptdesc *ptdesc)
  */
 static inline bool ptdesc_test_kernel(const struct ptdesc *ptdesc)
 {
+#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
 	return test_bit(PT_kernel, &ptdesc->pt_flags.f);
+#else
+	return false;
+#endif
 }
 
-/**
- * pagetable_alloc - Allocate pagetables
- * @gfp:    GFP flags
- * @order:  desired pagetable order
- *
- * pagetable_alloc allocates memory for page tables as well as a page table
- * descriptor to describe that memory.
- *
- * Return: The ptdesc describing the allocated page tables.
- */
-static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
-{
-	struct page *page = alloc_pages_noprof(gfp | __GFP_COMP, order);
-
-	return page_ptdesc(page);
-}
+struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order);
 #define pagetable_alloc(...)	alloc_hooks(pagetable_alloc_noprof(__VA_ARGS__))
-
-static inline void __pagetable_free(struct ptdesc *pt)
-{
-	struct page *page = ptdesc_page(pt);
-
-	__free_pages(page, compound_order(page));
-}
-
-#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
+void pagetable_free(struct ptdesc *pt);
 void pagetable_free_kernel(struct ptdesc *pt);
-#else
-static inline void pagetable_free_kernel(struct ptdesc *pt)
-{
-	__pagetable_free(pt);
-}
-#endif
-/**
- * pagetable_free - Free pagetables
- * @pt:	The page table descriptor
- *
- * pagetable_free frees the memory of all page tables described by a page
- * table descriptor and the memory for the descriptor itself.
- */
-static inline void pagetable_free(struct ptdesc *pt)
-{
-	if (ptdesc_test_kernel(pt)) {
-		ptdesc_clear_kernel(pt);
-		pagetable_free_kernel(pt);
-	} else {
-		__pagetable_free(pt);
-	}
-}
 
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
 #if ALLOC_SPLIT_PTLOCKS
diff --git a/mm/memory.c b/mm/memory.c
index 1c66ee83a7ab..781cd7f607f7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7338,6 +7338,40 @@ long copy_folio_from_user(struct folio *dst_folio,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
+/**
+ * pagetable_alloc - Allocate pagetables
+ * @gfp:    GFP flags
+ * @order:  desired pagetable order
+ *
+ * pagetable_alloc allocates memory for page tables as well as a page table
+ * descriptor to describe that memory.
+ *
+ * Return: The ptdesc describing the allocated page tables.
+ */
+struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
+{
+	struct page *page = alloc_frozen_pages_noprof(gfp | __GFP_COMP, order);
+
+	return page_ptdesc(page);
+}
+
+/**
+ * pagetable_free - Free pagetables
+ * @pt:	The page table descriptor
+ *
+ * pagetable_free frees the memory of all page tables described by a page
+ * table descriptor and the memory for the descriptor itself.
+ */
+void pagetable_free(struct ptdesc *pt)
+{
+	struct page *page = ptdesc_page(pt);
+
+	if (ptdesc_test_kernel(pt))
+		pagetable_free_kernel(pt);
+	else
+		free_frozen_pages(page, compound_order(page));
+}
+
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS) && ALLOC_SPLIT_PTLOCKS
 
 static struct kmem_cache *page_ptl_cachep;
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index d3aec7a9926a..597049e21ac1 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -434,11 +434,12 @@ static void kernel_pgtable_work_func(struct work_struct *work)
 
 	iommu_sva_invalidate_kva_range(PAGE_OFFSET, TLB_FLUSH_ALL);
 	list_for_each_entry_safe(pt, next, &page_list, pt_list)
-		__pagetable_free(pt);
+		pagetable_free(pt);
 }
 
 void pagetable_free_kernel(struct ptdesc *pt)
 {
+	ptdesc_clear_kernel(pt);
 	spin_lock(&kernel_pgtable_work.lock);
 	list_add(&pt->pt_list, &kernel_pgtable_work.list);
 	spin_unlock(&kernel_pgtable_work.lock);
-- 
2.47.2


