Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A735CD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDF7B6B0005; Sun, 16 Nov 2025 13:13:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90686B0006; Sun, 16 Nov 2025 13:13:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6736B0007; Sun, 16 Nov 2025 13:13:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 944E96B0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:13:54 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DC161A0A1B
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:54 +0000 (UTC)
X-FDA: 84117268788.01.6088A6A
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5A56D1C000D
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SyYa6u5y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316832; a=rsa-sha256;
	cv=none;
	b=1InkSyumunlBWyP1FEmm5nd3QVP5kyKlEVqHpteGoUfSyjtznZncPOTxREiGZSVesT7wuu
	nBczSpY4s0VblFPDqeyLWSFovHOLI55GDFmsBM9hMYnxvA+cV2RcLh76gi6qW0rmDxnZm9
	/rkDTey6r97QNDR1+nz2y16n9pbnC6w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SyYa6u5y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GaFRH+LZgfAFTVz1MTsYDXFly3Drs3VCN5bJgnDxjts=;
	b=MQrJ5RVRq57iLBl3AxLMvvIIbK5j1i++evpDXePdxvZWP2CY+Ziaad2mFJsBFheMKzM3De
	vnQd0y3pHjOqRkht4Xb4sJQtbPPIG7zC8ym1ExqYJEc8Jlh5R3plrNST6T4XepDg1HTeRw
	rfGjjIH7y/ezeUZGIffFvyNoG9tK66E=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b2d7c38352so138210785a.0
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316831; x=1763921631; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GaFRH+LZgfAFTVz1MTsYDXFly3Drs3VCN5bJgnDxjts=;
        b=SyYa6u5y09rhPbkjetgcI/lUSXzsdY8qaGOxC+4JO4i7RPNWebzqHyaewv5Y4khkNr
         sQf3enSaOlGpJoo4YB7Uu8JcgrxEFiJgGCzaAzDCMsZyLfjo8FwhO6IoyHyLiYQxyP+F
         +H8S04UJL00bj0Nu8CPy0tq3z37DIEYuz6ghxT0+iW1beiVgJCMPpkNuWdrzTqHvuSta
         I+GhwrzsJBUZZWcRNio7MRtyvngui2XkU4izbqmo28B5sIWjbI72AyFFr0Lkhv6ZshGC
         8CcI6EYg3EmPOqYqaDLdPor4UfBNPfXc8aKLDDZpryt/RFIkLL6oYStvbYCJkvn83sbT
         yLuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316831; x=1763921631;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GaFRH+LZgfAFTVz1MTsYDXFly3Drs3VCN5bJgnDxjts=;
        b=DGImUGtHwCFAZuZvHK3JUZSpQNrqtegyH1NXWjOsfluAB/5ppvpekEVrqX6r6Iqxx4
         PS8eVFy3tnDvDiJ7KR1Bfkh0g6LE9OqoFj3Xv3YVQ3wWD8vY2dgUmBxl+IiyKeb7U5aF
         R6EUFU39SHyImCzpvkBVsFuNRxdh5mHMM5uEtMHD766YX7UOfSriO4htIlDR8C1RrZWI
         eGQBbai7Owy9V84KYdEfyunBgrM34Vw5La7jPjDgLy70J1TZkdR8Mk15TFJhwweQDiRC
         SocsIDEC0s32lD5/o3Sdhyfycr7uYSdMvw7mIZQKcZqPWqL5I8V+/g7KTWwfVMylFoo5
         w97A==
X-Gm-Message-State: AOJu0YxKD67LKFPSbndJUF5FcS4zy31igA4LqLTMnwcJ/Ju+41CLxG4d
	rbId2MrjfAu/YcsJDs6GYyeqZaI93+VrKUEYYVCbaTsL14gykEhHfoL2
