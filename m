Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2A6ACAC5BA
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C6068E000D; Thu, 25 Sep 2025 23:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974D38E000C; Thu, 25 Sep 2025 23:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88BBB8E000D; Thu, 25 Sep 2025 23:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75A858E000C
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:35:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49042876BD
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:14 +0000 (UTC)
X-FDA: 83929985748.20.0C2AF09
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3C8AEC0004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TqxbjgWP;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758857712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=858jfz83lf2dK5sf5puAI0ZdMQu8FVFL5vISb3tcIU8=;
	b=ncM75eaRIJK/qnbxz0yscz/tk/Jikva5Zb3sDtc6tyVSEHtrdv49Yh3S3FeSeMTlNvviCB
	KRcjGFhZB6G2x4G0KoXuF1wfB7pzsfKefQSqDdvXqdmOyMk99g6IYvEopmZcioNPRW3b+L
	5uLlhaRa4gRriDC2I2pX1HP0fDChWXY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758857712; a=rsa-sha256;
	cv=none;
	b=mGZox7UcoyMD6uMYNNOZ8AsDiY6+1dip8tbCO/Y6zTmlbsIBYQSZmJx8RaPUaJpOe2BSQs
	m73oXt7dW51T8aUSlMzAMCB6ciu2hHpTVetGMF4cu3fxY23YCAyLnzXBFA5qTK7I6DJO2c
	tbK4Qj+BINeeEV1lVVxnFHwEIk0Llxc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TqxbjgWP;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857712; x=1790393712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ABrWTOP2f/rtttjKCvKr6tV1H34crqihnx6D1RT2A1I=;
  b=TqxbjgWPCOtCjafkMzhuym9sqTIrAWd2EI+OIpVL0BoRid6Jo44USJCn
   rO9lNQR8XK1fF6RUWnNe+XbHa4Vyf4nZNifZLwSZmNenKuJ+SHqSkTxmh
   viPxaFpe6DgWf6DVInmBYpDSHPL4N/tGBhqxPu02ROstId+XejCtVYVBH
   EGiOw2As4i5Yn8x48S3zoMEiB0+st3Ch7L8mN6T375uHBhHTAccWSxRKw
   7nfzwPLWxmLaMKjsoM0qu2yuUTyYsbrxHn2CzNmtSw9Etp0Ot2PEQqhxI
   8wNhYnkYRPAW09pREuqjUKWOyy0twjM08pXblznxa4KjY4qW7KgJYagBK
   g==;
X-CSE-ConnectionGUID: hHDexuiDSaeqpiYadjeJzA==
X-CSE-MsgGUID: sPN06oOfRfWljr1X+B+Vvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819488"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819488"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:05 -0700
X-CSE-ConnectionGUID: vWeSZrnxQDS2LHhJdcvsXA==
X-CSE-MsgGUID: gfY3r1/0RoWmrVc8P/eIIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636565"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:03 -0700
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
Subject: [PATCH v12 06/23] crypto: iaa - Simplify the code flow in iaa_compress() and iaa_decompress().
Date: Thu, 25 Sep 2025 20:34:45 -0700
Message-Id: <20250926033502.7486-7-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3C8AEC0004
X-Stat-Signature: naozsowa4snip7hfzi3kazjpcxq6oo4y
X-Rspam-User: 
X-HE-Tag: 1758857712-87823
X-HE-Meta: U2FsdGVkX1+Pc0dTtwWrL6+6UFdV7WZUtgamEn5v0GxbJJo1u+uw+MiunLIlVwglHkHJqWo8MRq3xtn1ggluUkNChXjs8QlHXD2FjS32FKgxjHcc7Xjim75ZKsRgBdrLts6mwzazKIva2E4CKH5pxqhUoBc+SeP7fRpy7OiKNQdQ8grr94mHVKu2UmSMCQy5e1AAspu6CexZxSdpH0I6LCejVgsW57JoJbgSpDR0uNNxaaJaHii5++rz3cik6U1+eKaRoqg7L28OVxoUdulFxQSyFsnrVEg/KqGBSiZywplgvplTBNxnUMvEU0/yoYEpLURsSUVPcNLDlFuC1k8Z+B5ZdNyVayH9t123fLSOwA309oPe0B0e/KsMHkchCxhSXI6JTtPgSmAM2E0jgZBETusWXFBu8laOFT6dUjuzrUqzhjaepNMc3yuFargpL0d4JIY2wgagMlHNv8D4VhSKWIFlqrNcrmfmAiBEGx6ayaPXmifuVer215+0DrjsbDMZ+sMPmDOLYlM9E6DdaGz4+zd7gsDyzqY/JcP6jaLzzClrJCoOQ7VXjeKtjhTvgZzOI+XJY+0g9xYLTqwo88L6piJZdz4QRYWsnGh6MtqbiiyfwO22Ufal0vOC2MPKA3xrqUGZa5hd23GBVTXvnfI+XHy1iMIDFYOcYSVrR88oz5SIw0ufFG/C6+sLQca+kNdjgKCNG42SZubduPJ/fzFHY77dfO3cW572yJfvG9iwKq5qooU1MpsKOXebwYl+s+3QDkz0zfBtWNbq8RMR3W3bNzGJMbMT3rhMHtcgdKzhylrnLZqwiD13LbLQ1dP0C+A7WCaKAMRTlokRLgx9LN0PJQnTcWq+2LfIyLC6Q34+K8Oqh9O5Sw/YIgTdz71U9SIGx6RBgM8rtLP8FG8+ggkjX34M9mrNjpvmznZU3jHpn5PaXMVUJlg8xDgQhWUEi9C/i4+Jyce2wG1uWJzHGbP
 HlIcxg0k
 XRDJ5e0N3A6nr205nCdvHFclYJVz3papASNaBAKFh1/ZHNwq/xHOtk895vsAjERjFGkx1vtUWTVsGGClsAWh5RdM+NrrZZcmAa8Z08COMsoW3ajZnMBdOGaOvsT7FtOVvsBmGmGmxLyZXnVlgzFtNWl2y6KomXew3toFDYIVa1Dw/CG9TW+sF0JZvsFwR7DGtQCPkOKAs1Ycb7QUUr9TQXFx3GODdp76s1b2K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit simplifies and streamlines the logic in the core
