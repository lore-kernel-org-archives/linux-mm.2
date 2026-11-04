Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BCE9606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=H+sCP4cq
Received: by kanga.kvack.org (Postfix)
	id 631476B05BA; Tue,  3 Nov 2026 21:36:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51F4D6B05BB; Tue,  3 Nov 2026 21:36:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435996B05BC; Tue,  3 Nov 2026 21:36:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7F986B05BA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:36:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71771A7FD9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:13 +0000 (UTC)
X-FDA: 85395872226.05.C17499A
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id 43B3D2000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=H+sCP4cq;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793759771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0IQ8XIu/sotRTs8H0lOLMAplNV7pNfoVWjeIbRD+3o=;
	b=euw2NJVHPyOs/PvIpT43SiTh3v+lrX7dE5FLSf4lFA7hO0Wiz5oXRnaf33VDcsu3vizAa3
	hrHhqq+hSg01XjJIZKivSY5iAtKENQ8ydyHAjLHZeb+PsRw8uyQxVTupu8AWoMl2wDkYuk
	vMQcaxtNbh/PqVJYCUm+QPZE1VxmnSk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793759771;
	b=K8Mo63CcW8WDRi8rs3JegRGfl1jY50fTgCnd/qxLRSOrY/iEjsdfjR1n4rLCumMZheqfYr
	PzFtgFtLF5CIoiPY76eQcd50/JetZQQHn3RlyoZhgSFqAutWWvlDLge0pLosod8vDxzrfN
	eudPpaRnwrh7xhuXshNcTnJXAwOgnUw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=H+sCP4cq;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a070781f63so120194b3a.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 18:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793759770; x=1794364570; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U0IQ8XIu/sotRTs8H0lOLMAplNV7pNfoVWjeIbRD+3o=;
        b=H+sCP4cqUAUbcENv8nO5oWNLbKgNg3lSphtTQm3EMIUgOSJA3+8MNlUMucmk/J3/W2
         Cov3KOdoMI9w+J0lwVEtIVCeLiP7hFORC9meKRHkLe5cPcyakza8hD1ygq5TigN1t4G4
         v/7MqcnqYysEundewXpUR5smAGZz+hR/egMhFHDjBdnVVgR7NgYAIFQtxpFZ+czwJB7Z
         BpsbD7dvVn326xulT62iFAelV6RPX6+qt2CTgHA0P4zVxOJ0/5GhxkbRbTSCdQ51ObfS
         klGlA7mKk9fa8NTvkT2mNSVK3vr0zbub9x3OhtEd8VLBaf95izbwSpEACjAN3QqQq+5O
         kUgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793759770; x=1794364570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=U0IQ8XIu/sotRTs8H0lOLMAplNV7pNfoVWjeIbRD+3o=;
        b=fcSv47BbygE78NF/kndZ/SwwC4QaIw/CyLqsN4lKMaExKo1xMTNRWXhBAAp+h9wyBc
         ML50Jmtu1p67xu737I9KfEZx4Hy8xr6ar+nnROhzYjRdlWlW406r0zqzIaFT+KYC4PCr
         OH+iFH2yFDevbaxu5WlPvpvFRwIIp5amWSTfFUxPtodfD1n0sfCScY3UpehEkbK/ps0v
         Tc84gQDn3uCFm9U7E3MQ8ho/GAisEq4Sd3cOwtFtKOczEGNQc415PA1xG3GrcQEMTugI
         9mkru4D7wZ5dJwgQj4J74gYPCudLAlDRTBpO/T16vGaA1JxRdJMpCV2kmgU6vDZWqTgb
         YTKQ==
X-Forwarded-Encrypted: i=1; AKwUvBzVK5wFwwoN7Jx+8ikh04yux7UgJ9Lbq446jUwOpLtWcEt6RDpa2uysGLkVjp1QkLK5iU1N/CnN7Q==@kvack.org
X-Gm-Message-State: APuU4Z8MfGVU9snPKnxhVKfzEeVVcCZkoupFvjhLHOcIV2pEsCWg6liI
	VD/WO0p4li+QBSSplPMNU4JKXvqf63+atnCHK1vHUfi4xZUZhqM7GTOoaihJxrTisDk=