X-Gm-Gg: ASbGncssbY/rfABAFLFVf+aE9i9Q7SUwjalwDnSOKc2p5f5pX5j8ghcGMqHpscP0mT5
	reKl16LFx3E4Q2Mo0I29oHtQiWHpbZ4hApR10G38aRBQ6m3yLCx2ygkPJgoOLbjQQYkzHCO08cr
	GaIlBNHmTdX6bk6zsiKkSNdGacJFhPbmHJckWGEMNxmcYds4qjMnjbLFz1+h2ydtmfVkrpL1Gnp
	43RqazwoG2ft6c1FbBCcAn+i5JreKha+R7Bj7VxP2s1+vkKBXezaIZsQzyhTWhVBA5QcOMwjcwN
	rNo+1e1AaOWOdNmNSVhkIl4ruGJ5PKMDKMIrHlZX6oKWN0X5m23VWnwDlK1j+11gLaRqID3xa7a
	uNLNCLRsSilwwXp4QxEPeOvJKxo1Xtkb1gcxJZ9e7pAbPh1GRlG1psxbGdHllDHvVkA+GS4B+jf
	fK8wDqWzRb9EwpTu1VNDryZUJMIrelzsA9xZhiKHdDGw==
X-Google-Smtp-Source: AGHT+IF3Gl5RfTq1Dv9hBTvVfebDOvdvRj8TOBQUPvUtQu/3GgvLvXaywo2NFqYrhBlzy3T9W+La9g==
X-Received: by 2002:a05:620a:190f:b0:8b2:ea5a:414e with SMTP id af79cd13be357-8b2ea5a4434mr225284985a.15.1763316831313;
        Sun, 16 Nov 2025 10:13:51 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:13:50 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:59 +0800
Subject: [PATCH v2 18/19] mm, swap: drop the SWAP_HAS_CACHE flag
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-18-37730e6ea6d5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=19468;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=N4sVFNXUYYa37ImpeXCCWFDyNvi8beCR4LF0FZ2HaC0=;
 b=537wCrta7hlbAppABfx0CVbKYR2tBPnc+zHbnUNQ0WArvJyXmX33g+GlGOO/nOSHGkgux8fe6
 18TeWa3WK5iDIuKmTMqbPjhANxPtAYbWLNciyVmeTRDD2M/snjyeX+U
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: 5A56D1C000D
X-Rspamd-Server: rspam07
X-Stat-Signature: qhibsuch888xd84qnwmrqecus3ktuxq6
X-Rspam-User: 
X-HE-Tag: 1763316832-360568
X-HE-Meta: U2FsdGVkX19R9dXfenGpEpD2Lbsh40xZTrVgYyzVSgcYxL14a88maH1V5tc/ytQ7fwSSuyj9D/IiCj01mNaGBKCo0mbPsl2zyf1QNIqZfqR/AyZ7JQolFb5yA+Ilb3b96V9hJfSLGaeqLD6WYKLM7DN273TapciN0v9SVNd7AlxzjtwmRwPRU82WKHFgtXsXxpm+hqHFIY3n40sfjstSViCYvXjY68dlR9T2hsYk/xOW9lcwdNKfmqWUJ/yWD49EF/oaQqvkxXSyW20ZxloSgyH+/gT/48tH7rXP0VP6hrfBAEGw0JI/cuqULFoiv8+kKRPApRj60mRFr+mW4mQlUUDrkvfkVMSDZQN+Y4MQpOtkBqA/JgHj/NiNVbKzAI89sn/PKyrRqoWYyftwOawXBcUztBOyW1iE8oPhDtg8O0N8BhO+zWKsOIHQZrHLjDxR+K8MfBWRcQw2reMUij2l2YGsvATQA68Mln8eXpbuArarQRKJzdQAYt5GRQyHGIWTdLFoIuMbDXkmkfWk9e2s3LW2KswncC0lWRbP4a4GqR9NveRqhoZAbCxKdf0R2ncHBFVJUzsAVaAiZUOMBA/G0HTI8tB5ZIAFpZ0cnTeqwqXU9F32Yr2m06nmOWqSwDq+mYJ5caH6uq7zOTFpaHuFlexsqdk6qSSxCWokZJH6f7a4hQZfFRO2Ln+CtC2XopmGIDqhdNe/GsDzE5WqsDJ4psEHH3zHFPtQNrTT6NdRIDCtaq7H8IcH+ILWX/Vy4ZnA95rQCuYiIh5KNGo11BHdn+uZ28+tBrIfTv9Eh4Gz5gCcntwXUlwhTLgKERVzQVD/Mw2auQkK4CHVzsk+A/K5nSuQTBfnVq/2JyUYpciAreV/k8/A04oiSpXWZ2i98bWUloE+ZGS1QJ1c6vAzqbQbHtCtQvevtwML4o8eOBD0G74+kKdOjtDR/DQ3hP5Rm33l875GqYT4peAM4Yiejab
 ZmsQIl6V
 oGenvuOF8GlqwaRMbzDXuDjVCHdaP7d40h5kXCFJESFk9PdKp6dlG58w8sOFv5cBbdaCmzyK6+JP1Bga3W5ua7wHgyXZYcCMCU4wQNaDQQjYAZzPJEGmG0AGX7eKQAMumLhDdoqdIyZD8CwoVItXET5/Oh0kX5hihIfntlRO2sAbT6jBK7lvxeHz5DgyjrdDmAJftjTYW37Tyi921Drw4QC4yAuw+7zsVTUPaRdIpKfaai7rmHhlhT6U/mk2qYXO1N+QN4Fun9XMl5BnYZOsttVH5Z7RJSm6J4E75OfcaTJsc1wtRVKjKdN9q0Fa5WTZ0dS/GMnDbL5GOno/qjXCCagZ1JG6XkY9IAnLDB5beRVmN8ZXgcADXMNxNdKmVZLhfwPV+J51klbe7Mo8clhbfGgRtJnlo1t3/Yl93ORst7cNDDLGRvpLAbFKTdVbo+hNl9crav+PziKjVyWq/3wDysWadgezT6rthCb0NeXdaGeSsporS3ZPZyOJmYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now, the swap cache is managed by the swap table. All swap cache users
