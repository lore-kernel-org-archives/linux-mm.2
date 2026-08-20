Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8926C5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139476B00A4; Thu, 20 Aug 2026 14:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E82D6B00A2; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59386B00A2; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C83D6B00A4
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD9F3A2C06
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:33 +0000 (UTC)
X-FDA: 85122551346.30.4F232FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id CC347A0003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sMHXXLtk;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252131;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0evl4XHXKEeLpAPvE09AtEmL7POJ66cuWxs1YBI4Duc=;
	b=Aanr69EqL81gw/OWPyobaZ+ctXr46krqFhQb9aN890VVwUte4oNrQ7jjbSBkacRItmSAHP
	YI8aI7+y7By0hYbS73ZgiVhaJB5Y+/A4Wo1mtCtC0x4ykasywAFd2RdVByc82rtaU2lDQF
	8Tee6ArXpiInxjUd/Hql/Bn5nBsVev8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252131;
	b=UyNj3vDOvbbwqOqZXkeyW+uEmVSI9AkSUhkCYoJ+z7KCCU4EhVTYvCpCljRJ3fkJzTPYXd
	oCjlJnLtdKC53EUB1oKBpvNgwDUc+YoChvwDHCpZcqSlW4zAY2EydSRitvREwwqx8syB/J
	XOOGRUN5x/litMXKYnz0XJlk9PJmsc0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sMHXXLtk;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D86E440BA;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4DC6BC2BCC7;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252129;
	bh=qS4GqYWYyCCl8+fmXxoIq1Kn3P5FdUJnXvOLbgJEa5Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=sMHXXLtkAHLYLZzD+2nckPPvXWVlnM8Yxr/9pYnZ8pvfH1FcV9iHiYYkpatY3OIOz
	 lAFY0Q5JMWaZbJOlrodHlUpOXWZ9PMzJutfc4S6NnmjjDjBTOCB00H5Lw3Hb7Zxq1h
	 lNGJ/72e2o0w5Y2VWazqBpk1/44EMB89kt7oAoVHcxrwKsZ38omXVU7QJiFPHBtbfT
	 o+Ez41bbGNFw3yCsfuoeTLzFFotDvo3ZlqaGRisfNxkNhA8l6TwPwCroo1IoyfCkHL
	 S7ceJ/Q9hP6ehtIQULIU1kgVHgv4U9bchZnBQdkEraYzULeRjxhLRfLEPpB590pOIW
	 uplKxjSTeZoYQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6B0C5DF89;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:24 +0800
Subject: [PATCH v3 11/18] mm/huge_memory: allow splitting mappingless swap
 cache folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-11-9b43f5163238@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=5443;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=+MFrBoVl3UissmIXdeJ6Mf1y1W98vPZg6lWzSIq2S8w=;
 b=9MxM5xq4PW1atRNEtWMxx91LNUhT+mJy9k4IxQ04fXi5Ho8QFpxpINzrNVJMNsi/kw1TFRQqI
 z+DYD7MH8KxAq3QbHAHrQfgIDvWuGjgXSQC7XAbzH2H907ywtYOxxhr
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: 7e3umux8hoktc7yb7szmijdss69rhdnm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CC347A0003
X-HE-Tag: 1787252131-762212
X-HE-Meta: U2FsdGVkX19RPGcIXmEGlgGO497H3XuKvKYbZy4bOCNP33dgc+q1GoHIHpJF8RA7k+niisBc9jeEW5cHN3/tGxq7B5HEzttznbNKc0SBqUgxyuAspUgaasn8vHJi9mhnh8OmKgMfqr9jk0d3QZkYbe7h1j2GIC3EGcCqigaV1182lACrXo2yRLyGCAK0y48lKolTqdrxEw9V4mE5qPeFLSCa9E1xFkhJH+HYw/NCaIOCX01bUfD9lI0Vi62AiWNC6G1ilJhyQqY+Dgdfejo7vhWYzUOrQ2Qng7Jqv7WaewNyelRBH5Ofq3gxS97pAJiW4EPg/5WbiedEgInDOFTAYBFjkSA3+BzXX3/2rqHdiFSQ48GPK9zIgCHLMw8FEztlnAnqCUzFMf0frOmenQVGaeR3c/j0P6PQmJC3Pv1QsjtKMOBQj340kclACiv1M3iG82KLeRDuhjS6ubKmrplzEFt3CFWMk2kV/JrYnH1MzuYUK475oCSToUtemLNlrXiMeTqQZIDXFlMt5YNWOYJYbkYh69Ab9emfqVDgeIDh6tvZ7UO/cmFtvCGpXNwyUJeWq/PxyNCDXJr4HLkHVqM6/S2YXkGY+0bE0wXghsUYFd5LhOUw8feQDS3Xf0FQxeQ1JGvySc1WJ7qdi/fGrZzUDx0qw2NUO2kskPceJEfU64MFa+CiuCiciIcaq2mFljm2pZD4EDnbSj+Ub6pmg+m4sbp2KRmqpKNYj/E6LCORZlha7gcCgbURnaxsjzNU2AnCU78ie9pRI2KDZhGUcC2v+h9IaRI0iD37bNY/BLM0/1MR9BHKWI1lnXgPkta3fkzyshHC7PTiCA064n/IDeigZygkX9uHgujbUx6OofyQl6Iiiin5o+UHLsAW2cUxSlAdcJ7jJgnNpLqQ3T84gnluVldWe46fz5BnSH/tsYlGjiKQbItvEIOezQg8oZWPHAgQ/fUVhPr7tK+gYCugtwH
 Ki9qA4RG
 sA83SEpQauFp6kWVfGEVDKmOG9Fd0p6d+j0Ev2bbzuYSnbezxXn7qtEXa+4VebU6m8I6JS8a2RMvYRSfpk2qPoV1vwvenCPHV11/t21b89VmGMOAw7ijfQhzd0gW5n2v0dlC8Yod15zFuHaJRY6MDe7Mxh+LrUKIcraR6UBmhghLYCMfaY9LZVp8+I+ugEzWNf7oHVsY/3JnNjk7OrwVULfMqdUeYOplD5VAaUqxBNOyGMnvjd4B28Ps/mcxZVJSG8/FXMk4tAjwhAwcMQeN+PS+BZLtV2LmKHmV1FH69c9hnj9yXxFOTxkgZi49tuMDyqN8unWXL+UnEXccJ7ukpVKZdOuyUKUKm1GQGkLqo++a6HLiX9g9by+DeATjP5qD1qCaLIefNq3UbOkx63IWM1vFbNGBZIaCeNoIBSywFYAujKAjHJ14Ah65I/IK5bS2XzcIVlCVUo+4rbkA=
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
 mm/huge_memory.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3029cb1f07f3..0186238e0d1e 100644
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
@@ -3930,11 +3928,12 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
 	return folio_nr_pages(folio);
 }
 
