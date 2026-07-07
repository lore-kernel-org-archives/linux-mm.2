Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3623CC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E1C96B00B3; Tue,  7 Jul 2026 04:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 291D66B00B5; Tue,  7 Jul 2026 04:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15A736B00B6; Tue,  7 Jul 2026 04:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D67156B00B3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:27:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6055B168C6A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:27:36 +0000 (UTC)
X-FDA: 84961301712.05.9C26661
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id 93E9180009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:27:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r3moxhCT;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412854;
	b=SpAbGf7q/CEXm/q6y63PLxrrTDYEIoXdyr2sSJQi5Jk+AMYl2NrL6HbyiOu0SgTMP9KyOY
	hGMMnXHou2PkWISiyJjWmicJwNA5nSx30cMQYZztnTUHLeTw/9umbwGEQus+Yt9wyYiGHP
	lLJgYUYHny9AlPGVcQSgs8qazgQZjn8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r3moxhCT;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jkSw3/wP2rS9IGataP4Ft3A2tanbZq8ITS4QnfKTC3k=;
	b=NiCo3TBL82/eQ5ttcpjV+89a0JnhI+vGEkShzM/kzpB6oY+hZkKn7+gFD6S6BxL+0r1lQX
	C3d9KpcpJJlqaA6u8wek1e1jMG8Ey/qqU3MP6VXkOH6EipuXsEex13C104NrsZuMVpb0UH
	dg24gjiiK5fmwzou1hQqdAze7vTPOLw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783412853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jkSw3/wP2rS9IGataP4Ft3A2tanbZq8ITS4QnfKTC3k=;
	b=r3moxhCTLNzNF1gCf96rxCVxmBzCSkVbp5J+iePcf/aYH3Wn+Iww+ZWzUh4mnguljlmPLr
	mnJEPlYI7tl/DVF+fbm3wWo2yFNosViNCgJbWBCe2YPjwqPZA3BNL81JlBLSeCY3h0+rUg
	qBgmworePbpySFtgO+11sy0BPK41BDw=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 08/10] mm/swapfile: manage ghost cluster_info via lazy vmalloc
Date: Tue,  7 Jul 2026 16:26:10 +0800
Message-ID: <20260707082614.95030-9-baoquan.he@linux.dev>
In-Reply-To: <20260707082614.95030-1-baoquan.he@linux.dev>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 93E9180009
X-Stat-Signature: ux68yofd37fq31hnmcagxq9k3mupgqj8
X-HE-Tag: 1783412854-948148
X-HE-Meta: U2FsdGVkX1/kyzUk78phdooEnq/vPNvGKiiLHf289RQFzlP42F+bstYfpdAS8OCv8JQtqCLblYK0F1lzWEvNxvjoPbpDTdNiW8wDJcPqX4WjQLVomGQBixMKmZy3/0Ze128EnAKpe1De0GZ4LnhW1GLQfAySq5P6psDOMPvedJiOOKoM2efjvcTPE0sbsXsEjwDKVkI6+7no6PbWIYL/OpdMn6erDE5rrEa2jT3U+VJUxNRF6OdbVTvS0lwTBKfuK2Q+P46BZpmxvsao/H28MZWOVG+PpAfzDDbSeAlQ+jWzDu+aHLZ/vVvBX21grT7H9vm9btwC46qSi2urGAT7XDg0RhkETxy9D+nqTY2XVPnNKPAf8eqzIAtcHcqaCCT72akQ1MPqi9uLgsReGM7BvVcM/+JRVeUt+R4cDpLyRVhPhpLvWwGqh0T9p3PHnPw6magyaQ6wdtcfqBq/BRFmqdWjO3djEPBBJXWexcE/yR0MZKeR4x67o/lEweJcHIN+egAedGoRveezTcOlrVvRqYy3OI1q4JBa+zJN9HGSjgOPX9QlIi3zVmeXplPqyfOlDxQE2F13Mh9CabRRX0ANhcwezqk2L+QG/XLMjZfoTq+6XGGZ8p84PTemiDvKz2bfA1qQloxosB8Qce2/LWXuGyllt+SljnLOAaLct08/azZHj6+Lwrt1KHURPIoCBjvqtRqK1OXB2bbAh9Td4oncAlP6tafyyB9qbyq8VbslfYUvzEtFk3yFUsMRh6hoiCCdNE1HoapXcLut312ijN7OO7jN2k9h5czsSmNbzBslFmYEq+kQ7BqKfoS6+qL9BiRe/aNQsDUO9Y3iu0sVY3mKVoaMHw7317jbtuqyu3KO0Tx1QkAoaqhgMXsI+sQQd7f6pYh+hPJ7ujiQhqyGdSlsU2RepM77CNScLc8t+Eh4VuVvOaCGGqBf8EEAtDd+u1f0zt8JICeP3L2wfFwBPOG
 xWkPCrPt
 8evP34GH0Y/4wVsxExv/gerjJpZSO6bxUFXbEP52nXj3Jz+KtmAtmqUvYdJ+tcZCEzOL2HwhZbuFBe1CBu6vMQR0ZtVAkxDrLrtVRYodCkW7ePoICZiSY0ydDEnwnhLAHkbO5c18f5f6R6OOe6HQxWDAT7jvQFszrxzll2WiM0p9EiuQ9l26isHtey+4M3cCII6hz6pZvCpnmOET5XaOuHrHXwAJ7HhzNi50wSrAoHdHcsPxkamAMjcClwkOwwOtb8kbxQwkVI55ctWCTfX7v1XI0ouF635lkiEN8gAFDq6abPmvsDSDcDSI4ZXh/X5D5fXl2L65cauTypkddeCJaWKuhJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the kvzalloc cluster_info allocation for ghost swap with a sparse
