Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23979E66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C32E6B0096; Fri, 19 Dec 2025 14:44:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8775F6B0098; Fri, 19 Dec 2025 14:44:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4036B0099; Fri, 19 Dec 2025 14:44:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A2F26B0096
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:44:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D83C160158
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:58 +0000 (UTC)
X-FDA: 84237248676.28.C1A906B
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 31C7240004
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LJ0I0dpd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173496; a=rsa-sha256;
	cv=none;
	b=UOhynh1jznlHfOYuBY9GXfx1rxXx2wM7sHgrNmJF7p+VTXUUM7KLe0rzmOqJMwJhSYV6Kb
	wQg6R6fGHNee4lykNlcM+VwowAJG+IUqOuZAa6Mp8yFuvwsna9yY0DcJYXlWyrcsdBs+EA
	CpGRDaywdez7A6VDwSM4YyvM/WIA3kI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LJ0I0dpd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2dPOaaOJ2TQSWYXjPLzkHtEJKqmOi8KzZJUw0xmP+Hk=;
	b=0U7NKNHaxR+FlCUG79ebpLAPAtE+g/vRB0yXghsELZ5z2auwxHHahpCxq5S+KVEyGL11dT
	Hm1m4Ibq4PFuK2cQj7zLS6PaCC8JuqO903Z/Pft+ncAvvwSD/mMBR2dcxUDkEY0XvDSqtm
	74dmuzdsJXXAj98y+QxR9GVia10oNDc=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a0834769f0so20523935ad.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173495; x=1766778295; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2dPOaaOJ2TQSWYXjPLzkHtEJKqmOi8KzZJUw0xmP+Hk=;
        b=LJ0I0dpdT0T2ehvZtKCCnQ+KezWI87HLV005GpsHruv6SGZJeqEqjguKHJDLX3Z/VM
         Cd0/qoBmTc5FWIUZQyU+YdYoLJVBaSDllCVM5W2eHEHESidC7fZpDkcgmcFkILL49Ptw
         FURYgljcGQmG8BfOsK+Y4sTRNiab7MutAgPSTQKVHyq8km5+orslwJx4OBNn1U0UaHm+
         OrE8gHS0bF8TjxgJ3HMsZ1eFbw94pC8up5yowfjBhUF5HCCPBQDcZsZLPURNaCQcHkuS
         YEkdEHSrHl/H+2d9gNRDZr1E4CxABcF0xH1BHK4zA5+7Ir4jxF1whflLdYIgcgs8CxT3
         bCxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173495; x=1766778295;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2dPOaaOJ2TQSWYXjPLzkHtEJKqmOi8KzZJUw0xmP+Hk=;
        b=ORx6i0oWIOkT+KSDuJqtkybCZ8m/UkCvVp+UnTyRX1+bE7St2NCuwlmo0nxfOuIQbS
         rZxdInZ9AYxH9xNxSuqozBSgJqsZtT2/FdYk92rzfKQQrGNilg4T3sxFv75NPfTl8Z9s
         rq7vpc7ovy+udZ5wejBHjI4BKSKNQ1ucWFFu8ldhotMFrUMtH+KEcB5ElA4KCmGO6r/j
         WE6qnqVUoHlMhnnM0jKA8e+I3Cm5xfKmz9Kprv75vCf/8xyMMePOXmBs8PzCQuVuUSZS
         pAMEnT+dB9Tqq9VgNcM6k2Qe/o5gD/q1cYVbFbLFF2evIHd242ciZ37y33fOHnfIDvXG
         QJTQ==
X-Gm-Message-State: AOJu0YzmAR71Z8f+gzUjGqAfRJzxcxbp5QPiEfvp8HX/Ui/ZUpzsor5F
	shDI06YsC5dub+hZwVV/kH6I1unFJRDLnNKEvWc2jAjd52/BJ5O+BUAH
