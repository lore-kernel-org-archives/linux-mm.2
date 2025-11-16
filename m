Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4585ACCD19A
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09D68E0030; Sun, 16 Nov 2025 13:13:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1938E0029; Sun, 16 Nov 2025 13:13:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7978E0030; Sun, 16 Nov 2025 13:13:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77EA68E0029
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:13:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3FFF14E04A
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:35 +0000 (UTC)
X-FDA: 84117267990.11.41E2495
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3D5CDC000C
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EkQJH+kT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7EAjJXkojRjqmIT50lGJnzvrfDUaQb3ZQ9KqCBpob2g=;
	b=iocPC3wm4zdQw/GbfHcq3sbIN2nT7t3bIc1BFgv04DIyqx0NvxDlSGd/WI/qEPxq9spprC
	4JSBMNjPFl1s6zUZa2Rn4eR6EnJdi0hpWN+X9xsQSbjhFeFNBLEIdNNb4I8qzAIUU1Lyg3
	fGJ/mTHTgQZkfOqDU8jENKQkQsYpxnA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316813; a=rsa-sha256;
	cv=none;
	b=p09Rv51Vni1D8uCiYyyEn4Atb4PApeL3k5rt2YYCjEAd2AokWeDjmXKYiw7IyDFzXhAKhb
	oh6oQoCXW+/a1k7vsjL4XJWLy796aujNy+ciYVBGufo13CfZSOYZ2XsEGvMPvXQ9Uk/xDI
	r5OYwZp95pDyElX7U0dvXLxPotT+x9Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EkQJH+kT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8b2148ca40eso507923885a.1
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316812; x=1763921612; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7EAjJXkojRjqmIT50lGJnzvrfDUaQb3ZQ9KqCBpob2g=;
        b=EkQJH+kTKFIjjNBJLTMnHcO7zvLkk/Ona2Mpf1/htoO+RO1tTJeXU4yybmiDFK8Uae
         4R1cXA8gpjfWAeDwVyetZPhvZuU7YbCbL+85jdG+inE2eRq4bh/kyHnwr43sDTTYjo1y
         EzzdWPuxTgZlyAyDzHHPPScpWDzFtE0ctIef1Rjm/UJypDVaTNkz+OTkcWB2XtS71ice
         CVm6n+t3nCsl7T9EDRS/kRAbhI8iFCz0cLBd29ovioixLDVBjQclj/HD3t9xvNZIkqgd
         Y3Q7YkC1MJr8UyReEp0OOKe2slrvnrCyXu7aEOLLdNnIBsg4n5s9MRbxWHS1/awA1i4s
         yw4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316812; x=1763921612;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7EAjJXkojRjqmIT50lGJnzvrfDUaQb3ZQ9KqCBpob2g=;
        b=a3epehIPEihRIRxMzK7emjSv554+UJUzCsxHanMurjcZOfcnYeODCaV0ij9F+AcPHy
         wtql3OCGYDvQd3Zo7ubSbW2uJSRAf/hU4LjQ0TDT8PpKe1xrDFCXzDjYy9SVtrD0WA9X
         l7yubRvFvIE/4pxfhKkqmm1Q4DJF/pjGLf3hhyCV5WoWURLpyQDUs0thAyfI+a9lsU3q
         Rx3MkKSJiIo9ORVOtkouabNurcKvu27Glb01xeg0znkatH1n/Wu24MaS8xoqWp2TYS+C
         iL56DA0ToPgrKtVvLeCLeqocZbM4TlzMsHMEL9UAbf3X8aVndvsMAwcROD6A9VHX/WIX
         auNQ==
X-Gm-Message-State: AOJu0Yy1JbCY9UScDwFhKcW4zNxei18ie+xnyTHaaWzoyb3R4MUktASz
	vvAMrC4t81t/xJ96f3W2cgHD8n2vitfuIAQ+N4DkNCeYoyaTOSEl5gPP
X-Gm-Gg: ASbGncsaYMwRU1qaA6CNODjkiIdk5mqppHGKDoEgVIa7eFBRHC68zz6bvSoCcojxyhr
	Q6xpKp8uDs1Ne5EADKsi86n9mo57cZJiAo1VTrH+JLffuzKUXGSl43UznSLZaWWckW98qqSlkeQ
	LZ3UiM3N6+HtgXzaqWb235OMD8KeLrukEpCMPm+267Vlk93iGwAi+BWbdjR0cl2Ngi3aDKRw4GJ
	lqZMfdmQ1ShbXXDW6rvHSekJUvW8OysHpivYY4vwsnKg7bvM+h7A9tgBt1P2hWcZSobQzG+vV8C
	LoipHOe0FOCQL46UZXNss0ge3a+mk3DeRr/vzL3nhY5O/gHCXuRP0I2P1laIZYNEhyBlxJ1J/nW
	zpQhLyphHK0CW1l6nVRqwSGxMLPNwN7rr1uYGGEut7402kwe1g3ZXrcBcsFtFNyY6lU5CHA+p0n
	acJRYJPej7Y183pR3cGteAiVClESiD/WeW8Ov8Hs84lA==
