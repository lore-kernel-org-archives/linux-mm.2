Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45C94CFD351
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982356B00A5; Mon, 24 Nov 2025 14:16:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932FD6B00A7; Mon, 24 Nov 2025 14:16:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3456B00A8; Mon, 24 Nov 2025 14:16:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 653A56B00A5
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:16:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2CB3414054A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:56 +0000 (UTC)
X-FDA: 84146458032.01.932F540
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 193F3A0004
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Usqc7VF6;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dW2hSKXTwR8T2CwBP/MRRLrpmfjOQ9zqQiuqar3vsV4=;
	b=1xEZI/GC7AfZ52Ucx0IE4QvGuSSAb+ZRwP2uzNsa0gGRvOpJAVrr5dwqsFZIrgq8wMDVUF
	zZHI5dx0PC4iRIUff20lYf0rq43p81Yy3EYcnPDLgJRPtMpY07XqudFFyES/3VUkQni+zS
	eBYz2IcCccOeUierTOU9THaX+z1ZQqM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Usqc7VF6;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011814; a=rsa-sha256;
	cv=none;
	b=pX6F1Mv5X6ApKJzKnHJxCjyGbJgkVDGG/PokmPCk1s1OLX8OB/dPsdVSzRLh4OIn3Dd59T
	t2BnUrNmalmT/Rj2Z2PqJp5xB8wbvVxEqimoT87UtsCrfwIxGK6sFFz/8B7+d4F+ljMEfs
	EEtJzUl2zKc4nSfNUR3EfVgSDRXzink=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7bc0cd6a13aso2886346b3a.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011813; x=1764616613; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dW2hSKXTwR8T2CwBP/MRRLrpmfjOQ9zqQiuqar3vsV4=;
        b=Usqc7VF6c9jHQyqCpGUp+rCiZ1fNm9fc4T7iKtNJdsQuKgtta8uRINqJhwu8Z9gpOY
         Sjf/8XE35iH3KMFXlCzLh+AoWWKk355oZj7YepZNtnoFIW2Nd3ZG8N81jgo2NevHj7fF
         Yy1fUl3cXwTYiRPb93S+45lWUdp2jfw4hYgwSXzwtYxwXdM9MlUoIZUcdXw/AaJGXi/3
         b6LvYXQlTP9T89gCMRz1tHcgDZpmtaxnifJqxvE9pLX249eKguOusoEMeWfjIjfD4biM
         zoa2iqGBr+6XHuVgCXkOc+l54IMqqLQVhN1OarHkLqxYxUUMADc0xB3tl4lWgmV2VbSy
         SwfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011813; x=1764616613;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dW2hSKXTwR8T2CwBP/MRRLrpmfjOQ9zqQiuqar3vsV4=;
        b=W+v1c6aiJYozgKJ1MeJqZVbsTm8Ng3vKdqQckZUztLfz9+51Ga9W/ZXzPb7pV7TExd
         ZkZKZTEc7yGncFb1WBlGlgjXFH2FA8/MNH1I6oFkj7n71roaz7nLxp2emaiZaFEze0rf
         Aj2yhqyPuUvNqKxYV2D8pxxNiGKerLgLOhMcJGOBr6MshPwBIgSsJt7B1YxwSN3CHc3T
         P45RgJfe3a0IWXJvV0IJxR5goNsUZPJ3zHcrmZqMQPIsYAV9PvqBYrmSNeYCzS1UKKty
         qLKBaDybl7QGQOkuYDvmsk2ABNlRH47Jne/B1vioKOCCDsARg/g/r3Jsg9/BBbCEUE/+
         QOQg==
X-Gm-Message-State: AOJu0YxorRJCAu6Lynxmm3lljusPvf8N/mz8mqUe6avSYL8K0WcZAM4W
	mQjMTQ+Y8ogRoIPlWgautFzbGIIkyma+fkkgL4PEQIYpl8Ky3bd0JxIC
