Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 546B2C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 19:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 462FF6B0098; Wed,  5 Aug 2026 15:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ECB56B0099; Wed,  5 Aug 2026 15:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302B36B009B; Wed,  5 Aug 2026 15:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D94306B0098
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:35:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5843940555
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:35:50 +0000 (UTC)
X-FDA: 85068220860.05.02951F3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf16.hostedemail.com (Postfix) with ESMTP id 332B7180009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:35:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z6N+BKih;
	spf=pass (imf16.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785958548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6Zyj8jHfIKyngPmJwXUGOkXTUqQFxaRbqiTg6IGN9k=;
	b=CqHxYnsrsF01qgyV9QgzI20nElC6gw2hyn0/CKnjHuUqHxtycm7gFpxQdys7DYpzKMrzLQ
	uBTwo9sYZm/tnT3/v5VKPagOlPy4tidNIHghelVVVsSRuRQUX14hNeeSE2ztqm6kYoQPTw
	64apAJE1Dyce+mPb73DNv6d9LG1Y/Yg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z6N+BKih;
	spf=pass (imf16.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785958548;
	b=QlR3s45Qw2Quct0v4zYA1L1Q7L2YvD6qeQdqVMlJztYzdsgH1a+NGa4qIzXfZpaBi3TjLJ
	clpIdQJ+k50tTIMhhBP1JxodsXn7qHFp6N+rTge0gDlk3Kk/XGHG7k1fDZSuCXzW10TtTM
	010BJILYzFZq3snlANWYfRLhAyQlrN8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785958548; x=1817494548;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QYVG22Ril2YRFp2fcAJ/FBSXr0ANtT+bhitFTakpD74=;
  b=Z6N+BKihBDjBzkAFKKZcFYhSv5prxQRMsSIqQQhUNuY8/8uNW0nfLf0Y
   gTXVmuXOluBUL14VYbd8yP4gi+nktVatcRSyWqjr/qVa7PW5H3xsq7QWs
   +BDkwNskEtbzFhcvDeVCFR/Vc5bMJb1+o9+5oMDfDja6evHdIp2pd72fv
   XYoKkMGmeyh0r1qobYUjV6i9nN3FuQvMVSRsutJZhLkCj3uAzsNeN+qaL
   6zCDmRvYrlDKcmvXe/6xfjGPqCdKkVqGD7zDlLVcYAPZlFXhQBv0a7aAL
   Ocf1blVBco6Ow+bXspoQZt1YsSY08nFM8V517H3I8yz2wWqvC8CuohRWS
   w==;
X-CSE-ConnectionGUID: L7Bx3YjfRMek52mDLpjLsA==
X-CSE-MsgGUID: A0f2BdKiQmGNeMrwrHOtkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="109332981"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="109332981"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 12:35:45 -0700
X-CSE-ConnectionGUID: /fGuctSQS9q21fF+FOoZZg==
X-CSE-MsgGUID: 9KQEbQ3VSVe6d7wvAWHz2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="285263536"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 12:35:44 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH v2 5/5] drm/pagemap: Add fault injection for higher-order RAM folio allocation
Date: Wed,  5 Aug 2026 12:35:36 -0700
Message-Id: <20260805193536.3756457-6-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260805193536.3756457-1-matthew.brost@intel.com>
References: <20260805193536.3756457-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 189yjeguuei8akf3q9q7763znenppfgy
X-Rspamd-Queue-Id: 332B7180009
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785958548-370604
X-HE-Meta: U2FsdGVkX19ZaO5YuH2rwxLJpi41QiwUh/4zw1YN1nftxZIfz+SBlBNN9kbuY9EugOQuMCp6hI5z3k5+fWJd3VgnDiZuNG38a1W+ckoW2tyKFbWZ+1uixLMlO1pDTA1WYuUZD18NbVm7bWE+ZmUMMy5C/5G27/K+LOzV75IzBq6nxmlg/5Bs+30//1kAhpWIHmkMMIYRWd7oAlItYDnWvxsWW4QYVJ/M0V5RqoifiRPWmQwzDsAQfz/Pip7DfBXqaChbvScjYXsOLoLdcUd67nPMPlXjONpDcf+KdH2xrs5OUv4s4d5pamkuMUBxWzmbnR87IKTg43dyWgGXiqqAREzY9HGbnjHKOOo8ynSBqu7X6mXR1QnzPTbLFqbJI15Qx5o9CNqJ20b/qBZMCX/uW7VBfY2B9UfqKlilZhFB4pqBTp9L/nFVCTCKk+33sPsZbQyMX94Qa2Szgg9EKL9YFmTXATenaJp7LhfjA7mMx2YUwl4oShqxmB73BYXyS8As9XKJ/C9ipxMpf9nyN+PCuQCzGdU2DdX5bUJS8quvgXnAW+QY/zbdzIwOR3enmRSvetdxUlUOHQfFudvwVJbMdTbIEFyS/BYFpNZpUEKB7JI7TSwmUCFxsMLoXr1t5Bk2Co4k6YPYEP2c7sulpRjh8g4m2EG24sv9c0uKBv2fw6uWplKH7S40qSlb3ZOW3hr0puY8gNqVnX8HfwjzNLG7yN25diX5PGkLJHid98t7M+BgUje0GgGKvigArCcdjKsY2N55kX931mS2MgcMuEKM2xU68gLUYFyTuUo/gDPOegwh5tCu9Xo3jv9aqyiAm3hMNN9HsredNB5GUBdOYloxTI5NdlfXxYC4RipudGY60bk6r04FJMgP8XDzl9yVDbiyjreNDmQsnxp8WO0YkWJO/+ywXTyzVXFKVo7G/yME177/8nf7wKrIJZ3vc7plUP0xqhicPb4YzzxQ+XEPuAi
 96pDc/yM
 BjbJtRfNZva+dpfq8y4x1KyBuQ8oVI/C1A7V4rhbETzgVRk/r191AC3Ks1vl8TLoGiaVM1xIB1yZDrLDLKfyCBlSjgTRIlXiJgaO3N/MAHNm78XaYWZORPUpmcjdOtTXNpcDaUNIIpXrQiABrTd6ZDcQgpb5iiwEPfKc26mYs9Z59IycX1dKP+4Ek8hAxkelx4bCyv5MhXxVB9QEpqJz8KcIsHBzelp3HHbzD8QebYyPpBMh5MRZ/WCerr9iBgBHoXogedIo+bvLDv6deue/gjZnEz9+MVEBSBvxr9b/BCwioZXKy+qzFPpN3u9iKNV7gDNKZys94BOQXOKHqf/YaXuWeoDQC9QkSsnPZRs2vMgWlQL7sEaNxZ/Oink1emZC7SUA3PIXxlm8BtJgThKcWNj1OeA0rV1XDhbh29Y6g0SEHdZ6ZWZWDpn8T8uADvgMvPfUQjdS8BN2cRCvjn3/2yhonosjpvARzVKLKBckKZ6b7Wej47EDxwY8v2W4pxT8Fsa8A0Vb0bJ1q7vsF3hwOViSULxX6hE0coE3zGuPxz5mOQO8R3AD3ArYxJdk3l+iI1ZehmZo1l7jLItInFl1Mjd7EuY0RFTH5WBJlYgwR1Ip0K86Wjq7N5eX3pNg60iJfoom6MushLGU421K6witC4mPwzErLlZA3jUD0b/V+HMmE8fk2y3uld39atlgbqArp6erKtiP9dcWCXXKKmzPzqFCqY6mVjhGrC8BR9J8S4uBwIA34HZWz8iSIiQDdjaMiq5FAuIfSVUjPJyLIdl5a/oO2GWfvbEUlol7W+AS11+rdEdivmj+AJkeDGosQI2hft9/v+U9D1OHRGXRPemYesY97KkPeHYnUg97HkiG2lAdwRct0mAThvCKR5zpNUMggJEnjjHOAhsSw9vrJvFIvzN0z3belDTw30rvv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Migrating a device-private THP back to system memory has two distinct
paths in __migrate_device_pages(): the fast path where both source and
destination carry MIGRATE_PFN_COMPOUND, and the fallback path where the
destination could only be satisfied with order-0 folios and the source
THP therefore has to be split via migrate_vma_split_unmapped_folio().

The fallback path only triggers under genuine memory pressure, which
makes it both rare and awkward to reproduce, yet it is the path where
the interesting refcounting happens (the CPU fault holds an extra
reference on the device folio taken by do_huge_pmd_device_private()).

Add a fault_attr, modelled on backup_fault_inject in ttm_pool.c, that
forces the higher-order allocation in
drm_pagemap_migrate_populate_ram_pfn() to fail so the existing order-0
fallback is taken deterministically.

The attribute is exposed at /sys/kernel/debug/drm_pagemap_fault_inject
and requires CONFIG_FAULT_INJECTION_DEBUG_FS. With
CONFIG_FAULT_INJECTION disabled the helper compiles out to a constant
false and the injection has no cost.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Assisted-by: GitHub_Copilot:claude-opus-5
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 drivers/gpu/drm/drm_pagemap.c | 36 ++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 05eb7254028f..01c639da767c 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -3,6 +3,7 @@
  * Copyright © 2024-2025 Intel Corporation
  */
 
+#include <linux/debugfs.h>
 #include <linux/dma-fence.h>
 #include <linux/dma-mapping.h>
 #include <linux/migrate.h>
@@ -12,6 +13,27 @@
 #include <drm/drm_pagemap_util.h>
 #include <drm/drm_print.h>
 
+#ifdef CONFIG_FAULT_INJECTION
+#include <linux/fault-inject.h>
+static DECLARE_FAULT_ATTR(migrate_to_ram_fault_inject);
+
+/*
+ * Force a higher-order destination folio allocation to fail in
+ * drm_pagemap_migrate_populate_ram_pfn(), exercising the order-0 fallback
+ * (and, in turn, the THP split path in __migrate_device_pages()) without
+ * having to drive the system into actual memory pressure.
+ */
+static bool drm_pagemap_fault_inject_folio(void)
+{
+	return should_fail(&migrate_to_ram_fault_inject, 1);
+}
+#else
+static bool drm_pagemap_fault_inject_folio(void)
+{
+	return false;
+}
+#endif
+
 /**
  * DOC: Overview
  *
@@ -960,7 +982,9 @@ static int drm_pagemap_migrate_populate_ram_pfn(struct vm_area_struct *vas,
 		if (order)
 			gfp |= __GFP_NOWARN;
 
-		if (vas)
+		if (order && drm_pagemap_fault_inject_folio())
+			folio = NULL;
+		else if (vas)
 			folio = vma_alloc_folio(gfp, order, vas, addr);
 		else
 			folio = folio_alloc(gfp, order);
@@ -1554,6 +1578,16 @@ void drm_pagemap_destroy(struct drm_pagemap *dpagemap, bool is_atomic_or_reclaim
 		kfree(dpagemap);
 }
 
+static int __init drm_pagemap_module_init(void)
+{
+#if defined(CONFIG_DEBUG_FS) && defined(CONFIG_FAULT_INJECTION)
+	fault_create_debugfs_attr("drm_pagemap_fault_inject", NULL,
+				  &migrate_to_ram_fault_inject);
+#endif
+	return 0;
+}
+module_init(drm_pagemap_module_init);
+
 static void drm_pagemap_exit(void)
 {
 	flush_work(&drm_pagemap_work);
-- 
2.34.1


