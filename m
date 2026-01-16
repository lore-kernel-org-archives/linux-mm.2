Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 169DCD48984
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 11:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82D3E6B0089; Fri, 16 Jan 2026 06:14:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801996B008A; Fri, 16 Jan 2026 06:14:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3386B008C; Fri, 16 Jan 2026 06:14:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60FFD6B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:14:10 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E1AA8C119
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:14:10 +0000 (UTC)
X-FDA: 84337567860.30.525EC00
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf08.hostedemail.com (Postfix) with ESMTP id 04DF2160003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:14:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="fa/uXQGc";
	spf=pass (imf08.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768562048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6W/APdM9Oyy0cV5UpBAmEvhWdE7mtiBYO3W/yS4SnI=;
	b=ZQQt/TKeeyE0yG3VEJFW4ii54iAYAyZWUnMJIivEEJFP6skhZbp7063ikHpO028uIngGNP
	HbnZcDshW2aqas0xA78YhCRoMPVpmh1961YGREwfn2PFJIQ2820DXe06/MbsJkX5B3je8X
	p8vG4HNIEGGmUfibessIC8ntMV33uOQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="fa/uXQGc";
	spf=pass (imf08.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768562048; a=rsa-sha256;
	cv=none;
	b=HsPp1h6hlZNklCmXOFW0a3cX68I+blEvrGdKd+s9vbkyKKkOScpfPtdIRFIb02KU2bex6a
	nxyxI1q7A1xWoRft/KoTb+m5EamxVKF0VqBaD2WQ+QCBQWLgF3d+yOOX7bqFCCr3f7tJE0
	XPmptDanWRgIfM/l08TfqYpFZ8cGoGA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768562049; x=1800098049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0SRLvn1v5u7eTbuUJ05A/prO4E/QbcRKaOudyYKH0FM=;
  b=fa/uXQGcEne9m1ivWU4ffNI5itQh9F6a4l0YyBK2JVEDccTXzRhJbfoy
   VlSI7luU2zk+TvK6wkKTh5QLDQtpTSzGhS8lV+eRDvQ9/0vBBxQk2WIHt
   Utr2DBl0fxJA3bxhtnpnoLZY74eTUaW/ZqzXWlNuCzKkaBYVpo1A6mq6q
   elvuCS30IMIauF6oi1GoNrEyMXcibbNura+21e5ThbSeCpdFg9+Xv6UQm
   8fY/rmXH+ycHqDWq9bO751X1GBSdaamM7qkOcJmWdT7IFrBPDzEXvY2M3
   N+6RV/E5uJ6qBzmJT8hgwktc+Lsm5iC3ngpNKDA4/NfTwGWBPQo6lC1Fz
   w==;
X-CSE-ConnectionGUID: Y51Y3HyaQaujH6brZsR51g==
X-CSE-MsgGUID: hhKWGGuDTY66D8O3t2/6ZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69930640"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="69930640"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:14:08 -0800
X-CSE-ConnectionGUID: EolNQg6USFuQBa0DkCMuow==
X-CSE-MsgGUID: If0ItoI+QHC6rHFKmUK5Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="209713435"
Received: from fpallare-mobl4.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.245.100])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:13:59 -0800
From: Francois Dugast <francois.dugast@intel.com>
To: intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Zi Yan <ziy@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	adhavan Srinivasan <maddy@linux.ibm.com>,
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
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device private folios
Date: Fri, 16 Jan 2026 12:10:16 +0100
Message-ID: <20260116111325.1736137-2-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260116111325.1736137-1-francois.dugast@intel.com>
References: <20260116111325.1736137-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ffostktwegts97ywukpi899epseeqapk
X-Rspam-User: 
X-Rspamd-Queue-Id: 04DF2160003
X-Rspamd-Server: rspam08
X-HE-Tag: 1768562047-704839
X-HE-Meta: U2FsdGVkX19eORGUQW4FA4fho6sJO/CG4PzUmKnWew8gW10ejsQiV6y2TChfIuMQYDKTOocz44SRgoZQDQodDuGm9d0Cf2phpJtHmRB9VzRnKav9oYAvz/5ictM78HD/oUj/4XMzDUgfnO7qN+0L1gLjOKiz3Wpm9LZ/LHFQ98A/dMRPd+dEGeRc6lTlOw7TxROvPVSa9vWVKw8KHrMEDG9v9YIROPA1SU6PWmU0st3V8QCRJlnhEDEmfsfPVtccdUBgxPTfr9jCHptfFlunhRflJ+I23+ujJmI6cpbsr3Fv6HmozT0X+sR/f5jDc4wzpB6iE12qgr+eycEHUDJkSWrmHaYxcce3IFV5YWEqmG5+VQUJiFpdU/K9sOLukAKR9r8rNyFP7iTEkg9vcrCd0L/Mo++Bz0xE3QZZsksm7aQazrHfAR6cT+LZLOJes0F6GnbAyZpUbVH0GAAmVoSfIwTAcP5V5fyc5xopDGBz7sNlhbaCzZliirFye8TViTTbJ+jqjZlnzsrgQ/6/EEs3N94Oxjh5ihPZpZSbGt/CunCnrQeGwPUbZmIipztGMVlp73RXHuxfVo6kiWxg3Xt2qsae+5sFRgINVQmiZ5PfbYofvV514w1xwLsiosQVCK99wrpMOkcKdfHtFgGtRRCzDH2nLNhlLj6gfqfL/BX8Ikj6uE6tNxP1JiUVDDA3KHRvCNrD1yB5qA7E1O6Rs4BzzB+91WR68985Rc2BGxyvrS0cyutmpBlI6xtBms6YEXmDsDD53gx186FJcSPjTV706OL6vHOvSaywS9tUvT8mdkZM3BaTXwM6BZl9D0hpZKoP77sPL46yxTpbCKFsGJwUb01BpSVwLkvjidZe6DOX1JIifu8/9HOmP08uXLt83FBghGfpWtAhvxyeqINNMGQOw2el+mTAbacJ8RCfNY1e2eMUCgChuhgaara4ozorwyFhjpVvf9FLN5c7OqGDSA6
 unw++kp9
 EQnWkfkA8jee49bBa3SZKcgevgBDASJWc8ydE0b9093i7oJKrmedNedbLlufL5W30OJgD0BE++qHgj2lYOpT72i8psPCcUdcCOoK++T9owOI07yjze3egwdqPZ/7YFj7IrmBHCR/maYwg5bZIsoBokT9W5haZu1/ZvLu0B6U/qqsNt0kcL+HBcZBCSvwqifdRtQ2XOI6YqPe4oz+vY+DKdE/0Aph7PT8qRzSEyJqyHhH9gacDeQpylpfTDk2qHX6JOdhyAL2VZnXkdNxfk98QmBicremYtAquyzAtoxs+yEA4L3ewOJz6ID4OGpjKgNZDay/VyEhkgbyhged3/bpbQlFRFQXI7vgFRCqQlxzNcRbYzplguDfKJ1Xik/unLdNYcUVOXm7h9BGiU2ayTRzzLU4tJ9xBEsGwjlL60LSmMFKNNd/EnTkQ2KuALy8+B5VQYr1H86u1fKzNQR4cCZFhZJXMFAmIBNTJ9NL1cvnWHPYUSJqNqLcBAy4EDFePb3AFUxPFhr2lZeVAwLR9S9NnbBcPj52L88zqKmNxXrpXeBUwDLtr6J3GvgnyYmad+MwPbFciqoM3F+fRCJ1hBWFx1TG1BE9dIq61UDO8wSnl+RZDs5wFy4ZRThEncPy7RRK0o3hftgLULs4mfJwmFOEyC1grPM8r7tIkGLATjq6Gox152AUiXB3gqNtXVGNgy1PHrH7EkmUdT5JCxnkc4JsanXbS4gOGbXAxlHSEG8Hn+YwW9wb11HKzC+F6WZk07oPBIi6v05LSOIgT0VKTD70QM5uK9I1c0SmJygL1fN41TOB9njA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