iaa_compress() and iaa_decompress() routines, eliminates branches, etc.

This makes it easier to add improvements such as polling for job
completions, essential to accomplish batching with hardware
parallelism.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 114 ++++++++++++---------
 1 file changed, 67 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 5cb7c930158e..38b4be0c10b0 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1792,7 +1792,34 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 	desc->src2_size = sizeof(struct aecs_comp_table_record);
 	desc->completion_addr = idxd_desc->compl_dma;
 
-	if (ctx->use_irq) {
+	if (likely(!ctx->use_irq)) {
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto out;
+		}
+
+		/* Update stats */
+		update_total_comp_calls();
+		update_wq_comp_calls(wq);
+
+		if (ctx->async_mode)
+			return -EINPROGRESS;
+
+		ret = check_completion(dev, idxd_desc->iax_completion, true, false);
+		if (ret) {
+			dev_dbg(dev, "check_completion failed ret=%d\n", ret);
+			goto out;
+		}
+
+		*dlen = idxd_desc->iax_completion->output_size;
+
+		/* Update stats */
+		update_total_comp_bytes_out(*dlen);
+		update_wq_comp_bytes(wq, *dlen);
+
+		*compression_crc = idxd_desc->iax_completion->crc;
+	} else {
 		desc->flags |= IDXD_OP_FLAG_RCI;
 
 		idxd_desc->crypto.req = req;
@@ -1800,40 +1827,23 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = true;
-	}
-
-	ret = idxd_submit_desc(wq, idxd_desc);
-	if (ret) {
-		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-		goto err;
-	}
 
-	/* Update stats */
-	update_total_comp_calls();
-	update_wq_comp_calls(wq);
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto out;
+		}
 
-	if (ctx->async_mode) {
-		ret = -EINPROGRESS;
-		goto out;
-	}
+		/* Update stats */
+		update_total_comp_calls();
+		update_wq_comp_calls(wq);
 
-	ret = check_completion(dev, idxd_desc->iax_completion, true, false);
-	if (ret) {
-		dev_dbg(dev, "check_completion failed ret=%d\n", ret);
-		goto err;
+		return -EINPROGRESS;
 	}
 
-	*dlen = idxd_desc->iax_completion->output_size;
-
-	/* Update stats */
-	update_total_comp_bytes_out(*dlen);
-	update_wq_comp_bytes(wq, *dlen);
-
-	*compression_crc = idxd_desc->iax_completion->crc;
-
-err:
-	idxd_free_desc(wq, idxd_desc);
 out:
+	idxd_free_desc(wq, idxd_desc);
+
 	return ret;
 }
 
@@ -1888,7 +1898,22 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	desc->src1_size = slen;
 	desc->completion_addr = idxd_desc->compl_dma;
 
-	if (ctx->use_irq) {
+	if (likely(!ctx->use_irq)) {
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto fallback_software_decomp;
+		}
+
+		/* Update stats */
+		update_total_decomp_calls();
+		update_wq_decomp_calls(wq);
+
+		if (ctx->async_mode)
+			return -EINPROGRESS;
+
+		ret = check_completion(dev, idxd_desc->iax_completion, false, false);
+	} else {
 		desc->flags |= IDXD_OP_FLAG_RCI;
 
 		idxd_desc->crypto.req = req;
@@ -1896,25 +1921,20 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = false;
-	}
 
-	ret = idxd_submit_desc(wq, idxd_desc);
-	if (ret) {
-		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-		goto fallback_software_decomp;
-	}
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto fallback_software_decomp;
+		}
 
-	/* Update stats */
-	update_total_decomp_calls();
-	update_wq_decomp_calls(wq);
+		/* Update stats */
+		update_total_decomp_calls();
+		update_wq_decomp_calls(wq);
 
-	if (ctx->async_mode) {
-		ret = -EINPROGRESS;
-		goto out;
+		return -EINPROGRESS;
 	}
 
-	ret = check_completion(dev, idxd_desc->iax_completion, false, false);
-
 fallback_software_decomp:
 	if (ret) {
 		dev_dbg(dev, "%s: desc allocation/submission/check_completion failed ret=%d\n", __func__, ret);
@@ -1929,7 +1949,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		if (ret) {
 			pr_err("%s: iaa decompress failed: deflate-generic fallback error ret=%d\n",
 			       __func__, ret);
-			goto err;
+			goto out;
 		}
 	} else {
 		req->dlen = idxd_desc->iax_completion->output_size;
@@ -1941,10 +1961,10 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	*dlen = req->dlen;
 
-err:
+out:
 	if (idxd_desc)
 		idxd_free_desc(wq, idxd_desc);
-out:
+
 	return ret;
 }
 
-- 
2.27.0


