Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A22C1C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62CDD6B0093; Wed,  5 Aug 2026 07:33:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DEE16B0096; Wed,  5 Aug 2026 07:33:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CCC56B0098; Wed,  5 Aug 2026 07:33:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 228CC6B0093
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:33:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A19FC1A0409
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:33:54 +0000 (UTC)
X-FDA: 85067006388.09.D12E5DF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4F638A0006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:33:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="g7UL/ha8";
	spf=pass (imf25.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785929632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YyGbWlehIUzdnv0oRsqm2MTBPiQL+SmzqxPEqJVSUxs=;
	b=xRLwjrNjDwdYQQ54IEQQ7tWH0aKKLduvotfUbwkidxfhkngzTnLM8EjwrcFw/ZUVL4vyOg
	7L8T16Nwmqoq0egMObG8zoneN8fd5cCy0myaoZzdewZiBl/X6Un1nJM8MUJmA5w37gQzn9
	y6C2iP7JyLHHctWtMTj84ffCkK5wOyc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785929632;
	b=EPdlU0NhYmLuf+UbCwiudoHBKLr+esLqmBvHK1SFD+qnKo4Tv0+Bo/uLx8AjSdq1qXNMj9
	NcdLyH3xJgrjLF2zjKZO+Ax8AECLecLmM1ZVHyuTkAnGUEBAoaVOT/TgPubGM0EuRpwkn7
	8LErVLC26yTUkyjcogyyjG5AQAz3L40=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="g7UL/ha8";
	spf=pass (imf25.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785929633; x=1817465633;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xRlcIXHSrwF2uzzkzRuCIueeNRYGGHl04MyQZjBITUE=;
  b=g7UL/ha8uK1p4cgejtbCGVcxKx6aC0rSIdGAjvFQsNchYdk/JMo0wqG2
   h9CNg5rmFLPUdjUGkjpA/x7qp13iqT8bzqbz/SqN8Hlb9LmivQjD9IPuM
   T16A1HdLmRglHnlIDTvqYK1c5peCPPQKVwwGIaEWd3OTTZa+mI52tqocO
   P22uM0i5mcWN8khvhc37442JFsvqUhPjWIbIcU6Qc0PnUeYNCm86HaYix
   k7nWRUT5BX1/io/Sg3n8to1nYBKPjCvJ+mEU7tKjM0JFLxwNmnUtotYH2
   DbDHBt0GhJZ+GEpqaFucLn1Y2K9pvJccdSWgSQjUYD+bZthOHlQjRcJWm
   Q==;
X-CSE-ConnectionGUID: UPzwA1t3Qpe7ZFCnCoqOlg==
X-CSE-MsgGUID: tk/8udxySFWKP2cHvXVPAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="86358216"
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="86358216"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 04:33:45 -0700
X-CSE-ConnectionGUID: 0VOchQ9WTgCogTvfZhN3EQ==
X-CSE-MsgGUID: LjdTZIqWRfKlmWbwkV99CQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="265289753"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 04:33:45 -0700
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
	Francois Dugast <francois.dugast@intel.com>,
	stable@vger.kernel.org
Subject: [PATCH 4/4] drm/pagemap: Add fault injection for higher-order RAM folio allocation
Date: Wed,  5 Aug 2026 04:33:38 -0700
Message-Id: <20260805113338.3742178-5-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260805113338.3742178-1-matthew.brost@intel.com>
References: <20260805113338.3742178-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4F638A0006
X-Stat-Signature: ezrpxu3gask4xnp4rftb5p31orio5kjg
X-Rspam-User: 
X-HE-Tag: 1785929632-314059
X-HE-Meta: U2FsdGVkX187yTuV3uma/Ag2FP8RjXTwGPvtxHHyE1Hxq7hYTVOauvJ0LIIYsCB3Yba+QkuAOOLeCzdMcr5rYkTA/y6Vi4npz1WfGQztc9ajfbVy6PxR8MwDR4dsEmf29LUm11Dcfvm00EJBcD14oV33j1PGXu44xyD6L8ZEj9m97XzxnhfZNHYemeICxAaKMEKIVFR1NIiUXz8MoppBnDuAF5CpQmnHAxt9Vltusa0c+/E5ajwm+hYd9wvz2xEmZFAXVYmmFKZ7Iz9axf90Y/eU05ouzVu/5WKdLuWIEaa4TRXWpHWuWz7q2ukQ9eymcrDXTOcHC4G2dA1jD+n3ts1p/KyB/jQ0iNDRtbJnlT3Mj21qHMlGRD5R6D0OHCBroNzBd4AYjS0BC0/BfPKaMFXtx924FRaszwdqFhKVR3+bE9uXIFBHBrrojIQv9CoMSE456REYvHpF5xQuPFdaToYakTkap9HIga0CkW135ub1aRXxGF05N5uCGD7UwAEZPZd2zKcYcAY+8VDlsj39394+GaT1RPv1XYF7mo+p8EEePaIqo5ZfZlL1MxQHeXCruPLoJgqCZrZd2YzDH69+D2VLGoVO4ceWFINbRPZCRPcHLr/Otgv+hdQjoGDyZiYXKtXKr7FB1jB80fLBMbGaCrzx3IfPcsg1xn0KeFYan+C/kIM0RG5fxB5RC8lrCs69X59VzznRrJ9JCv3b2OIJdye5Zk/1gbi/bYa8Rstv0I29IEBPKAysizWjacyAqu0bo8eOui7D8yFAlWpfI6kVAvYdmvWcet3AFn0vI1vc36hrvd5wgg7EXPF0YxB+W7B7xr45qlBY5fPWYhgrqJyKE93jwTd6XHUC2VzFUcUOjdhWSkkbxLPmOJuEFu7yuJpRxAxCLo2GXNLjkU+EZGWAQueeKsp8QUtagNGH/CASIBf65jLx7dIvRF+7nnh3Mta7nwWWLBTsrXb4i2uVSx3
 nfAp524/
 uWTc70zK5VZZGtzRatuM8ZogLcQjs7RRYlNI91B0zBQBcz6Y07xAYWssRdt3bZIvtFJLa7RMEaIDrkdU0N6d2RHDSvSbH1e5VyiQ6HV25dDhnmSnspSTQtsMo3el5gwwD4BN0h3GUSiXEWCWIydZHl5h9TNsY3wp8pRsi+TvtjtI39i258c+k8xy6PwTkkKLMvEH69y/kCGPVPp9hTQ/0XKzTSbjuuoAVP0Mz3OAtLvqoLP8oGI92eQph3o2sbqvLGeI9esKINC9cXqfOTVMfo65uELtMG2fIt8KE8vwPifrnISobtbrX2Etcuu0Ef8Gsq2rmoIzwicf8N+9A1byCeIE1CQW3nm6T4PwGdKRm1DN1AwogMNpGkiLh0xANleekHWjXO89vqXEbvU2RTB6luwFVc5Duisf4JUY4Yp5Qgt/+zEAYx5QlkyQ6S5CHPQhgUbOtdJwwuoJeKgj+zf0uvey9CFWG6R4RI6YJ4VKHQRuQElFgSY5Hs3XtCFEQeKQ0T5/mFGZT/oCbHYXRP1GZCLSvvh9Vk2VdKKgZ9QpgFhnq2v9U6j2UKDLPmVJtulftOe/v8azRY7WkwFJ8herHc9h8lHYtaCd9qfYaQxfmUc4W5ulsvc8/MzrnDK7bfNV25jAyiN+sSzgjVRTKjivkmopreGTQQETCa18c/zsnsu5G+hjL0BvRwWw81+fepTLs+5RmifHGZGU0Bx1SXT3mjp1g7TquII0Vf4EXO65Fe1uTid3FGO7kn1+0vyAftyxo4RXFNRneFfc/zV+0ODe2NfPdQkfwlufWsZcnhac33iNNea8=
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
Cc: stable@vger.kernel.org
Assisted-by: GitHub Copilot:claude-opus-5
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 drivers/gpu/drm/drm_pagemap.c | 36 ++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 7610e233d238..01eb29ef023c 100644
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
@@ -946,7 +968,9 @@ static int drm_pagemap_migrate_populate_ram_pfn(struct vm_area_struct *vas,
 		if (order)
 			gfp |= __GFP_NOWARN;
 
-		if (vas)
+		if (order && drm_pagemap_fault_inject_folio())
+			folio = NULL;
+		else if (vas)
 			folio = vma_alloc_folio(gfp, order, vas, addr);
 		else
 			folio = folio_alloc(gfp, order);
@@ -1540,6 +1564,16 @@ void drm_pagemap_destroy(struct drm_pagemap *dpagemap, bool is_atomic_or_reclaim
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


