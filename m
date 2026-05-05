Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA0A8CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C23C56B00C8; Tue,  5 May 2026 11:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFBCC6B00C9; Tue,  5 May 2026 11:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9C7D6B00CA; Tue,  5 May 2026 11:39:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE3C6B00C8
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 581FC1C02FD
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:42 +0000 (UTC)
X-FDA: 84733776204.06.752C4A5
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7C82F120004
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cNv+lAe8;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.177 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SFnpur4kaCmWn2QtDwqcZNICX0b5VDD5PDiPTKwjs6k=;
	b=DAMW3mk/bHCMunr9zwgixNaX6soSMGatxXOA+Aprgrfu7cg9xf0nsGpQNsNmz8484IwhWg
	2SzZ2H13OklvtQd6c6lxEqCvoQO60lmdiUIt0H072A6fgB2hjsVoyleSozqgJ5WbU5XWiI
	hvKRDK+NcNe0uQ+eIqEvxQZ45cSPQJw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995580; a=rsa-sha256;
	cv=none;
	b=TQb7CTyr92UJtTsy6Ya3VLKwfYTGCjphtWpOc33p160jzXra/fQsMPvqsz3eETuwGYHdzL
	r+shtytIJKRz+ykb2vC8/pn73NQobBxSMijJrOEr5flsIEOwgT0QFDNyOilI2U/4FBNKYO
	0p5MDtDlrlSpjkEFCUcLXCmK98DeJdg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cNv+lAe8;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.177 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-4756e74f8edso3549842b6e.1
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995579; x=1778600379; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SFnpur4kaCmWn2QtDwqcZNICX0b5VDD5PDiPTKwjs6k=;
        b=cNv+lAe8wt/5Vm5NctI2BeaBwo4D/oy1P8oTWx4aaXExW9MqZLCm7pAevrQR9Nkgqm
         UXbmxwaBdpIjTPY4VVAEasQWYHsEW1N59gvrVwme4fePQ3hSqVHaz+6c1kO2vVdWaCDU
         auWhA97MeAhU0SupZkUgRvgU6ZpGKcbQm8iDbNYUkoFJf1FGEWHkoxITY3qjbGtxxIte
         pCtGbYbeKY67rHeQVU5MowOXBvQQ0DwkVmwF+fm51Rc7FphHVJiX5Lb7LwYD46m7KsbA
         2m87dCtYk/P9piHYupvHjlUX/490P0RVYf2mpYzoGXjdVi3dheKc73maONr81szik8Xe
         K3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995579; x=1778600379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SFnpur4kaCmWn2QtDwqcZNICX0b5VDD5PDiPTKwjs6k=;
        b=oaKw1GXQCtLaQ+h2PXy7Q0QW4wuK0zBBbdVd9nFpof6J9Nrb5I6UTkkNylOI3m5OUD
         sh+v1PT7ZEDpFV/ChaHEFNPn7fGXie0ItS5fNO8jmWGz+c1e4iUAKYikthF//o1BBXkK
         Bwe8Tvk7zVF/Ng4qv+lMGwzXW73yA38ZjBefasj4Q2pMa+4kbidr/FlAlBrRdLiae2EY
         EZEG/TWmBSY6i+XfUxnhtP/svlC8KhJ1HtzuoVBWP5XBUhc9tLO5M0a9j2bMHthzy7UB
         ZREFIRUTP4MUdGz2+1lf/2iHdS5HwR+YnxuJLaqsZkBeKea0DE7yiZibpUUz6HoVgeeK
         cRDQ==
X-Forwarded-Encrypted: i=1; AFNElJ812tLYA0AxRvWop5+8LZbS6G1X6iqeAPuP6wLYDqZszkqCvDLz3YETZW/S7uTOgVjKDI5pYDJe8g==@kvack.org
X-Gm-Message-State: AOJu0Ywwqh1zFLtSWP7i710VpbK+xjBili0U5FilO2zv3abdhmPcpxBD
	BMV4CXOewPShY9jb7BdQj25r1gZkV2G4/GXyxTgOvhXeYWkAtWEB5K0A
X-Gm-Gg: AeBDievJ5c1ilMlZyoq58gmOrMgy1ubu6kM5VuBFzhl99yDOvvYaepjP+3Qua/CnpaZ
	ITMJgT5MjKVWa+46ic3VfPk5Nu3JFCqTL4BgDw0JgrUQOXiMI/KSYdxX+JKKcP2Jviy4RQhk7HA
	B1AvSdhpu2CYRoyEh6U7untZ/Gh7Fcz1mu4K6Sbnfrv1eY6kF+Urbge3k8xSzsKCbUK2X49oCeV
	RNLQi/LtkLXn3A76yQIIYbo41/3R10qbqAUXbAILR+xYKEX6YrYHSIGO1j6qhk/mZE0C2cnQs8d
	pplThvhmX0XOS8pI1RkVWFAY/ls7061b+AWkoUk0ukEjjuCOeGQUCtkXj8il4iwb//40e1zzMv9
	bVRI3KziUQdilxWNjk2XljqFBiBDrZf3Fg6hs9cY2A9aH736cLcFQPJbLGFFJNi/cQLOxBT8RHj
	ltjBRwcwAw+YGdNLGfQx/FQmx/K872nGIPw3ZGchaJTCsoE0gCaAkz5JwT
