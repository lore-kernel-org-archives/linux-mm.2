Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DBBCCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 16:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C29E8E00A5; Wed, 29 Oct 2025 12:00:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89AA38E0045; Wed, 29 Oct 2025 12:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0728E00A5; Wed, 29 Oct 2025 12:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6106D8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:00:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FC4413BE8A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:00:28 +0000 (UTC)
X-FDA: 84051614136.23.7BDAB8B
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3F366C001C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:00:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SRAqxITe;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=js7VbMzO/PyCsGbnIWOZ2XRn9F05cVP9JsAjpW1ZYIc=;
	b=wRyn7rt6AIdtcRwrHAE3K17wSpklYRPyoahWORogNnlHsi4+oWnm72sGIwPlDvpxSNZiwd
	tGt11rgG00vwKKlbs43kx+xTrOuWcDmMZa3WG1kqvmYCGs+U1EJ00zEP4uZLnUfJQAieO7
	w6KuD9a7udEus42KabMTxGdFBoSmMtU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SRAqxITe;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753626; a=rsa-sha256;
	cv=none;
	b=ogpO57AVzWPFTy2MbZlGEL4zUcFdAu0yYt3GZdrhnivhrTn9gMwjwdrLwd3H43dL2SwCrK
	nTiPn1CvxgZ7fdqLBXAfFtVeFyfBZV4128hJiQrGI05O6AJGXgsp48x8+Hce9cIm29Mvri
	rN3s7I1Eq7r4aZBMRCzWIokesllFpgM=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-33f9aec69b6so39187a91.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753625; x=1762358425; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=js7VbMzO/PyCsGbnIWOZ2XRn9F05cVP9JsAjpW1ZYIc=;
        b=SRAqxITeVjkIwt0VYCHnWA7GawEX4EicsR7DeWg91gr54uZWIO3MQO8ocAp0ZydjmH
         T/8zGjUxTqxnv2XrXEFFn+8HIG5KbwXwWHx0qzCqirumz2EVnwuLxahOuj5h+l3WuJJM
         K9FjNMNxzWNS9jYB9SVW0AVkSHRkrEDBvBSUBk6m/wwuTlm3vKlfQ9lpFV3ZcvJilzNj
         BuOhzVupoIkfdjM5dWeVfB8R8CKfLWqgl4R5hE6RKCybqOOcMq/u0Ic3iSeD6XhUZGjM
         wNP6DsPw72I77vzRUqGZ7Yza/e9Zib8cHW/WpGVAuwJH8zP1/u5cs3C2POOS4HR1SZTv
         9nOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753625; x=1762358425;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=js7VbMzO/PyCsGbnIWOZ2XRn9F05cVP9JsAjpW1ZYIc=;
        b=tw57IkWBSBt3HXoi4XWe+jH3lRUysMYieQa2jsdu01BVaw++YOccqKFONgfrVUOtLB
         CAdSHcwPZXoIQl+CHevNq9CqAMzEKMVIjzhNGgpHPyJgd394q8/X5054C+z7uTbleSa8
         ARJmaQJOMimYsTZCeiV8WlgbbKT+C6KHy1va0BrrvQFg1Ybrbd/6Fmyj6t8k7F5pfHN/
         u8X2EPgVJTBzw+m5rkNbPq3V6p02m983/Mz0GmLOl0wcU9VTov66/E/JrpMrihQOSL+A
         Fv3uTonHWds0ADbfvVfllJLxzINGI66+yfTh/qAYERx2zwFUuHbhjg6NMJOgGGKpbJiK
         5uJg==
X-Gm-Message-State: AOJu0Yz78o+O1FKxSo4hc2xHNPZSSs+QfgIG42G+Fskjr7jG99wPIDiL
	sxOFew8l91xeuoVCoB88rVQ/3dywjyAwkybD1MurHcg3JqA4Z0nPqOD1
