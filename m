Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FF98CD343F
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6AE6B00CD; Tue,  5 May 2026 11:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348F86B00CC; Tue,  5 May 2026 11:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EA0A6B00CD; Tue,  5 May 2026 11:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 068336B00CB
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C54F9A0340
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:45 +0000 (UTC)
X-FDA: 84733776330.16.FD81BD6
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id A1E241C0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sds2NZe7;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QWvdPKMg7g8G8dTLNP+8rI3pQ34MBTFQ7Q5I5n1zybM=;
	b=ouuDSlhuJEHgruHr53j2kc2XHby3cge8LzXV7O2hBqDQIFi3LdkY441nHENwgPFu2oIQ7f
	rw1T11pQk7n87KQzb2RqP7g1IXTQS3nbAh1hi3AMnF5mZEQ1ZtmimuQMoNJ9bP+l3Iu3xX
	O+tXZLhxM0l7pEWKKo1PphjkRFLEA/M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sds2NZe7;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995583; a=rsa-sha256;
	cv=none;
	b=byXpHNUfGdAiCYd0YqkT8+lVmkUoAdPkiwWDf0SlqMtTY7ScO/ZZws4Wfwb12Y+oHhI6gR
	wsmHxHBNbZRd+3zS7IkkmIderaiNqQcZy17QK4mFztBWHzvgIKJs67ash4wokgREFpSgIc
	ZLpJNMC/Nbac/ZMdys4I7x22wL+4ezM=
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-479ef2b78f3so4093018b6e.2
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995583; x=1778600383; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QWvdPKMg7g8G8dTLNP+8rI3pQ34MBTFQ7Q5I5n1zybM=;
        b=Sds2NZe7dnPYgKKbkU4HvbR03VUu6GmDuCW/0+Ikl5tMgcnnRr12EBLZWTtYi5O8x1
         Reck1EflPfqK8XhECzcmeh3GGC2YPNiOyQeeCODXQMyIRMFaBpuEv1pf9mXmt25O+54E
         rGZBIVC5wyPdzackRKHR2+8qd/tZr9QGCvKVicGWNXorJYGsZtxq0LVCeu5EsuzftUPy
         2IdeiyQQVjzbs1Lt1HyWIi5aezBYqAXt30XgpJ8NGYD3WPp/BXvG8b0U4M6vE0HJdeeM
         iIBFVd0LR6wO5dcF/CzGagzu7XRi7hVCgnqiLMBYS6tZo/LBpJMd/koEg3b7YIlFATHZ
         OyIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995583; x=1778600383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QWvdPKMg7g8G8dTLNP+8rI3pQ34MBTFQ7Q5I5n1zybM=;
        b=mIp6rGJRCe7gCnijAdr6Iv8NHNb5UBbJj9UYo0Vrch4cKneD/ijTe1//QmnGCPoYed
         +qgFEc8R8VbM2n8e6/Uk3OgQp6R+6+9k3lECzCt5JYj8WNyxbAmnzngFJBPua6buiW5c
         UT5sekbXXYAYLKWYSwphI+va1IIi4WK9M69GZOjmK/yDOhtUPQ/zzW45+DSteUXtgL+L
         oUQuyGeA/u5G8tQ7WzqwXx2bQHdm7YERQJmcje+now049HAE+9N+Crr9ldNV3GWaUcDK
         XOeW/yYJGApOzB0r/PiktcZ0PhRURbxPNSN5kU1AjuLJxKY7ZHmsgzWqNh3fkRlCDXW3
         kysw==
X-Forwarded-Encrypted: i=1; AFNElJ/DVIh/SuXjX+s5HvlUVwswe0V5LTapzvCsq4oFsH5uJWaDyBxWjlyHz3QZuJAgbu3T9hA5lLcJWg==@kvack.org
X-Gm-Message-State: AOJu0YyfDlcXYSD5Z6tEgH6v+tPtNnhoBPfFTpwWl1jlsNkJZytV9WRu
	W+slI6C4Yox2IYE7ftI5t0rykziIWZdNJVwTPBe/CQrk+nPMntW+I2ii
