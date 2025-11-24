Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 065A6CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600016B00A9; Mon, 24 Nov 2025 14:17:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D84E6B00AB; Mon, 24 Nov 2025 14:17:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EE066B00AC; Mon, 24 Nov 2025 14:17:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3AF136B00A9
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:17:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 124148999A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:17:06 +0000 (UTC)
X-FDA: 84146458452.20.748FC43
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0A0A0A0014
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:17:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J2kvgEbv;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qKFQ/7z2VBxapImzqSseNC4lTKb3ZTDXKAUmT+VuH5Q=;
	b=327XDnOHC1Ij81rKnae+q+9WeKu9p7BxTjHJvFigKk65ATLVqP6jAe4qWDbuVZL9GdeiRp
	Sgs/bTFFNtImoVTCrXQW18xYwPPyPkD3d7O0dG8cTFESoGPRwnGSpf4bBffiyOwhfhH3Nh
	HrzVqFj3oUa4zGhZYERdNVQeKvDWZ5A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011824; a=rsa-sha256;
	cv=none;
	b=empCyxcFuQlA3b0n7KWYZT1nGeEqrh7ExmrQr+0jOYou5owbCExrAhcs2KXKbX1ZQmZ5x1
	tCKxEkyf95cwkcZNfgvZztcmOhg27vyX6pLYk3+p+VDlySeabzcuFzMbudHVkKqJLhVL1/
	BOre2A2GzWQvPH6Mta8tev4EHRfFZxw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J2kvgEbv;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7bc0cd6a13aso2886568b3a.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011823; x=1764616623; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qKFQ/7z2VBxapImzqSseNC4lTKb3ZTDXKAUmT+VuH5Q=;
        b=J2kvgEbvYIvfgI/8jEsM0uz74Punwm5cQrkW2FTKyfAGGL1bD/z24FmaFxcoJJ4gDa
         7O8YJbL3k1VOnoKzz+QyonZrAQwJqY32GLX5c/k3B7eLYnjtQ+f51Qp0ezohai505PWs
         pXE9uuQvq1lzY9xpiN4DgKFi7PNY9xiccehNdreY/tg7wEM9VURITeSGI9HUvMaa2iMu
         ETQq39zOGhtrKCUNIvx/hS3rfcTHCQQ0Fy8tIiqL5gwNCbfhrZJogAz6BF4KIAwsmHYq
         J07nhED17/qvHwcPKAdvYtJRr0t7MgXcsCIT6PQCmUb+iPap42twG/WHolqnmCFT1ugW
         bSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011823; x=1764616623;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qKFQ/7z2VBxapImzqSseNC4lTKb3ZTDXKAUmT+VuH5Q=;
        b=aK+xKXxm9KZAEPk0xKRgrjswksfClks1fZ/kPilsMK/Dj41uFsS3vaQSYpP9+Gk2dd
         it9SUqzT2hWfwDXxd4FP/K0Q2D1J6alw2eW6BxV7aRZPkeR7zQdHMf06ePhStBz5oHhS
         kF1AxVEHutze01beUJiRnxJmuPAbW7w7VMaZD4SHmdEAIvBxOu8rMgQ78jguckbymBbo
         1Uvff4DytBONPMkCZtJNy31wmiXkbPmBnkCCiS7G40fKim2hT6HY8m4l8NTcgRw3GrgK
         emzM7PgzheIXpkLBn4C6b7WfMWEUxJTQ1EnOQj3hFswgc6kc8kZdPbj7heNs2Wrt8INN
         WLiw==
X-Gm-Message-State: AOJu0Yx1LJx7PJuojlZ6cZMxqylsrc3Kz0E+LBfPGmpCXq0+jmekLv30
	hN/Y7oVYvK8piXjjnKOLZvSO0oDr/MipRQnCGvIe9zDnMRB2d2IAfCfe
