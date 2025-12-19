Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30BE4D7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E1D6B00A5; Fri, 19 Dec 2025 14:45:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95E966B00A7; Fri, 19 Dec 2025 14:45:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837306B00A8; Fri, 19 Dec 2025 14:45:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA4E6B00A5
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:45:17 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 356131401B8
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:17 +0000 (UTC)
X-FDA: 84237249474.05.5550A69
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 35F85C000C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NVWP1Z0B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173515; a=rsa-sha256;
	cv=none;
	b=AoE18yz7e25aAsFzJL/v5edRn1Lbwwu3YeA2Ap7OCsgvNi1DDbb0NtfbAGmWeDdGAfWPkF
	JjYj6zbuGCkIhN7WkMRasAVSi1O6AagngHymLjQp9rCMRoPNBMEuckWefqic4PcBbrWZgr
	UO0oSTo0z6+565V+EIUEvYE5FGDtzNA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NVWP1Z0B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OeT1TFSHDgDmGSm7JamkeKsgvgxmL4bkPd7iGrpb/dg=;
	b=mnau3yOgRnmQKxzI7DFAnuyQgujHTB0Q2i13zBfIF3YGvcpyRggp+n6md72bWJthB2P03G
	5MgJUA2wpH6GWxfowiUwkK6PDsNFU/FIjE458x51LsmipfSIIzZcI3ViOYMYGzq6YXVPAX
	tLz4rY0n4IiY0S43sljSgY7ED+m30xs=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso23499375ad.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173514; x=1766778314; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OeT1TFSHDgDmGSm7JamkeKsgvgxmL4bkPd7iGrpb/dg=;
        b=NVWP1Z0B6KEfx2G+kcsNPE/I1ily0ar1XzPx3Z9zk+zN5d6rH+J36AHVQYNEviQ9ZV
         4bAKyABGyeoszV0tXg9OBTqJhGucLbrRu5/ogMSGquCsdD132aQkANpdfIo4dQ7rNCVu
         LuCIdljC1JmZyeiP3CWBpe2UHSkGRAU6EhUAC2RomwJFi1IkeLpZPEnMTqALveiw5gsU
         cK8TEuGon3eio94z2WvFmJIw7VvxGcE0LtXHZLSdHby2MYYVsBBzF+VkveAYgc+SUtv7
         07ofILpIoaoJKNF+l5XZV3PL7SrSOEOuaLkDEgsCA4iB4j6gUW20Cxx1OKrUcGyTwLlQ
         H7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173514; x=1766778314;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OeT1TFSHDgDmGSm7JamkeKsgvgxmL4bkPd7iGrpb/dg=;
        b=NQgnVhTbeLlWM5DfQh19+mBNTxsP3trR68V+0xwijYl4EAqWqmwT8YhPK8UosTFgFD
         sYKCSamT/IerUfcoqnfJ2L2bDVB9YYNzwyPbC+E8RENqvhC+avE5HYm0aS87/oiiYDqz
         hkjLlP2B7LK24NDtzk6OQ0GMAzuFmD34bpPX7Hkgqp7dz+4oSqs5EVPxKSf3EEGmjAU1
         ElC0fXkIzM7TW/iINp38dzYeaVOQkuBHPfiqp/KSBPi7kix/A2DtXFxsqFIUNYaIVAVu
         rwP7Z5kmaaBUYcYxawLcPje/QJiGG/DDJbdZz2lcuZn44oD68OFpcDPZI/qtlKJ7DXiz
         /MrQ==
X-Gm-Message-State: AOJu0YxFqUAXLuyYYp/LP6ZmsLmhFfU67HiGg3ZeFKQbrfhMV+zKKZRe
	1hiCys1lu013cuQQtKMSzo0glmZl5j70KkZ1MAZmnYboMJCm0IJE7mli
X-Gm-Gg: AY/fxX52TLgczIMZNnKe1GrSiEFlIxW/+xmsbB6jF3ZXXXrnS6iXSHP4rh/SvyVMka2
	1J1ulKyIjZ07FKKS6kfM4fMceV+zSTvChkt5nHca9aR5h6IRNAU29pFj+kfJRlrbLBOCwU3llmi
	5vW0g0UgArfvnC6jwZPedlOKrrswuCB1f5F1YATymMNwhNwHzFi4I28rZt70ng1rEF2W5nmHjrm
	WW+C/wJqTRx5A3ddko2kPtsAxdYLOGhO9BP42o1+m97VIUMFDq5XCAYJZE2RJJWENsog2V8S+f6
	BZWhcrGdY0n3RoqL13HLeLMtAPZy0gIbkuSLT1wbG69+k16qy5pbwKqU2nO4oyV6QZfWJHKDS2r
	kkDzu4QpjmeR6bhUIQTqFw9ljr3p2xU4r0nBwOqQ11X1D08n/l6M7Fi2UeT9ZuRS2PLipC8v+uv
	sq/hXVszPxSveIevL8cfJ+9BgietYg2vV+6cPQ0z0iIIVmxj5vbPp/REJ5rE2hBjQ=