X-Gm-Gg: AeBDievzvbKcMI3Jmp+0vXKXNkfa8t+tm7h4EVd2HkqA4DONMwkXd8uqYdTyQh/PmLd
	qusq3YlsjRPl3YISli6dvbSMceyn6oGxOxWRxH4K02oCuZpX/S4IzDK/ikNz/JlhfMEgkAkqts6
	JGWXvnjWBi9SnTWLi/CzDECvpvwf5h9tbVE1v33apL+3jkedSbySGGR5RRNc57BJZt5ys/SIrEM
	OZwncJm3gTd4lfOOu1xeMGRaTF6A/XUNtmG+YFQ0ZDq7B8k6RYyuVfVgJcldmSEyXEz/dR7KQiN
	hHvgwUubdTFDDzLCmwZip7evTmgnoqpqMVFzUXzQju6/qdscU9NbxPeQDPa9mLj9dU+L3dGvJgk
	4s3HfamlyQF2b/P3kyv4r3ugeYJJAEFfdaA668+ETOv0r1dEJH/g+n1bRxc7e2ZYeEvXGwUAbjf
	W6S7d+pHyjRfB6vistJNeKyp2QiCvk3PS1/xHAKjF/e+Lne2L1At37Whqg
X-Received: by 2002:a05:6808:3006:b0:479:dcb1:dd0b with SMTP id 5614622812f47-47c892a59fcmr6977167b6e.32.1777995582553;
        Tue, 05 May 2026 08:39:42 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:51::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c763b32dbsm8934523b6e.3.2026.05.05.08.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:41 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com,
	haowenchao22@gmail.com
Subject: [PATCH v6 20/22] swapfile: replace the swap map with bitmaps
Date: Tue,  5 May 2026 08:38:49 -0700
Message-ID: <20260505153854.1612033-21-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A1E241C0005
X-Stat-Signature: meezia7qkhjd9rtchib69cuiu6rpexi8
X-HE-Tag: 1777995583-514813
X-HE-Meta: U2FsdGVkX18jMsDY8yYMmAdrpACDUepNz30zZqryBJGrzqmIWL8VcF3behjJ2uJUW9oVje50N4dGYmDYs6D8uSZYjWJKjFeMZok0QvAHoVT43uSnEWsGpz048JNkoDk7IYs7U790gauHmivP7RoXdXyOwTDlHIRRx0Ed7PIXd4z+YTLIF3OGdYzlloDN0OgUg3VuU3Ne0Qf5m4hy4b0v0Z/lx1JZlIYxjdX4N5g5I9+Ays99pUeFGTBW9iVyRUcc2v/PJIDQNRmaWoqA7pOzO7msOHRDyPgIY12mlu5VuzRKV8pUchcw4/0kYGDqkCGfz6GUzhrCN6EDSz4T+AfNdgFYW8NnA8NeB+VROcrXdYhaQc2StaUjKFSm4n0Km3VKFjaBNY9hnPujMfPrwwokmBiEn5054TqvhRexuD+5yiiYkK2McnIUD3gweX+Q0xCw5CrZlvNi30tLRqgcSB4cEEQAj/h7KL+KXxDIpydLQjny65SVodsq8AbM31ovZKW0XddL0imZvO0fS1HtigEVeVJCN1ko1xFdxv2FE87EyShxbFGD+lIYpSOOzf53ZuhGH7+J3iDatIpSwADNwUi1iPguRwBmhOO5VdNCSEM4C/0paoV33OTjZjYbskk1Zmp/3tnYSP6hPTaBCGoU9N6ZBTCFRoxCthD7EaPc1Z6TTJSdmkeNgSrEJcNaHGRjDRNdu3EjpKOw3pmQWN79OEz1YShm+mcK5fBkXY5aT2ctN4oQEbP1W9c302nx9Z/NoU71nm2oOOSOLYJGMeNJujp/zeHZ447zSRXeSqUn+/AW4OxCt4BozKsDxYYa4nbm+UBsj+c7J++PBwzWYcE/BCBoeod2LLHcSSjHFHB1ZKfbaTHHg4fWCTwM1Vz6z2p6MSfGbSWcCORJQXhjG0c/pmzK+DwTyFM7wOC+iIGS6MZoXPZSA4erdLlzsW/qEEtJRgF9DPRTiGyItkIhEkWDuio
 ZgScq6gS
 2Wzhm9Q/5mgg2mh6peFXjj0UrSa22zx3snh9pNx7YHzMvDngVbkj3Gq3aLHOSZ4dP6D7lu3GcscvhrYNPSaeC0B5KDlERz3S38q84fUiO8PXvHzM27m9NNEVmF8ePryCWgf38SeYbtU1gU/E9dRiKcN4tozQ2nuhWhL9OHsAIApffySxJVzbIBYyKndUDlF1lRUDzM+Igd3iG3Se3+jUqRl4OHQWcIflA7NxSoYuh6ftPXc0rA/D0ZiYuAEa6fDPS60/zAF53YMrJLPOh3wuc5wt6YJ7CHL28/YPMARxtmYv4Z4YVwh6EVkCGi49VUwCUPX+PyMP+WrV0GVztcAlpGTcI81NpqyajoZtcNG1RsZ0hl0b39Oq0EknikyqhvNce5m+7f8Oy+xaLsGQtSnsb5opSjMmK5k5b1GwvZVBGtCMoZMNY/wVwKcJ/9SX8dlRdaVRxf/ttO5nMHkP7ZUCkVenEORmX/9FJfx1aa2yyfK4Nwfz6NkjzESM/6sYTq1zG4VHSP2/Wo7JmzphC6ASSQwMgAneQ5/w8nI5HRgZ0VzDCbVDwze5eryXkeXvk1XPF2YxCyjfcOgMl7GtNwd5lM30VZJEkCatyzNSJ/+iflubP1Epv6pJACycgKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we have moved the swap count state to virtual swap layer, each
