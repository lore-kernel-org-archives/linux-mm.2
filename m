Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D89CD39014
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7236D6B0093; Wed, 14 Jan 2026 14:21:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD6D6B0095; Wed, 14 Jan 2026 14:21:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571AF6B0096; Wed, 14 Jan 2026 14:21:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44A916B0093
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:21:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8680A59A1B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:21:51 +0000 (UTC)
X-FDA: 84331539222.22.B0BCA6A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf03.hostedemail.com (Postfix) with ESMTP id 349992000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:21:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="YBrX/0SP";
	spf=pass (imf03.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768418509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZwiE/35ZsqgkWDcAHtCrU2hUyIiBiBdqk8v0OUngik=;
	b=SFEVCvOpSiE7mUwJFl9C0e6rLxFWQw4A/VI4xmObgoIBXMSxI1lSpj7U9AV5ZpGYGpUPSo
	Qg4yFIS20KAaawhEAGjG4VjG2PgOhPVA2F0onfnR/bTmlpYY1x2RggPZ+c2B2ENTFJe2V/
	O5b8jQFkJqjCmD9Du7p85k7c8zlMPGQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="YBrX/0SP";
	spf=pass (imf03.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768418509; a=rsa-sha256;
	cv=none;
	b=6TmIqFWSgxIsfDm6C3SToT1CV2gCOLyq63RGiE8AT5g/5GhCCWPxY7P0TOwCHvm4mRBHN7
	i2brOTxV8dc6QSwrw6c1IAlQ0pKi2OzoeedUt7Lw1ws6ONvicePnKMEn0GFqyd5uwArLbY
	+SAKoLEWx6MSxqT0ifyjbAxNmn9KsVg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768418509; x=1799954509;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jiGWK05xuN192DYv+TPcEdDntEMizLdbArhfYH/lgMA=;
  b=YBrX/0SP+QXYj4nR7EfYqJFq6vd3UkkW/UrZL26jZgqO+/0P00ASZxyj
   70GBX+OQugynBvIb4OYzfcjBbjCLT96/YlxEKd37JnGuc5Tdj6GH1A/vp
   8HTV1WhAFwBwkzioHpak3aeJtqafdQiKxNdV18SUe/nNiSMvhFKJ0feKB
   wkWVGsx6FRq5CwZWrsjVQnkLgG6gt6w4RDvSNSz7z+9INluwaL8Li3Zk2
   KcD4z8fdnHWeY9K90L9TlbYkaWyiunUQed5y+nesKIx+xkiBIcTMLpnPF
   6wjZt7AtZB+VRa+SgnG17AUGMw/bHYyejvrLM7145Hv5mnCwsDT83fojW
   A==;
X-CSE-ConnectionGUID: c8iqtz/wRuGmTLKuQ8wn9w==
X-CSE-MsgGUID: 6eX7JXzqQAusXzSw9ceF7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="87305729"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="87305729"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 11:21:48 -0800
X-CSE-ConnectionGUID: UrOFw46sSR+Opbvpw2+jpw==
X-CSE-MsgGUID: /21BpcAaQ6GbBGCCIQN2Ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="236006831"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fdugast-desk.intel.com) ([10.245.244.85])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 11:21:42 -0800
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
Subject: [PATCH v5 1/5] mm/zone_device: Reinitialize large zone device private folios
Date: Wed, 14 Jan 2026 20:19:52 +0100
Message-ID: <20260114192111.1267147-2-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260114192111.1267147-1-francois.dugast@intel.com>
References: <20260114192111.1267147-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xesx6bbxuytj161cpj357uxofc31iocw
X-Rspam-User: 
X-Rspamd-Queue-Id: 349992000D
X-Rspamd-Server: rspam08
X-HE-Tag: 1768418509-775613
X-HE-Meta: U2FsdGVkX1+3r223qaFEVcVNclJyMa1jg+eeZzAP4wu8dEVjYGql4z6VbWK47/mRqtpuH2AJXEcDfWMENO5OYW1olmTJbFt6Bpl26zH3+9sjiG575+/UFDo9hJUZhX1FvPCKmCneaWd8q+E5L1f7JVUV3UgIIKjsmZnqikBYw0UE9VIHYGReo9wymrU+PjRyBgpQk832t4GObn+Si1KBJUvNopwtguHWQeo0PQVPgI2kBGhAzIkuEZWUQe7GCJnhNXRENYt8fYpYL9gDvwtNUFQC2n49JMGakFrZOeegt65Wh5pJIWBq28VPAZaaMylW09hgwUgqp9dtUI177+XysXNtKENQ842yST8Myck1GeG76WaNWEWqls5aT34dLR55AddHLENLtqj8XTfw4zAI1f1a+IXBaFhKcTYb15B3RfD7qvFQUkoZanohLfUPH06/pCpOX0bnd3GVi7cynm0anuAydAWNlJGJH+/8UhWlhdUMyfUOQMUs8PCs6Fd0pvtVyBjlc8W8iZ07sS69lPGif4Wi9YJF6OQBIYheyktUeToPxS/qbpVfAlKkj8J1VoNP0wyA8S7HnaPFhX9wrAw9mZjICJaBDWjbrISCfJyEdapDg/OkKghNp5w6w5q1yZMWMySMTp8uXM4C/3UxZh0xFIsHRJyL3q9wMwZSel1UYnMIBuMp8K0t8HA/yHPGZs13dkeKhXi+7dLPCH5Y0EWXfpo8Hp0/MpZJUutxQy2TLtYHP/WR6Sn1GF80wLIlPF+GCbrQVZGKb/sYWdO1iCWGz/nyoYrk8cBrUEHQTbeGLaMuD5D4+yfIOKWu4BWl6IWRbFaM8TNf+8ISTmLpdtEDBjXrfU7rhvf25/9I6V6bzL7eug1tcevoxliHxs8Dptg+z+VMFE3r3EagRRurwFROcMV3ViT7XaH+64zWZEIsJnrSibdHmBkm5UTGDHq2p8Zv4iQM6T+grqsn/m8uBc1
 rNsyedQd
 sUBSYp9JLYe116sckB5YOeiwcioG0h5YWI1pu643Xrbhek7OnG5OiRjWOr92Lk3/mkBvAj7UzYRq4BZlYtVBFrSaLWhyRkJcsXkxiFlaXq6NObH3LNfIWe70/aZ18ALu9zD6PTVcbqeL+4Fg3H636kd9gRH/ttnP78zZHgBnrR+mKmZZuMafmiw9D8BEzJl4D1IOcZtlAl0hEtHx/vVZMWtMrs9E9+waPmSLErUdBePn8B/t/2jMRuTX5yitxJNgmeGC6eGU6OUGxKEbMRmkpuazZ1ww4swTVycPnqe0ZOvRpYLvIUtU+1/32BVnl0J0I7UL/rN1lCaElK6lYiTHHgKosQSiMPV8JxW8hfAhZ8Z/S4z6gUMtMqM9pDs13czNtlvJUNYMV7mPc7qbd+jwJoJ3drgxKDZZaprxsTMl7qGvLKsU0TXDZILNdWvcIoEzVSSaZY374uGCLHOUHmG7jXiqOKve7m+CFhD12l9BzwEN0hxVG7gUTzFWRJTquEZdOoUvihXqYEfhotSlrmlAOL8m6hwcFT8ifS7hKHTuuTrVUn4pDwBOmnoH2heSgDI6DQz4NrOBaLggbdEnpQf+y/8k4FYHbKty5jWxx2iH0q9Y/eIVshkEbYhqOKqYOzmWKsj7c3UjvuAvPkwTpHUjPsap97FQZGRKU11vwBjA8hguJXKaRhF+XLzbWTEDccDIuUxZSuJmfBV9UaD/F70EFrVLy+0t3Q9MFg6MSz342of3Qw2ZJtwHd23DU1S7N/msJ/Tu/+dtuL21/aIe0aOJT7QHWkXVKwtMU/ysC1+oJdU1CrLo=
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
 arch/powerpc/kvm/book3s_hv_uvmem.c       |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  2 +-
 drivers/gpu/drm/drm_pagemap.c            |  2 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |  2 +-
 include/linux/memremap.h                 |  9 ++++++---
 lib/test_hmm.c                           |  4 +++-
 mm/memremap.c                            | 20 +++++++++++++++++++-
 7 files changed, 32 insertions(+), 9 deletions(-)

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
index 03ee39a761a4..c497726b0147 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -201,7 +201,7 @@ static void drm_pagemap_get_devmem_page(struct page *page,
 					struct drm_pagemap_zdd *zdd)
 {
 	page->zone_device_data = drm_pagemap_zdd_get(zdd);
-	zone_device_page_init(page, 0);
+	zone_device_page_init(page, zdd->dpagemap->pagemap, 0);
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
index 63c6ab4fdf08..6f46ab14662b 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -477,10 +477,28 @@ void free_zone_device_folio(struct folio *folio)
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
+		new_page->flags.f &= ~0xffUL;	/* Clear possible order, page head */
+#ifdef NR_PAGES_IN_LARGE_FOLIO
+		((struct folio *)(new_page - 1))->_nr_pages = 0;
+#endif
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


