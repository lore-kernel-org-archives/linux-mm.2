Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9940D2502D
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 20:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20E546B0093; Sun, 11 Jan 2026 15:59:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC106B0095; Sun, 11 Jan 2026 15:59:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6E96B0096; Sun, 11 Jan 2026 15:59:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EBD3C6B0093
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 15:59:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8385A5E9DD
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:59:29 +0000 (UTC)
X-FDA: 84320898858.20.7AA4B2C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4BF79140006
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:59:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=C2cx6XEu;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768165167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5iQVo5fsut55OUT+JEEVpDr8Nk2P8clu36bv7MeIE1Y=;
	b=L2+oNEYqdOEPdDtEIVSH4NIu8Tm1A7Uo6KPVbxpUqGKzeSfg8LCEQP8WOFIcRERqYjCzQU
	+DKrCiDrMByKn5jrQtSUXIP8OYr7Enz7zPU8WzymYnNJZPrzhPvwqijMMVziKNdpzUUStD
	K09EiRDDFCD18EiOyZEvUYwOQTEgj0o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=C2cx6XEu;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768165167; a=rsa-sha256;
	cv=none;
	b=APru2b9xIipVo77xSd/EBVxAhCV20xOLEU3vCOc1v6sN5g6ru0qrLYKTD9cwgvJI5XbKIb
	w3dXJtx9QVEI/aGbWHQr8CkIZrwfkZ8UbA+GbNOJ5L4wNuvBol+a6v/Mp0Isna6Nj25W9+
	0ARgtPHDEFZkolzOC6HLKkYpHWyzbe0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768165168; x=1799701168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K7CaEXPX1Y90SZ4Qo51hMuLmWTYy4KmDbfKNdHZkWz0=;
  b=C2cx6XEuVkBgsJ1WVPnfRTZP3FG4hHXALGGdjaGvC6l1gPSSM/J6uaHz
   pIXYNDqARDJw13923MyAyUkN49rUJhubYXrZRP36Sv9AiZ5V1OU/fiw/c
   Y6mAkL3GHNQ+QzvyD5rQvVwYp6dEjCkpg3etFIw/T+2j0rmDyWX8tnnjx
   BAzn0Db56WxkxMAqBN3Qb/Qp4os3cDbZHiodSeisSRZjCLyFPz0KGEZar
   j8uDAR19GVAbiVn09CDYZK6WH6tek2uJInni/eQQ2aVJz4q9+CW7rnuPq
   LQwmHiOKW+J8Wkh8NAGZI6I1KWWjVtwORb25b0Zj65dyfjwlb277XmB3b
   Q==;
