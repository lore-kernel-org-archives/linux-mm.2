Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF807D78770
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26CD66B008A; Fri, 19 Dec 2025 14:44:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DD2A6B008C; Fri, 19 Dec 2025 14:44:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 063116B0092; Fri, 19 Dec 2025 14:44:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7FE96B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:44:29 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A0B06140271
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:29 +0000 (UTC)
X-FDA: 84237247458.16.C043E12
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9D6C7C0004
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WzMmtvO2;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOM3SvUw6equ2pewheYxYcWCJBK1kBvmm5iLOdPjOeg=;
	b=kWHqYj33q2k7QCyllhlSVn1/lQWIXB/RAfvvBcqHQvW+XN9Zw6Fg62UydESsuWS9NKcPyE
	gt41n0rd85oug1ccQbYfU6V+PPJABvbxxxxBSRLMRW2n80W+ntvKWAci1a5vE1xucZ1a/z
	B+zEdTUVPBUc7UQ0o317rJqvPaHDDM4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WzMmtvO2;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173467; a=rsa-sha256;
	cv=none;
	b=050b2y8N3AFZUmXu0sctMVM/LUs/5Svdo0h6Rk+tupTj0+mu3ImwI1yG2vMVdqWjKom1qf
	cbRuFQSGS3exPv6886jS5pfspwE8Jw4bd1AXGX8haX0qgEYVfo6itt1MnlNFDZ5nE1Swdx
	SzUriJ4/4ECoM8JJqb+Mrk2fWrBn1PY=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a0b4320665so31999295ad.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173466; x=1766778266; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wOM3SvUw6equ2pewheYxYcWCJBK1kBvmm5iLOdPjOeg=;
        b=WzMmtvO2sak7UQpnpHSdws6xgQtSk6QRqNP7cGsW/Drcu5WP+6HEUo5ELmBsKLyOrJ
         uySU5zN+GptwXPj+hgxG4oPRNmuSuglw7ZEvED36xFlw4svhcQTZlHx2Vb5zZKs+jnMu
         FDvSfICChnX8/aJnSbVmE3UNi+1C5NaRRJd7Sh0yX2jmDvLi/15X7MAqCPQM/vQYWnYv
         7OKCopTqH/VE4x1d6xzkM4Qm7l+QuPjd8ilV2mMeubMLBl3OD8w9xWcgB8Z//KV3ltmI
         vVZBknzASzoWmHqYHAthgVbSrRSRhV/HKfmy3rumnfnC9z9j0Ql5RC+yz4LtZuHhl1Qj
         4GjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173466; x=1766778266;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wOM3SvUw6equ2pewheYxYcWCJBK1kBvmm5iLOdPjOeg=;
        b=o4K7cVnspX5u33IoxhMEXapYTIOeCzPudG633U/sqa6KbCqw/aWkGWfctlo5wk51WY
         9wkP26knKbRFRwp440OuNjrBEHvf1/4Oh8AYC6LVXKJgiIx5WCYWefMtbMePYsmOABw8
         VazkOm1OxDNuotYfmIBADq+vqUu9TzwL5ylVlRUSBe+DQUvO1NQHbUxpkx1zq2NoLdhH
         PWFf500DUVuyDGwSnGjoKb0J5hXG6omu5l2TmcMZWMUHOuXYwnD3dpnha8uI6TquuYmm
         WQAMVeAVbQnd9V02tkGdZn+VAlxu+R+gLFDccNLHkKfRQeMTdwp2C/u/ZtEXCCDw8KKz
         Reww==
X-Gm-Message-State: AOJu0YzdEU0xTVfgDVJojMTGQq4jAkMI3O18sEPrA4ovUmFnCOZpeJQE
	mnCrAvpHtzAsU+4KBZNTA2/nR6n+jPx4Ki++pZv6QpMAXj0/Loj7YrBZ
X-Gm-Gg: AY/fxX5Ay9+e6KH6dTmG/A3o6DFljgkpc0avfXOqRHfeOOUvVPouJlVVVyrADBDMLIB
	bz0gXFHL6wr9vbsw2i0gEm0KIzg2UHmrhTvlrS8oiv+MOgUORaQr/edp4gZciXmjJ17zIh0jmKa
	VtwspFl7gzqORGyOjMqQ0eXWoZusRCj3fm8LbcdjGV6jScJQZu7CtS+jqYKUFMwvAwS+9N4waHT
	af9Isw1BxQO3hpOpsjo8U2FlktLIH1ghINWrXqWSrT8iEMJD5c4yaJ0trcLJy01Mxyv4tZIjiU7
	0/QEcmimnSG1+MmeIggn6dVqdcs98eNE8XQb+p2slrarCv6oXQ+xtBwHSxJG/DyeHD0avH17IW3
	nHZOITvyTQgaHYejDf5SE6/b9FoktFWSSprml+EycSCMmYJcj4a3QA3NIya+Q/8kBKf7eeup4In
	DyvYdMtflnf+jGhI2h6goQrhslog8JRiTFIfpm+VQCyj+dODjIHc+d