X-Gm-Gg: ASbGncvpLzP/f+XauIvolrLeWxMl9M8pjTYEqD8vtr3wlALSFmSAqWd+JWzzOdGQDD4
	CEjLeZhoe73p/Btx3sET3/YV8k+mqvJfxIdtQl6BEWzchf+Di4/XB9COWnSG4jBvto9FUKq34aU
	8lZC33uigx/Wu2VMH5XTPTzGTS2bmfPzn4sREFT0yByq9ZYSem+GryYMjiKvS6gOTtfOOMTLDBP
	N1J8d8mDQMp1N22DswsJKWrOOzrH/rrIcN7wu9LZHW4HeOGUg/LetF0tmQsqOx4rzjcop2IjYUz
	RQe4B8wZmZufupRHuFEU0xZeoUjQZKigcycti1DqiR7/ZrGCfY8b2H6odd7jXddAP5KaUCP4w2z
	NpTmvnN0yfRvE2DR/9cczo8XFPMLwYFaadfh4pqda7zX9gWfRMbFkVGR/bVtMjZ30icrp6QNefI
	km0lin7OuB/5g849pb8sfTDj7PNyg4wwRV2RInjDiICvTXm/Y9Sb8ojD8m74s=
X-Google-Smtp-Source: AGHT+IEJWjl/z5j8RKVC9K8o8FTnjnCf1r/hFIhxiR9Mkw5UkeNOePRPXbwYfdwjKuCnb/LdcCXnPA==
X-Received: by 2002:a05:6a20:a125:b0:35e:835:7ec9 with SMTP id adf61e73a8af0-3613e506c63mr20155913637.17.1764011812685;
        Mon, 24 Nov 2025 11:16:52 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:16:52 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:13:58 +0800
Subject: [PATCH v3 15/19] mm, swap: add folio to swap cache directly on
 allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-15-33f54f707a5c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=18567;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=isfv5Ia1RYLaAnBGIOaD0Ewhzh9QTFk5l53JXG2l+S8=;
 b=2Dbui++dBDCvWX+pGy0ME3ZWHBHPq8rezk3u4V4eX4x/XiUlCH/eDWkpliHmO2KltawfWtXLR
 58O6D2CwyvXBY3DqG+LD1w1k00URJ+8u/R1vvPe0XK/yGwIhtHDm1yk
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 193F3A0004
X-Stat-Signature: k9wkipt9fe3tu4apccjbm9bum7yjyubj
X-Rspam-User: 
X-HE-Tag: 1764011813-606238
X-HE-Meta: U2FsdGVkX19aLs2JXnFry8y3Pg2kmbxuqOUQVOLwBrjldUNdb/aGAijhzdBUerkvtZpWyceANMucQ9ufHlZet5QQmNuspKVyjQfyvkK1E3JQubJTtxdp1/zhFRaGltuBHU5LKIY1Rc1n40MxcU8j+EbQHxfrxFTKeHaaKW4qYKZvsCP4KMdypm4ynGcq85N5FSs8bFTrqHGxcboZeB0MR10qdAfrBI2fYA0U6FMZMDyWCdW2FTO1x1NQjIIwmTmro1aHRZPBXZHpF5x4ZqmDG9EjT7urYmeKuG6g643YOQ0ZN2JwCNamJ5wQaMrrBQfSGhza6YDxXiiDiHjZUOpVAMW9w8+zx/OL2RXyY4OxjN1McrPg36mLEKJ4wcCjfT/5R5C8IXfGDbX5Ul2CPR/lswFswVEofj9w6BcV5LtMu6Du1PwjQpbqLHEqDMfEXBFFwZUCbNEVWWQXAirkJiPEZoVz0QHilufmS0XLe0ocmq8dqYDp1AvHC9yDydmHJX7HtZr81nQt3gki7Bws+QiRvaSU405XSLUD8tkmBsvDNxHE72ry4pRjS6d7HYeACxeQv1BZUgvVz4AUwYOsX2yfEgNdunWollHmyL0qhpW9x/wMLZiAYewUU7c66j8QKBXtmfEWketMUZ4pa4y27lsihtVwA0DhoST2pBvdHCwyWCbQwepu+Qm3HX7J8INK7y8ja5vin+G1KJM8JSLN7IGNdcGsItVT30wzJ0IVcqtO/VYXXbjd/a4LkK/uahQExCoNEaH4nRbOKzY/8HgOFLpDRKj/ykuu6elqDIxs52MymPcsxa7E+WWStQiiH3r0IshbzbJaJQqXXLSw+Sat6yPn7p3r/QIqZsycC9RACs1ymM6wHbO28qaNN7T8/v8ptmowKX68e0hLn+MRSbYSocUA1JHIxBKv+zJdFhhr97acw20EOmGuEKlJfIdxM60y5DmXhITHvKGvYZwYvBUUt1+
 Csfgizk2
 IctCd0SdK2k0oImRPlRkxXuFIpk9Hnbg9eAqNfreDZuwsdET30ivfh1tbhj9mHS2qY3s6lDEVU6psqrmbTG38eAA7yyG87+3wblE6U+KIemf2kRZ+T1GfRgXl5ZtptWiYyYeBYqk4dD3gmJ8Si9uoEBZQ5KNjgHEJKBJ/h4nh5e5vfenCi6eR/H5OaZ5vTgvrusC8UUh05f8aGfhdVaqeGEJDb5ctChbrUuiSgcKJHMrvgFDzrLJhvM4c+zt5aSj/PyrV6quSWcpxP9K1X/rxEXr1ByJFr8m5JRMbJDmvDKELQwJkKYW802X6XzXsIOJAw1xVTR+qNf35wmI0Trx4rCIk3voJOIFoCR9VnZ79trMeRnKJfP8V5vQ1EPhFWJ3OxZDtmwHFu38RBuP3Qjg9wxraUEqhmIkLGHFAi1PKqQ2+PU5UAI1rL5dliQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The allocator uses SWAP_HAS_CACHE to pin a swap slot upon allocation.
