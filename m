Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FDCDCD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0C2A6B02C1; Mon,  1 Jun 2026 04:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE2F26B02C3; Mon,  1 Jun 2026 04:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF8F76B02C4; Mon,  1 Jun 2026 04:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9526B02C1
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:30:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F3BB161D5D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:30:56 +0000 (UTC)
X-FDA: 84830673312.17.0775F6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B386616000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:30:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EYJarc1W;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780302654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IOoxh1i/NfGyHNHYUj44iC+SXTNiuSmyXkF+hDZN9Zs=;
	b=Evs1xJgZQJReSq9HUdVBRCzIoyPh8MuPfvj1y8rWwA6NayqPd+SOquop4wNV0kX+heqQ20
	7C8ORjUmRC8t+w6shkK7d4+I89UdPns4PB9qdv5ojx6BbM39unyJBSsXdyrqANoW3H8WrQ
	5b/8/6cmuqi280NmnkntGOATbeC2elQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EYJarc1W;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780302654; a=rsa-sha256;
	cv=none;
	b=tgnQGX9E+7dLle85u7RiRx3WKD7PSOhaOmLp77MsIGc/3OuYEXRNtVxdoCcYWC+IZXCMCw
	pnPiS3sHYVnYuHMOB9meillGutQIcgIWWIrU32iLOlvLemizG3pyQlEgI8GLNdIkTxF8Ss
	IpnScJumNs6PZcTpFoUphc/rdYt8omU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CE956014C;
	Mon,  1 Jun 2026 08:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4198A1F00893;
	Mon,  1 Jun 2026 08:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780302653;
	bh=IOoxh1i/NfGyHNHYUj44iC+SXTNiuSmyXkF+hDZN9Zs=;
	h=From:To:Cc:Subject:Date;
	b=EYJarc1WBjXEjFcFJvxmPWAAbf+3HdsrSPO0J7pvPWcjchQN0JV3z+pCapSrtZ3GX
	 pZb44/6YDwpQGknU2DONJ4kZLcBe5Zljv6MSY2cXMDOhG/wiDvNMl4xBtXNKmqvKeW
	 zd1xzTWFbS+g/kFAC5lNvZlRGW63u0QVWeXhTdUAfdXV9L0llD+sWKuyaXebkhnE/P
	 p/1OhIoMCovAJiQV/SiX9hviMx/Ito0SvZjgqU2hD0u3ty7a7geFdFPxuFwMDB/aH0
	 Xy0i7n4DWYwW94kO7k5euMCt7XNPytzqvkLoZzm1+A0CZx/Sp0CxWdlehWEUPt6BXE
	 r9HfIT+axA/mg==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device private PMD entry
