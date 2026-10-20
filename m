Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A9B60A381E
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=cclop4vm
Received: by kanga.kvack.org (Postfix)
	id 0A52A6B04A4; Tue, 20 Oct 2026 07:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CA36B04A6; Tue, 20 Oct 2026 07:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EADE76B04A7; Tue, 20 Oct 2026 07:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF8F76B04A4
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:58:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57A1BA49CB
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:58:55 +0000 (UTC)
X-FDA: 85342858230.06.1292090
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 820C02000C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:58:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cclop4vm;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792497533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBoGP42HYuQovRH5CMGdUoju18XjesMfphZvgEwtxv4=;
	b=ieMSgRAka0RE4edmuiYGer/WDs7UOKsEJ07x68BQ5O7mzR1ZN90xIQXkb/P9PgBZq+yHoz
	MbCc6SlnbqeoNhjup7aXJTaKLWoIpqJfZPPw79SM6Cpx0/RtqBR74AE++LvGbu1a9gGp0o
	OXZ9dKG6e2Es6VmwqHyGeBjmR+2NGTc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cclop4vm;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792497533;
	b=xZYYafjujWW0uP7bGaFd+YjOPA9pV4N+UZgZ4IkZ6CycGjVoV8LaS/MRI3eS+KdgbEdIAm
	yNxmTQu1u4PojV8b45+CM9ii0m+Egs3ooso9EnTxq90xeUn/Gve7IrsyGuIoCzpZRm+8rl
	QA4W06ZpD+s+o4IlzjGQ1IJ5FPI3VNk=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so1711148a91.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792497532; x=1793102332; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TBoGP42HYuQovRH5CMGdUoju18XjesMfphZvgEwtxv4=;
        b=cclop4vmGPQAatvkk5kHpj0RX+BibrDJnVp3vQkApB+eJSXF8tZQKYXRGHMvgOLJEe
         FpJdY5pnTMfAy5X62/OgHkPwCLnQrY+agk6FSErQ+XIjZB0psQp4giHI1WJQCFi0d1E3
         65pIi4AylEssvPZYxubqM1r7C9mwEiMt6pMeON0hMmYiVuAoUJsrWIXyLpjC2H6yIMHU
         6kcBu6ouMmK8gF8EjmftafIlc2OIEE2cpUFl0QVwXO7JUytqUfgqMKPfid8UDyV8xGsf
         nY+2KAeFETCxo6FXZ0DH+/XfUq6f4NNaSs50w4RdVhiuj0NEZ4mImY65fdSPyAGdVlmT
         RbyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792497532; x=1793102332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TBoGP42HYuQovRH5CMGdUoju18XjesMfphZvgEwtxv4=;
        b=iwyEJF92RNavNbnQjImLsYbpHkSy+VWPlEtrNQL6a6d7JC5Ur4mjVDwEEoxrmoSdOu
         tEgj/nbBSlWAC5AVpAFbD+xZhUtzZlonl2nVfDIW6XUqo6xpMVdWBKO6sbnorfBLKlyU
         HaXquwU9ZMnjoQmQwi47BvsExtCOdm/87Yi7dz3Ia9yoGeXBJidG51aTcLum8N/AD4n4
         kjZQQeqvx7sjwSYBusqwH2hBm1SHy1ICBSXhBBQFCV5gYk7ASlvcbXTGNoMUBjBjR3A4
         yzbDwdJZl04cum5f6HSS7zKmXsHTQ833WBYtS9Q7YH6dGML7TWmczZ8EdESk22eZSb+c
         ACTA==
X-Forwarded-Encrypted: i=1; AKwUvBwSO4yQEi7jHOF2fJaoJSjAEhP7w4+MxUkV+V46/Ou6TfYhQpQqXE9ksWU7OKaogiV3qPY7pHvJaA==@kvack.org
X-Gm-Message-State: AFq9FYJBvhO2c2I+pv+UxKO/4PzF3XorBl4nFbA1Tt5XKa2V/gV6Y9p+
	DSPVXt3xd33iJCLOwMEY+hUwY1/vt6MpnFEfwinxcTz3ABLQc8KzSA1cBIdS1VRq1Cg=
