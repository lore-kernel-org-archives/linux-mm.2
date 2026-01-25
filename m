Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC7DE63C81
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95FA46B0092; Sat, 24 Jan 2026 22:35:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DFCA6B0095; Sat, 24 Jan 2026 22:35:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797986B0096; Sat, 24 Jan 2026 22:35:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA456B0092
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:35:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D618589A0
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:49 +0000 (UTC)
X-FDA: 84369072018.24.3E07811
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf25.hostedemail.com (Postfix) with ESMTP id D2C1CA0003
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NGz1iMzC;
	spf=pass (imf25.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=++lVG9V5pBBEbimLfPy1NZaH7UzAS/jgoCmYes8wCos=;
	b=FbvCCHsSceiNNsRfWR3Pe/mrLfX5W501tgeZp1oXrnNB4+atFnl7U5jBI4qzu+giYuk02E
	I2kJQo6SUu20d0k/IGdqzw4C7nXUb7toM87NTD8QW7yKzduBWjCl2/797RPMBz4yjOqlXp
	3BogIL+HOg9gHm1d6QnhQy15mp0u+Tk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NGz1iMzC;
	spf=pass (imf25.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312147; a=rsa-sha256;
	cv=none;
	b=y0p8o08P9gVXRMwzyai3ti/vKzO6/27WRaQnszQIJgEGkqtZbJ0cHf+pJVmpeZGHxzphz/
	FSaKdrbQdOhSo/tEq5W0Fl8XRKHeue3F7pC2jWr+nnQEbcICXXrhyzVwMQowU1Z+QeMXsG
	TkfX4lVFt2K2QFYUTdiWF1KfKZwBmLs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312147; x=1800848147;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8qEnUscBAhTGBThTZr2YCrnOoiRxGamC5eXnrBE4hU8=;
  b=NGz1iMzCU+nI7Q3r/K5r0pdZ4rRqJk2UNCCXYx+TQvg0QZEd1GfeO5l8
   2BjkulAG0TyKetb1FiUCd/ga0/6Hihmu+qlkLxbzdZlkuJUZiC620btoQ
   bPDxqicgCh7XBSnjt6sdSQG0Xw9gKuQxQD803ihEKXxF2cZ1E/5gIvslD
   zDuHnSET0yugVu03xU24/Jv6GlvN+zissYyGPaZu4bBawuVYeev7nrVgk
   tbLdTD6sqo945wmfjJSUUO5l0oIq9oAbI0NbNen2T7th5jXnhinuUnc+i
   RzAgFro1Rpzj+jITrmzLrJnVMM4M9W15yOqPRi3ZGHLz76rvAShBZpoxX
   A==;
X-CSE-ConnectionGUID: q3Wp+w8kQhuPrU5ArM9EnA==
X-CSE-MsgGUID: n6mXn4vKSgSORWrfGaENkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887351"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887351"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:45 -0800
X-CSE-ConnectionGUID: Ar+EX0NlRCWKU7IuF+LYuQ==
X-CSE-MsgGUID: A4gimB/pRAGgGA38uNPl9Q==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:44 -0800
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
Subject: [PATCH v14 04/26] crypto: iaa - Simplify, consistency of function parameters, minor stats bug fix.
Date: Sat, 24 Jan 2026 19:35:15 -0800
Message-Id: <20260125033537.334628-5-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bdweqkbo3qi3jjxs7qg6wt67jiupt3u1
X-Rspamd-Queue-Id: D2C1CA0003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769312146-926823
X-HE-Meta: U2FsdGVkX1+9Eu9FJL8ZTcRPl5MR8jom9dIA9mlTY95PM3FpCFLcNrMwqy+2D9iqYjPXCe4f480xWSHXL+/WilXDUpfbeB2z4w1iZchDrTqdq9EiWH15Fh9ZmoXs7iLnMqtkhysY2lrgq9Vb93PYNw+pX8rMFc9/3uVNnMczvjccIns/868DWbJVMuBHXflHSlHNRjWksDOzkYAuCfKaysqeabYhiyoDdPI5YpCPxAuefFzfx5ETxiBeFS+unYEgPHSOxMjD3XD+dO94RqpQJ7IPTNxgvnsufrahaCTd+8bNGGsQFtDd4OtfVw3IMrXy2Cg3H6tSM3NsXTqqvOPNNGoHnkdMMjaDaT5uk3w2apjH6Gbjc0jr10sIqadQq4wZv3BGXdjYxgsigFEYk/6OlQ4Qxo4tBQdl2scPjtMdU/DavW4HYuBe4dlyR6c7mDrY+HQvvtbALkPQK37BhLTdq3EEXscMIuWXwkwddD5QzfHgIRdwejuvQgZtugW3t3c7DO3lOIIu+0fYPjD18IZxXi14yy9xGMQzfp/5rSSK7NqN3K+97iGaY3W/8jqmYEOPhouYesckss5nbrYC1c60xQdfxnxXgLNoHq4FDc2/NDkC6NqHusHUWHaHdZBs551KWWzBm+yTO8Byt11YeDYJALv+yRmUkioni8tKtZxZJFisbagz0rq3xtZ9dy6HpvTAxXi1ndfbJwgIL8+XwlCmftOMVRCcwMKc/acwEUaSmzzkG4BGWB7sYAdoWzhvmn1wdR3f7SAHTERJS7Y07ralhTLzbxKlLds9KYvxQgyd6C+3eSM9MPEtSFFv093aboKOAP9y8zRgVGB1UMaU9eyO7FMytEIhbyoMLbPbGVG+Jsjnj3cX5/TPNjx5Pqfp9Kq8PjV8AOfaJJUSnFojZYraTTERP/0RiCJevv7O1gXr92idEQF+39uavZt9htNv512PChnMqBiDYuQ9KRMHlnD
 anPU5+7U
 r1LbEMk210EUiyQb8xx7+NFjxOGTAyzHcrpAE97t9d4ghLgks1GYRCIHQNDMDDbmEJ1GHAlbVq3aJshVX7baDL1r++ZaJkS8Kx9wTLTy7edEcWYuZh9QhztP9Akdg2aPk+2zDhBYUbkCcWwGf4jGgD/pm9TOilKHl2nbuvqycPXvl35D29a3lisZGAg==
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

6) Change some dev_dbg() statements related to verify compress errors
   to instead be pr_err().

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 114 +++++----------------
 1 file changed, 26 insertions(+), 88 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 85944ff212e5..bbc72254982c 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1597,7 +1597,7 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 			       struct idxd_wq *wq,
 			       dma_addr_t src_addr, unsigned int slen,
-			       dma_addr_t dst_addr, unsigned int *dlen)
+			       dma_addr_t dst_addr, unsigned int dlen)
 {
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -1621,10 +1621,8 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 
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
 
@@ -1636,19 +1634,11 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1671,14 +1661,10 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1752,15 +1738,15 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 
 		ret = iaa_remap_for_verify(dev, iaa_wq, ctx->req, &src_addr, &dst_addr);
 		if (ret) {
-			dev_dbg(dev, "%s: compress verify remap failed ret=%d\n", __func__, ret);
+			pr_err("%s: compress verify remap failed ret=%d\n", __func__, ret);
 			err = -EIO;
 			goto out;
 		}
 
 		ret = iaa_compress_verify(ctx->tfm, ctx->req, iaa_wq->wq, src_addr,
-					  ctx->req->slen, dst_addr, &ctx->req->dlen);
+					  ctx->req->slen, dst_addr, ctx->req->dlen);
 		if (ret) {
-			dev_dbg(dev, "%s: compress verify failed ret=%d\n", __func__, ret);
+			pr_err("%s: compress verify failed ret=%d\n", __func__, ret);
 			err = -EIO;
 		}
 
