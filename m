Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE8ADC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B9EB6B0115; Wed, 12 Aug 2026 14:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642D76B0130; Wed, 12 Aug 2026 14:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46AFE6B0115; Wed, 12 Aug 2026 14:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED61A6B0115
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5245EA03FD
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:17 +0000 (UTC)
X-FDA: 85093505154.08.AD889D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 58484140004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RFI/CNwI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560555;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fb62q86yimAmue9xdt7mC9nHeZ6S9RlvdvZpDp7e5cA=;
	b=v6s4wzFAewjMQR3rNBFqRERKMsAbRIP2aUNRQETFtynORfd3WPvnomAex3nVY5ukeUXQje
	Iq1YocoxHleQzuuRmUwFuTGDT2SqWoI6NnYorXtY5bcavljJUNLtrE+lQ0DdVNEq8e696D
	etiB636WRVuYPtpvOtxcTsMqYuHB3d4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RFI/CNwI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560555;
	b=TnEqZfftEqnciVUIrfFH6cL2KLPzdEIcsfHAmi1BDR/V2L8pFRLoBU3BdJ2oqoxonOikFV
	zennXlXnhmXvUbaWAx6/3N1FxNLQ9VbHv4XBRHXV3/7+KsFM3dXCYaiyoSjGdGgkRYRxLS
	lGkIpDpo8oAzycS4Nv5hRgn7CJwRqKc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E206243FB2;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4A9DC2BCFA;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560553;
	bh=MlidP5oYz6rZc2n0ey9JStoocVc51758tOV6HEpbwWM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RFI/CNwIFnWf8edIDiPMpCmhXortSgm1OvJa13wRhb1k2M9ZMhczZX1zTcmgIXHlk
	 6A62afeVfk/8X7mVQGe+zfxmQD+t935PNh8W2u6pbQsNorXzQTRzBe9rlsandHP33T
	 RGPZLmW3PqNxLXV6F90M6fnRsJZaoUmc1pqvmJ1CG+LNibxLzc2VgTxwGPUXyd1oKU
	 j9TZmIQbg4TdFXWTC3GL+M8gxhv4a66uOfnZMIlougv+7jx0uAnQvpxfgcDurP7gji
	 lkO6PL7Kzf+Dov2sP+g3EZsWvV3sSIqxRZ6XYyWOwe2nGqA6OvRWq+b7GRHiOhjzr7
	 q0UflcaGFy4QA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A10C5B572;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:44 +0800
Subject: [PATCH v2 04/17] mm/huge_memory: split the routine for splitting
 anon and file folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-4-d2ee48c6aa49@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560550; l=8891;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=u/PY3rA59I05qsJFQoxSfswRpt4QGmWJXn/YBJ2ly+E=;
 b=UyS+Ybcre9RJQTyAqQjSqfHwqYAvv4gnR792SypgViHDof+y9eE9m3XOtx0gAXQS85+nRFqdL
 xVBFl+WEPXuBoejnyg+lqyZHq8VJeM3/Zg61bzwUwcxyMie4aQ36dAR
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 58484140004
X-Rspamd-Server: rspam07
X-Stat-Signature: rj16hjzro4yjr7mu53nr7bp9fp4ce3xo
X-HE-Tag: 1786560555-290023
X-HE-Meta: U2FsdGVkX1+WoQFiVmROnuFRsmHDUB7tIOwfo+7Iq+tQPKxvk33JkApGijz98F82HJqNxF/zZJz5lfDeFbVCxMvBT8/pTyIpQht68o2DwIHxhzalBnSG98uBlsVHxwmNwwFNSu3n13h9W/0wfzNHVh3CzWPentFulgK1r6krQuTMjG65rUCKMDOWqCgebJULVpQSJhq3oCflEwivZ7/Y3KUklc1M/03SzEinRJH5+1viP3wIe71TGFhvsuqlOj+/zP0r2GQPnbkqSRyCfuYnCxFucyra2sdJNMn+D/QCu9ma71YiOrf22KaYz8DKcWWKphwB3bQF7isDY3RsoNh1GLcuqtzvyL57h8N1vFIdBR41PkjXkpfTXGRSARTiYoAE6OYyVbEzq4J7CzOcQSok/d0N93gGF3nt685K1wslGsnhGE78UhC874/il4NORrCMqa9+PuktgZcHBAotxQZXZM+rWi3+fdMPh3BJC7yLG1CS9qHdxwiuhnEngnfaSJtX2pP4Rlbom+mDIdwraX40VivDlLYhHMhAdV7gJ9/eQmIj7YsTh0tdsg+lHKBo7D1cIhkk5M8xP2g7LJ3KHZKFRcm2y1pSTU2G+DDNuwQyVdMMqT42y8vjzZneh4jtm405qKM1Phg1UNikj5DAUTqAxcKyOj+WYLFArw33jPnoeajiUwXD7RwSNjCJFuQWs3maJRX2v1+KjU4RhoX50TccDSb0TGUcAqkeNPC5I4EU3C0j2ppCAAyUCrtEVgZ3YRGTqyI+gwNTriGndEGZi0tKawzk4pG4xF2NrLNeO6KgiiDcoxh9ngL6OjwZjGh02GMN11KpfdBZbHEW9+Z/okmpA84OLDUumgC1mtNMK8NGi3stvDF/NyM6ungBj3s12VpfPHMv2KklOkgHsIDvV11ysiYW2TjgChHgqMJWuawV5BUj5+ZBc2TXgEHnENXT2qMMBPqBItOXnLDqBJtdrmQ
 NBLZqM+R
 HlD9LWZV2gvevbz1suwy0t4m5rcfQqIpwsuoievHKuBay1EJzfB1QvcsY8cGTn24x28eGIYvptFF++0khttGmfq0aU4YJZtv6hhLH1TXq5x7P6iHuG7z0PGX/XUZAECoxgjaF3rZYG38uAr7f5ziY3ordYvw9llSqNr2riRF1EVY+lvnvrnxAl+Zn6yXvHQ9b0sCJLbbV+eKRli1Vb2hTBHqbxMloWDc+bfPWtkJkBhYFeIVrDFzG8E978FF5FEBIpP1XTLmreaqTuxUdWcGteEzgH5+GO830dwEWlZI8hkdIgPbXoU6C7pxTJ96ntQF/MjVlOMpo/T7DGPGo6Dk9+VwbKZ2lUs/5IJz8s8Tu6knFq6dAMyChor64es8JE6JBHUp4a1l4zGJDS2oE5fSZf3PqrOcG3BsCvmvBddRxhXmQJ3fGV3SgPlQ02wE2VoZLOkFsIKMe0TmHM8SmQyvVyX+zU3H28Sl/YU3jn2GCH0xZhWDJU/A8DUj62KtK8RpqceW7ihUGVZ8sVog7gCOkrhjmJA==
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

