Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F72606A332
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Zc9ZY7hM
Received: by kanga.kvack.org (Postfix)
	id A13D66B05BA; Sun,  1 Nov 2026 22:26:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5A86B05BB; Sun,  1 Nov 2026 22:26:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83ED56B05BC; Sun,  1 Nov 2026 22:26:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 573996B05BA
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:26:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6FAF01A0BB2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:52 +0000 (UTC)
X-FDA: 85388742264.20.73D5607
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id E333E140005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Zc9ZY7hM;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793590010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJ54Xg0GcpdGsVS9czVD/kKCrgo5Wxyx3XdjPkQ/X5g=;
	b=4dQHFR3nxD2osj6fxI6Z+xP/yEo9pbk2U46jjVSKH4quBgUpA5L0urid7XRS78ThEknLmo
	vpUMjfmdS2emhnFUp78Oua6FSQAPt+nDDRT7qG/SyKwO+MD+p9UATuH1R3tLL/d0qVbZ4C
	udbK2bFpHt9fUeBrdceYzRo1+E4aVHU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793590010;
	b=5+Foag1VqqHjdU8CoOsqQjbrdMANCALZWtaBrkeFmAtL5dPFvJa43w+xvCreKPSczdAXa3
	0Z5S/gB/KntSxK2yHYBFAGbobMxORB/mAWtUfMxvOo28PckvS+Ph/GOYlxDlTMwV+lW0Ot
	DoBp4EkF1Ps1w9CgXGCpop7T0scbIyw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Zc9ZY7hM;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso1709041a12.3
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 19:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793590009; x=1794194809; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lJ54Xg0GcpdGsVS9czVD/kKCrgo5Wxyx3XdjPkQ/X5g=;
        b=Zc9ZY7hMHx/j7xVh9Bk9tfjxGjvL1szeGEWx+sHtdYmZnJRn1C9vamyDoDjuD0cBCD
         5u962zyVue0wHnjf3K4pgGEoaiWLQxI0gIOGU8F/7lZbhPqxTYvgMmU0ouGe+j4Smef3
         2HyKLaM6caczvuAOL7yQdprL+WpV7zxU+gr8BtgWXxko8hwcR/ABMrVnPq6rhR011ssX
         PSAcAnAJFgh8OyBDVNTy/Ee0bGkJ5dV1UcJvIqNEY2mu9OdRijxGin4RYQmAOib76reo
         bnpK2sZ8B6u8RzJ6ykOHs7LcVV0DtwwlurlpHU9PFQTd60gY6GhobX4XQncCNbo1Er2V
         PLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793590009; x=1794194809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lJ54Xg0GcpdGsVS9czVD/kKCrgo5Wxyx3XdjPkQ/X5g=;
        b=VSY4fx9+yGCb2SoPIZnBRirbPAKA3n+1onb1B0o8BVqIplt1Ei2r9IgRiY2p7RbzYJ
         f/1fySqyzTBOhFEgQ1Bn1X1DQRwxdKnpDUhywJZD5cnu+7iiM3ptejhxmaQx99QK6d3m
         ou5Yz9gh5x38iKvPRlkjqhkpx+rp+TvOu/yV+Dynvgz4o3KZObObBJLNwwzRmwssKVqM
         5AfPSWOvOVyLZ9EeTop1G7GFGGAotJQrT+ckt7lFgMI8zvrbiMW7o8oh8qJiUIDEOXXq
         KepMcnb6/pjvkPy7vAa8ZPKkY6nAEzG8aVDeiBbixTWM5C1/Bunz/G35smlrYtEPCdTF
         P7fA==
