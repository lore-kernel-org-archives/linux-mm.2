Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0919CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 16:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CA908E00A2; Wed, 29 Oct 2025 12:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A38C8E0045; Wed, 29 Oct 2025 12:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B8DB8E00A2; Wed, 29 Oct 2025 12:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 248E58E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:00:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E22A24A0DF
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:00:12 +0000 (UTC)
X-FDA: 84051613464.02.6009F41
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id E9959C000D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:00:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PazSlSj3;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOSfsWO395+hyZyDR55RbtfmCUyV+LYQE7dhSnv1egg=;
	b=VGIf5IzWf6K0oM3pMFx4Bq0fOH5yU10JK+0xFqgrevHKGMa6OSffxvwvdqVb2wQXNnxZXU
	lASEDpaswtm0lcSYUbI5tdiGU4tXTuITM7xWycZ/vp3ILYF6d9wIX7pm5cFLWMT8PxLq4u
	pYhCxNpI/mIcOf33omRWp1XcGCbT6XQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PazSlSj3;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753611; a=rsa-sha256;
	cv=none;
	b=ZIO5Ce7zkB51fGIdA4nwjTqi50gAcRAlB/DE6ZxNUvcEnRbvQxTcQyJIIUaczmgCEWj5Ud
	PWYPiJxC0UBhIrpKC3XatQG7sRQCD3INqsvrmgEGlluup7F9575yOq1gEbhfAG/lWaRFI/
	KQvKCAncAk9iy/sWR4vZQnbPy9ceP30=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-33f9aec69b6so38770a91.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753610; x=1762358410; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WOSfsWO395+hyZyDR55RbtfmCUyV+LYQE7dhSnv1egg=;
        b=PazSlSj3yccKINuMq5n6p/xS+GfawPKlwPhI5NFlm8ts5+j09Y5ZqlsjZHSkUhIVgP
         2/JY9+/EolUmDTgGd3nPUUmgQ8fxPN/ydgMGa0KiEuEXdvxqssk03/XvRD6aMrOTR7c4
         2EWK2c4QbM6MNBU8BGsWgUWRXLfWo13i7Q3QbaImnzyAgp4AuO1JCkzP036VJcAxqlLy
         CaXmfZrwIACvFyqNuWkCR1V4qloTBR62MqKe3ouzHaIthQB6xMB0aRURSMTu3kFj7ifS
         KvPPo9fdXKx4z2XHIElfuEZOGkdd5jgJHvetLgltChAmluvaGemA/Hh6t5PM5O0UKD1y
         ORaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753610; x=1762358410;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WOSfsWO395+hyZyDR55RbtfmCUyV+LYQE7dhSnv1egg=;
        b=cqaOLaJxjjjqT/42RBn95sQTx+q2cCBRFp7M9w8ku2TidobYeP2Dv2L3/aij/3zdlN
         LQ6j/2XBTi4eNPmeYMG6Zw8wTQdCfJEvTYtYekZ5mUqakwl3koqsUjTJNb7gtBVB6DZT
         5kr0BxSKhiBBwWawFp8w63/LmDOhnTVErj0H3QRl3Cl+4OHpbmRYZvtB8BcOBwTZTU3C
         CbZ3+dr2+bqWo6rT+UkowhlE4a+6rTSiIcQwpaw6lSsFhsP4S0MyrJ7hbjz5ceqBsN6Z
         K0nx9r/x4IVBQyPuPTIlMeFawPkaq1OR2i2JUsAz3qzbeP7cCo9R2ZXSBxUoNSupFa8d
         +tMg==
X-Gm-Message-State: AOJu0Yzsg8Cbs+53rB9xmToSTLb8ehFqKZB3QkBLaPIS6s+Xva2V98k/
	KOFPa5jKAEWuCIwwGIovgoRBQt/E/4sOor0ZWrhzc5EF0/R0vd0Thlk8
