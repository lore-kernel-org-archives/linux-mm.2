Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DC88E63C86
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1C46B00B4; Sat, 24 Jan 2026 22:36:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7D26B00B7; Sat, 24 Jan 2026 22:36:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015136B00B6; Sat, 24 Jan 2026 22:36:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6F826B00B4
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:36:13 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C86416045F
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:13 +0000 (UTC)
X-FDA: 84369073026.12.B12BEA8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85EA0140007
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z98QX76O;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MJuw+fJZw9Z/Bi2/XzvHkbGqj1w4NGoegk8eHkjZH0=;
	b=pCGarE/etjJ6stMsS59TuQlwkgHHj/3A1+1XTXA2amqOfbTb+JV+aqFoXw1jr8Ckk3DYc5
	G4WN38c8ZyTRCRW3/EgFRySIMoiLGNDateu58Xg18GEuaiHxMaR0hrrZtkPKYyxGNxkS0I
	clQSlC4FHlMQJr3vGmRa7gxStorldiA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z98QX76O;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312171; a=rsa-sha256;
	cv=none;
	b=VqJeK3lEB4YT9IbnLwaiSISh/h5W9edR2VKL1ql/EvBOP99Rfaoh2dAIMlD9fG62ubdBsG
	mVewfMZ6D9xI+jxoXNTczG0ecMP+HeWKC6sfCcU5JNAoDmGG1zj15qKpDlv65vERtly0uj
	bYcY7Hd35upmpZUnbr3YEcVxGD8lpX8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312171; x=1800848171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SaK461OE9N571yM1DigWyBRhAbZ7RXxHms5EPvXQKq8=;
  b=Z98QX76O5bADATtzPqXNuBDS8/CmBkvN5Lc9+5kHG5GQ37aFgvyUQ2zX
   /LtebsAEx5PJ8P9GpLzsqbcMPnlckWMoEFZrwSkbDxdtMTKxufO3nzOVn
   is3qhpvcu/YQJdj54vlU9EEUlu+sotz0pSPk5j65qOgty5PbG2XScM/eI
   R+UqbszCRsOgI2Xmvf4+oYV1Gp5iY2JyejQuU+sHdYErpz+PipmxPTVa7
   K7IvazsBsx+S6enu9igTsCXMO9fPjtAfMNYrtuZhkY/NJ4yAFcO75s1Sw
   jKaypPrCASdDwVFbWR9rfvjoJW1hHHOy6R4PuSIVQSP23/us++3UuBCUs
   w==;
X-CSE-ConnectionGUID: inIm/C7tQF+M1s7Uf2BTwg==
X-CSE-MsgGUID: rcWJQrErQbqXe5s/GQDvlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887637"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887637"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:36:11 -0800
X-CSE-ConnectionGUID: /MfoxdkxT5Ct5V0NNBDwbA==
X-CSE-MsgGUID: 4LQ/McmVTw2S0JQejqfk8g==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:36:09 -0800
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
Subject: [PATCH v14 22/26] crypto: acomp - Add crypto_acomp_batch_size() to get an algorithm's batch-size.
Date: Sat, 24 Jan 2026 19:35:33 -0800
Message-Id: <20260125033537.334628-23-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 85EA0140007
X-Stat-Signature: 7y4kp7rmtincmoybbdoam3o18ifdkmc9
X-Rspam-User: 
X-HE-Tag: 1769312171-795366
X-HE-Meta: U2FsdGVkX1+ka1yWTuAX4g+w3Xb+8PdFiFcS0xKfr9Eybww6ejORLm4yDG2ScSFg96KoUSHDbdaWxsqtRBa5RKCkTRwsfTRzfs58KSA2/WzM5WPuZ4PnCRQlI8RFtLvdEcASxW8K38XSefAoVbYABqXRfoB25BmUG5Z0q0dFrOvGLjqaG9tx7Oy7G3VCTdzv43amQRYtG82InCbkQI5IV15wSE1KB9Lz/0uE5+uDtK7ym4QhQA61NU5HB+9zWOjZGvwjmL4/uq43QzeYaXOeS/KiLBPrmtIhxWYcVuZq+Yfmfk77YdYjI106lj9H0IQq5JSFJPZAxIkCY2yz6eNkkQ1T3scvxUFzUcHYbZ8YI+1F24PcIgPiy2QqvDY6bM7wuuqnILWnSyiMuVe0+r7L5KjdKDQr3S/MQzIeb+24aorVBNRd5ozASLFK/yJ/VRvRloTjcRh6MdB11pK+6moHTwUjGYQvw6mo/AyH23HxBtEhfyPRNsSzKZpHXmchzIMR0klQdud4hCXKaIS2pJ1pL0qX9fSChLG28rN1J4n6PWdISBlu0/p34tkreg25wLGOPZbaHPemAXsRh7sAJbpwzdExGsRGc8x11oOTgbg847B3CjOlmMmHCvXsXOsPaT7pm5v/VQKftbH5KEnWnVkhC8OjvVYaHoHF1Gbnjhv+KoQA9TwhLKYfxxo1oJpgFH4fXdWB3PDNKtFUqRMZmjWgWmsoJ8nx1PJ/1t9SPaBEy6O64VaDo+RJf6BWtftKH9/JTxl2sFCulX1RIYxYATluYd8LABNG/1M3Yo6MIwQ5qOm+USRuqOUKwYfmma6LgxylSGcrVXC5jmeT2j//GqqdBzSe7fnEB8SAoZeFbxjuvwh8BF/kbeHPIJvf1TNczt/a77J0pDQxbwVWLWLwP56f+PE+ceeHBn20RU7hqcQkj1N+GcOY60xmRoMdPF7NpdD+E7ti0QjH3wMzqaL021L
 w9ZX6Sf4
 FXWKPg9V5RwDlymjrGs/Njy7wI6txYHEbYMCjScqe/xYjpa0XKScw++U5pmL0/P/0sb1Ub3uoAQAEt6Ses7V0Yc5CKsxw74JEWpKRX4qV2RPmAp1leMtcBGwQeQs4XvG29aiP4Tlb8vfCI1IB80CgVgMYpUjAfiJTwFdxRIQbyqxJZG9gv/FSqM6VWRH/kAZG7AzAew/ecnNnshQQTjHPFntFCPhbqKm8BjXy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit adds a @batch_size data member to struct acomp_alg.

