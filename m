Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A325DCFD351
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080B76B0024; Mon, 24 Nov 2025 14:16:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030F26B009F; Mon, 24 Nov 2025 14:16:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B376B00A1; Mon, 24 Nov 2025 14:16:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB4706B0024
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:16:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 87F45160569
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:40 +0000 (UTC)
X-FDA: 84146457360.08.DC0AA55
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 843A840007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YrCMyWnF;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pf/cbbwuQPv4so2HbL/+KOwhVvFF2m13qb5GevDv0r0=;
	b=cXhRZHhUk9v3WoAp/J0RC7EHPCMt/JaJ2RxZgfe/nVzfedX8KeNSYFEBccSS7Yla2qd0Xh
	rSWdT6Jn4b2OokM+5+qcsW50D++dAB0XsaIllzz6BbuIoX75jGH6EBX2liAO4o/AKs+ARV
	/dm/BOOqN56/PKO/Oa7s2RlcOziD9bM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YrCMyWnF;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011798; a=rsa-sha256;
	cv=none;
	b=h95/uCMfCCuFgKcuPr+MH+4I9OYWn7OdlDYZ05UUP7/zBYmPo5wXkUa/fVXG5I2vD9utZQ
	Q7wcA8TBfv0jlClOZzgtyb/yk/jyza12j6F7Uk3EwgYJ1tvwUB97UG/DUlcwzpRqnpgvmP
	URxLE6uaOheWBL+75KIMlFYINxt5Ugc=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7b9215e55e6so3207396b3a.2
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011797; x=1764616597; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pf/cbbwuQPv4so2HbL/+KOwhVvFF2m13qb5GevDv0r0=;
        b=YrCMyWnFI7EcWzh39aGxDT5jTWbnjhu9WnvmZkIyAlvAY7B7GZElfxLitYxksB84eE
         7kf3AbuoFyi0dJZWby/4gP7pUB8e6fogA3KGWo5VDxpkY2pGSJQif5iOBoS+H8cffZuf
         8Fc7xA2cZNvYrjrHOGrsgdONgzTx8kJJ7rmxgEGaxCr/rfk5wSSZvPZvMvgjtbZgpZeg
         gahz+t1hOAsSu/YGJv6olU48/35bIukHiE6mweYyvka8Mm3ZLOJpXgOkKmulP89kgP88
         9yYviT4cgZkRRXl5dxyT2U/uR48Np4ESl4h7vLYXtjeaY2xUM+4JPo8YAXUYESyZLwLb
         glJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011797; x=1764616597;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pf/cbbwuQPv4so2HbL/+KOwhVvFF2m13qb5GevDv0r0=;
        b=wRNZZWpNYxCeFXUC9LW1UdxpgtyH1GvJuKbgovea84UzBAj0Q7mf1147u5qM4Ky+Mi
         jbSIxxjo4UiXo+dCQ8ztub/kSyBF5N4ank5PTUXSZQVA+tAgsypGu9kx1hzRvUoLDMqY
         /BtKyO4iI3LhtyzBfwWfJdn6GlRqVjzW+jQFyiy6u9c3WdKaEupdemWRlLOmbJmHs1oq
         GG5c/+lGFvMVkcHGuU2LzWfBE9xoCpF6SFfOXuTWg1WcTHInxEbo5NLqK2Qdz9htC4sk
         QWmKMO8hOxRckqH/cI+adxcRDnr+b1DAs0CQ0SUizoOZcpOyCeQZV7Wrg+h/4R6gAGbT
         9Uzw==
X-Gm-Message-State: AOJu0YypaH+oXb8p/Erjdm+bWjZojXLXGKGzneVv4710UFd7Wa7FYSC9
	t9DVHfYGTphfQwo+g63e8rY0eZ6D9E9fhZdexdTzZ3YQygkoEdE1cezU
