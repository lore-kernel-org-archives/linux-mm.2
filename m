Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42FCECCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518098E0113; Tue,  4 Nov 2025 04:12:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0BB8E010E; Tue,  4 Nov 2025 04:12:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A83D8E0112; Tue,  4 Nov 2025 04:12:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F22888E010E
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:47 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C07F913AE2C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:47 +0000 (UTC)
X-FDA: 84072359574.04.35D29B1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id C90C6C0003
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Utd1XkJf;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6J9AdJ5CiZawMUHzwBW1ziniW8+dunsFRq+F/k2xI4=;
	b=Q3Cc/cILPtWyAXk2sSvox65IWgeUgMb2OsH0EDgGzf19l0kNbj5oz59GxTOuiY8XIsBMC7
	E8kZZWYxzvZfil/fqzLx+Wyjl6rKlIaqP31WWvQv1OkJo9Q57PF6FuKKKzsIhQGo/mQkcn
	Yj+Zdi9Dx6RhcHHBdRe6HiyzNMnc8tY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Utd1XkJf;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247566; a=rsa-sha256;
	cv=none;
	b=OH6FR5g8fdzOHuPNpR8JTEAcJ0zl4urrB9RzhNIU7mAjXDfaOjbY+DSvJb1boOPJvM0bKb
	7gobzFKluf+ssgREM9POLUKCrLUFvoHYLqTrba3VBGY1LFUivpMhLGlUQhIOsRoT2jgGUh
	u+qyBrEWL3Pr22hfPEMR/NzWE4TdYuo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247565; x=1793783565;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rEsrEPz/0zrCVWa4aN50sbVb7C5pN8I1T4EdA4dzSUY=;
  b=Utd1XkJfZTBqQ/JXQv2+zvJ+2iuRv92F3bgma5IpsHWLJt9MdCvEnZCj
   pJF8MWRkFxQ6nEy31UTtQnpU58edgKiFHgiz0h0x91yheIwx9B8U2Ok4B
   B3nE/tSCI35uOxsKRM5vH/9V3D7uE34o9INh41dbi5cPTzQXtjamYTKQZ
   Yg/7dddYwo8cISP2MP8HT4bRp/XdfdPJntVEfpbLFn5kdSs0p1expfQ4a
   tB0egzNprjR9PuXqkbWc/H63wcXuAvc/2Gt54hy2QBqfHNBOSByMXTHqo
   lcvJQGZRPF6Tkjmt9toK1dTowagjtQQNgwfd62SGx4ykLlLbsGFgcwAZj
   g==;
X-CSE-ConnectionGUID: 3Ys5rk+uQIihRpMo+NYJaQ==
X-CSE-MsgGUID: dMaoLSfrTHGuYWGTFHNyOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265188"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265188"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:38 -0800
X-CSE-ConnectionGUID: GuTJUa5BTsWVMAyNsIATEg==
X-CSE-MsgGUID: FCjTrpThS5aZEz4mXM7FcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795811"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:39 -0800
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
Subject: [PATCH v13 12/22] crypto: acomp - Define a unit_size in struct acomp_req to enable batching.
Date: Tue,  4 Nov 2025 01:12:25 -0800
Message-Id: <20251104091235.8793-13-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C90C6C0003
X-Stat-Signature: kdxf3gd8ordf3uudajmmkz4xz6noh717
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762247565-936185
X-HE-Meta: U2FsdGVkX19v/NL519wMUaBdZXv+TqsN69vTByyrsc1ngcv/jJB+tRH02+jpNxnOFYG3R32yzOcJfO7jKU1EvSbj6Kn6v5a9l2VUgn5YKxzrnK/Iadz6VZ4FEXi9crclO3G0RlS7AKE6YkH4d/cQhYcvfejisQF7vUindc4yOMij1jxehmDzhAPYLFn0EGAylZEUR/Asx0y5iqbA/DSsDhry7WXqc4o+B8hGDOAAt1Ff+K1EBhlHlJnn/Wr8RzKcq6uWv4TBSRbOkQXIx80bbCvqfxKv+wrADSovolPG28na4PjbLFDP0V4Jzc/wKAfJ5bvt2FEY1+urHE5Hha6Sq40Ak+LadCJjYUq1knTweLl8oZHNRblOqDBGiNM2673yG5J3aqKGwc3EdJy/gRYLPARIiQJE44YeGc/9oAi5LeMkXNz3fM17iCYyaWZwgj2EEVXf5Zjws9pRclntBpfrQMLAEvHPkW52yltzA9+DKx03GOlH3m1cdnE8SMvk4HFWlSWS2zMTxL33wg8JJBA0LdUGXSoycL1T76zsicZIxzKmLvDycAeKClXjETtlIu/t/T/4ocbfMes/Q9xyTjEWfRITdft+AuNNyxDaNcdPqnGZfTEfUEDLj5M1M6SVtYs48u73u00/pZr3jSpk5/Z6gnlpc5jddlmo95enT6C8Ep8fOM7knPoKlQAwM1ojZ3F8A6Ph8jBUmf6N/w2toq/2tbzHVTSf+WYqT4J3KngD/OEGQk6qbkV59e4hCg9LlA6FmAk85m26G0Ag5+xq4mAjf5UDI42r9rzxwXDQi2XNlsvpg15fQeIORHUudu1whNRDeD8dlOafUjFhZmaYFADTvBcBoOOJKNFJeRApQdUYHknW37PMG8siOe0BS5XSA1wiq37PjRQKhSw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm: zswap: Set the unit size for zswap to PAGE_SIZE.

