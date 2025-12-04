Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0F51D2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081BE6B0092; Thu,  4 Dec 2025 14:29:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032276B00B4; Thu,  4 Dec 2025 14:29:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8B136B00B3; Thu,  4 Dec 2025 14:29:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9FE96B0006
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:29:47 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB81612B5B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:29:47 +0000 (UTC)
X-FDA: 84182778414.12.1A20514
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id A20F6160016
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:29:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="UN1/XGgs";
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jq81d1H6YKMjZl5Zgb0MmVZ5YbUN3ZOXLRAy2GMP/7c=;
	b=ecpuyQ9FRwC1PhweejeS+dBW23+IfPAfIDJFG3qSyiRv+PCF8a6U1cYf0KPfyqlK9QWIbC
	hzGxazalOWC/yEwNKkzGbSDe3qoeHIXdqErd531UIneur2cO25Yyf88Kof22gvnwgTwTKT
	E1l62GK3JTs3kgNfISLS3FZby5qFqG0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="UN1/XGgs";
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876585; a=rsa-sha256;
	cv=none;
	b=oW8l783/s+2KCdNXCpPcg5Kue0gZ35DJg7tSBYFuU2VAuEUAu6FNGleR3NvqSXhM09mMw/
	lCk/OZ7OzEHB5FR7VHuQiceQQDRI+5o2FcBKVoQzv856sQ7HIE1UZvVDPcaf9alj97hAG2
	HOgWEAM44LTNMf5QXGO7cNpKf7iAyko=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7b86e0d9615so2246181b3a.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876584; x=1765481384; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jq81d1H6YKMjZl5Zgb0MmVZ5YbUN3ZOXLRAy2GMP/7c=;
        b=UN1/XGgsimmwke/7IGZ89n1Co72ahtFrQTb89TU3tYmX4eeXqeswamT7xfuOUEIeVy
         VGxmrYLCBLKuar9ei6D3+gmg6anJqrjvMex51Yvt9G9/E8HNTEhFGmQSXcOuan21b0rL
         OF3G1yUfFHKiilb/3+E+FNulZcQONyKYGUCyUtQRf7OEwPqWRBOhCgLHjvTTWDw8Fw6T
         aMz2qhSvKbawcmNVryy3UoUd6w1vyLwP3ql+bFA/u7qoQRZnxGHBwogCGPLTJh+yYC4v
         wduX6CMa6uYlHE9pxLyMLytdvY7FnEKIMZmxQdzmGol8zPMN3JtpF1Skk769R4ppJ4Dg
         ajhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876584; x=1765481384;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Jq81d1H6YKMjZl5Zgb0MmVZ5YbUN3ZOXLRAy2GMP/7c=;
        b=Clnn1f2JUe7ELEbioCjBYsTFqOJTbz49f08TkyIWQke2fozgn0TJZFKNxX/J5s2NR/
         AbMK3ntjLsiH+bV0dG7NMy2m8gvQGnQcuNgJHIPltDDQBwpgLdPGq25sxUe52qzbHmU4
         rlaqsqCxoN50+asa9GSzJp6T8QGt649GcWcivVg/IdwWXVVdRVFeZG6fqC/NVnInAnLN
         v2HFhnFP29TFC3Rleagcy+kGC8W1bSi7pomJnIjGAmGhfj2wS1J1+w2eLKVSja+KKwLt
         mrI4ZeCGjdr5oqYAgfrqF2VcagrupCy8vLdqT3bVdlEvynnVm81NzcMAD6hCHqQ3hnVx
         9muQ==
X-Gm-Message-State: AOJu0Yx0kasbs8ajM/VVvpEnTub/gr4oFBbW33p8idxE2GpUcp/Hq7om
	w3W+qH+2q2CMWTovU9MkfOapjz0BvKhKSsmQmgh+Qq90dr14P4rQD81F
