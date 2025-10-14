Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF93FCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2499F8E00FB; Tue, 14 Oct 2025 08:11:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9F28E000D; Tue, 14 Oct 2025 08:11:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8EC8E00FB; Tue, 14 Oct 2025 08:11:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9B8F8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:11:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9FE3CC08E3
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:14 +0000 (UTC)
X-FDA: 83996604468.03.31757E5
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3CC351C0004
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=KXVPMq6j;
	spf=pass (imf21.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443872; a=rsa-sha256;
	cv=none;
	b=8NUUG6crcdPfG+nO1LYMp8B/xOuvbvY9iZ3FM/aMYrvDRMc1x6trlEQImueRY/OYJ31YcK
	TiJ73rhEVX/RH9AuJ0lkBWZ7bVD3RYd7I7USZcq44/W3D8O+nIxa//k3VZ3s6xAKP1krf8
	qyGP9WQCqrYr4M/18xzZgUXbFG39jtE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=KXVPMq6j;
	spf=pass (imf21.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/LvlMlwmoGn4EEu6fl0YJvh1Z+uAYGGiSNYbvlUAoI=;
	b=jBXFSDBsI2YXxTFO/TKA8k3RNiZlEN2jh/NPuC60nCmVomr0b+Dktvzw3e5O3TgcqGKZnO
	zrWThFWYlRMlTZedyIF/svVSt4bDEiGrw4T7MT/sA5BqKPPkTILRDJ4EENY9LU6ftBrpFW
	yBl/Gz8L5+oXlIuKOhDKPC5GPm+vbNo=
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251014121110epoutp02cadac40e037499a7a9c7684e18954274~uWl9lunYX2397723977epoutp02g
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251014121110epoutp02cadac40e037499a7a9c7684e18954274~uWl9lunYX2397723977epoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443870;
	bh=C/LvlMlwmoGn4EEu6fl0YJvh1Z+uAYGGiSNYbvlUAoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KXVPMq6jumEvwP9xqK7fm9mUMAbJiNK54aw0VeA0ye1OrdsNFmudi3+eNXjyAN9eg
	 knmPQEJ8BSMV8cbjaas8eY15dU0ZsO3N1/+Zw7B2LCsMCXMK1LOOJ0Raw+uq5Vh7fJ
	 Q9NCarmAfG2p6B70i8TY7JBDYb8+k/W2PwHFLh2c=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20251014121109epcas5p1450a20b2fb1624046b50ace88f3a111f~uWl8-9sfY3122231222epcas5p1L;
	Tue, 14 Oct 2025 12:11:09 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cmCjm3nKMz6B9m6; Tue, 14 Oct
	2025 12:11:08 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121108epcas5p1d68e41bdb1d51ae137b9bb22a7d16fd1~uWl7o_jJZ1447514475epcas5p1s;
	Tue, 14 Oct 2025 12:11:08 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121102epsmtip1b866f23363f52d9d5531fb176e70bee4~uWl27p7SL1256112561epsmtip1F;
	Tue, 14 Oct 2025 12:11:02 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu, agruenba@redhat.com,
	trondmy@kernel.org, anna@kernel.org, akpm@linux-foundation.org,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, wangyufei@vivo.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	gost.dev@samsung.com, kundan.kumar@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
Subject: [PATCH v2 10/16] fuse: add support for multiple writeback contexts
 in fuse
Date: Tue, 14 Oct 2025 17:38:39 +0530
Message-Id: <20251014120845.2361-11-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014121108epcas5p1d68e41bdb1d51ae137b9bb22a7d16fd1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014121108epcas5p1d68e41bdb1d51ae137b9bb22a7d16fd1
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
	<CGME20251014121108epcas5p1d68e41bdb1d51ae137b9bb22a7d16fd1@epcas5p1.samsung.com>
X-Rspam-User: 
X-Stat-Signature: q4g3uxbn9kzhyab1ayfu7hgxy3oe6c6g
X-Rspamd-Queue-Id: 3CC351C0004
X-Rspamd-Server: rspam09
X-HE-Tag: 1760443871-219545
X-HE-Meta: U2FsdGVkX184dLLmaMaDNQHEAYCZ0XniZOzL4U4goNZYnBBRG6cVduinw+Py3NMmbryM9O/U+LcU3L/ukEFimp8am63S5aNjSS4ZClgbfAiRxXiir095G9ls05y1ins6EM4N/xu9K6syo3izeswGWwhhbpAUNU/lG1TyxRo4wfxFZ18ZwEgaf2rVU2I8xDhO8XnaZLoKIOUnN8zJlFkAPEEN4PEGmrex6rQ+xkCR9vpSXyHNr5UDRh2NrfDcz70cP+MlL1BNAILk98Hc7ISuPQ8WfiqXHELAIf1jw75K8lgIU7HjTBvk9bsxb21seNMIi4K2R+5T0hvwhLAaBeohpkNV55MU71KXDTKDhxh26JPKWZJ3TKBC7JqgOuwjcv6SvkyXfg8eNLmgukEqEDL/2WEo8fHkmrzzk3hIyWE/0l6xkjiP8+GOtqwPdBBm74MaSMFd08VSRwhEOgCi+uepGs9M79SO18GxXxNnknc9n5MqnhLGUsoOpt+UqbAuJFWP9Mu58HzHGHUlChr4wBPPnJOC4n/gXVBvoKxzSQUqt/7PucFWjkEJOEgb4MuOtHkbTH3EsIFQcpT0beAf4DSISshj3U3fXJ+KrMo673k4c+ALikbEGA9EoqPs8e6uKDQUyOW+7emii9n3Os93fzWSDcDwcWGWvn5ZJhFkxwo9pDqxvC8n89ydMTlps0ESZ3gE5LP/vNipuPqicnvlhlsfPWXQz809CQxr4FM0A3tvH1tzxXvY0kYCgbU6pVwFaj0LruO8PEWRf/mfDd9zZw0hSGPZDLdnvtqNlCF4HS0/cDa4O6uA0sUvUYAY87TWVWkmG518XLK97056rUYuVVivIfDYBM4dUGuacCN8BVVVWtqQQK9nEKuM/cxNAgwP+u9tF512YAGeEvZNyJK8N8zTFJsTCTerRs84aY0Cs63bTFOa3BocLA30yAuWgqLlN8WOaY1CBaDqoUunNzcR+TG
 IERGelfD
 wgQGBzdy3iCTvD2vdIQ8FM4yuTgT0pLG8j3V+K4SJk0qsvfk3O/5QJZwOw1iRmxMuruRQE6tGm2ZVFdck5OlPBmxddLLbrBzgWbL+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Made a helper to fetch writeback context to which an inode is affined.
Use it to perform writeback related operations.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/fuse/file.c              |  7 +++----
 include/linux/backing-dev.h | 17 +++++++++++++++++
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 8c823a661139..9c7f0e4b741f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1823,7 +1823,6 @@ static void fuse_writepage_finish(struct fuse_writepage_args *wpa)
 	struct fuse_args_pages *ap = &wpa->ia.ap;
 	struct inode *inode = wpa->inode;
 	struct fuse_inode *fi = get_fuse_inode(inode);
-	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	int i;
 
 	for (i = 0; i < ap->num_folios; i++) {
@@ -1833,8 +1832,8 @@ static void fuse_writepage_finish(struct fuse_writepage_args *wpa)
 		 * contention and noticeably improves performance.
 		 */
 		iomap_finish_folio_write(inode, ap->folios[i], 1);
-		dec_wb_stat(&bdi->wb_ctx[0]->wb, WB_WRITEBACK);
-		wb_writeout_inc(&bdi->wb_ctx[0]->wb);
+		bdi_wb_stat_mod(inode, -1);
+		bdi_wb_writeout_inc(inode);
 	}
 
 	wake_up(&fi->page_waitq);
@@ -2017,7 +2016,7 @@ static void fuse_writepage_args_page_fill(struct fuse_writepage_args *wpa, struc
 	ap->descs[folio_index].offset = offset;
 	ap->descs[folio_index].length = len;
 
-	inc_wb_stat(&inode_to_bdi(inode)->wb_ctx[0]->wb, WB_WRITEBACK);
+	bdi_wb_stat_mod(inode, 1);
 }
 
 static struct fuse_writepage_args *fuse_writepage_args_setup(struct folio *folio,
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index bb35f8fa4973..fb042e593c16 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -46,6 +46,9 @@ extern struct list_head bdi_list;
 
 extern struct workqueue_struct *bdi_wq;
 
+static inline struct bdi_writeback_ctx *
+fetch_bdi_writeback_ctx(struct inode *inode);
+
 static inline bool wb_has_dirty_io(struct bdi_writeback *wb)
 {
 	return test_bit(WB_has_dirty_io, &wb->state);
@@ -103,6 +106,20 @@ static inline s64 wb_stat_sum(struct bdi_writeback *wb, enum wb_stat_item item)
 
 extern void wb_writeout_inc(struct bdi_writeback *wb);
 
+static inline void bdi_wb_stat_mod(struct inode *inode, s64 amount)
+{
+	struct bdi_writeback_ctx *bdi_wb_ctx = fetch_bdi_writeback_ctx(inode);
+
+	wb_stat_mod(&bdi_wb_ctx->wb, WB_WRITEBACK, amount);
+}
+
+static inline void bdi_wb_writeout_inc(struct inode *inode)
+{
+	struct bdi_writeback_ctx *bdi_wb_ctx = fetch_bdi_writeback_ctx(inode);
+
+	wb_writeout_inc(&bdi_wb_ctx->wb);
+}
+
 /*
  * maximal error of a stat counter.
  */
-- 
2.25.1