X-Received: by 2002:a05:6808:150d:b0:47b:ccf2:91e1 with SMTP id 5614622812f47-47c891b877fmr8054874b6e.21.1777995579204;
        Tue, 05 May 2026 08:39:39 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c760bd16dsm8463417b6e.0.2026.05.05.08.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:38 -0700 (PDT)
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
Subject: [PATCH v6 19/22] swap: simplify swapoff using virtual swap
Date: Tue,  5 May 2026 08:38:48 -0700
Message-ID: <20260505153854.1612033-20-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7C82F120004
X-Rspam-User: 
X-Stat-Signature: je1zbcf6q7n7rb6hcjfoj514qxdgsd37
X-HE-Tag: 1777995580-955879
X-HE-Meta: U2FsdGVkX1/yySNJCk+HcAQWnQp+oTqHWJeQD3jstNd7iIxcRNTTmksKOeQ4bHRh/2nV/w0PZ5u4RKFfuUwtFV3MBrtPbyZw3VoTHzuWGaEMHpUV+kG7wiYGuoVYkMO/1Mf8r6Abrh2L843241LjzyTK9fhMNvV7+EhG0DrYfF8vduA2PLO26Jnp4xB4PnDUdDh4sBQnT2Eml4HKNNS7ZxMMFcGZx1kQXqYPr/zHu4Fmz06k7y5CNsODst3ilreGwlFBozo7xXoc5wI95J7smFAOYLeBQF88iW8GU5qghtlRFysE9L3itVIGsFabvLxF+hWOHmdA8svbk0Js76LkSkiodbdnuMUW+em8/w75BZzWHQhzkJ/oIYysiarRPsGksdvQ38vr4VZlZo1U8k7DHNRl2YdQNWV8w/eqUfs0aAxxzkSB7uYBGeh+IDsjJDFCaOWLZD8M6vgeFSsHwNKUsmsZy+B/X44zRiBCrlbaqcev6wJ3x5gEkVOlRITkueBXpLRKnKSDFVg7NLrV32Remv8tiqRnA+w/w+LfFoCrDze0FD2ki/CEva+la51+PnOHCO17ju3C851n5zZ0Wc60Al88whVANfnx+u1J9ZKbOttdVAOGUAV2GGEJDX1fRBzkmTp5LWSGhISbFK6kxlFTtXff6wSsNyNWNz2ajtn5jbU1kjCXwscWmc0hp+9e47i1ju/Prm52JXrkBYI2p4RFGqrdVFv15IeVrgaNGYG1GnTg7+TvI177MLV9RYJbIfFQYjUk9EdinuD6Hd/PWWw+IV2Co8ApnlmILBOhSrA+WusHALGlxtPmuiaMcrfT7PNQhKWgLRKM9vvGPsfL2fmR9Mm36UMuBVRWdSGGuhQhyJCj0DzxbNTHUAUNw2gGWKtRQN756e4wrfcasfCjcFoQeJ3AKzeiyPqTc5htpo6+RqOGIO4sRCf3gKJHbWt/jhIwyQfaVLVAJWPW4gy/2qx
 ZMmXy+9f
 MdgfAG0XjLtFHNbESzWq1unc5vz1gCaDdShheuROSvWn+wIBqZTMlfgZ2gUvINe/dFizIn9galIcK40Ek6Vyb+hIv02uyfJgOhgGhY/h+FIrwYtHC7ABwBzGSXJrjsjJx4uynJ2vID0nGtXRFYq0rmLnu3qXtZq4xfVV8fIXluAsxK/YV++f3cWnXy9H10c5bQ9DShR0IBqDcA7q+2NZ9B9I3CI/Jj0iQhDeoFJ048NBk+ejFeUlaC0mQqGyBlDwpEWSVX8L6OAZQSmLnCQ8vkVCvB+Wq7jXeue2SXjRTmfHhEAuNqMtq4bDKHq1W//ynEdTncSVkwXnv2xA/uhFM4XyTwO4miwFLZqmrpTpb1wiEip/yCvLj+EotZHmz7Bps3qFHGgxQiCGAusoBW0iyAqZQwyddE+tf+MK5ImvxElA/Z32CuhTkcCr/W0UcpaX4Ao1Cv0ED2cUBmB9U1rb+lS/jyn8JkqRY1qX/uFrRc87j9HOKcpgK+sI6DkRaDaPMfevVGCUsuWuocbdpqHsF98yVtsrmtE/VIVVR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch presents the second applications of virtual swap design -
simplifying and optimizing swapoff.

