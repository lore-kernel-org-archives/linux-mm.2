Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97F14CFD351
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F271F6B009F; Mon, 24 Nov 2025 14:16:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E895B6B00A2; Mon, 24 Nov 2025 14:16:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F7A6B00A3; Mon, 24 Nov 2025 14:16:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C82B06B009F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:16:45 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9FFB813B2B5
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:45 +0000 (UTC)
X-FDA: 84146457570.29.75E8E45
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A94418000F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aL8eDIKQ;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yWRzV1WRkV60aRgwV/nuINMmHJf95UsBR54eymIys8E=;
	b=a8tp/BlOgFEnxeF7LcUI5j5UAuSJ8bmKXN8T7Ymw9xzTk01SZiOhndyryqcznq5Kbs9ERw
	4wX8Et/O+WluoHV/KANXlSLZTh7NsuGG/6e8yRjiLKAB0W/QKvVB9+81+98IEImFmL/5rA
	ECbjmYh8q4nxljMBJRrlrI3Edbcunx4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aL8eDIKQ;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011803; a=rsa-sha256;
	cv=none;
	b=U10YrLHxYN0Ysp0YHmUEEbdHKXW6PDiaHqLv2eo2PI2KUTQypJUX84fIGcZsU+FVXccfUM
	nZu3aRa0nqyLzbhE2XxI64p0DrUR7XjO5Dx3sR6P8bJOzgWptfJL69dwZcWJvcHNxGO84E
	30h3bSwr8dVuFAaNyvksi1XnD05Cp3o=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7bc0cd6a13aso2886193b3a.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011802; x=1764616602; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yWRzV1WRkV60aRgwV/nuINMmHJf95UsBR54eymIys8E=;
        b=aL8eDIKQd9ljQb/bdpUf6qov2YoLJkQc26XFPOatB6ZSVaCacGgrTduw5sJJ16n8Ca
         DJ8btMdiBOHWWcZIftE0HN91ha7/O101udbYbDWQPQLTn5tFoQxt9oIRfuMTleksXqWA
         GQ64e7CRujzZGNs+VECAeyAl7Tcc8d2GlexDr/gBD7rVRZT12R0UFO2fByQ9Yd2nvr0F
         zzUSZnnPCqPPy36n6Yhj9MAGmYR8KsrE+dombXBB0OHoHK17b99QsEnDSoRZU129noR5
         L4Ovk29utjonqW1mT/cyotKcmg6sepVl4jzibPhEkiyjqJ4NbB4SdlVX0VrqqTGXLMv7
         FyiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011802; x=1764616602;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yWRzV1WRkV60aRgwV/nuINMmHJf95UsBR54eymIys8E=;
        b=cJ2nlyDUNulr6+aQfwmnv7uws7DoQokPMOWxpzbl5K3Ns4n9L2O8Tvfp3sS81lr4uG
         xPdGff9hR7cY486U4SpJEP5NPkDhRWaGN53QJLGN738kYhKAHUjfbP8Kypvr/iQATF7t
         /lIh7tNkpwdaa1LfVnHCBbPcSXbwOJQy5Uyp5KqFIeXkgBQ7Dh5XO5D21ucjdP+fNSkv
         tMNErNnqvsiu/v4KpuCjg7R6c0noCYhP/c4QviniXAKtSt4BJa0zcylMjvZHO6UXbirN
         1xSlbSHPDheZeXPibFE5hC90HZtJtkK4osAkZSkVWFF3oEDYplfoWOWjC2M12gNy0vrr
         Q2Ug==
X-Gm-Message-State: AOJu0YxF9D1/Sy91ncep5CT8Z5eJaTLoxR3EPd2re0uhvvsfl57ScRXC
	xn/BAyKQEwgdx/zAn/9AC6iqHK9nwgEQrIoSzDWUN6LCjJWbKSXWGWpB
X-Gm-Gg: ASbGncvVwKN9ZceMfC5ihtrJm0f/I5SmewycSbxnsgtnzfBj5/BxcExZ8hylVS/SfuR
	cVCG7TXBzVySzWgvNPfwWOvlZU8mGlD/3rSX39xwklzSiGqBSpwjfsJIA41jDyJ9t5kidwnDgRs
	nlTzLl3IvDzEH8c940SUNZlblD0nfhLdeXKV1Diy/hhnFApsAcFn2HttzIzC+bm4Cj9HXmtS+jM
	YQwDQ8wpUd8iVjPx0F7Oynjhlg+J2zqPtMNsD6NKQ9M/X3ieU5bB0s4QTtzO/JZfAe+CngpY/J0
	UoZvIieR7Twn6V5RFRoY801SOTsPdO3ajqaWIvuqJ2odLrwynm3WvtSXc0HB/QXagY8ChBlrN7w
	djKZmggZM72DFfpG5CktzStreVc2wQf7dY6TyV42t07IjKncSwIic0A+AvtGgDlAsdykI+Uhzgq
	s/5B3E5uC2QdMcSvMr2uDdjxiI+YjdyMAo16GAbra3ABwByQem
