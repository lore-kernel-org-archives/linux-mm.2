Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC21FC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F1B06B0093; Fri,  1 Aug 2025 00:36:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CAA76B0096; Fri,  1 Aug 2025 00:36:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F4C6B0095; Fri,  1 Aug 2025 00:36:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 432DB6B0093
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:36:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D608F1A0CAB
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:50 +0000 (UTC)
X-FDA: 83726928180.10.8766B34
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id BFB3640002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=USCptd3K;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QjCWMiXUzVsho+L/MkjramAy9iwQhQ7x9IIkxm310pk=;
	b=qeoGajRwdaOwieJcEEU4frEfT/Pi5rwLmY0zaQEuqwBmcPRY/c7BPgjLTFli+btPOkBLTI
	MnvGK97wU6QgS5YO3bxcC03jbRYEaFRkyIkFK1bfHFbO5hhGZN5RO8PHBvf7qPZRap0UGF
	9IyjAw8Uy322uwFIMW+4aPii69sKRfM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023009; a=rsa-sha256;
	cv=none;
	b=nXY2SGJRd/0BdblnWw7dvxzhcvVRNvr/VIL0Fq8+Ovs5YqKzzV9uBSH/skxSHa+i4V7H1Y
	LxLdvX6jW0z52Tl1ioKsNwEodcJpBA9nqHMYo9P2sB9IokaMaowqzzwygMBaV4HvePurd/
	e2oSkwmFhwNe/adKN7L0RqccK2D/WMc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=USCptd3K;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023009; x=1785559009;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fMrb/PuPQ+UKs6MUav0oTfeMY0ykBikhZCJCGvSTauY=;
  b=USCptd3KAhgH8JWgvG6y+WrP+8dzC/VsoEWsN1UFOFA172rUDt/LsXaI
   z6NPWrxt1ng3irNP40fqYg4D9Wi8WppCYyceGs4K6qHj5kh2vQN0XTHGv
   +F2ZHEqth1+md/a8fyvnvEYj+pupXWvsfh56BT/sX9yOtPUDULUbL6sPd
   NIPb6B1ihj6Siua7o1zG4uQEBgBaxK+mPhieaCCASp8Tf1qjrN43ps5pC
   QS7NpKH4SvDnKRs39blSfDmH3zh28eRdFsCPnTSN0zd1YWN4fbjukf4VL
   OeNM8rF/MsVvwNPCNr26vPvfkeQZALWhRZtxjxpAbn3/iFquJZ1j3lELu
   g==;
