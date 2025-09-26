Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19F5ECAC5B0
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A998E000E; Thu, 25 Sep 2025 23:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25F98E0014; Thu, 25 Sep 2025 23:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F478E000E; Thu, 25 Sep 2025 23:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A63308E000E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:35:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 836CEBA2E3
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:17 +0000 (UTC)
X-FDA: 83929985874.16.2B958FC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9A346A0007
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GGY8paAI;
	spf=pass (imf15.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758857715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WTUIrmbHpwYn4cveCkSP3iLYZRp1BZXyN/59/DoY/4Y=;
	b=5UgyAxBFyj0+WrLmzFuPkT5jIurALMsSC1ToVjy+yoa0ihiYG9VCGAFa4Oht0kr3DlawSO
	uV4TZvc5xXToqU7rvqKxfLwNN4jcoftWkGjDr6EuHNtRx2ix6+z1egkhkrXeiBftIiB72y
	0o9TU7zil1/5vGdtnSArtX1CWMimpDI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758857715; a=rsa-sha256;
	cv=none;
	b=LG7dnp0PPk12TOgRfugGv+Hjvu2I6ClWt/eN+k5zM5jEFz0IAUuKkXVbV5G10XxVyBsAJp
	VxYxWn/e3GyLqd+slKBVqWkopat/HA91VdG+Rui7TaXKebZ/rFp8LmtSDNfK3o1xsfky8i
	wz6AHAkN9MJEtc+nOEQC/gN3bOhhv3Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GGY8paAI;
	spf=pass (imf15.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857716; x=1790393716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YeucmBW4uE3v66fZdWNHbrEXnqb/5N0a3izK6ymDr0I=;
  b=GGY8paAIaitSk/F+vmjTKg+g6AqSocBT5sEDg2AebaZSIieMnsxKh2Mq
   vc2M84EWEsAXYjGqE1alzqQZjyWM+r2RW7S8/FFXDDB/p296HrKBz1dpW
   jBLeZrBuPgWnirZ9k9qmQPFbWkFLky1kePkv5o5/4bpN6R9NJwCv5KFIy
   YBCo4pDisE46bVC6QKI9inxYfZILmvcPuCSDzUqJGBDhWkmT6ESliOSZV
   imOn5P5pNUYaEYDQsFstU291FYfHQq4c9YQU6+iwGLm0NA0kBY7d70CZS
   bCqBQYcZLjUNuHZGsHkuJK4uR67B5HgQDvtAMkgx2a+bMA/gUgND/qPUY
   w==;
X-CSE-ConnectionGUID: 1DGXhhVjRvKi17H34Z4xLw==
X-CSE-MsgGUID: 6g/16qCcT+WybnMq/zWQnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819529"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819529"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:05 -0700
X-CSE-ConnectionGUID: /bspJ5WQSiWc8d4EuZm2iw==
X-CSE-MsgGUID: MXWsdFXuSoCqOvxAuuj0xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636577"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:04 -0700
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
Subject: [PATCH v12 10/23] crypto: iaa - Expect a single scatterlist for a [de]compress request's src/dst.
Date: Thu, 25 Sep 2025 20:34:49 -0700
Message-Id: <20250926033502.7486-11-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8ungx36okbdft5r16s5nydz5prq5fyg6
X-Rspamd-Queue-Id: 9A346A0007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758857715-964665
X-HE-Meta: U2FsdGVkX18l5ZaSzznDK0K6WI5/qANNsZnLCzfyIsdtprRzGm6Bb+gouXRrjdWFrw+e69+JJ/nWSlwbYwqleDp90F15VB5y7Qw/pkXDlb0hZVxHRknc3iNF2kdYzxxXkbcK2kboFRRsVDLsxIL7s/edFjyQGhef6fO2WvzsKe0MuMiRgvgvrPbLEqJkbrZ80D8wJ4Qm9dcG3J5xhDTZ9Fv15Z19zCrT5Bjm9AgV3MlFwrJ8ZiVGehkNXBcjKalotSnQ+plknZinXRZwqE8vqosAuUPxk+U04Cg8Qe/znR7hCHjk1hcZm0TVX915fJCr3S86FgjcME/nQEWtAOJmlYKw7F4bULK35d+zmuX13Zoa4+uzX2OZ28alCQtJPu5l1ABImrxBk5vECk+1VBl/5DR2q7JCYLSqIG4a0RPyW7V8vNlsOYgQEEHyb1y89D6uIw9F71/WiEDEgnfbVXY3u3Py8IBEeL5a6AkU7dJmQDTGEiBWej99g1F5A0mDPygHslJYUup6GwelDWka1poqwOff9yKQ0MGL+1vIorhJ5Jn+x1QxQdYaVIoGud8+B9KkvtuFB6Je02hhywrRYA58R8butdgKidX02hx84+nu/T+6bcgwuPEBzory66KQQfNNjcgj0GqHXzW5rXyITSbAOXVa9N0Nzj5GpL8o0R7wIgC4I4CqmeBm5vKepdvO/tOOvb5GVRe3gT+eP9uDk4txDR0K1Hhg6a5oqbj72tudFlm7B/D7JHJM+w8GvEStERqlo5MxjwygNHUzj/bivlZFhrIukyHkRWtnzAr+aYaNZMQLD4WrRhDlDe8/YpzaJse9ZY+kktoM2zTDcRypYMjOcFcseeqQYEUMeW5PZZF7UXcnpsUWGtA3gb0OcqhJu+Ox
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
index dd7c4831e092..16b071058f2b 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1514,11 +1514,11 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
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
@@ -1530,13 +1530,13 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
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
@@ -1704,14 +1704,14 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
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
@@ -2014,8 +2014,8 @@ static int iaa_comp_acompress(struct acomp_req *req)
 
 	dev = &wq->idxd->pdev->dev;
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map src sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2024,8 +2024,8 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	}
 	src_addr = sg_dma_address(req->src);
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map dst sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2051,18 +2051,18 @@ static int iaa_comp_acompress(struct acomp_req *req)
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
 
@@ -2095,8 +2095,8 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 
 	dev = &wq->idxd->pdev->dev;
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map src sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2105,8 +2105,8 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	}
 	src_addr = sg_dma_address(req->src);
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map dst sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2120,12 +2120,12 @@ static int iaa_comp_adecompress(struct acomp_req *req)
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


