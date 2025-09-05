Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E47EFCA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD8C8E0001; Fri,  5 Sep 2025 15:15:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436A16B000E; Fri,  5 Sep 2025 15:15:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FEBE8E0001; Fri,  5 Sep 2025 15:15:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 157DE6B000C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:15:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D22F816017A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:15:02 +0000 (UTC)
X-FDA: 83856149244.22.999BD9F
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 79C4780009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:15:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KA6S7eI3;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099700;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3aNJoCVROccJngmuYyj6rXHVyByugeVfWJigOc5CDQ=;
	b=0ZDtODWGDUC4rfzG6yKiJISsMghjT666FC+m000e+/NC/spVl2LEv/70JnB9UPXMeFHapT
	vQDnkB/oIYdXGt2DqCSaT7CT/q+RmjUkmE1QJT5h4SvZvjE2PNrUcy+T8Ojr/quxVtHJDo
	mszDFCU+ceOp2OJYu06ap5dRVS9wk7U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099700; a=rsa-sha256;
	cv=none;
	b=EEFcQ8VHNzGabv3Dhfw494PiTfOI4E5aUGoxYMi6eNyps931VTxA4F+Ylft9FBT5nKXvXx
	Sf/CWSOK9N3wWcW6BNO7KcItFpEj1wUYErTUg+J4yMn1VAljdxNx33R9vontQHnjTYwJQb
	KnpB/+v1uA/G1XsBCuQySdSyamrRpu0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KA6S7eI3;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7723bf02181so2028049b3a.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099699; x=1757704499; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=E3aNJoCVROccJngmuYyj6rXHVyByugeVfWJigOc5CDQ=;
        b=KA6S7eI3wMhUR4DnEWNjFzHKS0X3sfVQlyB6pnGoxK1IPDV0QasuLh6XYjS7K/65wC
         uq9bvPPSi92WWVm8ZG07xDwhSjzbFXgikK2hddnj4VLcS9qWd+9kGeW4wvz7TXBuW7mI
         TTEQJXZ7TI5fuj5/eAVPkW7WqOqa46Ub1JCfRUSmZxCSBQPyWz8hiS1H2CTSCIosd5i6
         FTwzanSVuu9RtZe040JxCRA4/tZsCMkJCKqaJW4XxV2TRi4Ds+bttxeV+3yrU1MzFUGA
         qYKwHOldRDCioPRPK5UbruSnf1knuUm7+zlgQMrIKxO6yakPDRe3W261/wdtqSojDvSZ
         qTDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099699; x=1757704499;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E3aNJoCVROccJngmuYyj6rXHVyByugeVfWJigOc5CDQ=;
        b=HFCVzTMCHhu+QiZVcs47hREquMHNjg3ZJuoTjn9GNERW+Z2Vl80aQ+KWs0+UNZJBB7
         QDkLsY906GbgPIXTgX+2ubHPMLqOB1v+FeVv4j7EgJAEOeiAYxROKVVMyKf4y7NeVAFB
         eBDPSnG7QD7n2vhhC5Nd6nMyiA16ornvcJ9bDL8OmDHiCnf8WEJTbmNslBLSPqwC2Fcy
         kiLzRpTcHRW9qJgKE/I0vUuOiMHmAZzhO3vtDHoPE7+OkPVgHXVfuYvPjbULpmYTwXPz
         BodBU/i4DS/bbbYJmazUNdFsDFAB+zLM20KzE347iy5XJ1fHoHv+u9xO/GhsI7qQPg7i
         F4BA==
X-Gm-Message-State: AOJu0Yym7fLtOq4QMKPw3pJyo/dicESh+LVldfJtePG8aPBxOFu83Eqx
	OgRmI529ZGoz6VaMy/6zTJmB2c1qD+yuVRAIct0UKi9tRE0pLryS4c+tAQyRECKkneg=
X-Gm-Gg: ASbGncvyI53QNBMq+qjonYfPcTqCdvm2zInoBLV005/hCB7riEkIEykmAAO4qTVP8OS
	dn927XXI3ZllJaxzYSBsE3F9sg88y4MKBDaqBXsesQl/xgbJUUxhENwdOE7OLtkE0uVJCLQHOdn
	mVjoAVS5xDLrJmYHB9AmqIrsQi59XzUGGPpqfaolMPN+W4mnQX/emPXEpqhSwh5v8MiLUyTK+/9
	rwLOlKU7RENx3ydWISuwH54H9OAW/qkGGGl1qBWP2aPaMcZo+Hk9gCPLjqR4L1ux6Bzibr1yxOS
	CHHolcs17Y3QsI318Od3tkX8iOA82TmNr2eOPLLV14Jaiq0ufBPYEpuOnibFDLWNCLwzaRaNGNS
	6TlFwZF2IPvhY2ZKxkZ6k+6CtR9Ryg/j4xLmtTVslCaZWEvdyQfJCKsDn1Q==
