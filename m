Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47507CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21908E009F; Wed, 29 Oct 2025 11:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1DB8E0045; Wed, 29 Oct 2025 11:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899EF8E009F; Wed, 29 Oct 2025 11:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 711718E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:59:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 349DD12B3D4
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:58 +0000 (UTC)
X-FDA: 84051612876.10.6A6F8D2
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 380A440010
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="G/RlwuIp";
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oro6FwqIkTmuaMWEGle1A3mIt+YqWKAuLSr+vB3zc4c=;
	b=TqODHLzL/ELy/AD0dQpSLy4jL9pabIo58pXX517W0+GJYKnQduXcLqqb/kOZZui++2kzBV
	EB4cYrV++ZepKBEFlFFVBLmKWWrmf8QOAN6YXPM+nwDgIfGcAm8vBR3zMJc2ujwwlnkELo
	+Em3PPg/FNrnqHZx5gzHFQumY5IqiuA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="G/RlwuIp";
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753596; a=rsa-sha256;
	cv=none;
	b=e+YmnSUsG+UhevUouACT3+WIIKNAXkswMJD257ITuvnBKSUA+z2TDWSlSCaeUHgXc+Vq45
	Wl4hOUheZV5t/gJjoLdQEE389Ccp4V/RDJ2tXaXOfEdSF/wrx1OlloSwvjCVfuIzcuKGaN
	HiQBJuAYUNBgPW1+lmuxUu+NhhA7cvM=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-290b48e09a7so90029035ad.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753595; x=1762358395; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oro6FwqIkTmuaMWEGle1A3mIt+YqWKAuLSr+vB3zc4c=;
        b=G/RlwuIpUfV8tEg4te5uZaMftjXEWPZ90H8bvlYrXnMr0VcFj34wFDuT/4w1iOBL25
         oSDMBVXC1iluloPnPwBqTTusxcDgaEAaR3k5YsJ0bPp8bCClUfXHCKILU8KEJszeOEer
         xvAptFifO2Eg5xsIri+X0oqJPH2D2jvk/Cs5wpdDo+Nze6k5oRg1sR+2AlGa8WLjvarO
         Ul8WwDCWTrRqja1vvEJGEURdip/BpLnmLy0cF9aKG8Oe/AMRhJMn7wjD50ZyzmSaZb2V
         bjYYplwecQKtgmP7ZsSdwkBvS4YJLXL4Ww0r1Rh5Ye4gXbQWJ1/5n6BQgLiS4eCt4UyB
         qEtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753595; x=1762358395;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oro6FwqIkTmuaMWEGle1A3mIt+YqWKAuLSr+vB3zc4c=;
        b=hWAOHtO1SR5sc5L3E3XvS7KxHQCTvVySZxD4spb8HtzDK1jhRXQAwKK9hXvl7htBu2
         MD6C/kPLRxH6x5+uPsJDFzgAvfLxae+AoBae/wNJGBdm9oHdzvhhlp6q8QUOhk+i+4Md
         Fye3qWO2mI31lRFEfTRDXr9I0sMxE9M9/1x53VLpICQBBXNRxgGNxQJoSd2kHJLiXyAj
         qMgf+vBCGZMD7YZEVSFz7yU990P8Dpefvn4n3xyf+FgKY6ufP9Au2w69WwGVosIo8kOl
         G82ZwNBS53BSGaoIIhGfc6IQQqIED0ZALM/F72ESkFupDfz+oHWkpypeHitYfC69wuYd
         Pg3Q==
X-Gm-Message-State: AOJu0YznLVo62kuROxSEDvrvnYDx75jW4URjzDF2e+rqHiz9cuQcjuc4
	u9GiH+7L883YCp6jEJXsm3X8jtnQRIcmqIYxW2sWGjfH1jHedq2PQv7k
X-Gm-Gg: ASbGncvNeuJEU1VsVXsT6JYzwOCLNvnDbz127C+PaMUhqTmp70JMmYZYSmifqyvi05a
	RialpJv8Cnmaavl8Mr3Vrb+lFwMn9JYytVXeu578wGSyfUhPVyv5dr2+iY2fONCD2snaMUIBWeg
	HWuM6RS3A+dC1eyqmBgAENEnk2iHtwoUe1+yxCPGx25gT9UCfgIKAYNhbasc4D7Vg7pHNedngHn
	kWSe0Psf5lziP3I8qNveR7LZWawQGlYXiO5UEWSJRdXhK10HAOjmiJdql0S0Pw93jR9qSA/ERGW
	n7gXL+lrt8qACbRsWggV+ii3UOWnZ1Y0PCu2q7ToB5DzhzWp0w+R1aATUHY2cZ6masgLJRo6ec7
	pUlmD3MkDu0B+aRV+wQBdUcKW0FtwFSiIiYSRaFWgsy/3mhADskr6ZGqb5KcKgF4JEmsakt2WgO
	lyyLTMpQ1tQw==
X-Google-Smtp-Source: AGHT+IHOMMDiT1d3KDkNSsyTngQflKh7MDlf/06YJIchSbedr8pH+Ab6kM95BleLFAmEkO+PZdRYrQ==
X-Received: by 2002:a17:903:2301:b0:290:c5c8:941d with SMTP id d9443c01a7336-294dee9970fmr42231285ad.39.1761753594783;
        Wed, 29 Oct 2025 08:59:54 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.08.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:59:54 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:38 +0800