X-Gm-Gg: ASbGncu3pWboCuuzBBbiXJJFKo6gPIJSI7pIorwCB0FJyQK2vNwG0Y4akOq1P7BKy6U
	fubHin5BG8g3q6AwzDkG+FdmenGmbD6s4OyyX/BcGh/EBB+wQKoJwzYEMTAwb/f4Ze1k9NRnCmQ
	dh302R/cryLKsTlpwGW+bqppAK8MAAb0qA4qH668tlIRwM093Tjt6a8MPq7lr31KU0hEn4mpJ6a
	rSfmAlvkkP3vSizN9T9SMxQFZoiayXiOVgLN3Kr9FendQF2Aw/5C/q6Skib3CIg6t3i+0c/4TwD
	LtdzOOGin6i0cPRwR8SLC5jmV7gTVJQYo9qN+KVfuQND3BOhu1HMdJquY8j+iup6NAmB45f3jAm
	qsn9kgHU9Wumnh+5/pwAELcYnEqm3oOa/rLYawmfV6QNFaqOT13t2yA9PEVqM4HXjW55tG3/+yg
	d7XVckmUs8p/KtptlCwoTIsu4/AGxYV7ZoB11pmjSEEcxf37FD
X-Google-Smtp-Source: AGHT+IHQV5VkZCtvC5zBu86MTJiizn8IrXJuvUIUA4DHSYAWVjquEPbsNdHmE6Oo4mnT3yQLmT3QEA==
X-Received: by 2002:a05:6a20:e212:b0:359:8dd3:9121 with SMTP id adf61e73a8af0-3614ede036fmr14823031637.33.1764011797255;
        Mon, 24 Nov 2025 11:16:37 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:16:36 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:13:55 +0800
Subject: [PATCH v3 12/19] mm, swap: use swap cache as the swap in
 synchronize layer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-12-33f54f707a5c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=14399;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=0RMabqX1iKeFsfqlJddyVwD0HFh8SlI/mslw+tg5GjI=;
 b=Qnpu2MqwZJyyOQ1+BJr7bXDdnAvlaqDU0CYMvYp80uqoM1+Jq+mJh5u7Yyr4Raq+HkwbbKhOh
 jL6EfXLylVEBBqUwcy4TAQhZNUq/kgWZm1xCAGvBvoh4JT5d4h8h4Pn
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 843A840007
X-Stat-Signature: ikg4s1s9yyi5wq47ga6b9mt4q4gsgekx
X-Rspam-User: 
X-HE-Tag: 1764011798-391465
X-HE-Meta: U2FsdGVkX1+ti5/YvyLC4PI+g0bocJtQLLRf7hTJIK7+moXO9KvHcPif65zFBEyygZA0r9S2ddGypqP7ml7GN3q7cGcK0weZxuZy7LqPWl/VGDJ9ZfoKecplnROkFtEJizyMtJH5RljGh4syY++e6fiyZveuqxOByMeu8ys4KkVlV15aUUI7xvnIERjHKtvJKQhUsV17Xgdo0dehSjnioBdF/axwpBmOHjE+SusEi4XwWoOql5eGSRG1pXoKloAb1ID77QgU+6yaF6JWxMvUfYO3gPk+g3cPXx4A9gwiH+S7hwaKwUnxhtoHsyeKs4rF9Vy5hufBMZkU1FFbQVHI1XqQaLgyQGBhSniD85eXybloHbj5GAnOgJ3e9ws5EyRnPIO49C49pk29bY5vNmIzPvGqArO8hbueiTVu6g2SR1Mkz8PV1Td7swt7AJP8kp4TjMiy+M5nMH83y2qphI1HNLT0QHAGFMe2rYHVum3G3vV0BgLovp9tlzXrseNq7u/q7LvDmDvCYP8UVWVKxBBME9NJjXwzCvMJI2WPyY09L15qW6haAvsaydLh+B6b2aCv5enBreRO5qwt+MaXl5ibKsi+7p3BjZQkIhIXEkRfMNVEKPI9Xwgc0F93ZXsxoW3Q/qzmK+KtP+sY1y52QmR92ApQ+YlzjS1KMgV0fJskLPX2Ag/iCPlPhuWdztlnJhEqfJP3e5CKhVxIRGjTNiMvIaKtGQe+I5hvSXH/khbImQuywjRuFzwJzO4MN8t6f+Pkzu39G9OakeRHlfO/y5PrQDgb042ibuwqzKWt1+Uxum+LPYGfgAs3sJev0Hf6LZViAJFQ9OWOpvb/+M0ZOMmd9x8eJ2o/AJ3CGx/p98DYsLLO1gcpkwO2NpcKaKnuW3CmsGRSLCsxtyB3+sx7mmqFL/xMBJgR95e3PfHyNIFDiD+vfTMLeFyvO8jPST8w+Y2qHaMgTeBnWf25wmZHLEY
 G+9+8uIl
 ESGYatQqSJ+3HbmKS+DYJqP82jUrGyhfUb2Kx77Z609r3kCDSZDr1QO8tqwgzROe14sSP6L93gwCYipTUCi7E1RtQy7bNbw23HdgBxCnP6v757hx2mMN3g+vMV6NysewWlj/ip8eZKR1XARuOS/cxx4+z4XdBYj9vKsarxhV7uf/BHSf6GsqSQXv7muyB2Tvb44OSQdwgg90OfS9rwTEvrJKu2v+AO20mYDIzXnO6N7VMSL0b3op0KhR4KsQg+PbpL3J2znqzxyEfUefPRw5SOnErD2wgTTMp4SjgDbP0aroLL5TAXk67MgU3ZNXIcOGt/G/xEZdpuQr0sQIoDLO5ISNZAS94CndmRLX+WrTdi2Q/janjGYi2zlnwHLEZ8aH4aGrDU5OSK9FYZZNMCLuQ2HkYzav3gS39JDIKjqMAR+26s/OypspQbmDhxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Current swap in synchronization mostly uses the swap_map's