X-Google-Smtp-Source: AGHT+IFkFSys4IRUs0tnQpRxvyD0XxRc9V7ETW+LXR3DXREnaZW5aW0gNaD7ew1XW/XButtm1AKAsw==
X-Received: by 2002:a05:6a00:3e29:b0:736:8c0f:7758 with SMTP id d2e1a72fcca58-7723e224181mr25962922b3a.10.1757099698697;
        Fri, 05 Sep 2025 12:14:58 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77256a0f916sm15871442b3a.63.2025.09.05.12.14.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 12:14:58 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v2 09/15] mm, swap: cleanup swap cache API and add kerneldoc
Date: Sat,  6 Sep 2025 03:13:51 +0800
Message-ID: <20250905191357.78298-10-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905191357.78298-1-ryncsn@gmail.com>
References: <20250905191357.78298-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 79C4780009
X-Stat-Signature: qam3r3xjn3fy67fhkadhns9tbjdoxx9h
X-Rspam-User: 
X-HE-Tag: 1757099700-395596
X-HE-Meta: U2FsdGVkX18KnRQ4y2DINsGvECR0kDT3RWlkbumwfUUeRsL71Cte2Bv3TPk2XsYRgWQfR2vANoN7D4PV5NPcF+GDYyzM6Fdc63yb/lBPaQkYx1noCvLq2Rj9NKcMGEz8nlBtQ6W1ttgyqfx04W7kln+/CVL3oezLKei8yE10V3qcoUH7nezjIFLubd80SI38RVZ8ATTb61/yfiKK35HH3sOYiqN5b5sZvBA8gOMlG1MFh+KnNOFChyALAw+Z14xohrSae6nNmj2uxYHEqFnnqAV64yPB1X6RL02GaIkR6kmC3kgkQcuzcOBZX6nk3r3QJEALSM0sD6j6iOTuZunn3IlQMlIjYd9psqqC/JwZbfuACcdmrVWm4E0Kz9UyVu2ZtM8u6nNfZe71/1H6Mmkymmrn2DJx1qykiQCdpm+++/iG54e9J24L9B8QBcm0bBELqn/2SxjEv527UyuwYZ0RTRBFOnGV0qO8Gb/XYMblqElUDipukjpJkeyCele2T5QLqUm7Un2hiYqazkLiwqvb3Jv+RwVoaKbletDoimjbUMznih+1Dfrs7bZyLF55owq3WEcHBZyacAoOYvI4ADuNDW1+L3Xol1bSZ7uxcmqkndgyyCxo1CoNygwZnkJpn2a8YZI7SLkMP70kpUcCOZRYQI1BTfSwuEI2q+I9EvjY8H3xvTJ2tVMwOh1osUfYqNYSCkUIjcEYQd3gDomizaEEBRNjaPd78HpkNRAzV45ASxOP3k6JnlX0OyOgoyxyTfkNKGfCiovFAAqsneyhWN40xfYoqTUSn3HkQU+ZwNhCtCZa5Yfej4qAYkx2fRw7Y1BekpEHedfXlg7vHwMgq7NPaWD+/NVEvdTKMrShM/+R7THuxPBZKTMMPDtpF8/HPsYC+8vUgI4rHA4eK9pJo1TSsbFswG0HGn3tA/zQUZ4tQVa5b17CIxWix7FAvdBFnFYW1NEh0FWc0HpGzj5uPXa
 Ybh53bxQ
 Fg3DghnXmD0DjG819JpSVHMQrtuQSJOiT4fu07SBjj+GPMgpXZeM74Hmq5GtYGsw9f6O4Hr+GRZfa1Uiuz7mq05gGEhH1smECeUvaOYj4Y9bw4o6xRlpRRA+Tv5cdlF0xH68WHrEOJK9jK99VgR0QsacDw11xacjHzbApywYPHpoqTAWVrtUjITBzS4t0fzyVTKRfkIwH8M3diPEDWYHboxRutaSrDUgZuZAlHWPC+zZ7M4/4UCg1rWhMPviTRNWtm4nYa6HYTXuFuyG/tNgTEZ+1yGztdry6k5uYPqcDZ/cfEal3g8nVzgza4qm6vJwErnZzcO3NCs2mAoJ5NiQxzPfEmQXvJ8oNqsVAqaA5gC7ZQ2gXYJcgV8CiEcbtjcTdQTNM/e4cO9rdoYERdcs3MYGbDl4CY/C69a+BMUfNToz7AsmNvBL70MrsHcJb3Mv3qx6A+lHCuYR+UxmZ7CyNofdVMmzLvWos6vHKvPBEvUEtK+BNWIODfacypCe0h7W7M51WkRd0Pf6UQJLYvy8YZZHlPkuZlAgt61/3ezHRVGkh9ydINrUHXd8O0JybgNwWQTndBgNLUbk1pVgDDi6xUwivJ6UemF2SjZ9X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

