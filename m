Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B76EBD47CD0
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 11:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2927B6B008C; Fri, 16 Jan 2026 06:14:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25A8B6B0092; Fri, 16 Jan 2026 06:14:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1866C6B0093; Fri, 16 Jan 2026 06:14:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05D136B008C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:14:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6F11C22DB
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:14:17 +0000 (UTC)
X-FDA: 84337568154.28.437B394
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8E12B160005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:14:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yb0vyGR4;
	spf=pass (imf08.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768562055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ay5t/wfC50cbWZ6o9tYkWvjAyTZ9Cjpk2YYswrTglT0=;
	b=vqx3RcdQpSWcFhL+Fe8noH2J7NPN2GaJhBe1GqJRpMiRt8MNWd0Lb7T6szwpU+BbylSl2w
	Fqmze03v8ZHxj8fqXycl1pYFLfgyAN0EIQYo1YjRXBjsu+JQcyEYj5hqQrLpqFShxC/Rst
	XLcUxw3YRNPtTya20Sm2rGWohIA7Mgs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yb0vyGR4;
	spf=pass (imf08.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768562055; a=rsa-sha256;
	cv=none;
	b=58EOD+sw3MmptYVMsAYis1Gb6CdNFag4MCkoS7ZTOwrevwQ7orXL2uW1i+7qLBP6AsUdui
	a3uxs5lh7xNvrAeAoAhwNrKvhbPbCkWyhZCbgadnGOIE061VLP1cG/ShHJX5W8zLMt0+qT
	MCOD9WYczdD3i/kRtm1ciGC2u3mHe1c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768562056; x=1800098056;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0bXpiyD5D1p0BHaDpVOZ3vCIiWJnAz1jNbixl6MsiwI=;
  b=Yb0vyGR4wSnlvVW9M3HKEeBP42/kljrlCREkXDndsvTXhPvLpCH87d32
   SFHu8ibagIamoKWuKnYUHrAC1QKsx8Ok023sk6ULtxLw6ajiT5T7L/CHm
   S4IiSfjPYwL4RRDu0Jg4Fd58uM2tfqg+7a9I4PXMWVt+qV8sQlq1AOvdr
   5nCBt1FiTHknYDdKJr82HGW9+/A7IWLMoxkUb4PvHOt5XDo+CVcoXKXoB
   dKCjYlHKQz7p3HpesB9njYWwV55/Vd+g/u+JNRlEi1Waq9wkiapITd1Jv
   hf+IK5KErigGL5ovMquEEY7CphTuZ14NQWDK6byJ8te3OoD+xdcwfzdl/
   w==;
X-CSE-ConnectionGUID: Ryc+uHvJSzOaTEaMbf9t1g==
X-CSE-MsgGUID: MLTy0odTRU6jqF9yZGGI2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69930676"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="69930676"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:14:16 -0800
X-CSE-ConnectionGUID: kdoUG+RKTnydb50m5cMYlg==
X-CSE-MsgGUID: wZs93xzgRiaqMSgQu8kekA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="209713464"
Received: from fpallare-mobl4.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.245.100])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:14:12 -0800
From: Francois Dugast <francois.dugast@intel.com>
To: intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org,
	Francois Dugast <francois.dugast@intel.com>,
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
	linux-mm@kvack.org,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH v6 3/5] drm/pagemap: Add helper to access zone_device_data