X-Gm-Gg: ASbGncsGicuyNJi6tcFLInMGcgsakS7jP8PG7XOjrRCO/ziutROj9EpoVQsgG51LWip
	z6RX5NBeU7qLmfeFxpxZgiVFqB/RqWgsJCE1hSLlum5U4DcHXdBG/O/CuFC8o2Bq31EQy4sQrpt
	szKThsI1xIM8+RqUhiAif+VR5b3GDk31NfXwL5zGyVQYXa1+OgSHM5dNvyhikjgfOKa1XJ5ZQ+O
	9K41h1fPtUQaS5wcoWFzPKIF3sO0GrNRSemjKpCP4CF5aGpkwtr2lVyddYe3Ix8zjSNMYi7PYs4
	IITzhTLHQTZA12aedW0iGvJRItHxgGHF/fiZzoNbtI8lk5MFagI+ObX9zL05EeBUlvSc+LKhGN9
	FMiPUere8QqFKY+hXgQjpm253XmbGmaJwyIEYOMDjTYvSvX7VnnlDkYovD4OF5AMqA+hPtehflI
	jLUTQGZ/QToX18nb7pTL8j
X-Google-Smtp-Source: AGHT+IHdMKk0xrUMkpxGL9OB/4Oy3R/jyTgK3C9xNhiIjy3DnteEJ3lW0AdeKL6BPVPFkxO3dw9Q8Q==
X-Received: by 2002:a17:90b:2687:b0:335:2eef:4ca8 with SMTP id 98e67ed59e1d1-3403a303662mr4108145a91.33.1761753609476;
        Wed, 29 Oct 2025 09:00:09 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.09.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 09:00:08 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:41 +0800
Subject: [PATCH 15/19] mm, swap: add folio to swap cache directly on
 allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-15-3d43f3b6ec32@tencent.com>
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
X-Stat-Signature: h39hch783s36t1dicffmdkx5ma79btux
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E9959C000D
X-HE-Tag: 1761753610-885067
X-HE-Meta: U2FsdGVkX19Uxonie7hSvTeeWLjks0KFIM1H4riP3gIFQ7DVDnjOGgHiddI2fHk0eJ4CPZ2jcf4IFDiiwSlOmNqLZZEBwGoYfQ6SY2a6pzWrO0yQ/l3An7muhek0STAwb6Lx0Ti0/BVDOCvr2MV0rntSmhj2dBKBsYJLSelLjw5kMJq627eTmWS8Og9DtDGRp29kJEMQdTQL+NLI+wHThAuEs9z0MISQ2Sr+kk1yDHsC5FYY0d234tH3NiS5pjO1ntLxok8bFW2SnS67YrTu5Cd/fD9jcUFjNoF2F7if8UTNhJaS/Etb+JPWmQn9+vA/7s6Q9S7EtHOvrDROj9Ot6SX4aBtFewDhODUqhpUVyd7v1y7sb6wapTiYNLZq1pgDOz0PfDUgYmzhWpLh2dNG/wYFScHqkNNPTd/u91N40R2mj0RsgTKCtUGcBQSRlXCh1VGnJG1/t56RlX8ISluSiNrpxmd/ZcEOHU0l9yYGSjC6YhHsFpfe0dPNn/NOcgCeyyMFACBLKGuep74VHxYxU9f9XB2z38SctJxFIEbtJY8ytgcBXQJ6P4EnMgCCSczbOg2YQp+rGapOCitds4PdTkfLsNs5ks/tyuH7E4WAQFCndjPn9DeALzqPwfll9SOQrhuR0ePWpyNrsQR1EO8NP5q+l6R/wBpovIMlPDN8HP2DYKn8GeCm8llWQGafcSp8JfxFloojJ7pEv7FBtaz4fzQf1E8agSuZg49nN7Iq3QpFoU0CCmX2oyb+/90muOM+hxIuBuvIp+18SuXuT/lD74irCKOvizva849VgjS+oZV9J0BHd3efl5pF/jxt738QWxpCemDmStJE9n6p9I7U7I5P+a5A2v/WrmJDx+Taf5ub+eyqoNQEE77tSoEo+fwzd7sGm/kzc+6RpZZnx+OAv2w3X5DPM9DMyzgSCUx1rorkaURMlCgIvkuWyvV3JoGfJWqA5KDasS4ygRIK3nN
 82zDnI83
 ZC+CVhjZT3D70RvoC8TcvgeucqX0Q5hA4zNKoBoG2HfNQ3W2NVqSOgzNtmZpGfWDXLzvpa7y0OtwggPUCTFKgfwVHO8FvKeniWnKto7o+ucGJtUycfnbipknHGYm97W7sRK6VpHNpbt8sRgmYGzRXYgYg26sVLqRocGq9P4v2LFXlHxTdL/+xA6Vt+SS8/T2MxiNhg+NhdMHvAhC0Ck2SYKkYlkz+jB3+DVuH0FPAyIeSe9N/bP4uf1VKcWcRa2WVOsDPp+zVqmTfgs7Hpxz9p09kYTnWTChydeL4fstB93hhGB5j85BJSgbwSOJYmudpiQxXLyCLZqo8cFXg9JQup4K+2tCuasXfKM2+WGJU2oX0vgw04zD9De1kIS51j0WMQuLX/VKFYwPhz7PhZUO5bWOhpqdrcsAORph166djXdpn2gtdHX3i/LfLrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The allocator uses SWAP_HAS_CACHE to pin a swap slot upon allocation.
