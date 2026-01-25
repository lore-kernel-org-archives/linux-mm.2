Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB325E63C85
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AC4E6B009E; Sat, 24 Jan 2026 22:35:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260A96B009F; Sat, 24 Jan 2026 22:35:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E656B00A0; Sat, 24 Jan 2026 22:35:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 025836B009E
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:35:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7B70B970C
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:53 +0000 (UTC)
X-FDA: 84369072186.16.91F1F35
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf27.hostedemail.com (Postfix) with ESMTP id B96B540011
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="jDK/KsBm";
	spf=pass (imf27.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsB5qCtpghq+0b8Sr53ex3YJVapa9xrYcuOCYIKavx8=;
	b=MEwU/gyJF9uPUdneXqFs8MgiiYWPlKnM6IgcgKBTUfcwgszP2JTxvHmji6IdCdpTY8973l
	LSa7YaX+ntQi4vzqWSLzHk8jh3C3E63E7pp3uQUyUBvvSR3aoKr1OtIA2TnGa6Q5FA32GK
	GgqbcLbjYf6Obn6iszmen68lT4i693w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="jDK/KsBm";
	spf=pass (imf27.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312151; a=rsa-sha256;
	cv=none;
	b=jFFxci1CsyGy3FOsNORDu4aBQLIm1xfxt4eacBdvxcnwdUkl/bKVQpyvSbR3HUmEqiFQLA
	CuNUM5JXHwDaAtlJ2dsZZjK/KBh78Vjgy9vLk5fI6tLesqlYAffWocyICEKhp/xhXi/5Kw
	P6p70TKhTB5MICDE8UdA73ElptaO5Pg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312151; x=1800848151;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=chu3mCAeP0wjFOIz/yBzyDrIjGaCv78aq80eLeyDUEI=;
  b=jDK/KsBmk6N+mY+80S/1FLGDYvG6VD30+v4LUvMi39R5JrNxvMT1pAM5
   Om6quO8KFHynZM1DSy/xKFEuGGXwUhOIspRufcZtuM2dpt4aqO1gJ2NaC
   sMlY/YNKvTQwPh4SX5qoWyCjFqg9fPULko8nqQS9DGdbWNAEYq8pBCvhW
   OV87GAJzQylIUPOKaLhurEwbNAVN6WbfUSc5eFb/e0IkZA0h+R/QhEgJ0
   wWYOKc0HlcHbg5wxvkzkrh685a3fgg6zOIHk8giHsT/s9kjp/bjck32nO
   ARbkxaDbIfaYERPg0kFnahYGnPLdH+Nrly0qasQqj+PGsJGZ5+mN2nuSq
   Q==;
X-CSE-ConnectionGUID: F0PojPoGSsGTAUzXM3SptQ==
X-CSE-MsgGUID: f7biN84dT22BrsTsp6z/jQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887421"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887421"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:51 -0800
X-CSE-ConnectionGUID: T/10WBPPSwms9qTZoautxA==
X-CSE-MsgGUID: pC5tBX5jQ1ml8oNpW3wuOw==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:49 -0800
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
Subject: [PATCH v14 08/26] crypto: iaa - Refactor hardware descriptor setup into separate procedures.
Date: Sat, 24 Jan 2026 19:35:19 -0800
Message-Id: <20260125033537.334628-9-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: sckrdo8cknz1dgh3yendgc4nwwz8y7s5
X-Rspamd-Queue-Id: B96B540011
X-Rspam-User: 
X-HE-Tag: 1769312151-809418
X-HE-Meta: U2FsdGVkX192I40pCkYwMh0KbqwzzZjM6kBsu3q1FFW2JRNHeCmpYhufniqlCryxzs3c7z3cEyoNhJPH9HNbIIFj5j7Iql8zqPOD3WwekwhY2yn1pfOV8ZNcomazXlocv17AEvBZNVbwhyblPZXfil/K2Id/ZlebxEQopXPN8S3z8JOpsf8T7E2P8SDwy+zPXFyqowWpj0Dabi9/Mfpu9Cn+nOtLu1OlCpo2mn0lU689Eg5JFV2CQjRfKpus6hc86fVHawfnbQgF+mBsux0PvW1FPieVKWiTPax/Hcg6gacuhVfM/nCIx7odZ5qhzbuIanyCo4ZDR0EKx2xs/eSyW4LWkO0xZfaX1tCrhqIpqLr28I9EJKY4BRBW189mj/pXZ2wK71zwqNLkNZqjEiJEmmGXbYloCDC4EqG/+glDNDFG4qr2lXTCZx+pWEO/XRgEYUR47DktWzTi5GpaeaWtwzwasTk/qpNllTzXVwCUfyZMCGa8iHYQVl6fJCUm61bE/pFcBQldBeHfbKvb38oYgj8Zk2tOGPj4iQ67uQjTdvKDcvAWa4417n7BK8Vj2M1Lx+GCD4rU16nW6p7I37NAWqNJ48zzjrCE4lt2b4jM7z4rvsDdOcGiNYjuHuvaeWe3hDjAIhv1D1kZXA5OxsqnsdEyuDS7ARKVl8Tsg3HmWx5Nmirz/1y4d2sRPP1jOYfZwlvSHEqa4jDNEm2Ko8OPQsgxIafwGJ/VG5d+/OmbGvPFByoaDZTmXSVL6y1Kz5eHjqnU2hnP/2Ql9IA5hx7EsXp/Zg6fXP8HTNdO+LM0XdyR1BqDOKFfXuC6Ay6+grotddg3iK3P1+REqYHHSn7cSeouK92MPdUPdo88Qvq7zhVZE/qeBBOBQLK5jp6MUheGVat+s0g/pKBbL1I8yJ87kiyN9A7/JZa01VPg9Ulb+wPp9OWZi3aKg7Jfhz8tuOKSw7VNIPCL2Q/o6TnQgLn
 /0Jqrlkj
 5vFKmi8/Iqqel/ag8p16gFYh1G6iw7R8y6Vm0yC8Oz/JbOzNyAD4rsKqdN2zCTt1LAxzXaXDU9eJcBV/rWO4g8ygg0KwDl7SMjvqgrYiLNAppdQpexFtRfmkfdxxdbeM4YAeBXRKw9ki5bIP1bXunCOdYav3iGDssuVf6swSRdfICP5BXhu74xRunYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch refactors the code that sets up the "struct iax_hw_desc" for
compress/decompress ops, into distinct procedures to make the code more
readable.

Also, get_iaa_device_compression_mode() is deleted and the compression
mode directly accessed from the iaa_device in the calling procedures.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 99 ++++++++++++----------
 1 file changed, 56 insertions(+), 43 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index a727496d5791..f0e9eb52eec4 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -484,12 +484,6 @@ int add_iaa_compression_mode(const char *name,
 }
 EXPORT_SYMBOL_GPL(add_iaa_compression_mode);
 
-static struct iaa_device_compression_mode *
-get_iaa_device_compression_mode(struct iaa_device *iaa_device, int idx)
-{
-	return iaa_device->compression_modes[idx];
-}
-
 static void free_device_compression_mode(struct iaa_device *iaa_device,
 					 struct iaa_device_compression_mode *device_mode)
 {
@@ -1571,7 +1565,6 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 			       dma_addr_t src_addr, unsigned int slen,
 			       dma_addr_t dst_addr, unsigned int dlen)
 {
-	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
@@ -1590,8 +1583,6 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
 	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_decomp_desc_timeout)) {
 		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
 		cpu_relax();
@@ -1667,8 +1658,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device,
-								  compression_ctx->mode);
+	active_compression_mode = iaa_device->compression_modes[compression_ctx->mode];
 	dev_dbg(dev, "%s: compression mode %s,"
 		" ctx->src_addr %llx, ctx->dst_addr %llx\n", __func__,
 		active_compression_mode->name,
@@ -1748,12 +1738,63 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	percpu_ref_put(&iaa_wq->ref);
 }
 
+static struct iax_hw_desc *
+iaa_setup_compress_hw_desc(struct idxd_desc *idxd_desc,
+			   dma_addr_t src_addr,
+			   unsigned int slen,
+			   dma_addr_t dst_addr,
+			   unsigned int dlen,
+			   enum iaa_mode mode,
+			   struct iaa_device_compression_mode *active_compression_mode)
+{
+	struct iax_hw_desc *desc = idxd_desc->iax_hw;
+
+	desc->flags = IDXD_OP_FLAG_CRAV | IDXD_OP_FLAG_RCR | IDXD_OP_FLAG_CC;
+	desc->opcode = IAX_OPCODE_COMPRESS;
+	desc->compr_flags = IAA_COMP_FLAGS;
+	desc->priv = 0;
+
+	desc->src1_addr = (u64)src_addr;
+	desc->src1_size = slen;
+	desc->dst_addr = (u64)dst_addr;
+	desc->max_dst_size = dlen;
+	desc->flags |= IDXD_OP_FLAG_RD_SRC2_AECS;
+	desc->src2_addr = active_compression_mode->aecs_comp_table_dma_addr;
+	desc->src2_size = sizeof(struct aecs_comp_table_record);
+	desc->completion_addr = idxd_desc->compl_dma;
+
+	return desc;
+}
+
+static struct iax_hw_desc *
+iaa_setup_decompress_hw_desc(struct idxd_desc *idxd_desc,
+			     dma_addr_t src_addr,
+			     unsigned int slen,
+			     dma_addr_t dst_addr,
+			     unsigned int dlen)
+{
+	struct iax_hw_desc *desc = idxd_desc->iax_hw;
+
+	desc->flags = IDXD_OP_FLAG_CRAV | IDXD_OP_FLAG_RCR | IDXD_OP_FLAG_CC;
+	desc->opcode = IAX_OPCODE_DECOMPRESS;
+	desc->max_dst_size = PAGE_SIZE;
+	desc->decompr_flags = IAA_DECOMP_FLAGS;
+	desc->priv = 0;
+
+	desc->src1_addr = (u64)src_addr;
+	desc->dst_addr = (u64)dst_addr;
+	desc->max_dst_size = dlen;
+	desc->src1_size = slen;
+	desc->completion_addr = idxd_desc->compl_dma;
+
+	return desc;
+}
+
 static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 			struct idxd_wq *wq,
 			dma_addr_t src_addr, unsigned int slen,
 			dma_addr_t dst_addr, unsigned int *dlen)
 {
-	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
@@ -1772,8 +1813,6 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
 	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_comp_desc_timeout)) {
 		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
 		cpu_relax();
@@ -1784,21 +1823,9 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 			PTR_ERR(idxd_desc));
 		return -ENODEV;
 	}
