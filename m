Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E911CFD348
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB50C6B0089; Mon, 24 Nov 2025 14:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65D06B008A; Mon, 24 Nov 2025 14:16:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C206B008C; Mon, 24 Nov 2025 14:16:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A54486B0089
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:16:20 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52C371A04E3
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:20 +0000 (UTC)
X-FDA: 84146456520.08.2677128
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 45239180008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="S/5nmwu3";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011778; a=rsa-sha256;
	cv=none;
	b=Kym1fJDkbSa/11jyGwAcskrgJ9jcYW+mZAOw+1/49m+dUYOE490krGbh5NdBwIUMzQo6q0
	a+sfdNSFvqOUJ2Ja7RkiEndp+jSubbVWU+NEXbsu/NPKW/KqH0AuymX4LxMJfQS+OlotGP
	+JlSAZe+gJDVuYQ5G7zf1D3Wt5oUbgQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="S/5nmwu3";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GpNi8FjhSIttEAU4/SYztJU0s3eplrF9RCrsYzGaLWo=;
	b=uk3Dlm4m6pDoGhNe0Cn+zdqkYu0ag3AZjC6ctAbuWBXN3eyyDS2it2SsDKBIQ7nZXcWjg6
	uXFjqkxq37mkUMdywKYb2NzI5/2zFSkeSl92sgg8d0lEeVm3omMIY5FGxu335E+uX38wr9
	XwdchhJLMtyZFXtG8G3TKey3+apGJXc=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so5568054b3a.2
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011777; x=1764616577; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GpNi8FjhSIttEAU4/SYztJU0s3eplrF9RCrsYzGaLWo=;
        b=S/5nmwu3wiw+iziomfemnDeeTk75z1Sxe57MU53HGoH1miOggzTXW6VuNBQcuekI3l
         5gePICwjMEV8y0+fc5aezCyPMWUFCMjOAp+pH+FSVbcwejoM4vkj7QgSnhWBA8ISK01y
         LRmJhqS3sK9DOXI4/6Jpn9dc2LK1ElBM3JHzB/Za+6gGGBiuGsUvZ7ha5rO/twl9Dgrl
         P7rgp4LP5PVv6xKMdthWi1WJI9smhah/JRyMFom5a23CYY3VMo6tvhnsNbWHHigDuE1o
         O2mcXgu0JGvyRVqO3aVIwEdC5UuMN3UGa7U+POoKzBkQ+/JCJp9q0ggKpU3/3k0YJLqW
         rloA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011777; x=1764616577;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GpNi8FjhSIttEAU4/SYztJU0s3eplrF9RCrsYzGaLWo=;
        b=EKWALshiL6xcpfodlENJXCOW6DVlnDrtCD/srgZUidfuQqtQPtYIV18A2mpM01eME6
         7vuGK+6Ook+c4kLwJbgSMLEIJAU0/6q0sn/U2IliCLKwq5B6VqfpO0oBDoNZ6MNV176C
         KPukBp1BNE91z+YM0ncqcRWnbhxdWox0eUPjEIoGiQJv+ErEQWrtJQiVM+gfAbyhoRT/
         rPCbYxuktjemDfqnFpaaL3rva8+P4JjHFIN5DXw9ixhvMu+ia98ajYgbzjn1xGbKu8EW
         Ncpk2PELeTQtopTuyUHzf7tt7a3r/r8Ei6hSK/f+C9/rezplVfmX6UqTkTGmFTtFDSOw
         tFWg==
X-Gm-Message-State: AOJu0YwgemCIKCdIJZ821S6pZveRIDUDRUNmpNgvI53RKJZFjyeYt1Wt
	Yq2DhL/AHyOAD8xXuOnDjHvnVf+xJ8ELByi+0/mGRgvWSWwjFu0bFC9B
X-Gm-Gg: ASbGncs9twvwewDbxrKXZd5iLOT31+Y/9e1WoasSFDCt9JB3B2uZjPfgvsPwuKKwwRN
	hJiaUfir7R2S85xdhMXUQOS8lfczPT44bYESl5ZcNTpTQZ93f8Dt63ViDXOIMSjLhXZhxEUu+kY
	fuvIXFeqygBR1VoyIRRjYaQ22zmb5wrnv+LZ2u/HW+9uuptlGX8ukTm6F4jwRMr4zATwaSqFsrd
	lu05qDIEa0+TXWSA2Ev8Wi7i2Cm2nPtGiGrqhIkzYlkefhOFUg9+rnbtC+r1nudNbN5fJjRDwYb
	9bp/I93fXYH8hVFFz/cnScL7HaZ+OaXt0SwhLP8LfiKBSjV9Ul27eiK3ucsFuUIpF100gs9kPEw
	DN8MqcrTH/zJyepK+IzazTO44Q6SNUmWkgLnaWzYwCTIOdP/EBD7yBtdJFYvKfqUeEAAOnzQaBH
	SgbnG5vD0s3mrkB5TRS2swTK8jLMS7bQe2M3j6tugGO3q4vvXxsnkNhoakNIM=
X-Google-Smtp-Source: AGHT+IECvy8wsfwYygzgHpvNBsk6OsB2Az3ifuap9gn5TViDmzLyWX3HaNQQ51t3DUydcesHNZXR3Q==
X-Received: by 2002:a05:6a21:6d96:b0:334:a784:3046 with SMTP id adf61e73a8af0-3614ed971e2mr14909542637.38.1764011777067;
        Mon, 24 Nov 2025 11:16:17 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:16:16 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:13:51 +0800
