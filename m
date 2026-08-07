Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C8F7C5ACD1
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:18:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 317A86B009D; Fri,  7 Aug 2026 17:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9906B00A3; Fri,  7 Aug 2026 17:17:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07E6F6B009D; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C46946B009E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5050012014D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:53 +0000 (UTC)
X-FDA: 85075735626.19.FE8BFCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4BC6E14000D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VBeEbGFV;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786137471;
	b=fC0WDGmG/0jEHjVJvHbVMKsBpupmuOjcgdvjENd3vgUyCWNEpUYeui8FzL+r0c9jhpEANm
	l28mFTFOsHAXUQjxgtk9u9xkQ5hY3pPMMIyglWVk+C0z/79hZ7Asi/A7dFKdLGyTqEvNjb
	rr7M+dieK0Lg9A3WJmuYYpS4LGz7n9c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VBeEbGFV;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786137471;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Mbg7ng+jUB3FHiYJuZWYyDbsL7r+vADE55taf9LhIY=;
	b=AVReCyjzZtF3v7sr8alHzw7OJ2Fr7h9heZY7lN81PdMWFqlwFD2q+40B+BAus3Epo3Hwwn
	lE6I9K8C7KhK3+xcmYofI8dcP9Eyz+yZ/gCOzQRW+ZZJnxewfisfmAbcoPTDO/9zn3ZaFR
	V4VySTrGDXC7GpzxtBhYftzpGeMwDP8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0765043FE9;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC9CEC2BD04;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786137469;
	bh=Xjvbc6dxTdwAtdxCb/oqs8fxkZQn50o3lLgMYMga3lU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VBeEbGFVP4aY1rkUHKVeKdXQZDIzOAQjS/oNrzFbQAZlvIIQvjQIN/WkPpLYhscjZ
	 Hb5q77v1lMZ/zt73cV13eU2nQtlNDAu+boxTn9N4qcTQXt22tBD1CKVNgeVmdcmp6Z
	 hBADLhOB7n6xxMUd4KzM+UTpfJbWBligvCtvurOpAuSC2ICP49gv5T9FhsfdNx9yyi
	 BOpIcpv6vwYQlN2+QZDjtLKMrNUEtNXJME+kCyd1eEQTPTz7T78xhqmcEnO2annbAU
	 B86+2RHRdPjaB4RZfzsU/Nruv6BjQEIryMJr3VCCzRjeQ/jaknWPkXaW2cfZhwaJI1
	 0pJKqJcE2jD1A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB53C5ACD1;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 08 Aug 2026 05:17:04 +0800
Subject: [PATCH RFC 03/13] mm/huge_memory: invert folio_ref_freeze() check
 to reduce indentation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260808-swap-thp-cleanup-v1-3-689939a7ccc3@tencent.com>
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
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
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786137467; l=7825;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=vEiSOg48pfKlibIxJXaAjoXOcM/bHDnJ1mwc1VCXIgI=;
 b=LMT7kjdS6jvyvicYZiiyyzzNsAhx/DUVFJfuN7IqgCQboDJ6ieR81y1ldneSjPPnU5tDqMOWr
 FLPV+jm6USLBz6V6nYiNojSqezgdSVklrvLkCovfIfJL0AY5zWvx8Yy
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 4BC6E14000D
X-Stat-Signature: mk66wbcx8acp5ni8unatskr9wb55ursh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786137471-451599
X-HE-Meta: U2FsdGVkX18+Dkto8g6PMVTbPWYC/Zs6fWeawZgqJBLvEsP/VjOMUbEcBB1yF98pcpuzgHOfnaitT6rtkoXdUhdlbCB1UFHLlOeb1B03ptXTQq+dMzbdeFjy3OSptZyZrZgKBdC3uL5wHNJxxx10NH78+z4P5/vcdgfvoQ2W3pVBJ6gylVWDzBGnE2AXzI6L7JmHbv7942RLUzPvZ+quZWWTvSfzwqfPbre5kX/cabZiSDujfxlN8g87tOi62uwi9EQ0VcHVlhsJ+WD0kXYbaZZngss/gSO9EGMn2mp7Yvqs+SxALzheIyXDWozDj1ggv1027lm8CUZAFP/HBOwRW4o0Fl6j6JFCZQYZfIkVF7oGpi88sdvU3moJihWQPzZSip8612NRgNtHdoMqksvBYSWGM97jh1KXcUAJJnTw1CDDCJAyjbswe5UOZbDTKCydyam04k+BNhgu2+sYVMyZ/OFFqFWM337xFAJUJeXwxOtvsQ+A8+Eji/8N7OfesR0C8mDSciRUEkpjcgzFtXCMNdc0IXfWbNrsec9ZCMvAyN7dH9Otfm9k3CiNdm1lAt4DWVd1zP92pqBfIWAiZRAHNf9Hm7KWvfwLvwpYaSFo6XrVlgxxAyVDFXpy6T1JQ6sYfWuHXCy2qKkq4XJJYg6kLpQCGPyJ76mMMO5TT7zoBacvW+e2niLdKZdWemNiGmkevXk0vxkIYO9tvTw+Ct01SK8FIe6llAYYG35O23dDOWLcWMfGAlLOMtDr23MGXsjyg7XvEabFTY16LljdyGscNhuTHzPUKC85XZgtbRyLK6S0HmgMkVY2aUCwzKWirII5x0VB0IJn9nhJVzKsaDQ2Tu4JYhcpb84epBhM9sKGk1LFLC2gEfEFy6lmWoMxtodiAeJ5Mf54bcGe9/C5wwdn2GnE2JOXwHzshkexw6H8bcvItyezwfw4QGKLozEzMyEzmrQGou3OF/10ztkcij4
 9TYjdbMm
 4/ckq8ImDzioF7qwXGA+km6Ui05g5ArsvHggUggWvmT9l/UH8AGqjBCyfyj66dpcVWW8r+LAX053/Z8H+WhEpF9urpSS4iutKWNwiNrc5RLZ4dI5BdQbpt5SOgv4Vjv1eeumLMxemD/dt4t2skBKO5kUQpJwY2Z776FVIJ5LKcHkMDO3vRAvd0z+Aa23fbqLfOXqoBBVU1jd9jfbmatvQkuI360nKPxWOD6WkhQyclKwMI6CU3BwujaXOkepy3qUr9sGlWMHAXJxs0vDRK/Hxq2ebAnl7ZfF6Quusyo8ZtolyEqOoijNL3uB0qsAdPYNx0M8rdRiROiloPiHXTNjOlifuubjVja/xJ2yNAR8iAeYvuiR8/tiCKtDq4z0MmTrhXsLNIfmANJFv0+TsZ5q//Jelh0nsmqt0keJzEl+V+CAkbVPZvLiXZTkU4orHQ5rqjqMezKWs3tJ28/E=
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 181 +++++++++++++++++++++++++++----------------------------
 1 file changed, 90 insertions(+), 91 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2fa72158e063..cf8f90b94e42 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3941,9 +3941,11 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
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
 
@@ -3964,122 +3966,119 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
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