While splitting, some cleanups become easy to apply, and helped drop a
few now-redundant checks. Also introduce a folio iteration helper to
avoid a common pitfall of iterating post-split sub-folios: a sub folio
might get freed mid-iteration as pointed out by Zi [1].

Link: https://lore.kernel.org/linux-mm/DKJSFCLP967N.YBR4DNK1NM2N@nvidia.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 133 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 85 insertions(+), 48 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7fb603ac500f..7587eeb09e4a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3634,6 +3634,18 @@ static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
 	return false;
 }
 
+/**
+ * for_each_folio_safe - iterate over contiguous folios safe against folio free
+ * @start: the first folio to iterate
+ * @end: sentinel, folio_next() of the last folio to iterate
+ * @sub_folio: struct folio * to use as the loop cursor
+ * @next: struct folio * used as temporary storage
+ */
+#define for_each_folio_safe(start, end, sub_folio, next) \
+	for (sub_folio = (start), next = folio_next(sub_folio); \
+	     sub_folio != (end); \
+	     sub_folio = next, next = folio_next(next))
+
 /*
  * It splits @folio into @new_order folios and copies the @folio metadata to
  * all the resulting folios.
@@ -3933,11 +3945,9 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
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
@@ -3948,7 +3958,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	bool dequeue_deferred;
 	int ret = 0;
 
-	VM_WARN_ON_ONCE(!mapping && end);
 	/*
 	 * If this folio can be on the deferred split queue, lock out
 	 * the shrinker before freezing the ref. If the shrinker sees
@@ -3956,7 +3965,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	 * lock and must clean up the LRU state - the same dequeue we
 	 * will do below as part of the split.
 	 */
-	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
+	dequeue_deferred = old_order > 1;
 	if (dequeue_deferred) {
 		struct mem_cgroup *memcg;
 
@@ -3986,24 +3995,70 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
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
+	 * Unfreeze the post-split folios and put them back to the right
+	 * place. Keep the head @folio frozen until the end: sub entries
+	 * in swap cache must be updated first, so a concurrent
+	 * swap_cache_get_folio() cannot return the head folio for a sub
+	 * entry (folio_try_get() will fail on the head @folio until unfreeze).
+	 */
+	for_each_folio_safe(folio_next(folio), end_folio, new_folio, next) {
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
@@ -4013,39 +4068,21 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
-	 * list. @folio should be kept frozon until page cache
+	 * list. @folio should be kept frozen until page cache
 	 * entries are updated with all the other after-split folios
 	 * to prevent others seeing stale page cache entries.
 	 * As a result, new_folio starts from the next folio of
 	 * @folio.
 	 */
-	for (new_folio = folio_next(folio); new_folio != end_folio;
-	     new_folio = next) {
+	for_each_folio_safe(folio_next(folio), end_folio, new_folio, next) {
 		unsigned long nr_pages = folio_nr_pages(new_folio);
 
-		next = folio_next(new_folio);
-
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
@@ -4064,7 +4101,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		folio_put_refs(new_folio, nr_pages);
 	}
 
-	zone_device_private_split_cb(folio, NULL);
 	/*
 	 * Unfreeze @folio only after all page cache entries, which
 	 * used to point to it, have been updated with new folios.
@@ -4075,8 +4111,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
-	if (ci)
-		swap_cluster_unlock(ci);
 
 	return ret;
 }
@@ -4230,10 +4264,14 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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
@@ -4333,9 +4371,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
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



