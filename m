Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B59EECCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D4A28E00FA; Tue, 14 Oct 2025 08:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ABEF8E000D; Tue, 14 Oct 2025 08:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8EC8E00FA; Tue, 14 Oct 2025 08:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EEE848E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:11:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5FEF11B070
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:09 +0000 (UTC)
X-FDA: 83996604258.16.2FE3D93
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3A4E718000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=VWzGZvfi;
	spf=pass (imf24.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9L9Dd+P57Nr9ie5r9Dy2BGUr0ErT9/3lAp5Du2+fgsc=;
	b=nLaxlCjx4NgEN4Y47KulE+V683edfTB02gF346+g/42Nqj3YJ7wVW90jJPBVZXSNl+oabG
	8FI0mjcRjwbgAiWsfsxhkPcNV0WoeM3vHpbUBEOyuIvpIQFfyX16i4o/Ds1lreOrKGttEL
	vnLAqtT0IVQRa2MTLpOSquoqAzQ4Wqo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443867; a=rsa-sha256;
	cv=none;
	b=tXtYOUOfrKefD6uoiLe6qhtmM8wICF9mYRZwbP0uDEtrlrb6Z4UKcoOVxQn55E+P/KBNpI
	FIaEr0hVuIFzJwt48ZLV+oo3UbbjFlAi6G3aPOX2H7f/35elTkATHP6LU//6BoEgdPCeCm
	G9hNIh9h/CNu5fOWkcr/ta00WRZbTCY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=VWzGZvfi;
	spf=pass (imf24.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251014121104epoutp028eefc62ded2c1ccefb935f2ec1c1f256~uWl4jwJlz2397723977epoutp02e
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251014121104epoutp028eefc62ded2c1ccefb935f2ec1c1f256~uWl4jwJlz2397723977epoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443864;
	bh=9L9Dd+P57Nr9ie5r9Dy2BGUr0ErT9/3lAp5Du2+fgsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWzGZvfiHiU5Yz8K8MUBF/sznhrM9+sNgjg53fdyEgQwvRJICwiS7dfGfPgYSvCSE
	 Tymm6YJMjuSzD80p3C5TV0qzpTpD3b/5G+fop71hg8uZbZo2J6z2RBVvyYgoY6Eq7V
	 8qbcsIs6NS+JZaKd8csOvwhgE2lkkHX724BTgY2o=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251014121104epcas5p2bc15fe91af3f477ce59f23de07a762e7~uWl4GCzCQ2441424414epcas5p2z;
	Tue, 14 Oct 2025 12:11:04 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.93]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cmCjg1c1Qz3hhT7; Tue, 14 Oct
	2025 12:11:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251014121102epcas5p3280cd3e6bf16a2fb6a7fe483751f07a7~uWl2mt8mp0753907539epcas5p3l;
	Tue, 14 Oct 2025 12:11:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121056epsmtip121363f1d7a311e444423e431a609c5f4~uWlxNY78_1239712397epsmtip1d;
	Tue, 14 Oct 2025 12:10:56 +0000 (GMT)
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
Subject: [PATCH v2 09/16] f2fs: add support in f2fs to handle multiple
 writeback contexts
Date: Tue, 14 Oct 2025 17:38:38 +0530
Message-Id: <20251014120845.2361-10-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014121102epcas5p3280cd3e6bf16a2fb6a7fe483751f07a7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014121102epcas5p3280cd3e6bf16a2fb6a7fe483751f07a7
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
	<CGME20251014121102epcas5p3280cd3e6bf16a2fb6a7fe483751f07a7@epcas5p3.samsung.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: weimuxowttyt5hedp8g1bazh933eofyh
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A4E718000A
X-HE-Tag: 1760443866-178617
X-HE-Meta: U2FsdGVkX1+6BkSDreoK8VKDZIop4T2FKmGzoVI+MSpxFLRJnfffn6GALNflreMRcIIjxFGgFqVUoDqF8GnicxzJl6lF5bobIyD2pd3LyqBpVzhxkEb71AEXdV4l68+qiyd0AQ6PMoWv0X1RjIeVBbn8X4TOBDCEarCRHZhDoJZKH767FDxLpwrVQou+lOK+hvrC17FY8tuLI5MH5Ewhpkqtw0wQTK4RDujhMaoMBcTVhnsxyogeCGrfVnJETbZkJhcqR7PU8J/0soGGkvFPg/NSpoXlIMv+PsWJJeKh7/XtXA6PX3zZLfYDfISJRRPVYnTTEq4wgaLLGWjry0pC7/BonDJ/0cPL8eCUgUPy0+UgBMHCfURz0qWNTq12V6WfwyrfB+PTFpA9res5XWJTrijozVxGGeRxQ4WEZ5Z75ajNQMzX9UJnuO1ubtrw/g3zDKBEi5mX5bZv61JcJJ0waSkPy/wRrOfHwlsUomDwXsuekgcuyikLayOCp5WfLDO76wY/21Vlu11cCyjH2b531gXMPW9lKlL00JYkasOaITwsSLSiBs2tdw/BpCCBPWhkUGWe1UaRZnh0tWA/Q79LpJvIQMJT6ubiALsEgcomlN9jqAMePYCRNDs3EE4+pvcxsd2b47Y1ZEMw9CE3NSH+8d14+BgVNwhTusRBZRPTVl+vgs3CebZ5Ca68qnAQbXSXrWnCf6c1raESm68Gou0nof1f9xSsp/IDwaVa+3uhxCcyvvRzOkSkMuNblZorAtRSFCu8mjscL7HVE7eSJJhQQO4U7iajNUAtTlpP5S5npUuxYLxDMUohQhReoyKSAwYSLXqroQ/yRwfbbdNL/n0ZBxB3Bg/peo00c8Hq/432kyH4BgokuSpjftUDIXr6OTLXQfE56ABSPmd4mEUCPyxvBGmw2ztZcN74lNlIg05fIshh/2zBEg9Zpi/TCYrSozV/jd8c/W2RDy5JRv9PD9D
 2KMrciwt
 nb4qc19szySxQM1hU+0KO06mmdST4kyhdIk2m9K0rN+Q3FqduQOevKKJ0rqtOuoP9r3p6mn+3IqyS1x2yaygLfJ8YPTh3ww5XqjN9TRF0/N3i6mRTAeBjmZ8MBFjYQ5dzZv+1Mi5Yt7s8sY6RPMb87jIbBSUcvaUWNtaoYCKI2En7dkjI10td/aCK12DBcbraA9L3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support to handle multiple writeback contexts and check for
dirty_exceeded across all the writeback contexts.

Made a new helper for same.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/f2fs/node.c              |  4 ++--
 fs/f2fs/segment.h           |  2 +-
 include/linux/backing-dev.h | 18 +++++++++++++++---
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 1693da9417f9..cd75aa98a1ca 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -73,7 +73,7 @@ bool f2fs_available_free_memory(struct f2fs_sb_info *sbi, int type)
 		if (excess_cached_nats(sbi))
 			res = false;
 	} else if (type == DIRTY_DENTS) {
-		if (sbi->sb->s_bdi->wb_ctx[0]->wb.dirty_exceeded)
+		if (bdi_wb_dirty_limit_exceeded(sbi->sb->s_bdi))
 			return false;
 		mem_size = get_pages(sbi, F2FS_DIRTY_DENTS);
 		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 1);
