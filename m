Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88E60D4898A
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 11:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7AB6B008A; Fri, 16 Jan 2026 06:14:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF3B6B008C; Fri, 16 Jan 2026 06:14:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9496B0092; Fri, 16 Jan 2026 06:14:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D22836B008A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:14:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 98B0F8C0EC
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:14:13 +0000 (UTC)
X-FDA: 84337567986.02.B566EF0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf08.hostedemail.com (Postfix) with ESMTP id 984AE160004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:14:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="D7zaK5/n";
	spf=pass (imf08.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768562051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g0TmbaAH5e7FsNHJuYWRRTqG0y3iHCPX31T+nmFz/SM=;
	b=UfBcAAT/hk7m9bbTx0iuestG1U8y0lmaF7GBwkyTEdziRkx520ThJcPcGyNEPlFr/r4rnU
	31kNOo483DZKhmjP7CEx2twfDh2ZU6kbtM+RoSCH6UOL4d4zQzks5YcEb3laaU/XbqExcY
	gtrGDYLSmE+hGK1mo3O5lkxj4RtFFUg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="D7zaK5/n";
	spf=pass (imf08.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768562051; a=rsa-sha256;
	cv=none;
	b=EnwM10REmYDJi/6cYmrgQ9idVW+e5LhKHJu706D3hewq42qvWNIJsoUNKk0H5MfHVpz3g/
	MA2SC3+q6QCxNedtcIYqkUCd1rxMNLD7XfHfcMsjm5ahCXJ0yYYsHfJn8nLyncDPRQsL/v
	d71xRTBOCFxECzEdszEzCZKJLlcPIpI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768562052; x=1800098052;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ocrp/eylFW5UQLpU9JLpH8QHEGjvevQsJMehADaKSBQ=;
  b=D7zaK5/ncafpzBRa6ESgeXPwbweI8njTMdvCjMJFfakzjwIzaJ10uYIC
   Gopw2RCsGVLcIq9pwzng2A+0R9nS+mKqQhQxDbHePxPMFrz1sa/4K2A+z
   bx4wa1Dd1fd2K2B8YI+NtQJrNWvKJJFe1GE3omD7KKWIP61VDYHcP/J4c
   cB4BntUVXzmjwvZgN1cr1jdbABts+iG4ah6n5bdL0QI6qkRjb+7EpDh8d
   FY8FFXUcMCmYaeYD59qOCfzHg4497IoX2rLwoPmjva+yfGikw1vE3tMPb
   HlB7GxUKmUodKoNsTySfjFUYNmLOlRNJ5VigYLZvThrBsx4bxbJF/aZof
   A==;
X-CSE-ConnectionGUID: S5+fROytRbKOTvWk15ob2Q==
X-CSE-MsgGUID: ghKS7uFlQYypLfOGpBJy3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69930664"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="69930664"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:14:12 -0800
X-CSE-ConnectionGUID: BW0V33PURSeOncgvxmVpDw==
X-CSE-MsgGUID: DpQ/PilxQ/aDw4Nqd70PrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="209713445"
Received: from fpallare-mobl4.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.245.100])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:14:08 -0800
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
Subject: [PATCH v6 2/5] drm/pagemap: Unlock and put folios when possible
Date: Fri, 16 Jan 2026 12:10:17 +0100
Message-ID: <20260116111325.1736137-3-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260116111325.1736137-1-francois.dugast@intel.com>
References: <20260116111325.1736137-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t7at5h5787bxpri8d16pxbw7aa9da678
X-Rspam-User: 
X-Rspamd-Queue-Id: 984AE160004
X-Rspamd-Server: rspam08
X-HE-Tag: 1768562051-587212
X-HE-Meta: U2FsdGVkX1/qKKn/pBWBwFMnk9E9rc8ITeLg2na5FHBZNHNRMZ6Juv34/Ib3us0p9Ac2jtHWkiJkwY6f15hXT6s7bOUakUJW65pCBvjr+A2lMU8bIP1SU0Vwl7SoCbB/Fd1/A+76+G8MVcfqdoWmM3xT7IMS80zB2qxTFJk14vUABUvXCcxyCfh127F5quIdnb3r4925uwOLTzqzR/2V7E5rvC0u+AzN4L0Bbhu+Jn+e8t8T8M80rmD2RVFdqZIzgyqG4Gj68N3lrV6VHawDn7MsIFSfZzlfaKg79zViRH4yTWw49Q3gV4WMhPMe0SVxEhqt5t5egAYUhqPJpjmD24IQMPpLkD2H4XWzbHHEOIJLp3B4A+N0DekAtarKuddYTzHVRnXZxDthaTcDHrK7sWU2weOeRn6e6k3nKieWapJOxLzP5hJ/mcw8sYTGuDrxYMXvHJFKtI6brQK5JA1GWMlw+QyDhO216YK2+gRVtBQdwApPdWU7MT1vauAg6/GZbmGdwWT0mhrZa+Tm1i6jQKc2ZfnD9dChnvMox2hB+jD3rGlE7nrC9G7ZhW69Pg4DCVhkR43so8Tzwc7aemPzyqYQ+uVGKTl4MLtyb9Cjrxg8fVfFzoELw884jjAuDotMYj/TxbCN+1nf+SUUVO/yGKVtFPMFb1O3nm1OypL5p/AMIs9Boy4DfiHGPk6n/UHKUTje1D9LZ9sd6j925uVc99m87lgDdK/Q1r/K2t/9i5RG2UkNnFvNECaJGE5y3T6MDBrVXlE8kiYPHSBxeDIoC+5/gjGz1ZoKqqrB5B8hX+EzoqEZV4FIwFJQHanCT4Q5EElJLhJGOabn5f1D723NvU9rUOedWGYnA4+A4Ods8jDyfPP54L0VFET8uBVSmm4Jq3jDt0O0Aj4SZ51JYPVdFucvNqrjF1ptrI46VvWunARqvSHe49RQJZ1Osc+1NG07Z2YpvZhi0E3x2OamdAy
 4zT0kyVl
 ZAzfonqA25wwcccxYjPZB6V97gd8YBCFi/+wX4RfynPDZJY2bpxeKx9etdVyKAjjRDAUePlsXivLDszs65/H6C+rEZEOKqcF+QVwurf/su+AWHNnTzA0nTwMMzDWsCeBlHMs+DPcVxSU/TYw2oqhgsqVpr7OwuFSPdaGQ9eVI6TzIICx0Vw8EolALgAGInf6ukZB/7ktQ/cllaAnCQt8TCDRkctshhmkereGWwVan6RRDlE1vvf/n0aW6ryZmJPe7iHuTzrErCdzgrcLwdtwByqUro0qqkbRTtn8GHu5grKSSwp7ijCIfdOjxkR1yxazPAnok3S28TiFKYqzzXB2STAIprt+zEatNtSibVti7RK9rgsHx0qocAz0XG+QTGFVgQg56esTua8iNYraSyY8NjM+5L9EwkFyEyJxZjHiZZvth9tNDX/L8m4dRT2HLKp7RDOouMabdfU4lPLU=
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
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
---
 drivers/gpu/drm/drm_pagemap.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 38eca94f01a1..8e24a2c24729 100644
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


