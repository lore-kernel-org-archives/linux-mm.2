Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75A20C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 19:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881A96B0095; Wed,  5 Aug 2026 15:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859966B0098; Wed,  5 Aug 2026 15:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC266B0099; Wed,  5 Aug 2026 15:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 300C86B0095
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:35:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18A2514058A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:35:48 +0000 (UTC)
X-FDA: 85068220776.11.23DAF7C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf16.hostedemail.com (Postfix) with ESMTP id A680E18000A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:35:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HLDSJwL9;
	spf=pass (imf16.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785958546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkx+k/DvovTgViaD+43ZOc8fRqaV0uieVtGwvKibkK4=;
	b=4rXr0E4BNlk77yjYStUAg8IpB76p16UuBFO6CZb22rhwQXVDTj/5UDWnTAqF7sHfu6Vqt4
	5vB7sT4NU1QlABCDcP+lY43VPgzE1qLF6LSbCQPs1ben4NBBDjEsjyOFNQNR6JTzDfn9wJ
	8Fl0uGVI9X/navpTk7cKuCWJjv4zeCA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HLDSJwL9;
	spf=pass (imf16.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785958546;
	b=QmIFxU/RE4tLxcS6nirdP9wc41gBcGLtgzyBW3ofXGEmkpwkSduwubnB4T2MzFprPbE3r4
	6cTFu02DMdLMVEdFuf9TIoJ+Lki0UmVysAMaZpRuYwI8CACgOUHGBKH3NKHLPMGUxS3BcN
	esW66ydQr4b7Q7Vbew0qVYczIroca1M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785958545; x=1817494545;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q8T+Js7ezU9vaLDf0JKr8untYueFAoOH+rF/XAfETZI=;
  b=HLDSJwL96qSu/QcY1SelnSrjbxGxB5cCJeevJwIjcVJkFIwUAgahrEBd
   A7QlsSmDSDdSqPi0jmH/XaoDDZXfwvuQ4Kiw6t6eIbldPQxzCdz+6eAy2
   bzQJWG7c+xZ1tyaFvVRnLRcqglEfsOPwgjyX+1siiyfIl0tc3Qkvp3Iib
   QKFWW82D33w2VpGMJLfik9mRvF08DPtqIXkb4jD2sO2e9QP3h6T3XHo2U
   28LlsXkIw7ylPHHB2CayEk7Vu+w5Aesa3Z7/IlBsO+2vQw2LF5XJSm9BZ
   yZ/cIzkvPXNIhgSJM36iSz4Ivug1eO+zMeAyxR88KrudS3ktKrwmmH0S6
   Q==;
X-CSE-ConnectionGUID: yiqKjYsRTWqDlWdZ3EkrUg==
X-CSE-MsgGUID: +4f3CCqiQ3+kDOsu3hISzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="109332935"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="109332935"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 12:35:43 -0700
X-CSE-ConnectionGUID: KHiaN7iMRTau0I+DyND8PQ==
X-CSE-MsgGUID: 71gF13OgSAuigqw8aZtv1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="285263524"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 12:35:42 -0700
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
Subject: [PATCH v2 2/5] mm/migrate_device: Fix THP splitting of a CPU faulted device private folio
Date: Wed,  5 Aug 2026 12:35:33 -0700
Message-Id: <20260805193536.3756457-3-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260805193536.3756457-1-matthew.brost@intel.com>
References: <20260805193536.3756457-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fzua8kw3ysxanscoy1pstjpise7nzbpa
X-Rspamd-Queue-Id: A680E18000A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785958545-1429
X-HE-Meta: U2FsdGVkX18B09UDObWlqHcVDiTZjPHO0MFkMha/fzuWrBHDR/lsYAygGaXEbM9oDWtp9aia0wi6VXDY20g/5N2p5DcqqDT4sE2JfnE1tCd+AMkyIOpipVwuhHjUI3/Oo3g83I6hS7ZBkzbELsRrSnebZ8KCjf2J+pxn46/qz3gatFdqFD3O996o87Z7HTZB0ic4MA/FROMq+cjZeyHvJJyfjSSm4n9dqGvxiUutEl4cYtBHJuuIprbZDHOMLPbs2mEdhCPPzmkY/EP8YTXBxjEF7w39oEaMCqu9rTYCIZ/XYGzDMZvT3zvWI1k9B/GsbjsmE/7SGwXgDrasbXxpbcGma7G61L2lwJ/YJrlU4BSXCbjC/N1sNKuyitezkxm3DS/s/B8ZTpEg+Ra4Cxk/UH2DrhF7aeqbhA7y6uApAbKYTWqCOrLA46uhOTaZ4SsUCWipxm7mTY7Cu5ee0R9XH4gPUSg7gDfdNM9eloI1d/j3hxFTaJau5CHCb851po0m2GPIIBKokMyizrlWJSnuVuNMTJcZsb7HlAUY45s8cZDHZlKV8Fc/h7XfNwM1e/zx/e2xoX9Cd2ihPirnslJfu3EozbnXI5HfLyMzazJCNuLC6PUb1IFlAxdEf3kquHY8brVnOUWAHWhX5ZkHAy4XhOlTyp4WSMvYq6iAco+hW8+Mha1hNkfkuc6TWXUUoNcP9xXVIC0XTXiISR/cQWW9VHar6KNzNSDlRGEwdqXIPTnObCTRSgTH20dlrRQzFBxa9k5z+tg83ezjl7oIGaLl+bGV0vFvVl6Edjzl+uq1OGHGy9WO5xk4rbbtxmVFvgrB2h/zFkL6gkqzSfoZ6UY0SSiMHdawLV1vqjmhSJv1QQ1T16DDS9lGKxF03xo8I83c+zb8VlX8o1a2+LG59xFFR87a8uhL8eHw5YP34/zULV3nVes5XUTwHXH7ZwAy5Ck1NgaJIt5wmUOVGcwM7Lp
 GtXlhrk2
 6cHW86fLaujNk4s5HYPK70xahASiE/H36THczgCMZQm3O8K1ZnY+Ux+uGxcvMF5L1CAznoN10QPH0SMxFJ1KXCzC99cEqfPvtToaSHg4UOSCHtlGCG0mBtzRL1d82CwJNQNVPWdal6xDpEWCSdtuJcJxOp8EAPrE/ATFx3R7bFj7MXi9oMK27IGY14tcp6Uiuk9mq5P9NjegjdYfVCAQ8Vj5N7/UvBgDDwPKHISZ3jJ4XMDjg+TYSR7ece2cCwLMOlK07aCsDSYWmS7SkJd4vmbYf+8vTVfhJlB9BRK2Gre0lACsBx8dh3AJkrqxr75i7J4cZTi1Lr0oiq+BTGYU18Wu9eaLo16pi+5oyVSM2w57EYFHEIjTmlfJx/eE/yr4wPGXc2/QsA3G/EIKSKLlFylB2njrHOdY6ZHidAKgMnFtMfUlDFrYVl2ZIdBqmr/hM9kcp87irzOMfFzBkAS5SlRoN4LfjE3ijsWrGphoya23crOlDAOlojXczQKEJcwlbFEGSWLV4QEpF1ReHDxh1sL9KaN1tItdyVGROaIZYRgHNtkHMbMETXIVAomv1N3foU4UAbl8BPXoDzN8lEfth0qSdI1GZrqCjEPCIvDJPBSDPjolbYlWqqa++P92yj9HmyPXzw8SaZBYRiWIV5/e7it4HTiPBCF5qY6aZfqL6XIkRGDATRHoJ88MLOz8Skl9G/+d89j5yGDVMLURrtoXqt4s3c+W/o+RnV8BNGnqXhOPjG8X3LMzwnZWNfxrfslrp6bO6W1OuILVW4gLMQyd0UcxkbrUUAbvPTGwt+pwmU0gKYMRFurKTCD1yxcIl/rco42O1UJmU2N+kbwaNOWtpPuibZzDEyi0CxD8Mi4jXrzHWxOVBmEf3GTxg8oosktJBYfQYQpGgFjyYi9gahqmhyVu8J03dI0HWVbnzlpKlePzqS43V/k50sT0QUCT3T3BYkofkeASl9QnKS3E=
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
Assisted-by: GitHub_Copilot:claude-opus-5
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 mm/migrate_device.c | 98 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 89 insertions(+), 9 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index d37a96cc6335..142920a464d8 100644
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