With virtual swap slots stored at page table entries and used as indices
to various swap-related data structures, we no longer have to perform a
page table walk in swapoff. Simply iterate through all the allocated
swap slots on the swapfile, find their corresponding virtual swap slots,
and fault them in.

This is significantly cleaner, as well as slightly more performant,
especially when there are a lot of unrelated VMAs (since the old swapoff
code would have to traverse through all of them).

In a simple benchmark, in which we swapoff a 32 GB swapfile that is 50%
full, and in which there is a process that maps a 128GB file into
memory:

Baseline:
sys: 11.48s

New Design:
sys: 9.96s

Disregarding the real time reduction (which is mostly due to more IO
asynchrony), the new design reduces the kernel CPU time by about 13%.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/shmem_fs.h |   9 +-
 mm/filemap.c             |  14 +-
 mm/shmem.c               | 196 +---------------
 mm/swapfile.c            | 474 +++++++++------------------------------
 4 files changed, 127 insertions(+), 566 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index e2069b3179c4..8f45bd65dc20 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -40,18 +40,14 @@ struct shmem_inode_info {
 	unsigned long		alloced;	/* data pages alloced to file */
 	unsigned long		swapped;	/* subtotal assigned to swap */
 	union {
-	    struct offset_ctx	dir_offsets;	/* stable directory offsets */
-	    struct {
-		struct list_head shrinklist;	/* shrinkable hpage inodes */
-		struct list_head swaplist;	/* chain of maybes on swap */
-	    };
+		struct offset_ctx	dir_offsets;	/* stable directory offsets */
+		struct list_head	shrinklist;	/* shrinkable hpage inodes */
 	};
 	struct timespec64	i_crtime;	/* file creation time */
 	struct shared_policy	policy;		/* NUMA memory alloc policy */
 	struct simple_xattrs	xattrs;		/* list of xattrs */
 	pgoff_t			fallocend;	/* highest fallocate endindex */
 	unsigned int		fsflags;	/* for FS_IOC_[SG]ETFLAGS */
-	atomic_t		stop_eviction;	/* hold when working on inode */
 #ifdef CONFIG_TMPFS_QUOTA
 	struct dquot __rcu	*i_dquot[MAXQUOTAS];
 #endif
@@ -127,7 +123,6 @@ struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		struct list_head *folio_list);
 void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
-int shmem_unuse(unsigned int type);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
diff --git a/mm/filemap.c b/mm/filemap.c
index ebd75684cb0a..53aad273ea2f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4614,13 +4614,13 @@ static void filemap_cachestat(struct address_space *mapping,
 
 				/*
 				 * Getting a swap entry from the shmem
-				 * inode means we beat
-				 * shmem_unuse(). rcu_read_lock()
-				 * ensures swapoff waits for us before
-				 * freeing the swapper space. However,
-				 * we can race with swapping and
-				 * invalidation, so there might not be
-				 * a shadow in the swapcache (yet).
+				 * inode means we beat swapoff.
+				 * rcu_read_lock() ensures swapoff waits
+				 * for us before freeing the swapper
+				 * space. However, we can race with
+				 * swapping and invalidation, so there
+				 * might not be a shadow in the swapcache
+				 * (yet).
 				 */
 				shadow = swap_cache_get_shadow(swp);
 				if (!shadow)
diff --git a/mm/shmem.c b/mm/shmem.c
index 3a346cca114a..984e01ea88d3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -290,9 +290,6 @@ bool vma_is_shmem(const struct vm_area_struct *vma)
 	return vma_is_anon_shmem(vma) || vma->vm_ops == &shmem_vm_ops;
 }
 
-static LIST_HEAD(shmem_swaplist);
-static DEFINE_SPINLOCK(shmem_swaplist_lock);
-
 #ifdef CONFIG_TMPFS_QUOTA
 
 static int shmem_enable_quotas(struct super_block *sb,
@@ -1413,16 +1410,6 @@ static void shmem_evict_inode(struct inode *inode)
 			}
 			spin_unlock(&sbinfo->shrinklist_lock);
 		}
-		while (!list_empty(&info->swaplist)) {
-			/* Wait while shmem_unuse() is scanning this inode... */
-			wait_var_event(&info->stop_eviction,
-				       !atomic_read(&info->stop_eviction));
-			spin_lock(&shmem_swaplist_lock);
-			/* ...but beware of the race if we peeked too early */
-			if (!atomic_read(&info->stop_eviction))
-				list_del_init(&info->swaplist);
-			spin_unlock(&shmem_swaplist_lock);
-		}
 	}
 
 	simple_xattrs_free(&info->xattrs, sbinfo->max_inodes ? &freed : NULL);
@@ -1435,153 +1422,6 @@ static void shmem_evict_inode(struct inode *inode)
 #endif
 }
 
