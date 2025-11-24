Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9CC4CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 141D26B002A; Mon, 24 Nov 2025 14:15:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119F86B002B; Mon, 24 Nov 2025 14:15:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02FE36B002E; Mon, 24 Nov 2025 14:15:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFF036B002A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:15:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC19E140545
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:15:50 +0000 (UTC)
X-FDA: 84146455260.25.D6CDB13
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5D6BF180003
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:15:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MXh52UDQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011748; a=rsa-sha256;
	cv=none;
	b=KkLy3xXM+BzyuCzASDJr/TmSBw9j2D7Wm+FMdpsMamw3WlK72uWTOSiIjt0b6zOOpMp/Nf
	QWUCXUX71BKgDar/e+FnSuHUu7kvmzCFso18T7bjY4NVnQQrsNbeUPG02tUP6XD2mznrzW
	/PhVJuxisva8yb6MCdCGUVySt7oE1HI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MXh52UDQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOM3SvUw6equ2pewheYxYcWCJBK1kBvmm5iLOdPjOeg=;
	b=kry6IauWyW/HmNfx3FaXD56N6EAb5C2C7Cb2xS3Q4/pyO+6/zO9pEEHPXizHNKVEm/NbDg
	hPZ4Qgd1Nf0ELq30c+l3b+LILYTytDze7sxDogvnw8Jft/s1nmbmdeHhaGFEwsB/wwRgnU
	GCmfpQKEZgBFWdKliUXykelu09G0h6U=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7b6dd81e2d4so4282088b3a.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011747; x=1764616547; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wOM3SvUw6equ2pewheYxYcWCJBK1kBvmm5iLOdPjOeg=;
        b=MXh52UDQafrS06TBSX7EiBE7Et3fDBnGIyJ37QbV/UupkDG0uldK7kOnd+wXOfBu7W
         hLqRoZPwPleR46uDtqb3Vkumt1kY+l5YEE6jTr7ewGg48fMSN10BSX6U2b8SEa6B+Mum
         HTp6o1Extwa0xVc0PXlyJCI0NtAErdsToKStL+iQbn4u48ppu8cTCmjey0bvNbbbT+4/
         3PNlD1zJrHkbrTnvDEpTxE6no1mtklaLoVqE2BdJfWSNiXW7zgjWWQ94Kj4xaPtTd1f2
         0z8JFRm0imikaRdTbGxexhacVDMpnR5YavznYm3bUwz/rxzsDQi7NCQ/AjWeeVRGKErX
         0lew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011747; x=1764616547;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wOM3SvUw6equ2pewheYxYcWCJBK1kBvmm5iLOdPjOeg=;
        b=Mrmqcdqzq8wfXsmmxB7WawgKKGvGuTxcmckF02UuwKt7N+Cm13z4ZPWtKW1v60V4V7
         ZBt+BZk5GGJ23T3hUixTX6UiRIlYw1nWYea+aZ9AO8BHE29vELlBrb+Nm8dyruB5Rqu/
         +XAVL2Sb+AkCLsSg48w/7s6u778nviebPU69oh/U46F5/gJLkJgnadpQbw3FRYrX2U/y
         dJtqnWyqTvM40Xp13dpT5C1+LOLxcQqWahylPXPV11j9sg5poDzO1qLsTOM3tVuaujFg
         LG37i/RMq/zgSOMd6jd78Ht98jknI6Sx4bjNtUSfj/zW6UwiRYky8td3TYhLGfdRUjtf
         1Isg==
X-Gm-Message-State: AOJu0YwqPH0x6O7q2zKd3SReuIvmmcCdj25R7zVwJK3O9sv9zh8hK5Dt
	P9mUK99KmIo8CfdID/emM3OpH2iADuQ9cR0W8ARSLJdcASGQEskNXOGC