In preparation for replacing the swap cache backend with the swap table,
clean up and add proper kernel doc for all swap cache APIs. Now all swap
cache APIs are well-defined with consistent names.

No feature change, only renaming and documenting.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/filemap.c        |  2 +-
 mm/memory-failure.c |  2 +-
 mm/memory.c         |  2 +-
 mm/swap.h           | 48 ++++++++++++++-----------
 mm/swap_state.c     | 86 ++++++++++++++++++++++++++++++++-------------
 mm/swapfile.c       |  8 ++---
 mm/vmscan.c         |  2 +-
 mm/zswap.c          |  2 +-
 8 files changed, 98 insertions(+), 54 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 344ab106c21c..29ea56999a16 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4517,7 +4517,7 @@ static void filemap_cachestat(struct address_space *mapping,
 				 * invalidation, so there might not be
 				 * a shadow in the swapcache (yet).
 				 */
-				shadow = get_shadow_from_swap_cache(swp);
+				shadow = swap_cache_get_shadow(swp);
 				if (!shadow)
 					goto resched;
 			}
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b93ab99ad3ef..922526533cd9 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1199,7 +1199,7 @@ static int me_swapcache_clean(struct page_state *ps, struct page *p)
 	struct folio *folio = page_folio(p);
 	int ret;
 
-	delete_from_swap_cache(folio);
+	swap_cache_del_folio(folio);
 
 	ret = delete_from_lru_cache(folio) ? MF_FAILED : MF_RECOVERED;
 	folio_unlock(folio);
diff --git a/mm/memory.c b/mm/memory.c
index 5808c4ef21b3..41e641823558 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4699,7 +4699,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 				memcg1_swapin(entry, nr_pages);
 
-				shadow = get_shadow_from_swap_cache(entry);
+				shadow = swap_cache_get_shadow(entry);
 				if (shadow)
 					workingset_refault(folio, shadow);
 
diff --git a/mm/swap.h b/mm/swap.h
index a65e72edb087..8b38577a4e04 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -164,17 +164,29 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
 	return folio->swap.val == round_down(entry.val, folio_nr_pages(folio));
 }
 
+/*
+ * All swap cache helpers below require the caller to ensure the swap entries
+ * used are valid and stablize the device by any of the following ways:
+ * - Hold a reference by get_swap_device(): this ensures a single entry is
+ *   valid and increases the swap device's refcount.
+ * - Locking a folio in the swap cache: this ensures the folio's swap entries
+ *   are valid and pinned, also implies reference to the device.
+ * - Locking anything referencing the swap entry: e.g. PTL that protects
+ *   swap entries in the page table, similar to locking swap cache folio.
+ * - See the comment of get_swap_device() for more complex usage.
+ */
+struct folio *swap_cache_get_folio(swp_entry_t entry);
+void *swap_cache_get_shadow(swp_entry_t entry);
+int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+			 gfp_t gfp, void **shadow);
+void swap_cache_del_folio(struct folio *folio);
+void __swap_cache_del_folio(struct folio *folio,
+			    swp_entry_t entry, void *shadow);
+void swap_cache_clear_shadow(int type, unsigned long begin,
+			     unsigned long end);
+
 void show_swap_cache_info(void);
-void *get_shadow_from_swap_cache(swp_entry_t entry);
-int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
-		      gfp_t gfp, void **shadowp);
-void __delete_from_swap_cache(struct folio *folio,
-			      swp_entry_t entry, void *shadow);
-void delete_from_swap_cache(struct folio *folio);
-void clear_shadow_from_swap_cache(int type, unsigned long begin,
-				  unsigned long end);
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
-struct folio *swap_cache_get_folio(swp_entry_t entry);
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
 		struct swap_iocb **plug);
