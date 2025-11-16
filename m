Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F0E9CD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFDB88E0015; Sun, 16 Nov 2025 13:12:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5778E0005; Sun, 16 Nov 2025 13:12:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB9F8E0015; Sun, 16 Nov 2025 13:12:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B792B8E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:12:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53E93BBE43
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:08 +0000 (UTC)
X-FDA: 84117264336.19.C42B2F1
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6083C40010
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PhHlwGqq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316726; a=rsa-sha256;
	cv=none;
	b=I+ZSrJA7ZRZ5AXHlyQOo3GYib7+/fmZrCB+qT1dT8v1+49vLjiJIlchiSyoxuBwZzJVV3e
	3G525XSi5gv6OZfpPxR3VGYH6pqgu5lu8BxyTOsR3r6E+9QNIe0FCJeXuCsrvDGAMHhDu+
	nPNSOf33KFLF4yd2uTIWNWV50GTfmgM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PhHlwGqq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NhZ6AXP7RAGh9uysgG1UlJvSzAeXVZ3It6HsfrK2kbA=;
	b=4gXlyBkOpHYruoXkF1MUgdjzQJQWiRoW/6fsfOdNHXkVIS/n/VaaH2gssgtctBC3qMUnLQ
	nila2CeaHOLctWu6MP1Vy6G3wYjhtma4dgLmlMFw9pH5wLn3qwz6YL5ls/Sse2f7TqdG6o
	RJ3XAlwqId03AtZrYxSH4kOgwLagqvg=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8b28f983333so366525485a.3
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316725; x=1763921525; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NhZ6AXP7RAGh9uysgG1UlJvSzAeXVZ3It6HsfrK2kbA=;
        b=PhHlwGqq+Ub7ys0xZzAQ0ZdGbGl1/56ghedxQqphsfbXxC4ihkVdzqaG+lusvfzPCK
         a4cPunx4W07ch+wJ9QlGk2Rg4TNtqpsN1X59Efx7hsO2VxwxnMmQpkPI2ruZxexLfz8o
         +xbcLnc+CP+K3ujTMDD94WyDVAEi/ODKlMV6QKZ88enIrHRuef2EdnmQ50hYg/ITxluG
         QIivamj+3bfs1mF9FYKq3vTp78j1DEKRCaLkgg2h4lEKIsfiuSfYyw9XBIw89khn+IeR
         onkwQ6ghJ+Jut5UwVCkSSgbgLURB+Tbu8+uheO1zHgRa2HFnUKbVKqEggglZFFWmTH48
         DfRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316725; x=1763921525;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NhZ6AXP7RAGh9uysgG1UlJvSzAeXVZ3It6HsfrK2kbA=;
        b=qKNO6Z/QoWsFfPj+YWggTXgoUKNi6nsIacHVM2Ipa/IdLsOEZ2iQp2BPkbxEnPCRB0
         91SlNNTTD3bC8goiqAY2TL+J63WGw1ZVWApyS5xNkD7xHYvXIFSkCh7xKTyLe8KxTC/T
         PfADRnQpGdKMOAmqLUBHPoRs95t3ZqfavfNKrLdh8GEOAqyFCihSVl92FwgBxGSmGSiW
         Zqgr38DP4mkvFBd2cYFzUyHVuAjgOcFrIY1+HjgP/3oLTlx0wpmwHrauSrJCguqkW1N7
         CF0nGLUQotTsDO+ER6b++de/yam9SPc5GpXnKdsT/XYrW4xYy7s6Ou0Z3Xhk1TM1wtFL
         HDAw==
X-Gm-Message-State: AOJu0YztWSRxX4AdjtEO8IwoeUIXu6XqtL1EcfSzNaCY6krJOzSLtLxw
	KaGXPcCI9XeGK3nDBeitTs0aXRxrI0D+zl9kQlGANj10wy1N1Gn17UaBtmrC3m4Ksds=
