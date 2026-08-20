Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0ADAC5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ADFD6B009B; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15D4B6B009F; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19F76B00A1; Thu, 20 Aug 2026 14:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC6B26B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E60C401C4
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:31 +0000 (UTC)
X-FDA: 85122551262.08.69A6FA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4137C18000B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EK3WsBFR;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252129;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUnOaSQPAqHOKi2xJKDiueezHtrJkWHJGTvG4QB0iE8=;
	b=iV+vSvP55xEiniKLFLlxw1FHXtrH19C3WHnHmikVYeXWzjAcc7A1OntoRxjswpAC9OpQ/U
	t1Qk4syd/fBG1YcrwU6eG7qDEOoVURHMX1gP2EHAypjV85IMyseO+rB8AmrW266P8M3b3L
	Q/jgMdmdh7J6Na+Br7s56rAYrxr8Wg0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EK3WsBFR;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252129;
	b=fz1xEfK4uDPWUUCov3ig0RR7Ufy09ei8w7/wk937/Z0FWbl7O0XNcyppnKPVrlK/AmTE9Y
	oHO9bPwnTQZBfXrVa9x/MuB9XLSBM4XrlEMOu0gA+2oI9Vixpkg3Zr3xtuwARopZh+cyPV
	V3e1tz+rPDaMKVi6vWp+KE2KTpDbd+k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1442144588;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8A65C2BCFC;
	Thu, 20 Aug 2026 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252128;
	bh=+Fhq/ThhPdJvanb/xrY423riYXh79oib+Ae4a1g8tWE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EK3WsBFR4L+foI14/kCgTqKldpA+4IgxTJyLvAQC7jCVL4+Y05UpEobNMLN8oPa1n
	 LsZoIdO+mz3y8Vj6IAiGzkInSpB85b8mjheOptcFdgiIzU0Ul0F0NfMdKYjS15h37g
	 Sne4FEB2CVDC2Ze4cIhZCKer4vZMqzvtIGr21ZeGm2L/Bv0EFde5Fto9knH6rOA3aj
	 mON2qL0/p/VFQBk3Z+H7b2rmkbYc6J4v2XBqLopjHoUv8OjDv0P/S6iINMrpuzw3ix
	 dUrYdnpKcMqh4G/hLqiH7HJqPbS7hea5uGSTXi0uk2Bsuxuv+z5RjpqUJaQe9ClkVI
	 /Cl+kpfSBEsEw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE71AC5DF89;
	Thu, 20 Aug 2026 18:55:27 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:16 +0800
