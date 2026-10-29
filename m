Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1B960A2607
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BtblEQni
Received: by kanga.kvack.org (Postfix)
	id 23D766B05B1; Thu, 29 Oct 2026 16:33:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214AC6B05B3; Thu, 29 Oct 2026 16:33:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104B06B05B5; Thu, 29 Oct 2026 16:33:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D04146B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:33:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 430FAA0502
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:33:47 +0000 (UTC)
X-FDA: 85376814894.28.9AE2099
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 874DB40006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:33:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BtblEQni;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hl8Hja7261+PqX6A1yngTbcTCPox77BGspRqPrmbmIw=;
	b=yx5SGRnBbMg8KsI6qsUbVnsaBq/g6FjIKgnrsJrwi5WWVvYZdFQ62nqAoUGm9zrMOetfmn
	MLw9B2T7tbvMBONUEtX0m0BM3+kT7EHouXimER7t2ARAzHlrNZycJ/NeMGIowi4wD+FVwY
	ordJp8ZIKgYlezSn0jylcKBcPR6fx04=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BtblEQni;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306025;
	b=a57KK5tKrBrPdowd/ReeZfLcJNnG3+YcjSZvZ/laXGa8klELadrALa1gz+vkqQkUoaJxU1
	J8nd7En05ed7tDjte63rfskNw1XPWINwxnllEyP4NrlGENde2+ZJkoo5AOmi19FUPsNzDx
	XIlggcAQyvT11kDNQ3KH8I6wHBI+lfE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E8418600DA;
	Thu, 29 Oct 2026 20:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E1B1F031E2;
	Thu, 29 Oct 2026 20:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306024;
	bh=Hl8Hja7261+PqX6A1yngTbcTCPox77BGspRqPrmbmIw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BtblEQni/tV7KmG4ZsM9UPfe8T47hGMbbRdFSbdDMyagtA6eYkZbhluhI9z5BurdL
	 1e78U6Dqg2OUvWYcFR0R5N87ly5LSuFRTWMfolODfDF1YuUhHuMAr0b1iHsc7D3Zok
	 WWXgLFaB/7lS8DNFBPkUEV5jhF93hksYscJQ72sXQp+mQe59teJ8lUli9p5tFfB4A9
	 Wz6e9K2qIY/jLVAnShYPw0I9kE8fFZ2d73v1Bo2z6zzKA/PIuyGuoriHgYP9CxUnrd
	 fa/lB7eBUKMmE00K0RofgBKFQ5hGuNr17dEBDn3gMz8NHlng/llC5yjiUWyFxZr+iQ
	 1NGfRY7z8HfBQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:32:56 +0100
Subject: [PATCH v2 01/47] mm/mglru: don't use stack pointers when walking
 PUD and PMD tables
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-1-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2764; i=david@kernel.org;
 h=from:subject:message-id; bh=kEXlYNiQWeqMYPtO5Vb4nXU0nymzCVHXtW6ux1YnkxM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer2256v+r64KNwb7oXRXbchL8DsTsVdVJFHuRImHuO
 1Xm9q1ZHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzESYvhD9/mT2dFj7Wqffct
 nXRd8fk7gdkPyxdo7bD4kys6+eDSXysZ/lc7b9U16thV9e2thKX+9d0xK38eTp3Zs4hT2P0qxyT
 NN9wA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 874DB40006
