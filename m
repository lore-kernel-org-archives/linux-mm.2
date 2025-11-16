Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 352C1CD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1158E002C; Sun, 16 Nov 2025 13:13:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882418E0029; Sun, 16 Nov 2025 13:13:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797538E002C; Sun, 16 Nov 2025 13:13:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62D858E0029
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:13:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3105313BFF4
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:16 +0000 (UTC)
X-FDA: 84117267192.19.FCD8FD3
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2930620008
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EhBwXpIr;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3d60INsDSU6i7HOv6EYKY0OXEVhkEWBQcdpSlm4Slwk=;
	b=KdYmjMaUMJXMq/MDXTaRNPHB6fsm8K+43ZP+b1Q/YHcE0LNhXUqFwEJQgojNCXv9njg5h/
	rbCGBPRSbv8s/bqab91Q7InNxepIvbal1lYoQu3phn5mYRk6OzgNzvNUzF3m4fUP4bOHtc
	CJLWn0tNncaJTqOweFoovxb40F2Nwb8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316794; a=rsa-sha256;
	cv=none;
	b=E2HFIBtjPvrKrJ9ohvM4/jQ0j7I79GnqpuvOc9rDs2C3tgBErN17UDDpku0Svu5aUknuRt
	Xoz6tV+26cV5fAu4aHyu3yozzq3vV+XlzZUeubaTSVAduP4fOHkiHoi2UAapSvXzzZ+JGL
	6Htte+PPILyF/r5swsYHDWUL/6AyKqU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EhBwXpIr;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b1bfd4b3deso291405085a.2
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316793; x=1763921593; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3d60INsDSU6i7HOv6EYKY0OXEVhkEWBQcdpSlm4Slwk=;
        b=EhBwXpIrHvHaOqkBQXNLI9fvgcNleADCIrzwzj0qFiimZjNLJQTh5Yb5vlDuOt0kdd
         yFlmwSq3zBc7UcTw8mEkUrHkeZBFpYZ0ojxIGkaoKpVlaih9D5o6scuE4y1MzQFGhcdE
         /y0BTp2n6pDvzPE1jT65qENdLopP+iQD8z7/FVZGKZah/9TS2iCu0CzzUXHgO8Bogn13
         v+VTIQNnrvHEw3CzwdlFdSgAyQ8QSv+cN7JSDyWQCZK6DKvB3yOIsxbrmV5ANDDHHCSz
         3eL4B8UfIho4fhsI788cpnRMM7BmaCnQ/pzXoHmvqEVVBln4Oazfdugk/j4fwEbm0SrG
         csgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316793; x=1763921593;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3d60INsDSU6i7HOv6EYKY0OXEVhkEWBQcdpSlm4Slwk=;
        b=DVc0i++pT0AsWrQQCxIvMWlLgfJHeA4BnVK/6USXQM8Q/xKIVa2ycHE2qxzDhqhevO
         hETta4wsSws8yLOxz0pMQSgvmBbIdIqWcAX1sC2TsfoK285W2UzCeSUrftE9E7mDI8WZ
         Ny07gmNMAg8dtMnKciz8s+xIsDe55pNEgppWKVFqBbTUJDrSxmI/1h7X5PGRV/B2x0uz
         MF0x5vDNZ/Ax1eWr4YbuIEGK+t889/n+7IRXXESoEA0r0TrVxlVnKEATmKXjy0aS2ZU6
         xMGXP0dtBNZsS6gtUujN2cXmqpVGurljYV31eomx5ler6J6vkd7Vx7uvk8rqIerwPTZ1
         GiWQ==
X-Gm-Message-State: AOJu0YwtUeAJqiwJ6sheB/6zTlilBlzbFLWhgptJtC3YTLAmv9nWNHXv
	dlzMe071u1Q69efW3gwbXDYX1xFNKNAhB9CJ9bIIkOnJqq3Ud3EKibyJ
