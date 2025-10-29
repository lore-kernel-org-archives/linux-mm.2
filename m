Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C89CCF9F1
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120C58E009C; Wed, 29 Oct 2025 11:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1DE8E0045; Wed, 29 Oct 2025 11:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00E3D8E009C; Wed, 29 Oct 2025 11:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E69338E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:59:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA95F160877
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:43 +0000 (UTC)
X-FDA: 84051612246.10.48BE31D
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id AEE1520010
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G9WywaLC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0PKlbwwkMgYNvXaDf4Er6Bj6mcJgZLUDsODPjxx62Q=;
	b=LxW9QeN1/lkWg6uavwbLB3+y0z2SW4T2dAZB8yXcM6ciyS3/inRI8mdXFsV5o59JJKepEy
	RoZ67RC0/94WoMFhVUgAX/kM1KBKF7mhSCRSt80nKl5jVUt49ECVRs8ZZ3Qqjt2IiWrTcF
	+WKFAXc5cgauniNizl9nhCeZLiQWtEs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753581; a=rsa-sha256;
	cv=none;
	b=08KWOvO0g1DxIuz7OvR66VrKRvyjWrnsgqmf7ve9LhWyJAvZlHLgYVfoFREBD3xSkhSBoU
	Uw6s6uRign3S8b4/qAoHWyiVVMFAi6dfAiTI8Ur6V5sqjtYWggpYYE3x9oZ1kg0LhUEHSr
	2Q1IBzqpwFIopWjqWqaZz7deymQlsJQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G9WywaLC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2947d345949so65399235ad.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753580; x=1762358380; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s0PKlbwwkMgYNvXaDf4Er6Bj6mcJgZLUDsODPjxx62Q=;
        b=G9WywaLC8zrpLxa8lp92lKQcqcaUUfKhZcd4YgOgZ912+1xw2RXKo4Ddf0sU5KmzT7
         2PSSjzoQC4IkipuPgh+x04q/ncpEG5okHfdseyZ1Ab2jXRc4iB60ar4vNdT4HwctHiTS
         cY49GPai48n+eN/vlS4JvoAzczfK11Zbsa9aJ6dM28Mt+mtggcNa1UntKs7dYXLE8c1Z
         yVU/H83FDud69Fc0MHVPx4gm1DtuxOSoLTBk21CEhRKDOme38Nhm7aeOw71e3MOTTVhA
         EQ4cCtKsAkAooAaeK8qoUSKHSgngQbJeGTY09BeD8li/J/WpUPmEdIQhP2PBZme7fnFM
         A3Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753580; x=1762358380;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s0PKlbwwkMgYNvXaDf4Er6Bj6mcJgZLUDsODPjxx62Q=;
        b=U8mvQPjCazwA2/WpsVPDk/r8NEVPUeJa5Evq38C7Ear9r/t4j3aGIWkQuo1Jy5ai4F
         uQ8y9BA8U+qAmq4adJCtY4ivCh2JNXUFyOGlYR1sybiZcJRv9jO3OUw3yLPtNjxjbVXj
         6znQ2ZmuFFvoD1LHHksw+f/WvxqCkqnE0APITz7osuDjznD44CE0FeY+x99pCxzLwuTR
         1WggY5N6lFgIr9YJXEHQJqws9JZ5MDZuGOlyWWIGfzVHsIVixJB1r6k+1tecj5TsJSrE
         XgDf5Y5KJw+VVoiEc1d0NP9UhcfmDaPpu2MLgptLgFpx77B+FkLdaCi+RwiGiAu0bgAw
         MdwA==
X-Gm-Message-State: AOJu0YxyVbZRT0R+f4GBohvvCMWaXtZPZUojDQBdrEHN78vwtbkYnOIB
	WpicuptaYhNwfdwBWMjYo7v5ecvdg0PGo9RA7OlorDnADUN3vYO1OOjL
X-Gm-Gg: ASbGncuFAT6cox1ng4ewyYn4LoKAg2bfIYwt6/KXWrPlZ5r35G30JrjCe5hA9oLdCH0
	YDZGRDWCSgtVhzzyIZWarV+pYLxQdSm4bbLHqgYz3qhNEYwYUZ2XGgVG4gP5xAeKp13GMLajRmE
	Kdlpc3qTbtVtoHvtjm/oJQFTCTa99Rk3TUdr29OWITf7F6VM1fsQUarAJdY+tEOIKDxVpzgu2Is
	uvM0w22cZnLbFX4YLrZGiOiU8rSy6e2dfaR9n1ojhDSgUHjM92n+59MeDdlcQjt+lzFRoAMBLQj
	4PgU3FoUMfjpZw4P8h/E7Pp6Gr4jjQ8L0XYQl8NvpjjRlv5omhtgx3Hit30LeXGqybzlN7OKq+1
	W9QybA/IGp7wQII2ErhqH5/oj+ntW9udpzNv5LtztUZazxFIvnu2rKYA/9S9F8dxx08a8RHObnp
	UKL/cc5ncgD5pavyvl5z6t