Subject: [PATCH v3 08/19] mm/shmem, swap: remove SWAP_MAP_SHMEM
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-8-33f54f707a5c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=7126;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=mVLrWCcOCF2opEwIpHmoO8gRgwudRDdzZKps7g3enEw=;
 b=gjX6UZ//yplqGvwKWzYk0/CGzU4i15dfWYfnqKLpnNStNKAwg1KK+h+8qq0JEo/rh7L7WJgEM
 ZE9ktkILD3nDsYG5yQ0QDKAumJbGDDjOdE35IHicpm9T9e0+t2jBweo
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: 45239180008
X-Rspamd-Server: rspam07
X-Stat-Signature: x38kbdzbqdaozmzzn3ucbtwf94x8qnyr
X-Rspam-User: 
X-HE-Tag: 1764011778-681728
X-HE-Meta: U2FsdGVkX1+KeUM6hI3GL17kusMr8GxFpnvEV/f2lvA5xKAIimBUuiufXkPKdhXPvltuli0uomtm1dEWAG31/nJNHMBMRhx0VpKwYLyXUeP1vdy1b8GvjMNZSuZPrqFz1WW5sV5fI4soAQCfkd2jTLTD8L4sklNE7R1JWlD7bL4GUih1gnKhcGRwYobk+r/ZBm4SysJjrZNOetTLDQRROebPbto0a0yV1Kqj6KjCBBEtpUa3UyMKzrGQxX2HulDzT2ugtUWW0pqy6O6+Ccp+VgPJk7r6pK+G2EKNsJiOsyS5iVJejWZwbtyUnAM60nOQZzH5PjH28kdfpLiJ4LCQCsXPd3RVMvfOc7dwz4ebnvE+G5KyPPCV+33Tbo73ECWaFVBdk6GYSJCkPpFzF2A+z4sVP9ReE5IWlr8/koUdZ53aZe+7ukYxglCXacv5kFz3eDOobwN4i0RW1wk4FPQrhASBTKZ76VMmrzQNngzZx8HBqVS52XBBqUSxLYE6ATYILqwyEIij6sDefN5JK+FDsS+hCgJqlNn2wcN6lIcqk1iw57oOnfWA0npDR/WsWcOGcRcr6Njm/5ei9WmgAih+V2mZ8rZsM/ODRmKKzbi9x7KF/L/p5SiTLELaD7+5dibgJbJT83cmld+lvMzxls0jJippY34Zjkay0bzBwO0cS/y/S2lN1w3Zfg4QC0c3uPjwU89Uo0hzP/ggjEiOVm3tiLswi4JS5CTZR1TecIHtn/LAmSXXWdkZSDWscd/rA5FBS06/FA2cbm51Kd4XBg5KSnaGhUuGw+MpgLSocN2WKKLOIEbX/t66nL2JLOzu3GJjAzq8Th5rzuJzsdG32bgfc9PiWwX+CCpseAtLzvqMFKhSl5pCYOuS1dCzNkhs77czTcVPhESfSMItxNkxS6gmbniuEOoYehNI5CaMsVeLRMiREeSZhD4EzLpeJutB29p20cXGeaoPU0lKe1czI0V
 qjPp2Kzb
 5sw67f9suc2FrLoTjOJwYjx2RQ1zkKaRjjwb0T+7YiCuOwsb1SafjwXyK2f2TtqpJwxak4oPdsvWr807zrFg0FGdQFTt6w6N7TDbGcAijF/k8F2qIbyuhYYSuDm84ah85uCjNhiYkeCQZ1T7RAhs4VsR/ujPWS5kW3krD+494a+oSFkLL6yoY0cI2BbnPp30IYeNYUBnwzWj8hjbLJv8+vlVAjeEn8GuABNbqgvAZLFnc08zsKG199sB+sMsz1hvcucHWEPdxPh4wmpWBvKWbH8Gn7P8g+my6p/5almNALQYy7k62rRDX5pD3LKvUBKjNFgOBNtclDVqN3x+HHljulhAp+TCjO72MiVDTCfFgkKxd/ETsAtPzwkPmUHeqRbtHC2yy5zL9FIPGeCPaHvSi+/8Ho4A4URAkWII4/3dQTSCmw4xh9IYnFczg0sI4iQatn88/dRPnvDDt0ylU4t4LiIVN2g==
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
index 5853db044031..cc07246985ef 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -201,7 +201,7 @@ static bool swap_is_last_map(struct swap_info_struct *si,
 	unsigned char *map_end = map + nr_pages;
 	unsigned char count = *map;
 
-	if (swap_count(count) != 1 && swap_count(count) != SWAP_MAP_SHMEM)
+	if (swap_count(count) != 1)
 		return false;
 
 	while (++map < map_end) {
@@ -1519,12 +1519,6 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
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
@@ -1622,7 +1616,7 @@ static bool swap_entries_put_map(struct swap_info_struct *si,
 	if (nr <= 1)
 		goto fallback;
 	count = swap_count(data_race(si->swap_map[offset]));
-	if (count != 1 && count != SWAP_MAP_SHMEM)
+	if (count != 1)
 		goto fallback;
 
 	ci = swap_cluster_lock(si, offset);
@@ -1676,12 +1670,10 @@ static bool swap_entries_put_map_nr(struct swap_info_struct *si,
 
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
@@ -3674,7 +3666,6 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 
 	offset = swp_offset(entry);
 	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
-	VM_WARN_ON(usage == 1 && nr > 1);
 	ci = swap_cluster_lock(si, offset);
 
 	err = 0;
@@ -3734,27 +3725,28 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
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