X-Gm-Gg: ASbGncuqYQtubiynoiGtzSJszLLwdcKQYopUY8YXSPWmK8LzvCCsKxPVRYNdoWgS5bU
	uPuOusK8C3Wie9lRW6DNsMWDc1TIcmv3Jz/7D8Bf7huqfY+uC90fmlDtODAjDZrMcdrWychmsqG
	Lqcsfu3JlVzlo/vOgWLGI4Cgc5gxZSp5HhzXqjM9xF1ElsXmVrr3/I9lIFuWI8UScCbhtfz4b7/
	FJYGx7CfbmvFAUznzMaChuUXfIbQwv6tUJ11FeHNuLfWkge8GB5GOhhWtvpCRxj8LHZoCeOGv7r
	/RG4qpIRGzjWqXg7sVI5RNyuDxX2N6lvhdMxFearYGomEdon4mjRTP4O0vWByHzs8nIb7X1mBTw
	bPPzcKJXTFA8T8meVt6Vqd1/XsK9dVs7xiwiseBSsNpm8ryN9HL/DAPAkhzfifTbXu8Zz58yATT
	F6WAdaoIjyFu/Kraj3q9jlTYER01myC5gOFA4w+H54WroTi3co
X-Google-Smtp-Source: AGHT+IF/PT8KbR1tAqo7AK8HYvyLqub/CkizxT9rRbD7bM96UwbGh1ZzrVk0tYYBIMOKFHyN6Nu1Lw==
X-Received: by 2002:a05:6a20:4321:b0:32a:745f:bee3 with SMTP id adf61e73a8af0-3613e56b2f5mr17248958637.21.1764011822559;
        Mon, 24 Nov 2025 11:17:02 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:17:02 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:14:00 +0800
Subject: [PATCH v3 17/19] mm, swap: clean up and improve swap entries
 freeing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-17-33f54f707a5c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=13631;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=BF6jwfku37yd6zUniJTYo0hL0HpTBM3Sf7/qOkB7gY8=;
 b=ARV/qDNrgBe1feo6i09/IbKQGMHm9Hs8ASYADj5iWg83GPTlsVzGx5KL6Mn9lMsffaJkiFLqz
 43pX1Ke+r1tAbw3pF8PomjR1Ci+gSHrS/VUojzQReVVsiYLop2EqYt6
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A0A0A0014
X-Stat-Signature: cr98yc7puyujay6wk1jgkgy7dp4e45rr
X-HE-Tag: 1764011823-830334
X-HE-Meta: U2FsdGVkX1/hgR45MRN6fGa2eRACFB0zNI96Jxkv76AlJtFTFUVWaCXphIDjT7q6OcwNZ6zeCcdmYk1coQuO8B3bpD1dK1JsOuIDl9VKkyW1Cy9GA9fz/QSntOh1km5BeYkJPHdJ5XOWm8z+sF/lzIZJVm2vizDp5SfLjv0qDIj6A4/JuVQBw77he7rl10pGwNDVGA6q2Ba9H7SNbC9W0CtPxVfKc/KZKh5HNgcpm7BfUsl4LQ0UXVebKYd/U+LPo01v9ZvP6oy9rQfD+ZhlO6UTvCV8hIL/zpAxM7F6zpx/9qUpLWxnA+0ZAy+C5elb23tMd6pvi2PqhzVHBqa+IQoDRtETpBTctmbzD8m0IOWOrXi60j2S8HQdSxHmCGE1hNYoRYz6q9seNgpXeeJO5f7tNQcuy1HkTt0RwbLKiFsPixQzZBhNUepszItl2ZhlkNkTy6dN/0Xgy1TQkLyq3vrDXXj40lhB+gPdHUeOP7yMqvHHBxdOu7yvSbHNJ+ad2VPS8bSEH8eRqJ1elm2sw6qTwrRfMhbVlRvxbz6obesZQ6y7hiY4flJfR1aOV74OGwH9xKeQqv2aX+FtLzMDgq16870TiPk7pwkg2Hf6bkPHEhE0XlLcpQOtfpaDMWY+aMIdhtHqXasDj2ul4DNkumr1ctrvPvttZTcISSLCgyI6NWafKaF5Put74Ldz0m955MUjrAWhENi9iJSwXIn7fvZZtLlp+2+P1LeXT05FEQ95U3OzXAkSU4jZjQX1reSmCtpv09zUR7N/o62xDgg7NqfvLdxHPgMqNwacWR2rffdk5J37MxMOrjJKykhmsFk/IhEfJKrGsyoAwI4p4fyktZEEKeuslKXEutUURSr79rMcMhFwZd5vyU74DD2nxPqP6lYa5aug11Ft2/iBYM73qsvmBakPb9GNxlDMDVGGu05xCINEqIj7059YFCYT+zbp9qiLz+MPsQAAAVMcQ2g
 XLbPlthj
 puibvYwrvEGgucOFmmPCXZbkpZgi8TEHkmcPcjDELD27sPiO54kcx0EP75ou8gNqM6MaToPX/mC+BsXLt1IwJ9tbj46zLyP8xLdc++1vf/eAGaJNULq++XPK/xf5+VJ+ayKCLFNHFr5oZTm90p7f8IsVXvUgsTZEdz/XHsWZnew+XxwZNAIwRhNPrSenaArJXm4yXXmNDvoS2wPXGhNyijVWM/IHniEIJod4yMpgQcqoVTdmDnhk6AulKnj+Ik4m/9VJLfDqfS/bVEc0a94QEKXcvbGcStXvOsAfPVGAuG/mATRCWoVfDOSHz7dsVCblPfQ2xmOr+08XPwic+ndVczt0bKjgg0QUA+HaIGhULho6cb4/Q5r6AaRwuO9l/aqrfz/xidM/PXkLsFIr+BxsH9cVj103LiQt0XFuWF86TiPbQ5qi2LoLHb0KC4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