X-Gm-Gg: AY/fxX6BAdssxCjvQayVTBbHitlhYKh1EFYYd/UcULcTLMu0Lf3avxsOvzR/87WRtLI
	iQmYjTvcSx/IO1yiL+cSJNGKttVLSCgjp1V11asT/hMrS9JMlzD4IQBwNN+16ZHGT5HANuRY+0l
	rY2qpGsgVOx9zx93K/2bSZac3FbnJWwylZ4Tvx+3D+20EttWlhD0LUGTKK1+l7sSORO7TWudXy2
	7iFLR7gsjO8IT6LPYL2P4Bz3coBqPPGaiPNlPtKlZOPV9Xoarfwc8WfGErm36sGTRXfHVZn+GKZ
	ikODSCg1wbX+H0uDXBt+iamzf4AdKte2pFg6teEO4ieq/lm5vgnG/vFGVzp2ckw//WRMFqB6YFb
	6+jK+GijxwxL6thO4EMrUNq0RY10yuMNUys/tIUGPrk7vPSZkn3fASt5Zyd4ZB7w2nHbIPN2QpN
	ioerh1ch2AhDB2K2caPNFh35cB8MaQDgsrw2dt6JP/P5ht3/mMA4ONZC3GzQfSDTM=
X-Google-Smtp-Source: AGHT+IE4dkzSppOt3tHGWCnWXkosxODEpLg9AmqyJsLq4gVhbtsrGH39aXgfltGk3xyFoNlZwzd48w==
X-Received: by 2002:a17:902:ef52:b0:2a0:dabc:1383 with SMTP id d9443c01a7336-2a2f22234a1mr44134155ad.14.1766173494957;
        Fri, 19 Dec 2025 11:44:54 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:44:54 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:37 +0800
Subject: [PATCH v5 08/19] mm/shmem, swap: remove SWAP_MAP_SHMEM
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-8-8862a265a033@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=7240;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=JUOvtAP1dKiH1CMj9+4csv5/DFFUtuyY45QPHt+u/IE=;
 b=8Jn84cPjQ22CkwioQYmAbl/Yn1agcuCqkgakUWKAtfNfnUYO4P3hs7B2jD8IdxX2p72W98ogA
 i5Nuo+l6LCbDAysmgOoza5guwPPrK0mCtHVeysaL6aklklSSnaHnS1h
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 31C7240004
X-Stat-Signature: r3fdobdr5x6qjd4mujacf4eoui9k5t53
X-Rspam-User: 
X-HE-Tag: 1766173495-63531
X-HE-Meta: U2FsdGVkX1+yxfeXo7iTLoPTP5KxusnOrToJO1GhBSCI9j4ylPNw6HLqalNOwmMKBiO93JvM34NtfhSRiOiUfoDbVMVjWUQrDSuxygd/1I66OkfD4FLS6oj67qYlS9ZSPRAaOeif4dhnwbfjCFpd9ZTysdGw2/FpRpne8DHn05jYg65bzOyTqj+EBEUPc/sqKmfITsfcz+s4peNo3GBpcquBTpSmKoWWABhAB4Am1WhPfsg0Y78yOVZnWeFXdi7hEA0LF8XLghFaiveJeUJiw16LfVazQRKSpLe0QgUXe37fYF2Go7hK2K/Bnr1nRBQe5LYYEbOsK2N+oJZjWpxOVgIQkU7ZkoOSNxH5gZgGsHKOyaTvbNjHYeSeDUe9nzgD8gTHYihodgDdME/1VrIieTN0/ef0+RdYjCa0HZcG8+143f6TGEZXu81JS6lMczXeTle9hDVujCIzpXDq/5YN+N/aXVrdmFDdN99dRXXzL/SDEM4YxJ5Q40Th7teA3d1eKGoo6kHiMXIL60AvK383GN5QztYKq/B6Zk7Zo/Z9J4P4x6GPNV3f40WI27HroHRF7Vt2wIpO3tP4NocB56AO1HiFFxnJRH520TL148E79Z9zM7Ie29M43QiQXm7wDQOHE/IDeD/hAFCtVWwN1qSLd33/VR0f4y6gymTFC7iHg4FHnfJd0BHxZzLMl8uXytTLvS/WG7lML1aEtYhRNtkMAKXUF8/2MZRB+z5LKAfHOq8mdZsbJSSazl75wEjP8qWBnzk+epetK8i51P4ZGPrEuhBfGRy7T4vEf83vos+SOzlhHOjNo6SrJE7Xw6DawZWMmbN8PR54E6bbFqtwCpz6mASGvpb2NxEqH4QeXPOAokXsaAVyNKmsBLOEZy0Q95xBs1gJ4bCrM4kE11xknN/jb5P9FCNEf7XA9Hm0icA+RDSl1X9k/5fNXUT02cZN0AWB8K0NcrxWZImYwsBi388
 Vt3t2K6z
 qZtK5yHpXg4rwI/iOGSAabXWLCxxLeSxHl/7JPkfsYTQs6dFZgONfctEUcjwF+O3X0anhbhXcPZdJflgGc9R9aMeBJ8A3F/OgUf891uV1R1lePdbbK+eSDIn6mmMr1zTb+8Qjwgx8W3DGkY41vUvCTX7c+nX1k5OHcBGa978Cy5/JUZWC8KWLC8PwxwOUm62270ZVp36XhXxVGaQKnXjwj/Y+fJaPXl3ormxerIxd9M3RlUWnn7LXqdcqPEUgkrLDYQPXMNSJrRwIthICig+JY+qlI4a58J6drJOgV/SPGAGRbNgFmwUUi26C4v9rXe9DAZqHb2SK85LC7SQrPF/0UBwLW0GXlEAzP8tEO+tc3R8Cn7xtfYo+bZbQr3PKD5r/+QrgACxdOAiqej6OkBU4roZZK23sx6gAhnDb6SH3KogVznnpjnqz8EahyoFoEna8nae//C/JClQcHuZpimDynLDLTB3rihwXQO3h+pcE9EX6pLQUMQ0/fy4zpC1Hixf5KMIIP91P1nJNiECS8j3ymNsgK0qYgerwejgnzSqwOvD7IEO3MNOmH6EyoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nhat Pham <nphamcs@gmail.com>

