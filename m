Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F21CFC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229F66B00A2; Mon,  7 Sep 2026 14:12:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201E66B00A3; Mon,  7 Sep 2026 14:12:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053EF6B00A5; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B96E16B00A2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42EF940202
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:22 +0000 (UTC)
X-FDA: 85187760924.25.C776DE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 36A6540005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QgOTHUlX;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804740;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ElllQurlyVhdzsOskFtOAyCA15PO10ehyG0h3EHkyfA=;
	b=1ALyhIE6vrhebC0J1tfafqz3To2KUNUefP7VqH6UO3wavcb4oajVo5WoCa9c+sYWWQ/nz8
	RnAP9qeoQVVfXu6SzsYCNbKoXDtLc83H8ovYIrQdvCzxfkfvXNgL5DP+G2JZCLht/AaeKi
	x63kRrK2flKH6YHpHd4UWIzfVV9mZKs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804740;
	b=eN9qZvofSyTQx/U3dj6nYdKUtuUrSi1V0d1GW5lA+RjJB1b9Fpaq4ZKXCgSsz48Hqbuq/w
	eeeGWmGxnLAwQYSjpgI+30X/7ValfobKjKEcKHrButU25efKBuTRLbjEIUbKOpe7C6VtUa
	m3nPHp9mR29DgFo5f4D6KtQRsmhz4SY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QgOTHUlX;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 108ED444F0;
	Mon,  7 Sep 2026 18:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5796C2BD01;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804736;
	bh=LirXvJJX0Y/6Fo5sXUix83AOPmuYDoroUD8pSAtNyj0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=QgOTHUlX0OwjqVlEVvoWBbOdTBNWxKz0jkjh5UA6t3TmSY4Z8Ai2LAFlhkpYxg+DV
	 HbHktoBEk9AyN01vgsxxxxSxrwlwBCeH+iD864Rp+D302iNQlbLrbO9wat3JzlCQI3
	 aMNMvf9fn2UbBj9dk3aLxexJU0Oj77+X25p/hmTLaH2OH2sejNV41V9eCWKQLiRe8w
	 MOmaNj0VKRYmIecePX0jdCWXD/CrTOSsSH4PjLaO3lE7P2DqiCb4EjCfWEL/KkG8nT
	 HjqK/ywP5OnoKptuX7lBN8QUdOgY71avmfHaZyz1lWUxsdAA1L/VIU0i1a9QL/nof0
	 OFWVxhGw0Sq6w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1795C79F99;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:17 +0800
Subject: [PATCH v4 13/17] mm/huge_memory: move memcg switch into the file
 split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-13-b532a3f20e71@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=3655;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=uIbn+TS0iIeP9vFYqPvx1IGgAoImfhKW84wopAEDXo4=;
 b=VZnf3gSCQZgZbn1iZTc2hUb/vK13UG9e9hi8wvd77ElBa98VWNojeQ7JlQMREeFcR8EnJ7om9
 /E6JMsBGRdlAc1zXWgKxvjQWVvdanDEgVWQVm4KHeLzleFEL4pTBT97
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 4ybzc33jpqmu4f4j9maon8ffg7mwwj3q
X-Rspamd-Queue-Id: 36A6540005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788804740-269036
X-HE-Meta: U2FsdGVkX18XwbjmUgHrNFMTqlK9IBtyHYQeuTfZUmzcPw1/+5hlOeVdl+cXqN4nr3trYEX6DscmsYTu2KYL947gqN5a8RDGDT+FzPgboi1M1BDLudrbab1zrX4cGcSuPGEnapM/dWRPzj88adzwoHSgRoxHKlLD8NMgvKicoUXedOQ+uUxslF2DOoIQm7perN4Cy9APTnULWGd+6hSvlQw5GneZ6Wdx2dWyt189tC7YOli4KQ6+cSniwyIf67W8PTBkF8bhs80IpMKKqJMMQQ45ykOypUMo5wF7dcpQqJh/8SHdQNBB0hcwZ1t9FKHp1xHH4JtVXWY+gGbyDkF011jabS7XxN6E5qoCIx+SbrFS9z7X0Vg4EJhUgE8ruBHG4mG8zqAIm4woe3q+tcYZsE4DVNXrVpJNwuk2Uh8v3ReJS99QdtYRtdcrrKUqP0RtGA2eJsCdzA+bFpsNKXQ/SU59HKBnjST9uXUZLxx/Swpupv83kboqEkQjHbzPcAPsMvb/pqZCwWcwCHbQ7DhFTXC3aEae0SMtsDkTuHoTI4PQUy0kwEvHlxwflsegYxPR6aOBwmfnVkb4gtCDZJytFKnOxf1sPztlWjwOfRouTeZQITo0ibCuSev3+VUxibAF1CAsKRWQ/bDhAsvi535NwRmOUhWVHXmhhJQjkqU7R3pNsO3B3nOUcABU5N8IvzpaPFOvySmUhUg4B9GlVQmKEs3gjQtFpL9/XbDTqaVQ6HjDqXV8MZzWaJOaZCZFctgwjTwrZ3fG887OXWuwbxHrwIaGgwFdHy/rQuWNjdi9apHT4l2cNVeGJCZ0luVlmBtAluIK17SkELDRJoNOZhft53tF/vIx47ZKHtakP8G35LmiY+J/kH4dpaxtnxoLOo6YBJJEOIRKFH2kAf/cT6nr0eAk19dLpikaTLKc+LDh+hwt8uX/hsTEHO8e7i72f6S8OUW3IGgTLlKqXvf9Fkf
 z2cZ1Gf7
 2VqErL5mVlx2mAKZ1er8gg2gzHI+9LnI+ca45w3bHE3jmOWsxFGEa07CEJXhV5AIpIYKb+4Rc0AWAepDsYa7ubPKY1J0Kuh4LCo5tX4xnx0O29cek7rMBktjmW+z1JWHNwti7njAM5k28V7+SdeoH02LjSuSGRkilsHpW7/jylsc0d5/e3KyleP+Tzmp2c4Leml1RrC+FUXQxw4oV0PzWL/4je6U28+c7W1dmqWIMBpmHOsXCRXOaxt4WYCFW4u36es+jHKtObxROBgl0+P0ZFhmVygK1YymDBsASTqFu54hFyU5h5hSGpM0L25AbSsM/oA1VETzW6wEranqRRjnQT+anElOxWwGAB3LvQgiQT3oBd63eB9CMv5woyAwQGGTc5MeSSyGWcarYlBjfYwqnP83Gp5ywfEp2LAXr7EuhZIKIQ9SATyGrW6cPx2K6d8BYP/QLGRHGKbwYABkK0fkTQFvsBKZDHHSAfW1KYY8rQHHsZJ+No228jkfZnhjgB9qXoweJn6yxoQDTLEW0E2WKPXEO29cT0wWQ4B8PtPqVSEu89kQrewmRepwQ4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The xarray node allocations in __folio_freeze_split_file() need
