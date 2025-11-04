Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A04CCCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FA5B8E010D; Tue,  4 Nov 2025 04:12:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082928E0109; Tue,  4 Nov 2025 04:12:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8CCD8E010D; Tue,  4 Nov 2025 04:12:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDEC28E0109
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:44 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F3CFB981A
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:44 +0000 (UTC)
X-FDA: 84072359448.23.52C9682
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9449E40013
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LTW5gzTx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247562; a=rsa-sha256;
	cv=none;
	b=mZFyxe1ReCuyV79Oe/BUbkm667+b1soLTvW41c5YZvDQCDwJ9mJARnKcmUfaeEFG3O7bJq
	Hcjbp/byDHpQGw5nfO7K49KG4PZybGigG0sP17lx+3nrMPRz5XWOuk4+gVSRD5M+BfmQlB
	LQoNu2JsosmX6adfYzHmKVHXUvuoz3E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LTW5gzTx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFDiYvP33Ir6Ilh4jEfQpbx7I8wZnRVk9fGIQ6Acj5Q=;
	b=fdf3QAvhB6mse8rRNfiV8B0qPMNkgW113kpfCsvZlnwvc0KrlEstJzomPf28/rSYfIPe02
	E1VTou72/PUbNJ1lrDe3zX+hmE3tlcNp2w2FXf7l8HNQQ2pj3KD9EGiEkrV8bJInIAf8Ah
	RAyAhy5pBpIPmDp/owtPg86wJgdzZYk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247562; x=1793783562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hcUM15fRJGMKAEAHFUE5/pmeQmEhBmfG4TIDV4Z0wWE=;
  b=LTW5gzTxpQx+04/WNYxC/bTWeKNGOiDQIGMHFy6vo9FauJR7TzpFA583
   6IDeiWLpew6jdsBoemcaLK5UF8E8Uoyb4M6+AsFN57vE5pqb2sW03vdlz
   zPXzkqe7amCSodF3ki/BhfFlxfLRTWZ9pmOh6WuS0TcsBzd+isgwJKaOM
   WjaeFurJ75Vq9c3K0jrcDcLBx9wdYTt11KVNAqNoC7wWhlwv1bmxnEA0L
   hnr1pbMEebuHgQq2f41LakFkIL6DdZJ76Kc79UhhJV3FCjPRpU8x3FO0l
   3EocBzgEPhLSe6mOjtp/uk8cu2/K8iaTB/NaquYYFnExt+qwuJefEVNwR
   A==;
X-CSE-ConnectionGUID: Ti7dhXAES2SdfXp4C2uJcQ==
X-CSE-MsgGUID: a8FZcLQ2SjWVj+zyPmIlFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265176"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265176"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:37 -0800
X-CSE-ConnectionGUID: 6d87QPIpTaK5Sniegvufbg==
X-CSE-MsgGUID: iM1k1y0rTvSE/IajcMFd2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795794"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:38 -0800
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
Subject: [PATCH v13 07/22] crypto: iaa - Refactor hardware descriptor setup into separate procedures.
Date: Tue,  4 Nov 2025 01:12:20 -0800
Message-Id: <20251104091235.8793-8-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9449E40013
X-Stat-Signature: 1u7id7meu3qyoqreuzq5fhi7zzzfokoa
X-HE-Tag: 1762247562-141442
X-HE-Meta: U2FsdGVkX18R7Lj2kG4IXvTeW7vk5ntaGOQZ0p7vb4/1+d5lsG8WNA1PYHgSSqILtgavXoCmcNSD1CrzukX0SZhYaJemGbDMR6o6yRBbzHRrSp8y7cdne94AZT+QvSICAmTqQIzPbI0O+BIzVduSRrGMIwHfTTfS5gERdQ7qTpFsfCmqdW1yazaZacjlvPDbOZq1B3QJd7tW3YDdmfcfYRtaaZVpibdz8mIR8vAx7UgoregW3e/c2e0Ja4n8uv/2ICgMhlZmOKdG4vWlwwRY/KguLT3gqabWUL9umaX0mSjQhglBorwM6agDiFC/81eNaLOgJgamf9iPontBCfr/yFwqBdb8/F7mtdRNUC6LQDJiZ/Asc4Uai0fpM85dUTH6Kf+ocwfmUuVGYr09RkPDDR0iqThYWo0MIqaNZL/js1FzMxEHbfXWVw/GwT+Mttq1zrX4jY9esXf6jSdxdrRIe3m6jvzS1QafD1b1uu85ciyXykYY/TpUF/khYWa3umu/C2j6yFUzIkV45MgSCzwanTb7SfhfrIOVLSl1ikzf2yButgVDU2UPb1n4jko6jTsp/0lGkiCj7XblJQC4dJQ0wNXty+XOT2xtyfHXozOEgiFYJNYalK/YNP3h7Kb++h825vJeVox4mjqgl6qFxIyDeHzVX/46WIuWTARG18Gii1eT5m+v68p84p3G+31LMRXdq8ihUiS5s7A1m+WZl/ljqf1CpZQDpm5QqiGfzgs2pO1aSa1wkse3VvAPqeEFMVMTfLfjmWRbHz03XyzzeE3FQQ1Chf5UtI+apvuFF2OHvcj99RZCUuE7oNmeKjIhtUcGkPntM1Ak5syIZPHGdsqeZ3zmWaPRCDnC3lLWMZRe4sAT9DgRwLoD6Y0H6NSpf2dpogmPKpuAuPjdEZgdxphyfWrEwcRFky25nFvHv95CvylRkM+an2Z+OE3YMGM1kAYcG+JdNO0nDG1DZh8VcQF
 cAplK89d
 Y9sncdKpl4CkHvE1pDzNbcVYLSahmWF9cTnW8Jr0A3QMsBSM8Zd07y8/JafPHSJCmKGdigJ0HEeIh/X55Gl9cuaXywpuewGLonx9PfyiNMVShJ+rzOZWpsHw7ZRfZ4E1ZoCaWK3RMLCNPTnJIOnOGwRRPxqQD4YS7hrAbCcwovYRI9M033jDtwxsSUA==
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
index 74d5b451e34b..697e98785335 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -483,12 +483,6 @@ int add_iaa_compression_mode(const char *name,
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
@@ -1570,7 +1564,6 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 			       dma_addr_t src_addr, unsigned int slen,
 			       dma_addr_t dst_addr, unsigned int dlen)
 {
-	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
@@ -1589,8 +1582,6 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
 	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_decomp_desc_timeout)) {
 		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
 		cpu_relax();
@@ -1666,8 +1657,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device,
-								  compression_ctx->mode);
+	active_compression_mode = iaa_device->compression_modes[compression_ctx->mode];
 	dev_dbg(dev, "%s: compression mode %s,"
 		" ctx->src_addr %llx, ctx->dst_addr %llx\n", __func__,
 		active_compression_mode->name,
@@ -1746,12 +1736,63 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
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
@@ -1770,8 +1811,6 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
 	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_comp_desc_timeout)) {
 		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
 		cpu_relax();
@@ -1782,21 +1821,9 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1858,7 +1885,6 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 			  dma_addr_t src_addr, unsigned int slen,
 			  dma_addr_t dst_addr, unsigned int *dlen)
 {
-	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
@@ -1876,8 +1902,6 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
 	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_decomp_desc_timeout)) {
 		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
 		cpu_relax();
@@ -1890,19 +1914,8 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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


