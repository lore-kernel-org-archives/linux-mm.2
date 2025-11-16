Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFAACCCD19A
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8E28E0031; Sun, 16 Nov 2025 13:13:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378B78E0029; Sun, 16 Nov 2025 13:13:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240D68E0031; Sun, 16 Nov 2025 13:13:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B7498E0029
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:13:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4528C0993
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:41 +0000 (UTC)
X-FDA: 84117268242.25.662A60E
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id C406C180004
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L1qWdxsq;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SavEcK2CMhgZIRsXzDOKK9GlP82rp8qYgxpZUC/TvE=;
	b=GELlgwxmgVyNyn7/vzLnSMDu6bs7nyuPoVEwgp1t/kZyJP8ghm0O0hGZh0ijAAH+Ak5mZE
	YECp+6H9TqTCp3C7YWOJyPCEp7hWxEZeDdNYZwxpT+PxU4yTYSaIbv7ZKvGzwMQ+imMVEy
	tzfVOSGaIE2D7ctdibYQ+rIkxdOYFsk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L1qWdxsq;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316819; a=rsa-sha256;
	cv=none;
	b=oLAFh0Q0xBiuiz0PGnQCw4JHL8kqi1Zd2dsNfYlXC+eW6Ilw1fi4NXlhUPwJ03Ecm30pQ7
	x5baXlkjElwwtbw3L5j22uP46IpUNEK5XLfbohc3xM+cm/oI+gXZSElZIyrScJcoTh+3e8
	tX21Ob2ea6CZeFgVWVPRTeuEZEaYags=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8b1bfd4b3deso291426585a.2
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316819; x=1763921619; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4SavEcK2CMhgZIRsXzDOKK9GlP82rp8qYgxpZUC/TvE=;
        b=L1qWdxsqd4cq50K9a2azHI/z1rua/cCi7esyLG9eCgt9t03MxFUX7/9nRDciJ7uyFk
         HFp35qzNRNNB+p77pcficPKiYO2qbQkV16eNb5oJ2uWon/ZJh8FmI1Txobpsjp2d7mWg
         zXWi4x1sVW71hQi9X+rzwbmD5Y2Gn9u9cUrn3/viBN+CK1CdczQo83NugsuQ6yqgUP93
         vdc4BirJbHMIlakqsXEqtsBnhspSd3haauvzM/RX4DXNEo9W5qWPFsPoQ0qvJR0kIk/M
         0nabxmoLhyds2hlfwOru5n6Jm1JqGwltAe5tpdC0rrjlyzWtzXMyd7PfamfR3EUcSr5h
         cNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316819; x=1763921619;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4SavEcK2CMhgZIRsXzDOKK9GlP82rp8qYgxpZUC/TvE=;
        b=tTBQ66oqsQ+ut6DXld/oDgMJm96t73dvH3W2pnCIdq0BKcl7pVktzIbsCopRbct3M7
         0rLmrpSQTprvZdehz1+j2YH+BHJg7PupuuligbxODM+PEvloBUJczVFP3Ub3QKebPA3T
         2gSzV6NGssRlBYY+fpdZ589d5zfB80ul46cKPD1RL2Nbv/59StXLmYtnlJ4z19ztHgnK
         crH/3CiBX2qXM54TIHmCLm2Bmk3ZuzdYIm3g/LpPu8m/CYbN1VWpoMKMqfEgNBvuSl1S
         7vjpl0czmbma3sPfugWgvIujHcoS4K/f3x0GX5keH+batE38I+QnvD/m01T0IQ0MZtAx
         iRIw==
X-Gm-Message-State: AOJu0YzX/9vFlQkVowgCn+HDG3srWwCesdjK7vBk/KwlOUnvBiq91fEh
	nkLyESX+pHGx5UTaJcQeGwrYtMVhGzlj5QDd9aqo+asuehDfSi0Gdx7X