X-Gm-Gg: AYBFou1FIS3OxgnXReMRfr36/sOu9jY+XzJGlweoC83J6JOMwoYyMqy0yGtx1K/o6U+
	NDG8nu3okD697ulKqKmNpx62Gw1kjk4MLoZT6bzj4GClfRto6JInbPVLA7HTk2TZcGpMbWUUiBu
	8AR9FWs/aE5m0WmHTz3fgzL8mdB7C8dc3fCQedp/d+sGnnEurfaiSPi/DQxphf5fqtuaVwe7Ypg
	WJeUCtu6l9mW0VfgEKNRJk8+Op6wRvyaIYOks1ycbchbTf2tNRVU3bQd9/y5WaVFWCup8zmPrnS
	1GquyYPLKXFCZEtvY2UzB2Id9g1+bPBjiIi1d9v9fnKB/RlxI8PnTFKoK/d60QHV278K+ueszDZ
	Gv268pbSb11T9zTGQteBfqaUbY25FqZY8hA5pQBPiFNzF3EHMCVuPQx34VhxuDWy3W2RLX1NbHz
	KY4E8NNDD3IBDa6wgfHBuZOwqyXrPxF+7YPcyQmAQV970N5SQMm6GwgPTtzhtkheKUwDspaxQsK
	wtnHKJ3rh5SDqonh5ACgU0+yG6BKRpapddDx9j0Wbz5zIRQ7D1WF729jJAvRElHHWY91hVTc6qs
	mNhfK7XqdeRnJxR3UHHc3pvDodp+iX/WviZCfPuBNGgo+62gyw==