X-Forwarded-Encrypted: i=1; AKwUvByyVyPb3v3XhpjTqwq/lbzLS578/yNwC3GWSZX/lTGd2N4OjscxDZjVlrll+QTEATZBGneGkmdXqQ==@kvack.org
X-Gm-Message-State: APuU4Z8Hfk3vG3Z9EUL0HXYkSnq/4VJ9zG/9i0arvCqHpA+fBNEvKawq
	iAmgSjGtbv4/YUyIrcg5k+/qz8BIOf/hXLomnG5u1KQkbEfUVbE8f7/KQRMaDH5xHks=
X-Gm-Gg: AYBFou3zC/q5i0uzAhmmHD7yJtCdsVMVxgcnmdvc9hFEh37Sdvv9rKnH0OjJ9GWYuYM
	XO/TOboJSe/1VExLlYUv+wA9vdSpNCtUT8Ctuoe1a3t9gYX5LP9Ou2FZ4+a9Y1e21labztOcir8
	E2iz2O8KEiYWMDINxizsBD66Nd9AvTP5uqekc0bh/ENNyPvOqmI4+uJP6hkc1dNjOvHNJoBO8xC
	cYFRFjVM+WBq5NavEsQo/TYR+o8qnIX3kUF3Epb+zcBcGsMP+MWkB/iHQ4v/74CaURh6Kgqi7Nk
	w8WOuQdabuk/gi25ePLRu2cJtg9xq9p758JzXr4pnA2tudvK/zHcvh4RO5xOj/HYyCS7OeFjbMI
	QrtSBRCeZl71wfOOdoQTGp1H5vzRXNevgW4yAx8r9ztDck0c7o5JtgOSpEeT0FLM7wNSlUOWbAV
	UEhOcWQagazDXR2qyMgz7hE8Eibri6TM8GeC+bn5Nd97zcqdDJlAsah68cO2xd97+Optt8mMHX/
	/KSIWFBxCoYdgePrXoaAOGXtTRkLpa0CQwxHOLLZtt/8rrE6UvQy9sHVPKJfP8NMTxjQElR4OqC
	GRcgXLmBaJ+9GIyFKAI5DxQE9WN1g8YHH2RMolZNIlMgUmDKRg==
X-Received: by 2002:a17:90b:28c5:b0:3ad:ce24:acfa with SMTP id 98e67ed59e1d1-3ae897c652dmr6697898a91.20.1793590008702;
        Sun, 01 Nov 2026 19:26:48 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845984absm12303317a91.10.2026.11.01.19.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 19:26:48 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 07/12] mm: hugetlb_vmemmap: simplify shared tail page handling
