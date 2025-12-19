Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC51D7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:45:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A54F46B00AF; Fri, 19 Dec 2025 14:45:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40B66B00B1; Fri, 19 Dec 2025 14:45:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918A56B00B2; Fri, 19 Dec 2025 14:45:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8026B00AF
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:45:42 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 151E358B63
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:42 +0000 (UTC)
X-FDA: 84237250524.13.A8D76AF
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id DDFF54000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="e3H/Rwuq";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173540; a=rsa-sha256;
	cv=none;
	b=vTQabf2MmgqkrfHX9lJZCzvknHvjBkd8JJw2airQFFONndSCORCSiOzQHNrRhRumHw45+V
	SC4c8vfTuCtvlpw2Cf1XVQ+X1RDe/sQcZhz3SOpjQLdO19/mzPFZ/2JBXpqEDYJsx/ew5A
	BjfvpZaWOba87XVAIDLgYGaaYNbrDpg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="e3H/Rwuq";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EXUnD0TxdvvVVNqfs6+uH6gTotwTKlm7rUuPyZoYLVg=;
	b=kWFQ1+PJp17QeMwVil4BuBEL4wLWX1oBMcHewGdkl0qUYu2uwlcsPy817mQEj7mzloWZjJ
	TOVcDcqT1cNt1d0JCanmfEUIbFqolfIwG/wFiDBbv/7yAK7kCfW2YUMq16iygRUqAsJhGo
	NqeAbzzlluHSgeKeNFuNygJqYftvr3I=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a110548cdeso29474945ad.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173539; x=1766778339; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EXUnD0TxdvvVVNqfs6+uH6gTotwTKlm7rUuPyZoYLVg=;
        b=e3H/RwuqKwUY8fTh9WQ74FIVQQt8JSazM0HrgyWqBkOk3YYeh+pF6lrigD5wpWr5SI
         IwYsjy/wNaavCIBe9cDTHxWs4Epdsakmk3m4ROfZOOaRGccq6nfWsDZOVqcpHgg8VeiQ
         OwBnn7Oj4LjiLwxBfo0cCey+irFuMK+lXbt0zbODkIkfCKV5KRu9BzF2VDOm/awwdzsT
         zWFGSqCW7VZdFkltGk3tylrHJF6d0YoT5T9fmYeldeb8FTX9am27Yxq7Vz8/z6KgO7mL
         9tmWex9cAEbkQosCyv/EJHuNb2+XkZpGGE89fJnt66T6vQdk99AE+CaxxoEJYCehj8y+
         8oMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173539; x=1766778339;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EXUnD0TxdvvVVNqfs6+uH6gTotwTKlm7rUuPyZoYLVg=;
        b=ABUPwKkIq8Dc3R4AMj0nyYrijaDPo8jSU0kvIKKyiXSdMxz2h+tBYoPSauI+xWWimE
         uaomiksenyj7UPTZUt2FEEOcmW4kTRBunKZRPb5e0qvnnFf08O8Xg1Mdrb8ZIY4h9x38
         StTvB6z9N7nIZPk/r/laYhke+6hTVKgdgmX3Xy8NsYOghaN5GH41FHLAXW6W6r2xrg91
         D4dqOxvP8hB/CWZbiTW1u3vtcyQMKXmO49r3RxpADmZkKwD8P6yP+nS0hSCg2kx3GIMr
         a3GZKdp1NmIW4fI7biimmz/5NaXBSoPBybd6rJoDHnuAgbFBHphGoA4qeCSimR19mnAw
         mFGA==
X-Gm-Message-State: AOJu0YynSlSydIoyuXtAe3cluEqsJvuUQQbvoIgyizW2Z2JExA6yzKf6
	6Qx+f/ZsrKVnTfPxiQiqKFn/UxZWIcxdhGpt+D8tPb7BfO0V9MnUQun2
X-Gm-Gg: AY/fxX7x0uTRywD39svOoxy+6FkONThOi4klp4PVCWN4+uSEvObIYeYUDbC7J0wB0gt
	c3lgIYfC017hl+WoL8D4OAIlYTUfQgAu4M0MDo4eNqqLk0Ccqyq+SBbdQPs/ElIf6b/SEMtLCwF
	8i/6am8BpApvUmS8xxYGCJLLgqA/A6TvOcN9MVKAzLU0AMu+KboGL6zlL91211y8NIWrv6fhGPQ
	HsxLHK6L8URmw3c4bJTQEfrzJ60G8XcmWRtgnudfARzlmGBvVT1jhX+G+fYhBMgYikHZV0lZSxc
	4uMf+0hQAYcgl6xGzZ8J+07O8ZdtBIj9RtjI293CdaQ41W++ftDBmxfFDUtTfgHdt74d45ECst+
	kntkugp6odJKeM/SIXDriRAE6YKDNs4T1ge/T25MsmG0wvjkCCPy3co4m9ul9eRl0HkCfp/sxCy
	tx7Ci7boNtDVr1zHOG0kJsZwHqMXjUghelIeD9pC2pUREr/p1dQd3V
X-Google-Smtp-Source: AGHT+IHyinYRJHe8wMfdWgxB9GsoLx6jzI9oqskhYPXafXHKGKtObYuOnRTJnebQDO1RErNCH8baBg==
X-Received: by 2002:a17:903:40cb:b0:29e:facd:7c02 with SMTP id d9443c01a7336-2a2f2830ff4mr37513005ad.28.1766173538644;
        Fri, 19 Dec 2025 11:45:38 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:45:38 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:46 +0800
