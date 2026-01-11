Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30E69D25039
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 20:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7426B0089; Sun, 11 Jan 2026 15:59:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79F096B008A; Sun, 11 Jan 2026 15:59:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69DDA6B008C; Sun, 11 Jan 2026 15:59:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5947C6B0089
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 15:59:15 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFAA8BE90F
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:59:14 +0000 (UTC)
X-FDA: 84320898228.07.CFABB64
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id BA4DD140009
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:59:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WF8PsuxE;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768165153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dsOnrOPJk1h2sm33TCAr8bc8lh5O+rfxt+K7WPWfLyM=;
	b=YTM39hrkXMbk/kVg3GvDRWs9yzqHBgSP40ShFE/UvizFqfvsIZcAyGisXuaH7+e3OR0Xq1
	4+ARx+BxYo/qgbS+IZRitdqVVTSY2OIbzsEEwWsqRFzGUSPxbn0ju6K3Z0doTJCrEn+eVk
	5vk8aTVaqyDB9894SLB17bnVFO94Ekc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WF8PsuxE;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768165153; a=rsa-sha256;
	cv=none;
	b=0Gdch/qDQrmZPoQXMj7iVK8OoYo37kpiiO2tD+mtOmKTBl+qFK8bst3JqYsp4wy6EPmfVb
	dFZWKxYIxICg2rybY7mdn3hmxua9rrOZtfg9L8VPKogNEJnhNFT5iV8/5kPJ4IkF94i4G0
	uRfyvG4eYermCz8M3Xk4UX2avw06V28=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768165153; x=1799701153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s1T9vuao+kXccuTcOMDTHHq+bj2twItjHB4YXvJcFdM=;
  b=WF8PsuxEcNOiDc7vopemSQZoVwqqQbDQoh66Hnb7WLIJlh0LKPrwg3pQ
   wEXGD1LjfO5wzg8FRaWaXxZ4j1KevJeeUO/wVMuzxE98NOmDh/y6U6y+Z
   PPuGetfqNCq5vxExr836gHyMU91kIf24MCeki/WPYYukr/1gyF/EsXIai
   a90lnRVqhfYm1jVmLdNh60/ba0zz8q8xoOtDdij9+P9O8zGX2UnTA6iJE
   vbOGBKeSs3dpLokivohufAPstaybFPtpRqg2N8Gl1J7isaqaJHhNo/Cwk
   2BAcTGWjr7Q8/3phEgM4Y30QEN3dvystXuU7PbEioidLuTG7Yuz2xeYGv
   g==;