Date: Mon,  2 Nov 2026 11:25:20 +0800
Message-ID: <20261102032525.3597743-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102032525.3597743-1-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E333E140005
X-Stat-Signature: pknfi3d937o8qhszuczhapf91s4gutec
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793590009-868106
X-HE-Meta: U2FsdGVkX19WKguJVUZiHRWa1zFsX1lZhsA53MJknsCrOjVjB+PElyz5PGuOkkAshhS3a6AmCkwzeZYnCcql2bf4o5H3Cc2nJkkSQM8hBgEJ8AD8YPbvHFKHup+XJ7b2Wy3Oy8bS2azSwd4Js6o7Z7TKpNH/n71f40R4JKr4DAwGO3x/sTcqH7dfveXH4U9ONPr+O7XYKjAPPpUBoZSi/uVtTpabSBMIvJCvL1gLemSN7qvNGgK9fUpd7tjEixFSkrH/EBh74j84YmVgcb4u6ep0ddEBNLZU3DT5eL/ULr+/jzBhX/nRYFhmaBetpVGwAD6xNzYaEpHhK9kd0nJgCaNCoc1m3NnvNRxlSyEKBTzYvijGrWwmApLKizjm6Ko4FyjxkMh+4QJaCBgJJpaDhtkJj0xNd/85Ex2C4DkRqtO5qEO1dmkNsF/ZyX2ed0TUsIXc/jYdU+O0p0dKQ0Vqc8tL4lYdoIfXtMp8DsWLNGzXgaXLiUpwc7Knq+bQw5zoT7NGFIw5lKD0M9M+orusX4h6f/0nXPQrlf17t4ahC3xTpNuwzHaHp+qU0/P8Jo/3wG6hmW19a7Ifo/+WN02LfWKvN7It6W+1MGbyRfdpUvFjn9UlCegMYtRPLF6pftVMHnMknI7jWckjC6ZqcZlLvsf8FmruWvTdy3IbeWIu0CTZEMp3pdw2LmP3u0AHxuVcyaNmFH36MJ39lYSS9T5K+LJ2jcAaxivwfgoJ0cMXffnrfeRKv7P978yrNgAYqfoMtYCsjh1NFiipjCyCCIkzeZlGklM1aVNdD5QXwjk8/6cG5CX0/7GsTYpWHHto9ITqdFXNRavIEG547E/AR/0zRB8ay5ZWREt65SpbOkHkB9qFaY0xAKO30s4QH7jWagUV1SvF2BmPJGN9VE/AFVwHjSFJyRseFcHhOTyAbLis2OZqqRQV1/Q1cAC+tZ6D118yzYrL/eZh+Ja2BOlI9lM
 14btxjd4
 +KmU15DiKLcGlzt8uyIr4vVz1UkKz3rX7xDOXMX1W7iJ5OA3IW6FYOq16QYM7j7ZvYRBZJypr4mb0jtdZz2RfnnUUXHKOtQrid5O4gk7Pr282qWvr/PFJ3XOJtJ7P5LxnYFzC13/51q9rtFHChIKdh27ANIn4+isWkKQ+j/jaLrbeuVGdrltrcNw5lJksbZWEZ+tlNLvum57f0QGHmYfO/OKMcRFLp9XDFX0z4greuT/52rSJcfAl+YvIP+O5fBQad1FQEMSMdx7Zr2gtRvlxIBJl1FdusLkRXs7O+LV7sDWj63YSULnmJwW/GuNdVcem0o60PR73leq2dB9bqgP0mlFoQISlEpAnVAEdxV/DGk9LFUjtPTLD792L9lovKlrUpKL3o37VDztcAXgXBe5tF3D8aR+YtAXqHCKdLGuDU8jnH2D+NUWt0YfJ0EqwmzRJ83rw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The remap walker currently carries a shared tail page selected by its
caller, even though the optimize and restore callbacks can derive the
same information from the folio being processed.  This adds redundant
state to the walker and couples its interface to caller-side preparation.

Derive the shared mapping state in the callbacks instead, keeping the
mapping policy with the PTE being processed and simplifying the remap
interface.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Update the vmemmap page-list contract for shared tail derivation
  (follow-up to review by Lance Yang and Qi Zheng)
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 include/linux/vmemmap-optimization.h |  6 +-
 mm/hugetlb_vmemmap.c                 | 90 +++++++++++++---------------
 mm/mm_init.c                         |  6 +-
 mm/sparse-vmemmap.c                  |  7 ++-
 4 files changed, 51 insertions(+), 58 deletions(-)

diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
index 065840f3c241..858311a71b0c 100644
--- a/include/linux/vmemmap-optimization.h
+++ b/include/linux/vmemmap-optimization.h
@@ -91,11 +91,13 @@ static inline struct page *vmemmap_shared_tail_page(unsigned int order,
 }
 #endif /* CONFIG_VMEMMAP_OPTIMIZATION */
 
