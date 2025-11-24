Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50850CFD348
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92956B0098; Mon, 24 Nov 2025 14:16:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6F856B0099; Mon, 24 Nov 2025 14:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97FC16B009B; Mon, 24 Nov 2025 14:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86C626B0098
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:16:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 596F3160571
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:25 +0000 (UTC)
X-FDA: 84146456730.17.D1397BD
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id 578AF40002
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TmiVP8dA;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FKeLqk+1/RWvLu8QYWhyCh1bLbzPzjz8T6cPe9gn1XY=;
	b=4noih1il9bKEQWg1DcH2vDRh7XCSkEIOEgN6CFEbMv7YN1sipls891dLs+plOpljeAa3Mi
	he1Ycj+8equlCRuW+EElVjGDPM3u4LORIwKvxtNZMyZc7ztmwO6wOj9I+zcSi6jQSirSKX
	TqqEI5T2oDMXCaqWyeFIFMXrIuzm2Pc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011783; a=rsa-sha256;
	cv=none;
	b=Wc27z7luMCpLDT9rhuEp8DNvtixYS001TztkpzYSyVwzYVymKWVoALxb72DQSD/BN7AyKl
	1pIJKFniVVO048RWI15idfz/kidqhAJZhZDfzrMFYgPaIJqVtRgBL8khTxPgKWPrU5wLfX
	TwxT641PADRXemvh8GcByTnLbG2yHcU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TmiVP8dA;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7bf0ad0cb87so4510097b3a.2
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011782; x=1764616582; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FKeLqk+1/RWvLu8QYWhyCh1bLbzPzjz8T6cPe9gn1XY=;
        b=TmiVP8dAVP0IakcQoKg2LZPNKv4VYCoJve0PzNGSyKNblqKb6lOQtvg1HKbuDtnDXY
         Z+5SuW3DlFT0IT84o3VV+FyrCCdJXXcPxBCW9g5//S10j6FISpJGf3zLaUI2g5L3z6Ph
         I94BoGx7cvkEqcT5zy6+lknLcMYM2kGJ4d0EnEtxAmGfU0iGbBibSIpXUmfIoO8Q648J
         F3SLPVyFfdgB1qRQXpVL6IFoOCwp/Cryq9yj9E5Ylqks3KJ/hasoyNefCn1cPlyZESpb
         CXdZZZ48SK4KgR/vPs5moOHtlxnSwuzp2e33QnG7IFlCIIuDx3Eg5BI6+6rF1NtJowVX
         b00w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011782; x=1764616582;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FKeLqk+1/RWvLu8QYWhyCh1bLbzPzjz8T6cPe9gn1XY=;
        b=QWE8KLhgExyRpkqrT5DSqVJc0ieDHqslY+NCSGS4tlqMmHaxdwLDOBQvOkjGkOnaie
         5f/nfHwj10aUBiW0Yw1PVm3urOYoj2ZCBgdNaDHdC0XqLDIvfqwH4UrBRsUHY8mrC6uK
         cF92mfisDnL8G68/87bS1aafZsF/Anpxccl/7wiK5/PHo1Dy4ozbEfyVVbJYtRVVca20
         88l5eUKYshzcVc5vaf9uV/KziT8nrhBtYUk9RoWYBuIWQlyV5+p0FZhnv53ZfF1mhFpo
         LVu1/6piK64VKJdFuSfz2wE0/BZ2HGyprqK6Y/drH0SyiWfh5XwIzJGrUZbXJzSWvAj+
         pl4Q==
X-Gm-Message-State: AOJu0YzTfshvYO96ot3D9jb1W2+gV5IgAMYTWg0nGkOcAhCN79C8AlAo
	3Ugi4HF/WgLoyd+dvfXJs4DBIeHgkNhi1FOS+bB30dYaJI6GRFULgh/S
X-Gm-Gg: ASbGnctSWo5J/HfqMzlDNrJryr+dYhBQOPm74bo6du20I/f64PcxmxvZc0Hj5/QPc/5
	PGzDxjAwIhgk7UFTFhlROudCrwY39wI19UkiLDqMJlBe98xIEbCYe2tsuSc9GXs8WWi1ZomrnHJ
	8aZ/7cRfkh4qOh8tjtqDOMYQ3xKXh0XnRuaBq50Lz4aOLjpLg73VlbgKpl9LICK7QWJGcdjWzRe
	sQmmI40xlOxr/Fc9+LaeVDhUqEdOmKg7XuG65CS0qUa5c3hWqVVy0Xw9zRY2Gc4wRUkOkECLdRg
	8+KbUZ+9SEckWEMulKuQKZMubXim+qBxg3P3Wo+T7BrbghmabIqORmoA2/f+H6Z7oZIE3F5oY4h
	oSyBHF/A42FtLeyrozcHXGl6nyZGqlOi5poOAQYbBb7qPn3EsogxIRLcs0ItfT5Dj9tZE2W3Z0t
	QBnJDadqlW00mDfreot3jEJ5elllekbMwkCddpZqI93vZSeITR
