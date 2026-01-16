Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6268D47CD0
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 11:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FADD6B0092; Fri, 16 Jan 2026 06:14:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1CE6B0093; Fri, 16 Jan 2026 06:14:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18FCD6B0095; Fri, 16 Jan 2026 06:14:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B16B6B0092
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:14:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B210E160646
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:14:22 +0000 (UTC)
X-FDA: 84337568364.07.5E70572
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9A21D160004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:14:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rp9oAwKW;
	spf=pass (imf08.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768562059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9UVfYwjRJVJ5/u5EzL+LE3+jwnvHK4sPd1yGcvhGBU=;
	b=2jH0+Fpb5RkB3sWagxn1EVjeHfp0krCC0yjmOZJ7tXOMGnaGC6PodM8vLPVA52Ly1wN4l+
	1NPQutzdKOYxIK7bRhMVcdpIMglhw0jpsYrQZvNu9TOt/Slkhw3L6gCeT+ioetZcyk70ww
	4bS+40M1xvdoBBr03m/fYgpIPJhxiTI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rp9oAwKW;
	spf=pass (imf08.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768562059; a=rsa-sha256;
	cv=none;
	b=StJQZE5zB4+PJfyo03Z7DyA0YRHcHPP3nERAQADNo6TbugLw2znST0GMlnJU35kDbb13DB
	WxKe33a+nVj2Ouj3SlpO7X4qGeZ7e9CWbH4ZstkTUWfsx/VNxV9F3xcOtA8+4X5SCdP/+X
	CqEdpDrAE9VToqR89tnz+/L+Cd+qPkg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768562060; x=1800098060;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mBOxQs8BH8JAqY3k9CojIrwNOlG02fRJacnATFBUiKk=;
  b=Rp9oAwKWhKysF3E4OlVvsWUerg+IVkV91kKskta/WpCW8o9o5ldYVel3
   IO6OsimBSSOTTxlusF55XqF/haQN4VyrokuC/ubf/QPTMR+7bf2MMIciB
   mFkFDpsQyde1yifXIjcW/A2gu0Scgsohv4+y9XyH0hzFvgJuhhhcOhqXM
   XOv1XxqOtS7azqCtJCU+JB6JtOxx2Wo2dsfZrFsClZncHMZJRrNLqPt1L
   Ag6sgtTLSIKL5agrRW8D11sUi1ZLs0sRjsmEvE/2x5OvcVOLfMSrBPgaH
   jLEvqWosYrcQW5Tqn+24MpZRXZA6UldDUamxyth1JUadeXeDF7TghNZVS
   w==;
X-CSE-ConnectionGUID: 8Va6Kg67TVCFZmKcJSFckw==
X-CSE-MsgGUID: sQxGVmXlQee3NM/a/U98vg==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69930687"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="69930687"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:14:20 -0800
X-CSE-ConnectionGUID: pKNQy3n6Sl+c6qOXNSh04w==
X-CSE-MsgGUID: /SG8r+tuRpuXYH6enghuCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="209713475"
Received: from fpallare-mobl4.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.245.100])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:14:16 -0800
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
Subject: [PATCH v6 4/5] drm/pagemap: Correct cpages calculation for migrate_vma_setup
Date: Fri, 16 Jan 2026 12:10:19 +0100
Message-ID: <20260116111325.1736137-5-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260116111325.1736137-1-francois.dugast@intel.com>
References: <20260116111325.1736137-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6fx14bbuqkyh19sfcx5unqepfemcnwt4
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A21D160004
X-Rspamd-Server: rspam08
X-HE-Tag: 1768562059-918163
X-HE-Meta: U2FsdGVkX1+pak01Dp0abYnLgwPXktUstAKYITm1/EDR3oBawSw23eUMS3WsvAQHUwfumnhrjtBXyFrg+e8w4Rg+P+452Mngvp0/UOw66VQweS9jtU8tgE3nFDcJurstKf0hZaENYp/etqJQWGq/PbZS9WzH1uINXkowWOenpniKXT1JynpCxMi1ew3Z3TVyTEQP8P3slUBg9SEz02j30Ff6gCZLlfB0WQrMlo9TqED/20CM9X95GlDpgP6FsSnnNCWe4rW+NaWtO+epPtmUsfltCcVCbW9yqsQb7gTN2tFpNO7saZAKFR5rhKbnN5qxz+h+635HmZA3h28cqlT9xzr4LAugBX91G/0po+Ha1HcQIb0K9vX+4l9/IBvVYLBLleUVnxAZsbkDBgFmNMkD2A+I+iIOEWwRBIjAaHzPUYIpNqa/4vvRbE5vw3PafoFi7mDSy4Y3SLEp1V03syZlPb2wnuDGKcSg56VEmqjGfbe8YLWcW95urLCLWE/+nI++kiiBksSXGr6FpaUJnmkte1089sFYkla5fXQw9CYiZelY4ggUgpIQfD6ZwKq6DCLvfJCxeNk85DOmkDTtRV0RR9HrtjOE52R510t3OCqKpPtjixs1RSGeSqL/P+uxZMTDtdwyzhy3EFstWn7DxnuArqqnMyOYcFT5IxYxJrKUpLEEQ+MSEd/nbi+YcBZOWO9RuR47c9aXNR8Q4tDq2qwE8FmwQvi+jCvw+p8cEuJKPBodUzp+bcRmAjLCNsZPmtKOKwsk1lA54aEOOmW3kckeGEeB2AYn3DSh3lQjDds9qLosYVbmzC62nJ7BBl42gZ3dG+5fXmTxtYZ8Pt6eGPMDp1ssJGd53aTTqSn/W2UZq8Gy4NdYiTifpxrU2gjI3sEX2iFl+/b++Yo+CemakQJzw8IIltP2goUgbqH2yE2gR7Id7XhZsPUYRJG3s0uMPI81hs8T9pLGfazMYZSwtrc
 Rjpbt7J5
 VIiUFf7qOZ1aqOTJHLV/bY5NY7m0eBOPT8FaL1l8+QS/RlY4Aio+I2GYRe67I0ZuVxpLdtXaiOVcJMXY0QyL6O8XsUes6CPzGB8/i3LM8s4hL1APynGKQBH8pKaUhgRBntNv2oNsxmVd1/RFQ/qv0Kkb1/5iblVaZtDePiK33fV+0PjnmDWJU5tjOgJ2NM1ClYRwUT5WR9Yl7T4SijqCR9L4nHFgf0E3UM7iA2T9k0cXhs8Bj4PSaPzu5uaI1xg05qimI6DWT3b7yZRR90XmXr3kZ2ErBAT9BJbYnn1kVrL8o1QhSIOjJg5bNGEndW+ZddQGXcbm7BiCJP7z48PulBW69wQo76N4hJzRBGABt0L4ESm9HGkMqanwCkgXhIdjLW1/6kbnwjNb3WAiArDEodH5cM5Kn6rQ6laJVEsS4DCS84uMuMG9PQKB5ifq/826w+kfihv5/8NaFj8tV3PBA4x5rl3dPVPjrF4U0pLXul61q4xH5MNhniQ6moGfmQP4GqN6TPSlOsUmLlNDtYp4ybC0n5+6w/MRBscf/fQs19joObx2JFlj6lRMIhHg+nEl7p+7T+oOL3sYOT9CgHHvOiU3+0biRRT2dO2UxHpJkl9l3h58=
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
index 61c6ca59df81..801da343f0a6 100644
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


