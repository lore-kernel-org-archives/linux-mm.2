Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81699CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:59:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E17758E0095; Wed, 29 Oct 2025 11:59:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEEC98E0045; Wed, 29 Oct 2025 11:59:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D051D8E0095; Wed, 29 Oct 2025 11:59:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE3358E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:59:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6CAA81A08D9
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:10 +0000 (UTC)
X-FDA: 84051610860.25.0B3552B
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1E3A84000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C4Ut6hsD;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753548; a=rsa-sha256;
	cv=none;
	b=7+e3728izYqp+3trW+q88TfIhdB+0q/5FQ3ypafL7dh20ErVv/g5i9m5rRp2JZih2aiWvt
	hLtSOHJgyd2IrvrMp5fT0SqBR70obPPWd0TuSs/hL5GN95L6F9cYRjqS6/HrlGadjWFbBW
	3dFf9FAb7XqFumEn734KI0Qys8vYq7o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C4Ut6hsD;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zhK86G+HkMMGSPEaLHkQ5V4087sDn+TsFFEp/mH7iIA=;
	b=6pvVFG7PvA5U7sNWgxIFBffLd/a4Y8GjE6zrfECZEqKQXswd+oNiMJKiaaXdwyFcLwmobd
	A/3gkMWeTiHArpg2RKTEMHENu7/x2yuN7Wh7xRUKPHw9Wpwx7Jx5Uyc+J7ljA8NDh8Dnnu
	mxeUVUoCBFCnVyJiatcymUESFJMYDXQ=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-340324d333dso16280a91.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753547; x=1762358347; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zhK86G+HkMMGSPEaLHkQ5V4087sDn+TsFFEp/mH7iIA=;
        b=C4Ut6hsDQSKg6c/XJsTh5MOX4VZEGMsBrk/y4gwdd1Z8TjdG7TKihFCcK5rbMAgGi7
         nDVBatevS07fPyUbbka9p7axSrxjtzRRDtmIjqrb/UCISYlpcG5lKt9pSXcEVjJ2HWEm
         YS+b1Df7LSGvtapTK+hlVpzk/X9oaX8aOZZ2RQpW9HqZh41G4g1MdQAzDc4N8XYDfKuI
         fXkFBF4a0BXT9ZgVcJzuX4kqxponIyCjk6tDAix39cVWEmUckn7OIpXBMIs3WZCE2DU1
         Owclcsnt3aur67F8utkuO7TkK9oengNyb/DgGmZmkECuorOJmh0MWFvF2x8S2I1xx9rL
         cfig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753547; x=1762358347;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhK86G+HkMMGSPEaLHkQ5V4087sDn+TsFFEp/mH7iIA=;
        b=rCmwZ2YmiDgC87ziCPTy1EyXrhXdMOM6UNNzFdn6FY1t+NTg8WGrROT/7kv/fe1s9+
         6LEKi130vS59JJUxBcGzRd2C8ua2ewp+5BFVBzqTInCTvV+Hk3mQy/5gQEz7iO9SwegN
         J9vUygrNahvS/lzjWwyOfgaek+Ktr9B9rnrCWopfdEq801nzBS20Sy8g0+sedBsua7T0
         lKjvIhgZfZZbtqbYYZ7VJWS1hp9OAeoOrMdRHCJFo0OE9NMj44jzPr5PQe/0rYBxWB+f
         jgNpzeSo7s3AUdQ8GDNkWhxfeyhQ/pxtfa1scmLyOpqUVNBlmoUliwjQqJ4rzXDbBWr9
         jMSQ==
X-Gm-Message-State: AOJu0YwvA5QqgRY4nzFgeP4MTiJAM2J+gNcY6ldmMj3eaV2ab18m/D73
	g3cBOYunW/VnPu1U/uhVn+BEeB53sPZ9nkbq3NZqzI9HV/jz8Rjod2sA
X-Gm-Gg: ASbGncsNEDKqeSw6ndKURI9fb7PiCpah6OR3VVyH2nPPikxYifOOYubfGINU53UnxMm
	q/uypEB+isDPJEEP6iSPRo5iM6iSR9hFPrS0S1GO/+HQU9ekNHzWzJofU5Y2tJQ6I3JUKSc+N2R
	4p8O3Ky7Mg8AAVQb8vpQcMfAuxQQ2bWyA3ptqODNbdl5y7R/Y5F6f/p/DrwrAwKPhGQb27f5ysJ
	UFlaCTda+tW5AHlNc/Va+vSaJB0VqUicPXNJxfuXI/VuNtbDPMx41Cbth6e2xo6g3ii0RJQgrfX
	S3AuOomnVM6zQnPcLuT2goH1ZuwDiTXYM55IlQMmIs+24L5jOikg0Jup4gnEA5qMqaZ4VI23Vss
	JJZMV35LouHUdW1mSSB+OpiFm74D2VA7tPKuo8ZEUvKOZfwxS8zYIdeWC76irYVqFEw4nwhJ2LT
	bRd79X6vD3HQ==
