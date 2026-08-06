Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18719C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 18:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F420E6B00A0; Thu,  6 Aug 2026 14:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19CB6B00A1; Thu,  6 Aug 2026 14:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1BC6B00A2; Thu,  6 Aug 2026 14:43:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B20026B00A0
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:43:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0AD301C00AD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:43:16 +0000 (UTC)
X-FDA: 85071717192.09.DFFC1ED
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 279AE1C0013
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:43:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JEcx2esz;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786041794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mfv2zxxfrg+kFLvg5TbxKt0slusQCG6TQNqV0DBz5Rs=;
	b=K/65VWC2KBPYRMtujE4qN7VTlElpLfrq3zW/kUONUw649C/c36LPC6dknpiuSkqraxrI0x
	D9m0+Ypba1jv8J3bQexGTRg6VMuMRkxbWv7HxK7co5s57+/oUevaEwcHR771h0Bi+h4bhf
	ABFT4KmzIOG0O0OmiEiSgRsdOZWS2aE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JEcx2esz;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786041794;
	b=5t2jRzAzAJf39kasBt86QhWXo4720rg2oRIvBZ0aGAh8gncfpuFqFNlhjw1h8G6T590KpK
	UpYAkvlgofy2WpIKjeZ52/G2VUybBp1bupt3EiI5jLJMobYxyJKodNdLOEcqI1ChMy7kiu
	NvPt5G3GsLYeCX8zc5s4GHT+fgYds3Y=
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-4591f35aff3so1191786fac.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 11:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041793; x=1786646593; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mfv2zxxfrg+kFLvg5TbxKt0slusQCG6TQNqV0DBz5Rs=;
        b=JEcx2eszLC1gGFEQBQHJlXONAvbYf2C3eZzKzyv6G5pq5/gOeiUwkjHDw2ZmAmw04J
         dvsFKHl6fZGy1LEpd3AdpF9d4LfnVSZgFPRLvkw12NP3ZSbKg8zd8Dt9Fe0ww1sKfqWU
         um4/x/gPzQPyRvLdUwySQLfwSb8C9ZQcaLbZy8jbB3zzCuUTjQg7nJpvpcJzsGR7wWP0
         86d0UBlR8u1fOKN1z/0Ktg9lLAQSB60gA4UK5JOPcifmN/+rmSlCFGXXRxCXaAYb7MbA
         daZ2ltefXcYNngkw3O2T1b8v+mKW7EBcWpRhBcFdUrh/ZhWFn/JjCpDEYt4Kz/+fkZ40
         9XCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041793; x=1786646593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mfv2zxxfrg+kFLvg5TbxKt0slusQCG6TQNqV0DBz5Rs=;
        b=ClJMNDYWh6aHwwHUHW0/G+PzQrK0ERxekox2LERbs5kurUHYnMVlX8UyxkHf3Eo8Z0
         Ks2IOb0DTfb5aW8X5Et1u3CSQ+us8TfAPIUGALrH0CExBWTQusmHbjtvyy/foPaFeOQI
         wxNtJlP6JW9qSxU/FZwMEwjb+7xBBI+4WhM9nGqKEKMGeKh+Rd2GE4pt3OUugbqd/3QW
         NAYn4trOmE3fcYg5ioVoSEa5zVDE+x76Av1MMedTRaybHPDrmnq3HAKX6/CheZha+4CS
         vsORDTR0Akv1rGxwecbMGFidznWpBsdByKSa9nfG8siwIYqJbC+HPDxM8I5EdUYHJJZp
         IGkg==
X-Forwarded-Encrypted: i=1; AHgh+Rowd2h4Ia0GMnI6FrIgFO5aAxdHqA928r2xsCZrFapmmls0Yzhx2+VLCGJfIIjHmNTiHF0krbeLUg==@kvack.org
X-Gm-Message-State: AOJu0Yw9NXgfIqYhub30UKN4UWy1Y1Y/x1oY+fm8x3xKxz832oY8Z5ey
	O43Sr5pXzxQlusYx6vxWBlLWljzBvxLF4YNjxGZ5LLrH8hMtp79taGTn
