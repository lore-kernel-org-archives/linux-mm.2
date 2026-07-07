Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38C1FC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37DEA6B00B5; Tue,  7 Jul 2026 04:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32E986B00B7; Tue,  7 Jul 2026 04:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21D816B00B8; Tue,  7 Jul 2026 04:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7DD16B00B5
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:27:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E39012039A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:27:46 +0000 (UTC)
X-FDA: 84961302132.07.098E8CF
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9865440007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:27:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="R/5DCUXv";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412864;
	b=gV2O8fLac/aDQRq5ilQ4P8i4suxWtCTJCP25P0SUYHmUdv2+LIXP+FpO7dRCWFs4E95aqO
	RR4Ji5BOGAtSolwYoKin7KDcG4AdPNsGy2eHOsYKLRF39IWtkpg0KSHlEMKXJqnub346+6
	6djug5Zc1+I5g3FMuN7QnXkpC/daCoE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="R/5DCUXv";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yihnCEZ8cVWBNOzVl1JoQsUGqfa5cZb/NMsbpAPjbu4=;
	b=YhMPCpQX/JDZys78P5mn/ZrQ1WD5UQ/Zl4bGRVn+E03j4QjTacTxuV2Usq7MRBX3CITCLw
	wrpC/eEz2tSFBhbz2tHRxRxuNOsnKxEJHVdWX+5cYr/1M/mqIYkLuhrSYIGOxs29nXC6Dn
	CoiMIBBvpWmbKF21/BIEE0fUdMx+FRY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783412863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yihnCEZ8cVWBNOzVl1JoQsUGqfa5cZb/NMsbpAPjbu4=;
	b=R/5DCUXvrIXSqgwmx1kRAI7I80LsohS9htiVnFyv3HzIxXkRNskpMmlWBJKmwwhxHmW0qV
	hpRmq8hUHxz0V0MeIi0fwNoalxmtVT4FOueDChy82KJbX4N0UxijVY6Do2vDWwtFsyyknT
	FFiGCDGQTqrGUbyEc8PpFZ9MaaH/KcU=
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
Subject: [RFC PATCH 09/10] mm/swapfile: implement swap_ghost_extend_max() for dynamic growth
Date: Tue,  7 Jul 2026 16:26:11 +0800
Message-ID: <20260707082614.95030-10-baoquan.he@linux.dev>
In-Reply-To: <20260707082614.95030-1-baoquan.he@linux.dev>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9865440007
X-Rspam-User: 
X-Stat-Signature: 53ykdcycyrfaxcy97zwiudk6pcdc9sbe
X-Rspamd-Server: rspam03
X-HE-Tag: 1783412864-523669
X-HE-Meta: U2FsdGVkX18b5wfwIbkZifWpYC+JqiLG/1YyuYcrUooaPoIZjjdfxlYyYeNTSg4XnCuaPPVNr6TCGNn+eNX2fx8DMGUggkHdBE1hZZ4D42Y61ZKpnaCGHcuf1ORH31zd763trzLs50121pAwls82ONsJ5AvTgEflqOpwL4InYImLPF15HY9S9U9dkbTy2cLeSmRCvPMAQrpP/DijUqpZrFwl9uR4W9PY61rOYg3jZqA6T3pSacLpUSeRV3b1lOS87dBfTksZgfyfhjB+j7Wf7vy2l26QfLTy/oieOzJpYQ+jw7C8hpyhTjjFMlJJg3034cFWTMMZWcK2hx3cCc/MvBBIPYp7MS9voJr8Wc5e2UNPK/uSEsmUJaYxAs+BIWuq9hwRZj1Ug2NK1qLLKQ5qPNslhDPfjLuzu7RGBx35U/g02+MWbvVb7ZkqhP2CSGt6bvoKILOqdAcyvXa+h2UKrtuPOTlI0km/tLJhc+eUK34rXKF3y0gmPUW2QHVfp7zX9r6pEhCyyGqek3IkxW7/huySm/Mpo5M9pjl13qJ8xeMHit61AMgv4rJqisnba/XYFkRq8OyQFdFOSjjHqfsd61M+ZnVjpxMMHfMU427bWXOfibLki6QZZhL3m+K6la/tmFaQi+mBj2ajAnBkQCWnKywbQvjWjq/ZgYzHPQ/lXmdJbVSG/kOBZfr5GoMUuQVXsIrVSCMhJuLuLDRXVuTV9g3TFrSv72M9VipPFejIihJxck5pV0ddVamFUzwKy0BFvMgwEOLMyooAXzP/mRsxqGGMKAr43dXG4F+Eja5IZlFCYeko19rxfbCXPQUnMuerqqYgesfJHBQ5Y+Nj1mBVuKioqF4JpcHY1hUgs84udjQAkONwcqHTF/lnNBUUmN7lXxaKjPgb4KCKq1dai1ttbhe46byhLjYp/wZjXlsBAQfBkCBOBdQR3aX0sBzMU/cMVtv4VUsq1P8GyfBUpNx
 Mo650EPq
 j6vn8QKeWbEu/zva64NjJNzNFNKkRO2gJWH3XYgBNVl3ky+AL3s+r61/ORGTRjV+J5EGosNY2H5Tr7P+sVfbQM2o7Yd3wZcy8jZyrS8ej1FKkYYb9QMHtt2xWBd8RvQ3v3CpTqFI2NjvHkEpO2w9FatGVZxA/vR+M7oRZrzL4avQ58ClsMGMAoySzWWXXN0aYjUrdC2ts/Epsmgh+r7KHqU3Oj+E7YmkFzE2OQnwY5CetX5fEe4SjQfIaATk2/xJIWSrBGmPIZTK+2cum0NsFwStaGZZkqV32jbkSDhXxCvQinc55uh3LQen+UStWE1QUQb1mbtodVq67fyNE86PQGkhIkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allocate additional physical pages and map them at the end of the