X-Google-Smtp-Source: AGHT+IGCBgmMdgFmMsePvkB0PmSb+aFjRIQoDbF7xmYjaqCG2xJ9PpuIvij1g6RTJtvdlQmxXngKtQ==
X-Received: by 2002:a17:902:e88b:b0:262:79a:93fb with SMTP id d9443c01a7336-294deea316fmr43936795ad.32.1761753580273;
        Wed, 29 Oct 2025 08:59:40 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.08.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:59:39 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:35 +0800
Subject: [PATCH 09/19] mm, swap: swap entry of a bad slot should not be
 considered as swapped out
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-9-3d43f3b6ec32@tencent.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: AEE1520010
X-Rspamd-Server: rspam02
X-Stat-Signature: 8k7759upgak7c5d6bafs7ziaakw4h3zh
X-HE-Tag: 1761753581-597521
X-HE-Meta: U2FsdGVkX18TxqB04qSLWKe9mgNvS6VwTiuW7kknCMZDN9hI/ssfsgAxvA+eHhswWpNCvKxnt4+0lKNeACac/ZAKgpc9zMm+j7NQ/T7QNNrjFMQyey3BGAP/bXwmsUuTzpnkLJyN5w34v7K6HfI+BAkJCY+Z0d62t/NvZeua6zmfUXb0LXdZVnXyhoTZLo9jUBMZuYcJtlPI49sk60STwqh3aRuiluv+FLUyjd5iRCgPt4rh1ypAxb5kFrdiX7xVt2z8SfITrd6ngnjWs0Ltb2krT4duv/XZBmPHumpaaMJ7XacTmuywgoKdhUDwDEjVoeSiafoHH7XDCuwqwqbtJvGZYJJTcFp/00SmWBrBhzuL81Vnd3h17McoBdlwQokM4bBWUs3K15v0FFyZrfZWOkhfVGOQoQe5NI+bcWEO/NmWE9dDR3uwNZX1foCuqiN8j1HUpWRMO2Mha/VfwMjk/Q+QACUNxyyCnnFh+F2cPLqWRnrMRyITPrma+tlV0dKXonRnZy57sJD5RaAV3cNW43feKl4Hla4wOVwP746eH8tsoaqOAgcV8kS59/zRQQhguuT4RrG4PEi+dw0NZ+8277Kf3G7oNZgsS2a1Ts/qrblEwQvAW8Re00BDhIpmd1GTqsdsoFaJI1aBvCqJkyZ86eFwzqrvtgtbC0CUVY7NEfUnfdLBQ5LoAZhORfo0oxmhpnQr21AuwOLSMYxy+WVoKncLMLzk9jiYmxCnk8JvzcBpdCtdE8BRYIJm2KUnJKNl9fBVaZeD2h0z/O1IlShnjV/L0uVScZ4UYEvrP4WuDHevs4gKSXaq9E46YNUYnsOjdGiBVvsUO+UQXhV01YxG+3jSUS5gV2uGrG6SwiJQMmyXGExNFn+4kX9xusHLgXvWRHdrsyTg/wWoz2U1boPFi+W66mTKpvQkfvrEU3S0oDZ8wzY2ra6ww8SfJq6KukxyDwBQoN1llIpnto2wFrX
 xR9maPVp
 dbiVoeq2aNmm9dZwrBb0hsTR7uHQnyzw37tkNBPkXHft+AwqMI3ONPfx7xt2Oo0wiOAe8IssJZeo5FxGN4+6Dx7zvpP5Ot3PPDmN8BSov/P19YTEYYD0nZnZGNbi+YJ7WpKded38l5qsVSciEwMrUP5QY0HHkDbOmR+bbqeX/jK3aTrs5jbII3PwV/dqHp42ahIP6qQb3/TaW4qwkSXJXl0zEaBKwUkbLpSS40gkGSC9qckE2+BU1s4y4UUM7njL0u+JlcTBh46FWRhjJqA4vyHqngMhW2UVK+j1neJfpKCmn8wb4zmb2ndxzBb5nltvRPs46K+DdAgfm5g3gx7hdtACyZpjcRcknyC6PCIcz5mYiWIqqTJah0FyrIQ+84w1zPAqBGq8O/mCSt57KhH2A8aUugNSrM+Fjhnj7/jovhDAj6vM=
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
index b3737c60aad9..aaf8d202434d 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -526,8 +526,8 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 	if (folio)
 		return folio;
 
-	/* Skip allocation for unused swap slot for readahead path. */
-	if (!swap_entry_swapped(si, entry))
+	/* Skip allocation for unused and bad swap slot for readahead. */
+	if (!swap_entry_swapped(si, swp_offset(entry)))
 		return NULL;
 
 	/* Allocate a new folio to be added into the swap cache. */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 55362bb2a781..d66141f1c452 100644
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
@@ -3671,10 +3671,10 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
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
2.51.1