X-Gm-Gg: ASbGncuKHq9ch1nNX0fCEZ9Dxb33QWmKAQ5aAHOXtIaZn+8dMNpd2lv2O//EEbuXFzP
	39EsL5b1HH5YUqPckLWdNvkV1I5gCd35I61W6/LlWP4HQzv4SKfTqOFGV9SGafMGasrsrVyxdYA
	L/Xt/SqcFa+3SoGrrAKTcWyP7cVzfWswD4X00CSpkj6TWqCqNt/iWLQdL9sSg6Ximnl9FQeHQLU
	t49ZyF4yIqvEdABFX9ca7c1ZsisGN0LzuVUqeMt5CnR/HYpxgCHNzMqW8zgDH1Z1tY9r2DkmeLP
	mThkHsopLxzidqm+a5w2H783rLK/gvx782VT6TgHSuaEmGYf5vzMBIugQ3dlT/fz7cE77fz5y0k
	LTU2B0lw7LxbmkLKKs/SpnomkI9Oslp5uKZ9uvk/2kIngLkRnelLb2bdXoxojLbsgQZ/2/SG0ii
	FySG2Z4G37QRQQbQN4hh4yBXfV0zw85D/e0jALAXHIG2jyvREhnzos
X-Google-Smtp-Source: AGHT+IHAWu7Bk+kJ0k1Ixq1Qlx5fg/HwpueJA+4PmIS00LyzPvK6x+eQvNc97iR3Uswub2L27vjJpA==
X-Received: by 2002:a05:620a:3952:b0:8b2:6ac5:bce1 with SMTP id af79cd13be357-8b2c31a1308mr1194879185a.52.1763316725248;
        Sun, 16 Nov 2025 10:12:05 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:12:04 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:42 +0800
Subject: [PATCH v2 01/19] mm, swap: rename __read_swap_cache_async to
 swap_cache_alloc_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-1-37730e6ea6d5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=8749;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=LgE5Sjz+i9PJ11iVTTGTSw2inPWKcMkfPhBUgoQ/uFw=;
 b=ovbNvY8byXskgOsqWOv6d+dwDbXMvfs540wcXGorq+nFkeoYa8Psd0shfST/jWpJD2BymxDeQ
 2LLVgc00VXGBXdQfxqvI9CjDbGyQisHLuJjqb67Hw5M3kDB5ocj+qUW
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6083C40010
X-Stat-Signature: 51xhd18xcynin7a8dizdhnqdane171fb
X-HE-Tag: 1763316726-829405
X-HE-Meta: U2FsdGVkX18D9QHZZ//fUE3VAUi/r3DvEoNp8jET4RA0/TGAtslURpEnSPou4ohd53UoLEqwIfO5i27iBzF9b8G8u3V720JkXZ2BbYhxeb7wtb947iL4ifKFHPGrGfDqXHLAYlS3+LrNSTyPAHnqIxI9cKRPj97Rdsom16SSunyniNDMN1hEVEb5WZK6+B5M81SWsS46fgCoHiP8fjFZgBdB1nTUOxt/87sYCEeIblMQDCaxJNM88iagnWqg0qHTgTZt9KMhhA/rGgzSOhi/UVHXPL2T/jxmrpFZWRszGHmMuq67xqR39B7wCVAP0Qsjx9l1QsAHROmS6MTkWkOyp3dO3/wkTrA34DriKyHcd84MXx4EPDWO4objATVUbrL/FioDdNGMsen3hjSmUcUZkUoIPUIV66IXGgGugZ7mRlbvwtFCv3ZQeNwbYJQHUNrhm4P0mMRMIu30jyeUfdVazLxMISqkZuxpXufqONsI+2XMTJ1+EVQaE7RV92RGotx5s79Mjy2DcRLfUo9T1SaxBXulzZEXtvnUkevUMKx9M4BXWXJkEZqRZR9O6t/qWUnW2Np5ettZkXH2ZxzpPYc3xherhM756Tbgoh8aEXqDnTTlPRUqCic8CuCnbKQ09bfGS6/mZkj2fvEQUWyKgoEQ6WKKfFdye42m/I8+lo1BLMk/Z0sB/GMzuWi6M7M4Np9YT9nTBSiXSqG6Q/xn+XKMu/Vgbxzs7s5B4L+TsUxlLdzgMHzF21toq1ZuEeoQUlIcRtCcbHCtMTD9e4hpE4FwCduCzjnfl+yn9wgHnOMkuG1aokDJkWYq01bG65P12mpIHqoV2tkWetOZzzY8jJ93uKTXcjW9pRzqdNx91/d+030k7nuKoHubaLIcJJf6kmmqfs2gsVv7Py7gYmyp/bSO+doqIDX0IsBDYYCYadJXBDFuAgnJr7DLsbNSlOAgPLP782i62bfHKe21ySzmYQZ
 h0R0DFlz
 PXX68zliqoHDz9000jXBZKG53vGDSQKZUVP/XuWdjWvqpUHpPTGa7u/jjxE0kAieY16Fcl9fJMIIgs3Lv2X2+nf1+qQ7twY1+16nK55jp2fQKJXb1dlP6IWhbPYJAxGlZHD/DM9uyFApWNBafPlfmxIxs0lknAXdl3usP4TsoLalFGXwxEXC+X3UONDmPLEZZbKhiqIizvrRS4WT03o3bNLJXWL+likLzS7BZIQTsoBD4MMplH2fhRaEy9wWzg+ysKZdqf53zg3m499P67KfqvZYCjCdCVR0l6CL/7p6XTZxZVD7iUees5ACT4+tNSCcOVCRQKa9SMk20O9wbDl4aYik/Lt5StDyYg9bcO0ZwuSyyDJHqnP9IiXguzstkYmdpNEkS7AEdgEmwAK1mjGAYUI0v1g5i1sMYEquK2QPEDRc2rdTe8sRQF+UL5Sk4F+tkxuL0OxMowlSnjRpAYtHPLEbCWZ/E5xvxUqSa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

