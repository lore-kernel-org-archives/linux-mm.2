Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F260CAC5B5
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4CDC8E001A; Thu, 25 Sep 2025 23:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBFB78E0013; Thu, 25 Sep 2025 23:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAEAC8E001A; Thu, 25 Sep 2025 23:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95D8F8E0013
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:35:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 58E5F59471
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:23 +0000 (UTC)
X-FDA: 83929986126.18.8D2772C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2EF33C0004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QSxRZd3v;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758857721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ELs5EDpFXs/1fkSSuedFadcbM6MiNM+Lk+q7h7Woik=;
	b=b4asG6Nk1gGod8jwxax/Xcjw0P1KAw3huwH46oQHuQ/lni0EdoAFMkKr4hpKnqvWOjA4tB
	2eydiOrdlizmRGhcFPMcwexjWCEUWq7hFyBhDN11Nd/iXa6+/uHq6ON2gRPwVRhjFxIKAB
	/uu6YjB/opKTLC4kTdC5j3hXLLJRjFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758857721; a=rsa-sha256;
	cv=none;
	b=nkIXoCo8iOHgBAJO3KEql2NI97Vf7aVLqsxGFf8d0KU6uwSIQCW8jAieCv/b8sHXGm8psx
	ThIcCuY3RoU8ZAJ4tHRrpP0RrUFFLWZM/DHNGwPAYDKDbZMiJGgw3L5U9Kgmg3CLpxAOu4
	YCPhzlMd6m6Mz6+TxFnLUhEataMPNDM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QSxRZd3v;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857721; x=1790393721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2jjGz92VWP6NF7MEg84WWTreqEFFwrPZBW5/7GBPLbg=;
  b=QSxRZd3v+GTSMFllo/ggU1QHfPFJUIoA2AEs61Mri9cyMSGMnKLP9BAk
   4XO5djR8tIV01wJS4UVem12vA7ZkuAgKutACZ9HpjTCZJZO4Iscj1WWzu
   eyW42/PWEOOj51uxpmlK55bx0N0HFl5MHUZ9feVZhr1NknQCghfHqBFwn
   4Wc7aRwl0Jk14fhw5OvLFUn0YhfdkBdtTZxGcd8yAFmseLYW6uTB0SWhw
   G2wGpOcWi+UXV9OOtHYkBb5Z5/GbBZjbSLV/Tm9mlz3ePUcY5JOpOqvtG
   DjEgQbQT6jRyEMJJywDKNNRTRvYhMwyme8u7mXdKrW010qHZ+ddu+RnIj
   Q==;
X-CSE-ConnectionGUID: LohztW1ERYCj8mXxovHnHw==
X-CSE-MsgGUID: GLB2OmlGQPmLyKneOy7BIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819659"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819659"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:07 -0700
X-CSE-ConnectionGUID: c0bOvcQGQX+dEcSCyb0UBw==
X-CSE-MsgGUID: eyUfyWhnTnOLmHZ5RSOtoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636609"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:06 -0700
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
Subject: [PATCH v12 19/23] crypto: acomp - Add crypto_acomp_batch_size() to get an algorithm's batch-size.
Date: Thu, 25 Sep 2025 20:34:58 -0700
Message-Id: <20250926033502.7486-20-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2EF33C0004
X-Stat-Signature: zhy6c55iqcc88tm19cg17xpcyqnhisch
X-Rspam-User: 
X-HE-Tag: 1758857721-368585
X-HE-Meta: U2FsdGVkX18cnc4bSySDqLquy9cjJ4zied3oC0MBtqSXfEXzT1lmcdSCiyDHnc2X7ZUdbiePi0XHpQjEwrZgFFb6BI2D4TjQoiNVvZGgR6G9z/THdeaFyxdr8mb9IJgdagE2O2dtM+KGRNBeerCLBT1hacThTcUs7WV5NmPKuJGaoC2MFErS630LNDblq9lyCfSxfekfsl89WEPC7kw1drDktwo4SeBZZVmPTZWwkTcXKfcTLaKBv3iKn8chKmXHOAYJ3kUNIpL/SsNDWmJbEo247tSEz5/oAcrBQJo5enWzGkb5eqCbAWrlpPosUbfwj937LX0nuHsndTu9TNA/9sJn/wJstfASm3g4D0glbKfci3ZJ95+IxSRVMXy1tpA6Q6ElnabZGFMZUi9b1Ol65eOnpdtqA6Z+CipMVgC5LN4gUIBhXfNoh7r0Pk2aUAxPcESc1ck7y821aFfy2ZWLIdzwtubtm83weVDRY444sQAIMWAE4cQXDuuPTI6l7MZVG8kG9BSYqtsPwrIDvHKylHVyyrRas9BXFlv/EE6SlHDWP0oytiVXmcHRRbhX/sxIcSbEEX0mx/enehvCQ05rFFMC4VNZMDIwNwRFPhXmY3DKKrsjvED0Xn/Oa8zq1KHp9fepJVnhY9nyV1OZfhTfW/AdaFRFb6emj6NeMZ+oRNoci/ifNp9JbY1fL6MHEkXH8w71PwbmFn8JduPMYV6mcWIxm2VhMx0u5xpB18HcjZGLI4fP99AJbp3TI4ARoBzGF+vr0gz2kT3sY8xAP2RsioYokdef4/+J/+SY+u+nRjnLGg047DJRWxysO//AhIqZ+udfHtxFLnjoGlrQGMtr6Gis0MifFEIwXf63hB2YJE6+XrwcBrY7RtR16NjFglPj6B76d+yG66frSO4erQ8qp2mHQmrRlMLUEe2xWsUgnLKXwy+QjkjdgOk/H5pwqs34HisvrTo6F+gl6ytQ9SC
 wHiYwQOa
 4RgKMGwt+O8VcciMCwaMUdiJQEzPa81cEnNjb9Cct2qsgdCSlpIqVoEJA/B7IQmPoQEoh71CRWoaZDMGqV5/3EOUAUQlxLYmwjxDE/xLsxx1duIe9XyJOrwTTkcIvBDPr1I9qSviszsjcZHe+szJX0zyf+/pSMbjEfgrlN2B0Z3Z25ZWOYHcp4TPUMnC1lEspz2jcZ/lo/ZAm2DZHtLBxSGRmWCaVuKUkHJdt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit adds a @batch_size data member to:

  struct acomp_alg
  struct crypto_acomp