We add a new @unit_size data member to struct acomp_req along with a
helper function acomp_request_set_unit_size() for kernel modules to set
the unit size to use while breaking down the request's src/dst
scatterlists.

An acomp_alg can implement batching by using the @req->unit_size to
break down the SG lists passed in via @req->dst and/or @req->src, to
submit individual @req->slen/@req->unit_size compress jobs or
@req->dlen/@req->unit_size decompress jobs, for batch compression and
batch decompression respectively.

In case of batch compression, the folio's pages for the batch can be
retrieved from the @req->src scatterlist by using a struct sg_page_iter
after determining the number of pages as @req->slen/@req->unit_size.

As per Herbert's suggestion:

 1) acomp_request_set_callback() sets the @req->unit_size to 0.
 2) In zswap_cpu_comp_prepare(), after the call to
    acomp_request_set_callback(), we call:

      acomp_request_set_unit_size(acomp_ctx->req, PAGE_SIZE);

    to set the unit size for zswap to PAGE_SIZE.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 include/crypto/acompress.h | 36 ++++++++++++++++++++++++++++++++++++
 mm/zswap.c                 |  3 +++
 2 files changed, 39 insertions(+)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 9eacb9fa375d..0f1334168f1b 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -79,6 +79,7 @@ struct acomp_req_chain {
  * @dvirt:	Destination virtual address
  * @slen:	Size of the input buffer
  * @dlen:	Size of the output buffer and number of bytes produced
+ * @unit_size:  Unit size for the request for use in batching
  * @chain:	Private API code data, do not use
  * @__ctx:	Start of private context data
  */
@@ -94,6 +95,7 @@ struct acomp_req {
 	};
 	unsigned int slen;
 	unsigned int dlen;
+	unsigned int unit_size;
 
 	struct acomp_req_chain chain;
 
@@ -328,9 +330,43 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
 {
 	flgs &= ~CRYPTO_ACOMP_REQ_PRIVATE;
 	flgs |= req->base.flags & CRYPTO_ACOMP_REQ_PRIVATE;
+	req->unit_size = 0;
 	crypto_request_set_callback(&req->base, flgs, cmpl, data);
 }
 
+/**
+ * acomp_request_set_unit_size() -- Sets the unit size for the request.
+ *
+ * As suggested by Herbert Xu, this is a new helper function that enables
+ * batching for zswap, IPComp, etc.
+ *
+ * Example usage model:
+ *
+ * A module like zswap that wants to use batch compression of @nr_pages with
+ * crypto_acomp must create an output SG table for the batch, initialized to
+ * contain @nr_pages SG lists. Each scatterlist is mapped to the nth
+ * destination buffer for the batch.
+ *
+ * An acomp_alg can implement batching by using the @req->unit_size to
+ * break down the SG lists passed in via @req->dst and/or @req->src, to
+ * submit individual @req->slen/@req->unit_size compress jobs or
+ * @req->dlen/@req->unit_size decompress jobs, for batch compression and
+ * batch decompression respectively.
+ *
+ * This API must be called after acomp_request_set_callback(),
+ * which sets @req->unit_size to 0.
+ *
+ * @du would be PAGE_SIZE for zswap, it could be the MTU for IPsec.
+ *
+ * @req:	asynchronous compress request
+ * @du:		data unit size of the input buffer scatterlist.
+ */
+static inline void acomp_request_set_unit_size(struct acomp_req *req,
+					       unsigned int du)
+{
+	req->unit_size = du;
+}
+
 /**
  * acomp_request_set_params() -- Sets request parameters
  *
diff --git a/mm/zswap.c b/mm/zswap.c
index 5d0f8b13a958..4897ed689b9f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -783,6 +783,9 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	acomp_ctx->acomp = acomp;
 	acomp_ctx->is_sleepable = acomp_is_async(acomp);
 	acomp_ctx->req = req;
+
+	acomp_request_set_unit_size(acomp_ctx->req, PAGE_SIZE);
+
 	mutex_unlock(&acomp_ctx->mutex);
 	return 0;
 
-- 
2.27.0