X-Gm-Gg: AYBFou0RM8cC/dXrClhn4QkjpUfu/ZN2MlaJ1Z8Chdtze7iIQM26BWzaHUDKEAxASOf
	Kdjxt9FBacNZrmDm0RvwFPHmTD/7oQkcdgKkIUJrIiO7yKk6zbttpc7I3nPj67pj8Kz+ZRQc18D
	iyxhoEpgBbUFi9djmTgLqDcKnKSZ31hlhUWqVFzWVuWxxhot+tggHnHGzLtjaib16PTHMkmA9Rj
	hbiNLMBNS42EuBjrxSYe7QYkW5JvrLZ8FUF8jPyipSpTwenP47ih3+kWL4h7jV5+lJyF1L7lpgi
	T2FO+7V2x2FKRRrDjewd3OL9id8XnvPpbp2w0Pu6/8whyg/jVXGsMd01WjGezD59KuSduh8fxrn
	bVcDnw4aiv2CXj6SClLxNMrv9kt1kOG0xBSdqfJv3wkPiWup6lL2/6lH3n5BQ6bwcqcRHv/9Dr3
	oPgPtsd1hP4JRYQyuP4c9UnlySIsPOuxTibXbZkCVmdkRn9PzcocwwmW3hHAE1AB88US1KaJV13
	E5qoouuh0RRvkbL4YEUrsCos4IhQyw=
X-Received: by 2002:a17:90b:5112:b0:3ab:c80:9365 with SMTP id 98e67ed59e1d1-3acef0f47a8mr9218040a91.42.1792497532133;
        Tue, 20 Oct 2026 04:58:52 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad60274fc1sm3448095a91.0.2026.10.20.04.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:58:51 -0700 (PDT)
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
Subject: [PATCH 07/12] mm: hugetlb_vmemmap: simplify shared tail page handling
Date: Tue, 20 Oct 2026 19:58:19 +0800
Message-ID: <20261020115824.823278-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261020115824.823278-1-songmuchun@bytedance.com>
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 820C02000C
X-Rspam-User: 
X-Stat-Signature: hrycpdxwo4is1ijgo3c1h1hcmdpb368g
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792497533-694118
X-HE-Meta: U2FsdGVkX18x/uEJ8hpr89K6uePgC6gOO8gx2c3R4teu8Zofo0+CJ86cd5X6Z7xxEdu5G+NndbDt0WuvJfqcQfRl5+VLYu6jTwQn5StN3CbckvER8XxW8m6G7RTUnacOTyHtXATMbQ6KDET+x/qDm0mLXaQmArNzXO12zmTv14AkjRPx6OhBOzbt6ePOdGDP3W6OiPp/tr6mp9QV+2XE35VHCDo74mzedscQLOgfb7uKe/g/W/E7FtQ9gdiCeEPx83C7/OC2wqOm4M2FcnEOPFoMxwjyNl6pU2jMwTs4nODMwF8RMkeTsR2oOaWDZ1tmcihIDEjfOkwLU6wwjNMfi275m16H+hFR2ISByVymMdyYXo/ffF/rBTKF8CFFJMT7y8vdNOsDjuLrvZ3u1ZKj5OkTArJpcSU5A6REYUDVH41fvsrAooYCOMsWU2cvHShP2OzAIdCrgSfCuwgHCGsohr+QJWur5gJ5/lHfpB9Yuax4kexkq9acEmgdRrQGLlM9DFpbuY15WkQHn5lzb1C2GrZYQC8o9FWnhUE/9n8UDoyEk7ocblngSllnhOjojp4UvLPj5EQ90frosuriN0FUGYhSV+EasbNfx32sriQCXcMTGk0NKrp+KHuLNcEdJBgCiz4zQgGe8+6rYGv1vUE6fxSgSJUw5KknmvIWp+OsvDf+/M5npK6fLV8/EiUazsHLHJ0qGi64h1Cn4IdoWLYbTiAijLZx+INF7lmBqDUs2cTcVrmR5I17AcdNEAHleExTzaqcIhfDxxMAQAUk2KHIDF6I1lOGs2JqkB9SBpIwXpJ8xszRbu7cXfhU3esBZIZlp0oL41s6AJ/QX3KizRVFMjb8wanBSPLeCoN5gIJdaovE3EBSD7bX6yg4RiSFGFL/hdWSgERs+W37ctXwgvVsz2hGMz2f6iHvAUX2xXqdJTdEPgJn0SRmacxS3RFvQrW93RjfnM3UiDdcujbYUDN
 Ma4DiO86
 0a9nMngPvju/Gk3JVPGqVtyu5ZvCBMwBzKgMfxlEbPgb2b7kqTLekuooTQEaJp6zohbeIFjqce1JGSGHK9w2ZCQiMNmHS56JkicBSSx2WnRTWhnTIMJOiZhLC+O98hzUoxhBCvvW6nxjeA7sT4HusH7Af0s8/+xcRPCKB7wa2yTNP6xr0OjedNVHHyADGqAFVCAJGg0vOOni53ZQyJnlvzCWnD0ZGGQf2Sk57fLNZqR6ff7n92Hh9QiEZ8Gfgf8yy4piCUzN4cYNWlCqV7WtrQz2CZleZ0o48t5A1OCt0qFT5fjRa3JeNV862narhXP4xGwNEUP0GYJXyVlZNF3/7/Yi3lMWRIhHmzf4kPMX3MronLaA=
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
---
 include/linux/vmemmap-optimization.h |  6 +-
 mm/hugetlb_vmemmap.c                 | 89 ++++++++++++----------------
 mm/mm_init.c                         |  6 +-
 mm/sparse-vmemmap.c                  |  5 +-
 4 files changed, 49 insertions(+), 57 deletions(-)

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
index 18b72d553955..8fac61b7d74a 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -24,22 +24,18 @@
  * struct vmemmap_remap_walk - walk vmemmap page table
  *
  * @remap_pte:		called for each lowest-level entry (PTE).