X-Stat-Signature: oo7m4x3aheu3qjrw7q914zy18opwadj5
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306025-995981
X-HE-Meta: U2FsdGVkX18A4NCOWjutHLzf3VYpsiBRnrUEyhHCqRO6SWVFJyestFPxu5LfkvlXlOGupwrhmorNzZDsDvV66gAc2E8vKVK4ShJUzlxoeu2P0OvCPLlO09B+ivnMCA+3cDecL3S13FlC2wJt+rZIunQQWRaUQZKxh5xft32ikxCyh2CSeFEik/WbFAhGGkju0f514hhSXY0PHjj4DF6I62gZuJp3gkPozXfS0y4uIeALeTiYW2hgWV4SpSEPLV3GZKVli0O1KnND0eCGr5+4lndApm8FrvZek90hw/aJKTNy6JeYRnCyZ8giCWX0vUn2UMcIfS9rvqstT8TtiuMVymoBJlR6hRlxTa/GiDFvqMeKGdDtZxXj/jo4UsFazhl6jzIxioUbnFonxtbtfHSGN46WaFaRTdJDfFDrz/F9xZ/xMxgVA2jgESM5nHUvnW2OEwGn7oZI89fkyfKLxJRIt1WUxSeUKcMq3okAM5B4EUidDgy14d8oWX/Ljg6iZ+WtSAZmcxQ74bahM6bv3tV+LSWfl4RKXRBb4X/zKLtvOTU6ifIHvKL9qOO4RjQcUFH2Wz7yGC4r9jkdy9esrRz9hhxhRanLIdK1wbbxsU94THkHQT3BxB2kZ2Q95TJUFHkZm8r1y3vAuE4UgmCn3xE1/6pU/pRNNmkdGGbDNigTqvtQlQ75oXG1R6fF0Std+4lj50WVKDoJYI2HSmjpHhcKGAxlKbwBSkGYeHodmv7wvQu/NmGyVgd0611KWEc3ou4owM4fsjHDfyebYZ/xnr0pGzZmbOqSG7wQvT4BFRV8XzRUKRRE8q2sIwP4m+R5nZXM28JzUtGT5f/xUM7y8WxjxXxzEW4yQfsYn/whFxlEmR16BP9F4bEe8UY7wiGuHHMoQm1mqfmbAtd1vn/i9C7ldCatyiklACuPwq7+H+isqV+j3UGzl14VN0EO35CaYggK0n4Ecw5l35idiDNhI96
 iMuOssXl
 WqWbGIuqPLQTJhzPwNNbf2FNCjByXrlFxmaztskzyQVVZ1sKHIWW9V4zCXcZrXZSWNfL36IMvZsBneSm8zHnc1To//YQr9i5PnpD6M9KQvFKn7RInZzR7kCVqsr4bDwUj/9mF0H/p5suKDoIocpYtj/Y6ayEColCkduMOO7XLaUCXNkrPRGa8CSitzg/4rBemRrht51G2CO5xzqj8L9NeGiF9RRoaxmYT5HSiRX5PZ7aFYsZfnDrXDg30JIJOWymwz19+3R56DEO93cH59JhNq1Ka764sHTZSDRX76Mhe1oXe4NWsWDsP1HgN4YTKK9RxAdd2/fSX/Clejk3wEz3hN8kOGtIYx3ddw/UVOycWIVS/0CR/cKmhtZY8BPwoIsewE0yJVvZjPfa6d0TWK5rmjjKptRkQHLNjZ/HLfKtnIb3snbYuXpa7v70kbewOeOX6OFTq5wic1IdO/5wlSQIeBLZI4pChjmI23HbSVxhrqRVyI76naFr4S4ikS6SiWTnh4J8YfuQCKuXPQw0BwouF+XwPgcmRKVIFMUEZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

MGLRU passes stack copies of page-table entries in walk_pud_range() and
walk_pmd_range() when walking to the next level. These copies can become
stale when khugepaged or MADV_DONTNEED (CONFIG_PT_RECLAIM) removes a PTE
table concurrently.

This pattern dates back to commit bd74fdaea146 ("mm: multi-gen LRU:
support page table walks"). Likely, earlier locking masked the latent
bug. Later changes exposed it: commit 1d65b771bc08 ("mm/khugepaged:
retract_page_tables() without mmap or vma lock") allowed concurrent
retraction, and commit cf4a65539c13 ("memcg-v1: no need for memcg locking
for MGLRU") dropped the walker's outer RCU protection.

The fix is simple, so just fix the original commit so we don't have to
speculate. To fix it, pass the actual PMD/PUD pointers. This restores the
RCU-protected lookup and validation against the live PMD. Note that the PUD
handling is required as well to handle folded page tables correctly in all
cases.

Fix generated by an LLM and sent by Josef Bacik in private.

[ david: handle walk_pud_range() as well, clarify+simplify description,
         adjust Fixes: ]

Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce8..6a1af9b92349 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3911,7 +3911,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
 
-		if (!walk_pte_range(&val, addr, next, args))
+		if (!walk_pte_range(pmd + i, addr, next, args))
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
@@ -3947,7 +3947,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		walk_pmd_range(pud + i, addr, next, args);
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;

-- 
2.43.0


