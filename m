Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E522C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18A2B6B00A8; Fri,  1 Aug 2025 00:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139606B00AA; Fri,  1 Aug 2025 00:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1CA86B00AB; Fri,  1 Aug 2025 00:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDC8A6B00A8
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:37:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8C1D140FF1
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:37:01 +0000 (UTC)
X-FDA: 83726928642.20.86D9751
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id A21034000D
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=a0c44Pvm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023019; a=rsa-sha256;
	cv=none;
	b=0d0CmPM5Ze59yFoQ7gINO5xE+SaUbJTGRyEebkdjRgp/RIk1Y/F9HBQf5Zzlo+idbefRKM
	Jc7f1U42cRte7/0kFBEmQvQySSlQTVsV8tUJlX+P6ciSDuch/ABWxGweTZ9L1hVV1+w715
	FYqnGQb4hxHRrzMIJbnC2wZnFlP8nv4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=a0c44Pvm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9U4yMgUu8e5Mvyuojg7399tY2Dwem+bS/o+ARc9I84=;
	b=7ObLvrjmdOb4N3u1S3rvVphvZcRQHudBDmq/OzIEoD/WKlEHE3HjsrKygnLiU+J8HWQonJ
	DWms5gx4YWIiJusC32MOXMByYcYPUER83Xaxn8UiddisjO22beWY7psMDXZR1PaMwrKvHC
	FUsMBj0ReiuPSvDef49yqDS1ALj0EsA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023020; x=1785559020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jBYqtIdn2g/qmc5lPRJuQdSpcp+B6gPWEJvQ/KJK+XM=;
  b=a0c44PvmwM3GSP8m2R5YFf8/2xplRYS/inDE7KigKrXICvz6cd3CeH+n
   9WAVzNRKTQ7C3l8uZUliRdgVqEg7Ed8S+jzrqCo2J6kYZuIAm0IskVdJi
   Kstv29LLoI/D1FDPWBU/4wfg+Yo74wr6V6hFZ7IGkV60IkXHXQMg+BU3/
   GxyXU9HzSPaYuQUnhf3eRP3ciGNSuOT1e+vH2IFA6MQi44Z+1ckcivXfB
   cGfXbPa9poFW8DYWaqJ+Uke2INpgSyi/+wtR9riaHdmgc3eiBgL1ppzHr
   Kg/QaPXbu/4VlxfSa4uDO/AZ6rdNP0KydZkcOKzkY+PbrgDSHkis/jBkr
   A==;
X-CSE-ConnectionGUID: Nn7YvTcpTeSSl1bhumHQMA==
X-CSE-MsgGUID: QRtvPYitTGyw6P/cqPG6yg==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820377"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820377"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:46 -0700
X-CSE-ConnectionGUID: 67ys5ai6RRu463egZMl72A==
X-CSE-MsgGUID: LkB5nBh/SRCjfrvI35zSqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796297"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:46 -0700
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
Subject: [PATCH v11 18/24] crypto: acomp - Add crypto_acomp_batch_size() to get an algorithm's batch-size.
Date: Thu, 31 Jul 2025 21:36:36 -0700
Message-Id: <20250801043642.8103-19-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A21034000D
X-Stat-Signature: hxcnaf9ddn8tych656o54eicxh4u8uc3
X-HE-Tag: 1754023019-695478
X-HE-Meta: U2FsdGVkX1/eGQ29rQKe4CSI9YsPm8uYZsRAXHPW8fOJ1G6lRJd7CmXYFifWbHEhA2jPeyKeHSrkaBG2smmI4mqxMUjvy0t2nHMbYKVOkVEVLQn/1cvzYQPMZJHA5ituSA1Cg3Ts3KauCIT/PIwXIQ6vSNGP4DxO1PkQrjYgEMuEgzgdPoMlxCWPuRW5MeGShHixdYFEFqB0VYZ5sq1E/YNkYf1E8LdO22+2LEcey7VkMwpo3OD7OO52Jvtqp7Z0Vhqm8klWWCdiLaSSB0z4VhniVlx/668KUQ8QS4YZ/1Fm+vubwuy/ELVaN9i/wuD5YBmgcfNaAr1wdjxLBGnelQiYD3u0TG7LVAcTluj+afvfQnp7pMGNlCK4t6DhapCcQg2CInMPN590uMS8wwdl0rOz1Gt1JbCLBcROWGsO6bs6u9UTE1eJby0N5DnY0slQuyjJE9RkQBzc91by9UvN12k1bbcE34PQf/ZTlrQHJ5GLx9u7QWHX0zlIQ/E0YHCmbNb24sYBBeOKxNOwfDm37i/qeMgO2IzSXKoS7mpJlRGvmVUl+W4wKgp+FUyV/px/5P/270CWyql93u2g5dBKCKZvo+pXkHknqBD9YcmTmgwCHRJOrV7JD6fTCTVcYyrOLOTBKEh+3EqQrKnPodupNGP2DG0XzzJ50aZ4kwSPCD+NKc7psw2lardoykn43bTRrp5B/OPz/ZY7tBXX8bDistwUaLayxhJbWh2o/lYQLDcJtH83yUBcctNj3KG6gGIfBQvjzxMmIv292G27lLIEU9ztHx7yFvekYE353r815Slv5h9WwONW01DIcdNREcsB5UWBMwQ5DW+b5+wtMrDAYMWfBnYz+z5KzhOQdTWWlBEYzVOyLw338Ebe1EFTEXlbC0Rn+JZxVOjYSWWOSoZgYBjBwHzOdEjCFm5kde9oYzoksOMN0wwP5fb4GDZE+qyva08/y/BjThUQaFAxBVs
 QcohClC9
 573PN6IrQxOiKW2cVhr3io+p1Yn5VOhSHJPZCK0/quucpDaif/Ap3fz8Gcwn+u5Fq7499ZOXu781mawheQSkOPn3ogy/YDEUTYdgqoArLnrIKkwKQ1rsWEIYnDVMjWSZXoaU6SJWIlhClZUxdhCIGQ3dnlXhp1iU/xbjbZ+YuRcz+8N7bLshy3UsVDqommbk1ELrRhwlYGF2OFdWZUaNMDWfsVg+1FqyXDZug
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit adds a get_batch_size() interface to:

  struct acomp_alg
  struct crypto_acomp