There are a few problems with the current freeing of swap entries.

When freeing a set of swap entries directly (swap_put_entries_direct,
typically from zapping the page table), it scans the whole swap region
multiple times. First, it scans the whole region to check if it can be
batch freed and if there is any cached folio. Then do a batch free only
if the whole region's swap count equals 1. And if any entry is cached,
even if only one, it will have to walk the whole region again to clean
up the cache.

And if any entry is not in a consistent status with other entries, it
will fall back to order 0 freeing. For example, if only one of them is
cached, the batch free will fall back.

And the current batch freeing workflow relies on the swap map's
SWAP_HAS_CACHE bit for both continuous checking and batch freeing, which
isn't compatible with the swap table design.

Tidy this up, introduce a new cluster scoped helper for all swap entry
freeing job. It will batch frees all continuous entries, and just start
a new batch if any inconsistent entry is found. This may improve the
batch size when the clusters are fragmented. This should also be more
robust with more sanity checks, and make it clear that a slot pinned by
swap cache will be cleared upon cache reclaim.

And the cache reclaim scan is also now limited to each cluster. If a
cluster has any clean swap cache left after putting the swap count,
reclaim the cluster only instead of the whole region.

And since a folio's entries are always in the same cluster, putting swap
entries from a folio can also use the new helper directly.

This should be both an optimization and a cleanup, and the new helper is
adapted to the swap table.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 238 +++++++++++++++++++++++-----------------------------------
 1 file changed, 96 insertions(+), 142 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7e28d60d90e1..dd1a138ae265 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -55,12 +55,14 @@ static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
 static void free_swap_count_continuations(struct swap_info_struct *);
 static void swap_entries_free(struct swap_info_struct *si,
 			      struct swap_cluster_info *ci,
-			      swp_entry_t entry, unsigned int nr_pages);
+			      unsigned long start, unsigned int nr_pages);
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr);
-static bool swap_entries_put_map(struct swap_info_struct *si,
-				 swp_entry_t entry, int nr);
+static void swap_put_entry_locked(struct swap_info_struct *si,
+				  struct swap_cluster_info *ci,
+				  unsigned long offset,
+				  unsigned char usage);
 static bool folio_swapcache_freeable(struct folio *folio);
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
@@ -197,25 +199,6 @@ static bool swap_only_has_cache(struct swap_info_struct *si,
 	return true;
 }
 
