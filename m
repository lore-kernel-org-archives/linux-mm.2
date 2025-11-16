Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED53ECD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54D5E8E0026; Sun, 16 Nov 2025 13:12:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5250E8E0005; Sun, 16 Nov 2025 13:12:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43B2C8E0026; Sun, 16 Nov 2025 13:12:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3142E8E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:12:57 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E96C4140A67
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:56 +0000 (UTC)
X-FDA: 84117266352.26.78F41EB
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2ACF820007
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SaKZg716;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZOKrPxmb2yknUYuBNcmT2AdChM+0jcdM9YzJtn8wWw=;
	b=6qzo++Kyre05KSOLc3a0wMekUgDLmVFrOQ8IawWk/tud47ZA6lTNN+KKdt6izxV4PstUiw
	fjTN7fxGEYJwjmmfd7g+vyeqFS8B0z8xmTaT0wvFvkBxY6Xn9szK1oHRrSPmfRaYHj7isC
	paGmvWxzijspcgk7ocbCEC7Qg9d+z/k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316775; a=rsa-sha256;
	cv=none;
	b=Q5tm3hbJq4g7jrNZRxU1nsk35BiZVgYxAyBRtIaH5RE2XkVKLK8nJcqQR6LDJz5KDmSSWm
	1Ip8RLc3A9lYCpmFS94CqXyS18XFND8jxYK2Bn7mTrrK56MfKmYi5bMJwM94e9zclik4TN
	rjH+OdJexWkQUfXBmUTQuJAQ6otKNNQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SaKZg716;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8b1e54aefc5so312637185a.1
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316774; x=1763921574; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xZOKrPxmb2yknUYuBNcmT2AdChM+0jcdM9YzJtn8wWw=;
        b=SaKZg7162VtiHE1TxaBRUqf2qVPy6lW8UW1L2rMtY9wRjPtTXI5HX+x62otyF6niB7
         +nmsKI5u4cbzWe+lUsBiYJswGT1TrcKuGpIcXIL9KxAYAV3I1f9rwUvS1OHcc3bqjuhs
         Rzfe7HNFk3qKTUD8IP0aTODHKRZewUWWEHZKyicmVtzyuQlecBnsS/zM8b6fwe1sCpRT
         W86ooKjvfeRztm0u2ns7cT4t7CJGF0H5xjkef6imwHNy3dMrvzOZL5bbt/GtE2Ktfhs+
         0hmxq0ykjHtfznNn4LxwC2Yv163wE/8syTyuxyA1S9gcwl13+2z6wjiKIc6Yb3Z1M7uJ
         BUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316774; x=1763921574;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xZOKrPxmb2yknUYuBNcmT2AdChM+0jcdM9YzJtn8wWw=;
        b=eOHlGMs0kVeE6GW9+c3t30J8W4vMawuLSUHcVKVor1qzJISaspRtEHVINZbscwQQyY
         RMkRHhhaeQuSF84Eaw6OxrmCRtR/6Poa+4BBMRGOxKceqbHrL/FDNja6WtnKevKmy2/N
         EGYVKRpFHOPxb+68QRMo+HO8XbeqcNYOIKidEW5pF4GNbHmph7CiSDeFhhlCy+xMpyTF
         GNVL3M5or6hdFP1Q7UUhfMfaRBIE6gBbgp6lOFSrkg0A9XFlgGCswMmLlLR4pmD8PtZ2
         u8/RgV6itSUYF2ofbBKEK47nCC1vgogmRCynK935/wYgR3ECALAM+rf2j2wW2WuWaDdR
         q50g==
X-Gm-Message-State: AOJu0YypirPaUD5nSQyngTdGI+rlLL3B29F75vm+bKh3AygydSqHnb7R
	i2IcCSkLPXBmbuuO5DRXFmAgHRYkGrY59CPIuX4uQVeSZZGqV7v1nWqr
X-Gm-Gg: ASbGncs+dkG8eXDo9PQXuZd9k1ATFoNs6N6m8R3ew3P7GMBl/nNF9RZ+vS7WbCx8ngk
	eworqnrizYgXif0ZPh0b3+lUzw6pWdg1FKtHHV5oU0NlE6RiltkOUf7tYnunqVph9LI9UtJ+aHG
	aG3JfRqDBFWPnkCWIiuWKkD1OaEA/N75lNtJwTXWlFSQk9BLSzeh0uDMUzFY9MPZF0u7ROFKvLx
	rCG428Yem5PiQ8UBnSksPGSsTwKx0gUftmPQmA4t1XSdgnNohvLFDzOxWpqIVHudEZYYSEev9b/
	QkGqUeRv+jsRw8qp/T7/F44aY1qCQhjqSt1skYEaXV8f2bvWhoQ1Gddh3b42pckm0JnX32LrDLj
	4CDNzjefhfRwPAkkfiGegadURf+RXA3AufJbnOXOfcfkiMX68qYAM2hxt4uP7y0U1ljhs+p47Ei
	Aja/J4A/zhHntCHIoCb4s/y/T7VfhnGnWZ+qZNsM+sj7t4DlPEuCf2
