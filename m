Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAFACCCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 16:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651978E00A4; Wed, 29 Oct 2025 12:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6295C8E0045; Wed, 29 Oct 2025 12:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F8E8E00A4; Wed, 29 Oct 2025 12:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40DE98E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:00:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0799F1A08E3
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:00:23 +0000 (UTC)
X-FDA: 84051613926.14.789F148
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 074E820018
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:00:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RKaRkyM+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753621; a=rsa-sha256;
	cv=none;
	b=0Q3WQIPH3sWdRpHi113P24kT+bA5cx+NgFRcDYPd5LAeYJMjlECUC7Fmn55jH59RhlT+73
	4MiAoTKhGX+L6wEcBv+kdr+dMNp00pbJKwSeRnZ+IE5AnbGUTtjhdAYKG/fUwgTG7PFCm0
	u6tuBYyEcTIqTEef55JdwuLUWp6BqJ8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RKaRkyM+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zoVrXsn7rvX5B7PiDhrEJ9ULAwxtbalHy9W90Ojrs4=;
	b=jWWZToyKhxIRfkFztLJO570YG4Gb6ohzLfVOvQKHt1ayO3wh0Gw5y7drHAxqYY9Un5maI1
	QtuwQvzDONQn25U+pPYm87ohcbMyYtpl6gDxWE2OYop/FOIw3r/OSE12OMihwjL0NQ/6sV
	ZhTn6q5rLvrwyS2q3Nf69luO2hJoYqY=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-27ee41e0798so105340535ad.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753620; x=1762358420; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8zoVrXsn7rvX5B7PiDhrEJ9ULAwxtbalHy9W90Ojrs4=;
        b=RKaRkyM+/hPBnIkhLqsrVuHPxKJF/8WhQVwyuDhOvUePDy64M/A5Ra0Le6OkaJRrv8
         T9bJPV/C7nA8KDgEnB1g3cnJLKJRCasLhE9csEevcKGCS9CinILraJeei1vfWFKqREEF
         yCenEfxvhFZ7mJe+Lma8aYuFuc0/LWaNSu/Y+3XMP+qxPtUJf5dX1o9KDHF2yyx6QUj7
         vvQTKZrNd4A9D7w9KEtNUD17j1Nu3yO4kl07JRN/oLHM9FzzDKPi8DeMjlJqvHYS0BZs
         bjluKhbLS7Sxql/i/2yEoj89Wst9RZ0iARNHBeG1E/FTiFVsDYVy0/M8c1cD7gjbwC8S
         exbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753620; x=1762358420;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8zoVrXsn7rvX5B7PiDhrEJ9ULAwxtbalHy9W90Ojrs4=;
        b=VLcKoxoLOKD97tDVu6EMjMd+XvCqRvYKkHu7Ak1/Xdhirmip5hn0BVt3lgQAdW2stt
         Pkvrae72JvAgXzfxCDy6B53L242EkPe/VYAOrkZLYiLVKFP6FkX+Tk2Koav4juc9XOOs
         NDDhguMm2F8tvFzq+BBmepqps77/GSxHuk+zjR47+RxrVdwAv7xG89zOuzb67nv39mXi
         hcBj+sy+hcwVR9cEMO2LTYSQTPNMOksY4kw6BOXDxXU1+nmpHiuRysFlIIS13RdAVH/y
         /USIaIjU03fEUoNEZX2DLZXK1mjxkp0uBNOffCiSJIzc809ehc3US7G7x+WRpq/LS2ML
         yWaA==
X-Gm-Message-State: AOJu0YwS/Yw2Rh6XfjBnuIEkFGVeC49BTHchbi9pGqBktlTfpW/7oKj3
	rxrtHVLZeBqNiMMDco3vr7k/fg3fzLZ1uVlZcMVzURidmNuG7GpfxVX2
X-Gm-Gg: ASbGncs9M5Wqg0KFlWV1azuVcGPeYVAi8ihImwOBiEkZtLIjwVSK3gOEtJcS9PKtI6n
	tkCG46iFmTNo89Tf9lsONeNV6+Fm2N4+cm/dGOQ9s4H6xTR8nW0ofUaLOYQyxU3/SsrFnP19MHt
	5trdRx/uuNcUOcoeX8mM+wfQUfqS6mb3DPnFHkFxkh6+rqdAs9cFJsr6sGOQ5fzOslca0T6YFiy
	jrGifvURZNfA4J+zzf7E3+Rb/qFIAa/1DE2W9BWwWfbkbUPHOuiIcQKocfPRcIAyL6FyPiVj5iJ
	xBVDSbo2tblqqTUH4+iEn8OQ/BcviX5sPBTAbZR4F+uk+ivpjwtgTbpgx/w+yBy+rUQNdMNxqrC
	T3LNgrrb4DQOsBZnpav8zZ+d6GdKZgRxi2az0kYOJGVx4IpZog1tzsVdEUH6R62OfAAiWnQSS20
	3E9JxW+OTiqm0WpUpc2hIsjm5gz3+tgvE=
