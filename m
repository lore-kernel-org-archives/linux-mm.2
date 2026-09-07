Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1964FC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 228E16B009B; Mon,  7 Sep 2026 14:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02CE66B0098; Mon,  7 Sep 2026 14:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4BA46B0099; Mon,  7 Sep 2026 14:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A44046B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 352591A01A8
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:19 +0000 (UTC)
X-FDA: 85187760798.03.27D9CA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 30AE5A0007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hc5Qakwd;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804737;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WNckUHct125SL5nOMESQI4diaULxianSJDIvj+wR3kA=;
	b=7nLU0sXU/QobS/DK19Bm2lhYYLK4E6NSbi2fcYZqVBEFoa+WAXfDbdhii7DNT88ew5Xm3m
	xysI9IKz1DefAYgip+qQKSizxIWUCut5IKAEQc1hzAVBuJkI5YxEsHaKvEj6uAAil+mfYc
	4Ne48N6ek/Lu2uxbTSYfOSBiOuKNOns=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hc5Qakwd;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804737;
	b=5Tpwy6uwLGL0zkQ3woNzopq9ciWx3ioLka9dQjUwJmZQ2LGgZRZokQfyqz0rYGSPPsbWNZ
	kcnmr9V80/s6DHn30pgF7Xz3FFuZV0nm3C4ELvNHdxKJtotJkcBeEFVG9+sLiMDPt61rZZ
	kRBVS7iqQNAojf7PVRhzH418oKHqDWw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B77143FAD;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0DD7C2BD00;
	Mon,  7 Sep 2026 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804735;
	bh=UQxE9U8zUuQpP1iKLbROwSQIKo79F5tPHz6aqRL825o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hc5QakwdjZra0foEV0Kv/LTqxuLX6pLXe7wqKIzB5CE2mA83462k4+z18+u0abrOT
	 B7TLEOB71hg30fgKjFjto2j0Azc9aRom4YrUcW/CAR5ZsOc+pYVuGyQRLSzieUEhl1
	 P9HLwDxGLfpva1/laQEbATnw5zxI84fdCPN10AwE1qI1QtYIrI7VUwcBSUgjpkyXvd
	 gppnSioCWjAmGGfMcbflWAG6BZrNvG7w9t82KVPdIL1NWt8GpkPbyzVf/k0Tah+gP5
	 /erVBTeOSqFgW+R1CZTlaNNRBVRAgLTMqp0Yy6yaBQLOMWeImGDR46VcY7+g2bh+zt
	 GdZEIg9McqrFw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C692BC79F9F;
	Mon,  7 Sep 2026 18:12:15 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:08 +0800
Subject: [PATCH v4 04/17] mm/huge_memory: split the routine for splitting
 anon and file folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-4-b532a3f20e71@tencent.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=8272;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=F8dPsP3fFvpOvuos1eYuyIIw+I21YsBNU7NmRi/afk0=;
 b=ZyKgqL3xLR1pnD3HAXBLQcjz38JCrnSMlJMXoKMqJVXy7WduKuWGyOhW8e/nqm+yS5Or0WtoP
 D/nK/iIkQbqDlD9U9nrS3zyhnpi/+T1ZsuFxm2yA7FdHDqXLT4uko18
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: bbdsxs5xz46k7uf5p5a4yj333sdqzrkx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 30AE5A0007
X-Rspam-User: 
X-HE-Tag: 1788804737-947724
X-HE-Meta: U2FsdGVkX1+qurZYUIEHId3KVT8WtTmtQp133T8SgnoQWBToI581nD58dTpMqeqpirZhtQ6TscuzgcQE2AItBEXBwQBc1E0V0kPdaLgjpMC0obbWJ1vH40dvjmST/9mzTdcWnRgUXwkFI39ztikExjbv7DJ+m99ZK0dR4k6P19mdslxwHh7JJzERMYnZFroT0uie1p7KjfUBy8LcbHX6NPWzDvVhnYKUR7lL+pDqRxKiPXgzfs95qIyLDDzY7VJTeOX3rI4jQUJO+BbdfbzUOqTtp4qilynSznC54ayPuCMqftz+PkD5EcteKHOqZBpuayDLAxZQadhrSn6fvHzg74Ss9gnLNA3N1jCnljV4qb9TUr5wWRMtHxBdaFZL22mFoQq52yB/38S1rNgm0cAJWQS9HK9A7Ofo/zWAIDasDww8czQrCETMp/6GUbCa+AYors49CYDuAp9lXjFF3+P4fsgr3p8o8Tl1go7EvD1I4NV6P6DHKaom/oMJN9DGuNVsZfaYfubRl7B/dKExrIh4O69LkvfpG63tJuIwjoagC/P1gPO6hZfqlCh5NwFgAx+lhYer+3GiHSI6l8fJ/xsyOMsUnHygM/WXhOCOfV5ObrWS9InFSDqSxom/COVZE+5ogvThBY9wuiORZfGi1Xa8Gl9e5Smw2YMaJCA8OGiRuQpNcsbKdq8gVF6kadea3FFzuthJK/IOyn7BFBqSq0wxZZjenQjrzwPpcAFQWAqtP/2WhEBqEMVpa0w+nvJLfBd1hO6ZvYnKuCJCdPCo6ZXE9ebH5nHzRn1MgfbnZGWDbJkyvUJvOmpmC+KJLBdqUvZUuKsg9x4UC2RkFHCH2tnwHfrP9heCJmxOkvqG40aQwJyvWz/pkvxQNuaXwrHhpJiRnaWl/nKNpCyb1q2XP8bwM8QzMgvkUGve6vEl/p0Z1G7BhT8vIoXwfWjfbr4FqsQ2DGZxOVHWD2WnlNmpgBH
 +8IEsfuE
 FAPV9SVsoZkNv0hhDPcyTFrCF4uAvKhFrIzMDZL5lus72czKmPEZQY9uSUdPrJvDRzv3z4ZnkeqzgNAkUPGa35ADCFVF6fv8sI1ddLeQzVO/pUMYDVCEte0av/Ml08nqtF8syApEesGOIfMShp8+7C7kVXgYeswlGAdVkn+a8dO1ZF0FEi0Vkf9nNPxl5z1WyP6878yhu1YDAInCqmzexUuzNh/V2ec3IwwOUbnJDFLwOrkdfwQ1/HGvbjHyEThA74nPsO3ZTK9QhiFcGrhIB6DtgJxwgN5GI1zbIYR7Ih1doYZyUV6zxHluLwxGHAf6Jt+0GGvDJ28y363RjDdTccZz1sy4ITRlab9L3GcwhzeOY+39fEiBGOMCFQoYlUbsD/OE+P0qJM+1RIB6jp2kZADnKv7R/LTHi6jKLS0vq/egLYPAWKPbbtvzeKQm3XwPks4Z0uwJwh727TEiNm5aZIAOZiPSla9EFhOSIBEyfEAxPKQfdP5LpnjGSF+OOhtX2B0AV3UK5U7sbOIc1Q0BPAK9O47hzVAXKlWO0liJ20O/gVeXFQkLTH0pjNJOV2YCPhjOATXEm8feIhkMDFv+i1oPXSw==
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
few now-redundant checks.

