Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA7CD7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6026B00A7; Fri, 19 Dec 2025 14:45:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0346B00A9; Fri, 19 Dec 2025 14:45:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D1CC6B00AA; Fri, 19 Dec 2025 14:45:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3BA356B00A7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:45:22 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 085ACC06DC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:22 +0000 (UTC)
X-FDA: 84237249684.05.AF7ED27
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id DEF76180008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OSnLlt0t;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PF5XJt/nU8iAJ4BQE3QnHtVFZgGKv4P0kbw6cXKmw6U=;
	b=YNkNGU0309uDkJj/dLoVZp4pk897J/F6Xk0+mfoUR1ArFfJKA1FFDzhcVznQwGC0ajjZk6
	asNqv8LHIHoG65d/Sh6S/8KkY11fM80qWUFPqn0ajlSK20CMeK8quTgobVtJpxho7k99ba
	IGOp4qL9FYXZ5uxQfea/GLx05/DM8B4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OSnLlt0t;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173519; a=rsa-sha256;
	cv=none;
	b=eFtlfzydT/7SO52b3nK0ah1Ur7tikzU5P0Pk+qQ/rdisnzOJzEgh8GMEg6a9m689rsoffC
	KjXQA3DfGK5fVLpXz829CNjhybaAj94HQwk/At8kJeVHmbcN/37uT9PZqIQfFJYg1bchYd
	Wm1r9SzWnvtloOKevum+JRiJNPKWkTs=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a0d5c365ceso25527665ad.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173519; x=1766778319; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PF5XJt/nU8iAJ4BQE3QnHtVFZgGKv4P0kbw6cXKmw6U=;
        b=OSnLlt0t6DOuGf+/MNWcb9ZDhaK12b8OQv7z9dVmSUmre24IDvLHg9BuvsK+9iV00d
         lUiFhia3FIIxUIpb497CTXswH0yzyhzC4AZm7yYUDd7AggdwzOAHod6rsDWNm+AMQWjn
         JMI7XIzgTyyuDE0/S4FKocsWWGFbj0qHW5PY33oHEr0RAonkbjy9KdvHuvcwCatKUsNu
         96XtZD5Xvtpubf8Rfn1yuQUC3Y+8aFMK45n+RiSJzJnqC0W9nFIIwp6DxcOZ5G8U4pma
         S3qyZGOw22L3MhUXr5K63qLw/tvnUCeE6zpdeyMF6bWofsCghtaQPbyqbAetp1mal2Kb
         VCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173519; x=1766778319;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PF5XJt/nU8iAJ4BQE3QnHtVFZgGKv4P0kbw6cXKmw6U=;
        b=Hm/eOM9VP5xV2VkUFbrZPumm1dRPGxyJyPn8GcMj+3c3zD87ju91ZCZfUV+vuPmgf8
         384Uc28jtZ8jhCX9wcFQyHR79/x08xPJ9xbPyO/HiNVs5ksXKi1u57B0/2LzWQbNA/a2
         upx+NLlk/s1Di8CRxuG3+o7Z1cjh9Vq5shL4to3fhb6TxNaEjKTp4OUOl8TSKEDYrrl0
         iDvxbgkYa8PKeehlgRhnscD3JYAiNmp+gAmsxwEhJYwl5aABvyBxkSqothsaD7XOTirc
         KkgE+RqlAhdFrFVtLO9nAXZpqjo2YWze9FrliisQ7dLWwYVedqPox6NVp7EFmOgSsdDG
         4R/Q==
X-Gm-Message-State: AOJu0YxKBIf6Gw8BZT4HaVERz9yrNE/vlZRF+BkgTNAEarM1jr5C8qdR
	EjJNdJx0KJP+bRJPLhsWAGjmH/xrDT4Fbw5gArWROci80VnfM6aSIbpT
X-Gm-Gg: AY/fxX7UsTWAKKqMOCGQWW7NyJdCD2k23OHVBzr9UAsfrly0QEiJRRM6MoJSdLNVaQM
	z79/NoqTHiqM//51up3snlmpMJ9lGRTVm5kVCnnmJn3IMDaJJr6DMZt+iiLx2KO2wG1IZKrZEKP
	TdeMNL5qINF2IRdHFwHOpvKaC4Oejp6snERV1Az52bW1JVwkViWEYcjsP/l4kAEo8nIoqFEgbfx
	Dp+GDsSQvObdeuVP2lNCg9O8APbQHrGt2DpmOs5bgXmi/Uc87ANKktJiYGPkOX8MwojvH88MLTE
	SsYKdvJc07gRi93DEnZ5bxN0jx9afezMDJZStn9Q6xosVOoBU2a/ZTxgkOEk/HYI34f9U4Doj0k
	yCUQj1X56KNE48aYHkufA/q9EnVQquQ54lLyz12kDeUsNSi2RDbRAor1zkFJ4lc3Qs90ccKKu1t
	H//7Ik/B9IQ/t0Rz5VKhtY/dT6VbiTnhwfFU853EZP2ATD8YZmzunQk5xVJcS3sM8=