X-Gm-Gg: ASbGncthUVd86BGSL9D5IA14CnAR0BILL0dIyQYMTvrk4yh+AGvHszEtDCvxyL/7JUQ
	uk46sCuC8Ft/U9jgScUT3zeqdUuq4x0NwcSBSZAtx8S9jJPfF+AMt2kS6KSRBtO7J9qmVp6DMEt
	nf5xnjrmzjY3Q1Vn2L7F3NvHpJbUmOIv/Ma12ygToaofs3Gbbeg+8L4Qf6MbZdaNMlpB90vdp58
	2da1joxOXH/NPbdROkxsUVtCDb1ItvmC6L1Xc48ioJ6AohTkAr5jkdI8N3Emy3/2CelqiElPbVd
	CUYAXyZQd0PvNEcX5MUtm4QZb3O14MbfoAN2X9mUfAYxghwGm3dohSdXgTJNW8Mgib2Kmz+fXVM
	f54PnYpWGBoW+LQLCHoAkyfGQz5zb/V2Cvl9MU/ndf+Ayu+NI9mbeHg1sC91Z/vNfWd+wigFW16
	DoDp+kN+mWu7+XxFjwEa/L
X-Google-Smtp-Source: AGHT+IGWCQLviFcQvcj4hei5TQb5babvs+IdShmaI91V27dhBK786K4d+NOP4MaEXVIILQVw35I/iA==
X-Received: by 2002:a17:90b:4f44:b0:32d:90c7:c63b with SMTP id 98e67ed59e1d1-3403a2f218amr3958243a91.30.1761753624639;
        Wed, 29 Oct 2025 09:00:24 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.09.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 09:00:23 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:44 +0800
Subject: [PATCH 18/19] mm, swap: drop the SWAP_HAS_CACHE flag
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-18-3d43f3b6ec32@tencent.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3F366C001C
X-Stat-Signature: ab7e6zxshx9x6k8scd6fcu1t9qtamomj
X-Rspam-User: 
X-HE-Tag: 1761753626-160183
X-HE-Meta: U2FsdGVkX1/J5fzPZt3dDInNVIHk9M31H9nwx3EXMPXXY7Ei0bmbBX3oFiLhYpWlvwwt6gUjJ2Pq5tOk9rLTuzxNItyeuU2D5oBVAFgHeTi8vDaKe1DYbQES5hImLbyLx37zSG7ccCSVNDMB05oM/pX5vhdV/c1HlCrrbQbJU+okv9jdxPDJVnUNUkmNAvD+zJ6ZOiwvQ3CYcAr6r5O6Osxe6HvAOpiKiEaU1TuKwloLrBwnxQCOcipGdG0Z3qqUDjun+ES71WYUh1cunLwZye7ttSddh01MfeB468MPgSvTh8Kp7mGmy+ar4ns/Ov26njYSeZGlxk+HBu4l2WMk3d7C2Fnax5VqQ7qoWSDjlhn71+vjr6+PMaUDAyP0FRazxsQV3205WzL2CKEr7B+lxpHvDFt7lam6GLXjweX8uRcfyD0yZPRtOzGRK2Nk2QAKbBx0dZw0FZFv5+o7dbydsumUNGpxnmTFK47lXSG0CDyF1zuAtSjYegWbtZZcDBr0+GTq6fNTjrvbXs6uz08ZeGUNjiz8efn6s2P8EK9tv1ij6kiaoOMuffHmZMS6NTaxfMM1d1wd94UlSVIAP4Gms188fw57abTtOMOjDxjtjyWWZfSZRaB9/7bgkvpDXWAlnAmuSI5TPaMcWg/11jLGgI3mjTdL9hGabSMCVO8DiUQAAVjdBiyzxP3V1MUVoC0GJRBOxe8mayXukAc6wuHDkA+OvS94zxlweOXUXSFqOYoTQvl2dt5eFSyjMy32stlO8fxQEHjfRTKjUDkITDKusi6zDy+7GY0/ET7qib5uwv46aodX7eJB2PZh6JL/vz7N8YUSGFX6bT1/d99aFihRLGAtZ7vrgZb58+h5IZ7Sx8AU9xLEf/BB5dR1TCzVlZOBPUVyXdGO6TU+RdlEkUauzG4jVs0cVxs+YhuMEPHEpbh2nO9f3Qmv4uyC2Gq0plKz45cjt5qucYji4rf3QVb
 0agevH6+
 4fjs7Deu+ROVS/MiJxkXjznnT12DAQKqUuJ/nkgmSGWb/Hu2wEYl4EF9K9dcYwU43P3ULHOYYPX1ccRA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now, the swap cache is managed by the swap table. All swap cache users
