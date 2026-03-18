Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D62BD1088E48
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96ACB6B0358; Wed, 18 Mar 2026 18:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5286B035A; Wed, 18 Mar 2026 18:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F8B6B035B; Wed, 18 Mar 2026 18:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5482D6B0358
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:30:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 266C7B6E24
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:11 +0000 (UTC)
X-FDA: 84560628222.03.316AF53
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 578A880009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ON/Nh1iR";
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773873009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KY7NTF4Dm0MfL8/0ZISsKMQQ1GHAv90xIRFAuLv54rc=;
	b=R5GwCvX3OA49s/nCxLBAMRy3yuDviPbaKuxWMMbh3hDezW4NC3I4gG+ZEeCIEyUeTYVex2
	THDgtOJ2o6vNZJz+PKuP70Tm9fjBK/VnAGw8Pb7PYmbiCbD7gO4xVvamhDXVAXUXegzb9i
	nE08HWhNf1HH4j89fbgCUyzlA5WxeYg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773873009; a=rsa-sha256;
	cv=none;
	b=68rqojt1rjDx+gbdWBy2WLUauzDSoZT0yGIdFJ/94FGJ0RM8YzSSm2yWgYx3xf37OO8Aaz
	lRZOrpK5XhL/MB9cgBFwVvjxd6b3NIxjKxzG9W4T208ZwM87YrGGVjQJRHIVzIAbx6mGcm
	RmYSVrmE1q+oAVuoSkwrpnLfgE1vbI8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ON/Nh1iR";
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d77b179b52so295246a34.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773873008; x=1774477808; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KY7NTF4Dm0MfL8/0ZISsKMQQ1GHAv90xIRFAuLv54rc=;
        b=ON/Nh1iRu1EnKr6A/8AWh2D8Lx5qiSFfiP5iE/orPLOsAV7g0P3hy0mF+WB8++J0rF
         6Cf7oqwf6kUgzH5KB75oMcBV78GAjD2YYwzpNOCQLGnX2NuYwAWlJGbjn9uVFEniOEME
         IaRfyk2powquALgWfqSTq8fIBAH+HUSsJICibqiWW4MmTqvqF2Zbgi2xsdJM7e+Ipt2/
         3URutXtUC1vysRZZKc/zWH1CmmI+EV2GPjJQdFGR14Js2iX8awDoam0RpSCEy0Edml24
         ZVPmK2MijLtnc7XpMl29jPIwnwgaO39CxHl/IXQeN8zytf4yxHmCnGrqzQLbCIIXp8P6
         weww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873008; x=1774477808;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KY7NTF4Dm0MfL8/0ZISsKMQQ1GHAv90xIRFAuLv54rc=;
        b=l7N1GPnPKWOElcMla+bmakdmcC9CGG1yrqsWPk8ymCFVnsESWivYPvURw38ZJi3e9b
         0TDnCLQQ/d9fnEWw3oIwbBN+dwcLN4kqB5aUQqzv0rqzmUJJ1cuZVNGhpKwlWBWXE9Lu
         FBKdjUOvK2XbspslShzpWWIdkdFkdXHgDm9CnuHwCuVKQCoJbpsrnzcGlduZSRpThUjc
         oXsQCBIFe/s6ZsYg3UnMCeUHBHRy+NYdOe6gfsB6XLr+fy+wK3UjNMGeBtQcvIzCvjGo
         lx26jxdWw5WKlLRpv6vXTIV8LZXLkEhR2oC92NOvT6O8P9rWrO/iRL/V2T8C8pLdLSBF
         xuJw==
X-Forwarded-Encrypted: i=1; AJvYcCUVFe/B189tpNH4OzrXvfgknhsyswb2dIdxmPF+4i5vE5D5wmeA4A4EKx1ba4JDmB737MoU1EdQeA==@kvack.org
X-Gm-Message-State: AOJu0YxkA85aFPr2WZWkltJRli0iC419Bg9yAXl7Bwehc9jbolYtgEzq
	nMJ3d2MGCp3FO4adD6uUAYw85gfqlrG6GsUoNBJsX9uonfhMFCYP0zQW