X-Gm-Gg: AR+sD12TznDTsuOz7U6zoixPOClKwIELYixkaJwHF1UqxWZXmq3PBLi3Xm5wCSlYfvt
	xi+0P/rMlbuxJ4XAmyjI8P9ilvHBrbcYvgdLpd0HDa87icYv9yPqDSD5KwsdDQKFH2Q3NrPLWe0
	eqtLO/YJVFJS3Z1SrN6Rxc5A2aPv+aebVs7TP8JFANl03uB/+yO0VZarTW91VKfT2q3fZY2P0i7
	AjzuFR+Kgu/jfvH6rWbrzSXCZVXZ3Bc6NKHQZ19YnWXCe2m9722WxiGHCRz1a+csiCTfnMk8Swz
	x/b65XYFO8zU9yNjuvSkDDZEYiXLC7E0cNWKUsWJLjgGqrn8KhC4aSy4nkQJRlgT+kllupZ5eS4
	gPWVRQ1OhOlmEjwaMIT2Un6bW35r/w/gXhKlrJ117K3qX9Ggj5BFT0/qSjDi/laTUTh9w4gpGE4
	G3XfJq7elfjuz8B6O+0d6/iV4iB0Fjhb1S3Q/Sk+T4v7uJ4fJQ3cUvVgZL3OTSaUUHiUxgSlBe+
	I1CimsQ1q1/BFfGLbOUTg==