Subject: [PATCH v3 03/18] mm/huge_memory: invert folio_ref_freeze() check
 to reduce indentation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-3-9b43f5163238@tencent.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
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
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=7863;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=UY6iMKTpGLPfiYtzBDed5IoafUyCePQg/1v3UphPlKE=;
 b=l0sPmEqPmT8nBCikfRluoTynOrjtdDJng6/asUYQZF2y+2hhTjyJUEQF30etsd6v5pmNYUflh
 xbvQ8SDlDgrCKDbmn0g/Sie1J2KEftxrbFKTx9x5DtXt0OtYtOo9P1O
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4137C18000B
X-Stat-Signature: f879w91rkgjyrwfp7kq4fbu3z4sy1akr
X-Rspam-User: 
X-HE-Tag: 1787252129-895821
X-HE-Meta: U2FsdGVkX18tIBfmYZEqyRE5GmkqCFpROAwcKeJNPiALkOfiYb9RJlSEH8bQiTaJ+VQhMFg2aEmyY+c5bVPDOiBp2dnAfxcIQ4xU4v8w+mDRG7PfrTHJv1jS3itd4LNCka3DxAFRx1WtBpPtKpRRMJtaNrZonImvifgJVqVyXqTyNI5J9Er1oJOb/lpyyurN+Ke8X+4RO4tMTxduNTyyRoFrIiP0Rm8aME5WCMjdADA/mjst7UQqKEsyvVXztXlNOj78B33qRCetsQ506tmqy2UO+5fYO4M/b+rTggrv+UrZ2/JVy6hziv95rIeyDA8MSfWbWlEOex7HsJPrBPJHv6D4SHTwOt8WMiykKNtXw0GK0gMTKhk/Gf5B/ywZVwXM7r7k7vuSowfKaU8bVVpIGPbbOIabV/q8emAmMeU8tkI3gF7/M7eHxwKQ783jDqAZT0rsjGReYcGezFhqzznCbrFwsRyCv/9DnLpOChzEPaMiOTW4u4qwiimxpJ93BG1tGmAh8YSewz4bCwTAjjj1/4mk1aeNoKaVaiKIqQg0EQZxik26ZQuEvBZgW3GOiAzRq6GFu/Wh4De0wV2fJ/cQbqDGsV9RA5a7yTutmJPS4Nqt4Ns75NjkUAhNs5hJgAUUYrKPqfoVp5VaybwfvTW1ExhDqeaORH5lySjn8nHl2YOIC9NU5XR2jxcSGk18z3mDArpgr4w3QE70BEZp3Xkoq7EprZ+RrchHWWoQjeZ38VjTFYCRaTtqoNXJculJIFDw/T7jrsnfCcRQwuPip3REIrP7FS4YR5cRIzDpoWy4xbLzT0WLlJxXXhaf7QNY9H3NtWMQM+Dam9SMGkO6bQSFIQcyUTixF5zOzMNWOh3d+tuy2Fx6K0RSsFNcHZKhbLbdlxQNg/TSZhAMVwAiv8EHF4OY6ONInvT/kIYVBnEzPpZqVjDX/JiQMLCvtpTcmrnj8GyOe4fkDqkjzkWjzbA
 b6fKY5WO
 vTz4FyuR/M//JnKN7GHtwgske+Yfr9KNiJQwXsQ9tIclQ4W/sqH5UQDA1N/p+RSX3zExC4b+kXU3teWOGQeh2dHNEeK7P3MMKXQPaTtCOCQiYmFAJls6X3ezUUZoLpSdWF/xrOBsB429RczKjUmyQ5vryRBubwMXai9E+BvPNhRktO70ehJoQME5/F2tjYzkOpTlrOQ/jfiOG5LwU622z0Nwh2pcY5eC50CPcn91Vdu5epqUucJ/eQRxuHKl+7itHA3Ny9EYelN0o8F5SqT1cqWshpFjg6lkzDIDzjBU2+sc5N4hmdg2efRTpZEFduucEAjUaKLRs8Qpq62i5BXA158Q8I6p+P224zfhIOIuj4hP3JSK3kAw+uWZHF6Jy8zcw/sRjvlBsLmcUAr3dhqDt9xwOOgYUffWMtM0yPYh7bdVyUNYd6OF1mzdmy8GtAYw9pRvTxaFbjQKoLhxN0NwdI6j2remQDXy5Yxsl
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
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 181 +++++++++++++++++++++++++++----------------------------
 1 file changed, 90 insertions(+), 91 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a6759a14e057..7fb603ac500f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3940,9 +3940,11 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 					     pgoff_t end, int *nr_shmem_dropped)
 {
 	struct folio *end_folio = folio_next(folio);
+	struct swap_cluster_info *ci = NULL;
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
 	struct list_lru_one *lru;
+	struct lruvec *lruvec;
 	bool dequeue_deferred;
 	int ret = 0;
 
@@ -3963,122 +3965,119 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		lru = list_lru_lock(&deferred_split_lru,
 				    folio_nid(folio), &memcg);
 	}