@@ -302,28 +314,22 @@ static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
 	return NULL;
 }
 
-static inline void *get_shadow_from_swap_cache(swp_entry_t entry)
+static inline void *swap_cache_get_shadow(swp_entry_t entry)
 {
 	return NULL;
 }
 
-static inline int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
-					gfp_t gfp_mask, void **shadowp)
-{
-	return -1;
-}
-
-static inline void __delete_from_swap_cache(struct folio *folio,
-					swp_entry_t entry, void *shadow)
+static inline int swap_cache_add_folio(swp_entry_t entry, struct folio *folio,
+				       gfp_t gfp, void **shadow)
 {
+	return -EINVAL;
 }
 
-static inline void delete_from_swap_cache(struct folio *folio)
+static inline void swap_cache_del_folio(struct folio *folio)
 {
 }
 
-static inline void clear_shadow_from_swap_cache(int type, unsigned long begin,
-				unsigned long end)
+static inline void __swap_cache_del_folio(swp_entry_t entry, struct folio *folio, void *shadow)
 {
 }
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 0ad4f3b41f1b..f3a32a06a950 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -78,8 +78,8 @@ void show_swap_cache_info(void)
  * Context: Caller must ensure @entry is valid and protect the swap device
  * with reference count or locks.
  * Return: Returns the found folio on success, NULL otherwise. The caller
- * must lock and check if the folio still matches the swap entry before
- * use (e.g. with folio_matches_swap_entry).
+ * must lock nd check if the folio still matches the swap entry before
+ * use (e.g., folio_matches_swap_entry).
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
@@ -90,7 +90,15 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)
 	return folio;
 }
 
-void *get_shadow_from_swap_cache(swp_entry_t entry)
+/**
+ * swap_cache_get_shadow - Looks up a shadow in the swap cache.
+ * @entry: swap entry used for the lookup.
+ *
+ * Context: Caller must ensure @entry is valid and protect the swap device
+ * with reference count or locks.
+ * Return: Returns either NULL or an XA_VALUE (shadow).
+ */
+void *swap_cache_get_shadow(swp_entry_t entry)
 {
 	struct address_space *address_space = swap_address_space(entry);
 	pgoff_t idx = swap_cache_index(entry);
@@ -102,12 +110,21 @@ void *get_shadow_from_swap_cache(swp_entry_t entry)
 	return NULL;
 }
 
-/*
- * add_to_swap_cache resembles filemap_add_folio on swapper_space,
- * but sets SwapCache flag and 'swap' instead of mapping and index.
+/**
+ * swap_cache_add_folio - Add a folio into the swap cache.
+ * @folio: The folio to be added.
+ * @entry: The swap entry corresponding to the folio.
+ * @gfp: gfp_mask for XArray node allocation.
+ * @shadowp: If a shadow is found, return the shadow.
+ *
+ * Context: Caller must ensure @entry is valid and protect the swap device
+ * with reference count or locks.
+ * The caller also needs to mark the corresponding swap_map slots with
+ * SWAP_HAS_CACHE to avoid race or conflict.
+ * Return: Returns 0 on success, error code otherwise.
  */
-int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
-			gfp_t gfp, void **shadowp)
+int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+			 gfp_t gfp, void **shadowp)
 {
 	struct address_space *address_space = swap_address_space(entry);
 	pgoff_t idx = swap_cache_index(entry);
@@ -155,12 +172,20 @@ int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
 	return xas_error(&xas);
 }
 
-/*
- * This must be called only on folios that have
- * been verified to be in the swap cache.
+/**
+ * __swap_cache_del_folio - Removes a folio from the swap cache.
+ * @folio: The folio.
+ * @entry: The first swap entry that the folio corresponds to.
+ * @shadow: shadow value to be filled in the swap cache.
+ *
+ * Removes a folio from the swap cache and fills a shadow in place.
+ * This won't put the folio's refcount. The caller has to do that.
+ *
+ * Context: Caller must hold the xa_lock, ensure the folio is
+ * locked and in the swap cache, using the index of @entry.
  */
-void __delete_from_swap_cache(struct folio *folio,
-			swp_entry_t entry, void *shadow)
+void __swap_cache_del_folio(struct folio *folio,
+			    swp_entry_t entry, void *shadow)
 {
 	struct address_space *address_space = swap_address_space(entry);
 	int i;
@@ -186,27 +211,40 @@ void __delete_from_swap_cache(struct folio *folio,
 	__lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr);
 }
 