X-Google-Smtp-Source: AGHT+IGBt0Vry05BOp+MqbADIQaHT6h2/EkPtbXhMj+RRGB5akUIUP54sZfWuunfzNN/FFmthDGryg==
X-Received: by 2002:a05:620a:3197:b0:855:24d7:5525 with SMTP id af79cd13be357-8b2c2e5c6e3mr1343714185a.0.1763316812244;
        Sun, 16 Nov 2025 10:13:32 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:13:31 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:56 +0800
Subject: [PATCH v2 15/19] mm, swap: add folio to swap cache directly on
 allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-15-37730e6ea6d5@tencent.com>
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=18917;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=QAf4gHYVYlb1gaJfI/55FDXVwGn+2i7hMqLlpxZIIRI=;
 b=tQp5z9coUnx62/nZ8umGo9weoh93kH2AlZt5O+9Dp0LnmvOga/+UzQ75clX+Ku24ARVC19h/M
 sVNAFcCK5cmB2d/T97h33LjvpOHVqmS7mDW7a4ig/HgoNgA2hawjF6A
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Stat-Signature: jxhtdfwpee8ykdtuhyp8sksibxy3yiqx
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D5CDC000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1763316813-659155
X-HE-Meta: U2FsdGVkX1+/4Pq5JrKBU2sf+mK/WacHr/3WIHSX+dMWjXpvQHboWC+Aiz86HTjeIarfehJVxtug5OTIfB5dxAJBljGlCsgEFJ/Ht7KKx27DoY1lK3cPeneJxhyj/4pHzVdNy5q1YDIjvaqN478oqFcBNcoOR1Ylcgu9FPITjp5Jxp1B3VGpWYjvUf6DY+1qLDGCo5/QgY1RQTvxzqU9QX0j8uTzEW/jM2E2vuGcuC9cfzTQ1boTe/tW+NnHMPJZk8I7yHVdOPvq2XokZx16PTU4heSpYJFNA++F1o6ssXRHt+i2kw4VoPpv9IiXd7VsdhCwiw5SdnhlBH69UQqAHiEaisT0IU5za0RN7kQlqBaHNaksN6lpQD5wtgEKfkdu8IHFcq2sT0VSmKG798ZGDNrVMxjT8fmO1/Thg5AySyvZp4zx3FwdMSkmWf4UppVw9RRdH5GEJw+o1yC4OcECXVj8SpubWvjLX/658/B+8/TrRY0uLNlSdW7UV+Vh1aFjUgFSTnFFloTand5oKRThGfPYWhRUh7YvQxjMRBQW923A2lKjHBB2BCdxv/dU5OE6FTWzWgoJ1MI8SbB1/JYrEJGLdOaWVjtSBVW0fKzLjYzT9vos6F/2RdvtBAPeVB1tOovOejMXOou8856//LuyhRXgjXfCPI7DG7xpQnhHPbc3VZGJaMnP6MxPIo/VdLUifC/oYkciHMVrO4w+1xuoJxeqLNIBkUak5z6tM6HOZonsF5vJH7qR0xozwuT7XSGyJnef/poizO5SBLEGR1jMjjFkp70NJt+kHvyE+sEC9lwkRSsxmYih16NZL5knJi+QF9wfVG2qRXx/LiMhAbdGSYuWAihjB7fCl4hyBj5omSvx3WSk8UUigPHlk1qJlBvmLLtWO4s6P+EHuK/mvV/tOcXDygaeTVBHsEJvGIf6Nx5ko87/cKTiiX4UMk8bTp0PZ/QLsEuOCj4XlrwiKm0
 ZAQcDCLQ
 c8AZ4G6MgoFEga4TRK9Fzmc8pnil2YfxbhQrbKZI0MwlgHpjia9MjwW+lNxlOvputBBmL2M8unfPx+FQwHw7Ln0F/fgKZbhIqUjbpe7aNDcbSQsPWzGHwFVMlzErXS3besn/6agD4fZNLlKPDcCCsQHZtrW3s1taEseJpayNJ7UeWpoZt0LfVfQ3QgoklqPqBpgk/uU6Sr/l35/8nNOSJmVAp91MxCT25wNXFFAz3eHNAH+uQynwAkFrI+WwTNsDh0DYcBpookHdKL4QGyQPWPt/HejzJ7f3aGEDmuIrUkbFpJAlglE9RDpJfA8GYjriM/t2jbJXkqaX2WCzEDF6owp4Ll9BZt6hpl1NqOdNXYYOT1CmndQZIood2N85R3tpIdEGUQltEiLr1Aqk2daCTe31W0IVs2dyIEemXU/txmsvdkd0RxB6t/Admkw==
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
 mm/swap_state.c      |  58 ++++++++++--------
 mm/swapfile.c        | 162 +++++++++++++++++++++------------------------------
 4 files changed, 103 insertions(+), 132 deletions(-)

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
index adf6e33263f3..ca1b7954bbb8 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -122,37 +122,58 @@ void *swap_cache_get_shadow(swp_entry_t entry)
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
  * The caller also needs to update the corresponding swap_map slots with
  * SWAP_HAS_CACHE bit to avoid race or conflict.
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
@@ -168,7 +189,7 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 			err = -EEXIST;
 			goto failed;
 		}