are checking the swap table directly to check the swap cache state.
SWAP_HAS_CACHE is now just a temporary pin before the first increase
from 0 to 1 of a slot's swap count (swap_dup_entries), or before the
final free of slots pinned by folio in swap cache (put_swap_folio).

Drop these two usages. For the first dup, SWAP_HAS_CACHE pinning was
hard to kill because it used to have multiple meanings, more than just
"a slot is cached". We have simplified that and just defined that the
first dup is always done with folio locked in swap cache (folio_dup_swap),
so it can just check the swap cache (swap table) directly.

As for freeing, just let the swap cache free all swap entries of a folio
that have a swap count of zero directly upon folio removal. We have also
just cleaned up freeing to cover the swap cache usage in the swap table,
a slot with swap cache will not be freed until its cache is gone.
Now, making the removal of a folio and freeing the slots being done in
the same critical section, this should improve the performance and gets
rid of the SWAP_HAS_CACHE pin.

After these two changes, SWAP_HAS_CACHE no longer has any users. Remove
all related logic and helpers. swap_map is now only used for tracking
the count, so all swap_map users can just need to read it directly,
ignoring the swap_count helper, which was previously used to filter out
the SWAP_HAS_CACHE bit.

The idea of dropping SWAP_HAS_CACHE and using the swap table directly
was initially from Chris's idea of merging all the metadata usage of all
swaps into one place.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |   1 -
 mm/swap.h            |  13 ++--
 mm/swap_state.c      |  28 +++++----
 mm/swapfile.c        | 163 ++++++++++++++++-----------------------------------
 4 files changed, 71 insertions(+), 134 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4b4b81fbc6a3..dcb1760e36c3 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -224,7 +224,6 @@ enum {
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
 /* Bit flag in swap_map */
-#define SWAP_HAS_CACHE	0x40	/* Flag page is cached, in first swap_map */
 #define COUNT_CONTINUED	0x80	/* Flag swap_map continuation for full count */
 
 /* Special value in first swap_map */
diff --git a/mm/swap.h b/mm/swap.h
index 3692e143eeba..b2d83e661132 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -205,6 +205,11 @@ int folio_alloc_swap(struct folio *folio);
 int folio_dup_swap(struct folio *folio, struct page *subpage);
 void folio_put_swap(struct folio *folio, struct page *subpage);
 
+/* For internal use */
+extern void swap_entries_free(struct swap_info_struct *si,
+			      struct swap_cluster_info *ci,
+			      unsigned long offset, unsigned int nr_pages);
+
 /* linux/mm/page_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
@@ -256,14 +261,6 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
 	return folio_entry.val == round_down(entry.val, nr_pages);
 }
 
-/* Temporary internal helpers */
-void __swapcache_set_cached(struct swap_info_struct *si,
-			    struct swap_cluster_info *ci,
-			    swp_entry_t entry);
-void __swapcache_clear_cached(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      swp_entry_t entry, unsigned int nr);
-
 /*
  * All swap cache helpers below require the caller to ensure the swap entries
  * used are valid and stablize the device by any of the following ways:
diff --git a/mm/swap_state.c b/mm/swap_state.c
index e9ae7c09c2bf..d0625f59726e 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -213,17 +213,6 @@ static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 			shadow = swp_tb_to_shadow(old_tb);
 		offset++;
 	} while (++ci_off < ci_end);
-
-	ci_off = ci_start;
-	offset = swp_offset(entry);
-	do {
-		/*
-		 * Still need to pin the slots with SWAP_HAS_CACHE since
-		 * swap allocator depends on that.
-		 */
-		__swapcache_set_cached(si, ci, swp_entry(swp_type(entry), offset));
-		offset++;
-	} while (++ci_off < ci_end);
 	__swap_cache_add_folio(ci, folio, entry);
 	swap_cluster_unlock(ci);
 	if (shadowp)