X-Google-Smtp-Source: AGHT+IF6oDkF29fP7Zgad5PE+BeKohxldhqsbyS6qNXAnkrppKlg9jNj64G56E7F3aiZ6PnkAZD+OQ==
X-Received: by 2002:a05:6a21:3290:b0:2ab:a456:9b09 with SMTP id adf61e73a8af0-3614f4a0c7fmr15516656637.15.1764011802296;
        Mon, 24 Nov 2025 11:16:42 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:16:41 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:13:56 +0800
Subject: [PATCH v3 13/19] mm, swap: remove workaround for unsynchronized
 swap map cache state
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-13-33f54f707a5c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=7032;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=EqyErHrG43rTclh/Dj/hWJSWApsejLOsmiO76lsWvo8=;
 b=/oih483LAH2Cg8yPDBqVttvrPiriRWEQTCTk58Q6x8+VMqd3wNHzP3ITe0bAg2xv7661yfmZf
 ZEEkXZkG255BX/sg5BxhXbn68OYafTCP3y4/s7htW+ddB/tWFmz4Q9O
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8A94418000F
X-Stat-Signature: oykayxehz6frotexagn3akstnf68gei8
X-Rspam-User: 
X-HE-Tag: 1764011803-229121
X-HE-Meta: U2FsdGVkX1/E60+7mLyNaUV6i8dWx6WPyUlEBYl96Eqv/PudRGKxdwG6OFzfQLjFKFhwQ0ttumu90rok3ePK+WwJVGJ0RKtc9HehMHYsTBFTMq0C3BkYqvRNocMn+pVuIaCz5xO8QI1flEtoT0wQ6V0T9zXWwpMQOJJovszv6dECehJJiRr9mpA4PO1rG1BYBxFG3GZ3I9XnfrQxaAuPjDwU+yFWk3jq3v9Ev7UgqQBpWk1IHmw/uqLtMZVN1OFtETfKlKL+Ma7Pu+0Wun2yANPi+mgweLTcpjraN6UDuCk9e5zOBkqOARe0WFJaiwfzHCoBjynz3rTQ15tczC++92i3ABcIu/EslKRZSQbwsBWkRE05xbP+l3tMsSG6ZBgoTXbgBkJ0QiEGJ45psReaFykRw/Vg8hqFo7I9sNLIUYy9tAQIOEEbSKtCbcBG8PwnIE6a4rnHMArq0I65LJME9SbEnX9wcOxPmKmYAM43ilPdqVVG4VclAUZSCY+/N8hLGMVokEwKChmQ/gxA3+9788riK80IzMStSA/igeQ5PE8+x4uCrv3MPpSPQoP68DzQmjWM4LB0C6t9sl+tr7vqSLr+NKNguMVmKmM5Ih4leuheNkniDb4Vk9jeDKe5vpwQHDqmywCmoNWpRG7/eBMi5x43120Hb2pjVNfun4HNGvViY6zfcB0GFekX9MLy5cZwwGx461gJJrybm1qKgXB/Bycypwv5mr3XqwUvMghucBXqTLUX4LXQBHJ58H+zOvwvSNQ5glWN8St7inh+5NFlANaMtq3TdKImzfUsYa9zXY+rvhGXTgiZ1N+hN0TjDIsGCoDeYoQ95XzDf5YlYMq1BldEIUdWNXAGHN8V/5aGcIt/82/kyIV7uv1zSufMzwj9wiacA6n61M1mzelyX75Q/9+TFkaXeW/QcsaIW99Ty9Zzh0Pu6TiUnmGyeG8vRtAumOlEnSEQ26HONIzxAF/
 OixW1UQA
 M3/Is8+YTmWdKa5wULsJuZ0QsoIGjbOV50/HGPFsoJJpgJS2QFm7lxqxssk8VaEFDoAVbIbbFTVhXC8tsTCHn/gNThSQFeywv+aOB3IWmmZqx5q1p6jtheCyBMlB0rY8SYSmIlYlLCmQrDnSGDAf35xKlusfoqsQq/Ivj8H2Ms88N2j9CkNph98VQUjW1uz1hZBkgpx5rOQRZafe/okD6Pn12xBYC4zhkLMKNylDoWpl4q8Fd/gfx6G4feyNyNGCokJL8cOVIZIh3CftHqwxaC8HS7U/WHL1EaBhwuk1N3Hd6GYx0olxN/wtgd+A/vqL5Bs33iTuqPkF8vNZLDLQC9hwTQVLWqKNNE/DG+zWvR2vW/haPFSpwXDUJf5S//EvIXmebbeuMsL8NlVSv71znFyy6GLM2b66E7TLVBVrBuIwvj3UrrY4yEn64Rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Remove the "skip if exists" check from commit a65b0e7607ccb ("zswap:
