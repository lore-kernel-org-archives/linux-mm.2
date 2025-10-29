Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E638DCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 16:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31D578E00A0; Wed, 29 Oct 2025 12:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CD6D8E0045; Wed, 29 Oct 2025 12:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1956B8E00A0; Wed, 29 Oct 2025 12:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06ABA8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:00:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C46A12B39C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:00:02 +0000 (UTC)
X-FDA: 84051613044.01.4C8F307
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id A8286100003
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:00:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Nx/BC+2Q";
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HaJeOLc41bvRnU13WOF01XHE844GkJvbSlk0im22rDM=;
	b=0DlM2IQ7vo2u+6Y2v4Ei4Aoiml/j6WYGPOOFohJnN20X/wkFUVRvE0bsySC5kmToN4rRpr
	rIhs2GRy2rTonOtp3QmX1KQ82Dj3Omsk8FOB4WRqSbgXYJbX5rWjKjHRQFwqetNPJr2yTd
	FssUYKdvQ+663xzQDvYOTHPD+DIFRgg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Nx/BC+2Q";
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753600; a=rsa-sha256;
	cv=none;
	b=fGpkzMDxP0rOHk54fearnhBs1X1hWSAuUDMInpoSuJnE5OWrtp98fm8cJghgsnrGrVQ4b2
	Sk/pBfRFEcw6iUnFt6NgmV25mKPW2SSYvED22vKo8/NPrLYuWwnuvYY5HAkD2s7xZ0j66B
	iSnhTUxv0ut4ige9gr0jxW4AVI/yX+w=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-339d7c4039aso95357a91.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753599; x=1762358399; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HaJeOLc41bvRnU13WOF01XHE844GkJvbSlk0im22rDM=;
        b=Nx/BC+2QW/JtWLXYWXIuyWY5770u4G9HUIoBRSBmcltm+hBAVD4ms8tuDJMe6GycZU
         +8VtSZr4UqvI4CiDgfgdWZaps2TuB7g1RGgKL7jSzkAHSXMU7AjF9FsEhQuMJEBM4X4R
         Prt0R6mrKyOH4o7hzbq+O5RkarJQUMz5JGiR+YZbvwGb5u9++Tju50sBU7WXMitSfZRp
         QgPNI3Cz7sqINCNQo2eN0L9Gl7J4vcPfBGdOp5LQf0ovsSgx8I+E24uX/5GJaQ7q7KDC
         zTntCEB9M1NLPcaoczZDp80gP79XhIXjcaB/PamrpwGHG6KYntoHA0+TXEtGD1KngWqQ
         d4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753599; x=1762358399;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HaJeOLc41bvRnU13WOF01XHE844GkJvbSlk0im22rDM=;
        b=gA86ltBCqtBxXUuYVS8dhCcq3UJq8z5OOu/BfFnYLLh0hGw/YDY3nFQz5Sal7qBbXR
         3uJmw1MP6LxB7daoFxaVCmT2AcE5qBSWa10Hts9ClFtPxmBe+l+Y4RuV8OphzjrniwOO
         svCuss5A44b7GX4atXIoRJwd8kCqmNv3C4Nuaz/98LqJXtfsGzypI6aJCF2ASfRXiZE7
         iVGXoIPi9Kw1u3JXTlHR91WIEHTQAghtshLJsgafyrYUYPPd+7zV9jMde7nAid1lSe6a
         8tJ69OEy8/GZCWnsp7cUa2UriNNGUmF9DtOweXTKDdFAIWXOSL43BQmiOP3Ugr+aJl6h
         dJyw==
X-Gm-Message-State: AOJu0Yzmompuq6yCw8EA4HBb7xFyql8kqd0QH5bwWvognFPmF4M1CIuV
	2o8W9gsbLQbZQ1TWX+Fv8W8ABwSyQ4oSDy4ROkOVakvSZ264cesC2crM
X-Gm-Gg: ASbGnctdKxO1wfa5iqsCa1PjT2jOGDSjWHJ1cU/f7lR4SSn3tq7MeA4cOyU2NlK76Xr
	d6Jwtodmu2etG6WMlsFG8pTVPymhuYR9qibiToO/WXa0XQrnsZiGreIiG67bkB7bNQGdj+rramL
	OguFfkTFtGi9wAFqFFzO9nP9kXQT4lXOPK+eO/p4hcLBFQhzA2bVCmh/pNRP6vObjxhzuK461GU
	/3i5Y8e2NoFH6ow132eaHkXOfkX9OQWrPIl8I6d/EeDriyE1p/6rY+Y3H22NY2F/gXZBmRrTCLv
	sOa8UjQw4xIKUei/EC1YLYiWXCW5TZvM3b4RBWpnO2utYipqY3DTArtz+0pshVr741A88PUgDED
	ToXFilZGIA4P8opwInM3KnT4XFHvjEXp9+ifScM3pq1uCQCJ90MjyMqz492hZj6RjBYP9KzC1cI
	5tv2yvU/ikDEsp1B3ldPE2LBwMF7l/IaE=