X-Gm-Gg: ATEYQzz09HEzq+vObzsqLcSKE0iUti0+t5/lnBJQx/em+SmqR/IeZsGSu6tzvARYI2N
	vg521j4/TrFIaXRN1LMyreIrjgk4s1RqCiC/o9vuw8H0m9WzPWp9iP52RlfW9M05btzb48LqXdJ
	f8+Xvm3SSX6uRPiS2H4F/T/qmmpUaSDpEKuoRxa0UO4r9E9miMHS2k3nhI6wJF1Tf6cPM/aohRP
	yc6lJu5Yjqz6gqZDhULrmqp6KJVMyL+FbBAMgH8CDlChvjMEhCb/xb+Pfg4sGTqoxQYi03ph335
	YZrWTpu1JPWYraF93m1vMBY2B4JZ7ejbhUwZWPKXbTGMsk6MkXxmkUlcZERXN44mvgeoINPaewA
	oXPMKWK1UFGIu8n5gZrifD5kNGv3Wi3zxDh0h2Wt7u1WCb922VJOk+Ca7IYB1kOr5EQ694VnkN7
	eh/7YGTmGErF0piwHpNZ92qhX9onyrc0AQb+5YbTjU2Sft
X-Received: by 2002:a05:6830:498b:b0:7d7:4279:f1d1 with SMTP id 46e09a7af769-7d7ca281344mr3404168a34.0.1773873008244;
        Wed, 18 Mar 2026 15:30:08 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7c9b39ddbsm2935440a34.17.2026.03.18.15.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:30:07 -0700 (PDT)
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
Subject: [PATCH v4 08/21] zswap: prepare zswap for swap virtualization
Date: Wed, 18 Mar 2026 15:29:39 -0700
Message-ID: <20260318222953.441758-9-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 578A880009
X-Stat-Signature: p383p93xghhnsgf73aaif4t98nafrhak
X-Rspam-User: 
X-HE-Tag: 1773873009-944359
X-HE-Meta: U2FsdGVkX186ngzDWPscbVkXfC4qYEnp2bOBczNEOYPllouLj0/Xk/daV2uNssExNyh9nPFNWerLPtZ29IhWvizYA/kPMNBVkfqopAEZCdBdTqAE9xSPdzT488ZfBNKKGezKVu1kaZhkOndB2JwaBl3fOB79KZpxYptfI/+q9dsgaJAtQKM3yCljf/yN9y1ja+EsGJigk+VF4k20LQo7pCenWEmJC4zIlbbGBdGwp/cH/Ic8WNvfVqSCIoJhY/xUZovfC2kuDlcp3aWM2twutunxNHcovRU4XUbGeuecW6iYHZkgWUo0dlQrgTd4e/lahf1HVxNtwdzXJ3Ta6oawV+XrmRU4LuI7KAWZTtB4GdivLtuM98N1VmtfKltZsWbGGDs1W3Q4udBb60VkUJAQc67MxasWObwud4zuSkBG0vUNCev1pIANQsZkzrlejruwowCMevAEILBOVFZ9w9mMFtPrV24rBvwPe2dHQCchwfXnmTgCCk0uyqsrspGG/k1wKbf5sF6hXbdYLBqvEcfJkeKf2Y8qg10uPt+xJZZSiAcuid++WBSaHw2htpwvBXwqjh63IcP+q6D/bMjetapVVsKAcnWVwCkZiHImgaTbxmcxTw4oRp/PMBj5h/cZTW6+9pnbZy+ydIxvBZ27L5NmGBqsQBrpnueqlHpFr0UlcdNxIgbYoq6qLJBQc0NNLnO/JwapiaZBIdAGcVoRTfqoCICjrpfyPgg4B5OxZPbzThtF7aZAMsiyNgR5qkA3JNof0iVCyRSB/PWxuUfMgsjhldl/fhJ5Ulan1pAKwQ63OJpbugmCZwgCM2Lr0OhLT87inc1sCwsD7V48v1nVeVs4wl0f2OIn41gkEn3yoFvcP8NrVWwI2dHBLc+D8o1dKtGAu8TsXzHq2rRIUdvAlMXEqJqgrHEbrT83X5HqzxPvrtdodRd4opiQPxTyyYcAZsePzNG16fBcomA3lbuNiI1
 260L8nRQ
 kyCAZeQvXkAYQyT2tO/eQ9qqj8OdFBn6rj+ZDciO73NIwg33wnTLr9HzB2eeAtBum0Je9G5Llc8bBb9yUCzXQ5CkSptJizTwUHuz/ocJ9++YuR7YH/URhYf4rGRzuspVLsQzN2S+LTNqxtNGBHMhJwAx/sVPLV9c8znuFBB9iRAM6ovWjbmuv/6uk1JOVsib/QlxOUE/jfBb06hW6cS7F+pl9ryQA6y9Wx/QD4SUiu3rES/k1m+XEDEDqY2J7w6/rIpSZLHEB1aLCPVkovodQe+dkPiQVtLh21vaLr1p9VXoVLVFY17dZ30+unKCl+kcDHDSm+ruZuGkw4MsDjPVRTXBIuYiPieDwRhDRw9WhOtc0cza/QLhrhq1X0dOjmvSkSL2s6Iazba//TCgokLV9ssp5ry4s/zH39AaHPlgz7ko36yd1F9smE8L69woG3xJ++bdFAOglnXyKPBXu9FvyM8QThKm/xs3Oe0HSNCTBsavzM0FgIgaLNYJI6MLlfRj9nOYX4SHPnyK/KBSCuB6ZOFVTGbRJFVdnl2Ii+7gB7NwYAIHgsCrYWvD48+L9QyYxc36K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The zswap tree code, specifically the range partition logic, can no
