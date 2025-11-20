Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16713CF9C72
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 17:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666026B0005; Thu, 20 Nov 2025 12:05:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63DCD6B0098; Thu, 20 Nov 2025 12:05:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57C9D6B0099; Thu, 20 Nov 2025 12:05:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 46F316B0005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:05:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C100588541
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:05:29 +0000 (UTC)
X-FDA: 84131611578.21.F7BC392
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2DEE320013
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:05:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="MqING/AM";
	spf=pass (imf03.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763658327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=E9ip36rubT+CVrDml5ch1XI3NtiGWW9mBTpvkIZg71Q=;
	b=b1XACCe/p0PiqoNgfH7opoiZJa+EVccIrWNOSP8yBUGxxE2jWHQxBbU/LaPLPqywtLnBP6
	7u0pqGNaWqm78AlQFSwQIrndkVzzG9ngUs0a382v5iMXw3yLnVB1sLbTrs9HDh59urMOXe
	xGWdN6ZNJqqp6gHv2v03fmdpgVaIQAg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="MqING/AM";
	spf=pass (imf03.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763658327; a=rsa-sha256;
	cv=none;
	b=UVXg3ZJQURLgaxbcxUv0PcWrNHUeHMEApbet3pxZuhNjZ9P4GqXCoJt7wux027ZYVfSU/j
	4qumdcGEIHkNzXCPSxQ4ds1FVG+IPDomQluYvihjv8ZTXdkbHbcndsqWBIQzmxMtvNo3bZ
	OqzL9ijjNEQIRIGV/LAnpMVd3eXuIZc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763658328; x=1795194328;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0P+F2Tg0fn+MXjgxnMgiCiFpy4TcG5e/HDS82IiOpjI=;
  b=MqING/AMNhjRxWb4Nf0P3tQ9SvUnvU4k52aTC2P3aAx2+LjnxfCO70EK
   rmhSLYoIN8skLEuTT8rF7atowW61WwjzkG6w8UWgZELeWLQW4ap2lvBJE
   7P/3ivT+Yk/xXnFMQBSKvp9yR668KBhFlvKWkhymF1RkDWI5Oe7OpHafR
   CQnJkHlqHV+kqGCMobOGOeEYpp+98N30wfzeD1E1muwBYNjx7IGsmGb+s
   Mbv97+LnnfFg9wAEBElR1rvY3WnSWXb9QjyE1BB2cTFExYaJdiPnlaS71
   18FmWe19/q0vSlO4InlgcOun6FQv+1hu1Bl5uBVEmCk49iaxfrEWUH5M1
   w==;
X-CSE-ConnectionGUID: q0EHat/nSE2qjA5lIR8MgA==
X-CSE-MsgGUID: NhCTuBC4TSOUV6NbSV8B6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="77205138"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="77205138"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 09:05:26 -0800
X-CSE-ConnectionGUID: d67znad0TziXigjrOBwcAQ==
X-CSE-MsgGUID: SxjtGamwQXaoMQ8AZZezmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="190710630"
Received: from lstrano-desk.jf.intel.com ([10.54.39.91])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 09:05:25 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Balbir Singh <balbirs@nvidia.com>
Subject: [PATCH] fixup: mm/migrate_device: handle partially mapped folios during
Date: Thu, 20 Nov 2025 09:05:15 -0800
Message-Id: <20251120170515.46504-1-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2DEE320013
X-Stat-Signature: 6158z77hxwa7jj9gxm64kzd8n467j9x8
X-Rspam-User: 
X-HE-Tag: 1763658326-946594
X-HE-Meta: U2FsdGVkX1/V+meWdzfvXRL5Wse2u/qSlGPyYkrEK/57DBzISOwp3+sWm3vQJ6z91Qg6k762Jf+hQgblPalnZNi9GvEErVYcxxzEcApFBgiOyn9dYAs8TkNEM6CZOwmUBIIJGZDvQszQNk3+302lihfZMnAs1xrwmBkm1bW9RJgBi3hG3vD3+sWkh6Yb3WIcSnQA/CDAdpxFJW3jQyWTXDT0IeU9uo+DgZbfRHhOYeZLOxrhpGDrj/10WPJDaZDoVXpT0SVilyAJtomzJOjipoVp5f9ZxT2X35yMzUxz3ybox7ZLyGr0E/Kgm73i80E72y6STGpxNp9IeoEqoPDcIIBL5B/5RS3PVZAlcCJdgOd5arr2oInfVMLg2C2oLvoUDzFxQ2qgL+heC9wORMN2mOGW2ruBWe5JseWrtLfUkW503R0andNmON/J6kjKF2d66JmknJkto6HMzPIt5HEPUw6VEOqCRp3Ww1y49c9W3awxx6+p2nDta/acap8ZvBdpf5k1SSqfG8Mm4kIisGbpv3Vcrk3B+Cam0hL9owwFop8bBHckuGJkyvaO2nvCP4BiW+eEvLUqKb3dE4L9H6b9eTI8AmoK8vs0QRhXE976UsBnyK4n6lwnb0UQ/RhD0RgwROZqp6nJCaUPAk69xM3dGUPdgCilVl4XGbaZHjHwom6mWN3PKI12REVQ/L362WGQCnUKVk/jlMMifDC3BioX5eGP1F8arxCZWkGXOP77Lp6uS+9G1gi/cRUwOkBciwoqU9hTLfXqCPjRARRDGV31hYXPWAUF4Weq+S35PvV0VdztzyRGHF8DYxQ6SbByKpEZ2p9UT0HmsYJgtRu6FYpdHIvjM++ClhPn50Dyx69xTeJuBym7w2Q3vjlEGFcg2jhGVOXWWk/gJVh8znIuPUV6WfPas0MJQisMPzGoi/ctlDT4V9M3nj0eF2ytem0C3BU3rUXj88vw9kgcKyXH9wW
 gec+ee1z
 QXejDAXPla1pbsoSVSo2pQ+3A4qnjcx8GQBqxrB2aXg4qcXxB7QCRwIyJCmKBDUtQ42SCoGxc+rB7fRgC74mkK92ejH0FJsG0EWBIHeK/cvbrNR/EEEDP3mykhsvxn86qAqn4geD2LQ8Mz6z/UcWE51KmMjly9VdFKtrpAszfkkYyOFqdlNSLCF+LvPBUCxdrx2PStXpc8JabMd88ZK5qm8zWTf7Tk7xXpTqFyljbdiEPiTLaxEbF5vGUMil71RxuB/7tBsfgXdLQKgsYulkqg5ae5W2OSLuvDs2ICSCLNkQjVt5gXp91MS/ZQnqjegiAhlmETidtsHfgYYbustUcDzUhWHtnRAhAmShSZsWmWP0ZC6kPrlQ10h91VGEB95ymy2iZDbliaGUkqx2YzRIqqxzkdDEhF4hTA8XIqm2k23EXrfTIHaEU97mzcA+Mt4vU7HgCWf0ngJJAYETMHklOdqCVOC7+qAqJzDJd/K6TQapOXqitmAsK2JsOikTaRFeWyqp8snRUnXtMgsSDvFROemjjwA4N32mOILCzOCYpF8oK6fRja9kmbfWDUiGZCIZUzCkvgfQcFEAYM3VEH15+4kOHCVMvBgZO7Iz05YFAzxLH6Vchbuil1L3udphAjG+48Rs8rK2QT6JoSLO6Lr21IUehvio3HZZenmw3FLnRx8od+Xth9gf0n1Fa22Gj56SWkgIQa5kgSIKmpk4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Splitting a partially mapped folio caused a regression in the Intel Xe
SVM test suite in the mremap section, resulting in the following stack
trace:

 NFO: task kworker/u65:2:1642 blocked for more than 30 seconds.
[  212.624286]       Tainted: G S      W           6.18.0-rc6-xe+ #1719
[  212.638288] Workqueue: xe_page_fault_work_queue xe_pagefault_queue_work [xe]
[  212.638323] Call Trace:
[  212.638324]  <TASK>
[  212.638325]  __schedule+0x4b0/0x990
[  212.638330]  schedule+0x22/0xd0
[  212.638331]  io_schedule+0x41/0x60
[  212.638333]  migration_entry_wait_on_locked+0x1d8/0x2d0
[  212.638336]  ? __pfx_wake_page_function+0x10/0x10
[  212.638339]  migration_entry_wait+0xd2/0xe0
[  212.638341]  hmm_vma_walk_pmd+0x7c9/0x8d0
[  212.638343]  walk_pgd_range+0x51d/0xa40
[  212.638345]  __walk_page_range+0x75/0x1e0
[  212.638347]  walk_page_range_mm+0x138/0x1f0
[  212.638349]  hmm_range_fault+0x59/0xa0
[  212.638351]  drm_gpusvm_get_pages+0x194/0x7b0 [drm_gpusvm_helper]
[  212.638354]  drm_gpusvm_range_get_pages+0x2d/0x40 [drm_gpusvm_helper]
[  212.638355]  __xe_svm_handle_pagefault+0x259/0x900 [xe]
[  212.638375]  ? update_load_avg+0x7f/0x6c0
[  212.638377]  ? update_curr+0x13d/0x170
[  212.638379]  xe_svm_handle_pagefault+0x37/0x90 [xe]
[  212.638396]  xe_pagefault_queue_work+0x2da/0x3c0 [xe]
[  212.638420]  process_one_work+0x16e/0x2e0
[  212.638422]  worker_thread+0x284/0x410
[  212.638423]  ? __pfx_worker_thread+0x10/0x10
[  212.638425]  kthread+0xec/0x210
[  212.638427]  ? __pfx_kthread+0x10/0x10
[  212.638428]  ? __pfx_kthread+0x10/0x10
[  212.638430]  ret_from_fork+0xbd/0x100
[  212.638433]  ? __pfx_kthread+0x10/0x10
[  212.638434]  ret_from_fork_asm+0x1a/0x30
[  212.638436]  </TASK>

The issue appears to be that migration PTEs are not properly removed
after a split.

This change refactors the code to perform the split in a slightly
different manner while retaining the original patch’s intent. With this
update, the Intel Xe SVM test suite fully passes.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>

---
This fixup should be squashed into the patch "mm/migrate_device: handle
partially mapped folios during" in mm/mm-unstable

I replaced the original patch with a local patch I authored a while back
that solves the same problem but uses a different code structure. The
failing test case—only available on an Xe driver—passes with this patch.
I can attempt to fix up the original patch within its structure if
that’s preferred.
---
 mm/migrate_device.c | 42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index fa42d2ebd024..69e88f4a2563 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -254,6 +254,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 	spinlock_t *ptl;
 	struct folio *fault_folio = migrate->fault_page ?
 		page_folio(migrate->fault_page) : NULL;
+	struct folio *split_folio = NULL;
 	pte_t *ptep;
 
 again:
@@ -266,10 +267,11 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			return 0;
 	}
 
-	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
 	if (!ptep)
 		goto again;
 	arch_enter_lazy_mmu_mode();
+	ptep += (addr - start) / PAGE_SIZE;
 
 	for (; addr < end; addr += PAGE_SIZE, ptep++) {
 		struct dev_pagemap *pgmap;
@@ -347,22 +349,6 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 					pgmap->owner != migrate->pgmap_owner)
 					goto next;
 			}