X-Google-Smtp-Source: AGHT+IHTuELgJagWiO9HF0bEHZrRLOvMc2Sd5Mamt8ZnZ2vAcpqNHk4koDJcao+DF2q7BAaL6JiIqg==
X-Received: by 2002:a17:902:e804:b0:2a1:388d:8ef5 with SMTP id d9443c01a7336-2a2f222be85mr35317645ad.19.1766173513922;
        Fri, 19 Dec 2025 11:45:13 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:45:13 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:41 +0800
Subject: [PATCH v5 12/19] mm, swap: use swap cache as the swap in
 synchronize layer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-12-8862a265a033@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=14397;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=J1Ds9O04g7V7tEQO5Qz0K9cHHMCuOrrjtcVKQms28oc=;
 b=1X83e/A5HlJfuwQ/5pAdROI2saGAmIgQhM4X0zbuqk3Oj3jEOz53TBO+Ip9LI22njC3SRqHZG
 d+FfS6v9kg0B9a2biE3jXZ7eiwKlGacY729m46yppz8IV4XmKURXyiC
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35F85C000C
X-Stat-Signature: ibigb3zqeeyihmbjx1ownsk6h5dofoeu
X-HE-Tag: 1766173515-981898
X-HE-Meta: U2FsdGVkX1+bE6PfoiJWtD9LmjM1bgCC5FstWI6ZK1RQrObsywKZAWUF29if6XoFFfv2JbWMuLYdeKc7PDWIv/huvVFWnyIStdbESnDGClCLBrS2ng9ZfK0nCgBsuv0KHBV12hsInnW9zN0R2bqH/89pWIkpED+jIJ3D9pJGJ0oNTMsUfMlHsqHGAliBlT4ZRDUycCvYhgKaA9AIBZLLXDE+g/maLXuSygy3d4Q6NeHZFo3Pm6E2ydYGpKdo6LCxlPG+NzfBjIgSG07TJekSy2aeuE+UELvATcVShPXIKQCFroWHjJ4UvKVA72l5jOiwO69cO5E3nE3hIE0oAZFYbVHkARLu8eKf/KkzvxMgCCs6B33qi0lm+4w49Zy+3mQtG9Db1znoekByTRl9DDLsqbOc1i+8E43k2CpZPcGkMVx28Eoy6pwjwx5bgRhq3dGgg4+sqKxKZ36LeDcS7FB+cXYzi7/8OUog6mljcKpsWmRymeYInnAPRa6hbvp5fIZ5XugnYgOOyeUq2I2u69mZzK9ummDPcCWEDbolpSVr+skcmp8jyTKDtUZHtzGJEaNBSxCniWHY5noKv8GmgJvSrUnmG3WywCZEN+v8OE2d085hrljzbQ2ewcMgRd8D0mSTYP5+65ej6SK1QwQLqvLIkqoXJT0d1G+DQtlclueygncwKjFxxX+yrg51+52pwX4qfCJX0u0TRngN/Ag7aDs4r0c92mlOHHPGfya/uDa7arFYv+jZvPGZXDkAndadJ0+nbILGYaVAm/RK5bwqfuc48pvfswqq1yRKDQlDN+NYqI6L3WducQv75HIYv7UsXKrvUhH9OJb6ZiBukKdpTPP3LszIHVDtpz9tXZ+H1gfiRBpJTaQ0gEFxtTHcR8w6xZs60g+d+CFAwGzoLZmLeiBbI4DYb0SoxtpCILXvQuvxoSufvgLTmYrPu+AQNSuREqBoaVyerfxj89wEN3OVL6B
 HywDrE03
 UFTO8rxy7pFHGrnnHxoEZhYo+UmNaMHpbVs0bREVAD2cLl0iA4SbLAWIH/g0u+j9cM9StXlRQOW7ft/opk/ZsUtK+fWBjgzWzea1xbTYNIWX9RQhf/js2BjvchMneEY/lqP9zsZqrxcCAzPBiM6bHcUcuZzTUi81hiV67597dYq0GkSLoOgX9pBCxiOP87eX77YwXpN0cK9PBRVrBygddPYvObyWdFGIki+7VVjy8YDnC7GeDakN0GCmtyhjNEgbriX98qteYzOVBwa+VIo8tNdXylttrX20YciOVqnah+HdDp3TNUNLd/UvvwfqIOoPug4+/w2sVbnCeSZjHCZ5+3gkTtfDlUddW9eppX9238UZEv5RBHpv/lIv1j6WKiw0FWDJV0niEx5DjnqMLnuP7nenmDoaKd5eAChvv7zy6DpTLe5Gr7jalSpyXyuyEw6Kst5MiT11c/M4PkvcEFD82cg2/Wg==
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

Now all swap in paths are using the swap cache, and both the swap cache
and swap map are protected by the cluster lock. So we can just resolve
the swap synchronization with the swap cache layer directly using the
cluster lock and folio lock. Whoever inserts a folio in the swap cache
first does the swap in work. And because folios are locked during swap
operations, other raced swap operations will just wait on the folio
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
index bf72b548a96d..74df3004c850 100644
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
@@ -517,11 +516,6 @@ static inline int swap_duplicate_nr(swp_entry_t swp, int nr_pages)
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
index b7a36c18082f..57311e63efa5 100644
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
index c878c4115d00..38f3c369df72 100644
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
@@ -3769,17 +3772,25 @@ int swap_duplicate_nr(swp_entry_t entry, int nr)
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
index 76e9864447cc..d4b08478d03d 100644
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


