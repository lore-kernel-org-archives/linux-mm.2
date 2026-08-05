Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F268C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 19:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79A86B0096; Wed,  5 Aug 2026 15:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C02D46B0098; Wed,  5 Aug 2026 15:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2E226B0099; Wed,  5 Aug 2026 15:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58F8F6B0096
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:35:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1866C058A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:35:49 +0000 (UTC)
X-FDA: 85068220818.21.E8447C3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6836B40002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:35:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jEo1WYUp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785958547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/4BgkKb4z/Zyy0+oMLNfXZSZHc8qsKdv5QM7Hyx+X4s=;
	b=r/u4u1ApgNgvcOl+4nClK1H42zi7tv10wBLeKqpuQcM1VQ8J0epsd68+f40F06ZGVR6n2J
	ipBuDLPedMfFz9RzhwRPQA/wHFUhGhI+ZrZ57G3uqw96u+tfFtM5+9kgKH14FoXB1/zg9o
	WbIDSO3af8ak33dgvEiTaPG0/186W9o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jEo1WYUp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785958547;
	b=G4a/m94ddnJgLFQJsj+WqvE/FZw/U96TO+OGnPaaeIxwHk+bB2wlTr/fIzBtoKNDT2KDgy
	cB3f/ZBWqHAartMNmpC8CvS1eYbdUGR7h0g1lvvDxux7zKtxCwtVDCYOabCFABLUBQ3DGD
	pxIa5U5WSbEJqmCghKtxyRBXYEYpQEY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785958547; x=1817494547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zZRj+b/NzvOD47gFxglRIPtyT0lDGG2KHr/65GQvaMk=;
  b=jEo1WYUpAsfc6YBLDTpUNcmF8jf4j1OystlzarfLsrueTtk19llUZz7G
   cMuVww98v8gcqTZoRCccSKWBdDrhthpACWRCW9htcwnHUve0oISaa+gM0
   w9F1uUlzKPf2VD1l7hlNAZFLWc+mwmQkKJplPAXx0j8GcfaudbhgqsPKT
   4dypT44NdaSYFD5xERGTCHK9Zx008+a0ULnmkkTqyfwxqYyBXcl+HCCn2
   3hs1/ekRHkb+W+22xqKD/TEysMZuNCA1iXKr/FmNdvY1RPVJezFTFPhUQ
   AjBPKX9dcuplTtBdg8uCHllJ6w7oxXv0QNO4tbGeaaIq7E8yPyhXlLaKV
   Q==;
