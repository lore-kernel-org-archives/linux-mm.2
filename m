Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44806D2502D
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 20:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADAD76B0092; Sun, 11 Jan 2026 15:59:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB25B6B0093; Sun, 11 Jan 2026 15:59:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C8546B0095; Sun, 11 Jan 2026 15:59:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD766B0092
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 15:59:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D1421A1138
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:59:26 +0000 (UTC)
X-FDA: 84320898732.22.0957596
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id 00819140005
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:59:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YWNEveyU;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768165164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+J5UsGcaLpwYORxdHvRP2gwdCILhwWNUoU2PNPz4DI=;
	b=ssKbdj0ZxSVU/uYFVFTpMnoF5awHDjwL54Lfdv721uMIInUUjnuPiCC6+w7z8MBfZVJ9T6
	zTuOUgBgHgYG7s6M2EDA2dbvYwJPoikBKYQgRCf817Az0ZeAtXAnsDN+Ywp7PCxXQZLpls
	bczkkaUM3grdMoW3mbhY+1m5s0iH0tM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YWNEveyU;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768165164; a=rsa-sha256;
	cv=none;
	b=HqCZhU2DDiZQyM1DAMYD9ao1np2hwKAuV/yfvVxHFbDb096pc8Zei5P4k25Tuqu+AkKZ7i
	dLoZ5eExPL+t+1dpJju/zBiLCj5mwFblwGWCWAh4cSUqkkNaLoVVg3C6uM5G78fc6+E1Zm
	m0Re6l/J9zOckGLIEYQP7Tegaw1JaNk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768165164; x=1799701164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=akE/Z01yEQIwtJD2UJY94Z/0Ycw5aoVagvBjfr0UIfw=;
  b=YWNEveyUQuae/88QjMpAgVuPGWj2azQ8EvtivXn9iDVRNDlWqnqBmMNH
   mAiJeLmaeAbBBlC4gi1+jA/7tWfj6f+gMYKRJFA7zeNUtPwXRa0a2nNv6
   w6ZLuHZtEqNwDY8lU+u50CjoV3/s6ZJ/Ow2soNr/wqFneZorAJAfaRm9D
   q+NGqY/LyNh0rucxRcZ7ACI7aVG7851Dvn871W62yuXeBvoLw8nTfVjhx
   RDYSjF1xQWgSabfw4AY7/DlzFJDoDY/8b+IlpkHnmCVbLPTJ4R/Zfbpjo
   gMKJ40RW3iGLHKIwCpFodahRhr+aQi3YSjcW8knW2FFTJcsD5NULU0fsk
   w==;
