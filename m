Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C404DCFD348
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142146B002E; Mon, 24 Nov 2025 14:15:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11A806B002F; Mon, 24 Nov 2025 14:15:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030276B0030; Mon, 24 Nov 2025 14:15:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1D2A6B002E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:15:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EDE74F6F5
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:15:55 +0000 (UTC)
X-FDA: 84146455470.19.30FFDE4
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 621C110001A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:15:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G7NTk1gM;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TP0sJnBGats4iaw1yAn2XnkxPNwTDZpe+FnZpSRfeaQ=;
	b=PaNHPV57SrHrhUBjMOadAKWGkxzQFFzJlf7pizQUVfFAfCzu/ddDtuiUH+/ZCq0T8IkcMt
	xDPJZlunBLfVGEFpgdPZZXIQ7nibwDJLvGE3wCLb05TsJeqqasixK2mynS/gnaJCMv4BLW
	uHI8ibJXSjaj2RZ0o1yuLpnQyT9JtlI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G7NTk1gM;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011753; a=rsa-sha256;
	cv=none;
	b=n+u8uwY72fsuwuKnEmHQ8kfSjQSZqIgJs1+QK9LiDo7UTofxR4QSYy3FRJ+SXbVs93laHg
	Vn/Cc/XeI8s050nqvzHNLL+7AzuDBPR1UWUn0zczW0rSTO3p+nQ8UiH4/+PqUN4Oq3VAoF
	SUs3a7Bc0kV82usD0fWIKTDb+wugpEc=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-298144fb9bcso51121415ad.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011752; x=1764616552; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TP0sJnBGats4iaw1yAn2XnkxPNwTDZpe+FnZpSRfeaQ=;
        b=G7NTk1gMgv+j9c3vnMJo5fc/9Lvx6/B1NM5YcHSoBRGS7U3l0Ut0H+SsJ55Y1vnylY
         9cLglSfeVxyEYawjUPOwKwVS3Nb8q6k+aKwclXmJuB5qYu63+jLn6+Vll9ivY3KkREK9
         fYGvs20uIixcRcbCTUvxs1auVHFIUqixhSkV/g/NyTRkrtSWaFe5JZ+635zAPEOtszdq
         1sJOZWyb+EAS8Evf1odfEQQFx9oD/b1g8vlwLF4Hl9PQO7nP+ZOyxK29JyL+jEmlCQ6M
         YEltuj+W+BxP5grj5gw5ygiZ1Es21sCsDTblFLE78jH/w9FyfnUNhdBaRyJQSUw/OwZ9
         r44g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011752; x=1764616552;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TP0sJnBGats4iaw1yAn2XnkxPNwTDZpe+FnZpSRfeaQ=;
        b=GH8vxkQvjja5CK5/r2n2GQUbH9alSWiHCDr3XQK+Qb725nFjesDjfZ2Mona0wuDUbd
         BMDvi7Wu6zcVbcS1i3E3f0pCFWARHEvI0Z6tQkhh48DgTK48MvugYNF2NKuJHsgBKkMf
         Mje6jQZzpGYVSaakFPp7Wr1aqhBQBJWGAU2kO+hb4/JQIK14nefUOn4mDUpAtVfNoULP
         McES+CXEsGlFGk0lKo01dC8uKSzwDHutt4IwSS+pdaTR45B564w/66l9qgvrnbTuxjJ1
         FAeCa/pGlcDiIedZVirvAkGjfkohrWmssvDUyWSz5SFKzsbCSGK74puHPPkGL9kzf0vY
         zf3w==
X-Gm-Message-State: AOJu0Yx3XptdVamAM2wD8QVExkL5K8g2i4u+dRfKFUVHO6gv27TUrtIV
	d3jEL/RL5kdPbdKPwCXKUFwN3kdrv/tIcNvOz33RoEKPncSlZ3kWG4rB