X-Google-Smtp-Source: AGHT+IHSchAAxtIz4UwFm8I+ff4dKglO2Nxh47GBLubgc7ZgXuU8QFpULQuCMGz4Njd/WWeyBqBAiQ==
X-Received: by 2002:a17:90b:4a08:b0:33e:2d0f:4788 with SMTP id 98e67ed59e1d1-3403a2a2323mr3784546a91.18.1761753546699;
        Wed, 29 Oct 2025 08:59:06 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.08.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:59:06 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:28 +0800
Subject: [PATCH 02/19] mm, swap: split swap cache preparation loop into a
 standalone helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-2-3d43f3b6ec32@tencent.com>
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
X-Stat-Signature: arycibnsx6tnn1jui53pwknef7g6jhtu
X-Rspamd-Queue-Id: 1E3A84000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1761753547-857202
X-HE-Meta: U2FsdGVkX1/w4b8jIKTCDPE6RdoytMcTaO3lJJMVJ2t9JwxkVj/cMt73oHv4YfmRx3ACUWd6rdzSEypz8aEjLqSH1x7Mvhd5TeWpSRfx1APT0kP4Yb1vpRkHgnFQt/E+eyj7Be5K6GEj5LITXcz7sjXeh1nWPKEAiVWx0VHDqYTqKJ3aLObAQCQw68inJN+wbhicn1RF5pZiyuSQTy2/VR8tgyrR/NF6UFkYAYIZqKAw4dWgIm/sFQhWo6fCxuCaUQ+q1FnNMekoi6Re7gVWNqlRdYk4/vmid6sEr4cF+gK1IPhzXeTCAsQnfKK8fW9SsbO9TSuouYhQInymBzszEQ+/K7aiXd5yWGSYAf3m1eis1+i19z2VDGCOxOfclT02Mg92ZuynO1Ns/wdUYRnHIiNVO6uYMBuzB6jxHVzXvxWVE2T4zFk9kfvFPdAtMK1elixJj5Q6Vb6yfdLby4fqhUECsCBDKvSwxZyPCUB1ODRg7w23W5DXeKAiLMJOq71Qju1373peauEV+Cf8IP/Fkj5DZ1xB+yiF6JUhS8shF/X/V4yOKi0uV4IrcU1reEI9EN7o26Z4miGhqkbXBnvniwIzD5XLdnxMF9hyZhVuAgJ7nNtzbBjpzUMa9IfwzfEbG0fBU3xzYBRictVGUkyqwQ+boFVjxs/CnTXOA0ZtO9JyevHzY3RGgd3aD9okWxzEAJZu5blrRrf1wjGgRFljAfroU1ogZiePlxCC4Go1BIAbHjALRCSUbrBAYIjUlvPmWF/5aevaorN8G1rw9nTxVHMKFlxOfnAVBKiPI2TigntFZWbRlsy1RL7HAwNmbGc+clrZHRBx5yxLrR/08GYIpBylSZY8zoruhttQ9G583jG+loEhz25gV+YyyPu5AONo0ZkonvK8YGA/KP9ybH+S82UUie52fimikRflYNfhI/aFJUChYizRwc/5jEN46kEqfFnSjJw3eRDbT+PthGd
 Zf3wOIAq
 iPvYZeJn8fsvuZ627yWmmfl9anZQR3p+1AOt0BihnQlH+oax18tSaYDy8ws2RDHKcmWKv977DBzvGT2HooJs/M2quI0AxNgbWF9cl6qZydNCC5nyLquAI3NPFvtsDwXszEBSLtWyTxH/VzGrUFRNCTNdHcvTP86H5iYVwHA6eO7dPr9UWnCSlZGEPMmznH2MO9S92WpVcRSg07GDInu7Kh2u35gEpNGX0a1fwIwC42K86st2NCFXSaYOnTg/sZqYH3rXcrnadGSO6/c4uYx0JTNXS1ZAeCh9JUQZ5xDDrqVQGFd+YtHRLBEgjpj/EVdenGbEQ7M3ya8C8zKQQMXhxcPAAuwv/V4WIQCO7/jkDtpQ/LdW5HSDdpVU469JyPmFulPHJagzXCtgQG+mYpWOZYp0ZwAQjEilibzWJbDz+Ea2OxPLe1E5t0bJCgQ==
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 197 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 109 insertions(+), 88 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 7765b9474632..d18ca765c04f 100644
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
+ * Return: Returns the folio being added on success. Returns the existing
+ * folio if @entry is cached. Returns NULL if raced with swapin or swapoff.
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
@@ -427,99 +518,29 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
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
2.51.1


