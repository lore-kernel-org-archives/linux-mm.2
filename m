Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD07D44C5A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EAF76B009D; Thu, 15 Jan 2026 09:46:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957346B009E; Thu, 15 Jan 2026 09:46:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786706B009F; Thu, 15 Jan 2026 09:46:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 633046B009D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:46:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4E35140380
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:28 +0000 (UTC)
X-FDA: 84334474056.08.A7BA41B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id BDD13140004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R699iQhV;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768488386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0xbAn3WK03b8Fq0STC1d+hgogBWGwO30vD5oM61yX74=;
	b=tZdgkhQa9fsfuEPtXnZOeH6rlEujFdiGMg5J38AOYojjc6mQPu1eIGYyPWxRXJGCPQc1we
	WRt3IPlnEW4Adl1SPDjBA96b3na1UsaAkBd5Rxk+bSJMHsCW6BLvSJu2ykKi+kqEsQYN0q
	wh4xJFakkfiSoWzbulNkTv5PY1bqdV8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R699iQhV;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768488386; a=rsa-sha256;
	cv=none;
	b=F6EwDnxcijbysYMTciXmEXDITjMM/oyV53ybF5v2HPDuetKm7KMjYg30y+sdqhJQ/WosaG
	l7a1xtVP+gJzqC1g//VlvkLtza2+6thRW/JjoaiaUV/t5UQPM+2Z9nyvrOhtOYtLtBTYM/
	zIsIgTBmMtZO1DsqAfmmniAtNTAGePc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BF744443E;
	Thu, 15 Jan 2026 14:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C9FC4AF09;
	Thu, 15 Jan 2026 14:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768488386;
	bh=I0peSzQJvlIZz5uMjSKzPiwpkY7ufWY5RidKc3yKlbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R699iQhV4OOHiDgDYTjylFpQBC6eLW+aiX9cTvJJ4tgeLRRFggUCDCtDpoRKfsh/S
	 02U6AOEO2KAqxxfFd57tns0l2SHnNpWa+pJdCRYhD9f44xqT2iit4TbiowmIcB0H6e
	 /V8JkqSpD4hVBTYr1zeOGzqb/+wmIJclkfDxNt8t3h+BWZctFpERXLcr+ktikmBS2V
	 RFo5qY7fwFh64Xd08iQrcIFstqyelGubITEBBEZqh0DO4+YaTX5u1FQhEgvagvYz4B
	 2EtjG4u2+ORD+G5l/Z9Us+8RZxXz6hY+cvTGxaJ3rLUjPWsVxRKTWmY1tuCrChmyI+
	 2yysEf2GfKojg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0016EF40068;
	Thu, 15 Jan 2026 09:46:25 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 15 Jan 2026 09:46:25 -0500
X-ME-Sender: <xms:wP1oaZvpnEUe5vsfvHSgOlJT4hooIQooCRbaUNDRis-Y6U7mcjCH8A>
    <xme:wP1oaRvxSod6DGeoJsLIvaX5Y2zRBd66MzQT_NksmYNUBFDvi4U-wEeBLN8X-F-pp
    frXw73uNq0FnY1g_N0fNGaa8pMeDcpDShQn0-er3LcjhilmgIQiLM8>
X-ME-Received: <xmr:wP1oafneybhNCm6rZWt920vgGvpEI9-eHaKCkR04si6AeP6RNHEPKV4YMsm68A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeifeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:wP1oaXt9pQQSAp2t_NdEt7r8lR30t9W_G0uu3uvyHlbC4covWI6afw>
    <xmx:wP1oaeM34zMbMcB9RzPAFWrxxfT1dYMHXiekJ3_ohiK_dFcEDDZN8g>
    <xmx:wP1oaY0MPHfCI_NWf8gd10K1UMr-sL3r5N1nSOT9rOhE9aVw9IQ9JQ>
    <xmx:wP1oaQzt55hw4TKgFLCG8KI3S7XMrqXzpv_sQxzE6odlrrDpP7QmVQ>
    <xmx:wP1oaSqgO7wVkmzErlv7ieLaYPRsE1BkRIYZQBvyD0bEo4Ztm6CuctG7>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 09:46:24 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv3 10/15] mm/hugetlb: Remove fake head pages
