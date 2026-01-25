Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C72E63C85
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3696B00A6; Sat, 24 Jan 2026 22:36:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5224B6B00A7; Sat, 24 Jan 2026 22:36:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B9956B00A8; Sat, 24 Jan 2026 22:36:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 03DCD6B00A6
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:36:01 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C262D58C02
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:00 +0000 (UTC)
X-FDA: 84369072480.04.053C7B2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id B3083180005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kxOIXE0B;
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSr2LSx4I/m6nLp8Q6L1CmF5R6RR1bSiVtgiRpfoHWI=;
	b=k0VbC02ZyPVir5v0CKcDiYrS5GMz3zMF9Gp6kTWO9ztXu8ceLi9hNgu0SUeNKduLmmafjp
	L2d4qxVNLj7gjfeaGJ4upu21+6QFZVhBPaeBtQAoXYe2E57YtGibzcu6PdcRGQx02CyFmk
	t1VZfDvUOuHFF7xFBnOjeTO8nQegBO4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kxOIXE0B;
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312158; a=rsa-sha256;
	cv=none;
	b=ukvL8HyUI8TNNr20fjs+VedaWZgW/9P+Z+yUjhvkw2xwLDqKcX0gX9w8jtLOlgUAHq3/ht
	P3BpOmX2DR3vvXC76Rh9lhDVcUx5VD4CHtrD8lHDnXupescFSAgM8TbYgp6bBcNv4HDFqR
	kO+5dZUbnnStq78QFsGJVGji3JR2VCc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312158; x=1800848158;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=70sBRuY0D3jWosg337M/chzngh/qThvgD1lCMLip+1Y=;
  b=kxOIXE0BHjj97Dxbt2TM0Wn+o3JERZG7IjUr9fGNcf5Ry/57rXKQ6VGa
   v/MmYzDXRJa1IX/ZtAHoem0GxHxlX5hCseQ2MOCAhbEL+Yy4m3XNBRQnn
   3Pdpvp58zrpiQNyMLwMved2UNQR8h4R9cF5ktt2Qwpjwj38sW0fk3MWd9
   4KwKBDMdvAf2e/hKTme5R/CXXr2Edd7DpEVCQq3Gny8/ecq8Qs+rQLLAt
   Mra0l0jJm7YYbTwRtWlT4lb07o+KNhqyhm3vUyWu0Lg/K9jEjTA/ttkXr
   t+MszXVBUZ+BXB7qijUjt9x0NDLCBPLfKN83eTxpa/widERe79vwuJlUv
   w==;
