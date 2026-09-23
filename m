Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B34D6C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3ECB6B009D; Wed, 23 Sep 2026 17:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15F56B00A0; Wed, 23 Sep 2026 17:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B596B009F; Wed, 23 Sep 2026 17:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC9516B009E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C15E160157
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:46 +0000 (UTC)
X-FDA: 85246326732.05.9B48C93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3D53416000E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pMj/ApG3";
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199164;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5ruh4kZESFDjAyQs4zBp0bMPXXtPkFx5EkduJcpQQ4=;
	b=CNpzk95ejAscKBdUDK3jA4fq0XdJuQ0rFrHSvT8E7SDyfrThhrEuYdap706eStjQYtOgWu
	ZItT8R6RMnOpACjGXisu/AFBQ8mOgW9U/liDTAU/fK5Jbe+t+Gbz1HeJ2q+ux6UfXcYupe
	7HwR0d4/71HNfBczyw05FjEXy84kmPQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pMj/ApG3";
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199164;
	b=Xx9UwSg40I7zaVe/GRcVDT2JkK+qeidoj5bRLvem5HqkS/fuiYR2r1UaJuksyralLBmRZD
	xjnDUw7UIxcXpS6GsQQOQphvyPQQ+wvDVlnOWHk9B049o125wF7Zm18fjNk5BXD9YvTWgA
	OOVE2KGOezLTkWmb765sLjjxJbtrfNo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C01143EF7;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F16ABC2BCFA;
	Wed, 23 Sep 2026 21:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199163;
	bh=AlG9b9X0RGUOUnaV4lCSu0L+6PtqGMzvhv4TLKbM208=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=pMj/ApG3ZDXO4DysHJStGRu52DpPLCKbuSj+eGCfgzqlVsx4ajFfzvpo+acLJkGbV
	 jvnYYq6LddJT7OilFCG++BLICd0ynoxEV0drCb0bz0yFwcVJYvC3ScENCxMwHdgZ4M
	 lLh7v8GDy2YKN7CDXnCsEKhkdf/YNGJlizOsEnn8N6YffTp/iB823ujnSqtrgd6pm/
	 xD0Hz2dVUvqJhHzJ95cbX/ynC5l4FRIIj0WvvwbdX4SkmrjuYHgA7GQTPNGiqytbhb
	 pGeWrD2Y9YVk+ttw3pvtlOI7hQnA1wOhpu+8E9oa+T6VVBFEQaDuQUlUyYRho8xEQP
	 w9Mu4SdDhHpnQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF98DC9830D;
	Wed, 23 Sep 2026 21:32:42 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:33 +0200
Subject: [PATCH v6 02/17] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-2-ba1b4ba72c6f@tencent.com>
References: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
In-Reply-To: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=3844;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=r8O7IxC0Y3pay3mFjqjlnT64x3uz6sA8DPmkIPqd0RE=;
 b=eGkwoI5fC+OmgprGowmfNfI6eQgDDCAuA8gmp8oDZZv08ehu9OY+GY0DCCIpio4jRxVa7WegH
 csogviooyBkA9cHBdKwQGIYK3IuJoMGlUmjgs/1OM+9P8/KJxmMPSKO
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3D53416000E
X-Stat-Signature: 66y93zdywaz6cqfgu4rj98bhp55ppf88
X-HE-Tag: 1790199164-674375
X-HE-Meta: U2FsdGVkX18zk+6OKZeohpc/P95p9nrcqope/YZj8GSPCqXd6keZm3tKMrQz9oETM2zLmy5b7dL7DCmNCQbMacPmLPkze2yUyxax+nunmjnoY+HeZ+LgHS0KprU3x/ys4GIgOyzw69ty71GNzb0iHJXIbBX0ft1Az5W8MDrS4+JV1Hqs41qocwoBuIc8bKOtp2OBcsPKD/6uZMcnYfuMnj09UcniLBbiFD2G8FvjSgjik9MM00/jQswaPDu31qEJicIc8jxk0rWUMdG2sPgsbRGIDIRENq2biEgKDz20/Mi7yXowtLpvtk4jTrU41aqH5lvIxl+n9iRSwnmecYQy44YoKKM+ABf/ZXpUJfxLgUGlQx8l/9vXHzyX3dmIm3cXEmJMbwkRbg5eOc8ht87zH84/td3dq6KhtagNq3FK7XX9ahn9V2WJK1Ko2WvfnJ1m2KgMQisdR1lzZIPuMmXPpLMBZSzDVekRQtGvyrxCtNiyyyNruJmMrD+apogTwB5Ww21vWyIecQvFpb9HAPfvJcDhElNqx/er8J1FCQZFOzqtmdlKkpALg7D0WAJUuZhqYPseHjVHeTNTyWlHZf8+A6kMd5bjimdK9YnUzkyI/ja3ldDShCpE1OKXH6dV02y4Qh4g3TIeNfYEAc7PkBGKdb4KsL3OBQWHYfVPVYjYNPBGQGO1sBaHzBpfYNfBLocGI9ffc8kIZ9c6tcPmlyC+jUmGMxtN27Xy4/ISK6D1+iYm6qZ415JUBIZukfex01V0H/Z4QGZ7uVb3KrpjFTOzNqmFIHhBMCL1nNj+oVDyGaKZ9JBVku36xAdtTkGcZHbqM15Q4ao/ZfFu14tzhHS+9swoJ1wH2/8q/lUEVC5RY1TjCqqHQzqqOA0wUGOSKVcsZc+StBQwOUQCPgelOXL6b6comZjnXAGXWag7yHY5LMSTD8MaQ6UhBNwFSQAyBik31kb/J2NL7Sgb1HwrfDL
 GIqBDgX5
 GDtiRWmikZ/cQsUR7I13QP7KNHmCBaGqHoTy6SMKWUA2XGGe1wOs4tpCvUnYxVy5p+o5DsniBwZEC7cJiC+rQLIQwogRccuvT3/CiriF3J1d4Tg2TbmGnJMEAZ+hGbqMKuwPiwEoTu1xCM16Xhx+GaQxQX+FsrYkrTQEP3t7AHpZsHlLT9tZZBn+znneEL4W2ZPKIyqHSprUB7+6XlcB5BZiNtLXgCqJMxnyfDnHVExqrR3WDgyuN+Q4UgZCFLmBNDZdWmwYvX9NRkUQBhxCdhwvI3UJAbIEltaWDqIB+LKuMdJwkli2+25fZpL7Wep+9oDQXwYtke4VWaWP2i2BUqgAeiK4jqaCwirwtqk6+ZuXbcjnNsVCfzthz5yVwXhTBNPAJjjAhpj0BOMrx8/gO0uBO7F5FAlze1xkhruw/KbBw9NTThU4Hx+7UyzHVd/OAQSyO3A9afaJfblqjyFDkG9ZaCKaQGwEbCRuECridLuThDQ4a7M6O9F44nBUy94F5iD7TXA521fknUJ34+XheTKHYROQMbCi5arGcd2zRwtcZSJMVL4O7vwJZFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

