Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A56C4C5ACD1
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:18:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3182A6B00A1; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A476B00AA; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190496B00AB; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEA406B00A1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:17:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7BA63401E4
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:55 +0000 (UTC)
X-FDA: 85075735710.08.65E605B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7C9BDA0016
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eUnSm5ET;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786137473;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nOEf0LQRFIOGwQKsXKl1nUVqkaZVgh/q/H4DI9zPzQY=;
	b=o26cO89+brHOyfjOfsal0f7Z1Ixg8Wu3ZWSuPv4M5HHnJTBg996WQ3N9sJzb1VJ+07sBX7
	op+JpYrbyIkndzFtPgbZ/409v8hFPaxQa1oRyv+Gi7FdqlJL1qJKjkZwLeZdLFaQVkrPPO
	4Rs3OWNXNOujv8QUrjh0+O3MDmMWg4c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eUnSm5ET;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786137473;
	b=bWrxZAL+WXO6kU7S2Db/eLbBdefz2VClwfbekUHK0Z52GZGyWRVNsLFfDAyKoWhApWqHpo
	SJPWh1dqoI3vXF1wIl/ZjPMTd0S+mveBmz0HyCI3dyo7NF9sAH63crVhG1M7pM2mhG1VFN
	gZ0hO/t6F27uokp0k7VDSdRmDoS9zb0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7671244E52;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 567F0C2BCFA;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786137470;
	bh=I9ZwUvZv1ol36H9/Rq5s+TZN0X2Qruo9ioQ8LVL316Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=eUnSm5ETfyN6i6crs9GnEMS4ry6XhaR5jKbidnB6YiwOoRH4+gLpS6YRTeezgwdLh
	 iu+PoVVJclxJ3QAOHTvKN70SIgGkQkY64utKvN74fo67yCYIp1PiZHAAiaOWCuhKux
	 hkXnnKATGvlYRjHHSoXIG5lWH4CKhs8hglsBYA/qPLQsgEy2eu3IiPAtFIU4j8Yu/w
	 Z9YzYJM8mPYLRw9EpzoudZiU1/9z1MY5fhUKBk1SqQpAOdJa3Elp26F3n9TwSipxRk
	 Qe7JtFpCfZ7apN88TSEwHIkUeeKCn24GLVGkIldQK4uOlJDlaODVYr3THnQgPM2ivk
	 Fv6JI7VbdxmqQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F23C5ACD1;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 08 Aug 2026 05:17:11 +0800
