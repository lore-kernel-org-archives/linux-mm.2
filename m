Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21052CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:59:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 677648E009A; Wed, 29 Oct 2025 11:59:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DA3C8E0045; Wed, 29 Oct 2025 11:59:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8A18E009A; Wed, 29 Oct 2025 11:59:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9228E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:59:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0932314081D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:34 +0000 (UTC)
X-FDA: 84051611868.03.05A3191
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 19C60140012
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IR0aKc3F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753572; a=rsa-sha256;
	cv=none;
	b=0peYBVtwxCNia74LBj7QCjzUcSPPNvro4gKT9mhpVXKAdSqfEjR1MlLcmi/A9R892N+Hsb
	OgsHFtr2j6D7oLx6HNjcoB38/yM03bbexylYBH7ewTbALScObn/6oGCexHIR8ex3qKAhET
	2YCUt7KJqIlSp8u98f1L8+qmyIbvuAs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IR0aKc3F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//x7l/ZVG5GFT0i4YAgVrYYCeiDcBTswgh555TzkaWQ=;
	b=aUrGifqlZLrpPCQyIdFw7+KmAeoITYLsjKMeZTlnD/0WZesP/KhFu9p9XEEdZ4c2vfeDFk
	Bu5wv/dcRoXARniu/o3D7cQ3e3DbKjmwGCy/SfLQx9vqmPxczZwxS7o+XDluRFloy4wQSX
	GSWPVJRiEVjUA5S+N6vwZx3PjoS7eWc=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-290ac2ef203so71465135ad.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753571; x=1762358371; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=//x7l/ZVG5GFT0i4YAgVrYYCeiDcBTswgh555TzkaWQ=;
        b=IR0aKc3Fllk4Lz7bKo3kfkRR7N7teI3U+e4pY0qZja2qOFRCQagaw8BwNCdLPF8NAC
         yJL2o0KicYmfml2AIVaReKUuZ0VqeCp35MD2c1G9ikKjqDQP2GTcblfFXIVyByMbjhwm
         IgXMzbil3nfAMG1tkSePflLiUV8uLVZMiA2NGzTsutWh0MapnUyxTul++vIznkfV6xIf
         mTx9+VuA8khH+xhmkB8qnoRZTIpQItUBb3xQK5Rv3eUuFR3wqIx+UfTPc7bQ70mCJTyu
         W6fQqR+VPpQY4MYmu+Z8M9olglNVGJQoQTOpEWD3fSDi+QmnC1TaKf4cJTYHsz4dGa1O
         1rtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753571; x=1762358371;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=//x7l/ZVG5GFT0i4YAgVrYYCeiDcBTswgh555TzkaWQ=;
        b=tm4/tVfEHReJmNtLo46eOKHU2R3v6ya/gfXlbPvhDlzbbAHyBgRDlUhFKrSb3nB/Nc
         h3wpToHmpvV0+CoKXzuHeE8VKgott4vvSiR5drBkbKMtE2VmLwjlF/cb5ihS2D1DDH7n
         T3/X9z2T2cLFpXgLkxGLU+1tG8wrFeTplTrwMjQ5J2NgVM9ts6HXq0yPpEaUsfZAphS/
         zxfkXM+37yfKLP8FJFm2ZQf7kbQCtsduY6b7RQ5Jla1p5fjQ27Niiw7qSDfongtk43i5
         DOXG7YMm078UT5GSY1t/bdqOLvvXuc2334kSeesGNX/FeG9OFu8uoQdx5AMsctviwEsH
         9mvA==
X-Gm-Message-State: AOJu0Yypu+pRdwpHp0xzSTXQEzbM5IgM7VE3h242TFWAZmJRZT8qMGPG
	ttKeiFG3A8AduICkgO7oJ3ue5PFKQN94vberkQtwAs44MOVUKmYZmQKP
