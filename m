Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FB5CC56208
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4877F6B0088; Wed,  5 Aug 2026 07:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42FAE6B008A; Wed,  5 Aug 2026 07:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F0B6B0092; Wed,  5 Aug 2026 07:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0014A6B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:33:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 87F7B12042E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:33:49 +0000 (UTC)
X-FDA: 85067006178.05.2B0830B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf25.hostedemail.com (Postfix) with ESMTP id 33291A0006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:33:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hZkzHtLQ;
	spf=pass (imf25.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785929627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y4uwfR3GklRQiRMIczoF+4+/ivpNY9OMfXoC7zxxmqA=;
	b=dBj+LrP2PC5X9MB/jDEBwn39zCmlE0HX3AHODJbP1mPVxrVU72p4lfwrP8c4CLWH8LnI5r
	8FfgfeWBg+6a8G1JjzUYYHoE8hmlMA1Z5ROInxvauHp/0ED3m/gt7Dcl2bnEZKBfL+oyp8
	CU2Z7m1eVDMKskW43TdQK7n3ymPQVlc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785929627;
	b=lHFkTxk0FFxDV33BO+NORQYpO9D5xm9Pfd4PPisYCr6dGlrujVxSCA+W25RsG/DlV5GU8C
	s8tUlPzrjqf+DHV1X6il0rgexIFVWuzPhkqpfXVvtwDnqqRKiFF+Chim5g4QTq6ynrzVYH
	mc14oiwy1s0g0C6UccsYPIhGCigPqWY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hZkzHtLQ;
	spf=pass (imf25.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785929627; x=1817465627;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3lWJYMs3nbBFgdmv4/bZs0/V4ibefvqdyoqjZL6QD24=;
  b=hZkzHtLQuFn+oJoW6diYbc4mekFzOpjOGMpnKgEV9MPWuOfG0ZYKACRi
   bozL4KOJ17ah6K3fusqISwzsV2CuHGNZbG71L41xcyZ6TbxXBPhSzSg/t
   ysih0jUkuzzTPOO5qZgZ/oYgB95+Hx7sDToc7/FxJdQRL2ZUUyMdq0QQI
   NKnubVD/0YKeUncW0XSnCcrVbMmqQwDT8tTJSOzr2Ie6DAPx0zlcelObX
   FWJmK0yC5XnFPa7CEwrrEs5vM/Ebws5wka4sXX27G33O4YXYTevKKTTyT
   EszWOKwpbx0CiOk/8EA4lKJp0+w3D3Nh4dE4B1gkYYJKd4enRJ5ttJ+Ot
   g==;
X-CSE-ConnectionGUID: CZH0eN8NSUGrqXE5m/zwLA==
X-CSE-MsgGUID: nBQ9TFmRTDOd9fYCNNQz7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="86358167"
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="86358167"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 04:33:44 -0700
X-CSE-ConnectionGUID: 8qTpyZacQ5ylK+ugbK5C3Q==
X-CSE-MsgGUID: s8apNhHaQTGF25KG/UCxNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="265289744"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 04:33:44 -0700
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
Subject: [PATCH 1/4] mm/migrate_device: Fix THP splitting of a CPU faulted device private folio
Date: Wed,  5 Aug 2026 04:33:35 -0700
Message-Id: <20260805113338.3742178-2-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260805113338.3742178-1-matthew.brost@intel.com>
References: <20260805113338.3742178-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 33291A0006
X-Stat-Signature: 754u6zi4iwmy35w9r6f8z1913jm4wcqo
X-Rspam-User: 
X-HE-Tag: 1785929625-221304
X-HE-Meta: U2FsdGVkX1/05q4FxI7Qf221G3aVi4gnmbF3DuLjBuaApkt832tWX7Ue4sEHanhRKGmyJqXJpqzIf5uJUXOHshoM1gX4ynShZiunyHr8dNj7N6J/gGcjFWspC2J1n1lIsuT7eVH3Hu+aPQ5ZTNHK9+F0iZuMy08mjkdD4fznWFA06rRaKuot1RO8CZ+6g9KfLwggaq34aj3sCwt5hjZE9kaOw8y7SPIJnben/uFdt39IPOPEeyf6uaKioshNb5uRNMMbZWy9P8IRGJGROd6N4g+8nS8XP2ab5Nxee81i6XXxoQUBEr49hO70amfSzefCScu+u6sSembu3XE2W1AzzxNTegYN63VJh6tlyWc3ZcC4LZ5DJP+Arc8M3vP8Ubfi/DpO3SwYGm6oHhK3K02QCRjoW5neFH1vfmE7Q3eSnPY8gdBT/ra3VnJY8AK1xWBVOIyw32KuavQKv8sZO6npa2CdgcZMjGgtl7WZwA/pIy3RbRKhNvlg7VMlAsivbLEQAv7DKd1O/FIRZV5zLrXS2+s8xT092DGmj9dR9cLGVsHaR61Iu6r+OYi3aVuEMCZBTHkUSbaybNXn+gE0AnDl8djVk8HOGvhsW9GLar2WxS9DKj1h3+H8wRyvNdXGbtTHLunLzllzVN3fYxU3sJYGeAyw4sPasyebAU9tOruQ4OqJnrLjVtRN0Dzk1ZuYiYqCNGzgF944m3wgBfnjM9X6Cxncdpk9ueiF73tzF3kTW9UQj8q2Ryr18jEfGParxenDchuJpspEnRrIc+xwwGE2k0MCyex+886tK+octMXkHKN2gEY7qcpuB7xV4lBKeOsHfxk7P2LYUmF0/OHGW7z9X6LFr+YbHF7xTP58BspoBJgbwVF8NOA6daJkaVsMeDDTSu95Nr96Kt+GvI4mPkDDmcCmMcXpZY06nm6JdlKzkKQMofldpt8cvVl9nEmLC0i38c17r7PkqH09FIeze82
 KYp9eUv5
 EtsYteaYctM+rTYu7yeQN4cJTHJOVM6Ej6xLUr0NEbkwFJ5/nnk0oyU5hL6ajIro+pYQDY3pHqM/HS1Umj6DgVE2izRa7j5dwKjGc39yhf9Jo/stT64AEvwB4JtiPCSC3BvaW7705NQRYZT+Ghd5onhWqnGPlP91eUIRNt5Z1I4RbqsRQHgp/N8NuHJHPqYxER7DiHYGp13lhaxOFSI6pfNU2ZlxnUJnh5FVSsOFoVZ8HPbLQeZ0q6xsJBdwXHA4aZGMxq07WS6rfw61BZIQ8t8mA5aVynqistXGyoaeNDkRrlUgUUxDgbg58ITMcG7Hu24O3OM4C5+3nia9LEBm5HDdp2ckfmPFu9ZZ6FPeczrNzyGIY2qKTjWfHRFUsBZricNOpo5z+OJa9kqd2IieHXNKBZg3VVViKUcYK9PQu1kxNduSPhVdONwLbXeGM2IXfxs/0iGx3GTvPNa9/FbQ5L0M9cM0dQIa/4QT1KxJPSxF5y/IuDiaNh0TZrFSkkvW4bBmuiHDHSgWzCzgMGGRMy0SZe6fw53SQbCKmAD31oYZQo+QZpO7TWvwudfJ1/nDyLKZQC1pi62vIz65JnQBLGpnQGXVtybyCkETHUa/RMV6e3AdzeRZlZ7DTmQEwGkrbVPH/Z0a96g4azBy2A996RlTDCvADGj8ZzkB7nAe9GEoncfCxkeetiOmEKZSVPkTevHmJxM27juqN0vydl7JYOVFn0ZOEnEuhepSIhsofW3I8w0lYcAIcabukonzHp/EHqRSu6ZP2fkUmKpRRMWacvZqzyYT7I++3Xt2ygKDfm81qcEz31dIAs3+l3Cz6d2xifEHwJVfayHR454o4UMoH+4BmWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a CPU faults on a device private PMD and the device driver can only
allocate order-0 destination folios, __migrate_device_pages() has to
split the source THP via migrate_vma_split_unmapped_folio(). That path
is broken in two independent ways when the fault is what triggered the
migration.

First, the split never succeeds. At the point folio_split_unmapped() is
called the folio carries two references beyond the ones it is
entitled to:

  1 - taken by do_huge_pmd_device_private() for the duration of the
      ->migrate_to_ram() callback
  2 - taken by migrate_vma_collect_huge_pmd() when the folio was
      collected

(the mapping reference having been dropped by set_pmd_migration_entry()).

folio_split_unmapped() requires folio_expected_ref_count(folio) ==
folio_ref_count(folio) - 1, i.e. it tolerates exactly one caller
reference. With both of the above held the check sees 2 against an
expected 0 and returns -EAGAIN, so the migration is abandoned and the
CPU fault makes no progress.

The PTE-based split path does not have this problem:
migrate_vma_split_folio() is called before any collect reference is
taken and explicitly skips folio_get() for the fault folio, so the fault
reference is the single caller reference the split expects.

Fix it by dropping the fault reference across the split and re-taking it
afterwards. do_huge_pmd_device_private() derives the fault page from the
PMD entry, so it is always the head page of the folio and always ends up
in the head folio of an uniform split to order 0; re-taking the
reference on the folio therefore puts it back exactly where
do_huge_pmd_device_private() will release it. The folio cannot be freed
while the reference is dropped because the collect reference is still
held.

Second, the folio is split globally but the page tables were demoted
only locally:

	split_huge_pmd_address(migrate->vma, addr, true);
	ret = folio_split_unmapped(folio, 0);

migrate_device_unmap() unmaps via try_to_migrate(folio, 0), deliberately
without TTU_SPLIT_HUGE_PMD, so every VMA that PMD maps the folio is left
holding a PMD sized migration entry. A folio that was PMD mapped in more
than one VMA -- after fork(), for example -- therefore keeps huge
migration entries in all the other VMAs while only migrate->vma is
demoted.

folio_split_unmapped() does not notice: the folio is fully unmapped, so
it only looks at the refcount and happily splits to order 0. The other
VMAs are then left pointing a huge PMD at an order-0 folio, and
migrate_vma_finalize() -> remove_migration_ptes() walks into it:

  page dumped because: VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
                                       !folio_test_pmd_mappable(folio))
  kernel BUG at mm/migrate.c:368!
  RIP: 0010:remove_migration_pte+0x56a/0x9b0
  Call Trace:
   rmap_walk_anon+0xfc/0x260
   remove_migration_ptes+0x79/0xb0
   __migrate_device_finalize+0x113/0x290
   __drm_pagemap_migrate_to_ram+0x278/0x360 [drm_gpusvm_helper]
   drm_pagemap_migrate_to_ram+0x5c/0x80 [drm_gpusvm_helper]
   do_huge_pmd_device_private+0x160/0x280

Without CONFIG_DEBUG_VM the VM_BUG_ON_FOLIO() is compiled out and
remove_migration_pmd() installs a huge PMD pointing at an order-0 page
instead, along with add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR). The
victim mm then maps 2MB of address space onto a single 4K page, which
shows up later as bad rss-counter state, leaked page tables and page
allocator freelist corruption in unrelated processes.

