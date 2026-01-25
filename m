Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0AA6E63CAC
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 17:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173CF6B0098; Sun, 25 Jan 2026 12:58:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144A76B0099; Sun, 25 Jan 2026 12:58:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067FC6B009B; Sun, 25 Jan 2026 12:58:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E8D866B0098
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:58:42 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 77A08160577
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:42 +0000 (UTC)
X-FDA: 84371246484.12.0F1F3A5
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 89BB54000C
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f4qU+Zsv;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769363920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBjV8XyXDLoEReDqKUKA22e4GI0fZeu23FHRrREbJdM=;
	b=6veQaFwMe4pnlLFqlaTuMpEtvF8OMFJFWlkLxIbaw4bfecV6G65Q175od1W9wqE1J75BLZ
	x/STb0+CsKLm1bv8lp1k6tqNO58x89+m9FhmgKlW1g5gy+a7yBDv7hYW+zi2Lbtlj0pvLL
	LBKl1UnbpNbkHX2Nr0DhhZW4WKiyDZM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f4qU+Zsv;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769363920; a=rsa-sha256;
	cv=none;
	b=dObWQP+YyUhQ0U5yEJlyPdQvaMQmmV6yAVHqycE1kG+t/X64aEDsQgZnNuznHTB4c9qq4c
	3UhXFgDTNeBTehuRGEdWVcJ3+z9JuZvBk28bkIHmnPOwHBDUXRDNFHDA30ndAS2rqW62nQ
	xyWj21WiZDPLyvisp44kNoADZ1X3DiQ=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-352e2c59264so2712570a91.0
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769363919; x=1769968719; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bBjV8XyXDLoEReDqKUKA22e4GI0fZeu23FHRrREbJdM=;
        b=f4qU+ZsvSKx2V2PYMaU4r6eo8aiVOv+uvecr+A2rVRJ7yQ+fYqudD06kzXX1C7znAH
         RWYwHo9IqsUKMKiQun11d5MBXyB6EVj/ZioZNeYvGBdAq7K2itGs5RN2qFYymmeVX6lq
         sNpVIntJzHATlRVpo5pPCtpFpeOJ/6GGyGxPGZBUvnxyLYmDn7AfilUSaF4FTyblxvAw
         CsgRayIBGAMLyGFUhTS0QiNGNrqpAmWzmc68HO6thZe37VOXRH/GRZh8wG0pudfKWRl2
         pdrwm3qFl6OOL1z2rZ5c7vqcAxD1iNSbptY/up9rv4N+1uozf7jqaZWAOiZ2D9m7qJpx
         ipnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769363919; x=1769968719;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bBjV8XyXDLoEReDqKUKA22e4GI0fZeu23FHRrREbJdM=;
        b=DLhYI9Fh1YbKXGda6RNAmyhIQWvzfJNJI/8jqHO+TOMGHDbcQbWn64LWjf2dUTH9/x
         dbNI9umL4FyGVL0tniOJquoArY+pi4nnGiQ+SVkoRZLafZ6WbJroZNinalmHVXi1BHGG
         fw13p0e6s7PqC4pGuhbN/fbALms/+oHax7+zMANfmRkecFd4WyDfbNnFD0uM4MXSuY76
         3wWXSBB17l+tpMdrQQi+FTccY3Lz2F9eBHKc4ru6a0xkjs2xgqXBKc98UUtJQFJHreT8
         MSZKfbRZC3mMEPY0OxNkXPugyCN6+DM9F9Zo+7IvhMcozCwt+5CN7HJ4Cq/sitLgaFip
         LzBQ==
X-Gm-Message-State: AOJu0YwySTin3qQ7jdv+CrT5dEmZNQOl0rxx6AjVu/T6QVwKIr/y0kqS
	Ph8itvddmIy/FGe2hGYy9Jrcrzx8w0tiCDfgyJc0WDpbC0tnmJcEdDj0
