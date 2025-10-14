Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E24CCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:10:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3528E00F8; Tue, 14 Oct 2025 08:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AB778E000D; Tue, 14 Oct 2025 08:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8328E00F8; Tue, 14 Oct 2025 08:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F08F08E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:10:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3A9687782
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:56 +0000 (UTC)
X-FDA: 83996603712.01.7F564AD
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3D68C100009
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=DJ2sBHXm;
	spf=pass (imf14.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/c9uP8WFDKEPNYMrrAFtFep8Nz4Xp2VTqpgzQSUqfpI=;
	b=yE2cWvoR2Nn+Ged/MJDr6FFGPJwV0jtXGMVrA5xpe1qfVRQS6720ooQblKRYdXuO6fJHqa
	2iMlcsuN1tSRow6KJQZRxfEU1UiUbDKLrTpY+XcnqFNP7RwFwieotFcIjua7C62Hp4PTuk
	U9bSFQQxTVMm2rdeiSfu9xWXHCgP1sI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=DJ2sBHXm;
	spf=pass (imf14.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443854; a=rsa-sha256;
	cv=none;
	b=Zcw+4fBTt13AW5RJEIZHftHzpFAQIbhKB6VDbhPbaKJ5uXr3AoscUDWCT/yPBRfJqiO0qh
	aL31X7X9870+kUiHvib8v+dOjiv+j98DkhqgnpaZR975ADvG1peDR87lTUcYaNGtbhoc6a
	Md2fD9QZoSyoIUHVGrjQjjZft3QQJFM=
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251014121051epoutp039bc19d2c2149d8dd7b0c6fc9442ead26~uWlsPrLjj0713307133epoutp03M
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251014121051epoutp039bc19d2c2149d8dd7b0c6fc9442ead26~uWlsPrLjj0713307133epoutp03M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443851;
	bh=/c9uP8WFDKEPNYMrrAFtFep8Nz4Xp2VTqpgzQSUqfpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJ2sBHXm3mNyOFFCZ1PEByN5AJSZVwNvAFJxR60eE6o4rljWlJxgjVs2Cpw0wG6DQ
	 GUNLbMp+BJPKIJ8njBtJpDdz0Qh+WGJJHj5riYa1Kkvx0Oufk/gvQVToxfiYqbwQnX
	 IPQJnE2fhqw3CCLt9Dr5xA5fdvc23OzhcW+m6GJI=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251014121050epcas5p2744521b1cd7ab3333db2e5cacdfc7f33~uWlq7rEWC1888918889epcas5p29;
	Tue, 14 Oct 2025 12:10:50 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.89]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cmCjP14hQz6B9m5; Tue, 14 Oct
	2025 12:10:49 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20251014121048epcas5p4e8665c2e4e12367465aa4d4ec1de84d9~uWlpTljEg1794917949epcas5p4R;
	Tue, 14 Oct 2025 12:10:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121042epsmtip1c3105d716cc6a7bb92c6dfdb8c45772e~uWlj45mPs1256612566epsmtip1k;
	Tue, 14 Oct 2025 12:10:42 +0000 (GMT)
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
Subject: [PATCH v2 07/16] writeback: modify sync related functions to
 iterate over all writeback contexts
Date: Tue, 14 Oct 2025 17:38:36 +0530
Message-Id: <20251014120845.2361-8-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014121048epcas5p4e8665c2e4e12367465aa4d4ec1de84d9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014121048epcas5p4e8665c2e4e12367465aa4d4ec1de84d9
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
	<CGME20251014121048epcas5p4e8665c2e4e12367465aa4d4ec1de84d9@epcas5p4.samsung.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D68C100009
X-Stat-Signature: rb7zbccn8odbx6pyzmy13gctyqzix5uo
X-Rspam-User: 
X-HE-Tag: 1760443853-924799
X-HE-Meta: U2FsdGVkX1/73vgE3MBykeAJ+J1HZE9POAF0MU5dVqE5j51hpLUtF49HprvEepFXjauiZHgH9uEPMN9GTB1g8OdUXfktGZfb9L3hIuGcHW9ORswRMzWgEdkH9UEjUJBSz8F7dKhYcB/MQslAMFXMlcThn7/xDb20V1447JcACbhHKSfg1epvc5B1ePlBwCS08pTo0BAZ2JewpqGvFSHmiuOMcnZMFUtCwS/yKHak9PPSHhCEFJDffiOJdIw8gx8ja1DBN79Y4ow0w0mC8irTb6Xq3hQTqUN38q8chGdxejdHDCKhHdM66OdxxgnOytiO3+AaPAzJrZjmtGLkVrorHZNah07SEcUTfYXBm1FDPJ8QcTpk4I2tXcqkWlFPH3O6Qa7tEBSjxXC/WTNAPF56pqsLMW6DChC5yBtZjMe4pECcaLyGqNFx33VDSaE6k6ISRJTQDlaucvw1dAM+kQlBx44qkYuEPeHuBAXUs5Ewe7KYl0lhAHaWGjcs+weCdqiXc0eRHgVOMeYGo1qQvsLx+UeFuLlEOi0JnrVuU+r9S5wJDOmqsBpj7oGES3VRKyCnLqkOtjVT06OXHM9aIjkVCRIT2pMURjpBfsyCwEV7kDBlIp5ta17a+fFtDfnFXofRbmtnHZH+X5S8TWheTFj6A6bpfp168RuGoBIrh641qoF+hIXWvJN7x8MjQy+e3q0gtXlGlzEMHuZKdOyXmAIzRKwn0wTrEGLWCBPWisj1pkobJI5A3sh/bRkcRP/BSfWiZC5nRZFBNwm8VTbIY6pxug2Wx4eBjYvIoDGc2NHJHQRHdz+2KErvho/kNnPQ7Guu99DiKq6COAkA46oq1d3UqbBR0qGV3OitL1qTeqSm4x8JkJ2aVkAbgq3GnJtQqXcSU9CqFZwaVZX9PBzYRPb7FrgZHCzbZG6NyKuT9748TqyyJd50/W1dJOfkPL0/JlaCm3R0fVPcmraqKkz1V9h
 PINQ43Yw
 E6ZKbRwztGEaF6yOVTp6Z+Dztq2rEZ7ZuAMcSN8lDNpxn1tr9swB9xNUVj7QYOsn7QSE5stXzBHUgXR8lvIG2SbyVB8bOLhG5+DmloabYh3lnUKaJ/GIZPJRCengqOGha+eq5fkJjZwrxFOsoE+emJspGryiXlCXU3oADaKTNcieJ+Tc5w8DA2Gk/J/nKwx7tVOaC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify sync related functions to iterate over all writeback contexts.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/fs-writeback.c | 66 +++++++++++++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 22 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 432f392c8256..7bf1f6c1c0ba 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2753,11 +2753,13 @@ static void wait_sb_inodes(struct super_block *sb)
 	mutex_unlock(&sb->s_sync_lock);
 }
 