Subject: [PATCH RFC 10/13] mm/huge_memory: allow splitting mappingless swap
 cache folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260808-swap-thp-cleanup-v1-10-689939a7ccc3@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786137467; l=5534;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=RlM8mpHFdOY4ZKngaHLh0+gwh65R/G4errquU7C7PiU=;
 b=MDqPUHQlHc8YqRsgbFOiw/gs+clVxgCEnHoReVoVTyTkxhaAB4NXX3KxsTtkkEa6Yz3qns2nk
 DzI/Sd7a3E6DfST1h2ASXmwqXdemTCpnhxl4nCsz0a3lS1sJqa06qma
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: yrcetca1pg4ezignqmb94cdpsrx88t3u
X-Rspamd-Queue-Id: 7C9BDA0016
X-HE-Tag: 1786137473-409438
X-HE-Meta: U2FsdGVkX19rAm/9OMwGTarH01LFnlTgGizCKOUY1phOzl8iknxjNo2bdQ5KaKOhKswV43Ib8omgRFvdFkyk6hbvzsNHCT2FvcI6yMCG5AagGnowEgp+x7Dvm7Dl3RZrt9L3d/uJee+Xej32FNcHlxAdczmucIeh+yKoKMyP/haajxf6W0SyVxwQIa98euNPz8X7/aPZ+xzY/TStxApn5IbcKjKe3XGtrIoD0yAt7VcAoASZizfHw7Dd+ln2UY33GhdH1WDCVbylNg3l6+cEvwchTp/xYncEf0RHCPBJQOQ0L5xKwQ0j9WEIrYMr3GN6Z+2QKEeHjVRcaVyiXtMr05/iQTgnsoaPyQFBFKo8nUUVeFzZAXROZDbmCENN97j6wikqPn8bXvXdMST7V2HwXJkJ+vQ2zLnBiczJ2HFIWHuSwwvL9Ln4KBrp/a8w3It+aLja0QexqoGDp/kDJ5LhPVBivqlyH2amM5Eyei/eT9yY8E0auy4iqLii5ANfi152CIx787/sKYS7O5ZXhTBKnUzyEYuU5k8LjuEYxOGgrzKHWGNSPE0T9dSa3T7wj6Bm1sbMdAfXJY4ZA7KlOYw3Xj6bUV/jPmqQ7E6a7FdpNPAxxuvbc/PqciR7JlUMwM63xjpvfOrQ1Xc9/9xOYUkfXgY4Wf8Miv0f2P+NK0p7zksomQv7S6TX/0nIWAJ9UUtIIVgVX9zmNwd8T88NLu0eqK2MU9CVUyLWtZofiasUnKnyt3O8brOujC55/MiXxe0sJMnaenCnubnTLTEYcJNStJL06Yj7hh8HDrUnAcwZg7/cRzudh78Se2D7XHdoDCwnmyUZl2SW1s0M/DlgBKj9hUYNAQ8IdbFGDAVzLLqe5I7tNvIgKQ9Qj4M8jI2iSWjSZrPaJbvI/2lmn1JmWgcIzpqjw9iiBpVk8rAZPzu4cNs9Pj1OwjbAkiJcsR3YqH4g/R4zlGhqn86wWB7Jn5M
 SEcsPglL
 /DTCOcGENasMOjVsb0sNETPkIy14zMFHnl29oI5olsOn+jwYN3z7f2J2XznugGT7x/1LsBFcT9jAnYZupaakmqi4vTHHQSWtp+Pe1BLWr6ByfW8hhCedXoGO0HF/hIfeaUwGtXwvQyMyJMkEgwkw28aWRqCZjKWStGkuArhX2c2GnWjyqPvHYDG7/D31lG3cbitcSjZsP7WdwTrYBhTXG9vR/ED68QryDqx3UYG8j+plT0098T5fbYH2PVcBdU6Nkhi+HzeCJiYpXDxCAbIPBELvhZKwHAU8h7jK+hVSlGDs0xcbEMZNwh8XhEgQx57XJKXLq7DZ/LrKgCf78Tu0Vn4dyJdZe3CYP0LPK7RvRnNLaM6BGL30MXQ/AlxeqGooHPeTsFyPuQl7mGFDUKrteG/eVGL0avLsn4y6HCefYktu8XBe8GUUtuTa65LRrQKCnX4reGI/6+plaYcw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Lift the restriction that kept swap cache folios without a mapping
from being split.  All the underlying infrastructure is sound against
that with a few more tweaks, no reason to block it anymore.

Also rename the split helper, which now handles mappingless swap
cache folios that are yet to be anon, or may actually belong to
shmem.  In either case there is not much difference in how they would
be split.

A non-anon swap cache folio that still has a mapping (e.g. a shmem
swap cache folio) remains rejected up front: it would need both its
page cache and swap cache entries updated on split, which the split
helpers do not do, and there would be little benefit in doing so.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ab2bb29748d3..b80d0db63225 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3881,12 +3881,10 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	/*
 	 * Folios that just got truncated cannot get split. Signal to the
-	 * caller that there was a race.
-	 *
-	 * TODO: this will also currently refuse folios without a mapping in the
-	 * swapcache (shmem or to-be-anon folios).
+	 * caller that there was a race. A mappingless swap cache folio
+	 * has no page cache entries to update, so it is fine to split.
 	 */