Subject: [PATCH 12/19] mm, swap: use swap cache as the swap in synchronize
 layer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-12-3d43f3b6ec32@tencent.com>
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
X-Rspamd-Queue-Id: 380A440010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ciqgon3qtnf8mkuhoodac1u37k85eabk
X-HE-Tag: 1761753596-571802
X-HE-Meta: U2FsdGVkX18c51V/0WwgdKSABDp+F1Y5PNHMhl323JY2rCDRqavQ/sMiDZtbCAnYqfKlnpxA/wXDU/PxkeaVSe8Glum/1DSw/ZHcI5BPKvSZ9EEo+wJLNXidDeeDN/Q3twcIuKD89vMFzb5sGyGyVm9ImHbx9TuZ+HdMWSIK1hyThTxGKPwzjzevty3LP4DWvYc0GIlsZt+16v8P3uA/7SRFuk5JFKfZoIhqE9/RKp9ka4qYw3ChwzTTLP1LOpIpnm4Dm2N6ovM3kKQuHMlhOgKlOCdxpRVfCC0GuNHSdsxpaHLxoR1jsDY62ykkrK/r0eHwkAhkk8LX3kIxKXbY5uHsbWq+NHhRb9JAVzOTUiDaRbCht0EEGrCxnmZEdfrJBuyZh9YhPzB1LHMdElReygzgWh4QnrYRT43inFVUkgrrYzmv+j9VMOBEyhc3P0liuzoC/oocVyuspeLxBknP6s3aO9FKPk8WLRSfnIEuQVqOlImZMwE8WpHV+AJjAv7nhMPhge7gchcdFf2TyxqWhT74XxVhTQ+DUwNJkp6cKTSVyM2aaIPu9RwuvD86AFynuOM5nRf/OfHXtJnYKGUP5EZ13bysrvKLyN8ARXnKwCNO/ajXl3Q07hMM/hbn/muuDsjjcY7swfvdxthji6ZY5suH7hq1OWpnoOkVpmhBThHDWmjR2VoR4VjpZdXOkdDlvbtg+/YLdTDC7a7nKV+/eO8C9xXyBrVH8HwfojtN3JpAnEKvALwEpJ6w0XFgZmPAgFyiQBFFtlO4ypFO32yhvqJkBn7098UClWtkLk4gTJvggOaO5rG/CwXeZoAA26vTl1vI7Dbhi87Uy/kitPzBgFX9AwyGi0rRhW21z1zWgk3oLd6oQWQpgsb0Nv6seKmpYMxlbrV+KNUv54cUlTTGIyPz6oS0+23edafbUE3uTW4oFG/c74i+Guph/jm07/A335GLLEur0i8eYlJFgIj
 fFLgqIuM
 bcGBoXrmYVCTDKW7HzbhrnQImSjHpMM2aASyw+81t50gB20MXC5+l90ABviZg5MibzfycJte002N4O5KRG8A/7m/E9WRZKVDCwroInM9gXTroTGdPqiJdZoh+nRKDaLi/CM0RZ/kNawlMcjrR86UlhycbbN3X5dQmiHQOvEK3NCLETFcwEoZIwg0XyCArWHReyM/VsXsy5IjkDWB1X9RJ70oTgy+csTYfZegieTtq1j8Y48NIaO67vZiS4Ki8qpB/VD27es6zpAZSuQa9AiVYnqQ1JKxtC6A+atfldFEB+JD8a0RrlKh6iW8jOjD9xtIhPYODj8x+UxZN1VcE+8eAh9uJmDo+WHgKmVEiqKI738DeQTGIJZoTzMGUUVYFB6CKNlMshQ1T9iXkLOgJEijALoOUcqCppx/db6/BscqwOkGZKL7Znj8XifwiLuBophjW/dPaEt68P8cgOFnPCazv6cQSDg==
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
 mm/swap.h            |  14 ++++++-
 mm/swap_state.c      | 103 +++++++++++++++++++++++++++++----------------------
 mm/swapfile.c        |  39 ++++++++++++-------
 mm/vmscan.c          |   1 -
 5 files changed, 95 insertions(+), 68 deletions(-)

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
index e0f05babe13a..3cd99850bbaf 100644
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
@@ -413,7 +422,8 @@ static inline void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
-static inline void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadow)
+static inline int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+				       void **shadow, bool alloc)
 {
 }
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index aaf8d202434d..2d53e3b5e8e9 100644
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
index 56054af12afd..415db36d85d3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1461,7 +1461,11 @@ int folio_alloc_swap(struct folio *folio)
 	if (!entry.val)
 		return -ENOMEM;
 
-	swap_cache_add_folio(folio, entry, NULL);
+	/*
+	 * Allocator has pinned the slots with SWAP_HAS_CACHE
+	 * so it should never fail
+	 */
+	WARN_ON_ONCE(swap_cache_add_folio(folio, entry, NULL, true));
 
 	return 0;
 
@@ -1567,9 +1571,8 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
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
@@ -3748,17 +3751,25 @@ int swap_duplicate_nr(swp_entry_t entry, int nr)
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
index 5e74a2807930..76b9c21a7fe2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -762,7 +762,6 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 		__swap_cache_del_folio(ci, folio, swap, shadow);
 		memcg1_swapout(folio, swap);
 		swap_cluster_unlock_irq(ci);
-		put_swap_folio(folio, swap);
 	} else {
 		void (*free_folio)(struct folio *);
 

-- 
2.51.1


