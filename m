Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0CB8C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA85F6B012F; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7D3E6B013A; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD39B6B0158; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67F0E6B012F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BAC11120409
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:19 +0000 (UTC)
X-FDA: 85093505238.19.A2B392C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id AC4D7A000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="icfpxg/z";
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560557;
	b=J1rMNmYDKyxwrexdhJ1Kcoq6sj8YFC3kdSjguFrMq6xK+p0amThwcDzL3EMin3rptGdfWi
	XH4e40STB3ekMISnSW3mhkMAr2O+T10JOe5Vlq709RsS/0HGDiYa/rlxaPlxeJmaS1WjPa
	jublWJDSId+oDIxW8I20bZHh8GkvAOE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="icfpxg/z";
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560557;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5yB0B608tngPZIV5z/3Tw2bUhxs+DF+NDQIXpDRUrs=;
	b=lfdAZyiu1x2eZ3xz992qtDP1SLV10dTrvBilSJaiKDbBhKfYAqn+LUv4Cqk3DZu4VgmWey
	jJyMr5C3c6HNI7hiuor5DI1YpMPqTNjALDqrB9uFcqSe2ElgERZHSTA2RuT6o4xIgt4iwj
	pBgeHR7ttdQzIuadOK7VQkZa9eVkRq0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6145C44FD9;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 447DFC2BD00;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560554;
	bh=L74y7kL9EMwS3z+yBXbz518h0GbrhqCoFh1CzcoW5W0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=icfpxg/zHzxaLIOzErszHAkzeNLs2kFmrTZAm85i2i78P/k7jIsol/uWMMuDwszlH
	 FztzB+5iO+6bCVOpaOo+VJI1F8+IRLQtwF5xepJ79MqQ+M/iwY1eGt8RU1G+BP7Ei/
	 8qZncgoNs+8Bl7JghVwQyjzHquuK62Jaa6yCiY2bmbnVFX5kKUuaAJuZx9dJjd02tx
	 4vEAGlfn4OSE8h/1LgGzUbbK7WAfeFuLAaWVZc0epz5vJrxN4HcOPcwxmdtk5ScLAY
	 y5IJy+iF/vQS4mExa3iy0LJOdEYSod4c9GeHiWzgttKlKROicMHQ7wIdEKasGPNioo
	 2LiRU9crZ6a5w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30714C5CFEB;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:51 +0800