-	if (!folio->mapping && !is_anon)
+	if (!folio->mapping && !is_swapcache)
 		return -EBUSY;
 
 	/* order-1 is not supported for anonymous THP. */
@@ -3931,11 +3929,12 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
 	return folio_nr_pages(folio);
 }
 
-static int __folio_freeze_split_unmap_anon(struct folio *folio, unsigned int new_order,
-					   struct page *split_at, bool do_lru, bool unmap,
-					   struct list_head *list, enum split_type split_type)
+static int __folio_freeze_split_unmap(struct folio *folio, unsigned int new_order,
+				      struct page *split_at, bool do_lru, bool anon_unmap,
+				      struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
+	bool is_anon = folio_test_anon(folio);
 	struct swap_cluster_info *ci = NULL;
 	struct folio *new_folio;
 	int old_order = folio_order(folio);
@@ -3953,7 +3952,7 @@ static int __folio_freeze_split_unmap_anon(struct folio *folio, unsigned int new
 	 * similar to folio_lock_anon_vma_read() except the write lock is
 	 * taken to serialize against parallel split or collapse.
 	 */
-	if (unmap) {
+	if (anon_unmap) {
 		anon_vma = folio_get_anon_vma(folio);
 		if (!anon_vma)
 			return -EBUSY;
@@ -3966,7 +3965,7 @@ static int __folio_freeze_split_unmap_anon(struct folio *folio, unsigned int new
 		goto out_unlock;
 	}
 
-	if (unmap)
+	if (anon_unmap)
 		unmap_folio(folio);
 
 	local_irq_disable();
@@ -3977,8 +3976,11 @@ static int __folio_freeze_split_unmap_anon(struct folio *folio, unsigned int new
 	 * a 0-ref folio, it assumes it beat folio_put() to the list
 	 * lock and must clean up the LRU state - the same dequeue we
 	 * will do below as part of the split.
+	 *
+	 * Only anon folios are ever queued on the deferred split list,
+	 * so non-anon folios (mappingless swapcache) never need dequeuing.
 	 */
-	dequeue_deferred = old_order > 1;
+	dequeue_deferred = old_order > 1 && is_anon;
 	if (dequeue_deferred) {
 		struct mem_cgroup *memcg;
 
@@ -4047,13 +4049,13 @@ static int __folio_freeze_split_unmap_anon(struct folio *folio, unsigned int new
 		swap_cluster_unlock(ci);
 out_no_split:
 	local_irq_enable();
-	if (unmap) {
+	if (anon_unmap) {
 		if (!ret && !folio_is_device_private(folio))
 			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
 		remap_page(folio, 1 << old_order, ttu_flags);
 	}
 out_unlock:
-	if (anon_vma) {
+	if (anon_unmap) {
 		anon_vma_unlock_write(anon_vma);
 		put_anon_vma(anon_vma);
 	}
@@ -4257,6 +4259,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
 		struct list_head *list, enum split_type split_type)
 {
+	bool is_swapcache = folio_test_swapcache(folio);
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
@@ -4283,8 +4286,11 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	}
 
 	if (is_anon)
-		ret = __folio_freeze_split_unmap_anon(folio, new_order, split_at, true,
-						      true, list, split_type);
+		ret = __folio_freeze_split_unmap(folio, new_order, split_at, true,
+						 true, list, split_type);
+	else if (is_swapcache)
+		ret = __folio_freeze_split_unmap(folio, new_order, split_at, true,
+						 false, list, split_type);
 	else
 		ret = __folio_freeze_split_unmap_file(folio, new_order, split_at,
 						      true, list, split_type);
@@ -4344,8 +4350,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
-	return __folio_freeze_split_unmap_anon(folio, new_order, &folio->page, false,
-					       false, NULL, SPLIT_TYPE_UNIFORM);
+	return __folio_freeze_split_unmap(folio, new_order, &folio->page, false,
+					  false, NULL, SPLIT_TYPE_UNIFORM);
 }
 
 /*

-- 
2.55.0



