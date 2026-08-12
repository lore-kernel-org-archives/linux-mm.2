Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1903CC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5595A6B0125; Wed, 12 Aug 2026 14:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50DF66B012F; Wed, 12 Aug 2026 14:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9C16B012C; Wed, 12 Aug 2026 14:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF4BC6B011F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2883714045E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:17 +0000 (UTC)
X-FDA: 85093505154.25.D34BB6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1EE1840008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qZhXbbpJ;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560555;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUnOaSQPAqHOKi2xJKDiueezHtrJkWHJGTvG4QB0iE8=;
	b=1NLN7jCELLCYPtOyoEm/E66SixXjXMh18+oT+aYx0xYm7VA1/sipj0M4v+Z4SNAeoJZ4B0
	HApZyzztKpAWvlqLGaszWQG7I/eISkOC0ZUWjvdnRCUp/w1kGBQrWFfRXB99jEuXVZzXi+
	8JU0DipAzVGimShPpjx+yNJQAkdmVNY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qZhXbbpJ;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560555;
	b=DwD7mF1kSgZ0qKITKroA9gn8SNLVkVu5lEB22jpbe9l+Q4b2XLhz98WxtMh+8XEZ3GzByf
	YgrUVjl2OBwEG4ucepNwWZP3Z+/PV23kNsh7nNLVPDVLov1bbu1JlfzBIl6xtXnb6KFXIg
	fuDa2IkRTQIw7hlyvC0e1X+7R04avv8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C59A143F64;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A13E8C2BCFB;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560553;
	bh=+Fhq/ThhPdJvanb/xrY423riYXh79oib+Ae4a1g8tWE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qZhXbbpJdi+4pk+4BJjwdcmhZfdJrvIGqOOoAaFCoRhHskAweRtS1udSS8cFqG51C
	 7GJuY0VU2uey82sQqP/gDzXycQjph7V0hZ1Mulr93m0QzEmcE6Yau8JLXNKKXiu2me
	 2a/zHuauUqYap4dJvo1o6j4UgTwKupdvl7Hcav4zHhFLxHnswkOWILsQA3WARwmFp2
	 QA8weqUwhlhNGoHWFjbhikvCsTxfzEojI8xk1k5ObbjoMPzJsbl9ChDQcn2ZwoKstD
	 m4Y4wnI/PL9vpj6+I6d40uVTfSCeYaJJfSEMrhT4HDy9lTA5Wq93qkvIoOdWLY9cdW
	 pT9AFOtFlozvg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CA2C5CFEE;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:43 +0800
Subject: [PATCH v2 03/17] mm/huge_memory: invert folio_ref_freeze() check
 to reduce indentation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-3-d2ee48c6aa49@tencent.com>
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
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
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560550; l=7863;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=UY6iMKTpGLPfiYtzBDed5IoafUyCePQg/1v3UphPlKE=;
 b=k4IG78nRBmlhKeBfg0Wx4nDDWhC9Vtr8PHRcslUHVjITGXD266Y9FUK35fUyhPfN8FIPI72QP
 5iC6XdY49TSC5yoOcDQrHPKCMhVO6EHxgosecP0zC0sUd+wvOep2FvC
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1EE1840008
X-Stat-Signature: qyyq1yfnme6o3d7978x8zgudmr1aen47
X-Rspam-User: 
X-HE-Tag: 1786560554-597090
X-HE-Meta: U2FsdGVkX1+sCUpfeNLeh8w46gO82Rm0y4tQJxLGhY2M6o+HFwNI+pgjw4gf+Uvt/Qy34TNop5NvPxU7EEqeNY8nPWvunr7V6fJxQYiMHnf7KrJKAaUvZcRZFSCmoa036zApMaD670qBj5cv/hr95Wmk7TT77ajOh4vcjtVmGINJtJslUgp/eXFerRGAJvjIfYk69r4w3uWdjxL5ogvYVGbf7FeXa7rlTsBAUlnZD5WZKn2zcA26Lr2saiPx2S7uPbZ59+sZnlHljrnJM6zLiqdRD88UnlPztN84hArwAawJJPQcLtEvt0/8n3GFrDacRb4rHoO4cOzYcVmzuQgYfFHUFFZIJQ+7ASc3rhArwL3u6wVTBSjnCNSv89hBdPCPDPApTVRurLaNSE3db5AUb0KXAeN8e01vZIy0WfBciU6GsaA3mlDB59oI5O04m8JICPDcfa/SoQtdxqRW/cBVbmbRlmb6jjB6CNXuqr3lRM/RIVkyJZByZ2aOjtDV/zZCQFxm7klW2IJzvZX2ZtMKrP/BBPiQ1ayu5fXCfNsNg+bVFXLJ3ubjBLIfLmz+yqBizy0/9Yoksz5EzdASGBtwzqCfLuFc8x64dOqTMr7q84LErYKSK34ze4uoTHXp/G7su2BMkNyArAWHVjdAklbJ/veiUPux/5Kx6mfWB8tgE0lACM9wyxlu12VZmfOhLvxiJ2oLHZ5ao1UoBLXxqdPHg2wK+q2BnMy1acBipSM7fjYsVn4BxMRZ9mQwgidPKDPmaAtl2y3HDc51ZfScbOpW9ZAzVkBKEgYdLY8klYVRK0sXoYAjrdOfhNcI77+ysJ9F2hHiGeyYDEBbyQZUv4ONLe90w3UnvxaK8DuSUTvnLrmCbNkoMWwuYQIEEwg9T+6yEMu9gioSYkVqWpQs7VQR5AyMzxhQWBp/ibsALPKaPclbhmEXymaWyK9mbC8NcFeaaz3FFfHNjSrW64bGnIU
 JGYYKugl
 vrLWh8Yy6vQec+mC+1M4tCYlsCUR3pv+3ow8S+HhZB1QBP+E1itOF7pX5JG4rH4eF5dGPqBL/eteVvKXge9HjaZ4rMoB5LWNbcxsh9pUZq8U0ft8G8X05dbEljIm6NYHBSzp4W9/c3MmBOH4F4wvo3CiKl1c8cyEYmCzyu43axoziarapmSKP6a7plo4MPvO1h62ILUwVPbc2PjvJjtauIIaHrfsu5qgflm+rnNOUNkjCAK3VE6DTHaQu9qYt6SaLNs1InzV50Ld0BZrsXQfM3lewLoXVbiD7G6DFTQZX9yKspnAmF6dSkNBYvT3TCWK/bp05igiwQuYyc6Ha4ErUCHv+mxUg2iMGttm+m2MxhTbONyvkeYz3gWNSkSXkWZbGGJvsm3Cy6OisNvPop21NQyikTurtW8SOhZhM1PyjDX8Wj0GFQzT8XRJnmIY+jtVOjed3It/MZGTeTCe1z11nbBMbPeCriafonA8n
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



