Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DACAED6D230
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:10:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14B46B0088; Thu, 18 Dec 2025 10:10:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B8F6B009D; Thu, 18 Dec 2025 10:10:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 885626B009F; Thu, 18 Dec 2025 10:10:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3B36B009D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:10:15 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C193C0260
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:15 +0000 (UTC)
X-FDA: 84232927590.05.EC03D08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 25F7A120006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hlYsuWjQ;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766070613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qOVs+a8TvhIvMl/nx3Q/sngc4L38xV9GqENXesoC8Oc=;
	b=Ep5eBhd6CpyBbRgB/t9CFdgIZSDteOoUwZgULABEaM9bVo88HKl4aDETwG4dtX58HOjE4v
	oJaXA/U5DBxm9K9Y1MhKFqbszMxfhamGz/ca/YS1+5kWpjS6d8lcVl1A9t1q8O+eSA+tUf
	alQH+Icg2EsPH3U0NnUCcEYlGvEAI2g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hlYsuWjQ;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766070613; a=rsa-sha256;
	cv=none;
	b=LHswmNVuivw7ZG4c92095SX1Ud3HRXp3tEAuYD292rhavUicTfsPJHUEHjYAIcYdT0/iuJ
	qOgs4213xw74D5P4fOwTsoGPtTv3YZx9JffSOgdL0aKRNnf2FYIlWOkElBDQ5YgpjR9GmD
	Ss0Hk3cQmi3/dxc9bfzvChmhlPpF11w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D08E42A76;
	Thu, 18 Dec 2025 15:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC17C116D0;
	Thu, 18 Dec 2025 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766070612;
	bh=TSdSWKSGTjJX3BfXX5DtxkhH6XDBorGJgKQrJKFha5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlYsuWjQ9gTp3i1zu8X8wXjPIeenFpI8MmVitaxT8tncRMWY0JxjKQtde/cXeKPP8
	 nsmNor6lnPCpf5nNSWSnWqKPR5aRpa2jj4wQ5pPi5N8c0ZNnEi+OPYmaSluK8SU65m
	 XHR4VtSf9AbRaSyJ5873nP3e39L/4dmAqvxkPC5CoZUMOdWzxVIXb/JU4FPOKjKvod
	 W0mZoHjeBT0GQTxeEDSEhaolnKuhOWYiWm+QTuZRBRcxjPSpwNgNVJWY6jYPYHhQhy
	 bReIzs1pDxHIS6bWGnlK+kVVtDg+uwLo7KQNIbLa6iwHIBTsmWLkQx+uXv2IJQydrX
	 0zPcRIMI5nIcA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id C8B1BF40078;
	Thu, 18 Dec 2025 10:10:10 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 18 Dec 2025 10:10:10 -0500
X-ME-Sender: <xms:UhlEaZ46_JOQvKPkgwLjVLfXtCmcXpsJijAq73vxKzKEvAr16qJ6-Q>
    <xme:UhlEaWIhbdE-Sv_G9z5sHrogrS08pDvowbWG93ZmbMCWFGhs0vegMf3FeYBQZ4SsF
    SYLx_PyaNpPTm2-YO1csoaMmTcVPIYpynxrV3iSG7EATW_eZmK5srI>