X-Gm-Gg: ASbGncsT8vfSIDANGJkY/z9/DItpEUPXtoEwB+NM5tAiwFLFXg/oUOsg/jJCUVM7lxX
	Xc8kDJTN5jm8RHZpmcGQ3a5LgLloNDIhopIHXiInLQRLYO27yP3c/KgN3C0iDRURt8JxKTvf9Po
	qa9M5b15wT7mIT5XkFRW8aXN80l1hAIgkECdABN3hdgMZLqpvUbMLcqS2IM6eYxrcVIsnX/L+rt
	Y9vRSuyOvA8Tn3bNZfIIO1FI1VOz+68OZa0TWYeII0dNVhcFj2b1gHALY2/aAg5La3w+QaSYzpd
	fRf28JogWVfglQSxSC8mCsrr6Jva3JX8XFomiubpCveHEcLviPakn1LHHpuGmQsI/rsDYHxa2tB
	jV/cAitxx1Twrw8pY7CM1QfQ3VSSB0u6d25bXmu2n1GD/Xoo137r3uhGgUz5I0z8IazL5rv8qwk
	Vly0yDHc7LS6pQqIDsBC/gne179ESb6OdGQV4Adn/7skqmFIEe+5kI
X-Google-Smtp-Source: AGHT+IH8Tyd2HSeZUc6kE3TT8jmo8+Whz13UeInuARaMfSFdR+VwjUv6fdGQycCFONqBmWoHXyGNBg==
X-Received: by 2002:a05:620a:3941:b0:8b2:74e5:b13 with SMTP id af79cd13be357-8b2c315e77dmr1291207185a.32.1763316818689;
        Sun, 16 Nov 2025 10:13:38 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:13:38 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:57 +0800
Subject: [PATCH v2 16/19] mm, swap: check swap table directly for checking
 cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-16-37730e6ea6d5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=7942;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=4LpI0+nubS4oB/IzKKwW7+HHeGQMbTZwqJ7RekkxmGo=;
 b=BfhHqraQQgddSnRblDBV/DhFJETHAshg2hqQyk3fx7cdQg6LZuyml4vb9T0EXG0WRz2Evddtw
 3pcvF03q2E6B+CRONJEprqksBeE7MXyl+UW8rdD6kVZm7KGKnKq/EMu
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C406C180004
X-Stat-Signature: mosx1unyudofgkdogr58ryr677uo5zak
X-Rspam-User: 
X-HE-Tag: 1763316819-553152
X-HE-Meta: U2FsdGVkX1/ou5J/HfwzWehpzSQBqebwuYu+QZygt9CqZOozZeJc3nox1Xs993oJlxRGbylhB5GNA1nBclDj0VYDGdyqH28zqGz/j1OUCijw9kGLkqfdYCWbanF+J0R1yTYj4V/Wfbp4CZ7zbVTMZ4Ff/yZMMe01UtEp0PGwqi0h8gIASQ0WBQS3Rm7liQsShQ2RdfrNTSFW5W28+8F3ZU8aULWxH5hw/fkMr8/dp3OtzMTSoFjqBqvGgEla460DBNzwhavGJDvetVotKpvNhoGU77pY2NgpERVG2K1lZ7rrsNRHQETccnTMt6HXTYBcNuH0d1XjoI9R+vvmhrMIycC9wULYNhUGO+AmrGIJTjSXUhwlCH4f8ilgjEltudOQDDtkk46TllnOTpoE4dDAXUB8JoWoqkQxW4wVGI2cxP/ukLH0uLA/J2Tfj/In7qgtXIcP8rxxHExTgsCWsmzAldNaFdamrVByYxYslnx/TowQ+Gl9Q0MNTY8bDaQl39ulkrbRY7Hp3ucKkD/Gw0Hcogn0iGpy+yaXoKp359Iuq27DPy+gQlQbAsRIvHTt3AaVGOp7MTD0c5+OKrpL0hbTHtqwLljggPnS5AmuQlcRza7iX0crKf7KqUD9ST1qnxeblFRL3p5EDdI9TjVN4dipgh0BPaNH8pan7FalYS7KX55L3aC2ameiKTkNkIxmOz+Vcb50edEjQO8XOvc4tz+QXE+94EdJNRJNYjKu3li6d3dj5jHTiKvYzCQH/4g9glBgOaNXmZsyqhtvTQjFJZfPvcCjop3eCsDZLGFSPNRpuiwE2MjvmLZ723g/8NNAdlvG1Eo6hF2yWDWXG1O+dWEvumb11KU0jqvG/Pjq6I5SujrJn3SdyIrDIh5ECQOSUbHsICiH8yceAFuRnuTYGxPr14IvRaolB2Zm0Ah+1kLlMmUqSa3oo/jNm8TcUGZYl4156E1KlruK8j5dP3JOQ5e
 3wh0HXsD
 GGFcv8JpqCOC7n1PlxmmY9/YUM1c1LIy0QPXaxmSkG2/4IMpPUg3QFiV18LA5ghX1CtClzXyZ96f+wU77u0H62/MAzQTHvlSmdbZDZejTKJEPZJxSnu4TuFoMHDrQy5AzH6UhDacPJXzGZ57rk2t4+eHbPvIcSY/0Jp+80Dgi5h8IOZSELuvyGSo156yPG9K7T9vX+XWla7WBUYFHvD6I8ucXkLU3Y212zgqRzUIGrl9HwhUIhSVhBVvPQ4POKLfgahvaCH5GyCpRtXs2YsAk3PnrqQ2tlyuN4jV6QrOJbBDyHgfhav35252zNJATvIs+tlzMONi0nZoxGWNfTxPPwSN6BA0YHGo/FsHoehTQMKSkcTdm6D+Wg3VOL/vt8zR4XbCoa6wWxqc7nfea+6HBIE3lTeGgIuohN9of3F73Se7H+334U5ePOPtnTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of looking at the swap map, check swap table directly to tell