X-CSE-ConnectionGUID: MwcpbKd0S1CtwWg9G2wSKA==
X-CSE-MsgGUID: DTsGv97+SWuBtd7yG5TPSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="80904717"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="80904717"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 12:59:24 -0800
X-CSE-ConnectionGUID: G1RwncdhQOmKVSiO7JufMQ==
X-CSE-MsgGUID: rK9ZPakuS1mx8SoRRimqwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="208419996"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.245.11])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 12:59:20 -0800
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
Subject: [PATCH v4 4/7] drm/pagemap: Unlock and put folios when possible
Date: Sun, 11 Jan 2026 21:55:43 +0100
Message-ID: <20260111205820.830410-5-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260111205820.830410-1-francois.dugast@intel.com>
References: <20260111205820.830410-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uiu9q55nqfr9n5uot3s6cmt8pwqfs8kq
X-Rspamd-Queue-Id: 00819140005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768165163-427000
X-HE-Meta: U2FsdGVkX18uLDNtRnpCAb8scyF5AW9jl64odSqkkGuEOURRlnnt5UQIlW1Iwh1M3nVPmRmoSq7a6kSfNJjipEJQatSJyBgcq1Mp3D9pUofSm3XrEd3YaC1FEbBDCu0duAFxjlr/Zkt+30xLy3RAV5P9Lx99sxg2KYb13dFM1S1Qt6zkIVSUfPFTNooul4H+U5k3B1K5+yj3E08nmP76lkkUQ6t/PbW922gExA9XGCqqRmcYCae+a+iOA2+v53LG8vioUGOB8bsuKSYPwOlwfMnfCOt+Ic4wFiVno/fm11PDNL6KyD5WiqfzJJssSJ0TjdqT0EeeTUHo+OIDajMHLhBKBLTAilj67RHmC2VIWLu4tn0E6fBKIs3SKt4YJ0usBgbGv8ngF5p+R8SWPjQl6nLTuE+jlPKxUzolsBqGEtMmH5mNhhexnkpww3LdYYM3ztkw6K8T5iP1FABqZKYf9fSVaXEqZrKAKoauyZk+UD1XWVhX8LE3HIUv5SgeVOKqZTpKMT98kmjBLg4ga1P3s2z922fD/gwXbwxfgsxWgtzbN2J/LwYDVNefk8uy1Pp4fLLq7J2Cfje/piV31K8XEjxymvotmIdYQ1bvu8yJ9nU/nObeWXVWNimrcxqnY9SJ8BRsY6O68Lp9gR2Z0U+/3IFhfnE0NV1K4LodTx93d+Z3JBYpJiQeU0hwvpB/m8pUBOTEiq+2GcVbbBbMHEXvYBG32WM6Iv61b/Z51ZympaPdWK2/rBEv46orL5JRH9IQRIWfFAcXbl2QmWWZ6IAxmWXPuuZlBNEK087UE7nKYRKKltxB1lDJ0sbaXi6DY/j3njhmxJ3qKGSv5k7qOg4GDzX2Nmy+346e1VFO3xKq/TZr3FbO4bbm+c4si4ugU+JIj1QhKbh3DrgdZgApkP63kM4akq0BgY904aE0YFx4qcJk0tK7hrrriTHnnhi6WYkwVxgbj/aZ805s+RZjY1g
 yB3WcKA+
 7YYsAKOl/Xam2q+lJ9XQIye19hAA29VRNANRJz/fSA4yyiKX+/u01Vg0Bw8gRoELZKFd3GpTu1Pq0HhdCw7JsCdE8cvjkWMlUtunnIXmN1AKuIz6KPUPTFgRbdORM7+0D3oIoEo7dx7LRbKZIjHgNkIgis9MTHWAZSL16j6oK+GihVLfQBxr/zgB+N8Y0eUNAzkPv2Uu9uJdIuY2j0Dk2lyUUwMJp/6wsLG+xLsj2GhlfSUxLQxWx/PxMK0he0Citn6/8Arkc2T99Ptj6RJgGgo0bOZ66rZlQ3kSZ4RZnemyIqHZtP2LlOivdlfrNImOEGiPXCY1bmHHzV+l2j9qEEWRDLkndQWscIeA75V4L94fGMXGEWwrCwpX1lr1PcTLplQLC4t/jcb1xMvaCONtz4iU3XGikQ4piXtVcvtTx86olMsRn23xJHPWynlYC49o+z3HMQdh32SUh9sA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the page is part of a folio, unlock and put the whole folio at once
instead of individual pages one after the other. This will reduce the
amount of operations once device THP are in use.

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
 drivers/gpu/drm/drm_pagemap.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index df253b13cf85..bd9a4703fbce 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -154,15 +154,15 @@ static void drm_pagemap_zdd_put(struct drm_pagemap_zdd *zdd)
 }
 
 /**
- * drm_pagemap_migration_unlock_put_page() - Put a migration page
- * @page: Pointer to the page to put
+ * drm_pagemap_migration_unlock_put_folio() - Put a migration folio
+ * @folio: Pointer to the folio to put
  *
- * This function unlocks and puts a page.
+ * This function unlocks and puts a folio.
  */
-static void drm_pagemap_migration_unlock_put_page(struct page *page)
+static void drm_pagemap_migration_unlock_put_folio(struct folio *folio)
 {
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 }
 
 /**
@@ -177,15 +177,23 @@ static void drm_pagemap_migration_unlock_put_pages(unsigned long npages,
 {
 	unsigned long i;
 
-	for (i = 0; i < npages; ++i) {
+	for (i = 0; i < npages;) {
 		struct page *page;
+		struct folio *folio;
+		unsigned int order = 0;
 
 		if (!migrate_pfn[i])
-			continue;
+			goto next;
 
 		page = migrate_pfn_to_page(migrate_pfn[i]);
-		drm_pagemap_migration_unlock_put_page(page);
+		folio = page_folio(page);
+		order = folio_order(folio);
+
+		drm_pagemap_migration_unlock_put_folio(folio);
 		migrate_pfn[i] = 0;
+
+next:
+		i += NR_PAGES(order);
 	}
 }
 
-- 
2.43.0