SWAP_HAS_CACHE is being deprecated as it caused a lot of confusion.
This pinning usage here can be dropped by adding the folio to swap
cache directly on allocation.

All swap allocations are folio-based now (except for hibernation), so
the swap allocator can always take the folio as the parameter. And now
both swap cache (swap table) and swap map are protected by the cluster
lock, scanning the map and inserting the folio can be done in the same
critical section. This eliminates the time window that a slot is pinned
by SWAP_HAS_CACHE, but it has no cache, and avoids touching the lock
multiple times.

This is both a cleanup and an optimization.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |   5 --
 mm/swap.h            |   8 +--
 mm/swap_state.c      |  56 +++++++++++-------
 mm/swapfile.c        | 161 +++++++++++++++++++++------------------------------
 4 files changed, 105 insertions(+), 125 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index ac3caa4c6999..4b4b81fbc6a3 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -452,7 +452,6 @@ static inline long get_nr_swap_pages(void)
 }
 
 extern void si_swapinfo(struct sysinfo *);
-void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
 int swap_type_of(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
@@ -534,10 +533,6 @@ static inline void swap_put_entries_direct(swp_entry_t ent, int nr)
 {
 }
 
-static inline void put_swap_folio(struct folio *folio, swp_entry_t swp)
-{
-}
-
 static inline int __swap_count(swp_entry_t entry)
 {
 	return 0;
diff --git a/mm/swap.h b/mm/swap.h
index 74c61129d7b7..03694ffa662f 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -277,13 +277,13 @@ void __swapcache_clear_cached(struct swap_info_struct *si,
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
-int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-			 void **shadow, bool alloc);
 void swap_cache_del_folio(struct folio *folio);
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
 				     struct mempolicy *mpol, pgoff_t ilx,
 				     bool *alloced);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
+void __swap_cache_add_folio(struct swap_cluster_info *ci,
+			    struct folio *folio, swp_entry_t entry);
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry, void *shadow);
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
@@ -459,8 +459,8 @@ static inline void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
-static inline int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-				       void **shadow, bool alloc)
+static inline void *__swap_cache_add_folio(struct swap_cluster_info *ci,
+		struct folio *folio, swp_entry_t entry)
 {
 }
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index d2bcca92b6e0..85d9f99c384f 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -122,6 +122,34 @@ void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
+void __swap_cache_add_folio(struct swap_cluster_info *ci,
+			    struct folio *folio, swp_entry_t entry)
+{
+	unsigned long new_tb;
+	unsigned int ci_start, ci_off, ci_end;
+	unsigned long nr_pages = folio_nr_pages(folio);
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
+
+	new_tb = folio_to_swp_tb(folio);
+	ci_start = swp_cluster_offset(entry);
+	ci_off = ci_start;
+	ci_end = ci_start + nr_pages;
+	do {
+		VM_WARN_ON_ONCE(swp_tb_is_folio(__swap_table_get(ci, ci_off)));
+		__swap_table_set(ci, ci_off, new_tb);
+	} while (++ci_off < ci_end);
+
+	folio_ref_add(folio, nr_pages);
+	folio_set_swapcache(folio);
+	folio->swap = entry;
+
+	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
+}
+
 /**
  * swap_cache_add_folio - Add a folio into the swap cache.
  * @folio: The folio to be added.
@@ -136,23 +164,18 @@ void *swap_cache_get_shadow(swp_entry_t entry)
  * The caller also needs to update the corresponding swap_map slots with
  * SWAP_HAS_CACHE bit to avoid race or conflict.
  */