X-Gm-Gg: ASbGncugw2OR35Up3pP7uOJdtfeUFz5HEiCQPFDZX6dknTpdbKD/SdXBrhqpt4NIDAf
	UomDmudphJr5nqeCPrag6aNgHpxR8nz7/diDXsbeq4NUDQx9L1etNRGALw+X5Eedmh0j75hLgfB
	ct+xwusZdAYl7A/BfxS4HnJd5AZBErN5xfHhup/qy2aip0esptw6UKchUWI+EXrrSOKBITXWQdf
	sgnczGgBiDgcbkhiSB9voJgXdnCGsJAopouMd2Zedi9ElZrGpKRY33IZG3hAZhMt+7OYHLvKFho
	1mbfWk0gDpglIz4GfHTqOIdFpafLYmVy7wc3zxqea2FElmWu2bKuY6vfo4eWgNuhHm2EZZB5LXL
	olMnwTck6fnthgNum9jGDeWLJTNdaJJSmJKP7msBHa81gwtPeUhf7MkjEjqQLIeujDjcqGiVIlx
	7zV3tCNXQPbjMmw9SAx4pC
X-Google-Smtp-Source: AGHT+IEWtY10yvvY4Cp0RzOTU6HW9O3cstRaZVUbKF1PyT4VABvIddsgFxCghFW1F8bVuzsAePb2qg==
X-Received: by 2002:a17:902:ec81:b0:268:1034:ac8b with SMTP id d9443c01a7336-294dee334b3mr41546155ad.26.1761753570876;
        Wed, 29 Oct 2025 08:59:30 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.08.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:59:30 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:33 +0800
Subject: [PATCH 07/19] mm/shmem: never bypass the swap cache for
 SWP_SYNCHRONOUS_IO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-7-3d43f3b6ec32@tencent.com>
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
X-Stat-Signature: 4jgoun1gzuf8yth4ctko87c4ac4j7od1
X-Rspamd-Queue-Id: 19C60140012
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761753571-155675
X-HE-Meta: U2FsdGVkX1+XOC+Om3v2j7eIFdZq6l2ag2Auwk9oCmr3F37WxLHmUwiC6bp9LuIfJJYNzKbKPvuWbnp/Y3gVPsePZGnRfQ5mDk0lpL/JM6Pv+ygQofyizhm6TuDU12PHu2rMkMdUW/eQ4MP7nbomtQpgPuDH8XONs0hT0RnhFiFSMupcbfAOCzc/gezM9OemlpXEzskwIzRyjb+J3wnhMwCufNflUIRtwjzWr0EWDgZbZKzQrwKI+2JaGAax/QLRuxQgzDLI6WLDu1pP0P4WTfufg5P8zdlvvyJ8i26zwrLJRqXHgSpIGd9vsFGoBqSj/Z2GdzJ96M5H1Wqc56akVFa8HXgYe544ltDj3wtfY0V6psB+4wpQ9fnbedQhuWl07ZK5Hf2TIdvU3L3kEPTK2WAGnnqb5k3hY6iBn1sYj2dRYFMr0VdEAmp0rbN9mYt/TEos3Ag5YHUO/W7PuOyh49u42aZb3RnB4KYp4aXl13G4uztbYnsgDGn7xu2YoJLYiFBP0BbvA5KclnE1Dak1G8LTZ4q1KJa2BYauKFv9ifOrgoxMRUh597SLYeXpb9RETAt9ZXMhQiJp00liY9m22Z1cLdTJkqMCyWKdv6NJTdy9l4iWatdmPqqjXch0/E05I9ZdYRDEKQFns0G8TwdO/1+GZ24T201lT/tJ6pOe8jslgqIVQAULhhLFCQHgE5QNFxI0JMlh010b8bZSeWLcloHGu7RdoXjVyFXzwiR2QR8l+mNfdJ8UoQPf9yflwQidKutHhuDI58BRC0GXyxQg6qB0YX7GMELYxLGwXXeYL9P86S1mNlJp0D80QBckfFZS3/+/hcGlhfsM3lTVEVs34ZSwjG3XiD8grrPuJl3OnHVePyBuCLDfDDs4veeczNi+hVxUY22MCRCbOGzBzxp+TqYUHUwoRCiyt5uIK9klFpCHaYXd6qYzQR9QGWeFW1bQiXfyetjmF+o64wOJ0GZ
 wY9siOmS
 3uoJTeWPDGT0OR58n6fM3TXxtB/Yh2MLReDy9dQOWQrwJX2Cbz2X08joH23ZpiBJfsQ7lwF+meo680bbK8Yq2JJ0rpVt8kUZRiuOV/89R2hqfuv3QF14eD8UiRW7gXNeSBFDPpzllXZ9CHaxzj4FPSCSOLBbG3mVmNRhlqfZ4YWXlW2YBTDUEbZNPselWaJHHoJlpvrhEtNHnSPBbzhSnkGvUdLs4iIyqzv/+F2okEInaJnlt/WHn/gYHSekTzD/VWbrzVzM8qm1D2jO72HMlnYo4mgqBPEp4PhQyv59ayaLzT0UVDq6nggQLhtSPXcImkRcnFSE+v+j7oJmQgIQpDRXMeaCcceY9dg+U9NjcrS5kMrBWCSOmb0vdsynH26bVSIv6ETltxQRTc7o4Ym4NLk7sJMFpjjr93HDHqGaTUveusab9ffZoaLey+CgXSgWNjWEC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now the overhead of the swap cache is trivial to none, bypassing the
