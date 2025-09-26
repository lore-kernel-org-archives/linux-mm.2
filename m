Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A6BBCAC5B5
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F9F88E0014; Thu, 25 Sep 2025 23:35:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A92E8E0013; Thu, 25 Sep 2025 23:35:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249EA8E0014; Thu, 25 Sep 2025 23:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2588E0013
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:35:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CC67EC0568
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:18 +0000 (UTC)
X-FDA: 83929985916.07.516AEF2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf28.hostedemail.com (Postfix) with ESMTP id B0CA0C0004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hTRZSwRv;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758857716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eX8UsgwzY7WbpyA/jTTT8eTtd67A6JRzRgg054s+cmQ=;
	b=oqjOcd0/EV0yNZG5QiaTTEiiZ0qc7FLvJxDNjGqPnNqxurEZjZfiUH2FWN6M89i2qq8qfy
	acpYdGjh/0phVP2Kqa+q3n02/zhkkG3qs+VaMi8cx9iAmn6lfhL8kgYUAWkLjF5KhIQmc5
	5gUtip8ahceLl1/zN90IJkjJ9O546sM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758857716; a=rsa-sha256;
	cv=none;
	b=RQjn0f3RuoITB71k/OFaVWWZgSgO4o+EsMN3CQbNitCRd+Xy/C88FeQRqNpwHKUT4MpCNU
	KWS+aKwNA51oER+uUm4v9JllAuA5LTvVCU1DPNxFADLpGkn6qUejP/eyFXAUC55XR+HWLi
	+v2NHvmyuk65jL13bPlmhTa/gXu32Ow=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hTRZSwRv;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857717; x=1790393717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O6Y/KqSHNNgjHA7lJ/nseE1s3+rHj9XrHsce22HNXnk=;
  b=hTRZSwRvT61+umwC7epBfzlt1vkBlUCVGQdWnrH+CYg/ZpiaxMHPILEG
   GezS0l03+wo/rSb4kMmdL0EVzS70hs03q3NwKXiN1oIIxENvvTt8O5Aot
   T45V4C/SgZj/QEQ7D/B2qhEwdhnVlNedQucDg3ZfhV3eFehFTXwZje24U
   JrA7S+YFiza5MzQJRQoQQRu/8Ul7GFckn3VY7eepQZWtBjR7Xpe+8nLHU
   g6hd1tt/G5JGhTk6uNVpxQe9XZP4KvpV46KtHbHCdWC2P4N8WsBG06m+D
   1fQ+gA097S1lCu+YKExOYNrlkFRtQOkWtjdGL9ZuQmbYiwxt5ley9cAqE
   Q==;
X-CSE-ConnectionGUID: ojyQIfwqTKq1aNlA8vnkUA==
X-CSE-MsgGUID: +EepdAuUQQeOVufMzEZERA==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819549"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819549"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:06 -0700
X-CSE-ConnectionGUID: AFxCyJRuTT65k9GCwiosJw==
X-CSE-MsgGUID: +ZdoxfwoQgS5NAUBnswviQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636583"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:05 -0700
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
Subject: [PATCH v12 12/23] crypto: iaa - Enablers for submitting descriptors then polling for completion.
Date: Thu, 25 Sep 2025 20:34:51 -0700
Message-Id: <20250926033502.7486-13-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B0CA0C0004
X-Stat-Signature: hwozfcum3qu13i3a76pty8691ifsks7o
X-Rspam-User: 
X-HE-Tag: 1758857716-791216
X-HE-Meta: U2FsdGVkX19Xro7uuCCnUKEb/XRoX2mxJelcNQB15dUTV/f/83CkrLXV0KxgKJrsVqdhRDk56lK+A5Rhnck4uU6SY3y13Gp37XDxHhb/nA3KsIbKgc86clJSX8q4F0tAK5hN6H4YyB4P7XsJtHZeCNfZ4m0m6/MI8rDPb+4+IWyU7+4CmyTpkAUPvnZo4t1OVlRgfTLRt+trKBGltMKsA5oaNBQ6o4IdPa13ANhgXfFnrutERF39+Xos9r/mHOF743+jateIW1xhlUl4zIJZ3JqW88X4LerYFhPvVgYcl+edqfcAru15nzq9dGng0C/FsCGNH2+spsS+nNdKm3A9ts5bVTofZYl0jyEgs127Kz4UuP4reFmjqoJJ/fUodlgF4oXvxC6ozf5KL0gU1wXOENyuwhljzsflBxFEJ6Zp92tROuTrqZbUTNkGYXeU6X9oLSf7dXqN9LGVQQNO7J+Z26KxYJ9M6vLXS8H347mRa8LC+uiKYuXnFfSxbhHfge5yC+Q6fpLk1LBZnriS0Fvq//ZPZL6vINq7A/FmCJ2FYaEv4mtjO2SjOOOZhCChWrn1hjKHkefTpS2V/8GHguTlLKZkBiDMPj+aLdhZzf+B4rExLzGqhGkou1tXhFJFYfPAfx7uFQHA2F/ABiwgpKrZldbBpUNnWPQ1o+eUdUiHDkprTxsW7GflyByHEll3Atoi/8hGXTYFQKE4XOXY2Z5o6HIhamTEtBHAH1wKigj1Su5WQeV16EGK0GzObWK2YHB0JSVLimN10h0bLy/DWo5sHqVhNvs9C/BUqVRzpDoLcQmsbtjfI0w32SgxL0hCOskBrYHOB3o1U5fczsCFT8aANjEgwxjt4S1ZV4JU+JVsmljRNT8kb3cJB00BDjjCBuPzGBBOSnmiO8Nn6bK9qRdnUzhK3sX6vG+zWtbYz/aLa7ca9ht8ho+hx5dFQQgjv6Zaj3gOqyICfSk5imYEz60
 Lyaf2jNb
 JA+eaMvrnIsTZBhD5jhbiNbN2wcXq5RpXgu+QIMUdFIarrf0kM5JCu1RIhHZeObJ0QGMH0qOMxDLQYtafoMBIBaMvtpA7Iu7GA1FuklveKubMcgu2U4Rg1rBNQBZAOjheUB5Vp0iKwntsmVaOGk8A0RBS9ScNPrlsGgSTFKaV3uEqSEUVIlBt/ha9HA==
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

To summarize, both these conditions need to be met for a request to be
processed in fully async submit-poll mode:

 1) use_irq should be "false"
 2) iaa_req->flags & IAA_REQ_POLL_FLAG should be "true"

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto.h      |  6 ++
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 71 +++++++++++++++++++++-
 2 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index 190157967e3b..1cc383c94fb8 100644
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
index f5abad950371..7395822430b1 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1891,13 +1891,14 @@ static int iaa_compress(struct iaa_compression_ctx *ctx, struct iaa_req *req,
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
@@ -1979,13 +1980,14 @@ static int iaa_decompress(struct iaa_compression_ctx *ctx, struct iaa_req *req,
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
@@ -2188,6 +2190,71 @@ static int iaa_comp_adecompress(struct iaa_compression_ctx *ctx, struct iaa_req
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
+	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
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


