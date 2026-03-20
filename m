Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B001099B39
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062A36B016E; Fri, 20 Mar 2026 15:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA556B0170; Fri, 20 Mar 2026 15:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34996B0171; Fri, 20 Mar 2026 15:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA1666B016E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:28:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8EAFFC0BA8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:28:08 +0000 (UTC)
X-FDA: 84567427056.18.A940660
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id B1D7B80006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:28:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C3MvWN2R;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3Gvdm3PaljwFAuBB/+7hzNv2aerA2JysVE5/2pi+vc=;
	b=A6iSDorYeeZMzoXTbKKXwn3CEjmIgTgEs4IiejDc0tE+hwNl3EevcFEDeg/LRGf0gwlxdq
	Ee4oxZxELpN7xs+iwwhzMGd0XKfZgq6Qxew886WtiN31c9DJfIZkNlvwr47daQZRexxmuW
	NUoVFkpu2vGmfRVVrjCx0I1rPgrydMM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C3MvWN2R;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034886; a=rsa-sha256;
	cv=none;
	b=mcRKLiLb3MRUL7No7VAQwu7135+5FxTjIUs2E4dS85qgF4aX/adibfx7i/NHNhDhnccHt2
	EWbeEcm1qht3SKPyhNv1GKSrJzW7qIKxd4R+2ENXL/yPv6zXOY0FWRi+ZDOrQbIJL30joe
	mxdhwCg4hvFW0S1Dwj8EaYqrjQEIx68=
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d7f8f0d7c9so363056a34.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034886; x=1774639686; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I3Gvdm3PaljwFAuBB/+7hzNv2aerA2JysVE5/2pi+vc=;
        b=C3MvWN2R2NtB54WyUcVVSAubGFoKsltR3JZp6e2YzFLPS1XbdPI+3zZ0850OXaKk5x
         tqG8ymKj3Po/N6tk2b2vcNvmAojjtzSyYTHM/LSJl06TwFsRGEaVk+ZDs8PszyFN3HD0
         sJEpVGB4AACVmLIBijnf08pWQ537se5mKfOccmijt/b68etXEkISIfAOeZmYokwcytZs
         FEYINd2Ku2J/BEVk7fmQxFFlCXt59v9KqysFSY9RB7kMl8Mzjx3XE6g0I3uoMNwqpIIc
         WYQoYK/xuVHqMVmEvmvOB7t479K9cKjPkl2mNr1nNPDS+kKOv6BJpyu5hhQSIfHWkKUL
         aITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034886; x=1774639686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I3Gvdm3PaljwFAuBB/+7hzNv2aerA2JysVE5/2pi+vc=;
        b=X6V7vdr1DyIUQCwtuBF2wm8JANCZJIvV2lZz+bdrh7YXRBmDRuxS1vgce25VH+4WKw
         afGklUz2gIvwjZhutVtjtyVgPAK24ilu86lBI6SK6Gt35Wgg1r93CFIxsNay5HxjOKI0
         iQWxsL0Pp4ZEctpysPi9uSOEBoeOYQKTX3xMiHax4T6dIGubxAi4Fm7I5crwHEtUtZNq
         uMg4H20Uy1tERIkR+TYJKQHR5G3qq3tALIb9LLtmZfnuArhAMbVrV6xqFhF9oN44R1Wj
         8SYpzNkkszIWyNkiSdSAzX+m2eqbxKVE72y4W1Uq6PHLKPWzKomd3dUWYLnDf2+JgtUM
         qpLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQPp9vcviWa4Pi3h17q+OpJiNrmiey15onFyPySPVFVcygtG1DWPpOMG7fqefJt+2V+/y+OXlCOQ==@kvack.org
X-Gm-Message-State: AOJu0YzVpTFHy1WO4SmFVTkRTbWOYjvDtRS/ZvdkP/KINqh25mGu2TEP
	BCCQu5E1+ZxwuBFU29Efizi1VNvJIn7JKQF0CH/1e1WV/o86NzRGrTnR
X-Gm-Gg: ATEYQzy1CSCNKdC+rhcJRy0rCZM+bg/HSG43hma5clflZx6WcK/vxuWuvq/hU8eMiCz
	Nkp0q4DdfMy97sABIqYREVUR7oiSmTgWreOAMyjoJWrgYxx+idrO1P6Vk9EAK00zq47+/dGU02T
	dz1keITkJpA6AJfneppAOHkIsXbQqsqIEgZnX10JwJ2mlzpRDUVUI2dc+3BItQce8XSJUWdd0ft
	C9dAcSVOZogP+aFB29jIw37uanGBK9iCyL446z+M4qnn7k0ZDZ+LRwRDQGegRN9CDE62d72/E/N
	vQBTKJt1wyyGG2nPFxzwaiE0cTaYVo8YqfMFMcM1MgLKJJotGzhAbRYsSyXPYAA4mH9kNewrtni
	WnUO5uwCKM85kG0PjBdy2sPNK0SZNSDsS+yoR1VSEnrd1MoLMUnuJ+n7ffWHCwMdJcuPF8AUTIE
	7MrqftOkHsUgae5U3z04sGeGWpaLzX0HU+5xKmnUgNqBqRxg==