X-Gm-Gg: ASbGncvg6jfR6wrwVHxFqGzs8Z7SjTrXRl7xkvVq2IxRX/rJM8dVVkWdETM8lpa84x1
	25cjrym04O4pfKYQWjuC/JkLNRKbPTP+JGZD0dVtjm2OEc1ACO1sutRP6gifIOhsiX4fGCvrfWG
	HkouYxcXAVOPrLRf43K+5pr7R17EBAixTLGuqNABx5r0R+uLjsT1mg6iO7Zr4g+4VrUCm//utAe
	r5yp32Tbp61VCJwKyxJtcY7NsUSkj/GkE1PSOX/Ns2BTaP+5nVagFS1+ZlD0We/rClhMK6RmzXM
	8UHbA++dD6F2xfVUUArT6i/6wmJQzoTRuHVk7lbTBy9kgk5sIWOu/77wSfwgVfl17zqi0hHgf/B
	iXnEohXZA8S/j7VTx3XDnCvKR4fIYCANJ28EICDHRxXbVw1G4Exl6xcwaBY+CHMD4H0azdV4vWq
	/8hKVXkEEbceAW5dYhXm4SmGmJRc0iVQ4HkrJiWwEaxnJ5O+nf
X-Google-Smtp-Source: AGHT+IHX9EthexG+oeWI//LhOXn4BfZoVzv5xsvsh8Z3gG7/UPRBMZdtZujHkCx0+spRKcHWHMeP/g==
X-Received: by 2002:a17:903:b84:b0:295:a1a5:bb0f with SMTP id d9443c01a7336-29b6bec3fe6mr146413115ad.18.1764011752071;
        Mon, 24 Nov 2025 11:15:52 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:15:51 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:13:46 +0800
Subject: [PATCH v3 03/19] mm, swap: never bypass the swap cache even for
 SWP_SYNCHRONOUS_IO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-3-33f54f707a5c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=12677;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=aVFvf2crptwdmhd9deVsooYisoiLEO+MLQv3WATEJDc=;
 b=hjUaqvrGMfhEkIbdfUq9ZlDOej8AxaikVBeDeOY138gqVzpfnPqWZc4dj5LySIBHHJ1RprTAc
 JDHq8clEGGGAHlAH86RVFbandwEURXQAU29zKsOjHWgadAC1TWGAfkx
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 621C110001A
X-Stat-Signature: 7r1jbd87mfmhy1gkjjhwxbhk9tr7zeux
X-Rspam-User: 
X-HE-Tag: 1764011753-418353
X-HE-Meta: U2FsdGVkX188Xmzb0Gv8EqsMKTPUcvCjULsnpDGEVhNopH8OQ0YJ1EASTPJdb6vaDI2YLEm2NOyk3X8oZA54yuZxDccsR7lY/FqTTNqCOivjqEKqGFriFm0invP1yKt+mB7tkvJ72vkGOU+OFA28d96LIXU6hSyfUBlDUZxcnhYjVjpz9lT4GS6up26is2wEvaqXiIvO9BvKMqVHD4vLV6fdkAOD42eYHuRolsoILm6Q/YE1vW+Mbk0q1Wnx7Z/eXEBPFCZUsTBMdulSDFr3SiizxOBPbhgHnDFdVa0kwwVFrWSPLGKwYZmXcS+FId3dLyu5ZRFsR99Iug5e+m8gTFalkTa+hV3RA9O3+kzWjY1qB2LtTRUvBxPv1VYHUyYEllGeDpPbYUZ6+n3xbUG5FBDpbBqp08YvotCaJeH8wVmXsiyKNnQvV1xDmpQvq0rC6ARy5uSLrR+Q+RR8E8iwfHFywrEDFMCLhcic/7SGHgFV7vE/cW3VZRPXqeILZHUsRsuRtsD+E/bVElNBcRZ451tMfiMhjuc33hG/XW5Hnc8d5mv9FoKAo/uI4IMJ+7W5SMCHZuxERTGOT4zJgfSWxRkok9qoFl5wbo1WMmlDtZtOQc3xHo67VeFX1CGSdodogiVEWO1wg00gLX+1YTP9goyQjrQ3zL5rZ2yPDDiGYCC3s/484piiRNGtPXbTEF8QUOOusldMHgjSoH9IyXFWSWJHrqtc6oC8heGARCkEV0dWUssAjhXYyXm/0Cqba9ET0OLKKsEM2/+SYIoCKQvQvt844CZIOM4fANbaoDXSOv5nlZ9K1dS+YybOoLKw2tja4kuyw6ssKcJB+tFgrJZj2DHbxJbTkeCwjUtahu3Q7ipRd1TCuZyjWRuVHdsyCswMZ0o8bXqZ30ZoqmVqEZs0/zClYy6ZNf7Amz2AV9RpqBEdKT0z86yA8aOqhmlygxL20MFqfuOnHErab/AzlNz
 YHAfzDZN
 13eWB2O+We2JFKwaX0kvNtrzu06Fx2QNmGbs5updj7WexEPKAOYhv/v5C8sTBL4ObASmHsJ38HAyS3ixW392k+FwtodmJQNp6UaRcxhs72T7r7Db0nKWHgXWgwOJ/sac2ySm6Ej9Cv1DxKDgeXtbNC+2fhNJlhnBM5eqdcDUy4RqXNFjP02g2cU1TMYALZGwRUibypbYcSSDMifPuNAdf4t3NVUVkkH3dH0lCJ06s+l6nQPrBoXqnf+bmDSxmn58kEE+PrzTvRkLXS5qqtVscB8C0wNYvsNphk8lWnWnJKBKaNUiM5QM/xBTbPFN1dr0eLqoB+RUnREEw9FSG2aFvxJY1+s4Bfa9/eRifAB/nv7SxuIb6b8ABXvJtWuXflOLph2Of2UePNBdbObyuy5CP9qAIn4+5SHKnERMdy1xv+oimy3A8as1jH7ijU3g0CXa78ReWrdpR/AobdjoyM5ED9JxPusu4iyqH0z9F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now the overhead of the swap cache is trivial. Bypassing the swap cache
