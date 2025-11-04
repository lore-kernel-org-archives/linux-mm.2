Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34E69CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DEE48E00E7; Tue,  4 Nov 2025 04:12:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3118E0109; Tue,  4 Nov 2025 04:12:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1946A8E00E7; Tue,  4 Nov 2025 04:12:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED6898E0109
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:41 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B3EFC1A0459
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:41 +0000 (UTC)
X-FDA: 84072359322.01.F701103
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id C26BBC0004
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bvdtPkFe;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qMn6EZGrUDMO7px0gNA7/H6Pw8NJeVrQVsuF2tY6kI4=;
	b=yvDoKbnHNIXQa+1YpUY1BmIuxOOBgGTEkIQXkxgHFj4PhFgNoYZu+w+ula2T6VMtW0/3E6
	NbkgER5ApWhxEspYcfJ3pTNuiKaty2eeHdCKpth5/1bXgOHrq7F+bfmWa3Cv6tPC2f8GE0
	YZcTdx1DY1ZJx48jGv/RVIfc5vCZgGg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bvdtPkFe;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247560; a=rsa-sha256;
	cv=none;
	b=6aeHLHkMFzAyHGRB+RVSE4K5mHQ0YY33i/TDTlymNefSMRIpKll4KmOaqzLgjvgE9s0T6L
	+XYVmx/k/GAH93y595NrAuFTofrZOfqEIP9BRUCOuBudS0ykXqVtQ5i2aMbR3Ic1+Rdi8v
	moexiOgNfZTLMfRLz9dMsV46gg5ywMA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247559; x=1793783559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eCl4EG1eBmLJuc5d8RhnsvBkJgwdr6FIQHonseSuOMg=;
  b=bvdtPkFeaPquvQSzN8woc4yqIhLcunbo0Ol3jxppT5kQrG7TxGLmaDSW
   EXV8XaQ4SddDCUK0d7SUJmsntf3psC46hLfdFOkdqeK18C4m/OrKiRZlt
   dEbjtYZw+D057C7CMXAB5uZwGBTFbKLEwKeWKZL2/vWv4QN6Zg9U9WOQi
   /Gn7ccfepRj7995vpe6F9NLvpCpMvSviVjN8jQ7zmgQl5PVbBfBnWB/vh
   ge8gD1CrN2wPTK895vkLFEAFPHONPmEXDOORyaDx42m2tge4jHLGh2u/b
   0VjHWEkYBIDGhIHAfcbFnBVptmWQWmX+Ab3ejUkGWnul2hvCIvcYVJabI
   w==;