A crypto_acomp compression algorithm that supports batching of
compressions and decompressions must provide a @batch_size greater than
one, representing the maximum batch-size that the compressor supports,
so that kernel users of crypto_acomp, such as zswap, can allocate
resources for submitting multiple compress/decompress jobs that can be
batched, and invoke batching of [de]compressions.

A new helper function acomp_has_async_batching() can be invoked to query
if a crypto_acomp has defined a @batch_size.

The new crypto_acomp_batch_size() API uses this helper function to return
the batch-size for compressors that have registered a @batch_size. If the
algorithm does not define a @batch_size, a default of "1" is returned.

zswap can invoke crypto_acomp_batch_size() to query the maximum number
of requests that can be batch [de]compressed. Based on this, zswap
can use the minimum of any zswap-specific upper limits for batch-size
and the compressor's max @batch_size, to allocate batching resources.

The IAA acomp_algs Fixed ("deflate-iaa") and Dynamic
("deflate-iaa-dynamic") register @batch_size as
IAA_CRYPTO_MAX_BATCH_SIZE.

This enables zswap to compress/decompress pages in parallel in the IAA
hardware accelerator to improve swapout/swapin performance and memory
savings.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 crypto/acompress.c                         |  1 +
 drivers/crypto/intel/iaa/iaa_crypto_main.c |  2 ++
 include/crypto/acompress.h                 | 27 ++++++++++++++++++++++
 include/crypto/internal/acompress.h        |  3 +++
 4 files changed, 33 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index be28cbfd22e3..a1bdfa21e688 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -105,6 +105,7 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 
 	acomp->compress = alg->compress;
 	acomp->decompress = alg->decompress;
+	acomp->batch_size = alg->batch_size;
 	acomp->reqsize = alg->base.cra_reqsize;
 
 	acomp->base.exit = crypto_acomp_exit_tfm;
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index cbe3a2457253..2fa38176034d 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2777,6 +2777,7 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 	.init			= iaa_comp_init_fixed,
 	.compress		= iaa_comp_acompress_main,
 	.decompress		= iaa_comp_adecompress_main,
+	.batch_size		= IAA_CRYPTO_MAX_BATCH_SIZE,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa",
@@ -2802,6 +2803,7 @@ static struct acomp_alg iaa_acomp_dynamic_deflate = {
 	.init			= iaa_comp_init_dynamic,
 	.compress		= iaa_comp_acompress_main,
 	.decompress		= iaa_comp_adecompress_main,
+	.batch_size		= IAA_CRYPTO_MAX_BATCH_SIZE,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa-dynamic",
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 0f1334168f1b..e94046529e46 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -108,6 +108,8 @@ struct acomp_req {
  *
  * @compress:		Function performs a compress operation
  * @decompress:		Function performs a de-compress operation
+ * @batch_size:		Maximum batch-size for batching compress/decompress
+ *			operations.
  * @reqsize:		Context size for (de)compression requests
  * @fb:			Synchronous fallback tfm
  * @base:		Common crypto API algorithm data structure
@@ -115,6 +117,7 @@ struct acomp_req {
 struct crypto_acomp {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int batch_size;
 	unsigned int reqsize;
 	struct crypto_tfm base;
 };
@@ -205,6 +208,13 @@ static inline bool acomp_is_async(struct crypto_acomp *tfm)
 	       CRYPTO_ALG_ASYNC;
 }
 
+static inline bool acomp_has_async_batching(struct crypto_acomp *tfm)
+{
+	return (acomp_is_async(tfm) &&
+		(crypto_comp_alg_common(tfm)->base.cra_flags & CRYPTO_ALG_TYPE_ACOMPRESS) &&
+		(tfm->batch_size > 1));
+}
+
 static inline struct crypto_acomp *crypto_acomp_reqtfm(struct acomp_req *req)
 {
 	return __crypto_acomp_tfm(req->base.tfm);
@@ -578,6 +588,23 @@ int crypto_acomp_compress(struct acomp_req *req);
  */
 int crypto_acomp_decompress(struct acomp_req *req);
 
+/**
+ * crypto_acomp_batch_size() -- Get the algorithm's batch size
+ *
+ * Function returns the algorithm's batch size for batching operations
+ *
+ * @tfm:	ACOMPRESS tfm handle allocated with crypto_alloc_acomp()
+ *
+ * Return:	crypto_acomp's batch size.
+ */
+static inline unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
+{
+	if (acomp_has_async_batching(tfm))
+		return tfm->batch_size;
+
+	return 1;
+}
+
 static inline struct acomp_req *acomp_request_on_stack_init(
 	char *buf, struct crypto_acomp *tfm)
 {
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 2d97440028ff..e451e0ae3b9b 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -28,6 +28,8 @@
  *
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @batch_size:	Maximum batch-size for batching compress/decompress
+ *		operations.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
  *		transformation object. This function is called only once at
@@ -46,6 +48,7 @@
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int batch_size;
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
 
-- 
2.27.0


