Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98B5606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iLdA01ou
Received: by kanga.kvack.org (Postfix)
	id DB0056B05B3; Sat, 31 Oct 2026 05:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D61436B05B4; Sat, 31 Oct 2026 05:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4F896B05B5; Sat, 31 Oct 2026 05:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9FB8B6B05B3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:40:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 329D3A08FC
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:40:32 +0000 (UTC)
X-FDA: 85382426304.10.8D6FF25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5CE3C40006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:40:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iLdA01ou;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vhzYAmOdAkqyGhBWNfdsKGQhygIIdv6/ZXuoCf/3yVw=;
	b=686tbZKQiC6esqoulI+J2M0/2tYFGDTDpd4k41klZ7rUgTZwn3ytq+HhEJlMjm/Qearq8o
	/M6/9f7cAEOpKYanktjZLqYhGOM1JZSVL6Fw5UZo2J3Lj+5GaZNmcJP4IcL8Xo6nY0SYt5
	ZLHtzChkazV2BXQPOicKlOE+t4QTb7c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439630;
	b=RWUZmC55lvUU3MDkLkunsyxIAcI0ekxzIUfQj6rq6zvP/m/C63WGKSD0cdmvmY3g0Z0wON
	pJUl4MjzPIENYtSodI98NueLscZ8lMhXNZf6DsJs0m/K2Qm75u2cXVQAZj9R00dAUK78G3
	mjwj4lzUu8f9CvHrT79LaHMihZ215FM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iLdA01ou;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E43943D0D;
	Sat, 31 Oct 2026 09:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE891F00919;
	Sat, 31 Oct 2026 09:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439629;
	bh=vhzYAmOdAkqyGhBWNfdsKGQhygIIdv6/ZXuoCf/3yVw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iLdA01oulWOO6dYvCP+CtRKKHWVIi81CZdc7tIY0Dv0DRrOCh+iPbwNtueXAYD92X
	 Qcgd0tHi3SkRiMvKjvpNjilGV1OUQyFkVExiWCHoRLnRNf3Pg5Quf82DyuCipFvJ5E
	 eveba1t1+pQ0Frfq4xnnrxG3rjX3rvSC7U+WnP1cDs35mX/LmePYgMcd5i0fRatOpU
	 K0EhSHEBTWngDz/8AHMg9CqlauhF73UCYeWW+kZQVnCJZdA6x8MxrgdzmYs95gNe+f
	 Trzk2SBQLZAoy7Sv9Nr/OlxoHxjH0BXgihgLnMIG+CuFpzv14vabuGlY9p6/yQUdK9
	 rtmHADN+zq7bg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:30 +0100
Subject: [PATCH v3 01/47] mm/mglru: don't use stack pointers when walking
 PUD and PMD tables
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-1-d6437171ecc3@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, SJ Park <sj@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2804; i=david@kernel.org;
 h=from:subject:message-id; bh=zbtgr6vf31Mknvg8yOsqXmy9ZbpWPb8teGHpWqYOrTA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk99XM03S8lEQljolPcxvX3C3cw/nzuZuYUnfdt6y
 0Fde9XrjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACbirs3I8FmT9YONSo2yefGp
 zZ6B64/OyORR9zl9mSHu1nPmfYwLTBgZfm6qjWJeGrhwzfpj/wy9HNQMl3z9rPpC+33etU8qqzy
 s+AA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5CE3C40006
X-Stat-Signature: aoi8z4iwtatqesgaz6crmbza6zc55h9w
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793439630-992040
X-HE-Meta: U2FsdGVkX18QYaUoe6IEPdHkSx1KTFQUJ3sXbeziWG0zlp1UWKrkZab0oo7SGmx3IixdsreYt+MEqAoXt3wvi7s5hVXh2fvojeg3NO+UirM0WEhk0N/xuxNsXeulcm0STkNBkeW2ZYBxrKb+kUTd6f6YUOtrrGPq3BfkaIhqrnyiQAszHn7eVxALA+UH4ED/ykltb4wYq3/8WDTpOgE7n4Q3ty3Oh+ZmsuGaijI7w5IJBAvy8dgAZwAnM8y20mTrbKYw7Fg/zp31/o/fmrNcK2Jqiw5+NJkW1Wq5zh2eZiLlSouiZf1IwdviM7nt8WXZgkmk1JuPVj5QNmc4k/Klnr7+FIDhMqD6enyBJmax/kca+rzxItOlywTK6VTPIS3M4idvx7Fo7fWcHOjgJT1tbSvkwJhtPuVLSJX/Sq7PfsaiRidrLvb5mbZFVoEjJvdnxrPIRLUOjsOmzyj2zP2nWmCdrHGp+l08Sev0qAzA886UZhW9rmMtvSpUdBSgbpfoQbS6s6/+v+J4coNyAecca1lmFBFC0IWBvBJdI8IPIlEUiIC9R8EmIz1+i2bZYGJYwPsuZOlGUDNI7o/Y69ays0gtixl0ow4AjpH9HBAe/c0pPsUHILFr8FDQOf2Q0zyLrQDyqCvfIJDd54p27uIZodRO8Ic/pOxaWTESeYFOQcuq9BRJgw0HS3LExj0xaJn7TWImC2yW0nzncqrDpQIaC2CJxCisrMAyMD0wSSTKlL6TqwmNA2tre9v775NySW7ZthP/5VDLyR6DGJCxfK2hBNfpmmZwJDdUUQvbxM5Oy36Fwp2KGaYQNhf8DX2PjPs1RBB7tN/pJzGotayZDcBB3tLmFDL6+49XgwcGnFF+gp+pUE+u0pK6vtUBJjRqbqSJEK5IGfwZVHs2Rz+WR5V+Br28yWZIAmdD9x3bs4wzst5Ds31WzNWxClRkQOHtgOTwi2WQ39pLHcXMSUReOOm
 VlPQmCLZ
 nuA+HKbnfoOxRRfF8YXUT79GQle9rawZL9Bei1/ztw6znc8oQ7CkugqG0gFYRuAGvondWcsqLYfw/EvzEID2YQTUvoNhBZ291IotHZxhVAZB8LrBNj7bvNfSTya45abpFvnm4+HhW51eYQ6r+FDRND6zzbGLrZuQdUowjyCBi/g7FseGc7xGkq1Vf6G5i/uBLG0YDSrG03D7zvyFmqUwwIZMMbfxiB5oWX0BC+JHBAqYpKonacBiXtg/3E6KeKnP4Scvsvdv/nDiQrFNDLWIt1fbdFxqyrD6PRIPf70nODHHF3NPjMx53dhyM82JeQSZNgz3g2dfrclxr3umYLb9Nt2191v1qcCdO24xsy2QhO3kzOIEcgLxUrFJM4dESXFWYgSTUtL8jTCy+T9UmNsLJjefc0sgoz3Fw9Q70je7uP5MNLllGhSHaNA14mfFRvserHTn1ahAopxKpWqcU7Ye07huU7V1Vy0hhQ30/ObrTRvVIiPupL3BnntUXVt+9qZZRBluVtYc4XwgCOBfKNEmCBqPfI9Gd9UMgFX+q+GmEIo7iK3A=
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
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce83..6a1af9b92349f 100644
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


