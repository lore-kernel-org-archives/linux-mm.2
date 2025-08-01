Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D161DC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50B186B009F; Fri,  1 Aug 2025 00:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3E16B00A0; Fri,  1 Aug 2025 00:36:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35BF86B00A1; Fri,  1 Aug 2025 00:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 248086B009F
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:36:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB773141005
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:55 +0000 (UTC)
X-FDA: 83726928390.28.4152927
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id E4A3C140002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lzQEhQaD;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023014; a=rsa-sha256;
	cv=none;
	b=qzu7knTKCTerLR53pU2zuw6BPc2u3KnWDHMMwMfprUyuJbOUc90M2aVSa97sXwDcECi+39
	ZMEQG7oD0lbk+sFD6vC+NjRdkzH5yYKUAry+yLLmn0WF0Jz+iA250PwLga0Dbu4luL0ABk
	CE70Cu/VERYyPpR7rNDGIDoXC6VRT04=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lzQEhQaD;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfkOk+7YvAii/Uvi/rP+wqSfFv9F8La/8f2rm5p4hn8=;
	b=OMpCvOfp8jaoFzcRZIVoMEwQZTiWSfe+WNOPb6OlqkuOl+ZLuyWX1VLavLHS38pRauyByg
	o/ILZBc8ewfyhHUMHZSPFUEGcmgmRWJf6zBVU9YejjY+HISxGXII/Tutzm2A3NKhsgAKjJ
	mvkQf6YXAIB49FQg8rrnI+dATWfyccs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023014; x=1785559014;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Juz5+DSaK7h1p94wTjZ2U4q/C7jNNHsj9r4rfBgefQ4=;
  b=lzQEhQaDwAVw4jpvuiUuk8XCIqvQw9V0lbtioFGBRSM04ZVeFHjfE/Qa
   EVGpChgNiqKbGHY094LgwWSArYlw5Zob/PRY5O81p/OtxN63GfTBDGldQ
   VvNZ4DGg3JQEvdnNM3+UIShiD6obqHenQYM0XpqHtPEamwIM/KkgXnDgx
   YpszJJTJLXeWwj/WA3It+jrq87u5re/LSzyW/DuIs1Y+E56ee5qpq4TtS
   hgDXSioC15vfDVx0hUbzPNoqLQMJ9pFim4Mh/25BPA7WFWhrG/RpQOXuc
   K4JlWssPBadPZhcZku4dXPQnM9dGf1p3nHnvPMaUeY73nZnzfSMGTJFBV
   g==;
X-CSE-ConnectionGUID: pLlymP74QgaR+r88nJppcA==
X-CSE-MsgGUID: 1yf0QGWNQ+uatsgSw+2XNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820279"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820279"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:45 -0700
X-CSE-ConnectionGUID: 5ROpvnbGS7WVFDKrg3S45A==
X-CSE-MsgGUID: AFBWeA0+QyScJQlbFa/8Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796262"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:44 -0700
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
Subject: [PATCH v11 11/24] crypto: iaa - Enablers for submitting descriptors then polling for completion.
Date: Thu, 31 Jul 2025 21:36:29 -0700
Message-Id: <20250801043642.8103-12-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E4A3C140002
X-Stat-Signature: ppjfdrqwg1z1cwt7dtmz1uyk5jswd8jx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754023013-907059
X-HE-Meta: U2FsdGVkX1/QWF4G/F1EN3rUVEAKfuZg3n2UaexMaA4RAYg5+ODzoXG5Kpns0n1CJ1mKryUxHZDTapWiUs1Yg+NHjHRmsX6ljsOmtSgQA/rD0lH1y7RDlqPTOOa9G5UmDKDMTBx9P/1YscBSrMZ0VR5ZQXjqRJWVAWkXqsRXSYnHxBj6fFPdhCXOJ24z2CZcCCXOtXvLJlinsEnQwXwgv5MMWzzqyD1al3GF6fJT7EnTMAhM7VtPZDTBccZ7s8CS2b5lD8OmCbziX+RrFeEj6r4VaBRQZBnjQuNtian1c+TJLzJIzxUxdtbID35LHpbGvui+3m91H8TDuB0EG2oJOxvH+q0xeOZyFQQeOkgZl78KPEhLu5tZZzIeuQLHhBCZXdu+z1naT2G1GEogzM+0CbrKFtOkVM4iDhPNuaZCDhn+dqTy55rG8bjxHWAiX7RfkAeMNbQHb5stUxFN/S/XDxXfs/0oOcQdm0w2Kb2Badf8ivq1zg+YqI11Z5jHXm1QzjFTyjZU7Yxm2BwTMoaH5/U0ilHHCywKGC7CRNGLDugQ1Jtb1GqhQookGLW4ChdTBI2n18/XUY2A6MxGuHufam/kIgkYTnjyZgwQhDV7zzlmZky197uBZBKQ0PRREoa/9pX+wQTeQbFO7y3nuqSNHp1zcKlyGGp7owjO5m8EnTUL08HA83wno7wAUSnbicx4aAvJOBlsVAv8NUPj2qVF5MR/gZcLYBeGgREYvNOfk+VRnKLKVijFQKmWj1wmf2JFhNrma0vPRJencI/4qfCzn58c6REYKFNVp6+kOQNgLZP/349CQq/mifrNz2tJPWGMmBV24fPChda6Sr89ApKKYz8P1yjpvzTqgilLyb2tX5ngrb7LOsPafViZeJyjK82H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds capabilities in the IAA driver for kernel users to avail
of the benefits of compressing/decompressing multiple jobs in parallel
using IAA hardware acceleration, without the use of interrupts. Instead,
this is accomplished using an async "submit-poll" mechanism.