Date: Fri, 16 Jan 2026 12:10:18 +0100
Message-ID: <20260116111325.1736137-4-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260116111325.1736137-1-francois.dugast@intel.com>
References: <20260116111325.1736137-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ww1mt968e7om76thfs5j5euryy8fr4q1
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E12B160005
X-Rspamd-Server: rspam08
X-HE-Tag: 1768562055-750676
X-HE-Meta: U2FsdGVkX197mPwv7A3FS52jOkUidfpHudmwAwG7rncPsdJCcXkTmpiVniTNjTfqxp1Uf5i88ddf0EDR+SFnsgyZKn4aQwYk1VLdHNWAzmAz+AYAz3vUk7AsbGP2+hlhwFIc/kNdrgFn6+/CyJdyUT5HgL2XY+pf90SDyhoqoWjnlAmehaTdnGZM8XDwxnQIgqtvAAZVIM/N0n/P7ZdPneqfF3t5sMj/HnxnXGDR/Rpzw1/6JKxSfxAxkEWnTQgFmAbfDLKNKioqx4vauWHLdse+wxYhbeCpQOERHw3TbzHJVXkVA1qPExNgsQDNgV/d4hyVOaV9ASAs+/nBnH2ezs24Sp2OS7JUSXsQbij1s3TnBcpIw0RtiJSmGXcBZ1Rba4OvZSs6rnxxd8J/ijwqKRMj/YCdASiEVJmIYq3UxYnpDebtpI4yKpdvl2ywSFz5jTeHAYE+j6QjyUykOwwCfvMb1s39MtaekLU4G8b8syCfoy+Xh9rnYzRfq12qdLffeCNgt9LpjKuYh9aFobcEGeg0KHVO52a+phf0peg1QktFbvUTVREPqskaBV/2L0LTPxYCatcKDSyjzu2e8D+8T/Kut2UEiujCfIJfTLGpaq2s8LEZw0LjmWBfbvVPyNgHVtyQctipwJm7ykEZ6rxfkw0rtMmHoH2FE21TPl04PepyEkLCaAoJulaM5QpayQ/lCOrLpigaqS/+NzCfSnUGw2OlVm/kXGAtn6IwXw4vRWhRplt+9kltYT+JBkZrr6XVIsqDVL0RftxkyCB65SNEBrB0nS2Wm3lsAXHuJYRw1du1mE282hwKJ8E/0OLs93OemtH6o1u83GMsAc1XeXpYEihEqoq2eImo80OwkKUgfh+T7KtYIwT2dtGY1yhPHy4mrr8643UEL3RTFPvVbXVU13qDIkodGXKj5cHSbdX6B8Zdl5OK3QXi96wtFlTamVZi3DdFEleDfb363vQDxPU
 mmfYUR9r
 Ufwj8QmK6xEVsJW8SUMgI0TwlHdfbROw48SQkoaKRnANYAcakWBXmcFP2VbPgq8TARCgp4pcYTNfgqSMlhnPTD7bSGzZ8gp/wQS9ulQndoqJnqc0Z29kHUoAOrtd8U9IV5cSso69TVTbOwfpogJHVtn3eZjNk8gJ+XPrpnNa86+A3VXstExSY2jiK/4QIBbHQHcDy1V47WQxXFf3sdxjaOwyPGZvGfk1X9j9DfBaL370KkvCg8FbZjqyulnj3ji3CMn/f8Hcc/6uEfpoEv3tuNylsGVRCDvwlqkvKN7wlb1KjN8xsy00cq8/S6fqdQh0TzG6li1UMpDo36nM1c7B9s9FXYxvIazhRQ0uhRbFGZHFQWNjTnwXwQPupBvH93aTiiOrwJHowxonQ3VCIcomRchB/BrWF1XV1Q/7h/Ws3fr0KK+brDWmmvkgwWowgv0XiOQ+pSl4FJmDwzeoEEHbspgIkNz+Qn7zHszi7jv2+Lb9t8bMv36YnTRNGEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This new helper helps ensure all accesses to zone_device_data use the
correct API whether the page is part of a folio or not.