-static unsigned int shmem_find_swap_entries(struct address_space *mapping,
-				pgoff_t start, struct folio_batch *fbatch,
-				pgoff_t *indices, unsigned int type)
-{
-	XA_STATE(xas, &mapping->i_pages, start);
-	struct folio *folio;
-	swp_entry_t entry;
-	swp_slot_t slot;
-
-	rcu_read_lock();
-	xas_for_each(&xas, folio, ULONG_MAX) {
-		if (xas_retry(&xas, folio))
-			continue;
-
-		if (!xa_is_value(folio))
-			continue;
-
-		entry = radix_to_swp_entry(folio);
-		slot = swp_entry_to_swp_slot(entry);
-
-		/*
-		 * swapin error entries can be found in the mapping. But they're
-		 * deliberately ignored here as we've done everything we can do.
-		 */
-		if (!slot.val || swp_slot_type(slot) != type)
-			continue;
-
-		indices[folio_batch_count(fbatch)] = xas.xa_index;
-		if (!folio_batch_add(fbatch, folio))
-			break;
-
-		if (need_resched()) {
-			xas_pause(&xas);
-			cond_resched_rcu();
-		}
-	}
-	rcu_read_unlock();
-
-	return folio_batch_count(fbatch);
-}
-
-/*
- * Move the swapped pages for an inode to page cache. Returns the count
- * of pages swapped in, or the error in case of failure.
- */
-static int shmem_unuse_swap_entries(struct inode *inode,
-		struct folio_batch *fbatch, pgoff_t *indices)
-{
-	int i = 0;
-	int ret = 0;
-	int error = 0;
-	struct address_space *mapping = inode->i_mapping;
-
-	for (i = 0; i < folio_batch_count(fbatch); i++) {
-		struct folio *folio = fbatch->folios[i];
-
-		error = shmem_swapin_folio(inode, indices[i], &folio, SGP_CACHE,
-					mapping_gfp_mask(mapping), NULL, NULL);
-		if (error == 0) {
-			folio_unlock(folio);
-			folio_put(folio);
-			ret++;
-		}
-		if (error == -ENOMEM)
-			break;
-		error = 0;
-	}
-	return error ? error : ret;
-}
-
-/*
- * If swap found in inode, free it and move page from swapcache to filecache.
- */
-static int shmem_unuse_inode(struct inode *inode, unsigned int type)
-{
-	struct address_space *mapping = inode->i_mapping;
-	pgoff_t start = 0;
-	struct folio_batch fbatch;
-	pgoff_t indices[PAGEVEC_SIZE];
-	int ret = 0;
-
-	do {
-		folio_batch_init(&fbatch);
-		if (!shmem_find_swap_entries(mapping, start, &fbatch,
-					     indices, type)) {
-			ret = 0;
-			break;
-		}
-
-		ret = shmem_unuse_swap_entries(inode, &fbatch, indices);
-		if (ret < 0)
-			break;
-
-		start = indices[folio_batch_count(&fbatch) - 1];
-	} while (true);
-
-	return ret;
-}
-
-/*
- * Read all the shared memory data that resides in the swap
- * device 'type' back into memory, so the swap device can be
- * unused.
- */
-int shmem_unuse(unsigned int type)
-{
-	struct shmem_inode_info *info, *next;
-	int error = 0;
-
-	if (list_empty(&shmem_swaplist))
-		return 0;
-
-	spin_lock(&shmem_swaplist_lock);
-start_over:
-	list_for_each_entry_safe(info, next, &shmem_swaplist, swaplist) {
-		if (!info->swapped) {
-			list_del_init(&info->swaplist);
-			continue;
-		}
-		/*
-		 * Drop the swaplist mutex while searching the inode for swap;
-		 * but before doing so, make sure shmem_evict_inode() will not
-		 * remove placeholder inode from swaplist, nor let it be freed
-		 * (igrab() would protect from unlink, but not from unmount).
-		 */
-		atomic_inc(&info->stop_eviction);
-		spin_unlock(&shmem_swaplist_lock);
-
-		error = shmem_unuse_inode(&info->vfs_inode, type);
-		cond_resched();
-
-		spin_lock(&shmem_swaplist_lock);
-		if (atomic_dec_and_test(&info->stop_eviction))
-			wake_up_var(&info->stop_eviction);
-		if (error)
-			break;
-		if (list_empty(&info->swaplist))
-			goto start_over;
-		next = list_next_entry(info, swaplist);
-		if (!info->swapped)
-			list_del_init(&info->swaplist);
-	}
-	spin_unlock(&shmem_swaplist_lock);
-
-	return error;
-}
-
 /**
  * shmem_writeout - Write the folio to swap
  * @folio: The folio to write
@@ -1668,24 +1508,9 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	}
 
 	if (!folio_alloc_swap(folio)) {
-		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
 		int error;
 
-		/*
-		 * Add inode to shmem_unuse()'s list of swapped-out inodes,
-		 * if it's not already there.  Do it now before the folio is
-		 * removed from page cache, when its pagelock no longer
-		 * protects the inode from eviction.  And do it now, after
-		 * we've incremented swapped, because shmem_unuse() will
-		 * prune a !swapped inode from the swaplist.
-		 */
-		if (first_swapped) {
-			spin_lock(&shmem_swaplist_lock);
-			if (list_empty(&info->swaplist))
-				list_add(&info->swaplist, &shmem_swaplist);
-			spin_unlock(&shmem_swaplist_lock);
-		}
-
+		shmem_recalc_inode(inode, 0, nr_pages);
 		swap_shmem_alloc(folio->swap, nr_pages);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
