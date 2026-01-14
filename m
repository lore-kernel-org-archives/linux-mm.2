Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D532D3900E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106666B008A; Wed, 14 Jan 2026 14:22:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6F16B009B; Wed, 14 Jan 2026 14:22:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F360D6B009D; Wed, 14 Jan 2026 14:22:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFEDB6B008A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:22:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A88EC1B9C0
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:22:04 +0000 (UTC)
X-FDA: 84331539768.04.7A115E6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf03.hostedemail.com (Postfix) with ESMTP id 78FBE20011
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:22:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HOe6IuvH;
	spf=pass (imf03.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768418522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3sUcrQkkPphRmmOO7LZofEu9NUMlWjnTig9U84JFdk=;
	b=QmQ8FMtxbYzifEZ/0PzPTsh9L8FqLeJGken6fee6OakXfQz9Tl/9nbQ6tOpd+fdruuQpR9
	2e+GlF7R7sK6kLMEH/Qe3TFHVP/8i9ej6jtzmDghTvPDadeu94pdb1eTkGA3SNGNbxZy5R
	B4KyjJ/IiORqKItVOJgjMzNLO/ybuts=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HOe6IuvH;
	spf=pass (imf03.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768418522; a=rsa-sha256;
	cv=none;
	b=0wvu8eDc9c8W6W4ibypEKlD4eucERxMBYOllm2ff1KnSB+OHdChA/TzGwYHXS3G18eOqN3
	ilPq/5CpLZljJy2fgB9xyjg0xm94TgmYdkQCBVX6IZwiEDRJHn86gejWkcZDo+hs75lVtq
	4kQguU90GY/iqV1b3EjitVeaFbvHXU0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768418522; x=1799954522;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=klqgvILMBV8YvYjouVal5kpqMrYS1cOW9frG4fw/18s=;
  b=HOe6IuvHLfSx9sqsaYe+3ZARJWOqYCE/QSAgHwl+gHkcetrNWkS4j4d8
   30BqwUFtj8ITTGEl8yY+UJDSw57DL8EduuSakQakipmvw6wEr3C/C8vZA
   RYcOw/QQo0wpwRV5vyqLW2cp37um/v5u0oBNjBiJsU6fH+vE/qA+nymQt
   LbD53x4vGMd0LSVHe/otUlv6h6B0jwcgc6MFNq0aS7wctVD0R4tj+fwgI
   +GcZoEekTh//MMXPH4xwpY3wRal79ERt1EfHsxnSALQyDA5aahaSVKTPu
   cm/v207Pli8tLaBxJUPgHRlmVGcoX4fCtdEaEpUz7jeG/VmNyuVyjGhSf
   g==;
X-CSE-ConnectionGUID: IEcFOO//SXWTAXlqXMkbCA==
X-CSE-MsgGUID: uCU25DTaQt64d3oyJXhfVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="87305781"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="87305781"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 11:22:02 -0800
X-CSE-ConnectionGUID: bV7j2E4rQF6z4ci6vjXQZw==
X-CSE-MsgGUID: NXiBL6xATc+WvFLkbrJBPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="236006911"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fdugast-desk.intel.com) ([10.245.244.85])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 11:21:59 -0800
From: Francois Dugast <francois.dugast@intel.com>
To: intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org,
	Francois Dugast <francois.dugast@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Michal Mrozek <michal.mrozek@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org
Subject: [PATCH v5 5/5] drm/pagemap: Enable THP support for GPU memory migration
Date: Wed, 14 Jan 2026 20:19:56 +0100
Message-ID: <20260114192111.1267147-6-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260114192111.1267147-1-francois.dugast@intel.com>
References: <20260114192111.1267147-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dkm6jicdzsj3qdpxwd9o4zo5ic9ns986
X-Rspam-User: 
X-Rspamd-Queue-Id: 78FBE20011
X-Rspamd-Server: rspam08
X-HE-Tag: 1768418522-246393
X-HE-Meta: U2FsdGVkX1/AdZUeUgCB1Szu2r/erHnQ7LQpueOFW2KIp+Z/Ujb0mzKaq2WdYlsCL+q5VAPOQOQrOuKxCtXbrQyCE7zKP0TbEIQbHIN3C7K/tVWwrAzSsKFy2L6KdiT0muB6HRCpuZ1Az+byXj6JtWxRfT0MLTZyFgSgU1PzPg4tygImGxXptuVNU2AsdimYDt0d1eOyUC0dN3KIL0ofPmXcGTij88KcESOvLlo4QNzeuWHysCc9KOUB9d7oo06/7HbSnv/rTserDbNNbkXrzRP7AQa/wXqJBbwM02UAYVzBUw6PB7NaSrGFLz7P6yqmOmmas6E9ysvpLEFw3c2Dkno/sQf1aprawscFDecM2rtGBQnaCFjxFE2npll11bhYSHRSEelRsYzkijSPfFV2qZC0OiRNsUhrqUql9sNoOgUUcaRQIOE2EGj+VgnztzGMMBguyDaPGbwtgaCTxHkDMreffngpr8Xw6VIkCi2dCDpgBAxjwvQRwzgGTZQr80vQPfnD72fIX85VEAakYVaIZvOV26vmztvQvlw6+qK6LUNzeNahQGTpf/Ct08OC4AAO61ysCoMbiLHaURNb1UQPM7EaQQu7FnIyxILqzsrzDPGoios9NNfJgAKRrSj6+t+x8XPOiufF7ubqY51Lgr52WFc5nXm7uQM+XRM0B7egM05eg1uR837ODfSe8czsfvez4UULzlXg0liIqlo7toWvjUtdEfP3dn+CQw55n11QRw0Ex6/+HzGT9PdJpDq7vil5Fr7j7A/BwClfoBIAqeQXk+Kw4fc1lMbZy6C42mxH0rsTj3ZLTnSpcIJ3UsRfbI14lLT3MW3UJFkwORTw/AnotCWa8/UrarL5+E5cDUZvd1w5WQqv28R8584Ze4Gzd78PWWOJWTdNysZSOhRit+4dn+sIygT4nw6Fm9Xn+1N0+6kaVyj3U8Fi/R0fuwOdmO9p51zs80ZvWym7aIxP7MV
 nT2G/Xn9
 fjWJQJb9HCidkvCTN5YPDK2WaEI4UwwHwxWeJnhM/mqTFkO7voDEGbDEFC9ffVRTK2aSJi4fyxLv92+jrVfUYtePGk/4IeqYBOUlu/Rakhg5QdminDIIALcvsgnwYYCW9+7WfatexwZf2/7Qm7ZM0IpShQCLLfiCAfyjTBAb5pdal+22KKu0wHiKJDp1YKWxHFwiVqxfCZsqzMPAoYq6DK5C0MM+I/+i8wmWt3S5ujSG/Ku/SWkhaalh+lFi3V3m8r44zJktEs41CKXIP2zBNu1qln4tGW5N+gArUpU2C4FtKr8raI/eNCt/Wughx1uoOormqjIB4hWsGf7c+A8cm1fBfV4Bm0+MSgLseZYt/YaA2zVOgPm4944j/JAA3mPYRMw6q5nj4SmoxG98bpvXlsxjNDRTP1UYDCtf5E3AjgE5r0IZUuOI0/4Dl0ypVFrVrsKsmnnCQrJLVhlYN6GBQj5+C4i7U603GhHu9WqGm4xjf0kg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This enables support for Transparent Huge Pages (THP) for device pages by
using MIGRATE_VMA_SELECT_COMPOUND during migration. It removes the need to
split folios and loop multiple times over all pages to perform required
operations at page level. Instead, we rely on newly introduced support for
higher orders in drm_pagemap and folio-level API.

In Xe, this drastically improves performance when using SVM. The GT stats
below collected after a 2MB page fault show overall servicing is more than
7 times faster, and thanks to reduced CPU overhead the time spent on the
actual copy goes from 23% without THP to 80% with THP:

Without THP:

    svm_2M_pagefault_us: 966
    svm_2M_migrate_us: 942
    svm_2M_device_copy_us: 223
    svm_2M_get_pages_us: 9
    svm_2M_bind_us: 10

With THP:

    svm_2M_pagefault_us: 132
    svm_2M_migrate_us: 128
    svm_2M_device_copy_us: 106
    svm_2M_get_pages_us: 1
    svm_2M_bind_us: 2

v2:
- Fix one occurrence of drm_pagemap_get_devmem_page() (Matthew Brost)

v3:
- Remove migrate_device_split_page() and folio_split_lock, instead rely on
  free_zone_device_folio() to split folios before freeing (Matthew Brost)
- Assert folio order is HPAGE_PMD_ORDER (Matthew Brost)
- Always use folio_set_zone_device_data() in split (Matthew Brost)

v4:
- Warn on compound device page, s/continue/goto next/ (Matthew Brost)

v5:
- Revert warn on compound device page
- s/zone_device_page_init()/zone_device_folio_init() (Matthew Brost)

Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Michal Mrozek <michal.mrozek@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
---
 drivers/gpu/drm/drm_pagemap.c | 73 ++++++++++++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 3fc466f04b13..e2aecd519f14 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -200,16 +200,19 @@ static void drm_pagemap_migration_unlock_put_pages(unsigned long npages,
 /**
  * drm_pagemap_get_devmem_page() - Get a reference to a device memory page
  * @page: Pointer to the page
+ * @order: Order
  * @zdd: Pointer to the GPU SVM zone device data
  *
  * This function associates the given page with the specified GPU SVM zone
  * device data and initializes it for zone device usage.
  */
 static void drm_pagemap_get_devmem_page(struct page *page,
+					unsigned int order,
 					struct drm_pagemap_zdd *zdd)
 {
-	page->zone_device_data = drm_pagemap_zdd_get(zdd);
-	zone_device_page_init(page, zdd->dpagemap->pagemap, 0);
+	zone_device_folio_init((struct folio *)page, zdd->dpagemap->pagemap,
+			       order);
+	folio_set_zone_device_data(page_folio(page), drm_pagemap_zdd_get(zdd));
 }
 
 /**
@@ -534,7 +537,8 @@ int drm_pagemap_migrate_to_devmem(struct drm_pagemap_devmem *devmem_allocation,
 		 * rare and only occur when the madvise attributes of memory are
 		 * changed or atomics are being used.
 		 */
-		.flags		= MIGRATE_VMA_SELECT_SYSTEM | MIGRATE_VMA_SELECT_DEVICE_COHERENT,
+		.flags		= MIGRATE_VMA_SELECT_SYSTEM | MIGRATE_VMA_SELECT_DEVICE_COHERENT |
+				  MIGRATE_VMA_SELECT_COMPOUND,
 	};
 	unsigned long i, npages = npages_in_range(start, end);
 	unsigned long own_pages = 0, migrated_pages = 0;
@@ -640,11 +644,13 @@ int drm_pagemap_migrate_to_devmem(struct drm_pagemap_devmem *devmem_allocation,
 
 	own_pages = 0;
 
-	for (i = 0; i < npages; ++i) {
+	for (i = 0; i < npages;) {
+		unsigned long j;
 		struct page *page = pfn_to_page(migrate.dst[i]);
 		struct page *src_page = migrate_pfn_to_page(migrate.src[i]);
-		cur.start = i;
+		unsigned int order = 0;
 
+		cur.start = i;
 		pages[i] = NULL;
 		if (src_page && is_device_private_page(src_page)) {
 			struct drm_pagemap_zdd *src_zdd =
@@ -654,7 +660,7 @@ int drm_pagemap_migrate_to_devmem(struct drm_pagemap_devmem *devmem_allocation,
 			    !mdetails->can_migrate_same_pagemap) {
 				migrate.dst[i] = 0;
 				own_pages++;
-				continue;
+				goto next;
 			}
 			if (mdetails->source_peer_migrates) {
 				cur.dpagemap = src_zdd->dpagemap;
@@ -670,7 +676,20 @@ int drm_pagemap_migrate_to_devmem(struct drm_pagemap_devmem *devmem_allocation,
 			pages[i] = page;
 		}
 		migrate.dst[i] = migrate_pfn(migrate.dst[i]);
-		drm_pagemap_get_devmem_page(page, zdd);
+
+		if (migrate.src[i] & MIGRATE_PFN_COMPOUND) {
+			drm_WARN_ONCE(dpagemap->drm, src_page &&
+				      folio_order(page_folio(src_page)) != HPAGE_PMD_ORDER,
+				      "Unexpected folio order\n");
+
+			order = HPAGE_PMD_ORDER;
+			migrate.dst[i] |= MIGRATE_PFN_COMPOUND;
+
+			for (j = 1; j < NR_PAGES(order) && i + j < npages; j++)
+				migrate.dst[i + j] = 0;
+		}
+
+		drm_pagemap_get_devmem_page(page, order, zdd);
 
 		/* If we switched the migrating drm_pagemap, migrate previous pages now */
 		err = drm_pagemap_migrate_range(devmem_allocation, migrate.src, migrate.dst,
@@ -680,7 +699,11 @@ int drm_pagemap_migrate_to_devmem(struct drm_pagemap_devmem *devmem_allocation,
 			npages = i + 1;
 			goto err_finalize;
 		}
+
+next:
+		i += NR_PAGES(order);
 	}
+
 	cur.start = npages;
 	cur.ops = NULL; /* Force migration */
 	err = drm_pagemap_migrate_range(devmem_allocation, migrate.src, migrate.dst,
@@ -789,6 +812,8 @@ static int drm_pagemap_migrate_populate_ram_pfn(struct vm_area_struct *vas,
 		page = folio_page(folio, 0);
 		mpfn[i] = migrate_pfn(page_to_pfn(page));
 
+		if (order)
+			mpfn[i] |= MIGRATE_PFN_COMPOUND;
 next:
 		if (page)
 			addr += page_size(page);
@@ -1044,8 +1069,15 @@ int drm_pagemap_evict_to_ram(struct drm_pagemap_devmem *devmem_allocation)
 	if (err)
 		goto err_finalize;
 
-	for (i = 0; i < npages; ++i)
+	for (i = 0; i < npages;) {
+		unsigned int order = 0;
+
 		pages[i] = migrate_pfn_to_page(src[i]);
+		if (pages[i])
+			order = folio_order(page_folio(pages[i]));
+
+		i += NR_PAGES(order);
+	}
 
 	err = ops->copy_to_ram(pages, pagemap_addr, npages, NULL);
 	if (err)
@@ -1098,7 +1130,8 @@ static int __drm_pagemap_migrate_to_ram(struct vm_area_struct *vas,
 		.vma		= vas,
 		.pgmap_owner	= page_pgmap(page)->owner,
 		.flags		= MIGRATE_VMA_SELECT_DEVICE_PRIVATE |
-		MIGRATE_VMA_SELECT_DEVICE_COHERENT,
+				  MIGRATE_VMA_SELECT_DEVICE_COHERENT |
+				  MIGRATE_VMA_SELECT_COMPOUND,
 		.fault_page	= page,
 	};
 	struct drm_pagemap_migrate_details mdetails = {};
@@ -1164,8 +1197,15 @@ static int __drm_pagemap_migrate_to_ram(struct vm_area_struct *vas,
 	if (err)
 		goto err_finalize;
 
-	for (i = 0; i < npages; ++i)
+	for (i = 0; i < npages;) {
+		unsigned int order = 0;
+
 		pages[i] = migrate_pfn_to_page(migrate.src[i]);
+		if (pages[i])
+			order = folio_order(page_folio(pages[i]));
+
+		i += NR_PAGES(order);
+	}
 
 	err = ops->copy_to_ram(pages, pagemap_addr, npages, NULL);
 	if (err)
@@ -1223,9 +1263,22 @@ static vm_fault_t drm_pagemap_migrate_to_ram(struct vm_fault *vmf)
 	return err ? VM_FAULT_SIGBUS : 0;
 }
 
+static void drm_pagemap_folio_split(struct folio *orig_folio, struct folio *new_folio)
+{
+	struct drm_pagemap_zdd *zdd;
+
+	if (!new_folio)
+		return;
+
+	new_folio->pgmap = orig_folio->pgmap;
+	zdd = folio_zone_device_data(orig_folio);
+	folio_set_zone_device_data(new_folio, drm_pagemap_zdd_get(zdd));
+}
+
 static const struct dev_pagemap_ops drm_pagemap_pagemap_ops = {
 	.folio_free = drm_pagemap_folio_free,
 	.migrate_to_ram = drm_pagemap_migrate_to_ram,
+	.folio_split = drm_pagemap_folio_split,
 };
 
 /**
-- 
2.43.0