X-Google-Smtp-Source: AGHT+IHyFiCjGWjxbpnTxEAvuhX6HZnuwDWgftPyPKoGfJjyR1MJhk4bDdtEm2j5zF1rCoIDXvQ7mw==
X-Received: by 2002:a17:902:d2c6:b0:2a0:7f60:9786 with SMTP id d9443c01a7336-2a2f2329b92mr40659905ad.26.1766173518719;
        Fri, 19 Dec 2025 11:45:18 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:45:18 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:42 +0800
Subject: [PATCH v5 13/19] mm, swap: remove workaround for unsynchronized
 swap map cache state
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-13-8862a265a033@tencent.com>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
In-Reply-To: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=7074;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=zTalgfGlV7+CJTkvCj0IVamySdLUBiF/z2UipqwcRfk=;
 b=SeMVJF7sbJAO3fb9Jk+YBdlBabmvuiOr1aVwmX8ZYy4VLPGEyuv7eHO57a/r3rfIFJgG2MQz6
 qzF9xBlxPyDD0vDbkOZ6BriDHDsAu6vyQ1iphWqr+F308vMHQmjhQNo
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam02
X-Stat-Signature: 43xzp9g77zp5pp5oma81yiroietw3gm1
X-Rspam-User: 
X-Rspamd-Queue-Id: DEF76180008
X-HE-Tag: 1766173519-263066
X-HE-Meta: U2FsdGVkX1+un8nggLhyeQWb5yxVtf0dGhS5MUYEhluEhLq4KvRpkEa/VESSyJZceUAsuHJHoxjXVCVlQe7WY3HtIqKatrY3kEr49ZDEicrBksVyTF2xugaewGurRUWxKVYyo9ne9OodKs4m9tbygpoZpJCbfi72JUzbgqvCLdU+4DGZI5o9IsOZxUVRirG3TgZORKnDPGUiH/zWNBv4Cdm/d6VV7YsXOs4G4gChaFzYKBLurCEiwG5dm0fthyf9g64GRRS/yZ1tbiCbXsmJ6p/u4uPM5My50bxyfjf3y0z+40ejMhUDFp+ftZDEUDeUms8xfvbnlid1kGQymaoBcN+sW23lkZPeccTcW1uACjg8PlGZPQVUveJiorihMsRvbUxW3Qnef7i1w3yeWcg/R+jur5W0eL90FV5bM11DBHfuaa6xlH8dOJUd7kmZ9EZ0fqnEZwpshMw9vRkC68k6a3z4uDAtHeR8QQn4mspUWrjzwnDuLa0gNY2f5HfxuwuoBxbYwZ8NrMbUvAe8yiJq1e1kUBpD7xpIBZyBsOpR/KjuAL8yIYOtX4crUMmpKpOBMfQ/wG0I5LboYloBa+WK8ak2IUlr0Q2Xdv+Mc7jfUKB/OvnCpxGnuSjyKFN1DcJl5GHvkFYClW/AplOP9DnyYsuQP+bMhf1eNqdCZju7RJwxGUBWrWmvlgZyf+LN5nH6hk3GEp8nXwX0CAiVXWh1aYmo4Rp4rI3hwqgJ9SD2OgDahj7Xmnd1WeIU8k056riYxdkzh1SzhLCzDVCFfuFp9wzIR+Z/u0D8/uxuHV3UqVp6p7WQTYIufhR7C+MlK0oPY2BSkEixYUqknnGAwojQQY9IE1A4aQ975/UmRj5ehyi456OnNz3gS5SWGWc4h9PWxTSIzDjX2JBHo7UGX9YHzzncHS6fh8DluuGUs553ISROhbp4m+pGMh80zdkx5C2Gd4IuD+oPxQdSgZOU0P3
 1axLDp5T
 lZ7O/G4lLBQl4uQb9mWgOIn2PPjZfVbVPyvL9v/ccI63cv0Kl6awJete1BYWr1iBV+abuWSU3uSMHvW5POcj2LRHIBOa2wb0XrfB/+oy6mhEqsN1wGnWu5lmBNQVLIMw3e1ZXJQinsEw/B0Np2MUn7hTRN0VHTOLHt06PhKdXRQ9P7m3ATBVkTy3RErZw0r7qjnXCcOTBxuzk0HyPaWXH6l6IkF9LVkIZt2kfLgmQdJNXgmVGBZJfjE8rM4jW2NLbDfBhH+plbq+8vXZvUETiIY9/vu97+QNE2aj1wMHapFHiEtjvtt+uar9x4umg7KibjktboKmITHbTraAM0IepXq/BblsUP5LlIHZ3n3qdV+uT8N71P/gvxpH08AkRskEDqQ3tLjS5cdqVtjW55dZl4FqlwKHiQpm0arwAeXffeI46ilfHIQcRlsd4594EOMwGunpFnFYaxno++Gs=
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

Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h       |  2 +-
 mm/swap_state.c | 27 ++++++++++-----------------
 mm/zswap.c      |  2 +-
 3 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index b5075a1aee04..6777b2ab9d92 100644
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
index 57311e63efa5..327c051d7cd0 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -445,8 +445,6 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
  * @folio: folio to be added.
  * @gfp: memory allocation flags for charge, can be 0 if @charged if true.
  * @charged: if the folio is already charged.
