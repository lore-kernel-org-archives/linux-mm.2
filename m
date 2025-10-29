Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3685CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:59:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42C1C8E0094; Wed, 29 Oct 2025 11:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403D78E0045; Wed, 29 Oct 2025 11:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 340E88E0094; Wed, 29 Oct 2025 11:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24DAC8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:59:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDAF212B3CC
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:04 +0000 (UTC)
X-FDA: 84051610608.20.DA221B6
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2DD421A000D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=feYjUzqQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pu3PoeCbPMR/s39iM0CKCsQHdYun12Iw5kqNeSZR2xk=;
	b=KGIcYpdD18pqZiXwVKEcYVmRuX0yB5sSiod0irJ4bjt4s0pGF9jfZCC5mi35+lhpGYzDlb
	/k/NBcKUQTUrFMipyY3srOaShYzKwI0vk53nn+qvZrYz/KSmHNMgnYD03bhxVLU64ZN+lU
	drPa3jfH0dWtvnnv/uuIeJCmZssCVVQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=feYjUzqQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753543; a=rsa-sha256;
	cv=none;
	b=rA4flugKS5T4pkmjEklk/pgsedKXPhTSvpR2D2oEShMRBTqQMVcukZHp5Igq9fklF8tcNq
	ui2wkjcUsLpLqmOktZt2axcvkOxOw9NIaFioPYvR9nN6HEfzD2WmR5bJkUMRtkAfNRIxLy
	SinWJB2hT/5ICVUVV6v199FWroErHkI=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29488933a91so76593955ad.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753542; x=1762358342; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pu3PoeCbPMR/s39iM0CKCsQHdYun12Iw5kqNeSZR2xk=;
        b=feYjUzqQyqNzqGi/vAXsuDxM6Lxt3l98IoHhSkF2B3og8LAl7L9chVbRyq9AvLncQG
         k+koGr3zCLFOpkRHbsGDVaQo9cH5/wxzAMWnwHYDreqiJotJDtlE0HXDQzqQz4t4t1Vj
         9qsNmOlYVxwb85bDgf2Nt8+p9lPVGGAf1ws7qLAF2GirE0pCacC5KcVK6IOrALJr9lab
         g0fVtw4nqXZY2l+fOgWsRQ84fb0Nu0JWfz/Ws+l+BWyqDyvRsQSbvYrAnYNgv7a7pkfj
         9PjTxy9mnjvz+hadaKdwBSacjSe4J8HwmTqlKO0B+wCF0I64RVvWV0KzFqwl895KJbWt
         WsvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753542; x=1762358342;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pu3PoeCbPMR/s39iM0CKCsQHdYun12Iw5kqNeSZR2xk=;
        b=d1F8pKDfjzBi4HHoX2TxciGtCGoWIbMyqtwhzaYg5gQaUJGI0cUR0+XMxLm0kz/b+L
         UP/kqWToAzORWG6VZ8mZPr/fhRqpLYCjbWnh4D0NDzaaS21bR/N4FiGRSi3zfp9Br9tM
         Je7V+I8umTgas9CCeAiF7A4PXZ0uKdSW8If+M6cttDD3xS6fZrMA66hS5TfckdNO1V1P
         UK19zUuODgqF0ha+qBtKQMOR6p7MN8RC6LegB/NRo68tJe/NCXJSc8bmbdBzOVFw/PbX
         Ipsr4wcod5IQCEMfATjj/KIL2X6T7j8LETIR8K3xWuaSQDQibjqWH7q28mCdM9xNSBdd
         dCAg==
X-Gm-Message-State: AOJu0YzrSUjDsCSV/501KacnvwJs2c0+7H/wdeyV/nk2fhPQb0oH2yo8
	tkMVZZ5XxzhRUH/S5niyjqXo5BiaYL7flHwH8wyKlRzPGs9ij0on5S0J
X-Gm-Gg: ASbGnctBhokPidoByKJltNNHdYNBOLLUfGFoAPVcf7hf6ylqBLXO5P0GTZ5IwYfWhKk
	sqtUNt90sPFDaBn30I5tNhR+XzKeLeLD/glwWN+xqEgP6JcVpMHr5yZNNV5GYWzu6iM4Pm0vuaV
	UzP9YVSN7b/HPgW2cZsxSCNjTHknzrbmz/92CsRh/yx3/2ZS1yGc+kKTcLsCmtSRbSztO40oX0X
	qBtOyPpx7BV8f/n4Y9FTLo9CBA//NB/277bdITwVSmB9+fw68Rdi07+ahR84kfIvcIvTWnuYx/R
	VDjU4cBks+w4ppEdjOZBIsrw2H5lAXUEigIvU57axcby17myUETxS2VLRuez05fDy1K4nANlMGa
	uwllA6pBA0cKFA7IzN0lrdXmMT5m4Q2wCipyg9bUiMLmBIWYZS68cDoTZyXHvMDJDDPzZfD4R0j
	piUshnQHpn2Q==
