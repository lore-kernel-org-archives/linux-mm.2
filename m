Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 932931088E49
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D8336B0370; Wed, 18 Mar 2026 18:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489C06B0372; Wed, 18 Mar 2026 18:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4346B0373; Wed, 18 Mar 2026 18:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CCA66B0370
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:30:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4AFA1C2EA
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:31 +0000 (UTC)
X-FDA: 84560629062.30.E7DC4EE
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id DFC7814001C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fk3AXwu+;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773873029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=03afpDvtGuNWbxO8rXYZMIlB93FyoeHq7W5GxGEi1h8=;
	b=5+P61xmBJwoS/ZzjFeqxpOHGvxaTp7M2NAd+c5euNFNNgFaE5Ho4t20j61MJl6OelmTtWy
	0f09sfW8A2Bht4djh2YUSLr6nN/TDGkoBUu2ltfiN+KSoXvCyXz1+WCnHJ4IL7VqoHMy6h
	CCDTwS6sGFT8OtRyD8KZ+zRQMdV/0NQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773873029; a=rsa-sha256;
	cv=none;
	b=gflZDviBIDaVgTsSMubrtxen33SYA6jkLoS7nCMrbr7Pp6yZHKbv+BPQEPETUZ5SN34aWy
	sgJ/PwtLwDjsF8jJzAmCsaeAD3Al6Lu2SesHyi6uNs3RvKIxzt9/hlvbitTjppIYH7YbT+
	HsR0t0+fHl6T0jqc7K598GDHGhcftdc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fk3AXwu+;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-4042905015cso287577fac.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773873029; x=1774477829; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=03afpDvtGuNWbxO8rXYZMIlB93FyoeHq7W5GxGEi1h8=;
        b=Fk3AXwu+2+58V4mBmDE69OX0M/h02tRieH+G62QKqj0sr2kaY86OVamFBnR2KyFBMr
         xpJ1vwQWfp47MFlvY/Z7hFL7414/LX3GVbhPQZaiYzGGvZEpy3S5Lqui6eNIeKUUteVR
         PZbRlfYe1FhYUhA6zlHlRQPMNRAoqyq8+HH0rNUt7HeHglPYShGjblLA3JS5AvVshW68
         iG7Hnd3peShIFlHoB6e8y0HCx3i3y11RcWxLWTNQ7f3Y9a1rZajENSjPSgktWvMVep7I
         LvEQWtJUDkq4TlEhz84wLmDtPmgfHy2f9XVTzi2zAX3AxsWAUeajjM2um4SueztZjJPY
         iDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873029; x=1774477829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=03afpDvtGuNWbxO8rXYZMIlB93FyoeHq7W5GxGEi1h8=;
        b=herAkRg7ncrGsMvkxM70EJIRO8ewJcXAA2VBWX8JOLcptE7Wb7beJtUFCJK+oLmKvJ
         c7rs2OyYBUJ2Ai4uN9HDfr+xE7iSLatmarfj6HC//LF/xLmxb/Lw3ekYSYl0KfyqBGhO
         EGZWPMsZg2yWGlu4QT30eS0T/uTzbCliEff7JCvU6myT+741w19I2/Ptwcv/WR1KOCjx
         548+lrr+/aOJ6+J6T43XS/wpNXE+rjLximGMd2xR4HJZFTeJL2Lv0X1tAakPJLzk9YPi
         ix9Q3plP/HeIgmIUhX8GjbZx78lk+YX+ZLQWoeuHgAid+sQfsV/SZF0pEezgGGs1Xk8Y
         eUmg==
X-Forwarded-Encrypted: i=1; AJvYcCVS/Si9bFXcfIv3mq2ZmzIpKjVYh1V22WmisqgjSIyQsqs1pfyNiojmmfdCf/tXU+AyFNewvoi1WA==@kvack.org
X-Gm-Message-State: AOJu0YzTyKNgki/LToriFubuV0wmO/GCfScv2Zvp/ZjaBjaTY0uCXm2D
	gSKoFGJPHegBE9Coj7vrbsUDD938VhaL6tAcuHO3681mOcLE2x2P4OEz
X-Gm-Gg: ATEYQzwIfE67I6Fg53gp91o8a0/CMq0dYif3spwelVvtj8JAScjn5Qm9kGnfjq/R5YY
	NnzRqcdlR84WsBS+a2kCC/OZVY5uNF3aUpDo2/rjXMrqsDhWnWeb09cmZsgADAa1xHXI6FgSpUZ
	54Se6gPoVXofS2+H4HNbePIhvA+QBxeYyAOyXU/shIc16Y2w8Y5deCBhehYZj0kkvPWv9aHTJez
	TbViRCfUpbIhwEgFLEGqc5V9whTAZY1YxdxovI4AeTabgyZTzK4YUgSo2bBSKyMYQqdrWPzS0ZI
	k4x7KVpDd/Av//YwLGE235WpEBzEZ+2cfYMx0WcMft+CGnRu98a2ZpCflszH2g0odds1Q94ZZrF
	mfQ8EY8oJvgEdwGc/X8ohbdusZF1prnf6AEV9aSEoki+G3Zxf6V6H0P+Czvnf66kS1f2vHUrmD3
	9xL3YhIOBabb5rxtuFDjIVxjMmhR2uJnukBrid6fcmh8yM