Date: Thu, 15 Jan 2026 14:45:56 +0000
Message-ID: <20260115144604.822702-11-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260115144604.822702-1-kas@kernel.org>
References: <20260115144604.822702-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BDD13140004
X-Stat-Signature: no3p7ib41ky36bskjt5qhqc1xt5tokwu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768488386-608919
X-HE-Meta: U2FsdGVkX1+upaLtq2fq3LPFBGAB5KUsZajGT3COZYSd3/36EXvs20hQrW/mUChDrUJhLa16Kd5VywsYksT5HLWw7ArW9cKVYQK/vl0NFQa47AvWGHyvkdXoozLVKq6VkGkg54Z0QCJIquxAsuPhZ4aBU1Rxa1oC3mjQc0aA96oJ2UVe8dU0qNvkOl26X6v+/CBgs+1ENCeDkM3b3bUd5+LKTQKeXxo8Y3a5MOHgYllgbxNiBY0McWvnuRpVxlNsUIQR1FDHqX54AVlDxJNV0M+Ntt09AKSksJn75zr5/qgCS60+ihU81N4vAxDVpUu2xjPIvDCr/RegmvM7jkA3/5/PO7rJsvWptw+tIwe9lETeiofLTkcQtEJGIGC1RRnUSOhe6Tw6yicQYLN0E54j0bSjboLdRX3dX7YIEI2VBfgECJ5gWoDrpabtxpyeSvIGOduV6HTgocvu8Zhpuj+Ug1lJcbFxsnc4kdYFWwZaVdwhIGZY5rWKEsJvScQcNDG/ZKWrqVMUcv1THb8D6bKpVisvld8/eK4Ny1vS1WgmGv65ypLv3hFZ77Gx4bBP2+PwX6uHun/5zm2+IdLmrrMUY3O5on1EFiwnwQnPSmKCcx31wSmXiErje142hqyh+BwKWqplbq7O+WG2Oc2Uxc5HMcg/qUcnFiTrNTKPfcYTff1VQJcBfxmlWrm3gqZfHr6D/gSXUGHs5DctLNTiEQ5dJ3ihmtoY89u7R9hZ6wt83fh8N0dKnRigJNUwRyhd18nj2OctMgdCvucKVI+bTxH2IDCtnENBILwT/NeK/isvWlnXNopICp9EzjClN1+6mKo530lyLGHayD7VU0zI589JadJznTa+AKqOjVLwTUf/kxgmK9s/0MMte9SZl7tszt3ue4Tts1Fcn0azkd68oAqHyYsI8OsASF9SLs8WIyO3gQDVvDP1wxw187rWFRgzERQsVWUNHk6xR4EBLH4NrXd
 ZZCMMXBx
 oj3clCoUKSGhOiFy4WKL9PAij0rYRevv2cWeeTR/d+IWzw6I+p2TXh2kd9VOVlSRM+aYqBhISAR0Jwt3EVP9HPOYXhXwRA+yQNLxY5m/Gn5VTu7kOuJdEsd4GxAcWtVXM6umpuH5upBh2vat02T42kmGmdTQgIDQYaiuDcev1JO9Bd7PRbhCo77sftztuy3vwhBcxaoLMGESHAEgcNpezjIwx8Tg0NesjztJOmXk6/GNBd7w8ge5TqTrfDfj6O6IerB1a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
vmemmap pages for huge pages and remapping the freed range to a single
page containing the struct page metadata.

With the new mask-based compound_info encoding (for power-of-2 struct
page sizes), all tail pages of the same order are now identical
regardless of which compound page they belong to. This means the tail
pages can be truly shared without fake heads.

Allocate a single page of initialized tail struct pages per NUMA node
per order in the vmemmap_tails[] array in pglist_data. All huge pages
of that order on the node share this tail page, mapped read-only into
their vmemmap. The head page remains unique per huge page.

This eliminates fake heads while maintaining the same memory savings,
and simplifies compound_head() by removing fake head detection.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/mmzone.h | 16 ++++++++++++++-
 mm/hugetlb_vmemmap.c   | 44 ++++++++++++++++++++++++++++++++++++++++--
 mm/sparse-vmemmap.c    | 44 ++++++++++++++++++++++++++++++++++--------
 3 files changed, 93 insertions(+), 11 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 322ed4c42cfc..2ee3eb610291 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -82,7 +82,11 @@
  * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
  * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
  */