already-reserved sparse vmalloc area via vm_area_map_pages(). The flat
cluster_info pointer never moves — new clusters appear contiguously at
higher indices. New clusters are fully initialized (spinlocks, list
heads, trailing BAD mask) before si->max is published via WRITE_ONCE.

Page-pointer tracking in cluster_vm->pages is reallocated to accommodate
additional entries. Returns -E2BIG if the requested size exceeds the
reserved VA range. Extension is serialized by swapon_mutex.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swapfile.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index da085a75d7b5..8bf336678887 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -58,6 +58,8 @@ static void move_cluster(struct swap_info_struct *si,
 			 enum swap_cluster_flags new_flags);
 #ifdef CONFIG_ZSWAP
 #define GHOST_MAX_CLUSTER_BYTES (64UL * 1024 * 1024)
+static int swap_ghost_extend_max(struct swap_info_struct *si,
+				 unsigned int new_maxpages);
 #endif
 
 /*
@@ -4247,6 +4249,114 @@ swp_entry_t ghost_redirect_to_phys(struct swap_info_struct *si, pgoff_t offset)
 
 	return (swp_entry_t){};
 }
+
+/*
+ * swap_ghost_extend_max — Extend an active ghost swap device.
+ * @si:  ghost device (SWP_GHOST set)
+ * @new: new max pages (> si->max)
+ *
+ * Allocates physical pages and maps them at the end of the reserved
+ * sparse vmalloc area.  si->cluster_info never moves.  New clusters
+ * are fully initialized before si->max is published via WRITE_ONCE.
+ *
+ * Returns 0, -ENOMEM, -EINVAL, or -E2BIG.  Caller holds swapon_mutex.
+ */
+static int swap_ghost_extend_max(struct swap_info_struct *si,
+				 unsigned int new)
+{
+	unsigned long old_max = si->max, old_nr, new_nr;
+	unsigned long old_bytes, new_bytes, nr_new_pg;
+	struct page **new_pglist;
+	unsigned long i;
+
+	if (!(si->flags & SWP_GHOST) ||
+	    !(si->flags & (SWP_USED | SWP_WRITEOK)) ||
+	    new <= si->max)
+		return -EINVAL;
+
+	old_nr = DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER);
+	new_nr = DIV_ROUND_UP(new, SWAPFILE_CLUSTER);
+	old_bytes = ALIGN(old_nr * sizeof(struct swap_cluster_info), PAGE_SIZE);
+	new_bytes = ALIGN(new_nr * sizeof(struct swap_cluster_info), PAGE_SIZE);
+	nr_new_pg = (new_bytes - old_bytes) / PAGE_SIZE;
+
+	if (old_bytes + nr_new_pg * PAGE_SIZE > si->cluster_vm->size) {
+		pr_warn("ghost: extend to %u exceeds reserved VA (%lu bytes)\n",
+			new, si->cluster_vm->size);
+		return -E2BIG;
+	}
+
+	new_pglist = kvmalloc_array(si->cluster_vm->nr_pages + nr_new_pg,
+				    sizeof(struct page *), GFP_KERNEL);
+	if (!new_pglist)
+		return -ENOMEM;
+	if (si->cluster_vm->pages) {
+		memcpy(new_pglist, si->cluster_vm->pages,
+		       si->cluster_vm->nr_pages * sizeof(struct page *));
+		kvfree(si->cluster_vm->pages);
+	}
+	si->cluster_vm->pages = (void *)new_pglist;
+
+	for (i = 0; i < nr_new_pg; i++) {
+		struct page *page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page) {
+			while (i-- > 0)
+				__free_page(new_pglist[si->cluster_vm->nr_pages + i]);
+			return -ENOMEM;
+		}
+		new_pglist[si->cluster_vm->nr_pages + i] = page;
+	}
+
+	if (vm_area_map_pages(si->cluster_vm,
+			      (unsigned long)si->cluster_vm->addr + old_bytes,
+			      (unsigned long)si->cluster_vm->addr + new_bytes,
+			      &new_pglist[si->cluster_vm->nr_pages])) {
+		for (i = 0; i < nr_new_pg; i++)
+			__free_page(new_pglist[si->cluster_vm->nr_pages + i]);
+		return -ENOMEM;
+	}
+	si->cluster_vm->nr_pages += nr_new_pg;
+
+	for (i = old_nr; i < new_nr; i++) {
+		struct swap_cluster_info *ci = &si->cluster_info[i];
+		spin_lock_init(&ci->lock);
+		INIT_LIST_HEAD(&ci->list);
+	}
+
+	if (new % SWAPFILE_CLUSTER) {
+		unsigned long base = (new - 1) / SWAPFILE_CLUSTER *
+				    SWAPFILE_CLUSTER;
+		unsigned long idx = base / SWAPFILE_CLUSTER;
+		struct swap_cluster_info *ci = &si->cluster_info[idx];
+
+		if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL)) {
+			for (i = 0; i < nr_new_pg; i++)
+				__free_page(new_pglist[si->cluster_vm->nr_pages + i]);
+			return -ENOMEM;
+		}
+		spin_lock(&ci->lock);
+		for (i = new % SWAPFILE_CLUSTER; i < SWAPFILE_CLUSTER; i++)
+			__swap_table_set(ci, i, SWP_TB_BAD);
+		spin_unlock(&ci->lock);
+	}
+
+	WRITE_ONCE(si->max, new);
+
+	for (i = old_nr; i < new_nr; i++) {
+		struct swap_cluster_info *ci = &si->cluster_info[i];
+		ci->flags = CLUSTER_FLAG_FREE;
+		spin_lock(&si->lock);
+		list_add_tail(&ci->list, &si->free_clusters);
+		spin_unlock(&si->lock);
+	}
+
+	si->pages += new - old_max;
+	atomic_long_add(new - old_max, &nr_swap_pages);
+	spin_lock(&swap_lock);
+	total_swap_pages += new - old_max;
+	spin_unlock(&swap_lock);
+	return 0;
+}
 #endif /* CONFIG_ZSWAP */
 
 static int __init swapfile_init(void)
-- 
2.54.0


