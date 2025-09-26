Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A986CAC5BA
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000BF8E0015; Thu, 25 Sep 2025 23:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4838E0016; Thu, 25 Sep 2025 23:35:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6DBD8E0015; Thu, 25 Sep 2025 23:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BFD6D8E0013
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:35:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83CFFC055D
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:19 +0000 (UTC)
X-FDA: 83929985958.16.DB9B17C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf29.hostedemail.com (Postfix) with ESMTP id 67F59120007
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eVcXkwPw;
	spf=pass (imf29.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758857717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EotO0tDseM7PN0vvFSN+GHcuIuXQW2PhfsEVnTRNFtY=;
	b=pUuVOI4KQ5W3aRZWrG765gehvATdnVcu9hnySdg5imamXmd8Xwma+5fm3f8jHIlghdQteV
	FKjlMS1SlVttShuBxr7HcqBcFo17Fzz2G6MYe1L/E2kakcaPdWzy/RvGIK8LKWk1E8Wd8Z
	2sChfvjfpTdgXIf2BakA9LforYJBFzw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eVcXkwPw;
	spf=pass (imf29.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758857717; a=rsa-sha256;
	cv=none;
	b=Jat4PkkOMpDPBV1h3GUS4x+7rgeOK/KEIEi3EY7Fetf41BLy3Bfoik43hTjCJBlQMxpbH8
	or644FM0yDBonRgN/WweWb0Erwuoy3AgnhgHPrKZbzPPySSwJMxaMAPlQGLX9MVZ41pDxT
	yfSQaVVv28Lz9WZ5oyYmlQC6veWYWWk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857718; x=1790393718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pwC8gGnN93tPpG8XUySSvRTzqGEe+iI+19bkiX/xCZY=;
  b=eVcXkwPwXC1ZAWodootBfgJOqApNS+Vmh5/OriaiCKDY1621+uKfW5aE
   R9oQoOxxjduu8TEL91zm0uFj/Q2BARncKVLQS9pAcXg/JuqASd+t6GB+f
   liaBY2QBgOSL+nVZ6CmF7oB3AGUDpeL1OXGazy2fi41At20Hlz0K1pDYe
   6Z9TY9RD4aef873r7xs51gfV5fEZy1es6znTI9bHuEKAvS/2geP9214/L
   dCp5epku1UimNoDexstyQbahBPyFuTo/4ULOC4tH72Sqro/vsdP22rPlg
   83nvAlKEWOw2Uuk/evzp4nUtMKH7Z1GyhYHf4uwLJfw5oXLmsWoPtPX4C
   A==;
X-CSE-ConnectionGUID: AYacaFeoRG2tTpfnCY/fiA==
X-CSE-MsgGUID: tbpVgCCjQH228NeiuHuD0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819563"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819563"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:06 -0700
X-CSE-ConnectionGUID: 5JNP4bi0RRaUIOdbR0R7xg==
X-CSE-MsgGUID: wIVCNUzbRyyBSK7y3Qvb8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636587"
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
Subject: [PATCH v12 13/23] crypto: acomp - Define a unit_size in struct acomp_req to enable batching.
Date: Thu, 25 Sep 2025 20:34:52 -0700
Message-Id: <20250926033502.7486-14-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 67F59120007
X-Stat-Signature: bkjgmucm8dx1bo38ypaxppcq93xa8muz
X-HE-Tag: 1758857717-85372
X-HE-Meta: U2FsdGVkX1/VZg1Zn4JKW++wjyDKY0/Ovt80jd5IO+d0BbcFmaUjqs9v51tMH4uMsI1+lYa0LrqazxKR8WCl0dVAeoDSvBq75UtLxkG9XE6y4eykcb3OzakIMRC4wV8j4zmwFypqJMnUJ+l90wkIYmYehTwAv61fZjEnk3uvJdISKRPO+WtKhyCvK0rsEvEfGkpDa//rkwhOTqq5F1604L0vgBOFzohivBksypEvj9BSl71lDQr8rj+8vEuVYn2CpCCREBFu43DbGTSZcJkj0UR1RoLeq8ku6YYGIb4HoZoPTelkkAXYgs+5Mn9J2UhI4iHMOOqP8A02BYg7JywFmHBBROhTbDpk5VLYChXrGkYjhUNNUKvtUggsbrlo9vpENmNwUQubMC6HY7ga8Ra3HBq0ROnfHjYlAG/Lifh/yaSTHbnRekepLL/G6rjs0gaXadZIoh2/7j/nI8CAF71yDTeD5MgnGp2YG0OELuD934GoFWD5FUOUYzp6uIbOjks7jx52vVGe4ShLCqlPYxib3ORIKYcGamKq/noFqWDd4QoLsaFG4+GlHrbeFKmYq9FbcNy2S7flHI/5jB7/1xl7JSygwZudJSf57YvOpxPB/2sOq2l6xRkDCrxINW8hDRx54gEeLxM21+6IMc2UxTKhCEjq79ij9tKyJ4iU+56dZ+R8+eM6r3NkU09lP5aSeTTHH5HAvHqlBEeXPV/M0RJD57jPagZr/0M7wEQ3wDkbXGRzfjgxuqxwXTJpYJtGoQ4wB0BoNebAsinFbwIoii8TmNIsLMPzEDstgpXJ3Q+9iD7dIUiPvc7WMhuVTSNAnbl67mmBijEkcKmvw64xsHGd+h/VwQi56nvu/7G5rstCLLI4LwTGFzn2+hnR5p1f3PAG8RMM03QilNwImflR+iQq24YaU/f1mI6DekvhlbYQQMpo+m06W+dMncjjp4tRXqjUSUDCnz4cHhe+e23CmsR
 LePJKCQV
 6SEklViBJfrXEpls4Cwd1RTsf3IjnD8D3I94E57XbX307E+rvUECJcJDRubDyahlsgWg1gIaosI3LI5n5EN2ZGXqSrbupK7ZpNAqxbajzQn1ghAOueyjPYzO+3rDeCDw4v8OV3I6vk5wGmfFkSNmq4dmLIL2CnqlgyYIhyU73uaGZRn5Ui2NNTl7Ct2wfALXgoX3DVz2Zr/ZY5a+ATs8Pesk/FbamNzL1gF/qZn9GRHxy0FrJYPqTCf6bCqn3OZwMKoFOy3AHeAgIn4qM3m02JQvtaJZE/XggmBDe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
retrieved from the @req->src scatterlist by using an struct sg_page_iter
after determining the number of pages as @req->slen/@req->unit_size.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 include/crypto/acompress.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

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
-- 
2.27.0