A folio in the swap cache cannot be split if it has a mapping (shmem).
The split code does a defensive check for this in
__folio_freeze_and_split_unmapped, after the folio ref has been frozen
and the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented. It
rejects the split and returns -EINVAL without unfreezing the folio or
restoring the counters.

That error path is buggy, if it is ever taken. It leaves the folio
frozen and stuck, skews the counters, and fires the
VM_WARN_ON_ONCE_FOLIO for a state that is actually legitimate.

Check for this case up front in folio_check_splittable and return
-EBUSY before any state is modified, so the split routine always backs
out cleanly.

Also fix a bracket style issue that checkpatch.pl keeps complaining
about.

Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a4984e14909e..2500fbd9197a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3933,6 +3933,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type)
 {
+	const bool is_anon = folio_test_anon(folio);
+	const bool is_swapcache = folio_test_swapcache(folio);
+
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	/*
 	 * Folios that just got truncated cannot get split. Signal to the
@@ -3941,11 +3944,11 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	 * TODO: this will also currently refuse folios without a mapping in the
 	 * swapcache (shmem or to-be-anon folios).
 	 */
-	if (!folio->mapping && !folio_test_anon(folio))
+	if (!folio->mapping && !is_anon)
 		return -EBUSY;
 
 	/* order-1 is not supported for anonymous THP. */
-	if (folio_test_anon(folio) && new_order == 1)
+	if (is_anon && new_order == 1)
 		return -EINVAL;
 
 	/*
@@ -3956,7 +3959,7 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	 * swapcache folio split. Only uniform split to order-0 can be used
 	 * here.
 	 */
-	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio))
+	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && is_swapcache)
 		return -EINVAL;
 
 	if (is_huge_zero_folio(folio))
@@ -3965,6 +3968,15 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	if (folio_test_writeback(folio))
 		return -EBUSY;
 
+	/*
+	 * A non-anon swapcache folio that still has a mapping can only be a
+	 * shmem folio under SWAP IO, it's removed from either swap cache or
+	 * shmem mapping afterward. There is little benefit in splitting them
+	 * hence reject it here up front before touching anything.
+	 */
+	if (!is_anon && is_swapcache && folio->mapping)
+		return -EBUSY;
+
 	return 0;
 }
 
@@ -4037,14 +4049,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			}
 		}
 
-		if (folio_test_swapcache(folio)) {
-			if (mapping) {
-				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
-				return -EINVAL;
-			}
-
+		if (folio_test_swapcache(folio))
 			ci = swap_cluster_get_and_lock(folio);
-		}
 
 		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 		if (do_lru)

-- 
2.55.0



