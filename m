Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0EA9D2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 259126B0008; Thu,  4 Dec 2025 14:30:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20A556B00CF; Thu,  4 Dec 2025 14:30:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11FE66B00D1; Thu,  4 Dec 2025 14:30:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3C866B0008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:30:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B2FFE57119
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:55 +0000 (UTC)
X-FDA: 84182781270.23.14B6CF2
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id A9ABEA0016
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NYjl3XKE;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+OV+xfMG8vEK+0t4KO8+hqW6O39H5Rzxm6GGnh7ZqQ=;
	b=jV8OiKJv70yXbpISsz4I5aD58tHvN6NLlIuJbucFDoIYGGiAeFZi/3AUG+8vi+phRlsJW4
	fWhnM+TAmSAGzzlwHETlx17DpyDY4u6RGrZLjWrBcdghcd5esySgSUNJFjVIN4G+Ok7QoR
	PHsXlaa7OYXSWWzFkj9kjTSEZ1g7m3U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876653; a=rsa-sha256;
	cv=none;
	b=QQrsh6CkfaGzlBTPFeXJRt9lFjAkVxbuLe5dsQXquoNyOmxvIpEL2QN29h4lNThmeBfUGX
	J3Cw0JettphZ9KOXtvLFL6ZAiOUz2U8us2YeTAy13E82ZXUboVsk9x0g9Kz9DWOAphnQPQ
	jGbqBQO0833Q054vubcIupq9idbJg+s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NYjl3XKE;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b86e0d9615so2247931b3a.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876652; x=1765481452; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z+OV+xfMG8vEK+0t4KO8+hqW6O39H5Rzxm6GGnh7ZqQ=;
        b=NYjl3XKEPcxceOPyryov7A+5wRQ7Sz8Zw+V8BLIo3I+AiW/RTF34xiFKZUvq2JqVex
         0gP7fcFy9Nt2DnRpamx3m7FiP1GJbfF/cDtv2JU+mNXr7j+f9SolK9Lqe58/CNdlMT9H
         PaOL4ZGkqdNppgS9DcnyIb6ULOsFiaKfJiC5JuvI1WsQn4IesoiBhT5TDCv8X50qnK7i
         NfUcL8NBKIY1d5q/v3uv7lLAmC8PxfrT/Iv0sHPo0JiFK/NYZvKaWW2lf6El6YHfMRF1
         OOmzxf9UGJvtfCkj55MBbd9Nsh8D+AA5aGq62/ldhKxzlQH+BWJM9YtKieZijMjaFYTl
         RmMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876652; x=1765481452;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Z+OV+xfMG8vEK+0t4KO8+hqW6O39H5Rzxm6GGnh7ZqQ=;
        b=wIRpBdNA4DzUvGFZErWyECnSE5zYPCPQ/MvPiOLoTJn6XvNrrvSaiGPP9orZwxCtIo
         Noe9HzWlG+DthdnQFrxVCnwbtFCb12GfMptFplZswdmPY41qcM0APTvt0UcQCANbYZkU
         uJtkJSdgoGzx6h4TR0ls6xRN5PsvLG5VaNRFiuuqQZY+LJLi3AGhmqsep3b5oaWyeWzj
         8KpUbEm7UUsPSR0HqDo6Dct4dOVw8pLuYarEMQRqyNoK1nym5fnkXNRGSiqzzFw1zWrr
         1ToDWEaV3QJmWw5wZmFHyDdUHBsLHVSXpbPjmTN3itwYDlFPtcquft65Y79UcAyx0JPW
         iJOQ==
X-Gm-Message-State: AOJu0YycP+8sq5128cqf6KfXwnVlJWuO5/eV/P7290qE/47Uo7ksV6n/
	Orp4Qz0mH36di1EbMrlAtf5Xw7ANKzAw1QIiqOLUvWLyc/Zg3e+rTMjh
X-Gm-Gg: ASbGncuXrpD9Sol4kYYRCR85Yvb2OZKETL2LIm9BBgyvvTysyAJi5isQGiPPQQX0n4v
	KLDopeuFcSm4/PQ5p9ZiZLPacwoJA1opqqorlOYTBO/4mdkrJqpCEVF8UYUEhsUb2dYFrt9kZy2
	yfWLqAK104nQvVk03QsKLKtaYrClM5Le/pDBAvCLuKadQfXb57uq1+qX9Eadw14vwwd2yibqWup
	vYcv3tb/qBDNCVjUA47L/gT6jz+B49he6y/VEx/HUCSaj/+sL4qnsmIgSRelGu9QCBR64j/JqFJ
	tS0QSoprBbiaBRbZDDkGLYRDKupg0Xjs3L7ihnzGL3geaa/Oex0ywE1QWr1JOprgmmqge8uvgom
	Mc6vo3fMVBxLz284cQtymBFBTZk88cnXpMLZFmQ9xJfE3V8eQU4I+EYHBVcoAX3g0Xg3fNcq1wE
	BwxBe50AdZDCqkjGU8YsPCajHj8G2qrV+JkutcNfAN8GhGbWcW