X-Gm-Gg: ASbGncuyepBFVQb5jG6CBgX4I7KgCHIMiWpcGl7Y1d07ot4bpGzF82ct8vKtvn3fPUP
	wbyMhDFm6b1wqIfLBQQWTmefQ23AMOtvzPw9AWnLVPC/bYIw5kP7UMZIpoTP/fCMLBWazEQrmWu
	5X2If1Raq2AZhfbuB09DZQVf34NzEOa+jY8GuUZTYLbkkxzIGyQqsmuHMx41z50wCVq+FIds3xf
	wZJka8k7zqiqU5EwC+lv9J9J7U2Dtqi3bKXjIOkmYo+oqghdkhdqwahsn4v8aH4nwd93o1G9cgX
	JerWpP/Qu21v7kMguGQeqxi+YBNhHiPPeYi0Jlfw3zNP7kwLgj3DwlGGrjaCSluXM53rCVgQlOT
	wF4hOoMD6vht76aCCYLFEGFfABT2fSthUZbTjqKYAWonWoRiFKx0krJTbBvLjRXZzhSlVcn39gb
	af19Rfp6RqHPyrA7D4LBSU+GbGYOpHOm2+gDAe4priz8IXv2Bf
X-Google-Smtp-Source: AGHT+IF0TVKgirCriQhQIqanjTyXUXt/Fdsy4Pfg34dF7leoPxgPxDVoSG2O3RN3YQxVQcLSx4jiow==
X-Received: by 2002:a05:6a20:2449:b0:35e:7605:56bb with SMTP id adf61e73a8af0-3614eeb01a1mr15594864637.59.1764011747013;
        Mon, 24 Nov 2025 11:15:47 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:15:46 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:13:45 +0800
Subject: [PATCH v3 02/19] mm, swap: split swap cache preparation loop into
 a standalone helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-2-33f54f707a5c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=7996;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=zTQ0qqEjQqVMue2feX7IfMCwec9b88xoOj9LChkN4Ao=;
 b=/9/Zq1tFDJh0xOp/YKLyGKXbuQJ4l7zdp4kLU0qagMc4+s++qCl9m66xLq5XbU8mElb4CKQ7q
 NLMt6YLo2oXC5wNj3JSNLWb9ebHRjnpA16dEkppXixKYN6q/02l4FUj
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5D6BF180003
X-Stat-Signature: b84m3je7d13rfwknzdgfm4ppxbtrggqm
X-Rspam-User: 
X-HE-Tag: 1764011748-906532
X-HE-Meta: U2FsdGVkX19lyMJVEKzdNpXYs8ctqUbq8R5RcjR6nbE1PK9GL+LrPdMew6ThLTZQd0l6YZHw1yN3Wbv7lzvRGk2pztXqaiIzwhyswhFO+3diJ4YvFmjPJIz3v+BwClKtQLsbEVMVWjNr5baef3liR+Z6Fpxcy3gsME8v5kcmeLvi4ggYptwZxcoMw/vk9AwMzBGWd0uZdDa6u9rYfr/B63fWv6uvZ2KrW8T47wnYRzddLgVFGnY/0MwrM9zXkXQtWYkxj6RJhYbFWQMA408brdVeBGLZQEybgkxbN0vRRz19X0xHS/R0LK02mhEKbegav+r2FDKjSdvHYr3Jc5NuvgL6Wr9h9NIVYDx2Pzb3s9VnIdxvBopIYRz1RmzZA1vvO9CSwjqISx2GA3ZTq6esTf7pSh0XtcQ3cfm7p43Fcw+vsnGFZrdPwdz6DyPxb3eftwh9ZTdPcQDidVX/gCJUsb3EJiXFWIJIJ8QPkm1b3g7yav7NeD7ZqQXSKamn6pVYHGezJLk8yM99nQ6WfjdrfVeTb1TatriGnAQbjU3OQf/vlUIE3U0WA/UL59CGRkcqJs7FUylnnl7ymFsEgXm0nSuTx+rVhFIA856EGHauYoGt5V5s49Zg8xTvNrJN/R8x7J0giM/NklQRFLwJbU9LkpOP4WgDofoM4rxZabO6+A3J51TRQa6xLP0sipCHyBumNrXlDAOB1UJdZpTu66dip6IGIxgIgvmi/U7/3PW5x76WeGbMAPGhaJ5R7fdI4eE6JNrZzy8QzAUUgeP5vRHUpCL9i77JqtPWUHWXUCOnsbJ/LGqOagKaBY8+yI8SOOJwQ8KVJdN2Mnmha8DaHGUppe3PkKqchIbK+VUu1/MGg9TeYwrXjj6tJ3L9mIzn1A5059lrRNB6iNUTwWtmXR1kvyM0SwJVlSCbDG+pge9pXQOFNtmbQnrs1VhEvOCrE7S5X8NYOn0i6nCjwVASho/
 +u7XWZ6H
 RdwIcT2IQJ5LihUYbvg2cALExppyXUr9LC21zYNw9yPkKubfvkofkA+iG6+y/1djjt6TuX2tw60HWVNVgo558auAI/gF8Ik73mp66gVaoQ1M1u6/Jltf2RAX/qy58iKsHR/SruH2k7/JqgkV/AhtppexOhq1VxDGaQw2O0uUIOuvD3R8PDFE7t/J+MmL2AcFB6JMMzNITHS9Vpx5RU39v0tGpRL3qmg6iheAxk0kwB7mQ5ssZhnz2U1CsrpJHli9v2gPbpT8PHVXyN4M4GamEh+MyN6cWZlGuHiaE6UMpc2bzYec4HdOXfXeeY17lk96M96kTS8O5Jlvzc8q4HEUhqKEGcSKtlFuWVtGYsmZkQNDRiXxenniJmHG4vjCEWsioGZ918lukQw/REkOcIPxKo1VHHbgzb4S76QM0nEoVHsITU9Rrlo8fZNVc6owMMP4DIZkh2r9I9hlp9UA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To prepare for the removal of swap cache bypass swapin, introduce a new