SWAP_HAS_CACHE is being deprecated as it caused a lot of confusion.
This pinning usage here can be dropped by adding the folio to swap
cache directly on allocation.

All swap allocations are folio-based now (except for hibernation), so
the swap allocator can always take the folio as the parameter. And now
both swap cache (swap table) and swap map are protected by the cluster
lock, scanning the map and inserting the folio can be done in the same
critical section. This eliminates the time window that a slot is pinned
by SWAP_HAS_CACHE, but it has no cache, and avoids touching the lock
multiple times.

This is both a cleanup and an optimization.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |   5 --
 mm/swap.h            |  10 +---
 mm/swap_state.c      |  58 +++++++++++--------
 mm/swapfile.c        | 157 +++++++++++++++++++++------------------------------
 4 files changed, 101 insertions(+), 129 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index ac3caa4c6999..4b4b81fbc6a3 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -452,7 +452,6 @@ static inline long get_nr_swap_pages(void)
 }
 
 extern void si_swapinfo(struct sysinfo *);
-void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
 int swap_type_of(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
@@ -534,10 +533,6 @@ static inline void swap_put_entries_direct(swp_entry_t ent, int nr)
 {
 }
 
-static inline void put_swap_folio(struct folio *folio, swp_entry_t swp)
-{
-}
-
 static inline int __swap_count(swp_entry_t entry)
 {
 	return 0;
diff --git a/mm/swap.h b/mm/swap.h
index 9ed12936b889..ec1ef7d0c35b 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -277,13 +277,13 @@ void __swapcache_clear_cached(struct swap_info_struct *si,
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
-int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-			 void **shadow, bool alloc);
 void swap_cache_del_folio(struct folio *folio);
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
 				     struct mempolicy *mpol, pgoff_t ilx,
 				     bool *alloced);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
+void __swap_cache_add_folio(struct swap_cluster_info *ci,
+			    struct folio *folio, swp_entry_t entry);
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry, void *shadow);
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
@@ -459,12 +459,6 @@ static inline void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
-static inline int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-				       void **shadow, bool alloc)
-{
-	return -ENOENT;
-}
-
 static inline void swap_cache_del_folio(struct folio *folio)
 {
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index c29b7e386a7c..eb7710120d5f 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -122,35 +122,56 @@ void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
+void __swap_cache_add_folio(struct swap_cluster_info *ci,
+			    struct folio *folio, swp_entry_t entry)
+{
+	unsigned long new_tb;
+	unsigned int ci_start, ci_off, ci_end;
+	unsigned long nr_pages = folio_nr_pages(folio);
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
+
+	new_tb = folio_to_swp_tb(folio);
+	ci_start = swp_cluster_offset(entry);
+	ci_off = ci_start;
+	ci_end = ci_start + nr_pages;
+	do {
+		VM_WARN_ON_ONCE(swp_tb_is_folio(__swap_table_get(ci, ci_off)));
+		__swap_table_set(ci, ci_off, new_tb);
+	} while (++ci_off < ci_end);
+
+	folio_ref_add(folio, nr_pages);
+	folio_set_swapcache(folio);
+	folio->swap = entry;
+
+	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
+}
+
 /**
  * swap_cache_add_folio - Add a folio into the swap cache.
  * @folio: The folio to be added.
  * @entry: The swap entry corresponding to the folio.
  * @gfp: gfp_mask for XArray node allocation.
  * @shadowp: If a shadow is found, return the shadow.
- * @alloc: If it's the allocator that is trying to insert a folio. Allocator
- *         sets SWAP_HAS_CACHE to pin slots before insert so skip map update.
  *
  * Context: Caller must ensure @entry is valid and protect the swap device
  * with reference count or locks.
  */
-int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-			 void **shadowp, bool alloc)
+static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+				void **shadowp)
 {
 	int err;
 	void *shadow = NULL;
+	unsigned long old_tb;
 	struct swap_info_struct *si;
-	unsigned long old_tb, new_tb;
 	struct swap_cluster_info *ci;
 	unsigned int ci_start, ci_off, ci_end, offset;
 	unsigned long nr_pages = folio_nr_pages(folio);
 
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
-
 	si = __swap_entry_to_info(entry);
-	new_tb = folio_to_swp_tb(folio);
 	ci_start = swp_cluster_offset(entry);
 	ci_end = ci_start + nr_pages;
 	ci_off = ci_start;
@@ -166,7 +187,7 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 			err = -EEXIST;
 			goto failed;
 		}