Note this second problem was latent before the refcount fix above: the
split always failed, and the failed attempt left migrate->vma demoted,
so the retried fault took the PTE path, where __folio_split() unmaps
with TTU_SPLIT_HUGE_PMD and demotes every VMA.

Fix it by walking the rmap and demoting every PMD sized migration entry
mapping the folio before splitting it. Demote with freeze = false: entry
creation in __split_huge_pmd_locked() is dispatched on
pmd_is_migration_entry(), not on freeze, so a migration PMD becomes PTE
sized migration entries either way, and freeze only controls a trailing
put_page(). With freeze = false there is no refcount change at all,
which makes the demotion idempotent across N VMAs.

rmap_walk_control.anon_lock is deliberately left unset:
folio_lock_anon_vma_read() depends on folio_mapped(), and the folio is
already fully unmapped here. This mirrors remove_migration_ptes().

Finally, refuse the split for a folio that is not anonymous. The rmap
walk would otherwise reach a file backed VMA, where
split_huge_pmd_address() zaps the PMD instead of demoting it.

Fixes: 4265d67e405a ("mm/migrate_device: add THP splitting during migration")
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
 mm/migrate_device.c | 98 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 89 insertions(+), 9 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 908d2d4ec43a..d1d81bbbf795 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -899,22 +899,104 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 	return 0;
 }
 
