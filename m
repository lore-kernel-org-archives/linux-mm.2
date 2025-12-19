Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3286CD7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 998666B00AD; Fri, 19 Dec 2025 14:45:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95C7B6B00AF; Fri, 19 Dec 2025 14:45:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E816B00B0; Fri, 19 Dec 2025 14:45:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2476B00AD
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:45:37 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C73A12DAD
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:37 +0000 (UTC)
X-FDA: 84237250314.05.B86BB52
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1B38012000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l0bX7G5R;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173535; a=rsa-sha256;
	cv=none;
	b=hZX1fpjjY+AchEvwozpVFLly3cwRvZsVbR9KNhDuqPCwCwSSP9K0Oy/jCXFfrOsFlx6Nw7
	VgWZMm4fw7M+AhJ6dpdbuEBvrnnCowmvGZck86Y+kGzAsaOra1Si7A9WO5DbHby2wiQ9ax
	evv65am9B3tBL3HStArTN3gThe0tnPc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l0bX7G5R;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+RQ/TfHSPFWESgUxtvx2lU9JguTovbHRFDwOD/mV7w=;
	b=i7eg7ZEIRU8w9UPy9k00g7aneNzk0mot7BkJ/DjqvIOAF+LP/Joz+ccK8HN8azKtlmVt+n
	9rNEPQPMnkmWis1YrQWiSct2f4MrCvvkDPqEZCkF4IvLwIQjMFmHDTy4sZbEMIZsdxRVot
	E7vtIoANs558JJcEu0Plu1xNR2+/z/M=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a0c09bb78cso14635775ad.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173534; x=1766778334; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C+RQ/TfHSPFWESgUxtvx2lU9JguTovbHRFDwOD/mV7w=;
        b=l0bX7G5RbiMcZzNEHZjY7ZD5V45PiflXShsi5Fpl8CQjxb07Vr7kxi/nQrQunB1MMP
         s6vYgtnZQKRU85e0HJCUWmHq+1IPR1bXUqBs/FgfX6awInZOfTVuYmH8ywngJaWq2eyX
         2w7oEa3qDPzH68s1SERqdrfK2nK11c151Tb0nGaLj49vr5iaLNWCzMOwgeHGIOt4yBCx
         sBuPo4NPw67kigERCIXCGKo3M5fxuOn3sx2abt7EleMgzPwL7sOzXVInXseyHw6b6w2o
         I6n7AkOtRObizPhqiZpjEVRxFLU9swDZ1xT8+TPeSA6wnexkXdKeWiV5GtahqqChZAWP
         x62Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173534; x=1766778334;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C+RQ/TfHSPFWESgUxtvx2lU9JguTovbHRFDwOD/mV7w=;
        b=ueWtkYt7PknXAxGkK+BVtvdo4FcbFLhJN8CV35Vdc0KGczgat4kBLW3Ukt5czpUjJu
         UjNuyCGXJ5Zy+VXsDpHuyzoKzs5BdsHW5wuVCfJ0/OMDMGEZ7imudMn9TK3MB/dmhDf9
         zAbsXegh+UYdgpS9hL+XN+BfJK7l6X87YpD4eS7Pfj+3BdNrqNY3U/IrFF/gl3Y6tV2X
         SidP3jwttATLdaNlKlZQoRPHTcXeSMfKgZUvpPun7c6TVMNGtdzZcnkw08F2lHjAeheg
         jnHgbCSUVitNgr6hHowRBeEpLKevgQkSAeDXqwguy4SKj9u6YsbeMkB06xwXj0OSjExQ
         5hRg==
X-Gm-Message-State: AOJu0YyR8DpYq5vyIUqFNwCQ6PeostCUFc7Qsl0LBoVPtGy/yFQbIeGi
	76icrF7ZaCzO+dy1LIZ0SDDhQUFo4d52Rr9/HmNa4dS01vvcvugmiLee
X-Gm-Gg: AY/fxX7WUz6eeMVGjsqX2L/2U6upUF5FHbqOau08jMaKZVv02snNyk4QcvvT65+ImMZ
	wJ+6dPDsN6MFgZH9KgcgL6M7NvMbHgdVU7Vx+imkMrypUXrx8pCI2oEVK3Brs6QCtIcmJFBwWVX
	ZtdwJCSJeK1A8yvOx0qE7h0l3lcEZd34/mG9RGJVw4c4/4F2hs/KC7z7a4HQ6laJf/OEHkoSD33
	9T6Acv5UpY6puqH8xjMY0xP3xEM3z1BFRzb5MRQi0zB2KnffrlwyrysTqjxB/IauvLc1CL6W7UQ
	YX/yzRSvj6Y7+0/sdqu/pf6i7CtzOTYUtO6xa4lkEA1O3N/kh8hUQcULeIGWhHJTLFIAZS2v36r
	SB4Uiph7iIcDO68OQep5ZxBFOYlCROQeWr/q2HFDbQpjXVr3UyMV+Oz+JAP90vn5VAvLcRF6VrX
	dGJb483LSHru1YIqz92/81XB2q6KxVyI2V1DMLTzqu8qTpihshDJJJ