X-Gm-Gg: ASbGncvK3ZDxh+Xx1u9ym+xJmrKB5T7/uPXVPYl7n2kPCj4cjKHB+uItDDNlIG+9tQ2
	3Hb3Oh3uE5FAJ5096ckiLVnsf5NcVZGulAWFC0/67msVAfdbv9Jjw+z0Sa6aTOpMU6ykm8eXliB
	rSFk/BAVgr8XOAhyhDLXhbbFUH1SaohMZvMJfGVicRq+vdxhk+5rn6UQX9C9acgbd4ZLiaFo52a
	wabV9bEBWTWMSOi9aeuNUWUF8ZKq+a3vWqgV1QqtSpL+1fRSsxDoZW1Dx6FqQxOVT2GL1n5UVpz
	1dZ9Ugb8lgLFB5xF3buGpnQwdiGbmCuZ2FxJq+XLhuT4Z4JzXQoyeUYVs1IFosU9A2uG4YIzqbt
	BBK8+bIgm55NLzJ1WuQ5FsgbT7s8sIAllYKJXNu60aO5/u+HcySyQTjqMIDMZkV6uDENLsO1E+G
	atHMpSUm9E28fUCfUaaKglkvQtiOTQQmn67mfsv+Vy3e66PUEGYjKIJKQUn/4=
X-Google-Smtp-Source: AGHT+IEzzWPUKgseDNtI+TAN3a+rf5FvnoqWhzpl1W0PHwGSKZNXSLgSNaIQHWAI4QWskmWptXHJCA==
X-Received: by 2002:a05:6a20:432c:b0:35e:11ff:45b4 with SMTP id adf61e73a8af0-363f5d6270dmr9088976637.21.1764876584356;
        Thu, 04 Dec 2025 11:29:44 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:29:43 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:09 +0800