-/*
- * This must be called only on folios that have
- * been verified to be in the swap cache and locked.
- * It will never put the folio into the free list,
- * the caller has a reference on the folio.
+/**
+ * swap_cache_del_folio - Removes a folio from the swap cache.
+ * @folio: The folio.
+ *
+ * Same as __swap_cache_del_folio, but handles lock and refcount. The
+ * caller must ensure the folio is either clean or has a swap count
+ * equal to zero, or it may cause data loss.
+ *
+ * Context: Caller must ensure the folio is locked and in the swap cache.
  */
-void delete_from_swap_cache(struct folio *folio)
+void swap_cache_del_folio(struct folio *folio)
 {
 	swp_entry_t entry = folio->swap;
 	struct address_space *address_space = swap_address_space(entry);
 
 	xa_lock_irq(&address_space->i_pages);
-	__delete_from_swap_cache(folio, entry, NULL);
+	__swap_cache_del_folio(folio, entry, NULL);
 	xa_unlock_irq(&address_space->i_pages);
 
 	put_swap_folio(folio, entry);
 	folio_ref_sub(folio, folio_nr_pages(folio));
 }
 
-void clear_shadow_from_swap_cache(int type, unsigned long begin,
-				unsigned long end)
+/**
+ * swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
+ * @type: Indicates the swap device.
+ * @begin: Beginning offset of the range.
+ * @end: Ending offset of the range.
+ *
+ * Context: Caller must ensure the range is valid and hold a reference to
+ * the swap device.
+ */
+void swap_cache_clear_shadow(int type, unsigned long begin,
+			     unsigned long end)
 {
 	unsigned long curr = begin;
 	void *old;
@@ -393,7 +431,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 			goto put_and_return;
 
 		/*
-		 * We might race against __delete_from_swap_cache(), and
+		 * We might race against __swap_cache_del_folio(), and
 		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
 		 * has not yet been cleared.  Or race against another
 		 * __read_swap_cache_async(), which has set SWAP_HAS_CACHE
@@ -412,7 +450,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		goto fail_unlock;
 
 	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (add_to_swap_cache(new_folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
+	if (swap_cache_add_folio(new_folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
 		goto fail_unlock;
 
 	memcg1_swapin(entry, 1);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 367481d319cd..731b541b1d33 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -266,7 +266,7 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	if (!need_reclaim)
 		goto out_unlock;
 
-	delete_from_swap_cache(folio);
+	swap_cache_del_folio(folio);
 	folio_set_dirty(folio);
 	ret = nr_pages;
 out_unlock:
@@ -1123,7 +1123,7 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			swap_slot_free_notify(si->bdev, offset);
 		offset++;
 	}
-	clear_shadow_from_swap_cache(si->type, begin, end);
+	swap_cache_clear_shadow(si->type, begin, end);
 
 	/*
 	 * Make sure that try_to_unuse() observes si->inuse_pages reaching 0
@@ -1288,7 +1288,7 @@ int folio_alloc_swap(struct folio *folio, gfp_t gfp)
 	 * TODO: this could cause a theoretical memory reclaim
 	 * deadlock in the swap out path.
 	 */
-	if (add_to_swap_cache(folio, entry, gfp | __GFP_NOMEMALLOC, NULL))
+	if (swap_cache_add_folio(folio, entry, gfp | __GFP_NOMEMALLOC, NULL))
 		goto out_free;
 
 	return 0;
@@ -1758,7 +1758,7 @@ bool folio_free_swap(struct folio *folio)
 	if (folio_swapped(folio))
 		return false;
 
-	delete_from_swap_cache(folio);
+	swap_cache_del_folio(folio);
 	folio_set_dirty(folio);
 	return true;
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ca9e1cd3cd68..c79c6806560b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -776,7 +776,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		__delete_from_swap_cache(folio, swap, shadow);
+		__swap_cache_del_folio(folio, swap, shadow);
 		memcg1_swapout(folio, swap);
 		xa_unlock_irq(&mapping->i_pages);
 		put_swap_folio(folio, swap);
diff --git a/mm/zswap.c b/mm/zswap.c
index c88ad61b232c..3dda4310099e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1069,7 +1069,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 out:
 	if (ret && ret != -EEXIST) {
-		delete_from_swap_cache(folio);
+		swap_cache_del_folio(folio);
 		folio_unlock(folio);
 	}
 	folio_put(folio);
-- 
2.51.0