-		if (!alloc && unlikely(!__swap_count(swp_entry(swp_type(entry), offset)))) {
+		if (unlikely(!__swap_count(swp_entry(swp_type(entry), offset)))) {
 			err = -ENOENT;
 			goto failed;
 		}
@@ -182,20 +203,11 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 		 * Still need to pin the slots with SWAP_HAS_CACHE since
 		 * swap allocator depends on that.
 		 */
-		if (!alloc)
-			__swapcache_set_cached(si, ci, swp_entry(swp_type(entry), offset));
-		__swap_table_set(ci, ci_off, new_tb);
+		__swapcache_set_cached(si, ci, swp_entry(swp_type(entry), offset));
 		offset++;
 	} while (++ci_off < ci_end);
-
-	folio_ref_add(folio, nr_pages);
-	folio_set_swapcache(folio);
-	folio->swap = entry;
+	__swap_cache_add_folio(ci, folio, entry);
 	swap_cluster_unlock(ci);
-
-	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
-	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
-
 	if (shadowp)
 		*shadowp = shadow;
 	return 0;
@@ -464,7 +476,7 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
 	for (;;) {
-		ret = swap_cache_add_folio(folio, entry, &shadow, false);
+		ret = swap_cache_add_folio(folio, entry, &shadow);
 		if (!ret)
 			break;
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7890039d2f65..91368294170f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -884,28 +884,53 @@ static void swap_cluster_assert_table_empty(struct swap_cluster_info *ci,
 	}
 }
 
-static bool cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster_info *ci,
-				unsigned int start, unsigned char usage,
-				unsigned int order)
+static bool cluster_alloc_range(struct swap_info_struct *si,
+				struct swap_cluster_info *ci,
+				struct folio *folio,
+				unsigned int offset)
 {
-	unsigned int nr_pages = 1 << order;
+	unsigned long nr_pages;
+	unsigned int order;
 
 	lockdep_assert_held(&ci->lock);
 
 	if (!(si->flags & SWP_WRITEOK))
 		return false;
 
+	/*
+	 * All mm swap allocation starts with a folio (folio_alloc_swap),
+	 * it's also the only allocation path for large orders allocation.
+	 * Such swap slots starts with count == 0 and will be increased
+	 * upon folio unmap.
+	 *
+	 * Else, it's a exclusive order 0 allocation for hibernation.
+	 * The slot starts with count == 1 and never increases.
+	 */
+	if (likely(folio)) {
+		order = folio_order(folio);
+		nr_pages = 1 << order;
+		/*
+		 * Pin the slot with SWAP_HAS_CACHE to satisfy swap_dup_entries.
+		 * This is the legacy allocation behavior, will drop it very soon.
+		 */
+		memset(si->swap_map + offset, SWAP_HAS_CACHE, nr_pages);
+		__swap_cache_add_folio(ci, folio, swp_entry(si->type, offset));
+	} else {
+		order = 0;
+		nr_pages = 1;
+		WARN_ON_ONCE(si->swap_map[offset]);
+		si->swap_map[offset] = 1;
+		swap_cluster_assert_table_empty(ci, offset, 1);
+	}
+
 	/*
 	 * The first allocation in a cluster makes the
 	 * cluster exclusive to this order
 	 */
 	if (cluster_is_empty(ci))
 		ci->order = order;
-
-	memset(si->swap_map + start, usage, nr_pages);
-	swap_cluster_assert_table_empty(ci, start, nr_pages);
-	swap_range_alloc(si, nr_pages);
 	ci->count += nr_pages;
+	swap_range_alloc(si, nr_pages);
 
 	return true;
 }