X-Google-Smtp-Source: AGHT+IH4BgyhtjQ6aAK/eANfM70fuqbmBXp38dAAyIsWduO5W2Y5IejVtVYXYVWdCO6+aJeJ0iJSng==
X-Received: by 2002:a05:6a20:6a27:b0:350:d523:808d with SMTP id adf61e73a8af0-36150e6b162mr14792076637.15.1764011782031;
        Mon, 24 Nov 2025 11:16:22 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:16:21 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:13:52 +0800
Subject: [PATCH v3 09/19] mm, swap: swap entry of a bad slot should not be
 considered as swapped out
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-9-33f54f707a5c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=4721;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=zJsDgTvoRf5ue0A09hZMBoXms74WK9KtuFF78M2jiUM=;
 b=wEJdetMpxtMi4VDQmNp3IzzjeOOKJVStHD+BWwhHDiebKbwfmQiNS/Ue8io/7d460vuXnxeCl
 8Yg+a6i0i2vD3t/fSngjap9MV78qj0T5rRMHgifocJ6AaXj1T4lydd0
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 578AF40002
X-Stat-Signature: 7cmxq3o98ru1i69ot8xca8qha75ug6o3
X-Rspam-User: 
X-HE-Tag: 1764011783-624891
X-HE-Meta: U2FsdGVkX1/E6U6FumlEawv7Fjypf5Ckl2qEG5Vzvff/vcTPLiTD4EM0/h9Y+nO6Xy5Oj81ph2fGuzhWMytg3ETc9XIHv/vQ7Xnrc98LxxUky4jb7vYUoTyfEkfbNyrfOoYRXFVxTJy57HHPvtjo5WfXtGChfxco7YP3i2dCMm8Sjsw/JZqTUUYA1dJCoh20GSS5NWlD7evlb86Kuptl39MnCPqQ891Kkch6JCvs7fVyuI8O7Y1T2vhf7D0OjCpDgV/RGxWB1VBQJQNXBuSfraUfubkc5l09mPP8F9JuCb/jE7k83RlaMzKcCqh05QnAdn+Ci9UqYVSpgleE13lITtQ2FZQBpCPvMkQha3EW+z7wlRc+VSNW9PV8Q3wDosIP1jEcHEjd+wChFj3NNmKxs2mwGJrV9zQBeRmk/3611ONSpia8JgONz2sypnAZhzEIBEYcUl4Qn9duYhAEyOlidj7YOQDXdEsIGc7lV+kNf24J5c0v5qkl5XcZeigYIBWARHoSrcjPcUUpP/+cgjVo5Sf6dXDc0tUNvIEfKVqkOmWbmj1sE9zgILkdFYWhCu/ytUotAycwKpDGrh8JAAvloKJOjcBcsQfTt35CeyX477Ws0DFpHMVkcW5QxPcNwAqhgxu18pAISAWBZf2dhqnVDcjgQR0x0GXGjkcbk1Xt3BVgCZd9o8NrfGIgElD5UJ5e0yJ6v/Ru9a5VPcg6v7cNhE3HODbhfXLZRVIgUCrIgHgr3PnPuvBD30hC660uciz1vJlZa8jy2H8gQINHSN75h1j1WTHfJE/4dDxzooETLrzrdsivQLpeWUcLG6AzwCOGe2tkt4jJcXd0g2YxtDlXFVMlHjBZ/3u//cokoH9ogzexYLbmddCQj4hoObSsS/fpy2XI5BzbHnbiiuxuwMpn59PTGhxeR8KOUHrc3USzVLl+y+BaZPr8pjkxVDxabXF5fAwXYdx7ai18JcHppWP
 L7ruOfpW
 jU+vDRctpxewavzSUHebNL6mww6YsM3pikYn/6RE8iPmKMm/7gSLoH8FwMQ6FaEXmZL0Yt0hjzFdrj9EstaPBHu46iCn6YBaiGCCaPDMBM0MUbdhJsorSkb2Tam/P39meZ+aI6hTLd5Tuv1pvDRU9WUgU96/U9TJbrfk3zdRZpoZHZXBitlC6MFkDvD8M/Mv6Cph+9Kf2eU+oMDccjcJUGfdKKPiTNVip9UoJEqSmBXUkyOLkOjQh0x9MV1OoJT7R2Dtxs1cdLXmVk2z72YTsuoDNnpms581ekSQi+4tclzEkozYCEuQFIssaQEB6HZO59+bC+EybA+DEssPYy6fGEBUhL4b0x2hIKqRCiGUmvZCe75eVXEykRW6wFHi/GSAclyzMgU8iJBIv3yV0R2kQe2GPUxd90wJlPHrEEhebOiCnnXI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