X-Received: by 2002:a05:6870:8929:b0:441:f3f6:622b with SMTP id 586e51a60fabf-4599eb1f492mr9226089fac.5.1786041793178;
        Thu, 06 Aug 2026 11:43:13 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:15::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1a0586asm197246fac.2.2026.08.06.11.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:43:12 -0700 (PDT)
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
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v3 11/11] mm, swap: widen swap_info_struct max/pages to unsigned long
Date: Thu,  6 Aug 2026 11:42:54 -0700
Message-ID: <20260806184254.3790858-12-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260806184254.3790858-1-nphamcs@gmail.com>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m9dn1ig3szxd8nz6zyuzbfzf4ipaegy1
X-Rspamd-Queue-Id: 279AE1C0013
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786041794-372977
X-HE-Meta: U2FsdGVkX1/l/d8MFCx2M2jQwk5gh/t1miE7H2mF1LOtYCGl6wrvGOkNtDttB9Cqi/LstI2siPOM8ivlbUfBSQ6LYxoR8DP6kJEHL+XGCoLOa05s+qmEhA9oWSdPhZbbSfFZyOtiQGb05iYczWBOPtAX4j3EcC0EDDjjVMRyLqBEnrjDIDncyjmha2yhHTg4kTc91MpVz9tItQ4xKZIytZBPtDBEmq+ogURiL7gnFDP9uOs/8pZZUJ2g1zK8179xEV/B3tQTl6rbooPl8YopNtUoiPYb3Xd5K+LQBrV6rWFXu9eDeFEC8+848S+H8J9nSGL1UQYbKGuiATesI7TzX/SZOoZFI1FDFGPXdVIE8wEK2xGNs5E3zq9iiv6+XfSBXkT6M61FAtApVYvB2UOUAViZYXDq66iQaKuMKForCXoA5twdbdWk0plIBWrgTYa6QV2hRS0GP+eTOZd4IuXJH3c8VW+j8uRzns66hmchuMe/v6Q31+1ADyjORVETncr3Q+3Wx0QYNPdmy+v1IMlZffa6HGTbrow7vsDVA1TtpgnTVBsUUGjM6NvBqkTz1sHGLNA6ZvEph13J5vnL095Cgg8q3SSyPI3tb5aFz/udB9nAKQoc9RrrpLS46jdkKT78bOuNdcguX2VDJMcQ/a56QH4eH4tg6jTQBxk0jCOqsQjQMsx+URISLjrebqd0ryfuVoPw3NdJ06QocdtHiQUkDEqYV82dXxksy6332764SO+LomeEDCKgBAk2IyXMZoQAUB/QKbX0p8N3PRkVvFdN3kgQwmpNE0y+idtQEFH+KECBbzUZQWsWNU+xXv0gk25Hj1KcZUIONWnnDbnNhDF2jSzZcdGp3iRRnqGBuuUwqtkS3ZgicJ41C06pu80MSezLOEddZiOwRQ8NAgRjr/sNtfTrpxIr3IX2eUTG4VwmnG7a2zSBm2xG/+TB9fEq1Qnsuk0606wQeb+V0C7NOzf
 z3xVhUoB
 deRBPUkKzHV11fcWYykWA8cbtYpfjSH00O0dh15u5lfCd74WcSe5TpWYOzJXg970IJAHr4Ivx7lZ41CKHg5G4qC8/mNvZvB0GZanzV/3CZM+PXfaNsbMADzRBfeqbz4w2iVxI5snXZRGlbErF4fmRBpJLk8fIV+FKFKlF3ncRCpSystMVrcmsrxZVKDVrtVFWU7JqrwrrVYMWPAYuXQTtg1oujE0C0kkDt+HEy9XBPBLZcVPD4fJ3FZcWL2in6Ql/OPHJLtlh/e/gJyPayHwJ5uZ5eSKep44POC40CmO/YzOGPQNqwmomnBPahouhs/hI2fMW/ybci57qhd9qCds0PjIi/7y8ws5ZpIDgkBMCcBqkJ7QuVAy/4JXroUdY0tNqh05Sk31QTzrSidWx7sfELuzpt5MIJ9yzAnQ2IjD3IsPuU8NYKDk/m2QMyzjbZ3UiPVF2fiFcuGgGxMMIa04TbnyLbHSbCno9sBZ1pqstL+A4TYWrKktImZ4Q+oVhkQdQVeOc9mN/iZjQcf0=
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
index 19a703510675..44353eb554da 100644
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
index 65559647eeb4..6db605594d48 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -450,10 +450,10 @@ static inline unsigned int cluster_index(struct swap_info_struct *si,
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
@@ -904,7 +904,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	/* si->max may got shrunk by swap swap_activate() */
 	if (offset >= si->max && !mask) {
-		pr_debug("Ignoring bad slot %u (max: %u)\n", offset, si->max);
+		pr_debug("Ignoring bad slot %u (max: %lu)\n", offset, si->max);
 		return 0;
 	}
 	/*
@@ -1170,12 +1170,12 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
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
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned long end = start + SWAPFILE_CLUSTER;
@@ -1245,12 +1245,12 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
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
@@ -1267,8 +1267,8 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 	return found;
 }
 
-static unsigned int alloc_swap_scan_dynamic(struct swap_info_struct *si,
-					    struct folio *folio)
+static unsigned long alloc_swap_scan_dynamic(struct swap_info_struct *si,
+					     struct folio *folio)
 {
 	struct swap_cluster_info_dynamic *ci_dyn;
 	struct swap_cluster_info *ci;
@@ -1392,7 +1392,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 {
 	struct swap_cluster_info *ci;
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
-	unsigned int offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
+	unsigned long offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 
 	/*
 	 * Swapfile is not block device so unable
@@ -3488,10 +3488,10 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
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
@@ -3529,7 +3529,8 @@ static int try_to_unuse(unsigned int type)
 	struct swap_io_ctx ctx;
 	swp_entry_t entry, vswap_entry;
 	unsigned long swp_tb;
-	unsigned int i, j;
+	unsigned long i;
+	unsigned int j;
 
 	if (!swap_usage_in_pages(si))
 		goto success;
@@ -3964,7 +3965,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
 	struct inode *inode;
-	unsigned int maxpages;
+	unsigned long maxpages;
 	int err, found = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -4386,12 +4387,8 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
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
@@ -4630,7 +4627,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 	if (si->pages != si->max - 1) {
-		pr_err("swap:%u != (max:%u - 1)\n", si->pages, si->max);
+		pr_err("swap:%lu != (max:%lu - 1)\n", si->pages, si->max);
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;
 	}
@@ -4718,7 +4715,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
 	enable_swap_info(si);
 
-	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
+	pr_info("Adding %luk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
 		K((unsigned long long)span),
 		(si->flags & SWP_SOLIDSTATE) ? "SS" : "",
@@ -4906,8 +4903,13 @@ static int __init vswap_init(void)
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
 	si->ops = &vswap_ops;
 	si->bdev = NULL;
-- 
2.53.0-Meta