X-Google-Smtp-Source: AGHT+IFrS4+YI1PtHu4EckGeptTeEt08RBywVMSqzRAmb+q3EmeaVDzM97Qx8rxRv/8t3S8At73Uvw==
X-Received: by 2002:a05:6a20:158d:b0:35d:3bcf:e518 with SMTP id adf61e73a8af0-363f5bd10bdmr8778613637.0.1764876652406;
        Thu, 04 Dec 2025 11:30:52 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:30:51 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:24 +0800
Subject: [PATCH v4 16/19] mm, swap: check swap table directly for checking
 cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-16-cb7e28a26a40@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=7912;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=VV8qeY6YSf7kGi1o5LI7gaOuEu3UiPZDdvkv5SrF01I=;
 b=ocSLlXivLRrvpyKbP8eKxqsuGmMYp+DRkuAoS4awZfncg3+dcSmilhcrfoxNhmGF8DtGfm73a
 1Jd4UXJDxdwCddAP2vi11cwknzaDppHMO2+KTFKuhwD6QBl8DZCoKuY
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A9ABEA0016
X-Stat-Signature: rkb51tsht7oxj4s9pe1t69ismcpky6ma
X-Rspam-User: 
X-HE-Tag: 1764876653-833916
X-HE-Meta: U2FsdGVkX19hEyyM1rMJmlSTtDImGjFzO/m2r7VIE8daoBiEWF7mURqCMr71MvyCt/qKlG4Y00EP85X/1YU55lColm0ooP1IDs4m2AgoQ2LT7Sq5SjEHvnVZoynAW+MAvPb9PvC7KBuB3qc5Og21ntC/h+RWYKUlQt4q88NMGkRQbWTHS7xmyNPhQuINU4oHnSIbynBMwbNr4jWXS2RIZSUEf3YahCV7LRGBWuC4qo52C8IUXxtEA2xkK5skKawcWmQVTTTsgpn7BOaELXkZBkilb3choFmFatKfAUb8Whh6n7oYrPJZxLI7pQcNz9VCZ2xRTcyhkp3RmeMVNzb4T+pX9OgMVI2AmsDTl1fpwrReHfFj+cC1WWEdHf3d21SfG/MnEQOtse5M+/OdfeXhxjQBCBkVk954fvV3ukr218B6r/Q5z7bUxU/8/2qUxoui9cK+a3PVNnCiueiig9n4NABsTbI8ngkg81d/R57pbo732fgkYwkGCWaeaMSP/1+pZVlu7x/GFiAV9yqCWw+/bGU2njg3/kQz3t6CTcfOgyMSYBYNeTXmpKt4+MXBZBUemyDAI7e/FL6znuVHirErBZ/muBH8uS8z/IPBXOsXSCzSsmw4k5aIWXlU9Sm/Li0wP2Qd0JUHs/7NTZgNr43nm80Cbl9ZG7VpTKKk4aR0BAbbzokNrtisIZtgfAT3l2D9K47FofDiMJfntR0oDQVEa6oBL3TbKeI4wc+QU+49eo09tPTuT3cRA4cqaxsTKxtu4pQQ/tIJ8osmkCslwNwFQg7VFqrWKaQ/SgWbpgflcM/TmLffi9mG8eSx2Q0KeUrg3otH7E9NaHNJWu5894hnBgC1M3a4OBdYOY02UulAZQku2mNYrX1H4ZjrhobWXIUY+ofC/otMosJS+eceHnlGOr9j/Iv2DmatybYMA4/OIZgaJoEXNlpIpShVuwBa2v14vZsuoYssZyJkcjw1w3Q
 eZTVdcwY
 /+21mEU1uv99SKcHZRNzXgmgo9mGNUrHwfuAt6NUnPZNZd4vWLZWvbKOOaIDqW28iCmq7x5JQKa/4+IU3Bibjcj4x4DDZIaEDceujOxlggovDs2Tbv41QY372qPtq4Zm6DrwTn5IUK97su2LZH4aW/ZE+z2JpM4DgexVnx46MlKoh3ZZAB3mtOlGtOmtQKb2rHmOqHLiKncQ5xwL958ztMEQu/h83lD7HS17vqc+6bESUeZCJtRyi3K6S74VQ8WKc5721iiTnSfNyHRHEo9vkdOSrcJa4uKvb44RVcB/7DLthbpCUuRIyY4sCIJHWFu7TZhtec56FhwIPDVOfEfVxXCHIMHCpcLdLgnOV+AXHepMTGxEip7x9gcIQj3nSiL46rZ3eeINfWmFyQTcrlsiojC9YdnTEHBhrSbBhJn1herM+xuWXgZgTnO0vdA==
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
index f478a16f43e9..6bf7556ca408 100644
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
index aaa8790241a8..2cb3bfef3234 100644
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
@@ -1980,6 +1980,7 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 	struct swap_info_struct *si;
 	bool any_only_cache = false;
 	unsigned long offset;
+	unsigned long swp_tb;
 
 	si = get_swap_device(entry);
 	if (WARN_ON_ONCE(!si))
@@ -2004,7 +2005,9 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
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