X-CSE-ConnectionGUID: FB2GaWaOQQOdIjkalfIT6Q==
X-CSE-MsgGUID: 9xO1IZA5RqCk9EGnUyvm4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="80904729"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="80904729"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 12:59:27 -0800
X-CSE-ConnectionGUID: TBj5hiKzRKO9UOCqgU5/JA==
X-CSE-MsgGUID: e9tGNLFfThio2sQzfZP3cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="208420013"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.245.11])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 12:59:23 -0800
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
Subject: [PATCH v4 5/7] drm/pagemap: Add helper to access zone_device_data
Date: Sun, 11 Jan 2026 21:55:44 +0100
Message-ID: <20260111205820.830410-6-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260111205820.830410-1-francois.dugast@intel.com>
References: <20260111205820.830410-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b79fqzb1ckhbnepy5hsqaboboc4j16ky
X-Rspamd-Queue-Id: 4BF79140006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768165167-772790
X-HE-Meta: U2FsdGVkX18UPFJ6bDWuRN8JdyXNZhfAz1hn3PONGGZ6N8nfzkgSr6k5U7BMRuDE3LoqRsWHnluVrsBO+TMy9MVYOwWHi/cvFmFR/TE2ZxgjbAGSuSxhn1uQOOnbPbaCLDqZT6mxSKddzJWYUa/GtztSIB7O6tiPIWEZFIGn2cUd0ORut3tkjYN4BIjkJTQvMZ4pBbHlcDE1UGl3560Fdk2XQw80YFGocUyP57K6mCsNcSbNsfwT0L9eFe0ACowduj6yPGbhbToSxkWCdOIPg0X6Gzbs5JdwiY+uaS1fqfFuGqFVtV5lCxszPqkRiQ1Jgl3Zgh/6LoXGhkX7hJCbPmuW+WmZzslb5OpJaATmglwsChWH4iOaI38HUYPDnwCtMc/xRGxj/jqP3Evcy4BGvOYL/JTb+k9Kav/4WTe3TN8v522Z1f/gVegnMFZV5ol9pvgtdmDgPWgDByUjQDn4yNs8VnQd1ovHgaYK+09OBiG2WZlnEu69cCIFK3bonJgV5y8X9TrzbsjLSCLKYBa1WkDRB6j8WHosUtsP4x+4TtUqZpYFTX224ERG3e+jR8syczia0PWUyc/ls9jtHG9ln9e29ALGaYtrfSbPXrYPadurQkTSKi4DlsLwiJVAejLLU0bbxKTsIhj9E42h5z9MfuSNKnTPqW41LpmN7m6WzvGCMeHqhZZFaGz7ra7f8i02n5oZ4CeBhmDEc16ye54PEYKMgk2aPtYgX76VYlCSKEble/GxHDqNKDBdVhRj0NpErF0tosvucTCe7TpDZ4QHuLXIkU8UqZp6/ID/w9ZAfH4lAPiJ3v4HNEEMhc99r4mg5cuDc/+iujiwskeRZddo/b8o7Ivga0ad7z8RTq9TkxyYKqYmgBo72u+4uJAqH9K3Gh5hYl6JNot1DLNhtOLgtcSk0/t/LvelTynJBDK2hDgqepZzGerK/CxPPzVJ9krl0ZddRBlQCrNWnqfCdx+
 ced4MIac
 lRH3pO56bDlEoQ0NTPWo7HGgxynfUxFMmioLt39as5H/QjWGvIjmI427J128wdR3SpfY34IA1CupKsxDi0qdtsfbgDikxqB/4/tDIoLDncdJnL80P/JvVVLj4uRgVpfOQzzbgy/nCVBOGgn2QlZu/I7UO1n/BmJsFo19E60wpHqnVXYO6KKL9Wp2Xpb62th6rcmofuwkj73WZdReTF0k81qSV2NYVHvLbtHsFNfXQZIoEIhLdBdAVT2yROoFXB8beOFJ1iW/o4KDL1jEeiOwiel3BVCiw1eGgPwgB9Q4us+ZqSGGwQpFPd0kmmFfDMluezWEfZtnaKtcszZqXMTfZ6kTnsdYIBZl34KzODZseCGz4HQWtKhhC7InGrvtoPKRUVmarxCKjQ57KD1p2HYQ8Fw7CJpL7HIfLn22jNj8ual6ITX1cQNoZl5zKEHqfcdUFuj1aKKK5qlY+RrMjqDNUGwsM+xGm7v4RqtkNZ2C/6lA4pU4xondWsPZfFA==
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
index bd9a4703fbce..308c14291eba 100644
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
 
@@ -1159,7 +1160,9 @@ static int __drm_pagemap_migrate_to_ram(struct vm_area_struct *vas,
  */
 static void drm_pagemap_folio_free(struct folio *folio, unsigned int order)
 {
-	drm_pagemap_zdd_put(folio->page.zone_device_data);
+	struct page *page = folio_page(folio, 0);
+
+	drm_pagemap_zdd_put(drm_pagemap_page_zone_device_data(page));
 }
 
 /**
@@ -1175,7 +1178,7 @@ static void drm_pagemap_folio_free(struct folio *folio, unsigned int order)
  */
 static vm_fault_t drm_pagemap_migrate_to_ram(struct vm_fault *vmf)
 {
-	struct drm_pagemap_zdd *zdd = vmf->page->zone_device_data;
+	struct drm_pagemap_zdd *zdd = drm_pagemap_page_zone_device_data(vmf->page);
 	int err;
 
 	err = __drm_pagemap_migrate_to_ram(vmf->vma,
@@ -1241,7 +1244,7 @@ EXPORT_SYMBOL_GPL(drm_pagemap_devmem_init);
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


