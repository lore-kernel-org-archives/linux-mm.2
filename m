Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B54D47CC3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F2036B0096; Fri, 16 Jan 2026 05:13:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2BE6B0098; Fri, 16 Jan 2026 05:13:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E9E56B0099; Fri, 16 Jan 2026 05:13:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0FC6B0096
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:13:08 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 30F611A05CB
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:13:08 +0000 (UTC)
X-FDA: 84337414056.11.34DD747
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 49A4B40009
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:13:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=BrclL0mt;
	spf=pass (imf17.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768558385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LEudv48FbYI3jxGKm1EoFln+VzTAerZ867l6GxD+u1Q=;
	b=Ke6YFeOHqeFufOyts8qfn6/IGWni6Z7nea+CxutZ6T/dvTSGH+H3sLMEpNlZKWisL/5OxJ
	g28k9vavoIYWES3dDWAp7K5v5VmitZF9ASljuGqTKpYIJzAx5TVtgwBU7QEluMe3Q14JSj
	/TOalvLqtkhnDRMMCc9kObtXxW76HRM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768558385; a=rsa-sha256;
	cv=none;
	b=H8ksdeDyBtFQyDODtWW3bwmbvM2qZVDsm/wyNIDE9/hcPW/tausWXhZ/3FqyYn114OyuND
	X6AfgFS0Gu1vdO/r2K5HfqvXwggExNYuAYV6v4xMFtT1bcgwSTmfP7TlT/23mWsfKRO8Gw
	faAK0ANgyQfRbXPRy0oGWQN7wLMw7mg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=BrclL0mt;
	spf=pass (imf17.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260116101302epoutp0470e5b095616dca22c70987f115709641~LLnpwoDw_1540615406epoutp04h
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:13:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260116101302epoutp0470e5b095616dca22c70987f115709641~LLnpwoDw_1540615406epoutp04h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768558382;
	bh=LEudv48FbYI3jxGKm1EoFln+VzTAerZ867l6GxD+u1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrclL0mtcL/9mebcncNQJLEd+K9SZWXqC4LSYx5RokpaDy4Ij9PDzjIzfnsgoJMB9
	 Yxg6ypw4X6pyA3eL9hyR6XVlEpebQcZy/GEF/hJFzLfaVY6JB3qTeZiqGzjM9UjkK7
	 cYADjPTlHIZJ6VuVu/2wyvYbMZz0DFC57Bw7D5Ew=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260116101301epcas5p1dabcbcbc983d060bfd774a6b49d2621e~LLnpNvqxI1616916169epcas5p1i;
	Fri, 16 Jan 2026 10:13:01 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.89]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dswf42lMvz2SSKd; Fri, 16 Jan
	2026 10:13:00 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260116101259epcas5p1cfa6ab02e5a01f7c46cc78df95c57ce0~LLnnsIu7V0902909029epcas5p1_;
	Fri, 16 Jan 2026 10:12:59 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260116101256epsmtip2c5338bdbb107259573618ff7a08310b7~LLnkrm3ds0821508215epsmtip2J;
	Fri, 16 Jan 2026 10:12:56 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, kundan.kumar@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: [PATCH v3 5/6] xfs: add per-AG writeback workqueue infrastructure
Date: Fri, 16 Jan 2026 15:38:17 +0530
Message-Id: <20260116100818.7576-6-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260116100818.7576-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260116101259epcas5p1cfa6ab02e5a01f7c46cc78df95c57ce0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101259epcas5p1cfa6ab02e5a01f7c46cc78df95c57ce0
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101259epcas5p1cfa6ab02e5a01f7c46cc78df95c57ce0@epcas5p1.samsung.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 49A4B40009
X-Rspam-User: 
X-Stat-Signature: eqofbcwr179b6p5icu16y4t71yj9kxqw
X-HE-Tag: 1768558384-722982
X-HE-Meta: U2FsdGVkX1/qyBGJ4mS6ZQBZz6RnmyjnJ5znKj54xhbdpYcPRcnZlmNr23czQ3uHkoNxtUoPiajHZ73kQXGH+kngMstNsmgMlI6YzzDvkUesqginN8VTs3osud5/oY/rsKa4NqLtNYPtLI7GbgPsU27PWvMAqCadR5SFo5n7LS5txKwqRiAYM46wg4vP1GDcfUb6E48hTdrxZTogAIcf2j2ouowQBUYHpD6D0/AMl/149Jlozo/+XJTr8m2YZZr07T7R574c1bRH/kfCHdVEpRcoFQQ+2LMhh3IqYhPjjge+T847I4+URrbhgVzo633Djbvd0WOZfzLRPVy48M/GH4iT8PRFS/VMJpKfLVA72fhs3B+hPmaPB3waiGFuBCXgrOYE51v2gR/RXQ/fIyoUkaUkBEcQ57KwFHMlhWJCxeLdTcSHFjRSzR+J+baFAvI4iYq3lzU9xUT85vKigqETJM1NC6S/Uo7ouAHF6jZaaZUo9r5rCBOonmBKHOyrMVcuXzZCNdxiOjudlEXf1MpSyQpkINH3KnHOhvJDJ8bUpfDlrE4xOMrbP+5nqlfehCcQmLYUojNyJZ63qcVIREovZME5ZR4zJXhsPE/HfzN0iU9iEjRV8F7sAObh5A7TFRtb7N3wnoeob34fvTQlnIyGfu8OYsf55QIanaVqfGFStzYA4bolP2XRRFIY4XxaaR/fN8esxxSvsggQ/THKzviArBR3v0QSqxUoKhA7nC/KWKBrq52soxEWv0flb6k60goWg+sZnfG4JpZ7sHQFJEORkjF/E8H6pimpco9BFOKK2wWOJ++7T6ZTJGuJ6NLJi71xxw90iyK/0WpadidZqPxs9BXmXw4ppTfJQqH2K1T12c7Qad9dsMgQUGUPazfBSYRDVog0FgbBfy9vH212nOD2XLzSEoB6DkGEB1q0hDo1XPm+HaG0KjGvkQO+aYmsFjmef+7nNSaXPItQ6x4Zr9Q
 nPfUg/zX
 1dqvi0Y/9qq+4HRnzcCd6+xlme4GVhDaoFA7xCQrXkL+jW3nt/nUvez5pSWu3hdh50aEwc3oJpp3tcvsuVGlyj48sabBtWJF40WeDxUCJqRIEACr2Kj18QWCBa5Pkpg0PonvfwMOfauI/MkwortK8Q6+ShMkc4ynki3ib
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce per-AG writeback worker infrastructure at mount time.
This patch adds initialization and teardown only, without changing
writeback behavior.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_aops.c  | 79 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_aops.h  |  3 ++
 fs/xfs/xfs_mount.c |  2 ++
 fs/xfs/xfs_mount.h | 10 ++++++
 fs/xfs/xfs_super.c |  2 ++
 5 files changed, 96 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a26f79815533..9d5b65922cd2 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -23,6 +23,23 @@
 #include "xfs_zone_alloc.h"
 #include "xfs_rtgroup.h"
 
+#define XFS_AG_TASK_POOL_MIN 1024
+
+struct xfs_ag_wb_task {
+	struct list_head list;
+	struct xfs_inode *ip;
+	struct writeback_control wbc;
+	xfs_agnumber_t agno;
+};
+
+struct xfs_ag_wb {
+	struct delayed_work ag_work;
+	spinlock_t lock;
+	struct list_head task_list;
+	xfs_agnumber_t agno;
+	struct xfs_mount *mp;
+};
+
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
 	unsigned int		data_seq;
@@ -666,6 +683,68 @@ static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
 	.writeback_submit	= xfs_zoned_writeback_submit,
 };
 
