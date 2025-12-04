Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D893D2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F8E6B009D; Thu,  4 Dec 2025 14:30:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626B26B009E; Thu,  4 Dec 2025 14:30:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 516726B00BE; Thu,  4 Dec 2025 14:30:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 400506B009D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:30:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDC0D56AB7
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:18 +0000 (UTC)
X-FDA: 84182779716.07.4620B40
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id E922C1C001D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U+MrMZds;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3tLTYBb1R8OZr/Q1lTi3HD1NNbsd1epvJzg5LKD0iOs=;
	b=G/Hi76/h6yDLSnzP0z6NlXArfxOhLRp8FOdrvnrw+HmT2hxpZjp5xppp0g9NEDaFRJP3Tk
	mbqkndTp8DekKNqe9PB/84XRWRqR8zISExPOKE1WKrQltuBpHBl98zXCLutoX8mInjy6Cn
	0sgomnEwm+qSyeROvK31QOKL9R+6mwk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U+MrMZds;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876617; a=rsa-sha256;
	cv=none;
	b=SD6XMkq72ydRdsyNxFDd9rdsKifAqWa1oCeSEcFRqJ9bEj7LYi/uzTk/FzwAxwqgS5QNh9
	1gbVEYrzyvD+62CfCf1lNXta5tOIkfpYAiBi5U35Enfv5qog9hr/WU1AoY+28pR1ObD/PT
	FEXx1eQtzw6Bfa6lwvIl+wOxKNO3FUM=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7b22ffa2a88so1329344b3a.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876616; x=1765481416; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3tLTYBb1R8OZr/Q1lTi3HD1NNbsd1epvJzg5LKD0iOs=;
        b=U+MrMZdsgxQAsY8ruRZOzTWhhuqnKaEPT1kNd9T2m+olM6W0CLh4R7mVxiSwe9O8ja
         MionlttT8jy9hn1PeEBwYDK6hlpKG7/03I7EHCfzv9OCMejiVCzkjZQWJpBselFF6q5Q
         7UPrVnZajEf6SLujFkUuEtLCd7aGocn0AzSP+uQF8hdhY2LO7U7nxeOQN8ptjvxz4bbn
         kZdR4RNlXZr6a62iN6iGYbg5jMpeS9oPC9SVij0HHbGYpqtme0V72uakIghe0fWjP5ia
         hfVgT/L66dhvjUyHrKfScDPWtHgMSdrKsHjPWAYXK4vdHKl7JAF5x6h/Bskt998AhRfS
         WBwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876616; x=1765481416;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3tLTYBb1R8OZr/Q1lTi3HD1NNbsd1epvJzg5LKD0iOs=;
        b=QS04eT82im4eHJlBBr7aQqxJ0z1ZxuKxeYu56SJqdKR9tLnoEZa31RdLoLsHIpx165
         Ocq0ih4MMIbPlKCoaMU9YQzn7416LhRYb+rjA/hjdCkYKXmdAPX5G5tVhp4bn2Elcl8s
         VTag+UOgnAuoFyp3fsEDfvIQ9SNyUWuP+6HWia3vPY2ksJGwxC7g8QQRsLMoY91VhpcO
         QeRDQF2xBkjOkXdBxD4OLqep2Hk2g5jg2K6OVzpM6m84wnQ9V+YiMFQM8XNbKfxrVygt
         ulnGmmhtxJzc2Mai2XWX8zjQHDiXg+vS2RlphfqOsWNf+C2OeFi3Luct9xcmrAkBba5x
         ECAg==
X-Gm-Message-State: AOJu0YxnCxPxMRLS1wojiR/nHasizo/Dw2TTuhYXjQJZt9vTcOWd7iUV
	GmPscwxjqTqVOQD/94dGiZ0tI/LbRkwRBRJzbBqdbGRR/RtA2/wXWWbu