if a swap slot is cached. Prepares for the removal of SWAP_HAS_CACHE.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h        | 11 ++++++++---
 mm/swap_state.c  | 16 ++++++++++++++++
 mm/swapfile.c    | 55 +++++++++++++++++++++++++++++--------------------------
 mm/userfaultfd.c | 10 +++-------
 4 files changed, 56 insertions(+), 36 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index ec1ef7d0c35b..3692e143eeba 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -275,6 +275,7 @@ void __swapcache_clear_cached(struct swap_info_struct *si,
  *   swap entries in the page table, similar to locking swap cache folio.
  * - See the comment of get_swap_device() for more complex usage.
  */
+bool swap_cache_has_folio(swp_entry_t entry);
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_del_folio(struct folio *folio);
@@ -335,8 +336,6 @@ static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
 
 static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 {
-	struct swap_info_struct *si = __swap_entry_to_info(entry);
-	pgoff_t offset = swp_offset(entry);
 	int i;
 
 	/*
@@ -345,8 +344,9 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 	 * be in conflict with the folio in swap cache.
 	 */
 	for (i = 0; i < max_nr; i++) {
-		if ((si->swap_map[offset + i] & SWAP_HAS_CACHE))
+		if (swap_cache_has_folio(entry))
 			return i;
+		entry.val++;
 	}
 
 	return i;
@@ -449,6 +449,11 @@ static inline int swap_writeout(struct folio *folio,
 	return 0;
 }
 
+static inline bool swap_cache_has_folio(swp_entry_t entry)
+{
+	return false;
+}
+
 static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
 	return NULL;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index ca1b7954bbb8..e9ae7c09c2bf 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -103,6 +103,22 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)
 	return NULL;
 }
 
+/**
+ * swap_cache_has_folio - Check if a swap slot has cache.
+ * @entry: swap entry indicating the slot.
+ *
+ * Context: Caller must ensure @entry is valid and protect the swap
+ * device with reference count or locks.
+ */
+bool swap_cache_has_folio(swp_entry_t entry)
+{
+	unsigned long swp_tb;
+
+	swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
+				swp_cluster_offset(entry));
+	return swp_tb_is_folio(swp_tb);
+}
+
 /**
  * swap_cache_get_shadow - Looks up a shadow in the swap cache.
  * @entry: swap entry used for the lookup.
diff --git a/mm/swapfile.c b/mm/swapfile.c
index ea18096444d7..e321093d0552 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -788,23 +788,18 @@ static unsigned int cluster_reclaim_range(struct swap_info_struct *si,
 	unsigned int nr_pages = 1 << order;
 	unsigned long offset = start, end = start + nr_pages;
 	unsigned char *map = si->swap_map;
-	int nr_reclaim;
+	unsigned long swp_tb;
 
 	spin_unlock(&ci->lock);
 	do {
-		switch (READ_ONCE(map[offset])) {
-		case 0:
+		if (swap_count(READ_ONCE(map[offset])))
 			break;
-		case SWAP_HAS_CACHE:
-			nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-			if (nr_reclaim < 0)
-				goto out;
-			break;
-		default:
-			goto out;
+		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+		if (swp_tb_is_folio(swp_tb)) {
+			if (__try_to_reclaim_swap(si, offset, TTRS_ANYWAY) < 0)
+				break;
 		}
 	} while (++offset < end);
-out:
 	spin_lock(&ci->lock);
 
 	/*
@@ -820,37 +815,41 @@ static unsigned int cluster_reclaim_range(struct swap_info_struct *si,
 	 * Recheck the range no matter reclaim succeeded or not, the slot
 	 * could have been be freed while we are not holding the lock.
 	 */