is no longer a valid optimization. So unify the swapin path using the
swap cache. This changes the swap in behavior in two observable ways.

Readahead is now always disabled for SWP_SYNCHRONOUS_IO devices, which
is a huge win for most workloads: We used to rely on `SWP_SYNCHRONOUS_IO
&& __swap_count(entry) == 1` as the indicator to bypass both the swap
cache and readahead, the swap count check made bypassing ineffective in
many cases, and it's not a good indicator. The limitation existed
because the current swap design made it hard to decouple readahead
bypassing and swap cache bypassing [1]. We do want to always bypass
readahead for SWP_SYNCHRONOUS_IO devices, but bypassing swap cache will
cause redundant IO and memory overhead. Now that swap cache bypassing is
gone, this swap count check can be dropped, the new introduced swap path
is now always effective to skip the readahead.

The second thing here is that this enabled a large swap for all swap
entries on SWP_SYNCHRONOUS_IO devices. Previously, the large swap in is
also coupled with swap cache bypassing, and so the swap count checking
also makes large swap in less effective. Now this is also improved. We
will always have large swap supported for all SWP_SYNCHRONOUS_IO cases.

And to catch potential issues with large swap in, especially with page
exclusiveness and swap cache, more debug sanity checks and comments are
added. But overall, the code is simpler. And new helper and routines
will be used by other components in later commits too. And now it's
possible to rely on the swap cache layer for resolving synchronization
issues, which will also be done by a later commit.

Worth mentioning that for a large folio workload, this may cause more
serious thrashing. This isn't a problem with this commit, but a generic
large folio issue. For a 4K workload, this commit increases the
performance.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c     | 137 +++++++++++++++++++++-----------------------------------
 mm/swap.h       |   6 +++
 mm/swap_state.c |  27 +++++++++++
 3 files changed, 85 insertions(+), 85 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6675e87eb7dd..41b690eb8c00 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4608,7 +4608,16 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