X-CSE-ConnectionGUID: U9iVwsfhRvGrBWVQbVq2Ig==
X-CSE-MsgGUID: xE//S46CR16rNwdmrUlhVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887497"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887497"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:58 -0800
X-CSE-ConnectionGUID: QrFMYZo2Qt2H6QcH3tF6aA==
X-CSE-MsgGUID: QBjoQZT8TKWWSVQKfQakGw==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:56 -0800
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
Subject: [PATCH v14 13/26] crypto: acomp - Define a unit_size in struct acomp_req to enable batching.
Date: Sat, 24 Jan 2026 19:35:24 -0800
Message-Id: <20260125033537.334628-14-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B3083180005
X-Rspamd-Server: rspam07
X-Stat-Signature: 8ss7x3aydetpen7s76r9t9m64p74rp3d
X-HE-Tag: 1769312158-434380
X-HE-Meta: U2FsdGVkX19wTnt9DtLxJTSpHpyFkvJCATNtqawNGWs8VY7WDYZBPQtL7OeU8ix2DxQE8+qNaame0jsTIE3QXfZEzYvBzIZVZpiBwHgWNQULrVFy0LxyupGiPPn5ojJJ4I4/WKrclwSD24EhctWGep1xqnGKIqf/MhLDpARyw+8TN2mOy2tA88ozE24xIUWqf68nryBa/Eo6tBT/msqEeHi8X+kPqvPNMiB+j9jsXyqot2J7rc3ASs1vUKWnL2G4TTKLisEd8q+HIuaIUaNbBIYFktYnaHe5v5h/ickGyVKeylVVkFu5anEMwwfQgCcbJ3UMfHNhVcmKRZHNaE6TkvQPz2FFn7dFqd9gko2Qf0k9hL+tGFatFqX+Zj8xrETWaJ+vI6kS8uPxDAcBRisJ2bPLkzc1YAfL8O127Zeymcrm92Te7hV8OeBWEQ5LPeXVi6Y+vKX1bAHXx6LYWE9B0It948VcvMEgZZcx7K6HgPYMRQkmQIoYKIHGWyIyqT6XBuYoo+SozIUr7k4jeLGVRijbqt4VgDqzD3qwTvRq7IB4Y3w8r3GCc+5qt/u8ILiiQOUSOhZq94vn+M6DSM+yQGLZbSaIlavo9R64x6RRcCAM3JClUcBTvNlUItzt/YxTCtkrs0IooqcrgPW2LfdLI5eHmHjpvrtqBmxy6c+k2rjY3wpAsR9fhfIXHzpjJRVl+AqmwBeCsq0dIlNbrAniIWM9q+k1D5b1tKfFZHmHpefbdR7xK/Z0h9u8ELGG3IvsFU5qF1OWOkDDD9KCgKilZSrblZt/1wufEL1Am9wIkRiOVBEhSZKmlyRuEx4MWXjV3IPkHuFmdHmTFJ1AMsGBetAEfZdQVzmcJ7+wOkIJs1zuakjnRPWip4GuB4ZTauCmJtdDv7/OBobOzWhcBweNST0aXWhK4big5PX/ppdrrfL/cOn1QdPBwt55L6+YzWMFtSJxuYX43pRsmbmEEAv
 7Qh40LJf
 SYvhCtPVY3uRyhE+bn7NXVsQ4qmqjh1CjkhwehkSrRU+vHiRLkMmfivAko/HbubFQuzzZiLeELD0ohZ2HljKXOu5ORTQaFVnsr2hex4Zm/6OFcEg4RsiHAA/vWxlYUW2U/qEvabqkJ49Lc1XwUo7BMf1N15bXLvh6twcABNC3HrkR2iKEIKdx2Zawq6VE76LQavCtkRsr5b0A1L7YDpiKZFIdZslf3uHUhqrLeo6E7nMTsLW8uUGgxAf2NA==
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

 1) acomp_request_set_callback() sets the @req->unit_size to 0.
 2) In zswap_cpu_comp_prepare(), after the call to
    acomp_request_set_callback(), we call:

      acomp_request_set_unit_size(acomp_ctx->req, PAGE_SIZE);

    to set the unit size for zswap to PAGE_SIZE.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/acompress.h | 48 ++++++++++++++++++++++++++++++++++++++
 mm/zswap.c                 |  3 +++
 2 files changed, 51 insertions(+)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 9eacb9fa375d..23a1a659843c 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -79,6 +79,7 @@ struct acomp_req_chain {
  * @dvirt:	Destination virtual address
  * @slen:	Size of the input buffer
  * @dlen:	Size of the output buffer and number of bytes produced
+ * @unit_size:	Unit size for the request for use in batching
  * @chain:	Private API code data, do not use
  * @__ctx:	Start of private context data
  */
@@ -94,6 +95,7 @@ struct acomp_req {
 	};
 	unsigned int slen;
 	unsigned int dlen;
+	unsigned int unit_size;
 
 	struct acomp_req_chain chain;
 
@@ -328,9 +330,55 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
 {
 	flgs &= ~CRYPTO_ACOMP_REQ_PRIVATE;
 	flgs |= req->base.flags & CRYPTO_ACOMP_REQ_PRIVATE;
+	req->unit_size = 0;
 	crypto_request_set_callback(&req->base, flgs, cmpl, data);
 }
 
+/**
+ * acomp_request_set_unit_size() -- Sets the unit size for the request.
+ *
+ * This is a helper function that enables batching for zswap, IPComp, etc.
+ * It allows multiple independent compression (or decompression) operations to
+ * be submitted in a single request's SG lists, where each SG list ("segment")
+ * is processed independently. The unit size helps derive segments from a
+ * single request. crypto_acomp does not expect the segments to be related in
+ * any way.
+ *
+ * Example usage model:
+ *
+ * A module such as zswap that's configured to use a batching compressor, can
+ * accomplish batch compression of "nr_pages" with crypto_acomp by creating an
+ * output SG table for the batch, initialized to contain "nr_pages" SG
+ * lists. Each scatterlist is mapped to the nth destination buffer for the
+ * batch. Depending on whether the @req is used for batch compress/decompress,
+ * zswap must set the @req's source/destination length to be
+ * "nr_pages * @req->unit_size" respectively.
+ *
+ * An acomp_alg can implement batch compression by using the @req->unit_size
+ * to break down the SG lists passed in via @req->dst to submit individual
+ * "@req->slen/@req->unit_size" compress jobs to be processed as a batch.
+ *
+ * Similarly, zswap can implement batch decompression by passing an
+ * SG table with "nr_pages" SG lists via @req->src to process
+ * "@req->dlen/@req->unit_size" decompress jobs as a batch.
+ *
+ * This API must be called after acomp_request_set_callback(),
+ * which sets @req->unit_size to 0. This makes it easy for users of
+ * crypto_acomp to rely on a default of not opting in to batching.
+ * Users such as zswap opt in to batching by defining @req->unit_size
+ * to a non-zero value for use by acomp_algs supporting batching.
+ *
+ * @du would be PAGE_SIZE for zswap, it could be the MTU for IPsec.
+ *
+ * @req:	asynchronous compress/decompress request
+ * @du:		data unit size of the input/output buffer scatterlist.
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
index a3811b05ab57..038e240c03dd 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -781,6 +781,9 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	acomp_ctx->buffer = buffer;
 	acomp_ctx->acomp = acomp;
 	acomp_ctx->req = req;
+
+	acomp_request_set_unit_size(acomp_ctx->req, PAGE_SIZE);
+
 	mutex_unlock(&acomp_ctx->mutex);
 	return 0;
 
-- 
2.27.0


