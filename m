Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE82CCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222C18E00FD; Tue, 14 Oct 2025 08:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3AC8E000D; Tue, 14 Oct 2025 08:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1103D8E00FD; Tue, 14 Oct 2025 08:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F2E558E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:11:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0EBBBB467
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:24 +0000 (UTC)
X-FDA: 83996604888.18.6D6B565
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2F99880010
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="XE/sU7vV";
	spf=pass (imf02.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61qDs/uNLNIIdKnnYQdqSL+IPjVsVRa8wMEMFzbI1Ig=;
	b=bAIOI7j6T5DM9AbHov84u2o19m9Mk2WnEcP4ha3fbvQCoeNtbeB/zj2jadeXGCc5mjuUIy
	A/Xy5GIG2+A+TlqB882KfQpdNiiKle4dmg3Q7A5hyQdYccxtM32R8RK2MKR1pmh/jJqs12
	zri8HDMbHxOaAF2Cm2eORK0AKRitBaM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="XE/sU7vV";
	spf=pass (imf02.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443882; a=rsa-sha256;
	cv=none;
	b=e8Ftnfyxc6D+cJBnOgp+ESxZh6dwHyZXS7B11Doq+qSHdtEVsTjOe36KuHqBYXotxbNtkk
	QVte+GOASPzhrXO9Jj/WZwW5LqZjpvHwd03mH7FOQGX15JnDZXOwrCLUBhm8qbIjMmekBX
	Hh3nSo5NwIOV4W8OYGRmfXCqjQFy60Y=
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251014121119epoutp04b23f3a7fb5b46ac680ccdae839220df5~uWmGwSPOD1207112071epoutp04e
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251014121119epoutp04b23f3a7fb5b46ac680ccdae839220df5~uWmGwSPOD1207112071epoutp04e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443880;
	bh=61qDs/uNLNIIdKnnYQdqSL+IPjVsVRa8wMEMFzbI1Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XE/sU7vVXE/e7MnP7E7r0AmM0u0xHWNb0WuN2b/dUX9/kpXzsXJmeIxfhY+/Ey9jP
	 cFgzwX4SMWh/mvWFDEFlps9TZ+TGhqvUXvUIkeflj27ofVsdAoY5dhzLdy5cNAElfS
	 gHxIpSt4QFXj7OwCKUo0FtsoDs2jDAzA8y40Ny5s=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251014121119epcas5p37555d2e9cbae9ba706e6102f72c13305~uWmGQctVW1718117181epcas5p3b;
	Tue, 14 Oct 2025 12:11:19 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.93]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cmCjy2l8sz6B9m6; Tue, 14 Oct
	2025 12:11:18 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251014121117epcas5p3f095fc3e8c279700c7256e07cd780c5f~uWmEts7qX1002310023epcas5p3P;
	Tue, 14 Oct 2025 12:11:17 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121113epsmtip19fc785cad0e58b227dd7ca61b631f1b3~uWmApRSVh1306813068epsmtip1l;
	Tue, 14 Oct 2025 12:11:13 +0000 (GMT)
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
Subject: [PATCH v2 12/16] nfs: add support in nfs to handle multiple
 writeback contexts
Date: Tue, 14 Oct 2025 17:38:41 +0530
Message-Id: <20251014120845.2361-13-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014121117epcas5p3f095fc3e8c279700c7256e07cd780c5f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014121117epcas5p3f095fc3e8c279700c7256e07cd780c5f
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
	<CGME20251014121117epcas5p3f095fc3e8c279700c7256e07cd780c5f@epcas5p3.samsung.com>
X-Rspamd-Queue-Id: 2F99880010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ptakdpdnhujqnkdko8skfrhy9epoo7cc
X-HE-Tag: 1760443881-270443
X-HE-Meta: U2FsdGVkX1/5GSJfLPWJ9Nc8zbjcEWYMxpfccjvOvs2Nmfzf8olb+EISjrFCTBK+BrpFNSmK+7faZ9nz8pdFZdS3pT8nnWLYyYNDpBu9vmHnuIWQIOMo6I9ei7doyKklo+ufLLL3Se9tQUR2T3nWr2QO0r0Aml+5VIXH4TAjRW772piN5+wo5gW2mpIve3UbEbgf9bCUNHLCPK65cVNKgrwkYitXXBF/+arcSoXt3W2qAXzS5Arl9vsTTIqvQFP0GlLNp2JlPv6WeXdruec9V/Uxp8GK1mLr/RK+FLws0mTEJc2q16VYQJPl74chb1HQRfG5/NOHAOHNbUe3rX6qxhvUnzkvX80526TmNWrNQsrTtEF/oRUYPYNyxPJasitMm+JAxpdRAoUfYu4kQk+9zeoHm52FHLde7V4PMwD4lL6p9M35GSt/kZ83vTmpN6GTIg2r+Xyg6r1PxrMN8OkancYJfjfRyOQrSdgaMXtlhDPTUGjRslL6Aj9rWHvFub5zyY6sgwdpSgqNREbGrUwlSNizmfn5kRzMPUF1FyKCovM2PRhPiMT3mQBdbTujCW8mTki2aCtZ0RWGzRUyPjEB4+YYvk2coXyrf9XUSCBciqTgxucReSi7uCyu6AgHxHbqn7gvjHgy65b/F6tI5EvRwUadspGQ1/s4uqsNpcSgOccclW030LvFIEhiVjnVC4DC+JHKSWx1caR5luijYKhbK5/fg+hXv2g3Vh1gvU59ttrjbielJcoJ8au8tww4bOmj2dyL9RQ6s4d++4BfiD+rLVjAr6bf2cHouFM3+DgRl3Q5uv5Hiw8DcHnXzT8W7SWVb3NN0NINLyNa6OriFd9jW0P751eE6Dr3A69nZsUqmDXwjYIQhcLiKgTU1bSyAMPySOhq/wt+Jr4E/WAlK3I+/yvAi0zWQcrEHs6BU20fa0p2VEQFhf48B3x5bvqd7e59mYwL91AACAG40VGSp8S
 SRp0jPjw
 KrjQb9/lc5Qtkc99vcHpWMqv5IVkguUVcyYuHkYQ8xiwPTHu6iGAwJnXJ0XVEd5lZGy25Q5+eJKJ4Lc3yglvo41w0fWMMyhbcQBEkOwiMfnOykUttPYlhsvoRrLsCfRHQUR1uy2UgLO/KZfRu22EwPJN0pXFFXh+GQrEuwX0r7POAGDXTIx0zRR3KZqqkosIosQdt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fetch writeback context to which an inode is affined. Use it to perform
writeback related operations.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/nfs/internal.h | 3 +--
 fs/nfs/write.c    | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 5b3c84104b5b..99eb6a5d5d01 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -857,8 +857,7 @@ static inline void nfs_folio_mark_unstable(struct folio *folio,
 		 * writeback is happening on the server now.
 		 */
 		node_stat_mod_folio(folio, NR_WRITEBACK, nr);
-		wb_stat_mod(&inode_to_bdi(inode)->wb_ctx[0]->wb,
-			    WB_WRITEBACK, nr);
+		bdi_wb_stat_mod(inode, nr);
 		__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
 	}
 }
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 4317b93bc2af..0fe6ae84c4a2 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -868,8 +868,7 @@ static void nfs_folio_clear_commit(struct folio *folio)
 		struct inode *inode = folio->mapping->host;
 
 		node_stat_mod_folio(folio, NR_WRITEBACK, -nr);
-		wb_stat_mod(&inode_to_bdi(inode)->wb_ctx[0]->wb,
-			    WB_WRITEBACK, -nr);
+		bdi_wb_stat_mod(inode, -nr);
 	}
 }
 
-- 
2.25.1


