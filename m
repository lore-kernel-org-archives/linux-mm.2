Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA0CFC44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A32B16B00AB; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FB536B00A9; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B2D76B00AB; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CD106B00A9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8472E1201A6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:25 +0000 (UTC)
X-FDA: 85018036530.11.FE7C0BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7FF32180004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SYOW2JrO;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763683;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8O+fqQsckXEH+jpl5Bx5PjrrzEZThvXm9S3Grx0d+M=;
	b=AtHKlg281GfafwZ2/jHyf6oUD+VVNsipDfnzQPlvj0Kn1gpkxoUquYh5/tqyWRtMhjhyOt
	37MTFHrul2Lr5sgWKpsSVt5RfOaac/8OCSV0wgHwKcoUca2sRbCnq709rFuKF0CB9DK8yr
	tSBDg/9j4K+gH9uffUQwLjk5i1IedSI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763683;
	b=RW9TzNQHC6RcOk2VGIYAGTQjJyhZNKCTnH+WIX0R9kWImtmL7pNiRJE81sXj/yaJdh3T5q
	1RTt3OW0E8WdamFcsuq8EememKx+la8CMFEwiXJzKicxwlA4OCIVqjr0t0WOvtStbLgRiF
	cFoi9aX3t2/ZDr9DSVuL969nHFjlNxs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SYOW2JrO;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A73D45105;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1A708C2BD04;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=v842uTAMaAywtG7oyLP8iPjSSWfoAFBKwZA8emE/Hno=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=SYOW2JrOWetwvA2auCJtx5rX+NMEj8Shzph9S9DnmswH+JqUzRxXseW+OGjBOzayv
	 XEPm9ewTfziBv9Ftg0n8CKdQ8EVzU535UWxwerrcpG3ySn8PTVfJN/dTxaDLStsY/K
	 9no8aN4qTHc+CGlg/LWll/ynR9E0mx2+7P2EUf+NhvlZ8L6+TRVBPHlcqb8vVba6+Y
	 1/G4QspWHW9SPax4fTW79WZpCBMQ1OK4ymihO6PF63IdixgHm/eCepa2kXU4NRKUJW
	 +1nGXHho5KPL1LqY5ZZGI80sacshSLyd6MJvWjaD5WBlKffRQXJuCcrwRJDCKoefE4
	 ug3Y7cppIoQZw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A7EC4453F;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:13 -0700
Subject: [PATCH v4 05/16] mm: hugetlb: Fix subpool usage leak on allocation
 failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-5-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=4429;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=aioziCwNl1YhUSW9QJsopoiM0FNET1b5J61jDqmRBgE=;
 b=EgFMKfYcEA2o7aDdaYSsd6UI7TTvR5GAm70ONUg9KMMDn45zAWhKmQCqMLfU8tl73gxpDjjB4
 l7LDr/Y+kTGDj3eEZeDlBJW0M2vKZYYopIAGmS2bhziu7J6FHpt5CR0
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 7FF32180004
X-Stat-Signature: eo5gtxp9g9kdp57c3is1naztt9di4w1c
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784763683-463981
X-HE-Meta: U2FsdGVkX1/+ZL1MIjWjuaxgqX6iJoTehuO3LYTgRcbHYoPeKlz3gEAnIqXVP1RfBuuVAiqAj4TBWoxUybYS2icON4iXKYNgvXhGmQwvp1P+xyUxixOyEmy7FRUOOg+K5+YAYpHTy/cia37e/0GzZpWCJ9RyYeAnzIX3hI01iCRKDBLf4X1qGZh2iXVpBImcHwItnYEBl7E/Xj5obrIFOk0CvpXhOIhoLebaPTd8/cuTY22lsbXupkLbYOIIKA/XrE2KM7wLCvo/ABGekO5aXCPPXqwYpmf2b7WYT1orGCPTOH9CKNGtXPvC4unGAL9RSFkhIGOCXihp93YvzElvNrTvV78PPHqY1GBB3tgk+4P+xxnXOtExTYchGGTh/l0fjkfMp4RC/kPAZFIcuOnwyyhyL1vIiGdY7rFGdpIJGzNQzj3qLbQW6HE4hc5yj0MfnZhuku/A3bsyOBm4MG1JBYyCznM7bhDr2kx0poUpTf7zPLN4YmNRaQO7VqboKNKmJfGDOKxn2XryCfopG0x1vP45flwjlzpbQNb4WDB6CAvSo9N8wZqqnyuuBqKB9GaTSO0+DIPOZYanc6QpHZzAMz9587zUnfnRcWlgSb58JFfM8xTDanFoF1qOAoMV4z6B4BfBxRpPrWfrGB4PwC04Ar15F597OfrSkprbWwswBsAeJ5fCFAxSP5SOW+T8t1SkbJb1/ZcvvlzMArtDJW5MCDWl3wTArg9Wr3NetuIw+VSlj+W1ABcaGQMJ/4IeJwblryGiF+GfwVM3+RBM1/nS/xKUqGHTt878trSV7yV6UH/9L+P03uXGAc56Eb21rHSbi9Ld3FaR7FdQL9y4Z+IsRqXXTHbC6zEiOks3AvAxuA/Y0VfJV+0ZHcXdCdUTEfVyd8K0xnKAPenA5uLHI9ZfKaD2IzES1WNzsm3p3CBX734dyRf0baKCsQcB8QCuM5/UEsBXzrij/imMoT8WbL+
 I0jioCbM
 1tDBZFGOzZt6BJAT5ndYBvpLXdy7/ebLd9O8BlmHm/hiv4ha6kiXpEPmaCkyFaSGkAat4jAutLBDJhbMXVbVVC1slvO6yzJRvC8rV8Q6EXCY/6QgCxhW1sWf+tiU71yRpJDhs41aLQep/WrhJO3jJDoipYa1Ia65o+AcTIM3jwoeKYXWshqLuPZAWj8v2ClsrFrGWOIM0gevlIGjAKKSY+iK/1yPqa5b+9mB5FJ8QAeIYaEo6FhYoJXDOFS/CCs8C+6wO10kTa6PDYUaZMrBQAT0O0xWTkdEUPXi977bjB3WxLWJ7hpGtSLRJG/xW0rCq4SSUmcYg7FmSaSWqDoh7VptwRsrUNBRMg+WXkh6dCzyhsCk/eq4u96B3hLCQJ+wHQOQWqFpF7VgCYusIesv34LWCN5J7Q5n6RuvY/QFkExGwGrUBCyQ1X1/qnS8rXkYZZilGnJ4KfGRl1gIMdI5YGTGxIbqs+9UMKOu8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When alloc_hugetlb_folio() fails early (e.g. buddy allocation failure or
hugetlb cgroup charging failure) and gbl_chg == 1 (meaning a reservation
was not used, but a global page was allocated instead), the subpool page
acquired via hugepage_subpool_get_pages() must still be returned.