SWAP_HAS_CACHE bit. Whoever sets the bit first does the actual
work to swap in a folio.

This has been causing many issues as it's just a poor implementation
of a bit lock. Raced users have no idea what is pinning a slot, so
it has to loop with a schedule_timeout_uninterruptible(1), which is
ugly and causes long-tailing or other performance issues. Besides,
the abuse of SWAP_HAS_CACHE has been causing many other troubles for
synchronization or maintenance.

This is the first step to remove this bit completely.

We have just removed all swap in paths that bypass the swap cache, and
now both the swap cache and swap map are protected by the cluster lock.
So now we can just resolve the swap synchronization with the swap cache
layer directly using the cluster lock. Whoever inserts a folio in the
swap cache first does the swap in work. And because folios are locked
during swap operations, other raced users will just wait on the folio
lock.

The SWAP_HAS_CACHE will be removed in later commit. For now, we still set
it for some remaining users. But now we do the bit setting and swap cache
folio adding in the same critical section, after swap cache is ready.
No one will have to spin on the SWAP_HAS_CACHE bit anymore.

This both simplifies the logic and should improve the performance,
eliminating issues like the one solved in commit 01626a1823024
("mm: avoid unconditional one-tick sleep when swapcache_prepare fails"),
or the "skip_if_exists" from commit a65b0e7607ccb
("zswap: make shrinking memcg-aware"), which will be removed very soon.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |   6 ---
 mm/swap.h            |  15 +++++++-
 mm/swap_state.c      | 105 ++++++++++++++++++++++++++++-----------------------
 mm/swapfile.c        |  39 ++++++++++++-------
 mm/vmscan.c          |   1 -
 5 files changed, 96 insertions(+), 70 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 936fa8f9e5f3..69025b473472 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -458,7 +458,6 @@ void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
 extern int swap_duplicate_nr(swp_entry_t entry, int nr);
