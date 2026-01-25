Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DA81E63C86
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 261426B0095; Sat, 24 Jan 2026 22:35:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7686B0098; Sat, 24 Jan 2026 22:35:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AB2C6B0099; Sat, 24 Jan 2026 22:35:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E983D6B0095
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:35:49 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF6D01AF536
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:49 +0000 (UTC)
X-FDA: 84369072018.17.87A36D1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf29.hostedemail.com (Postfix) with ESMTP id A5FA8120003
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ftS5r4xy;
	spf=pass (imf29.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4B2sgGhXOCIXTn/04mNEux0xvYoMmoc+UaNq9ZUiRg=;
	b=FRmkLzp857l2OC6eIUKVB2lPRhQ2wC+pElwmuFhRAGgxLJ3+TDe9wMourrfBstpZfhv86y
	B7DSU+SsOVWhAmodNwMi+COo6G4a0WZywM9x/vCU0HDekU2kdbDs3LL/vGGXKsFetXyGeW
	GrHXWIZFs+B/vCTIoPTjLAp/aPCBEw8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ftS5r4xy;
	spf=pass (imf29.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312147; a=rsa-sha256;
	cv=none;
	b=e8mLAdJhAL3FZrEL0C2rJgHJpfJ9bUHpOafPvlBZ11fAj71eg/CE2sxM390peEcO5Iys/E
	9hEpA0CrswqNQ3cBO0L9VUQReDMTsFx1emR+iBCcbjk7CQABcdgeRL+gQW+mZ3mAfwCXDf
	38bqso4EIGO59kqJZbc0K66Kgic8k9Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312147; x=1800848147;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jSmkM3KVp013rLmlvluc9OtVKZVi5NWhbXEC06tt8dA=;
  b=ftS5r4xyJj+MYc3677uQHXQEZk6uit3vgTTCkFWymbUiigY3gxWXUIvq
   MYFLHESw7/Qc0It7XL+ZImIknQTZhlgv2qL8TJdIYYUZrT0LBZXGy8vm3
   CNLHfOnyuTV2p4nY0/MmeWemuEWSw3hOIPxS6OFHpRJX1X6Le6oVDUGV9
   5XLC5lSkFAkkIOdcMGOSDcrOhaG+IyjEviPuGX6oRdDOrZKuzx804lVK7
   3m/oyoTw8nI1lN04Z9Md/HBOfj7cTd9nOo20r56WhjlRyItoRWwcJKdsX
   wevpCOwoZTo5M51IRfDVgwSXJbO4deRuB1vxQ8zeHRbgiIfq26/W+KXwu
   A==;
X-CSE-ConnectionGUID: vUfICrFoQduIq9ymFlDLPA==
X-CSE-MsgGUID: aFjUzuAeTXaLPioJsTVkEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887367"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887367"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:46 -0800
X-CSE-ConnectionGUID: 0tj+TR6VSKKXUE+ZO0SuBw==
X-CSE-MsgGUID: SEdjBZ9IT1CHo7VRoeVwNA==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:45 -0800
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
Subject: [PATCH v14 05/26] crypto: iaa - Descriptor allocation timeouts with mitigations.
Date: Sat, 24 Jan 2026 19:35:16 -0800
Message-Id: <20260125033537.334628-6-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: jcimtw5jizkgqwd9n6qa9jqsggjzrjjc
X-Rspam-User: 
X-Rspamd-Queue-Id: A5FA8120003
X-HE-Tag: 1769312147-761377
X-HE-Meta: U2FsdGVkX19JLoJnoPVN4t5VWNf18OVPd2NzqgYZqRlZoJLIJi5LzUc16fOoenzBd6dLtF+7Au/NMqL/S/XM76MvgRkCUmhsyqIJ1L7wHUqEI6eOaQrMjBrV/Lht3ZEBVfFWS9SZBewoWEuMl8XqMXwUqJnpeot+wx9kocLpI6GB41w0Ol4ujFSBdt6NyNmwrFJjmV5SnIQC089hoEYbMJhJ2jxE5S3EjiA1Fft6B8gFX/c63ZECTF9m2otx4mcpTXwq6acLblJAq2UpcygLMTvx+yRFuz4ZkmH/cYdiisSzcILJQMhfcjsddn/3arllBoKmL2rs8icTofbKKxjQWsFEbjBMdh5UcecaBe44p5GzzTnkc0U33bQDr4rWP8ZgOzBEGcb0fJ6Zj7YyILWYLzQbgfJKgwnsenNzsxaNHBhKVxB80LohXIEql+/dGmL67ucckS+4NSYikwgDqiXDBs9xpOyZjsY3YrkRwCjAqL8ENzia0reB31ySUZHjgVSx/h+zEMs2CprsWavXnD1jEOu51/gPuxIOAzP0U0ZSx36AJLGHzZrqw967BEORUpIJzyoXyz+6YffZ7XW0gLaBoKqfycu69jHXNiKMRPTQIPt4Okt9cGxO0OTPaKj7/pNc7UzkSDuJYu3nIlOrpf1PlaIzvsUzzJV/RI05P8lkh6tlkCPelTcFK0rWg49mrASXMYCJpjUK0ubgnZUg8FfAokPQZwKWYlUpQOVX+YRyf1yZKWcJoLSkN1j1GcfgFXRXTew/LUG85k/lqbJQm4vbQC+c1twCSlO7Zmo5rjjnngmDb5Brp4piCyeyZlQgOWHdcVDnESZJLCwS9ig5kqgB2j0Mn1egrqAXmd12Tm+1ASb4arA6bTGaFF50OlO2logKfE6Hnlg74WB7DDwD6PhtN7NxFHAJlw4M58zKK+utoGdtHf3VqlK45rDs4ld0b4311/uxsQbPlteS+vS11mY
 8UHxoFca
 ijiJ6iL5ln+iLEKHcH+k0OdRovlgITYL/LuI/7YFZN6MYM602jD9TATv0YloJJheKQGuw5VuYWPPCwd1S81XhUjURgg6/gz2vcGlMrFuyCc3NYTiJljrbf2pe9aqpgDlZKLdBUOaSe7SGKga8mmo9SHEXROmTSIfULUZdfjhSCYmlVoeO7Pr8ywlBkQ==
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
index bbc72254982c..3466414f926a 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1603,7 +1603,8 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
-	struct idxd_desc *idxd_desc;
+	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
+	u16 alloc_desc_retries = 0;
 	struct iax_hw_desc *desc;
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
@@ -1619,7 +1620,11 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 
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
@@ -1780,7 +1785,8 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
-	struct idxd_desc *idxd_desc;
+	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
+	u16 alloc_desc_retries = 0;
 	struct iax_hw_desc *desc;
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
@@ -1796,7 +1802,11 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 
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
@@ -1871,7 +1881,8 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct iaa_device *iaa_device;
-	struct idxd_desc *idxd_desc;
+	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
+	u16 alloc_desc_retries = 0;
 	struct iax_hw_desc *desc;
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
@@ -1887,12 +1898,17 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
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
 
@@ -1921,7 +1937,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	ret = idxd_submit_desc(wq, idxd_desc);
 	if (ret) {
 		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-		goto err;
+		goto fallback_software_decomp;
 	}
 
 	/* Update stats */
@@ -1934,19 +1950,21 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -2127,6 +2145,8 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 
 static void compression_ctx_init(struct iaa_compression_ctx *ctx)
 {
+	ctx->alloc_comp_desc_timeout = IAA_ALLOC_DESC_COMP_TIMEOUT;
+	ctx->alloc_decomp_desc_timeout = IAA_ALLOC_DESC_DECOMP_TIMEOUT;
 	ctx->verify_compress = iaa_verify_compress;
 	ctx->async_mode = async_mode;
 	ctx->use_irq = use_irq;
@@ -2141,10 +2161,10 @@ static int iaa_comp_init_fixed(struct crypto_acomp *acomp_tfm)
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


