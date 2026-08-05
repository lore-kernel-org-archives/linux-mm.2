Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04E3DC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BC296B0096; Wed,  5 Aug 2026 07:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58F8A6B0099; Wed,  5 Aug 2026 07:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2CE6B0096; Wed,  5 Aug 2026 07:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE046B0096
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:33:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5D99140465
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:33:55 +0000 (UTC)
X-FDA: 85067006430.11.B669147
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf23.hostedemail.com (Postfix) with ESMTP id 64A9A140012
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:33:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aDntiiZG;
	spf=pass (imf23.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785929633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHLq3Va7wYJS4V6cEv14Mc1Sy/Tm/Z6gUaOVc9lSjFY=;
	b=228LUnpEnz5xmChGWsQhVfyhjC7bR9iEr51PzZgc+/SuSK+RPSgObiE5M7/qLcdskVIWMz
	sIZsb3j/ZhYkJ96o5O2BX2r7tqs+8u1p3vLcWmKQjphzc1SaLUbsRkNkYeiJICXQAxkSsn
	GnKUzN+6gEpxJJM9MWYMnGUflioyJx8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aDntiiZG;
	spf=pass (imf23.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785929633;
	b=vBY0Kj0UrHByDSi5p77B+c+FFjIzxpeYBHV39VauciI3ZhA4WS5b+0NUFcVZW93tQqAVSH
	A0h7jtTeUMrD2HC03xYQaeMmyx98JN2xTBxuPGL8ITpbYTkgr5a55SpHrHrR4GrIBB2vU/
	etn+b7uzUpuIGk+3NS26FACAbHM609U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785929634; x=1817465634;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1PZI3h2x2Ab0c8hVhz32upUrjeLKnaZ4yhcq7z0XhUo=;
  b=aDntiiZGTxcuM/3rEw5qVenEf1yfNFCvskxugB1CYsofkumNtOFy1ua+
   uJYbpU/5n7ZIISdc/9Ieyd3LUFKmBUp2wVliGZiMvoaOlc6RaQBqUon3O
   EMXFOKWjBS4m3jDYcvhiqd1FAtQlF0yX6plHiXMQ1gFBe9cop/l+2DEM5
   eQ57dR6RkQVZlVeyTu3RL5hq2b3etWpNTcgEfhg9wz0Zl7Z89v4hTYywA
   ROiWQDkDHySFRYPPRHx93/6a9Pg7xs855o/JwbdLrheOyIHobEDijgc4X
   5lWCL6szrpV1CJyuHzPH1xsnLCLG3QvkhVG5Z35TeBBBWfVTt4uCbLS8h
   A==;
X-CSE-ConnectionGUID: AN+HSGJWRlmjyRMg0dpqwg==
X-CSE-MsgGUID: BNw+qNuNRwOWH9fi+Y3GEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="86358201"
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="86358201"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 04:33:45 -0700
X-CSE-ConnectionGUID: O6nBJ1lDQK2RDwRKOtvgJQ==
X-CSE-MsgGUID: GK4wobLNTNuumrCiE9PkbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="265289750"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 04:33:45 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH 3/4] drm/pagemap: Fix folio allocation fallback and use-after-put
Date: Wed,  5 Aug 2026 04:33:37 -0700
Message-Id: <20260805113338.3742178-4-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260805113338.3742178-1-matthew.brost@intel.com>
References: <20260805113338.3742178-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4ju7w141razmtbmtwmkw4oaeuwtf86h9
X-Rspamd-Queue-Id: 64A9A140012
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785929633-722075
X-HE-Meta: U2FsdGVkX18cnr2lwqNACqecaC0esAWUoRAgb6H3+BLA49Q7XIEYQWL9CvApeD9fNrDeBk5FW7HWX9/7x6ZQ9MGLE+gVr+6mDLtuot/WinOs1L+mqNXjBTNcrEHA7aPO5keHuKsdBoGjYUjawER2Qs8Lb+VRNJfPTqMWMJ6oNoN8vUsJyPqSRpXXD+CWbfHrMRD5o1ovRdyhUrXmksMPwpIiM33KTx1vvDaPBzsMTELtXGjlpfJFxm2Oz5tFYDuAYF2rZRaMJ0eZ/J3MJXb3eZgG4nooVS4SA4F+RdEAEHdsUUg/hy5NPkkk/KW5HcFwFhSXkDe03nAXaO9Rxegcv6XbhoZDZdIe9Q/1sl5ShL2eUssuos+Qq1d0XmkNnH2vtUQVudDCsmPxhFXIR6lcFf2W9oKMXmWsGoq3S7hOYmmDGng3I4kGsKsQEsh/JmhxvQvDa/UTffuHm4VTHnISp24gGaplLSQcG5ncJ5Jl2jxsNTZ46Y8UGXh1C4q1LruCGXzx638OZBiRQcuL0eoOQLvmVLz5QjKXy0URDnYVVNiBHL98nk85fEgfUeIcO1Du1SHzsSWvfw2YKLOfAeDeIH44JGuvZFU/5rhR6UPhAc2gwHMXCN6P2CEpTWLk/cdMiX9GE/a2E8WpOihFrc4rWbeggKuS2lBmPkLHYe2Y7y+mJv3CMd1sqnuP1Aq8aKHAmqRF4I3+nUOCoPuTnKfsPznJVrqY7SxRikIO8vUUCSekrZO32qlwQK9z/k7zmPFkYWZs3w6NbWRcEvW7xK8LtEZqRxPoMiMi2jgJI/lHnbMNSNC4O5iCr27w2fjd+hDNZuFNnMdnMf7Kyu2CBwkZ3GXknbfpvK29cknjBzfuaHo/hUys/CUSlWlvAadjU8rHZy04ZrZMj1EWdy/PIxafEqr4TVCAwr6te7YNwMSkCBww8cCGWq3dMExlIcmhhn6yfg57JVRHP319oNO6w4c
 ez8XC9um
 LEOpyLl3AHUggcZQnSym7PnyhJ7f65w3KUmBEilFfih7wrF7Opa93RYfJ7Kn9YmMP77eiXpbADGIfjtgJ3JDk17IWp/Pn+G9z5nShmVSelyqxwvZ1VY4eW1co7T+ZNFx0Vd9PNvnLXdZSYTqFr60pudaIaOlE+8ssSoPj3A1kBIoyXrdpJMMX4OApv235U8q4vfKGyd+1QYq0feDROaxAAgBZZvt/SPRYBpoyxKacFW+Fr/jt2xm9BNn/ZMqnRX5q/LcflwaA8hfaFp/q8y6KNPKtlRELyTpYIRHPSD3GmNzeP56UAQKZVEKp2zsGG/v7C0HS00cU3OQGErMQ8rvkbLz674P82G7BolupWi7hgOF+yqxJGXm4z286SJvBfOi7aQFD3zRnx9ouciyecg2Bm6o3SEappIYwDaUFRuBQchrQWffzGJxe7Grw1utt9BYxW8Q+Bx4VjKn7EiGll1F+vawQLILxc/sQYRGOg+7nGegbF4v+w52dw3cJtdiBxP+CrLNpw7pmO9Qeppg2OGn3oR4SJq8uvelWSL7ZCIo9VwTAPD+9ohtHmMPifpx/sokiqm+LLE5MJbvyCEW5NWwCKO8kWB905YO/1pOa50FtnZ7Ry5sqUgwxmVPhMYjLpRleeNn1Zeuhtmj6oWtW9YQdpAwBb6EI8w7wu99MT4VxWWIn0kDzJ9MZfgHZPq6o8WN1vRsTmZRCPS3twGwSvtjPdhJnyKHJjTsjcZpGWpoBQfD08COlwRkt2e/zh5ZagHlnu1yoNYHtUYlh4UUkkQ9+8MC5xhC/lfPWq0Ct
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drm_pagemap_migrate_populate_ram_pfn() had two issues when populating
RAM PFNs with higher-order folios:

1. The higher-order vma_alloc_folio()/folio_alloc() calls did not pass
   __GFP_NOWARN, so a THP allocation failure under memory pressure
   would spam the kernel log, and there was no fallback path despite a
   TODO comment stating one was needed. Add __GFP_NOWARN to the
   higher-order allocation and, on failure, fall back to order-0
   allocations for the entire range originally covered by the failed
   higher-order allocation, leaving MIGRATE_PFN_COMPOUND unset for
   those PFNs.

2. In the free_pages error path, order was computed via
   folio_order(page_folio(page)) *after* put_page(page) had already
   dropped the reference, resulting in a use-after-free/put when that
   was the last reference on the page. Compute order before releasing
   the page.

Introducing the fallback in 1. also requires the source page array
handed to ->copy_to_ram() to be built differently. Both callers only
populated the entry at the head of each source folio, relying on the
copy callback to derive the rest of the folio from the order recorded
in the matching drm_pagemap_addr. Once the destination has been demoted
to order-0 folios the drm_pagemap_addr entries are per-page, so a source
page is needed for every one of them; leaving them NULL makes the copy
callback stop after the first page and the remainder of the range is
never copied.

The source folio is only split later, by migrate_vma_pages() /
migrate_device_pages(), so its order cannot be used to detect the
demotion - test the destination for MIGRATE_PFN_COMPOUND instead. Factor
the array population out into drm_pagemap_migrate_populate_src_pages()
and use it from both drm_pagemap_evict_to_ram() and
__drm_pagemap_migrate_to_ram().

Fixes: ddeda6136038 ("drm/pagemap: Allocate folios when possible")
Cc: stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Assisted-by: GitHub Copilot:claude-opus-5
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 drivers/gpu/drm/drm_pagemap.c | 114 ++++++++++++++++++++++++++--------
 1 file changed, 89 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 892b325fa99b..7610e233d238 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -383,6 +383,58 @@ drm_pagemap_migrate_map_system_pages(struct device *dev,
 	return 0;
 }
 
+/**
+ * drm_pagemap_migrate_populate_src_pages() - Populate the source page array
+ * @pages: Array of source pages to populate
+ * @src_mpfn: Source array of migrate PFNs
+ * @dst_mpfn: Destination array of migrate PFNs
+ * @npages: Number of pages in the arrays
+ *
+ * Populate @pages with the device pages the copy callback is to read from.
+ *
+ * Entries are normally only populated at the head of each source folio, with
+ * the copy callback deriving the rest of the folio from the order recorded in
+ * the corresponding drm_pagemap_addr. That does not work where
+ * drm_pagemap_migrate_populate_ram_pfn() had to demote a higher-order source
+ * folio to order-0 destination folios: the drm_pagemap_addr entries are then
+ * per-page, and the copy callback needs a source page for each of them.
+ * Populate every entry for those ranges.
+ *
+ * Note that the source folio itself is only split later, by
+ * migrate_vma_pages() / migrate_device_pages(), so its order cannot be used to
+ * detect the demotion - the destination has to be inspected instead.
+ */
+static void drm_pagemap_migrate_populate_src_pages(struct page **pages,
+						   unsigned long *src_mpfn,
+						   unsigned long *dst_mpfn,
+						   unsigned long npages)
+{
+	unsigned long i;
+
+	for (i = 0; i < npages;) {
+		struct page *page = migrate_pfn_to_page(src_mpfn[i]);
+		unsigned int order = 0;
+		unsigned long j, nr;
+
+		if (!page) {
+			i++;
+			continue;
+		}
+
+		order = folio_order(page_folio(page));
+		nr = NR_PAGES(order);
+
+		if (order && !(dst_mpfn[i] & MIGRATE_PFN_COMPOUND)) {
+			for (j = 0; j < nr && i + j < npages; j++)
+				pages[i + j] = folio_page(page_folio(page), j);
+		} else {
+			pages[i] = page;
+		}
+
+		i += nr;
+	}
+}
+
 /**
  * drm_pagemap_migrate_unmap_pages() - Unmap pages previously mapped for GPU SVM migration
  * @dev: The device for which the pages were mapped
@@ -875,6 +927,7 @@ static int drm_pagemap_migrate_populate_ram_pfn(struct vm_area_struct *vas,
 		struct page *page = NULL, *src_page;
 		struct folio *folio;
 		unsigned int order = 0;
+		gfp_t gfp = GFP_HIGHUSER;
 
 		if (!(src_mpfn[i] & MIGRATE_PFN_MIGRATE))
 			goto next;
@@ -890,12 +943,38 @@ static int drm_pagemap_migrate_populate_ram_pfn(struct vm_area_struct *vas,
 		}
 
 		order = folio_order(page_folio(src_page));
+		if (order)
+			gfp |= __GFP_NOWARN;
 
-		/* TODO: Support fallback to single pages if THP allocation fails */
 		if (vas)
-			folio = vma_alloc_folio(GFP_HIGHUSER, order, vas, addr);
+			folio = vma_alloc_folio(gfp, order, vas, addr);
 		else
-			folio = folio_alloc(GFP_HIGHUSER, order);
+			folio = folio_alloc(gfp, order);
+
+		if (!folio && order) {
+			/*
+			 * Higher-order allocation failed, fall back to
+			 * order-0 allocations for the entire range covered
+			 * by the original higher-order allocation, without
+			 * setting MIGRATE_PFN_COMPOUND, until we move past
+			 * that range.
+			 */
+			unsigned long nr = NR_PAGES(order);
+			unsigned long j;
+
+			gfp &= ~__GFP_NOWARN;
+			for (j = 0; j < nr && i < npages; j++, i++, addr += PAGE_SIZE) {
+				folio = vas ?
+					vma_alloc_folio(gfp, 0, vas, addr) :
+					folio_alloc(gfp, 0);
+				if (!folio)
+					goto free_pages;
+
+				page = folio_page(folio, 0);
+				mpfn[i] = migrate_pfn(page_to_pfn(page));
+			}
+			continue;
+		}
 
 		if (!folio)
 			goto free_pages;
@@ -940,11 +1019,11 @@ static int drm_pagemap_migrate_populate_ram_pfn(struct vm_area_struct *vas,
 		if (!page)
 			goto next_put;
 
+		order = folio_order(page_folio(page));
+
 		put_page(page);
 		mpfn[i] = 0;
 
-		order = folio_order(page_folio(page));
-
 next_put:
 		i += NR_PAGES(order);
 	}
@@ -1120,7 +1199,7 @@ int drm_pagemap_evict_to_ram(struct drm_pagemap_devmem *devmem_allocation)
 	unsigned long *src, *dst;
 	struct drm_pagemap_addr *pagemap_addr;
 	void *buf;
-	int i, err = 0;
+	int err = 0;
 	unsigned int retry_count = 2;
 
 	npages = devmem_allocation->size >> PAGE_SHIFT;
@@ -1160,15 +1239,7 @@ int drm_pagemap_evict_to_ram(struct drm_pagemap_devmem *devmem_allocation)
 	if (err)
 		goto err_finalize;
 
-	for (i = 0; i < npages;) {
-		unsigned int order = 0;
-
-		pages[i] = migrate_pfn_to_page(src[i]);
-		if (pages[i])
-			order = folio_order(page_folio(pages[i]));
-
-		i += NR_PAGES(order);
-	}
+	drm_pagemap_migrate_populate_src_pages(pages, src, dst, npages);
 
 	err = ops->copy_to_ram(pages, pagemap_addr, npages, NULL);
 	if (err)
@@ -1235,7 +1306,7 @@ static int __drm_pagemap_migrate_to_ram(struct vm_area_struct *vas,
 	struct drm_pagemap_addr *pagemap_addr;
 	unsigned long start, end;
 	void *buf;
-	int i, err = 0;
+	int err = 0;
 
 	zdd = drm_pagemap_page_zone_device_data(page);
 	if (time_before64(get_jiffies_64(), zdd->devmem_allocation->timeslice_expiration))
@@ -1290,15 +1361,8 @@ static int __drm_pagemap_migrate_to_ram(struct vm_area_struct *vas,
 	if (err)
 		goto err_finalize;
 
-	for (i = 0; i < npages;) {
-		unsigned int order = 0;
-
-		pages[i] = migrate_pfn_to_page(migrate.src[i]);
-		if (pages[i])
-			order = folio_order(page_folio(pages[i]));
-
-		i += NR_PAGES(order);
-	}
+	drm_pagemap_migrate_populate_src_pages(pages, migrate.src, migrate.dst,
+					       npages);
 
 	err = ops->copy_to_ram(pages, pagemap_addr, npages, NULL);
 	if (err)
-- 
2.34.1


