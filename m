Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4630DCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E98E8E00F5; Tue, 14 Oct 2025 08:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999558E000D; Tue, 14 Oct 2025 08:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888618E00F5; Tue, 14 Oct 2025 08:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7192D8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:10:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A78B140913
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:39 +0000 (UTC)
X-FDA: 83996602998.07.9618190
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8F100160014
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=W05Y14re;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf08.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rKJH8bwqA59RYOc+B5sM49aSVlRkW4PvNX4CEB13cCo=;
	b=OXA0XC/t8do4eXeKdIUHZlFXrw3L3kTbGE8M7WwnOBjCvgqbRekr2nsdJLnoT9JnMJTp/k
	kw4z/vaVyAYoSMIDQnibWTCpMq7kWBANlBjStXgQkgyxOij4QQ+t+13U1/NzFsO0Hq/zss
	OXzw0rsl+BPYfklU2q+BdH41pkTWoFY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443837; a=rsa-sha256;
	cv=none;
	b=CtnAncw1PRNt7Nu8NS4259SEwgd6u8bVAUsG4TsOiGdXG+4llyAGLMjLXSaISiItXMVAIx
	KtazNADO9TGbIGRdak0Bj2NCLeFYZJwxDqCaI6yhJHbczb21XfHBUCnZvWo5nO9aIEJ4rX
	584Pmjnbjha0xlFcsTuSj7mPuSl6RBc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=W05Y14re;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf08.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251014121034epoutp0291905bdfb68237916c779a59ea17dbf5~uWlb9Siot2397723977epoutp02N
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251014121034epoutp0291905bdfb68237916c779a59ea17dbf5~uWlb9Siot2397723977epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443834;
	bh=rKJH8bwqA59RYOc+B5sM49aSVlRkW4PvNX4CEB13cCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W05Y14rePZ8RFgXUzU42idAHG2tHyqnxyTHEGnyOuTLnJCR/PBRpmpxJAYeWIdafb
	 wDeLhW0PSZ/QiE4Za8cKFfPoUyj6W/ieVWNi+AasoDHJtSKXrhQXMrBrzXsJ31gnd4
	 J5rZ2dJ/Xi23b+2H3bT+d4wVB81A2+1H8pW1F1c4=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20251014121033epcas5p1d8391adbcd15cb4c8848b8cb66b6cfeb~uWlbWfGcV0673806738epcas5p1Z;
	Tue, 14 Oct 2025 12:10:33 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.90]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cmCj42h5Qz6B9mF; Tue, 14 Oct
	2025 12:10:32 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251014121031epcas5p37b0c4e23a7ad2d623ba776498f795fb0~uWlZtq5xY0650006500epcas5p33;
	Tue, 14 Oct 2025 12:10:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121026epsmtip1b892e5a7d3af784888e5b4d33982dd8f~uWlVOMbrO1256112561epsmtip1n;
	Tue, 14 Oct 2025 12:10:26 +0000 (GMT)
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
Subject: [PATCH v2 04/16] writeback: affine inode to a writeback ctx within
 a bdi
Date: Tue, 14 Oct 2025 17:38:33 +0530
Message-Id: <20251014120845.2361-5-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014121031epcas5p37b0c4e23a7ad2d623ba776498f795fb0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014121031epcas5p37b0c4e23a7ad2d623ba776498f795fb0
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
	<CGME20251014121031epcas5p37b0c4e23a7ad2d623ba776498f795fb0@epcas5p3.samsung.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F100160014
X-Rspamd-Server: rspam02
X-Stat-Signature: yr15phem78sw9qq9nxqbwiboyw6pkim3
X-HE-Tag: 1760443836-848628
X-HE-Meta: U2FsdGVkX1+20T2RjAVu4lmdJyYWUk9A2X1rjx2QO1gQsi/Y2n5RcA2qHWfjMBmMJSoKMGcvy6Uis6IucKX6ALaUFIpY+rYVw8VhmjitqMz7XKWCJwJk3usoJjytTeD4Rl0KfTni+N3nZ2EL63cqZCG9OMYKwLargCTO7zEMn2ubGPMhH8l9/mFcqVmripYdn19s4VEwvi+lB2O/wKdkF5Og05TmnPWpJ/Xxwfhsz2isgzWLdDEei0uW8e5iI9OruJM1m88cp4KitngDc3NdfhCwTTeOZMYHugjXQWGGMKKTW7rV79xFZOHorNWSe4Z6RnSuLqX0H6Y29iOYW7WzdP7BqeTxNRHlzp+yK4crC8Lceh7suhVrAZUFtFeBJulG120LraEPPbbuTFHOjWg2iA23utGstTV+a9rJ7TYWUwY/aAu234pi4TIcboeYsI7qbhMzUKwEcT9UuT7z6yV0nT1tpeF4xSwrse83JbQwCGOF0csS8bsQrHLUePlm1T8eEW6aJr11k1wYyNJrK8yKqp+JuMqf3zKE29GQNjSYx6e85ZUZ4gjsoAPN9FND2pzBiCcm05nt2YrW0WZN7xSXLbidDGDflXL/dtlOLyyLZ22aRInz7XZgBu1dfhPdxgrQt9p4K7ozaBHwKN+TU/xfNAzhGygoQAmAfgA+b7Y9i44cZZyn/LEBwRDmbtoRkzc9FGdD8ZJpvOnCeYd8/3Si+sRnWCA1+f5X1BuGVDUMGRLNbSyrny1mHzERbJnYxZXJPxZizamGBicp4Ci6/5FnwO7UMKxkL04oHw9FZn4xUHu6i7434xPvF6O7Gjsahymv1O4FooY10bbZwW/I5xN2SXoqB+mdExuVNNkFzeewN3S/Kxv45VrCNrLtSuFw8D4Nh0eiqxClPqzrOad7uug9qH/pgHeD1R1rCF4MrQUJupD3X02GHh85mqw2VKaOrKTxK8j+6497nLKDmGBhBaZ
 J1C49KeN
 T3vImTxDM6QVSFosoEaQBs1HNJtSc6ENDG0xjbOnypNSE0Tgl/KZ3HeQ5y9lUog3ylQSCRay+9/8jde8VbV2KfN5WnqcslWhl7Pi2a+MxLU5mseT8sOTEgD+x3lhxDW+GBWBQaaC4iM7Rgtolf0F3UnyGkTkf4/ch0MDnVMEGRVoWdAqlXluRtthuwQ4qPxQWVkRG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Affine inode to a writeback context. This helps in minimizing the
