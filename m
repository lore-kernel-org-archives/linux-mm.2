Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D22C9E63C81
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EAE66B00A2; Sat, 24 Jan 2026 22:35:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468CC6B00A3; Sat, 24 Jan 2026 22:35:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0E26B00A4; Sat, 24 Jan 2026 22:35:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 110A96B00A2
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:35:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB5EF13AD2B
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:57 +0000 (UTC)
X-FDA: 84369072354.04.7CB0BC5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id B8403180005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DwlWLcKV;
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qTctHNEfD3FZRBilJ87zXFdfNfnTIbipX2+UsCQyDpc=;
	b=qJwwmIiPTuoGsgxecNiQM6mUgdQtGWDHN8W8k+YwfldN5CxJphWeJ8AVXEDsY8c/IdFypR
	EdptLVMA0Dnnn2HvRTz/ZK/bQMMlbDxVfIKIVPxdCNaXEbah5PPlAyQ0SqTTvYrHi1ONUf
	SNrC4Mk6eeT1Nq9ORMLpO6BbSh9WMb4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DwlWLcKV;
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312156; a=rsa-sha256;
	cv=none;
	b=fenKxHlrmLN4+i3r1KE8wUcvVdAuNNuQzbgdKWOWuIb1K860rrjPt28cEnrc/SOulp+1qM
	U08vFB74w1Pwj28beEzUcTZu3AAcy3tclh9DkIk0zJyzoCQuJiQToKHpoUSjQn2biSgDV5
	2Ld9po5zGKtMWdxW/KMb8GlrDklSHZg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312155; x=1800848155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GQ14vRAHcbbj8om56GF25rYzFUWGSeE2wTidcEC1vZU=;
  b=DwlWLcKVgU+fsnwLA9YP5fj4m4th3vEdAii2TPoXyPfmYsN9wzTl/NFp
   FNF+tVy2FA3wHhSSCtwGMJXR+4SnODhC6EbyR7Esle/I4SF7BmhqKXjKc
   oXCH4yNCzLLDtXHXgYZxPBIS5tiCs1VYiA8Q7EJ6msa8UxgQbqpDBBR01
   ARUqN3dBK3MwamFfs51b0fNNlnMPtj99v4/3wQJrozFxMq8pDhqCl7D2t
   lIkU3mn/6Gp2VQQGXHS0/ZdRNzJ9YoxbldY/PB1JmJ0f8Ut0DdVYQ83Oq
   LpRcAbJSOm3TVvtyQplEwc7wVW5RgR7m/fQar/BE47pmO5uJuQhwHPfMU
   A==;
X-CSE-ConnectionGUID: wbvtKPWjQk2anSI0/tC5Kw==
X-CSE-MsgGUID: d3cJfU24RxOa2YpGmkAiyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887467"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887467"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:55 -0800
X-CSE-ConnectionGUID: lns0XCV+TNODYDu1Ja0FCA==
X-CSE-MsgGUID: 91AaHQWjQ+GzdFYQIBIm0A==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:53 -0800
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
	vinicius.gomes@intel.com,
	giovanni.cabiddu@intel.com
Cc: wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v14 11/26] crypto: iaa - Expect a single scatterlist for a [de]compress request's src/dst.
Date: Sat, 24 Jan 2026 19:35:22 -0800
Message-Id: <20260125033537.334628-12-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B8403180005
X-Rspamd-Server: rspam07
X-Stat-Signature: nw9rjpzxixy5hmsnorggmu7nn4crkpru
X-HE-Tag: 1769312155-160583
X-HE-Meta: U2FsdGVkX1+2sOwCOeCJAqzARfwubaBXckT09uULEHX5aGrub1OG13ZM/JO0+LV15SvMLhDeBi2/pQ9yCN9nuAoThATWG091y1GVVvhaiad1KByyYG8Y2oJBTN2OoVR28ag0/pd6xskpRsfHAhBQPXwZXucTvnadaDPtcYGJ85sjGh399CZrF03se6A17zZIm9dM4T3Hi/PIgDQ2c55hFf01NlZZ0WjNa/xNqMYb5KlhDemuJjXyJKepjvCTfgw31Elmf16EZvh6u4X8Z2FqmrDqvpCAEHo6whJ0YnxlpDDgV/yN48/4BKoo1RpzPP+pgeA3Qp8teAs+ma+/12RDt/4iAB1+7xkerRFKzbZNVh0CGGTmPUEcuIYOprA9uqjf4ppM2Nsh8GwxImUn7pgEVZAiF/DxvmT2ZEdHdP5Y+mK0vC2/iO19izoNiD07DU1AfmyDC44evzvnH2n/58aQ0onwWG35Otcyh+eEY4d7ljif4C8AYLT4vH2hu+Q1SY1+eZtWHakOs/oc4y47+FaFm8OQelic9jgt4id3E9TNsTrtAzUxhPQknLNvVBgW3YR5z1GXJofsN5bpfEsoGa0PCIKLh/xLutwWq0/E6u2Xga+EMLxRMvyhiBKa8AbYscpCA1rpwK66yWyPiHk740yG11dI+MaFpZjJEnN+b88874ijr8+b74ifL/h+iJvwb0Ju7P+NkgftYYrnOPZ5rDxmLZHvIwxO6QbMnIuNkHCIpuk0eTdxm046zYkvBJqd/gnDazvu3GyLg131fBvwqh9tftRhu8Y46QSYyw/jijvAo0bPi7O8W7tzZ0g/jNsyqpQsxS6hIM54m2u7s9wEY5O/UPph7zlBunaEpjCdurOAQ0GWOr67Zb7N7KvC0m9UyQttRpV+Fj0R1VnvwhVgFobKDNK73Lek5Qj/MkViQAV1OrUObzYotLQ9AN2C8UhtwTI342h1LBfzBiofzrwrbxf
 Cyb2cC8I
 LH+nrIslylivyyGXrts8g3yPDsay1CLArUApop4a7WhEPqwITQCC/zTLQJFd3TpGP4Thg5gVdb9K6SNgbHIjNF6ssxLfy4MJZ4z9DXkzcsQUJSMrSd4jkriXfP4LNyRkWpPLmwKcBTHlHRtNV9GbdGWvlDQ2u/XfngtL8ycOTCy/Om3bCNW4c1AO2yEvpob766iW8bQZiXXDarbPxv8lq9Mk6P4QYPLQ+CPJ2pjV3cvkCqexsCvA8FuoevTN12Ne3shyn0NYWnLTVqnY=
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
index 1b44c0524692..aafa8d4afcf4 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1521,11 +1521,11 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
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
@@ -1537,13 +1537,13 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
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
@@ -1711,14 +1711,14 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
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
 		dev_dbg(dev, "asynchronous %s failed ret=%d\n",
@@ -2022,8 +2022,8 @@ static int iaa_comp_acompress(struct acomp_req *req)
 
 	dev = &wq->idxd->pdev->dev;
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map src sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2032,8 +2032,8 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	}
 	src_addr = sg_dma_address(req->src);
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map dst sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2059,18 +2059,18 @@ static int iaa_comp_acompress(struct acomp_req *req)
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
 
@@ -2103,8 +2103,8 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 
 	dev = &wq->idxd->pdev->dev;
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map src sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2113,8 +2113,8 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	}
 	src_addr = sg_dma_address(req->src);
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map dst sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2128,12 +2128,12 @@ static int iaa_comp_adecompress(struct acomp_req *req)
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


