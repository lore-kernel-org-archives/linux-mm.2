Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AB96CFD351
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 711B66B00A7; Mon, 24 Nov 2025 14:17:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C19C6B00A9; Mon, 24 Nov 2025 14:17:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5625B6B00AA; Mon, 24 Nov 2025 14:17:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 413D06B00A7
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:17:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0706D1301BC
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:17:01 +0000 (UTC)
X-FDA: 84146458242.03.9D17D8A
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id F12801C0006
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="RBgzL/3q";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011819; a=rsa-sha256;
	cv=none;
	b=t7oDAjQVX8SLDCm1vzmXJuH3T9FyfdoqW+ZR76+ixT/HKoi+LdnemV3I1a7cbGsN5OdL0K
	gHJofqae04zt/J/crOIn0sTuxFANklNYHcb7HOM5F6fYs+8PVlxJsk8LRCOSu5aGjNfp0R
	ly6pyDp/UATH6ktm9ilqa4QU/pItAEk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="RBgzL/3q";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GcrO4+VrgA5lfPDgsn5lPfD0YSBWSARCYG+aVCir9Rs=;
	b=V4AsfcCOgIa5IcCdAiU0D0ZDdidllWrALA43nV2Ky65G5MQPP9eRLw1mb7176cc36Z1NKl
	vEimUzJAZ5th/0pEHMKJ8X/enoV2QILYEGVQOjem7nWRSZ4ltCWGmKmAmcA5T9gMviDcrK
	p1x5+9/aYtrHYiM+ZJfzOmQNhyJXDpc=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7b9a98b751eso3659990b3a.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011818; x=1764616618; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GcrO4+VrgA5lfPDgsn5lPfD0YSBWSARCYG+aVCir9Rs=;
        b=RBgzL/3qD/wUlRkzfteO0UXFHXIpG6+lISEzkwGiUrjalLnBWtupaUsIi0yaMwCxh6
         Csa7Ag5AFJ5HU0OWnFAhfSwuEb1czQkizb9/EgnKJngFKoMMISZIRBRylTXA0ymHXZGG
         DaOJKGAJS6LVRzuu2cHNq7TKOqSmmf2snnLD0gPlbY6MLtcJRMegRrRYMwEjhJSU2ahn
         53WGFEQzOpUGBKS5v+VTL8NeKOrRv+iWZPu5U4MThKbo+B84fBoR6R+lZXBTcMxOJKPW
         /vrewfRVqLLI2ei7zLLOdKPh7LVPSIiSUZrbpi5wVZSe5KFnY6+rdhvHYUHSLbw0Vsov
         qy+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011818; x=1764616618;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GcrO4+VrgA5lfPDgsn5lPfD0YSBWSARCYG+aVCir9Rs=;
        b=fnqChFc9aFlVu+DBbADIQbs0k9irasCIYpkBx01T22hEGphKSw1wnxilowZzDvhfyQ
         dzQSwcnpuIgx1LDSIYhxMO0lI8hn8ZgYigh0nRD/ajtYSUbWC1NdfxOZJ8u5gHlFTxn/
         3nB69zUSUgVMFYJGAh7aovPsfV91GDF5PiJeXFShqvcNkRoUgR2f9Ov+JGnTjaNjg1S2
         rp191utPlWcLM+2QUUiG869a/5kY2L9c+/jz437dQT9DBWmottks8XHf5GDJ12YcrcVF
         p9JQ5g28het+gllVJrj3mE7xsBHo7GGoIwTMqDRtNj+yta/SxTtCiEbEHfGVa2fxgh3y
         ka7w==
X-Gm-Message-State: AOJu0YzNd7l3/9DfxSJIjHhWgVjG+IdlijEgLha6OEjA/hAqdaxR1yGz
	UeyyImHjyAsNG8MBcOrX/prr9fmhIfXk60hdJrHXkcRBCi9e4TxHi0t9