-#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
+#ifdef CONFIG_64BIT
+#define MAX_FOLIO_ORDER		(34 - PAGE_SHIFT)
+#else
+#define MAX_FOLIO_ORDER		(30 - PAGE_SHIFT)
+#endif
 #else
 /*
  * Without hugetlb, gigantic folios that are bigger than a single PUD are
@@ -1408,6 +1412,13 @@ struct memory_failure_stats {
 };
 #endif
 
+/*
+ * vmemmap optimization (like HVO) is only possible for page orders that fill
+ * two or more pages with struct pages.
+ */
+#define VMEMMAP_TAIL_MIN_ORDER (ilog2(2 * PAGE_SIZE / sizeof(struct page)))
+#define NR_VMEMMAP_TAILS (MAX_FOLIO_ORDER - VMEMMAP_TAIL_MIN_ORDER + 1)
+
 /*
  * On NUMA machines, each NUMA node would have a pg_data_t to describe
  * it's memory layout. On UMA machines there is a single pglist_data which
@@ -1556,6 +1567,9 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	unsigned long vmemmap_tails[NR_VMEMMAP_TAILS];
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 2b19c2205091..cbdca4684db1 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -18,6 +18,7 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
+#include "internal.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -517,6 +518,41 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 	return true;
 }
 
+static struct page *vmemmap_get_tail(unsigned int order, int node)
+{
+	unsigned long pfn;
+	unsigned int idx;
+	struct page *tail, *p;
+
+	idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	pfn =  NODE_DATA(node)->vmemmap_tails[idx];
+	if (pfn)
+		return pfn_to_page(pfn);
+
+	tail = alloc_pages_node(node, GFP_KERNEL, 0);
+	if (!tail)
+		return NULL;
+
+	p = page_to_virt(tail);
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		prep_compound_tail(p + i, NULL, order);
+
+	spin_lock(&hugetlb_lock);
+	if (!NODE_DATA(node)->vmemmap_tails[idx]) {
+		pfn = PHYS_PFN(virt_to_phys(p));
+		NODE_DATA(node)->vmemmap_tails[idx] = pfn;
+		tail = NULL;
+	} else {
+		pfn = NODE_DATA(node)->vmemmap_tails[idx];
+	}
+	spin_unlock(&hugetlb_lock);
+
+	if (tail)
+		__free_page(tail);
+
+	return pfn_to_page(pfn);
+}
+
 static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    struct folio *folio,
 					    struct list_head *vmemmap_pages,
@@ -532,6 +568,12 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	if (!vmemmap_should_optimize_folio(h, folio))
 		return ret;
 
+	nid = folio_nid(folio);
+
+	vmemmap_tail = vmemmap_get_tail(h->order, nid);
+	if (!vmemmap_tail)
+		return -ENOMEM;
+
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
 	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
@@ -549,7 +591,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
-	nid = folio_nid(folio);
 	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
 
 	if (!vmemmap_head) {
@@ -561,7 +602,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	list_add(&vmemmap_head->lru, vmemmap_pages);
 	memmap_pages_add(1);
 
-	vmemmap_tail	= vmemmap_head;
 	vmemmap_start	= (unsigned long)folio;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index dbd8daccade2..94b4e90fa00f 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -378,16 +378,45 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
 	}
 }
 
-/*
- * Populate vmemmap pages HVO-style. The first page contains the head
- * page and needed tail pages, the other ones are mirrors of the first
- * page.
- */
+static __meminit unsigned long vmemmap_get_tail(unsigned int order, int node)
+{
+	unsigned long pfn;
+	unsigned int idx;
+	struct page *p;
+
+	BUG_ON(order < VMEMMAP_TAIL_MIN_ORDER);
+	BUG_ON(order > MAX_FOLIO_ORDER);
+
+	idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	pfn =  NODE_DATA(node)->vmemmap_tails[idx];
+	if (pfn)
+		return pfn;
+
+	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+	if (!p)
+		return 0;
+
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		prep_compound_tail(p + i, NULL, order);
+
+	pfn = PHYS_PFN(virt_to_phys(p));
+	NODE_DATA(node)->vmemmap_tails[idx] = pfn;
+
+	return pfn;
+}
+
 int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 				       int node, unsigned long headsize)
 {
+	unsigned long maddr, len, tail_pfn;
+	unsigned int order;
 	pte_t *pte;
-	unsigned long maddr;
+
+	len = end - addr;
+	order = ilog2(len * sizeof(struct page) / PAGE_SIZE);
+	tail_pfn = vmemmap_get_tail(order, node);
+	if (!tail_pfn)
+		return -ENOMEM;
 
 	for (maddr = addr; maddr < addr + headsize; maddr += PAGE_SIZE) {
 		pte = vmemmap_populate_address(maddr, node, NULL, -1, 0);
@@ -398,8 +427,7 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 	/*
 	 * Reuse the last page struct page mapped above for the rest.
 	 */
-	return vmemmap_populate_range(maddr, end, node, NULL,
-					pte_pfn(ptep_get(pte)), 0);
+	return vmemmap_populate_range(maddr, end, node, NULL, tail_pfn, 0);
 }
 
 void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
-- 
2.51.2