Date: Mon,  1 Jun 2026 09:30:44 +0100
Message-ID: <20260601083044.57132-1-ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 99pxt3y97eg1epdkcqbb3xtbxro51s1b
X-Rspamd-Queue-Id: B386616000F
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780302654-996557
X-HE-Meta: U2FsdGVkX18w7rE7uQ1QgG4WuF580oQzRR7ln8K/O15bK6ZejEUsyo/w+A0MRvTiVPxhYE3NiPSDs70uq+CE8NWHWEjfnVaN77LEugvIjSDT9aGSLQZSg6cqULtx2aEkAFZt5+aIGSmeSz3gEmXtW2mggqeY4PkN2CJI5DdmGyi8hnjjAMTEIByWw/YlEmfIbr3D9vAJ0IeDkbEZJ9JrcmAPm/aQ8kMuo8DG1BCz4SZqNkqG3sy22PPJQeHtU2+jC4lggDJmM4ogWKP3csMjP7KVOCaLwz81PFFjwLl3u+2RepxKG/G9DOisPvyGI4tPv6GI+LrJlikZdpj8bB+IHELgiMc/ksj06GrxaZi+VrAkOV0fI5x2LMgq386StBvFJ4l4iiNAAfGSjX+yqITlAwQ2B5yuU5vVRJ4AmCU7r+SjGwf06SJ94XzYQX3ab9qrP0tte7UMuoUB5upr6TET+ogxi1FixVrjr+i/vgaSQeQXMr5YgT/AuQOIZTzwb/ZmMg1dIkyUov1ucOQcCcY3qbx+KeMyikc4fgmariWxNRSTXOGyCSTWdbRckFNwR66GCrCP9tZk2w379HrovkieVavIvlyRtt3SVh+LMzgY509JzS2a8qhnLy4EF+OKBm12pNeqTIkhw7Lhay5IA6dqmLHYYxh163ndt4DpiRsKLa1+vFnHVaAAzRUj5mqCDhF1LbW+xxQg24CmKmjj/fbotgQU4BbtES3Oj9SsqNQJQqW4DyYfLrMDdXQFX3fYlglVKljTtL2UhWYK5/Kvs4nQDkudHw4lUnig//igGigxQF3eRbE5iR4SeBAGGT2SqpjsR+zVUIB/cA9mO7dufV94x5WLES+Gaoi+iaAh3YNWq4TmMwDZw6qMUr5kOrbG7ibnyryn96Izk1x2opGSKwCqw5xhFM5nyqVlAJgVJDLtc+wx4T167/PwRMducg2qNihxluJCy7Sn+3MWYboILhm
 JZdd6I9s
 0xEG6yToT1sr34zsC7byyiYuB1kl701UjqOI+KRUmHGsADS3BLYXB4+eIGDLtbZSfkBdi60YJwgmN0YXGl+UXQjqkSOFWuVythgtlF0rAvGvFPEtmqzkLQus7sbDfqqOMnLdI3UlUEEsTNIy937Lj9kbBTryp78RvglKVR65O51B77vnRUPY8zu3hPLWmXAOa+VPV0bYK4B106JM9q+2Vi6CPY3Yn9yvmzMRhwq4yrpVpKD8g9JW/v4Z5A/w4GiST46tB6ieS3VvBB+WjPYKZjz7+Ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
device-private entries") updated set_pmd_migration_entry() to use
pmdp_huge_get_and_clear() in the softleaf case, but made no further
adjustments to the function itself.

Therefore this function continues to incorrectly use pmd_write(),
pmd_soft_dirty() and pmd_uffd_wp() to determine whether the installed
migration entry should be marked writable, softdirty or uffd-wp
respectively.

Whilst all are incorrect, the most problematic of these is pmd_write(), as
this can lead to corrupted rmap state.

On x86-64 _PAGE_SWP_SOFT_DIRTY is aliased to _PAGE_RW. So calling
pmd_write() on a softleaf will return the softdirty state encoded in the
entry, assuming CONFIG_MEM_SOFT_DIRTY was enabled.

This was observed when running the hmm.hmm_device_private.anon_write_child
selftest:

1. The test faults in a range then migrates it such that a device-private
   THP range is established.

2. The parent then migrates it to a device-private writable PMD entry whose
   folio is entirely AnonExclusive with entire_mapcount=1, softdirty set
   (accidentally correct write state).

3. The parent forks and the PMD entries are set to device-private read only
   entries, entire_mapcount=2, softdirty still set.

4. [BUG] The child writes to the range then migrates to RAM - intending to
   install non-writable migration entries - but replacing parent and child
   PMD mappings with WRITABLE entries due to misinterpreting the softdirty
   bit.

5. In remove_migration_pmd(), if !softleaf_is_migration_read(entry) we
   set the RMAP_EXCLUSIVE flag when calling folio_add_anon_rmap_pmd() for
   both parent and child, which are therefore AnonExclusive.

