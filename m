Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68339D29FBE
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6D136B0093; Thu,  4 Dec 2025 14:29:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D086B00B4; Thu,  4 Dec 2025 14:29:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5686B00B6; Thu,  4 Dec 2025 14:29:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9CC6B0093
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:29:52 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2E2757119
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:29:51 +0000 (UTC)
X-FDA: 84182778582.12.7C8529B
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id 26D8240009
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:29:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZZLx1eaA;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOM3SvUw6equ2pewheYxYcWCJBK1kBvmm5iLOdPjOeg=;
	b=kRSAGpyAbpzYP6aVea8PFUk+1eih1nFr/iZT4U4l/Ggp7HKnu0jf45t8jp9upblrh/1ivH
	f6lbnixSqcB/2LB94urdegUhVCd5arHN1t1sP+637mOfe6ylAEZnOrKzRXaxqK4Ck6ynoR
	dJsRwvI3vXuBHpayI98Lbz0do4bLUdA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZZLx1eaA;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876590; a=rsa-sha256;
	cv=none;
	b=cWC2bIb2gUABtyVBNBAnZqM6dMgiQGIxh8ipzalkHOe8q0HcHZupqsYPI8wcD10fSciewQ
	yBdKETnWf9slEnSJdxJKC2ortLj8yzjpg2ccKmkabEeUloKgBaR/64BwdNPdHEDsRsN+vW
	y8cMuIUrU+Qwc1z+afxZdrpvE5CnY90=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2953ad5517dso13608995ad.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876589; x=1765481389; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wOM3SvUw6equ2pewheYxYcWCJBK1kBvmm5iLOdPjOeg=;
        b=ZZLx1eaAthWO7gIm1RngIeZbVeufFyxWmofQOyJ/B7In+pFgBShS/Rq9JMZo8zYfsa
         HjpgWwHhFu6KXZjHCADOZyw4vnFpA9Lw8SYZ2tOFQ5gl05Om9gyq57IJQyZPXdSO2XQb
         oZrVtwMOGW+s2Dp0E9LqXBnPHDf7EFoLNotLzCK/Kte8WXWgbEeujQeefC/eDkcdtHTV
         mT3BIgAowZbJyzmm4l63S0+/ij/Tx5ByAz/BkKStAx8VQttYUTocrFpE6iUyv+fZJ2y5
         9sSHIwxeQUZyl1Vp6pyPoNF3Cm6KtR2+rTxiWrE/4beq14tE1XTo5I1pBKGYLtr9bGVg
         +Uog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876589; x=1765481389;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wOM3SvUw6equ2pewheYxYcWCJBK1kBvmm5iLOdPjOeg=;
        b=QCHz9hzrR1hzV3vDIHrDnVPKIHCddbtxFoArwYoeuOyxkG7uNav0IBvja5AiSizbtm
         MpXMm4x8eZhPaeky3mWTzxR/KMZOP869WZH9z0GyzotDtFh42UfrPdvHcMDls6mFqx3L
         Dj40RVvvzwb3va/+0CKASYnxdVWKQbFKlLKlsTAKsizrXv+e9//kB+8MlRjYRIPKh2Bg
         Lp+6Z2cVEfE2QyTZJgtiiNcmdVBGTwY96EUH86tlkhUOU/MwEtsBWJfTwwWCM2bSWbT1
         wxYVU0dQNLyzRTFn39G+igfYdBQ1t5LbSYx5wanPMqj1jc3EEYqHQ8s2JDOJaigDHH9M
         Suug==
X-Gm-Message-State: AOJu0YwqH65d8Ff2I4LtGtlzuUaOrv49rGTciqBtADXCWj2kYfzR4e6G
	clNZHyPluJvWtHV9huOaRZBHyDs8A5l9hpYKdW5AAZR+saGrMKe58j8s