X-CSE-ConnectionGUID: XiOKsdz7QLGXxC09xhg63A==
X-CSE-MsgGUID: 3hrlcpmsRCmoki+XxWFXHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265168"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265168"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:36 -0800
X-CSE-ConnectionGUID: nmNo778lQxi/+j5yJsvhGg==
X-CSE-MsgGUID: bdHmsEe7RASBUpp2c5c/Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795781"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:37 -0800
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
Subject: [PATCH v13 03/22] crypto: iaa - Simplify, consistency of function parameters, minor stats bug fix.
Date: Tue,  4 Nov 2025 01:12:16 -0800
Message-Id: <20251104091235.8793-4-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C26BBC0004
X-Stat-Signature: z7ku9mito5p6zpfs57c4zge67agewwy1
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762247559-608641
X-HE-Meta: U2FsdGVkX18xQTLmq2bmQtN1QVeyARa0kWnENjCxsPAcCWfyw3h/XyYxsMcauvrUQpoxkijD4nLdj2SckPBsn1ke1RrrBa2lsJMJ9ZIgfouNRrbrdHsnddhvZg9iz8EnxjllsV0PfPp5O93HDb8viT3EJy5t++xw/r3k4Idh9TcgD9h1UtNzLd8PU6PXsn1Qm5LhaXhTWgEtn0lOl4hLisW/or0DrIX2QaryZk3/Q4/Y1mHN+uY5mv98/ufS+Vw9tsOkVIAuBLpW4nqoYCv1BeAYZwQ2fRu5mRhp6EVoAoRDXlt1/PJ9sFffZH+0SHgpRkTL50o55XBLR0LFQnBoS5pIr97herZ5vUuYJ/5evp1phhFiq857KI3fgiucPHLKGFucLKaN4aHkuSmpooa4mSqFEzad8WksX6ii3Eb5S9NB5IETIMzfthrKENwsH3QSQgNwuN+42NE+OmRSjc88nsZXSmIQXhOX+GDP58rkH9ceoPJ1/D/Y34iLxJosqmLvH7jFQC8aEUY1pnuauIjlS02IrhzKTP7arfkbqOQghAJQt2TzlVtZm67DFV0+0bYefFE6Q5SwZrFAGgpJ4WUntG/AxFTEIDbllL2FpCWqbB9oxMWgDQOhjIVOzflxg6Zj8iEEKCOLpT5f1xaydWdhhbD6cSxVbBa6yZyW4OtgDDA5ovxzD3FYsp7iNRXcVXlBZSCmqCN6KczYW91I7aeV2o53lOHgUR49rLF7mVKZiXSMNrc4vFMTAmHvq13h9vhLW6lx20mCiT2ymb8Q5mWDQHZp2Jq5Sv1qTdsoC9NJj0t94LF0vHvE6XJyik78zLe0N/0OjJ5/wNW2853PAXSKveHslaThrCAh57styQcqd0wSHocmNpTbyTgiJGVh8PPN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch further simplifies the code in some places and makes it more
consistent and readable:

1) Change iaa_compress_verify() @dlen parameter to be a value instead of
   a pointer, because @dlen's value is only read, not modified by this
   procedure.

2) Simplify the success/error return paths in iaa_compress(),
   iaa_decompress() and iaa_compress_verify().

3) Delete dev_dbg() statements to make the code more readable.

4) Change return value from descriptor allocation failures to be
   -ENODEV, for better maintainability.

5) Fix a minor statistics bug in iaa_decompress(), with the
   decomp_bytes getting updated in case of errors.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 107 +++++----------------
 1 file changed, 22 insertions(+), 85 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 9de7a8a4d7a8..44d4e2494bf3 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1596,7 +1596,7 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 			       struct idxd_wq *wq,
 			       dma_addr_t src_addr, unsigned int slen,
-			       dma_addr_t dst_addr, unsigned int *dlen)
+			       dma_addr_t dst_addr, unsigned int dlen)
 {
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -1620,10 +1620,8 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
 	if (IS_ERR(idxd_desc)) {
-		dev_dbg(dev, "idxd descriptor allocation failed\n");
-		dev_dbg(dev, "iaa compress failed: ret=%ld\n",
-			PTR_ERR(idxd_desc));
-		return PTR_ERR(idxd_desc);
+		dev_dbg(dev, "iaa compress_verify failed: idxd descriptor allocation failure: ret=%ld\n", PTR_ERR(idxd_desc));
+		return -ENODEV;
 	}
 	desc = idxd_desc->iax_hw;
 
@@ -1635,19 +1633,11 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 	desc->priv = 0;
 
 	desc->src1_addr = (u64)dst_addr;
-	desc->src1_size = *dlen;
+	desc->src1_size = dlen;
 	desc->dst_addr = (u64)src_addr;
 	desc->max_dst_size = slen;
 	desc->completion_addr = idxd_desc->compl_dma;
 
-	dev_dbg(dev, "(verify) compression mode %s,"
-		" desc->src1_addr %llx, desc->src1_size %d,"
-		" desc->dst_addr %llx, desc->max_dst_size %d,"
-		" desc->src2_addr %llx, desc->src2_size %d\n",
-		active_compression_mode->name,
-		desc->src1_addr, desc->src1_size, desc->dst_addr,
-		desc->max_dst_size, desc->src2_addr, desc->src2_size);
-
 	ret = idxd_submit_desc(wq, idxd_desc);
 	if (ret) {
 		dev_dbg(dev, "submit_desc (verify) failed ret=%d\n", ret);
@@ -1670,14 +1660,10 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 		goto err;
 	}
 
-	idxd_free_desc(wq, idxd_desc);
-out:
-	return ret;
 err:
 	idxd_free_desc(wq, idxd_desc);
-	dev_dbg(dev, "iaa compress failed: ret=%d\n", ret);
 
-	goto out;
+	return ret;
 }
 
 static void iaa_desc_complete(struct idxd_desc *idxd_desc,
@@ -1757,7 +1743,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 		}
 
 		ret = iaa_compress_verify(ctx->tfm, ctx->req, iaa_wq->wq, src_addr,
-					  ctx->req->slen, dst_addr, &ctx->req->dlen);
+					  ctx->req->slen, dst_addr, ctx->req->dlen);
 		if (ret) {
 			dev_dbg(dev, "%s: compress verify failed ret=%d\n", __func__, ret);
 			err = -EIO;
@@ -1783,7 +1769,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	iaa_wq_put(idxd_desc->wq);
 }
 