X-Gm-Gg: AZuq6aK2ePKOdFzwTonDclbyRkuBMiA42jDOyzAFrGSu8+XDwiizAiNLYFrvlKFVSWr
	OpY+dWqjkriSYsIBCOdFC8Kx2kGOsxH/qcFxLzVYiDCRUiwn1wz/EWeLMRmGJICu48FhWg74Skx
	J8xh83gIPT3G7XM+8vWP2faLuVDDJXyOFaHt8o8kDkWZXcB1ZjYcupvu+PfmPuA0z1m9qfiZhUH
	5HQOeYeVKQnlme9l4zJoqL3dRy1vKPLU28fEbgu1UVLFy7hdxx/9cKYeWYl8ec9V9TGi35XAXnl
	4ZOwavH76aWjCK6+/LEl3+EWOQxdbAgxAWAJXPEO/UqdlSC//1PSaiQgPjTwboMIkwumugCW/D9
	m8XUxQS1nF/m8vaOJYoX5Po+1AJFSfElTUlAySCjUtT9QnWzU/W5yhQEjT7Oy8tbLJxO6QBaEq/
	xfvSKgndar1QPbRmqQNwemJDNT7khniTO5OQ7hm6EDwcDryPDG
X-Received: by 2002:a17:90b:548e:b0:33b:b020:597a with SMTP id 98e67ed59e1d1-353c3fde050mr1632030a91.0.1769363919442;
        Sun, 25 Jan 2026 09:58:39 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e718sm7405963b3a.62.2026.01.25.09.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 09:58:38 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 26 Jan 2026 01:57:31 +0800
Subject: [PATCH 08/12] mm, swap: simplify swap table sanity range check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-swap-table-p3-v1-8-a74155fab9b0@tencent.com>
References: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
In-Reply-To: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769363877; l=3805;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=xEm9vmKYs9I8cGuUNSJYWeygrYtNmSS9LIdq7v6ecsc=;
 b=FCG72J3dYPeMjzlN2+p8N1F/IqZer4WAcNKJ/kLqN0BHkotDArPvXlR/hYqlVNWS4glF2dlTS
 4NngxeKIwoFAIxg4FABZHBfwqiOh6oBbVULHlPkJ/sDZnYU4wNVFokZ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 89BB54000C
X-Stat-Signature: ec75e73zgskx1m4dbf7so4bh3zhjrcxj
X-Rspam-User: 
X-HE-Tag: 1769363920-566292
X-HE-Meta: U2FsdGVkX1+J4ePlsqoYGizL2XfuZ5HmduI0LF/W93QkcI1t4kzFkrGOALH4UMaaiTUp9MsgzvC6TGnZEwuElvVQpPRaYbbMGh3d3qYDdDw4spfaWi+0/9wC0aNCw7GclqSwEr8P4iFdrSxYo90cGEuHgo39Q9fOs9ByrtD7wREw8w81balpIFTFEmZQDWWsaZ07FsHNEv95E3+iTs++7sWBaXVoZsph1i7vBY4KPXm6NOfpxeplaQxpR59sgm0Q+MXF0mDIKbmqRGMRf3qESwde82/8y1SWHxqaob4DAXcFcdMXn9o3Af5Bc8dMMa5OTbD9spvR9ZGubYke9pnh10KxZ9j9NO35jlR2tC8rYy1qhO4rS9nhycmxC15NemQ+9xueKppg4xwKT6/S/anDc9TDLRvHqRU23P4YRjioGfp/lcjODTDD3oIH43Aa+MXATp3HVePWcNU4LbabuT93XuVzTSClNVWPJONUGX+208qiSiu+wnkC2w9TqcuHet6u0KwsSGJ3YozHPoshjTkI+M4p+PLI76cRiGz4majOn2pAXWhS7oUjxhpMlXUzYk6RXAjWKQgW/s2sn1poQcCUUHS/++W4JsEqyXnWViVEpyGQiFY11AXAOOqetJlSgWOfSmJpnqUL7vMeJBR92plCmYhG+ixzpv3s8MkJPS5LL68729YrUrCVu//mAd3Nkb8yt1Ov/Jfvh4v0QrracqkgiQESI1uf2fS87HXSM9nMvTv27ijf2vVgewN8T8gMREKokUG+CaXhyuLH/p1mkVCXLWUpmsO2lP76Bbc+QKtYAwv3NNRibH+Chw/V/7IdnQ4LUhLZee2KAXAd4Fo8eWub1GsJxOAFH++hXreNfUrbYc11kkon0c+rt71eIGSe87Yo6q4YGCis4JETekPF3lw7xG647dbvHvJ+h5rhF9m4CrzoMe5ZM+u3MmgAmwnMY0Fh24AXjsP6KpCWVu59hfg
 wEnVbkuV
 W7P359/UDg16Hfd+Ny8NomG5eNT6qgxdVcp798sPgctKkr6KTk5WJWTd8QJzXxkOscw3LRfMTUr3SCKSO1tWBhhiraVY3wD9ypERTSydWceOE7QZK+xl7XNQcNwHOuM4ePBUV03Ip5wWx+9zCzC6vupo9/nGo2DRDUy0/uEBkkF1pEkyuDyL/gAuU9+fJS5R16XikxJbxBfcp8gO5fJOAGXU6SNmRA5QWiPtfm9T2qACuPnH8xFeqGNu5tHpZimRmBJD5Cnkncnm4tAHVrKnkDVinlM3LLQq4mP+p3tj2r65Sao7evIof/Sks5f+ed3Ft4ViIs61qfSkz//Q3+OuG5p+OU3I6TdFQSEt5P/EP19SD8EVvX8PtQ6qRtqddoEBqBS1j5HW099COv4jIuqQdiabbngNT4LfuyUE3CD4e9w23Jpw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The newly introduced helper, which checks bad slots and emptiness of a