helper that accepts an allocated and charged fresh folio, prepares the
folio, the swap map, and then adds the folio to the swap cache.

This doesn't change how swap cache works yet, we are still depending on
the SWAP_HAS_CACHE in the swap map for synchronization. But all
synchronization hacks are now all in this single helper.

No feature change.

Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 197 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 109 insertions(+), 88 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 08252eaef32f..a8511ce43242 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -402,6 +402,97 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 	}
 }
 
+/**
+ * __swap_cache_prepare_and_add - Prepare the folio and add it to swap cache.
+ * @entry: swap entry to be bound to the folio.
+ * @folio: folio to be added.
+ * @gfp: memory allocation flags for charge, can be 0 if @charged if true.
+ * @charged: if the folio is already charged.
+ * @skip_if_exists: if the slot is in a cached state, return NULL.
+ *                  This is an old workaround that will be removed shortly.
+ *
+ * Update the swap_map and add folio as swap cache, typically before swapin.
+ * All swap slots covered by the folio must have a non-zero swap count.
+ *
+ * Context: Caller must protect the swap device with reference count or locks.
+ * Return: Returns the folio being added on success. Returns the existing folio
+ * if @entry is already cached. Returns NULL if raced with swapin or swapoff.
+ */
+static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
+						  struct folio *folio,
+						  gfp_t gfp, bool charged,
+						  bool skip_if_exists)
+{
+	struct folio *swapcache;
+	void *shadow;
+	int ret;
+
+	/*
+	 * Check and pin the swap map with SWAP_HAS_CACHE, then add the folio
+	 * into the swap cache. Loop with a schedule delay if raced with
+	 * another process setting SWAP_HAS_CACHE. This hackish loop will
+	 * be fixed very soon.
+	 */
+	for (;;) {
+		ret = swapcache_prepare(entry, folio_nr_pages(folio));
+		if (!ret)
+			break;
+
+		/*
+		 * The skip_if_exists is for protecting against a recursive
+		 * call to this helper on the same entry waiting forever
+		 * here because SWAP_HAS_CACHE is set but the folio is not
+		 * in the swap cache yet. This can happen today if
+		 * mem_cgroup_swapin_charge_folio() below triggers reclaim
+		 * through zswap, which may call this helper again in the
+		 * writeback path.
+		 *
+		 * Large order allocation also needs special handling on
+		 * race: if a smaller folio exists in cache, swapin needs
+		 * to fallback to order 0, and doing a swap cache lookup
+		 * might return a folio that is irrelevant to the faulting
+		 * entry because @entry is aligned down. Just return NULL.
+		 */
+		if (ret != -EEXIST || skip_if_exists || folio_test_large(folio))
+			return NULL;
+
+		/*
+		 * Check the swap cache again, we can only arrive
+		 * here because swapcache_prepare returns -EEXIST.
+		 */
+		swapcache = swap_cache_get_folio(entry);
+		if (swapcache)
+			return swapcache;
+
+		/*
+		 * We might race against __swap_cache_del_folio(), and
+		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
+		 * has not yet been cleared.  Or race against another
+		 * swap_cache_alloc_folio(), which has set SWAP_HAS_CACHE
+		 * in swap_map, but not yet added its folio to swap cache.
+		 */
+		schedule_timeout_uninterruptible(1);
+	}
+
+	__folio_set_locked(folio);
+	__folio_set_swapbacked(folio);
+
+	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry)) {
+		put_swap_folio(folio, entry);
+		folio_unlock(folio);
+		return NULL;
+	}
+
+	swap_cache_add_folio(folio, entry, &shadow);
+	memcg1_swapin(entry, folio_nr_pages(folio));
+	if (shadow)
+		workingset_refault(folio, shadow);
+
+	/* Caller will initiate read into locked folio */
+	folio_add_lru(folio);
+	return folio;
+}
+
 /**
  * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
  * @entry: the swapped out swap entry to be binded to the folio.
@@ -428,99 +519,29 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct folio *folio;
-	struct folio *new_folio = NULL;
 	struct folio *result = NULL;
-	void *shadow = NULL;
 
 	*new_page_allocated = false;
-	for (;;) {
-		int err;
-
-		/*
-		 * Check the swap cache first, if a cached folio is found,
-		 * return it unlocked. The caller will lock and check it.
-		 */
-		folio = swap_cache_get_folio(entry);
-		if (folio)
-			goto got_folio;
-
-		/*
-		 * Just skip read ahead for unused swap slot.
-		 */
-		if (!swap_entry_swapped(si, entry))
-			goto put_and_return;
-
-		/*
-		 * Get a new folio to read into from swap.  Allocate it now if
-		 * new_folio not exist, before marking swap_map SWAP_HAS_CACHE,
-		 * when -EEXIST will cause any racers to loop around until we
-		 * add it to cache.
-		 */
-		if (!new_folio) {
-			new_folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id());
-			if (!new_folio)
-				goto put_and_return;
-		}
-
-		/*
-		 * Swap entry may have been freed since our caller observed it.
-		 */
-		err = swapcache_prepare(entry, 1);
-		if (!err)
-			break;
-		else if (err != -EEXIST)
-			goto put_and_return;
-
-		/*
-		 * Protect against a recursive call to swap_cache_alloc_folio()
-		 * on the same entry waiting forever here because SWAP_HAS_CACHE
-		 * is set but the folio is not the swap cache yet. This can
-		 * happen today if mem_cgroup_swapin_charge_folio() below
-		 * triggers reclaim through zswap, which may call
-		 * swap_cache_alloc_folio() in the writeback path.
-		 */
-		if (skip_if_exists)
-			goto put_and_return;
+	/* Check the swap cache again for readahead path. */
+	folio = swap_cache_get_folio(entry);
+	if (folio)
+		return folio;
 