X-Google-Smtp-Source: AGHT+IHuvrF0Tu5VI3bO4fs+LvM+8CgRisU1xPC+GDqoRvkRBpcU82/x1EVGEJmBaKM2vuBkXY2ETw==
X-Received: by 2002:a17:902:ea0c:b0:294:9919:b29f with SMTP id d9443c01a7336-294def471f3mr45839805ad.58.1761753619498;
        Wed, 29 Oct 2025 09:00:19 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.09.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 09:00:18 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:43 +0800
Subject: [PATCH 17/19] mm, swap: clean up and improve swap entries freeing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-17-3d43f3b6ec32@tencent.com>
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
X-Stat-Signature: o5myfzy4xs7gc63dqd5bsfkziid6ibpu
X-Rspamd-Queue-Id: 074E820018
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761753620-49347
X-HE-Meta: U2FsdGVkX1/ib+bVn7MIynkcwX0PKBiwfwzgQSIF4FqOpNbm1jgNQtO4aV8KgPe5yqpBMiuXiJ85J2K1EHhYWmnPGRhLcmFy/n7VyWnrtBk4WNiuQIRYWxdCT24e+J0bTWDQtzWt4DKpYTeNcWeLEk94A7jOzTBHPJ1FtAcVTWlQPTHZbaZ2KvK3TUWFJt+1/jI4jNXsd3JyaNtOddooBMdHr/hmkujRrs2gGvBTYQPhbDtlwHf1tUh4HF8QURGzKeJUI37mHXGKQFJe1425vOgsu6GtmoEc0gyZFWdlTqEHnFe8aNEwSQTGf1elTm33gHPnprQo4MLU0c5K3tJ0ohnte5xGh5uuLaMNjMP97AIn7NxXsbKDlzABPhPebhlbkRwl5Z2LsZenSR6gPMUIX6iK797sO+q0kMBfjBuL9lil6RTiAcN4rn4zXRxqYIQinERdL8YPGdxdxLHNDGp/GZg9VBtWK3IW/p016/U0iehhttbZO7NfazydZu9xt6SbKDAp8KKrqICFENfRkMmzcLOuex19/SROeDgTTSv/t/14s9UvVdcLNkrmi3TrIn1slxMpf22k/Q34E/iqtIDR0eq31HsAyzhx9Hb2NGbdRsexxh1I8sl1BWks6nIAA5t4yD/kPNUEhBrDuRyEH9uP0MC43dDv/8I2e8NeAeqeVOSn+Ynw5B26RohsgnPUiVl4Iw0JUFeWjNugraW5plqgGY4VM9tnWE0euLRVr+zGiIP/XIwE5PLpKJz7/0l3ln+a65rAAqJ7dhf6phpN6usnax3IdXQJJIMduXWh+SnlJjQXpIO/gPbDLMBAag3F3G1oYMBYgQYIYnLATMXlY0VPElYOXdZoxHTcOWXtLglksqFAht1pp5ZN7JdEVBvmWf0XoEmZriwkVB8PHA4Uftyl8VsohrB59msK8TyxBrLn2L4hwsKO27wpY0VBnISQBR1sJvJll3hJAS0GFt0+iYI
 eV3lqTm/
 dwYzi6pVz+tsD5lUV8PukNvouJ04gTxK9xVfpIoNKEIAzGAQ2RaOFVJ8L4LQOumQ4l5j7G0j8z7SIIUTHgejesdRB0EKLLzmVhKYAdztEjmH9oS5wu/LBe4NRchBZgNYcY0TUGG+KE2eLUz01oFcOjiCjgTchwVKvifyxT093fRt7OUBsF1z4Pvbxy6nSS0nKzWaFHjIvk+ZOnlODjY8fMtjG6MPw86uwPV8N9+ERJ1clTt2Y2nMUITix0GbCFRv7VK1iPCkf8GZQx9RfrNdZlSFXwOWn1TkTe8HhjHIsURNLiRf5SpR//xmJYI7cyhTtP1rFhZAhVKk83PHRLlNlyNGpzdwI6s52wNTRcaiV0WZhE2dA2hM5DnGK935nxQf2Myae4JQyKEAQl3iDys6NNrp0jmZmAOQEtlsU/b0RqnUlAjBNBXnqI+nf7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