@@ -114,7 +114,7 @@ bool f2fs_available_free_memory(struct f2fs_sb_info *sbi, int type)
 		res = false;
 #endif
 	} else {
-		if (!sbi->sb->s_bdi->wb_ctx[0]->wb.dirty_exceeded)
+		if (!bdi_wb_dirty_limit_exceeded(sbi->sb->s_bdi))
 			return true;
 	}
 	return res;
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 7e5b7b1a5d2b..8487bd5d4394 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -993,7 +993,7 @@ static inline bool sec_usage_check(struct f2fs_sb_info *sbi, unsigned int secno)
  */
 static inline int nr_pages_to_skip(struct f2fs_sb_info *sbi, int type)
 {
-	if (sbi->sb->s_bdi->wb_ctx[0]->wb.dirty_exceeded)
+	if (bdi_wb_dirty_limit_exceeded(sbi->sb->s_bdi))
 		return 0;
 
 	if (type == DATA)
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 59bbb69d300c..bb35f8fa4973 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -51,6 +51,21 @@ static inline bool wb_has_dirty_io(struct bdi_writeback *wb)
 	return test_bit(WB_has_dirty_io, &wb->state);
 }
 
+#define for_each_bdi_wb_ctx(bdi, wbctx) \
+	for (int __i = 0; __i < (bdi)->nr_wb_ctx \
+		&& ((wbctx) = (bdi)->wb_ctx[__i]) != NULL; __i++)
+
+static inline bool bdi_wb_dirty_limit_exceeded(struct backing_dev_info *bdi)
+{
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		if (bdi_wb_ctx->wb.dirty_exceeded)
+			return true;
+	}
+	return false;
+}
+
 static inline bool bdi_has_dirty_io(struct backing_dev_info *bdi)
 {
 	/*
@@ -149,9 +164,6 @@ static inline bool mapping_can_writeback(struct address_space *mapping)
 }
 
 #define DEFAULT_WB_CTX 0
-#define for_each_bdi_wb_ctx(bdi, wbctx) \
-	for (int __i = 0; __i < (bdi)->nr_wb_ctx \
-		&& ((wbctx) = (bdi)->wb_ctx[__i]) != NULL; __i++)
 
 static inline struct bdi_writeback_ctx *
 fetch_bdi_writeback_ctx(struct inode *inode)
-- 
2.25.1


