Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ADFDD2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C92436B00CA; Thu,  4 Dec 2025 14:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42E66B00CB; Thu,  4 Dec 2025 14:30:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31E96B00CC; Thu,  4 Dec 2025 14:30:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A0CF06B00CA
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:30:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7122E1A037E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:41 +0000 (UTC)
X-FDA: 84182780682.09.9960ED2
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 918D81C0013
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GjiOADTv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876639; a=rsa-sha256;
	cv=none;
	b=h4ANtGOzl3IsLaeTGz2uLfOVHnIERX9xwiVJUOOlYnOmPsXQghb8whzDL2yZ8lkc5FUFGW
	/qYGbfnX9Q9cX0E9wHEs7PquvIUt0iq5hf0piSKZcKxr7CHoeUnK0MUqW5MU2+BwgovTTx
	1zUcp3Scr8FOUYCTUwGeQDv4WB75pH0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GjiOADTv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iynThVMRdzdMBrnu7L3dH8nlr9uonc5S69ZtO1nbUe4=;
	b=RAUJXYgx5ctcNMmkZRtmMFSMw0Jvo2zgGzPh4VlYbOwuRlcCF3BV37k1WjlZMFDAaIGqKT
	idEIpoIAYO1TFl+PPcNwYQ44NGnErVjAbD14aRicQ3pMxBNEzIbG6FWMnArRL3A5RR2UHP
	FMQgx0iDaJJNj4tk6PHVzc5V92A53ng=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29ba9249e9dso18058745ad.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876638; x=1765481438; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iynThVMRdzdMBrnu7L3dH8nlr9uonc5S69ZtO1nbUe4=;
        b=GjiOADTv+1iYiIv3p0+StEr/wPyCkelHfnAWt3ZfnfbowqBxyjwDaMYkU2BvETWm1N
         lfLm78t9PL3ki4E0NCt380bIKt3GLF5D7oHzcDEo2lXoqjDzXi7GUvn1WW7fRuEhbpbG
         HoY55oGs/202Ue8LyUaDxrLlpH9iG0uRIs5JRJXXu5m+BxzlB6lm+gzouH8gNiBcwcy6
         MmanQyXI/OMg/MiK3dJezZTQu9N+Ir83YKvpUUijrau/Omp8V78lXTPEifK5tFCT39HV
         GzGV4/8Qkb7rV52ADvc3oxcX+VKiqQK1mwHer6PgVRrkttpmh4a8+37gHX2jYLwmQGfs
         kjdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876638; x=1765481438;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iynThVMRdzdMBrnu7L3dH8nlr9uonc5S69ZtO1nbUe4=;
        b=kJPjmW5aMdTbxNuQb/LqphUaRhmEOVlmFkCwwEns3jgwiVqeJgKt3SXfaxJQ8ozr4w
         /eTo6BSoQef7J52ykc465db1ZJPLnErEnyH+XwCrwFM23iM5l/DW7wTt1JEV8HT9r/ia
         6XAOQZuVKqq7BH4W8ONcssIDSNYpvkZjJNGr9RHv1W9hlaG4JApmJ1yEoLKguttgJy0m
         0qUd0LYXEhajB15M5saYudf2evPFwZNsogTE/NjCZmDdbFzwCLioocAjcmg/thjTuCtJ
         fPtf/v0upbiPXVINonMTtPgBEgEyPViVfVFF3MB255UvNAmr0Mm14iJSLsEDHZTaU+NO
         gsCA==
X-Gm-Message-State: AOJu0YwHfRfNuPVbL5joLPrGTvHZPMROE0JtPwubvo4UNPjHYC4aNZCG
	tS/3YNQRfbGFvMHU9xh62nrnYIGPMNDK2PHFlZDLVk99U4Xex/1SI/cx
X-Gm-Gg: ASbGncut9IeZplRqf0WV9FNisVU+4YdQJH7vf0o36fhZ2X3vgtPV1j0foNyv8mu72eM
	3Bz4RwxRNsUykXSkXiNdsLntnHFX4g8Xo4AGQHn0hVEUVNMkJ0Ywsv3UyGuUTk1Ip/9dj0dpmoi
	8jfvesJbcYIYlM+O0Us60LDi9YLApHgOcbPCoCT4xy/E+tDvcNwV9DKhDCorP43/vBKpz3b4m3c
	/JvEezLj21bFpdaBOoh5s/0fj8B2KbxX+0ZCkl99qG4iayV18LDLg8t3coJzPBhJXfXJMXLpXX1
	R2wRVn2l1HLnvYuD2tzlP/kMTAcH2F09FRJvxvcLwdBO1OhlNUNUQ3ikJV9GXL7MQgj2qF2t2K/
	gHVAcYb9S0MNFi3RqO2lxMvgjOdhSAVFEr6gjYUVVTJNdj+cvKMZ1xUP33SXALtibCREjiCwKqp
	Z1yFPm4/Irg8e5xfNuwArcWFEXNjEdm+SZhAnwXb2iXZEp1hM3