swap cache is no longer a valid optimization.

We have removed the cache bypass swapin for anon memory, now do the same
for shmem. Many helpers and functions can be dropped now.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/shmem.c    | 65 +++++++++++++++++------------------------------------------
 mm/swap.h     |  4 ----
 mm/swapfile.c | 35 +++++++++-----------------------
 3 files changed, 27 insertions(+), 77 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 6580f3cd24bb..759981435953 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2012,10 +2012,9 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		swp_entry_t entry, int order, gfp_t gfp)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct folio *new, *swapcache;
 	int nr_pages = 1 << order;
-	struct folio *new;
 	gfp_t alloc_gfp;
-	void *shadow;
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
@@ -2055,34 +2054,19 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		goto fallback;
 	}
 
-	/*
-	 * Prevent parallel swapin from proceeding with the swap cache flag.
-	 *
-	 * Of course there is another possible concurrent scenario as well,
-	 * that is to say, the swap cache flag of a large folio has already
-	 * been set by swapcache_prepare(), while another thread may have
-	 * already split the large swap entry stored in the shmem mapping.
-	 * In this case, shmem_add_to_page_cache() will help identify the
-	 * concurrent swapin and return -EEXIST.
-	 */
-	if (swapcache_prepare(entry, nr_pages)) {
+	swapcache = swapin_folio(entry, new);
+	if (swapcache != new) {
 		folio_put(new);
-		new = ERR_PTR(-EEXIST);
-		/* Try smaller folio to avoid cache conflict */
-		goto fallback;
+		if (!swapcache) {
+			/*
+			 * The new folio is charged already, swapin can
+			 * only fail due to another raced swapin.
+			 */
+			new = ERR_PTR(-EEXIST);
+			goto fallback;
+		}
 	}
-
-	__folio_set_locked(new);
-	__folio_set_swapbacked(new);
-	new->swap = entry;
-
-	memcg1_swapin(entry, nr_pages);
-	shadow = swap_cache_get_shadow(entry);
-	if (shadow)
-		workingset_refault(new, shadow);
-	folio_add_lru(new);
-	swap_read_folio(new, NULL);
-	return new;
+	return swapcache;
 fallback:
 	/* Order 0 swapin failed, nothing to fallback to, abort */
 	if (!order)
@@ -2172,8 +2156,7 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 }
 
 static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
-					 struct folio *folio, swp_entry_t swap,
-					 bool skip_swapcache)
+					 struct folio *folio, swp_entry_t swap)
 {
 	struct address_space *mapping = inode->i_mapping;
 	swp_entry_t swapin_error;
@@ -2189,8 +2172,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
-	if (!skip_swapcache)
-		swap_cache_del_folio(folio);
+	swap_cache_del_folio(folio);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
 	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
@@ -2289,7 +2271,6 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	swp_entry_t swap, index_entry;
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
-	bool skip_swapcache = false;
 	int error, nr_pages, order;
 	pgoff_t offset;
 
@@ -2332,7 +2313,6 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 				folio = NULL;
 				goto failed;
 			}