-int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-			 void **shadowp, bool alloc)
+static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+				void **shadowp)
 {
 	int err;
 	void *shadow = NULL;
+	unsigned long old_tb;
 	struct swap_info_struct *si;
-	unsigned long old_tb, new_tb;
 	struct swap_cluster_info *ci;
 	unsigned int ci_start, ci_off, ci_end, offset;
 	unsigned long nr_pages = folio_nr_pages(folio);
 
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
-
 	si = __swap_entry_to_info(entry);
-	new_tb = folio_to_swp_tb(folio);
 	ci_start = swp_cluster_offset(entry);
 	ci_end = ci_start + nr_pages;
 	ci_off = ci_start;
@@ -168,7 +191,7 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 			err = -EEXIST;
 			goto failed;
 		}
-		if (!alloc && unlikely(!__swap_count(swp_entry(swp_type(entry), offset)))) {
+		if (unlikely(!__swap_count(swp_entry(swp_type(entry), offset)))) {
 			err = -ENOENT;
 			goto failed;
 		}
@@ -184,20 +207,11 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 		 * Still need to pin the slots with SWAP_HAS_CACHE since
 		 * swap allocator depends on that.
 		 */
-		if (!alloc)
-			__swapcache_set_cached(si, ci, swp_entry(swp_type(entry), offset));
-		__swap_table_set(ci, ci_off, new_tb);
+		__swapcache_set_cached(si, ci, swp_entry(swp_type(entry), offset));
 		offset++;
 	} while (++ci_off < ci_end);
-
-	folio_ref_add(folio, nr_pages);
-	folio_set_swapcache(folio);
-	folio->swap = entry;
+	__swap_cache_add_folio(ci, folio, entry);
 	swap_cluster_unlock(ci);
-
-	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
-	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
-
 	if (shadowp)
 		*shadowp = shadow;
 	return 0;
@@ -466,7 +480,7 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
 	for (;;) {
-		ret = swap_cache_add_folio(folio, entry, &shadow, false);
+		ret = swap_cache_add_folio(folio, entry, &shadow);
 		if (!ret)
 			break;
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 426b0b6d583f..8d98f28907bc 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -875,28 +875,53 @@ static void swap_cluster_assert_table_empty(struct swap_cluster_info *ci,
 	}
 }
 
-static bool cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster_info *ci,
-				unsigned int start, unsigned char usage,
-				unsigned int order)
+static bool cluster_alloc_range(struct swap_info_struct *si,
+				struct swap_cluster_info *ci,
+				struct folio *folio,
+				unsigned int offset)
 {
-	unsigned int nr_pages = 1 << order;
+	unsigned long nr_pages;
+	unsigned int order;
 
 	lockdep_assert_held(&ci->lock);
 
 	if (!(si->flags & SWP_WRITEOK))
 		return false;
 
+	/*
+	 * All mm swap allocation starts with a folio (folio_alloc_swap),
+	 * it's also the only allocation path for large orders allocation.
+	 * Such swap slots starts with count == 0 and will be increased
+	 * upon folio unmap.
+	 *
+	 * Else, it's a exclusive order 0 allocation for hibernation.
+	 * The slot starts with count == 1 and never increases.
+	 */
+	if (likely(folio)) {
+		order = folio_order(folio);
+		nr_pages = 1 << order;
+		/*
+		 * Pin the slot with SWAP_HAS_CACHE to satisfy swap_dup_entries.
+		 * This is the legacy allocation behavior, will drop it very soon.
+		 */
+		memset(si->swap_map + offset, SWAP_HAS_CACHE, nr_pages);
+		__swap_cache_add_folio(ci, folio, swp_entry(si->type, offset));
+	} else {
+		order = 0;
+		nr_pages = 1;
+		WARN_ON_ONCE(si->swap_map[offset]);
+		si->swap_map[offset] = 1;
+		swap_cluster_assert_table_empty(ci, offset, 1);
+	}
+
 	/*
 	 * The first allocation in a cluster makes the
 	 * cluster exclusive to this order
 	 */
 	if (cluster_is_empty(ci))
 		ci->order = order;
-
-	memset(si->swap_map + start, usage, nr_pages);
-	swap_cluster_assert_table_empty(ci, start, nr_pages);
-	swap_range_alloc(si, nr_pages);
 	ci->count += nr_pages;
+	swap_range_alloc(si, nr_pages);
 
 	return true;
 }