-static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
+static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 			struct idxd_wq *wq,
 			dma_addr_t src_addr, unsigned int slen,
 			dma_addr_t dst_addr, unsigned int *dlen)
@@ -1810,9 +1796,9 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
 	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
 	if (IS_ERR(idxd_desc)) {
-		dev_dbg(dev, "idxd descriptor allocation failed\n");
-		dev_dbg(dev, "iaa compress failed: ret=%ld\n", PTR_ERR(idxd_desc));
-		return PTR_ERR(idxd_desc);
+		dev_dbg(dev, "iaa compress failed: idxd descriptor allocation failure: ret=%ld\n",
+			PTR_ERR(idxd_desc));
+		return -ENODEV;
 	}
 	desc = idxd_desc->iax_hw;
 
@@ -1838,21 +1824,8 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = true;
-
-		dev_dbg(dev, "%s use_async_irq: compression mode %s,"
-			" src_addr %llx, dst_addr %llx\n", __func__,
-			active_compression_mode->name,
-			src_addr, dst_addr);
 	}
 
-	dev_dbg(dev, "%s: compression mode %s,"
-		" desc->src1_addr %llx, desc->src1_size %d,"
-		" desc->dst_addr %llx, desc->max_dst_size %d,"
-		" desc->src2_addr %llx, desc->src2_size %d\n", __func__,
-		active_compression_mode->name,
-		desc->src1_addr, desc->src1_size, desc->dst_addr,
-		desc->max_dst_size, desc->src2_addr, desc->src2_size);
-
 	ret = idxd_submit_desc(wq, idxd_desc);
 	if (ret) {
 		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
@@ -1865,7 +1838,6 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
 	if (ctx->async_mode) {
 		ret = -EINPROGRESS;
-		dev_dbg(dev, "%s: returning -EINPROGRESS\n", __func__);
 		goto out;
 	}
 
@@ -1883,15 +1855,10 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
 	*compression_crc = idxd_desc->iax_completion->crc;
 
-	if (!ctx->async_mode)
-		idxd_free_desc(wq, idxd_desc);
-out:
-	return ret;
 err:
 	idxd_free_desc(wq, idxd_desc);
-	dev_dbg(dev, "iaa compress failed: ret=%d\n", ret);
-
-	goto out;
+out:
+	return ret;
 }
 
 static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
@@ -1920,10 +1887,10 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
 	if (IS_ERR(idxd_desc)) {
-		dev_dbg(dev, "idxd descriptor allocation failed\n");
-		dev_dbg(dev, "iaa decompress failed: ret=%ld\n",
+		ret = -ENODEV;
+		dev_dbg(dev, "%s: idxd descriptor allocation failed: ret=%ld\n", __func__,
 			PTR_ERR(idxd_desc));
-		return PTR_ERR(idxd_desc);
+		return ret;
 	}
 	desc = idxd_desc->iax_hw;
 
@@ -1947,21 +1914,8 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = false;
-
-		dev_dbg(dev, "%s: use_async_irq compression mode %s,"
-			" src_addr %llx, dst_addr %llx\n", __func__,
-			active_compression_mode->name,
-			src_addr, dst_addr);
 	}
 
