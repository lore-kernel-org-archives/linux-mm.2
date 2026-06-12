Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91CD2CD98D9
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 19:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8FDB6B009E; Fri, 12 Jun 2026 15:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3DC26B009F; Fri, 12 Jun 2026 15:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44396B00A0; Fri, 12 Jun 2026 15:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 96BF26B009E
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:37:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62E2AA01DF
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:37:56 +0000 (UTC)
X-FDA: 84872270952.22.736B1F1
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7FF6A100007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:37:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L0Kq1ljr;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781293074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PlWgO7yzJ7D4dSwTEw1DL0jwS6Qno5QzBy9pCRF+UlU=;
	b=hzD6XlYB8TUKovAz5MO3VFf73kMUBEnqi+bieeKc1D+CzihKmYTayBkAGffoF6MMgOWjhO
	7yHXvtE2wfwV8CxiGVDhskNQjEPt8EdRT+Fq8BN5Qv/DjVQUNrSWSQqq8ZMGWVwCVr4XuS
	srP8Z98CF8ldsaron30pw1ynbGDQlds=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L0Kq1ljr;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781293074;
	b=cp+d2xfkOnOuuQYpHZTYb/Coo8uZG/m/FmW/Oj4p3naoME55xHmwl/fMZupITKOzaBRDqQ
	AptDK0wdSY81w48oOXxmAD9DZnkVNu0oRsq2I45R52BqCxJgXLn4s4XUC2MFfehXMF5q61
	AEsDEp5wRcIwAwK/uwGhrAm4ddW4Ito=
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-43d3454f643so652060fac.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781293073; x=1781897873; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PlWgO7yzJ7D4dSwTEw1DL0jwS6Qno5QzBy9pCRF+UlU=;
        b=L0Kq1ljrVmDO+bRBFBH+IUdjk1mJA5p9UwJJZ9t6nA6EGIy8MrxMjOY6jNsdL6Sfvm
         wC6iIEltnj/FHHBleI0/LZ8s8DOLTDtk1UDBgwNEdiPZA0BbhlIs2CK/BPS0GAc5uy8j
         J+wAGXpe27Lv5KRngxPD5BIXu+PSKJUf6ZOlSJAIj1Qa8L5GQ4BDnjZnavE9bnaa50Pa
         eFdmMCWWhQig9NmXYo9V/2CXzIIZl2oUyrv/41ohc3OoGvy5R/dz+qWT9ObiF5dtGORh
         EvtWt2QIDcpmsRXUCYD17nf8DNsdXMH9c5GLpWS5ygd+MMmkOA//1HHLdMKWvfhxu8Cs
         VlzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781293073; x=1781897873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PlWgO7yzJ7D4dSwTEw1DL0jwS6Qno5QzBy9pCRF+UlU=;
        b=IvGXj5LzO4/PKQ0fWhR/8KWh9wXmN+J1zRLhlltRmTY5q4z18SYxecLJtdxTyQ8ObW
         Z4hygqQhFL3tQOijTIi3xfS11m0BDkueWhBcxoIGUwRxcFlFC4AQFrOrRVsAQhrD9+7Z
         +yqMhR6cz3Xj/TEwwcnuXeYVaMR46aDGxPNFtuJ8iUakZpPa2E27mrr9REV35GFOAYNg
         8F0F2HLi+gWl2LtA8ofHBEooyj23ugTeXvfBBYNU4eolyPQ6Xw/byFyDxHej2/1wE+8I
         7ok/6Yv/2G3mDCfKxkBpJ11vA+TBCIyx8STaXPGny+YlOE1Wf9Dkefxgf4Ba9V126Bep
         oyhA==
X-Forwarded-Encrypted: i=1; AFNElJ8Zkvq6IjMT3D+TX9W/VwXZxt4P5SccVt5yBdFPozjOetUVfpWH4dvRfC46mcCI2VWY8BQau3Eylw==@kvack.org
X-Gm-Message-State: AOJu0YxZyHqLXlf3+5jLKBv9lMGW0lfNh2WPhbdwVzrjR8MgTWnz+o6u
	/RvnGPeZK753IqsKC8/04IZKjnmMSNiWBO2v/rN0fZHFngvhQg3VH4O3