@@ -904,13 +929,12 @@ static bool cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster
 /* Try use a new cluster for current CPU and allocate from it. */
 static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 					    struct swap_cluster_info *ci,
-					    unsigned long offset,
-					    unsigned int order,
-					    unsigned char usage)
+					    struct folio *folio, unsigned long offset)
 {
 	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
 	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
+	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned int nr_pages = 1 << order;
 	bool need_reclaim;
 
@@ -930,7 +954,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 				continue;
 			offset = found;
 		}
-		if (!cluster_alloc_range(si, ci, offset, usage, order))
+		if (!cluster_alloc_range(si, ci, folio, offset))
 			break;
 		found = offset;
 		offset += nr_pages;
@@ -952,8 +976,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 
 static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 					 struct list_head *list,
-					 unsigned int order,
-					 unsigned char usage,
+					 struct folio *folio,
 					 bool scan_all)
 {
 	unsigned int found = SWAP_ENTRY_INVALID;
@@ -965,7 +988,7 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 		if (!ci)
 			break;
 		offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, offset, order, usage);
+		found = alloc_swap_scan_cluster(si, ci, folio, offset);
 		if (found)
 			break;
 	} while (scan_all);
@@ -1026,10 +1049,11 @@ static void swap_reclaim_work(struct work_struct *work)
  * Try to allocate swap entries with specified order and try set a new
  * cluster for current CPU too.
  */
-static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int order,
-					      unsigned char usage)
+static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
+					      struct folio *folio)
 {
 	struct swap_cluster_info *ci;
+	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned int offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 
 	/*
@@ -1051,8 +1075,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(si, ci);
-			found = alloc_swap_scan_cluster(si, ci, offset,
-							order, usage);
+			found = alloc_swap_scan_cluster(si, ci, folio, offset);
 		} else {
 			swap_cluster_unlock(ci);
 		}
@@ -1066,22 +1089,19 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 	 * to spread out the writes.
 	 */
 	if (si->flags & SWP_PAGE_DISCARD) {
-		found = alloc_swap_scan_list(si, &si->free_clusters, order, usage,
-					     false);
+		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
 	}
 
 	if (order < PMD_ORDER) {
-		found = alloc_swap_scan_list(si, &si->nonfull_clusters[order],
-					     order, usage, true);
+		found = alloc_swap_scan_list(si, &si->nonfull_clusters[order], folio, true);
 		if (found)
 			goto done;
 	}
 
 	if (!(si->flags & SWP_PAGE_DISCARD)) {
-		found = alloc_swap_scan_list(si, &si->free_clusters, order, usage,
-					     false);
+		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
 	}
@@ -1097,8 +1117,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		 * failure is not critical. Scanning one cluster still
 		 * keeps the list rotated and reclaimed (for HAS_CACHE).
 		 */
-		found = alloc_swap_scan_list(si, &si->frag_clusters[order], order,
-					     usage, false);
+		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, false);
 		if (found)
 			goto done;
 	}
@@ -1112,13 +1131,11 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		 * Clusters here have at least one usable slots and can't fail order 0
 		 * allocation, but reclaim may drop si->lock and race with another user.
 		 */
-		found = alloc_swap_scan_list(si, &si->frag_clusters[o],
-					     0, usage, true);
+		found = alloc_swap_scan_list(si, &si->frag_clusters[o], folio, true);
 		if (found)
 			goto done;
 
-		found = alloc_swap_scan_list(si, &si->nonfull_clusters[o],
-					     0, usage, true);
+		found = alloc_swap_scan_list(si, &si->nonfull_clusters[o], folio, true);
 		if (found)
 			goto done;
 	}
@@ -1309,12 +1326,12 @@ static bool get_swap_device_info(struct swap_info_struct *si)
  * Fast path try to get swap entries with specified order from current
  * CPU's swap entry pool (a cluster).
  */
