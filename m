Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 405C8D47CC3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2B966B0098; Fri, 16 Jan 2026 05:13:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17CB6B0099; Fri, 16 Jan 2026 05:13:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 916CC6B009B; Fri, 16 Jan 2026 05:13:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81C0A6B0098
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:13:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 439FF1BE73
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:13:13 +0000 (UTC)
X-FDA: 84337414266.08.6A6926D
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 89686140002
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:13:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=jjvE2GKY;
	spf=pass (imf23.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768558391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlCHSeFlA1HYaGvLiSk9R+HfjopCZ3pdVXy3ICJlSGo=;
	b=l0SGrfZgo5IftS5QHe7nNqnLte6zyBhSOXDMhgxuRoNQKWsJTe0DkIBhbD0InMyjslu4Ng
	I6G4r6TeQk28aLwW5wby+Y6kaXB2Y0Bnuzxzk0mwjZSS00p7eWRZ2j0CXt/tRaXXQ/JSHX
	8HUwA0liMbPtPpjs9+zAiznCQyU8qDU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768558391; a=rsa-sha256;
	cv=none;
	b=cc+1KdA+O84DbP5xj2TTSl4WV6prkBuw9jtOY3P3h1nmyi88sLB40qWZhMR+OftSbtmWZM
	DL8cnTwN9L5kpFdWQ0jF9pugxCYD5r01tFzTbiSdtfPlmUFBaonFalf9RNuxM5W9Z5EFYt
	d9DwyXtP6UzeV/RiuMHi0zTY9IQI36Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=jjvE2GKY;
	spf=pass (imf23.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260116101307epoutp048c6b7fdf18c58e84a35f1f8a6ceb3b98~LLnvICqIA1548415484epoutp04b
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:13:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260116101307epoutp048c6b7fdf18c58e84a35f1f8a6ceb3b98~LLnvICqIA1548415484epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768558387;
	bh=XlCHSeFlA1HYaGvLiSk9R+HfjopCZ3pdVXy3ICJlSGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjvE2GKYR75v0zIDAbIb8KOPpIvrc6NGMLn+lXoTtYfbicvYSWzoNGBa+MPNXV1Nj
	 YLCUZKBV9Wv6z3a1zJ/G4DVQkl7CyaGqEFVqZm35MIrdRI8kg153UmGZ5aiGkIsE1u
	 StL7/FdeUfapG2DKv9LLTl18DebsguBtuM7rEWTo=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260116101307epcas5p4fbee8b3aeafc6de8c006769961b34482~LLnuhh-Kx2325623256epcas5p4P;
	Fri, 16 Jan 2026 10:13:07 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.90]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dswfB1G0Tz6B9m7; Fri, 16 Jan
	2026 10:13:06 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260116101305epcas5p497cd6d9027301853669f1c1aaffbf128~LLntHUbqu3257132571epcas5p4D;
	Fri, 16 Jan 2026 10:13:05 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260116101300epsmtip27dc0a597055b27d334ed909f6acc148e~LLnn5AZqB0634506345epsmtip2R;
	Fri, 16 Jan 2026 10:12:59 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, kundan.kumar@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: [PATCH v3 6/6] xfs: offload writeback by AG using per-inode dirty
 bitmap and per-AG workers
Date: Fri, 16 Jan 2026 15:38:18 +0530
Message-Id: <20260116100818.7576-7-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260116100818.7576-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260116101305epcas5p497cd6d9027301853669f1c1aaffbf128
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101305epcas5p497cd6d9027301853669f1c1aaffbf128
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101305epcas5p497cd6d9027301853669f1c1aaffbf128@epcas5p4.samsung.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 89686140002
X-Rspam-User: 
X-Stat-Signature: pa6n56khfb9eet3gcy7y7uwm1br5maiz
X-HE-Tag: 1768558390-540511
X-HE-Meta: U2FsdGVkX18QBQ/vm2QqAXCAgt2DkOq0kjjHPjohxf5WK+TqZsCI0qpXCl4zDJLK+8iWIqmiOuXvyNYeM1qweC3KSdQEcM2nuCDfvKXF7IJp7KQY4c8T6L/1jn/kkqmssAl1FFIaupec5JbuInqn46uu6OiRMRXfNROdtZZr9sfYRwyDyhu6lzHQu5xvETLHu3mx0VXO31tEwZiXut64eqXUq+osvP0vx3hoDhlzT8USowUKneZnVpsixgi8f0yOsX63sXVQgmrPPXXiBAsmPGmKCGyKnYXiqEX1OqNyOXCtBJiM92g2iTrHXqCej0FTR+Wkn6jhNWbXMV4QARl9br5EQRqsW4onj/REIC81vkw+RpCDLOAgB7DE3sbLsKwj9vtfYYNFdhh23BGs0aRvpCKKCk7dAI/SOnmV9OKFxtKFOuy5C/QBHZWmsp+0vMOodkepeE0IX0lQxns4zcb6Ru958D6eGXxuSCXUx3MCRQO7s85lhVITrYb7APlZaWwjmGqDZ4ovN/FeJZODyqFkkDCeRg2xtD1QfJkAh5onFvp4o6f45/iJBIm+1RLAYXC2S4L0cGQ0yFY/bhOo0pYOspicza8BQlSH4K33tilFrkKPYd5S6WRrgWZ3A/TnxOg3opdXB+MH82suDodOq5S50ozCoJauNw300bBIKyMPIqED9ZVw5TpdzF8KMgxeVDhfORiNoi4fDbNujIo0RR2rXlEniCsP4BEmtH9WtXN4bQQqM3DCd32iKmF4VW9i9iliTUbbx0Eq0PBPy/MdWycjCnhxPLHPfcLjqTRQeUNl+Ax4VcofTAL9h2E66bT6WfyF5joIPhLbY2YpQQLmL4rEPHpzewVs+wTg1fQhhp5P4Fi9r/70Tj84p8uYxNMH22Joz90yePikVw9T7Z991pbbyn2325AUfnCcktVqXBOS3Ktw/VuHjINUHVy7rygv+hRaWcha2/P9qwwLgiGGE2i
 QXVJjRFz
 dH5wr8yvy1uAnxQasxWT3Y84f9U8TIR4N3JT1Bk1UgM9Vr7O7UNMDbBhFbBCRNQLxXS4In1mt9hOQkCyVtFU4foqqbKVwauopYItxVOVALN3DL/UxkNsPesNOoeC/RCjgS2Abci6I5WWq4I+acx9iQURlf4Q7dU6J3NcW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Offload XFS writeback to per-AG workers based on the inode dirty-AG
bitmap. Each worker scans and submits writeback only for folios
belonging to its AG.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_aops.c | 178 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 178 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 9d5b65922cd2..55c3154fb2b5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -678,6 +678,180 @@ xfs_zoned_writeback_submit(
 	return 0;
 }
 
+static bool xfs_agp_match(struct xfs_inode *ip, pgoff_t index,
+			  xfs_agnumber_t agno)
+{
+	void *ent;
+	u32 v;
+	bool match = false;
+
+	ent = xa_load(&ip->i_ag_pmap, index);
+	if (ent && xa_is_value(ent)) {
+		v = xa_to_value(ent);
+		if (xfs_agp_valid(v))
+			match = (xfs_agp_agno(v) == (u32)agno);
+	}
+
+	return match;
+}
+
+static bool xfs_folio_matches_ag(struct folio *folio, xfs_agnumber_t agno)
+{
+	struct xfs_inode *ip = XFS_I(folio_mapping(folio)->host);
+
+	return xfs_agp_match(ip, folio->index, agno);
+}
+
+static int xfs_writepages_ag(struct xfs_inode *ip,
+			     struct writeback_control *wbc,
+			     xfs_agnumber_t agno)
+{
+	struct inode *inode = VFS_I(ip);
+	struct address_space *mapping = inode->i_mapping;
+	struct folio_batch *fbatch = &wbc->fbatch;
+	int ret = 0;
+	pgoff_t index, end;
+
+	wbc->range_cyclic = 0;
+
+	folio_batch_init(fbatch);
+	index = wbc->range_start >> PAGE_SHIFT;
+	end = wbc->range_end >> PAGE_SHIFT;
+
+	struct xfs_writepage_ctx wpc = {
+		.ctx = {
+			.inode = inode,
+			.wbc = wbc,
+			.ops = &xfs_writeback_ops,
+		},
+	};
+
+	while (index <= end) {
+		int i, nr;
+
+		/* get a batch of DIRTY folios starting at index */
+		nr = filemap_get_folios_tag(mapping, &index, end,
+					    PAGECACHE_TAG_DIRTY, fbatch);
+		if (!nr)
+			break;
+
+		for (i = 0; i < nr; i++) {
+			struct folio *folio = fbatch->folios[i];
+
+			/* Filter BEFORE locking */
+			if (!xfs_folio_matches_ag(folio, agno))
+				continue;
+
+			folio_lock(folio);
+
+			/*
+			 * Now it's ours: clear dirty and submit.
+			 * This prevents *this AG worker* from seeing it again
+			 * next time.
+			 */
+			if (!folio_clear_dirty_for_io(folio)) {
+				folio_unlock(folio);
+				continue;
+			}
+			xa_erase(&ip->i_ag_pmap, folio->index);
+
+			ret = iomap_writeback_folio(&wpc.ctx, folio);
+			folio_unlock(folio);
+
+			if (ret) {
+				folio_batch_release(fbatch);
+				goto out;
+			}
+		}
+
+		folio_batch_release(fbatch);
+		cond_resched();
+	}
+
+out:
+	if (wpc.ctx.wb_ctx && wpc.ctx.ops && wpc.ctx.ops->writeback_submit)
+		wpc.ctx.ops->writeback_submit(&wpc.ctx, ret);
+
+	return ret;
+}
+
+static void xfs_ag_writeback_work(struct work_struct *work)
+{
+	struct xfs_ag_wb *awb = container_of(to_delayed_work(work),
+					     struct xfs_ag_wb, ag_work);
+	struct xfs_ag_wb_task *task;
+	struct xfs_mount *mp;
+	struct inode *inode;
+	struct xfs_inode *ip;
+	int ret;
+
+	for (;;) {
+		spin_lock(&awb->lock);
+		task = list_first_entry_or_null(&awb->task_list,
+						struct xfs_ag_wb_task, list);
+		if (task)
+			list_del_init(&task->list);
+		spin_unlock(&awb->lock);
+
+		if (!task)
+			break;
+
+		ip = task->ip;
+		mp = ip->i_mount;
+		inode = VFS_I(ip);
+
+		ret = xfs_writepages_ag(ip, &task->wbc, task->agno);
+
+		/* If didn't submit everything for this AG, set its bit */
+		if (ret)
+			set_bit(task->agno, ip->i_ag_dirty_bitmap);
+
+		iput(inode); /* drop igrab */
+		mempool_free(task, mp->m_ag_task_pool);
+	}
+}
+
+static int xfs_vm_writepages_offload(struct address_space *mapping,
+				     struct writeback_control *wbc)
+{
+	struct inode *inode = mapping->host;
+	struct xfs_inode *ip = XFS_I(inode);
+	struct xfs_mount *mp = ip->i_mount;
+	struct xfs_ag_wb *awb;
+	struct xfs_ag_wb_task *task;
+	xfs_agnumber_t agno;
+
+	if (!ip->i_ag_dirty_bits)
+		return 0;
+
+	for_each_set_bit(agno, ip->i_ag_dirty_bitmap, ip->i_ag_dirty_bits) {
+		if (!test_and_clear_bit(agno, ip->i_ag_dirty_bitmap))
+			continue;
+
+		task =  mempool_alloc(mp->m_ag_task_pool, GFP_NOFS);
+		if (!task) {
+			set_bit(agno, ip->i_ag_dirty_bitmap);
+			continue;
+		}
+
+		INIT_LIST_HEAD(&task->list);
+		task->ip = ip;
+		task->agno = agno;
+		task->wbc = *wbc;
+		igrab(inode); /* worker owns inode ref */
+
+		awb = &mp->m_ag_wb[agno];
+
+		spin_lock(&awb->lock);
+		list_add_tail(&task->list, &awb->task_list);
+		spin_unlock(&awb->lock);
+
+		mod_delayed_work(mp->m_ag_wq, &awb->ag_work, 0);
+	}
+
+	return 0;
+}
+
 static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
 	.writeback_range	= xfs_zoned_writeback_range,
 	.writeback_submit	= xfs_zoned_writeback_submit,
@@ -706,6 +880,7 @@ xfs_init_ag_writeback(struct xfs_mount *mp)
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
 		struct xfs_ag_wb *awb = &mp->m_ag_wb[agno];
 
+		INIT_DELAYED_WORK(&awb->ag_work, xfs_ag_writeback_work);
 		spin_lock_init(&awb->lock);
 		INIT_LIST_HEAD(&awb->task_list);
 		awb->agno = agno;
@@ -769,6 +944,9 @@ xfs_vm_writepages(
 			xfs_open_zone_put(xc.open_zone);
 		return error;
 	} else {
+		if (wbc->sync_mode != WB_SYNC_ALL)
+			return xfs_vm_writepages_offload(mapping, wbc);
+
 		struct xfs_writepage_ctx	wpc = {
 			.ctx = {
 				.inode	= mapping->host,
-- 
2.25.1