X-Gm-Gg: ASbGnctDD7iO1PEG6dX2Gvv88Z31EAMxaDww3fCTShS3+UiDbpcafzaSkcO13uwUolS
	i/y7zfNXi1dh5kyJcyEbzk3RAyhxMwnN7jZ/ia87wwGXHr3zOGt5r6oych19YKeaiuplEBePnQX
	UrBRsJIqxNW7IFMpj2euYSiYHxXD9o5VpGUl6F6Ty/7YDEq5okVtsOnkgjmlL3A6qQlxbTjiLo3
	pV6tEYZMx///jxs/oS+SjVrb5TATZngNLXqhPAu9K4IkaeYhDmnu3CnoY5PpvfhGS7pin4c6zc+
	qMmeKkgk676RXXjLK/XTCKhQ2FSSQ4Ai73xbQ2E+NCPs1HIhlESJW/0GCaCV0HAvqdCA5ZS9GDM
	4roHm5NpPifWNRvKRsKpJODGlDutHRLrJNSGJcJsNSIB4osktdDLMqVrG48jrzpVlP/CNitzqlK
	NJl1MjsBAYNQM3PMQoR1pqRqJ1iqqgZLUZzVFZID2I4V4AJOVJ
X-Google-Smtp-Source: AGHT+IHdO2edJuvMK7Tdmwga/SAccjACFd4tKCXhD5hJFGNoxPw4sAHksA0RDQa7PXKOpMFQOxmb1g==
X-Received: by 2002:a17:902:f603:b0:295:ed6:4625 with SMTP id d9443c01a7336-29da1eb4c96mr48731645ad.47.1764876588861;
        Thu, 04 Dec 2025 11:29:48 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:29:48 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:10 +0800
Subject: [PATCH v4 02/19] mm, swap: split swap cache preparation loop into
 a standalone helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-2-cb7e28a26a40@tencent.com>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
In-Reply-To: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=7996;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=zTQ0qqEjQqVMue2feX7IfMCwec9b88xoOj9LChkN4Ao=;
 b=rgkfXy5MtJkcEjGgJL0f43HP7rPfSU/RD1a9mE+hj9skY7zby2N4ptMkQ6KZcXdzhNRVXBYXm
 mC/FZQVBxhUC4eLfyPvx8iYrVBSRYmEP/OvTR8ach2w50MmIBUAHrlX
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: 26D8240009
X-Rspamd-Server: rspam02
X-Stat-Signature: eh1qprkunbqyqchs8zyjwfezrjy9ziub
X-Rspam-User: 
X-HE-Tag: 1764876589-834434
X-HE-Meta: U2FsdGVkX1/Fi+FNY+2jn4GsKM3oc5Guecj6eAkwGS6vjYctuFgRtU7pmd2y8dCLrZ8DL2vmOb+e6/+NmIL8uSm1MiCBavSelZK5T47RSeSM2O70hDmDGYeb5zd6BbD018jsi664Ov+PVvevrpjYZDtn7WVqSXDcMBqy1YVDJ4OUcXBgGMAxFrBhnyvXhgmRhWnsM0XrwE8Ckk/mq0bLyFgM8pdGq3cBlOcOeJZO7zP4uDhUG94A9eRnLIZIa6K/XZCJlyZD9RVfgIWYUHkteMeaYw/ECtjTquvWG4F8B5lVV8YPdFOdEsnLYQFlWfdsD5U4Ct8qarBMoWgUh+IUn4R3AY1XXV/0WDG8AReeT7vG8O12dV8MOO6CbAwvntpBKZTQkOQbLE+adwjhAMI3JEzBI9kxEKEIk7wtRoBJeOaTSQiQXRl88rq8uBI8qy0ZoSzGTM3X/R3unSlK9XJdyrOnXdRZgzAR0rc8KXO5uzWzK4cBlmNiaJHSLyjG/zHcjIxQsTi37pPY7IUsIHuSkYnpadDGqPON++J4Qxqz8t0iJvJjeLyUhwncqUxMgA7FN/B6N4aVD+iIUt2GCZOTAzk+pVKSc7o3VBacuEdUF6omBaHLVbQdnkVsraGHgu99v0S2WfU7CEXBpLFf6yW/6gEEIfFQZChL5O4xT30Z2IBX3VZVknzP0gWqzkmcjCbdNDwUzeAEQRf7Qmjh1vj/I9Saz9NcEejP6ZTFcElgL2xvXygWRwAFowJ6AKe3FmkEeUlNQSLIdcbSKlKOnHiTKBz8BKuuVyIldV0NWSY92IXNpiMgAbe2xa5I0cUravon7fsYPaSCBF5SW5lTo1LKXNzVuQGiYVWxpWjJOIP5Czda0j+BHpH7RdfM+mBOxpgTBDPdHnAk5VgwxX/d0V+fYxVa/XnFeYJ9MKzsZl1EDds6tr6UCu4HCWwCuoJNyeiaBKnpO4LyjYH2DGST2/a
 la2LJckU
 uTEnn36zUP0Lf4ya1cIUASChGfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To prepare for the removal of swap cache bypass swapin, introduce a new
