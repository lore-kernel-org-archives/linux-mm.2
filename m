Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5685C98324
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 09:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D00D6B0088; Sun, 27 Sep 2026 05:48:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8966B008A; Sun, 27 Sep 2026 05:48:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE7E6B008C; Sun, 27 Sep 2026 05:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 569B56B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 05:48:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE1D61A0701
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 09:48:20 +0000 (UTC)
X-FDA: 85259066760.27.AF8F86E
Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9502A1C0003
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 09:48:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gGmnowq3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790502499;
	b=CJIgK8u6nPzOpk10M2Pc93DgNQbR6/gMdnsg5fmtl2zfdtvwFfqPTirLDlsuogTMkrQ+rQ
	EocV7DYQ1KX+9vnpmuX2mx8mmiikJaM1uv4hE0ddZp4MhkUtbfL7NV6E+K6TMyxd+F2w+Q
	sODlqcrhURiddzuDPzmE24GyyBRfk20=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gGmnowq3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790502499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cPa0yIDMvgdd1DDJzjJRHJJZbznRv6FGbQ/XkipObMI=;
	b=536HSPZZPp8Px2cFRu2bH6P5ZQ+gYkMzx2TtwhEl63o8kS5iEpq5PGATfoOyayMpqgpdzO
	g2x9zz65Nu08WEqLlZlRhNlwqwSsVhVvwgUa6Op0RyQBdpXjy6s+VhGngLevmhrCkdKIUf
	KIwPi6ZR5TwOaYATlC8w129tudxkFpk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5w+Y1CcKn/CttHaHw0/QkpxouoRBSJrbYaTBcdJOvHI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790502497; v=1; x=1791107297;
 b=gGmnowq3wfjygxut6JzuCkT1+itiNZ0Pm4dny//0BIfVzrE01qKftU+OzyyKQQTCQXPjjQ0F
 gAo9W94skVSOmbU/oRqWh7Ga0kifPThO88WT1yIQgcZM1SCayY18pwyU+N74ZOjVLAS3W6TU+d4
 tIzJsZ7CR/axRDojYaApeuLY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 75e904128475050b;
	Sun, 27 Sep 2026 09:48:07 +0000
X-Mizu-Trace-ID: 75e904128475050b
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	vivek.kasireddy@intel.com
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v3] mm/memfd: fix hugetlb reservation accounting in error paths
Date: Sun, 27 Sep 2026 17:47:57 +0800
Message-ID: <20260927094757.31665-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ftdec4d7uh3y7iedp6n3bud4ttnm9itm
X-Rspam-User: 
X-Rspamd-Queue-Id: 9502A1C0003
X-HE-Tag: 1790502498-283131
X-HE-Meta: U2FsdGVkX1/vnyLO/rI0SqDC/HLisrdIpBD6bWaRS82z1VOLGX83gf1Q1rktCiiDAWOCpLTGnv7UZbwxXTgJ9XSmI18LMg4xlj5UXOdEUQuF45VxkRL3PVqwl9WIJKMWPRQbVPM30kXesxsFb9cyqSyIm7fXKKGKWEyoBhkmcc++TQvUkpK0JE8yS28WQXkjJ/DRlh3iTaxr0L7LUHmOijtaOGbs/kLf1tGSV0I7nCmvDSXPlf44A/QQC1XuQBJQ5H++V8dAso/JzAAQf7LR8jewt8UdytruKOSFX/0Slh4ARURshu7TdY/+hsWCm48pK5bGyIuEaPl95gwkQYbvkdFe7jw/PvroqOx3U6x8L5VrsSRSfXmJIq6Tx2mgnErgHig0lnAsojEVDxnS44fD1zCq8moGGPfBub8FQR3S/rX70TYSCCMgbArCMnvsPy79DnAJShj+mTkQ9wqReTRgqvL5+if3RvZk51nXZnGMG64q8srVOSFvMnkTITXD8W7o3eLT5057FcawTlHg+Q5/LyXXkI2dy/K8AUnyBRFHaWm6N4JYnsTu0bumQwPeYAItdDQbgAc62qwv9ayNgU4GNJEyFiTKIuZd9NzFa29I1dJPVrz8eZiOg5zKIWna0cSBwia8wli9DXNIs5z0RHlFzcb++wb1irKDIdp/R87pv1B8V8ARFS14CInev3oSz7b2VPHzpSZ+74cfdaCkyWJypq/a6RvtFa8Z5/GoZd0mYGgmNO+wX7x/Up8wW4YSBTh3XPMQ3an2hESDkAH54j6iZVVJe6rhKKsUcvmh6P8Bw11zQL6QxFnFzuYpMeGjKycJz5lgxZcADSfGZ+2889qkNKqQHp6qCqRr0C/JiKRJK7jGN7dmgKnn8JjzuS2DOERN0ZAwPEj5TjJHQ2seOiGABmWa7zzOddNCJpo1l32eFI9Ql17Y9pPQEGJgr3fjcH1NhXq6kQoC12iNdq1USmh
 n7j0bfsn
 DzKG8nu6ROj6iBMPUQpFzY1w6jSW/q2xu51GpGnFIfkTvV9KBRl/ZrcWAYrZZOWziGIOkk2WTbgb0Y+raX9pijTf+1rrO/W1uJFvdwdEGN17jxvdOVUiv/6KYA9HkRl0rxMe3op/A44Ud/rgB/rW7I1FSZpwdeVdmhXI1ywAJiD9HCUfKN+km8AYPLmluVdMIdxD1K0YztsrbHLycifuQsVNGM/LBWwEmATlkWjQ77vcOEoSkYE7m7rJdvCo4gsPMNlRI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