There are a few problems with the current freeing of swap entries.

When freeing a set of swap entries directly (swap_put_entries_direct,
typically from zapping the page table), it scans the whole swap region
multiple times. First, it scans the whole region to check if it can be
batch freed and if there is any cached folio. Then do a batch free only
if the whole region's swap count equals 1. And if any entry is cached,
even if only one, it will have to walk the whole region again to clean
up the cache.

And if any entry is not in a consistent status with other entries, it
will fall back to order 0 freeing. For example, if only one of them is
cached, the batch free will fall back.

And the current batch freeing workflow relies on the swap map's
SWAP_HAS_CACHE bit for both continuous checking and batch freeing, which
isn't compatible with the swap table design.

Tidy this up, introduce a new cluster scoped helper for all swap entry
freeing job. It will batch frees all continuous entries, and just start
a new batch if any inconsistent entry is found. This may improve the
batch size when the clusters are fragmented. This should also be more
robust with more sanity checks, and make it clear that a slot pinned by
swap cache will be cleared upon cache reclaim.

And the cache reclaim scan is also now limited to each cluster. If a
cluster has any clean swap cache left after putting the swap count,
reclaim the cluster only instead of the whole region.

And since a folio's entries are always in the same cluster, putting swap
entries from a folio can also use the new helper directly.

This should be both an optimization and a cleanup, and the new helper is
adapted to the swap table.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 238 +++++++++++++++++++++++-----------------------------------
 1 file changed, 96 insertions(+), 142 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3b7df5768d7f..12a1ab6f7b32 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -55,12 +55,14 @@ static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
 static void free_swap_count_continuations(struct swap_info_struct *);
 static void swap_entries_free(struct swap_info_struct *si,
 			      struct swap_cluster_info *ci,
-			      swp_entry_t entry, unsigned int nr_pages);
+			      unsigned long start, unsigned int nr_pages);
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr);
-static bool swap_entries_put_map(struct swap_info_struct *si,
-				 swp_entry_t entry, int nr);
+static void swap_put_entry_locked(struct swap_info_struct *si,
+				  struct swap_cluster_info *ci,
+				  unsigned long offset,
+				  unsigned char usage);
 static bool folio_swapcache_freeable(struct folio *folio);
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
@@ -197,25 +199,6 @@ static bool swap_only_has_cache(struct swap_info_struct *si,
 	return true;
 }
 
-static bool swap_is_last_map(struct swap_info_struct *si,
-		unsigned long offset, int nr_pages, bool *has_cache)
-{
-	unsigned char *map = si->swap_map + offset;
-	unsigned char *map_end = map + nr_pages;
-	unsigned char count = *map;
-
-	if (swap_count(count) != 1)
-		return false;
-
-	while (++map < map_end) {
-		if (*map != count)
-			return false;
-	}
-
-	*has_cache = !!(count & SWAP_HAS_CACHE);
-	return true;
-}
-
 /*
  * returns number of pages in the folio that backs the swap entry. If positive,
  * the folio was reclaimed. If negative, the folio was not reclaimed. If 0, no
@@ -1420,6 +1403,76 @@ static bool swap_sync_discard(void)
 	return false;
 }
 
+/**
+ * swap_put_entries_cluster - Decrease the swap count of a set of slots.
+ * @si: The swap device.
+ * @start: start offset of slots.
+ * @nr: number of slots.
+ * @reclaim_cache: if true, also reclaim the swap cache.
+ *
+ * This helper decreases the swap count of a set of slots and tries to
+ * batch free them. Also reclaims the swap cache if @reclaim_cache is true.
+ * Context: The caller must ensure that all slots belong to the same
+ * cluster and their swap count doesn't go underflow.
+ */
+static void swap_put_entries_cluster(struct swap_info_struct *si,
+				     unsigned long start, int nr,
+				     bool reclaim_cache)
+{
+	unsigned long offset = start, end = start + nr;
+	unsigned long batch_start = SWAP_ENTRY_INVALID;
+	struct swap_cluster_info *ci;
+	bool need_reclaim = false;
+	unsigned int nr_reclaimed;
+	unsigned long swp_tb;
+	unsigned int count;
+
+	ci = swap_cluster_lock(si, offset);
+	do {
+		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+		count = si->swap_map[offset];
+		VM_WARN_ON(swap_count(count) < 1 || count == SWAP_MAP_BAD);
+		if (swap_count(count) == 1) {
+			/* count == 1 and non-cached slots will be batch freed. */
+			if (!swp_tb_is_folio(swp_tb)) {
+				if (!batch_start)
+					batch_start = offset;
+				continue;
+			}
+			/* count will be 0 after put, slot can be reclaimed */
+			VM_WARN_ON(!(count & SWAP_HAS_CACHE));
+			need_reclaim = true;
+		}
+		/*
+		 * A count != 1 or cached slot can't be freed. Put its swap
+		 * count and then free the interrupted pending batch. Cached
+		 * slots will be freed when folio is removed from swap cache
+		 * (__swap_cache_del_folio).
+		 */
+		swap_put_entry_locked(si, ci, offset, 1);
+		if (batch_start) {
+			swap_entries_free(si, ci, batch_start, offset - batch_start);
+			batch_start = SWAP_ENTRY_INVALID;
+		}
+	} while (++offset < end);
+
+	if (batch_start)
+		swap_entries_free(si, ci, batch_start, offset - batch_start);
+	swap_cluster_unlock(ci);
+
+	if (!need_reclaim || !reclaim_cache)
+		return;
+
+	offset = start;
+	do {
+		nr_reclaimed = __try_to_reclaim_swap(si, offset,
+						     TTRS_UNMAPPED | TTRS_FULL);
+		offset++;
+		if (nr_reclaimed)
+			offset = round_up(offset, abs(nr_reclaimed));
+	} while (offset < end);
+}
+
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
@@ -1521,6 +1574,7 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
 {
 	swp_entry_t entry = folio->swap;
 	unsigned long nr_pages = folio_nr_pages(folio);
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
@@ -1530,7 +1584,7 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
 		nr_pages = 1;
 	}
 