@@ -2116,12 +1941,12 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 }
 
 /*
- * When a page is moved from swapcache to shmem filecache (either by the
- * usual swapin of shmem_get_folio_gfp(), or by the less common swapoff of
- * shmem_unuse_inode()), it may have been read in earlier from swap, in
- * ignorance of the mapping it belongs to.  If that mapping has special
- * constraints (like the gma500 GEM driver, which requires RAM below 4GB),
- * we may need to copy to a suitable page before moving to filecache.
+ * When a page is moved from swapcache to shmem filecache (by the usual
+ * swapin of shmem_get_folio_gfp()), it may have been read in earlier from
+ * swap, in ignorance of the mapping it belongs to.  If that mapping has
+ * special constraints (like the gma500 GEM driver, which requires RAM
+ * below 4GB), we may need to copy to a suitable page before moving to
+ * filecache.
  *
  * In a future release, this may well be extended to respect cpuset and
  * NUMA mempolicy, and applied also to anonymous pages in do_swap_page();
@@ -3106,7 +2931,6 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	info = SHMEM_I(inode);
 	memset(info, 0, (char *)inode - (char *)info);
 	spin_lock_init(&info->lock);
-	atomic_set(&info->stop_eviction, 0);
 	info->seals = F_SEAL_SEAL;
 	info->flags = (flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
 	info->i_crtime = inode_get_mtime(inode);
@@ -3115,7 +2939,6 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	if (info->fsflags)
 		shmem_set_inode_flags(inode, info->fsflags, NULL);
 	INIT_LIST_HEAD(&info->shrinklist);
-	INIT_LIST_HEAD(&info->swaplist);
 	simple_xattrs_init(&info->xattrs);
 	cache_no_acl(inode);
 	if (sbinfo->noswap)
@@ -5785,11 +5608,6 @@ void __init shmem_init(void)
 	BUG_ON(IS_ERR(shm_mnt));
 }
 
-int shmem_unuse(unsigned int type)
-{
-	return 0;
-}
-
 int shmem_lock(struct file *file, int lock, struct ucounts *ucounts)
 {
 	return 0;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index ce1254733e96..701bc80bc381 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1697,300 +1697,12 @@ unsigned int count_swap_pages(int type, int free)
 }
 #endif /* CONFIG_HIBERNATION */
 
