Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECE46CCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7620F8E0110; Tue,  4 Nov 2025 04:12:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69CC08E010E; Tue,  4 Nov 2025 04:12:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5167A8E0110; Tue,  4 Nov 2025 04:12:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7DB8E010E
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5F6C88B04
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:46 +0000 (UTC)
X-FDA: 84072359532.24.5D10A4E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf11.hostedemail.com (Postfix) with ESMTP id C245F40003
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QMtbnyuB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247565; a=rsa-sha256;
	cv=none;
	b=Taf/J/t/okSv1R0m5+ovfMHfJpLWzR5hzocYuVwhCxwNnS9LuSPjGD2X8dcrHU6cDNlJWq
	Od6xu+iqS87oKEVsoIJapvBdsylp2ISq23NPBucy9asaqdvJt9dQLlEdSHaQrpJn/RKydA
	Hr1fDtbJ0rkKa/KGfnM5ns2s0DLC0LQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QMtbnyuB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nu6KdvA/BUeSUH+q/iWS4xrKT4gDQ23o4rF/CoEp9H4=;
	b=mrJovpCnQL7WwBMBujUs7grZ2rMx6n2ep2yBWciMQaZJRz1pJySuEV6ILRhPt67Ki576d1
	6XQtIT8SG5m1mVSPbjO9glZaJSM2XoSHujAvge8kgNcbTuBMkcUojdvvOnZylmZwo/8Wzn
	YTxhPfU+q/RNpA+OIIebL91YR0uS9ZI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247564; x=1793783564;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DYdbUQmDyjma1Uk7ERKMfMbJfAu0/DQUfg94r8ghqgQ=;
  b=QMtbnyuBFKXW6mQDlY8pQTL25MHtVG4UeyPIFzVb6VNEI3OoVQnspxf3
   IN7pXv+8liEs9Ybt5bbkfawi2sPjtio+0ZmSl+Frx7QDJecM5FVDUGv9n
   erPfHyuwQYyI5pcQKzs4GGAZRvynrVBDzclRWaZMQi0RlB24+fRWuy5Ty
   pgXWiXw7t4kvlf1dDroeNYZ9LBlFORQ4yxtXcDIveIsXpO4XjEOpUV7Js
   dRpPMlZkQqLEXVRMFhk9b7Exa5Xo2CH+UEJoM3bQeaEUeRHiysWYlDJjA
   vxEBPORxaCEQXInm2uCb8L5/WKyd0bAEnMa15vPDpchk13QkZx5rJvuH/
   g==;
X-CSE-ConnectionGUID: 6+MuJGQDRNKZ95wXMm4pAw==
X-CSE-MsgGUID: nU+rKisYTCm1mMNRl58F7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265183"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265183"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:38 -0800
X-CSE-ConnectionGUID: CefLIxCmQiGT2et7GffAEw==
X-CSE-MsgGUID: ExBGBeCxSbqxCSwqxUv1qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795805"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:38 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	sj@kernel.org,
	kasong@tencent.com,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v13 10/22] crypto: iaa - Expect a single scatterlist for a [de]compress request's src/dst.
Date: Tue,  4 Nov 2025 01:12:23 -0800
Message-Id: <20251104091235.8793-11-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C245F40003
X-Stat-Signature: 8shctb7nbjfiutts33os6h38c6c463pa
X-HE-Tag: 1762247564-642667
X-HE-Meta: U2FsdGVkX1+X7hy7WLtXFsJgMMqVs7hPSJIH9o+dzvT03V2QbWj7FJkZGJu/OBLBru2FK6IQ59WOzZzMLgjIolSdZywAqclPX4OO2Z6pdno3O3qWUvbCVXxpb+ynvNIWakUqlJ5HvndH5v3dtBwOtdpMUwAhVrrc9O+Rlf0OJ4zu9hw2tuW0DdKs3Sja7vK17DSmoDkfSO17xy/PYvkd7xoRkc5J083FxfZLud9cgN/udmnPEX5ePlRjbQkAwXzKl09YAzINDJw+W9ajtIm42aVmAbwwTcFHsUzBVBLJJo0ndmIYmqmmajH3ihaFEM2xbEjvetSFbqjrZE1ktq4J2eMgBu6sva5TIF18Zv3AzIoDVITqlf5Wpjcvz6O0ltpfr/nw3QAWwu/9u4xryOYJrUYWkE1YmC4nsynbh9NKhX22zanuUAkOtf7yAm95G6RfBk8JTB3YCREFwiEc8lg3srD06XduKW1enD03yOwgLFgSVwgNw+kQHafKw3E8XIC9vMi9R0D5m15QRAiN3kAXlrKm7uMLyxS2OpChdMZXV3dtgtekiNCXvQiR/DptKZ7axGigX7jRgXPHT2VwLsllYxn+YZgKKGEajLTjpnkYMCpB5dczR585/gmHAntBj9dvqfjSyg4VFpADsSjIZo+KTtc5fZbgha98CrDnU0wosoz4UHdS3haPlLLT3/ph137EjDNH78VoPF3k6wtMyNi1doLBWy7LpEGx5hmbm1tVhtpRPMN3H6AgJ3FGAtJKKB4XI2hwPg3CI9WHmY/L6Y6kGwho+3QCjRVpq5RDqT4zl5DhqGZPhZP2IItvEElwipNAKaB/DQERatTcT5KZIK4cZNqNX0qK0entcJ3e23SUIIvrYAU9W81b1NQaYrsP256Kaqcs4nGFrlIxQvgGnq95GOmG6SuKTRWEelWx9tCXXtW2vIWeWYd9IolufiHHo3EjJuixrO9TJ7EipHMlI68
 VhOKIvXF
 SSGtotwEttXS4YEwa72VnprQLWyI5/+Jo22nwdMfn0qsY+jXXVT/BI+X4J4PHyDNzINrpYPakg1dPodsK/HfqXO4fbFEl2BL7C+DJfNOCSLim+PhSkzbn5KOCrmlsNJ48+1iRpWqMvH+oh8cWPGAdz5E9lvimeDkt/1h/N8toDQW7+m47AzBhSbtDJjGJj4F9GTGPBA9m3ckXFlLMw+nd8KZoI8CnXFCunWSoG87HVXR0hJXTWL0Z+V0IEm9ifwXBQurA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The calls to dma_map_sg() were passing sg_nents() for the @nents