X-CSE-ConnectionGUID: 4y+aExnTSCK1/fcl/98y0Q==
X-CSE-MsgGUID: /a68QzyrS76B4ubgm4UgMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="109332965"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="109332965"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 12:35:44 -0700
X-CSE-ConnectionGUID: 9lSYi9ToSZiwsdkFe3a+OQ==
X-CSE-MsgGUID: SAeRpc4fQWWc+k0u9sIZ1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="285263531"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 12:35:43 -0700
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
Subject: [PATCH v2 4/5] drm/pagemap: Fix folio allocation fallback and use-after-put
Date: Wed,  5 Aug 2026 12:35:35 -0700
Message-Id: <20260805193536.3756457-5-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260805193536.3756457-1-matthew.brost@intel.com>
References: <20260805193536.3756457-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6836B40002
X-Stat-Signature: gjjin177hma4t81y866u3bajxrzymjmu
X-Rspam-User: 
X-HE-Tag: 1785958547-153755
X-HE-Meta: U2FsdGVkX1+TGwtz+JLBjknHPIQG07L9Q6DXzz5rf5QNYBEkQf/fX9uwAcmu0HmC8zW7fXD6pugpB++dHFLeUIuT3oyZ0BKmftbBH1xY2KNARwVLK0frMAq47VAmpPtD2XolGcLJV8vLtyTNTX8AtkA7YdHc68f/tL0cIpeA3Vqrykr25vDAWq4GdZDJWO6XHcOFa8I4qgru+ZuWVyIdd5nrL5FsGvFYJCZWvpTFAfhIiwqHBhx8Cs7V8vNQKtnETRxTy1TO26Oq8rZuwEqV7txygRSdfFFMH6u7EXb0z1IJbnsuncqdX/iQveouypVQe7RSLvdCTLz2h1crbn2YFxMZ9jiIx6ijTwpRSMUSIh82UkdPCbs3BUBSNUmwxFRAAhiNHlketUCzwsf47oARylVDVt2Zy8MF7zlDo+bTTq+taknlUGn4DLsl8NDVQXfN4jj6OfxKMEXddrthCahMRj83BJVVZRlqBWs3H5GvBHKyCYEjCRkAnldbLAHPfR/O2jiqg8Hkf+BAxUo+eq2nv9wC7kzjLVvAcRZUE2UFYg6UZQrbGa7TX1vxZQ9tmOm92XM8dM/CH5hVFW2CxEn+iTXeeFImbaDAdjcCgwXRZp9Cqw/0NyYI2t7vdeua0TyRZvEmDloBW0fSI1p7cOfu1TfW6x8cunX5yPglkTmAmRHh1Ey/mg9GrDuj9Npi4b+IX0KE7n9rntvc3pa6f/c9FfByGckMjIDfhad6Xvm4P/9vfzU8vW9VvDO88xIjB9FId0aG9CmzaaSIVeGi4Oee/Yy8upoTGpYicBzv3AWCwIc/8XUFpfgLoOr1gEqPIv2ki4Q7+5MjUWWYL4rGPHUx9qhUcFBn/iLcg44xDRz22IgGpGjV7kvRve7XSzHfgMaV+0HJuMu+1vBkVjpzjYLFAxHoOhQWAQOSyLsrLOkvNIIG/FGR0qi5XRk5wqctVZs2receTMMkXdWo2E7+Kho
 U5EMxRw7
 fYOdnZ+EXn3olgnBdJll8mnqCr5a2mlm3BIeV60oTOeFYvOsaFZzNvG/PywByTOT/JVB5/muLVCTn9mDtEDbj79l46doMGVQIWJGApmfGgw7QlHqpsHkoFdYSyVMlR+mKXXzSdVkSP+99ic0C7wQp8lCeXjvEuPqFHxltKeefk1PQUyoEcGeCL/8ux62zGcQa0vJ7oiKb3Evn5fz+zXHRDG4nHi0MsY0rnQwgrj6oQrvHJdBllxyhdOJoOqQb0JFWC+gY5g6QM1HOo3sDxPFAVFUgU5BYUvX5Vqp4dZANmklrzKu97l79KSd4+WIUBmjKBjaoUZCdrEmRhf34eR1ZXVeJMDQqpSU2ICE5oWjlKa78b5yf3PIIAGQdoiQgtaFpCqFsPDID256c0zyaAc/+hb+mLremidS00u9OczqGE/D1O8SAxaqjMJJ1cqHp0r3LkOd8SZw0fCBk/han9oh9libUc+1/IovePyo6Ru9k1GpEYrXmYkn2vs9UIvVnoSw4ThBi0dYHLsYr2YAXZ9hTnF5qnSoSxsjZ5C+pKadph3DubOjJfsrX1rx73yfwPwSsKYvdzQHmeDkLPoHHIARGQJ5yfjncRMRcPHeemGRybWFZt379S1lsg1AVYpCF9DmqCiy69Cg//YhmRzZW5jKhQPPr+xPUkOlXoCisBXotA3wEfNkQFbsNp05Us7h6N0+LF3f9ZZSLatdBlzPMg6HBqWgXmd1tv0c5eS92D0T9TCRRVJRycV92Y6HdaLvjX5Zyq/ZwwOJKa85zE9sHs3fav62GtNFMJ8Lpxfu7
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
index 892b325fa99b..05eb7254028f 100644
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