make shrinking memcg-aware"). It was needed because there is a tiny time
window between setting the SWAP_HAS_CACHE bit and actually adding the
folio to the swap cache. If a user is trying to add the folio into the
swap cache but another user was interrupted after setting SWAP_HAS_CACHE
but hasn't added the folio to the swap cache yet, it might lead to a
deadlock.

We have moved the bit setting to the same critical section as adding the
folio, so this is no longer needed. Remove it and clean it up.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h       |  2 +-
 mm/swap_state.c | 27 ++++++++++-----------------
 mm/zswap.c      |  2 +-
 3 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index b5075a1aee04..6777b2ab9d92 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -260,7 +260,7 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 void swap_cache_del_folio(struct folio *folio);
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
 				     struct mempolicy *mpol, pgoff_t ilx,
-				     bool *alloced, bool skip_if_exists);
+				     bool *alloced);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry, void *shadow);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 847763c6dd4a..c29b7e386a7c 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -445,8 +445,6 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
  * @folio: folio to be added.
  * @gfp: memory allocation flags for charge, can be 0 if @charged if true.
  * @charged: if the folio is already charged.
- * @skip_if_exists: if the slot is in a cached state, return NULL.
- *                  This is an old workaround that will be removed shortly.
  *
  * Update the swap_map and add folio as swap cache, typically before swapin.
  * All swap slots covered by the folio must have a non-zero swap count.
@@ -457,8 +455,7 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
  */
 static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 						  struct folio *folio,
-						  gfp_t gfp, bool charged,
-						  bool skip_if_exists)
+						  gfp_t gfp, bool charged)
 {
 	struct folio *swapcache = NULL;
 	void *shadow;
@@ -478,7 +475,7 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 		 * might return a folio that is irrelevant to the faulting
 		 * entry because @entry is aligned down. Just return NULL.
 		 */
-		if (ret != -EEXIST || skip_if_exists || folio_test_large(folio))
+		if (ret != -EEXIST || folio_test_large(folio))
 			goto failed;
 
 		swapcache = swap_cache_get_folio(entry);
@@ -511,8 +508,6 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
  * @mpol: NUMA memory allocation policy to be applied
  * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
  * @new_page_allocated: sets true if allocation happened, false otherwise
- * @skip_if_exists: if the slot is a partially cached state, return NULL.
- *                  This is a workaround that would be removed shortly.
  *
  * Allocate a folio in the swap cache for one swap slot, typically before
  * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
@@ -525,8 +520,7 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
  */
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 				     struct mempolicy *mpol, pgoff_t ilx,
-				     bool *new_page_allocated,
-				     bool skip_if_exists)
+				     bool *new_page_allocated)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct folio *folio;
@@ -547,8 +541,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 	if (!folio)
 		return NULL;
 	/* Try add the new folio, returns existing folio or NULL on failure. */
-	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask,
-					      false, skip_if_exists);
+	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask, false);
 	if (result == folio)
 		*new_page_allocated = true;
 	else
@@ -577,7 +570,7 @@ struct folio *swapin_folio(swp_entry_t entry, struct folio *folio)
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	entry = swp_entry(swp_type(entry), round_down(offset, nr_pages));
-	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true, false);
+	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true);
 	if (swapcache == folio)
 		swap_read_folio(folio, NULL);
 	return swapcache;
@@ -605,7 +598,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
 	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	mpol_cond_put(mpol);
 
 	if (page_allocated)
@@ -724,7 +717,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 		/* Ok, do the async read-ahead now */
 		folio = swap_cache_alloc_folio(
 			swp_entry(swp_type(entry), offset), gfp_mask, mpol, ilx,
-			&page_allocated, false);
+			&page_allocated);
 		if (!folio)
 			continue;
 		if (page_allocated) {
@@ -742,7 +735,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 skip:
 	/* The page was likely read above, so no need for plugging here */
 	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
 	return folio;
@@ -847,7 +840,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 				continue;
 		}
 		folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-						&page_allocated, false);
+					       &page_allocated);
 		if (si)
 			put_swap_device(si);
 		if (!folio)
@@ -869,7 +862,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 skip:
 	/* The folio was likely read above, so no need for plugging here */
 	folio = swap_cache_alloc_folio(targ_entry, gfp_mask, mpol, targ_ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
 	return folio;
diff --git a/mm/zswap.c b/mm/zswap.c
index a7a2443912f4..d8a33db9d3cc 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1015,7 +1015,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
-				       NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
+				       NO_INTERLEAVE_INDEX, &folio_was_allocated);
 	put_swap_device(si);
 	if (!folio)
 		return -ENOMEM;

-- 
2.52.0


