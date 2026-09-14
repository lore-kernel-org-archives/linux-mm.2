Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70FB2C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D814D6B0096; Mon, 14 Sep 2026 13:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C191F6B0099; Mon, 14 Sep 2026 13:15:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92E5E6B009B; Mon, 14 Sep 2026 13:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 521966B0098
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:15:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A301D1201F6
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:57 +0000 (UTC)
X-FDA: 85213020354.06.8C69157
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 90CE240002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dOtXpksE;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406155;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1TSQn1JentxIymnXSmR+HegK4ZK9aelebLel8IoOf3I=;
	b=GDedQajjgEhuFlgEnKrFZHvf131ZZxTslg4U8V7EuYce0YvWTt9kuEqfxz1bT/XNs2JI2a
	USpCcy06nHw+qdeJQHSUjxrAGjhJeIWWpHeD8urxod7dhKN+lhvKmHexs7auI6KQZuCenM
	FCJvo6dDnmycHRzIpVTO1Xa4de8kLmU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406155;
	b=Z+YPk7COkS78fD6TxluQM9bP9/89VoB24HrUCEOrnTJ+YeQsgVxYJ6p7Dz+rm+AUjeoT49
	LWb/r3yiTGT+i4ssqRXLmWxl/m/coDn3XEtClb6HUcLnR00GJzT5nCyhvr/GM8UUsO7vvZ
	VxN8vgC+7hvUMKChzPfpJ9+45TewA6o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dOtXpksE;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 143C8405AC;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8036C2BCFC;
	Mon, 14 Sep 2026 17:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406154;
	bh=abpVLnEUvW8CDt+a/XpJOaH91FoTKNqN5452UmC7Kt0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=dOtXpksErd5xAnDA6AYXoCVmUeDMbQwQGeEBd9PzfnwA8/lq8pROdzzVvYtBGmUJ6
	 SJEkulF8f5S6rp1eRKhK1SoQIwxbZ4qNNCQEP4Jwe7WViN8Zgcv/4WbROf5lI04BRt
	 uIk0FZ8eAwd6ZhjCssMfc3vo9CChWEtSMtKO+z0neqw/KtlQz5CNHybLNjTjjWgUCG
	 T4nXAG0uqV83W8pwcHDWgGzaNd4bcquLtilLf2EbvDc5y3DiwgfRiUtOOs/md3FTEV
	 1hnF92LUhQqJwaOe6ttRVrfNCeD60lZw6SuqhI0rmBGkM30hTAQJF47opHk7wMNq2V
	 Z94aPtIfSDuGw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E7CC88E72;
	Mon, 14 Sep 2026 17:15:53 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:46 +0800