-	swap_entries_put_map(__swap_entry_to_info(entry), entry, nr_pages);
+	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
 }
 
 static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
@@ -1567,12 +1621,11 @@ static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 	return NULL;
 }
 
-static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
-					   struct swap_cluster_info *ci,
-					   swp_entry_t entry,
-					   unsigned char usage)
+static void swap_put_entry_locked(struct swap_info_struct *si,
+				  struct swap_cluster_info *ci,
+				  unsigned long offset,
+				  unsigned char usage)
 {
-	unsigned long offset = swp_offset(entry);
 	unsigned char count;
 	unsigned char has_cache;
 
@@ -1598,9 +1651,7 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
 	if (usage)
 		WRITE_ONCE(si->swap_map[offset], usage);
 	else
-		swap_entries_free(si, ci, entry, 1);
-
-	return usage;
+		swap_entries_free(si, ci, offset, 1);
 }
 
 /*
@@ -1668,70 +1719,6 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 }
 
-static bool swap_entries_put_map(struct swap_info_struct *si,
-				 swp_entry_t entry, int nr)
-{
-	unsigned long offset = swp_offset(entry);
-	struct swap_cluster_info *ci;
-	bool has_cache = false;
-	unsigned char count;
-	int i;
-
-	if (nr <= 1)
-		goto fallback;
-	count = swap_count(data_race(si->swap_map[offset]));
-	if (count != 1)
-		goto fallback;
-
-	ci = swap_cluster_lock(si, offset);
-	if (!swap_is_last_map(si, offset, nr, &has_cache)) {
-		goto locked_fallback;
-	}
-	if (!has_cache)
-		swap_entries_free(si, ci, entry, nr);
-	else
-		for (i = 0; i < nr; i++)
-			WRITE_ONCE(si->swap_map[offset + i], SWAP_HAS_CACHE);
-	swap_cluster_unlock(ci);
-
-	return has_cache;
-
-fallback:
-	ci = swap_cluster_lock(si, offset);
-locked_fallback:
-	for (i = 0; i < nr; i++, entry.val++) {
-		count = swap_entry_put_locked(si, ci, entry, 1);
-		if (count == SWAP_HAS_CACHE)
-			has_cache = true;
-	}
-	swap_cluster_unlock(ci);
-	return has_cache;
-}
-
-/*
- * Only functions with "_nr" suffix are able to free entries spanning
- * cross multi clusters, so ensure the range is within a single cluster
- * when freeing entries with functions without "_nr" suffix.
- */
-static bool swap_entries_put_map_nr(struct swap_info_struct *si,
-				    swp_entry_t entry, int nr)
-{
-	int cluster_nr, cluster_rest;
-	unsigned long offset = swp_offset(entry);
-	bool has_cache = false;
-
-	cluster_rest = SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER;
-	while (nr) {
-		cluster_nr = min(nr, cluster_rest);
-		has_cache |= swap_entries_put_map(si, entry, cluster_nr);
-		cluster_rest = SWAPFILE_CLUSTER;
-		nr -= cluster_nr;
-		entry.val += cluster_nr;
-	}
-
-	return has_cache;
-}
-
 /*
  * Check if it's the last ref of swap entry in the freeing path.
  */
