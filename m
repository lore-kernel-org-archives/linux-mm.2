Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15AA6CCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A964B8E0117; Tue,  4 Nov 2025 04:12:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1F2B8E0118; Tue,  4 Nov 2025 04:12:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E8858E0117; Tue,  4 Nov 2025 04:12:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70DAC8E0118
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3D7BC58E53
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:52 +0000 (UTC)
X-FDA: 84072359784.19.5EFD2B6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2FC421C000C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XJo3N/5b";
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQBDiFzhpMnCKf9c9s1T91c/BRv+lnz+OWyL7TOxKoA=;
	b=Q/JB9hRP/ODOvO1pzytfXNZtmXtyr6VjixLY8lKSKcBOl1lQPQ5UVnvhniqcXafwf2U7ob
	xVyzBOkuoBih1UOMV01Izn/BaSn/sbbnm+86IB4u/X/Lmuqa/4l1ZsSKOGeTfPMiLulDwX
	6Ex93ROFn0lLMYyKco4MkCIIs724d0g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247570; a=rsa-sha256;
	cv=none;
	b=kztHQoI+XPe9CPk41/JmPOhqo5L5t2WmC20+fRZPiHGKZFe2an0mxy9m/w6/5Uo5xfjV4T
	4Hd7ri8ccGiHbLlLXlo2GmeJs3ehxd86yr9rmofNF4TdTOQh08aW0ujZuPzKkhV7ocyh4a
	nZMR0ASRvs3E8SpC1hjvcb5ljQ/DZ/w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XJo3N/5b";
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247570; x=1793783570;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vCApmtmMXoGN5S/Qb3qu/+sfAmKpMxg+chJJ85/VF+M=;
  b=XJo3N/5b90IFAPqThV5QmMX1br8LAWtgnfRjO2rPyMzLPlyVYWMKVxzT
   ECuP4BU+6uL/22pc3K+G+/CMHL8+OMZN+rgmMNjWkaB1u3/gYqnlVqdne
   VZxcOzZdTLfBU8TW3W2EiBNcN+FMn0NGA+NG/rAdqCuEPRzpdc93LLaq9
   +ZSpKRvFcPzCcYn+3r8vgxiEM01w1fE7GD1jgcUMAtfKuKwxBlDs7Jqz4
   MoDObw1TwibSwnt0iLm3U8KUZeyOWhuCIQb4MQ9IwfNJLhNqoNlK0o/Z+
   G1UWnwWgbjtkSLA2RfKO39ZnzeC6guez5pWIhoZTxWg7nOorLGzYVPgMT
   A==;
X-CSE-ConnectionGUID: 7GTOPqhVRmSQsJnUD849LQ==
X-CSE-MsgGUID: eCZifBM8QhWaBL1t/fR0VQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265200"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265200"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:39 -0800
X-CSE-ConnectionGUID: B5B5oAOhTrqeoAjYGQrftA==
X-CSE-MsgGUID: hO5Z+nCcQpKR/y3sWsGqpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795829"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:40 -0800
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
Subject: [PATCH v13 18/22] crypto: acomp - Add crypto_acomp_batch_size() to get an algorithm's batch-size.
Date: Tue,  4 Nov 2025 01:12:31 -0800
Message-Id: <20251104091235.8793-19-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2FC421C000C
X-Stat-Signature: 4wbgkgemjc98sg4e7zboex8cib9n6trr
X-HE-Tag: 1762247570-61945
X-HE-Meta: U2FsdGVkX1/LRIhUw9DRGyJUgq4+t8+rsohs0YOLYskBEEvDgzOyFW6HclDB+FhC4rNaRl23VjnCKq55UFvpNhsEkXfO2R3aCaXdKi42YqxpOyUfTWVdzHlc8H4hIXVG1/8sN7318JS/uid9Jawn0Lp9uFi7IzMkdJP3dx9vlryToJ2/MS0w4QrqfJfK+vRPgS3m3XQgnBPL1aG6oR07t32nb0rAKnsBb9H6axrDiOS6aFT+fup/Ddw5KNa9hR9CiU2T8gKShDQ4dCI4GhBCAKZGzgxNXjNcLbjwaiI/Q/RCZdPM/ckoTNkMjYmQ8zCqAJwCs0xWHBu481kdNC9muFhr9I/POl2YVmbekI8OsKepddZwbjR1Ustm9/n1Q0K8AMddx6PwwCIlU13lrXRHJJ12M0EiIeTRQ+YIc/WdIdMJqaQK8JqXJBICCJX9+9PMOfJCaqTnwZaGi1JdvFOK1nQoFoqsqCc26Z51oOsPPH58n1rfh1L18SOAYFB5a0DpnQnqSQGJxTfh93PMKbVN/JRhizz9QB1ZvTYu4LPockVx0IdDFoMcyZmWYTi5oY+ccmbtxzULfwHxX4y+jpWHtJRurNX83E07it+mQ4ybPu4g5LnmvLDQ2AYvFCRJlEfPDlTcXbjhnYG8mz7NJW2OaVMiHZKqEgATGIUK7tKgVktNUcuvWCy1sU2L4FuR6dLRje4Oj2kgjtVdyYBREnzsaLRFBg1PwkFDc/ZrhtqcBPyiySDWdqsGdu9ZXex3b8n+jzYbP4wg2Fh8YpkFr1nsgJY4yiU30YgLMTt5FCN+/G/a+mz6950DpUqXk5Q1bs6uB1AMCChfxMPmKkXJsJHfCfELELnoy6l8mooKIMptXbc32ssq2ny3bSCj3t4n1Riqm9z8zWjxIl447F2ItSxrH3m4a4wvsvATspg1h9JjoYs4SypUFgWxGzI+Sf3gc/JEcQCxhvk8Xck2kx2g3GY
 cNzppaPh
 8apBu5KJnvVlDyh4WLMWnnOmxYjf5IGNjdYwIaNPVDEBapMAe4peb4wwr/E52jlIjL+y/LRW4uUu88smlORPGkb7l1t9wpFQlwKX1vf2/BU+FOuhndk7WzOeiN5IOYR43FliHDZNuTrb1+RljnTGznVyVANEtduJVVFf2YOxKKXiJYdlsXQNM3i19GYNxAL7KE5wmgwpBr4hpK6kWeqo98YwLS35QE72QmhgN
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
index be28cbfd22e3..61ad81b06f49 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -305,6 +305,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
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
index 37e1cc720e5d..2db2ddd4cb49 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2671,6 +2671,7 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 	.init			= iaa_comp_init_fixed,
 	.compress		= iaa_comp_acompress_main,
 	.decompress		= iaa_comp_adecompress_main,
+	.batch_size		= IAA_CRYPTO_MAX_BATCH_SIZE,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa",
@@ -2696,6 +2697,7 @@ static struct acomp_alg iaa_acomp_dynamic_deflate = {
 	.init			= iaa_comp_init_dynamic,
 	.compress		= iaa_comp_acompress_main,
 	.decompress		= iaa_comp_adecompress_main,
+	.batch_size		= IAA_CRYPTO_MAX_BATCH_SIZE,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa-dynamic",
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 0f1334168f1b..6385f9b78a0d 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -578,6 +578,18 @@ int crypto_acomp_compress(struct acomp_req *req);
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


