Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62C1ED39008
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA40F6B0099; Wed, 14 Jan 2026 14:22:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B51736B009B; Wed, 14 Jan 2026 14:22:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D7F6B009D; Wed, 14 Jan 2026 14:22:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 864EC6B0099
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:22:01 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 222A81B55A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:22:01 +0000 (UTC)
X-FDA: 84331539642.18.03E2105
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf03.hostedemail.com (Postfix) with ESMTP id F1B9020004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:21:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ehkgDJVZ;
	spf=pass (imf03.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768418519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WgJ6H3YY8gG9HgSjCPktz50itSHG3UyjBjXcHyKvPA=;
	b=BDlnYKck2yMo4q2JUjrLVrPG1Ea9o/apazfLZkMFWuun+S6MZJjkKjMVcUcnb6bCttwTeM
	9LqbXyejx3qlC9vxdgql84eSUU0kUwiSRL/2TVYBfSVDhXXr9EE2WVmwsXWDrLl+39FpF7
	Bof6GQ77ddK145iFAY398ewI+BgR07U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ehkgDJVZ;
	spf=pass (imf03.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768418519; a=rsa-sha256;
	cv=none;
	b=ySBstBnvjMG9d5Elb52hf3AEhDyR8WpSLSMNv63sXiA59cmph9qq9NXkHf3pbD0JROsTIk
	VMf38EyplTjL7FHuPQlbhyRWLHeesYzX7nKMDpngFQWSH/q0pXYu5PxTbuVBieKmbrXHhc
	Asu8H97UdgXBEP8xH38L7W3YNDHRQPM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768418519; x=1799954519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wNHhMTFoKgcFcoI9MvGkKR8c9s4zetyJ56xuA3FEFno=;
  b=ehkgDJVZxwl9cveMjk/LGnAF//c7ufccgxPflvqG4Go3Gpl9PhZzuzc9
   dDGmV3vyFrdX+vBTXDY4T6ilYieYH9G4alHQBqTdQeeESZ6m0wBt1eBns
   jSiBf/5JuY1G+oqyiVEwht7Vy08A2+E2m56xBizb/eMbrf7Hys2qurCCT
   nWEJsUBo205q+4AHhxFXzZUsTGZb/51yaTYxrn8XXl5+xP2uatC4IW8Ku
   tDRiNxbIoDxd6CdMoyi0JQd0nZuqyx+oNyEliexGqR8I+LCbOn+VSWMS+
   Tw5JFYhT0khfaKxBEHYrBAJGPuC3B1otum8inlRcyF6T7BHhLuOmNvis0
   w==;
X-CSE-ConnectionGUID: Czcsd2nlSqWKE0/xxNobjQ==
X-CSE-MsgGUID: kD716l+XR5y3qijtjikOMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="87305769"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="87305769"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 11:21:58 -0800
X-CSE-ConnectionGUID: NvgJqYT2She6Ue0D77QvjQ==
X-CSE-MsgGUID: XysvMgwMRsSCbM9MSkDCFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="236006896"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fdugast-desk.intel.com) ([10.245.244.85])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 11:21:55 -0800
From: Francois Dugast <francois.dugast@intel.com>
To: intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
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
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH v5 4/5] drm/pagemap: Correct cpages calculation for migrate_vma_setup
Date: Wed, 14 Jan 2026 20:19:55 +0100
Message-ID: <20260114192111.1267147-5-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260114192111.1267147-1-francois.dugast@intel.com>
References: <20260114192111.1267147-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9xrkymtc6wsh3t97wwdragd171ibhyro
X-Rspam-User: 
X-Rspamd-Queue-Id: F1B9020004
X-Rspamd-Server: rspam08
X-HE-Tag: 1768418518-261124
X-HE-Meta: U2FsdGVkX1/AiRBV1j2DiesMbH4UMKxrSZCqx9uM67chGYpcPn0TGCPW+JTKBK4xZMDMtB7Bn9L/Nk2wdjlKVt1i+rOJRElRhyA2JZBsMwHBA1EoQ1m0MyHEx7dFTAPasUXtjsfBkMlhloUFgh50+3hhcun7KsNFxowJlfpctpyjIFzLkaWUj0YTnjowusOfYZ7CzwTjOFDryZQHOv2dnHRpL0eOa3bXzbHZu815vWts79atNPc/GJnQ71FbYygXo1lauDXwvqp0ZiZdLiO2ABoo2l3zKxtZJpsPu6yCjTPu3li4ENTtT5qcvpOEf/IoDzs8nTSF037a3gkYnzbFpsxFXeFxG04/OvUQi5aHZa4eYMNM/mzMShvXqF0KtIvfLV9g2KKiJPvLmCaTIk5r8fC+PgImhSDsGy+Ikmr5snK9xxCe8fNPlZkB1IUr8K0+jjAXGH1P4MGBJWts3FNMyrwG1XcVLM2Nu9xaoyxKH+idy43P2mxrxh2tAGNImbcwrJoHyuiGPfaIVLyqqh9kMTcJoyi2JZmmAAarlUiNKLOp14tt+Kt1w39RaES1lMHIrEuJYa8sbN55inOLYiUAG46BeKczOy2I4XL+rg89iUIF3zaR84Rqd6nDJG4IPvM9+MPTa7ZZzokrDDwyo0ritZplhgB1JVT0UNVPoUQH31dJmpNuxRkwKmzRcjpOKt/arXmMZmxQZXPirQOvdEN9IrgZ3O0AforeVXItTQ5jUUq0WG1Z7m5uvkRjpxGzBxu8rkyMYAxtan1SKBqu7F9evxOB77I1dd/8gkLN7D7yeKJbWQzj2E5Qch4Kn5OugfxvGfEgcvXEnEcFeCughnQXJaS0yknMkZmskMDPq3CvIV7SZ5aof4KxI+FPWC1MSYrKFbnD79ak4ca4UXcqyqJN0GQrEb3ac0Lv0L8sVDvMuMNrXKqtGYnhuNABsjKOYJw8Yhuf3ruuft8tLid48Ux
 hOksu8rU
 bgL4MK6gjlx9YsG8zCLXvxTk5vhxjkjje9/sgjC+/nQMUJr09/g4AzRGW868tGatnhpra3Ip69+4JbvcPNa5XkZdoA7Em1XwfR8O76W2nUxTTbJr9UpEtCsf/ZRB+DZSkmWOO+uMvEt37hmbULKDcV9Ra4sZTcLqKguVmJ0Q9WgbXhXzce497MqIf3mT6PO/Xblmfh58cqdIiLXcU7Z/o5fhIFCbBRiVNAkME5eeA1udI9ePLsoThcEDMr2N0oM/n5Rf3o/tWtgOYWBkL3DcPbFVBSLXpvi8WTbDzUGuo3n0uBeRJs6reApYrpuFKccr2aeU9YRWrbuJcvPQehCBIMKnsIkMJKX+G8Wv/gKyR053vhJEj+VmCLbJGGc8lfAwLbAvg7fJquoXD4NfodYwKcQGZGCZnItIGisMMaS+g6kzDf4wmXzaxf0CxqXjz96guKfxsjvI7FnkbStc5jKfESbaciHS/yf58EOtq57S+LahRL7yelN2yMba4/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