6. [SPLAT] Child sets migrated folio entire_mapcount=1, parent sets
   entire_mapcount=2 and we end up with an AnonExclusive folio with
   entire_mapcount=2! Assert fires in __folio_add_anon_rmap():

		VM_WARN_ON_FOLIO(folio_test_large(folio) &&
				 folio_entire_mapcount(folio) > 1 &&
				 PageAnonExclusive(cur_page), folio)

This patch fixes the issue by correctly referencing the softleaf entry
fields for writable, softdirty and uffd-wp in set_pmd_migration_entry().

It also only updates A/D flags if the entry is present as these are
otherwise not meaningful for a softleaf entry.

This patch also flips the if (!present) { ... } else { ... } logic in
set_pmd_migration_entry() so it is easier to understand, and adds some
comments to make things clearer.

I was able to bisect this to commit 775465fd26a3 ("lib/test_hmm: add zone
device private THP test infrastructure") which first exposes this bug as it
was the commit that permitted test_hmm to generate the test.

However commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
device-private entries") is the commit that actually enabled this
behaviour.

Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/huge_memory.c | 45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bf9b480bb3b0..79463c709c98 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4982,7 +4982,7 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 	struct vm_area_struct *vma = pvmw->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address = pvmw->address;
-	bool anon_exclusive;
+	bool anon_exclusive, present, writable, softdirty, uffd_wp;
 	pmd_t pmdval;
 	swp_entry_t entry;
 	pmd_t pmdswp;
@@ -4990,12 +4990,26 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 	if (!(pvmw->pmd && !pvmw->pte))
 		return 0;

-	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
-	if (unlikely(!pmd_present(*pvmw->pmd)))
-		pmdval = pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
-	else
+	present = pmd_present(*pvmw->pmd);
+	if (likely(present)) {
+		flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
+
 		pmdval = pmdp_invalidate(vma, address, pvmw->pmd);

+		writable = pmd_write(pmdval);
+		softdirty = pmd_soft_dirty(pmdval);
+		uffd_wp = pmd_uffd_wp(pmdval);
+	} else {
+		softleaf_t old_entry;
+
+		pmdval = pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
+		old_entry = softleaf_from_pmd(pmdval);
+
+		writable = softleaf_is_device_private_write(old_entry);
+		softdirty = pmd_swp_soft_dirty(pmdval);
+		uffd_wp = pmd_swp_uffd_wp(pmdval);
+	}
+
 	/* See folio_try_share_anon_rmap_pmd(): invalidate PMD first. */
 	anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(page);
 	if (anon_exclusive && folio_try_share_anon_rmap_pmd(folio, page)) {
@@ -5003,24 +5017,31 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		return -EBUSY;
 	}

-	if (pmd_dirty(pmdval))
-		folio_mark_dirty(folio);
-	if (pmd_write(pmdval))
+	/* Determine type of migration entry. */
+	if (writable)
 		entry = make_writable_migration_entry(page_to_pfn(page));
 	else if (anon_exclusive)
 		entry = make_readable_exclusive_migration_entry(page_to_pfn(page));
 	else
 		entry = make_readable_migration_entry(page_to_pfn(page));
-	if (pmd_young(pmdval))
+
+	/* Set A/D bits as necessary. */
+	if (present && pmd_young(pmdval))
 		entry = make_migration_entry_young(entry);
-	if (pmd_dirty(pmdval))
+	if (present && pmd_dirty(pmdval)) {
+		folio_mark_dirty(folio);
 		entry = make_migration_entry_dirty(entry);
+	}
+
+	/* Set PMD. */
 	pmdswp = swp_entry_to_pmd(entry);
-	if (pmd_soft_dirty(pmdval))
+	if (softdirty)
 		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
-	if (pmd_uffd_wp(pmdval))
+	if (uffd_wp)
 		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
+
+	/* Migration entry installed: cleanup rmap, folio. */
 	folio_remove_rmap_pmd(folio, page, vma);
 	folio_put(folio);
 	trace_set_migration_pmd(address, pmd_val(pmdswp));
--
2.54.0