An acomp_alg compression algorithm that supports batching of
compressions and decompressions must provide a @batch_size greater than
one, representing the maximum batch-size that the compressor supports,
so that kernel users of crypto_acomp, such as zswap, can allocate
resources for submitting multiple compress/decompress jobs that can be
batched, and invoke batching of [de]compressions.

The new crypto_acomp_batch_size() API queries the crypto_acomp's
acomp_alg for the batch-size. If the acomp_alg has registered a
@batch_size greater than 1, this is returned. If not, a default of "1"
is returned.

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
 crypto/acompress.c                         | 14 ++++++++++++++
 drivers/crypto/intel/iaa/iaa_crypto_main.c |  2 ++
 include/crypto/acompress.h                 | 12 ++++++++++++
 include/crypto/internal/acompress.h        |  3 +++
 4 files changed, 31 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index c48a1a20e21f..02c25c79c0d4 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -387,6 +387,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
 
+unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
+{
+	if (acomp_is_async(tfm) &&
+		(crypto_comp_alg_common(tfm)->base.cra_flags & CRYPTO_ALG_TYPE_ACOMPRESS)) {
+		struct acomp_alg *alg = crypto_acomp_alg(tfm);
+
+		if (alg && alg->batch_size > 1)
+			return alg->batch_size;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(crypto_acomp_batch_size);
+
 void comp_prepare_alg(struct comp_alg_common *alg)
 {
 	struct crypto_alg *base = &alg->base;
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index fe9f59ede577..e735aa01dce8 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2729,6 +2729,7 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 	.compress		= iaa_crypto_acomp_acompress_main,
 	.decompress		= iaa_crypto_acomp_adecompress_main,
 	.batch_completed	= iaa_crypto_acomp_batch_completed,
+	.batch_size		= IAA_CRYPTO_MAX_BATCH_SIZE,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa",
@@ -2755,6 +2756,7 @@ static struct acomp_alg iaa_acomp_dynamic_deflate = {
 	.compress		= iaa_crypto_acomp_acompress_main,
 	.decompress		= iaa_crypto_acomp_adecompress_main,
 	.batch_completed	= iaa_crypto_acomp_batch_completed,
+	.batch_size		= IAA_CRYPTO_MAX_BATCH_SIZE,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa-dynamic",
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 752110a7719c..1448b20de492 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -598,6 +598,18 @@ int crypto_acomp_compress(struct acomp_req *req);
  */
 int crypto_acomp_decompress(struct acomp_req *req);
 
+/**
+ * crypto_acomp_batch_size() -- Get the algorithm's batch size
+ *
+ * Function returns the algorithm's batch size for batching operations
+ *
+ * @tfm:	ACOMPRESS tfm handle allocated with crypto_alloc_acomp()
+ *
+ * Return:	@tfm's acomp_alg's @batch_size, if it has defined a
+ *		@batch_size greater than 1; else return 1.
+ */
+unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm);
+
 static inline struct acomp_req *acomp_request_on_stack_init(
 	char *buf, struct crypto_acomp *tfm)
 {
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 7c4e14491d59..dc126a8cfea2 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -34,6 +34,8 @@
  *                      of all batch sub-requests having completed.
  *                      Returns an error code in @req->slen if any
  *                      of the sub-requests completed with an error.
+ * @batch_size:	Maximum batch-size for batching compress/decompress
+ *		operations.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
  *		transformation object. This function is called only once at
@@ -53,6 +55,7 @@ struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
 	bool (*batch_completed)(struct acomp_req *req, bool comp);
+	unsigned int batch_size;
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
 
-- 
2.27.0