are checking the swap table directly to check the swap cache state.
SWAP_HAS_CACHE is now just a temporary pin before the first increase
from 0 to 1 of a slot's swap count (swap_dup_entries), or before the
final free of slots pinned by folio in swap cache (put_swap_folio).

Drop these two usages. For the first dup, SWAP_HAS_CACHE pinning was
hard to kill because it used to have multiple meanings, more than just
"a slot is cached". We have simplified that and just defined that the
first dup is always done with folio locked in swap cache (folio_dup_swap),
so it can just check the swap cache (swap table) directly.

As for freeing, just let the swap cache free all swap entries of a folio
that have a swap count of zero directly upon folio removal. We have also
just cleaned up freeing to cover the swap cache usage in the swap table,
a slot with swap cache will not be freed until its cache is gone.
Now, making the removal of a folio and freeing the slots being done in
the same critical section, this should improve the performance and gets
rid of the SWAP_HAS_CACHE pin.

After these two changes, SWAP_HAS_CACHE no longer has any users. Remove
all related logic and helpers. swap_map is now only used for tracking
the count, so all swap_map users can just need to read it directly,
ignoring the swap_count helper, which was previously used to filter out
the SWAP_HAS_CACHE bit.

The idea of dropping SWAP_HAS_CACHE and using the swap table directly
was initially from Chris's idea of merging all the metadata usage of all
swaps into one place.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |   1 -
 mm/swap.h            |  13 ++--
 mm/swap_state.c      |  28 +++++----
 mm/swapfile.c        | 163 ++++++++++++++++-----------------------------------
 4 files changed, 71 insertions(+), 134 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4b4b81fbc6a3..dcb1760e36c3 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -224,7 +224,6 @@ enum {
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
 /* Bit flag in swap_map */
-#define SWAP_HAS_CACHE	0x40	/* Flag page is cached, in first swap_map */
 #define COUNT_CONTINUED	0x80	/* Flag swap_map continuation for full count */
 
 /* Special value in first swap_map */
diff --git a/mm/swap.h b/mm/swap.h
index 73f07bcea5f0..331424366487 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -205,6 +205,11 @@ int folio_alloc_swap(struct folio *folio);
 int folio_dup_swap(struct folio *folio, struct page *subpage);
 void folio_put_swap(struct folio *folio, struct page *subpage);
 
+/* For internal use */
+extern void swap_entries_free(struct swap_info_struct *si,
+			      struct swap_cluster_info *ci,
+			      unsigned long offset, unsigned int nr_pages);
+
 /* linux/mm/page_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
@@ -256,14 +261,6 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
 	return folio_entry.val == round_down(entry.val, nr_pages);
 }
 
-/* Temporary internal helpers */
-void __swapcache_set_cached(struct swap_info_struct *si,
-			    struct swap_cluster_info *ci,
-			    swp_entry_t entry);
-void __swapcache_clear_cached(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      swp_entry_t entry, unsigned int nr);
-
 /*
  * All swap cache helpers below require the caller to ensure the swap entries
  * used are valid and stablize the device by any of the following ways:
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 41d4fa056203..2bf72d58f6ee 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -215,17 +215,6 @@ static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 			shadow = swp_tb_to_shadow(old_tb);
 		offset++;
 	} while (++ci_off < ci_end);
-
-	ci_off = ci_start;
-	offset = swp_offset(entry);
-	do {
-		/*
-		 * Still need to pin the slots with SWAP_HAS_CACHE since
-		 * swap allocator depends on that.
-		 */
-		__swapcache_set_cached(si, ci, swp_entry(swp_type(entry), offset));
-		offset++;
-	} while (++ci_off < ci_end);
 	__swap_cache_add_folio(ci, folio, entry);
 	swap_cluster_unlock(ci);
 	if (shadowp)