The SWAP_MAP_SHMEM state was introduced in the commit aaa468653b4a
("swap_info: note SWAP_MAP_SHMEM"), to quickly determine if a swap entry
belongs to shmem during swapoff.

However, swapoff has since been rewritten in the commit b56a2d8af914
("mm: rid swapoff of quadratic complexity"). Now having swap count ==
SWAP_MAP_SHMEM value is basically the same as having swap count == 1,
and swap_shmem_alloc() behaves analogously to swap_duplicate(). The only
difference of note is that swap_shmem_alloc() does not check for
-ENOMEM returned from __swap_duplicate(), but it is OK because shmem
never re-duplicates any swap entry it owns. This will stil be safe if we
use (batched) swap_duplicate() instead.

This commit adds swap_duplicate_nr(), the batched variant of
swap_duplicate(), and removes the SWAP_MAP_SHMEM state and the
associated swap_shmem_alloc() helper to simplify the state machine (both
mentally and in terms of actual code). We will also have an extra
state/special value that can be repurposed (for swap entries that never
gets re-duplicated).

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h | 15 +++++++--------
 mm/shmem.c           |  2 +-
 mm/swapfile.c        | 42 +++++++++++++++++-------------------------
 3 files changed, 25 insertions(+), 34 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 38ca3df68716..bf72b548a96d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -230,7 +230,6 @@ enum {
 /* Special value in first swap_map */
 #define SWAP_MAP_MAX	0x3e	/* Max count */
 #define SWAP_MAP_BAD	0x3f	/* Note page is bad */
-#define SWAP_MAP_SHMEM	0xbf	/* Owned by shmem/tmpfs */
 
 /* Special value in each swap_map continuation */
 #define SWAP_CONT_MAX	0x7f	/* Max count */
@@ -458,8 +457,7 @@ bool folio_free_swap(struct folio *folio);
 void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
-extern void swap_shmem_alloc(swp_entry_t, int);
-extern int swap_duplicate(swp_entry_t);
+extern int swap_duplicate_nr(swp_entry_t entry, int nr);
 extern int swapcache_prepare(swp_entry_t entry, int nr);
 extern void swap_free_nr(swp_entry_t entry, int nr_pages);
 extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
@@ -514,11 +512,7 @@ static inline int add_swap_count_continuation(swp_entry_t swp, gfp_t gfp_mask)
 	return 0;
 }
 
-static inline void swap_shmem_alloc(swp_entry_t swp, int nr)
-{
-}
-
-static inline int swap_duplicate(swp_entry_t swp)
+static inline int swap_duplicate_nr(swp_entry_t swp, int nr_pages)
 {
 	return 0;
 }
@@ -569,6 +563,11 @@ static inline int add_swap_extent(struct swap_info_struct *sis,
 }
 #endif /* CONFIG_SWAP */
 