-extern int swapcache_prepare(swp_entry_t entry, int nr);
 extern void swap_free_nr(swp_entry_t entry, int nr_pages);
 extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
 int swap_type_of(dev_t device, sector_t offset);
@@ -518,11 +517,6 @@ static inline int swap_duplicate_nr(swp_entry_t swp, int nr_pages)
 	return 0;
 }
 
-static inline int swapcache_prepare(swp_entry_t swp, int nr)
-{
-	return 0;
-}
-
 static inline void swap_free_nr(swp_entry_t entry, int nr_pages)
 {
 }
diff --git a/mm/swap.h b/mm/swap.h
index e0f05babe13a..b5075a1aee04 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -234,6 +234,14 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
 	return folio_entry.val == round_down(entry.val, nr_pages);
 }
 
+/* Temporary internal helpers */
+void __swapcache_set_cached(struct swap_info_struct *si,
+			    struct swap_cluster_info *ci,
+			    swp_entry_t entry);
+void __swapcache_clear_cached(struct swap_info_struct *si,
+			      struct swap_cluster_info *ci,
+			      swp_entry_t entry, unsigned int nr);
+
 /*
  * All swap cache helpers below require the caller to ensure the swap entries
  * used are valid and stablize the device by any of the following ways:
@@ -247,7 +255,8 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
-void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadow);
+int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+			 void **shadow, bool alloc);
 void swap_cache_del_folio(struct folio *folio);
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
 				     struct mempolicy *mpol, pgoff_t ilx,
@@ -413,8 +422,10 @@ static inline void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
-static inline void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadow)
+static inline int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+				       void **shadow, bool alloc)
 {
+	return -ENOENT;
 }
 
 static inline void swap_cache_del_folio(struct folio *folio)
diff --git a/mm/swap_state.c b/mm/swap_state.c
index a99411b70c99..847763c6dd4a 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -128,34 +128,64 @@ void *swap_cache_get_shadow(swp_entry_t entry)
  * @entry: The swap entry corresponding to the folio.
  * @gfp: gfp_mask for XArray node allocation.
  * @shadowp: If a shadow is found, return the shadow.
+ * @alloc: If it's the allocator that is trying to insert a folio. Allocator
+ *         sets SWAP_HAS_CACHE to pin slots before insert so skip map update.
  *
  * Context: Caller must ensure @entry is valid and protect the swap device
  * with reference count or locks.
- * The caller also needs to update the corresponding swap_map slots with
- * SWAP_HAS_CACHE bit to avoid race or conflict.
  */