@@ -254,6 +243,7 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 	struct swap_info_struct *si;
 	unsigned long old_tb, new_tb;
 	unsigned int ci_start, ci_off, ci_end;
+	bool folio_swapped = false, need_free = false;
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	VM_WARN_ON_ONCE(__swap_entry_to_cluster(entry) != ci);
@@ -271,13 +261,27 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 		old_tb = __swap_table_xchg(ci, ci_off, new_tb);
 		WARN_ON_ONCE(!swp_tb_is_folio(old_tb) ||
 			     swp_tb_to_folio(old_tb) != folio);
+		if (__swap_count(swp_entry(si->type,
+				 swp_offset(entry) + ci_off - ci_start)))
+			folio_swapped = true;
+		else
+			need_free = true;
 	} while (++ci_off < ci_end);
 
 	folio->swap.val = 0;
 	folio_clear_swapcache(folio);
 	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
-	__swapcache_clear_cached(si, ci, entry, nr_pages);
+
+	if (!folio_swapped) {
+		swap_entries_free(si, ci, swp_offset(entry), nr_pages);
+	} else if (need_free) {
+		do {
+			if (!__swap_count(entry))
+				swap_entries_free(si, ci, swp_offset(entry), 1);
+			entry.val++;
+		} while (--nr_pages);
+	}
 }
 
 /**
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f98529f5c209..1bb568728b85 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -48,21 +48,18 @@
 #include <linux/swap_cgroup.h>
 #include "swap_table.h"
 #include "internal.h"
+#include "swap_table.h"
 #include "swap.h"
 
 static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
 				 unsigned char);
 static void free_swap_count_continuations(struct swap_info_struct *);
-static void swap_entries_free(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      unsigned long start, unsigned int nr_pages);
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr);
 static void swap_put_entry_locked(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
-				  unsigned long offset,
-				  unsigned char usage);
+				  unsigned long offset);
 static bool folio_swapcache_freeable(struct folio *folio);
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
@@ -149,11 +146,6 @@ static struct swap_info_struct *swap_entry_to_info(swp_entry_t entry)
 	return swap_type_to_info(swp_type(entry));
 }
 
-static inline unsigned char swap_count(unsigned char ent)
-{
-	return ent & ~SWAP_HAS_CACHE;	/* may include COUNT_CONTINUED flag */
-}
-
 /*
  * Use the second highest bit of inuse_pages counter as the indicator
  * if one swap device is on the available plist, so the atomic can
@@ -185,15 +177,20 @@ static long swap_usage_in_pages(struct swap_info_struct *si)
 #define TTRS_FULL		0x4
 
 static bool swap_only_has_cache(struct swap_info_struct *si,
-			      unsigned long offset, int nr_pages)
+				struct swap_cluster_info *ci,
+				unsigned long offset, int nr_pages)
 {
+	unsigned int ci_off = offset % SWAPFILE_CLUSTER;
 	unsigned char *map = si->swap_map + offset;
 	unsigned char *map_end = map + nr_pages;
+	unsigned long swp_tb;
 
 	do {
-		VM_BUG_ON(!(*map & SWAP_HAS_CACHE));
-		if (*map != SWAP_HAS_CACHE)
+		swp_tb = __swap_table_get(ci, ci_off);
+		VM_WARN_ON_ONCE(!swp_tb_is_folio(swp_tb));
+		if (*map)
 			return false;
+		++ci_off;
 	} while (++map < map_end);
 
 	return true;
@@ -254,7 +251,7 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	 * reference or pending writeback, and can't be allocated to others.
 	 */
 	ci = swap_cluster_lock(si, offset);