+static inline int swap_duplicate(swp_entry_t entry)
+{
+	return swap_duplicate_nr(entry, 1);
+}
+
 static inline void free_swap_and_cache(swp_entry_t entry)
 {
 	free_swap_and_cache_nr(entry, 1);
diff --git a/mm/shmem.c b/mm/shmem.c
index d7eeeaa9580d..e36330cdd066 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1667,7 +1667,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
-		swap_shmem_alloc(folio->swap, nr_pages);
+		swap_duplicate_nr(folio->swap, nr_pages);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3762b8f3f9e9..e23287c06f1c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -201,7 +201,7 @@ static bool swap_is_last_map(struct swap_info_struct *si,
 	unsigned char *map_end = map + nr_pages;
 	unsigned char count = *map;
 
-	if (swap_count(count) != 1 && swap_count(count) != SWAP_MAP_SHMEM)
+	if (swap_count(count) != 1)
 		return false;
 
 	while (++map < map_end) {
@@ -1523,12 +1523,6 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
 	if (usage == SWAP_HAS_CACHE) {
 		VM_BUG_ON(!has_cache);
 		has_cache = 0;
-	} else if (count == SWAP_MAP_SHMEM) {
-		/*
-		 * Or we could insist on shmem.c using a special
-		 * swap_shmem_free() and free_shmem_swap_and_cache()...
-		 */
-		count = 0;
 	} else if ((count & ~COUNT_CONTINUED) <= SWAP_MAP_MAX) {
 		if (count == COUNT_CONTINUED) {
 			if (swap_count_continued(si, offset, count))
@@ -1626,7 +1620,7 @@ static bool swap_entries_put_map(struct swap_info_struct *si,
 	if (nr <= 1)
 		goto fallback;
 	count = swap_count(data_race(si->swap_map[offset]));
-	if (count != 1 && count != SWAP_MAP_SHMEM)
+	if (count != 1)
 		goto fallback;
 
 	ci = swap_cluster_lock(si, offset);
@@ -1680,12 +1674,10 @@ static bool swap_entries_put_map_nr(struct swap_info_struct *si,
 
 /*
  * Check if it's the last ref of swap entry in the freeing path.
- * Qualified value includes 1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM.
  */
 static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
 {
-	return (count == SWAP_HAS_CACHE) || (count == 1) ||
-	       (count == SWAP_MAP_SHMEM);
+	return (count == SWAP_HAS_CACHE) || (count == 1);
 }
 
 /*
@@ -3678,7 +3670,6 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 
 	offset = swp_offset(entry);
 	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
-	VM_WARN_ON(usage == 1 && nr > 1);
 	ci = swap_cluster_lock(si, offset);
 
 	err = 0;
@@ -3738,27 +3729,28 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 	return err;
 }
 
-/*
- * Help swapoff by noting that swap entry belongs to shmem/tmpfs
- * (in which case its reference count is never incremented).
- */
-void swap_shmem_alloc(swp_entry_t entry, int nr)
-{
-	__swap_duplicate(entry, SWAP_MAP_SHMEM, nr);
-}
-
-/*
- * Increase reference count of swap entry by 1.
+/**
+ * swap_duplicate_nr() - Increase reference count of nr contiguous swap entries
+ *                       by 1.
+ *
+ * @entry: first swap entry from which we want to increase the refcount.
+ * @nr: Number of entries in range.
+ *
  * Returns 0 for success, or -ENOMEM if a swap_count_continuation is required
  * but could not be atomically allocated.  Returns 0, just as if it succeeded,
  * if __swap_duplicate() fails for another reason (-EINVAL or -ENOENT), which
  * might occur if a page table entry has got corrupted.
+ *
+ * Note that we are currently not handling the case where nr > 1 and we need to
+ * add swap count continuation. This is OK, because no such user exists - shmem
+ * is the only user that can pass nr > 1, and it never re-duplicates any swap
+ * entry it owns.
  */
-int swap_duplicate(swp_entry_t entry)
+int swap_duplicate_nr(swp_entry_t entry, int nr)
 {
 	int err = 0;
 
-	while (!err && __swap_duplicate(entry, 1, 1) == -ENOMEM)
+	while (!err && __swap_duplicate(entry, 1, nr) == -ENOMEM)
 		err = add_swap_count_continuation(entry, GFP_ATOMIC);
 	return err;
 }

-- 
2.52.0