helper that accepts an allocated and charged fresh folio, prepares the
folio, the swap map, and then adds the folio to the swap cache.

This doesn't change how swap cache works yet, we are still depending on
the SWAP_HAS_CACHE in the swap map for synchronization. But all
synchronization hacks are now all in this single helper.

No feature change.

Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 197 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 109 insertions(+), 88 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 08252eaef32f..a8511ce43242 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -402,6 +402,97 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 	}
 }
 
+/**
+ * __swap_cache_prepare_and_add - Prepare the folio and add it to swap cache.
+ * @entry: swap entry to be bound to the folio.
+ * @folio: folio to be added.
+ * @gfp: memory allocation flags for charge, can be 0 if @charged if true.
+ * @charged: if the folio is already charged.
+ * @skip_if_exists: if the slot is in a cached state, return NULL.
+ *                  This is an old workaround that will be removed shortly.
+ *
+ * Update the swap_map and add folio as swap cache, typically before swapin.
+ * All swap slots covered by the folio must have a non-zero swap count.
+ *
+ * Context: Caller must protect the swap device with reference count or locks.
+ * Return: Returns the folio being added on success. Returns the existing folio
+ * if @entry is already cached. Returns NULL if raced with swapin or swapoff.
+ */
+static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
+						  struct folio *folio,
+						  gfp_t gfp, bool charged,
+						  bool skip_if_exists)
+{
+	struct folio *swapcache;
+	void *shadow;
+	int ret;
+
+	/*
+	 * Check and pin the swap map with SWAP_HAS_CACHE, then add the folio
+	 * into the swap cache. Loop with a schedule delay if raced with
+	 * another process setting SWAP_HAS_CACHE. This hackish loop will
+	 * be fixed very soon.
+	 */
+	for (;;) {
+		ret = swapcache_prepare(entry, folio_nr_pages(folio));
+		if (!ret)
+			break;
+
+		/*
+		 * The skip_if_exists is for protecting against a recursive
+		 * call to this helper on the same entry waiting forever
+		 * here because SWAP_HAS_CACHE is set but the folio is not
+		 * in the swap cache yet. This can happen today if
+		 * mem_cgroup_swapin_charge_folio() below triggers reclaim
+		 * through zswap, which may call this helper again in the
+		 * writeback path.
+		 *
+		 * Large order allocation also needs special handling on
+		 * race: if a smaller folio exists in cache, swapin needs
+		 * to fallback to order 0, and doing a swap cache lookup
+		 * might return a folio that is irrelevant to the faulting
+		 * entry because @entry is aligned down. Just return NULL.
+		 */
+		if (ret != -EEXIST || skip_if_exists || folio_test_large(folio))
+			return NULL;
+
+		/*
+		 * Check the swap cache again, we can only arrive
+		 * here because swapcache_prepare returns -EEXIST.
+		 */
+		swapcache = swap_cache_get_folio(entry);
+		if (swapcache)
+			return swapcache;
+
+		/*
+		 * We might race against __swap_cache_del_folio(), and
+		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
+		 * has not yet been cleared.  Or race against another
+		 * swap_cache_alloc_folio(), which has set SWAP_HAS_CACHE
+		 * in swap_map, but not yet added its folio to swap cache.
+		 */
+		schedule_timeout_uninterruptible(1);
+	}
+
+	__folio_set_locked(folio);
+	__folio_set_swapbacked(folio);
+
+	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry)) {
+		put_swap_folio(folio, entry);
+		folio_unlock(folio);
+		return NULL;
+	}
+
+	swap_cache_add_folio(folio, entry, &shadow);
+	memcg1_swapin(entry, folio_nr_pages(folio));
+	if (shadow)
+		workingset_refault(folio, shadow);
+
+	/* Caller will initiate read into locked folio */
+	folio_add_lru(folio);
+	return folio;
+}
+
 /**
  * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
  * @entry: the swapped out swap entry to be binded to the folio.
@@ -428,99 +519,29 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct folio *folio;
-	struct folio *new_folio = NULL;
 	struct folio *result = NULL;
-	void *shadow = NULL;
 
 	*new_page_allocated = false;
-	for (;;) {
-		int err;
-
-		/*
-		 * Check the swap cache first, if a cached folio is found,
-		 * return it unlocked. The caller will lock and check it.
-		 */
-		folio = swap_cache_get_folio(entry);
-		if (folio)
-			goto got_folio;
-
-		/*
-		 * Just skip read ahead for unused swap slot.
-		 */
-		if (!swap_entry_swapped(si, entry))
-			goto put_and_return;
-
-		/*
-		 * Get a new folio to read into from swap.  Allocate it now if
-		 * new_folio not exist, before marking swap_map SWAP_HAS_CACHE,
-		 * when -EEXIST will cause any racers to loop around until we
-		 * add it to cache.
-		 */
-		if (!new_folio) {
-			new_folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id());
-			if (!new_folio)
-				goto put_and_return;
-		}
-
-		/*
-		 * Swap entry may have been freed since our caller observed it.
-		 */
-		err = swapcache_prepare(entry, 1);
-		if (!err)
-			break;
-		else if (err != -EEXIST)
-			goto put_and_return;
-
-		/*
-		 * Protect against a recursive call to swap_cache_alloc_folio()
-		 * on the same entry waiting forever here because SWAP_HAS_CACHE
-		 * is set but the folio is not the swap cache yet. This can
-		 * happen today if mem_cgroup_swapin_charge_folio() below
-		 * triggers reclaim through zswap, which may call
-		 * swap_cache_alloc_folio() in the writeback path.
-		 */
-		if (skip_if_exists)
-			goto put_and_return;
+	/* Check the swap cache again for readahead path. */
+	folio = swap_cache_get_folio(entry);
+	if (folio)
+		return folio;
 
