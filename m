Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE6B9CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57DD08E00FC; Tue, 14 Oct 2025 08:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52E5C8E000D; Tue, 14 Oct 2025 08:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46BEC8E00FC; Tue, 14 Oct 2025 08:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 35BA38E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:11:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0D2D13BEB3
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:19 +0000 (UTC)
X-FDA: 83996604678.24.8A44F56
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4F24B14000E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=oVP9IXio;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf26.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443877; a=rsa-sha256;
	cv=none;
	b=pqmECng6SOkzy2NHMZP8Q1kilyJe+edPcul2WK/LJ49BIAypFglDO4Y9XPcFY52wNPurBl
	v20Da4YjmlR1oas4C7rg44GL8Y2QY3HrxLuYf6D4LhKJPz+UZrkLHkSsXkabyMCQyy2NTn
	LW8z6E3PTarHARDR8cF5Ghl0igmXwmM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=oVP9IXio;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf26.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PXGKebblkuYyVq32XepqRXoghfCKJGEOOFxZca7FgOI=;
	b=bwItvw3V++4Q2jYxvyQfXAHK/+kKVoHZEleIEJmaDvrM9qWn8aux/EtmbogSDCA2W9VMUl
	c8DSOn0DTdxj+waC6TjPXf8MegByP0dPFrewApc7mS6GZRw5v7xMU9TuHU15Cx3gZT512F
	ghH0V1IDrJCuXOJ7oGJ/Ek6ylBchcrk=
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251014121115epoutp02dddad7be3fa987dee34840ae63da320d~uWmCVO_A_2267922679epoutp02U
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251014121115epoutp02dddad7be3fa987dee34840ae63da320d~uWmCVO_A_2267922679epoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443875;
	bh=PXGKebblkuYyVq32XepqRXoghfCKJGEOOFxZca7FgOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVP9IXiobPJGIbz9EacCOAHSnCKNKbX9TBtPASsWhoBdgEe0oMU+HrFuS4ReblZ0t
	 dEPavhOeWgnqnMySP5yAQUtMsDeYs3csraClpoX6hpVmfRZTuVEcXZtA58eKuRbyi3
	 vQV6rZpeJRg/A/Ne5ajjbCCqphVMA7fnmh4zVRfc=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251014121114epcas5p4d0d2a74508fa8c2ff7694bfcf2f9da2b~uWmBwq60C1326113261epcas5p4X;
	Tue, 14 Oct 2025 12:11:14 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cmCjs4c82z2SSKb; Tue, 14 Oct
	2025 12:11:13 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251014121113epcas5p3522dd553825deccfb9a1c9c12f071e3a~uWmAVF5dU1718117181epcas5p3R;
	Tue, 14 Oct 2025 12:11:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121108epsmtip16a22dad80f2ca2c63d567898c2d48def~uWl78CnMv1256112561epsmtip1G;
	Tue, 14 Oct 2025 12:11:08 +0000 (GMT)
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
Subject: [PATCH v2 11/16] gfs2: add support in gfs2 to handle multiple
 writeback contexts
Date: Tue, 14 Oct 2025 17:38:40 +0530
Message-Id: <20251014120845.2361-12-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014121113epcas5p3522dd553825deccfb9a1c9c12f071e3a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014121113epcas5p3522dd553825deccfb9a1c9c12f071e3a
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
	<CGME20251014121113epcas5p3522dd553825deccfb9a1c9c12f071e3a@epcas5p3.samsung.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4F24B14000E
X-Stat-Signature: 9agabmqzigtkw7ciyegbk7rduusjh4b5
X-HE-Tag: 1760443877-465130
X-HE-Meta: U2FsdGVkX1/0zb6Ze9UT2RW/vflcLndaErkdweskNYAazEu+mRgNe2po6e+9TTmjszw0gU0hlCr3FAtein4sysc/D4NHTeOlhp1rEjeeW+RZMraj7wYxwi1IB6kMTO32nwR3NYDXu7E6n907WyCYMobi/psMrwcTiTT3Utxpw2UcQSgGx7GUjuhyAi8Z+liddz36ETp7hiMADi/ygWEnU26yx2uNpim4AVnsy1QDapF4bXyngEfuDye4mhchLeqcTTARitFs4BDSWraEKsHPZiBsyqFg+2dE3eIZbHlJznAit6p/hz5nNXg9QhmAmEmIUy2rQE578lQiEgg38lzlFpDS+x06utKVJjR4gLko9xs65XW3O0kNUpv9QRXPSA8H2cI6s80mQl3KsM3zvNT+EmHfp8Dm2rGanOseEknc1TrVeV/xqZP2rLVvBh7N/xIu43rHA3L89UVk5Yu4bHHDjyBOJrfT0Xc5tMIhmTd/vE1v/wdsOflRDjXsOmkwbaRMaxsHLvpC+pZc5owCNCwmmFsDNHeR5IECXgCxA32juM1cgCgJnH5POP+ljpF0att+9prZ4Bcye8RHKVfFQSfiPXxT1ddpEQv2L9YXATpNzfXMxYMOGdomFlTMHvaqAb9XFjamo4QPrDQ9N4HdiYl/+AaY1dR3BEe2Q2r/KMBGPh+ngx0DIhpRqL+OrHt1ZvFRpiZw7yUbR8MxQB/NE/6TbeDUa83uf5f9xSfcp0bTsi+eZnfLBy+mbcRKgFAgtGBLUKq35tT7oA3zETkKdhznDcXwrgY2gF5R+2gMcjrkwlx3v5qypi99WmMP8neHIwHrXnBbYM89fzNkiiocprJTIldGQbn7Oi7EvSwU2KmXiO7ho8SizzdI5Rpw9jT4vEwBHjyez/3Ew5sysnfgD8b7UZ+49xgQtAE+RW7Fzxu7iVDSLnQhnsnjIEPHpoAGU74RXEWxRl0eRn1tX6NpA2Z
 OUUgr7e/
 kYuHGsquzfNo/E7QMPy/dHV3j+irgtqNFJc3W/RtieGocF4jSq5hBMYJfoJyCisjv7heHohrBiSHyXk5NuW2NHD0Izbk8hZH3Qvzyfm5lHeX8uHrqxcDdLkNc0kLZHYVpPCize5tC6nrT1RTOrNee1/EgQ2Ned2n6a2TRlljC4HK0bKkgcfOADtsXfnahJEI/rBK4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support to handle multiple writeback contexts and check for
dirty_exceeded across all the writeback contexts

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/gfs2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index bd11d5e6cf63..b1e00a64e5ec 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -447,7 +447,7 @@ static int gfs2_write_inode(struct inode *inode, struct writeback_control *wbc)
 		gfs2_log_flush(GFS2_SB(inode), ip->i_gl,
 			       GFS2_LOG_HEAD_FLUSH_NORMAL |
 			       GFS2_LFC_WRITE_INODE);
-	if (bdi->wb_ctx[0]->wb.dirty_exceeded)
+	if (bdi_wb_dirty_limit_exceeded(bdi))
 		gfs2_ail1_flush(sdp, wbc);
 	else
 		filemap_fdatawrite(metamapping);
-- 
2.25.1