filesytem fragmentation due to inode being processed by different
threads.

To support parallel writeback, wire up a new superblock operation
get_inode_wb_ctx(). Filesystems can override this callback and select
desired writeback context for a inode. FS can use the wb context based
on its geometry and also use 64 bit inode numbers.

If a filesystem doesn't implement this callback, it defaults to
DEFALT_WB_CTX = 0, maintaining its original behavior.

An example implementation for XFS is provided, where XFS selects the
writeback context based on its Allocation Group number.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
---
 fs/fs-writeback.c           |  3 ++-
 fs/xfs/xfs_super.c          | 13 +++++++++++++
 include/linux/backing-dev.h |  5 ++++-
 include/linux/fs.h          |  1 +
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 0715a7617391..56c048e22f72 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -265,7 +265,8 @@ void __inode_attach_wb(struct inode *inode, struct folio *folio)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct bdi_writeback *wb = NULL;
-	struct bdi_writeback_ctx *bdi_writeback_ctx = bdi->wb_ctx[0];
+	struct bdi_writeback_ctx *bdi_writeback_ctx =
+						fetch_bdi_writeback_ctx(inode);
 
 	if (inode_cgwb_enabled(inode)) {
 		struct cgroup_subsys_state *memcg_css;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bb0a82635a77..b3ec9141d902 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -53,6 +53,7 @@
 #include <linux/magic.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
+#include <linux/backing-dev.h>
 
 static const struct super_operations xfs_super_operations;
 
@@ -1294,6 +1295,17 @@ xfs_fs_show_stats(
 	return 0;
 }
 
+static struct bdi_writeback_ctx *
+xfs_get_inode_wb_ctx(
+	struct inode		*inode)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	struct backing_dev_info *bdi = inode_to_bdi(inode);
+	xfs_agino_t agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+
+	return bdi->wb_ctx[agno % bdi->nr_wb_ctx];
+}
+
 static const struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
@@ -1310,6 +1322,7 @@ static const struct super_operations xfs_super_operations = {
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 	.shutdown		= xfs_fs_shutdown,
 	.show_stats		= xfs_fs_show_stats,
+	.get_inode_wb_ctx       = xfs_get_inode_wb_ctx,
 };
 
 static int
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 951ab5497500..59bbb69d300c 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -148,6 +148,7 @@ static inline bool mapping_can_writeback(struct address_space *mapping)
 	return inode_to_bdi(mapping->host)->capabilities & BDI_CAP_WRITEBACK;
 }
 
+#define DEFAULT_WB_CTX 0
 #define for_each_bdi_wb_ctx(bdi, wbctx) \
 	for (int __i = 0; __i < (bdi)->nr_wb_ctx \
 		&& ((wbctx) = (bdi)->wb_ctx[__i]) != NULL; __i++)
@@ -157,7 +158,9 @@ fetch_bdi_writeback_ctx(struct inode *inode)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 
-	return bdi->wb_ctx[0];
+	if (inode->i_sb->s_op->get_inode_wb_ctx)
+		return inode->i_sb->s_op->get_inode_wb_ctx(inode);
+	return bdi->wb_ctx[DEFAULT_WB_CTX];
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 754fec84f350..5199b0d49fa5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2379,6 +2379,7 @@ struct super_operations {
 	 */
 	int (*remove_bdev)(struct super_block *sb, struct block_device *bdev);
 	void (*shutdown)(struct super_block *sb);
+	struct bdi_writeback_ctx *(*get_inode_wb_ctx)(struct inode *inode);
 };
 
 /*
-- 
2.25.1