@@ -256,6 +245,7 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 	struct swap_info_struct *si;
 	unsigned long old_tb, new_tb;
 	unsigned int ci_start, ci_off, ci_end;
+	bool folio_swapped = false, need_free = false;
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	VM_WARN_ON_ONCE(__swap_entry_to_cluster(entry) != ci);
@@ -273,13 +263,27 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 		old_tb = __swap_table_xchg(ci, ci_off, new_tb);
 		WARN_ON_ONCE(!swp_tb_is_folio(old_tb) ||
 			     swp_tb_to_folio(old_tb) != folio);
+		if (__swap_count(swp_entry(si->type,
+				 swp_offset(entry) + ci_off - ci_start)))
+			folio_swapped = true;
+		else
+			need_free = true;
 	} while (++ci_off < ci_end);
 
 	folio->swap.val = 0;
 	folio_clear_swapcache(folio);
 	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
-	__swapcache_clear_cached(si, ci, entry, nr_pages);
+
+	if (!folio_swapped) {
+		swap_entries_free(si, ci, swp_offset(entry), nr_pages);
+	} else if (need_free) {
+		do {
+			if (!__swap_count(entry))
+				swap_entries_free(si, ci, swp_offset(entry), 1);
+			entry.val++;
+		} while (--nr_pages);
+	}
 }
 
 /**
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 12a1ab6f7b32..49916fdb8b70 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -48,21 +48,18 @@
 #include <linux/swap_cgroup.h>
 #include "swap_table.h"
 #include "internal.h"
+#include "swap_table.h"
 #include "swap.h"
 
 static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
 				 unsigned char);
 static void free_swap_count_continuations(struct swap_info_struct *);
-static void swap_entries_free(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      unsigned long start, unsigned int nr_pages);
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr);
 static void swap_put_entry_locked(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
-				  unsigned long offset,
-				  unsigned char usage);
+				  unsigned long offset);
 static bool folio_swapcache_freeable(struct folio *folio);
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
@@ -149,11 +146,6 @@ static struct swap_info_struct *swap_entry_to_info(swp_entry_t entry)
 	return swap_type_to_info(swp_type(entry));
 }
 
-static inline unsigned char swap_count(unsigned char ent)
-{
-	return ent & ~SWAP_HAS_CACHE;	/* may include COUNT_CONTINUED flag */
-}
-
 /*
  * Use the second highest bit of inuse_pages counter as the indicator
  * if one swap device is on the available plist, so the atomic can
@@ -185,15 +177,20 @@ static long swap_usage_in_pages(struct swap_info_struct *si)
 #define TTRS_FULL		0x4
 
 static bool swap_only_has_cache(struct swap_info_struct *si,
-			      unsigned long offset, int nr_pages)
+				struct swap_cluster_info *ci,
+				unsigned long offset, int nr_pages)
 {
+	unsigned int ci_off = offset % SWAPFILE_CLUSTER;
 	unsigned char *map = si->swap_map + offset;
 	unsigned char *map_end = map + nr_pages;
+	unsigned long swp_tb;
 
 	do {
-		VM_BUG_ON(!(*map & SWAP_HAS_CACHE));
-		if (*map != SWAP_HAS_CACHE)
+		swp_tb = __swap_table_get(ci, ci_off);
+		VM_WARN_ON_ONCE(!swp_tb_is_folio(swp_tb));
+		if (*map)
 			return false;
+		++ci_off;
 	} while (++map < map_end);
 
 	return true;
@@ -254,7 +251,7 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	 * reference or pending writeback, and can't be allocated to others.
 	 */
 	ci = swap_cluster_lock(si, offset);
-	need_reclaim = swap_only_has_cache(si, offset, nr_pages);
+	need_reclaim = swap_only_has_cache(si, ci, offset, nr_pages);
 	swap_cluster_unlock(ci);
 	if (!need_reclaim)
 		goto out_unlock;