+static bool migrate_vma_split_pmd_one(struct folio *folio,
+				      struct vm_area_struct *vma,
+				      unsigned long addr, void *arg)
+{
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
+
+	while (page_vma_mapped_walk(&pvmw)) {
+		if (pvmw.pte)
+			continue;
+
+		addr = pvmw.address;
+		page_vma_mapped_walk_done(&pvmw);
+
+		/*
+		 * Demote with freeze = false: the PMD already holds a
+		 * migration entry, so __split_huge_pmd_locked() creates PTE
+		 * sized migration entries from it and leaves the refcount
+		 * alone. There is at most one PMD mapping @folio per VMA, so
+		 * stop the walk here.
+		 */
+		split_huge_pmd_address(vma, addr, false);
+		break;
+	}
+
+	return true;
+}
+
+/*
+ * Demote every PMD sized migration entry that maps @folio to PTE sized ones.
+ *
+ * migrate_device_unmap() unmaps with try_to_migrate(folio, 0), i.e. without
+ * TTU_SPLIT_HUGE_PMD, so a folio that was PMD mapped in several VMAs -- after
+ * fork(), for instance -- ends up with a PMD sized migration entry in every one
+ * of them. folio_split_unmapped() below does not care, it only looks at the
+ * refcount, so splitting the folio without demoting all of those first would
+ * leave the other VMAs pointing a huge PMD at what is now an order-0 folio.
+ * remove_migration_ptes() trips over that in migrate_vma_finalize().
+ */
+static void migrate_vma_split_pmd_mappings(struct folio *folio)
+{
+	struct rmap_walk_control rwc = {
+		.rmap_one = migrate_vma_split_pmd_one,
+	};
+
+	/*
+	 * Do not pass .anon_lock: folio_lock_anon_vma_read() requires
+	 * folio_mapped(), and @folio is already fully unmapped here.
+	 */
+	rmap_walk(folio, &rwc);
+}
+
 static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