X-Received: by 2002:a05:6830:4486:b0:7c6:9eac:2385 with SMTP id 46e09a7af769-7d7eae6243bmr2598575a34.5.1774034885485;
        Fri, 20 Mar 2026 12:28:05 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:72::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7fbee2c6dsm332595a34.1.2026.03.20.12.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:28:05 -0700 (PDT)
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
Subject: [PATCH v5 19/21] swap: simplify swapoff using virtual swap
Date: Fri, 20 Mar 2026 12:27:33 -0700
Message-ID: <20260320192735.748051-20-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B1D7B80006
X-Rspamd-Server: rspam07
X-Stat-Signature: k6r8mk6ct4eekxzo9xao1xjn83nb78o6
X-Rspam-User: 
X-HE-Tag: 1774034886-504980
X-HE-Meta: U2FsdGVkX1+uxOi2BwtG4C/97NdW/2gTY5uCzbeMVEl/Zy+b/kq8hLS8WDA5emjrStmn8t4OgVc23/S9BtVSFMm/vY5vMbdcnFDhKE+vVBsK0iEk36mFA48C6QoEIpkEmJXZUnYuGuc+MdfE1+sPd2gjpMCXWZCae2LqTuFK8c6u8ecsgO5wK0w/koaFJxH1o2iVfkdsPe9gm5uVYelyoL7NQryuKo/1NeSc4mNHZQZTLNiLvzqn2+Yz4yGleiusicfChDDLHJmHrOrv9QFcEtvFPGxDXsBeAdO6hagQPxKziXpEDb+U3Udu6qJP+N7QzVnOZQtfIdCmvwwnrLHS4sfHuMjBoU2TCmyPwVIslE9bx2d/+g5XSWGuXzLiR62QxTXgiCD8pEfsh84uPoxKIjTAppwk/4aG5VBQBjhrL1Kci9lIihj4Yau4rVpeo6yKGYVW1YSeGSvkSLOf+8LQb56ipBTGLVKhcPbgf2BSdsgJ9op2B89OubqCnkdaea7Y914XXp4RPINHlR4Xc4Ppu5yGuX6JSBRdhgXzCA1jWUbeyTcjhD61O2W1O88bqNoMO1sMpBOUmUZAeq2MXyuXrIXi5XwZwfofr6pSMCS32C8R/s+9BSA3l3tJva5PTzZTCylBMS5n5b4isHS0HQM7TErueReXl4Xlnbim4nvzVQaWKsN1MIgRiYTdEUeBP4eaPAbduaTPmtJIyivQxlESnwn5Vso8lHqVYXrG0OQk0UMHslMabxuicPhGQNqczujePUI//5TrglxfG07AX69KACypvi2wvLL894pdi3RVCzMpiI2rvKRiDyWlCoGZpiFkrl623grCBidgKkWtSxCnqCfeJQsDck9fkqZqILf1R7TEd5ADa4lQOKQ31D8l80mTfAg9KhM5US6vxwHFh+3yha0KxbldEILxOJ9C5KRJdX54fbvbPzkXi1/2beEmbR0ZkjydpOKBfyqgZWArZGZ
 e4K+s87x
 91x+vRMgQ0ULNEDtq+qSMAlmBRtPoPe/kpehzIhi/uFNgE1kG6Tq3AoNod8as+lreLmWtA9E0uHz+39ZiIhRZdyS6kDzzgy0iycAIT/hYbagIGTHKUO6ZwFqWR9ppeVJ+lAKsiNb9ekZZ+qr26/pDzwHokGfOQtF9jsxP4Mn9LyYO5k2HKkkUM1Rw7aWNfxaGVNBRP1ac4bpTidH39tGDHOOxnHfRSUeKKYqDZVpmaWw7TWdL+IXQyN3OccHXOg0glcIuZuqXaYIdnniq5QepJKMrgovbUnEvl7aUIti0fcsoVM9YHzerGBH1kw7aSf3+eTFqWip64GR4krjJ+iRxECOLoBG8yxXC2RkbDv4ucVBv6jc3/3xXyAWWyTvxMyF7yFBXPlv5dZcCxxOPyj3/x3tYVwevSm8bSs8CnXrAm5mzWG8SQy/ZhxJ2lso4NeDZrWbNNYOKCqKX2qFzhtu4FIDvxAHnJUyqNkZtRk5qDKdZapulGREjZGHKPEGSdRfLWadiQJcN6yTaFXp/6QjPBSzbS/TWDPINVL11
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
 include/linux/shmem_fs.h |   7 +-
 mm/filemap.c             |  14 +-
 mm/shmem.c               | 196 +---------------
 mm/swapfile.c            | 474 +++++++++------------------------------
 4 files changed, 126 insertions(+), 565 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index e2069b3179c41..bac6b6cafe89c 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -41,17 +41,13 @@ struct shmem_inode_info {
 	unsigned long		swapped;	/* subtotal assigned to swap */
 	union {
 	    struct offset_ctx	dir_offsets;	/* stable directory offsets */
-	    struct {
-		struct list_head shrinklist;	/* shrinkable hpage inodes */
-		struct list_head swaplist;	/* chain of maybes on swap */
-	    };
+	    struct list_head	shrinklist;	/* shrinkable hpage inodes */
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
index ebd75684cb0a7..53aad273ea2f1 100644
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
index 3a346cca114ab..984e01ea88d3c 100644
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
index aeb3575df8a0b..b553652125d11 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1741,300 +1741,12 @@ unsigned int count_swap_pages(int type, int free)
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
@@ -2046,7 +1758,6 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 					unsigned int prev)
 {
 	unsigned int i;
-	unsigned char count;
 
 	/*
 	 * No need for swap_lock here: we're just looking
@@ -2055,8 +1766,7 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	 * allocations from this area (while holding swap_lock).
 	 */
 	for (i = prev + 1; i < si->max; i++) {
-		count = READ_ONCE(si->swap_map[i]);
-		if (count && swap_count(count) != SWAP_MAP_BAD)
+		if (swap_slot_allocated(si, i))
 			break;
 		if ((i % LATENCY_LIMIT) == 0)
 			cond_resched();
@@ -2068,101 +1778,139 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	return i;
 }
 
+#define	for_each_allocated_offset(si, offset)	\
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