@@ -775,7 +772,7 @@ static unsigned int cluster_reclaim_range(struct swap_info_struct *si,
 
 	spin_unlock(&ci->lock);
 	do {
-		if (swap_count(READ_ONCE(map[offset])))
+		if (READ_ONCE(map[offset]))
 			break;
 		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
 		if (swp_tb_is_folio(swp_tb)) {
@@ -800,7 +797,7 @@ static unsigned int cluster_reclaim_range(struct swap_info_struct *si,
 	 */
 	for (offset = start; offset < end; offset++) {
 		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
-		if (swap_count(map[offset]) || !swp_tb_is_null(swp_tb))
+		if (map[offset] || !swp_tb_is_null(swp_tb))
 			return SWAP_ENTRY_INVALID;
 	}
 
@@ -820,11 +817,10 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 		return true;
 
 	do {
-		if (swap_count(map[offset]))
+		if (map[offset])
 			return false;
 		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
 		if (swp_tb_is_folio(swp_tb)) {
-			WARN_ON_ONCE(!(map[offset] & SWAP_HAS_CACHE));
 			if (!vm_swap_full())
 				return false;
 			*need_reclaim = true;
@@ -882,11 +878,6 @@ static bool cluster_alloc_range(struct swap_info_struct *si,
 	if (likely(folio)) {
 		order = folio_order(folio);
 		nr_pages = 1 << order;
-		/*
-		 * Pin the slot with SWAP_HAS_CACHE to satisfy swap_dup_entries.
-		 * This is the legacy allocation behavior, will drop it very soon.
-		 */
-		memset(si->swap_map + offset, SWAP_HAS_CACHE, nr_pages);
 		__swap_cache_add_folio(ci, folio, swp_entry(si->type, offset));
 	} else {
 		order = 0;
@@ -995,8 +986,8 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		to_scan--;
 
 		while (offset < end) {
-			if (!swap_count(READ_ONCE(map[offset])) &&
-			    swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER))) {
+			if (!READ_ONCE(map[offset]) &&
+			    swp_tb_is_folio(swap_table_get(ci, offset % SWAPFILE_CLUSTER))) {
 				spin_unlock(&ci->lock);
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
 								   TTRS_ANYWAY);
@@ -1431,8 +1422,8 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 	do {
 		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
 		count = si->swap_map[offset];
-		VM_WARN_ON(swap_count(count) < 1 || count == SWAP_MAP_BAD);
-		if (swap_count(count) == 1) {
+		VM_WARN_ON(count < 1 || count == SWAP_MAP_BAD);
+		if (count == 1) {
 			/* count == 1 and non-cached slots will be batch freed. */
 			if (!swp_tb_is_folio(swp_tb)) {
 				if (!batch_start)
@@ -1440,7 +1431,6 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 				continue;
 			}
 			/* count will be 0 after put, slot can be reclaimed */
-			VM_WARN_ON(!(count & SWAP_HAS_CACHE));
 			need_reclaim = true;
 		}
 		/*
@@ -1449,7 +1439,7 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 		 * slots will be freed when folio is removed from swap cache
 		 * (__swap_cache_del_folio).
 		 */
-		swap_put_entry_locked(si, ci, offset, 1);
+		swap_put_entry_locked(si, ci, offset);
 		if (batch_start) {
 			swap_entries_free(si, ci, batch_start, offset - batch_start);
 			batch_start = SWAP_ENTRY_INVALID;
@@ -1602,13 +1592,8 @@ static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 	offset = swp_offset(entry);
 	if (offset >= si->max)
 		goto bad_offset;
-	if (data_race(!si->swap_map[swp_offset(entry)]))
-		goto bad_free;
 	return si;
 
-bad_free:
-	pr_err("%s: %s%08lx\n", __func__, Unused_offset, entry.val);
-	goto out;
 bad_offset:
 	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	goto out;
@@ -1623,21 +1608,12 @@ static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 
 static void swap_put_entry_locked(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
-				  unsigned long offset,
-				  unsigned char usage)
+				  unsigned long offset)
 {
 	unsigned char count;
-	unsigned char has_cache;
 
 	count = si->swap_map[offset];
-
-	has_cache = count & SWAP_HAS_CACHE;
-	count &= ~SWAP_HAS_CACHE;
-
-	if (usage == SWAP_HAS_CACHE) {
-		VM_BUG_ON(!has_cache);
-		has_cache = 0;
-	} else if ((count & ~COUNT_CONTINUED) <= SWAP_MAP_MAX) {
+	if ((count & ~COUNT_CONTINUED) <= SWAP_MAP_MAX) {
 		if (count == COUNT_CONTINUED) {
 			if (swap_count_continued(si, offset, count))
 				count = SWAP_MAP_MAX | COUNT_CONTINUED;
@@ -1647,10 +1623,8 @@ static void swap_put_entry_locked(struct swap_info_struct *si,
 			count--;
 	}
 
-	usage = count | has_cache;
-	if (usage)
-		WRITE_ONCE(si->swap_map[offset], usage);
-	else
+	WRITE_ONCE(si->swap_map[offset], count);
+	if (!count && !swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)))
 		swap_entries_free(si, ci, offset, 1);
 }
 
@@ -1719,21 +1693,13 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 }
 
-/*
- * Check if it's the last ref of swap entry in the freeing path.
- */
-static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
-{
-	return (count == SWAP_HAS_CACHE) || (count == 1);
-}
-
 /*
  * Drop the last ref of swap entries, caller have to ensure all entries
  * belong to the same cgroup and cluster.
  */
-static void swap_entries_free(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      unsigned long offset, unsigned int nr_pages)
+void swap_entries_free(struct swap_info_struct *si,
+		       struct swap_cluster_info *ci,
+		       unsigned long offset, unsigned int nr_pages)
 {
 	swp_entry_t entry = swp_entry(si->type, offset);
 	unsigned char *map = si->swap_map + offset;
@@ -1746,7 +1712,7 @@ static void swap_entries_free(struct swap_info_struct *si,
 
 	ci->count -= nr_pages;
 	do {
-		VM_BUG_ON(!swap_is_last_ref(*map));
+		VM_WARN_ON(*map > 1);
 		*map = 0;
 	} while (++map < map_end);
 
@@ -1765,7 +1731,7 @@ int __swap_count(swp_entry_t entry)
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	pgoff_t offset = swp_offset(entry);
 
-	return swap_count(si->swap_map[offset]);
+	return si->swap_map[offset];
 }
 
 /**
@@ -1779,7 +1745,7 @@ bool swap_entry_swapped(struct swap_info_struct *si, unsigned long offset)
 	int count;
 
 	ci = swap_cluster_lock(si, offset);
-	count = swap_count(si->swap_map[offset]);
+	count = si->swap_map[offset];
 	swap_cluster_unlock(ci);
 
 	return count && count != SWAP_MAP_BAD;
@@ -1806,7 +1772,7 @@ int swp_swapcount(swp_entry_t entry)
 
 	ci = swap_cluster_lock(si, offset);
 
-	count = swap_count(si->swap_map[offset]);
+	count = si->swap_map[offset];
 	if (!(count & COUNT_CONTINUED))
 		goto out;
 
@@ -1844,12 +1810,12 @@ static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
 
 	ci = swap_cluster_lock(si, offset);
 	if (nr_pages == 1) {
-		if (swap_count(map[roffset]))
+		if (map[roffset])
 			ret = true;
 		goto unlock_out;
 	}
 	for (i = 0; i < nr_pages; i++) {
-		if (swap_count(map[offset + i])) {
+		if (map[offset + i]) {
 			ret = true;
 			break;
 		}
@@ -2005,7 +1971,7 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 		return;
 
 	ci = swap_cluster_lock(si, offset);
-	swap_put_entry_locked(si, ci, offset, 1);
+	swap_put_entry_locked(si, ci, offset);
 	WARN_ON(swap_entry_swapped(si, offset));
 	swap_cluster_unlock(ci);
 
@@ -2412,6 +2378,7 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 					unsigned int prev)
 {
 	unsigned int i;
+	unsigned long swp_tb;
 	unsigned char count;
 
 	/*
@@ -2422,7 +2389,11 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	 */
 	for (i = prev + 1; i < si->max; i++) {
 		count = READ_ONCE(si->swap_map[i]);
-		if (count && swap_count(count) != SWAP_MAP_BAD)
+		swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
+					i % SWAPFILE_CLUSTER);
+		if (count == SWAP_MAP_BAD)
+			continue;
+		if (count || swp_tb_is_folio(swp_tb))
 			break;
 		if ((i % LATENCY_LIMIT) == 0)
 			cond_resched();
@@ -3649,39 +3620,26 @@ static int swap_dup_entries(struct swap_info_struct *si,
 			    unsigned char usage, int nr)
 {
 	int i;
-	unsigned char count, has_cache;
+	unsigned char count;
 
 	for (i = 0; i < nr; i++) {
 		count = si->swap_map[offset + i];
-
 		/*
 		 * Allocator never allocates bad slots, and readahead is guarded
 		 * by swap_entry_swapped.
 		 */
-		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD))
-			return -ENOENT;
-
-		has_cache = count & SWAP_HAS_CACHE;
-		count &= ~SWAP_HAS_CACHE;
-
-		if (!count && !has_cache) {
-			return -ENOENT;
-		} else if (usage == SWAP_HAS_CACHE) {
-			if (has_cache)
-				return -EEXIST;
-		} else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX) {
-			return -EINVAL;
-		}
+		VM_WARN_ON(count == SWAP_MAP_BAD);
+		/*
+		 * Swap count duplication is guranteed by either locked swap cache
+		 * folio (folio_dup_swap) or external lock (swap_dup_entry_direct).
+		 */
+		VM_WARN_ON(!count &&
+			   !swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)));
 	}
 
 	for (i = 0; i < nr; i++) {
 		count = si->swap_map[offset + i];
-		has_cache = count & SWAP_HAS_CACHE;
-		count &= ~SWAP_HAS_CACHE;
-
-		if (usage == SWAP_HAS_CACHE)
-			has_cache = SWAP_HAS_CACHE;
-		else if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
+		if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
 			count += usage;
 		else if (swap_count_continued(si, offset + i, count))
 			count = COUNT_CONTINUED;
@@ -3693,7 +3651,7 @@ static int swap_dup_entries(struct swap_info_struct *si,
 			return -ENOMEM;
 		}
 
-		WRITE_ONCE(si->swap_map[offset + i], count | has_cache);
+		WRITE_ONCE(si->swap_map[offset + i], count);
 	}
 
 	return 0;
@@ -3739,27 +3697,6 @@ int swap_dup_entry_direct(swp_entry_t entry)
 	return err;
 }
 
-/* Mark the swap map as HAS_CACHE, caller need to hold the cluster lock */
-void __swapcache_set_cached(struct swap_info_struct *si,
-			    struct swap_cluster_info *ci,
-			    swp_entry_t entry)
-{
-	WARN_ON(swap_dup_entries(si, ci, swp_offset(entry), SWAP_HAS_CACHE, 1));
-}
-
-/* Clear the swap map as !HAS_CACHE, caller need to hold the cluster lock */
-void __swapcache_clear_cached(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      swp_entry_t entry, unsigned int nr)
-{
-	if (swap_only_has_cache(si, swp_offset(entry), nr)) {
-		swap_entries_free(si, ci, swp_offset(entry), nr);
-	} else {
-		for (int i = 0; i < nr; i++, entry.val++)
-			swap_put_entry_locked(si, ci, swp_offset(entry), SWAP_HAS_CACHE);
-	}
-}
-
 /*
  * add_swap_count_continuation - called when a swap count is duplicated
  * beyond SWAP_MAP_MAX, it allocates a new page and links that to the entry's
@@ -3805,7 +3742,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
 
 	ci = swap_cluster_lock(si, offset);
 
-	count = swap_count(si->swap_map[offset]);
+	count = si->swap_map[offset];
 
 	if ((count & ~COUNT_CONTINUED) != SWAP_MAP_MAX) {
 		/*

-- 
2.51.1