-static inline int pte_same_as_swp(pte_t pte, pte_t swp_pte)
+static bool swap_slot_allocated(struct swap_info_struct *si,
+		unsigned long offset)
 {
-	return pte_same(pte_swp_clear_flags(pte), swp_pte);
-}
-
-/*
- * No need to decide whether this PTE shares the swap entry with others,
- * just let do_wp_page work it out if a write is requested later - to
- * force COW, vm_page_prot omits write permission from any private vma.
- */
-static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long addr, swp_entry_t entry, struct folio *folio)
-{
-	struct page *page;
-	struct folio *swapcache;
-	spinlock_t *ptl;
-	pte_t *pte, new_pte, old_pte;
-	bool hwpoisoned = false;
-	int ret = 1;
-
-	/*
-	 * If the folio is removed from swap cache by others, continue to
-	 * unuse other PTEs. try_to_unuse may try again if we missed this one.
-	 */
-	if (!folio_matches_swap_entry(folio, entry))
-		return 0;
-
-	swapcache = folio;
-	folio = ksm_might_need_to_copy(folio, vma, addr);
-	if (unlikely(!folio))
-		return -ENOMEM;
-	else if (unlikely(folio == ERR_PTR(-EHWPOISON))) {
-		hwpoisoned = true;
-		folio = swapcache;
-	}
-
-	page = folio_file_page(folio, swp_offset(entry));
-	if (PageHWPoison(page))
-		hwpoisoned = true;
-
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	if (unlikely(!pte || !pte_same_as_swp(ptep_get(pte),
-						swp_entry_to_pte(entry)))) {
-		ret = 0;
-		goto out;
-	}
-
-	old_pte = ptep_get(pte);
-
-	if (unlikely(hwpoisoned || !folio_test_uptodate(folio))) {
-		swp_entry_t swp_entry;
-
-		dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
-		if (hwpoisoned) {
-			swp_entry = make_hwpoison_entry(page);
-		} else {
-			swp_entry = make_poisoned_swp_entry();
-		}
-		new_pte = swp_entry_to_pte(swp_entry);
-		ret = 0;
-		goto setpte;
-	}
-
-	/*
-	 * Some architectures may have to restore extra metadata to the page
-	 * when reading from swap. This metadata may be indexed by swap entry
-	 * so this must be called before swap_free().
-	 */
-	arch_swap_restore(folio_swap(entry, folio), folio);
-
-	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
-	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
-	folio_get(folio);
-	if (folio == swapcache) {
-		rmap_t rmap_flags = RMAP_NONE;
-
-		/*
-		 * See do_swap_page(): writeback would be problematic.
-		 * However, we do a folio_wait_writeback() just before this
-		 * call and have the folio locked.
-		 */
-		VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
-		if (pte_swp_exclusive(old_pte))
-			rmap_flags |= RMAP_EXCLUSIVE;
-		/*
-		 * We currently only expect small !anon folios, which are either
-		 * fully exclusive or fully shared. If we ever get large folios
-		 * here, we have to be careful.
-		 */
-		if (!folio_test_anon(folio)) {
-			VM_WARN_ON_ONCE(folio_test_large(folio));
-			VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
-			folio_add_new_anon_rmap(folio, vma, addr, rmap_flags);
-		} else {
-			folio_add_anon_rmap_pte(folio, page, vma, addr, rmap_flags);
-		}
-	} else { /* ksm created a completely new copy */
-		folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
-		folio_add_lru_vma(folio, vma);
-	}
-	new_pte = pte_mkold(mk_pte(page, vma->vm_page_prot));
-	if (pte_swp_soft_dirty(old_pte))
-		new_pte = pte_mksoft_dirty(new_pte);
-	if (pte_swp_uffd_wp(old_pte))
-		new_pte = pte_mkuffd_wp(new_pte);
-setpte:
-	set_pte_at(vma->vm_mm, addr, pte, new_pte);
-	swap_free(entry);
-out:
-	if (pte)
-		pte_unmap_unlock(pte, ptl);
-	if (folio != swapcache) {
-		folio_unlock(folio);
-		folio_put(folio);
-	}
-	return ret;
-}
-
-static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-			unsigned long addr, unsigned long end,
-			unsigned int type)
-{
-	pte_t *pte = NULL;
-	struct swap_info_struct *si;
-
-	si = swap_info[type];
-	do {
-		struct folio *folio;
-		unsigned long offset;
-		unsigned char swp_count;
-		softleaf_t entry;
-		swp_slot_t slot;
-		int ret;
-		pte_t ptent;
-
-		if (!pte++) {
-			pte = pte_offset_map(pmd, addr);
-			if (!pte)
-				break;
-		}
-
-		ptent = ptep_get_lockless(pte);
-		entry = softleaf_from_pte(ptent);
-
-		if (!softleaf_is_swap(entry))
-			continue;
-
-		slot = swp_entry_to_swp_slot(entry);
-		if (swp_slot_type(slot) != type)
-			continue;
-
-		offset = swp_slot_offset(slot);
-		pte_unmap(pte);
-		pte = NULL;
-
-		folio = swap_cache_get_folio(entry);
-		if (!folio) {
-			struct vm_fault vmf = {
-				.vma = vma,
-				.address = addr,
-				.real_address = addr,
-				.pmd = pmd,
-			};
-
-			folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
-						&vmf);
-		}
-		if (!folio) {
-			swp_count = READ_ONCE(si->swap_map[offset]);
-			if (swp_count == 0 || swp_count == SWAP_MAP_BAD)
-				continue;
-			return -ENOMEM;
-		}
-
-		folio_lock(folio);
-		folio_wait_writeback(folio);
-		ret = unuse_pte(vma, pmd, addr, entry, folio);
-		if (ret < 0) {
-			folio_unlock(folio);
-			folio_put(folio);
-			return ret;
-		}
-
-		folio_free_swap(folio);
-		folio_unlock(folio);
-		folio_put(folio);
-	} while (addr += PAGE_SIZE, addr != end);
-
-	if (pte)
-		pte_unmap(pte);
-	return 0;
-}
-
-static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
-				unsigned long addr, unsigned long end,
-				unsigned int type)
-{
-	pmd_t *pmd;
-	unsigned long next;
-	int ret;
-
-	pmd = pmd_offset(pud, addr);
-	do {
-		cond_resched();
-		next = pmd_addr_end(addr, end);
-		ret = unuse_pte_range(vma, pmd, addr, next, type);
-		if (ret)
-			return ret;
-	} while (pmd++, addr = next, addr != end);
-	return 0;
-}
-
-static inline int unuse_pud_range(struct vm_area_struct *vma, p4d_t *p4d,
-				unsigned long addr, unsigned long end,
-				unsigned int type)
-{
-	pud_t *pud;
-	unsigned long next;
-	int ret;
-
-	pud = pud_offset(p4d, addr);
-	do {
-		next = pud_addr_end(addr, end);
-		if (pud_none_or_clear_bad(pud))
-			continue;
-		ret = unuse_pmd_range(vma, pud, addr, next, type);
-		if (ret)
-			return ret;
-	} while (pud++, addr = next, addr != end);
-	return 0;
-}
-
-static inline int unuse_p4d_range(struct vm_area_struct *vma, pgd_t *pgd,
-				unsigned long addr, unsigned long end,
-				unsigned int type)
-{
-	p4d_t *p4d;
-	unsigned long next;
-	int ret;
-
-	p4d = p4d_offset(pgd, addr);
-	do {
-		next = p4d_addr_end(addr, end);
-		if (p4d_none_or_clear_bad(p4d))
-			continue;
-		ret = unuse_pud_range(vma, p4d, addr, next, type);
-		if (ret)
-			return ret;
-	} while (p4d++, addr = next, addr != end);
-	return 0;
-}
-
-static int unuse_vma(struct vm_area_struct *vma, unsigned int type)
-{
-	pgd_t *pgd;
-	unsigned long addr, end, next;
-	int ret;
-
-	addr = vma->vm_start;
-	end = vma->vm_end;
-
-	pgd = pgd_offset(vma->vm_mm, addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		if (pgd_none_or_clear_bad(pgd))
-			continue;
-		ret = unuse_p4d_range(vma, pgd, addr, next, type);
-		if (ret)
-			return ret;
-	} while (pgd++, addr = next, addr != end);
-	return 0;
-}
+	unsigned char count = READ_ONCE(si->swap_map[offset]);
 