-static int __folio_split_unmap_and_freeze_anon(struct folio *folio, unsigned int new_order,
-					       struct page *split_at, bool do_lru, bool unmap,
-					       struct list_head *list, enum split_type split_type)
+static int __folio_split_unmap_and_freeze(struct folio *folio, unsigned int new_order,
+					  struct page *split_at, bool do_lru, bool anon_unmap,
+					  struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
+	bool is_anon = folio_test_anon(folio);
 	struct swap_cluster_info *ci = NULL;
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
@@ -3952,7 +3951,7 @@ static int __folio_split_unmap_and_freeze_anon(struct folio *folio, unsigned int
 	 * similar to folio_lock_anon_vma_read() except the write lock is
 	 * taken to serialize against parallel split or collapse.
 	 */
-	if (unmap) {
+	if (anon_unmap) {
 		anon_vma = folio_get_anon_vma(folio);
 		if (!anon_vma)
 			return -EBUSY;
@@ -3965,7 +3964,7 @@ static int __folio_split_unmap_and_freeze_anon(struct folio *folio, unsigned int
 		goto out_unlock;
 	}
 
-	if (unmap)
+	if (anon_unmap)
 		unmap_folio(folio);
 
 	local_irq_disable();
@@ -3976,8 +3975,11 @@ static int __folio_split_unmap_and_freeze_anon(struct folio *folio, unsigned int
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
 
@@ -4045,7 +4047,7 @@ static int __folio_split_unmap_and_freeze_anon(struct folio *folio, unsigned int
 		swap_cluster_unlock(ci);
 out_no_split:
 	local_irq_enable();
-	if (unmap) {
+	if (anon_vma) {
 		if (!ret && !folio_is_device_private(folio))
 			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
 		remap_page(folio, 1 << old_order, ttu_flags);
@@ -4259,6 +4261,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
 		struct list_head *list, enum split_type split_type)
 {
+	bool is_swapcache = folio_test_swapcache(folio);
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
@@ -4285,8 +4288,11 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	}
 
 	if (is_anon)
-		ret = __folio_split_unmap_and_freeze_anon(folio, new_order, split_at, true,
-							  true, list, split_type);
+		ret = __folio_split_unmap_and_freeze(folio, new_order, split_at, true,
+						     true, list, split_type);
+	else if (is_swapcache)
+		ret = __folio_split_unmap_and_freeze(folio, new_order, split_at, true,
+						     false, list, split_type);
 	else
 		ret = __folio_split_unmap_and_freeze_file(folio, new_order, split_at,
 							  true, list, split_type);
@@ -4346,8 +4352,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
-	return __folio_split_unmap_and_freeze_anon(folio, new_order, &folio->page, false,
-						   false, NULL, SPLIT_TYPE_UNIFORM);
+	return __folio_split_unmap_and_freeze(folio, new_order, &folio->page, false,
+					      false, NULL, SPLIT_TYPE_UNIFORM);
 }
 
 /*

-- 
2.55.0