- * @skip_if_exists: if the slot is in a cached state, return NULL.
- *                  This is an old workaround that will be removed shortly.
  *
  * Update the swap_map and add folio as swap cache, typically before swapin.
  * All swap slots covered by the folio must have a non-zero swap count.
@@ -457,8 +455,7 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
  */
 static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 						  struct folio *folio,
-						  gfp_t gfp, bool charged,
-						  bool skip_if_exists)
+						  gfp_t gfp, bool charged)
 {
 	struct folio *swapcache = NULL;
 	void *shadow;
@@ -478,7 +475,7 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 		 * might return a folio that is irrelevant to the faulting
 		 * entry because @entry is aligned down. Just return NULL.
 		 */
-		if (ret != -EEXIST || skip_if_exists || folio_test_large(folio))
+		if (ret != -EEXIST || folio_test_large(folio))
 			goto failed;
 
 		swapcache = swap_cache_get_folio(entry);
@@ -511,8 +508,6 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
  * @mpol: NUMA memory allocation policy to be applied
  * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
  * @new_page_allocated: sets true if allocation happened, false otherwise
- * @skip_if_exists: if the slot is a partially cached state, return NULL.
- *                  This is a workaround that would be removed shortly.
  *
  * Allocate a folio in the swap cache for one swap slot, typically before
  * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
@@ -525,8 +520,7 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
  */
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 				     struct mempolicy *mpol, pgoff_t ilx,
-				     bool *new_page_allocated,
-				     bool skip_if_exists)
+				     bool *new_page_allocated)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct folio *folio;
@@ -547,8 +541,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 	if (!folio)
 		return NULL;
 	/* Try add the new folio, returns existing folio or NULL on failure. */
-	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask,
-					      false, skip_if_exists);
+	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask, false);
 	if (result == folio)
 		*new_page_allocated = true;
 	else
@@ -577,7 +570,7 @@ struct folio *swapin_folio(swp_entry_t entry, struct folio *folio)
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	entry = swp_entry(swp_type(entry), round_down(offset, nr_pages));
-	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true, false);
+	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true);
 	if (swapcache == folio)
 		swap_read_folio(folio, NULL);
 	return swapcache;
@@ -605,7 +598,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
 	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	mpol_cond_put(mpol);
 
 	if (page_allocated)
@@ -724,7 +717,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 		/* Ok, do the async read-ahead now */
 		folio = swap_cache_alloc_folio(
 			swp_entry(swp_type(entry), offset), gfp_mask, mpol, ilx,
-			&page_allocated, false);
+			&page_allocated);
 		if (!folio)
 			continue;
 		if (page_allocated) {
@@ -742,7 +735,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 skip:
 	/* The page was likely read above, so no need for plugging here */
 	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
 	return folio;
@@ -847,7 +840,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 				continue;
 		}
 		folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-						&page_allocated, false);
+					       &page_allocated);
 		if (si)
 			put_swap_device(si);
 		if (!folio)
@@ -869,7 +862,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
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
2.52.0


