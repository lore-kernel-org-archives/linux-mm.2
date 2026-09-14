Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE0F6C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1D396B0088; Mon, 14 Sep 2026 13:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBA26B008C; Mon, 14 Sep 2026 13:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2EF6B0099; Mon, 14 Sep 2026 13:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A60D6B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:15:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29CBE1A01DC
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:57 +0000 (UTC)
X-FDA: 85213020354.04.59827DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1280D1A0002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eehZ0h6D;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406155;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsKk41GGGGEzfO9gO/cBvlTZcQPl0l5MThJ3Eulpjwg=;
	b=4AzNHkulx9iCD+CInn00FkzBJ7ON5Qdf//gWdvv3SQ7fqrBd6XRqFiOaUTdAvgiYRj5BSn
	koS/rNf9IwmIbNlnN0fouMrgz3E2MCpolG95e+Bn5QE4xNiA+c7UXCFnpKWTORIx3jVNNW
	X9rf/ygN1gQ1cYoh8emHcJKHs02mgZQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406155;
	b=VzAHNSBXFg+Ma1ZsXuUQ3HyeS1iiBdAopJDpGo7BSwzJ0CEiG0L84Ha13k8JTS/wtZQrMu
	eTwtkDkaqCyyV6XI0A+3evu5ipHbH5glD029eq6gATBgEYpRNcslkaSOsGOx1U22XhS8GB
	fj5ESRGjyAYjL1of6mUhC4VSE59fG8U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eehZ0h6D;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DECF743E4F;
	Mon, 14 Sep 2026 17:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B60B0C2BD05;
	Mon, 14 Sep 2026 17:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406153;
	bh=fyBCOw4+N6CRo45dsKGNLKOnvaUBAl4lgh7oeWdQpuo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=eehZ0h6DOvyjU1/3kO9RerxTBct+MQyAmnzRhu7M1/XVHwv1NoXrXhFEay6wtDcru
	 IeiGJQHYa/GYgMWJcTd4c5M/INUkfirmGXGh8qWmhWziKcEnwOx3QzRpLwotC5jmLl
	 LOJIVtwWOu0SMF6ujv3H0R4+C/JvWeNNBfN4oRvtuJyQnLHusJte3tX9ukeuwgWqVL
	 BTQ86klkkZ2HR2rItVWstOBVo2+20shiUw+bWLplc+4BVlqfkyu005PM1WNqCuJ3bh
	 T9K5/jJNnO/wv8xEgmg/Zu7+ErpZIBWZKpn61BXWWj0HnK4XYrbRFqFvcleeroHces
	 3kW9xdjJpb5HA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3750C88E73;
	Mon, 14 Sep 2026 17:15:53 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:44 +0800
Subject: [PATCH v5 03/17] mm/huge_memory: invert folio_ref_freeze() check
 to reduce indentation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-3-39878b37dfb0@tencent.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
In-Reply-To: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=7784;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=latEh40NnLWKMC/lwPwKkp8cUPKuNcUqCBFdrRonmI0=;
 b=LF9CwRSWO7QX2xtJGgU1N4DjLMpt/6TJD1KiYIIf+U42yUy3OysnwhHcRc57vnLNCfDKbmIVF
 qylApHUe87EDjJNSFbPiCuD9raUQcmt76Qt9iylVNZ5/ho0tDpXFTm7
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1280D1A0002
X-Stat-Signature: gigr61a919rjhm1rkpak1q37g4yyobdg
X-Rspam-User: 
X-HE-Tag: 1789406154-971295
X-HE-Meta: U2FsdGVkX194GYJ+xVbA8UVyiWy4f6q4nyi1NwSBR4HVujGkdXN2B9PEHRbaZnJ77XXxcyivIjgw6ERG0rUo+38ezDTFoQ4stLaU8CPkML9j8L8bltFUYMEBNtkC5I6IVQf2K0tO3rSAYwTg0CKk02TkQQHYfWemy5pacciUGCP65F47oE3+hIni2yxI7qSGEoguBoiWJxIrgElnfVL6Fd54GHSmNGhMVepUMyga4+Gp+swaYdwcjcnYm+BZyQc4RZFWTvAi26ICdWAdMwnzjtydB1k/KjhHycxmYHkQrv3v7ZzytbSYJTUJl4Q9ax43w3NZXN+Aw6x8DNqYWVkFfaJxlWeUGcHB83K8ZbQ3PaauUwOdDUvNJQ9sdE5m7titOX3W7o5dYdlUpTFoFQkvgB9nElpDoPcEBxy5vhZoqmkV1jYY8uZMCiGl++gk+saBdYaMYaHCyMKRXehgeAM21cJIyNhAhYdtT1iv3Z366V1OcVNZ87QjejYyWDNsCDDC61+QkBFLa68oOKccrMS0YGOjTuAtbQM3UW4D8iFtyGGduTeHW6cazX+C7AvjiStLe3iE+9hpyVINhrYsGj9tcDU0eIpoDbxMP0exp3qfFN5jDiOKIdF/odTr+dWL5auevQWYms4TNFmesX9RcU/IaI9ElKKg93qTRNkGsbn/z6m2PhdrZn1LJyQpBD+9VT0zZgKZDnoTCqnijOUj5J1g0wvp1esJcGYnU8ZAYyQ2Uq/KeH/sQl1FeLEjpPnRnaNURJUdveNcqrjnmTehT0KcxXzQGgVskULjLR7p90zMeM4jYnFPJ8YxS3tXJzN4AoZ3G7cnKdu+Bb5J6rfaCz3QcWIZ12VzWCeOTtboP7HEarmhJ3DG/wTz62iGqaOXDlyXlT/uPda45EGDRl1QeFo3mvm9lcUfPykG1A3EiVqqPYLfdFMDX8uoQO8C3qebcIDDWUkQJwcuLMQEx01iDKs
 YbB2h92O
 YnQuSN/MHK8JOLJ9WyRyXdeSJCKmIqChuJgNmYMPfXjwOHmxEhvDmr+mvVBGLwoMan8My3ogAweO8q5oAM0uWgDwVFyYV2kkIR3B9dqCUr6/lNUVFYSDdFcUM3dDeyRjVp5h4jS4b2pdHu0sPUAWuHCzDLd2Bi/geDCXUG9FZsp+zXBr2B/rRJ4wWgfhDsRNQ3f2l9fZTRQqfwTTCnkuscuK/TImPeNF+ItCixcA4X/Ns/4ETvClR6WXPI8nWIQi6AqoeaLA7dlgKS8c425PSzAByOAxlmeqUdEX+ohj6v2rIGxm/yL3IFj8OiZ2ZEt4HiCvAiV2yxF8/pHZCd60vPGKoxqjjx/iBMaEtUWleyYyXcmXlTgPvhr7h/u9sWydBgdzLG4vlhHYz582aNoi8aT6nlJmSeEvQ1cVgTWedz98jbLJOVbp1F44Hbtb3M2wFu7e60XHafzeDYbqXxrSc4VHGsh+mMVHD7rB7XaAfY+cSmm9XZt6g1aZ0oxH6A/xLNcJoe4OwwQ56Zf4TtXfvHpYj9VDn2PqllF3EOVH1CMeHDf66kyYKLMo/RA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Invert the folio_ref_freeze() success check in