X-Google-Smtp-Source: AGHT+IGrQ3Q/FdBKfcVai6hio6T0QoCziVZqMcESgeV47I7zHwMkeXW0Pae8tSt7dWOmGEe3IFAQeg==
X-Received: by 2002:a17:903:b90:b0:29d:7b9b:515b with SMTP id d9443c01a7336-2a2f2527092mr38887355ad.20.1766173466340;
        Fri, 19 Dec 2025 11:44:26 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:44:25 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:31 +0800
Subject: [PATCH v5 02/19] mm, swap: split swap cache preparation loop into
 a standalone helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-2-8862a265a033@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=7996;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=zTQ0qqEjQqVMue2feX7IfMCwec9b88xoOj9LChkN4Ao=;
 b=uwZ/nGWmMEjJ1Y+auph7TYnVzo/nsS072TR9lc38iy4sEmW/hjGgekZVoKCGLnY7cZO8ZNups
 hGIn0qnxc4rDjwVP4mT9B9Hd/tMdB+PZTz+DqL49qti049TRJB01+5Q
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam02
X-Stat-Signature: c31n4nz59f4utk4s7hwmyaxdsiprpdrn
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D6C7C0004
X-HE-Tag: 1766173467-567711
X-HE-Meta: U2FsdGVkX19myW5hx+wggD6hWt8s0BSwP1Yic6JE42++k/qYyAEybkwncZ7PDHQfdX2DHwCMscl6aqTAT9vIuBc/mZW7dT7kI6qZBByBYNZH7UPYPJTg4LmDKpBjKqjzZqvTYIEghFkf1JdSilQn+JTCB8eDdRrFkwMe/Wze6Ku+IPEVMjYHroIYRynSivyVIIVromqCrKzz4DR2fAW5DOjZ/oD2aYTAhIKdC4nUqrcTXgXTUORRw5EDhN8qPDQ916In1QaljKqWRrRqYziNfCn3yFkIBOT5Yg1llgPIkaUToPv0fodvuU1G6GnWELALy0eDWd3MGvvwoIwxyqz3tZJB8R85G4T1ZOQ608cJ8p50j3i4S65wRiGuFVNAfa2TkaDT4LIvfq8Bu+akQm3EV/LHZ8218EClk444nxs23r5+Z1SGekYy/kNEs5QiqQqP4mMpFm126B2yT5AhGmAARJMyUdYDLr3FtWODmyXWx1cWzf+G7U9JxNTE/ehstbt2XdLlGohQX5obCzJr7Ub9qd2hzpD5zi6VxjDPzuIJGPJjkwvtrW2uSgwMv9LEPP9qSVUzxPWc77vlpsbMrOjNtQz7m8bIagFqRDVQQXh4sYddjDVnDr8ur+ITk/D9loDyAh3q6T7MogU0qIxQpb/fJ7nQNAnS5OEe1t7qDYdzK+yMlx6tZXbpMHVvfBg0ic+hZLdXpe7iyEfvCGVdOurFF9OtnbualpKFK9McPkaOJihfldPEvXR3/w6CTSmOQr88Y3S6PkjdCWyKAr8wOH1AVDr0AsW/ghfCIcf1I60BRHE4pTUiI1fRhgp14SoVLbEo9Kz+n4fLTC7WwoPt1YLbhXEcXlJe135MKfTkgn6DmaIHjFCrxVdwDl1tFUgBK0xmE6IjmqisYWrwM5IH82LVwbLmmZMWbYpETEDdYxC39YzeP9UjRP5teIBy6wUACPV1xQTWNav03k70XuNUzNK
 VYTPLUSu
 CQfPIIS+OZO/c+ir4HftorEA5YWkdR7YGsQkpjEw70APuFexBQObQJr8FpqN3RCG+/W766BWz+lnzTOC9KnO0WLZLsxcOUfD57Uh0USufXxFwL7HQ/ublstr5fHYDWJmYZCm8lp5YUYQoliKYA/yu6aY+UHELkMLJ6EifZKJ8g3Bau2fsfpW5IZ/NgKMzT807GeGKUjjymdnum6dJuJDVx0qnoSLtzJytEazmhcD0I5/COKRbpioZQt0cnFe+4rgPjISjLXs9Ekkoro0Nc4bXDRvc/n8vKES+agsV9ahHBI4tToHRSFKrqBdlDhPMHXdDXhYoYK3g+6GVmFqLQPBWpPqv9kpUwAEMGYBoL4/0jZSCGhwMWoM30XDccIYaflRWbAFH/LCyspYeGN0CW3MJFQOPUIAMNXBnYyBxTxigkfaMTH6YvnasVZeNcbIbzYgBSbbmwf5ZGYKuDYM=
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


