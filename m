Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37F97D2502D
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 20:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00F26B0095; Sun, 11 Jan 2026 15:59:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D8816B0096; Sun, 11 Jan 2026 15:59:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3786B0098; Sun, 11 Jan 2026 15:59:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 797CF6B0095
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 15:59:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C989BE966
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:59:33 +0000 (UTC)
X-FDA: 84320899026.15.67502F0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id B478914000A
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:59:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q7xsbdJO;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768165171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o/qJmeS0rGJ37ioXyFKLvguUKECmB8xbwehwoETQHrE=;
	b=7OrOXFruRNjKHv4YR6v58G9VY41e/UPXoP8RpnzVVol8NoZBJ2s6Vlyl5WKey9cKLmCgEt
	TzQJxaLMgU/0YRbNeXs6RsMMXSUIcAeM/5WNgN9urRGSkZhqVT/s8y+Ch13Ja/LskW199z
	MvF1xgpcAmqfaHxkDB1k9CSUrk9Pka0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q7xsbdJO;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768165171; a=rsa-sha256;
	cv=none;
	b=38E2LosT6tdjQ8uR9VJZ8PUkGO4S0eyQTfl5YHr0Gf7MlZ1dCpdA0Sfv9XJ3u/5aQOCQTV
	5p6ll4AOU/+zCoH9kMphzx9XBRhyQ8GMT9lgrHNqWE3zvsq4uBYwHzXlELRORCmuGCU+G8
	Pgn+S0IoF4JDw+LUPcP15ytIcuMFcVI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768165171; x=1799701171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dkxdN34VvfdBFndpQ0gAnBJpqBFw5MZRAtUXsBQrZmU=;
  b=Q7xsbdJOrJX+d6GIzJJWuaJgvqZwMqNc1YQ7ZHrOls0ex7zJrN+QVzff
   SKR/EKqqKERdZvqw2rwqCPayCMKvdBLEeCC+JOa2sI3BCH19dvsWdUgBY
   hqvAaQZj5tlNm8h0NfOHp83QtOSduVUrN3tvGqOmnNasl5NoJBslHDRRf
   5Wc3EiGB+/mTSeNJLaaEBBwcRgxChhtncNgE6bGUwC3BxXipbMEWU7R2A
   DkJXXA91x+DzNylhwGQAJtVJcpCVHvJdwvCuPVHR1MkLu6FCJa/la2AgJ
   R+NsbuFpnMoWG2XM5pm+g7TeROezUNwnW+Pn/nRAVZcvxW0ucPvBYFMRQ
   A==;
X-CSE-ConnectionGUID: fnR7zWxhRmWMq23qeC8+Fw==
X-CSE-MsgGUID: 660nuzBzSO+ZHAFsNAZ94g==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="80904745"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="80904745"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 12:59:31 -0800
X-CSE-ConnectionGUID: yguL52m2SWK5qQ9OZYrOnQ==
X-CSE-MsgGUID: RB8LwdxQR0qMHbiwr7DZwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="208420030"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.245.11])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 12:59:27 -0800
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
Subject: [PATCH v4 6/7] drm/pagemap: Correct cpages calculation for migrate_vma_setup
Date: Sun, 11 Jan 2026 21:55:45 +0100
Message-ID: <20260111205820.830410-7-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260111205820.830410-1-francois.dugast@intel.com>
References: <20260111205820.830410-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w71n66pxex4mrmy8yn7pu3injwfeddok
X-Rspamd-Queue-Id: B478914000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768165170-837188
X-HE-Meta: U2FsdGVkX1+xIfeOPuKYsApVsxwGxgkWxTjBRCuqi/XWUQxX4qnE02GJJhSFxRQhuzcB7laywOnydMLSd6yVkTlToMrST3eXEG3GqQkKtsWtxqdrXm3ytRsod8xNeGhFBoip45rQpAtl4kuTP+CWbcEAXrfiP51cmyAs4bR6/BHR+eZqDDiWyuvPUqkUk9DMEks+1Ptymi/F3EyiGsuWs6z/AVAhXn8ygWZr2syMN7UBU1n6PgyNnhbseMTs3zdUPM0AUADs1neZDPQnK771HtnY3owkOTSylnjdEb9Q08yNGqgBejbHXs7kkxDpsdxTCqTDfngrMTCWzEdRLA12bTGBK1vNedSRyoseNnncXVTQDjY/Z43Yw6YC7cNdc/+bL87cIJB03Cb1kG8T8PcyySOqQ9wBczGUg510hi25Ax5HkCUM6ePDurZQ9HJcwRFJcCor/uANqVUdUn2YqZvlFw+3AVH/JWrir7Ey24A83yd5YGetPaZbMW0AlN+Xc6J0mWJa9xi0vYc+JmDm/L9LHALOPAUcLUcI77oORPalrxLv0hSolVIT4SnfHc+w9Ll/xpwHsvJPrF28Y/ht48sYW6FoZZg1J85ZEYU+m8t6Am3mYpjkpso7+RLCWhKVcZQvju9NdD80hK0gndLS8109aMKyzhX8Wvrua0iax9uCr1jloyvYkcwMkAQSCRxpVlK/HOt/4z3OCXwvq2OgyRD4Jhabpe2vVs31DngRU/id/OdCOLKuX2y2hsJ5VFwhCiM9Uongz9ngm8DrFR36EcfSH6vathig4hQS3ABZqQsCwUpos5bb0rpdID3UX8WQrAswqnmINuTIng0o4+/NCHM23BdE69yYojonPCB7ZkLm9QuhZ37tgMAJplCXwfNGlPxyANM2nlSw9MWbn5YxzbBVPGGo+bp+iE3TqbBNRdDazeecdT1j3k0TpnwQPV26NwmTXr4Ab48Yk4AqQ2bHAKQ
 oUmD6WG6
 p+8iDfxXQQopPjwtTorBtImNkvI0Fvppmpem6c0m2P4qjTorHgX2m7L47uOs2Ht/vEeuQBil+obaAPfphghsYf8BqYXBAsqvhImlEt1IBJzYyLXhY2Q1dOvufu9cld3kTAhnVsE0QgOb3nFt5PDjGrQeYKcAMWdzpD7xZqgYXL39lUrP4yDfz/y21JoOIiDE8sI9DcATLmCl5mkSTV6FRsmD4Rzlq6PTvX/9mmkO+Xy9z7Ac00hgruK1Oa1LNDfqjO6FCoWaViCtLfPKaamFAjk5obCd+HPQyhAP7xtZhj63NVr9upB0EvAetfeEnYaSG7CwBsPlK9txNrm2Q0aiyCl9bunSHD4CAh67Qns43saehDMIljd13yu4712wUDidpkH/yOF93qbxLPAfsmHdqPyEpZnYFp2mmqYNv20LVIb/A9BxH/C6LW8XxlBAJXUhsIkLwbwc0FgmtI4IOQj+mVzpzyN/B0JPlnFBuZ/RG0dibWmK7x4eVcE3B6g==
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
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
---
 drivers/gpu/drm/drm_pagemap.c | 38 ++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 308c14291eba..af2c8f4da00e 100644
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