X-Google-Smtp-Source: AGHT+IH/UTCTqpYSmz9cLrJwQg84NY1Mo97k7i39oFV9pTJDKLPSFp149pFzopAt++ZGKki6mXWCFQ==
X-Received: by 2002:a17:902:e78c:b0:2a0:d0ae:454d with SMTP id d9443c01a7336-2a2cab4335fmr58302215ad.22.1766173533875;
        Fri, 19 Dec 2025 11:45:33 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:45:33 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:45 +0800
Subject: [PATCH v5 16/19] mm, swap: check swap table directly for checking
 cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-16-8862a265a033@tencent.com>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
In-Reply-To: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=7912;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=6WuwtHjxFkVBfgapei4Gm4oolBwvY/HEU9CfiVMF7mo=;
 b=eyypQBKFn6nJdcyrPA2kVE7MGM8ssqk71hkL0pP6t7Ns6U3cc+hHDDoOMIRLaoDkXUp26Te77
 mpSbCIGxjtkDOMMG2Z2ZOw1FpaXoPdrAZAeOSfEyEWgBznKVO3FXQ/a
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B38012000A
X-Rspamd-Server: rspam04
X-Stat-Signature: bcr5bxuwdckp9yc1561915meucjmrkh4
X-HE-Tag: 1766173534-312107
X-HE-Meta: U2FsdGVkX19ouREN06hpBrBCTd/rBOYhvix/NxYN2GiF01DdDyld3ZdR8TJFzi9nkxdGx4dSEICwtDCWqco33AlQCg3fF//lekq1WiRxBozUHfLofrua+mpeq4A/rcMMwNgkd+bcQ4viLDfXYIDxilRHNRbqQrs+aFdxyXUVqfXEVsIgusGekaiymejoo/8LkzdmD2Wik/GvDT+KDod/6bFieVx1c7OrpEq0INsYcPpSQZCj6gdfHKwG3piBkiGMu8wotQpWARIJoMA3CBH/EnkmJjvt5t6PxczHtO9ZpOQO9AUrnecD2VV7Z1KfHGnd4nH5BYwfRt25sekFk5q1WxPhjMlWKWnr+Ja5CRFmOYDYPreB/u/giUo699SFyvod1zjt12MGqoVQW3qDLsu8spPkLlzNaTcHgfuGRjXpxjFtA7sggjJCXR/P1SRnQmnrRvx8wHgkZ/LFhJfF8Q+loUjmafcmSNWJfJ8e0HqfIQ5rPalNVLJWr6CVCpNGHrwzknsFWHFI97+W7G1olShmWOPBzePybS/HrII+GHm+6+mp32+Tl7s7HAZUsy2P674inPU0/obuqImxQ2DE0Bo29BprH7Wr0mHo/zflfQRN+WMeEKl9GZ4DV6K8Q21vXriFnA+1MQTkwoKamM2PvAC7IxnmIFBs7bOUf3LEsWAEMSCKXPQm/JzWqLmXiMeuFwBkBkdLMoNVmZ2A4Dx7d6n3OPYNLeIblsNqvmMvJ4iAhY8XYNU98RHapM1JIPl3sX2KVheDo/Y2adJFT+fGLVF/uU6imS1nrgZO9vHFskRmgCQCZZJ/yfb3enu8DDd/2ex3zGDlPjA6+tp3m6thRUExRnC/OoeMqpZzfuLbCR3TaCdeuv9Pb+nT+1oQmQOBFKoNaFD8tm/vKc2+f+Kxks1DHFNvvdVptATnmTMxHbdIrauGJTcDqHS/xEODffiW2GQ/yHryCcr20yhrJddK0l9
 qZ0fPBfo
 jiPgSwT48XaNBiWnD4fXDuSqawK4osKoGYMC29N/M6Lf6VB7vCDhSAQdv1Ovc5HTSLXM/9HllK9H/ROiHyNoELdOQ24IxdPehpXmiR4N+/PChNmgUPY+NPKf3GjVor+lx45qT7Jz0LUw2PWzJTFNHArOjnETiO91zjb57sjXcZYFHdnpeIW+6dhwyMbCxQjUkAGKzKHrSaomqkWLQMzxZR8Q5pOdOZuqU+SxB3TYel1LGeIj7j1BmTJ8ThIsXKJwnHNXKhaKVcp8uhX1PSt/ub9MHs7oB92VVsze/rFd+cbanVY872SJ579mqV26Wo6oazwU6xlg1AdMrgIJD+C5KEJhms4bXyed7CZ0ZxkTUfPCa00o+XOYy6jr+bSvqGNQjpaYNx45bctqfj2TIVThKS+lf4IZJQjfnnCnMSFH4NvKzTfHzT2wymmFPHg==
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
index 29fa8d313a79..0ff6c09ee702 100644
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
index de0f4c1352cb..91436ee41446 100644
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
@@ -1030,7 +1029,8 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		to_scan--;
 
 		while (offset < end) {
-			if (READ_ONCE(map[offset]) == SWAP_HAS_CACHE) {
+			if (!swap_count(READ_ONCE(map[offset])) &&
+			    swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER))) {
 				spin_unlock(&ci->lock);
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
 								   TTRS_ANYWAY);
@@ -1981,6 +1981,7 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 	struct swap_info_struct *si;
 	bool any_only_cache = false;
 	unsigned long offset;
+	unsigned long swp_tb;
 
 	si = get_swap_device(entry);
 	if (WARN_ON_ONCE(!si))
@@ -2005,7 +2006,9 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
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
index b11f81095fa5..46256e7a3d51 100644
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