- * @nr_walked:		the number of walked pte.
- * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
+ * @nr_walked:		the number of PTEs successfully remapped.
  * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
  *			or is mapped from.
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
 /* Skip the TLB flush while updating the vmemmap page tables. */
 #define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(0)
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
@@ -213,51 +211,51 @@ static struct page *vmemmap_dup_page_from_list(const struct page *src,
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
+	pte_t entry;
+	struct page *src = pte_page(ptep_get(pte)), *dst;
+	const struct page *page = (const struct page *)addr;
+	const struct folio *folio = page_folio(page);
 
-		head = vmemmap_dup_page_from_list(page, walk->vmemmap_pages);
-		entry = mk_pte(head, PAGE_KERNEL);
+	if (likely(vmemmap_optimizable_pfn(page_to_pfn(page), folio_order(folio)))) {
+		dst = folio_vmemmap_shared_tail_page(folio);
+		if (!dst)
+			return -ENOMEM;
+		/* Remap the shared tail page as read-only to catch illegal writes. */
+		entry = mk_pte(dst, PAGE_KERNEL_RO);
 	} else {
-		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
-
-		/*
-		 * Remap the tail pages as read-only to catch illegal write
-		 * operation to the tail pages.
-		 */
-		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL_RO);
+		dst = vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
+		entry = mk_pte(dst, PAGE_KERNEL);
 	}
 
-	list_add(&page->lru, walk->vmemmap_pages);
+	list_add(&src->lru, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, entry);
+
+	return 0;
 }
 
-static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
-				struct vmemmap_remap_walk *walk)
+static int vmemmap_restore_pte(pte_t *pte, unsigned long addr,
+			       struct vmemmap_remap_walk *walk)
 {
 	struct page *src = pte_page(ptep_get(pte)), *dst;
+	const struct page *page = (const struct page *)addr;
+	const struct folio *folio = page_folio(page);
 
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
@@ -281,13 +279,11 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
 
 /**
  * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
- *			to use @vmemmap_head/tail, then free vmemmap which
- *			the range are mapped to.
+ *			to use the shared tail page.
  * @start:	start address of the vmemmap virtual address range that we want
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
- * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
  * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
  *		responsibility to free pages.
  * @flags:	modifications to vmemmap_remap_walk flags
@@ -295,14 +291,12 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
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
@@ -320,7 +314,6 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	 */
 	walk = (struct vmemmap_remap_walk) {
 		.remap_pte	= vmemmap_restore_pte,
-		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= 0,
 	};
@@ -494,7 +487,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    unsigned long flags)
 {
 	unsigned long vmemmap_start, vmemmap_end;
-	struct page *vmemmap_tail;
 	int nid, ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
@@ -504,9 +496,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 		return ret;
 
 	nid = folio_nid(folio);
-	vmemmap_tail = vmemmap_shared_tail_page(h->order, folio_zone(folio));
-	if (!vmemmap_tail)
-		return -ENOMEM;
 
 	/*
 	 * Very Subtle
@@ -535,7 +524,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 * they can be freed by the caller.
 	 */
 	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
-				 vmemmap_tail, vmemmap_pages, flags);
+				 vmemmap_pages, flags);
 out:
 	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 01ced0553ce9..0bb3fff4944e 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -896,6 +896,8 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 #endif
 
 	for (pfn = start_pfn; pfn < end_pfn; ) {
+		const unsigned int order = pfn_to_section_compound_order(pfn);
+
 		/*
 		 * There can be holes in boot-time mem_map[]s handed to this
 		 * function.  They do not exist on hotplugged memory.
@@ -911,9 +913,7 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
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
index 40eba70c0048..107850b530f6 100644
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
@@ -296,7 +297,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 
 		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
-	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
+	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn, order)))
 		return NULL;
 	return pte;
 }
-- 
2.54.0


