Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 561A9C5ACD1
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0862B6B0092; Fri,  7 Aug 2026 17:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008B86B00A3; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91F66B0092; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FD466B0098
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2388F1601B3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:53 +0000 (UTC)
X-FDA: 85075735626.09.57E1B5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3985C140012
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TQ5D4qlB;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786137471;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ymf+Jv1zX1MFAn+O9z5jUweguVU8iIhA2GkzJ9/hCcg=;
	b=gYiSbpWssucKhH3RxKNQKloapRKFzUciqGLPUc/kB7Nt7UL2pfx5Ym/XUUv0GOsWmcsTz/
	QdpDviYrmnJrV5nQ/OFmMCOKL0ojNcBrfVCratI1wMPSkQcUfqCFzXfUmLZ3RHbgWQXA3E
	V2ilWiXm9V1q5wFx1WArunx6YxvM5f8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786137471;
	b=5BgyGzVKWygOPQWheBIHJVeo8WcKh6UVJqZJTO7p93+TiDyQyjrsz+FzVqU33WTxYs5is0
	VrXVWInMwTONRkX0cZoRpCMsoOhW96VeexUGrm/alW3ZzqoygA9zOTNLRJQWJkIekHe462
	uua58mvgIcO0Zi6AY4/4D8mtDb/nP9c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TQ5D4qlB;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 43A9D60A5C;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9460C32781;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786137469;
	bh=h2zIakGlP4riVOSKtW+5kfZ5EhRMYipRYteot4VyaNs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=TQ5D4qlBUX9fhTvwUi8xbqIViGMx3eW7fBZVi5c72iBxOytMY91mqKfv8cm8+Y2qC
	 +5G3XXajkOKwn+u2/dFEmSog4/ZAWUvZUxCFtDo18sO+vxGi2MwcORrKdM4S4b/XtI
	 3/DrHCJTvrQyIGKPH89Y1BpVdFO2czmy9y05rd5oEsv325ikdhPtvDz7jcs16Hno8S
	 fxdMeIb/BTJK5eTQypeZqIaj9mpdemb5C8xv8xccnUNcg9kggDiHWx2K4DcatCCKQ3
	 pzrbvS1lGB9qX/gPeZUXXzyau86fXKYJlMu1igytz90useIs3CYRskDBuS+6Fyczhz
	 ji4U2L9164HfA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39CEC5AC7A;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 08 Aug 2026 05:17:05 +0800
Subject: [PATCH RFC 04/13] mm/huge_memory: split the routine for splitting
 anon and file folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260808-swap-thp-cleanup-v1-4-689939a7ccc3@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786137467; l=7993;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=lE4agxpn3+FjF8GNafybHiUXu6DuwUcHCxx6OFIyyko=;
 b=jXXfNFzNWB6VtTyyD5fFqI1uatlfOQTIT/j+NeGk17u1RduV+pdazf0ClMyT0jhyVcRUiflDM
 AjI2pnjs8n2Cu+5vYJxZ9KJ6O8TjLytin2u13dIH9nuR48TVn8DzPu7
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3985C140012
X-Stat-Signature: sra5yubn4qetfizieny43cisipdiyfjr
X-HE-Tag: 1786137471-895267
X-HE-Meta: U2FsdGVkX192QLtU2HWHdnFkrSuhinATwJiqiQrWeUiLFr2zGbbzdPZ0x+ngQSvvBdKP1k9NjddBvvVOOIDeqpYbmL+0n3lLgvKCwVQEmjM0kaO+mTHSizFTM0gvHkp4eV1h+OXKYgkIdQlqnlxnnuJQ9MZ/M7sfSIe7p+Ij1+MC1WXJBiKRtx9GF9wj5K+hI/JP1KAqd4D0rWIs/qUadG9Cl5Vlo2WAmPaqrlMLviQC7XTO+I4ck1XHDgjKVEoPvA/KVJ2UcS0bx5hPpuWy2+0FMzW5h+PqmLwIhnEJsI31WKLtfIffh1UR7fRuPmUH195fbcA0B2fYRJMCZjKAVo978ZiI8DFP5RBMUG3Pzt7I9Nh9BWCQosvdAZ8uWivE+SPC+TtJbIEAUX3wL7WLm0NVIZIAlHem3qSpMtiE6SzZvBVyfSQbPKIQELtphtSqWjyVyfK+qx1pE5iisg9KFNj93C7fjrgBvZTvv0Da1ag+lYq2jeKzKr8JyMO5WZCuNZppybXxj6kxM+l76XKVUBpqGayFjWWe3THCPnzco7BmVFYRhaXLNCGhQ/VxKuBfCMA5JLx7QgZnwtYMG+A90PuS4AP7ZmZM/fBteeCRcgH4VVhjZC2/fj0y8SdXPf2ajNZ+FVVU5H/BRp9qk8+xSJgnu9POgWs+L/Sg6kWlO8ZuZVr2hiRjD21YV3ZVC8We97aezw7knCfLtg5vphs1l9dBzDN2HCDFzfdb2Hpo8YvC8oDZTFv9tev8LZm5kX4AQUPAzbVTrrU3gRgQOvXmjSZfEY8zVlgYY2TfEyU1e/sv/Z78UoEi3EBQ1xF0DyLKjmapzMFgxId763pY+E2GfhexmBWUpVpHUQ0XiLMr2ZWlF91alU+UTob1dePjBMTjpWbMb6v+8wyLA4K6KvFmP4Mwk0PFgjZJa/zQIe89EGfSKFZ91TrHDtH827x+Zyh3dMcFCWrosbsaCLIM0Ai
 Fzr0WEE7
 is2VqSOfPN+u8fhFt5aYXHlN0G7SqHh0z6JxhTQuxWTIZhr6Ba5hjuHZfm1J7kkMTtIS+drgec0BhrYxSK2RmXZ4PYUuRdToQoBo75rpZgRuyu2ES5F72Jyb85MlUZjkMVdLBym0kUVHFMkr56fQ9Zs1qYxALcPoSQTvs3WoFTwG7w8rtJEXiGcoeLrZlmo01f2xKra6cAYDNajAOjL2n3yxrt0GimFbis7GOcq5Xqou/mYHGyzzs9e5Y/KCfVjuli4t7aqjGLoNg9Y2Y91UbS3urvirAcX6t8qSuuA71PovE4akRHs0WufVNUUZVYVemaY1GJ2UK0aLcGP4lwQN8udqCfttkUHh+XDxlSh+LmqbXdGwCM/xCtvaQl4PZ41j11Jluhztk2rZUhVBHhS1yW4/P2M90ukZH84n6wOnvyNmRoG5ruYZVPmRmwLwsPK/DZU8D4HX/tHcCFWv79n8jdA9vMZ1cfMTkwpYibh9hcQ4DnQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No functional change intended. Before adding more logic, split
