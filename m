Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBFB3CCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46AE98E00F3; Tue, 14 Oct 2025 08:10:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441F88E000D; Tue, 14 Oct 2025 08:10:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 358458E00F3; Tue, 14 Oct 2025 08:10:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 264AC8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:10:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB0B1BBD83
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:28 +0000 (UTC)
X-FDA: 83996602536.03.3E9088B
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0D72C140002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=l345k14G;
	spf=pass (imf09.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eHJ+QzB7bCnBbwX1a/ip7LbHhQnCIhG/2G0p09gVgzE=;
	b=rOzpmpSCWtr5xUh9BFG2eYGcEL4z+lk74Wo3UC0zyAaPsk6mYgGeiucQsNw9zjs9oXho3R
	3RDMIjvASRS2VRXgoSK1/MaEH5oTHbkHTEviTMGPGPc2dAfetm6uxAA1iiXbKOn7oekjx0
	ozS34+3ouGIBE91nz0gQMtZCNIE61hs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=l345k14G;
	spf=pass (imf09.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443826; a=rsa-sha256;
	cv=none;
	b=aVjyD+Z75sWsyEykKFRls0jLfv+cTbM5y08S5x8nVkga5dw8P7M9d4cKRF8HqiMlFEh7XO
	pR/PSuuEYoOq2d8sEOi8X99rhIVMdmhpSA20nnMEztGJM5PDmD8MBYwMVrZOdUn+K1AiLM
	FLhHVhKaCpY4fNPgeUwrUaeG8baTe80=
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251014121023epoutp039c173d3ec3c32b6b459a0b2692d2f896~uWlR8ZeuX0652206522epoutp03S
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251014121023epoutp039c173d3ec3c32b6b459a0b2692d2f896~uWlR8ZeuX0652206522epoutp03S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443823;
	bh=eHJ+QzB7bCnBbwX1a/ip7LbHhQnCIhG/2G0p09gVgzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l345k14G559CrmfftgGwIQZN6qFnhJbE7WwE9ntPZzWwRWY4QmDA6cicbz9z00rDg
	 Neh0PIEXc0Mk9inH40jgB9AIlwJ48EUnI30qGlJTiMr+Nc5LkA97O2+kPiF3sADRHG
	 x8x3EULaNt14QJy3S2H9MFB52LDExUUIN6Qo5p3U=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20251014121022epcas5p18ca54217626ae6f7cf1a4881989cd40d~uWlRJ98ZF0673806738epcas5p1P;
	Tue, 14 Oct 2025 12:10:22 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.92]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cmChs371hz3hhT3; Tue, 14 Oct
	2025 12:10:21 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251014121020epcas5p36ca8a0d6d74f7b81996bb367329feb4a~uWlPfM4OW0426604266epcas5p3o;
	Tue, 14 Oct 2025 12:10:20 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121014epsmtip1dd1dae420667f5e45f691b22f2193ab7~uWlJvBsTP1256112561epsmtip1j;
	Tue, 14 Oct 2025 12:10:14 +0000 (GMT)
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
Subject: [PATCH v2 02/16] writeback: add support to initialize and free
 multiple writeback ctxs
Date: Tue, 14 Oct 2025 17:38:31 +0530
Message-Id: <20251014120845.2361-3-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014121020epcas5p36ca8a0d6d74f7b81996bb367329feb4a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014121020epcas5p36ca8a0d6d74f7b81996bb367329feb4a
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
	<CGME20251014121020epcas5p36ca8a0d6d74f7b81996bb367329feb4a@epcas5p3.samsung.com>
X-Rspamd-Queue-Id: 0D72C140002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hdko5swudgh15hc375izbuybbyssp8yo
X-HE-Tag: 1760443825-646761
X-HE-Meta: U2FsdGVkX1+JXZu0WIlME0KjnJgABSL75A5ZVyPoScXNUK12qEf+W/n4ybLYCMLuv9jInSUepaRqyL98nAh/ZEt4A71luzSoudV4Gne0GKOf3GlmuK3g/WPoxwSlqZ7VF0ECTgUc/HfphrDNC5bBclcVXhvtm10nxUdJEJZHqL9Ym1CaipCxhbN0hepbDenDvdnvOirr5vPp0VUqLws5j/HtH6iqKdZ5XN8TWqFW8H3iBfHGcGs9DoUVIxNZ4fAaImcHV2gfFcbT/MH8zpFspGr6ruS1djM1FUXoGScnw/iII5HTLb7bqPhMGpFGzadb6Wap5HfGTHcvtE2BmLdR7Ay7r2sYloJ2JdmajGCJwyRzCmCheq0+FxMt5lQ/lxJYH3MVJVhDv7EUsjaeEoMOrwLvSCUtuvARVI7bWHxSA0PQheP/woWSAPFUcJGNuoqB/XBmrHqkrUdeCBctxHegrwm1AczEq/kZXKIDOMwPKj5Aoar3thpB6ORBKM1Guf5CTgJpRcv2O4osldDso32GDKKhXfiqS4W/lP0OBgIRuWqfbO9hH+cD0fc1GBnGBcM1gF3ih6Aiif04xitTuRNWuecSO/Xkty7/GGAeq2kih9ugMOl3mRQWixd7vV1yN488yew60bx72ZCE3EFc/pDQeknYiWwOPHElnfUHkcrF2FkC5C136zpK1HamdbMEeHndQu5W6pNZWJZ5sHp7q5H3C0DF4M8KG97gOnO9177TQptDsEnQnhPUgZNl9w+vwuYl5shI4MXPkwukWvbtQNQCTgmPW3Vy+C67W/MfOih7JdJVtqNqpt0n9peOJgvrjxC93frxM5KG0k1TkgqG5kC+bzWASTozND6xxTUp5ME7lPYabazEj6Y6XkJFOHvP4sAY6ymjri8F4U68mH+mjNnFlFq8hGjGet5FrdgNjh8FRVVL+znQpfvmgm4N/M3Oo5BSvBgznzzt7jtXKTJiqUY
 HrQ31jzu
 +D0K2/W2CfUqwAyVR2c0EHnzS3uRWbI450hjM7CSPjGMBNAAE9h1FQgSC0ILQRnHZVTM9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new macro for_each_bdi_wb_ctx to iterate over multiple
writeback ctxs. Added logic for allocation, init, free, registration
and unregistration of multiple writeback contexts within a bdi.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 include/linux/backing-dev.h |  4 ++
 mm/backing-dev.c            | 81 +++++++++++++++++++++++++++----------
 2 files changed, 63 insertions(+), 22 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 92674543ac8a..951ab5497500 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -148,6 +148,10 @@ static inline bool mapping_can_writeback(struct address_space *mapping)
 	return inode_to_bdi(mapping->host)->capabilities & BDI_CAP_WRITEBACK;
 }
 