__read_swap_cache_async is widely used to allocate and ensure a folio is
in swapcache, or get the folio if a folio is already there.

It's not async, and it's not doing any read. Rename it to better present
its usage, and prepare to be reworked as part of new swap cache APIs.

Also, add some comments for the function. Worth noting that the
skip_if_exists argument is an long existing workaround that will be
dropped soon.

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h       |  6 +++---
 mm/swap_state.c | 50 +++++++++++++++++++++++++++++++++-----------------
 mm/swapfile.c   |  2 +-
 mm/zswap.c      |  4 ++--
 4 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index d034c13d8dd2..0fff92e42cfe 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -249,6 +249,9 @@ struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadow);
 void swap_cache_del_folio(struct folio *folio);
+struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
+				     struct mempolicy *mpol, pgoff_t ilx,
+				     bool *alloced, bool skip_if_exists);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry, void *shadow);
@@ -261,9 +264,6 @@ void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
 		struct swap_iocb **plug);
-struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_flags,
-		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
-		bool skip_if_exists);
 struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
 		struct mempolicy *mpol, pgoff_t ilx);
 struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
diff --git a/mm/swap_state.c b/mm/swap_state.c
index b2230f8a48fc..08252eaef32f 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -402,9 +402,29 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 	}
 }
 
-struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
-		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
-		bool skip_if_exists)
+/**
+ * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
+ * @entry: the swapped out swap entry to be binded to the folio.
+ * @gfp_mask: memory allocation flags
+ * @mpol: NUMA memory allocation policy to be applied
+ * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
+ * @new_page_allocated: sets true if allocation happened, false otherwise
+ * @skip_if_exists: if the slot is a partially cached state, return NULL.
+ *                  This is a workaround that would be removed shortly.
+ *
+ * Allocate a folio in the swap cache for one swap slot, typically before
+ * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
+ * @entry must have a non-zero swap count (swapped out).
+ * Currently only supports order 0.
+ *
+ * Context: Caller must protect the swap device with reference count or locks.
+ * Return: Returns the existing folio if @entry is cached already. Returns
+ * NULL if failed due to -ENOMEM or @entry have a swap count < 1.
+ */
+struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
+				     struct mempolicy *mpol, pgoff_t ilx,
+				     bool *new_page_allocated,
+				     bool skip_if_exists)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct folio *folio;
@@ -452,12 +472,12 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 			goto put_and_return;
 
 		/*
-		 * Protect against a recursive call to __read_swap_cache_async()
+		 * Protect against a recursive call to swap_cache_alloc_folio()
 		 * on the same entry waiting forever here because SWAP_HAS_CACHE
 		 * is set but the folio is not the swap cache yet. This can
 		 * happen today if mem_cgroup_swapin_charge_folio() below
 		 * triggers reclaim through zswap, which may call
-		 * __read_swap_cache_async() in the writeback path.
+		 * swap_cache_alloc_folio() in the writeback path.
 		 */
 		if (skip_if_exists)
 			goto put_and_return;
@@ -466,7 +486,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		 * We might race against __swap_cache_del_folio(), and
 		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
 		 * has not yet been cleared.  Or race against another
-		 * __read_swap_cache_async(), which has set SWAP_HAS_CACHE
+		 * swap_cache_alloc_folio(), which has set SWAP_HAS_CACHE
 		 * in swap_map, but not yet added its folio to swap cache.
 		 */
 		schedule_timeout_uninterruptible(1);
@@ -509,10 +529,6 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
  * and reading the disk if it is not already cached.
  * A failure return means that either the page allocation failed or that
  * the swap entry is no longer in use.
- *
- * get/put_swap_device() aren't needed to call this function, because
- * __read_swap_cache_async() call them and swap_read_folio() holds the
- * swap cache folio lock.
  */
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
@@ -529,7 +545,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		return NULL;
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
-	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
+	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
 					&page_allocated, false);
 	mpol_cond_put(mpol);
 
@@ -647,9 +663,9 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	blk_start_plug(&plug);
 	for (offset = start_offset; offset <= end_offset ; offset++) {
 		/* Ok, do the async read-ahead now */
-		folio = __read_swap_cache_async(
-				swp_entry(swp_type(entry), offset),
-				gfp_mask, mpol, ilx, &page_allocated, false);
+		folio = swap_cache_alloc_folio(
+			swp_entry(swp_type(entry), offset), gfp_mask, mpol, ilx,
+			&page_allocated, false);
 		if (!folio)
 			continue;
 		if (page_allocated) {
@@ -666,7 +682,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 skip:
 	/* The page was likely read above, so no need for plugging here */
-	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
+	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
 					&page_allocated, false);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
@@ -771,7 +787,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 			if (!si)
 				continue;
 		}
-		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
+		folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
 						&page_allocated, false);
 		if (si)
 			put_swap_device(si);
@@ -793,7 +809,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	lru_add_drain();
 skip:
 	/* The folio was likely read above, so no need for plugging here */
-	folio = __read_swap_cache_async(targ_entry, gfp_mask, mpol, targ_ilx,
+	folio = swap_cache_alloc_folio(targ_entry, gfp_mask, mpol, targ_ilx,
 					&page_allocated, false);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 94e0f0c54168..a2bb09867f1e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1573,7 +1573,7 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
  *   CPU1				CPU2
  *   do_swap_page()
  *     ...				swapoff+swapon
- *     __read_swap_cache_async()
+ *     swap_cache_alloc_folio()
  *       swapcache_prepare()
  *         __swap_duplicate()
  *           // check swap_map
diff --git a/mm/zswap.c b/mm/zswap.c
index 5d0f8b13a958..a7a2443912f4 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1014,8 +1014,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		return -EEXIST;
 
 	mpol = get_task_policy(current);
-	folio = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
-			NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
+	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
+				       NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
 	put_swap_device(si);
 	if (!folio)
 		return -ENOMEM;

-- 
2.51.2


