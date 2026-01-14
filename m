Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ACECD39010
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71A7C6B0096; Wed, 14 Jan 2026 14:21:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EEE76B0098; Wed, 14 Jan 2026 14:21:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611586B0099; Wed, 14 Jan 2026 14:21:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0096B0096
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:21:56 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2726A1A05BE
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:21:55 +0000 (UTC)
X-FDA: 84331539390.16.D74FDF1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0271F20013
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:21:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XKabpkG6;
	spf=pass (imf03.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768418513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ufgIXdvPVF2gx42QGJNDZZOAkrzN/fx8Ex2dJa/HRd0=;
	b=7L7HLJOCrlir2mnqTFjO9GkH6XA1hQ/UUIyU8IojXoZjtRxb5h/GApp3vusUgKkNnwohH+
	4bfNgVMsjy2EbKiLUYopHd2dsfC/8Wu797vgdp9KkeoDEWo1jhaNR8FfrUe9/B8tNhovpH
	GEe3tciwH+phYaNccVkv7QleaVVkPTA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XKabpkG6;
	spf=pass (imf03.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768418513; a=rsa-sha256;
	cv=none;
	b=JBV6vOiHxsdLYxRv8lFBj8qCSDJZyK6Jh2LIfa4i+MUVoLO5x3RIUjA+BumvkHmbQEwrLu
	nFTjzeIsPV81cz2Bce4pL7/qcceXLuk0czDtgbFxaVNyT11iz2bVZTuLo9XWQHeknCLutb
	RbrcNRJ1Uog17Is4LtoB48OLsR91h+0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768418513; x=1799954513;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s/HjoCCOzzfzulVqC6JKs+F4xrPX7iIZ8X8STMovGus=;
  b=XKabpkG6+JeF6A1Tr6GqebYq5mUZNrDP8DblR3+DqsJD02nelbmzPfTz
   AFsCoieAm+nt4BIpcpOs6QmutUdr1GICQ5/cQ1VbT3UcHh45LItz3nRZM
   efuLuL/Ultq6Nde5NE0NfQv59p/ni3XCfPKM7jiaQpUuPDHQLTYWe+uIL
   7O85s8P+DhQy5oxrMBdP2D+vr0deKcbsmZ1GO0m18f1pxczKZ3Kq8e7m2
   G4ZtsjTyNSWIMnBeFHHzOayBR/0P7itXZZ6TU0oLAeoV+9sDD6LSf6xos
   iBiOMeJj+2V07Gkx18nnmowou2tdol7rTtaoJ2xMZgHePddb/kA5WRkl+
   w==;
X-CSE-ConnectionGUID: iW2P7+aZRuS9SrKm+pjpiw==
X-CSE-MsgGUID: nJfPkklZRFqSuIi/EEX+Xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="87305747"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="87305747"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 11:21:52 -0800
X-CSE-ConnectionGUID: CM/J6lc0RPyu1AlZfdwSjg==
X-CSE-MsgGUID: /6jlWb8fRBan42V2cn+AMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="236006844"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fdugast-desk.intel.com) ([10.245.244.85])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 11:21:49 -0800
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
Subject: [PATCH v5 2/5] drm/pagemap: Unlock and put folios when possible
Date: Wed, 14 Jan 2026 20:19:53 +0100
Message-ID: <20260114192111.1267147-3-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260114192111.1267147-1-francois.dugast@intel.com>
References: <20260114192111.1267147-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zj76p1dnwb96z6zs44czfcwsm648a37p
X-Rspam-User: 
X-Rspamd-Queue-Id: 0271F20013
X-Rspamd-Server: rspam08
X-HE-Tag: 1768418512-812428
X-HE-Meta: U2FsdGVkX19nIW/J11JWkptcix7khjZhcSP7FhonGnZvtBdxdbLA0sUR0Hs8j4AdCzc8/2XLiMxKYmbRswFAx3Ty1AAE3QHzz6k7mlEvhibINlWNBPNDYClGA2+fMhbenhsB2N3oswD3yEkdg+sVCiggnpyWFAM6hNSQ7z8Qu/XMilsbWuQR68G/ApR5DUKsOOC9OBld4ibFFDqTuxVsBEZQmwv35ufXgk/VAnqSUBGWZ8gVoLuK58XiDbgxbddfoyslqRzDXfiAtKOFSO54gvpYLs3z+TylhTvefEiAQghLykDsyuhWMYMWBdeDy0VisZdpzfdF6JQmNfeTSyr1uigXfqwG0EFvqBarWHmaGkO4cpdJJIN45FcBeL052LB/Yn6J9/MvyZqDFGPFbYPwyrDZB/rp/KmCkWgg52hCBNfixsm1v+CQtG8iM15D2T7P6ahZ0zI/UFGAtqltF8TsVhGSTGoUXazsdojX0i6do9urABlv3ecwoDXUmTY1IgF5uk++ciHrSGDnHefn088xbIXn41vvjvpKZ3DFJF5AeNUA/M6dJ4PuFbl+9VY5KnMe1HEbcqMTymJ41pZRJXkce5/8SzHXkDwPy+XZ6a70puorsd1X/iQIjx/gNhE97EzPE2JFpKe0P7557U5k/Dji2JiNAZ5UrZQxyWFeKgcjGAZ2MZS+gE0FXFnFSj4zWS1sF+98gKL6D8cDe/emCzqNATxQST4a0xBSdyPT8YGRUbypTI/KnChVlLFQfryZIKMFtM9+kR+l7vkZnLIX2j5O9k+ZagKcaTOIuHc0kNw8w0VKQU+j7gclHqIVQbNWdIM3YYqUqlwaHeg074Ee2bBUQ7hat+1DDlmsqkDTptAMl4e9Mp/Jwj64p+GNiEl4OjTX0FofWKuRbG32rxijhQfQ4EibDwillZaRrOOV2jDv4l4eSD9rCrIzb3FMszIcEoLZBhTR9D4PLiTV446VYZX
 Fp9n+d+k
 ljluIz0JGiIk1OOr2gMHCenc9HJeOzUmOfT8jvI7mqKKKYDyaCIrQNBTAw2qVlRq6etSMOcYoC7hp1fA4A8ZwA2nPb5QS1Ewsc1JE99mfuBfy0xDDxgAVQW5Cd04H3y/UnvKm8O/nt2LuIWvyul9CDML2EufKmDcf+EtbnModR+cgviCXZK07G6TxIISgvAMLPG9tZzrAOBfZvy1ZTQg6GPkz47DiUXfU81kHsXryiSD8v5ySeAtQ3zQF3AWm/gU3rgllnCOYM7BFDUexsFLkMU3UJBJGa6I5Jq+eNuDmlwh1fhEIh3PntGDZ353IMwLPiLfbnvZgPYiPZi6G30BB7dpyeUJw74pVJ8ZPoR7GgSKS9nt0hik34XyUli9UAMffM37IiQ1LDfBy2hm0mpNHTfyU2cWWIXFjXJbgPSXRi0IRawTEvVizfxVdH/ZfvVqtSClVZzmQvoiz/gVpxhYblAnY7LGyDpANmAGrH6+DCRK7iDj/Mrfx2/inwBvL04/xQEncan+tVA48qe+IfyxTajJiPkHhppemtFYH6IV71hxs8Ku4NKEnujSIW/EVbCi0Ncrr
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
index c497726b0147..b31090b8e97c 100644
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