X-Google-Smtp-Source: AGHT+IFBM69X5pxHyD3MEtjs9Hok3q/yPZBDJUCYgD5ZLroaODN6kmz+XKztQfn2faRgu7hlU5vjoA==
X-Received: by 2002:a17:90b:2e4b:b0:33b:bf8d:6172 with SMTP id 98e67ed59e1d1-3403a305995mr3636072a91.34.1761753599453;
        Wed, 29 Oct 2025 08:59:59 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.08.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:59:59 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:39 +0800
Subject: [PATCH 13/19] mm, swap: remove workaround for unsynchronized swap
 map cache state
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-13-3d43f3b6ec32@tencent.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A8286100003
X-Stat-Signature: weafrzt3r6dcfsizaak7ibrqccz7q3u4
X-Rspam-User: 
X-HE-Tag: 1761753600-809357
X-HE-Meta: U2FsdGVkX19aL0hDk8QCC/kbJSl/z27vwNTEZ4lhGLzxNIUrJVFNgoWJjVpZEiZlxHhdL3dSBeG49KpgUrgy1RzcteMbsgSTTxeACk+w6HWO4pc6oimQRYWrg+ZYJeoqydrrueVlJY3il93yIBNCWaN7BPAYMjIRqeAsFCg6cGNnoQhY4VPKx0m5tAWRQEsm/d2H3If7FCOE2XnTZI9vV80T4RQETOAys11NmvbtL251JxWNZQymTKQZbt9zHAAkXWIEgTXyqB1+dUvxBAn/nCY1oCcZc49F+sgtMLJD7p0cxqDC7cu/9bjZJWODQ7ZzvIfKW4xDn6RfB+IdIlIuYg2iMf7GQPACiRCee/5NSTY18TzSwdw8Afg34TnaYy5o+ypCTBzATh4pBWA10ySz+E5QQhEFC1wHbbJa6PW2uvTGV4IPeNQVcU+b5CyCPwoL3noBP26XCM0E9mpkqzxXTnk53NjcR9GV/3ignKkLht0EFpPXIeL+w0GIuyyfAr2w1M9gw0v3WhU5ybMlcG+YE3/PMjUwLS/SIbedbfLEVfWa5bjy6nFkUV1F7oODXWfPUylnZ0oiYPo/n25YwN0PBBug05i6I0YO6GRAAnvBXR0bzuqnfiM3XFlDzSx2FCvcqzdqlaI+Rgs15us1ZtR7mEXYum7T4JM+ucxOTp/koQhOSvJz9SKYj6g9R3DSRt6mjnzjq9T8pMMddI7/RqI9uCYFF+hO7wa0c1CVLz/T+gZdvhEsX3iAaNZnPSQ5cRA1QGyLVIoh1tSUiOkT7BlXf+OUAISFjs+lbTb8OdribZnZGFTTXBdAvWHYeY+/nJl0fwszqHluo4ml4ATBT3hmkc+bQoVMk8+nMEcWW9WVyDsaTUyiHUadau5MEC40ojLTI3vHaAXoVel10x2W/TtXq5ErYnAwOpQFqKs1DFCZWAwagYsNCzDaFjFjnOF8WVxh2ajQTV/JB1arH0Ax21e
 r1Asr2YE
 y5sVIpPMUhRdwaWgiaPRjoD/4yS/ijbe57NGRKl2LkJS85CTGHw2JnkTqKMms6Wgo90LTiNzZj7Hi7bCZnDtZ4HDVUTcjgPweUYFqbqn06lLUsutK9IvTp1Yta9Ow+yq8X8I2BmtSZbeqFPj0PvfIN7e4FkrycsnmhyyVVqkvn5f1OuGCasTy5i7/BPS0N6MUvJZ+fKhhTf3WcJEB5ON9PWt4ASApg36g3SSiSZBBjcTT9DUoiJni+OnCi2ef1RDVMnM1jG/NCjXWvS9iapVQmvDeprDQvtEs69uJEDUVFipA0edwCCn7XsZohBddtDDM1llITTvmcht3H/E6jz9rIk0etRgXy3wzVzL6IF2EOsIeSk4AJRh6K9aMD5l5YGO0NLLRVyeSloUr5uVlFRKsH17P5+AhNhqZiPgypWtyjLyTEoI8RMtd3LxqNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Remove the "skip if exists" check from commit a65b0e7607ccb ("zswap:
make shrinking memcg-aware"). It was needed because there is a tiny time
window between setting the SWAP_HAS_CACHE bit and actually adding the
folio to the swap cache. If a user is trying to add the folio into the
swap cache but another user was interrupted after setting SWAP_HAS_CACHE
but hasn't added the folio to the swap cache yet, it might lead to a
deadlock.

We have moved the bit setting to the same critical section as adding the
folio, so this is no longer needed. Remove it and clean it up.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h       |  2 +-
 mm/swap_state.c | 27 ++++++++++-----------------
 mm/zswap.c      |  2 +-
 3 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 3cd99850bbaf..a3c5f2dca0d5 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -260,7 +260,7 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 void swap_cache_del_folio(struct folio *folio);
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
 				     struct mempolicy *mpol, pgoff_t ilx,
-				     bool *alloced, bool skip_if_exists);
+				     bool *alloced);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry, void *shadow);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 2d53e3b5e8e9..d2bcca92b6e0 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -447,8 +447,6 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
  * @folio: folio to be added.
  * @gfp: memory allocation flags for charge, can be 0 if @charged if true.
  * @charged: if the folio is already charged.