__folio_freeze_and_split_unmapped() into an anon and a file variant so
each path can evolve independently. The two paths shared little beyond
the folio freeze call, the LRU locking, and the unfreeze skeleton, but
differed in all other per-folio bookkeeping and routines.

While splitting, some cleanups become easy to apply, and helped dropping
a few now redundant checks.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 121 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 76 insertions(+), 45 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index cf8f90b94e42..56a356c30f30 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3934,22 +3934,19 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
 	return folio_nr_pages(folio);
 }
 
-static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
-					     struct page *split_at, struct xa_state *xas,
-					     struct address_space *mapping, bool do_lru,
-					     struct list_head *list, enum split_type split_type,
-					     pgoff_t end, int *nr_shmem_dropped)
+static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int new_order,
+					      struct page *split_at, bool do_lru,
+					      struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct swap_cluster_info *ci = NULL;
-	struct folio *new_folio, *next;
+	struct folio *new_folio;
 	int old_order = folio_order(folio);
 	struct list_lru_one *lru;
 	struct lruvec *lruvec;
 	bool dequeue_deferred;
 	int ret = 0;
 
-	VM_WARN_ON_ONCE(!mapping && end);
 	/*
 	 * If this folio can be on the deferred split queue, lock out
 	 * the shrinker before freezing the ref. If the shrinker sees
@@ -3957,7 +3954,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	 * lock and must clean up the LRU state - the same dequeue we
 	 * will do below as part of the split.
 	 */
-	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
+	dequeue_deferred = old_order > 1;
 	if (dequeue_deferred) {
 		struct mem_cgroup *memcg;
 
@@ -3987,24 +3984,73 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		rcu_read_unlock();
 	}
 