To achieve this, we break down a compress/decompress job into two
separate activities if the driver is configured for non-irq async mode:

1) Submit a descriptor after caching the "idxd_desc" descriptor in the
   req->drv_data, and return -EINPROGRESS.
2) Poll: Given a request, retrieve the descriptor and poll its completion
   status for success/error.

This is enabled by the following additions in the driver:

1) The idxd_desc is cached in the "drv_data" member of "struct iaa_req".

2) IAA_REQ_POLL_FLAG: if set in the iaa_req's flags, this tells
   the driver that it should submit the descriptor and return
   -EINPROGRESS. If not set, the driver will proceed to call
   check_completion() in fully synchronous mode, until the hardware
   returns a completion status.

3) iaa_comp_poll() procedure: This routine is intended to be called
   after submission returns -EINPROGRESS. It will check the completion
   status once, and return -EAGAIN if the job has not completed. If the
   job has completed, it will return the completion status.

The purpose of this commit is to allow kernel users of iaa_crypto, such
as zswap, to be able to invoke the crypto_acomp_compress() API in fully
synchronous mode for sequential/non-batching use cases (i.e. today's
status-quo), wherein zswap calls:

  crypto_wait_req(crypto_acomp_compress(req), wait);

and to non-instrusively invoke the fully asynchronous batch
compress/decompress functionality that will be introduced in subsequent
patches. Both use cases need to reuse same code paths in the driver to
interface with hardware: the IAA_REQ_POLL_FLAG allows this
shared code to determine whether we need to process an iaa_req
synchronously/asynchronously. The idea is to simplify iaa_crypto's
sequential/batching interfaces for use by zswap and zram.

Thus, regardless of the iaa_crypto driver's 'sync_mode' setting, it
can still be forced to use synchronous mode by *not setting* the
IAA_REQ_POLL_FLAG in iaa_req->flags: this is the default to support
sequential use cases in zswap today.

When IAA batching functionality is introduced subsequently, it will set
the IAA_REQ_POLL_FLAG for the requests in a batch. We will submit the
descriptors for each request in the batch in iaa_[de]compress(), and
return -EINPROGRESS. The hardware will begin processing each request as
soon as it is submitted, essentially all compress/decompress jobs will
be parallelized. The polling function, "iaa_comp_poll()", will retrieve
the descriptor from each iaa_req->drv_data to check its completion
status. This enables the iaa_crypto driver to implement true async
"submit-polling" for parallel compressions and decompressions in the IAA
hardware accelerator.

Both these conditions need to be met for a request to be processed in
fully async submit-poll mode:

 1) use_irq should be "false"
 2) iaa_req->flags & IAA_REQ_POLL_FLAG should be "true"

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto.h      |  6 ++
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 71 +++++++++++++++++++++-
 2 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index 190157967e3ba..1cc383c94fb80 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -41,6 +41,12 @@
 					 IAA_DECOMP_CHECK_FOR_EOB | \
 					 IAA_DECOMP_STOP_ON_EOB)
 