-static void __writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr,
-				     enum wb_reason reason, bool skip_if_busy)
+static void __writeback_inodes_sb_nr_ctx(struct super_block *sb,
+					 unsigned long nr,
+					 enum wb_reason reason,
+					 bool skip_if_busy,
+					 struct bdi_writeback_ctx *bdi_wb_ctx)
 {
-	struct backing_dev_info *bdi = sb->s_bdi;
-	DEFINE_WB_COMPLETION(done, bdi->wb_ctx[0]);
+	DEFINE_WB_COMPLETION(done, bdi_wb_ctx);
 	struct wb_writeback_work work = {
 		.sb			= sb,
 		.sync_mode		= WB_SYNC_NONE,
@@ -2767,13 +2769,23 @@ static void __writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr,
 		.reason			= reason,
 	};
 
+	bdi_split_work_to_wbs(sb->s_bdi, bdi_wb_ctx, &work, skip_if_busy);
+	wb_wait_for_completion(&done);
+}
+
+static void __writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr,
+				     enum wb_reason reason, bool skip_if_busy)
+{
+	struct backing_dev_info *bdi = sb->s_bdi;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+
 	if (!bdi_has_dirty_io(bdi) || bdi == &noop_backing_dev_info)
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	bdi_split_work_to_wbs(sb->s_bdi, bdi->wb_ctx[0], &work,
-			      skip_if_busy);
-	wb_wait_for_completion(&done);
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx)
+		__writeback_inodes_sb_nr_ctx(sb, nr, reason, skip_if_busy,
+					     bdi_wb_ctx);
 }
 
 /**
@@ -2826,17 +2838,11 @@ void try_to_writeback_inodes_sb(struct super_block *sb, enum wb_reason reason)
 }
 EXPORT_SYMBOL(try_to_writeback_inodes_sb);
 
-/**
- * sync_inodes_sb	-	sync sb inode pages
- * @sb: the superblock
- *
- * This function writes and waits on any dirty inode belonging to this
- * super_block.
- */
-void sync_inodes_sb(struct super_block *sb)
+static void sync_inodes_bdi_wb_ctx(struct super_block *sb,
+				   struct backing_dev_info *bdi,
+				   struct bdi_writeback_ctx *bdi_wb_ctx)
 {
-	struct backing_dev_info *bdi = sb->s_bdi;
-	DEFINE_WB_COMPLETION(done, bdi->wb_ctx[0]);
+	DEFINE_WB_COMPLETION(done, bdi_wb_ctx);
 	struct wb_writeback_work work = {
 		.sb		= sb,
 		.sync_mode	= WB_SYNC_ALL,
@@ -2847,6 +2853,25 @@ void sync_inodes_sb(struct super_block *sb)
 		.for_sync	= 1,
 	};
 
+	/* protect against inode wb switch, see inode_switch_wbs_work_fn() */
+	bdi_down_write_wb_ctx_switch_rwsem(bdi_wb_ctx);
+	bdi_split_work_to_wbs(bdi, bdi_wb_ctx, &work, false);
+	wb_wait_for_completion(&done);
+	bdi_up_write_wb_ctx_switch_rwsem(bdi_wb_ctx);
+}
+
+/**
+ * sync_inodes_sb	-	sync sb inode pages
+ * @sb: the superblock
+ *
+ * This function writes and waits on any dirty inode belonging to this
+ * super_block.
+ */
+void sync_inodes_sb(struct super_block *sb)
+{
+	struct backing_dev_info *bdi = sb->s_bdi;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+
 	/*
 	 * Can't skip on !bdi_has_dirty() because we should wait for !dirty
 	 * inodes under writeback and I_DIRTY_TIME inodes ignored by
@@ -2856,11 +2881,8 @@ void sync_inodes_sb(struct super_block *sb)
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	/* protect against inode wb switch, see inode_switch_wbs_work_fn() */
-	bdi_down_write_wb_ctx_switch_rwsem(bdi->wb_ctx[0]);
-	bdi_split_work_to_wbs(bdi, bdi->wb_ctx[0], &work, false);
-	wb_wait_for_completion(&done);
-	bdi_up_write_wb_ctx_switch_rwsem(bdi->wb_ctx[0]);
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx)
+		sync_inodes_bdi_wb_ctx(sb, bdi, bdi_wb_ctx);
 
 	wait_sb_inodes(sb);
 }
-- 
2.25.1