Currently, the error path out_subpool_put: only calls
hugepage_subpool_put_pages() if !gbl_chg is true. If gbl_chg is 1, it
skips it, permanently leaking the subpool's used_hpages counter.

With the earlier patch to always track used_hpages in the subpool, always
call hugepage_subpool_put_pages() if map_chg is true to consistently
restore the page to the subpool. Condition on map_chg because map_chg also
gates hugepage_subpool_get_pages().

Opportunistically rename gbl_chg to gbl_resv_get, which is the number of
global pages needed (because neither resv_map nor subpool reservations
could be used).

If the number of global pages needed is 0, this allocation uses a
reservation somewhere, hence proceed to consume a reservation by
decrementing h->resv_huge_pages. If the number of global pages needed is 1,
reservations are neither created nor consumed.

Also rename gbl_reserve to gbl_resv_put, which is the number of
pages the subpool could not absorb into its reservations.

Adjust global reservations using hugetlb_acct_memory() with the difference
between gbl_resv_get and gbl_resv_put to take care of possible races where
another thread might have performed get or put with the same subpool, hence
perhaps requiring updates to global reservation counts. (If gbl_resv_get ==
0 because a resv_map reservation was used, map_chg == 0 so the entire
subpool returning is skipped - still correct.)

Fixes: a833a693a490e ("mm: hugetlb: fix incorrect fallback for subpool")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5ee1bc5c00bfe..879e4640dc50d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2872,7 +2872,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct folio *folio;
-	long retval, gbl_chg, gbl_reserve;
+	long retval, gbl_resv_get;
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
@@ -2912,15 +2912,15 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 * Or if it can get one from the pool reservation directly.
 	 */
 	if (map_chg) {
-		gbl_chg = hugepage_subpool_get_pages(spool, 1);
-		if (gbl_chg < 0)
+		gbl_resv_get = hugepage_subpool_get_pages(spool, 1);
+		if (gbl_resv_get < 0)
 			goto out_end_reservation;
 	} else {
 		/*
 		 * If we have the vma reservation ready, no need for extra
 		 * global reservation.
 		 */
-		gbl_chg = 0;
+		gbl_resv_get = 0;
 	}
 
 	/*
@@ -2949,7 +2949,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 * from the global free pool (global change).  gbl_chg == 0 indicates
 	 * a reservation exists for the allocation.
 	 */
-	folio = dequeue_hugetlb_folio_vma(h, vma, addr, gbl_chg);
+	folio = dequeue_hugetlb_folio_vma(h, vma, addr, gbl_resv_get);
 	if (!folio) {
 		spin_unlock_irq(&hugetlb_lock);
 		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
@@ -2965,7 +2965,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 * Either dequeued or buddy-allocated folio needs to add special
 	 * mark to the folio when it consumes a global reservation.
 	 */
-	if (!gbl_chg) {
+	if (!gbl_resv_get) {
 		folio_set_hugetlb_restore_reserve(folio);
 		h->resv_huge_pages--;
 	}
@@ -3022,13 +3022,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
 						    h_cg_rsvd);
 out_subpool_put:
-	/*
-	 * put page to subpool iff the quota of subpool's rsv_hpages is used
-	 * during hugepage_subpool_get_pages.
-	 */
-	if (map_chg && !gbl_chg) {
-		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
-		hugetlb_acct_memory(h, -gbl_reserve);
+	if (map_chg) {
+		long gbl_resv_put = hugepage_subpool_put_pages(spool, 1);
+
+		hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
 	}
 
 

-- 
2.55.0.229.g6434b31f56-goog