@@ -1774,7 +1760,8 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	dma_unmap_sg(dev, ctx->req->src, sg_nents(ctx->req->src), DMA_TO_DEVICE);
 out:
 	if (ret != 0)
-		dev_dbg(dev, "asynchronous compress failed ret=%d\n", ret);
+		dev_dbg(dev, "asynchronous %s failed ret=%d\n",
+			ctx->compress ? "compress":"decompress", ret);
 
 	if (ctx->req->base.complete)
 		acomp_request_complete(ctx->req, err);
@@ -1784,7 +1771,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	iaa_wq_put(idxd_desc->wq);
 }
 
-static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
+static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 			struct idxd_wq *wq,
 			dma_addr_t src_addr, unsigned int slen,
 			dma_addr_t dst_addr, unsigned int *dlen)
@@ -1811,9 +1798,9 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
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
 
@@ -1839,21 +1826,8 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
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
@@ -1866,7 +1840,6 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
 	if (ctx->async_mode) {
 		ret = -EINPROGRESS;
-		dev_dbg(dev, "%s: returning -EINPROGRESS\n", __func__);
 		goto out;
 	}
 
@@ -1884,15 +1857,10 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
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
@@ -1921,10 +1889,10 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
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
 
@@ -1948,21 +1916,8 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1975,7 +1930,6 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	if (ctx->async_mode) {
 		ret = -EINPROGRESS;
-		dev_dbg(dev, "%s: returning -EINPROGRESS\n", __func__);
 		goto out;
 	}
 
@@ -1997,23 +1951,19 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -2060,9 +2010,6 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		goto out;
 	}
 	src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
-		" req->slen %d, sg_dma_len(sg) %d\n", src_addr, nr_sgs,
-		req->src, req->slen, sg_dma_len(req->src));
 
 	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
 	if (nr_sgs <= 0 || nr_sgs > 1) {
@@ -2073,9 +2020,6 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		goto err_map_dst;
 	}
 	dst_addr = sg_dma_address(req->dst);
-	dev_dbg(dev, "dma_map_sg, dst_addr %llx, nr_sgs %d, req->dst %p,"
-		" req->dlen %d, sg_dma_len(sg) %d\n", dst_addr, nr_sgs,
-		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_compress(tfm, req, wq, src_addr, req->slen, dst_addr,
 			   &req->dlen);
@@ -2090,7 +2034,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		}
 
 		ret = iaa_compress_verify(tfm, req, wq, src_addr, req->slen,
-					  dst_addr, &req->dlen);
+					  dst_addr, req->dlen);
 		if (ret)
 			dev_dbg(dev, "asynchronous compress verification failed ret=%d\n", ret);
 
@@ -2153,9 +2097,6 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		goto out;
 	}
 	src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
-		" req->slen %d, sg_dma_len(sg) %d\n", src_addr, nr_sgs,
-		req->src, req->slen, sg_dma_len(req->src));
 
 	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
 	if (nr_sgs <= 0 || nr_sgs > 1) {
@@ -2166,9 +2107,6 @@ static int iaa_comp_adecompress(struct acomp_req *req)
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