The zone_device_private_split_cb() calls are only kept in the anon
variant, as device private folios can only back anonymous memory, and
add a VM_WARN_ON_ONCE_FOLIO() at the entry of the file variant.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 123 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 78 insertions(+), 45 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ad45b86819fd..0e28a3e66b67 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3984,11 +3984,9 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
 	return folio_nr_pages(folio);
 }
 
-static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
-					     struct page *split_at, struct xa_state *xas,
-					     struct address_space *mapping, bool do_lru,
-					     struct list_head *list, enum split_type split_type,
-					     pgoff_t end, int *nr_shmem_dropped)
+static int __folio_freeze_split_anon(struct folio *folio,
+		unsigned int new_order, struct page *split_at, bool do_lru,
+		struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct swap_cluster_info *ci = NULL;
@@ -3997,8 +3995,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	struct lruvec *lruvec;
 	int ret = 0;
 
-	VM_WARN_ON_ONCE(!mapping && end);
-
 	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
 		return -EAGAIN;
 
@@ -4017,24 +4013,75 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
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
+	 * place. Keep the head @folio frozen until the end: sub entries
+	 * in swap cache must be updated first, so a concurrent
+	 * swap_cache_get_folio() cannot return the head folio for a sub
+	 * entry (folio_try_get() will fail on the head @folio until unfreeze).
+	 */
+	for (new_folio = folio_next(folio); new_folio != end_folio;
+	     new_folio = next) {
+		next = folio_next(new_folio);
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
+static int __folio_freeze_split_file(struct folio *folio,
+		unsigned int new_order, struct page *split_at,
+		struct xa_state *xas, struct address_space *mapping,
+		bool do_lru, struct list_head *list,
+		enum split_type split_type, pgoff_t end, int *nr_shmem_dropped)
+{
+	struct folio *end_folio = folio_next(folio);
+	struct folio *new_folio, *next;
+	struct lruvec *lruvec;
+	int ret;
+
+	/* Currently device private folios can only back anonymous memory. */
+	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
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
@@ -4044,7 +4091,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
-	 * list. @folio should be kept frozon until page cache
+	 * list. @folio should be kept frozen until page cache
 	 * entries are updated with all the other after-split folios
 	 * to prevent others seeing stale page cache entries.
 	 * As a result, new_folio starts from the next folio of
@@ -4054,29 +4101,15 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	     new_folio = next) {
 		unsigned long nr_pages = folio_nr_pages(new_folio);
 
+		/* compute next before the folio can be freed below */
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
@@ -4095,7 +4128,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		folio_put_refs(new_folio, nr_pages);
 	}
 
-	zone_device_private_split_cb(folio, NULL);
 	/*
 	 * Unfreeze @folio only after all page cache entries, which
 	 * used to point to it, have been updated with new folios.
@@ -4106,8 +4138,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
-	if (ci)
-		swap_cluster_unlock(ci);
 
 	return ret;
 }
@@ -4250,7 +4280,10 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
-	if (mapping) {
+	if (is_anon) {
+		ret = __folio_freeze_split_anon(folio, new_order, split_at,
+						true, list, split_type);
+	} else {
 		/*
 		 * Check if the folio is present in page cache.
 		 * We assume all tail are present too, if folio is there.
@@ -4261,10 +4294,11 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			ret = -EAGAIN;
 			goto fail;
 		}
+		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
+						true, list, split_type, end,
+						&nr_shmem_dropped);
 	}
 
-	ret = __folio_freeze_and_split_unmapped(folio, new_order, split_at, &xas, mapping,
-						true, list, split_type, end, &nr_shmem_dropped);
 fail:
 	if (mapping)
 		xas_unlock(&xas);
@@ -4364,9 +4398,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 		return -EAGAIN;
 
 	local_irq_disable();
-	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
-						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
-						0, NULL);
+	ret = __folio_freeze_split_anon(folio, new_order, &folio->page,
+					false, NULL, SPLIT_TYPE_UNIFORM);
 	local_irq_enable();
 	return ret;
 }

-- 
2.55.0



