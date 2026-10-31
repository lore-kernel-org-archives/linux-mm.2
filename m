Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A1B5606A326
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vxe+k77k
Received: by kanga.kvack.org (Postfix)
	id 13E2D6B05E4; Sat, 31 Oct 2026 05:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EF876B05E5; Sat, 31 Oct 2026 05:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F22926B05E6; Sat, 31 Oct 2026 05:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC1C56B05E4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:49:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 56C628089D
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:49:08 +0000 (UTC)
X-FDA: 85382447976.18.1A0C5C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9B6F3140007
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:49:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vxe+k77k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IjXGxdI21GHlefNuc9d8WG3Gh6i1uecgZnNzYjBLxQA=;
	b=o6HahPucYb//k/3NnXhAbCOsJATgOrr4ALnRSgp5qBjpCM3IoZpXoZCg9PglkaSkRgCYVb
	yWUQsGgEOebE77H6X8o+Z5cXPNg6OovlChSH7x688ElRh/y4hPRI7Y1G5NiVbgPTQ81pOM
	k+2XYIh8fVGGPNVBAynLdOnOmF9bPI0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vxe+k77k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440146;
	b=l19w6LtQkGy8pRBSGxIuobUBpvHeUJU1Jrol1xrMv1lt/dI9DFPuI3f8Olt+Z+iLPxBaqQ
	B/0tab2ZNICBt80vK5IfoxWNIXA0yJTixby9MLeYNEuIoXLApTua9P1iFDdTNjuFBME7eP
	Jl6d/c9z0yNMeCk4gTvuf1I9xSvvENA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C78E605CF;
	Sat, 31 Oct 2026 09:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB06D1F00A16;
	Sat, 31 Oct 2026 09:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440145;
	bh=IjXGxdI21GHlefNuc9d8WG3Gh6i1uecgZnNzYjBLxQA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Vxe+k77kJPuUdVyhCbp6hqSL5tOVmFwh62QnvvZPRanJVeYjVeqJffbeRNnz6bi7Z
	 vJdeaHpjumIsgJdILQnTJEu7H7EbVbRZsqoXiAagi4mHoe3X/P3hsSEdpjEbruGdEl
	 fkie4Ik9xJ4scAW7TEs2sD0XZmJ98VuYgSZwI9KITCZBowq0dQUQCaY6WDXIIIhDSW
	 mlGHw7ibBWgm3xwzwaCOM78EU02kSve6SOeLgYiVL3f8yUrfXWbUbskMw2cilY0ust
	 QFg4g9JR0agefCjXswUnCs6aQu3t7FyolU+jzLtrz4mmumfSsW66hGPLXxSJJBbO+9
	 RX+PAGn7J9Qnw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:40:03 +0100
Subject: [PATCH v3 34/47] mm/madvise: fix data loss from MADV_FREE on a KSM
 page
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-34-d6437171ecc3@kernel.org>
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
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1790; i=david@kernel.org;
 h=from:subject:message-id; bh=1jHBM4yk7cItfizVmqJa87+gzav2ElPv67Z1UsegsEg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs9coxvHyH1z9s7VefczZtw+fkhp40ypL1M2bLLxy
 Cx3fSHF2VHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEZmkz/C/0dhFjdz3d/179
 gLK7z3f2pa9y9xzsbsid1zQ1c8LEyp+MDHPUY16u7ZrSKTKz6UJziCPDjl/K/z5zx+p/sKx6+vj
 GE04A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 9B6F3140007