-		/*
-		 * We might race against __swap_cache_del_folio(), and
-		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
-		 * has not yet been cleared.  Or race against another
-		 * swap_cache_alloc_folio(), which has set SWAP_HAS_CACHE
-		 * in swap_map, but not yet added its folio to swap cache.
-		 */
-		schedule_timeout_uninterruptible(1);
-	}
-
-	/*
-	 * The swap entry is ours to swap in. Prepare the new folio.
-	 */
-	__folio_set_locked(new_folio);
-	__folio_set_swapbacked(new_folio);
-
-	if (mem_cgroup_swapin_charge_folio(new_folio, NULL, gfp_mask, entry))
-		goto fail_unlock;
-
-	swap_cache_add_folio(new_folio, entry, &shadow);
-	memcg1_swapin(entry, 1);
+	/* Skip allocation for unused swap slot for readahead path. */
+	if (!swap_entry_swapped(si, entry))
+		return NULL;
 
-	if (shadow)
-		workingset_refault(new_folio, shadow);
-
-	/* Caller will initiate read into locked new_folio */
-	folio_add_lru(new_folio);
-	*new_page_allocated = true;
-	folio = new_folio;
-got_folio:
-	result = folio;
-	goto put_and_return;
-
-fail_unlock:
-	put_swap_folio(new_folio, entry);
-	folio_unlock(new_folio);
-put_and_return:
-	if (!(*new_page_allocated) && new_folio)
-		folio_put(new_folio);
+	/* Allocate a new folio to be added into the swap cache. */
+	folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id());
+	if (!folio)
+		return NULL;
+	/* Try add the new folio, returns existing folio or NULL on failure. */
+	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask,
+					      false, skip_if_exists);
+	if (result == folio)
+		*new_page_allocated = true;
+	else
+		folio_put(folio);
 	return result;
 }
 

-- 
2.52.0