@@ -913,13 +938,12 @@ static bool cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster
 /* Try use a new cluster for current CPU and allocate from it. */
 static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 					    struct swap_cluster_info *ci,
-					    unsigned long offset,
-					    unsigned int order,
-					    unsigned char usage)
+					    struct folio *folio, unsigned long offset)
 {
 	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
 	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
+	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned int nr_pages = 1 << order;
 	bool need_reclaim, ret, usable;
 
@@ -943,7 +967,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 			if (!ret)
 				continue;
 		}
-		if (!cluster_alloc_range(si, ci, offset, usage, order))
+		if (!cluster_alloc_range(si, ci, folio, offset))
 			break;
 		found = offset;
 		offset += nr_pages;
@@ -965,8 +989,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 
 static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 					 struct list_head *list,
-					 unsigned int order,
-					 unsigned char usage,
+					 struct folio *folio,
 					 bool scan_all)
 {
 	unsigned int found = SWAP_ENTRY_INVALID;
@@ -978,7 +1001,7 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 		if (!ci)
 			break;
 		offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, offset, order, usage);
+		found = alloc_swap_scan_cluster(si, ci, folio, offset);
 		if (found)
 			break;
 	} while (scan_all);
@@ -1039,10 +1062,11 @@ static void swap_reclaim_work(struct work_struct *work)
  * Try to allocate swap entries with specified order and try set a new
  * cluster for current CPU too.
  */
-static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int order,
-					      unsigned char usage)
+static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
+					      struct folio *folio)
 {
 	struct swap_cluster_info *ci;
+	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned int offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 
 	/*
@@ -1064,8 +1088,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(si, ci);
-			found = alloc_swap_scan_cluster(si, ci, offset,
-							order, usage);
+			found = alloc_swap_scan_cluster(si, ci, folio, offset);
 		} else {
 			swap_cluster_unlock(ci);
 		}
@@ -1079,22 +1102,19 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 	 * to spread out the writes.
 	 */
 	if (si->flags & SWP_PAGE_DISCARD) {
-		found = alloc_swap_scan_list(si, &si->free_clusters, order, usage,
-					     false);
+		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
 	}
 
 	if (order < PMD_ORDER) {
-		found = alloc_swap_scan_list(si, &si->nonfull_clusters[order],
-					     order, usage, true);
+		found = alloc_swap_scan_list(si, &si->nonfull_clusters[order], folio, true);
 		if (found)
 			goto done;
 	}
 
 	if (!(si->flags & SWP_PAGE_DISCARD)) {
-		found = alloc_swap_scan_list(si, &si->free_clusters, order, usage,
-					     false);
+		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
 	}
@@ -1110,8 +1130,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		 * failure is not critical. Scanning one cluster still
 		 * keeps the list rotated and reclaimed (for HAS_CACHE).
 		 */
-		found = alloc_swap_scan_list(si, &si->frag_clusters[order], order,
-					     usage, false);
+		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, false);
 		if (found)
 			goto done;
 	}
@@ -1125,13 +1144,11 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		 * Clusters here have at least one usable slots and can't fail order 0
 		 * allocation, but reclaim may drop si->lock and race with another user.
 		 */
-		found = alloc_swap_scan_list(si, &si->frag_clusters[o],
-					     0, usage, true);
+		found = alloc_swap_scan_list(si, &si->frag_clusters[o], folio, true);
 		if (found)
 			goto done;
 
-		found = alloc_swap_scan_list(si, &si->nonfull_clusters[o],
-					     0, usage, true);
+		found = alloc_swap_scan_list(si, &si->nonfull_clusters[o], folio, true);
 		if (found)
 			goto done;
 	}
@@ -1322,12 +1339,12 @@ static bool get_swap_device_info(struct swap_info_struct *si)
  * Fast path try to get swap entries with specified order from current
  * CPU's swap entry pool (a cluster).
  */
