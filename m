Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 339E8C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 15:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 379546B00A3; Tue, 25 Aug 2026 11:33:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329A66B00A4; Tue, 25 Aug 2026 11:33:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA876B00A5; Tue, 25 Aug 2026 11:33:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D978C6B00A3
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:33:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5600C16048E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:33:06 +0000 (UTC)
X-FDA: 85140185172.27.239924A
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7F255120010
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:33:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C+Qtx8BJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787671984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uAKqLnS2duDg8f3jGAvM1PgrDRSN4wgtQcZNf8+IpfY=;
	b=6A350rkKzHnDR+BW/pAyHeuSUT8Z6/55FujJvZxIA7/qSwdeHuf9zKJhEWO3V3g6/VYVAj
	2vhkUvRFfPW1FQCdLWqGlO3TRBd8JrHxpE/WG0pMAX+r5mYOfsQ5Hyo/nTdy3Encay/oEu
	hWTbyGlxix9KYy8e74gKPo8FVOALyu0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787671984;
	b=Trj16iJ3mPmNM03WATUP7QF0DqOUmRuzsrxJemsW6xY8phDXLMkdljMF1u+HlHLq4ASl3k
	8zzPsWXPqThff2t5t2/uwENHzDYjdJY1HKmfMSjlRgpxomt6g8pU0vcDrKrWQQdeTnQZzc
	JtLVulCxUUVLOo5i0WEs5ReCgnvyJPw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C+Qtx8BJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-4a46a53abc9so3906178b6e.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671983; x=1788276783; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uAKqLnS2duDg8f3jGAvM1PgrDRSN4wgtQcZNf8+IpfY=;
        b=C+Qtx8BJ1SS4Jef2OtmfbweGa4yxZKKMK3+Fk/Ra8xa02RBqa34FXq/7SEjV7D09Fb
         Yx0wmGOjJPSN8jK/2ofyzeFuVbMTED/LH9/WvIxwfqOMyOb7R6x+Juml2ye0mnZKbtiz
         J9HYiUp1DZXIlNgx3xdz7WLW7MNn1jHaMlD6kKCADqbQaSEaC5y7LEdZg93zhkqIFNTx
         5GH4Gv6KcA8B865GI/8tejbNdKEPY32clO6ij540ch4RjMkXTbjO9GSzD/dlcUI1QXOZ
         A3KKfQT4FQDcHccop/YnHrHwogFMevWT22bIQ1YOia3oyXFdFIghFm/7gOXsVYoPhmIo
         VFSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671983; x=1788276783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uAKqLnS2duDg8f3jGAvM1PgrDRSN4wgtQcZNf8+IpfY=;
        b=Q84vSTUOMQTmsJ3nYFcSUSZAtyq4DvaqC8KtWhlMyGiKLKekiJcBlizUeG03/AbAtW
         5QPhtroscVBb7O9jUPhumf3kQgJ4K/xc9Wdw1wHS9exHLZ2K3o9T8nPD2Pi2rKKL6dhe
         yaVQpbFebM+/qhzbx3SYKdmuigul6F0vZntIXSHWCRbR5ydao2RjoowMmhPqkYTWe1e+
         vW1fZo3UNnBSqcVumPNUA47dp9yVnfFHwZ/2i/RMjfx4jhGg/+IpTvkQ7nWDLb9nf7Mi
         Vfb7icpm652YnrvE3qrk/DKsHl3QJvZFehurvvRdbgm2z/Pb17QIsHCXUbYQnvgpz2mJ
         Wujw==
X-Forwarded-Encrypted: i=1; AHgh+Rp1fFt44Mp70KknCRvNKqfs488gqb8w6qyRhw3F65KkiWWkkxGf5xaccXuskaHcUg/XwUUB5MdQ3g==@kvack.org
X-Gm-Message-State: AFuF++nxaBLAwaY8nhoFmiHGwDdeYsDMapm0a04lnLBYi1wOkk4q++TA
	RqndM8LNFxuPB3P1g3XGn14Fueam38APpF8Qn4ifaLQYV6FG/6HgILMc
X-Gm-Gg: AR+sD13VwB9CX3LZEqYN65SH4HpOvTtGokR/DeAj1msqXtLrU/FRgyeHKHvi0GjQnI2
	LwDWj2ANA5Bwk9RqrnnGNtSwG6wYVR5hRecZearfY7KHjjPpqw3LqWSXMdut7aGi1gCqW1f2l3v
	TGnHyr+umrp+kPrKryrytabLwBl8Sp0cd/XCntVeEXN1QPMb5T4xuVKkXkiFrLZNCODTykCdA1b
	5AjbZYdG5jEyYMchAIZjkl7JR/sviqfXAG9ahSuAYqLfjcKG2VhEdi1Drr76FL8gZsHETsiUGI8
	AcxbV0ZDtZ8h5VhHo/YuIKuRAvJy2fnbDVK5HSDB/3Qx061mJMqazIFh5DI5ZWiQDfDUYHdHtp3
	BpvBcsKqTnr6RWkzUXqcAPusOIqbpJ9MqmVXbuAg8TY1pckSdaQiq4y0AKZcP36iQWLx2gCC7y/
	bqf7muHtPb2CPjv9zc6HwfJR8BHLoqwnVYBTiCdNf8BhCz1IIdVXnntjyT5wbOo60EaeEPMau55
	iuRV1pL5LA=