-		if (!alloc && unlikely(!__swap_count(swp_entry(swp_type(entry), offset)))) {
+		if (unlikely(!__swap_count(swp_entry(swp_type(entry), offset)))) {
 			err = -ENOENT;
 			goto failed;
 		}
@@ -184,20 +205,11 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
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
@@ -466,7 +478,7 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
 	for (;;) {
-		ret = swap_cache_add_folio(folio, entry, &shadow, false);
+		ret = swap_cache_add_folio(folio, entry, &shadow);
 		if (!ret)
 			break;
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c2b03af5c4e3..ea18096444d7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -875,28 +875,53 @@ static void swap_cluster_assert_table_empty(struct swap_cluster_info *ci,
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
@@ -904,13 +929,12 @@ static bool cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster
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
 	bool need_reclaim;
 
@@ -932,7 +956,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 				continue;
 			offset = found;
 		}
-		if (!cluster_alloc_range(si, ci, offset, usage, order))
+		if (!cluster_alloc_range(si, ci, folio, offset))
 			break;
 		found = offset;
 		offset += nr_pages;
@@ -954,8 +978,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 
 static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 					 struct list_head *list,
-					 unsigned int order,
-					 unsigned char usage,
+					 struct folio *folio,
 					 bool scan_all)
 {
 	unsigned int found = SWAP_ENTRY_INVALID;
@@ -967,7 +990,7 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 		if (!ci)
 			break;
 		offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, offset, order, usage);
+		found = alloc_swap_scan_cluster(si, ci, folio, offset);
 		if (found)
 			break;
 	} while (scan_all);
@@ -1028,10 +1051,11 @@ static void swap_reclaim_work(struct work_struct *work)
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
@@ -1053,8 +1077,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(si, ci);
-			found = alloc_swap_scan_cluster(si, ci, offset,
-							order, usage);
+			found = alloc_swap_scan_cluster(si, ci, folio, offset);
 		} else {
 			swap_cluster_unlock(ci);
 		}
@@ -1068,22 +1091,19 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
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
@@ -1099,8 +1119,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		 * failure is not critical. Scanning one cluster still
 		 * keeps the list rotated and reclaimed (for HAS_CACHE).
 		 */
-		found = alloc_swap_scan_list(si, &si->frag_clusters[order], order,
-					     usage, false);
+		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, false);
 		if (found)
 			goto done;
 	}
@@ -1114,13 +1133,11 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
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
@@ -1311,12 +1328,12 @@ static bool get_swap_device_info(struct swap_info_struct *si)
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
@@ -1331,22 +1348,18 @@ static bool swap_alloc_fast(swp_entry_t *entry,
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
-static bool swap_alloc_slow(swp_entry_t *entry,
-			    int order)
+static void swap_alloc_slow(struct folio *folio)
 {
-	unsigned long offset;
 	struct swap_info_struct *si, *next;
 
 	spin_lock(&swap_avail_lock);
@@ -1356,14 +1369,12 @@ static bool swap_alloc_slow(swp_entry_t *entry,
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
 		if (get_swap_device_info(si)) {
-			offset = cluster_alloc_swap_entry(si, order, SWAP_HAS_CACHE);
+			cluster_alloc_swap_entry(si, folio);
 			put_swap_device(si);
-			if (offset) {
-				*entry = swp_entry(si->type, offset);
-				return true;
-			}
-			if (order)
-				return false;
+			if (folio_test_swapcache(folio))
+				return;
+			if (folio_test_large(folio))
+				return;
 		}
 
 		spin_lock(&swap_avail_lock);
@@ -1382,7 +1393,6 @@ static bool swap_alloc_slow(swp_entry_t *entry,
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
-	return false;
 }
 
 /*
@@ -1425,7 +1435,6 @@ int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
-	swp_entry_t entry = {};
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
@@ -1450,39 +1459,23 @@ int folio_alloc_swap(struct folio *folio)
 
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
@@ -1781,29 +1774,6 @@ static void swap_entries_free(struct swap_info_struct *si,
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
@@ -2054,7 +2024,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 			 * with swap table allocation.
 			 */
 			local_lock(&percpu_swap_cluster.lock);
-			offset = cluster_alloc_swap_entry(si, 0, 1);
+			offset = cluster_alloc_swap_entry(si, NULL);
 			local_unlock(&percpu_swap_cluster.lock);
 			if (offset)
 				entry = swp_entry(si->type, offset);

-- 
2.51.2