+/* Sanity check that a folio is fully exclusive */
+static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
+				 unsigned int nr_pages)
+{
+	/* Called under PT locked and folio locked, the swap count is stable */
+	do {
+		VM_WARN_ON_ONCE_FOLIO(__swap_count(entry) != 1, folio);
+		entry.val++;
+	} while (--nr_pages);
+}
 
 /*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
@@ -4621,17 +4630,14 @@ static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
 vm_fault_t do_swap_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct folio *swapcache, *folio = NULL;
-	DECLARE_WAITQUEUE(wait, current);
+	struct folio *swapcache = NULL, *folio;
 	struct page *page;
 	struct swap_info_struct *si = NULL;
 	rmap_t rmap_flags = RMAP_NONE;
-	bool need_clear_cache = false;
 	bool exclusive = false;
 	softleaf_t entry;
 	pte_t pte;
 	vm_fault_t ret = 0;
-	void *shadow = NULL;
 	int nr_pages;
 	unsigned long page_idx;
 	unsigned long address;
@@ -4702,57 +4708,21 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	folio = swap_cache_get_folio(entry);
 	if (folio)
 		swap_update_readahead(folio, vma, vmf->address);
-	swapcache = folio;
-
 	if (!folio) {
-		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
-		    __swap_count(entry) == 1) {
-			/* skip swapcache */
+		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			folio = alloc_swap_folio(vmf);
 			if (folio) {
-				__folio_set_locked(folio);
-				__folio_set_swapbacked(folio);
-
-				nr_pages = folio_nr_pages(folio);
-				if (folio_test_large(folio))
-					entry.val = ALIGN_DOWN(entry.val, nr_pages);
 				/*
-				 * Prevent parallel swapin from proceeding with
-				 * the cache flag. Otherwise, another thread
-				 * may finish swapin first, free the entry, and
-				 * swapout reusing the same entry. It's
-				 * undetectable as pte_same() returns true due
-				 * to entry reuse.
+				 * folio is charged, so swapin can only fail due
+				 * to raced swapin and return NULL.
 				 */
-				if (swapcache_prepare(entry, nr_pages)) {
-					/*
-					 * Relax a bit to prevent rapid
-					 * repeated page faults.
-					 */
-					add_wait_queue(&swapcache_wq, &wait);
-					schedule_timeout_uninterruptible(1);
-					remove_wait_queue(&swapcache_wq, &wait);
-					goto out_page;
-				}
-				need_clear_cache = true;
-
-				memcg1_swapin(entry, nr_pages);
-
-				shadow = swap_cache_get_shadow(entry);
-				if (shadow)
-					workingset_refault(folio, shadow);
-
-				folio_add_lru(folio);
-
-				/* To provide entry to swap_read_folio() */
-				folio->swap = entry;
-				swap_read_folio(folio, NULL);
-				folio->private = NULL;
+				swapcache = swapin_folio(entry, folio);
+				if (swapcache != folio)
+					folio_put(folio);
+				folio = swapcache;
 			}
 		} else {
-			folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
-						vmf);
-			swapcache = folio;
+			folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, vmf);
 		}
 
 		if (!folio) {
@@ -4774,6 +4744,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
 	}
 
+	swapcache = folio;
 	ret |= folio_lock_or_retry(folio, vmf);
 	if (ret & VM_FAULT_RETRY)
 		goto out_release;
@@ -4843,24 +4814,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out_nomap;
 	}
 