Subject: [PATCH v5 05/17] mm/huge_memory: rename __split_unmapped_folio()
 to __split_frozen_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-5-39878b37dfb0@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=4280;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=XND1MzFZ/5QjlCiHq1qzBj5rRVTZjMI69ArS+Pfup4k=;
 b=eP2IZf1y9TDMHsbAuUXluphK/piRi22XAPlid351B6F/CMR45W/DuZMohILXkvr8o7q0az7ji
 2tNq+Mm4wOcApIHDphbZdHS9tJzYNlRPJi4/cN9EO/Kl9iQFDnQW8Kh
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 90CE240002
X-Stat-Signature: oeyjqk1sb3zb9668fnk4m7txo7qkqtuh
X-Rspam-User: 
X-HE-Tag: 1789406155-554146
X-HE-Meta: U2FsdGVkX19xg0XjL7TYqtVmHB2i4PsqpDDjoXOWmqOS1AyKdU/8oG0YoOzxbNxldwhP1+OCcOelUgw6hCc5rzmvgRZmwvz7slyXiob5u94486b9pGVV/5XeeoIUZ8JuyUBHW2dxS9S4RasDjM7eKd371EesyzuV7bHCpSslXMeEFYFcn5l16oYvhbwU4ZtdD8UZuQDKnpJMpaB1dV1gdbbWLqKt1mdoDKMjwyf4EDQ9Cs+IUa1HpboK/h77HaT4DTyzHeYUxYBnziw7n6b4b9vjw9MVCin5NUbmQgLQQk5Dts6PkBtthbW72FcdYmUuqGUriChDDgCs5qzq2lgRG4kUG3ynYFi+sBf14FsRnCPc4RtbxdP5Ee45td0zE+DAlqSp0G31/WvYfuL1PPFc9mCX3uSgKkV3liR3YvJd5YT4dTwtA5m6vJwJhoYjyiG7JVo5M4xBHAwtxFa4a9h9W1Rap+G41xw1aN3maImpIXW8FgUZctihnIpXm1UIQr/JHo45BXacEzI60mn4k4Syldezmx3eqf/Vcq0Bj+ANY34pC6CMVOQxW/eRqT6enU6gSpnQXdOgHgu46E/+ouVcesaI6X32UGpdU+hoTp++6Ymal4DdZKvtdp71IxXmN19JGvkqWqNEthfxPEVfpJxIxm8RF+iPur0V2TYdhXnz2e1jPJDvfst24O2XUYEh9EsnanJVGeO98VzcxpJjinjbFEklzIPO78pL/0CBH4PVFtSdFuervAwnTR9FULvXaHJ01PVS0O4oPUrclHLajbXBNUEU1W9XxJl04YTTrb8RacbZgo51fyiMTYSH8tY2+/sX+UVrlmLSMDSgQg1eRiYEVR9CBGCtsZEary+8ZHwKwmipXRgjhaoTIAr3Wa3JYprLRoqVE56jjseRu2SA9mWmHVSoest9BXrWl5V/sayCHcDXh2lqOCwGJou7VUsoFe3eWMnn7NAMdWWeyObmn08
 SnIqgDc8
 Ks4rj/4r/BPW/SZvhwCsPaR41GpHnm7RRjGHE1SgKV9mC632bk4Fp3HhBEBQCezhegZMx6IOhjYoXsVYxqYWAybx2+RaX90QB6VyHM0CvsTdJKPQyrs13wUxdCuZ44KYcXW35mkPeP+3/8aFUN4fl24Uffoa2wZCEGABtiUgSeA4/JaWZFJA/L5rr4wUqpFDb6FhI4aupnjRF0ZZV15rXGeON+BPPbe7xsVtWi59jxM7QuLVA1sRqscAU/2//Bi6jPHgTe/HlZBZhVILoSlYIhF9AHY/V8Ubp5c0ydgA41lVXUAhSiK95iYanDe+V0cF7CklkShf4r/N/mgJXvDd8R/PiZgigTcT/PJKqMKCQ3qp3ctgG1tkMLOSyuvCZjKNCyTuKzvtpUICZTqCoxhGQZiBuCIfRyLNHl+wOi0Fa6DxIBnKYS1npw6jzaHAhKvphfv0Jf3lxBjM8Kwg+ZpX8CF895pEwbsH+slyPxRVIPswRJISUCgrAi8tBsTrV3y0gUDWixOTHxdlMzeAs/Tix/UYjGy+ZFCJgJOI9J/AGrK3UYPpuE8LVKl8iTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The helper splits a folio whose refcount is frozen: the frozen refcount
is the state it relies on, while unmapping is arranged by the caller
beforehand. The old name caused confusion and people may try to call the
helper on non-frozen folios.

Also add a VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio)) to self document
that frozen implies unmapped.

Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 517259c1c26f..35c48eaf038f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3811,8 +3811,8 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 }
 
 /**
- * __split_unmapped_folio() - splits an unmapped @folio to lower order folios in
- * two ways: uniform split or non-uniform split.
+ * __split_frozen_folio() - splits a frozen @folio to lower order folios
+ * in two ways: uniform split or non-uniform split.
  * @folio: the to-be-split folio
  * @new_order: the smallest order of the after split folios (since buddy
  *             allocator like split generates folios with orders from @folio's
@@ -3851,7 +3851,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
  * split but not to @new_order, the caller needs to check)
  */
-static int __split_unmapped_folio(struct folio *folio, int new_order,
+static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
 		struct address_space *mapping, enum split_type split_type)
 {
@@ -3861,6 +3861,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	struct folio *old_folio = folio;
 	int split_order;
 
+	/* Frozen implies unmapped, callers unmap before splitting. */
+	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
+
 	/*
 	 * split to new_order one order at a time. For uniform split,
 	 * folio is split to new_order directly.
@@ -4038,8 +4041,8 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_unmapped_folio(folio, new_order, split_at, NULL,
-				     NULL, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
+				   NULL, split_type);
 
 	/*
 	 * Unfreeze the after-split folios and put them back to the right
@@ -4105,8 +4108,8 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_unmapped_folio(folio, new_order, split_at, xas,
-				     mapping, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, xas,
+				   mapping, split_type);
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
@@ -4170,9 +4173,9 @@ static int __folio_freeze_split_file(struct folio *folio,
  * @list: after-split folios will be put on it if non NULL
  * @split_type: perform uniform split or not (non-uniform split)
  *
- * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
+ * It calls __split_frozen_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
- * preparing @folio for __split_unmapped_folio().
+ * preparing @folio for __split_frozen_folio().
  *
  * After splitting, the after-split folio containing @lock_at remains locked
  * and others are unlocked:
@@ -4275,7 +4278,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		i_mmap_lock_read(mapping);
 
 		/*
-		 *__split_unmapped_folio() may need to trim off pages beyond
+		 * __split_frozen_folio() may need to trim off pages beyond
 		 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
 		 * seqlock, which cannot be nested inside the page tree lock.
 		 * So note end now: i_size itself may be changed at any moment,

-- 
2.55.0