X-Gm-Gg: ASbGnct1iLXWbsJu3dOOYA51Tg2sQ9FSCp7PSrfpbrAoKv1DtDe+/NkiBQUupW3eetU
	0tgjZyYcnH4J0KGb620AUyVjYGSmW7nNtHtDhHISCmad/a3w4bcGGLdLMaX8DlSVQ2Y27gjGjki
	x4J8XrGyKR/9emULVYXaXi5qMHhGe4B2Y94U4+SCpHYkn/sVkiGfVeRHOvYdoE7Z2huWs2mk82z
	l/1beTDXG6lwIfB6eMzcrgfJ9VKvRp28sOpRIyNscN/LBEGBqQ9EIYeeMAsJKsEMGTyYC08RCL4
	fr5JisuMJ4/YSpeuv+Prl+57ME3SnbCHNC0VI/D/jY7o7sUVeWa//Hri9Hfn/mQgRt0HLwhf8Cx
	LIwPZSEu36l/KNSrRDqCN88Pc6ZarNjVx/L/UkxY/KELt3iwCRdejD0UphyWztdUk3jqk3E6tiY
	Bx4yBqgvZnEsIYI8E9HYe6+FXn9t5Nefjy3kgk4jqVmJv3fYn+VmJlD2jX+fQ=
X-Google-Smtp-Source: AGHT+IHvJYLo8F8+iVs5g+AC7Z1DpoGJWGbAAjlkPHHFpXjznCercQgieQwO0K2vl+49n6Q84tHoRQ==
X-Received: by 2002:a05:6a20:748d:b0:35e:a390:ca13 with SMTP id adf61e73a8af0-363f5e953eemr9424236637.57.1764876615737;
        Thu, 04 Dec 2025 11:30:15 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:30:15 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:16 +0800
Subject: [PATCH v4 08/19] mm/shmem, swap: remove SWAP_MAP_SHMEM
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-8-cb7e28a26a40@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=7240;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=TGM4pt6Vv98jEk/nHCqFhIlNFGrXBJCep7RNsaXlLtY=;
 b=2ZtxbooaUmEm69Q7j6Un4XL+5k8vWv15mF1yXP0Jzx5HPPvYKOBqYBDrzdiF8Ky+e19Y5W3Fs
 8SIvKR6OGpMCZCbHPiV6hmppOtDCIKekU+9Jm3Vnk+caHaNmLi5r/sT
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Queue-Id: E922C1C001D
X-Rspamd-Server: rspam11
X-Stat-Signature: bow4emyxsywx4otbi946ursarcgjch5y
X-HE-Tag: 1764876616-169336
X-HE-Meta: U2FsdGVkX1+rD9YiP0gZXw7IMbEMg4nLQOBHtVDRMXuwwUQvFykOx8/wE6VR//G+glhljmDwUDMxBPVF/jfapuSqpm83xXiBKmVAI8/tt6qhOUMHWgOf6tfSEGicKRzasokoh/ekjF2V2KIAafj7NiNawbh5nqimbpEr00Koc4nIdlHoJT4M3Qvx1BCReyKzBxXgE3v/ql24enUhlc74Q9wgJvnV41QWL9sGbkLar2+xRWV10xX4UMWaNkoHjB+NTWrm4yFAMc4rnxQ4KwhXsEoxmNS/5OBFSt7/kTrdiUGt7H+Yye7SIyHFNmDjR+4iGW/oIF2hy0FIPL3EvTE34kJxlCn6AkcZu5iMclds/QdlDq5YndLWAQQOBvB8Fd8HHWVWLB5nhIb+t+P4LdCw93duoLCdHgQZGKiH9ulQ/2GluqAK+eq6Z9g9a/kVpjsfGtqEpeb5qO7CPx2M+6lcVJF/bfgFs+/d0d9BpZFM+FRMaH5cqQUV8mn0vaT6AGUIOO1azYAvhRHyVzaf9Kqu6Ib5LDXIhTUwbUVhJYjB1NYBV2jom4te4GTcW9DdWO0HFKXTBw9wxYQGwdJ0wMVU8xSJ/b7uF7pbnPU1uVHYJ2lmMwLwZqQL9owvvD5k+ZZiPpChm2vNQkHxz4KaQaNKkj5rLjUTQfRILIwUlWFI/Q4O8h+WSn6rAULW3+aGGYZqiUvSckoaP/4XjUc4HxN87oT21tnctj9RsRD46sihdG6KafkyxTvB2TPln9vQi73O4mfgOMeLljI/1F62tcvmK0BlR6mtjoikh44Le32wTBZ+lZYGRkJkoacWnZpWNLj3ceto1+qK+NqOJewZcI+rY4JisIOCo1616M40oWDxES7FiMYAbczvKPmzNZ4/hCr3jXHSFLrmY0EX1SYDNj6wjurRS1gzznvolFcPV5Ctnfz8ozFap4USehLjA4tjXcPtEpbaf6+o/zmRswM0YSh
 Jv+ygnkB
 9xrMV/ANbTMQmnJt3ha+ZKeoEBS9tTKOXZIdVm+VbU74KJ6IoHyUAPc1wHMZ8+GsmnGK1HCys/pFURTwjB13ogTbeH1oMuz3B2ktEFeTScjLI2p39HSNAe/HkJUCMgVsFOTU0XSAiqsVfyIKBflE7D5SV/oVSJWU0tRX9+QNlM1vtGv43vuASX96tRLBuHYLIegN2JLLEhgMihOB5AXDxaBijrufht9oz0Rhowj3ZasyOpoOBSTcg/B6AsPpidNtDeCAoWywb3llj2Uf3YruDesA8L8btDuS38eVhYkIAPcH7yQomtZoBGthCl7raTicfwxGFNX7LauyEuVXdpQ5RHDG28iaHR9JxeGScGopSkmpH/xCsLkI/1P+9LpXywTLgdoDYB45Ys/6s3YqjH3I24QbzBiHRLalULE5O5Pmgp3ezG6WWUg9NCTLUEyOAvO2sI7miRketlAzBVDFyz3yLvcwWwREAL3FRenITppSMJE1DCBA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nhat Pham <nphamcs@gmail.com>