X-CSE-ConnectionGUID: VXgtWOR1RkSEPXVAHnzPBg==
X-CSE-MsgGUID: 6+EAjRpRRQipDydPipxLUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="80904671"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="80904671"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 12:59:12 -0800
X-CSE-ConnectionGUID: x5hfc93rT7yYrL+IWOJYbg==
X-CSE-MsgGUID: YcOO9Gc2RRmD+fYdz8alfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="208419956"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.245.11])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 12:59:04 -0800
From: Francois Dugast <francois.dugast@intel.com>
To: intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Zi Yan <ziy@nvidia.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alistair Popple <apopple@nvidia.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	linux-pci@vger.kernel.org,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH v4 1/7] mm/zone_device: Add order argument to folio_free callback
Date: Sun, 11 Jan 2026 21:55:40 +0100
Message-ID: <20260111205820.830410-2-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260111205820.830410-1-francois.dugast@intel.com>
References: <20260111205820.830410-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xd9iuj5ohpmpeyqg7bdbcypsqqoko3ee
X-Rspamd-Queue-Id: BA4DD140009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768165152-192978
X-HE-Meta: U2FsdGVkX1/vixR4MEN8DKUqIF4fNbig7GE6zY4QNZJnQZDcaYESXyp58ZPOfFYQu67PfsdxqNVnJRVqy+zWHhTvWOvQqFHKQMkLs+z1HMuphKVq5OluY12NYf4apRxovv7flJJGN4GdSKnchWYD0gDurYaJsM8Snk81BHzheOqLilZhXGwNrIk9gfhbGdg0vw5jodugijU+yX7zybk6aUV1+otFfdrHKzWPZh1pTnmqIPmQ8ZP0wKsVzoX9OZVIHGeXEGk5wLNmsdjx9Z1ZXfSfEClW/K1p39Hd8hTzLfGMiDafTy4NxV8KH52HMVx+TXErmZxLpGzOcjpWHr3XGZCkHJM19awf1Spz3Xm+SJvS9kVI65MqvMD+CoH1Wbl++vA3ByhmEX682cVxPWy6QXNDCCFsx0L/RERAkV3PPmBRV0OFeIAbTrFRCmLCWX+p+y/XMS4g4W0f0cwD436ODGJlqHp37nmrxoNx483jdWL4dlt4j5u7+A9TfSRpemDwssT8sbdxjrYlObsRLH7PIelVYL/xB7eL6E3rFHTx6PQsm8aKyHwuFUJLLsPj+E2julUbbLZNDLoOV+5N5HVOhEzYok4o7ZGT5rOGfugBYPt7l29lOw3mEb63WWY/NbhbzbbpyYEjLfhWtYbEu7G3KS/LDNd4v9qzKGpc4rwRbridHW1bOiu+nAhnE9NkHh6TkLSAmcJ41ZqpYq20Ne0u+WPFglKtlJCjF164y8yMvAn+V6yR9O9VxoPky9b/CFMjDr8ZBu3NEoe2HFcwCY81rIOXdlootCyr/E45KBNQhQCWLDwPWqdZ3tgqJbznZaNtHbRoGP6KGUzpl4l7kJbogYuQYncIlDhZKM2c9y3Hht64CM7bPF2aLKD3d93hwAnPHcXP1lUCzgtZ8ESXSI7arnUNh3gnmOD9kQ5hlo7imQjAdOc3Mqwa9ebdzn8rHXm0iaVfXW5QnigZnx04x1S
 c8twP4ND
 h5kCf9FmUNtrZVR+ObHJxqOLno5ZqecToJj2y2Aq/NLMTNN8WJThJlXIokvorncNa1P1QtJlur0tY9v8mLj3zg4H4jt44yYL+t5ueadeNzXXbSGv1eO7lKIL704ziU24yTmb4wYRRdOjJJh0kqSMdfjVcXzcZZZ27bPxP/PZadwUoeTo3dtKAG21nibiGvEI+9bOIs5zey5mDj4NWM6Z8Pmo5/iPRIBB/yHdz0aKHkGZWlKFYmlfzP9u3epX6D4ICbMuxpm8O4lXuun1I8pW6u9vRR87cWUPYxEMfp7A6TeE903NwsQJ41kw1AbKr0rJDATZXUfr8i4ZSDSklDrHPHgoc0s918JCAUF8O4Sdy0L/upRW/j9Qht246C/6MI+I6j9LSYDxDehsjPtp7z1eJmP7YLI6Iwe+nlPzxFvheIwEiU+5NExNyuQXB8ldTwRt6tDHR0Qe7kvxg65l1BzW/Zi2HLgrTWnPHqRg8aLnX0l0o3vR5grpxNoir9kk/MHYRb1UzHkNwf5VDR/xViJ5Ry7HXKqjUI1Zfg/Ab4EUEU06r4LM+ey1zZxNHhEQjwchrBDrbohaKQB/19Em/oHLxGJ/xNIwk4pFsurtmLB7+4iVBZl7P8LCEYYy4+Fu3b4IcQYlxVLRB0BMXRY6EczQgIZM7oeuHDGbFl97Kncvb6u4Kp59Pi83eww6uC7iXRSjWqKCOI/o8qFY7+Hbbx1lnGYAMguUCSXz50tnQiSUkeR1LSL2TLfuody9EywZyMwEDL7YMGkPV/cGP4IHw/GEU4v4+k75ijFGtTeJPjeLoJtVa2Ae9R16U2EoiDSdhSh0eNgYMBxOZU+G6ZTbOisqoLhbnqhihr0AxH8QPf90jXvPAg/I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

The core MM splits the folio before calling folio_free, restoring the
zone pages associated with the folio to an initialized state (e.g.,
non-compound, pgmap valid, etc...). The order argument represents the
folio’s order prior to the split which can be used driver side to know
how many pages are being freed.

Fixes: 3a5a06554566 ("mm/zone_device: rename page_free callback to folio_free")
Cc: Zi Yan <ziy@nvidia.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: amd-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: linux-pci@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c       | 2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 2 +-
 drivers/gpu/drm/drm_pagemap.c            | 3 ++-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   | 4 ++--
 drivers/pci/p2pdma.c                     | 2 +-
 include/linux/memremap.h                 | 7 ++++++-
 lib/test_hmm.c                           | 4 +---
 mm/memremap.c                            | 5 +++--
 8 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index e5000bef90f2..b58f34eec6e5 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -1014,7 +1014,7 @@ static vm_fault_t kvmppc_uvmem_migrate_to_ram(struct vm_fault *vmf)
  * to a normal PFN during H_SVM_PAGE_OUT.
  * Gets called with kvm->arch.uvmem_lock held.
  */