parameter, then error-ing out if more than one @nr_sgs were
returned. Furthermore, there are no use-cases for iaa_crypto that allow
multiple SG lists to be mapped for dma at once.

Moreover, as per Herbert's direction in [1] for the batching API from
higher mm layers to interface with crypto using SG lists, batching
within iaa_crypto will rely on there being exactly one SG list per
"unit" of [de]compression in a batch, where the component SG lists are
obtained by breaking down the @req->src and @req->dst.

Given all of the above, this patch simplifies the design by expecting
only 1 @nents in req->src and req->dst, which aligns with current and
batching use cases that will be developed in subsequent patches.

This alleviates the latency penalty of calling sg_nents() per
[de]compress op submitted to the hardware.

Some unlikely() annotations are added to conditionals in the core
[de]compress routines to further improve latency per op.

[1]: https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#m99aea2ce3d284e6c5a3253061d97b08c4752a798

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 54 +++++++++++-----------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 061e3403d365..04602df8d173 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1520,11 +1520,11 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 	int ret = 0;
 	int nr_sgs;
 
-	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
+	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->src, 1, DMA_FROM_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "verify: couldn't map src sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -1536,13 +1536,13 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 		" req->slen %d, sg_dma_len(sg) %d\n", *src_addr, nr_sgs,
 		req->src, req->slen, sg_dma_len(req->src));
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->dst, 1, DMA_TO_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "verify: couldn't map dst sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
 		ret = -EIO;
-		dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
+		dma_unmap_sg(dev, req->src, 1, DMA_FROM_DEVICE);
 		goto out;
 	}
 	*dst_addr = sg_dma_address(req->dst);
@@ -1710,14 +1710,14 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 			err = -EIO;
 		}
 
-		dma_unmap_sg(dev, ctx->req->dst, sg_nents(ctx->req->dst), DMA_TO_DEVICE);
-		dma_unmap_sg(dev, ctx->req->src, sg_nents(ctx->req->src), DMA_FROM_DEVICE);
+		dma_unmap_sg(dev, ctx->req->dst, 1, DMA_TO_DEVICE);
+		dma_unmap_sg(dev, ctx->req->src, 1, DMA_FROM_DEVICE);
 
 		goto out;
 	}
 err:
-	dma_unmap_sg(dev, ctx->req->dst, sg_nents(ctx->req->dst), DMA_FROM_DEVICE);
-	dma_unmap_sg(dev, ctx->req->src, sg_nents(ctx->req->src), DMA_TO_DEVICE);
+	dma_unmap_sg(dev, ctx->req->dst, 1, DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, ctx->req->src, 1, DMA_TO_DEVICE);
 out:
 	if (ret != 0)
 		dev_dbg(dev, "asynchronous compress failed ret=%d\n", ret);
@@ -2020,8 +2020,8 @@ static int iaa_comp_acompress(struct acomp_req *req)
 
 	dev = &wq->idxd->pdev->dev;
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map src sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2030,8 +2030,8 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	}
 	src_addr = sg_dma_address(req->src);
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map dst sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2057,18 +2057,18 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		if (ret)
 			dev_dbg(dev, "asynchronous compress verification failed ret=%d\n", ret);
 
-		dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_TO_DEVICE);
-		dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
+		dma_unmap_sg(dev, req->dst, 1, DMA_TO_DEVICE);
+		dma_unmap_sg(dev, req->src, 1, DMA_FROM_DEVICE);
 
 		goto out;
 	}
 
-	if (ret)
+	if (unlikely(ret))
 		dev_dbg(dev, "asynchronous compress failed ret=%d\n", ret);
 
-	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
 err_map_dst:
-	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
+	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
 out:
 	percpu_ref_put(&iaa_wq->ref);
 
@@ -2101,8 +2101,8 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 
 	dev = &wq->idxd->pdev->dev;
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map src sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2111,8 +2111,8 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	}
 	src_addr = sg_dma_address(req->src);
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map dst sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2126,12 +2126,12 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	if (ret == -EINPROGRESS)
 		return ret;
 
-	if (ret != 0)
+	if (unlikely(ret != 0))
 		dev_dbg(dev, "asynchronous decompress failed ret=%d\n", ret);
 
-	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
 err_map_dst:
-	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
+	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
 out:
 	percpu_ref_put(&iaa_wq->ref);
 
-- 
2.27.0