-static bool swap_is_last_map(struct swap_info_struct *si,
-		unsigned long offset, int nr_pages, bool *has_cache)
-{
-	unsigned char *map = si->swap_map + offset;
-	unsigned char *map_end = map + nr_pages;
-	unsigned char count = *map;
-
-	if (swap_count(count) != 1)
-		return false;
-
-	while (++map < map_end) {
-		if (*map != count)
-			return false;
-	}
-
-	*has_cache = !!(count & SWAP_HAS_CACHE);
-	return true;
-}
-
 /*
  * returns number of pages in the folio that backs the swap entry. If positive,
  * the folio was reclaimed. If negative, the folio was not reclaimed. If 0, no
@@ -1431,6 +1414,76 @@ static bool swap_sync_discard(void)
 	return false;
 }
 
+/**
+ * swap_put_entries_cluster - Decrease the swap count of a set of slots.
+ * @si: The swap device.
+ * @start: start offset of slots.
+ * @nr: number of slots.
+ * @reclaim_cache: if true, also reclaim the swap cache.
+ *
+ * This helper decreases the swap count of a set of slots and tries to
+ * batch free them. Also reclaims the swap cache if @reclaim_cache is true.
+ * Context: The caller must ensure that all slots belong to the same
+ * cluster and their swap count doesn't go underflow.
+ */
+static void swap_put_entries_cluster(struct swap_info_struct *si,
+				     unsigned long start, int nr,
+				     bool reclaim_cache)
+{
+	unsigned long offset = start, end = start + nr;
+	unsigned long batch_start = SWAP_ENTRY_INVALID;
+	struct swap_cluster_info *ci;
+	bool need_reclaim = false;
+	unsigned int nr_reclaimed;
+	unsigned long swp_tb;
+	unsigned int count;
+
+	ci = swap_cluster_lock(si, offset);
+	do {
+		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+		count = si->swap_map[offset];
+		VM_WARN_ON(swap_count(count) < 1 || count == SWAP_MAP_BAD);
+		if (swap_count(count) == 1) {
+			/* count == 1 and non-cached slots will be batch freed. */
+			if (!swp_tb_is_folio(swp_tb)) {
+				if (!batch_start)
+					batch_start = offset;
+				continue;
+			}
+			/* count will be 0 after put, slot can be reclaimed */
+			VM_WARN_ON(!(count & SWAP_HAS_CACHE));
+			need_reclaim = true;
+		}
+		/*
+		 * A count != 1 or cached slot can't be freed. Put its swap
+		 * count and then free the interrupted pending batch. Cached
+		 * slots will be freed when folio is removed from swap cache
+		 * (__swap_cache_del_folio).
+		 */
+		swap_put_entry_locked(si, ci, offset, 1);
+		if (batch_start) {
+			swap_entries_free(si, ci, batch_start, offset - batch_start);
+			batch_start = SWAP_ENTRY_INVALID;
+		}
+	} while (++offset < end);
+
+	if (batch_start)
+		swap_entries_free(si, ci, batch_start, offset - batch_start);
+	swap_cluster_unlock(ci);
+
+	if (!need_reclaim || !reclaim_cache)
+		return;
+
+	offset = start;
+	do {
+		nr_reclaimed = __try_to_reclaim_swap(si, offset,
+						     TTRS_UNMAPPED | TTRS_FULL);
+		offset++;
+		if (nr_reclaimed)
+			offset = round_up(offset, abs(nr_reclaimed));
+	} while (offset < end);
+}
+
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
@@ -1532,6 +1585,7 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
 {
 	swp_entry_t entry = folio->swap;
 	unsigned long nr_pages = folio_nr_pages(folio);
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
@@ -1541,7 +1595,7 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
 		nr_pages = 1;
 	}
 
