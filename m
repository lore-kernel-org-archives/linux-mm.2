Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C7661099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323B46B0170; Fri, 20 Mar 2026 15:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9F46B0172; Fri, 20 Mar 2026 15:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D306B0173; Fri, 20 Mar 2026 15:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBA736B0170
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:28:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B7D7913A404
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:28:09 +0000 (UTC)
X-FDA: 84567427098.28.FC37BBC
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2136D140016
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:28:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PlWbdTzQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=03afpDvtGuNWbxO8rXYZMIlB93FyoeHq7W5GxGEi1h8=;
	b=HD1fS3lhKCQ4IjPlTH1uxJKQMjf1irfXsG2kYYB+Rdm5FgUOdzL2PE5EBHkXcpCopWDeMK
	O3Y8o/hfNVB2O087MuZFsiyQg9ollHkRWszyPreWHRZxGC075wKe19SCyr8O1JrkeeBgVm
	m3IM36qbg/D/AYIYDh/RV/8DI0HxuNw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034888; a=rsa-sha256;
	cv=none;
	b=LfVFyqHdfENeAWN/GYkEkziE/winltu53SG/WXG+8I7XKxw5hfwiHGb5VTRqJ1gffzUHvH
	4aFyUcTSKgQK+bYe2VsZxGMMDqMIQGArZnovQDTI9lgvG8BYkMe3aIeR/s/72wcQ23kpF2
	DO5ck8i08hzmgzbfN0mxnuqEua2zqhY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PlWbdTzQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-40f1a1f77a6so1696756fac.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034887; x=1774639687; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=03afpDvtGuNWbxO8rXYZMIlB93FyoeHq7W5GxGEi1h8=;
        b=PlWbdTzQJPvv+3yicLEfmePPJlR/x/T4fN8BjjNxNeqjAN4ydECQnBbeJ6pTkQHlvn
         2hbOXy4c7GYrgQMx9KcGq3xnLg9P1970k2nnFNShxbrmPs72j7T8+nxpRmSJ+UcxFZjh
         ctwPpDqb9Du0fZwZ49zmsdBdnTmwZDWUlKYZpSf2fFwQV/B3aMY9tPi+4Lv8jth1EC0d
         11+jT2XUiQHr83ZI+xYApusHvhEMZqLxYUHIREgpjU5z/F8VzS5Vs489Q3Vcpq9ekLLk
         YUqHrnEyW9Pzydx8kkn2hK9WA/934TkkZeNdJq/60xGIOXMPiMMy6QtdfWu0ThcOpyNf
         N4PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034887; x=1774639687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=03afpDvtGuNWbxO8rXYZMIlB93FyoeHq7W5GxGEi1h8=;
        b=TG0Gp/M+hVL/HRV3cxIZUaakgkBkpphA91V/+coLWYE5DTI5HvJRHygckFEyR9YTFk
         ELFPsMg0g3lWHPkF3dyR7QOrsSBXvPGiIp/+7BJ+wdrAXrdcglc8of8YZpK/X9tRT/JF
         pcD/JQCHuCdj/X5W+X1U6m+uvHcRKen98qmTqjyvkZZIhELI9LYOMv9ZpX5zJ/QL90KJ
         BDEO7GAW36bS659wvGYD8p6J+hNIwE8RC1JAhb1L7r1Ad1qiWmXdUPMfzeDmhkZ3RjO3
         KBJfURV25lAqkwObGqj7LXYRnd9VrJ0SMOn4TsnUL6MGe1wnxUb92uhvztiUoEsAZxfr
         O2nA==
X-Forwarded-Encrypted: i=1; AJvYcCV14VBtGLkJq/ktJudQPIvc4y7o5o6Shjf+y13HncOsIvidmO2q9p0t+rH+CyJY9UomgGciElTuGg==@kvack.org
X-Gm-Message-State: AOJu0YyCvTmZovQbQ1pYGt+FxuvYziXTS/08KSWHktRoubBdmo99uFjN
	q51cJ63ew6rphhA1iYvypHAcO2C0MZiFiE8h/8H2UH+iz7JqbqEQGETM