-	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
-		struct swap_cluster_info *ci = NULL;
-		struct lruvec *lruvec;
 
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
 		if (dequeue_deferred) {
-			__list_lru_del(&deferred_split_lru, lru,
-				       &folio->_deferred_list, folio_nid(folio));
-			if (folio_test_partially_mapped(folio)) {
-				folio_clear_partially_mapped(folio);
-				mod_mthp_stat(old_order,
-					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-			}
 			list_lru_unlock(lru);
 			rcu_read_unlock();
 		}
+		return -EAGAIN;
+	}
 
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
-			}
+	if (dequeue_deferred) {
+		__list_lru_del(&deferred_split_lru, lru,
+			       &folio->_deferred_list, folio_nid(folio));
+		if (folio_test_partially_mapped(folio)) {
+			folio_clear_partially_mapped(folio);
+			mod_mthp_stat(old_order,
+				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 		}
+		list_lru_unlock(lru);
+		rcu_read_unlock();
+	}
 
-		if (folio_test_swapcache(folio))
-			ci = swap_cluster_get_and_lock(folio);
-
-		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-		if (do_lru)
-			lruvec = folio_lruvec_lock(folio);
-
-		ret = __split_unmapped_folio(folio, new_order, split_at, xas,
-					     mapping, split_type);
+	if (mapping) {
+		int nr = folio_nr_pages(folio);
 
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
+		if (folio_test_pmd_mappable(folio) &&
+		    new_order < HPAGE_PMD_ORDER) {
+			if (folio_test_swapbacked(folio)) {
+				lruvec_stat_mod_folio(folio,
+						      NR_SHMEM_THPS, -nr);
+			} else {
+				lruvec_stat_mod_folio(folio,
+						      NR_FILE_THPS, -nr);
+			}
+		}
+	}
 
-			next = folio_next(new_folio);
+	if (folio_test_swapcache(folio))
+		ci = swap_cluster_get_and_lock(folio);
 
-			zone_device_private_split_cb(folio, new_folio);
+	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
+	if (do_lru)
+		lruvec = folio_lruvec_lock(folio);
 
-			folio_ref_unfreeze(new_folio,
-					   folio_cache_ref_count(new_folio) + 1);
+	ret = __split_unmapped_folio(folio, new_order, split_at, xas,
+				     mapping, split_type);
 
-			if (do_lru)
-				lru_add_split_folio(folio, new_folio, lruvec, list);
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
 
-			/*
-			 * Anonymous folio with swap cache.
-			 * NOTE: shmem in swap cache is not supported yet.
-			 */
-			if (ci) {
-				__swap_cache_replace_folio(ci, folio, new_folio);
-				continue;
-			}
+		next = folio_next(new_folio);
 
-			/* Anonymous folio without swap cache */
-			if (!mapping)
-				continue;
+		zone_device_private_split_cb(folio, new_folio);
 
-			/* Add the new folio to the page cache. */
-			if (new_folio->index < end) {
-				__xa_store(&mapping->i_pages, new_folio->index,
-					   new_folio, 0);
-				continue;
-			}
+		folio_ref_unfreeze(new_folio,
+				   folio_cache_ref_count(new_folio) + 1);
 
-			VM_WARN_ON_ONCE(!nr_shmem_dropped);
-			/* Drop folio beyond EOF: ->index >= end */
-			if (shmem_mapping(mapping) && nr_shmem_dropped)
-				*nr_shmem_dropped += nr_pages;
-			else if (folio_test_clear_dirty(new_folio))
-				folio_account_cleaned(
-					new_folio, inode_to_wb(mapping->host));
-			__filemap_remove_folio(new_folio, NULL);
-			folio_put_refs(new_folio, nr_pages);
-		}
+		if (do_lru)
+			lru_add_split_folio(folio, new_folio, lruvec, list);
 
-		zone_device_private_split_cb(folio, NULL);
 		/*
-		 * Unfreeze @folio only after all page cache entries, which
-		 * used to point to it, have been updated with new folios.
-		 * Otherwise, a parallel folio_try_get() can grab @folio
-		 * and its caller can see stale page cache entries.
+		 * Anonymous folio with swap cache.
+		 * NOTE: shmem in swap cache is not supported yet.
 		 */
-		folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+		if (ci) {
+			__swap_cache_replace_folio(ci, folio, new_folio);
+			continue;
+		}
 
-		if (do_lru)
-			lruvec_unlock(lruvec);
+		/* Anonymous folio without swap cache */
+		if (!mapping)
+			continue;
 
-		if (ci)
-			swap_cluster_unlock(ci);
-	} else {
-		if (dequeue_deferred) {
-			list_lru_unlock(lru);
-			rcu_read_unlock();
+		/* Add the new folio to the page cache. */
+		if (new_folio->index < end) {
+			__xa_store(&mapping->i_pages, new_folio->index,
+				   new_folio, 0);
+			continue;
 		}
-		return -EAGAIN;
+
+		VM_WARN_ON_ONCE(!nr_shmem_dropped);
+		/* Drop folio beyond EOF: ->index >= end */
+		if (shmem_mapping(mapping) && nr_shmem_dropped)
+			*nr_shmem_dropped += nr_pages;
+		else if (folio_test_clear_dirty(new_folio))
+			folio_account_cleaned(new_folio,
+					      inode_to_wb(mapping->host));
+		__filemap_remove_folio(new_folio, NULL);
+		folio_put_refs(new_folio, nr_pages);
 	}
 
+	zone_device_private_split_cb(folio, NULL);
+	/*
+	 * Unfreeze @folio only after all page cache entries, which
+	 * used to point to it, have been updated with new folios.
+	 * Otherwise, a parallel folio_try_get() can grab @folio
+	 * and its caller can see stale page cache entries.
+	 */
+	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+
+	if (do_lru)
+		lruvec_unlock(lruvec);
+	if (ci)
+		swap_cluster_unlock(ci);
+
 	return ret;
 }
 

-- 
2.55.0