longer easily be reused for the new virtual swap space design. Use a
simple unified zswap tree in the new implementation for now.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/zswap.h |  7 -----
 mm/swapfile.c         |  9 +-----
 mm/zswap.c            | 69 +++++++------------------------------------
 3 files changed, 11 insertions(+), 74 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e1..1a04caf283dc8 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -28,8 +28,6 @@ unsigned long zswap_total_pages(void);
 bool zswap_store(struct folio *folio);
 int zswap_load(struct folio *folio);
 void zswap_invalidate(swp_entry_t swp);
-int zswap_swapon(int type, unsigned long nr_pages);
-void zswap_swapoff(int type);
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
 void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
@@ -50,11 +48,6 @@ static inline int zswap_load(struct folio *folio)
 }
 
 static inline void zswap_invalidate(swp_entry_t swp) {}
-static inline int zswap_swapon(int type, unsigned long nr_pages)
-{
-	return 0;
-}
-static inline void zswap_swapoff(int type) {}
 static inline void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg) {}
 static inline void zswap_lruvec_state_init(struct lruvec *lruvec) {}
 static inline void zswap_folio_swapin(struct folio *folio) {}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6b155471941c9..0372062743ef7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2972,7 +2972,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	arch_swap_invalidate_area(p->type);
-	zswap_swapoff(p->type);
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
@@ -3615,10 +3614,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		}
 	}
 