Reinitialize metadata for large zone device private folios in
zone_device_page_init prior to creating a higher-order zone device
private folio. This step is necessary when the folio’s order changes
dynamically between zone_device_page_init calls to avoid building a
corrupt folio. As part of the metadata reinitialization, the dev_pagemap
must be passed in from the caller because the pgmap stored in the folio
page may have been overwritten with a compound head.

Without this fix, individual pages could have invalid pgmap fields and
flags (with PG_locked being notably problematic) due to prior different
order allocations, which can, and will, result in kernel crashes.

Cc: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: adhavan Srinivasan <maddy@linux.ibm.com>
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
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: amd-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org
Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>

---

The latest revision updates the commit message to explain what is broken
prior to this patch and also restructures the patch so it applies, and
works, on both the 6.19 branches and drm-tip, the latter in which includes
patches for the next kernel release PR. Intel CI passes on both the 6.19
branches and drm-tip at point of the first patch in this series and the
last (drm-tip only given subsequent patches in the series require in
patches drm-tip but not present 6.19).
---
 arch/powerpc/kvm/book3s_hv_uvmem.c       |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  2 +-
 drivers/gpu/drm/drm_pagemap.c            |  2 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |  2 +-
 include/linux/memremap.h                 |  9 ++++--
 lib/test_hmm.c                           |  4 ++-
 mm/memremap.c                            | 35 +++++++++++++++++++++++-
 7 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index e5000bef90f2..7cf9310de0ec 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -723,7 +723,7 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
 
 	dpage = pfn_to_page(uvmem_pfn);
 	dpage->zone_device_data = pvt;