The SWAP_MAP_SHMEM state was introduced in the commit aaa468653b4a
("swap_info: note SWAP_MAP_SHMEM"), to quickly determine if a swap entry
belongs to shmem during swapoff.

However, swapoff has since been rewritten in the commit b56a2d8af914
("mm: rid swapoff of quadratic complexity"). Now having swap count ==
SWAP_MAP_SHMEM value is basically the same as having swap count == 1,
and swap_shmem_alloc() behaves analogously to swap_duplicate(). The only
difference of note is that swap_shmem_alloc() does not check for
-ENOMEM returned from __swap_duplicate(), but it is OK because shmem
never re-duplicates any swap entry it owns. This will stil be safe if we
use (batched) swap_duplicate() instead.

This commit adds swap_duplicate_nr(), the batched variant of
swap_duplicate(), and removes the SWAP_MAP_SHMEM state and the
associated swap_shmem_alloc() helper to simplify the state machine (both
mentally and in terms of actual code). We will also have an extra
state/special value that can be repurposed (for swap entries that never
gets re-duplicated).

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h | 15 +++++++--------
 mm/shmem.c           |  2 +-
 mm/swapfile.c        | 42 +++++++++++++++++-------------------------
 3 files changed, 25 insertions(+), 34 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 38ca3df68716..bf72b548a96d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -230,7 +230,6 @@ enum {
 /* Special value in first swap_map */
 #define SWAP_MAP_MAX	0x3e	/* Max count */
 #define SWAP_MAP_BAD	0x3f	/* Note page is bad */
-#define SWAP_MAP_SHMEM	0xbf	/* Owned by shmem/tmpfs */
 
 /* Special value in each swap_map continuation */
 #define SWAP_CONT_MAX	0x7f	/* Max count */
@@ -458,8 +457,7 @@ bool folio_free_swap(struct folio *folio);
 void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
-extern void swap_shmem_alloc(swp_entry_t, int);
-extern int swap_duplicate(swp_entry_t);
+extern int swap_duplicate_nr(swp_entry_t entry, int nr);
 extern int swapcache_prepare(swp_entry_t entry, int nr);
 extern void swap_free_nr(swp_entry_t entry, int nr_pages);
 extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
@@ -514,11 +512,7 @@ static inline int add_swap_count_continuation(swp_entry_t swp, gfp_t gfp_mask)
 	return 0;
 }
 
-static inline void swap_shmem_alloc(swp_entry_t swp, int nr)
-{
-}
-
-static inline int swap_duplicate(swp_entry_t swp)
+static inline int swap_duplicate_nr(swp_entry_t swp, int nr_pages)
 {
 	return 0;
 }
@@ -569,6 +563,11 @@ static inline int add_swap_extent(struct swap_info_struct *sis,
 }
 #endif /* CONFIG_SWAP */
 