-		/*
-		 * We might race against __swap_cache_del_folio(), and
-		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
-		 * has not yet been cleared.  Or race against another
-		 * swap_cache_alloc_folio(), which has set SWAP_HAS_CACHE
-		 * in swap_map, but not yet added its folio to swap cache.
-		 */
-		schedule_timeout_uninterruptible(1);
-	}
-
-	/*
-	 * The swap entry is ours to swap in. Prepare the new folio.
-	 */
-	__folio_set_locked(new_folio);
-	__folio_set_swapbacked(new_folio);
-
-	if (mem_cgroup_swapin_charge_folio(new_folio, NULL, gfp_mask, entry))
-		goto fail_unlock;
-
-	swap_cache_add_folio(new_folio, entry, &shadow);
-	memcg1_swapin(entry, 1);
+	/* Skip allocation for unused swap slot for readahead path. */
+	if (!swap_entry_swapped(si, entry))
+		return NULL;
 
-	if (shadow)
-		workingset_refault(new_folio, shadow);
-
-	/* Caller will initiate read into locked new_folio */
-	folio_add_lru(new_folio);
-	*new_page_allocated = true;
-	folio = new_folio;
-got_folio:
-	result = folio;
-	goto put_and_return;
-
-fail_unlock:
-	put_swap_folio(new_folio, entry);
-	folio_unlock(new_folio);
-put_and_return:
-	if (!(*new_page_allocated) && new_folio)
-		folio_put(new_folio);
+	/* Allocate a new folio to be added into the swap cache. */
+	folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id());
+	if (!folio)
+		return NULL;
+	/* Try add the new folio, returns existing folio or NULL on failure. */
+	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask,
+					      false, skip_if_exists);
+	if (result == folio)
+		*new_page_allocated = true;
+	else
+		folio_put(folio);
 	return result;
 }
 

-- 
2.52.0