X-CSE-ConnectionGUID: wPq909KKSjK/YgkD0hvqKA==
X-CSE-MsgGUID: 9sq0QIsySaimv0B+4KkWXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820180"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820180"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:44 -0700
X-CSE-ConnectionGUID: XvUMAi7iSKOQbBalD1WFgw==
X-CSE-MsgGUID: 5qZAAxefTmGEOzKcjCI8lQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796234"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:43 -0700
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
Subject: [PATCH v11 04/24] crypto: iaa - Descriptor allocation timeouts with mitigations.
Date: Thu, 31 Jul 2025 21:36:22 -0700
Message-Id: <20250801043642.8103-5-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BFB3640002
X-Stat-Signature: mjmcnkigdrbmqmkngq53ey9c1499cmq7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754023008-909155
X-HE-Meta: U2FsdGVkX18O11IzDnl/ji5cnYSBkFXsufvNS/eMKOkmsdqsMY5R3++EbtesIWOUxl/4cZX9TX5J31LM9g7HzFtQhmPFOMXaZmZkWncsdfIfVSC7vet87SlYlABtMUcLh87Y/749ALsbfP9iGtJNo2OZE23jqymZlMtqHaaAQxjR/AyUIIcXTsG7bKKV4MnT0fLafTtrsT7UBzIuXnTEJ/TgvFAMtetUBsfxsNo7/bDYTldR9fKx0lu7pnx7w+3wP4XpgTqaIQ5o9eUY9nybRYyrnVFDt5s/cOYZ4xFuIKT7GITv/9xRWXppo7L2VxszTU6vrewEgjksArKCLoYQnkvLtKrdRqpuwCPqlpfgfQIUnL6qBPs1hMXdtM1MqU5q29+SCbq4E0a6OIVABLaqpHd+kyMzlEVrmS9o60oi/yJKoMQD0tDKm4dLZXF6KScrR5atmhtZRiIV8FqIIqyveFfQar4dLDNREwM3AVLbAKLzd9QbdtC0RRk8O+bQ5i6T8Hi3LX3UI9TFT7EMQzaqMu8btPg8+hfb9G3OIWFnIGAUOQfUXfmbyPEB4X3edeMFBzJIbWXJqpua33Cy3asgNiwnVimMeVbeJ21Oq/qqDtAa4kWUKuKg+GKLswGHhcZlRajOWrU0aFNXFD+kTS9qXP6Xes2tdsQboueSBfel9/PiM2VbJfdUTX0j99gaI4a+cnw7+5MXwYfjsmKTWf7BboHx4PeJLXYpyVnqWtWXUCVsXvIZyXSC/OHDjlRx3nNe8j13NolQbCGkvIG9TZ8L4RHaP3id5fwJVXz8QxK+qaSAPvYpWij3ipo8LFxeIOfhABVPZdgJWXejdczQ/e977Bg0n15JTkd4a3m7BWbaivo4JqwbJPLu+k9B0bBahuWFwKGjP5hIHgNZsi6FqJBRDjF23KIz1Syl+CtqQQ8Mav3HBgg4fARSEDFDZ5Fe/xa2FYBAFHKyRbtqXhb/ev2
 9y1xCuUw
 kWtoPYYFYSmpmyopmK8zizxoNYtXn+jTQyJYdA+kYXsbIfiCEdLExRf7duzExWXuYsL3yyt/dLpWx+uD2Km8tgmNaitBb12U5bB4dwveRTQe1Ypq3zxEo27j/vjlsSDe1uAYKlNYDI8O5V1CNNDMYQSwbRGnOCktLVUNgyHsapYPDzV6fF9DhkmH9uw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch modifies the descriptor allocation from blocking to
non-blocking with bounded retries or "timeouts".

This is necessary to prevent task blocked errors in high contention
scenarios, for instance, when the platform has only 1 IAA device
enabled. With 1 IAA device enabled per package on a dual-package
Sapphire Rapids with 56 cores/package, there are 112 logical cores
mapped to this single IAA device. In this scenario, the task blocked
errors can occur because idxd_alloc_desc() is called with
IDXD_OP_BLOCK. With batching, multiple descriptors will need to be
allocated per batch. Any process that is able to do so, can cause
contention for allocating descriptors for all other processes that share
the use of the same sbitmap_queue. Under IDXD_OP_BLOCK, this causes
compress/decompress jobs to stall in stress test scenarios
(e.g. zswap_store() of 2M folios).

In order to make the iaa_crypto driver be more fail-safe, this commit
implements the following:

1) Change compress/decompress descriptor allocations to be non-blocking
   with retries ("timeouts").
2) Return compress error to zswap if descriptor allocation with timeouts
   fails during compress ops. zswap_store() will return an error and the
   folio gets stored in the backing swap device.
3) Fallback to software decompress if descriptor allocation with timeouts
   fails during decompress ops.

With these fixes, there are no task blocked errors seen under stress
testing conditions, and no performance degradation observed.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto.h      |  5 ++
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 58 +++++++++++++++-------
 2 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index 549ac98a9366e..cc76a047b54ad 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -21,6 +21,9 @@
 
 #define IAA_COMPLETION_TIMEOUT		1000000
 
+#define IAA_ALLOC_DESC_COMP_TIMEOUT	   1000
+#define IAA_ALLOC_DESC_DECOMP_TIMEOUT	    500
+
 #define IAA_ANALYTICS_ERROR		0x0a
 #define IAA_ERROR_DECOMP_BUF_OVERFLOW	0x0b
 #define IAA_ERROR_COMP_BUF_OVERFLOW	0x19