Subject: [PATCH v5 17/19] mm, swap: clean up and improve swap entries
 freeing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-17-8862a265a033@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=13630;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=0KT1qbJ6MLKCnGsBuLpaMmy6fVRGJpUGw01IvVzuI5c=;
 b=7Rl/9Zbe0K99+uB0pukbc2Z+bRniLyD1ih0Hhne2xrgy8aw/WHhmqMrM52gx1ylglpFXCgtA1
 b1s9Cm523vbD2VpD7iE0dONf5Xva0p38RkBd2N0oRdbddo3PN5fKpmO
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Queue-Id: DDFF54000A
X-Rspamd-Server: rspam10
X-Stat-Signature: usqttzzz7shpufut4wmmmtucndtyc7ew
X-HE-Tag: 1766173539-721484
X-HE-Meta: U2FsdGVkX195M1Ol7DZr2AJEt9DkaW9uszWhRTEu2xydTxzCuYDXG0omtvQa8h4wWdsH4gN4FKCQaQAhTl6Bp7IyXz5p+hfDUvNK1//e1rngcUj1Mi8sbQ/PmnFRu5jFlLKI5ML91atCrAfUeVeYIs8h/gA1XzIS6jTCEk7n6fvKo6YdmVKaq5JMJHdhuceQuPqIXkeXObp45xa5Pkq1p9nqHdh6BOX8ODyOWZGrxRue1TS6oUBd03nyGzbp0usd979lTuDEs/f/0ScFAAjMifRgP+/mXqwrh6A9JXeUBSRJTROl00Ahv7IlQ8eM9wzVHq4wGlTbGDdu3tHo84YIoKvlb7aGvA7TbyJYLIDuaysi3qINL+J1rPselRmfAv/7qBIP5DwkKawZZ+J3AsooWiB1FKwSFDbgnG1BbqmUaxT6fUjvqajQpTA3nTbEQs1CxxXRciEyDMIxslJFcf0IZlsz6+lYO8A6rrJElxpLXL2kblql9IjObMr2ky9egXpDzt8e0WUSZj4GkHULxbUzofn/qihsUPa/jnIwhSy62+7VGja0X3CZrwU2xTactsMfrscXAujpEF06DnrHFCkwfzVEiKIp0kCBDH/r5136PUXIkAnPpFZOdF/HPZgTJfuFNxe4tvxHE/CndYi0u9Q1c0PgjV+OBiF2sIAwNqT68fu26HLdq6pDfAkG2UH0maq4+qtlrd5hd7o2idpFMiI2HeIFXXSw1NvgdAFapB+gfR0GWDZqXaWn2mmGZ5ZFchyEDbVCd/eP0+TihxeDBYJn6O9HRsItN1RdQzt4sKIwO0NWy9fGfeR8xq3gq8vfCzTvexl9DDMztMUCuRNEgBEtahMsH1rszXtSCpuaOvhZrHYOgWMk13Se2YXvPQ8lKuCAd8yKy6sDBge9YFv+774u871lKBvXdl16+/IjIPyh5l2bJ2yW4YSjLKHWm8QkTKJ2cylQnMBNRnqbrghq1O+
 w9pxZJex
 7G15TjhOVOgJOZIG0fiRtuXmVwujoANOSdSAbEkqaV6/7JfcdSY1l36qnpohlduX2GwAxDgeyYV/S9MhOJW+6UutFCVBotxRA8bKiUIkxkpBCz24cvZCOvmNFfCFyPy0dGT7F0lnx4ZUTCA43Gb2pCK1ORq1xjZrlG7RGTADBfA/dqaW+XPZIlqdh8En+s/OYb5A/2/M8LaiI3+cMSOrKRmnEIvdCdxJh9lm71MTy97GxZMY1wpNijIzhgxSHwwSIWOuCFyZgOdkkbVhydmrwCtqGO/XKuvLqqaoVXXcPzx+oUX8zqYdaUbi7hqAX66lN+bzOlFsIjUBU8FG9AwxCUxcuzg88mAU6GbVjyHKngaWGBG1wu5UuDhPbTS4GOXcuwXV6AwTkBilGfs+H/YsoTSF16NzjGJVojrOeST0T6uQg6RSrrkEfOnnRQg==
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
index 91436ee41446..9fbb2f98219e 100644
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
@@ -1439,6 +1422,76 @@ static bool swap_sync_discard(void)
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
@@ -1544,6 +1597,7 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
 {
 	swp_entry_t entry = folio->swap;
 	unsigned long nr_pages = folio_nr_pages(folio);
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
@@ -1553,7 +1607,7 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
 		nr_pages = 1;
 	}
 
-	swap_entries_put_map(__swap_entry_to_info(entry), entry, nr_pages);
+	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
 }
 
 static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
@@ -1590,12 +1644,11 @@ static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
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
 
@@ -1621,9 +1674,7 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
 	if (usage)
 		WRITE_ONCE(si->swap_map[offset], usage);
 	else
-		swap_entries_free(si, ci, entry, 1);
-
-	return usage;
+		swap_entries_free(si, ci, offset, 1);
 }
 
 /*
@@ -1691,70 +1742,6 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
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
@@ -1769,9 +1756,9 @@ static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
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
 
@@ -1978,10 +1965,8 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
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
@@ -1989,44 +1974,13 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
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
@@ -2073,7 +2027,7 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 		return;
 
 	ci = swap_cluster_lock(si, offset);
-	swap_entry_put_locked(si, ci, entry, 1);
+	swap_put_entry_locked(si, ci, offset, 1);
 	WARN_ON(swap_entry_swapped(si, entry));
 	swap_cluster_unlock(ci);
 
@@ -3828,10 +3782,10 @@ void __swapcache_clear_cached(struct swap_info_struct *si,
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
 
@@ -3952,7 +3906,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
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


