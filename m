Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 799BED29FB2
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08C86B00CF; Thu,  4 Dec 2025 14:31:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8616B00D3; Thu,  4 Dec 2025 14:31:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80EE6B00D5; Thu,  4 Dec 2025 14:31:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A28676B00CF
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:31:00 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6607AB874A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:31:00 +0000 (UTC)
X-FDA: 84182781480.08.6E96244
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id 44BBC140013
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mx+ypnzZ;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I2hHCOKTmVEJWu9vcQFd3L/+raWQ+BsHL/zgl/R7UbQ=;
	b=UUhNaOUvjIHBhSQgXYE41Eva4Gg8IB2at9LR09aRTyHyhxp80Qwlcvx+ByJ8Np1dvQS8cL
	wK3/mFj736IaSHY2omIM7op2WuI8LcuhLowmHIwvfNeCe5gyuDnp+6XqHtr2PRi/dBn3J1
	C60gxVfWYdrnZyjVforipyZuQ9lwH1k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mx+ypnzZ;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876658; a=rsa-sha256;
	cv=none;
	b=ySzSGIkrcVYM6fTdr4iQ5nusHTHH3Qs3BeZ+6jdsyl1WwLXuDL5gyp5FI3/Ry3MWh9of/l
	Gye1ws05CXy4EY9oz1pMS6BRCYKbvoU2YlbuV4yBBJWv79qECpDGNbnQSYeQZtJvaR14TI
	kXLxDwbjddmcez/vPZ30Us81xlQe3Bg=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7bb710d1d1dso2056463b3a.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876657; x=1765481457; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I2hHCOKTmVEJWu9vcQFd3L/+raWQ+BsHL/zgl/R7UbQ=;
        b=Mx+ypnzZ229EEe2L4mXILCkS5UP+dl+R+75VkVUSxrB0hyBB4dIz/FS4bhJcr3YCnk
         17szka8GRZw+BZLvEEB7Ec0D6mpT+VhnFoo9qcDpZ5xeX3YcVC+jAkwGOoQ162bWXO9W
         nYFc2+xEs+DSdINidI/8eVcbexorP+X5yBWs2wh4FNlEhy/Eudv7PtCYMs5FvdVZr+LD
         7ERtvyIPSwZd903gr7XCV3FhtE61UItg3s7DcAkjigKwGmPw+h9dyEsTF8WCvdJCKD8Y
         N2Ql55qzhszfXt6M3LGm7Ad6agcgepTYaU2Z8k5M84bBW5JUw2d0jdNbJ78Yb5AQmHCe
         dlXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876657; x=1765481457;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=I2hHCOKTmVEJWu9vcQFd3L/+raWQ+BsHL/zgl/R7UbQ=;
        b=g92E2O/G+pM7pIvx7du8S/V52oAVQHQUZEXL5w2Kw2kki01asdD21VSFdyq1VRkiSo
         ranbZ2pl6sYrZlmPYVhkcqJST9fBLKYhGqHjK6XDqbt01y77nHausDtP8KrPtn8tAccR
         x1iQMC/fYraxMj5tBMSApdYSaDk+quJQsbGTrg7B8ryGoZI+xmPQBDUF1fgGuNYqksFH
         QCg3rIt3wwrwX6J93aU2usQHzkIhobo7EIzzu/nxIJzzUTwaZT8URofm2KO1/qczUNHd
         4R5vKXTrfBxd+aCxAW6bB3NAZrgmbr6fCr9B5SOPXgKQKcwGTRmTF/njeQ7e9bDhFpxC
         xeJg==
X-Gm-Message-State: AOJu0Yx18d2GEtyoUm6NGvB3CnPfOL4I3dY1xcCGCXQ4+xVvE4LOAg/q
	xz8gkK1gvO7VCOzw/o0xSs6kv2Y6B2M7uimaV2FyvU6b7P+GW02QgfH7
X-Gm-Gg: ASbGncsgzw+Q6Er//mG/4lpZcMU4H+2i4IPQx+v7bpaTt2VOFxncOKGCn2Xkr6uQEhf
	R81qhGVIAIejguTXTXlK+skr+Fyq8NhVZZjYFgPEObCm6TibTvROk+Iz5YdOwaaSOwepEaX3PS/
	jtk/LjtofxoMBzJXAdyO1bQrAntH1VGBGvarXiYii7JlxUyJp3op4FLl0Mjnx2NyL9Hvn4PxUWN
	Dm1Q1+bOEsEWx0smeK8LAmzCvujq6fmDAhwiMLqRojGmqwqqn3Jn5W5ze5DdpqMJOB+o5oPWMoo
	U0AiXAE+cMYRI8sSYADeDpFFOjraFR6fSV9dHGHOD9H6mAaTessrxR5WpHtVd7mDke1nF/KacDZ
	MKgXRN9/NJxD1A2AG9xiIk2nId+cgLrQIPlrOY0yjsV9UWlfXxYrehVnjHkU26gLViTME8zfCYZ
	zCQDXjvUo2S8No2OjR2QY+PnkUgXbbvOTZtBhbTAeJOoVq4Dql