X-Received: by 2002:a05:6870:b2cf:b0:3dd:6bdb:e741 with SMTP id 586e51a60fabf-41bd3f6279bmr3415550fac.26.1773873028705;
        Wed, 18 Mar 2026 15:30:28 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41bd282c965sm4366921fac.2.2026.03.18.15.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:30:28 -0700 (PDT)
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
	riel@surriel.com
Subject: [PATCH v4 20/21] swapfile: replace the swap map with bitmaps
Date: Wed, 18 Mar 2026 15:29:51 -0700
Message-ID: <20260318222953.441758-21-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DFC7814001C
X-Stat-Signature: mspr78zof1hf3imcg3dukih69eiauwrg
X-Rspam-User: 
X-HE-Tag: 1773873029-513978
X-HE-Meta: U2FsdGVkX1+1o8wprVTcEx5W9rlrDqzGgvDErWvToJ9TVrgKvRlAQ1Ii1q6cT7JuCaT4Ww5e3TG47Ji7BdDJnR7BcO0IlWkHtKTYGIjpnErzRIY4IIPPbJ7nYMk7nIrEYSYeHlx9HGvnVRNoT76PRW4asZAGKZm1SuLCTjTaYWZd29FPVsuy3AllxxlIcSi2GqHDq43FR0uDrBvuuB/6ZYpdRtVXiMR7y1orKq4FNDmgDrYIbGVzL4esUZknLqLzeio/cJZSwG3lPnChwOnPIJlDa2SrfPgLHi8s0T9cXKLjeteWoCJMu1uYvowHfHZoK6d82vf3eJzMwDxLx29G0bUvS4j7FOmJJ7pcKrhpmawAyq4yx0phxG13F5C6N6Vbb1drx44JdMJ+wfhc0E2NDQ7ELEzpyuDSZXPfP/2i1voAu8LLjQnshi6jSox3EtVddf5FHD5GqLoj4lrKH/lFiPq9PjFY1qL/89OgHr3o7yPRxqGb5tjcydqiVFxI/OJdwl2lo9rKbzKRlAP6+B2FikBnua/+v+K/qZy4O7/Nx9chpLtAUHf8wACOQRJGFx4GRzb7bF/lwnSQARJumuw9bSJ1G3qrraIyZ8876Fr9jp90wR1F7cjHmFm1RgZVNyDOg/+zx+0QnPJV9Q4AmRuGa2BFMepJMJeMInQiTLEOgi4sIyTOsxK+i6MKT6xRgs/4wUIRCkwF7SJKWRQt3rhyqsy31PYaX2XgEIjJVbRWxzQH+vvHsTuiqn9rD0YFnftYs8336CgwtrMqmUn3oE0wJF1UfXOwveW6MamUd3ZrbtnnYXBH3Ti09mPLfh3usgeOJzfEf2/gUisJ0iA+i3v8N+1Z8S8b6QseJDZypbv1dHqNacYFqk5gE0MzdtjPerBpFXSKGcH6xwSp715V5xTpoSR/YcmnBNW+in6eH/Fr+uiaqaZOcaUrOxt0lFmMOgOGm68xNePpw/qtB+6pkDa
 mcIRh3/C
 3YfxinHn9jZQXnqs8SAAucYOf4FiGs8163SVaT1+4gZ4SlO3jGnWXTnHzaxcVCZ0/zYu35xHWHfBIDX/sCKDbz/aSujkMj+222CUyV0RvdqqLwVEDiYIvUFVOdse2f6Bhln3FHdN+E7r2IrZo5YzuxGvUhUzXXlXw/rVZT4FgUM5Hhys5GRRKyiSj+igKBDyb+/JIe/6z/703rvZAHNmLVvnrrFQ3C4nDFVwAhKOd0iDeAd2bDFUvby/2XJ+H07UKDWXbAaRenxzLZmIPsC5VrNSCt2xpuI7+JJBMhRLnWgfkSvUu/6jwgcPiUkEnfToXJ0UIUafOGo9hDW7CHLhbz09DxQXGzMQN0RcM9Z4oR2zfOKAGO/fOGzbVAkOSYZw2OeJVF+3IC8mZWiNA1nY68o1GDfd6FJgtit2dL3kXpym3E45hJw6iNdTr+NT5875OW3uMr76G45XZZEkZcFXXBhVOF0tpcqEuuGyz81FqreEJpu6ogcEEEWcNoses4zHFgRLC/voBMo2TwPZi9+4QrMou/w==
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
index 21e528d8d3480..3c789149996c5 100644
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
index b553652125d11..3e2bfcf1aa789 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -760,25 +760,19 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
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
@@ -787,11 +781,7 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
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
@@ -800,15 +790,16 @@ static bool cluster_scan_range(struct swap_info_struct *si,
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
@@ -841,7 +832,7 @@ static bool cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster
 	if (cluster_is_empty(ci))
 		ci->order = order;
 
-	memset(si->swap_map + start, usage, nr_pages);
+	bitmap_set(si->swap_map, start, nr_pages);
 	swap_range_alloc(si, nr_pages);
 	ci->count += nr_pages;
 
@@ -1407,7 +1398,7 @@ static struct swap_info_struct *_swap_info_get(swp_slot_t slot)
 	offset = swp_slot_offset(slot);
 	if (offset >= si->max)
 		goto bad_offset;
-	if (data_race(!si->swap_map[swp_slot_offset(slot)]))
+	if (data_race(!test_bit(offset, si->swap_map)))
 		goto bad_free;
 	return si;
 
@@ -1521,8 +1512,7 @@ static void swap_slots_free(struct swap_info_struct *si,
 			      swp_slot_t slot, unsigned int nr_pages)
 {
 	unsigned long offset = swp_slot_offset(slot);
-	unsigned char *map = si->swap_map + offset;
-	unsigned char *map_end = map + nr_pages;
+	unsigned long end = offset + nr_pages;
 
 	/* It should never free entries across different clusters */
 	VM_BUG_ON(ci != __swap_offset_to_cluster(si, offset + nr_pages - 1));
@@ -1530,10 +1520,8 @@ static void swap_slots_free(struct swap_info_struct *si,
 	VM_BUG_ON(ci->count < nr_pages);
 
 	ci->count -= nr_pages;
-	do {
-		VM_BUG_ON(!swap_is_last_ref(*map));
-		*map = 0;
-	} while (++map < map_end);
+	VM_BUG_ON(find_next_zero_bit(si->swap_map, end, offset) < end);
+	bitmap_clear(si->swap_map, offset, nr_pages);
 
 	swap_range_free(si, offset, nr_pages);
 
@@ -1744,9 +1732,7 @@ unsigned int count_swap_pages(int type, int free)
 static bool swap_slot_allocated(struct swap_info_struct *si,
 		unsigned long offset)
 {
-	unsigned char count = READ_ONCE(si->swap_map[offset]);
-
-	return count && swap_count(count) != SWAP_MAP_BAD;
+	return test_bit(offset, si->swap_map);
 }
 
 /*
@@ -2067,7 +2053,7 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 }
 
 static void setup_swap_info(struct swap_info_struct *si, int prio,
-			    unsigned char *swap_map,
+			    unsigned long *swap_map,
 			    struct swap_cluster_info *cluster_info)
 {
 	si->prio = prio;
@@ -2095,7 +2081,7 @@ static void _enable_swap_info(struct swap_info_struct *si)
 }
 
 static void enable_swap_info(struct swap_info_struct *si, int prio,
-				unsigned char *swap_map,
+				unsigned long *swap_map,
 				struct swap_cluster_info *cluster_info)
 {
 	spin_lock(&swap_lock);
@@ -2188,7 +2174,8 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
-	unsigned char *swap_map;
+	unsigned long *swap_map;
+	unsigned long *bad_map;
 	struct swap_cluster_info *cluster_info;
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
@@ -2283,6 +2270,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->swap_file = NULL;
 	swap_map = p->swap_map;
 	p->swap_map = NULL;
+	bad_map = p->bad_map;
+	p->bad_map = NULL;
 	maxpages = p->max;
 	cluster_info = p->cluster_info;
 	p->max = 0;
@@ -2293,7 +2282,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
-	vfree(swap_map);
+	kvfree(swap_map);
+	kvfree(bad_map);
 	free_cluster_info(cluster_info, maxpages);
 
 	inode = mapping->host;
@@ -2641,18 +2631,20 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 
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
@@ -2756,7 +2748,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
-	unsigned char *swap_map = NULL;
+	unsigned long *swap_map = NULL, *bad_map = NULL;
 	struct swap_cluster_info *cluster_info = NULL;
 	struct folio *folio = NULL;
 	struct inode *inode = NULL;
@@ -2852,16 +2844,24 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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
 
@@ -2955,7 +2955,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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