X-Stat-Signature: eini3wnr1frd65hg63rtau4t7ezrax4j
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793440146-398296
X-HE-Meta: U2FsdGVkX1/5Z9Tw2FVRpNszuCF8kKB4v+FgksKJLSPK6wEeucpIE/SncjXMVLSPt6BFqwGWLfTPZsAWoUZwvlU6Wd9J6rjJegV3sfzCA6rwaPY/DuFUVp2ocK2ByJ/yYHMJ9W+TOI2nbeZfx7wuv8yaJV/dfrzV8OOtCdFAWfT4Xr7MEkJv8pFvRv++cF6ld4nDINQQQW7LOOsG2Rq7V4YV7n7tO9h1qMxMg5v62IDw/iqekwH2ueStn6UHe9qI0Yv7Ni2Wnp01g3sXjHLj0Go8wWICqs+H/GmI1/gsFd6DHWptImZWGkIBsuL133A85s7Trdx1buDCLi8PVhWUk1C06o2/K92KsVOZ8zi8kZJXixvYCFhJVfB6ypoII5JSqIE7zPX3THUPMQfquyplWlHsyfQDksdztAFvywgtdXUCm8Wj9c+NUF1Wt6Tv97iTzac8lErN3bJyXlETWeA88lHafTjOaqobwl1FmS3oJmo3Vdz3BgEX5nohD9QtpbAe7/tpaJkEmbHzfkzduzSxG7cRa7+X9DRrZ15REnmWcxvQCJ32ZphAhCilVOPQi+a1Jio11uKK/Ib5WKT7JbSt9d86Ux4sPa8TJeOZT9G+ldaoB8MlslIDiz/+Uh3dDz4ObSlHfOKhxSL89JK1rLv2YgUUM6JqwkKvsVA6pINxm3WEVeitJO+Wjv44ShRydEFU9DViiM+Dpm4EUOCax6dVbP8N1JhKbBbqLF84qlB1UlOE3lXE3X/m+Nl80ZV7hresVEQuJ07dCqspvkVkF5U3WdnPM+ARWyyS5OYnSXjxINgrAw+Tnk/5Jlk3Xh55HdJkrOBw5FtvVviVA4fGz9+2QG8NxOtJIFvDqQNfBWZo8TUzY59VQd7kIBCVLw6JYd0T1NgPVSagHqcl9njGKPyxeULuE3Nv1UgAPixRBDvltAuFKVPicE95U3Ud8AqxPmIS85z47tlkmsc697BLDM3
 Uzb/SStE
 FdbFwscLadECHbWf17Z8OPF8wGa0AF256Bsk8mYQftj6hRTJBAmmOYhkSBGfkMb2E0dSLVS97J176FB3+y5qhcc897+grzpdWaVn5k2YGPOWW23b6wNoRiwl6FFnuKuPpuDD5IzyTkCI0nnKTql7YlPQqYX3uDwG3XAzLu2sbsQ9LtL+4Lf6HrE8dLtOwqH9sOvSel2IvvzOPN7/9qFGS0YfMTBtC9D6RsZKMQJHYCPjAENl74gWdAwQq9oOo9WU2Zla0dgeG0UaiqtUtHHFfdivDhHBooNPyHxQHRGXqEgRcQKUSMAXEcxbBMmQoZoMVbW3vnycR/Mk84PTwOWbuq7xbzbG8hQkvTrVk1L7CHY1umdOuKUAek88ohZoMonWCTjr/maVyjkHbxx1sYOEIAxrC+JL+SyYqKczqQf9ZmkEXTNj7ryFnkkVmpR9KgH+PnvL+e83VAgnMNZMGR5NZDr6En9i9D0vKQkOO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MADV_FREE can clear the dirty flag of a singly mapped KSM folio. The
folio remains in the stable tree and can gain new mappings without being
dirtied again. Once marked lazyfree, reclaim can discard data that those
mappings still need.

KSM always marks a folio dirty when converting it to a KSM folio in
try_to_merge_one_page(). Marking a folio lazyfree clears PG_swapbacked
but leaves PG_dirty unchanged. Preserving PG_dirty makes reclaim restore
PG_swapbacked instead of discarding the folio. This also protects folios
that were already lazyfree when KSM converted them.

Skip KSM folios before clearing their dirty flag, checking under the
folio lock to serialize with KSM conversion.

Fixes: 854e9ed09ded ("mm: support madvise(MADV_FREE)")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Xu Xin <xu.xin@linux.dev>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/madvise.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 75b409e97dbf2..a16e3cb256b7b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -756,6 +756,15 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		if (folio_test_swapcache(folio) || folio_test_dirty(folio)) {
 			if (!folio_trylock(folio))
 				continue;
+			/*
+			 * KSM folios can gain new mappings at any time, so we must
+			 * not clear their dirty flag.
+			 */
+			if (folio_test_ksm(folio)) {
+				folio_unlock(folio);
+				continue;
+			}
+
 			/*
 			 * If we have a large folio at this point, we know it is
 			 * fully mapped so if its mapcount is the same as its

-- 
2.43.0