@@ -1746,9 +1733,9 @@ static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
  */
 static void swap_entries_free(struct swap_info_struct *si,
 			      struct swap_cluster_info *ci,
-			      swp_entry_t entry, unsigned int nr_pages)
+			      unsigned long offset, unsigned int nr_pages)
 {
-	unsigned long offset = swp_offset(entry);
+	swp_entry_t entry = swp_entry(si->type, offset);
 	unsigned char *map = si->swap_map + offset;
 	unsigned char *map_end = map + nr_pages;
 
@@ -1954,10 +1941,8 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 {
 	const unsigned long start_offset = swp_offset(entry);
 	const unsigned long end_offset = start_offset + nr;
+	unsigned long offset, cluster_end;
 	struct swap_info_struct *si;
-	bool any_only_cache = false;
-	unsigned long offset;
-	unsigned long swp_tb;
 
 	si = get_swap_device(entry);
 	if (WARN_ON_ONCE(!si))
@@ -1965,44 +1950,13 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 	if (WARN_ON_ONCE(end_offset > si->max))
 		goto out;
 
-	/*
-	 * First free all entries in the range.
-	 */
-	any_only_cache = swap_entries_put_map_nr(si, entry, nr);
-
-	/*
-	 * Short-circuit the below loop if none of the entries had their
-	 * reference drop to zero.
-	 */
-	if (!any_only_cache)
-		goto out;
-
-	/*
-	 * Now go back over the range trying to reclaim the swap cache.
-	 */
-	for (offset = start_offset; offset < end_offset; offset += nr) {
-		nr = 1;
-		swp_tb = swap_table_get(__swap_offset_to_cluster(si, offset),
-					offset % SWAPFILE_CLUSTER);
-		if (!swap_count(READ_ONCE(si->swap_map[offset])) && swp_tb_is_folio(swp_tb)) {
-			/*
-			 * Folios are always naturally aligned in swap so
-			 * advance forward to the next boundary. Zero means no
-			 * folio was found for the swap entry, so advance by 1
-			 * in this case. Negative value means folio was found
-			 * but could not be reclaimed. Here we can still advance
-			 * to the next boundary.
-			 */
-			nr = __try_to_reclaim_swap(si, offset,
-						   TTRS_UNMAPPED | TTRS_FULL);
-			if (nr == 0)
-				nr = 1;
-			else if (nr < 0)
-				nr = -nr;
-			nr = ALIGN(offset + 1, nr) - offset;
-		}
-	}
-
+	/* Put entries and reclaim cache in each cluster */
+	offset = start_offset;
+	do {
+		cluster_end = min(round_up(offset + 1, SWAPFILE_CLUSTER), end_offset);
+		swap_put_entries_cluster(si, offset, cluster_end - offset, true);
+		offset = cluster_end;
+	} while (offset < end_offset);
 out:
 	put_swap_device(si);
 }
@@ -2051,7 +2005,7 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 		return;
 
 	ci = swap_cluster_lock(si, offset);
-	swap_entry_put_locked(si, ci, entry, 1);
+	swap_put_entry_locked(si, ci, offset, 1);
 	WARN_ON(swap_entry_swapped(si, offset));
 	swap_cluster_unlock(ci);
 
@@ -3799,10 +3753,10 @@ void __swapcache_clear_cached(struct swap_info_struct *si,
 			      swp_entry_t entry, unsigned int nr)
 {
 	if (swap_only_has_cache(si, swp_offset(entry), nr)) {
-		swap_entries_free(si, ci, entry, nr);
+		swap_entries_free(si, ci, swp_offset(entry), nr);
 	} else {
 		for (int i = 0; i < nr; i++, entry.val++)
-			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
+			swap_put_entry_locked(si, ci, swp_offset(entry), SWAP_HAS_CACHE);
 	}
 }
 
@@ -3923,7 +3877,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
  * into, carry if so, or else fail until a new continuation page is allocated;
  * when the original swap_map count is decremented from 0 with continuation,
  * borrow from the continuation and report whether it still holds more.
- * Called while __swap_duplicate() or caller of swap_entry_put_locked()
+ * Called while __swap_duplicate() or caller of swap_put_entry_locked()
  * holds cluster lock.
  */
 static bool swap_count_continued(struct swap_info_struct *si,

-- 
2.51.1


