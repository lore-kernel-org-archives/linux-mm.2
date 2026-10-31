Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E629606A337
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gcS0/DUx
Received: by kanga.kvack.org (Postfix)
	id 355A86B05CA; Sat, 31 Oct 2026 05:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32DE36B05CB; Sat, 31 Oct 2026 05:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 244F06B05CC; Sat, 31 Oct 2026 05:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4EBF6B05CA
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:43:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E6D04026C
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:43:40 +0000 (UTC)
X-FDA: 85382434200.03.3218B89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B21C320003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:43:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gcS0/DUx";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439818;
	b=JpA/teFRyPumQcn2CPKRal34JKJ0ZQdLG4V8vIlvavfN1HUI17Yz/zI9xEVRQrxaXgn7WM
	BTauPZdNBxlqwb1Akwh4M9XCh5NGPl9TgOazDOPg5eqGt0/hcQmCycW0eL2snL+XVgjPlJ
	OrpzGMgNnGBdHZgOm9nLVjZwkY2Vu+w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gcS0/DUx";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75zyuTtsuafOzEahVl+WZW7s8/QVADxO/YkiuCeEnRo=;
	b=OUgsltEhsP1vAIxe915WLxNi7XnhLDMrj2NVZNyJ1cRPwByUqwBvdSGyDEkli910Kwgrim
	wjgeJDD/6s+Da5tYSx2TVIYwAOvh2wxVF/sNfW3vCGuVfeiK9iNSHTfwGRp9hU2WTfx7il
	WLoQ5Y5Sf4X/PFi4TgpWet+p5mCfG90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E4A5600C8;
	Sat, 31 Oct 2026 09:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8303F1F0093A;
	Sat, 31 Oct 2026 09:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439817;
	bh=75zyuTtsuafOzEahVl+WZW7s8/QVADxO/YkiuCeEnRo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gcS0/DUxOyrED5eDMwrEZauk5YChzRD/FtWcSvQxODQn2n1L5cR+0qiSKRFzIBJLJ
	 rFW7DasU5sYC/6T6La5izc16PE0mNI4Rmq7lrcAoDy/3JSML3NIwB2Dy4LwGNEkDzk
	 SdCGyPFFzDm+aklv+bE5cesAY0SEdFelz+QT39Tz91CacOq/vM0xsOKUwUYWUrjM+Q
	 rPAdwWRYW+lOcIU/oOjW4RbqF6vJKaHKvYVsDcVjBWiOHyd3KKoUDsIsEbWEI/D7UH
	 g9meyzaJhxk6j3y+CO+n4QNctXXT5KX/JCqJD9f+HW+WtwxJCB3nR1DFqH5enrefnD
	 SX5I+DKM4l9vA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:42 +0100