-void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadowp)
+int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+			 void **shadowp, bool alloc)
 {
+	int err;
 	void *shadow = NULL;
+	struct swap_info_struct *si;
 	unsigned long old_tb, new_tb;
 	struct swap_cluster_info *ci;
-	unsigned int ci_start, ci_off, ci_end;
+	unsigned int ci_start, ci_off, ci_end, offset;
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
 
+	si = __swap_entry_to_info(entry);
 	new_tb = folio_to_swp_tb(folio);
 	ci_start = swp_cluster_offset(entry);
 	ci_end = ci_start + nr_pages;
 	ci_off = ci_start;
-	ci = swap_cluster_lock(__swap_entry_to_info(entry), swp_offset(entry));
+	offset = swp_offset(entry);
+	ci = swap_cluster_lock(si, swp_offset(entry));
+	if (unlikely(!ci->table)) {
+		err = -ENOENT;
+		goto failed;
+	}
 	do {
-		old_tb = __swap_table_xchg(ci, ci_off, new_tb);
-		WARN_ON_ONCE(swp_tb_is_folio(old_tb));
+		old_tb = __swap_table_get(ci, ci_off);
+		if (unlikely(swp_tb_is_folio(old_tb))) {
+			err = -EEXIST;
+			goto failed;
+		}
+		if (!alloc && unlikely(!__swap_count(swp_entry(swp_type(entry), offset)))) {
+			err = -ENOENT;
+			goto failed;
+		}
 		if (swp_tb_is_shadow(old_tb))
 			shadow = swp_tb_to_shadow(old_tb);
+		offset++;
+	} while (++ci_off < ci_end);
+
+	ci_off = ci_start;
+	offset = swp_offset(entry);
+	do {
+		/*
+		 * Still need to pin the slots with SWAP_HAS_CACHE since
+		 * swap allocator depends on that.
+		 */
+		if (!alloc)
+			__swapcache_set_cached(si, ci, swp_entry(swp_type(entry), offset));
+		__swap_table_set(ci, ci_off, new_tb);
+		offset++;
 	} while (++ci_off < ci_end);
 
 	folio_ref_add(folio, nr_pages);
@@ -168,6 +198,11 @@ void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadowp
 
 	if (shadowp)
 		*shadowp = shadow;
+	return 0;
+
+failed:
+	swap_cluster_unlock(ci);
+	return err;
 }
 
 /**
@@ -186,6 +221,7 @@ void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadowp
 void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 			    swp_entry_t entry, void *shadow)
 {
+	struct swap_info_struct *si;
 	unsigned long old_tb, new_tb;
 	unsigned int ci_start, ci_off, ci_end;
 	unsigned long nr_pages = folio_nr_pages(folio);
@@ -195,6 +231,7 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
 
+	si = __swap_entry_to_info(entry);
 	new_tb = shadow_swp_to_tb(shadow);
 	ci_start = swp_cluster_offset(entry);
 	ci_end = ci_start + nr_pages;
@@ -210,6 +247,7 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 	folio_clear_swapcache(folio);
 	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
+	__swapcache_clear_cached(si, ci, entry, nr_pages);
 }
 
 /**
@@ -231,7 +269,6 @@ void swap_cache_del_folio(struct folio *folio)
 	__swap_cache_del_folio(ci, folio, entry, NULL);
 	swap_cluster_unlock(ci);
 
-	put_swap_folio(folio, entry);
 	folio_ref_sub(folio, folio_nr_pages(folio));
 }
 
@@ -423,67 +460,37 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 						  gfp_t gfp, bool charged,
 						  bool skip_if_exists)
 {
-	struct folio *swapcache;
+	struct folio *swapcache = NULL;
 	void *shadow;
 	int ret;
 
-	/*
-	 * Check and pin the swap map with SWAP_HAS_CACHE, then add the folio
-	 * into the swap cache. Loop with a schedule delay if raced with
-	 * another process setting SWAP_HAS_CACHE. This hackish loop will
-	 * be fixed very soon.
-	 */
+	__folio_set_locked(folio);
+	__folio_set_swapbacked(folio);
 	for (;;) {
-		ret = swapcache_prepare(entry, folio_nr_pages(folio));
+		ret = swap_cache_add_folio(folio, entry, &shadow, false);
 		if (!ret)
 			break;
 
 		/*
-		 * The skip_if_exists is for protecting against a recursive
-		 * call to this helper on the same entry waiting forever
-		 * here because SWAP_HAS_CACHE is set but the folio is not
-		 * in the swap cache yet. This can happen today if
-		 * mem_cgroup_swapin_charge_folio() below triggers reclaim
-		 * through zswap, which may call this helper again in the
-		 * writeback path.
-		 *
-		 * Large order allocation also needs special handling on
+		 * Large order allocation needs special handling on
 		 * race: if a smaller folio exists in cache, swapin needs
 		 * to fallback to order 0, and doing a swap cache lookup
 		 * might return a folio that is irrelevant to the faulting
 		 * entry because @entry is aligned down. Just return NULL.
 		 */
 		if (ret != -EEXIST || skip_if_exists || folio_test_large(folio))
-			return NULL;
+			goto failed;
 
-		/*
-		 * Check the swap cache again, we can only arrive
-		 * here because swapcache_prepare returns -EEXIST.
-		 */
 		swapcache = swap_cache_get_folio(entry);
 		if (swapcache)
-			return swapcache;
-
-		/*
-		 * We might race against __swap_cache_del_folio(), and
-		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
-		 * has not yet been cleared.  Or race against another
-		 * swap_cache_alloc_folio(), which has set SWAP_HAS_CACHE
-		 * in swap_map, but not yet added its folio to swap cache.
-		 */
-		schedule_timeout_uninterruptible(1);
+			goto failed;
 	}
 