-static int unuse_mm(struct mm_struct *mm, unsigned int type)
-{
-	struct vm_area_struct *vma;
-	int ret = 0;
-	VMA_ITERATOR(vmi, mm, 0);
-
-	mmap_read_lock(mm);
-	if (check_stable_address_space(mm))
-		goto unlock;
-	for_each_vma(vmi, vma) {
-		if (vma->anon_vma && !is_vm_hugetlb_page(vma)) {
-			ret = unuse_vma(vma, type);
-			if (ret)
-				break;
-		}
-
-		cond_resched();
-	}
-unlock:
-	mmap_read_unlock(mm);
-	return ret;
+	return count && swap_count(count) != SWAP_MAP_BAD;
 }
 
 /*
@@ -2002,7 +1714,6 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 					unsigned int prev)
 {
 	unsigned int i;
-	unsigned char count;
 
 	/*
 	 * No need for swap_lock here: we're just looking
@@ -2011,8 +1722,7 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	 * allocations from this area (while holding swap_lock).
 	 */
 	for (i = prev + 1; i < si->max; i++) {
-		count = READ_ONCE(si->swap_map[i]);
-		if (count && swap_count(count) != SWAP_MAP_BAD)
+		if (swap_slot_allocated(si, i))
 			break;
 		if ((i % LATENCY_LIMIT) == 0)
 			cond_resched();
@@ -2024,101 +1734,139 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	return i;
 }
 
