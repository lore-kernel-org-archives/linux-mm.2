Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C0AFCAC5B5
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36A88E0001; Thu, 25 Sep 2025 23:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0CD78E000C; Thu, 25 Sep 2025 23:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01B58E0001; Thu, 25 Sep 2025 23:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3408E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:35:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 686E587623
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:13 +0000 (UTC)
X-FDA: 83929985706.20.A1D55AE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6EF60A0007
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c5zzU8yH;
	spf=pass (imf15.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758857711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H1LGV2K0VDuDvJmKeBmuKX/qMY5r8bTe7gMXseZ2flc=;
	b=iE0VRcIaqvYviZJNUfSbitpeu+ab1rUzQoPMynBdV7nRHJY/oU7+3ue04W8Nu1MqwG/DwX
	gdE6Q9s8j2UVb8Wlt1elNkOnc/8KYlliHfKnEhBTZAtC0ioC7474WyTS5NZYWOA/2KJhpt
	rvKdphNCTNBbkZZ1A1akelussv/subM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758857711; a=rsa-sha256;
	cv=none;
	b=xNtLOSJgzZgGruFu7xiQ/tyhVmHkFu1+BW/qLlX44kwqRpXlbiRLlt0ikJqgUJAEncjej+
	+bp99oVGoY4yA/5tiRY97Kcb0lcSBLS38cFnZrguFn+rE+wZB3T0E8wsXxdGQVch5TQ7d7
	nIHmklyLK5fW5kghs//zvNMzjpNc89o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c5zzU8yH;
	spf=pass (imf15.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857712; x=1790393712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W3aURnxCmj1la91C1akYQZ8M4BvNi+tJIJrf7rRX5u8=;
  b=c5zzU8yHSVkbqs+qjnDP4CacxlBDsgL5/mKxtXSOsUu/3/rXoj08VfIw
   wJj3oLd/OAZwXrb1UlRDEisp0GJnh9WFWEWGRU9TglvS8i+L0X0fmvpuy
   k8latV/Bb5A0WvocxeGKSJXppCbcIm7XH85m9/4DdbFvXnN744ZJsEFtt
   9rzLVsq8Ny48YHEqiMhGmAO5/xNEGdDnEYXKC6zdv3a7/iu+U2pYf/qpW
   mvSRnam4Rbdyuk1XPSoJmW/bd8yNrTwZ7pzWl13nJ62y+/kmqyecUNEe9
   4HGI7HlHiilt/weBFKm0F5FTVnd89vIadyWXiZItG2RlEY/AaImWHHkdh
   Q==;
X-CSE-ConnectionGUID: d+Ym2GrlRK2SGwonb/j8xg==
X-CSE-MsgGUID: VD+LuzTvRne8O02TyvidBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819476"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819476"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:05 -0700
X-CSE-ConnectionGUID: PDSLPQf9RoGS/IJCefj2Ow==
X-CSE-MsgGUID: Ktg6tixmRPq8dew9KQqPkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636557"
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
Subject: [PATCH v12 04/23] crypto: iaa - Descriptor allocation timeouts with mitigations.
Date: Thu, 25 Sep 2025 20:34:43 -0700
Message-Id: <20250926033502.7486-5-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 44n7usoxpsimmf8hne998kdtf3ur3nyo
X-Rspamd-Queue-Id: 6EF60A0007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758857711-861958
X-HE-Meta: U2FsdGVkX1/uz8I1JjjnItyqUYepM6qzaufbX4iX7kJ6Dr2g6cuC2oX2L9034AFE/KnS7JkAGpV35gCQOgEgHRz41waQUhyqEp27CU/hTQIzo2Tfw242muSwje2IC6NPWPSYFq1RUyUYPmuNhl7tpv6RYW583j//U4/E+55FOnvxB9fLVte355JmYHEtOX3t63Y1fgDgfXHxb6ii5XNXz9fgq3TYXqSzNCax7VZSxAH/7vFblYgy5jrCeokQ/cDfRef8xeJL/o0AgYpuaicDwi1Rc2AeA1uTOK2BEa29niaq1RMv7Ch7pYpghy87G3d7BM0TUvP1T2DHiOR7b1b1Eg6kO7k5imHBX8zZYOBUInU7fROT2JtWWqbS52wS6MoV6BV2ACzki/CeNLpsIJjVbJ1LZAkrzkhff6MzgaPogZXQZ6wI87zeRu1rLRb6kErMMvNM4RkUo7Donh+9cNL3t1kWUcRa0hyShp898/BVh26VEkHxMCbzwm2Jqx+hdhUBX5O2/fudNzser95amPgy8nNFZCSF6vc604hJrgRLnzDiTUw/JxqGQqgpZ3J/qD6xwc8CLIAa6Sg67Y/vNsvunN+SJIm6lxnRf01KI5QadzaBzU13lxwgFyAqIN08Zyhj7L5VBOEOksaXWs1NkSGXX+QVB24BCHmPOsawCkHPrwsnTBYJtWLzwjmkRYlw2NwDhtd2qw0W+zrI54H6hbgT1zwMhGUzFN/WFG7No7zqJe/z8ARWjdkAyFxy5xCHt578doETCRFF9PJ7k5+P3QeZ5dmngK89NktiQf7RwK760dv1iMuB5ytBDp/0/suG1VXSUVkJm7UcB+dO1/5+6adKrOrgHRQXUTCmOhKnAThv74YU/g3ARL1ACyMHnJHPOPVb
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
index ed3325bb3291..1169cd44c8e7 100644
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


