Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2807BD2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FDE96B00A7; Thu,  4 Dec 2025 14:30:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AE006B00C0; Thu,  4 Dec 2025 14:30:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676BF6B00C1; Thu,  4 Dec 2025 14:30:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 524816B00A7
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:30:37 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16986C0397
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:37 +0000 (UTC)
X-FDA: 84182780514.14.7F2CBDA
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1BC8580002
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SPLjukJF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876635; a=rsa-sha256;
	cv=none;
	b=zoc8p+iaa8J86CShlROXBRDodRIHpOO3pyivip/mAphBBXEna+NmGU+ZiUPs9SZnhEOBa/
	fYiagkjScF77SEYLfQqJKRDy4Jtxhd/DzFvUmcRsPoCjbNZGu8ZTSL1i9INlNXHkZKw1U8
	I5laYw8WIq9lmoq75mOk1geVVhk+v/k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SPLjukJF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tv4aqICLd9L4YLKBploMWc2xd03ojcYwn13tRVcUQXg=;
	b=diVqywElR/djSWCxNPQJGrr6c11ciwmBZOT64mm9OsE0s25IMC+USic2W9XD2z4zFgPMtc
	tC0l+cISFz0halOi+XboPxfQt86LXpwM0BaYg5SXI7GTLIh5YDdNdRSpDxPLxCkYGgp0ui
	mJL8s5BR1u3IK5efM1eKUxI6viB9hQk=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29806bd47b5so8164345ad.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876634; x=1765481434; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tv4aqICLd9L4YLKBploMWc2xd03ojcYwn13tRVcUQXg=;
        b=SPLjukJFXw3S8wb0WrS9feGjLUs1EEarVQuhABJSQ3ldZzm49C99kUbZfIgKriPUHi
         lQ+E2xIYdCzEFUUAuqnE/fwxn5qEjuaYBzdnw/sOlhlaqgOr6Z1QqL5tsGsJ+3it+i7r
         MABvOHOsA8Qj3ZVuL72wQKpkrM2jGTf5Lbv9wZfh+6+Cro2scroG5yfCTC6sqBiBBguF
         im9OQyba5vvb4mRC2vmkDjpX113ovYKWqtySEpDci6dDukxAP1uaUrBDae2r8Qs1r89d
         M+RdwvrQXPdqwL0V4pn2NeOjIbHXuGt2UBcfjXSSD784IYuyiqlrGd5RahL59zXHZaxy
         VHTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876634; x=1765481434;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tv4aqICLd9L4YLKBploMWc2xd03ojcYwn13tRVcUQXg=;
        b=ivelf8QosX0EkXx/qfdgUellPdi1SZ05L0QAf4sro0swzJNWg2U0x0Xx13BtUmtu8z
         wYqAEq0JZRlzt/7odjTjGo3l3xZwmG5IwB1Q0IDCgpyXwBzRtkBISLT8YJ5IugvSG7ZV
         gCwsh+hJnRlnyC7gayMETLpDrtA8PBsczvgn0SKwsapDoRgqo7qADJmgJdU8P9/BpzST
         8icfABaw1V6P1Vdyx1zehvn2rAHtsrve6XydzLMy5MG+OGhRpvjIjYPVEohZOEry8x/0
         ywbHDc6qwWN2XSBIElcT6Nd8cft/DPdA1OkVqFdbSnAjeuEV+613j3CVRy5mAzXpqgQC
         dbkw==
X-Gm-Message-State: AOJu0Yy0G3jqaqtHJ7KjqYKiMGk8UkXIoUzLzupZWFQWUj3mO0vKq2U9
	dY0ff+TLHwRX8oAdC7j6PiqPOKmJUDQka2+F4f2vnjhdqFqRMpQ3h3AP
X-Gm-Gg: ASbGnctHw7J81KT408ZfseesZigiIwKPLCCeSUFdMMdrbC674bUaz7I3JmuqKE5bFGT
	dZumANvMUidkzySEshCmzwQ89HL5R5kJoVVuScWUP/XJthL9ZEtZHowVUz92mCvtG69SFOKyNJk
	lwPFYENyj9WhntqYGrLpYhW3wLrAqVzpWgClHJ48vKrXltxDsvMbwtFEVUAHUvDP7pH+qvwniGj
	+3w8+Oa3B0Ha5Wp0X+EKVGky2/N3xitm3rGngAnqINaG3EsTOEbaI4eh37eBsSztpZHicoPsiHj
	9i9GvHwfSiHefvagakUwi8EcJ4nVbAnETAJimQ6iliL8ZvzUJjUWpQkFI6UwRsobOHEQqy3xDe+
	1HywD9x2qY0z4AkArxGqdOyfJ9u49wsy3dzc0MMr6S3sPew+HU3nPVYEeDhHdbRzJaJWh+oZe44
	tYmC40+qZByy2EzePHw6z3q4zv2NBVYWv/j4riR0+mjMdSiDpN
X-Google-Smtp-Source: AGHT+IHXg3klf1bHAlWj25YlNRKccjBu8M+Fvq8/uOKLqB9fpvOKGlOKjcK7yS/s07jgXOUbSyhISw==
X-Received: by 2002:a17:902:c408:b0:295:557e:746a with SMTP id d9443c01a7336-29d682ef5edmr91403145ad.13.1764876633812;
        Thu, 04 Dec 2025 11:30:33 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:30:33 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:20 +0800