-			folio = page ? page_folio(page) : NULL;
-			if (folio && folio_test_large(folio)) {
-				int ret;
-
-				pte_unmap_unlock(ptep, ptl);
-				ret = migrate_vma_split_folio(folio,
-							  migrate->fault_page);
-
-				if (ret) {
-					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
-					goto next;
-				}
-
-				addr = start;
-				goto again;
-			}
 			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
 			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
 		}
@@ -400,6 +386,11 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			bool anon_exclusive;
 			pte_t swp_pte;
 
+			if (folio_order(folio)) {
+				split_folio = folio;
+				goto split;
+			}
+
 			flush_cache_page(vma, addr, pte_pfn(pte));
 			anon_exclusive = folio_test_anon(folio) &&
 					  PageAnonExclusive(page);
@@ -478,8 +469,23 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 	if (unmapped)
 		flush_tlb_range(walk->vma, start, end);
 
+split:
 	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(ptep - 1, ptl);
+	pte_unmap_unlock(ptep - 1 + !!split_folio, ptl);
+
+	if (split_folio) {
+		int ret;
+
+		ret = split_folio(split_folio);
+		if (fault_folio != split_folio)
+			folio_unlock(split_folio);
+		folio_put(split_folio);
+		if (ret)
+			return migrate_vma_collect_skip(addr, end, walk);
+
+		split_folio = NULL;
+		goto again;
+	}
 
 	return 0;
 }
-- 
2.34.1


