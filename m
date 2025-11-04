Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC49BCCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66C68E010A; Tue,  4 Nov 2025 04:12:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17048E0109; Tue,  4 Nov 2025 04:12:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90578E010A; Tue,  4 Nov 2025 04:12:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B4B5E8E0109
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80E0D12B950
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:42 +0000 (UTC)
X-FDA: 84072359364.11.C0A63DC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf11.hostedemail.com (Postfix) with ESMTP id 63C2C40013
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jbxnXelk;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247560; a=rsa-sha256;
	cv=none;
	b=VIiEKRrQYYYF2Tn+8cLbybSffd44xg0+O5EFCEp1O4VFk5UdlTfK99khILXkCY3CbWE92B
	5vGdZqI5h8WSVvHgVCHO15LmTJPsgULmHrubca0XA0kgzrWiV2/F0bQnqe+UFZmJ5vPm6b
	2blxuwBcoIwmIbA9FLALo2ogwTQRFr4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jbxnXelk;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkeWjXB6MAbCLMQmfb7hupBbf1BvnbkG62WN+HpcbHY=;
	b=zf+N7S4tEqLzeHxXazBoDWIuSvbomYmPnXpFRiPqsTAWwN0FV9kIHsrqHxgaFn2PRfRb8c
	7zpAluzG1JJCtDsvIGXn5rAvbP/DRO9aOk6fz6bMYxWPe7JuGObFEssNGFURrODnCCBJg3
	OcHJDmAHLab1JP97PrfhsXLGR7EmJQU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247560; x=1793783560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uknpE8VMoJmFrFc9hOoaqzCVgRiwBhnyr7a2KMGbfxE=;
  b=jbxnXelk/CbSCvjzfwILA7T+EOe1vVtG62tqeIqx2q72S2PduNmC/yOj
   O38bKJolzC5Tvu3POR5dHWO7FaHBwBpaeHeZEgeAx/xYofP96oYfl+cW/
   h8UhDUvmHGYkJPogNYBlxQr295ogHbjjxb+M3f7Ig31MxPqm71ScHYvBb
   jK3x/x3dARbJ65hm7LSHpuuOJoP0wdDxehWp2nDKeHBEWW4bSf+FotL+R
   WW3bTXlu86E+7uBBfZ4rhzUNeoUWzSP0ykYPo/Gqy9IG2SBwtYYgOmKqu
   /Bwt+vGhublTo/ZpjUFlSwyax4n1c/94+2ErENf84laE2IPtiiMkFHL3r
   A==;