-	need_reclaim = swap_only_has_cache(si, offset, nr_pages);
+	need_reclaim = swap_only_has_cache(si, ci, offset, nr_pages);
 	swap_cluster_unlock(ci);
 	if (!need_reclaim)
 		goto out_unlock;
@@ -775,7 +772,7 @@ static unsigned int cluster_reclaim_range(struct swap_info_struct *si,
 
 	spin_unlock(&ci->lock);
 	do {
-		if (swap_count(READ_ONCE(map[offset])))
+		if (READ_ONCE(map[offset]))
 			break;
 		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
 		if (swp_tb_is_folio(swp_tb)) {
@@ -800,7 +797,7 @@ static unsigned int cluster_reclaim_range(struct swap_info_struct *si,
 	 */
 	for (offset = start; offset < end; offset++) {
 		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
-		if (swap_count(map[offset]) || !swp_tb_is_null(swp_tb))
+		if (map[offset] || !swp_tb_is_null(swp_tb))
 			return SWAP_ENTRY_INVALID;
 	}
 
@@ -820,11 +817,10 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 		return true;
 
 	do {
-		if (swap_count(map[offset]))
+		if (map[offset])
 			return false;
 		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
 		if (swp_tb_is_folio(swp_tb)) {
-			WARN_ON_ONCE(!(map[offset] & SWAP_HAS_CACHE));
 			if (!vm_swap_full())
 				return false;
 			*need_reclaim = true;
@@ -882,11 +878,6 @@ static bool cluster_alloc_range(struct swap_info_struct *si,
 	if (likely(folio)) {
 		order = folio_order(folio);
 		nr_pages = 1 << order;
-		/*
-		 * Pin the slot with SWAP_HAS_CACHE to satisfy swap_dup_entries.
-		 * This is the legacy allocation behavior, will drop it very soon.
-		 */
-		memset(si->swap_map + offset, SWAP_HAS_CACHE, nr_pages);
 		__swap_cache_add_folio(ci, folio, swp_entry(si->type, offset));
 	} else {
 		order = 0;
@@ -997,8 +988,8 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		to_scan--;
 
 		while (offset < end) {
-			if (!swap_count(READ_ONCE(map[offset])) &&
-			    swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER))) {
+			if (!READ_ONCE(map[offset]) &&
+			    swp_tb_is_folio(swap_table_get(ci, offset % SWAPFILE_CLUSTER))) {
 				spin_unlock(&ci->lock);
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
 								   TTRS_ANYWAY);
@@ -1432,8 +1423,8 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 	do {
 		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
 		count = si->swap_map[offset];
-		VM_WARN_ON(swap_count(count) < 1 || count == SWAP_MAP_BAD);
-		if (swap_count(count) == 1) {
+		VM_WARN_ON(count < 1 || count == SWAP_MAP_BAD);
+		if (count == 1) {
 			/* count == 1 and non-cached slots will be batch freed. */
 			if (!swp_tb_is_folio(swp_tb)) {
 				if (!batch_start)
@@ -1441,7 +1432,6 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 				continue;
 			}
 			/* count will be 0 after put, slot can be reclaimed */
-			VM_WARN_ON(!(count & SWAP_HAS_CACHE));
 			need_reclaim = true;
 		}
 		/*
@@ -1450,7 +1440,7 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 		 * slots will be freed when folio is removed from swap cache
 		 * (__swap_cache_del_folio).
 		 */
-		swap_put_entry_locked(si, ci, offset, 1);
+		swap_put_entry_locked(si, ci, offset);
 		if (batch_start) {
 			swap_entries_free(si, ci, batch_start, offset - batch_start);
 			batch_start = SWAP_ENTRY_INVALID;
@@ -1603,13 +1593,8 @@ static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 	offset = swp_offset(entry);
 	if (offset >= si->max)
 		goto bad_offset;
-	if (data_race(!si->swap_map[swp_offset(entry)]))
-		goto bad_free;
 	return si;
 
-bad_free:
-	pr_err("%s: %s%08lx\n", __func__, Unused_offset, entry.val);
-	goto out;
 bad_offset:
 	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	goto out;
@@ -1624,21 +1609,12 @@ static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 
 static void swap_put_entry_locked(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
-				  unsigned long offset,
-				  unsigned char usage)
+				  unsigned long offset)
 {
 	unsigned char count;
-	unsigned char has_cache;
 
 	count = si->swap_map[offset];
-
-	has_cache = count & SWAP_HAS_CACHE;
-	count &= ~SWAP_HAS_CACHE;
-
-	if (usage == SWAP_HAS_CACHE) {
-		VM_BUG_ON(!has_cache);
-		has_cache = 0;
-	} else if ((count & ~COUNT_CONTINUED) <= SWAP_MAP_MAX) {
+	if ((count & ~COUNT_CONTINUED) <= SWAP_MAP_MAX) {
 		if (count == COUNT_CONTINUED) {
 			if (swap_count_continued(si, offset, count))
 				count = SWAP_MAP_MAX | COUNT_CONTINUED;
@@ -1648,10 +1624,8 @@ static void swap_put_entry_locked(struct swap_info_struct *si,
 			count--;
 	}
 
-	usage = count | has_cache;
-	if (usage)
-		WRITE_ONCE(si->swap_map[offset], usage);
-	else
+	WRITE_ONCE(si->swap_map[offset], count);
+	if (!count && !swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)))
 		swap_entries_free(si, ci, offset, 1);
 }
 
@@ -1720,21 +1694,13 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 }
 
-/*
- * Check if it's the last ref of swap entry in the freeing path.
- */
-static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
-{
-	return (count == SWAP_HAS_CACHE) || (count == 1);
-}
-
 /*
  * Drop the last ref of swap entries, caller have to ensure all entries
  * belong to the same cgroup and cluster.
  */
-static void swap_entries_free(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      unsigned long offset, unsigned int nr_pages)
+void swap_entries_free(struct swap_info_struct *si,
+		       struct swap_cluster_info *ci,
+		       unsigned long offset, unsigned int nr_pages)
 {
 	swp_entry_t entry = swp_entry(si->type, offset);
 	unsigned char *map = si->swap_map + offset;
@@ -1747,7 +1713,7 @@ static void swap_entries_free(struct swap_info_struct *si,
 
 	ci->count -= nr_pages;
 	do {
-		VM_BUG_ON(!swap_is_last_ref(*map));
+		VM_WARN_ON(*map > 1);
 		*map = 0;
 	} while (++map < map_end);
 
@@ -1766,7 +1732,7 @@ int __swap_count(swp_entry_t entry)
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	pgoff_t offset = swp_offset(entry);
 
-	return swap_count(si->swap_map[offset]);
+	return si->swap_map[offset];
 }
 
 /**
@@ -1780,7 +1746,7 @@ bool swap_entry_swapped(struct swap_info_struct *si, unsigned long offset)
 	int count;
 
 	ci = swap_cluster_lock(si, offset);
-	count = swap_count(si->swap_map[offset]);
+	count = si->swap_map[offset];
 	swap_cluster_unlock(ci);
 
 	return count && count != SWAP_MAP_BAD;
@@ -1807,7 +1773,7 @@ int swp_swapcount(swp_entry_t entry)
 
 	ci = swap_cluster_lock(si, offset);
 
-	count = swap_count(si->swap_map[offset]);
+	count = si->swap_map[offset];
 	if (!(count & COUNT_CONTINUED))
 		goto out;
 
@@ -1845,12 +1811,12 @@ static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
 
 	ci = swap_cluster_lock(si, offset);
 	if (nr_pages == 1) {
-		if (swap_count(map[roffset]))
+		if (map[roffset])
 			ret = true;
 		goto unlock_out;
 	}
 	for (i = 0; i < nr_pages; i++) {
-		if (swap_count(map[offset + i])) {
+		if (map[offset + i]) {
 			ret = true;
 			break;
 		}
@@ -2004,7 +1970,7 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 		return;
 
 	ci = swap_cluster_lock(si, offset);
-	swap_put_entry_locked(si, ci, offset, 1);
+	swap_put_entry_locked(si, ci, offset);
 	WARN_ON(swap_entry_swapped(si, offset));
 	swap_cluster_unlock(ci);
 
@@ -2410,6 +2376,7 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 					unsigned int prev)
 {
 	unsigned int i;
+	unsigned long swp_tb;
 	unsigned char count;
 
 	/*
@@ -2420,7 +2387,11 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	 */
 	for (i = prev + 1; i < si->max; i++) {
 		count = READ_ONCE(si->swap_map[i]);
-		if (count && swap_count(count) != SWAP_MAP_BAD)
+		swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
+					i % SWAPFILE_CLUSTER);
+		if (count == SWAP_MAP_BAD)
+			continue;
+		if (count || swp_tb_is_folio(swp_tb))
 			break;
 		if ((i % LATENCY_LIMIT) == 0)
 			cond_resched();
@@ -3656,39 +3627,26 @@ static int swap_dup_entries(struct swap_info_struct *si,
 			    unsigned char usage, int nr)
 {
 	int i;
-	unsigned char count, has_cache;
+	unsigned char count;
 
 	for (i = 0; i < nr; i++) {
 		count = si->swap_map[offset + i];
-
 		/*
 		 * Allocator never allocates bad slots, and readahead is guarded
 		 * by swap_entry_swapped.
 		 */
-		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD))
-			return -ENOENT;
-
-		has_cache = count & SWAP_HAS_CACHE;
-		count &= ~SWAP_HAS_CACHE;
-
-		if (!count && !has_cache) {
-			return -ENOENT;
-		} else if (usage == SWAP_HAS_CACHE) {
-			if (has_cache)
-				return -EEXIST;
-		} else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX) {
-			return -EINVAL;
-		}
+		VM_WARN_ON(count == SWAP_MAP_BAD);
+		/*
+		 * Swap count duplication is guranteed by either locked swap cache
+		 * folio (folio_dup_swap) or external lock (swap_dup_entry_direct).
+		 */
+		VM_WARN_ON(!count &&
+			   !swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)));
 	}
 
 	for (i = 0; i < nr; i++) {
 		count = si->swap_map[offset + i];
-		has_cache = count & SWAP_HAS_CACHE;
-		count &= ~SWAP_HAS_CACHE;
-
-		if (usage == SWAP_HAS_CACHE)
-			has_cache = SWAP_HAS_CACHE;
-		else if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
+		if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
 			count += usage;
 		else if (swap_count_continued(si, offset + i, count))
 			count = COUNT_CONTINUED;
@@ -3700,7 +3658,7 @@ static int swap_dup_entries(struct swap_info_struct *si,
 			return -ENOMEM;
 		}
 
-		WRITE_ONCE(si->swap_map[offset + i], count | has_cache);
+		WRITE_ONCE(si->swap_map[offset + i], count);
 	}
 
 	return 0;
@@ -3746,27 +3704,6 @@ int swap_dup_entry_direct(swp_entry_t entry)
 	return err;
 }
 
-/* Mark the swap map as HAS_CACHE, caller need to hold the cluster lock */
-void __swapcache_set_cached(struct swap_info_struct *si,
-			    struct swap_cluster_info *ci,
-			    swp_entry_t entry)
-{
-	WARN_ON(swap_dup_entries(si, ci, swp_offset(entry), SWAP_HAS_CACHE, 1));
-}
-
-/* Clear the swap map as !HAS_CACHE, caller need to hold the cluster lock */
-void __swapcache_clear_cached(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      swp_entry_t entry, unsigned int nr)
-{
-	if (swap_only_has_cache(si, swp_offset(entry), nr)) {
-		swap_entries_free(si, ci, swp_offset(entry), nr);
-	} else {
-		for (int i = 0; i < nr; i++, entry.val++)
-			swap_put_entry_locked(si, ci, swp_offset(entry), SWAP_HAS_CACHE);
-	}
-}
-
 /*
  * add_swap_count_continuation - called when a swap count is duplicated
  * beyond SWAP_MAP_MAX, it allocates a new page and links that to the entry's
@@ -3812,7 +3749,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
 
 	ci = swap_cluster_lock(si, offset);
 
-	count = swap_count(si->swap_map[offset]);
+	count = si->swap_map[offset];
 
 	if ((count & ~COUNT_CONTINUED) != SWAP_MAP_MAX) {
 		/*

-- 
2.51.2