cluster, can cover the older sanity check just fine, with a more
rigorous condition check. So merge them.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index bdce2abd9135..968153691fc4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -459,9 +459,11 @@ static void swap_table_free(struct swap_table *table)
  * One special case is that bad slots can't be freed, so check the number of
  * bad slots for swapoff, and non-swapoff path must never free bad slots.
  */
-static void swap_cluster_assert_empty(struct swap_cluster_info *ci, bool swapoff)
+static void swap_cluster_assert_empty(struct swap_cluster_info *ci,
+				      unsigned int ci_off, unsigned int nr,
+				      bool swapoff)
 {
-	unsigned int ci_off = 0, ci_end = SWAPFILE_CLUSTER;
+	unsigned int ci_end = ci_off + nr;
 	unsigned long swp_tb;
 	int bad_slots = 0;
 
@@ -588,7 +590,7 @@ static void swap_cluster_schedule_discard(struct swap_info_struct *si,
 
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
-	swap_cluster_assert_empty(ci, false);
+	swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, false);
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
@@ -898,26 +900,6 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 	return true;
 }
 
-/*
- * Currently, the swap table is not used for count tracking, just
- * do a sanity check here to ensure nothing leaked, so the swap
- * table should be empty upon freeing.
- */
-static void swap_cluster_assert_table_empty(struct swap_cluster_info *ci,
-				unsigned int start, unsigned int nr)
-{
-	unsigned int ci_off = start % SWAPFILE_CLUSTER;
-	unsigned int ci_end = ci_off + nr;
-	unsigned long swp_tb;
-
-	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
-		do {
-			swp_tb = __swap_table_get(ci, ci_off);
-			VM_WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
-		} while (++ci_off < ci_end);
-	}
-}
-
 static bool cluster_alloc_range(struct swap_info_struct *si,
 				struct swap_cluster_info *ci,
 				struct folio *folio,
@@ -943,13 +925,14 @@ static bool cluster_alloc_range(struct swap_info_struct *si,
 	if (likely(folio)) {
 		order = folio_order(folio);
 		nr_pages = 1 << order;
+		swap_cluster_assert_empty(ci, offset % SWAPFILE_CLUSTER, nr_pages, false);
 		__swap_cache_add_folio(ci, folio, swp_entry(si->type, offset));
 	} else if (IS_ENABLED(CONFIG_HIBERNATION)) {
 		order = 0;
 		nr_pages = 1;
 		WARN_ON_ONCE(si->swap_map[offset]);
 		si->swap_map[offset] = 1;
-		swap_cluster_assert_table_empty(ci, offset, 1);
+		swap_cluster_assert_empty(ci, offset % SWAPFILE_CLUSTER, 1, false);
 	} else {
 		/* Allocation without folio is only possible with hibernation */
 		WARN_ON_ONCE(1);
@@ -1768,7 +1751,7 @@ void swap_entries_free(struct swap_info_struct *si,
 
 	mem_cgroup_uncharge_swap(entry, nr_pages);
 	swap_range_free(si, offset, nr_pages);
-	swap_cluster_assert_table_empty(ci, offset, nr_pages);
+	swap_cluster_assert_empty(ci, offset % SWAPFILE_CLUSTER, nr_pages, false);
 
 	if (!ci->count)
 		free_cluster(si, ci);
@@ -2769,7 +2752,7 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 		/* Cluster with bad marks count will have a remaining table */
 		spin_lock(&ci->lock);
 		if (rcu_dereference_protected(ci->table, true)) {
-			swap_cluster_assert_empty(ci, true);
+			swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, true);
 			swap_cluster_free_table(ci);
 		}
 		spin_unlock(&ci->lock);

-- 
2.52.0