swap map entry only has 3 possible states: free, allocated, and bad.
Replace the swap map with 2 bitmaps (one for allocated state and one for
bad state), saving 6 bits per swap entry.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h |  3 +-
 mm/swapfile.c        | 81 +++++++++++++++++++++++---------------------
 2 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index ad5f59c807c6..aac9971633f2 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -259,7 +259,8 @@ struct swap_info_struct {
 	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* extent of the swap_map */
-	unsigned char *swap_map;	/* vmalloc'ed array of usage counts */
+	unsigned long *swap_map;	/* bitmap for allocated state */
+	unsigned long *bad_map;		/* bitmap for bad state */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 701bc80bc381..b5b126904d20 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -767,25 +767,19 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
 				  unsigned long start, unsigned long end)
 {
-	unsigned char *map = si->swap_map;
 	unsigned long offset = start;
 	int nr_reclaim;
 
 	spin_unlock(&ci->lock);
 	do {
-		switch (READ_ONCE(map[offset])) {
-		case 0:
+		if (!test_bit(offset, si->swap_map)) {
 			offset++;
-			break;
-		case SWAP_MAP_ALLOCATED:
+		} else {
 			nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
 			if (nr_reclaim > 0)
 				offset += nr_reclaim;
 			else
 				goto out;
-			break;
-		default:
-			goto out;
 		}
 	} while (offset < end);
 out:
@@ -794,11 +788,7 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 	 * Recheck the range no matter reclaim succeeded or not, the slot
 	 * could have been be freed while we are not holding the lock.
 	 */
-	for (offset = start; offset < end; offset++)
-		if (READ_ONCE(map[offset]))
-			return false;
-
-	return true;
+	return find_next_bit(si->swap_map, end, start) >= end;
 }
 
 static bool cluster_scan_range(struct swap_info_struct *si,
@@ -807,15 +797,16 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 			       bool *need_reclaim)
 {
 	unsigned long offset, end = start + nr_pages;
-	unsigned char *map = si->swap_map;
-	unsigned char count;
 
 	if (cluster_is_empty(ci))
 		return true;
 
 	for (offset = start; offset < end; offset++) {
-		count = READ_ONCE(map[offset]);
-		if (!count)
+		/* Bad slots cannot be used for allocation */
+		if (test_bit(offset, si->bad_map))
+			return false;
+
+		if (!test_bit(offset, si->swap_map))
 			continue;
 
 		if (swap_cache_only(si, offset)) {
@@ -848,7 +839,7 @@ static bool cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster
 	if (cluster_is_empty(ci))
 		ci->order = order;
 
-	memset(si->swap_map + start, usage, nr_pages);
+	bitmap_set(si->swap_map, start, nr_pages);
 	swap_range_alloc(si, nr_pages);
 	ci->count += nr_pages;
 
@@ -1414,7 +1405,7 @@ static struct swap_info_struct *_swap_info_get(swp_slot_t slot)
 	offset = swp_slot_offset(slot);
 	if (offset >= si->max)
 		goto bad_offset;
-	if (data_race(!si->swap_map[swp_slot_offset(slot)]))
+	if (data_race(!test_bit(offset, si->swap_map)))
 		goto bad_free;
 	return si;
 
@@ -1528,8 +1519,7 @@ static void swap_slots_free(struct swap_info_struct *si,
 			      swp_slot_t slot, unsigned int nr_pages)
 {
 	unsigned long offset = swp_slot_offset(slot);
-	unsigned char *map = si->swap_map + offset;
-	unsigned char *map_end = map + nr_pages;
+	unsigned long end = offset + nr_pages;
 
 	/* It should never free entries across different clusters */
 	VM_BUG_ON(ci != __swap_offset_to_cluster(si, offset + nr_pages - 1));
@@ -1537,10 +1527,8 @@ static void swap_slots_free(struct swap_info_struct *si,
 	VM_BUG_ON(ci->count < nr_pages);
 
 	ci->count -= nr_pages;
-	do {
-		VM_BUG_ON(!swap_is_last_ref(*map));
-		*map = 0;
-	} while (++map < map_end);
+	VM_BUG_ON(find_next_zero_bit(si->swap_map, end, offset) < end);
+	bitmap_clear(si->swap_map, offset, nr_pages);
 
 	swap_range_free(si, offset, nr_pages);
 
@@ -1700,9 +1688,7 @@ unsigned int count_swap_pages(int type, int free)
 static bool swap_slot_allocated(struct swap_info_struct *si,
 		unsigned long offset)
 {
-	unsigned char count = READ_ONCE(si->swap_map[offset]);
-
-	return count && swap_count(count) != SWAP_MAP_BAD;
+	return test_bit(offset, si->swap_map);
 }
 
 /*
@@ -2023,7 +2009,7 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 }
 
 static void setup_swap_info(struct swap_info_struct *si, int prio,
-			    unsigned char *swap_map,
+			    unsigned long *swap_map,
 			    struct swap_cluster_info *cluster_info)
 {
 	si->prio = prio;
@@ -2051,7 +2037,7 @@ static void _enable_swap_info(struct swap_info_struct *si)
 }
 
 static void enable_swap_info(struct swap_info_struct *si, int prio,
-				unsigned char *swap_map,
+				unsigned long *swap_map,
 				struct swap_cluster_info *cluster_info)
 {
 	spin_lock(&swap_lock);
@@ -2144,7 +2130,8 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
-	unsigned char *swap_map;
+	unsigned long *swap_map;
+	unsigned long *bad_map;
 	struct swap_cluster_info *cluster_info;
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
@@ -2239,6 +2226,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->swap_file = NULL;
 	swap_map = p->swap_map;
 	p->swap_map = NULL;
+	bad_map = p->bad_map;
+	p->bad_map = NULL;
 	maxpages = p->max;
 	cluster_info = p->cluster_info;
 	p->max = 0;
@@ -2249,7 +2238,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
-	vfree(swap_map);
+	kvfree(swap_map);
+	kvfree(bad_map);
 	free_cluster_info(cluster_info, maxpages);
 
 	inode = mapping->host;
@@ -2597,18 +2587,20 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 
 static int setup_swap_map(struct swap_info_struct *si,
 			  union swap_header *swap_header,
-			  unsigned char *swap_map,
+			  unsigned long *swap_map,
+			  unsigned long *bad_map,
 			  unsigned long maxpages)
 {
 	unsigned long i;
 
-	swap_map[0] = SWAP_MAP_BAD; /* omit header page */
+	set_bit(0, bad_map); /* omit header page */
+
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
 		if (page_nr == 0 || page_nr > swap_header->info.last_page)
 			return -EINVAL;
 		if (page_nr < maxpages) {
-			swap_map[page_nr] = SWAP_MAP_BAD;
+			set_bit(page_nr, bad_map);
 			si->pages--;
 		}
 	}
@@ -2712,7 +2704,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
-	unsigned char *swap_map = NULL;
+	unsigned long *swap_map = NULL, *bad_map = NULL;
 	struct swap_cluster_info *cluster_info = NULL;
 	struct folio *folio = NULL;
 	struct inode *inode = NULL;
@@ -2808,16 +2800,24 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	maxpages = si->max;
 
 	/* OK, set up the swap map and apply the bad block list */
-	swap_map = vzalloc(maxpages);
+	swap_map = kvcalloc(BITS_TO_LONGS(maxpages), sizeof(long), GFP_KERNEL);
 	if (!swap_map) {
 		error = -ENOMEM;
 		goto bad_swap_unlock_inode;
 	}
 
-	error = setup_swap_map(si, swap_header, swap_map, maxpages);
+	bad_map = kvcalloc(BITS_TO_LONGS(maxpages), sizeof(long), GFP_KERNEL);
+	if (!bad_map) {
+		error = -ENOMEM;
+		goto bad_swap_unlock_inode;
+	}
+
+	error = setup_swap_map(si, swap_header, swap_map, bad_map, maxpages);
 	if (error)
 		goto bad_swap_unlock_inode;
 
+	si->bad_map = bad_map;
+
 	if (si->bdev && bdev_stable_writes(si->bdev))
 		si->flags |= SWP_STABLE_WRITES;
 
@@ -2911,7 +2911,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->swap_file = NULL;
 	si->flags = 0;
 	spin_unlock(&swap_lock);
-	vfree(swap_map);
+	if (swap_map)
+		kvfree(swap_map);
+	if (bad_map)
+		kvfree(bad_map);
 	if (cluster_info)
 		free_cluster_info(cluster_info, maxpages);
 	if (inced_nr_rotate_swap)
-- 
2.52.0