X-Received: by 2002:a05:6808:4f49:b0:495:ff85:d33d with SMTP id 5614622812f47-4b35059a824mr7724933b6e.12.1787671978714;
        Tue, 25 Aug 2026 08:32:58 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:28::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b32c690f27sm5952581b6e.7.2026.08.25.08.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:58 -0700 (PDT)
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
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v4 11/11] mm, swap: widen swap_info_struct max/pages to unsigned long
Date: Tue, 25 Aug 2026 08:32:37 -0700
Message-ID: <20260825153238.2695446-12-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825153238.2695446-1-nphamcs@gmail.com>
References: <20260825153238.2695446-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7F255120010
X-Stat-Signature: pg3w8dudo7n7cbph1qbxcaq7kz9mwzt3
X-Rspam-User: 
X-HE-Tag: 1787671984-156571
X-HE-Meta: U2FsdGVkX1+3ydJtCm2sjCG21TZTEPW0Glp7yINPnCDS7nzZb0QJnj/SaYSKUxedM+RdnekkD+pmdCmChACxN65Rt3l4spZneUKXz3TDfPxmBBeQrfF/s/ES6pTs2+ekYmP5jLgPpEhY0FRY0jgiCR+ukb0HIVPGTknlfYD/u2QRJG3AVFXXyC/rhfsDMNCenSwAi2zHAENDj/gkZKe0pbCrEpbuswQq1Fl68ikgWMkKqjbf4e3CqfeG3K9GLk8aZEBJrZ4wnkUUDas0mCknYPLGldUFmFTjOvvjoQ0LQkGUTpthaRTabo9OzV26G2jE4gbwoJOcWB5Llsu3KaE6y+jobgxs2/UclBb+QyRHvJRZESMDrDxskTykhAOFF0DExB2SotbbRlNhuAwFamRkpd20cOnn3C3pI5EziRG0LgLN/3DgotIBN6YyVt3ziZhrfDIcUjoc2qEtpnlSHbBULuJ6WUgOZeGc+WjtUM5klQ4dJFjMbC1NdBOFhVjHNpMiVaR/MSG0nfpWP85qurwnumDK8REdkcigi9ZC1hf0shFS3JK36flrg+f+80YVUYFzvWWz8XNIUYuUgBR9lwuGTgKzuTURXG9trBm4TrmvA0c2HeSc4NPgGODckSKISoTdfqDOF9BLXDPUXRlzMcv3Z2oqiUNI3ZUAuvTG7AkFW2k2lqvge+5EAR9gj9q1+ycg73EjVBcjDjyLgLQChn/CEq4U6wgP1K394JIqYe7WjSfeUqLlJL4n+Ca+esThUWmvPYiJ4KoKKFsspXOsChpeHxQAhRWckNPLbpNIhwVdjasgPy57lUwasztRijo5sPwgTGLpzjrXK5WakXs8xs5E3+MrcPK9ETl16fk02pv9gTR8RB8eef4nk3CPMZ6GCiI15+NRtgFJDlv83XLAsTzZMqkJv8vzr6vc3fNryGQBpBEJN1xPS2BHl+1n/MI8yfQD4n+LIO6flqGVpritk5Z
 xuEOKYmv
 jzqcSy/GWbDAf4dKJgpm/XVBTjw64rKkntq6JzgZNgG3Zgv3i5sSveBxXhccmf/rvqiO00X9W2vYudVPklF8jcWe6sfzPzijuf05HIjq8iHv357jie1jAdnIjcXgOhpNCU+PyiZ5uTYZ5kVPMsFABx7jYy1VAw5LFyXwjlY583CWACPctAgyKS+VIA9ZmWGIsQotL0Zk1op9IHV6ZU//Q85HP20VINZgFTCIwkWp/LEq6NekIlFuiCNP+IX5K/nj1GpGnzdK3rGr4nCzojkkwGYLH9qEnt+8iUFqgcNo5ULs0jLa0FUuoTSw38GavivvtLX4tqWzJ3usWnxaqM8/e3OHsmy1ldul2+D2LYFxejyR2qGwh3QSfKwZwtXI4M2GWZGR8WsieKLOS75Fdiz01+UvKCudAZiIAiBBXx6qBXIma+w4QmQGky8tvrcQtIZgbwCIunwWHIxma3yQ7HU2e9wNflRO/Yewc0IbZ0MhFzLjacrrluUjl1sbYYdlg0lo7zXkF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Widen swap_info_struct->max and ->pages from unsigned int to