-	error = zswap_swapon(si->type, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	/*
 	 * Flush any pending IO and dirty mappings before we start using this
 	 * swap device.
@@ -3627,7 +3622,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	error = inode_drain_writes(inode);
 	if (error) {
 		inode->i_flags &= ~S_SWAPFILE;
-		goto free_swap_zswap;
+		goto bad_swap_unlock_inode;
 	}
 
 	mutex_lock(&swapon_mutex);
@@ -3650,8 +3645,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	error = 0;
 	goto out;
-free_swap_zswap:
-	zswap_swapoff(si->type);
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
diff --git a/mm/zswap.c b/mm/zswap.c
index a5a3f068bd1a6..f7313261673ff 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -197,8 +197,6 @@ struct zswap_entry {
 	struct list_head lru;
 };
 
-static struct xarray *zswap_trees[MAX_SWAPFILES];
-static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
 /* RCU-protected iteration */
 static LIST_HEAD(zswap_pools);
@@ -225,45 +223,35 @@ static bool zswap_has_pool;
 * helpers and fwd declarations
 **********************************/
 
-/* One swap address space for each 64M swap space */
-#define ZSWAP_ADDRESS_SPACE_SHIFT 14
-#define ZSWAP_ADDRESS_SPACE_PAGES (1 << ZSWAP_ADDRESS_SPACE_SHIFT)
-static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
-{
-	return &zswap_trees[swp_type(swp)][swp_offset(swp)
-		>> ZSWAP_ADDRESS_SPACE_SHIFT];
-}
+static DEFINE_XARRAY(zswap_tree);
+
+#define zswap_tree_index(entry)	(entry.val)
 
 static inline void *zswap_entry_store(swp_entry_t swpentry,
 		struct zswap_entry *entry)
 {
-	struct xarray *tree = swap_zswap_tree(swpentry);
-	pgoff_t offset = swp_offset(swpentry);
+	pgoff_t offset = zswap_tree_index(swpentry);
 
-	return xa_store(tree, offset, entry, GFP_KERNEL);
+	return xa_store(&zswap_tree, offset, entry, GFP_KERNEL);
 }
 
 static inline void *zswap_entry_load(swp_entry_t swpentry)
 {
-	struct xarray *tree = swap_zswap_tree(swpentry);
-	pgoff_t offset = swp_offset(swpentry);
+	pgoff_t offset = zswap_tree_index(swpentry);
 
-	return xa_load(tree, offset);
+	return xa_load(&zswap_tree, offset);
 }
 
 static inline void *zswap_entry_erase(swp_entry_t swpentry)
 {
-	struct xarray *tree = swap_zswap_tree(swpentry);
-	pgoff_t offset = swp_offset(swpentry);
+	pgoff_t offset = zswap_tree_index(swpentry);
 
-	return xa_erase(tree, offset);
+	return xa_erase(&zswap_tree, offset);
 }
 
 static inline bool zswap_empty(swp_entry_t swpentry)
 {
-	struct xarray *tree = swap_zswap_tree(swpentry);
-
-	return xa_empty(tree);
+	return xa_empty(&zswap_tree);
 }
 
 #define zswap_pool_debug(msg, p)			\
@@ -1691,43 +1679,6 @@ void zswap_invalidate(swp_entry_t swp)
 		zswap_entry_free(entry);
 }
 
-int zswap_swapon(int type, unsigned long nr_pages)
-{
-	struct xarray *trees, *tree;
-	unsigned int nr, i;
-
-	nr = DIV_ROUND_UP(nr_pages, ZSWAP_ADDRESS_SPACE_PAGES);
-	trees = kvcalloc(nr, sizeof(*tree), GFP_KERNEL);
-	if (!trees) {
-		pr_err("alloc failed, zswap disabled for swap type %d\n", type);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < nr; i++)
-		xa_init(trees + i);
-
-	nr_zswap_trees[type] = nr;
-	zswap_trees[type] = trees;
-	return 0;
-}
-
-void zswap_swapoff(int type)
-{
-	struct xarray *trees = zswap_trees[type];
-	unsigned int i;
-
-	if (!trees)
-		return;
-
-	/* try_to_unuse() invalidated all the entries already */
-	for (i = 0; i < nr_zswap_trees[type]; i++)
-		WARN_ON_ONCE(!xa_empty(trees + i));
-
-	kvfree(trees);
-	nr_zswap_trees[type] = 0;
-	zswap_trees[type] = NULL;
-}
-
 /*********************************
 * debugfs functions
 **********************************/
-- 
2.52.0


