Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B237C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DB3F6B009F; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588566B00A0; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42BB36B00A2; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECF7B6B009F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7841EA0125
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:46 +0000 (UTC)
X-FDA: 85246326732.25.5C15638
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6F4444000B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kfuYGiQZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199164;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9r5qhinRDZ/WOWHdF9dIwOMbKtxVCD6/6tu6v9KdB1s=;
	b=RcLQfP9b2mJYMG7B6dXl6s3PUjuPpJfUmiiGc0B/UzF1YJW/rMFW/Z2gvOGIuDGBpcJMPg
	PbSIonksSsyx96P1HLufYVCpJxwycSEoK/IlXNKFbg7IqhKSo7FtjaVIk2YfBrHV61N3wl
	G4NVca/8ERjxhWHdg1hxPr6/sPaA6U4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kfuYGiQZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199164;
	b=OTsbFCV2X2Ybm/4tTKlt542Mf7FiW+XWgDb964CXxwpGvKMMLrmIvgrGdG9ylXf43fGAsr
	cp77IeS5tl8ugTFCZZiMbS3nO5OYCj8dwT1ANcvXBWNziqVWDzye6A7Bqe6+9Tsom8fFls
	6hQzO/BncrPvgaRWl7Qg7j5B6P97EmE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4341843EF9;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0BF11C2BD01;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199163;
	bh=lxvk+d2PTRziyGkFuhfUQJlCysK6pDw0nqV5ypb7+8k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kfuYGiQZu0R3xO/YmQAV4LCsfb60HWXvEXlJugCurZLhpJ6GG7rMRzW1fSTEf2p17
	 upe6ykci2dT2f1Zzu4pd3taJKAmUy/0tExEPiWlqppY8IB/M8cZg6029XyxV9Qeavw
	 K4gc/TsLBWBKiRTo1cm/f2Ocvqql7cgkMc4lH3hPS0O953hSkxyDd4wZRH8NaxxY9K
	 +yj+AMJPcAf5iW2gQG8nM07aJzuKcgqhPOvofNDKzOw2tphJ3hfZ+osGaULDhZZWly
	 zlWFuJWonnY+K7nBVPUP1JJqyxJ6vQ+aD+NuiiIkAgI4lIxozXZk2X8rzXWLlu+dxl
	 56N3jU+U6ZA7A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4077C98312;
	Wed, 23 Sep 2026 21:32:42 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:34 +0200
Subject: [PATCH v6 03/17] mm/huge_memory: invert folio_ref_freeze() check
 to reduce indentation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-3-ba1b4ba72c6f@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=7784;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=tyKyhC3HjxOEHD6oTdGuiWz4W7o2CnGS6AQaMVDEp6A=;
 b=/2Uieid6+ENpSAQHNc5R2oOJ0WDr+q1oj3vrg/vQy397s6ljQneeMAyvfZ4RjnXUJEpS5vvuN
 vtR8//qXmOTBcv/z10vRtx7nzlZrg+D0IJderA2w2iB2FNpUa35vQVO
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 6F4444000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: g35838k95p1cdo5oqgpsb4c8ywi8wfz5
X-HE-Tag: 1790199164-710536
X-HE-Meta: U2FsdGVkX1/WNOU4x4TNYNwU7HBaLEGLd2JwlbpUZX9m4IVYIxslM2zru8Bx7sW3joXZUQZOQRKR33tZ6/hKa9yB+U4ON+Ab94sAMd+g406lzO+XENSKxADdApmlBZggnwEK+/AGkTTQObHXWXBj4S3YLVeRJQmj6dp9sojTQWL8yEoY2Ql/ho63nbNchiWhdVyl3pMy7QAgVBv6XEuGqBMJvws0GVOvOY0j4cjpIx5BOlnLnqv5J20d4ipUuZDSu4gg/NZgsYtcG2PW5g1QjPI3piLXVGDd+2U8gNiBgPPGNiMF8LnQb59hO62ZGWZ/VrpFKxvyCcEd4UN3sWcFIu6Q7xsQdoLjV4OTPfT1nj8OGK6jKToTqzwj3TdZW78F4cG2xdd2B9r8q8P5r2PGdzG1HzY1Aka68EX+vzOPM3kFmxjP6smQ6WWD0p6h6JtAKk4xvS1kabbRq7srOKFdIQ3zVvjnd/yCpKtq7IM7PJbRGklCyjqH0oYEBOjTX6sKvaZoG0q6AW8oHaVSkXQkQ2IKMX/nADq7H1oNNWHYzDQIQwlrVjs1B/MnMAdqS31W43lh84nnS00OHTfSTD//jlBJcz6Ak7sAhS58t7Wl20iWYO9nTRXpYGlreCHds2AcpXLT8MaZbvPoYh1KdiNh/VixGFcCsn1pJC9zcYxJAUECvoL5u9MBFp23Wp78QmglXxqNZ79clIGTcQjx7auAUJAPYxqPjheAerVEN0bgz/JIWelgANKh2hAY7phUMTC0nY2HxeO+NzWfF9yAmtIGPX2gTxxXDYyGnOSCqJAJn5jPEQCb4M/tHoKmypmUKNgSV1oAIkWSaPLUu/X6c6PfvPqeDAZ1KoOF8WkL+7XQdjGgiGwnjxsSHAotMsecVA0VHqQ9AZ/w8PcPEhmxPYtKXvSiy7U49p8P4R2S3RycM9aud2qN8c6o1XQKYCwgpPq7enQw6kouSloQYo4JvwL
 nZxn44Ek
 DCGmFI+FOjYCTJnjEHm4ZwXNa4NaxWg9SFy40tEjaejiiv+5JfEOscJ5SKFuPX/IP0HSEdgosEh7BRB8ASp4G0SJv6bAop2TKD1t9AgtZ/atT1myYwZuckKZ+p3+ngEasw4HG1f8EPTvSPMpSw76CzHjOSvkGtqt1um0efyAs0Gy8De+gQ7fqsA97CMJ3fZGaOVGwlBD+lDLwAch6SbO3zIDxySFV6dr7S5RKAlw7GHeqyPq1t3tg6sTXtbn0AOorM2ie5X0MKcuzGPm79XK/UAMBjzjY/HehBcFOTFQJRuIcNIgadbw0i8Pt2xCDIacq4UBaQ2a4a2DkHx4Rr+TC0k8inlwgm54Bgax8sMX0Ja4lAUiB88m+WvASUCvHqvdgOluZeiGUCfxL/3o6BfQ9McJKhlhCX5ZooJqTzeAWz45wIn1KgJoJb+BQ4WuvrnInRYSxnI/nFBg35plRTQaaGViEEllyqOk8L6FD80V/mh5KpbfkBb6sZ36p1AM6CAnQtBQVyHQlHylOte3L6WQKpVgs7Tq3Yxybq4JQRofL3xG9os9SO+mW0AbFMg==
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
index 2500fbd9197a..a475278e1e67 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4014,121 +4014,119 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
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