vmalloc area (VM_SPARSE). At swapon time, reserve up to 64MB of virtual
address space (supporting ~1TB ghost swap) but only allocate physical
pages for the initial size. The cluster_info pointer never changes —
__swap_offset_to_cluster() and cluster_index() are unchanged.

Add cluster_vm and ghost_name fields to struct swap_info_struct.
In setup_swap_clusters_info(), allocate zeroed physical pages and map
them into the reserved VA via vm_area_map_pages(). Handle teardown in
both swapoff and the swapon error path.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h |   4 +
 mm/swapfile.c        | 210 +++++++++++++++++++++++++++++++++++--------
 2 files changed, 179 insertions(+), 35 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a4d6851e0921..b87688b7d4ba 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -16,6 +16,8 @@
 #include <uapi/linux/mempolicy.h>
 #include <asm/page.h>
 
+struct vm_struct;
+
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
@@ -279,6 +281,8 @@ struct swap_info_struct {
 	struct plist_node avail_list;   /* entry in swap_avail_head */
 #ifdef CONFIG_ZSWAP
 	struct xarray redirect_xa;	/* ghost offset → phys swp_entry_t */
+	struct vm_struct *cluster_vm;	/* ghost: sparse vm_area for cluster_info */
+	char *ghost_name;		/* ghost: dentry name for sysfs */
 #endif
 };
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c1686c2b2521..da085a75d7b5 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -56,6 +56,9 @@ static bool folio_swapcache_freeable(struct folio *folio);
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
 			 enum swap_cluster_flags new_flags);