When checking if a swap entry is swapped out, we simply check if the
bitwise result of the count value is larger than 0. But SWAP_MAP_BAD
will also be considered as a swao count value larger than 0.

SWAP_MAP_BAD being considered as a count value larger than 0 is useful
for the swap allocator: they will be seen as a used slot, so the
allocator will skip them. But for the swapped out check, this
isn't correct.

There is currently no observable issue. The swapped out check is only
useful for readahead and folio swapped-out status check. For readahead,
the swap cache layer will abort upon checking and updating the swap map.
For the folio swapped out status check, the swap allocator will never
allocate an entry of bad slots to folio, so that part is fine too. The
worst that could happen now is redundant allocation/freeing of folios
and waste CPU time.

This also makes it easier to get rid of swap map checking and update
during folio insertion in the swap cache layer.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |  6 ++++--
 mm/swap_state.c      |  4 ++--
 mm/swapfile.c        | 22 +++++++++++-----------
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index bf72b548a96d..936fa8f9e5f3 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -466,7 +466,8 @@ int find_first_swap(dev_t *device);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int __swap_count(swp_entry_t entry);
-extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
+extern bool swap_entry_swapped(struct swap_info_struct *si,
+			       unsigned long offset);
 extern int swp_swapcount(swp_entry_t entry);
 struct backing_dev_info;
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
@@ -535,7 +536,8 @@ static inline int __swap_count(swp_entry_t entry)
 	return 0;
 }
 
-static inline bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
+static inline bool swap_entry_swapped(struct swap_info_struct *si,
+				      unsigned long offset)
 {
 	return false;
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index e3c01e5bc978..a99411b70c99 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -527,8 +527,8 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 	if (folio)
 		return folio;
 
-	/* Skip allocation for unused swap slot for readahead path. */
-	if (!swap_entry_swapped(si, entry))
+	/* Skip allocation for unused and bad swap slot for readahead. */
+	if (!swap_entry_swapped(si, swp_offset(entry)))
 		return NULL;
 
 	/* Allocate a new folio to be added into the swap cache. */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index cc07246985ef..cb59930b6415 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1762,21 +1762,21 @@ int __swap_count(swp_entry_t entry)
 	return swap_count(si->swap_map[offset]);
 }
 
-/*
- * How many references to @entry are currently swapped out?
- * This does not give an exact answer when swap count is continued,
- * but does include the high COUNT_CONTINUED flag to allow for that.
+/**
+ * swap_entry_swapped - Check if the swap entry at @offset is swapped.
+ * @si: the swap device.
+ * @offset: offset of the swap entry.
  */
-bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
+bool swap_entry_swapped(struct swap_info_struct *si, unsigned long offset)
 {
-	pgoff_t offset = swp_offset(entry);
 	struct swap_cluster_info *ci;
 	int count;
 
 	ci = swap_cluster_lock(si, offset);
 	count = swap_count(si->swap_map[offset]);
 	swap_cluster_unlock(ci);
-	return !!count;
+
+	return count && count != SWAP_MAP_BAD;
 }
 
 /*
@@ -1862,7 +1862,7 @@ static bool folio_swapped(struct folio *folio)
 		return false;
 
 	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
-		return swap_entry_swapped(si, entry);
+		return swap_entry_swapped(si, swp_offset(entry));
 
 	return swap_page_trans_huge_swapped(si, entry, folio_order(folio));
 }
@@ -3673,10 +3673,10 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 		count = si->swap_map[offset + i];
 
 		/*
-		 * swapin_readahead() doesn't check if a swap entry is valid, so the
-		 * swap entry could be SWAP_MAP_BAD. Check here with lock held.
+		 * Allocator never allocates bad slots, and readahead is guarded
+		 * by swap_entry_swapped.
 		 */
-		if (unlikely(swap_count(count) == SWAP_MAP_BAD)) {
+		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD)) {
 			err = -ENOENT;
 			goto unlock_out;
 		}

-- 
2.52.0