+/*
+ * If set, the driver must have a way to submit the req, then
+ * poll its completion status for success/error.
+ */
+#define IAA_REQ_POLL_FLAG		0x00000002
+
 /* Representation of IAA workqueue */
 struct iaa_wq {
 	struct list_head	list;
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index fad0a9274a2de..107522142be5c 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1890,13 +1890,14 @@ static int iaa_compress(struct iaa_compression_ctx *ctx, struct iaa_req *req,
 					  ctx->mode, iaa_device->compression_modes[ctx->mode]);
 
 	if (likely(!ctx->use_irq)) {
+		req->drv_data = idxd_desc;
 		iaa_submit_desc_movdir64b(wq, idxd_desc);
 
 		/* Update stats */
 		update_total_comp_calls();
 		update_wq_comp_calls(wq);
 
-		if (ctx->async_mode)
+		if (req->flags & IAA_REQ_POLL_FLAG)
 			return -EINPROGRESS;
 
 		ret = check_completion(dev, idxd_desc->iax_completion, true, false);
@@ -1978,13 +1979,14 @@ static int iaa_decompress(struct iaa_compression_ctx *ctx, struct iaa_req *req,
 	desc = iaa_setup_decompress_hw_desc(idxd_desc, src_addr, slen, dst_addr, *dlen);
 
 	if (likely(!ctx->use_irq)) {
+		req->drv_data = idxd_desc;
 		iaa_submit_desc_movdir64b(wq, idxd_desc);
 
 		/* Update stats */
 		update_total_decomp_calls();
 		update_wq_decomp_calls(wq);
 
-		if (ctx->async_mode)
+		if (req->flags & IAA_REQ_POLL_FLAG)
 			return -EINPROGRESS;
 
 		ret = check_completion(dev, idxd_desc->iax_completion, false, false);
@@ -2187,6 +2189,71 @@ static int iaa_comp_adecompress(struct iaa_compression_ctx *ctx, struct iaa_req
 	return ret;
 }
 
+static int __maybe_unused iaa_comp_poll(struct iaa_compression_ctx *ctx, struct iaa_req *req)
+{
+	struct idxd_desc *idxd_desc;
+	struct idxd_device *idxd;
+	struct iaa_wq *iaa_wq;
+	struct pci_dev *pdev;
+	struct device *dev;
+	struct idxd_wq *wq;
+	bool compress_op;
+	int ret;
+
+	idxd_desc = req->drv_data;
+	if (!idxd_desc)
+		return -EAGAIN;
+
+	compress_op = (idxd_desc->iax_hw->opcode == IAX_OPCODE_COMPRESS);
+	wq = idxd_desc->wq;
+	iaa_wq = idxd_wq_get_private(wq);
+	idxd = iaa_wq->iaa_device->idxd;
+	pdev = idxd->pdev;
+	dev = &pdev->dev;
+
+	ret = check_completion(dev, idxd_desc->iax_completion, compress_op, true);
+	if (ret == -EAGAIN)
+		return ret;
+	if (ret)
+		goto out;
+
+	req->dlen = idxd_desc->iax_completion->output_size;
+
+	/* Update stats */
+	if (compress_op) {
+		update_total_comp_bytes_out(req->dlen);
+		update_wq_comp_bytes(wq, req->dlen);
+	} else {
+		update_total_decomp_bytes_in(req->slen);
+		update_wq_decomp_bytes(wq, req->slen);
+	}
+
+	if (compress_op && ctx->verify_compress) {
+		dma_addr_t src_addr, dst_addr;
+
+		req->compression_crc = idxd_desc->iax_completion->crc;
+
+		dma_sync_sg_for_device(dev, req->dst, 1, DMA_FROM_DEVICE);
+		dma_sync_sg_for_device(dev, req->src, 1, DMA_TO_DEVICE);
+
+		src_addr = sg_dma_address(req->src);
+		dst_addr = sg_dma_address(req->dst);
+
+		ret = iaa_compress_verify(ctx, req, wq, src_addr, req->slen,
+					  dst_addr, req->dlen);
+	}
+
+out:
+	/* caller doesn't call crypto_wait_req, so no acomp_request_complete() */
+	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
+
+	idxd_free_desc(idxd_desc->wq, idxd_desc);
+	percpu_ref_put(&iaa_wq->ref);
+
+	return ret;
+}
+
 static void compression_ctx_init(struct iaa_compression_ctx *ctx, enum iaa_mode mode)
 {
 	ctx->mode = mode;
-- 
2.27.0