-	swap_entries_put_map(__swap_entry_to_info(entry), entry, nr_pages);
+	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
 }
 
 static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
@@ -1578,12 +1632,11 @@ static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 	return NULL;
 }
 
-static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
-					   struct swap_cluster_info *ci,
-					   swp_entry_t entry,
-					   unsigned char usage)
+static void swap_put_entry_locked(struct swap_info_struct *si,
+				  struct swap_cluster_info *ci,
+				  unsigned long offset,
+				  unsigned char usage)
 {
-	unsigned long offset = swp_offset(entry);
 	unsigned char count;
 	unsigned char has_cache;
 
@@ -1609,9 +1662,7 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
 	if (usage)
 		WRITE_ONCE(si->swap_map[offset], usage);
 	else
-		swap_entries_free(si, ci, entry, 1);
-
-	return usage;
+		swap_entries_free(si, ci, offset, 1);
 }
 
 /*
@@ -1679,70 +1730,6 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 }
 
-static bool swap_entries_put_map(struct swap_info_struct *si,
-				 swp_entry_t entry, int nr)
-{
-	unsigned long offset = swp_offset(entry);
-	struct swap_cluster_info *ci;
-	bool has_cache = false;
-	unsigned char count;
-	int i;
-
-	if (nr <= 1)
-		goto fallback;
-	count = swap_count(data_race(si->swap_map[offset]));
-	if (count != 1)
-		goto fallback;
-
-	ci = swap_cluster_lock(si, offset);
-	if (!swap_is_last_map(si, offset, nr, &has_cache)) {
-		goto locked_fallback;
-	}
-	if (!has_cache)
-		swap_entries_free(si, ci, entry, nr);
-	else
-		for (i = 0; i < nr; i++)
-			WRITE_ONCE(si->swap_map[offset + i], SWAP_HAS_CACHE);
-	swap_cluster_unlock(ci);
-
-	return has_cache;
-
-fallback:
-	ci = swap_cluster_lock(si, offset);
-locked_fallback:
-	for (i = 0; i < nr; i++, entry.val++) {
-		count = swap_entry_put_locked(si, ci, entry, 1);
-		if (count == SWAP_HAS_CACHE)
-			has_cache = true;
-	}
-	swap_cluster_unlock(ci);
-	return has_cache;
-}
-
-/*
- * Only functions with "_nr" suffix are able to free entries spanning
- * cross multi clusters, so ensure the range is within a single cluster
- * when freeing entries with functions without "_nr" suffix.
- */
-static bool swap_entries_put_map_nr(struct swap_info_struct *si,
-				    swp_entry_t entry, int nr)
-{
-	int cluster_nr, cluster_rest;
-	unsigned long offset = swp_offset(entry);
-	bool has_cache = false;
-
-	cluster_rest = SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER;
-	while (nr) {
-		cluster_nr = min(nr, cluster_rest);
-		has_cache |= swap_entries_put_map(si, entry, cluster_nr);
-		cluster_rest = SWAPFILE_CLUSTER;
-		nr -= cluster_nr;
-		entry.val += cluster_nr;
-	}
-
-	return has_cache;
-}
-
 /*
  * Check if it's the last ref of swap entry in the freeing path.
  */