If hugetlb_add_to_page_cache() in memfd_alloc_folio() fails with -EEXIST,
a concurrent fault has already instantiated the folio in the page cache,
and the reservation now belongs to that folio. Calling
hugetlb_unreserve_pages() in that case incorrectly removes the region
backing the cached folio and releases one reservation more than it
should, leaving that folio in the page cache with no region recording it.

That leaves resv_huge_pages one page short until that folio is removed
from the page cache, so available_huge_pages() reports a page that is
not actually free and the pool can grant one reservation more than it
can back. Applications using hugetlb memfds can then fail to allocate
or fault in a page they already reserved. They see -ENOMEM or -ENOSPC
from the allocation or fault path even though the reservation and
HugePages_Free still look healthy.

So hold the hugetlb fault mutex from hugetlb_reserve_pages() until the
error-path unreserve completes to make the reserve, allocate and
instantiate steps atomic against concurrent faults. With the mutex held
from the start, a concurrent fault can no longer consume the reservation
between reserve and allocate/instantiate. If a fault completed before the
mutex was taken, it has already added the region for that index, so
hugetlb_reserve_pages() returns 0 and the error path leaves the region in
place.

Fixes: 717cf9357325 ("mm/memfd: reserve hugetlb folios before allocation")
Cc: stable@vger.kernel.org
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
v3:
- Update commit message to describe the accounting damage and its
  user-visible effect; no code changes.
- Add Cc: stable@vger.kernel.org.
v2:
- Take the hugetlb fault mutex before hugetlb_reserve_pages() and hold
  it until the error-path unreserve completes.
- Update commit message
- Link to v1: https://lore.kernel.org/all/20260831090631.29227-1-hongfu.li@linux.dev/
---
 mm/memfd.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index c708d92533f4..0f6fff004f5e 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -82,22 +82,31 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		struct hstate *h = hstate_file(memfd);
 		int err = -ENOMEM;
 		long nr_resv;
+		u32 hash;
 
 		gfp_mask = htlb_alloc_mask(h);
 		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 		idx >>= huge_page_order(h);
 
+		/*
+		 * Serialize hugepage allocation and instantiation to prevent
+		 * races with concurrent allocations, as required by all other
+		 * callers of hugetlb_add_to_page_cache().
+		 */
+		hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
+		mutex_lock(&hugetlb_fault_mutex_table[hash]);
+
 		nr_resv = hugetlb_reserve_pages(inode, idx, idx + 1, NULL, EMPTY_VMA_FLAGS);
-		if (nr_resv < 0)
-			return ERR_PTR(nr_resv);
+		if (nr_resv < 0) {
+			err = nr_resv;
+			goto out_unlock;
+		}
 
 		folio = alloc_hugetlb_folio_reserve(h,
 						    numa_node_id(),
 						    NULL,
 						    gfp_mask);
 		if (folio) {
-			u32 hash;
-
 			/*
 			 * Zero the folio to prevent information leaks to userspace.
 			 * Use folio_zero_user() which is optimized for huge/gigantic
@@ -112,20 +121,9 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 			 */
 			__folio_mark_uptodate(folio);
 
-			/*
-			 * Serialize hugepage allocation and instantiation to prevent
-			 * races with concurrent allocations, as required by all other
-			 * callers of hugetlb_add_to_page_cache().
-			 */
-			hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
-			mutex_lock(&hugetlb_fault_mutex_table[hash]);
-
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,
 							idx);
-
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-
 			if (err) {
 				folio_put(folio);
 				goto err_unresv;
@@ -133,11 +131,14 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 
 			hugetlb_set_folio_subpool(folio, subpool_inode(inode));
 			folio_unlock(folio);
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			return folio;
 		}
 err_unresv:
 		if (nr_resv > 0)
 			hugetlb_unreserve_pages(inode, idx, idx + 1, 0);
+out_unlock:
+		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		return ERR_PTR(err);
 	}
 #endif
-- 
2.54.0