+#define for_each_allocated_offset(si, offset)	\
+	while (swap_usage_in_pages(si) && \
+		!signal_pending(current) && \
+		(offset = find_next_to_unuse(si, offset)) != 0)
+
+static struct folio *pagein(swp_entry_t entry, struct swap_iocb **splug,
+		struct mempolicy *mpol)
+{
+	bool folio_was_allocated;
+	struct folio *folio = __read_swap_cache_async(entry, GFP_KERNEL, mpol,
+			NO_INTERLEAVE_INDEX, &folio_was_allocated, false);
+
+	if (folio_was_allocated)
+		swap_read_folio(folio, splug);
+	return folio;
+}
+
 static int try_to_unuse(unsigned int type)
 {
-	struct mm_struct *prev_mm;
-	struct mm_struct *mm;
-	struct list_head *p;
-	int retval = 0;
 	struct swap_info_struct *si = swap_info[type];
+	struct swap_iocb *splug = NULL;
+	struct mempolicy *mpol;
+	struct blk_plug plug;
+	unsigned long offset;
 	struct folio *folio;
 	swp_entry_t entry;
 	swp_slot_t slot;
-	unsigned int i;
+	int ret = 0;
 
 	if (!swap_usage_in_pages(si))
 		goto success;
 
-retry:
-	retval = shmem_unuse(type);
-	if (retval)
-		return retval;
-
-	prev_mm = &init_mm;
-	mmget(prev_mm);
-
-	spin_lock(&mmlist_lock);
-	p = &init_mm.mmlist;
-	while (swap_usage_in_pages(si) &&
-	       !signal_pending(current) &&
-	       (p = p->next) != &init_mm.mmlist) {
+	mpol = get_task_policy(current);
+	blk_start_plug(&plug);
 
-		mm = list_entry(p, struct mm_struct, mmlist);
-		if (!mmget_not_zero(mm))
+	/* first round - submit the reads */
+	offset = 0;
+	for_each_allocated_offset(si, offset) {
+		slot = swp_slot(type, offset);
+		entry = swp_slot_to_swp_entry(slot);
+		if (!entry.val)
 			continue;
-		spin_unlock(&mmlist_lock);
-		mmput(prev_mm);
-		prev_mm = mm;
-		retval = unuse_mm(mm, type);
-		if (retval) {
-			mmput(prev_mm);
-			return retval;
-		}
 
-		/*
-		 * Make sure that we aren't completely killing
-		 * interactive performance.
-		 */
-		cond_resched();
-		spin_lock(&mmlist_lock);
+		folio = pagein(entry, &splug, mpol);
+		if (folio)
+			folio_put(folio);
 	}
-	spin_unlock(&mmlist_lock);
+	blk_finish_plug(&plug);
+	swap_read_unplug(splug);
+	splug = NULL;
+	lru_add_drain();
+
+	/* second round - updating the virtual swap slots' backing state */
+	offset = 0;
+	for_each_allocated_offset(si, offset) {
+		slot = swp_slot(type, offset);
+retry:
+		entry = swp_slot_to_swp_entry(slot);
+		if (!entry.val) {
+			if (!swap_slot_allocated(si, offset))
+				continue;
 
-	mmput(prev_mm);
+			if (signal_pending(current)) {
+				ret = -EINTR;
+				goto out;
+			}
 
-	i = 0;
-	while (swap_usage_in_pages(si) &&
-	       !signal_pending(current) &&
-	       (i = find_next_to_unuse(si, i)) != 0) {
+			/* we might be racing with zswap writeback or disk swapout */
+			schedule_timeout_uninterruptible(1);
+			goto retry;
+		}
 
-		slot = swp_slot(type, i);
-		entry = swp_slot_to_swp_entry(slot);
-		folio = swap_cache_get_folio(entry);
-		if (!folio)
-			continue;
+		/* try to allocate swap cache folio */
+		folio = pagein(entry, &splug, mpol);
+		if (!folio) {
+			if (!swp_slot_to_swp_entry(swp_slot(type, offset)).val)
+				continue;
 
+			ret = -ENOMEM;
+			pr_err("swapoff: unable to allocate swap cache folio for %lu\n",
+						entry.val);
+			goto out;
+		}
+
+		folio_lock(folio);
 		/*
-		 * It is conceivable that a racing task removed this folio from
-		 * swap cache just before we acquired the page lock. The folio
-		 * might even be back in swap cache on another swap area. But
-		 * that is okay, folio_free_swap() only removes stale folios.
+		 * We need to check if the folio is still in swap cache, and is still
+		 * backed by the physical swap slot we are trying to release.
+		 *
+		 * We can, for instance, race with zswap writeback, obtaining the
+		 * temporary folio it allocated for decompression and writeback, which
+		 * would be promptly deleted from swap cache. By the time we lock that
+		 * folio, it might have already contained stale data.
+		 *
+		 * Concurrent swap operations might have also come in before we
+		 * reobtain the folio's lock, deleting the folio from swap cache,
+		 * invalidating the virtual swap slot, then swapping out the folio
+		 * again to a different swap backends.
+		 *
+		 * In all of these cases, we must retry the physical -> virtual lookup.
 		 */
-		folio_lock(folio);
+		if (!folio_matches_swap_slot(folio, entry, slot)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			if (signal_pending(current)) {
+				ret = -EINTR;
+				goto out;
+			}
+			schedule_timeout_uninterruptible(1);
+			goto retry;
+		}
+
 		folio_wait_writeback(folio);
-		folio_free_swap(folio);
+		vswap_store_folio(entry, folio);
+		folio_mark_dirty(folio);
 		folio_unlock(folio);
 		folio_put(folio);
 	}
 
-	/*
-	 * Lets check again to see if there are still swap entries in the map.
-	 * If yes, we would need to do retry the unuse logic again.
-	 * Under global memory pressure, swap entries can be reinserted back
-	 * into process space after the mmlist loop above passes over them.
-	 *
-	 * Limit the number of retries? No: when mmget_not_zero()
-	 * above fails, that mm is likely to be freeing swap from
-	 * exit_mmap(), which proceeds at its own independent pace;
-	 * and even shmem_writeout() could have been preempted after
-	 * folio_alloc_swap(), temporarily hiding that swap.  It's easy
-	 * and robust (though cpu-intensive) just to keep retrying.
-	 */
-	if (swap_usage_in_pages(si)) {
-		if (!signal_pending(current))
-			goto retry;
-		return -EINTR;
+	/* concurrent swappers might still be releasing physical swap slots... */
+	while (swap_usage_in_pages(si)) {
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			goto out;
+		}
+		schedule_timeout_uninterruptible(1);
 	}
 
+out:
+	swap_read_unplug(splug);
+	if (ret)
+		return ret;
+
 success:
 	/*
 	 * Make sure that further cleanups after try_to_unuse() returns happen
-- 
2.52.0


