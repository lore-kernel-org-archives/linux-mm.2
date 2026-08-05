Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56BE9C55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 23:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74FCD6B0092; Wed,  5 Aug 2026 19:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7001B6B0093; Wed,  5 Aug 2026 19:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 616A76B0095; Wed,  5 Aug 2026 19:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 298056B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:10:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 82F661A02DA
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:10:57 +0000 (UTC)
X-FDA: 85068762954.07.EE23DDF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1DA4F10000D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:10:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fKTUVkdt;
	spf=pass (imf14.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785971455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXLnLLJYGaGXjoA55UebkVeF/hhI39l0HgKMhHSs1Nk=;
	b=WeuZcaKhaPDSpFtw3DivOz/8Z1NdfAyklBkJMEgRV+4id/TYBL1PROQEXH9yt9BoLB7NVy
	1S5hc3nGeT9pdPZBtfXq0OtI4VRuRz2vmP4BCu3M1livU4rjtoFBlgWv4M5HVhv3xHZXak
	HD3oGwghTNO4wKi4NS3IUBeU2mDnE1E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785971455;
	b=6n3yHjkOx8Pf3cblP6OTcvnfYDvwRbg2QFF7BThUFjTcf9rK+Bii7T3VhyLlwVLoD3beNB
	dLCqRFo9/U5KtFz/FXK+qOw41pYnRAX8qgnaRtaaqQBxy2pKNGzphi95+0nypdIvc4qCf9
	htaJKkSSOMXMk94Rip0z8TjKTdIvojk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fKTUVkdt;
	spf=pass (imf14.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785971455; x=1817507455;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7IwZ720KYefy5lGHWlIcMDNlKqXcJ+g12XviECt04CM=;
  b=fKTUVkdtx2C2FBQcXHnRyemWxId4YAovv7kOLyPivcfPib/Bj09HyHQB
   FbqerhdvRviaarwlfzO6FbiXP3371NFjLSYsYs/82tQLyHpx77GK4xW6z
   wOWVQQoCZK5VUNgSGWK5uurSLCxP9Ylbf0r2UE55NjzrgJD8CNHRR6IZ7
   LP8TMkiAeKzF64Mtamv7K0O2GGHDnI9Rt94waoigklla83n9gPJj/oqQd
   qYhe0CypYIYGMXW0mJJg+P5319L79jI5NhC74aq1eICpq1ZCpTPjlApMC
   o1Zx58TO6nXkUj64WRLvzJrlsCnAijrk8+YV43Xkb3ip/HlNWUZPg2U4d
   Q==;
X-CSE-ConnectionGUID: 8MNWl6qBQFaCfgd+TjAbHA==
X-CSE-MsgGUID: PiHpnt+WTA+JJ/+PSvZTIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="90376892"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="90376892"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 16:10:51 -0700
X-CSE-ConnectionGUID: TRftW6ygQaOc//3wYA5uIA==
X-CSE-MsgGUID: DCKgb19kSGe3y8k33VrtkA==
X-ExtLoop1: 1
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 16:10:51 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
	Francois Dugast <francois.dugast@intel.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 5/6] drm/pagemap: Fix folio allocation fallback and use-after-put
Date: Wed,  5 Aug 2026 16:10:40 -0700
Message-Id: <20260805231041.3791771-6-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260805231041.3791771-1-matthew.brost@intel.com>
References: <20260805231041.3791771-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1DA4F10000D
X-Stat-Signature: pk7eft9fb9qcdfd8egykuidxydikqcg4
X-Rspam-User: 
X-HE-Tag: 1785971454-682702
X-HE-Meta: U2FsdGVkX18m8WjTXFk/8+0mDviOubIp2Zji/tMr2cpT8OYqFTkUP7qr+tHskyC1FFXaMlAVYxdAmvr4BbwXeZNb2mG6XsQl+7MZ9DanYid3t2ZA7X90t0Fpr0154CZyjmWHJ8dnrA7OFhmKOA46aWCzVYdhsYopLWw7m3prQ/9zMH/uZysdEaqPx6pedt8y8C3mzhEhvW+THS4dT+lhqROTVB3+w8nh8HxgtBdRVAOvW3sybq3u7a+1kdfTbFfjTaUkC/u1LtH1piei4MiwoXKaOreWkcOmZcnst/t6HeSQUbY/ermbTGyNHbK7XpkI8gN8f67+NayIhYdnxESZOpSmHGJ+hinMrAgpBKTu0HACWDgiIAt6NL6jtyWhzNja6sNIFE1m9qSy/bwyIeTtKR4LxzS36kiIuEDQnlDliLwzDQZ1ezxDG3d3eCefGkOmbG/yBDC0TmkRil+jJWsflUD/P3gIY41LjKEJEt3xNIMOR76FQzQ/UT5djVoe4P/P0nsRs3oUcswRyr9gS2n27y7rhdXk0t+nQRtIS1fKW7k65eTymDRRqLEa3PLB7v/mBeZxmzLFWxh/EA1L0pNxWRMzilZr4z+EgdnH9Og5T5w3UyY3bw9BFj6VxiP1Wb00AmyJy+iuTml7Z5Buywu1vilcWsUxyVU0AfI/ivvj7iKpIdBdHWapu+q54i+JpcCW9YfuvuVP2n42hI8dEEbPcpUjcdSSwcO3kntpkZoQ29rdoyyBtvJ1sU987kONpEpYAHh05J+zvKHJOSkAci5n6++/uwEK+oYN+DDYIxezAnKL4FDzw3Z8afdERCXSPn2FmhmFg4hpaZPoflFB2thVoTxFGotlR+eCKiYZTZFkNnLiASdB4uc/VhnkQwiDOuHxmQC/GV9XM32NCmpA0y4a//L/a/UHR2VDzAjDmxEDcPrFiVaM6/F3jeMP7X0iu6ooMmdAZHribRwcDS5AYf3
 sMLhWeTV
 I7Plfl0XZ/0iS9s/PAGZNsZJeX0QnzICqezoXJ7GQyggYgAQbjEJt0zcMlwBnBEKasUdexdFF5+pWnaOQbSznz9bVnmhNwNOqA4XyL3h+vsPNwh2eIl7A2EdO94gc1EntNgblvmMtc5E42/uFPwHZfYtWju/2U+bghjZTc/UNFZxgJeh1fgkTR6dpKm/RO8wPqyt5tznjKmyjjmEeu/BWtGeA5we2dDyC+7sKAD1pUWsFj3J84PPyQul4XEiCH9SNtHpZTZDpchXjEQYUiw9TRmMB65sLP0GadPHFCD7bAu4DhkvCQhMwOFzPC/XtMm9+C+DmUMUroq434IDdDxa/gcp0JvGYw7xZaPwv/G3yMNPI7J3MUXr7/U3v817nQVBVsdt7gYIbYrk2uxugMlbyPmMcQm0hhteB28Fz+wx2twJVv9lcbirr22PyZsCRWIGEvRxK9PsbcVmYoyWvoRL+2bJzeg+tky56WcK0kQcOV8k1MWW7Ep1+IvcwrLI2H7Zf1lHYfWQQL5y/XRd7PE+ZKc/upkbihFRUdZx18T6xrtPEDAaK5gZulC2xvIt3Ult87LskG8WU9gRBa3/u8EQQ9nh0NiBeds57T9Z4zsa9Pn3r3H9i/RecHwdy/uZqkUsxsfklBZWedTaGLBC2jByyOYPYZ+CunbG113DpilzRIxJEhwFy6C+V1+tlcfBeAieBOlIv9ZifO8lMUFiBqkllS3tBx80fInyM30BBhhREfyraOga46Xg0dJLbKEwUyYcNPqeakKRllibEYbQ7KgUeKcx9HbG7Vg1oOBwxXUmjn3BrrtStKKyzSAJg1SsssXoYOnhHGcXxLLlT84h3yYa/X4sJh7m8pi1IPW5pPkkRu85q5sL9+Hjo6N1DAg4R9mazL7bCw8RMeCCFTLF6YA2celw69Dzw/Vrb8QS1
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
Assisted-by: GitHub_Copilot:claude-opus-5
Signed-off-by: Matthew Brost <matthew.brost@intel.com>

---
 v2: Add THP-mid-PMD invariant (Sashiko)
---
 drivers/gpu/drm/drm_pagemap.c | 128 +++++++++++++++++++++++++++-------
 1 file changed, 103 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index aef1fcea663d..51c6f12e4256 100644
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
@@ -891,11 +944,51 @@ static int drm_pagemap_migrate_populate_ram_pfn(struct vm_area_struct *vas,
 
 		order = folio_order(page_folio(src_page));
 
-		/* TODO: Support fallback to single pages if THP allocation fails */
+		/*
+		 * A large source folio is always collected whole, at its head
+		 * page, PMD aligned and flagged MIGRATE_PFN_COMPOUND: anything
+		 * else is split before it reaches us, either by
+		 * migrate_vma_collect_pmd() or, for the eviction path, by
+		 * migrate_device_pfns(). Both the order-0 fallback below and
+		 * drm_pagemap_migrate_populate_src_pages() rely on that, as
+		 * they index the folio from @i.
+		 */
+		WARN_ON_ONCE(order &&
+			     (src_page != folio_page(page_folio(src_page), 0) ||
+			      !(src_mpfn[i] & MIGRATE_PFN_COMPOUND)));
+
+		if (order)
+			gfp |= __GFP_NOWARN;
+
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
@@ -940,11 +1033,11 @@ static int drm_pagemap_migrate_populate_ram_pfn(struct vm_area_struct *vas,
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
@@ -1120,7 +1213,7 @@ int drm_pagemap_evict_to_ram(struct drm_pagemap_devmem *devmem_allocation)
 	unsigned long *src, *dst;
 	struct drm_pagemap_addr *pagemap_addr;
 	void *buf;
-	int i, err = 0;
+	int err = 0;
 	unsigned int retry_count = 2;
 
 	npages = devmem_allocation->size >> PAGE_SHIFT;
@@ -1160,15 +1253,7 @@ int drm_pagemap_evict_to_ram(struct drm_pagemap_devmem *devmem_allocation)
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
@@ -1235,7 +1320,7 @@ static int __drm_pagemap_migrate_to_ram(struct vm_area_struct *vas,
 	struct drm_pagemap_addr *pagemap_addr;
 	unsigned long start, end;
 	void *buf;
-	int i, err = 0;
+	int err = 0;
 
 	zdd = drm_pagemap_page_zone_device_data(page);
 	if (time_before64(get_jiffies_64(), zdd->devmem_allocation->timeslice_expiration))
@@ -1290,15 +1375,8 @@ static int __drm_pagemap_migrate_to_ram(struct vm_area_struct *vas,
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