to be charged to the folio's memcg, so move the memcg switch from
__folio_split() into the helper.

The anon split helper and the after-split folio freeing perform no
chargeable allocations, so no memcg handling is left in __folio_split().
Rename its out_no_memcg label to out.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 53614b875794..ccd48cd5f94b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4113,6 +4113,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
+	struct mem_cgroup *memcg, *old_memcg;
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	unsigned int min_order;
@@ -4125,9 +4126,18 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (new_order < min_order)
 		return -EINVAL;
 
+	/*
+	 * Switch to folio's memcg as xarray node allocation can happen and
+	 * needs to charge to it.
+	 */
+	memcg = get_mem_cgroup_from_folio(folio);
+	old_memcg = set_active_memcg(memcg);
+
 	gfp = current_gfp_context(mapping_gfp_mask(mapping) & GFP_RECLAIM_MASK);
-	if (!filemap_release_folio(folio, gfp))
-		return -EBUSY;
+	if (!filemap_release_folio(folio, gfp)) {
+		ret = -EBUSY;
+		goto fail_free;
+	}
 
 	mapping_set_update(&xas, mapping);
 
@@ -4263,6 +4273,9 @@ static int __folio_freeze_split_file(struct folio *folio,
 	 */
 	i_mmap_unlock_read(mapping);
 fail_free:
+	/* Restore the previously active memcg */
+	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	xas_destroy(&xas);
 	return ret;
 }
@@ -4294,7 +4307,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 {
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
-	struct mem_cgroup *memcg, *old_memcg;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4304,27 +4316,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
 		ret = -EINVAL;
-		goto out_no_memcg;
+		goto out;
 	}
 
 	if (new_order >= old_order) {
 		ret = -EINVAL;
-		goto out_no_memcg;
+		goto out;
 	}
 
 	ret = folio_check_splittable(folio, new_order, split_type);
 	if (ret) {
 		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
-		goto out_no_memcg;
+		goto out;
 	}
 
-	/*
-	 * switch to folio's memcg as xarray node allocation can happen and
-	 * needs to charge to it.
-	 */
-	memcg = get_mem_cgroup_from_folio(folio);
-	old_memcg = set_active_memcg(memcg);
-
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4351,10 +4356,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		free_folio_and_swap_cache(new_folio);
 	}
 
-	/* restore to caller's old_memcg */
-	set_active_memcg(old_memcg);
-	mem_cgroup_put(memcg);
-out_no_memcg:
+out:
 	if (is_pmd_order(old_order))
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);

-- 
2.55.0