X-Gm-Gg: ASbGncvxpv+K/Z4Kd7k5NNgI6HVcYjBA5DAuKC1TVQ8n6WmdaSCg4IXiAfxpoDnkTvY
	NyAkXvzPQHvLazJBDKU2Aohdj2CArBPhFuGsl+1b5BWmLYuY+QFP4RcG9txFeuXyaQKV60angIL
	YKDbX3DXhDvPWBjHZEhZuERBB/cJh8tqCKqaDzEHITFzjDc1tCAJnEsi3OAvpGejDWPIl9FNyc+
	wQf82ggzeF/JI/Lw647PLQogkYVxXYfGimjemZdozOmN/FAJrKcZKCwGKG/pB3mWLspbq19mB0p
	+zFBmki51JqOAqIJuEctwv01n8zUoIa/I2nqNmiU8Slj9IgATqJOBl/7ksGNmY0e+iWfg1ic3S2
	WLUsvzKabsk4iZSGXACXcZ87ViaJdIhleitrSoIzm3bvA+zqU4p4XJ3a0rnneC3Sp0tEZuKDk3t
	/GdLUfi2qWux3H2Vgz/IId7kWJfkVBMjXXJts8z5RJdZo/ZBaU
X-Google-Smtp-Source: AGHT+IHJUVf2bjQh7PYsc3slGlVxxnG0MimHJ3XPxaJaJmjt78qZ65YN1P9zZdlu49oz0qIj8JsQ9g==
X-Received: by 2002:a05:6a20:918d:b0:343:5d53:c0ab with SMTP id adf61e73a8af0-3614ecc985emr13628204637.20.1764011817625;
        Mon, 24 Nov 2025 11:16:57 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:16:57 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:13:59 +0800
Subject: [PATCH v3 16/19] mm, swap: check swap table directly for checking
 cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-16-33f54f707a5c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=7912;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=l2u8+7ztYOIx0yRaQjFhJKppLX2cjxl7BELgafgfB5U=;
 b=D4cavwQuPEBTnSw4UhrTn5nzBgDX/18iZdPVPrIpEkirBt9h4hmGJR4XigoJICqcJ3g67PoIX
 nkzAJPUJZoYBfWnIoSqnK9IRqBY73FZ5F/4zQ4l4K7DtL8IeGhIEgA4
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F12801C0006
X-Stat-Signature: ami8784sdbm6dhb7ar3ug9oxnbbnfknb
X-HE-Tag: 1764011818-898468
X-HE-Meta: U2FsdGVkX18g6aLkz8sVGSKl0f2KWxG4sER8LeHXkkZHYl94ddlixMv4gtl5aO/goNgmLXj0tyGglTrkiz+SCtDoxlFuHR/NEBM2ja7npls/CJzRnWqiK6bOhVcUxkOwmkQwYdVHqh384UEm54xJFiovjvE5muwK+2mlY/mE/D+XvCjvdwW0aOgA124xz8ipeESZSAFWvXia3aHdcyw7vaUtZftfnSfLVX6PLiYNgtDZHQvtMF8RgYeoxtiWugG8woaHHSck4VJUiq5vq3h9UPPBgdiAQMdPssQS20P6bSm7IhZz/V4ejTETaT0g36Tj341TqN2O0+3TDLy2MO3xS9hvRqQqIvt8DdWKGYKphvWvyx+QF+1rSfJE/XFb6PFBLXklRPCdT1LvjsJY4XWy0LGSSeu9vyCDFIxdWMC4aoSGauCNfjuqP5yUgD2Ggukn352TOj2wFBBYHtmMJ/e3L71qpd7SZHTBfiq8B+S/p6VvPJDZVvzDgnOsiEUPRNkwGkvbvx+V7hUSks6cVWXERr9D3XVoGY1DHGUlbCp+PrNOOo45Dq3Qnt/shzw2KslSkXOSi1x2w0syG5gRgnyEG3m5hlqlxtOf7xYQze92GCZCoftdWj68V3ZnxvBF2949dXdj/Sh8DnTpJ4VLm9tKCiZ88dFNe9Mw+bw2sMkbEPxuU0izBK8TRWjWcM5TbxSPR0jBxVGHm/IIcKWL9BW86y06EGC1YPuavjPkvOITaO8n9qzmKKPhUpYfQLyMzh6cTtnvd/Z6K7ce4ba80Cp/djSMeZMx0l7pk8a5sLnIr/gPKDxnAlxc6tOEBpbl/tjgv4MziOE+bh55/Ly5IuNqNVvOxOs9SYHTbhD1Yh6JD7spQmJNHmE/2fpxO3OtNcAV5Bj/mo7rLB7OG6BxQxORc5bxajXSFmxXDQo9z2C7cEoMqLKwbFDPQ1dsf67YFRx4WLLGWpBhr+qftGHDE6o
 WMB3SHrM
 2YxOuNyIGiTB+AmtF40X2tDvcATmEfN/dbR3NRC5JxbjseydsJEceTOZku7NG0mUL71R6PGecp1BoXMtKPAs/8XmgHE0tKQun6lvE0V61vhuQwfZHekuPgk/2CqUJLvA5xC8tCdeh23mno8vcmE8m82lh3pOErdX+vhPL7YradtcNU7oXQctTjgc7wn4/laPs/gfhgAWVGrHgX5FInJAsfTTfvyEfYymh+CfMSc2n0fj2331akZhF7YtpHsqFDKnmyty6s3hyA2q93vOQAO8RPgkVoLFnQRUcXTy9TikxqTjuBLIpVJhcLii2znNi5Ul7XZLSF7BXKGBeutZSWTYUUxa6PN37cEhHngqgAHQe5ys8Uw718R4fWVopLmWZCllKuLGxn3+xiua6nm+O5oCazGs1HcyEHp7tdPCcQv7olcE8uH21eAWjfTzYkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of looking at the swap map, check swap table directly to tell