X-Google-Smtp-Source: AGHT+IFb1iX3tuV0DGXqg+fZe0C14p3sGVHz3BXLkVY5YOZsG0Sk2fwS8XqgdeRiLf9YYVqpNW2Uew==
X-Received: by 2002:a17:903:2f8d:b0:269:9a8f:a4ab with SMTP id d9443c01a7336-294deef0a25mr38448885ad.60.1761753541822;
        Wed, 29 Oct 2025 08:59:01 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.08.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:59:01 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:27 +0800
Subject: [PATCH 01/19] mm/swap: rename __read_swap_cache_async to
 swap_cache_alloc_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-1-3d43f3b6ec32@tencent.com>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
In-Reply-To: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@redhat.com>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Huang, Ying" <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DD421A000D
X-Rspamd-Server: rspam03
X-Stat-Signature: kfctddpb5xg6urf6kxfoq6rj6utpxcod
X-HE-Tag: 1761753543-279205
X-HE-Meta: U2FsdGVkX1+Sk7Uciub4uo3GQFHtiPS54n4eNaTH9kZP7jpHrimCyYIu9QN6792BxrJ7LVxbWwLfZRaPM7h1GD+K4ic+W0O9fgiNwGZN+oSpzKwEMstKOQdarXPGI7rM0o+OSTVnpfMCSVcjTK2+eV5dHSkt8PZSrhAK1aZhwAu8aYvy8Oh40TPYXDNl0NHWr8b6Hp7Rp2TAe+0x0GPkCPupafN5ox3X2peW2vbitqmLbFLx5E4xGKvToMlrgurmfaAY2hGOPlO25cBXG6QYgqGxE3VcYw+H6oTnAgs67vdtb5cKhUBI6xmuyzwc/dIAbr5THoIYz8pkprR49DhCZqYTaVGSOPuWG8kTz0XMnwIuz1Fe7/fbQB5xP1j09UHCs09E1TmChf+BpMKzS/VsAvU140+S++87vBCZ5mnwIflUIyUp2tBtkTontarNuXGAaxQt2EScCQuaMwWL94AeBfi+gs4QPBZN3PLo6zL/u6UgoOD9cF5IrrTrxD+YwZJlChAM52dVLldDdFvmMlMB39z6fKF5TPAPK/yiAnQDF7sYKo2tWLf1UDyrvMVz4KnFPtphAqQhtLPaH2BsUr0Y6HR/k504CleGChGg6xf2xTtwTElH4UH0Z0A17q2O/wEd71f3+EiBA/TmNPu3OnrvfwU8jhWwF/ozmyL+ppmgscfKXyTaUvig7apgSOXmPz2tXVAEXyH/FcXE6Kciaz2ZNNRn3mqFWXz1Bq4rOUwhpDJPVkxC9ZP4NzORmuhM2HoVeq5sr/HmweG1DOLVjrWNVTZwfspiIpiFKcxHliZ3zKn+G2EAvd+17UJq9MeeTJyyDNtaf1BVneovoesxhHA60Hk120cPyRtHIVv92/WApVxxMRi6j6eyg37GTFXEy9vJdm9HFRhkbd4AdDjLYoKCmToYXNcSYFm2qS6LJnWFwb52AWjJgWmaTW5B3n7TVep7FVixR0afTSyfWJaNxVi
 /diGpFdG
 X4EWE9I48ZCVLkqyK7ZdB2DPw9KLFSjZ8cdb9/qqr6L0QVfJt5RTlg9+0fFNJum/dKf7rH2TGpHg/2ec=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

__read_swap_cache_async is widely used to allocate and ensure a folio is
in swapcache, or get the folio if a folio is already there.

It's not async, and it's not doing any read. Rename it to better present
its usage, and prepare to be reworked as part of new swap cache APIs.

Also, add some comments for the function. Worth noting that the
skip_if_exists argument is an long existing workaround that will be
dropped soon.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h       |  6 +++---
 mm/swap_state.c | 49 ++++++++++++++++++++++++++++++++-----------------
 mm/swapfile.c   |  2 +-
 mm/zswap.c      |  4 ++--
 4 files changed, 38 insertions(+), 23 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index d034c13d8dd2..0fff92e42cfe 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -249,6 +249,9 @@ struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadow);
 void swap_cache_del_folio(struct folio *folio);
+struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
+				     struct mempolicy *mpol, pgoff_t ilx,
+				     bool *alloced, bool skip_if_exists);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry, void *shadow);
@@ -261,9 +264,6 @@ void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
 		struct swap_iocb **plug);
-struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_flags,
-		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
-		bool skip_if_exists);
 struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
 		struct mempolicy *mpol, pgoff_t ilx);
 struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