Subject: [PATCH v4 12/19] mm, swap: use swap cache as the swap in
 synchronize layer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-12-cb7e28a26a40@tencent.com>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
In-Reply-To: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=14399;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=k7XA6vA3z6eaz1At5HxTObmE+fBHx81TMOa8X6ZDU2c=;
 b=/r73yBSBbHZb0OA0OGJVs53E47Q6H9PNK4+1TyQTPPhXeZpRNFQXkWB7YdrsEBfJd/KviAoEw
 Wtj3Ry1Hk4ZAOP9V4qDgTRc7zVnNZ/EBWkahaeS4tSJXUXKMej+m4HK
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1BC8580002
X-Stat-Signature: z6ezgiamoi8zn8a79yd413y1k9domi99
X-Rspam-User: 
X-HE-Tag: 1764876634-112232
X-HE-Meta: U2FsdGVkX1+ZfSxTrF7PxUAvMlaA52R9MxuZN5KuGyBCpHrnKrdtyGPQSE53e8UGOpNpjy8TP5D7Ec82U6amu49aFlhzdFXhDY4w4nh64xLQFOmusPXFQrxH65VlStkJqDH6kmVRldZYElh/n/ETqwEu/B0G7/G6gALa1/1mZgNN/ZzfIQYcKLSdBvY/TV/o29ZPJ3TQTWOHmV9Q4l4v7NgGrpcNUYiW6xg19PiuMidW3ksSEaaI/tLxlbdsVPUwb+WrwF6UaC/eBPNtZadu7goMvxVucNKJDobvrLux11nLZjF38I7gC4ayeZ4HC7W/IqnR7tfDZJtGdTDreNfZfvKV/qwns0XDVZ5fXwhS3t/AQP5L1UZngoO8Ape/V9bsrWmfSHk8lYOeEGYrYMwoB+8KJeDx4upo0TZd4HhqGnf37/OaMx3r+4NePT80+fsHFYb6XM0Y/jc/Ofkp5F+a1XCQJGZTPL5sodgAQXLpV56msC+QlDsDtbvMYfbH7pGVyxkDGD/XTBDBU4zxj2zflYU5GFgdUeAyIx8nRyxKN/9oi6y/jJyflLy4nVjMoLcl47Bsp47i63oH6PlGWHVsTe7q3ixtHPC5EMpUppRTIUwe0pRMxdCtRkxlKPN9WrAZki63uYTOc7tYCZKdexTx/2emuxXbvcfi/RCaSBpHkSins9pfjCe0GosGQHFhpPt8/0yYBykt6xBvOvHLELtwom64pD4wHWtnVdwY4TuwFXummHEw/EQdCTRRJ2WtxsPdtPB8iaHb+H4jo8IYdLs/BnJVMQIdujbuK5GAct703PpSyi5C0UWXQaVeSR1doZ4Mp3DPVhnBHZZEoTCzYWo84oXk2r9zN6qrCygyt1GrCDEYddW9dGgQVL30FRPWJ+rUxSwXBoftVYyt+CkYbM3iSbwF4S5af/Lnpz8hnjZ62+X44RpHEuYblmpNcOd2h08ORT1eTJJ6jbAT+yOat2w
 7haR9W8l
 Iwh/vgL9ksZABAFajtiqXdSee0XdS8wd5iNJQFzFlauBC4MNHxjKwQzyy/N/8o8xBzotJ++Iu/c4lbZYyGdB1NQ4B1mxKuj00mTQhmHx51qn0Vl0xujrZ38axA4zl2mAbpA3mSGa+r42K1/p+UrKpgFPJ7LlsyxrxuJykIRAXpA8rnX/hpZEo6GmJU6W/mkYRmRMzDnuzcWg7tS89tt1vSxoxZE+2W6/4UhwwqzG+WfmBlsRcSZGbqTrfRN4ltOsRBXvrEdnrVCSZwXVZhy6/Pb4RvlOsdrkr0xeFYzqA9iJWSd6qokEsoy26zXuK+7xkUt1aW29QqutCptLIQ5GmQGIWBhLHkYFQu9zhPFzcNlEWMX4QlaF4WNOmlBW6MojDrmIIAxrH2G5C57eoAWjHM0FL+NirzXaIP02qdSifdnujTWxk5jqTU5DH9w==
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
index 0c5aad537716..df7df8b75e52 100644
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
index d9d943fc7b8d..f7c0a9eb5f04 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1476,7 +1476,11 @@ int folio_alloc_swap(struct folio *folio)
 	if (!entry.val)
 		return -ENOMEM;
 
-	swap_cache_add_folio(folio, entry, NULL);
+	/*
+	 * Allocator has pinned the slots with SWAP_HAS_CACHE
+	 * so it should never fail
+	 */
+	WARN_ON_ONCE(swap_cache_add_folio(folio, entry, NULL, true));
 
 	return 0;
 
@@ -1582,9 +1586,8 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
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
@@ -3768,17 +3771,25 @@ int swap_duplicate_nr(swp_entry_t entry, int nr)
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