@@ -1757,9 +1744,9 @@ static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
  */
 static void swap_entries_free(struct swap_info_struct *si,
 			      struct swap_cluster_info *ci,
-			      swp_entry_t entry, unsigned int nr_pages)
+			      unsigned long offset, unsigned int nr_pages)
 {
-	unsigned long offset = swp_offset(entry);
+	swp_entry_t entry = swp_entry(si->type, offset);
 	unsigned char *map = si->swap_map + offset;
 	unsigned char *map_end = map + nr_pages;
 
@@ -1965,10 +1952,8 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 {
 	const unsigned long start_offset = swp_offset(entry);
 	const unsigned long end_offset = start_offset + nr;
+	unsigned long offset, cluster_end;
 	struct swap_info_struct *si;
-	bool any_only_cache = false;
-	unsigned long offset;
-	unsigned long swp_tb;
 
 	si = get_swap_device(entry);
 	if (WARN_ON_ONCE(!si))
@@ -1976,44 +1961,13 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 	if (WARN_ON_ONCE(end_offset > si->max))
 		goto out;
 
-	/*
-	 * First free all entries in the range.
-	 */
-	any_only_cache = swap_entries_put_map_nr(si, entry, nr);
-
-	/*
-	 * Short-circuit the below loop if none of the entries had their
-	 * reference drop to zero.
-	 */
-	if (!any_only_cache)
-		goto out;
-
-	/*
-	 * Now go back over the range trying to reclaim the swap cache.
-	 */
-	for (offset = start_offset; offset < end_offset; offset += nr) {
-		nr = 1;
-		swp_tb = swap_table_get(__swap_offset_to_cluster(si, offset),
-					offset % SWAPFILE_CLUSTER);
-		if (!swap_count(READ_ONCE(si->swap_map[offset])) && swp_tb_is_folio(swp_tb)) {
-			/*
-			 * Folios are always naturally aligned in swap so
-			 * advance forward to the next boundary. Zero means no
-			 * folio was found for the swap entry, so advance by 1
-			 * in this case. Negative value means folio was found
-			 * but could not be reclaimed. Here we can still advance
-			 * to the next boundary.
-			 */
-			nr = __try_to_reclaim_swap(si, offset,
-						   TTRS_UNMAPPED | TTRS_FULL);
-			if (nr == 0)
-				nr = 1;
-			else if (nr < 0)
-				nr = -nr;
-			nr = ALIGN(offset + 1, nr) - offset;
-		}
-	}
-
+	/* Put entries and reclaim cache in each cluster */
+	offset = start_offset;
+	do {
+		cluster_end = min(round_up(offset + 1, SWAPFILE_CLUSTER), end_offset);
+		swap_put_entries_cluster(si, offset, cluster_end - offset, true);
+		offset = cluster_end;
+	} while (offset < end_offset);
 out:
 	put_swap_device(si);
 }
@@ -2060,7 +2014,7 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 		return;
 
 	ci = swap_cluster_lock(si, offset);
-	swap_entry_put_locked(si, ci, entry, 1);
+	swap_put_entry_locked(si, ci, offset, 1);
 	WARN_ON(swap_entry_swapped(si, offset));
 	swap_cluster_unlock(ci);
 
@@ -3815,10 +3769,10 @@ void __swapcache_clear_cached(struct swap_info_struct *si,
 			      swp_entry_t entry, unsigned int nr)
 {
 	if (swap_only_has_cache(si, swp_offset(entry), nr)) {
-		swap_entries_free(si, ci, entry, nr);
+		swap_entries_free(si, ci, swp_offset(entry), nr);
 	} else {
 		for (int i = 0; i < nr; i++, entry.val++)
-			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
+			swap_put_entry_locked(si, ci, swp_offset(entry), SWAP_HAS_CACHE);
 	}
 }
 
@@ -3939,7 +3893,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
  * into, carry if so, or else fail until a new continuation page is allocated;
  * when the original swap_map count is decremented from 0 with continuation,
  * borrow from the continuation and report whether it still holds more.
- * Called while __swap_duplicate() or caller of swap_entry_put_locked()
+ * Called while __swap_duplicate() or caller of swap_put_entry_locked()
  * holds cluster lock.
  */
 static bool swap_count_continued(struct swap_info_struct *si,

-- 
2.52.0


