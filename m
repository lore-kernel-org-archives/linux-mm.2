Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2610C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9636B0098; Fri,  1 Aug 2025 00:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 890CF6B009B; Fri,  1 Aug 2025 00:36:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72CBC6B009A; Fri,  1 Aug 2025 00:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 624176B0098
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:36:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B7D4161005
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:53 +0000 (UTC)
X-FDA: 83726928306.29.3BE98B6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0189440002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S5uaaoGn;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P71ZVWpejbikExF80/FbYLY4NQ3GmXXkJTLNydD0qhw=;
	b=EPTyr1hZcB6WFB2Flr7rLAdoQ3yzDO0KpgkZtBKw87daIY83ZrUjeDSBuidceg9AskbQZS
	4wGYXmODTl+E6c6GVeLGRLN0o3Fkx98TCdq4XcPit4F48cn5FxqPsG4JXDRu3gFfgvcRT4
	SM5uEDWqNsAP73VKsbadx/uaIItqP74=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023011; a=rsa-sha256;
	cv=none;
	b=KsGvpyVvuzYzHrjDACizReF9HzdDM7jX7iyvqL/oGz5QyMnSssSavVPwr2Oa7AxLzud79e
	XC90xwDlos+Da6zWs2gomNXfn5PPzI8NrI2kXuJ9ufnhBFA1gU9ZB4w8DeastNrTrWac3Y
	XfJoieYXcipR0C656Kjg7Pq6W8m1xSo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S5uaaoGn;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023011; x=1785559011;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PJ41q0Y7ihf1WJHkg7xm1DLmymsBSt9wZer2lSF4sMY=;
  b=S5uaaoGnjDc395KIhNkTPZuDIYEMBejTeIBe/VX8W3mm7r0aGNd6vjil
   YaVxbzJLfHubQGbDmppQNU4xvVGNGAk5m7RXvJ5WYbWulxmZkLFjQ9NDF
   jDqXe8NGPw5yMeMwau0tFIio9maz6k0fEY3pcM7Z9sW9tlr9xwCdjG9W5
   kJMq3+Kj6t3IUoFi8Y88RLiN5gM1uj7QvdfvLq3gq8ChxLNfad1SbLe5Z
   YDMXyiMM6SVcWpV2EHYHMdzRpDcCIUEoPhmLNX+K3XMveA3UR6FtJe6tg
   8+YpeLQqF+HYJArDyHt4HCkYqfJBlCcKowKBcQoSTUjjXPFDE0wwUo9On
   A==;
X-CSE-ConnectionGUID: MxdEpQXxRmeohfouWrREkg==
X-CSE-MsgGUID: g43n2DwLRuegVIlvgq9cvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820232"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820232"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:44 -0700
X-CSE-ConnectionGUID: JsvaVsAuR+qYlTdKP6vE4A==
X-CSE-MsgGUID: jEwjxL83QAK6lr2C3H8LPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796246"
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
Subject: [PATCH v11 07/24] crypto: iaa - Refactor hardware descriptor setup into separate procedures.
Date: Thu, 31 Jul 2025 21:36:25 -0700
Message-Id: <20250801043642.8103-8-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0189440002
X-Stat-Signature: 8kw3xxtcsnq4yu3ybs65oj8ibjjg11b6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754023010-848543
X-HE-Meta: U2FsdGVkX185sBFgZUao4WXYYQM5J/5v6FzDn7mu+Kco9QCTGsAT3CBW+CO7klvIoG0XjA4mm1E42HyK7AHpE+W4l849OcDaQ5dQ9ccy5YzjO6WdaG5YthwWfoEmTbv6BniGvGFzCMgwMwSrBkxYYD0BFmYiElMoeWyFUExvDmEaIi7sLCfAME0xL/T63TJ650jY9sxenEe3Ry07Y6Dy7Z72mK+TQHFcwQ4hNiBCrueOTp9WLmi5IzMaIgBPJTHZLkHJRqeyGQHsWTadqmlmsC5F8BZXV7fZBqTNeK84PrUIE677CE63q3KZvePTdXCkYyHYRAOgjXcPMql42LOO1Vgjva8J5Akh4duQQ09YacbdgjgLukE8UQz2qQEUNOG4d499JxhHR+ZKDW0WwEA98qWEUzYBa9C9wdzlEcVJX12P4prBi2yJM2ipHEteyxWddVcwZlwpO55HtCB/1i1hTJvr0tc97UJ5ez3Q0HW3EpxVQ9oTz/MYX+rclWmfrP+kiHZOkYFcwrx7Az/S2KTO5Pj7qFsR4g2TUFWOB/EKb5mzxrzirJHTjO5MGMsVWrbRR7UZbDM2Q8CQfkCkCLQwIeSM/Qu4JBqIRpW+8f+YuflE4w/s+gGQOtw5ebpraX2QY87B0OxKvFcTvxMw2IxqYGAJvVVisEf8nl2OxeS8rDjU026nWzQIAwWKJ0s86molw2n1jPBG1ynaogtl5oazkgpH99B7DUEocz0JVy47yK/1zDUQCInRPj+CahFZ7YXZQuLNFR/D/7v8bY4yayIxfTAYbXO2mGACkKvOcL0oWSJmNTTWPyAvKGp7qTqb+SfRMM7IVaI4bYEp4MeEMevVc927x/SXsnIKlOZ0AhHJ3ptbN90cYFEmIURdCyfhfAU9KWVyNu/uu+0+TAL6kraijGpyBJjOAoZzvs4LSfxj3d8xIwMdzgWYfbMSybfhzKnk3qoN2+zhk5W7+NW5baN
 goWiiCFR
 5aNirRvizsJzjT52wIa2EZr4K4h+B7QDXIXHwqdj2nYVPBKoWAbjqNEQI7afGNjcb0ceZK2wpwDZUJydUugqBjN4czlaS3JmYPrAQ+N64uV6otNQc7CotPT8/xKlGoHS2K7QgQJLE43SxfVI=
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
index f80f3ab175a48..a9e6809e63dff 100644
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
@@ -1564,7 +1558,6 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 			       dma_addr_t src_addr, unsigned int slen,
 			       dma_addr_t dst_addr, unsigned int dlen)
 {
-	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
@@ -1583,8 +1576,6 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
 	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_decomp_desc_timeout)) {
 		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
 		cpu_relax();
@@ -1660,8 +1651,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device,
-								  compression_ctx->mode);
+	active_compression_mode = iaa_device->compression_modes[compression_ctx->mode];
 	dev_dbg(dev, "%s: compression mode %s,"
 		" ctx->src_addr %llx, ctx->dst_addr %llx\n", __func__,
 		active_compression_mode->name,
@@ -1740,12 +1730,63 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	percpu_ref_put(&iaa_wq->ref);
 }
 
+static __always_inline struct iax_hw_desc *
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
+static __always_inline struct iax_hw_desc *
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
@@ -1764,8 +1805,6 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
 	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_comp_desc_timeout)) {
 		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
 		cpu_relax();
@@ -1776,21 +1815,9 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1852,7 +1879,6 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 			  dma_addr_t src_addr, unsigned int slen,
 			  dma_addr_t dst_addr, unsigned int *dlen)
 {
-	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
@@ -1870,8 +1896,6 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
 	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_decomp_desc_timeout)) {
 		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
 		cpu_relax();
@@ -1884,19 +1908,8 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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