unsigned long so the vswap device can exceed the previous 16 TB cap
with 4 KB pages (ALIGN_DOWN(UINT_MAX, SWAPFILE_CLUSTER) pages).

The new vswap cap is the cluster_info_pool xarray's allocator
limit. XA_FLAGS_ALLOC stores allocated IDs in u32, so
max_pages = UINT_MAX * SWAPFILE_CLUSTER (~8 PB at the typical
SWAPFILE_CLUSTER=512 layout).

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h |  4 +--
 mm/swapfile.c        | 63 ++++++++++++++++++++++----------------------
 2 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 95386a86d3fd..5310ac0f3faa 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -246,7 +246,7 @@ struct swap_info_struct {
 	signed short	prio;		/* swap priority of this type */
 	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
-	unsigned int	max;		/* size of this swap device */
+	unsigned long	max;		/* size of this swap device */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
@@ -254,7 +254,7 @@ struct swap_info_struct {
 					/* list of cluster that contains at least one free slot */
 	struct list_head frag_clusters[SWAP_NR_ORDERS];
 					/* list of cluster that are fragmented or contented */
-	unsigned int pages;		/* total of usable pages of swap */
+	unsigned long pages;		/* total of usable pages of swap */
 	atomic_long_t inuse_pages;	/* number of those currently in use */
 	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
 	spinlock_t global_cluster_lock;	/* Serialize usage of global cluster */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8c80544a7d25..9860fb3b079f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -429,10 +429,10 @@ static inline unsigned int cluster_index(struct swap_info_struct *si,
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
@@ -848,7 +848,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	/* si->max may got shrunk by swap swap_activate() */
 	if (offset >= si->max && !mask) {
-		pr_debug("Ignoring bad slot %u (max: %u)\n", offset, si->max);
+		pr_debug("Ignoring bad slot %u (max: %lu)\n", offset, si->max);
 		return 0;
 	}
 	/*
@@ -1085,13 +1085,13 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 }
 
 /* Try use a new cluster for current CPU and allocate from it. */
-static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
-					    struct swap_cluster_info *ci,
-					    struct folio *folio,
-					    unsigned long offset,
-					    bool *nomem)
+static unsigned long alloc_swap_scan_cluster(struct swap_info_struct *si,
+					     struct swap_cluster_info *ci,
+					     struct folio *folio,
+					     unsigned long offset,
+					     bool *nomem)
 {
-	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
+	unsigned long next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned long end = start + SWAPFILE_CLUSTER;
@@ -1168,12 +1168,12 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
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
 	bool nomem = false;
 
 	/*
@@ -1196,8 +1196,8 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 	return found;
 }
 
-static unsigned int vswap_alloc_cluster(struct swap_info_struct *si,
-					struct folio *folio)
+static unsigned long vswap_alloc_cluster(struct swap_info_struct *si,
+					 struct folio *folio)
 {
 	struct swap_cluster_info_dynamic *ci_dyn;
 	struct swap_cluster_info *ci;
@@ -1324,7 +1324,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 {
 	struct swap_cluster_info *ci;
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
-	unsigned int offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
+	unsigned long offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 
 	/*
 	 * Swapfile is not block device so unable
@@ -3423,10 +3423,10 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
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
@@ -3464,7 +3464,8 @@ static int try_to_unuse(unsigned int type)
 	struct swap_io_ctx ctx;
 	swp_entry_t entry, vswap_entry;
 	unsigned long swp_tb;
-	unsigned int i, j;
+	unsigned long i;
+	unsigned int j;
 
 	if (!swap_usage_in_pages(si))
 		goto success;
@@ -3921,7 +3922,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
 	struct inode *inode;
-	unsigned int maxpages;
+	unsigned long maxpages;
 	int err, found = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -4343,12 +4344,8 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
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
@@ -4589,7 +4586,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 	if (si->pages != si->max - 1) {
-		pr_err("swap:%u != (max:%u - 1)\n", si->pages, si->max);
+		pr_err("swap:%lu != (max:%lu - 1)\n", si->pages, si->max);
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;
 	}
@@ -4677,7 +4674,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
 	enable_swap_info(si);
 
-	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
+	pr_info("Adding %luk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
 		K((unsigned long long)span),
 		(si->flags & SWP_SOLIDSTATE) ? "SS" : "",
@@ -4884,8 +4881,12 @@ static int __init vswap_init(void)
 		return 0;
 	}
 
+	/*
+	 * One u32 xarray ID per cluster, so the device cannot be larger
+	 * than UINT_MAX clusters.
+	 */
 	maxpages = min(swapfile_maximum_size,
-		       ALIGN_DOWN((unsigned long)UINT_MAX, SWAPFILE_CLUSTER));
+		       (unsigned long)UINT_MAX * SWAPFILE_CLUSTER);
 	/*
 	 * SWP_WRITEOK enables slot allocation. SWP_SOLIDSTATE selects
 	 * per-CPU cluster allocation; vswap has no si->global_cluster.
-- 
2.53.0-Meta