-	dev_dbg(dev, "%s: decompression mode %s,"
-		" desc->src1_addr %llx, desc->src1_size %d,"
-		" desc->dst_addr %llx, desc->max_dst_size %d,"
-		" desc->src2_addr %llx, desc->src2_size %d\n", __func__,
-		active_compression_mode->name,
-		desc->src1_addr, desc->src1_size, desc->dst_addr,
-		desc->max_dst_size, desc->src2_addr, desc->src2_size);
-
 	ret = idxd_submit_desc(wq, idxd_desc);
 	if (ret) {
 		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
@@ -1974,7 +1928,6 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	if (ctx->async_mode) {
 		ret = -EINPROGRESS;
-		dev_dbg(dev, "%s: returning -EINPROGRESS\n", __func__);
 		goto out;
 	}
 
@@ -1996,23 +1949,19 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		}
 	} else {
 		req->dlen = idxd_desc->iax_completion->output_size;
+
+		/* Update stats */
+		update_total_decomp_bytes_in(slen);
+		update_wq_decomp_bytes(wq, slen);
 	}
 
 	*dlen = req->dlen;
 
-	if (!ctx->async_mode)
+err:
+	if (idxd_desc)
 		idxd_free_desc(wq, idxd_desc);
-
-	/* Update stats */
-	update_total_decomp_bytes_in(slen);
-	update_wq_decomp_bytes(wq, slen);
 out:
 	return ret;
-err:
-	idxd_free_desc(wq, idxd_desc);
-	dev_dbg(dev, "iaa decompress failed: ret=%d\n", ret);
-
-	goto out;
 }
 
 static int iaa_comp_acompress(struct acomp_req *req)
@@ -2059,9 +2008,6 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		goto out;
 	}
 	src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
-		" req->slen %d, sg_dma_len(sg) %d\n", src_addr, nr_sgs,
-		req->src, req->slen, sg_dma_len(req->src));
 
 	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
 	if (nr_sgs <= 0 || nr_sgs > 1) {
@@ -2072,9 +2018,6 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		goto err_map_dst;
 	}
 	dst_addr = sg_dma_address(req->dst);
-	dev_dbg(dev, "dma_map_sg, dst_addr %llx, nr_sgs %d, req->dst %p,"
-		" req->dlen %d, sg_dma_len(sg) %d\n", dst_addr, nr_sgs,
-		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_compress(tfm, req, wq, src_addr, req->slen, dst_addr,
 			   &req->dlen);
@@ -2089,7 +2032,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		}
 
 		ret = iaa_compress_verify(tfm, req, wq, src_addr, req->slen,
-					  dst_addr, &req->dlen);
+					  dst_addr, req->dlen);
 		if (ret)
 			dev_dbg(dev, "asynchronous compress verification failed ret=%d\n", ret);
 
@@ -2152,9 +2095,6 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		goto out;
 	}
 	src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
-		" req->slen %d, sg_dma_len(sg) %d\n", src_addr, nr_sgs,
-		req->src, req->slen, sg_dma_len(req->src));
 
 	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
 	if (nr_sgs <= 0 || nr_sgs > 1) {
@@ -2165,9 +2105,6 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		goto err_map_dst;
 	}
 	dst_addr = sg_dma_address(req->dst);
-	dev_dbg(dev, "dma_map_sg, dst_addr %llx, nr_sgs %d, req->dst %p,"
-		" req->dlen %d, sg_dma_len(sg) %d\n", dst_addr, nr_sgs,
-		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_decompress(tfm, req, wq, src_addr, req->slen,
 			     dst_addr, &req->dlen);
-- 
2.27.0