__folio_freeze_and_split_unmapped() to return early on failure, which
removes one level of indentation from the entire success path.

This is a pure refactoring with no functional change.  It prepares the
function to be split into separate helpers for anonymous and
file-backed folios in a later patch.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 178 +++++++++++++++++++++++++++----------------------------
 1 file changed, 88 insertions(+), 90 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 351e8893808b..d9f0a3a9c9a4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4015,121 +4015,119 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 					     pgoff_t end, int *nr_shmem_dropped)
 {
 	struct folio *end_folio = folio_next(folio);
+	struct swap_cluster_info *ci = NULL;
 	struct folio *new_folio, *next;
+	struct lruvec *lruvec;
 	int ret = 0;
 
 	VM_WARN_ON_ONCE(!mapping && end);
 
-	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
-		struct swap_cluster_info *ci = NULL;
-		struct lruvec *lruvec;
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
+		return -EAGAIN;
 
-		/* Take off the deferred split queue while frozen and memcg set */
-		folio_unqueue_deferred_split(folio);
+	/* Take off the deferred split queue while frozen and memcg set */
+	folio_unqueue_deferred_split(folio);
 
-		/*
-		 * deferred_split_scan() takes the folio off the queue before it
-		 * splits it, so the unqueue above finds an empty list and
-		 * leaves PG_partially_mapped set.
-		 * Clear it here: the flag does not survive the split.
-		 */
-		folio_reset_partially_mapped(folio);
+	/*
+	 * deferred_split_scan() takes the folio off the queue before it
+	 * splits it, so the unqueue above finds an empty list and
+	 * leaves PG_partially_mapped set.
+	 * Clear it here: the flag does not survive the split.
+	 */
+	folio_reset_partially_mapped(folio);
 
-		if (mapping) {
-			int nr = folio_nr_pages(folio);
-
-			if (folio_test_pmd_mappable(folio) &&
-			    new_order < HPAGE_PMD_ORDER) {
-				if (folio_test_swapbacked(folio)) {
-					lruvec_stat_mod_folio(folio,
-							NR_SHMEM_THPS, -nr);
-				} else {
-					lruvec_stat_mod_folio(folio,
-							NR_FILE_THPS, -nr);
-				}
+	if (mapping) {
+		int nr = folio_nr_pages(folio);
+
+		if (folio_test_pmd_mappable(folio) &&
+		    new_order < HPAGE_PMD_ORDER) {
+			if (folio_test_swapbacked(folio)) {
+				lruvec_stat_mod_folio(folio,
+						NR_SHMEM_THPS, -nr);
+			} else {
+				lruvec_stat_mod_folio(folio,
+						NR_FILE_THPS, -nr);
 			}
 		}
+	}
 
-		if (folio_test_swapcache(folio))
-			ci = swap_cluster_get_and_lock(folio);
-
-		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-		if (do_lru)
-			lruvec = folio_lruvec_lock(folio);
+	if (folio_test_swapcache(folio))
+		ci = swap_cluster_get_and_lock(folio);
 
-		ret = __split_unmapped_folio(folio, new_order, split_at, xas,
-					     mapping, split_type);
+	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
+	if (do_lru)
+		lruvec = folio_lruvec_lock(folio);
 
-		/*
-		 * Unfreeze after-split folios and put them back to the right
-		 * list. @folio should be kept frozon until page cache
-		 * entries are updated with all the other after-split folios
-		 * to prevent others seeing stale page cache entries.
-		 * As a result, new_folio starts from the next folio of
-		 * @folio.
-		 */
-		for (new_folio = folio_next(folio); new_folio != end_folio;
-		     new_folio = next) {
-			unsigned long nr_pages = folio_nr_pages(new_folio);
+	ret = __split_unmapped_folio(folio, new_order, split_at, xas,
+				     mapping, split_type);
 
-			next = folio_next(new_folio);
+	/*
+	 * Unfreeze after-split folios and put them back to the right
+	 * list. @folio should be kept frozon until page cache
+	 * entries are updated with all the other after-split folios
+	 * to prevent others seeing stale page cache entries.
+	 * As a result, new_folio starts from the next folio of
+	 * @folio.
+	 */
+	for (new_folio = folio_next(folio); new_folio != end_folio;
+	     new_folio = next) {
+		unsigned long nr_pages = folio_nr_pages(new_folio);
 
-			zone_device_private_split_cb(folio, new_folio);
+		next = folio_next(new_folio);
 
-			folio_ref_unfreeze(new_folio,
-					   folio_cache_ref_count(new_folio) + 1);
+		zone_device_private_split_cb(folio, new_folio);
 
-			if (do_lru)
-				lru_add_split_folio(folio, new_folio, lruvec, list);
+		folio_ref_unfreeze(new_folio,
+				   folio_cache_ref_count(new_folio) + 1);
 
-			/*
-			 * Anonymous folio with swap cache.
-			 * NOTE: shmem in swap cache is not supported yet.
-			 */
-			if (ci) {
-				__swap_cache_replace_folio(ci, folio, new_folio);
-				continue;
-			}
+		if (do_lru)
+			lru_add_split_folio(folio, new_folio, lruvec, list);
 
-			/* Anonymous folio without swap cache */
-			if (!mapping)
-				continue;
+		/*
+		 * Anonymous folio with swap cache.
+		 * NOTE: shmem in swap cache is not supported yet.
+		 */
+		if (ci) {
+			__swap_cache_replace_folio(ci, folio, new_folio);
+			continue;
+		}
 
-			/* Add the new folio to the page cache. */
-			if (new_folio->index < end) {
-				__xa_store(&mapping->i_pages, new_folio->index,
-					   new_folio, 0);
-				continue;
-			}
+		/* Anonymous folio without swap cache */
+		if (!mapping)
+			continue;
 
-			VM_WARN_ON_ONCE(!nr_shmem_dropped);
-			/* Drop folio beyond EOF: ->index >= end */
-			if (shmem_mapping(mapping) && nr_shmem_dropped)
-				*nr_shmem_dropped += nr_pages;
-			else if (folio_test_clear_dirty(new_folio))
-				folio_account_cleaned(
-					new_folio, inode_to_wb(mapping->host));
-			__filemap_remove_folio(new_folio, NULL);
-			folio_put_refs(new_folio, nr_pages);
+		/* Add the new folio to the page cache. */
+		if (new_folio->index < end) {
+			__xa_store(&mapping->i_pages, new_folio->index,
+				   new_folio, 0);
+			continue;
 		}
 
-		zone_device_private_split_cb(folio, NULL);
-		/*
-		 * Unfreeze @folio only after all page cache entries, which
-		 * used to point to it, have been updated with new folios.
-		 * Otherwise, a parallel folio_try_get() can grab @folio
-		 * and its caller can see stale page cache entries.
-		 */
-		folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+		VM_WARN_ON_ONCE(!nr_shmem_dropped);
+		/* Drop folio beyond EOF: ->index >= end */
+		if (shmem_mapping(mapping) && nr_shmem_dropped)
+			*nr_shmem_dropped += nr_pages;
+		else if (folio_test_clear_dirty(new_folio))
+			folio_account_cleaned(
+				new_folio, inode_to_wb(mapping->host));
+		__filemap_remove_folio(new_folio, NULL);
+		folio_put_refs(new_folio, nr_pages);
+	}
 
-		if (do_lru)
-			lruvec_unlock(lruvec);
+	zone_device_private_split_cb(folio, NULL);
+	/*
+	 * Unfreeze @folio only after all page cache entries, which
+	 * used to point to it, have been updated with new folios.
+	 * Otherwise, a parallel folio_try_get() can grab @folio
+	 * and its caller can see stale page cache entries.
+	 */
+	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
 
-		if (ci)
-			swap_cluster_unlock(ci);
-	} else {
-		return -EAGAIN;
-	}
+	if (do_lru)
+		lruvec_unlock(lruvec);
+
+	if (ci)
+		swap_cluster_unlock(ci);
 
 	return ret;
 }

-- 
2.55.0