X-Gm-Gg: ATEYQzz9vVEV7aGG1bRyic1xDUcLDBB5JgBCQui+ypTKv9FZs1WVCdsoLiwByUBGtzR
	P6DWI/gpTwKzheeRpEH4PdC0XUCOSXXkRKYhgcr8g/yRMOYenzLtwcWsN4pLrPCXRGnojUsPaiZ
	JSarCtnks5by1/KBbKA52lTty83kZeaDDGBlHgIRW8TlNg5n9u6ozvoRUMOR6O0qMqt6LruNxbY
	n3K3UF8h+UC8a2olOTp1gEbwNt1iC80ch3aJgw85f6PZXJugmpGW2mlYHJuj+nbhtfaVamuZS8A
	DFMEHyEPbFsQODK+v9ozOQw/UINOXRepzpJ+5iYTqLc0fz2+8FZ637qAK7VBk29m4WqVzYM+fUz
	E2aY0BRpJhYDHj1wqaQjvEZRzQcAF4BEzR3/WOMPMJK+tnQlrcL24LO3Y9NqcU6x3RqBZUTxyHk
	GLUxaJ3lfGmaWCdV+Rt7HOZ5sXGhCrHkDpfCW/JgefbcAyvg==
X-Received: by 2002:a05:6871:1cf:b0:409:54ac:12ae with SMTP id 586e51a60fabf-41c10f6ae20mr2677223fac.8.1774034886900;
        Fri, 20 Mar 2026 12:28:06 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c148a5f99sm3030503fac.2.2026.03.20.12.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:28:06 -0700 (PDT)
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
Subject: [PATCH v5 20/21] swapfile: replace the swap map with bitmaps
Date: Fri, 20 Mar 2026 12:27:34 -0700
Message-ID: <20260320192735.748051-21-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2136D140016
X-Stat-Signature: ubik98xwqts6g35znnhjijjyopi6i9f8
X-Rspam-User: 
X-HE-Tag: 1774034887-449270
X-HE-Meta: U2FsdGVkX1+QfVvVM1m3W23tJA0YSY9giqb1bYHXl/0XrdhjYWOmS7ABfMBzeWUTu5Np0dt37jYMOc7ae3KVREPLkaYKvQBL5dPrxWCxGDYJsbvYhAqhjMd3+y4A6rJciWDPQ73ZYt6HJZZXqqLrxk5ZDTg1DY9KigLJs1/YsCwxGmMV9aN+YbWsiS1zvBU6dN7BfscpGcOo8QFsIBLRVHnhDqcq63PBdbktofeagkASXfb2ZjTHVSjHLUzXPnw3eNKf3PAGPosdX276GkL35tT8ynJH3uIuARRAHy2sF6ifCml4fScXQpaEuAlsB830hUSPoeizGDXo7WvmNw6q5icF4KtZQDRtUZ2mski5qQTiHoaKMNvMSrpi0oR5KcowHoacOdmd8nYcyHCYOz+yQTxjfEUmHmboZ/gBA8weaFS/l2/QoH7JF7q414kMtqmYEHGR6JoEvfOEKt/23XCu9oA5A9J0K1pkYl1PyCR3rfcfTkIzjL3MDIVsQYmJJTR6T3OMePJcG969moiuTJGnrumr7n4FPt6BHk5pShCePWnJLzGoN3Jbk2N3ZLW4loxdWxHZYEGkkj+w6ooMWaB6ZKIqARIp8MPSjJ3V3EGbInmK/4zNY4SqtzbljeUpKJcbhWDCCpgQloqSx6UkIdYyuI2XXUTXvGlPt8UBKW2pe99H6lmNMoKMxSavpyloCGeBCJXWPeNgQ/eZkqS0G9fzX0bcAR0Bpn8T8LbQjubhdYGhyjvUaVT01T7O5l/JsfgfaqruncNl6RGJwJcB+mvWwM2YYREFhjVN1jNoiOFGjXBGMqg4xUZGw0YsKL4Md7VPQF8e+sD3Aag+gffafahwTjpVIizltA5UQI84uNJk/3oe0QIJxHzx0igGk9jhKTdCrjK9aLN7zUNT4czUymMEMovjHZ+WhhFtqNhdn8kKztKHMHm0Un0FAgWdowCVgqKRAEmOFVKUd+wQmxTycHN
 5XUJof3/
 mwH7rXTtetJmWlxpU6sGfNtTAyLkQhSN0Ac+baHvKJjkw8p+1iJniPZdNEHvpoesViEhzmy1Kh4/VAzycD8V7ov81J8niJilK9aCDrO9MYonj3lyf31shWBTYd/AoC3qwWV5ZmswV+n23oUSL9SYcJ84JpQ2YIj4kVUal60NF8eNOnTQ=
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