X-Gm-Gg: Acq92OE8ws8nTP6Mrbq5hLkDrxFBGr2cO6RLkKXQIdHr5J075ofArZzARV9tA1CBt2j
	LxwPDxzub3EMkVcNSdzfJBJ5tUj1zBo06x9/ZQbQIh02pL2wIeLSbHcHw59D/tA2OuPfasJV4m6
	Um+oWt2+siHL7s9IRWrl4Xp8vpVe1s9xvjhVrgedcb/L0rrI6kWvSGy19x7ureZgkMOWuvjmiCa
	T3v0chD0oBRMJDvNRLQXGKCpi7AWhiG+TZ7qVoxhDXBpQx2yCtHWIcHjd6AhUN+EhIohjIpFi9z
	r/lqY8h/7XXR54TjvW9F4AyJixlVGxqjdayjGBNJJiA6CDQGQinhAOfiuEnhDhS1BSH4jIWGqaz
	nXcpKOzX1b8unHOsDHLhIbhTfh6f++g7cnmQBZZ4FV/vxshOhfVp6m7RodGzDtOtT9q0C2NnkBT
	UK0CubPWbxVSxJRGQL+XdMRbu59qUSDnI+uLW0zup3tqBk5Q==
X-Received: by 2002:a05:6820:198b:b0:69d:ffa3:f56c with SMTP id 006d021491bc7-69eec82234amr524964eaf.14.1781293073363;
        Fri, 12 Jun 2026 12:37:53 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:47::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4426ab0f533sm2500220fac.3.2026.06.12.12.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 12:37:52 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 7/7] mm, swap: widen swap_info_struct max/pages to unsigned long
Date: Fri, 12 Jun 2026 12:37:38 -0700
Message-ID: <20260612193738.2183968-8-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612193738.2183968-1-nphamcs@gmail.com>
References: <20260612193738.2183968-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7FF6A100007
X-Stat-Signature: mbrhr9qkdcnxioq47g97f9zoetqxqf4w
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781293074-981133
X-HE-Meta: U2FsdGVkX1+NdT3j0l/9syt0fMT60g/y32+xYe6WUnyc5YF5IEFjn2MfSr94Hm3KcdOmP5PnW62VIGd9/GDyZasB683xcdNaHum/Xz0YrOp+BtLWebHE3ifLO14zipeI8j99V4F3paWhgP3zt3te2Lk85E2F9z2DhSx9ucw+rUVurCsl/3/5Z0NEWSVVqoCvn4BSwASlGTBqA04xiNcVLRiRuPAxln28Ked9L2frwkyWyrC4ZAlfaBrPVygBt8OsUIoNZRVFVlgpXgR7oz6IXVvLDH1Zq10pN3VFRSRNqgJnChK5nYVSfZl7H41JZg+gmwX7GSdb/h2lN5GbcGjnGwNxdAUkRN5vxJ2U/9HxfIAyXqsa13VKQPRaPKg62IpkAJqV0m01NQhIHzjB3kpddgHlX8Qs+9fUxPHbsPxzzZnU/pQu073Bui3r3tl7CW+UZfZNQt4gRyH++UaB5eW09z0DDfLY7NnIgt0PDw2t8wyQEj6HZv2JmMAU94jJBsBlG+cqASbF6fPeQp7SUUhz7JNYi6PBATKeG7TErYxAVCY5HthDUTV+ZSs1XuPeAvHTAZbcrevYNFjY/32mNchqU8l09mm/tAkoHn6JH17aA07N4Xm/1Kv/OTmgzUSAamj/9bPwZ8hvy2oeO4ViXVDbaETQaeh8XflyI0Wv/IU4OM12+MDv/Z4B3QseJwz9kNJfqCsvzmcao+yKrVlBmO56GXaWQNE8189L7aNfGDoLvoflogqpED/hWp30WjvDtKdE15ad4rdK2zqYnCIyyatDrVKo5nNps+a/Tvwl+oVnEbQkh+/pJhKDtk8ywasjprzpa6p/Kt3xU/p1+drfG2YCTlUz3Sq1/B5HWK5YxFmMFwjx88S4wfCt13PI4Dd88a71Q/On0bxnSMRbYzTnliyam/EUfb94O67tU0GU+76Ulp5n8mvtvwgeZ1Y6qXWXrgRzB276XKKP1LKZE5ebZcn
 /BB+HLpi
 73REYEXSHMtC9oHCp14YWjSrEgojGDQrHXyjef5OUVFM1RCKln5bETG7gA93HKHTvJoH4ElG/T8sVuwefKZDBxhp5P0Xl221sq/ggEWJqORIM7NZj4VvnxOSbhMS8STgkR00IfD4jkTx24ZeGPW1cj5Jl4z1/o9Q1jYZFkUbP10DQT98bxf+uODKw0xwfaIfmzsP+tND8hP/MuHiwfN82+Ro7IUlmlW3ltvzkFKofosA7ajAEtfYRKHL9zaDJ4w9VniHXwov5LibgNMzzpq7pPDOGckI2Z8ZjW2pUXLp5L3aIT1YfbPMkG5JuRYtuxZTdp3xvIExcbuzoDm5kapp71+l3Xy9hgUnbDd4Ev4d9bBHJLBS+g/WEdRkYWjjZK5IzGiO/D/gyVj3/QHkE4V/XybGnF0wewjPByYxePXH7wRRvbfIrbWBHxizR4e/tjBF3E68CrZ9Wrk5WfF0ZkcZG81ARoeJWfanzTWjy2iALgcjbU1yYozJ6U3CAtR9OQ7mT5OZTSgtDKznzFLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Widen swap_info_struct->max and ->pages from unsigned int to