X-ME-Received: <xmr:UhlEaTQ3LBThRE931pKvvklTD7yMSfn4PEaGPGbaHToqZ4msGZX8D0hRmXiz6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegheejgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhudefjeehhfektdeuvdefveejffdvhfevtddugfduffejfeeikeelhedvtedvveen
    ucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhope
    hmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgt
    phhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvhgrug
    horhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:UhlEaZoQLskv2F2iYu7gNRpF0qlfwgjMHqhTWyQzKOTxpakceu8kWw>
    <xmx:UhlEaRa2yxjhu46bRMhaHamREtO9MvWlyVHqPFGYl1F45JWMH-TISg>
    <xmx:UhlEaUSan2DcdtiG3cvHOca-6hx7TGdGb90Ly7SxCf6wbLm2Wpq1-Q>
    <xmx:UhlEafetUcAMDd25PPIzzGCKBsl19nW89xETapPKth1xHnxxLm3Lkw>
    <xmx:UhlEaTnmOSqhYhzPeIDhYkIcQJK7AXTAJYtrS9WPBlJqeGsiO1pevK6k>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 10:10:10 -0500 (EST)
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
Subject: [PATCHv2 09/14] mm/hugetlb: Remove fake head pages
Date: Thu, 18 Dec 2025 15:09:40 +0000
Message-ID: <20251218150949.721480-10-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251218150949.721480-1-kas@kernel.org>
References: <20251218150949.721480-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25F7A120006
X-Stat-Signature: yjfzt5uhw5uiiewkpeecqaeir8zxdd8d
X-HE-Tag: 1766070612-409546
X-HE-Meta: U2FsdGVkX19F7dUdf2+n6r/tMsIV+iR1hxUAnQAnweoyjGPOLhA1o2NeCPEzs8bs4F/04bFhSTvp783CjkMp8by+19mdp38c7mpNkBpwOmjRm7hdu9+aGHBxyXSHFewLBQnLavhyAVHMjPf+t7CaFdQFTVz1pHcY/fFineVywj5X7XiNQ6CaJ/Ybutp5eGceBW844WlMvRWz8zgHivrRpX9PvWjj05EH77vBBmCq8ONAbZfVHCMjxnwo4sEqnIWCKCH0OwZsUyS/nJ7MAvNO8nCMrqq4THLzuY8Ma+gEDcCs2xmShJdbetxu/07f6W4g4Rpjy8ZA/tcNMKBf6POIS4XLArE2EXK5DpJj2kzIRsOmbO1AL20FQBEiZFhmRmrBf2uKF2duQF+whovNUdwR702Xwgi/YziT2mqrX4fDG172OPetwa7ERXUlgywUJ62uI99xVGS/3nP6uMYgP7NP40sNBprMd0IZJ2Zf8Zg8NgGgksVKeg2auKQVjHOSpL3IryRCrmneO3sGc/6DPJCmI5RxCxn2/wEFxNYvaRzBw3zTT/3EvEcoe+hFfKPbHUyARsHldCn2SIMCixA9vxJyvZqZ4nJ53sxwijIWp8JSu5YPNU/QEu48SW3zCiGOAv1L0DninJYjxZK/RqP4rgUNWtM0azykoc1JhvhCLt8mSeWa3LTbPgYX/99NBPKu6KMfLGQj4hfCC0VTuGZOC1Ux8bUtESWx5DqaVjIWYe5eyKvzlGk8xJxC5+wjo/hCb+4hl08k3R7OcI1KKkmv0BxUNxXZwbYmh9KBEsC1fJNIMJeBBl/BUCatteY8zvBMHZz9SCYyc+NMEHrwtJCULue8QsRzijNpo9akJshm4/y9qZr5StoTGDd0sfqDd57G7vl8nQqgJpk4g17Q5zHxu2XLwF85BuPOAcFKt31LeO/N1LrRuXOiFXSLhmbzjKsnU/xUoAOEzGWnAPh4E/ZXmze
 GPOiZE3k
 Lg0A5JsM2x0eAH9ewF0OUI21se+i8+m1MW3+fuMKTdtfPom964WOlSibAtYW8IwYsvB/QJI597YCNCpKbCn8CpOasL4jbOw5xqjPJvnuLEUCyaTEE6SFIFBJDGNxh5X2uu8JIACOn7PQkNA4mVDkiFfg4B7KkJGpnwrDtnD+RAt7M0XWN2Szqv8uJEASKQFzjWteDsQ72mRnAfEeoqmPS/3h8eWoqY1T55wjbHQ54yg+bwdUUTBL6ZZRsjRmJf5pHo4Yy
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
index 7e4f69b9d760..f33117618f50 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -81,7 +81,11 @@
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
@@ -1407,6 +1411,13 @@ struct memory_failure_stats {
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
@@ -1555,6 +1566,9 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	unsigned long vmemmap_tails[NR_VMEMMAP_TAILS];
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index d18e7475cf95..63d79ac80594 100644
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