Subject: [PATCH v3 13/47] mm/huge_memory: fix truncate racing with PMD
 zapping
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-13-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2170; i=david@kernel.org;
 h=from:subject:message-id; bh=1pZO1fewpEQg6xUjsBTP9l8Sg2iOXw60MZ7AwrYjmYc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk/TS8wsNG5f1ynrc6d0j+aVF32aYYfOzW1q9LWMM
 mKWe3q+o5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIk8rmX4wxHw3HS79LrHHm83
 7faz1PnZltr5tf2xrC3z5ppta08Jr2P4xXyOYYqJ9velqxW93AXPKWv0JXPH/myoOvmtu/OBy7I
 CdgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: 6xtebh7efcrdnkz1df53i493q6bodc6t
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B21C320003
X-Rspam-User: 
X-HE-Tag: 1793439818-946563
X-HE-Meta: U2FsdGVkX189RkMP5AmKMzqr9TBQjaGgAZaUVUVQwKzkKxZPIa4uVsPrqhF0Ij7t1H4lU7hw1pPDTx9ex56JhG2EVHj3riycUzfaCutxbQNr3NrUzL9Or2RkaM8smXkkrJEszmtig6f8ZTVbMtrsQL9XY5D1mvssA6c2WnqNsnzhNQf3e5GY8z//ILH7WmP1GBHPK3tSIjNq1GoEq2vHVBbtX8uZ9a9fB6q0r83zMQAbVGOP+qRSUZTm2h4eOTBTm/4SR65MjKKfHgMoXBYpDWPNtnnmRZQNpcJvKPvGpUtD1G6HLiIqoP28ei+dbDXHgEiqLPqKSP/kXkTjE4a8zxJ7dET9pXE1nupTQ6jm1lnPXFUOToH0BdIMKiK9h3yzEOEPM4XMvD0b98pZyS4pcZ1Rde/SlD7saj2Umu54Qr6ZORoikmz8pac9XkHGIsRW2MRMOviMF0OgLBQv8X3GctURHiotXqktMen2t1TpyC4zDEkiLGblSMC/lLuMrxZ5LCh5aaoTbooXs8+GHBI9OxC7o7Dw2kQd+8b5Gy1gHAP+nWMz+FWa/0fjfTCLyLcXSoEsLNmF4QEpZJBxOKuxCABeS7IZAVEY2DxBr5SWnOEh6YeLPHR9vH9Fjjqq/Hqpa9g/DIqT0LxJw5F8TX7Tw2E7qrGSi6wM65FFN++nA65ZLgKDK1U3d9cIVdwJR35Kgbygcjvz/oMBewvHZM2bzjVeFjKKl9awEjQVqmHRpJoLqdoodQIR41vcGVYQdDhTMk0tjEypAOE66FeT0/wqjWYgGUz/N44M8ruq/Vd0UTb1rr9I/dcY8Rk463dQvWPIwEVmnslDItOKGVCWhvgBtqZsbgiQlRYKilbYdUla3G9Ohy3jDvV/G7HaosVZf0e1dOuFBOLw5ODkSaM2PEeut/UStQvAYlnQ8L48d5MYmNFUM1Pl1qnG9adtU0QC2ZNi6MhFWUcnox7KQmMjy5y
 yocVPjsV
 1NCljUvgS+w/V3B7a0uoMs1mc8Kqu8d5ZkDootEEg9cTGUgpEOJ2BYGo4pGIvEcTEkE6rWDKDZfvtMyXpzsQwJP+R4hJhQzm3vTYnAvR4LK0CoieErDdqE4IfMGo8Tyj8gGc1uDMVoDanmZZPTxvMGhpOb5PIr/KCy1ud8FYSARWcOL+vRcfr/AD/twC31Tbm2NMnGyU4tsms2yGkYGuCkGGZ8WVVJDaNnKRHXlrhEj4cwJ91pPimGaDh+YLvCuuS+YCw/lr1LW28ynkmjP0o40Xzh7b9lNDWMemwUbbXTZnKXhwb4ZJtDNgVjvp9zOe74hXE5Mnz8+kDMgzgAboi3An9Sr3v0L+pbJA/klMnxFk646iGv2tLARN/3Nbd3EVTvkTT5E2whY4Rm3PSiJurN/56rgo3lGoXi/PqyRq7DOaJsUgTywCSx4x5HxYPrNQOrOXzpSVbcFTqHrg1n23dnKugeV/+ljGV99Pt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

zap_huge_pmd_folio() removes the rmap before calling folio_mark_dirty().
If this was the last mapping, truncation can skip unmapping the folio
and proceed without waiting for the PMD lock, racing with dirtying.

ifs_set_range_dirty() can oops if MADV_DONTNEED races with
ftruncate() on XFS, when we get the folio set dirty after it was found
to not be mapped anymore.

Move folio_mark_dirty() and folio_mark_accessed() before rmap removal,
matching the PTE zap path. This keeps the folio mapped while updating
its state, so truncation must wait for the page table lock.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: fe6cf984939d ("mm/huge_memory: transfer the pmd dirty bit to the folio on zap")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify comment and description ]
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/huge_memory.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b31a425c7a32..1d65c4f576f9c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2495,10 +2495,6 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 {
 	const bool is_device_private = folio_is_device_private(folio);
 
-	/* Present and device private folios are rmappable. */
-	if (is_present || is_device_private)
-		folio_remove_rmap_pmd(folio, &folio->page, vma);
-
 	if (folio_test_anon(folio)) {
 		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 	} else {
@@ -2512,6 +2508,13 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 			folio_mark_accessed(folio);
 	}
 
+	/*
+	 * Present and device private folios are rmappable. Remove the
+	 * rmap after transferring young+dirty to the folio.
+	 */
+	if (is_present || is_device_private)
+		folio_remove_rmap_pmd(folio, &folio->page, vma);
+
 	/* Device private folios are pinned. */
 	if (is_device_private)
 		folio_put(folio);

-- 
2.43.0