-	if (mapping) {
+	if (folio_test_swapcache(folio))
+		ci = swap_cluster_get_and_lock(folio);
+
+	if (do_lru)
+		lruvec = folio_lruvec_lock(folio);
+
+	ret = __split_unmapped_folio(folio, new_order, split_at, NULL,
+				     NULL, split_type);
+
+	/*
+	 * Unfreeze the after-split folios and put them back to the right
+	 * place, keeping the head @folio frozen until the end. While the
+	 * folio is in the swap cache, the sub entries must be updated with
+	 * their after-split folios before the head is unfrozen, so a
+	 * concurrent swap_cache_get_folio() cannot return the head folio
+	 * for a sub entry. Keeping the head frozen throughout also stops a
+	 * parallel folio_try_get() from observing a partially split folio.
+	 */
+	for (new_folio = folio_next(folio); new_folio != end_folio;
+	     new_folio = folio_next(new_folio)) {
+		zone_device_private_split_cb(folio, new_folio);
+		folio_ref_unfreeze(new_folio,
+				   folio_cache_ref_count(new_folio) + 1);
+		if (do_lru)
+			lru_add_split_folio(folio, new_folio, lruvec, list);
+		if (ci)
+			__swap_cache_replace_folio(ci, folio, new_folio);
+	}
+
+	zone_device_private_split_cb(folio, NULL);
+	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+
+	if (do_lru)
+		lruvec_unlock(lruvec);
+	if (ci)
+		swap_cluster_unlock(ci);
+
+	return ret;
+}
+
+static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int new_order,
+					      struct page *split_at, struct xa_state *xas,
+					      struct address_space *mapping, bool do_lru,
+					      struct list_head *list, enum split_type split_type,
+					      pgoff_t end, int *nr_shmem_dropped)
+{
+	struct folio *end_folio = folio_next(folio);
+	struct folio *new_folio, *next;
+	struct lruvec *lruvec;
+	int ret;
+
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
+		return -EAGAIN;
+
+	if (folio_test_pmd_mappable(folio) &&
+	    new_order < HPAGE_PMD_ORDER) {
 		int nr = folio_nr_pages(folio);
 
-		if (folio_test_pmd_mappable(folio) &&
-		    new_order < HPAGE_PMD_ORDER) {
-			if (folio_test_swapbacked(folio)) {
-				lruvec_stat_mod_folio(folio,
-						      NR_SHMEM_THPS, -nr);
-			} else {
-				lruvec_stat_mod_folio(folio,
-						      NR_FILE_THPS, -nr);
-			}
+		if (folio_test_swapbacked(folio)) {
+			lruvec_stat_mod_folio(folio,
+					      NR_SHMEM_THPS, -nr);
+		} else {
+			lruvec_stat_mod_folio(folio,
+					      NR_FILE_THPS, -nr);
 		}
 	}
 
-	if (folio_test_swapcache(folio))
-		ci = swap_cluster_get_and_lock(folio);
-
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
@@ -4014,7 +4060,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
-	 * list. @folio should be kept frozon until page cache
+	 * list. @folio should be kept frozen until page cache
 	 * entries are updated with all the other after-split folios
 	 * to prevent others seeing stale page cache entries.
 	 * As a result, new_folio starts from the next folio of
@@ -4026,27 +4072,12 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 
 		next = folio_next(new_folio);
 
-		zone_device_private_split_cb(folio, new_folio);
-
 		folio_ref_unfreeze(new_folio,
 				   folio_cache_ref_count(new_folio) + 1);
 
 		if (do_lru)
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 
-		/*
-		 * Anonymous folio with swap cache.
-		 * NOTE: shmem in swap cache is not supported yet.
-		 */
-		if (ci) {
-			__swap_cache_replace_folio(ci, folio, new_folio);
-			continue;
-		}
-
-		/* Anonymous folio without swap cache */
-		if (!mapping)
-			continue;
-
 		/* Add the new folio to the page cache. */
 		if (new_folio->index < end) {
 			__xa_store(&mapping->i_pages, new_folio->index,
@@ -4065,7 +4096,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		folio_put_refs(new_folio, nr_pages);
 	}
 
-	zone_device_private_split_cb(folio, NULL);
 	/*
 	 * Unfreeze @folio only after all page cache entries, which
 	 * used to point to it, have been updated with new folios.
@@ -4076,8 +4106,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
-	if (ci)
-		swap_cluster_unlock(ci);
 
 	return ret;
 }
@@ -4231,10 +4259,14 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			ret = -EAGAIN;
 			goto fail;
 		}
+		ret = __folio_freeze_split_unmapped_file(folio, new_order, split_at, &xas, mapping,
+							 true, list, split_type, end,
+							 &nr_shmem_dropped);
+	} else {
+		ret = __folio_freeze_split_unmapped_anon(folio, new_order, split_at, true,
+							 list, split_type);
 	}
 
-	ret = __folio_freeze_and_split_unmapped(folio, new_order, split_at, &xas, mapping,
-						true, list, split_type, end, &nr_shmem_dropped);
 fail:
 	if (mapping)
 		xas_unlock(&xas);
@@ -4334,9 +4366,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 		return -EAGAIN;
 
 	local_irq_disable();
-	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
-						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
-						0, NULL);
+	ret = __folio_freeze_split_unmapped_anon(folio, new_order, &folio->page,
+						 false, NULL, SPLIT_TYPE_UNIFORM);
 	local_irq_enable();
 	return ret;
 }

-- 
2.55.0