Subject: [PATCH v2 11/17] mm/huge_memory: allow splitting mappingless swap
 cache folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-11-d2ee48c6aa49@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560551; l=5578;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=axzIDmGBd7lK34RIiiCkCmxGB/OY8kzRuNR2iFyLEgA=;
 b=VVfsDpjhS3AuyTbgJ0R3IWwvcbxW474xxgRHBGP/ufz+aIPrjhmq1f0/CY7W8J4qxugU0Nlt8
 iPMsmlMN09zDy48pXfrnTWeWKR9e3BjuYT3OB0USmlvBZznCJwl0hmc
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: AC4D7A000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ijyjb8abyiyumpghiwn4346y8espi16g
X-HE-Tag: 1786560557-646353
X-HE-Meta: U2FsdGVkX198oGwaWqiEoEHwQ09zE7hAuTR9CNdJ31dwhEmLMpcWMa3V7LMr9r/5ayj0jKKD2XztPwUT33SyxE8gfSTssqtFQExwnFiiCu4oQ3IS2AKnu6gfH+Jomr7lMHBUp9JxnEQzAO1VhJiebbWLc9+2R6Y0rCILX9Q0mrxJtoieDFrmyuDQ8QmHVOez5exyeOD48djsR29yv6K6wuYIXPAPdYys7/SLmoK1X5IxLdASEWg3Dq2W+sXQqI7G+u9A3R2t6VS7OzrJPgjaG2cGZET8r0WcIp2H5nPnZgkLFxPRmLxcXdZkPZRf2R4d17SRCOybrA3JXC6Pca/CkyPM3LruXY5Y7QArX8uew6EvVH8KVwgI2OvRbgpyah+MxWs/GqX0ZC4+cz4y4LhEIjWlYfQauxcspgJw1o7yWDncN6l+QvZJSqLxQ6PEIotirv/Vi0qvm1mRsUgXdcIPZ/D19kbVcbc1DWuDUH6Tm7/ZAqrFKlBza1JLW2dSZv4LyPadsUZBZeyvgeJW1whPyhHQ4KG88jZsQyJHvJRayQsNeuSKZjX7Hw/XNLT7K1KPR4pZGKFzTQKVPManQzLbRfBFR+Kr3hMokJREzhtQeSE+yctK+A8m3ThU8bgKgnv9Yy8T/JqW615Gt0+SSeAWbbJNA0IKRo5V/lP3A66Rwu3dezoWbFXeS8feh9r232Oi9/SKucClds6oyVaroLQFI8qoYR35NbfJYTjhez/tiKbDUmVmj9xyml7ywpjl64uhdsVUwdJxORIViwVUvxhpTdekPEiA7SHkNY/nlNFBmTN4ceXgJ8yzn32mjIf9HKYx0K3z4l4xd/qiZI/9XxBov+BxFFPeFeKJ/6Zor2dfqWQuCn9d0jWWeMFEpjQ8O9t3LD+t/rJlgb3ekkBhuJKDe1cXeRcDZwoIjK2aY9IaO5gOExaeV0CN1JvSjQpVTIJEKanxt/wf6v4kgkv/t0m
 RBoxd+db
 UukpGch4olvEVcLUkpvDyLr5I3KqSuRlrnVRi55xpawvlJ+idfQOiAcYhS+eeftrHK67botga/ao7f7/qIJw2SvlbuJPZNXSjFzHPc8EY44iQGDUigAn+DO5LmMuBDmHMmHUJtYyyXW6SAaw5krySm36lUKG2s9OV444hFBRm6nWScUt7sQi0Xnv7W/iPYVLouI+JTsKocYA9VTzMjIt5V7uHdVS1Ny2Tvl3vDs+RbQdfvZpvVk03TAhw7yvomw04AqQctFQy3DAtmdfJS4OYulu38UkAnjhiVEaodDliJtgZEIesMg5c/o0NkbV3l9XPaMJ72M2orQczG8twMXK3Gc2zTeD3Dp0Zanp5dYJCK4m39XkpEl1xxNacRAJn1/sgsfgUS6Tx67ncTuz3jjHNLwWRzth0HSRaUMhTsKSdDg73QN7RA1D/DHcCQNseirLUZwjTUcj8XuDiaBU=
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
index 29b46f039d1e..67401c58794e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3893,12 +3893,10 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
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
@@ -3942,11 +3940,12 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
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
@@ -3964,7 +3963,7 @@ static int __folio_split_unmap_and_freeze_anon(struct folio *folio, unsigned int
 	 * similar to folio_lock_anon_vma_read() except the write lock is
 	 * taken to serialize against parallel split or collapse.
 	 */
-	if (unmap) {
+	if (anon_unmap) {
 		anon_vma = folio_get_anon_vma(folio);
 		if (!anon_vma)
 			return -EBUSY;
@@ -3977,7 +3976,7 @@ static int __folio_split_unmap_and_freeze_anon(struct folio *folio, unsigned int
 		goto out_unlock;
 	}
 
-	if (unmap)
+	if (anon_unmap)
 		unmap_folio(folio);
 
 	local_irq_disable();
@@ -3988,8 +3987,11 @@ static int __folio_split_unmap_and_freeze_anon(struct folio *folio, unsigned int
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
 
@@ -4055,13 +4057,13 @@ static int __folio_split_unmap_and_freeze_anon(struct folio *folio, unsigned int
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
@@ -4265,6 +4267,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
 		struct list_head *list, enum split_type split_type)
 {
+	bool is_swapcache = folio_test_swapcache(folio);
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
@@ -4291,8 +4294,11 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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
@@ -4352,8 +4358,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
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