-static bool swap_alloc_fast(swp_entry_t *entry,
-			    int order)
+static bool swap_alloc_fast(struct folio *folio)
 {
+	unsigned int order = folio_order(folio);
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
-	unsigned int offset, found = SWAP_ENTRY_INVALID;
+	unsigned int offset;
 
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
@@ -1329,22 +1346,18 @@ static bool swap_alloc_fast(swp_entry_t *entry,
 	if (cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, offset, order, SWAP_HAS_CACHE);
-		if (found)
-			*entry = swp_entry(si->type, found);
+		alloc_swap_scan_cluster(si, ci, folio, offset);
 	} else {
 		swap_cluster_unlock(ci);
 	}
 
 	put_swap_device(si);
-	return !!found;
+	return folio_test_swapcache(folio);
 }
 
 /* Rotate the device and switch to a new cluster */
-static bool swap_alloc_slow(swp_entry_t *entry,
-			    int order)
+static void swap_alloc_slow(struct folio *folio)
 {
-	unsigned long offset;
 	struct swap_info_struct *si, *next;
 
 	spin_lock(&swap_avail_lock);
@@ -1354,14 +1367,12 @@ static bool swap_alloc_slow(swp_entry_t *entry,
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
 		if (get_swap_device_info(si)) {
-			offset = cluster_alloc_swap_entry(si, order, SWAP_HAS_CACHE);
+			cluster_alloc_swap_entry(si, folio);
 			put_swap_device(si);
-			if (offset) {
-				*entry = swp_entry(si->type, offset);
-				return true;
-			}
-			if (order)
-				return false;
+			if (folio_test_swapcache(folio))
+				return;
+			if (folio_test_large(folio))
+				return;
 		}
 
 		spin_lock(&swap_avail_lock);
@@ -1423,7 +1434,6 @@ int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
-	swp_entry_t entry = {};
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
@@ -1448,39 +1458,23 @@ int folio_alloc_swap(struct folio *folio)
 
 again:
 	local_lock(&percpu_swap_cluster.lock);
-	if (!swap_alloc_fast(&entry, order))
-		swap_alloc_slow(&entry, order);
+	if (!swap_alloc_fast(folio))
+		swap_alloc_slow(folio);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	if (unlikely(!order && !entry.val)) {
+	if (!order && unlikely(!folio_test_swapcache(folio))) {
 		if (swap_sync_discard())
 			goto again;
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (mem_cgroup_try_charge_swap(folio, entry))
-		goto out_free;
+	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
+		swap_cache_del_folio(folio);
 
-	if (!entry.val)
+	if (unlikely(!folio_test_swapcache(folio)))
 		return -ENOMEM;
 
-	/*
-	 * Allocator has pinned the slots with SWAP_HAS_CACHE
-	 * so it should never fail
-	 */
-	WARN_ON_ONCE(swap_cache_add_folio(folio, entry, NULL, true));
-
-	/*
-	 * Allocator should always allocate aligned entries so folio based
-	 * operations never crossed more than one cluster.
-	 */
-	VM_WARN_ON_ONCE_FOLIO(!IS_ALIGNED(folio->swap.val, size), folio);
-
 	return 0;
-
-out_free:
-	put_swap_folio(folio, entry);
-	return -ENOMEM;
 }
 
 /**
@@ -1779,29 +1773,6 @@ static void swap_entries_free(struct swap_info_struct *si,
 		partial_free_cluster(si, ci);
 }
 
-/*
- * Called after dropping swapcache to decrease refcnt to swap entries.
- */
-void put_swap_folio(struct folio *folio, swp_entry_t entry)
-{
-	struct swap_info_struct *si;
-	struct swap_cluster_info *ci;
-	unsigned long offset = swp_offset(entry);
-	int size = 1 << swap_entry_order(folio_order(folio));
-
-	si = _swap_info_get(entry);
-	if (!si)
-		return;
-
-	ci = swap_cluster_lock(si, offset);
-	if (swap_only_has_cache(si, offset, size))
-		swap_entries_free(si, ci, entry, size);
-	else
-		for (int i = 0; i < size; i++, entry.val++)
-			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
-	swap_cluster_unlock(ci);
-}
-
 int __swap_count(swp_entry_t entry)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
@@ -2052,7 +2023,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 			 * with swap table allocation.
 			 */
 			local_lock(&percpu_swap_cluster.lock);
-			offset = cluster_alloc_swap_entry(si, 0, 1);
+			offset = cluster_alloc_swap_entry(si, NULL);
 			local_unlock(&percpu_swap_cluster.lock);
 			if (offset) {
 				entry = swp_entry(si->type, offset);

-- 
2.51.1