-					    unsigned long idx, unsigned long addr,
+					    unsigned long idx,
 					    struct folio *folio)
 {
 	unsigned long i;
 	unsigned long pfn;
 	unsigned long flags;
+	bool fault_folio;
 	int ret = 0;
 
 	/*
-	 * take a reference, since split_huge_pmd_address() with freeze = true
-	 * drops a reference at the end.
+	 * migrate_vma_split_pmd_mappings() walks the rmap, and
+	 * split_huge_pmd_address() zaps rather than demotes a PMD in a VMA that
+	 * is not anonymous. migrate_vma_collect_huge_pmd() does not check the
+	 * VMA type, so a file THP can reach here; the rest of the migrate_vma()
+	 * machinery only supports anonymous memory anyway.
 	 */
-	folio_get(folio);
-	split_huge_pmd_address(migrate->vma, addr, true);
+	if (!folio_test_anon(folio))
+		return -EINVAL;
+
+	/*
+	 * A CPU fault on a device private PMD holds an extra reference on the
+	 * folio, taken by do_huge_pmd_device_private(). folio_split_unmapped()
+	 * only tolerates a single caller reference, so the split would always
+	 * fail with -EAGAIN while this fault reference is held.
+	 *
+	 * do_huge_pmd_device_private() derives the fault page from the PMD
+	 * entry, so it is always the head page of @folio, and therefore always
+	 * ends up in the head folio after an uniform split to order 0. Drop
+	 * the reference across the split and re-take it on the head folio
+	 * afterwards, leaving the reference exactly where it is expected to be
+	 * released.
+	 *
+	 * The folio cannot go away while the reference is dropped: the
+	 * reference taken by migrate_vma_collect_huge_pmd() is still held.
+	 */
+	fault_folio = migrate->fault_page &&
+		page_folio(migrate->fault_page) == folio;
+
+	migrate_vma_split_pmd_mappings(folio);
+
+	if (fault_folio)
+		folio_put(folio);
 	ret = folio_split_unmapped(folio, 0);
+	if (fault_folio)
+		folio_get(folio);
+
 	if (ret)
 		return ret;
 	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
@@ -935,7 +1017,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 }
 
 static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
-					    unsigned long idx, unsigned long addr,
+					    unsigned long idx,
 					    struct folio *folio)
 {
 	return 0;
@@ -1103,7 +1185,6 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 	struct mmu_notifier_range range;
 	unsigned long i, j;
 	bool notified = false;
-	unsigned long addr;
 
 	for (i = 0; i < npages; ) {
 		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
@@ -1177,8 +1258,7 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 					goto next;
 				}
 				nr = 1 << folio_order(folio);
-				addr = migrate->start + i * PAGE_SIZE;
-				if (migrate_vma_split_unmapped_folio(migrate, i, addr, folio)) {
+				if (migrate_vma_split_unmapped_folio(migrate, i, folio)) {
 					src_pfns[i] &= ~(MIGRATE_PFN_MIGRATE |
 							 MIGRATE_PFN_COMPOUND);
 					goto next;
-- 
2.34.1