- * @skip_if_exists: if the slot is in a cached state, return NULL.
- *                  This is an old workaround that will be removed shortly.
  *
  * Update the swap_map and add folio as swap cache, typically before swapin.
  * All swap slots covered by the folio must have a non-zero swap count.
@@ -459,8 +457,7 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
  */
 static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 						  struct folio *folio,
-						  gfp_t gfp, bool charged,
-						  bool skip_if_exists)
+						  gfp_t gfp, bool charged)
 {
 	struct folio *swapcache = NULL;
 	void *shadow;
@@ -480,7 +477,7 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 		 * might return a folio that is irrelevant to the faulting
 		 * entry because @entry is aligned down. Just return NULL.
 		 */
-		if (ret != -EEXIST || skip_if_exists || folio_test_large(folio))
+		if (ret != -EEXIST || folio_test_large(folio))
 			goto failed;
 
 		swapcache = swap_cache_get_folio(entry);
@@ -513,8 +510,6 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
  * @mpol: NUMA memory allocation policy to be applied
  * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
  * @new_page_allocated: sets true if allocation happened, false otherwise
- * @skip_if_exists: if the slot is a partially cached state, return NULL.
- *                  This is a workaround that would be removed shortly.
  *
  * Allocate a folio in the swap cache for one swap slot, typically before
  * doing IO (swap in or swap out). The swap slot indicated by @entry must
@@ -526,8 +521,7 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
  */
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 				     struct mempolicy *mpol, pgoff_t ilx,
-				     bool *new_page_allocated,
-				     bool skip_if_exists)
+				     bool *new_page_allocated)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct folio *folio;
@@ -548,8 +542,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 	if (!folio)
 		return NULL;
 	/* Try add the new folio, returns existing folio or NULL on failure. */
-	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask,
-					      false, skip_if_exists);
+	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask, false);
 	if (result == folio)
 		*new_page_allocated = true;
 	else
@@ -578,7 +571,7 @@ struct folio *swapin_folio(swp_entry_t entry, struct folio *folio)
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	entry = swp_entry(swp_type(entry), round_down(offset, nr_pages));
-	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true, false);
+	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true);
 	if (swapcache == folio)
 		swap_read_folio(folio, NULL);
 	return swapcache;
@@ -606,7 +599,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
 	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	mpol_cond_put(mpol);
 
 	if (page_allocated)
@@ -725,7 +718,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 		/* Ok, do the async read-ahead now */
 		folio = swap_cache_alloc_folio(
 			swp_entry(swp_type(entry), offset), gfp_mask, mpol, ilx,
-			&page_allocated, false);
+			&page_allocated);
 		if (!folio)
 			continue;
 		if (page_allocated) {
@@ -743,7 +736,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 skip:
 	/* The page was likely read above, so no need for plugging here */
 	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
 	return folio;
@@ -838,7 +831,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		pte_unmap(pte);
 		pte = NULL;
 		folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-						&page_allocated, false);
+					       &page_allocated);
 		if (!folio)
 			continue;
 		if (page_allocated) {
@@ -858,7 +851,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 skip:
 	/* The folio was likely read above, so no need for plugging here */
 	folio = swap_cache_alloc_folio(targ_entry, gfp_mask, mpol, targ_ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
 	return folio;
diff --git a/mm/zswap.c b/mm/zswap.c
index a7a2443912f4..d8a33db9d3cc 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1015,7 +1015,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
-				       NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
+				       NO_INTERLEAVE_INDEX, &folio_was_allocated);
 	put_swap_device(si);
 	if (!folio)
 		return -ENOMEM;

-- 
2.51.1