-static void kvmppc_uvmem_folio_free(struct folio *folio)
+static void kvmppc_uvmem_folio_free(struct folio *folio, unsigned int order)
 {
 	struct page *page = &folio->page;
 	unsigned long pfn = page_to_pfn(page) -
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index af53e796ea1b..a26e3c448e47 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -567,7 +567,7 @@ svm_migrate_ram_to_vram(struct svm_range *prange, uint32_t best_loc,
 	return r < 0 ? r : 0;
 }
 
-static void svm_migrate_folio_free(struct folio *folio)
+static void svm_migrate_folio_free(struct folio *folio, unsigned int order)
 {
 	struct page *page = &folio->page;
 	struct svm_range_bo *svm_bo = page->zone_device_data;
diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 03ee39a761a4..df253b13cf85 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -1144,11 +1144,12 @@ static int __drm_pagemap_migrate_to_ram(struct vm_area_struct *vas,
 /**
  * drm_pagemap_folio_free() - Put GPU SVM zone device data associated with a folio
  * @folio: Pointer to the folio
+ * @order: Order of the folio prior to being split by core MM
  *
  * This function is a callback used to put the GPU SVM zone device data
  * associated with a page when it is being released.
  */
-static void drm_pagemap_folio_free(struct folio *folio)
+static void drm_pagemap_folio_free(struct folio *folio, unsigned int order)
 {
 	drm_pagemap_zdd_put(folio->page.zone_device_data);
 }
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index 58071652679d..545f316fca14 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -115,14 +115,14 @@ unsigned long nouveau_dmem_page_addr(struct page *page)
 	return chunk->bo->offset + off;
 }
 
-static void nouveau_dmem_folio_free(struct folio *folio)
+static void nouveau_dmem_folio_free(struct folio *folio, unsigned int order)
 {
 	struct page *page = &folio->page;
 	struct nouveau_dmem_chunk *chunk = nouveau_page_to_chunk(page);
 	struct nouveau_dmem *dmem = chunk->drm->dmem;
 
 	spin_lock(&dmem->lock);
-	if (folio_order(folio)) {
+	if (order) {
 		page->zone_device_data = dmem->free_folios;
 		dmem->free_folios = folio;
 	} else {
diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 4a2fc7ab42c3..a6fa7610f8a8 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -200,7 +200,7 @@ static const struct attribute_group p2pmem_group = {
 	.name = "p2pmem",
 };
 
-static void p2pdma_folio_free(struct folio *folio)
+static void p2pdma_folio_free(struct folio *folio, unsigned int order)
 {
 	struct page *page = &folio->page;
 	struct pci_p2pdma_pagemap *pgmap = to_p2p_pgmap(page_pgmap(page));
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 713ec0435b48..97fcffeb1c1e 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -79,8 +79,13 @@ struct dev_pagemap_ops {
 	 * Called once the folio refcount reaches 0.  The reference count will be
 	 * reset to one by the core code after the method is called to prepare
 	 * for handing out the folio again.
+	 *
+	 * The core MM splits the folio before calling folio_free, restoring the
+	 * zone pages associated with the folio to an initialized state (e.g.,
+	 * non-compound, pgmap valid, etc...). The order argument represents the
+	 * folio’s order prior to the split.
 	 */
-	void (*folio_free)(struct folio *folio);
+	void (*folio_free)(struct folio *folio, unsigned int order);
 
 	/*
 	 * Used for private (un-addressable) device memory only.  Must migrate
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 8af169d3873a..e17c71d02a3a 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1580,13 +1580,11 @@ static const struct file_operations dmirror_fops = {
 	.owner		= THIS_MODULE,
 };
 
-static void dmirror_devmem_free(struct folio *folio)
+static void dmirror_devmem_free(struct folio *folio, unsigned int order)
 {
 	struct page *page = &folio->page;
 	struct page *rpage = BACKING_PAGE(page);
 	struct dmirror_device *mdevice;
-	struct folio *rfolio = page_folio(rpage);
-	unsigned int order = folio_order(rfolio);
 
 	if (rpage != page) {
 		if (order)
diff --git a/mm/memremap.c b/mm/memremap.c
index 63c6ab4fdf08..39dc4bd190d0 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -417,6 +417,7 @@ void free_zone_device_folio(struct folio *folio)
 {
 	struct dev_pagemap *pgmap = folio->pgmap;
 	unsigned long nr = folio_nr_pages(folio);
+	unsigned int order = folio_order(folio);
 	int i;
 
 	if (WARN_ON_ONCE(!pgmap))
@@ -453,7 +454,7 @@ void free_zone_device_folio(struct folio *folio)
 	case MEMORY_DEVICE_COHERENT:
 		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
 			break;
-		pgmap->ops->folio_free(folio);
+		pgmap->ops->folio_free(folio, order);
 		percpu_ref_put_many(&folio->pgmap->ref, nr);
 		break;
 
@@ -472,7 +473,7 @@ void free_zone_device_folio(struct folio *folio)
 	case MEMORY_DEVICE_PCI_P2PDMA:
 		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
 			break;
-		pgmap->ops->folio_free(folio);
+		pgmap->ops->folio_free(folio, order);
 		break;
 	}
 }
-- 
2.43.0