+#ifdef CONFIG_ZSWAP
+#define GHOST_MAX_CLUSTER_BYTES (64UL * 1024 * 1024)
+#endif
 
 /*
  * Protects the swap_info array, and the SWP_USED flag. swap_info contains
@@ -3244,9 +3247,14 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	swap_file = p->swap_file;
 	p->swap_file = NULL;
 	maxpages = p->max;
-	cluster_info = p->cluster_info;
-	p->max = 0;
-	p->cluster_info = NULL;
+	if (p->flags & SWP_GHOST) {
+		p->max = 0;
+		cluster_info = NULL;
+	} else {
+		cluster_info = p->cluster_info;
+		p->max = 0;
+		p->cluster_info = NULL;
+	}
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	arch_swap_invalidate_area(p->type);
@@ -3254,7 +3262,31 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
-	free_swap_cluster_info(cluster_info, maxpages);
+	if (p->flags & SWP_GHOST) {
+		unsigned long j, np = p->cluster_vm ?
+			p->cluster_vm->nr_pages : 0;
+		struct page **pglist = p->cluster_vm ?
+			(struct page **)p->cluster_vm->pages : NULL;
+
+		xa_destroy(&p->redirect_xa);
+		kfree(p->ghost_name);
+		p->ghost_name = NULL;
+		for (j = 0; j < np; j++)
+			__free_page(pglist[j]);
+		kvfree(pglist);
+		if (p->cluster_vm) {
+			vm_area_unmap_pages(p->cluster_vm,
+					    (unsigned long)p->cluster_vm->addr,
+					    (unsigned long)p->cluster_vm->addr +
+					    np * PAGE_SIZE);
+			remove_vm_area(p->cluster_vm->addr);
+			kfree(p->cluster_vm);
+			p->cluster_vm = NULL;
+		}
+		p->cluster_info = NULL;
+	} else {
+		free_swap_cluster_info(cluster_info, maxpages);
+	}
 
 	inode = mapping->host;
 
@@ -3624,16 +3656,48 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 				    unsigned long maxpages)
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
-	struct swap_cluster_info *cluster_info;
+	struct swap_cluster_info *cluster_info = NULL;
 	int err = -ENOMEM;
 	unsigned long i;
 
-	cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
-	if (!cluster_info)
-		goto err;
+	if (si->flags & SWP_GHOST) {
+		unsigned long bytes, nr_pages;
+		struct page **pg;
 
-	for (i = 0; i < nr_clusters; i++)
-		spin_lock_init(&cluster_info[i].lock);
+		bytes = ALIGN(nr_clusters * sizeof(struct swap_cluster_info),
+			      PAGE_SIZE);
+		nr_pages = bytes / PAGE_SIZE;
+		pg = kvmalloc_array(nr_pages, sizeof(*pg), GFP_KERNEL);
+		if (!pg)
+			goto err;
+		for (i = 0; i < nr_pages; i++) {
+			pg[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
+			if (!pg[i]) {
+				while (i-- > 0)
+					__free_page(pg[i]);
+				kvfree(pg);
+				goto err;
+			}
+		}
+		err = vm_area_map_pages(si->cluster_vm,
+					(unsigned long)si->cluster_vm->addr,
+					(unsigned long)si->cluster_vm->addr + bytes, pg);
+		if (err) {
+			for (i = 0; i < nr_pages; i++)
+				__free_page(pg[i]);
+			kvfree(pg);
+			goto err;
+		}
+		si->cluster_vm->pages = (void *)pg;
+		si->cluster_vm->nr_pages = nr_pages;
+		cluster_info = si->cluster_info;
+	} else {
+		cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
+		if (!cluster_info)
+			goto err;
+		for (i = 0; i < nr_clusters; i++)
+			spin_lock_init(&cluster_info[i].lock);
+	}
 
 	if (!(si->flags & SWP_SOLIDSTATE)) {
 		si->global_cluster = kmalloc_obj(*si->global_cluster);
@@ -3644,37 +3708,64 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		spin_lock_init(&si->global_cluster_lock);
 	}
 
-	/*
-	 * Mark unusable pages (header page, bad pages, and the EOF part of
-	 * the last cluster) as unavailable. The clusters aren't marked free
-	 * yet, so no list operations are involved yet.
-	 */
-	err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
-	if (err)
-		goto err;
-	for (i = 0; i < swap_header->info.nr_badpages; i++) {
-		unsigned int page_nr = swap_header->info.badpages[i];
-
-		if (!page_nr || page_nr > swap_header->info.last_page) {
-			pr_warn("Bad slot offset is out of border: %d (last_page: %d)\n",
-				page_nr, swap_header->info.last_page);
-			err = -EINVAL;
+	if (si->flags & SWP_GHOST) {
+		struct swap_cluster_info *ci;
+
+		ci = &cluster_info[0];
+		if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL)) {
+			err = -ENOMEM;
 			goto err;
 		}
-		err = swap_cluster_setup_bad_slot(si, cluster_info, page_nr, false);
-		if (err)
-			goto err;
-	}
-	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
-		err = swap_cluster_setup_bad_slot(si, cluster_info, i, true);
+		spin_lock(&ci->lock);
+		__swap_table_set(ci, 0, SWP_TB_BAD);
+		ci->count++;
+		spin_unlock(&ci->lock);
+		if (nr_clusters && (maxpages % SWAPFILE_CLUSTER)) {
+			unsigned long base = (maxpages - 1) /
+				SWAPFILE_CLUSTER * SWAPFILE_CLUSTER;
+			unsigned long idx = base / SWAPFILE_CLUSTER;
+
+			ci = &cluster_info[idx];
+			if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL)) {
+				err = -ENOMEM;
+				goto err;
+			}
+			spin_lock(&ci->lock);
+			for (i = maxpages % SWAPFILE_CLUSTER;
+			     i < SWAPFILE_CLUSTER; i++)
+				__swap_table_set(ci, i, SWP_TB_BAD);
+			spin_unlock(&ci->lock);
+		}
+	} else {
+		err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
 		if (err)
 			goto err;
+		for (i = 0; i < swap_header->info.nr_badpages; i++) {
+			unsigned int page_nr = swap_header->info.badpages[i];
+
+			if (!page_nr || page_nr > swap_header->info.last_page) {
+				pr_warn("Bad slot offset is out of border: "
+					"%d (last_page: %d)\n",
+					page_nr, swap_header->info.last_page);
+				err = -EINVAL;
+				goto err;
+			}
+			err = swap_cluster_setup_bad_slot(si, cluster_info,
+							  page_nr, false);
+			if (err)
+				goto err;
+		}
+		for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
+			err = swap_cluster_setup_bad_slot(si, cluster_info,
+							  i, true);
+			if (err)
+				goto err;
+		}
 	}
 
 	INIT_LIST_HEAD(&si->free_clusters);
 	INIT_LIST_HEAD(&si->full_clusters);
 	INIT_LIST_HEAD(&si->discard_clusters);