-			skip_swapcache = true;
 		} else {
 			/* Cached swapin only supports order 0 folio */
 			folio = shmem_swapin_cluster(swap, gfp, info, index);
@@ -2388,9 +2368,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	 * and swap cache folios are never partially freed.
 	 */
 	folio_lock(folio);
-	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
-	    shmem_confirm_swap(mapping, index, swap) < 0 ||
-	    folio->swap.val != swap.val) {
+	if (!folio_matches_swap_entry(folio, swap) ||
+	    shmem_confirm_swap(mapping, index, swap) < 0) {
 		error = -EEXIST;
 		goto unlock;
 	}
@@ -2422,12 +2401,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
-	if (skip_swapcache) {
-		folio->swap.val = 0;
-		swapcache_clear(si, swap, nr_pages);
-	} else {
-		swap_cache_del_folio(folio);
-	}
+	swap_cache_del_folio(folio);
 	folio_mark_dirty(folio);
 	swap_free_nr(swap, nr_pages);
 	put_swap_device(si);
@@ -2438,14 +2412,11 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (shmem_confirm_swap(mapping, index, swap) < 0)
 		error = -EEXIST;
 	if (error == -EIO)
-		shmem_set_folio_swapin_error(inode, index, folio, swap,
-					     skip_swapcache);
+		shmem_set_folio_swapin_error(inode, index, folio, swap);
 unlock:
 	if (folio)
 		folio_unlock(folio);
 failed_nolock:
-	if (skip_swapcache)
-		swapcache_clear(si, folio->swap, folio_nr_pages(folio));
 	if (folio)
 		folio_put(folio);
 	put_swap_device(si);
diff --git a/mm/swap.h b/mm/swap.h
index 214e7d041030..e0f05babe13a 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -403,10 +403,6 @@ static inline int swap_writeout(struct folio *folio,
 	return 0;
 }
 
-static inline void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr)
-{
-}
-
 static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
 	return NULL;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 849be32377d9..3898c3a2be62 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1613,22 +1613,6 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 }
 
-static void swap_entries_put_cache(struct swap_info_struct *si,
-				   swp_entry_t entry, int nr)
-{
-	unsigned long offset = swp_offset(entry);
-	struct swap_cluster_info *ci;
-
-	ci = swap_cluster_lock(si, offset);
-	if (swap_only_has_cache(si, offset, nr)) {
-		swap_entries_free(si, ci, entry, nr);
-	} else {
-		for (int i = 0; i < nr; i++, entry.val++)
-			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
-	}
-	swap_cluster_unlock(ci);
-}
-
 static bool swap_entries_put_map(struct swap_info_struct *si,
 				 swp_entry_t entry, int nr)
 {
@@ -1764,13 +1748,21 @@ void swap_free_nr(swp_entry_t entry, int nr_pages)
 void put_swap_folio(struct folio *folio, swp_entry_t entry)
 {
 	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+	unsigned long offset = swp_offset(entry);
 	int size = 1 << swap_entry_order(folio_order(folio));
 
 	si = _swap_info_get(entry);
 	if (!si)
 		return;
 
-	swap_entries_put_cache(si, entry, size);
+	ci = swap_cluster_lock(si, offset);
+	if (swap_only_has_cache(si, offset, size))
+		swap_entries_free(si, ci, entry, size);
+	else
+		for (int i = 0; i < size; i++, entry.val++)
+			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
+	swap_cluster_unlock(ci);
 }
 
 int __swap_count(swp_entry_t entry)
@@ -3778,15 +3770,6 @@ int swapcache_prepare(swp_entry_t entry, int nr)
 	return __swap_duplicate(entry, SWAP_HAS_CACHE, nr);
 }
 
-/*
- * Caller should ensure entries belong to the same folio so
- * the entries won't span cross cluster boundary.
- */
-void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr)
-{
-	swap_entries_put_cache(si, entry, nr);
-}
-
 /*
  * add_swap_count_continuation - called when a swap count is duplicated
  * beyond SWAP_MAP_MAX, it allocates a new page and links that to the entry's

-- 
2.51.1