-	__folio_set_locked(folio);
-	__folio_set_swapbacked(folio);
-
 	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry)) {
-		put_swap_folio(folio, entry);
-		folio_unlock(folio);
-		return NULL;
+		swap_cache_del_folio(folio);
+		goto failed;
 	}
 
-	swap_cache_add_folio(folio, entry, &shadow);
 	memcg1_swapin(entry, folio_nr_pages(folio));
 	if (shadow)
 		workingset_refault(folio, shadow);
@@ -491,6 +498,10 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 	/* Caller will initiate read into locked folio */
 	folio_add_lru(folio);
 	return folio;
+
+failed:
+	folio_unlock(folio);
+	return swapcache;
 }
 
 /**
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5b173ef0bc74..567aea6f1cd4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1472,7 +1472,11 @@ int folio_alloc_swap(struct folio *folio)
 	if (!entry.val)
 		return -ENOMEM;
 
-	swap_cache_add_folio(folio, entry, NULL);
+	/*
+	 * Allocator has pinned the slots with SWAP_HAS_CACHE
+	 * so it should never fail
+	 */
+	WARN_ON_ONCE(swap_cache_add_folio(folio, entry, NULL, true));
 
 	return 0;
 
@@ -1578,9 +1582,8 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
  *   do_swap_page()
  *     ...				swapoff+swapon
  *     swap_cache_alloc_folio()
- *       swapcache_prepare()
- *         __swap_duplicate()
- *           // check swap_map
+ *       swap_cache_add_folio()
+ *         // check swap_map
  *     // verify PTE not changed
  *
  * In __swap_duplicate(), the swap_map need to be checked before
@@ -3764,17 +3767,25 @@ int swap_duplicate_nr(swp_entry_t entry, int nr)
 	return err;
 }
 
-/*
- * @entry: first swap entry from which we allocate nr swap cache.
- *
- * Called when allocating swap cache for existing swap entries,
- * This can return error codes. Returns 0 at success.
- * -EEXIST means there is a swap cache.
- * Note: return code is different from swap_duplicate().
- */
-int swapcache_prepare(swp_entry_t entry, int nr)
+/* Mark the swap map as HAS_CACHE, caller need to hold the cluster lock */
+void __swapcache_set_cached(struct swap_info_struct *si,
+			    struct swap_cluster_info *ci,
+			    swp_entry_t entry)
+{
+	WARN_ON(swap_dup_entries(si, ci, swp_offset(entry), SWAP_HAS_CACHE, 1));
+}
+
+/* Clear the swap map as !HAS_CACHE, caller need to hold the cluster lock */
+void __swapcache_clear_cached(struct swap_info_struct *si,
+			      struct swap_cluster_info *ci,
+			      swp_entry_t entry, unsigned int nr)
 {
-	return __swap_duplicate(entry, SWAP_HAS_CACHE, nr);
+	if (swap_only_has_cache(si, swp_offset(entry), nr)) {
+		swap_entries_free(si, ci, entry, nr);
+	} else {
+		for (int i = 0; i < nr; i++, entry.val++)
+			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
+	}
 }
 
 /*
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3b85652a42b9..9483267ebf70 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -761,7 +761,6 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 		__swap_cache_del_folio(ci, folio, swap, shadow);
 		memcg1_swapout(folio, swap);
 		swap_cluster_unlock_irq(ci);
-		put_swap_folio(folio, swap);
 	} else {
 		void (*free_folio)(struct folio *);
 

-- 
2.52.0