v2:
- Move to drm_pagemap.h, stick to folio_zone_device_data (Matthew Brost)
- Return struct drm_pagemap_zdd * (Matthew Brost)

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
Suggested-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
---
 drivers/gpu/drm/drm_gpusvm.c  |  7 +++++--
 drivers/gpu/drm/drm_pagemap.c | 21 ++++++++++++---------
 include/drm/drm_pagemap.h     | 15 +++++++++++++++
 3 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index aa9a0b60e727..585d913d3d19 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -1488,12 +1488,15 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 		order = drm_gpusvm_hmm_pfn_to_order(pfns[i], i, npages);
 		if (is_device_private_page(page) ||
 		    is_device_coherent_page(page)) {
+			struct drm_pagemap_zdd *__zdd =
+				drm_pagemap_page_zone_device_data(page);
+
 			if (!ctx->allow_mixed &&
-			    zdd != page->zone_device_data && i > 0) {
+			    zdd != __zdd && i > 0) {
 				err = -EOPNOTSUPP;
 				goto err_unmap;
 			}
-			zdd = page->zone_device_data;
+			zdd = __zdd;
 			if (pagemap != page_pgmap(page)) {
 				if (i > 0) {
 					err = -EOPNOTSUPP;
diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 8e24a2c24729..61c6ca59df81 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -252,7 +252,7 @@ static int drm_pagemap_migrate_map_pages(struct device *dev,
 		order = folio_order(folio);
 
 		if (is_device_private_page(page)) {
-			struct drm_pagemap_zdd *zdd = page->zone_device_data;
+			struct drm_pagemap_zdd *zdd = drm_pagemap_page_zone_device_data(page);
 			struct drm_pagemap *dpagemap = zdd->dpagemap;
 			struct drm_pagemap_addr addr;
 
@@ -323,7 +323,7 @@ static void drm_pagemap_migrate_unmap_pages(struct device *dev,
 			goto next;
 
 		if (is_zone_device_page(page)) {
-			struct drm_pagemap_zdd *zdd = page->zone_device_data;
+			struct drm_pagemap_zdd *zdd = drm_pagemap_page_zone_device_data(page);
 			struct drm_pagemap *dpagemap = zdd->dpagemap;
 
 			dpagemap->ops->device_unmap(dpagemap, dev, pagemap_addr[i]);
@@ -611,7 +611,8 @@ int drm_pagemap_migrate_to_devmem(struct drm_pagemap_devmem *devmem_allocation,
 
 		pages[i] = NULL;
 		if (src_page && is_device_private_page(src_page)) {
-			struct drm_pagemap_zdd *src_zdd = src_page->zone_device_data;
+			struct drm_pagemap_zdd *src_zdd =
+				drm_pagemap_page_zone_device_data(src_page);
 
 			if (page_pgmap(src_page) == pagemap &&
 			    !mdetails->can_migrate_same_pagemap) {
@@ -733,8 +734,8 @@ static int drm_pagemap_migrate_populate_ram_pfn(struct vm_area_struct *vas,
 			goto next;
 
 		if (fault_page) {
-			if (src_page->zone_device_data !=
-			    fault_page->zone_device_data)
+			if (drm_pagemap_page_zone_device_data(src_page) !=
+			    drm_pagemap_page_zone_device_data(fault_page))
 				goto next;
 		}
 
@@ -1075,7 +1076,7 @@ static int __drm_pagemap_migrate_to_ram(struct vm_area_struct *vas,
 	void *buf;
 	int i, err = 0;
 
-	zdd = page->zone_device_data;
+	zdd = drm_pagemap_page_zone_device_data(page);
 	if (time_before64(get_jiffies_64(), zdd->devmem_allocation->timeslice_expiration))
 		return 0;
 
@@ -1158,7 +1159,9 @@ static int __drm_pagemap_migrate_to_ram(struct vm_area_struct *vas,
  */
 static void drm_pagemap_folio_free(struct folio *folio)
 {
-	drm_pagemap_zdd_put(folio->page.zone_device_data);
+	struct page *page = folio_page(folio, 0);
+
+	drm_pagemap_zdd_put(drm_pagemap_page_zone_device_data(page));
 }
 
 /**
@@ -1174,7 +1177,7 @@ static void drm_pagemap_folio_free(struct folio *folio)
  */
 static vm_fault_t drm_pagemap_migrate_to_ram(struct vm_fault *vmf)
 {
-	struct drm_pagemap_zdd *zdd = vmf->page->zone_device_data;
+	struct drm_pagemap_zdd *zdd = drm_pagemap_page_zone_device_data(vmf->page);
 	int err;
 
 	err = __drm_pagemap_migrate_to_ram(vmf->vma,
@@ -1240,7 +1243,7 @@ EXPORT_SYMBOL_GPL(drm_pagemap_devmem_init);
  */
 struct drm_pagemap *drm_pagemap_page_to_dpagemap(struct page *page)
 {
-	struct drm_pagemap_zdd *zdd = page->zone_device_data;
+	struct drm_pagemap_zdd *zdd = drm_pagemap_page_zone_device_data(page);
 
 	return zdd->devmem_allocation->dpagemap;
 }
diff --git a/include/drm/drm_pagemap.h b/include/drm/drm_pagemap.h
index 46e9c58f09e0..736fb6cb7b33 100644
--- a/include/drm/drm_pagemap.h
+++ b/include/drm/drm_pagemap.h
@@ -4,6 +4,7 @@
 
 #include <linux/dma-direction.h>
 #include <linux/hmm.h>
+#include <linux/memremap.h>
 #include <linux/types.h>
 
 #define NR_PAGES(order) (1U << (order))
@@ -359,4 +360,18 @@ int drm_pagemap_populate_mm(struct drm_pagemap *dpagemap,
 void drm_pagemap_destroy(struct drm_pagemap *dpagemap, bool is_atomic_or_reclaim);
 
 int drm_pagemap_reinit(struct drm_pagemap *dpagemap);
+
+/**
+ * drm_pagemap_page_zone_device_data() - Page to zone_device_data
+ * @page: Pointer to the page
+ *
+ * Return: Page's zone_device_data
+ */
+static inline struct drm_pagemap_zdd *drm_pagemap_page_zone_device_data(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	return folio_zone_device_data(folio);
+}
+
 #endif
-- 
2.43.0