+void
+xfs_init_ag_writeback(struct xfs_mount *mp)
+{
+	xfs_agnumber_t agno;
+
+	mp->m_ag_wq = alloc_workqueue("xfs-ag-wb", WQ_UNBOUND | WQ_MEM_RECLAIM,
+				      0);
+	if (!mp->m_ag_wq)
+		return;
+
+	mp->m_ag_wb = kcalloc(mp->m_sb.sb_agcount,
+				sizeof(struct xfs_ag_wb),
+				GFP_KERNEL);
+
+	if (!mp->m_ag_wb) {
+		destroy_workqueue(mp->m_ag_wq);
+		mp->m_ag_wq = NULL;
+		return;
+	}
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		struct xfs_ag_wb *awb = &mp->m_ag_wb[agno];
+
+		spin_lock_init(&awb->lock);
+		INIT_LIST_HEAD(&awb->task_list);
+		awb->agno = agno;
+		awb->mp = mp;
+	}
+
+	mp->m_ag_task_cachep = kmem_cache_create("xfs_ag_wb_task",
+						sizeof(struct xfs_ag_wb_task),
+						0,
+						SLAB_RECLAIM_ACCOUNT,
+						NULL);
+
+	mp->m_ag_task_pool = mempool_create_slab_pool(XFS_AG_TASK_POOL_MIN,
+	mp->m_ag_task_cachep);
+
+	if (!mp->m_ag_task_pool) {
+		kmem_cache_destroy(mp->m_ag_task_cachep);
+		mp->m_ag_task_cachep = NULL;
+	}
+}
+
+void
+xfs_destroy_ag_writeback(struct xfs_mount *mp)
+{
+	if (mp->m_ag_wq) {
+		flush_workqueue(mp->m_ag_wq);
+		destroy_workqueue(mp->m_ag_wq);
+		mp->m_ag_wq = NULL;
+	}
+	kfree(mp->m_ag_wb);
+	mp->m_ag_wb = NULL;
+
+	mempool_destroy(mp->m_ag_task_pool);
+	mp->m_ag_task_pool = NULL;
+
+	kmem_cache_destroy(mp->m_ag_task_cachep);
+	mp->m_ag_task_cachep = NULL;
+}
+
 STATIC int
 xfs_vm_writepages(
 	struct address_space	*mapping,
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 5a7a0f1a0b49..e84acb7e8ca8 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -12,4 +12,7 @@ extern const struct address_space_operations xfs_dax_aops;
 int xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
 void xfs_end_bio(struct bio *bio);
 
+void xfs_init_ag_writeback(struct xfs_mount *mp);
+void xfs_destroy_ag_writeback(struct xfs_mount *mp);
+
 #endif /* __XFS_AOPS_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0953f6ae94ab..26224503c4bf 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1323,6 +1323,8 @@ xfs_unmountfs(
 
 	xfs_qm_unmount(mp);
 
+	xfs_destroy_ag_writeback(mp);
+
 	/*
 	 * Unreserve any blocks we have so that when we unmount we don't account
 	 * the reserved free space as used. This is really only necessary for
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b871dfde372b..c44155de2883 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -342,6 +342,16 @@ typedef struct xfs_mount {
 
 	/* Hook to feed dirent updates to an active online repair. */
 	struct xfs_hooks	m_dir_update_hooks;
+
+
+	/* global XFS AG writeback wq */
+	struct workqueue_struct *m_ag_wq;
+	/* array of [sb_agcount] */
+	struct xfs_ag_wb        *m_ag_wb;
+
+	/* task cache and pool */
+	struct kmem_cache *m_ag_task_cachep;
+	mempool_t *m_ag_task_pool;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bc71aa9dcee8..73f8d2942df4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1765,6 +1765,8 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_sb;
 
+	xfs_init_ag_writeback(mp);
+
 	/*
 	 * V4 support is undergoing deprecation.
 	 *
-- 
2.25.1


