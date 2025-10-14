Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C297CCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95188E00FF; Tue, 14 Oct 2025 08:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6CC88E000D; Tue, 14 Oct 2025 08:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA98D8E00FF; Tue, 14 Oct 2025 08:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B8C0C8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:11:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8787FBBE9B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:33 +0000 (UTC)
X-FDA: 83996605266.09.6692441
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf21.hostedemail.com (Postfix) with ESMTP id E8E791C0002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=aRg1W5LY;
	spf=pass (imf21.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443891; a=rsa-sha256;
	cv=none;
	b=B3xOdhRVFA0tBseLUe71EHlQ3hZSbKMCveVZFUEV7q6/SIWvhseJeiZTiDwnXis2v95qB2
	pxWj/WcVEfV4VsMfTysCADFhZEvUWa9BBOzRAOeh+B6CFifXkXmvboUSV9AtR7uUXOAbv3
	PAeAq7Ma6SPxq7x6kRntMR9M4S+5i44=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=aRg1W5LY;
	spf=pass (imf21.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xfpeIa6BTBN9y5Yua6WUo/kfaK/tK7nGJtau+f6sKc=;
	b=zyYY4v5pXXgZOtSlTDrp51wCS8xy1SP/ui9QM0TMimQeRRmW5J2lhqhtM973YsNRrhNq9a
	KkM/0hMUSVGhQRFXfIHHCwi6GWeDTEODzv1ovO29zjusrJwqsWjLw4K1bXrQaoAPsN9uG6
	V47FL6v9DFxeEHDQdiIYjTaiD9cLeAE=
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251014121128epoutp025d54bd4d648fc00adea5df9000c43b47~uWmO_lpkK2398023980epoutp02p
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251014121128epoutp025d54bd4d648fc00adea5df9000c43b47~uWmO_lpkK2398023980epoutp02p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443888;
	bh=9xfpeIa6BTBN9y5Yua6WUo/kfaK/tK7nGJtau+f6sKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRg1W5LYNkmKJwBmfMDXQwULILoQQMbKD5xpULndN+acw7wKF+EajcSX901J8Jl1U
	 0srsAeNWSVZqvnUIK60lYB6FgmXELyMEl31IcvSy8TC5CMQsTbWbmK9OWPXlR6Tp98
	 Lbh1JDG2eukum2O3hPuZuuu8mcFlIJOS0JXaVQCY=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251014121128epcas5p4967119ea4614d684d93c7583f8d5a134~uWmOYhois3228732287epcas5p4S;
	Tue, 14 Oct 2025 12:11:28 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.90]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cmCk71PPbz2SSKX; Tue, 14 Oct
	2025 12:11:27 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251014121126epcas5p2ff20c9139bdd702c77b9de50e4f259c7~uWmM4HphY2935829358epcas5p21;
	Tue, 14 Oct 2025 12:11:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121122epsmtip167b1288b36b0fc975fc831b21babda9a~uWmJEInWw1256612566epsmtip1C;
	Tue, 14 Oct 2025 12:11:22 +0000 (GMT)
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
Subject: [PATCH v2 14/16] writeback: segregated allocation and free of
 writeback contexts
Date: Tue, 14 Oct 2025 17:38:43 +0530
Message-Id: <20251014120845.2361-15-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014121126epcas5p2ff20c9139bdd702c77b9de50e4f259c7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014121126epcas5p2ff20c9139bdd702c77b9de50e4f259c7
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
	<CGME20251014121126epcas5p2ff20c9139bdd702c77b9de50e4f259c7@epcas5p2.samsung.com>
X-Rspam-User: 
X-Stat-Signature: dot34a13ho1qdpe1u4cy63asjs4orko1
X-Rspamd-Queue-Id: E8E791C0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1760443890-728221
X-HE-Meta: U2FsdGVkX18E6Y2kq4w2l72ntB3uLvoVfIMR9BffkRKwE18TZ0/clBIyp3eSxdq+n/vRvh2JYeOVGIg/L63iFSvKpo7hNjGTrnqdAcl9J9z38yArCpqA9VchvLdAmTnNgChfhijECXFPdF9K+CtffwIthSyhIN2SNYy9PCnIVsIZhrrmreXSwZAYzWTZ8Yw5BvJiNZLgGK39zspPo5UAzx+1E48l2IfjIkHOalcmd94trkX7zyQV8HpNsVvsBJ8vOBZrpnzU0dMguDjHbF2GMK6nKQmGqBr54WV+rE/0g+TK5CdLvWId/JVslnFr/zOX10B9rZgX/PdVQGvv4pfkuTZx0j8lpzK4wWiYuEsm898ycYgSnLE8Isrh8xgjzXbch4nB76RIHGSDCkIo2RUwdffcLFstQCLxCAX3h+qldYYPNvU/4mfwRk9ncmHtcH1nGONBuZA5kmYnewL0oO3R5ljJhwHgjDZjG8K6pgUDpjyK87GbhfnBqKAZ9G7gMoohXMrjNVaoFx5eaZhm1jC8+IBUkYfv5mwkBwf3E+LI49NgqPiUvGosVWJCK9n0Ne/XNnDbOKO91r44XXozWGlNPHEZaty5mHg6aV7pHi5i+leyXU/qoDgKFYa2ikSGuOzn9+Qax9pRJ6GK/MWn2wfaTcqTjPvw4yT7tHBRyg0UAgMcBoHylORUUHn+IrNOpVOe3OGWKj6RMsRzgzfZ0YpstRsw78o0kff2LHCfKcWvDx7dYZ4zhw/r/iSPrsGaXdOS1RfhxB8FQlY8jSBR+WSKhPzaaotrdMmvqZuvCcjkOCswgRKuCATw/IICMLYgXT3E0FGajNRrew8rw4NDfUu8K6c4zf7Q7Z5V6g0VOfnI9vqR6Zfzwc0HQHG3BdxC2jwil4O02i5+AhyOerq2aRaENca4/txhnOWczUe5LcQVRoep0Tu8VHlYTJxe1PRZ3bqdEtwjZMHAOCips4a4maS
 2dKmmZTT
 l2JGJVbtywzZjFNAO1Ohh1EB7ydbgzQ1HIaq2YADnjcFApOFvM71Wpe0SzWqqSteAVgv5Jf6t5HDX+U45hbvgAfenMZTkChyEZGq27Zve771wfT9Oxp8//n1/RS/E48+pfApFKwo0q8rnhQLASgDMk5lhkgYEiKZ8HXwD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The independent functions of alloc and free will be used while changing
the number of writeback contexts.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 mm/backing-dev.c | 72 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 23 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0a3204a3a3a3..2a8f3b683b2d 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1038,8 +1038,46 @@ static void cgwb_remove_from_bdi_list(struct bdi_writeback *wb)
 
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
+static struct bdi_writeback_ctx **wb_ctx_alloc(struct backing_dev_info *bdi,
+					       int num_ctxs)
+{
+	struct bdi_writeback_ctx **wb_ctx;
+
+	wb_ctx = kcalloc(num_ctxs, sizeof(struct bdi_writeback_ctx *),
+			     GFP_KERNEL);
+	if (!wb_ctx)
+		return NULL;
+
+	for (int i = 0; i < num_ctxs; i++) {
+		wb_ctx[i] = (struct bdi_writeback_ctx *)
+			kzalloc(sizeof(struct bdi_writeback_ctx), GFP_KERNEL);
+		if (!wb_ctx[i]) {
+			pr_err("Failed to allocate %d", i);
+			while (--i >= 0)
+				kfree(wb_ctx[i]);
+			kfree(wb_ctx);
+			return NULL;
+		}
+		INIT_LIST_HEAD(&wb_ctx[i]->wb_list);
+		init_waitqueue_head(&wb_ctx[i]->wb_waitq);
+	}
+	return wb_ctx;
+}
+
+static void wb_ctx_free(struct backing_dev_info *bdi)
+{
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		kfree(bdi_wb_ctx);
+	}
+	kfree(bdi->wb_ctx);
+}
+
 int bdi_init(struct backing_dev_info *bdi)
 {
+	int ret;
+
 	bdi->dev = NULL;
 
 	kref_init(&bdi->refcnt);
@@ -1047,48 +1085,36 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->max_ratio = 100 * BDI_RATIO_SCALE;
 	bdi->max_prop_frac = FPROP_FRAC_BASE;
 
+	INIT_LIST_HEAD(&bdi->bdi_list);
+
 	/*
 	 * User can configure nr_wb_ctx using the newly introduced sysfs knob.
 	 * echo N > /sys/class/bdi/<maj>:<min>/nwritebacks
 	 * Filesystem can also increase same during mount.
 	 */
 	bdi->nr_wb_ctx = 1;
-	bdi->wb_ctx = kcalloc(bdi->nr_wb_ctx,
-				  sizeof(struct bdi_writeback_ctx *),
-				  GFP_KERNEL);
-	INIT_LIST_HEAD(&bdi->bdi_list);
-	for (int i = 0; i < bdi->nr_wb_ctx; i++) {
-		bdi->wb_ctx[i] = (struct bdi_writeback_ctx *)
-			 kzalloc(sizeof(struct bdi_writeback_ctx), GFP_KERNEL);
-		if (!bdi->wb_ctx[i]) {
-			pr_err("Failed to allocate %d", i);
-			while (--i >= 0)
-				kfree(bdi->wb_ctx[i]);
-			kfree(bdi->wb_ctx);
-			return -ENOMEM;
-		}
-		INIT_LIST_HEAD(&bdi->wb_ctx[i]->wb_list);
-		init_waitqueue_head(&bdi->wb_ctx[i]->wb_waitq);
-	}
+
+	bdi->wb_ctx = wb_ctx_alloc(bdi, bdi->nr_wb_ctx);
+	if (!bdi->wb_ctx)
+		return -ENOMEM;
+
 	bdi->last_bdp_sleep = jiffies;
 
-	return cgwb_bdi_init(bdi);
+	ret = cgwb_bdi_init(bdi);
+	if (ret)
+		wb_ctx_free(bdi);
+	return ret;
 }
 
 struct backing_dev_info *bdi_alloc(int node_id)
 {
 	struct backing_dev_info *bdi;
-	struct bdi_writeback_ctx *bdi_wb_ctx;
 
 	bdi = kzalloc_node(sizeof(*bdi), GFP_KERNEL, node_id);
 	if (!bdi)
 		return NULL;
 
 	if (bdi_init(bdi)) {
-		for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
-			kfree(bdi_wb_ctx);
-		}
-		kfree(bdi->wb_ctx);
 		kfree(bdi);
 		return NULL;
 	}
-- 
2.25.1