cpages returned from migrate_vma_setup represents the total number of
individual pages found, not the number of 4K pages. The math in
drm_pagemap_migrate_to_devmem for npages is based on the number of 4K
pages, so cpages != npages can fail even if the entire memory range is
found in migrate_vma_setup (e.g., when a single 2M page is found).
Add drm_pagemap_cpages, which converts cpages to the number of 4K pages
found.

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
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Francois Dugast <francois.dugast@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
---
 drivers/gpu/drm/drm_pagemap.c | 38 ++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index f613b4d48499..3fc466f04b13 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -452,6 +452,41 @@ static int drm_pagemap_migrate_range(struct drm_pagemap_devmem *devmem,
 	return ret;
 }
 
+/**
+ * drm_pagemap_cpages() - Count collected pages
+ * @migrate_pfn: Array of migrate_pfn entries to account
+ * @npages: Number of entries in @migrate_pfn
+ *
+ * Compute the total number of minimum-sized pages represented by the
+ * collected entries in @migrate_pfn. The total is derived from the
+ * order encoded in each entry.
+ *
+ * Return: Total number of minimum-sized pages.
+ */
+static int drm_pagemap_cpages(unsigned long *migrate_pfn, unsigned long npages)
+{
+	unsigned long i, cpages = 0;
+
+	for (i = 0; i < npages;) {
+		struct page *page = migrate_pfn_to_page(migrate_pfn[i]);
+		struct folio *folio;
+		unsigned int order = 0;
+
+		if (page) {
+			folio = page_folio(page);
+			order = folio_order(folio);
+			cpages += NR_PAGES(order);
+		} else if (migrate_pfn[i] & MIGRATE_PFN_COMPOUND) {
+			order = HPAGE_PMD_ORDER;
+			cpages += NR_PAGES(order);
+		}
+
+		i += NR_PAGES(order);
+	}
+
+	return cpages;
+}
+
 /**
  * drm_pagemap_migrate_to_devmem() - Migrate a struct mm_struct range to device memory
  * @devmem_allocation: The device memory allocation to migrate to.
@@ -564,7 +599,8 @@ int drm_pagemap_migrate_to_devmem(struct drm_pagemap_devmem *devmem_allocation,
 		goto err_free;
 	}
 
-	if (migrate.cpages != npages) {
+	if (migrate.cpages != npages &&
+	    drm_pagemap_cpages(migrate.src, npages) != npages) {
 		/*
 		 * Some pages to migrate. But we want to migrate all or
 		 * nothing. Raced or unknown device pages.
-- 
2.43.0