X-CSE-ConnectionGUID: 7ri8Qa0YTcqyIZfSSlAPqg==
X-CSE-MsgGUID: iirjqy/fS3iE5x/C+UPsSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265170"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265170"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:37 -0800
X-CSE-ConnectionGUID: ydEucLK2Qlq/OFcpWRQf+A==
X-CSE-MsgGUID: FRqJEPPDRdSINjQHBgxntg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795785"
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
Subject: [PATCH v13 04/22] crypto: iaa - Descriptor allocation timeouts with mitigations.
Date: Tue,  4 Nov 2025 01:12:17 -0800
Message-Id: <20251104091235.8793-5-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 63C2C40013
X-Stat-Signature: 7jm65dp3nhh4wdmu9uaatypcwbxo8sub
X-HE-Tag: 1762247560-795259
X-HE-Meta: U2FsdGVkX192JTrm9dysm/5uRNIeEItmQWOd1LJ4JVYUCIwiwhUaubymnztXlXEtd3EQzm5yfcSI5zdpxuGeZXs2bebpV0M7atx0cpFmU4fpjzpAw1Y8pkJLYpQxtqIL+BpxfOiiqjOTldJR/UVBfdTQxrtklNXCBmvsPqMbKcuzTjUXGiaLtUXspSVN61sDklJ0ZxXUtN9iu/wZEqrHsCfQUYOS5C6lShA+tGMmgM4gOY5E/QvnWb5XwcJYdsZw9UwCZ1zK1AOBp9hlSpnZ19pEwDoJC6fATeyc+PJfPKt08i8T4COo4qfowgnuEylQqrff4frw0vgr+hhTQBpkj+HCItTPjKAFBj/ptHSj8W77pCo9zlc/Ji32XoKZLZoVbNx5CEPFTrzFXHluF/kba5RORsqo6Phze0dG8JirnCqEcxe0JLRZn4BpPXtzZ97xJ2NDlJqiokgZC3wd/yX+5N1/12mIk8oY/SCWR/y3ixVv6a0jWdQigodZF2bAd+i8qtBSJEHfym0+yw5ZTFWNSvqahgYhkGkSfO4b9VHC4x2oJwJrGYR0SeAk3NdwmFaRN8iyWLYRCYM5Y72FucMuKaSdoPknMggi4yy/65Dwo+45fOQwLJgyv5KAkFL14vNGED0vXtK1ugHJO8EymjYwdv4CRTpDdRtGO22VG9zIhf3XHmDkd77eGA264E1ra/LYtNHpZ6RFKMYzspUN+pNDNUF45VGrlCTWJkpI5q6kTkLvkjym/14STgHq6UaB0h1EAwoVLxd5hnpjPqmv/maR9duLyjUt9gi5/4j8hoN5mMytIQbcYTjiLHAI4H6euae2R02TcDzll3m9GWMEjlbn6sc3Ow5Vcuysxle86KfEdMEzPYgngAZPMT5WIHWZGgUfjYOOjFgt+DWAwxT/8m11Iw0eWImdLOuewAiV+eiAImLEWURBD4pjR1JeQCNDAtbFgwAjf9meN7tRuSplgNx
 YKZbVsrt
 +OwLCXpSQxaKEb7IqYWqI9Wpml2B04NY690aaJuJg5x5VZrK1Xwd3ACUuAMaaBIQ3KgQ3uOEp5CiNoc+kfsw2T8yQgpO+CEnw4Ab9uRDjP00PI8easMJ5hyx9ePmCPFEI3JeRs0F7uVYDy1uxonYJxM2j7W+NnNhN3JUDP2gnj2lK+Nq2zmJ8E1bXYQ==
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
index 549ac98a9366..cc76a047b54a 100644
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
index 44d4e2494bf3..89e59ef89a69 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1602,7 +1602,8 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
-	struct idxd_desc *idxd_desc;
+	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
+	u16 alloc_desc_retries = 0;
 	struct iax_hw_desc *desc;
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
@@ -1618,7 +1619,11 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 
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
@@ -1778,7 +1783,8 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
-	struct idxd_desc *idxd_desc;
+	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
+	u16 alloc_desc_retries = 0;
 	struct iax_hw_desc *desc;
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
@@ -1794,7 +1800,11 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 
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
@@ -1869,7 +1879,8 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct iaa_device *iaa_device;
-	struct idxd_desc *idxd_desc;
+	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
+	u16 alloc_desc_retries = 0;
 	struct iax_hw_desc *desc;
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
@@ -1885,12 +1896,17 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
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
 
@@ -1919,7 +1935,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	ret = idxd_submit_desc(wq, idxd_desc);
 	if (ret) {
 		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-		goto err;
+		goto fallback_software_decomp;
 	}
 
 	/* Update stats */
@@ -1932,19 +1948,21 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -2125,6 +2143,8 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 
 static void compression_ctx_init(struct iaa_compression_ctx *ctx)
 {
+	ctx->alloc_comp_desc_timeout = IAA_ALLOC_DESC_COMP_TIMEOUT;
+	ctx->alloc_decomp_desc_timeout = IAA_ALLOC_DESC_DECOMP_TIMEOUT;
 	ctx->verify_compress = iaa_verify_compress;
 	ctx->async_mode = async_mode;
 	ctx->use_irq = use_irq;
@@ -2139,10 +2159,10 @@ static int iaa_comp_init_fixed(struct crypto_acomp *acomp_tfm)
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