@@ -141,6 +144,8 @@ enum iaa_mode {
 
 struct iaa_compression_ctx {
 	enum iaa_mode	mode;
+	u16		alloc_comp_desc_timeout;
+	u16		alloc_decomp_desc_timeout;
 	bool		verify_compress;
 	bool		async_mode;
 	bool		use_irq;
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index ed3325bb32918..1169cd44c8e78 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1596,7 +1596,8 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
-	struct idxd_desc *idxd_desc;
+	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
+	u16 alloc_desc_retries = 0;
 	struct iax_hw_desc *desc;
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
@@ -1612,7 +1613,11 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
 
-	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
+	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_decomp_desc_timeout)) {
+		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
+		cpu_relax();
+	}
+
 	if (IS_ERR(idxd_desc)) {
 		dev_dbg(dev, "iaa compress_verify failed: idxd descriptor allocation failure: ret=%ld\n", PTR_ERR(idxd_desc));
 		return -ENODEV;
@@ -1772,7 +1777,8 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
-	struct idxd_desc *idxd_desc;
+	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
+	u16 alloc_desc_retries = 0;
 	struct iax_hw_desc *desc;
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
@@ -1788,7 +1794,11 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
 
-	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
+	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_comp_desc_timeout)) {
+		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
+		cpu_relax();
+	}
+
 	if (IS_ERR(idxd_desc)) {
 		dev_dbg(dev, "iaa compress failed: idxd descriptor allocation failure: ret=%ld\n",
 			PTR_ERR(idxd_desc));
@@ -1863,7 +1873,8 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct iaa_device *iaa_device;
-	struct idxd_desc *idxd_desc;
+	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
+	u16 alloc_desc_retries = 0;
 	struct iax_hw_desc *desc;
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
@@ -1879,12 +1890,17 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
 
-	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
+	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_decomp_desc_timeout)) {
+		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
+		cpu_relax();
+	}
+
 	if (IS_ERR(idxd_desc)) {
 		ret = -ENODEV;
 		dev_dbg(dev, "%s: idxd descriptor allocation failed: ret=%ld\n", __func__,
 			PTR_ERR(idxd_desc));
-		return ret;
+		idxd_desc = NULL;
+		goto fallback_software_decomp;
 	}
 	desc = idxd_desc->iax_hw;
 
@@ -1913,7 +1929,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	ret = idxd_submit_desc(wq, idxd_desc);
 	if (ret) {
 		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-		goto err;
+		goto fallback_software_decomp;
 	}
 
 	/* Update stats */
@@ -1926,19 +1942,21 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	}
 
 	ret = check_completion(dev, idxd_desc->iax_completion, false, false);
+
+fallback_software_decomp:
 	if (ret) {
-		dev_dbg(dev, "%s: check_completion failed ret=%d\n", __func__, ret);
-		if (idxd_desc->iax_completion->status == IAA_ANALYTICS_ERROR) {
+		dev_dbg(dev, "%s: desc allocation/submission/check_completion failed ret=%d\n", __func__, ret);
+		if (idxd_desc && idxd_desc->iax_completion->status == IAA_ANALYTICS_ERROR) {
 			pr_warn("%s: falling back to deflate-generic decompress, "
 				"analytics error code %x\n", __func__,
 				idxd_desc->iax_completion->error_code);
-			ret = deflate_generic_decompress(req);
-			if (ret) {
-				dev_dbg(dev, "%s: deflate-generic failed ret=%d\n",
-					__func__, ret);
-				goto err;
-			}
-		} else {
+		}
+
+		ret = deflate_generic_decompress(req);
+
+		if (ret) {
+			pr_err("%s: iaa decompress failed: deflate-generic fallback error ret=%d\n",
+			       __func__, ret);
 			goto err;
 		}
 	} else {
@@ -2119,6 +2137,8 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 
 static void compression_ctx_init(struct iaa_compression_ctx *ctx)
 {
+	ctx->alloc_comp_desc_timeout = IAA_ALLOC_DESC_COMP_TIMEOUT;
+	ctx->alloc_decomp_desc_timeout = IAA_ALLOC_DESC_DECOMP_TIMEOUT;
 	ctx->verify_compress = iaa_verify_compress;
 	ctx->async_mode = async_mode;
 	ctx->use_irq = use_irq;
@@ -2133,10 +2153,10 @@ static int iaa_comp_init_fixed(struct crypto_acomp *acomp_tfm)
 	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	compression_ctx_init(ctx);
-
 	ctx->mode = IAA_MODE_FIXED;
 
+	compression_ctx_init(ctx);
+
 	return 0;
 }
 
-- 
2.27.0


