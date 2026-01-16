Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46137D47CCD
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3B16B008A; Fri, 16 Jan 2026 05:12:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90F8F6B0092; Fri, 16 Jan 2026 05:12:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9F86B008A; Fri, 16 Jan 2026 05:12:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 672666B008A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:12:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2979AC22E1
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:12:54 +0000 (UTC)
X-FDA: 84337413468.14.8970F06
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3A019100004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:12:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=i40Vzp86;
	spf=pass (imf05.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768558371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BpzxFl3g/5TPELMzmGzvBSQN5CcPjGy3hoOD59YZp9U=;
	b=Cx5nWbYCj+Sp/qzwj+W8IZMNUKP/FPtxrPI69mSw4BiQ4sd7HBSEI2L1GzRtZFzVXY4iBO
	dyl9Ty2958E715Kzc2y8oBWe0aRv217rg3aCM86v+Z1YviHARnC98epb2TspZnPZ76ZVAL
	FX4PqjFXB7botw6XwSegUypCt3wpjg4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=i40Vzp86;
	spf=pass (imf05.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768558371; a=rsa-sha256;
	cv=none;
	b=a4fnSc8XCllreKNi0ZFexVRkjUh+4L/0EUi2RxvL4fWeZZSmLup/ny1lIMHB/Pp6jTx7mC
	FsSDQaLY9IU594tuD2ToVyot0wj53NOmnaehKXxjGHI92+eRBsnDEEvLv123qsO0Q3YMgg
	IJJiCV325bRTxuoRxHn2rKlqZCk4QFY=
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260116101248epoutp0138257bb938bc772228a22577ea296559~LLncrFOkd1968519685epoutp01S
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:12:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260116101248epoutp0138257bb938bc772228a22577ea296559~LLncrFOkd1968519685epoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768558368;
	bh=BpzxFl3g/5TPELMzmGzvBSQN5CcPjGy3hoOD59YZp9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i40Vzp86mK+KJk3FkTupWTSO+BkS3RzcIzoiU2Jc88AB2MaIbXgMPVmjoYw7eb8/3
	 ENz3L5+08tou0+EIyr4NQ8vImMaquqCHoxKgdJ9tUIY4mopzNADJ5Gj0n1wyLVVvpW
	 mNNr0U6WGHBgKKpZUH2GuhjqxVQLlcxXLRp3bZfo=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260116101247epcas5p44a05f2dc0b46ae9c4abe6b40e7f3a935~LLnbwhVO11433714337epcas5p4Q;
	Fri, 16 Jan 2026 10:12:47 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dswdp0SZCz6B9m4; Fri, 16 Jan
	2026 10:12:46 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260116101245epcas5p30269c6aa35784db67e6d6ca800a683a7~LLnaQNlS10614306143epcas5p3b;
	Fri, 16 Jan 2026 10:12:45 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260116101241epsmtip26bf4fc723f2f52008806efa410901587~LLnW-7TWV0710307103epsmtip24;
	Fri, 16 Jan 2026 10:12:41 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, kundan.kumar@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: [PATCH v3 2/6] xfs: add helpers to pack AG prediction info for
 per-folio tracking
Date: Fri, 16 Jan 2026 15:38:14 +0530
Message-Id: <20260116100818.7576-3-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260116100818.7576-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260116101245epcas5p30269c6aa35784db67e6d6ca800a683a7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101245epcas5p30269c6aa35784db67e6d6ca800a683a7
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101245epcas5p30269c6aa35784db67e6d6ca800a683a7@epcas5p3.samsung.com>
X-Rspamd-Queue-Id: 3A019100004
X-Stat-Signature: 33o9uo7wg79ieqyprnpb5zjtb9n81ywf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768558370-705598
X-HE-Meta: U2FsdGVkX1/1Q+7uDR9jkpCERhamc2AkpfcagayCVTy7fKZsrf6IqFLgz9BZkQnV7lo42DOlPL+GNckeFJoNsnxVaSWbOHABqJSFhQk49CvqJ3XpAiI4yVah7EaYGv7d6xy/TFOyUdofW4/jtpPhqdX1oeQV/I9+i6iW27rHce/yWwBa9O05Ial3Gi/An+sDE1WHrPg2X9WD1YKHV/FSKnmtJ8u2ZGANsNcjOZcI3JqQav1l+SHaxyFLKVFqjxUeY73TvGIpIuHv734jUlWK6NZlYw3G6gql5wEEIMFa2G+r5X7ua1cDqTaF61vTOGnkG2I5BPECCo1ZpQ3mfFOmDYgYTMd5XhOOclKBVXNxGpAGyueW1m9FkpsjGVoDAGkvtq6JYo1SYXAJqmf6ZYJAQhQzUrBR9fWurtNls4MJBbgbE+e/ixDtfW9pJ+wF6JJQScsxKllhvavWuNI7ec6iz7c+jokTT1MGbaJnYVSODLjuzoAM0HQgNNXH24bEWhfPYmyxkZPwo/cf8rYfUwTKcNZZ0Rdb7hlwhqkBpeZhx4CZNJIS0el0XEmAnLLNU1UeRKLJcBhVuYVMaD1erpOXTpw+0wDH8e7oVNGjAL0AwiPGNfRyHmcoKyE9MpmPGFbc0xVOA965G1d+C9/7tsC3Uo5Ql0Tv1b9u8IGTZ8QHnaDXufEt9X75zxchR90fzGnEPuwXCKmYsNpWUkW9uJX+uIlpsIbr377Truwmxoy1/G2k7PAuxkuVLvmXrr6XAb2q4jxHTFm8lTBsSVku3KxA4rvaKuVJsdNft6K7GzHdRr+RbA4EIHz/eSh6nm0KJv2dIkADUvffD02ZUTbA503XhI/4oLRjoQifbT9tLE8Kl98C8g492CeDQXhGs8qkDeMLoUaOuO5PEoyQWzgk0j07DNZVDS/bFd9QAxGbBUmCE9eawx4XPkKSuxaNr/ai7QOsEItvtDFqItyY2aqQ1Op
 lt0p7JkE
 oEzZlyB89qyExcD/zUjPRMViIWR7pApFAgdrmw/E176SC9B9r/qN3szpBKvlWhhkue/tAUFzboc7FQC+fNBiBM2oFqmh+7u4b6c/R+2HEHOV3DuEulfenag0e/2IxOcEeiUzJ0g6mEq+fy3ELeP2TjHdjnIvuoFZf782q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce helper routines to pack and unpack AG prediction metadata
for folios. This provides a compact and self-contained representation
for AG tracking.

The packed layout uses:
 - bit 31	: valid
 - bit 24-30	: iomap type
 - bit 0-23	: AG number

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_iomap.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index ebcce7d49446..eaf4513f6759 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -12,6 +12,37 @@ struct xfs_inode;
 struct xfs_bmbt_irec;
 struct xfs_zone_alloc_ctx;
 
+/* pack prediction in a u32 stored in xarray */
+#define XFS_AGP_VALID_SHIFT 31
+#define XFS_AGP_TYPE_SHIFT 24
+#define XFS_AGP_TYPE_MASK 0x7fu
+#define XFS_AGP_AGNO_MASK 0x00ffffffu
+
+static inline u32 xfs_agp_pack(u32 agno, u8 iomap_type, bool valid)
+{
+	u32 v = agno & XFS_AGP_AGNO_MASK;
+
+	v |= ((u32)iomap_type & XFS_AGP_TYPE_MASK) << XFS_AGP_TYPE_SHIFT;
+	if (valid)
+		v |= (1u << XFS_AGP_VALID_SHIFT);
+	return v;
+}
+
+static inline bool xfs_agp_valid(u32 v)
+{
+	return v >> XFS_AGP_VALID_SHIFT;
+}
+
+static inline u32 xfs_agp_agno(u32 v)
+{
+	return v & XFS_AGP_AGNO_MASK;
+}
+
+static inline u8 xfs_agp_type(u32 v)
+{
+	return (u8)((v >> XFS_AGP_TYPE_SHIFT) & XFS_AGP_TYPE_MASK);
+}
+
 int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
 		xfs_fileoff_t count_fsb, unsigned int flags,
 		struct xfs_bmbt_irec *imap, u64 *sequence);
-- 
2.25.1