-
 	for (i = 0; i < SWAP_NR_ORDERS; i++) {
 		INIT_LIST_HEAD(&si->nonfull_clusters[i]);
 		INIT_LIST_HEAD(&si->frag_clusters[i]);
@@ -3692,9 +3783,12 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		}
 	}
 
-	si->cluster_info = cluster_info;
+	if (!(si->flags & SWP_GHOST))
+		si->cluster_info = cluster_info;
 	return 0;
 err:
+	if (si->flags & SWP_GHOST)
+		return err;
 	free_swap_cluster_info(cluster_info, maxpages);
 	return err;
 }
@@ -3790,6 +3884,28 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	si->max = maxpages;
 	si->pages = maxpages - 1;
+	if (si->flags & SWP_GHOST) {
+		unsigned long max_cl_bytes;
+
+		max_cl_bytes = swapfile_maximum_size / SWAPFILE_CLUSTER *
+			       sizeof(struct swap_cluster_info);
+		max_cl_bytes = min(ALIGN(max_cl_bytes, PAGE_SIZE),
+				   GHOST_MAX_CLUSTER_BYTES);
+		si->cluster_vm = get_vm_area_caller(max_cl_bytes, VM_SPARSE,
+					__builtin_return_address(0));
+		if (!si->cluster_vm) {
+			error = -ENOMEM;
+			goto bad_swap_unlock_inode;
+		}
+		si->cluster_info = si->cluster_vm->addr;
+		si->cluster_vm->nr_pages = 0;
+		si->cluster_vm->pages = NULL;
+		si->ghost_name = kstrdup(dentry->d_name.name, GFP_KERNEL);
+		if (!si->ghost_name) {
+			error = -ENOMEM;
+			goto bad_swap_unlock_inode;
+		}
+	}
 	nr_extents = setup_swap_extents(si, swap_file, &span);
 	if (nr_extents < 0) {
 		error = nr_extents;
@@ -3907,8 +4023,32 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->global_cluster = NULL;
 	inode = NULL;
 	destroy_swap_extents(si, swap_file);
-	free_swap_cluster_info(si->cluster_info, si->max);
-	si->cluster_info = NULL;
+	if (si->flags & SWP_GHOST) {
+		unsigned long j, np = si->cluster_vm ?
+			si->cluster_vm->nr_pages : 0;
+		struct page **pglist = si->cluster_vm ?
+			(struct page **)si->cluster_vm->pages : NULL;
+
+		xa_destroy(&si->redirect_xa);
+		kfree(si->ghost_name);
+		si->ghost_name = NULL;
+		for (j = 0; j < np; j++)
+			__free_page(pglist[j]);
+		kvfree(pglist);
+		if (si->cluster_vm) {
+			vm_area_unmap_pages(si->cluster_vm,
+					    (unsigned long)si->cluster_vm->addr,
+					    (unsigned long)si->cluster_vm->addr +
+					    np * PAGE_SIZE);
+			remove_vm_area(si->cluster_vm->addr);
+			kfree(si->cluster_vm);
+			si->cluster_vm = NULL;
+		}
+		si->cluster_info = NULL;
+	} else {
+		free_swap_cluster_info(si->cluster_info, si->max);
+		si->cluster_info = NULL;
+	}
 	/*
 	 * Clear the SWP_USED flag after all resources are freed so
 	 * alloc_swap_info can reuse this si safely.
-- 
2.54.0