-	desc = idxd_desc->iax_hw;
 
-	desc->flags = IDXD_OP_FLAG_CRAV | IDXD_OP_FLAG_RCR |
-		IDXD_OP_FLAG_RD_SRC2_AECS | IDXD_OP_FLAG_CC;
-	desc->opcode = IAX_OPCODE_COMPRESS;
-	desc->compr_flags = IAA_COMP_FLAGS;
-	desc->priv = 0;
-
-	desc->src1_addr = (u64)src_addr;
-	desc->src1_size = slen;
-	desc->dst_addr = (u64)dst_addr;
-	desc->max_dst_size = *dlen;
-	desc->src2_addr = active_compression_mode->aecs_comp_table_dma_addr;
-	desc->src2_size = sizeof(struct aecs_comp_table_record);
-	desc->completion_addr = idxd_desc->compl_dma;
+	desc = iaa_setup_compress_hw_desc(idxd_desc, src_addr, slen, dst_addr, *dlen,
+					  ctx->mode, iaa_device->compression_modes[ctx->mode]);
 
 	if (likely(!ctx->use_irq)) {
 		ret = idxd_submit_desc(wq, idxd_desc);
@@ -1860,7 +1887,6 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 			  dma_addr_t src_addr, unsigned int slen,
 			  dma_addr_t dst_addr, unsigned int *dlen)
 {
-	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
@@ -1878,8 +1904,6 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
 	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_decomp_desc_timeout)) {
 		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
 		cpu_relax();
@@ -1892,19 +1916,8 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		idxd_desc = NULL;
 		goto fallback_software_decomp;
 	}
-	desc = idxd_desc->iax_hw;
 
-	desc->flags = IDXD_OP_FLAG_CRAV | IDXD_OP_FLAG_RCR | IDXD_OP_FLAG_CC;
-	desc->opcode = IAX_OPCODE_DECOMPRESS;
-	desc->max_dst_size = PAGE_SIZE;
-	desc->decompr_flags = IAA_DECOMP_FLAGS;
-	desc->priv = 0;
-
-	desc->src1_addr = (u64)src_addr;
-	desc->dst_addr = (u64)dst_addr;
-	desc->max_dst_size = *dlen;
-	desc->src1_size = slen;
-	desc->completion_addr = idxd_desc->compl_dma;
+	desc = iaa_setup_decompress_hw_desc(idxd_desc, src_addr, slen, dst_addr, *dlen);
 
 	if (likely(!ctx->use_irq)) {
 		ret = idxd_submit_desc(wq, idxd_desc);
-- 
2.27.0


