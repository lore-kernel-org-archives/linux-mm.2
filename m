Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D53DC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 23:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE02A6B0093; Wed,  5 Aug 2026 19:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6A56B0095; Wed,  5 Aug 2026 19:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E436B0096; Wed,  5 Aug 2026 19:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 806DF6B0093
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:10:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB435A052F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:10:57 +0000 (UTC)
X-FDA: 85068762954.03.0CE15D8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9402340002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:10:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MHFl3VwX;
	spf=pass (imf11.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785971455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5tWoyXH5IwDrcMy+oPeVQieBozDA3geoCdyfsWWrJi0=;
	b=qWu9ppUNsieUib1wGQYLUFzzv5E8+6EpOUrZd6K89H9Sqv9CDnE9xRhO+ssrfHW88H7bcc
	hZBkLtSZV3d17fUluZkkwvEkt8HXUpiG2aa+R4KxnHvAUiXf3q2NKnpiZjr0bWnAO3tMZa
	VmaW22uN6GIbQdBUoIw6jxKraWv4FOA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785971455;
	b=V7+O1QzdzyYO9oQ4RviydNUMJX8YyD3TWCuk9U7MC+GWKCMZiAnjPO00RrMyWj4sZgU4Fo
	yKsl7h6ZDn4Q5ZKHmqfe6Yhi88zSASqN/13dvz71GlaFuRIuDX38rMfSgA2S4J0zIws3YE
	Ca+AO1cn16eLg5/E3sONsVl8xn8HDAA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MHFl3VwX;
	spf=pass (imf11.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785971455; x=1817507455;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NZLOXaen9jDVMjpnEaM9wnAKmSoircGZzGky2M1Tvb0=;
  b=MHFl3VwXmfmrqRNuD5pS+6Tghg9kgGZS1DqDdG8Fy99of5118li++iK0
   y64EpA067BmC/sZ/yFeJ4eE8xPbI8cxUEoeUOBS1MplkwjvlSxMlIiYFF
   GR+M/kVJDFmtDkZMP/lEmBOGMz+npjkb661nzqltTkpiEVEzog1bv+EtX
   UeIoKtdPbbwjlcTijV22R34fBw6sX6/YyhESYaHB/O9xQXH70FCZYhqkI
   J4IStgoZ1RozMmVnYB+L0PtckjGtOrZXtgNQpUDDo+6+xp0QsejmhRPUT
   lo1Ch3ZozL2OYkdlZukW2zEvB7EAfs+GJhYxZJ+6Xs/mlP0LUnKaac+Qm
   A==;
X-CSE-ConnectionGUID: qZvMWjl+QeiRag5ENI+faA==
X-CSE-MsgGUID: Cm5BpnycRsCOPDGbVRO+zA==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="90376907"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="90376907"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 16:10:52 -0700
X-CSE-ConnectionGUID: Mu2CKANrRdOv2SSKNqnKZw==
X-CSE-MsgGUID: W3bcdhw1So+UvqvPffSiGw==
X-ExtLoop1: 1
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 16:10:51 -0700
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
Subject: [PATCH v3 6/6] drm/pagemap: Add fault injection for higher-order RAM folio allocation
Date: Wed,  5 Aug 2026 16:10:41 -0700
Message-Id: <20260805231041.3791771-7-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260805231041.3791771-1-matthew.brost@intel.com>
References: <20260805231041.3791771-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9402340002
X-Stat-Signature: e8ztgu6tiicckm1w3cybgeq9zienk31o
X-Rspam-User: 
X-HE-Tag: 1785971455-787889
X-HE-Meta: U2FsdGVkX18QBj8GNo9Dfngu1HDx3ykiT6xeMHHyZJYsDUFuQT3xwOQMiFoMJXIMfGod6sN0oqSh7XjUqaW2qS7crYSQdfxG/qkAq/f/sEbHwDmCWvvOnjiqPL2P7fvXZ66n2z8Hm1SZIHshDQ7eYEeBCZIUveFxDj+IJpxviLxWBki5m57oM9hsa5dlAbtHYOik5KhmqIYsRZwkv2+/OGbbP1LBThmyzRZ/kMw7m0OpFu/RRymJE9JQKDFVgrk3+Ar1r4CznFRApnFOKayWnx6aSStWSsr53LUg0EHHpOGgfZ3e/PHYAiVPolWHWy1k/xFBlvFOt8yCHMKXFRmacMDpjGZUohN5Yr8O+1oqh32h8lwePmAHHiexuh60miLr2XRHFslQ9eH1Yl5zt5zUqnhu1th18r17b7NSipE8PGFnYw5nuHGneHZ4nnR5nly1T3umzuyXhwNPq0eGYC78M9ZixXnqQU+tunA4Mt30EUQ5Lmjv1m0cogHEirQeL2S38ft1ZmH3Z9tpXKRGTiMdvhxz74mc2XfVDTwe5C9lOM2jxO8NC4Rq9uR/R0nSc8JnsssV0Y95agbENzIL3ggGevrn2gnHqPf6KaaoLxSnDUMTHDINRx8/FjUmT83Cw2jYna99X/X1ZDBXyoNqvQMCmPUDFlfLANmy6spdgcfcguVsiw73+QkLd1JpL9o8/uEQUEEEePJ1wHeUzYPM6Nt0GIaawJkXpxE5gpazWkuxQuUpheHbXYw3qeE2JYkY03IrqhmU3qTaSoB6Am2VWlWAZykzt4BLmJPh9zAuSF5pkIw4c6kG/V7OVguXLdQU7rwQKoWqGqQtwy5ref7BCZdVtX/VeB2nWqzYA7VutoHiN5tunQ2+3M+GCT3K3jeIEFaDpFKWMDkwllWBlS2dzZ1wDvuZ9yYOoa0mtGCCD5vBbnibARg9NSASJLhyCCV0eWJGpHjOIOzJOQpcOet6BCF
 DTKnGKoL
 onW+jEMa5Nd2jINLan5n+psIanPBA373K2JMRps+QDjr6U5FosTK1jtI9uI+7Qe9KMOZynERmCzENYr93dvRspiWqLbrjVeZCOdp1lhTcvsIafxI15lvLj8Y+zPOlVGMMTCK0Sley0fMr8aosWrDgbjylRCXAtJxDTay7+p+eH1P2qJstciEIpU7UvKS9qBEJ4IsENp/51XN8Zc1inmBg58S0QKP7yy1CI5yLY8RMPQuE5AT7t+W2sz2BzwYH4D7z8g1HmrrsxmbrRQt5K81ahR1EMr26ge3ySIKH7Ej20bwZuFeH07nwqzTlPAHde4qCohPn03X7OebPpASVyQUiFAlsPANh3NVUl669yCtNiK/cMNDZOd9mVcqSroOlS/xFkkokaWskYdH+eoGCDuCc1RqBtbXgTs4V5e37xLXpNPSm3azQYWYtIrkoGPa997JIrh4aLNWVRygcsPmDwXbc3oPxqreN0rRzRSBa9dmwahzwhC2aRZO2LPtDwWFxJ4QT3CbGrKkollRPHwLIigfX4iAgS03Ay5k5VPG/tvO6JaNy65zVskH1VstXwwfcn+59GRk72+rq9GkMMDColBQsmpk1GKYX3SLaanR3wkfMTOhcwFAVNT3kh+pduT2AAcOra7tJzzUmmOxBW3V1Xp52suGIu2EF5LkFCJ0yNUm8dYeLucgW2rEK6lQZz4MmtFFLAWYULaBLdvT/UFpod4kyE6BhsKBGInxYbDC97gSl1rG5Z+exE3RID/KGe+QdgTI1ztKAC9qMq9BtSB7yMnotjChyBp0yPwZM9aF1WLEaCYM15nqNX7kK7iEaQwgiJSlCsvtTlo8+Rx5pkRMnj8S+FGFxSoDu4InMT9+ovxFZA9H6Sgu9ke/0zti+JaynYkaiwrcQEz1jKu6cn2gOK9hb+QhgJuSElggOJ6k2
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
index 51c6f12e4256..6ae8c9aa36cc 100644
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


