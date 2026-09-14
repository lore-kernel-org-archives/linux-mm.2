Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 598E3C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C9FC6B00A5; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8146B00A7; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6DC6B00A6; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBF386B00A4
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 39D951401F0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:16:00 +0000 (UTC)
X-FDA: 85213020480.05.BCEC7EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 287CE40007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IfXxAFVL;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406158;
	b=ARB/8yiXQeisTaJSq5ytmefkGTemNKmto3Z+xniOAeLqZrL9cPNTjnmxUw05Rp1PkgwCa+
	tLZ+Ya+UCuIIf22Ohuvhh6FO+QR6VKmRpokJsdlCxPzpgDQaVaDaZXI2mypUR2899jp1Qc
	WORTAmrJCrPYn2smv51uHQX9uk/hKjw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IfXxAFVL;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406158;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZaZeJMyAT4IXeVVC9LdbRbQGTVr/DkmBt43TFoR0hE=;
	b=DI0Z3vrKQAzbXreMybhXwmuSeVQgV9tCc0iIYxUQ5FrPgVWcG71hS9aytHZdbzpXPhbXQ/
	bayxJxTioscaArpi1fMm14HjAUBMt/YRfC4w6WmgLgIjtxZKJ6RA1JwjrciVLTC0b+PgEm
	DSe/NUqe6DTbbTtlLt4/iu8LSXRuNKQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D0A7243E53;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B23FEC2BCB8;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406154;
	bh=/cN+FBCH4SnvUOXkF/Q8DuRZ83YkXTNFzJp9ZpEBNks=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IfXxAFVLtNGRO0IBfGROsaWcVBt/uq1e62lhZhlnYUTN95XMzT9qnwxo/5Q9KtwQi
	 lUAMCDJDa2Dij6wrwt3+BG7J+LGANarcgvlrIvUQQHL5qfIBW+vcSCfG/r5esMMLGy
	 AByMHxAnO0MLi+OMx+Sab4a5AQRNvxtc+WYXS+qujBLErG4UQTZTWdH0TizA1PQL/l
	 Esj6JttQBzsd9YAXAF2Q0n1UuI8DKVSRUWBZDXlk+//okJmTxkm8SxWyE+khZJpjan
	 scv38hCY8PePzHyiWD72It9+fDCTR+WzQUbWNCiWODZP8Oud1eJ8pSAe87ai0I7vMS
	 TCfkIdDquZTZQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A23E8C88E78;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:54 +0800
Subject: [PATCH v5 13/17] mm/huge_memory: move memcg switch into the file
 split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-13-39878b37dfb0@tencent.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
In-Reply-To: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=3709;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=cmwyWDJZVe1UvzzNSicYdeAQ1Ie6761/rX/pYHb2eu4=;
 b=oOZsXsWV809p10fdYi+5NGL+uJfyRilYaw5kkrwFnSewNLF7giO6F61RSFENYbBJxk0dJI/zE
 mNb0H2jt/+hC6Jrk10LJOWm+/Tqv9YKH7qc8fIM4brbqWOGk5LJyOFo
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 287CE40007
X-Stat-Signature: hfnory6uad3bmji71qg7durei854gw5n
X-HE-Tag: 1789406158-185856
X-HE-Meta: U2FsdGVkX1/DPHDbjN8MdtvvbUBSS26y62paAj6pLCi12uVFD7jRfzfp5jaF4CHgVBmv2+U+9R/xLzlLzXChucYq+l6cb87kigwPSMLT5E83Sa1SfJLS3x0zo7i49Rl50h1F5mhgSGS7c5RyKyymD5qq3aGOa21mHejRACbDH7NcMKsNbRHYfnYBcZMzLQmfgJO4qb1lnUzZUknfZsaAtsZBL2leA2WlwE5asa8KYrYeTqDae/Gv+c8u7fsmezRcWNuBFxV3YH0w4haPI4O5hk1lqF7HyAAwhWNK6b29MITRIap7JeHahGuAPoPoc1oCtCO2dam7EN5uze3YOum3a76WAmTUr8EkWxMo3WkagBHIu7J3QHRnbuMfK4mnZOWi/s+rExw9mINYtSj8w8XM+u3aCuuYa6CE9zdHt8xFAsHys9p6DCW/YmsSnErizGtanq6tt/3qFNns9y5NuBTnuWdh/uDOWQMspBcFmxj6nw1Jdf0uC2m99LvOB0yLvTn2je4WBvC6f5/Fl0r4sC56emh1meyE7WsAWSbgON44gx8aPmTzJ42kXKU0h5pYxlqZgGmXncQqMPa52d+nTIS9Ekx4skEm7ggI3eih71tY3x1VChjN4xjBWJA/sP5hBZpXB9T9al9B3SDHCBSCB84JKuH4NNtSQwV0jrNlTBUe2E/AB6Gu1GsyFcj+6IFtb3zRB0Ao9+NEDJ79WUJl2VlGEa++xasVo9/q/ywM+3GYzMNXCkhRnQHfYdEpqsoVIAZagxk73BtBiA8Deu0ZK7YskK1llDzYLhNk6+IhilR3srPTXGASk9BanAF1GbLyaJFaieo/2hvlw1e95mDAR7J/WREgkMtn4pXwD4Mtr23KgcbUtWY3OSzOiibUgWqQulQvReLSuTy//BoNppnEb64hiKwJxuMkGjWfzQ/k0aDpjzzb0ordd7dWLMw33W/mLLgGPHoCH+fwP0NAl5wCMYW
 3nQ7fm96
 MsytSJNR2uyCZjVNeVkihT7Pi0yr8h3N+rccAHV0zC5N0XJG6W1nONYIgXx0fSY7QNSwJflU+1AX948/e9SJMWTb4TgxgxqdtdiUxDoBt6wTxfoN9OjHoTzCW4amKnMILJZ+SBK8d0WX5KYeg7+FEOlOJfRSDtPkG0fyzYe+yOxVuq2ZZYB7alqD9OBDB7vRwMxtGFjb6KpE7um3SJDx20A22pRm1DT75VqgXG7qx8VjsBklM4Zx/BKuWJ0dVP+7Ukovz/rCQFP6MA7Onr5QfcRR2AT6I0263zdXNtJbaWB6Nl8ipsW1K7IKMSuXPwBiHsllg79BA2fpRelbeVcfqQO5/3eWcE55J5tfroMxmswUfKnWpa/SLCNoYURhzxeRbkqa5YPNsKOw4cACWnnp+MvdH3SnrA7kax+QvbL3NUdTKUCQ+V2XxTN7JYJjrSSdVMZP5ls3k1tVWB0ao/UW2VWMqORE+CluH7km/7EmBXBI4zGm4ltt3ucqDz7wj1Gg+WGxn5PEDJANC1yPbDNzYI2cc/19IXeFBA2elxuwB9TXf+FmFAVPj0q24ZA==
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
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a4c2e38f4a6d..169832e2a866 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4140,6 +4140,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
+	struct mem_cgroup *memcg, *old_memcg;
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	unsigned int min_order;
@@ -4152,9 +4153,18 @@ static int __folio_freeze_split_file(struct folio *folio,
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
 
@@ -4290,6 +4300,9 @@ static int __folio_freeze_split_file(struct folio *folio,
 	 */
 	i_mmap_unlock_read(mapping);
 fail_free:
+	/* Restore the previously active memcg */
+	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	xas_destroy(&xas);
 	return ret;
 }
@@ -4321,7 +4334,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 {
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
-	struct mem_cgroup *memcg, *old_memcg;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4331,27 +4343,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
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
@@ -4378,10 +4383,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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