if a swap slot is cached. Prepares for the removal of SWAP_HAS_CACHE.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h        | 11 ++++++++---
 mm/swap_state.c  | 16 ++++++++++++++++
 mm/swapfile.c    | 55 +++++++++++++++++++++++++++++--------------------------
 mm/userfaultfd.c | 10 +++-------
 4 files changed, 56 insertions(+), 36 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index ec1ef7d0c35b..3692e143eeba 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -275,6 +275,7 @@ void __swapcache_clear_cached(struct swap_info_struct *si,
  *   swap entries in the page table, similar to locking swap cache folio.
  * - See the comment of get_swap_device() for more complex usage.
  */
+bool swap_cache_has_folio(swp_entry_t entry);
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_del_folio(struct folio *folio);
@@ -335,8 +336,6 @@ static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
 
 static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 {
-	struct swap_info_struct *si = __swap_entry_to_info(entry);
-	pgoff_t offset = swp_offset(entry);
 	int i;
 
 	/*
@@ -345,8 +344,9 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 	 * be in conflict with the folio in swap cache.
 	 */
 	for (i = 0; i < max_nr; i++) {
-		if ((si->swap_map[offset + i] & SWAP_HAS_CACHE))
+		if (swap_cache_has_folio(entry))
 			return i;
+		entry.val++;
 	}
 
 	return i;
@@ -449,6 +449,11 @@ static inline int swap_writeout(struct folio *folio,
 	return 0;
 }
 
+static inline bool swap_cache_has_folio(swp_entry_t entry)
+{
+	return false;
+}
+
 static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
 	return NULL;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index eb7710120d5f..94b6d368e3e8 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -103,6 +103,22 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)
 	return NULL;
 }
 
+/**
+ * swap_cache_has_folio - Check if a swap slot has cache.
+ * @entry: swap entry indicating the slot.
+ *
+ * Context: Caller must ensure @entry is valid and protect the swap
+ * device with reference count or locks.
+ */
+bool swap_cache_has_folio(swp_entry_t entry)
+{
+	unsigned long swp_tb;
+
+	swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
+				swp_cluster_offset(entry));
+	return swp_tb_is_folio(swp_tb);
+}
+
 /**
  * swap_cache_get_shadow - Looks up a shadow in the swap cache.
  * @entry: swap entry used for the lookup.
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 91368294170f..7e28d60d90e1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -792,23 +792,18 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 	unsigned int nr_pages = 1 << order;
 	unsigned long offset = start, end = start + nr_pages;
 	unsigned char *map = si->swap_map;
-	int nr_reclaim;
+	unsigned long swp_tb;
 
 	spin_unlock(&ci->lock);
 	do {
-		switch (READ_ONCE(map[offset])) {
-		case 0:
+		if (swap_count(READ_ONCE(map[offset])))
 			break;
-		case SWAP_HAS_CACHE:
-			nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-			if (nr_reclaim < 0)
-				goto out;
-			break;
-		default:
-			goto out;
+		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+		if (swp_tb_is_folio(swp_tb)) {
+			if (__try_to_reclaim_swap(si, offset, TTRS_ANYWAY) < 0)
+				break;
 		}
 	} while (++offset < end);
-out:
 	spin_lock(&ci->lock);
 
 	/*
@@ -829,37 +824,41 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 	 * Recheck the range no matter reclaim succeeded or not, the slot
 	 * could have been be freed while we are not holding the lock.
 	 */