X-Google-Smtp-Source: AGHT+IGOdJP/EsSTwaVr7AFygqAdGBuot84duSfzZCknJi9NXOfM5aRT2Xo2RnGeSbtxqEmDaKfJKQ==
X-Received: by 2002:a05:620a:370e:b0:88b:72c0:2169 with SMTP id af79cd13be357-8b2c31d26b4mr1257853385a.90.1763316774218;
        Sun, 16 Nov 2025 10:12:54 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:12:53 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:50 +0800
Subject: [PATCH v2 09/19] mm, swap: swap entry of a bad slot should not be
 considered as swapped out
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-9-37730e6ea6d5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=4721;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=sgwq02tPOBUNRyuiV2R8t3DdMa9GcyMTM6y5wg237JM=;
 b=0sOxzrOyuIFS8YnjIQJYvn9L24bV5TicCy3kyR9s2zrzrBPagFA+d4AP3z8w2OjrrECblyayO
 QKmE5kh6UmBBVxbf83nXuSr+wKaEnOGsK2U7R/mMwC5jEOk60axXTvs
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2ACF820007
X-Stat-Signature: f7p6ku5whd91yb1c1578m7pffxe56xha
X-HE-Tag: 1763316774-695222
X-HE-Meta: U2FsdGVkX1+MHdzZCoOM/DELt07izhMgy997ETiwUokf9tCYh2AxPKf1q3r0PYnIJiO13CJ4e1/Nj49iFsQjxNe1nWMFrhjlfdLyLnT7oOWwmnAahvHnL2fmWUb06wGGAtSjiFrKxEbhW9QF1WLUwEo7vT7+89KbAAVMe7LV5XCZcj6wLZGBCvnhUmBsvr97z4YK5TWfRFNOH7xRiuEalkoR/jm9q5k3jqcA6vp0nRhYBXhC12HCaU6ZKW1Jgd5nnDC90GQ5625Tefo7zKqFRS45QD32UAT8vXDO+cA6B5Pt3dVmAg/pAnpBqF2dkki5vTfLQlx8b9cNzR/K6Se36xt31cHSDIXjzo1qd4mYEgy/7VBiCg+HNWUsN0+vTgfBotRZ1qUwS64vdfMdlGPX+bebz1s768P9S+V3KoDGuzeE0NXMjSKD43XO1CGcfywZhq7GOmS1YbpgrwxlRYGq4D2KJqQl/Ozs6BvvDlMQT9t5qkPg8ouvXczOKkGaaXpz0Zg4MZL2jGgdGpm6BHBSWChDQgTiEqmCUp8nHWWhwI4ekpTMXZZnqX7aRnB8O/NF/yPRpeDZB5lCseMBDXac09k46pk/IkgKOO+/Lfp+5uVbp9lM90sR52PnwCoa8uzauFxbrl2OX8I4obUDurMupYnxLmKfPASPlYfgOmgPbIsIeGWG2QXjaTTZe2w0eUnbeHhjAdX4WXQA5TKh/4h2dt4v8Lrag7QVaEBM4zemLxSpb0rxuLdPZF2U4E6eEb0CfsQAxwHQfkSY/Desq+JilM2erA9sAer9XIXiJpRKvvzNeT+S2BG5GG9/fOgrtU00DuirjJVLrT81cey8NVgS8hwFHvsZRRGcuzgqVDfM8LIZTDBki+ga82ufCIQfzsz3LEdNkbtktPskAUMxvjtNvwsvkB/u1gQvho1u/6uFL51f7AjoIl7flFfXM9H0A0gk5s43N/WKtsrNj7VcBY+
 37A==
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
index 826bec661305..cbcebda22d2e 100644
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
index 580adf9d93bd..d2e60734ce8f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1765,21 +1765,21 @@ int __swap_count(swp_entry_t entry)
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
@@ -1865,7 +1865,7 @@ static bool folio_swapped(struct folio *folio)
 		return false;
 
 	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
-		return swap_entry_swapped(si, entry);
+		return swap_entry_swapped(si, swp_offset(entry));
 
 	return swap_page_trans_huge_swapped(si, entry, folio_order(folio));
 }
@@ -3677,10 +3677,10 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
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
2.51.2