-static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
+static inline bool vmemmap_optimizable_pfn(unsigned long pfn, unsigned int order)
 {
-	const unsigned int order = pfn_to_section_compound_order(pfn);
 	const unsigned long nr_pages = 1UL << order;
 
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
+		return false;
+
 	if (!is_power_of_2(sizeof(struct page)))
 		return false;
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 5e84004db4b8..d0af251aa533 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -25,21 +25,17 @@
  *
  * @remap_pte:		called for each lowest-level entry (PTE).
  * @nr_walked:		the number of walked pte.
- * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
  * @vmemmap_pages:	list supplying replacement pages for the remap and
  *			receiving displaced backing pages for the caller to free.
  * @flags:		used to modify behavior in vmemmap page table walking
  *			operations.
  */
 struct vmemmap_remap_walk {
-	void			(*remap_pte)(pte_t *pte, unsigned long addr,
+	int			(*remap_pte)(pte_t *pte, unsigned long addr,
 					     struct vmemmap_remap_walk *walk);
-
 	unsigned long		nr_walked;
-	struct page		*vmemmap_tail;
 	struct list_head	*vmemmap_pages;
 
-
 /* Defer safely batchable TLB flushes to the caller. */
 #define VMEMMAP_DEFER_TLB_FLUSH	BIT(0)
 	unsigned long		flags;
@@ -140,12 +136,14 @@ static int vmemmap_pmd_entry(pmd_t *pmd, unsigned long addr,
 static int vmemmap_pte_entry(pte_t *pte, unsigned long addr,
 			     unsigned long next, struct mm_walk *walk)
 {
+	int ret;
 	struct vmemmap_remap_walk *vmemmap_walk = walk->private;
 
-	vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
-	vmemmap_walk->nr_walked++;
+	ret = vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
+	if (!ret)
+		vmemmap_walk->nr_walked++;
 
-	return 0;
+	return ret;
 }
 
 static const struct mm_walk_ops vmemmap_remap_ops = {
@@ -213,53 +211,53 @@ static struct page *vmemmap_dup_page_from_list(const struct page *src,
 	return dst;
 }
 
-static void vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
-				 struct vmemmap_remap_walk *walk)
+static inline struct page *folio_vmemmap_shared_tail_page(const struct folio *folio)
 {
-	struct page *page = pte_page(ptep_get(pte));
-	pte_t entry;
-
-	/* Remapping the head page requires r/w */
-	if (unlikely(walk->nr_walked == 0)) {
-		struct page *head;
+	return vmemmap_shared_tail_page(folio_order(folio), folio_zone(folio));
+}
 
-		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
+static int vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
+				struct vmemmap_remap_walk *walk)
+{
+	const struct page *page = (const struct page *)addr;
+	const struct folio *folio = page_folio(page);
+	struct page *src = pte_page(ptep_get(pte)), *dst;
 
-		head = vmemmap_dup_page_from_list(page, walk->vmemmap_pages);
-		entry = mk_pte(head, PAGE_KERNEL);
+	if (likely(vmemmap_optimizable_pfn(page_to_pfn(page), folio_order(folio)))) {
+		dst = folio_vmemmap_shared_tail_page(folio);
+		if (!dst)
+			return -ENOMEM;
 	} else {
-		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
-
-		/*
-		 * Map the shared tail page writable. A lockless get that read
-		 * a non-zero refcount before the remap can still do its
-		 * cmpxchg after it. The refcount is zero, so the cmpxchg
-		 * fails and leaves the page unchanged.
-		 */
-		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL);
+		dst = vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
 	}
 
-	list_add(&page->lru, walk->vmemmap_pages);
-	set_pte_at(&init_mm, addr, pte, entry);
+	list_add(&src->lru, walk->vmemmap_pages);
+	/*
+	 * Map the shared tail page writable intentionally. A lockless get that
+	 * read a non-zero refcount before the remap can still do its cmpxchg
+	 * after it. The refcount is zero, so the cmpxchg fails and leaves the
+	 * page unchanged.
+	 */
+	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
+
+	return 0;
 }
 
-static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
-				struct vmemmap_remap_walk *walk)
+static int vmemmap_restore_pte(pte_t *pte, unsigned long addr,
+			       struct vmemmap_remap_walk *walk)
 {
+	const struct page *page = (const struct page *)addr;
+	const struct folio *folio = page_folio(page);
 	struct page *src = pte_page(ptep_get(pte)), *dst;
 
-	/*
-	 * When rolling back vmemmap_remap_free(), keep the copied head page
-	 * mapping and restore only PTEs currently pointing at the shared tail
-	 * page.
-	 */
-	if (walk->vmemmap_tail && walk->vmemmap_tail != src)
-		return;
-
-	VM_WARN_ON_ONCE(PageHead((const struct page *)addr));
+	if (unlikely(!vmemmap_optimizable_pfn(page_to_pfn(page), folio_order(folio))))
+		return 0;
 
+	VM_WARN_ON_ONCE(folio_vmemmap_shared_tail_page(folio) != src);
 	dst = vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
+
+	return 0;
 }
 
 /**
@@ -287,7 +285,6 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
- * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
  * @vmemmap_pages: input/output list whose first entry supplies the new backing
  *		page for @start; replaced backing pages are added to the list for
  *		the caller to free.
@@ -296,14 +293,12 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_free(unsigned long start, unsigned long end,
-			      struct page *vmemmap_tail,
 			      struct list_head *vmemmap_pages,
 			      unsigned long flags)
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_optimize_pte,
-		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
 	};
@@ -321,7 +316,6 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	 */
 	walk = (struct vmemmap_remap_walk) {
 		.remap_pte	= vmemmap_restore_pte,
-		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= 0,
 	};
@@ -496,7 +490,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    unsigned long flags)
 {
 	unsigned long vmemmap_start, vmemmap_end;
-	struct page *vmemmap_tail;
 	int nid, ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
@@ -506,9 +499,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 		return ret;
 
 	nid = folio_nid(folio);
-	vmemmap_tail = vmemmap_shared_tail_page(h->order, folio_zone(folio));
-	if (!vmemmap_tail)
-		return -ENOMEM;
 
 	/*
 	 * Very Subtle
@@ -537,7 +527,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 * they can be freed by the caller.
 	 */
 	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
-				 vmemmap_tail, vmemmap_pages, flags);
+				 vmemmap_pages, flags);
 out:
 	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index d99af80ec752..a9d848c92678 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -914,6 +914,8 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 #endif
 
 	for (pfn = start_pfn; pfn < end_pfn; ) {
+		const unsigned int order = pfn_to_section_compound_order(pfn);
+
 		/*
 		 * There can be holes in boot-time mem_map[]s handed to this
 		 * function.  They do not exist on hotplugged memory.
@@ -929,9 +931,7 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 		 * Vmemmap-optimizable PFNs are backed by shared tail struct pages,
 		 * which have already been initialized during vmemmap population.
 		 */
-		if (vmemmap_optimizable_pfn(pfn)) {
-			const unsigned int order = pfn_to_section_compound_order(pfn);
-
+		if (vmemmap_optimizable_pfn(pfn, order)) {
 			pfn = min(ALIGN(pfn, 1UL << order), end_pfn);
 			continue;
 		}
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 3e9d6617c4bb..b8b55e12f5ba 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -241,7 +241,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 	struct page *page;
 	const unsigned int order = pfn_to_section_compound_order(pfn);
 
-	if (!vmemmap_optimizable_pfn(pfn))
+	if (!vmemmap_optimizable_pfn(pfn, order))
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	/*
@@ -286,6 +286,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	unsigned long pfn = page_to_pfn((struct page *)addr);
+	const unsigned int order = pfn_to_section_compound_order(pfn);
 
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
@@ -296,10 +297,10 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 
 		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
 		/* Map the shared tail page as read-only to catch illegal writes. */
-		if (vmemmap_optimizable_pfn(pfn))
+		if (vmemmap_optimizable_pfn(pfn, order))
 			entry = pte_wrprotect(entry);
 		set_pte_at(&init_mm, addr, pte, entry);
-	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
+	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn, order)))
 		return NULL;
 	return pte;
 }
-- 
2.54.0