diff --git a/mm/swap_state.c b/mm/swap_state.c
index b13e9c4baa90..7765b9474632 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -402,9 +402,28 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 	}
 }
 
-struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
-		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
-		bool skip_if_exists)
+/**
+ * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
+ * @entry: the swapped out swap entry to be binded to the folio.
+ * @gfp_mask: memory allocation flags
+ * @mpol: NUMA memory allocation policy to be applied
+ * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
+ * @new_page_allocated: sets true if allocation happened, false otherwise
+ * @skip_if_exists: if the slot is a partially cached state, return NULL.
+ *                  This is a workaround that would be removed shortly.
+ *
+ * Allocate a folio in the swap cache for one swap slot, typically before
+ * doing IO (swap in or swap out). The swap slot indicated by @entry must
+ * have a non-zero swap count (swapped out). Currently only supports order 0.
+ *
+ * Context: Caller must protect the swap device with reference count or locks.
+ * Return: Returns the existing folio if @entry is cached already. Returns
+ * NULL if failed due to -ENOMEM or @entry have a swap count < 1.
+ */
+struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
+				     struct mempolicy *mpol, pgoff_t ilx,
+				     bool *new_page_allocated,
+				     bool skip_if_exists)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct folio *folio;
@@ -452,12 +471,12 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 			goto put_and_return;
 
 		/*
-		 * Protect against a recursive call to __read_swap_cache_async()
+		 * Protect against a recursive call to swap_cache_alloc_folio()
 		 * on the same entry waiting forever here because SWAP_HAS_CACHE
 		 * is set but the folio is not the swap cache yet. This can
 		 * happen today if mem_cgroup_swapin_charge_folio() below
 		 * triggers reclaim through zswap, which may call
-		 * __read_swap_cache_async() in the writeback path.
+		 * swap_cache_alloc_folio() in the writeback path.
 		 */
 		if (skip_if_exists)
 			goto put_and_return;
@@ -466,7 +485,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		 * We might race against __swap_cache_del_folio(), and
 		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
 		 * has not yet been cleared.  Or race against another
-		 * __read_swap_cache_async(), which has set SWAP_HAS_CACHE
+		 * swap_cache_alloc_folio(), which has set SWAP_HAS_CACHE
 		 * in swap_map, but not yet added its folio to swap cache.
 		 */
 		schedule_timeout_uninterruptible(1);
@@ -509,10 +528,6 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
  * and reading the disk if it is not already cached.
  * A failure return means that either the page allocation failed or that
  * the swap entry is no longer in use.
- *
- * get/put_swap_device() aren't needed to call this function, because
- * __read_swap_cache_async() call them and swap_read_folio() holds the
- * swap cache folio lock.
  */
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
@@ -529,7 +544,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		return NULL;
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
-	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
+	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
 					&page_allocated, false);
 	mpol_cond_put(mpol);
 
@@ -647,9 +662,9 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	blk_start_plug(&plug);
 	for (offset = start_offset; offset <= end_offset ; offset++) {
 		/* Ok, do the async read-ahead now */
-		folio = __read_swap_cache_async(
-				swp_entry(swp_type(entry), offset),
-				gfp_mask, mpol, ilx, &page_allocated, false);
+		folio = swap_cache_alloc_folio(
+			swp_entry(swp_type(entry), offset), gfp_mask, mpol, ilx,
+			&page_allocated, false);
 		if (!folio)
 			continue;
 		if (page_allocated) {
@@ -666,7 +681,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 skip:
 	/* The page was likely read above, so no need for plugging here */
-	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
+	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
 					&page_allocated, false);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
@@ -761,7 +776,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 			continue;
 		pte_unmap(pte);
 		pte = NULL;
-		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
+		folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
 						&page_allocated, false);
 		if (!folio)
 			continue;
@@ -781,7 +796,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	lru_add_drain();
 skip:
 	/* The folio was likely read above, so no need for plugging here */
-	folio = __read_swap_cache_async(targ_entry, gfp_mask, mpol, targ_ilx,
+	folio = swap_cache_alloc_folio(targ_entry, gfp_mask, mpol, targ_ilx,
 					&page_allocated, false);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c35bb8593f50..849be32377d9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1573,7 +1573,7 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
  *   CPU1				CPU2
  *   do_swap_page()
  *     ...				swapoff+swapon
- *     __read_swap_cache_async()
+ *     swap_cache_alloc_folio()
  *       swapcache_prepare()
  *         __swap_duplicate()
  *           // check swap_map
diff --git a/mm/zswap.c b/mm/zswap.c
index 5d0f8b13a958..a7a2443912f4 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1014,8 +1014,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		return -EEXIST;
 
 	mpol = get_task_policy(current);
-	folio = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
-			NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
+	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
+				       NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
 	put_swap_device(si);
 	if (!folio)
 		return -ENOMEM;

-- 
2.51.1