-static bool swap_alloc_fast(swp_entry_t *entry,
-			    int order)
+static bool swap_alloc_fast(struct folio *folio)
 {
+	unsigned int order = folio_order(folio);
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
-	unsigned int offset, found = SWAP_ENTRY_INVALID;
+	unsigned int offset;
 
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
@@ -1342,22 +1359,18 @@ static bool swap_alloc_fast(swp_entry_t *entry,
 	if (cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, offset, order, SWAP_HAS_CACHE);
-		if (found)
-			*entry = swp_entry(si->type, found);
+		alloc_swap_scan_cluster(si, ci, folio, offset);
 	} else {
 		swap_cluster_unlock(ci);
 	}
 
 	put_swap_device(si);
-	return !!found;
+	return folio_test_swapcache(folio);
 }
 
 /* Rotate the device and switch to a new cluster */
-static void swap_alloc_slow(swp_entry_t *entry,
-			    int order)
+static void swap_alloc_slow(struct folio *folio)
 {
-	unsigned long offset;
 	struct swap_info_struct *si, *next;
 
 	spin_lock(&swap_avail_lock);
@@ -1367,13 +1380,11 @@ static void swap_alloc_slow(swp_entry_t *entry,
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
 		if (get_swap_device_info(si)) {
-			offset = cluster_alloc_swap_entry(si, order, SWAP_HAS_CACHE);
+			cluster_alloc_swap_entry(si, folio);
 			put_swap_device(si);
-			if (offset) {
-				*entry = swp_entry(si->type, offset);
+			if (folio_test_swapcache(folio))
 				return;
-			}
-			if (order)
+			if (folio_test_large(folio))
 				return;
 		}
 
@@ -1434,7 +1445,6 @@ int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
-	swp_entry_t entry = {};
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
@@ -1459,39 +1469,23 @@ int folio_alloc_swap(struct folio *folio)
 
 again:
 	local_lock(&percpu_swap_cluster.lock);
-	if (!swap_alloc_fast(&entry, order))
-		swap_alloc_slow(&entry, order);
+	if (!swap_alloc_fast(folio))
+		swap_alloc_slow(folio);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	if (unlikely(!order && !entry.val)) {
+	if (!order && unlikely(!folio_test_swapcache(folio))) {
 		if (swap_sync_discard())
 			goto again;
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (mem_cgroup_try_charge_swap(folio, entry))
-		goto out_free;
+	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
+		swap_cache_del_folio(folio);
 
-	if (!entry.val)
+	if (unlikely(!folio_test_swapcache(folio)))
 		return -ENOMEM;
 
-	/*
-	 * Allocator has pinned the slots with SWAP_HAS_CACHE
-	 * so it should never fail
-	 */
-	WARN_ON_ONCE(swap_cache_add_folio(folio, entry, NULL, true));
-
-	/*
-	 * Allocator should always allocate aligned entries so folio based
-	 * operations never crossed more than one cluster.
-	 */
-	VM_WARN_ON_ONCE_FOLIO(!IS_ALIGNED(folio->swap.val, size), folio);
-
 	return 0;
-
-out_free:
-	put_swap_folio(folio, entry);
-	return -ENOMEM;
 }
 
 /**
@@ -1790,29 +1784,6 @@ static void swap_entries_free(struct swap_info_struct *si,
 		partial_free_cluster(si, ci);
 }
 
-/*
- * Called after dropping swapcache to decrease refcnt to swap entries.
- */
-void put_swap_folio(struct folio *folio, swp_entry_t entry)
-{
-	struct swap_info_struct *si;
-	struct swap_cluster_info *ci;
-	unsigned long offset = swp_offset(entry);
-	int size = 1 << swap_entry_order(folio_order(folio));
-
-	si = _swap_info_get(entry);
-	if (!si)
-		return;
-
-	ci = swap_cluster_lock(si, offset);
-	if (swap_only_has_cache(si, offset, size))
-		swap_entries_free(si, ci, entry, size);
-	else
-		for (int i = 0; i < size; i++, entry.val++)
-			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
-	swap_cluster_unlock(ci);
-}
-
 int __swap_count(swp_entry_t entry)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
@@ -2063,7 +2034,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 			 * with swap table allocation.
 			 */
 			local_lock(&percpu_swap_cluster.lock);
-			offset = cluster_alloc_swap_entry(si, 0, 1);
+			offset = cluster_alloc_swap_entry(si, NULL);
 			local_unlock(&percpu_swap_cluster.lock);
 			if (offset)
 				entry = swp_entry(si->type, offset);

-- 
2.52.0