unsigned long so the vswap device can exceed the current 16 TB
cap (ALIGN_DOWN(UINT_MAX, SWAPFILE_CLUSTER) pages).

Physical swap is unaffected; backing files/bdevs continue to bound
it independently of the field width.

The new vswap cap is the cluster_info_pool xarray's allocator
limit. XA_FLAGS_ALLOC stores allocated IDs in u32, so
max_pages = UINT_MAX * SWAPFILE_CLUSTER (~8 PB at the typical
SWAPFILE_CLUSTER=512 layout).

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h |  4 +--
 mm/swapfile.c        | 62 +++++++++++++++++++++++---------------------
 2 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 2d6bc4cb442f..b8fc2aa4539f 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -253,7 +253,7 @@ struct swap_info_struct {
 	signed short	prio;		/* swap priority of this type */
 	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
-	unsigned int	max;		/* size of this swap device */
+	unsigned long	max;		/* size of this swap device */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
@@ -261,7 +261,7 @@ struct swap_info_struct {
 					/* list of cluster that contains at least one free slot */
 	struct list_head frag_clusters[SWAP_NR_ORDERS];
 					/* list of cluster that are fragmented or contented */
-	unsigned int pages;		/* total of usable pages of swap */
+	unsigned long pages;		/* total of usable pages of swap */
 	atomic_long_t inuse_pages;	/* number of those currently in use */
 	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
 	spinlock_t global_cluster_lock;	/* Serialize usage of global cluster */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0d48240de345..b03a81993a04 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -451,10 +451,10 @@ static inline unsigned int cluster_index(struct swap_info_struct *si,
 	return ci - si->cluster_info;
 }
 
-static inline unsigned int cluster_offset(struct swap_info_struct *si,
-					  struct swap_cluster_info *ci)
+static inline unsigned long cluster_offset(struct swap_info_struct *si,
+					   struct swap_cluster_info *ci)
 {
-	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
+	return (unsigned long)cluster_index(si, ci) * SWAPFILE_CLUSTER;
 }
 
 static void swap_cluster_free_table_folio_rcu_cb(struct rcu_head *head)
@@ -876,7 +876,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	/* si->max may got shrunk by swap swap_activate() */
 	if (offset >= si->max && !mask) {
-		pr_debug("Ignoring bad slot %u (max: %u)\n", offset, si->max);
+		pr_debug("Ignoring bad slot %u (max: %lu)\n", offset, si->max);
 		return 0;
 	}
 	/*
@@ -1152,12 +1152,12 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 }
 
 /* Try use a new cluster for current CPU and allocate from it. */
-static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
-					    struct swap_cluster_info *ci,
-					    struct folio *folio,
-					    unsigned long offset)
+static unsigned long alloc_swap_scan_cluster(struct swap_info_struct *si,
+					     struct swap_cluster_info *ci,
+					     struct folio *folio,
+					     unsigned long offset)
 {
-	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
+	unsigned long next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
 	unsigned int order = folio ? folio_order(folio) : 0;
 	unsigned long end = start + SWAPFILE_CLUSTER;
@@ -1235,12 +1235,12 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	return found;
 }
 
-static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
-					 struct list_head *list,
-					 struct folio *folio,
-					 bool scan_all)
+static unsigned long alloc_swap_scan_list(struct swap_info_struct *si,
+					  struct list_head *list,
+					  struct folio *folio,
+					  bool scan_all)
 {
-	unsigned int found = SWAP_ENTRY_INVALID;
+	unsigned long found = SWAP_ENTRY_INVALID;
 
 	do {
 		struct swap_cluster_info *ci = isolate_lock_cluster(si, list);
@@ -1257,8 +1257,8 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 	return found;
 }
 
-static unsigned int alloc_swap_scan_dynamic(struct swap_info_struct *si,
-					    struct folio *folio)
+static unsigned long alloc_swap_scan_dynamic(struct swap_info_struct *si,
+					     struct folio *folio)
 {
 	struct swap_cluster_info_dynamic *ci_dyn;
 	struct swap_cluster_info *ci;
@@ -1373,7 +1373,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 {
 	unsigned int order = folio ? folio_order(folio) : 0;
 	struct swap_cluster_info *ci;
-	unsigned int offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
+	unsigned long offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 
 	/*
 	 * File-based swap can't do large contiguous IO. vswap has no IO
@@ -3492,10 +3492,10 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
  * Return 0 if there are no inuse entries after prev till end of
  * the map.
  */
-static unsigned int find_next_to_unuse(struct swap_info_struct *si,
-					unsigned int prev)
+static unsigned long find_next_to_unuse(struct swap_info_struct *si,
+					unsigned long prev)
 {
-	unsigned int i;
+	unsigned long i;
 	unsigned long swp_tb;
 
 	/*
@@ -3533,7 +3533,8 @@ static int try_to_unuse(unsigned int type)
 	struct folio *folio;
 	swp_entry_t entry, vswap_entry;
 	unsigned long swp_tb;
-	unsigned int i, j, ci_off;
+	unsigned long i;
+	unsigned int j, ci_off;
 
 	if (!swap_usage_in_pages(si))
 		goto success;
@@ -3970,7 +3971,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
 	struct inode *inode;
-	unsigned int maxpages;
+	unsigned long maxpages;
 	int err, found = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -4404,12 +4405,8 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 		pr_warn("Truncating oversized swap area, only using %luk out of %luk\n",
 			K(maxpages), K(last_page));
 	}
-	if (maxpages > last_page) {
+	if (maxpages > last_page)
 		maxpages = last_page + 1;
-		/* p->max is an unsigned int: don't overflow it */
-		if ((unsigned int)maxpages == 0)
-			maxpages = UINT_MAX;
-	}
 
 	if (!maxpages)
 		return 0;
@@ -4640,7 +4637,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 	if (si->pages != si->max - 1) {
-		pr_err("swap:%u != (max:%u - 1)\n", si->pages, si->max);
+		pr_err("swap:%lu != (max:%lu - 1)\n", si->pages, si->max);
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;
 	}
@@ -4728,7 +4725,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
 	enable_swap_info(si);
 
-	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
+	pr_info("Adding %luk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
 		K((unsigned long long)span),
 		(si->flags & SWP_SOLIDSTATE) ? "SS" : "",
@@ -4900,8 +4897,13 @@ static int __init vswap_init(void)
 		return 0;
 	}
 
+	/*
+	 * Cap at the cluster_info_pool xarray's allocator limit
+	 * (XA_FLAGS_ALLOC stores IDs in u32, tops out at UINT_MAX).
+	 */
 	maxpages = min(swapfile_maximum_size,
-		       ALIGN_DOWN((unsigned long)UINT_MAX, SWAPFILE_CLUSTER));
+		       ALIGN_DOWN((unsigned long)UINT_MAX * SWAPFILE_CLUSTER,
+				  SWAPFILE_CLUSTER));
 	si->flags |= SWP_VSWAP | SWP_SOLIDSTATE | SWP_WRITEOK;
 	si->bdev = NULL;
 	si->max = maxpages;
-- 
2.53.0-Meta