X-Gm-Gg: ASbGnctAkMZdy/Dj2pMh7KRMwk9l07hiqznoOTiOkd/zQ6mxHyFUe2C6S9ZFmV6sCyR
	B9o0pQXDDsehElGwJpfSGwChY4q5c/ewO6hP2cugG6VOB5YbwJynlKGew0NKkG6hLC7AIPpYRv2
	f+XRBmmQl6ZwMHaITcPqiIeRsyqheD6tRX/f/IiknMCSqUvW329FBmuf+jEfL6pl0UTXd7DRmhE
	E85knMFY4Y6ePOcZUlK+zwQRkxWAKoBBimJsDHc7BuX+86BLw0zo5nyZFHiWMpgoZTaObgkoGb3
	NeuocwH/BiLJHfJ82LzkE+wO17auHT2n3aVft0a8wsnhPXdLTMTE03h3UiwGpJjJk/TREbP5e2u
	9Ntn9AeHcpDMyPD33OIMZ9jhZB1VxPr0B0H8EFlzQIJN7zAwmhAijYfrKc7LkCpjOLHn6ad0x8Z
	yIEqEIGCrs1BxNPceuEQMHw0Cp2IqtLd6uiauWRbJG4A==
X-Google-Smtp-Source: AGHT+IFiSA3zdC80N43gDA5WORx5Yp76poSWNhccE1nBcfNjYzuHLyL3SHkaHKBdTRLy7XThdSw86A==
X-Received: by 2002:a05:620a:c4b:b0:8a2:2e2b:2c72 with SMTP id af79cd13be357-8b2c315e657mr1197790585a.25.1763316793113;
        Sun, 16 Nov 2025 10:13:13 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:13:12 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:53 +0800
Subject: [PATCH v2 12/19] mm, swap: use swap cache as the swap in
 synchronize layer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-12-37730e6ea6d5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=14463;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=gbfZUGSA6CwsE3VLo/jCzjXTSSWjzdcwisbc3zsNooI=;
 b=+bfvwFeggdVy9/xW3pCYkwbTKmTWQfqB8Jvqg435CouGIaiWdqV03SBxFMLG19vPb2SU5vcMO
 WWA4ZbW0ExqDmXqiCr7u73EsP5rK60odZOh2WFxiP44NEPxCfDLeCSU
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2930620008
X-Stat-Signature: 6ejeesk37ri11x3hcgjwkn11xrt5o1m3
X-HE-Tag: 1763316794-272845
X-HE-Meta: U2FsdGVkX1+X1vKU+jSr7xdPrvK4Dx42yB+HHg3APGgBYKljmNYMN536CUwHYG1zdc/MvqwgKzf9PP+ruDlTsLsMCv9LTQUSs/He0PuikYdL2BhlzXN7ENRkq1z14+/8Pl5q0ydawGdqUOOJt/F03uwkKqWRCBuhnRCXG7amIkFTS3blc77nwX8SpsOOTh1g/o27DBPHitx9Cefd/74OR3mmT5+vzYSxpnJpJ9OKtVo6h4PvvtvxVsqsXKPT3tljynsSV8BwbdqZ5veofus8hCO8Tk6hAhwQGNLgy9MabECoAbNOeZFsEko4O6EuNv13okzWzV5j3UAWHaAaAt4YaeJY4ngoD4YCbI/M4tPwIhhgwaYIJBU6DpBkbIXZIPQSUrL4oADOM13yMkkDBdvkIbsBFoWnB5mzQLbyycSAlmx+K7GAnakIhB3KMN+kbI4COuJoci3VrEFRqg/cQiXRZRuzBDD8RaW0dkHCMc0bCNTU+Yuelhy46jGzSNAmruqZ2Mm3Ov4WaFyGRljQ8TkEmM+EAPwijTpMuRn5bcFn5CykReJFWmXSu6DPWuL95RglkTGMle6v//1ZDoh7hasCI2BottyZGSw/AHW/ZKUiSYIq6zqNC/N8RIZo4FnanI7od8cmmgrmesRkZHcSuqv8SZWcRnjR04zo08ns4R6NjsgZsUeygb/hI6JA3oZrCD2bsSHf+4wrvsp9ghGQjEEONq8Sc841KXRFORPrQpCdoZpujW4R83z3rpXFP1JJDUwDPODxZAdSNyW6OcL+a/mKIWq/WacTNIySppYfKjtKM9xEBt/KRL6KHPe+MQTDZirZ30XR/ZOssx0nz8zsLgNC58yPwRxgh25TIGocAZgX0W5/yFW+EkgiB801aokM2LCZllWVGeQEvvDoLfAd13uks508yPw1vu5RZtG6LHlyLubn5UOEsk3yK4bJWvb+/CtNVNH2b5XgI+sHBHcKHIz
 4iFXe2YR
 MsuXqSx9LS/q/EgBL3SBzYJKNlKjD6i0gJMtfC9YlJkni8eI/jUZxMWl7MIhKb40Soc3VI65vCk3cQsbb2/gzqb6vPh910MhLRHbu9udgFr39AkP0xHTRP3LU2nurvsHxtmp/4xJtsxyCU0YM73pLbTgtyNL9Q0E/ZjZiagCeVD9q3GDDfmKszF3BG00SDNhFAsnMlbSFrO3zpVI2To5LPNaYD+izVErRLbGtBg2z8EJt8KqQ77M9jj4aqRmaszoFvjHf/CqNIp/9ezJYqw0W24uiXyy7oDNJTpPtI/gZOTVQo/3IKjo9RXYTXzrf1w/7hQb6KV4GEjJG6MyEB2BNFmD7GRzZVq0HFiKzLK4Q+ep/aY4rorbOzawqLDiM5itOrURHPsQbL8DddCGea9SIsWSHxCN/xXkPAgjA5PhiZ+JTD0+Td46SP+QSJg==
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