+#define for_each_bdi_wb_ctx(bdi, wbctx) \
+	for (int __i = 0; __i < (bdi)->nr_wb_ctx \
+		&& ((wbctx) = (bdi)->wb_ctx[__i]) != NULL; __i++)
+
 static inline struct bdi_writeback_ctx *
 fetch_bdi_writeback_ctx(struct inode *inode)
 {
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 8b7125349f6c..47196d326e16 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -835,17 +835,20 @@ struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 
 static int cgwb_bdi_init(struct backing_dev_info *bdi)
 {
-	int ret;
-	struct bdi_writeback_ctx *bdi_wb_ctx = bdi->wb_ctx[0];
+	int ret = 0;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 
-	INIT_RADIX_TREE(&bdi_wb_ctx->cgwb_tree, GFP_ATOMIC);
-	mutex_init(&bdi->cgwb_release_mutex);
-	init_rwsem(&bdi_wb_ctx->wb_switch_rwsem);
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		INIT_RADIX_TREE(&bdi_wb_ctx->cgwb_tree, GFP_ATOMIC);
+		mutex_init(&bdi->cgwb_release_mutex);
+		init_rwsem(&bdi_wb_ctx->wb_switch_rwsem);
 
-	ret = wb_init(&bdi_wb_ctx->wb, bdi, GFP_KERNEL);
-	if (!ret) {
-		bdi_wb_ctx->wb.memcg_css = &root_mem_cgroup->css;
-		bdi_wb_ctx->wb.blkcg_css = blkcg_root_css;
+		ret = wb_init(&bdi_wb_ctx->wb, bdi, GFP_KERNEL);
+		if (!ret) {
+			bdi_wb_ctx->wb.memcg_css = &root_mem_cgroup->css;
+			bdi_wb_ctx->wb.blkcg_css = blkcg_root_css;
+		} else
+			return ret;
 	}
 	return ret;
 }
@@ -992,7 +995,16 @@ subsys_initcall(cgwb_init);
 
 static int cgwb_bdi_init(struct backing_dev_info *bdi)
 {
-	return wb_init(&bdi->wb_ctx[0]->wb, bdi, GFP_KERNEL);
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		int ret;
+
+		ret = wb_init(&bdi_wb_ctx->wb, bdi, GFP_KERNEL);
+		if (ret)
+			return ret;
+	}
+	return 0;
 }
 
 static void cgwb_bdi_unregister(struct backing_dev_info *bdi,
@@ -1026,10 +1038,19 @@ int bdi_init(struct backing_dev_info *bdi)
 				  sizeof(struct bdi_writeback_ctx *),
 				  GFP_KERNEL);
 	INIT_LIST_HEAD(&bdi->bdi_list);