-	for (offset = start; offset < end; offset++)
-		if (READ_ONCE(map[offset]))
+	for (offset = start; offset < end; offset++) {
+		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+		if (swap_count(map[offset]) || !swp_tb_is_null(swp_tb))
 			return SWAP_ENTRY_INVALID;
+	}
 
 	return start;
 }
 
 static bool cluster_scan_range(struct swap_info_struct *si,
 			       struct swap_cluster_info *ci,
-			       unsigned long start, unsigned int nr_pages,
+			       unsigned long offset, unsigned int nr_pages,
 			       bool *need_reclaim)
 {
-	unsigned long offset, end = start + nr_pages;
+	unsigned long end = offset + nr_pages;
 	unsigned char *map = si->swap_map;
+	unsigned long swp_tb;
 
 	if (cluster_is_empty(ci))
 		return true;
 
-	for (offset = start; offset < end; offset++) {
-		switch (READ_ONCE(map[offset])) {
-		case 0:
-			continue;
-		case SWAP_HAS_CACHE:
+	do {
+		if (swap_count(map[offset]))
+			return false;
+		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+		if (swp_tb_is_folio(swp_tb)) {
+			WARN_ON_ONCE(!(map[offset] & SWAP_HAS_CACHE));
 			if (!vm_swap_full())
 				return false;
 			*need_reclaim = true;
-			continue;
-		default:
-			return false;
+		} else {
+			/* A entry with no count and no cache must be null */
+			VM_WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
 		}
-	}
+	} while (++offset < end);
 
 	return true;
 }
@@ -1015,7 +1014,8 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		to_scan--;
 
 		while (offset < end) {
-			if (READ_ONCE(map[offset]) == SWAP_HAS_CACHE) {
+			if (!swap_count(READ_ONCE(map[offset])) &&
+			    swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER))) {
 				spin_unlock(&ci->lock);
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
 								   TTRS_ANYWAY);
@@ -1958,6 +1958,7 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 	struct swap_info_struct *si;
 	bool any_only_cache = false;
 	unsigned long offset;
+	unsigned long swp_tb;
 
 	si = get_swap_device(entry);
 	if (WARN_ON_ONCE(!si))
@@ -1982,7 +1983,9 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 	 */
 	for (offset = start_offset; offset < end_offset; offset += nr) {
 		nr = 1;
-		if (READ_ONCE(si->swap_map[offset]) == SWAP_HAS_CACHE) {
+		swp_tb = swap_table_get(__swap_offset_to_cluster(si, offset),
+					offset % SWAPFILE_CLUSTER);
+		if (!swap_count(READ_ONCE(si->swap_map[offset])) && swp_tb_is_folio(swp_tb)) {
 			/*
 			 * Folios are always naturally aligned in swap so
 			 * advance forward to the next boundary. Zero means no
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index bd1f74a7a5ac..bc2b1ae87a59 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1191,17 +1191,13 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 		 * Check if the swap entry is cached after acquiring the src_pte
 		 * lock. Otherwise, we might miss a newly loaded swap cache folio.
 		 *
-		 * Check swap_map directly to minimize overhead, READ_ONCE is sufficient.
 		 * We are trying to catch newly added swap cache, the only possible case is
 		 * when a folio is swapped in and out again staying in swap cache, using the
 		 * same entry before the PTE check above. The PTL is acquired and released
-		 * twice, each time after updating the swap_map's flag. So holding
-		 * the PTL here ensures we see the updated value. False positive is possible,
-		 * e.g. SWP_SYNCHRONOUS_IO swapin may set the flag without touching the
-		 * cache, or during the tiny synchronization window between swap cache and
-		 * swap_map, but it will be gone very quickly, worst result is retry jitters.
+		 * twice, each time after updating the swap table. So holding
+		 * the PTL here ensures we see the updated value.
 		 */
-		if (READ_ONCE(si->swap_map[swp_offset(entry)]) & SWAP_HAS_CACHE) {
+		if (swap_cache_has_folio(entry)) {
 			double_pt_unlock(dst_ptl, src_ptl);
 			return -EAGAIN;
 		}

-- 
2.51.2