This is the first step to remove this bit completely. This will also save
one bit for the 8-bit swap counting field.

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
 mm/swap_state.c      | 103 +++++++++++++++++++++++++++++----------------------
 mm/swapfile.c        |  39 ++++++++++++-------
 mm/vmscan.c          |   1 -
 5 files changed, 96 insertions(+), 68 deletions(-)

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
index cbcebda22d2e..cc2524e74120 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -128,34 +128,66 @@ void *swap_cache_get_shadow(swp_entry_t entry)
  * @entry: The swap entry corresponding to the folio.
  * @gfp: gfp_mask for XArray node allocation.
  * @shadowp: If a shadow is found, return the shadow.
+ * @alloc: If it's the allocator that is trying to insert a folio. Allocator
+ *         sets SWAP_HAS_CACHE to pin slots before insert so skip map update.
  *
  * Context: Caller must ensure @entry is valid and protect the swap device
  * with reference count or locks.
  * The caller also needs to update the corresponding swap_map slots with
  * SWAP_HAS_CACHE bit to avoid race or conflict.
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
@@ -168,6 +200,11 @@ void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadowp
 
 	if (shadowp)
 		*shadowp = shadow;
+	return 0;
+
+failed:
+	swap_cluster_unlock(ci);
+	return err;
 }
 
 /**
@@ -186,6 +223,7 @@ void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadowp
 void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 			    swp_entry_t entry, void *shadow)
 {
+	struct swap_info_struct *si;
 	unsigned long old_tb, new_tb;
 	unsigned int ci_start, ci_off, ci_end;
 	unsigned long nr_pages = folio_nr_pages(folio);
@@ -195,6 +233,7 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
 
+	si = __swap_entry_to_info(entry);
 	new_tb = shadow_swp_to_tb(shadow);
 	ci_start = swp_cluster_offset(entry);
 	ci_end = ci_start + nr_pages;
@@ -210,6 +249,7 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 	folio_clear_swapcache(folio);
 	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
+	__swapcache_clear_cached(si, ci, entry, nr_pages);
 }
 
 /**
@@ -231,7 +271,6 @@ void swap_cache_del_folio(struct folio *folio)
 	__swap_cache_del_folio(ci, folio, entry, NULL);
 	swap_cluster_unlock(ci);
 
-	put_swap_folio(folio, entry);
 	folio_ref_sub(folio, folio_nr_pages(folio));
 }
 
@@ -423,67 +462,37 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
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
@@ -491,6 +500,10 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
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
index 94d21b755c0c..6f334db651e2 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1463,7 +1463,11 @@ int folio_alloc_swap(struct folio *folio)
 	if (!entry.val)
 		return -ENOMEM;
 
-	swap_cache_add_folio(folio, entry, NULL);
+	/*
+	 * Allocator has pinned the slots with SWAP_HAS_CACHE
+	 * so it should never fail
+	 */
+	WARN_ON_ONCE(swap_cache_add_folio(folio, entry, NULL, true));
 
 	return 0;
 
@@ -1569,9 +1573,8 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
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
@@ -3756,17 +3759,25 @@ int swap_duplicate_nr(swp_entry_t entry, int nr)
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
index 807404e56e75..9ca9c58069ec 100644
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
2.51.2