-	bdi->wb_ctx[0] = (struct bdi_writeback_ctx *)
-			kzalloc(sizeof(struct bdi_writeback_ctx), GFP_KERNEL);
-	INIT_LIST_HEAD(&bdi->wb_ctx[0]->wb_list);
-	init_waitqueue_head(&bdi->wb_ctx[0]->wb_waitq);
+	for (int i = 0; i < bdi->nr_wb_ctx; i++) {
+		bdi->wb_ctx[i] = (struct bdi_writeback_ctx *)
+			 kzalloc(sizeof(struct bdi_writeback_ctx), GFP_KERNEL);
+		if (!bdi->wb_ctx[i]) {
+			pr_err("Failed to allocate %d", i);
+			while (--i >= 0)
+				kfree(bdi->wb_ctx[i]);
+			kfree(bdi->wb_ctx);
+			return -ENOMEM;
+		}
+		INIT_LIST_HEAD(&bdi->wb_ctx[i]->wb_list);
+		init_waitqueue_head(&bdi->wb_ctx[i]->wb_waitq);
+	}
 	bdi->last_bdp_sleep = jiffies;
 
 	return cgwb_bdi_init(bdi);
@@ -1038,13 +1059,16 @@ int bdi_init(struct backing_dev_info *bdi)
 struct backing_dev_info *bdi_alloc(int node_id)
 {
 	struct backing_dev_info *bdi;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 
 	bdi = kzalloc_node(sizeof(*bdi), GFP_KERNEL, node_id);
 	if (!bdi)
 		return NULL;
 
 	if (bdi_init(bdi)) {
-		kfree(bdi->wb_ctx[0]);
+		for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+			kfree(bdi_wb_ctx);
+		}
 		kfree(bdi->wb_ctx);
 		kfree(bdi);
 		return NULL;
@@ -1109,6 +1133,7 @@ int bdi_register_va(struct backing_dev_info *bdi, const char *fmt, va_list args)
 {
 	struct device *dev;
 	struct rb_node *parent, **p;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 
 	if (bdi->dev)	/* The driver needs to use separate queues per device */
 		return 0;
@@ -1118,8 +1143,11 @@ int bdi_register_va(struct backing_dev_info *bdi, const char *fmt, va_list args)
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
 
-	cgwb_bdi_register(bdi, bdi->wb_ctx[0]);
-	set_bit(WB_registered, &bdi->wb_ctx[0]->wb.state);
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		cgwb_bdi_register(bdi, bdi_wb_ctx);
+		set_bit(WB_registered, &bdi_wb_ctx->wb.state);
+	}
+
 	bdi->dev = dev;
 
 	bdi_debug_register(bdi, dev_name(dev));
@@ -1174,12 +1202,17 @@ static void bdi_remove_from_list(struct backing_dev_info *bdi)
 
 void bdi_unregister(struct backing_dev_info *bdi)
 {
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+
 	timer_delete_sync(&bdi->laptop_mode_wb_timer);
 
 	/* make sure nobody finds us on the bdi_list anymore */
 	bdi_remove_from_list(bdi);
-	wb_shutdown(&bdi->wb_ctx[0]->wb);
-	cgwb_bdi_unregister(bdi, bdi->wb_ctx[0]);
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		wb_shutdown(&bdi_wb_ctx->wb);
+		cgwb_bdi_unregister(bdi, bdi_wb_ctx);
+	}
 
 	/*
 	 * If this BDI's min ratio has been set, use bdi_set_min_ratio() to
@@ -1205,11 +1238,15 @@ static void release_bdi(struct kref *ref)
 {
 	struct backing_dev_info *bdi =
 			container_of(ref, struct backing_dev_info, refcnt);
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 
 	WARN_ON_ONCE(bdi->dev);
-	WARN_ON_ONCE(test_bit(WB_registered, &bdi->wb_ctx[0]->wb.state));
-	wb_exit(&bdi->wb_ctx[0]->wb);
-	kfree(bdi->wb_ctx[0]);
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		WARN_ON_ONCE(test_bit(WB_registered, &bdi_wb_ctx->wb.state));
+		wb_exit(&bdi_wb_ctx->wb);
+		kfree(bdi_wb_ctx);
+	}
 	kfree(bdi->wb_ctx);
 	kfree(bdi);
 }
-- 
2.25.1