Subject: [PATCH v4 01/19] mm, swap: rename __read_swap_cache_async to
 swap_cache_alloc_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-1-cb7e28a26a40@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=8299;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=+SR4a+Clox1gWWGvvj3O7fTgvXCBBPQIHCvWevNHVBU=;
 b=7JYvSNEeNJ2Sq4jdk+Kb2EUltwQCI7SO3G+uIZq1IG69COWybMWPF5xD+Sx+Vf7olTKI3QW2/
 YBbUjHxa+L7AzodOdqoqg8Tes9iGKobj1YeCTfV2phjKOpFq+3pE8bC
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A20F6160016
X-Stat-Signature: trpnyw4atjkt16di6kttmqstadks4xhd
X-Rspam-User: 
X-HE-Tag: 1764876585-489756
X-HE-Meta: U2FsdGVkX1+qHHQTLLPEMgpPeAe9tmVtUBRcJ5P7yls/ZXPESuwlqvliX0va0Zf+FWB7FvqYERG27PYpt/rAtSZxUyjOznlSWRcjnqhchCkwIbMCJsnNOytE/+nSew6QhXS3LntBPX+1/yFzzhtIWOsvz2wCIGJH3ZlC6MTTrrmxmK/HIS21Esgp/PCqtnVdt3HgE1DdBShgWK3LIzJ2LsJAdncDE3cM6mLRjZw280xMqWxSkJ4gVWXtlDpKWY6fzV9nAUGHGj8YHsHZ3ilixXlR8nCd8inMJ9dRwmk22AwtK3k39EEPyzULhxkCS0rtfVZuKnTHpllc6NCmktMHE2WNQySXpmlPWKuEShK16tCb/AT/K9Be8nw05zLJa6dYR/uAaqD0XVe98tA6FBwe4tQuawXkaE1VUTUe1cKmrI1un05uAlwkPU0n5fwx4zSpVa4gX3iDj4mqOVtjpfi4wM4214AwnCOdzkECwKEo2Tr/78CpSFYGXR02Hr3YdXEeIcvI9LwIiDRkXSPGyH4DsPJKVelXyAtTby3IOevyqCNYisxPsnPkCXpLTXm3BqjcC6tdzLme57d3IyBQLFQ+Ad+8uVUjAC6b4bAquxWyAcDc7BjnHEyiFZl0jtoTm7Dif3xf1LhGEyugKFbcCgqZIsCbJCNIM8oXQWJKofBs2OeRPCedxmySAgsum/0RR1AuNyzWmQxVakIkvw8c/YC1VeRFZnZ0U96r18oMS7XHIW6RzZkDaSp5RkQrPE5S9rmLllqKbBIlOpZuOHgvpJYU0Isjn0M3T48M7GVSxa6dML5BiW/JIv4tt0oIO4FpEKGOiM4EMZ8rjtU8bi4O+ddbMGmTvIJRKeAjTM3AeGA54xF+Ybq1sTXjP4zdSobCv4GZP1Xb7e00YNliNOYqnLu8pI4pEr2tYSg04GLSS+AwBDCdulTosmJh8njYWP0i2yMXDuOGSAlSQFT/LVGI5jd
 73mjsYR0
 nDTbRuR7VqE4qSJ8imGH3RDVL0sunIwAY4x4Et0nIBk84LcEWm5YTD5AqUc6ZBmYYcdy5M+lxCPBVLYtWpuHlvhNUbWrPGPN46CD9KXaZ2io0IbIFCRm5mPGjPI2Gx2VjBv0unhbh3G7fwHmPS91mk/K0kAk/2/Mpj0SYFEhSus1qbYKRkWIV2AMcggNf3wp34MRRnEvycT0qX2NKSHww8WaKw3cPWInnONIs7eTa3XfQqr9eycKWlidAJ43U1GDiQHpYefNJp5IK9tYRsaRrkKczAbYRfN5C+KtRGtlwpg+D8VX+N6O1IIyWuR9XL+y5AytAQG/WTICc1naUAi63B6fEqixI4sapU7w4f93P0sw5gK9rmkpBZlXfaqBIajR2Gfqo/rI3kVEkmqjAf4WRT8If/1fXWNZaCI75zmd6Ir8ngTsZZMDtGQeQlIFapWB1o6q54VsgaYhJmlEX9tg5B3CDnWJzbTKm932dnK4GYuiykM6+BhXo2udDNJafh+/mM3A7mUBN8VWi0LE=
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

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h       |  6 +++---
 mm/swap_state.c | 46 +++++++++++++++++++++++++++++++++-------------
 mm/swapfile.c   |  2 +-
 mm/zswap.c      |  4 ++--
 4 files changed, 39 insertions(+), 19 deletions(-)

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
index 5f97c6ae70a2..08252eaef32f 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -402,9 +402,29 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
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
+ * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
+ * @entry must have a non-zero swap count (swapped out).
+ * Currently only supports order 0.
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
@@ -452,12 +472,12 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
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
@@ -466,7 +486,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		 * We might race against __swap_cache_del_folio(), and
 		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
 		 * has not yet been cleared.  Or race against another
-		 * __read_swap_cache_async(), which has set SWAP_HAS_CACHE
+		 * swap_cache_alloc_folio(), which has set SWAP_HAS_CACHE
 		 * in swap_map, but not yet added its folio to swap cache.
 		 */
 		schedule_timeout_uninterruptible(1);
@@ -525,7 +545,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		return NULL;
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
-	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
+	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
 					&page_allocated, false);
 	mpol_cond_put(mpol);
 
@@ -643,9 +663,9 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
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
@@ -662,7 +682,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 skip:
 	/* The page was likely read above, so no need for plugging here */
-	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
+	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
 					&page_allocated, false);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
@@ -767,7 +787,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 			if (!si)
 				continue;
 		}
-		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
+		folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
 						&page_allocated, false);
 		if (si)
 			put_swap_device(si);
@@ -789,7 +809,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	lru_add_drain();
 skip:
 	/* The folio was likely read above, so no need for plugging here */
-	folio = __read_swap_cache_async(targ_entry, gfp_mask, mpol, targ_ilx,
+	folio = swap_cache_alloc_folio(targ_entry, gfp_mask, mpol, targ_ilx,
 					&page_allocated, false);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 46d2008e4b99..e5284067a442 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1574,7 +1574,7 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
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
2.52.0


