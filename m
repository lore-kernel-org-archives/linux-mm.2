Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0D4DD39010
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0026B6B0098; Wed, 14 Jan 2026 14:21:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05746B0099; Wed, 14 Jan 2026 14:21:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E11246B009B; Wed, 14 Jan 2026 14:21:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C81016B0098
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:21:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CF518C0F1
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:21:58 +0000 (UTC)
X-FDA: 84331539516.15.107721D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf03.hostedemail.com (Postfix) with ESMTP id 96B2E20007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:21:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Zdp8feIR;
	spf=pass (imf03.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768418515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Yrxsr3XY1C3c37bbsdcelQun0xE6j/9QPQdqYTAP1o=;
	b=DXtKg9rKJn6VY5T8T1YpRFBXlUGetxUwkuTIIlKDQD71vp4GoWmVlLAYxXAU+31rAnpbjM
	AM0KomMU1Ioy4P37YCL5WyMszLk/0oYfz555mlMPn0rwJ9I+qhtlDUYT8HsG7n3KoujHKx
	L+K0UymXqDn2XH/5hQVms9ck+nAWUOs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Zdp8feIR;
	spf=pass (imf03.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768418515; a=rsa-sha256;
	cv=none;
	b=eFjuW9Rase6opZbk9NYUhlfizPVZ+4SPPjnBYxSupRILhwkXyQQEPFJ0Akf0EAQRNeUdSk
	aJqCj8brze+tVIoxQHww6wXUjSxYNGf/8ME7TKyx3JCKeMFV0Wx7zridWIsfaLxWlAcGRS
	1TJ6kuLK8SZQH7ueSihDPeeD2e2+HwQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768418515; x=1799954515;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RzboktVU8jBzADz5dwPhtRw+aBxHtY4P+92EGbtCwtA=;
  b=Zdp8feIR46uAI1eHOF6unHIZuCSmqK/srPX8RDKDWoEVDSqJJ9TFU0aw
   D4nWo8KeUEB2W/sDBAMPARdW8SD9WPs4W27axBe1MpBR8CN/nNnHtEZDK
   kn4mlWNVJCIwvjXpMp4GfgsbkhwxZaytJmtiuDkWUoGI7TgH0YqbfY2JL
   8B6AqtUDIJ0KjALNfXSNR02TC5VggNTYoLXBtp0P4HrqhxhealzHeNSle
   /i6d9wgXoOYU5UoeUM2+OSJvXWRCAtsyFxDqr1OPENICGQzwrHNPxuSSd
   4pCOj/VBIToPZA2s4eNZ+xtbp3uFIiHzm8nBQVUvFVAmzYMBy4dexfk9Z
   w==;
X-CSE-ConnectionGUID: 1l356k60Sdm94cameM+mqg==
X-CSE-MsgGUID: WJCRtdueSkqPyI5Ajn6yjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="87305759"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="87305759"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 11:21:55 -0800
X-CSE-ConnectionGUID: 30PREGSWQ6+5qkryGG8EWw==
X-CSE-MsgGUID: YfJqD31zRreVMbYwJ1382A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="236006868"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fdugast-desk.intel.com) ([10.245.244.85])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 11:21:52 -0800
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
Subject: [PATCH v5 3/5] drm/pagemap: Add helper to access zone_device_data
Date: Wed, 14 Jan 2026 20:19:54 +0100
Message-ID: <20260114192111.1267147-4-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260114192111.1267147-1-francois.dugast@intel.com>
References: <20260114192111.1267147-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sfdeu3zynd6bpwmnstucnuuz67sm1ymi
X-Rspam-User: 
X-Rspamd-Queue-Id: 96B2E20007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768418515-879905
X-HE-Meta: U2FsdGVkX19wMKF6z4MPVMvMYPsgBBILvxaQ2eCHGZj1TU7zp/iQJ3vQnvKYSCPBAqlyUvWJbCkFnMfHTdFrjYKQdRDYOCLZ20SAFsVoMIq6EZMvJ0Kf6OsRGyCyXCAXgzC8Xm97l0Om4o3YBHm9lHR8C0WM0xO3JwVwkHiAcThgeyhbomLPB/bqHTcYqpiclh5YQEtOYHqsSbodnBI9jdmIAPAmpaBcDWP2ANtUV0nE9JJYx1wL9Ns9OVq7AEwfBloKokUYy1VZ4mljJraKuEjcx6NFexs3utSP0nf7Mo7h/46kkHa21Us+b3QRtaaT+PoO+UTG/n5gfoPqFEtzGO3yRg4F8FJK6nktLmbfzyFacZil608vUgBz8/ejLLaG4EgsM0zbRkY1sh0lU7G+c3F0qNc61e0njm3EhbT7JPU3A4iJs5ps3LEf/RRm1/QpPvrY9fl88iT3NRZiPZ6URQ9wgBePMRPadAXx1/w5IKIZ0uiTFW0kU/9IJm+aPbWyvv1SO5FkBq1FiCMKaIAw89lY/xm++rDA297v8FMiK6SZjA2g8K1PdM6RW/+hKCjrh+PrPWU5ZMK4qbQ87W2CBtQ0LqsprPiRwqGL8k+dHoE8oQJzn8CNIQO2ZXAnBq5JA2f4O8w0ME9yN4GxTLtEeygbTlskM91o333Mz/ex+lgSHZ2278xj0vgX9HbmKYxmcxfFZldfAY5FYOai2TPsTuRLrLOilVHStNzuWxc4066I2Z66raIqAcyk+FMNY53Dv1UEMMArJ4QcSfWrZgHB4BVnP+aL5uKuEFTblCNbneAiWZxqIp43E0TMTFsfe7aqL9vBNa4J2hAZK94Fauzkp0/my4y14gXow7W0wnCmZ4EMWWqmGVPL7IOjIRtGwumBT0fTfZZnajZ4dap74gDvKK3NcD9E7qepXN3M3WVxuJ9KpynO9mthl6gya6XpzCk5LxoMWvLMRXeztevNvUi
 A+9uRvcB
 HEySyBciaK/5LtbpH1EwX011a0VlSGDt4c6NqS9goRBpVP90lkQxbU04v3b41DTuHnM1W8ftsONL6twV8tXw/LK0tNVkIYNgnPcY27/4foBrj9faNuugbeMFQ0ZrC4VJrR4xbsnm4sw1YaDSMT+IqLsgh9U9+VbxwMRC9GeQ5o4alYaf1/YbVbMNI8n3umPgqZRh+eFsKGlmGduoovgWollOgEa2OhPLwp0xlFZ+l/DN0RHPPwoyQINSwyAbaX7WbA6b3647otmoMkqhhWywo6EBXQfLFruu19bnMF3mqdalH1bewfWBj1b1NTKMb0aQ2kYe02gfGOUm3zgqsFw0+jLJ3MqVrlhKsDozYjQVr/hBXW/YzBdgmJpzWIwnMVKgfGpgvjpigMvrHdwwvGN658N5hHzI7UBDNAds97/6fSdUypZ5bazVnxIAPLHLeIQy45R6+M6XRsDgpkvg/VDJFGidIRttKsz5AJvMJL6RkiYKEeoDo/PtFt2PVIw==
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
index b31090b8e97c..f613b4d48499 100644
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