X-Google-Smtp-Source: AGHT+IHkAo95IOwWZh4V1qJmP0GJYz+gC5Ov7f6z3VfqkVSM2RXpu273c86T89bxenPC+IcvjibDoQ==
X-Received: by 2002:a17:902:c406:b0:298:49db:a9c5 with SMTP id d9443c01a7336-29d68430f25mr77084565ad.43.1764876638354;
        Thu, 04 Dec 2025 11:30:38 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:30:37 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:21 +0800
Subject: [PATCH v4 13/19] mm, swap: remove workaround for unsynchronized
 swap map cache state
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-13-cb7e28a26a40@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=7032;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=SYqPgb2o84SebrcaWLsBII5bIr04ISZ9VA6R4j7AeY4=;
 b=18DhOG0mhl1tF3AnvCIQZl0WLi8NH5XB5nif23XJSLd0gnQqWZPk0OeZ6+x8LGsfRGVAEvDSJ
 DNd9sb4BWPRDbRzc+Ht9ROQgN9O3yghC06z0xSLZZoJlEwY1lsiqO7R
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 918D81C0013
X-Stat-Signature: e7pgnu7n9wptd31igsqraamzk373xsrz
X-Rspam-User: 
X-HE-Tag: 1764876639-555422
X-HE-Meta: U2FsdGVkX1/xa88eEIS+Yn7otcB9Gbd6oEfIzbz9bUBjTupqR8FeW25vlMrZzZUewvOgq6F9ld7eLVFioA3jKBrIG4zg6Ab9xB7pikrcgXc2rZZS1GC9AWosqkFVAWAwBj3z1JhPvA2y9qpQ+YIOvB40egiroEmvqH2Dc8zFHLUr31FOkfbhyyjKCgEFEF1jRi+nEUwNPe1u15L4NOmcgmoC3nmkVr3X+tAnrj+oyWkxpWNWtfAJ8Im24jpJRyej98lSMoDUVgdxYmYpeNORVZNZPDTKrf202xf2cWNAD0JQwek3W4lIgB5TBgMxPUsfh+SOcEzRVY43jC66LJ9zU7SviQ4Nik6Rw2+Lz8RUxrXxy3h+mZM8p9E74/RH3GaIa0+7yJNQJj8/5o6hzR7/2N5faHy1zAsw8qVOTocOLq4YQEO8cvrzvGJ9OSveROpZQkwnYiU0q2QjX/BsovhUkXPxzLZ7in+amWHy7xkxOGII8jqd3gCZCumvMltnnHeCdT8dEfdYFQGJcemPQz9LsoM1we7+Yqfwe/y9PV/mYc8IhWx+39tcqlEf7nbUNK/xXPiJ37UeHBEGA8H/35Lok4Gzt8EgnroMMz53A0porrLphKUQ7SB08Wi6Rrw/xWrZ0pUYjsVu4WCiR2duLwHtZE7yc1x/6tsThF2nOkwbzsjdHYOxp2EBJ0jkDGoivpXagwPSi73cmB2CfFaBmqmud1ZgIzwk30+e5d4XbIHamNnLLv3jZaeGhhCdjOkcEOtoyatcPavSnO/5HmyvpzUV4V6xmLePEymUCJKEJ9XEkNhBnNCCGHoEnTi4zz+/i5O+YBVhT0E3IQzvX6/bTApfWn5iRXK6puCQixYK/9gSreJRaSRIDB1IMVdRr9M6+MuveetS19W1zh7ShLfPXr1EOfa6L/M+VMPWNZAKmq67y4tt6ECnN+PrJviq2O5CEDyEy07sB9DAH9L2T9SzKF3
 eT82GxEm
 PuTXQddxcWkclPh+WARL5Vd25BQ==
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
index df7df8b75e52..1a69ba3be87f 100644
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