+static inline int swap_duplicate(swp_entry_t entry)
+{
+	return swap_duplicate_nr(entry, 1);
+}
+
 static inline void free_swap_and_cache(swp_entry_t entry)
 {
 	free_swap_and_cache_nr(entry, 1);
diff --git a/mm/shmem.c b/mm/shmem.c
index d08248fd67ff..eb9bd9241f99 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1654,7 +1654,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
-		swap_shmem_alloc(folio->swap, nr_pages);
+		swap_duplicate_nr(folio->swap, nr_pages);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3762b8f3f9e9..e23287c06f1c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -201,7 +201,7 @@ static bool swap_is_last_map(struct swap_info_struct *si,
 	unsigned char *map_end = map + nr_pages;
 	unsigned char count = *map;
 
-	if (swap_count(count) != 1 && swap_count(count) != SWAP_MAP_SHMEM)
+	if (swap_count(count) != 1)
 		return false;
 
 	while (++map < map_end) {
@@ -1523,12 +1523,6 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
 	if (usage == SWAP_HAS_CACHE) {
 		VM_BUG_ON(!has_cache);
 		has_cache = 0;
-	} else if (count == SWAP_MAP_SHMEM) {
-		/*
-		 * Or we could insist on shmem.c using a special
-		 * swap_shmem_free() and free_shmem_swap_and_cache()...
-		 */
-		count = 0;
 	} else if ((count & ~COUNT_CONTINUED) <= SWAP_MAP_MAX) {
 		if (count == COUNT_CONTINUED) {
 			if (swap_count_continued(si, offset, count))
@@ -1626,7 +1620,7 @@ static bool swap_entries_put_map(struct swap_info_struct *si,
 	if (nr <= 1)
 		goto fallback;
 	count = swap_count(data_race(si->swap_map[offset]));
-	if (count != 1 && count != SWAP_MAP_SHMEM)
+	if (count != 1)
 		goto fallback;
 
 	ci = swap_cluster_lock(si, offset);
@@ -1680,12 +1674,10 @@ static bool swap_entries_put_map_nr(struct swap_info_struct *si,
 
 /*
  * Check if it's the last ref of swap entry in the freeing path.
- * Qualified value includes 1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM.
  */
 static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
 {
-	return (count == SWAP_HAS_CACHE) || (count == 1) ||
-	       (count == SWAP_MAP_SHMEM);
+	return (count == SWAP_HAS_CACHE) || (count == 1);
 }
 
 /*
@@ -3678,7 +3670,6 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 
 	offset = swp_offset(entry);
 	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
-	VM_WARN_ON(usage == 1 && nr > 1);
 	ci = swap_cluster_lock(si, offset);
 
 	err = 0;
@@ -3738,27 +3729,28 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 	return err;
 }
 
-/*
- * Help swapoff by noting that swap entry belongs to shmem/tmpfs
- * (in which case its reference count is never incremented).
- */
-void swap_shmem_alloc(swp_entry_t entry, int nr)
-{
-	__swap_duplicate(entry, SWAP_MAP_SHMEM, nr);
-}
-
-/*
- * Increase reference count of swap entry by 1.
+/**
+ * swap_duplicate_nr() - Increase reference count of nr contiguous swap entries
+ *                       by 1.
+ *
+ * @entry: first swap entry from which we want to increase the refcount.
+ * @nr: Number of entries in range.
+ *
  * Returns 0 for success, or -ENOMEM if a swap_count_continuation is required
  * but could not be atomically allocated.  Returns 0, just as if it succeeded,
  * if __swap_duplicate() fails for another reason (-EINVAL or -ENOENT), which
  * might occur if a page table entry has got corrupted.
+ *
+ * Note that we are currently not handling the case where nr > 1 and we need to
+ * add swap count continuation. This is OK, because no such user exists - shmem
+ * is the only user that can pass nr > 1, and it never re-duplicates any swap
+ * entry it owns.
  */
-int swap_duplicate(swp_entry_t entry)
+int swap_duplicate_nr(swp_entry_t entry, int nr)
 {
 	int err = 0;
 
-	while (!err && __swap_duplicate(entry, 1, 1) == -ENOMEM)
+	while (!err && __swap_duplicate(entry, 1, nr) == -ENOMEM)
 		err = add_swap_count_continuation(entry, GFP_ATOMIC);
 	return err;
 }

-- 
2.52.0


