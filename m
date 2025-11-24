Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 286F9CFD351
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847D76B0011; Mon, 24 Nov 2025 14:15:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81F726B0029; Mon, 24 Nov 2025 14:15:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70DBC6B002A; Mon, 24 Nov 2025 14:15:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B23A6B0011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:15:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB957BA102
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:15:44 +0000 (UTC)
X-FDA: 84146455008.04.73F6665
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id C2C6B18000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:15:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bpRgXspC;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9jkj+STmE/k14nh35f8Limla3vrnfgi3c5F8LmHokA=;
	b=RIkKN0c0ctYRhCBNGHmHJGOy4ctdNhSkOe//gQ2nz7QaA1Kt+TcxBqc/+b7GkKUKHqsOU0
	5WbBBxtDOl69Yg1OeR8NFK27SgpuywK7SOCwlXGTpLPX+d9Wu1Rfmytzgy66drrJlOw7d+
	QJoL8egqz5SCfRpFy9D6ppt/TtrgSuQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011742; a=rsa-sha256;
	cv=none;
	b=1X9CR2XXyledDPZlVUp1CVUkgrTHK/5NdBJ7tgOmIGr4UjeV3rDJQU0MrwTGUmKAwRgo9m
	UD+dBvkdniGOQkNVr80mBM092j7T28vvsyBa47elXSFA6zNFR/wu/bfhaYB9ta83saZrWk
	DuXNN06IBo2+31/b/EwBnf76TnU+Eos=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bpRgXspC;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3437ea05540so4017170a91.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011741; x=1764616541; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u9jkj+STmE/k14nh35f8Limla3vrnfgi3c5F8LmHokA=;
        b=bpRgXspC2Ih/RdXwUokchQKEApFBHgwYGlTpYog07OFk9fsU8LEVdyllwFIhm543ZE
         3A6Kh15Oxi1MyoiEFF1p7BDh8Utf13SwP+/Fnwii5cKglTQSvUKX2YfmQ8xiw1X89B8p
         ArKXAkH69UfGg+MTUBL9IcSZiJ0776Cn7SVqLResJXKhwZ8L1hC4G5uShmazCLafc1Kz
         CQ9KYSou6WGWot4PXJBYhZhrSnu5H+Qz+Pg2foIkqwq/UlzGMWgwTHvPDUk+SVjWTO6k
         CTsulVDxvOX9yy4dja7yhzqcbHQtfBlk1/N6HaVuO4yPXi2xLNAOizC+eCRB/P2GQN8A
         KxgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011741; x=1764616541;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u9jkj+STmE/k14nh35f8Limla3vrnfgi3c5F8LmHokA=;
        b=qrCQ3vXux9ZQjgPc6e8Xywv1CvOI74H8Sy2I2UQH+dXlqeVDwu1i+RA6pDQB8qBkyc
         ii4MKrNl6I8yIgkvg7w7WiIaqzY1z84dvpRMNAAaPTjsAxesU5cB/rXt1SDYX/r7m37H
         SdRBNIkzS9hd0A7B/NkcwwGB+TlYymC/wOo4dD8r4PQ+enEZSqEAgDCq8lrHyuROa5yf
         L7KN8wtHVWKtDyTtfUF5g057LbbliiwstQKBERoam6B7UXHaiPLewtL/1c1WkHQp09+E
         jt5Uy13N9SQwvudyQXs0iZScSU50fIzvBnBGVGd8QEDPaYZgqS6e89AfeLtOZsfLN5iL
         0+jQ==
X-Gm-Message-State: AOJu0YwSvmuAiFv1UTqRlqLVGkwRf8TZVw6GxfgrzNc6ugJFc6ReHgsO
	g+yKcwQDzRdVtA7vh6QVZmIIpiWFi7ZIso7EmhTLUstpkb7qJ4OhU7Ud
X-Gm-Gg: ASbGncv6KAolv2EVfc3hZYkv6JGDdU8vDb0foBwX9cSyGsoEc54rfY86lo4xvDCB6Zq
	mx4PFsNkd64BeIiOGvsA3J/gPsu8svRe4MtMyoUQghXfmhD9Prj+F14R8d2nU8We8rwYg2HvJAK
	XyNQF+j6V3acjHuI8mX0fTTgb/JccgAh5nd08vYjtxMlojGepEiAGF42H9v2Vfd5GxJ/tIc13Vl
	8VzNqxOT/ovTFRMxbH3Z/wJpxijz8dnrnrvG/LseJqFFsaH47vfEjA3nddfdQYVwoib0NwNqpBi
	IrLhAoUah/94xpKQMPal0t2Pq7C4NV+3Dvr/vRuwdXnj5odZRjG79xnUgkMfV1lP2AtsaoNS1Ps
	9sOE2F++h1bsOIOfKvs8Np/6bOscXrPblXgIPP0hLzqmJ86DqccKpVPbEHJcEs72d2UHvxdlU52
	hwOs1xk30RNZQmoj8418tubpPBQCrh1cXk/13hHQiXUwyxTR4ecM72Krlprhs=