X-Received: by 2002:a05:6a00:811:b0:8a0:3ed7:93a7 with SMTP id d2e1a72fcca58-8a9bea6a4c9mr11561455b3a.32.1793759769834;
        Tue, 03 Nov 2026 18:36:09 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09bc3d1f2sm240815b3a.50.2026.11.03.18.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 18:36:08 -0800 (PST)
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
Subject: [PATCH v3 07/12] mm: hugetlb_vmemmap: simplify shared tail page handling
Date: Wed,  4 Nov 2026 10:35:05 +0800
Message-ID: <20261104023510.260766-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104023510.260766-1-songmuchun@bytedance.com>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: wm5j3uaho3pxsad6zwh3zq8otyw667ih
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 43B3D2000B
X-Rspam-User: 
X-HE-Tag: 1793759771-447695
X-HE-Meta: U2FsdGVkX19575+RSsCcK+C7kq1Kvh9wJ3ahvTn5rIHRh223AQF02GeZmLOvNSlMeVHEJOSLQGr8kCmymPDQQTa1efnGHdecKHwVo+9HXAnGi9ag5VjlzN9cBFxXxvWGcCS7SM95URBDrQLBefLRkw6VJe/J2rzjzPMa+dNxTc4qXO7wW/T72a2vTRmCGTOSap1wPTR0/x+Rg/EBy0I9lbpv6Ye4iRmaaqexzsyrq3KqV1xiHbwQFIYvRcPB4hB7u0s3h1JFFHXU9B1+Om+3OLI8BtEEK3qPs78TXJWgkZefhAAFyiZtuLqh06IV0ROtnWrdxvWoKcJ3Hn4pDUBneOvzpqGHQEcr6JbEkZ+XkOtb4LRf5xZEC3K61s/nteBcddEOyJ1olloDhr5l+IKgScrFVDnqfsrQ/7Oq4KPM0D3CkVCBLGjNPaNCmjZbDOKS3NN9oWcTmAXy3F+Gf5WIrfIe7y5YE2tFi7oZio45fl/g1f/RjXejsUa9QuvTpJzs984gwVPNLTXYTSWj3d+8o5JRwV7ABau/e4uh1HTW6kqXGneHtD2QLvRl0vXc18OK+b4Z0qNVX7Vo1CTxa2Wf+a/R+KceNA3Fhv3+EbCRfq0VVT1V2/a97Ueex1J1mPAsuIFB09kV8k2SHpFwFvNvwt4V2DFJ3gpKyI6HdpXJpKq8QXmmomuxu2EeHMkd6d9q7Vzj7fjpQ1z9x7XISzcv0pN/+0tptRE0laepQbnyu+CE36Zhou9HCQmbUzAjDT+MdrLIXUefXACfPb6BZ9Q/pwMrT8pk2Szx+5H/5rf4n4qBAfNwndEIblep/QziufQbi4dfjCIrJ2LCCt+AdqbK5N32n+ZPjanM+FotzGooc/WMc4lyGD+qsmUfhGcE+fIDDzGAUZJdmTfAu6vj+N6yno767VKwpK2z0HXc2Q+bZEOYsYfUOh3qqt6+eQn6ipSDa5UGdWcwN9WTSS71lz7
 DWm3ch66
 ZCBAVVk73q1aHm9ylcg/kB0w6/krX9WZW4+f8OqDpSd++cUqCrJlp02iS014PvZW3fq2aolmqE7NziBqc2MMONDkbQTYtfaRzVCnNJl1gZas5AQQ1MXVgV9V0ynY+ogYVb9a7B6b9iw+J81+db4o5rq6dgDu1OHaTc702618UJWSboJ8fL/vj/llbLPYw4hLerwV7TxVJQa3KmZwVoAFYwJw7riKRaV6z04dsU1S9U6KFRcrP2EdfIQlc9kbWwtvgrF3UMQaXkKQSbrgFzuWLn1xCTH5sy8TlrSOcOOIsKbVr55XPT26ezDUcYtr2LtwnM8SYKp0FKe064EFQcwwB5MQjkRvW30+JzVMEk9gztnv81yne/mvq+SmxXk0jGLQtzmcI
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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v3:
- Use two tabs for function parameter continuations (suggested by Mike
  Rapoport)
- Collect Reviewed-by from Mike Rapoport

v2:
- Update the vmemmap page-list contract for shared tail derivation
  (follow-up to review by Lance Yang and Qi Zheng)
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 include/linux/vmemmap-optimization.h |  6 +-
 mm/hugetlb_vmemmap.c                 | 93 ++++++++++++----------------
 mm/mm_init.c                         |  6 +-
 mm/sparse-vmemmap.c                  |  7 ++-
 4 files changed, 52 insertions(+), 60 deletions(-)

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
index 90175499b9eb..2724539f9c62 100644
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
-		struct vmemmap_remap_walk *walk)
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
+		struct vmemmap_remap_walk *walk)
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
+		struct vmemmap_remap_walk *walk)
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
@@ -296,14 +293,11 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_free(unsigned long start, unsigned long end,
-			      struct page *vmemmap_tail,
-			      struct list_head *vmemmap_pages,
-			      unsigned long flags)
+		struct list_head *vmemmap_pages, unsigned long flags)
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_optimize_pte,
-		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
 	};
@@ -321,7 +315,6 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	 */
 	walk = (struct vmemmap_remap_walk) {
 		.remap_pte	= vmemmap_restore_pte,
-		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= 0,
 	};
@@ -496,7 +489,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    unsigned long flags)
 {
 	unsigned long vmemmap_start, vmemmap_end;
-	struct page *vmemmap_tail;
 	int nid, ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
@@ -506,9 +498,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 		return ret;
 
 	nid = folio_nid(folio);
-	vmemmap_tail = vmemmap_shared_tail_page(h->order, folio_zone(folio));
-	if (!vmemmap_tail)
-		return -ENOMEM;
 
 	/*
 	 * Very Subtle
@@ -537,7 +526,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
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