-	/* allocated large folios for SWP_SYNCHRONOUS_IO */
-	if (folio_test_large(folio) && !folio_test_swapcache(folio)) {
-		unsigned long nr = folio_nr_pages(folio);
-		unsigned long folio_start = ALIGN_DOWN(vmf->address, nr * PAGE_SIZE);
-		unsigned long idx = (vmf->address - folio_start) / PAGE_SIZE;
-		pte_t *folio_ptep = vmf->pte - idx;
-		pte_t folio_pte = ptep_get(folio_ptep);
-
-		if (!pte_same(folio_pte, pte_move_swp_offset(vmf->orig_pte, -idx)) ||
-		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
-			goto out_nomap;
-
-		page_idx = idx;
-		address = folio_start;
-		ptep = folio_ptep;
-		goto check_folio;
-	}
-
 	nr_pages = 1;
 	page_idx = 0;
 	address = vmf->address;
@@ -4904,12 +4857,37 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	BUG_ON(!folio_test_anon(folio) && folio_test_mappedtodisk(folio));
 	BUG_ON(folio_test_anon(folio) && PageAnonExclusive(page));
 
+	/*
+	 * If a large folio already belongs to anon mapping, then we
+	 * can just go on and map it partially.
+	 * If not, with the large swapin check above failing, the page table
+	 * have changed, so sub pages might got charged to the wrong cgroup,
+	 * or even should be shmem. So we have to free it and fallback.
+	 * Nothing should have touched it, both anon and shmem checks if a
+	 * large folio is fully appliable before use.
+	 *
+	 * This will be removed once we unify folio allocation in the swap cache
+	 * layer, where allocation of a folio stabilizes the swap entries.
+	 */
+	if (!folio_test_anon(folio) && folio_test_large(folio) &&
+	    nr_pages != folio_nr_pages(folio)) {
+		if (!WARN_ON_ONCE(folio_test_dirty(folio)))
+			swap_cache_del_folio(folio);
+		goto out_nomap;
+	}
+
 	/*
 	 * Check under PT lock (to protect against concurrent fork() sharing
 	 * the swap entry concurrently) for certainly exclusive pages.
 	 */
 	if (!folio_test_ksm(folio)) {
+		/*
+		 * The can_swapin_thp check above ensures all PTE have
+		 * same exclusiveness. Checking just one PTE is fine.
+		 */
 		exclusive = pte_swp_exclusive(vmf->orig_pte);
+		if (exclusive)
+			check_swap_exclusive(folio, entry, nr_pages);
 		if (folio != swapcache) {
 			/*
 			 * We have a fresh page that is not exposed to the
@@ -4987,18 +4965,16 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	vmf->orig_pte = pte_advance_pfn(pte, page_idx);
 
 	/* ksm created a completely new copy */
-	if (unlikely(folio != swapcache && swapcache)) {
+	if (unlikely(folio != swapcache)) {
 		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
 	} else if (!folio_test_anon(folio)) {
 		/*
-		 * We currently only expect small !anon folios which are either
-		 * fully exclusive or fully shared, or new allocated large
-		 * folios which are fully exclusive. If we ever get large
-		 * folios within swapcache here, we have to be careful.
+		 * We currently only expect !anon folios that are fully
+		 * mappable. See the comment after can_swapin_thp above.
 		 */
-		VM_WARN_ON_ONCE(folio_test_large(folio) && folio_test_swapcache(folio));
-		VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+		VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) != nr_pages, folio);
+		VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 		folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
 	} else {
 		folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, address,
@@ -5038,12 +5014,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 out:
-	/* Clear the swap cache pin for direct swapin after PTL unlock */
-	if (need_clear_cache) {
-		swapcache_clear(si, entry, nr_pages);
-		if (waitqueue_active(&swapcache_wq))
-			wake_up(&swapcache_wq);
-	}
 	if (si)
 		put_swap_device(si);
 	return ret;
@@ -5051,6 +5021,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 out_page:
+	if (folio_test_swapcache(folio))
+		folio_free_swap(folio);
 	folio_unlock(folio);
 out_release:
 	folio_put(folio);
@@ -5058,11 +5030,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		folio_unlock(swapcache);
 		folio_put(swapcache);
 	}
-	if (need_clear_cache) {
-		swapcache_clear(si, entry, nr_pages);
-		if (waitqueue_active(&swapcache_wq))
-			wake_up(&swapcache_wq);
-	}
 	if (si)
 		put_swap_device(si);
 	return ret;
diff --git a/mm/swap.h b/mm/swap.h
index 0fff92e42cfe..214e7d041030 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -268,6 +268,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
 		struct mempolicy *mpol, pgoff_t ilx);
 struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
 		struct vm_fault *vmf);
+struct folio *swapin_folio(swp_entry_t entry, struct folio *folio);
 void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 			   unsigned long addr);
 
@@ -386,6 +387,11 @@ static inline struct folio *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
 	return NULL;
 }
 
+static inline struct folio *swapin_folio(swp_entry_t entry, struct folio *folio)
+{
+	return NULL;
+}
+
 static inline void swap_update_readahead(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr)
 {
diff --git a/mm/swap_state.c b/mm/swap_state.c
index a8511ce43242..e3c01e5bc978 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -545,6 +545,33 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 	return result;
 }
 
+/**
+ * swapin_folio - swap-in one or multiple entries skipping readahead.
+ * @entry: starting swap entry to swap in
+ * @folio: a new allocated and charged folio
+ *
+ * Reads @entry into @folio, @folio will be added to the swap cache.
+ * If @folio is a large folio, the @entry will be rounded down to align
+ * with the folio size.
+ *
+ * Return: returns pointer to @folio on success. If folio is a large folio
+ * and this raced with another swapin, NULL will be returned. Else, if
+ * another folio was already added to the swap cache, return that swap
+ * cache folio instead.
+ */
+struct folio *swapin_folio(swp_entry_t entry, struct folio *folio)
+{
+	struct folio *swapcache;
+	pgoff_t offset = swp_offset(entry);
+	unsigned long nr_pages = folio_nr_pages(folio);
+
+	entry = swp_entry(swp_type(entry), round_down(offset, nr_pages));
+	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true, false);
+	if (swapcache == folio)
+		swap_read_folio(folio, NULL);
+	return swapcache;
+}
+
 /*
  * Locate a page of swap in physical memory, reserving swap cache space
  * and reading the disk if it is not already cached.

-- 
2.52.0