X-Google-Smtp-Source: AGHT+IGGUc01kDS8qREeDUvGKB0ou8GTVkJk9Tagxxza3GasTdHBffRSTXXNoF4aXll3ha9UOleOmw==
X-Received: by 2002:a17:90b:1e0e:b0:340:f05a:3ec2 with SMTP id 98e67ed59e1d1-34733f34135mr15093395a91.17.1764011741360;
        Mon, 24 Nov 2025 11:15:41 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:15:40 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:13:44 +0800
Subject: [PATCH v3 01/19] mm, swap: rename __read_swap_cache_async to
 swap_cache_alloc_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-1-33f54f707a5c@tencent.com>
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
In-Reply-To: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=8299;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=avBXrzr/6LcA0po0XEbV8MSGPC0ib13hKBO1eBIu8Z8=;
 b=AClgnDVHupKXe6zKun7ExA0riZ3WusbVWCDk0HLSr8Nw0f6hBl58RDuVlmxlTSApXArTiHjzQ
 J3478M2xmErDF3a11oYExiZqSy1rvVQWb5rEmF3uqZJrdQtSiI84+tu
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Stat-Signature: fkycrn6qbz4mu3nyobazsaw7yd1yi4ei
X-Rspam-User: 
X-Rspamd-Queue-Id: C2C6B18000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1764011742-327344
X-HE-Meta: U2FsdGVkX1/XqeFxgzJGpeDydsXdvbZg5wmXJiMVa31iaUsI7VvmSZKz2PKKFjbAPUSsBhXzvcF7R5tCfnGS5dH4Jb3tK8vxnUpEp9cisOZQaMCqUsi+oDTKSgxHVywGi6bCVT+Gqmyb7T1iUUeG/GUp8HWxs2TnJTu7FONjvspqrhgPOBGjzLN72ZTyrU7PMhGaQcwN4U/IrQLyQ/zRsi+NEY7iFcRUJ35k/DijS4aG8oHopp/bsnk+Ptp4lOjY6zUkBxeD8ENrTIBYnRe2vp2Iehk5+YHBlRCY2SR1iYFfbJ12vOKfFFWsqeNOGSXUAxyBVI0DyfotJTmiXi8t5noZpf2Y1/Mgx82bpwViEjP+VrhjGvcWXrr6thGmJgGzocbQEmO6T0aNbafQ/556wkPGGcfvt9XuvdWc6MVAfU0nb3Wa1ipImN3vAdLoY5FYJpDPQY0Yldah2j7enYpJUIStcxTLsA/hhoWxNAU+5p5B2emF0YZ3nbSNTqPJN1iolmsLsnAe/EUHA/OD5iHnu55auvOerMpreDgzWRF4P1AvRQLY8sQru3ai1YyVo8rRnD33iZvAvRHKpF73vCGtvFZbawDBjmcZOkYgOhrLi/N+mTPOPxdKOvaNVebwUfuUGwI59u/LQif3J6A1GmKi1u3+BmVY89/jrhwhDH1F0OAVYaSoADz7+yghUehCQdWGFksff3OGOXgZb7fJ4RPaahQAk7zb+AQ4iOiW8ZShFjDhj5Sg4b++2+Plrq9aRLaWQakaSQb8hwdYmwlPe1HvIeej3uS1M8e+4Ijq6D6qwRJmNXY+LAuS9ZNggoCDHCYQf/veIqUneZyvuPrb+9YGiYUMj3S/3w6Fn7nLrTsRn2S/Sz/K8Ouyev/OMsSKofFndg6k6T0ny2kEydnLRMr8+PWLYFanfkm+wQzFv6PML69yEwK0YbZHV4Hpv/f4+kLMbhvv81epaf9HxqqxeSW
 6HNgi8kt
 lD7P2RZOkn5k6Ysqi1dwKhfO1YjnPrVET9W6I5GIDXpi+10zXSiCwTGj7PQaPDkVFBuj52aq9yJ8CasKY8X33WsbZhq6UkM1Dyn8AJdnrS7VW6Qigdvc+Qkpegqs4kTPya5GnSBIVOPUp+m3VCanQUAdUugp109Kr5TFQlAHlAKCamBXCn8OnjbXuY7hcqxrewhnNlF3Ka0LxFxyiA8t4wvogZX+/1Jr4maftHpUuYE3X8QuXP0KlcOjbjijmSJXZ8CuzZLOdfqcbVeEe/KCrr31uKjoS++0VhiItGPmvtoiNkcPxnEEYqgZ8GTM6WysPqB5Aeu3UQMDXqn2hroYlkC6fBbDoBED7SID5XMol6ivdOK3XA+1m+wqNtMhy9kOGoFa0BQrj+8yLpE+K088jg/bFiE9lQAg4P29v3WYGNnkoQpqBfWnhfWFH21htk+GE0I+g5BkdbQ2ekaiPEf9GcUrcLMd4tRRjKRoH3JU0rXYvdAavZ6+2+B4EqwsJD/Tv8S3ky1FbA/2hUkU=
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
index d12332423a06..ee6bb37ab174 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1570,7 +1570,7 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
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