X-Google-Smtp-Source: AGHT+IHRYBU2rcfuoo+jDuYxCOKhAYKI5obhnSagjEUUdYlBxzbom4/kWKQt1ICAZfdTv2/tSDI42g==
X-Received: by 2002:a05:6300:210f:b0:35e:fce6:46e7 with SMTP id adf61e73a8af0-36403764175mr5062454637.5.1764876657054;
        Thu, 04 Dec 2025 11:30:57 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:30:56 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:25 +0800
Subject: [PATCH v4 17/19] mm, swap: clean up and improve swap entries
 freeing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-17-cb7e28a26a40@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=13631;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=7RXtD1FvXy+eheLFQr5n4KvdqXdBT1d3xCF6452la6M=;
 b=i5fheAkj3sEsqTEkvqEBaZdZnbJmynpFZ+dO+qcQpzqzJ6jamSNO9id2I9ZFnfMFM0UgV7w4b
 ulNnmBskNANBEST0e8/3yR/9KAVldoehEUUG7gFBmh/0dX64LRs57cK
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: 44BBC140013
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: t6h3kxfqgnptcfeq9ci71a69ewf8bk9d
X-HE-Tag: 1764876658-734095
X-HE-Meta: U2FsdGVkX1+VYzUzewKRecmRiPoZES4n9zgX00fdwBkMG21F5n/IVReqk3UZINbaHaDq18M/R42MCmPtq3JvPVExmznsykkgA6O8HjEA3BKAWEkP+Tm7oKcU8YUkW+DhRXeIgY4IzdM+jf1Y808XIi6ShcfThTajdr1Q8d97CiBs8+MNHUAHlDVrknLyJtKuL1svY1GfcCi0jAI0lBS+QDuf5NDm9Te0KJFi1shaqfVgnaTZA4XvnZOYga0T+r5XyF/snWKaF5MGTzn7CG5VuZEnTxPkgoFs5dole/nNeYorcGzkIX1XW6ljDJjOq3oWppOsajeKIXIiDB7/p5Aq4P/6/TKSTtRE2QV9XhxQ3nBfvgclJwfp3gvyyRI804bSwnjvaOMl0iFZKCHVUEq64+845YlImcjY4bkj7sBGgNVVnZfaL0X1+i+c/OInCIPalGNSQwlpZR9IqvjXV3hB9ajBVF+HBzyL2nDaW7+Kae+1Z9t3D9TK43uItlEGHPs+FEMC0GHDFSqF9ysvsUStWl7RS5dDwEH20ISkDoxpJI+q4E6n+2fkQuWKEx3arD1QN60kp44399ZmQiz/aPBQ87MbQZl20Dgcai//Pd0ErZiwKW6GdV40yObXk8wZFalucHtku2M7fhPKQ+7I0QhcYbyf8pdoSIZUOWJ9zxBfb1WDVdLf0jRiqHqQgbCFegFtObQSvkweN6a6+lMY2PAPXkhzUCBUeg754wTC+dj7Equ5KO74fJtY6vCsRbt9KxYGZB9FQYRHL0J2+8IBYCvy1TqWfffX1Z/FyQWxdnoNNh2xqBSdwbTxCo2a19FbtvKUBlvw+MXl0JMRLhSp5zOTE0UOhgFCUo81g8jXnEZv2Im62wrtIPIL9D7jLqumrLIru5wHxeUN6pxNG61F7mC6XIvzEXfTLPbvaYRgzxj944J03RTvRpWL2Fvsbcb2BQwtB6HrcEHXgtvUWMKQTx2
 yfvB7zhK
 TaOt8p/sgH/JKOorbltw1i5FvGXYrS85uTAdC7BADHbVD9i4xbIuPRk2/2siB0ivlEG+sZJ+F2Xn5Na61Q1LMuBFBfoYCVTDlP9wQ4o+iddHgJRKahHYQrCGep9Ieo0GpDPQwqYS3Y9oROPbeR5uUKvA15F7mv3IU7A/bI6Lds0HVTOWI5UV825SdKZvXIWr0OlWRwV1ASxSXH+ljiuA6BAJCwZz3JgsVc5Rdt34/gAfrpDPt3UmY6ziIL+8n5aEoM7/dzBlyl7VIQHrBwC886ehsYXo3t87Hreil6gTRu4aTpRM6z1GfioEhBbdQatUZjhpSe38JFc1zccSdMdvRdr3T5sqDEdYY/njTS18QQhVXqLca1cxruV1S8Fv9ToueZyvL8vXYEGy+MICho2sX7qq9nDXZsA+6Xy16YGfG0PWM4/njAZqUlY9/VQ==
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
index 2cb3bfef3234..979f0c562115 100644
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
 
@@ -1977,10 +1964,8 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
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
@@ -1988,44 +1973,13 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
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
@@ -2072,7 +2026,7 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 		return;
 
 	ci = swap_cluster_lock(si, offset);
-	swap_entry_put_locked(si, ci, entry, 1);
+	swap_put_entry_locked(si, ci, offset, 1);
 	WARN_ON(swap_entry_swapped(si, offset));
 	swap_cluster_unlock(ci);
 
@@ -3827,10 +3781,10 @@ void __swapcache_clear_cached(struct swap_info_struct *si,
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
 
@@ -3951,7 +3905,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
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