A crypto_acomp compression algorithm that supports batching of compressions
and decompressions must provide an implementation for this API to return
the maximum batch-size that the compressor supports, so that kernel
users of crypto_acomp, such as zswap, can allocate resources for
submitting multiple compress/decompress jobs that can be batched, and
invoke batching of [de]compressions.

A new helper function acomp_has_async_batching() can be invoked to query
if a crypto_acomp implements get_batch_size().

The new crypto_acomp_batch_size() API uses this helper function to return
the batch-size for compressors that implement get_batch_size(). If no
implementation is provided by the crypto_acomp, a default of "1" is
returned for the batch-size.

zswap can invoke crypto_acomp_batch_size() to query the maximum number
of requests that can be batch [de]compressed. Based on this, zswap
can use the minimum of any zswap-specific upper limits for batch-size
and the compressor's max batch-size, to allocate batching resources.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 crypto/acompress.c                  |  1 +
 include/crypto/acompress.h          | 27 +++++++++++++++++++++++++++
 include/crypto/internal/acompress.h |  3 +++
 3 files changed, 31 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index be28cbfd22e32..f440724719655 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -105,6 +105,7 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 
 	acomp->compress = alg->compress;
 	acomp->decompress = alg->decompress;
+	acomp->get_batch_size = alg->get_batch_size;
 	acomp->reqsize = alg->base.cra_reqsize;
 
 	acomp->base.exit = crypto_acomp_exit_tfm;
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 0312322d2ca03..898104745cd24 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -108,6 +108,8 @@ struct acomp_req {
  *
  * @compress:		Function performs a compress operation
  * @decompress:		Function performs a de-compress operation
+ * @get_batch_size:	Maximum batch-size for batching compress/decompress
+ *			operations.
  * @reqsize:		Context size for (de)compression requests
  * @fb:			Synchronous fallback tfm
  * @base:		Common crypto API algorithm data structure
@@ -115,6 +117,7 @@ struct acomp_req {
 struct crypto_acomp {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int (*get_batch_size)(void);
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
+		tfm->get_batch_size);
+}
+
 static inline struct crypto_acomp *crypto_acomp_reqtfm(struct acomp_req *req)
 {
 	return __crypto_acomp_tfm(req->base.tfm);
@@ -545,6 +555,23 @@ int crypto_acomp_compress(struct acomp_req *req);
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
+		return tfm->get_batch_size();
+
+	return 1;
+}
+
 static inline struct acomp_req *acomp_request_on_stack_init(
 	char *buf, struct crypto_acomp *tfm)
 {
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index ffffd88bbbad3..2325ee18e7a10 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -28,6 +28,8 @@
  *
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @get_batch_size:	Maximum batch-size for batching compress/decompress
+ *			operations.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
  *		transformation object. This function is called only once at
@@ -46,6 +48,7 @@
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int (*get_batch_size)(void);
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
 
-- 
2.27.0