-	zone_device_page_init(dpage, 0);
+	zone_device_page_init(dpage, &kvmppc_uvmem_pgmap, 0);
 	return dpage;
 out_clear:
 	spin_lock(&kvmppc_uvmem_bitmap_lock);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index af53e796ea1b..6ada7b4af7c6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -217,7 +217,7 @@ svm_migrate_get_vram_page(struct svm_range *prange, unsigned long pfn)
 	page = pfn_to_page(pfn);
 	svm_range_bo_ref(prange->svm_bo);
 	page->zone_device_data = prange->svm_bo;
-	zone_device_page_init(page, 0);
+	zone_device_page_init(page, page_pgmap(page), 0);
 }
 
 static void
diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 03ee39a761a4..38eca94f01a1 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -201,7 +201,7 @@ static void drm_pagemap_get_devmem_page(struct page *page,
 					struct drm_pagemap_zdd *zdd)
 {
 	page->zone_device_data = drm_pagemap_zdd_get(zdd);
-	zone_device_page_init(page, 0);
+	zone_device_page_init(page, page_pgmap(page), 0);
 }
 
 /**
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index 58071652679d..3d8031296eed 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -425,7 +425,7 @@ nouveau_dmem_page_alloc_locked(struct nouveau_drm *drm, bool is_large)
 			order = ilog2(DMEM_CHUNK_NPAGES);
 	}
 
-	zone_device_folio_init(folio, order);
+	zone_device_folio_init(folio, page_pgmap(folio_page(folio, 0)), order);
 	return page;
 }
 
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 713ec0435b48..e3c2ccf872a8 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -224,7 +224,8 @@ static inline bool is_fsdax_page(const struct page *page)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-void zone_device_page_init(struct page *page, unsigned int order);
+void zone_device_page_init(struct page *page, struct dev_pagemap *pgmap,
+			   unsigned int order);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
@@ -234,9 +235,11 @@ bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long memremap_compat_align(void);
 
-static inline void zone_device_folio_init(struct folio *folio, unsigned int order)
+static inline void zone_device_folio_init(struct folio *folio,
+					  struct dev_pagemap *pgmap,
+					  unsigned int order)
 {
-	zone_device_page_init(&folio->page, order);
+	zone_device_page_init(&folio->page, pgmap, order);
 	if (order)
 		folio_set_large_rmappable(folio);
 }
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 8af169d3873a..455a6862ae50 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -662,7 +662,9 @@ static struct page *dmirror_devmem_alloc_page(struct dmirror *dmirror,
 			goto error;
 	}
 
-	zone_device_folio_init(page_folio(dpage), order);
+	zone_device_folio_init(page_folio(dpage),
+			       page_pgmap(folio_page(page_folio(dpage), 0)),
+			       order);
 	dpage->zone_device_data = rpage;
 	return dpage;
 
diff --git a/mm/memremap.c b/mm/memremap.c
index 63c6ab4fdf08..ac7be07e3361 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -477,10 +477,43 @@ void free_zone_device_folio(struct folio *folio)
 	}
 }
 
-void zone_device_page_init(struct page *page, unsigned int order)
+void zone_device_page_init(struct page *page, struct dev_pagemap *pgmap,
+			   unsigned int order)
 {
+	struct page *new_page = page;
+	unsigned int i;
+
 	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
 
+	for (i = 0; i < (1UL << order); ++i, ++new_page) {
+		struct folio *new_folio = (struct folio *)new_page;
+
+		/*
+		 * new_page could have been part of previous higher order folio
+		 * which encodes the order, in page + 1, in the flags bits. We
+		 * blindly clear bits which could have set my order field here,
+		 * including page head.
+		 */
+		new_page->flags.f &= ~0xffUL;	/* Clear possible order, page head */
+
+#ifdef NR_PAGES_IN_LARGE_FOLIO
+		/*
+		 * This pointer math looks odd, but new_page could have been
+		 * part of a previous higher order folio, which sets _nr_pages
+		 * in page + 1 (new_page). Therefore, we use pointer casting to
+		 * correctly locate the _nr_pages bits within new_page which
+		 * could have modified by previous higher order folio.
+		 */
+		((struct folio *)(new_page - 1))->_nr_pages = 0;
+#endif
+
+		new_folio->mapping = NULL;
+		new_folio->pgmap = pgmap;	/* Also clear compound head */
+		new_folio->share = 0;   /* fsdax only, unused for device private */
+		VM_WARN_ON_FOLIO(folio_ref_count(new_folio), new_folio);
+		VM_WARN_ON_FOLIO(!folio_is_zone_device(new_folio), new_folio);
+	}
+
 	/*
 	 * Drivers shouldn't be allocating pages after calling
 	 * memunmap_pages().
-- 
2.43.0