-	for (offset = start; offset < end; offset++)
-		if (READ_ONCE(map[offset]))
+	for (offset = start; offset < end; offset++) {
+		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+		if (swap_count(map[offset]) || !swp_tb_is_null(swp_tb))
 			return false;
+	}
 
 	return true;
 }
 
 static bool cluster_scan_range(struct swap_info_struct *si,
 			       struct swap_cluster_info *ci,
-			       unsigned long start, unsigned int nr_pages,
+			       unsigned long offset, unsigned int nr_pages,
 			       bool *need_reclaim)
 {
-	unsigned long offset, end = start + nr_pages;
+	unsigned long end = offset + nr_pages;
 	unsigned char *map = si->swap_map;
+	unsigned long swp_tb;
 
 	if (cluster_is_empty(ci))
 		return true;
 
-	for (offset = start; offset < end; offset++) {
-		switch (READ_ONCE(map[offset])) {
-		case 0:
-			continue;
-		case SWAP_HAS_CACHE:
+	do {
+		if (swap_count(map[offset]))
+			return false;
+		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+		if (swp_tb_is_folio(swp_tb)) {
+			WARN_ON_ONCE(!(map[offset] & SWAP_HAS_CACHE));
 			if (!vm_swap_full())
 				return false;
 			*need_reclaim = true;
-			continue;
-		default:
-			return false;
+		} else {
+			/* A entry with no count and no cache must be null */
+			VM_WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
 		}
-	}
+	} while (++offset < end);
 
 	return true;
 }
@@ -1026,7 +1025,8 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		to_scan--;
 
 		while (offset < end) {
-			if (READ_ONCE(map[offset]) == SWAP_HAS_CACHE) {
+			if (!swap_count(READ_ONCE(map[offset])) &&
+			    swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER))) {
 				spin_unlock(&ci->lock);
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
 								   TTRS_ANYWAY);
@@ -1968,6 +1968,7 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 	struct swap_info_struct *si;
 	bool any_only_cache = false;
 	unsigned long offset;
+	unsigned long swp_tb;
 
 	si = get_swap_device(entry);
 	if (WARN_ON_ONCE(!si))
@@ -1992,7 +1993,9 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 	 */
 	for (offset = start_offset; offset < end_offset; offset += nr) {
 		nr = 1;
-		if (READ_ONCE(si->swap_map[offset]) == SWAP_HAS_CACHE) {
+		swp_tb = swap_table_get(__swap_offset_to_cluster(si, offset),
+					offset % SWAPFILE_CLUSTER);
+		if (!swap_count(READ_ONCE(si->swap_map[offset])) && swp_tb_is_folio(swp_tb)) {
 			/*
 			 * Folios are always naturally aligned in swap so
 			 * advance forward to the next boundary. Zero means no
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index e6dfd5f28acd..3f28aa319988 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1190,17 +1190,13 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 		 * Check if the swap entry is cached after acquiring the src_pte
 		 * lock. Otherwise, we might miss a newly loaded swap cache folio.
 		 *
-		 * Check swap_map directly to minimize overhead, READ_ONCE is sufficient.
 		 * We are trying to catch newly added swap cache, the only possible case is
 		 * when a folio is swapped in and out again staying in swap cache, using the
 		 * same entry before the PTE check above. The PTL is acquired and released
-		 * twice, each time after updating the swap_map's flag. So holding
-		 * the PTL here ensures we see the updated value. False positive is possible,
-		 * e.g. SWP_SYNCHRONOUS_IO swapin may set the flag without touching the
-		 * cache, or during the tiny synchronization window between swap cache and
-		 * swap_map, but it will be gone very quickly, worst result is retry jitters.
+		 * twice, each time after updating the swap table. So holding
+		 * the PTL here ensures we see the updated value.
 		 */
-		if (READ_ONCE(si->swap_map[swp_offset(entry)]) & SWAP_HAS_CACHE) {
+		if (swap_cache_has_folio(entry)) {
 			double_pt_unlock(dst_ptl, src_ptl);
 			return -EAGAIN;
 		}

-- 
2.52.0


