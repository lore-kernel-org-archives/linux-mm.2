Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 048CD606D807
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xnX47ZF9
Received: by kanga.kvack.org (Postfix)
	id 30A416B05B4; Fri,  6 Nov 2026 02:24:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BADF6B05B5; Fri,  6 Nov 2026 02:24:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8E16B05B6; Fri,  6 Nov 2026 02:24:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E287E6B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:24:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 798521A0D24
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:24:22 +0000 (UTC)
X-FDA: 85403855964.27.CED00B6
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7E44C0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:24:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xnX47ZF9;
	spf=pass (imf10.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NH6LLO5d9K04QGTJQAsM95fgRxp71QEQs7Ta+RyYI+A=;
	b=5FKvVhzPhx1sNyAF/rXUE8r5zb+lrfEC0ZdEY1HGKNqyyIKGdh3ko9WXDlDO+za5etOMid
	fAmgWAVC5tM1tesKCmFcv2/Zb5ccU1KyGX6q/mnPrKUwvuFX7K778uxBZdtKeTFEKtBc7Y
	8CV0HK4/8a36rrYQPtc2LFDuEv85xOQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793949860;
	b=KbS31CuBJUYApluQtfuXBFInjviWgxzDmUz5gspjt8irNHA/FoOcN1RoXcsNKCYLiQIbTd
	B4BoYpZq/bMHwItrFnakVQQOvfY7piy9dteojTopmb4Vj1b2vVJE61qWlkaR9DRLfOhD1n
	5VzVCFJ4uGUzNrL5z42sVA9w8nOGlrg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xnX47ZF9;
	spf=pass (imf10.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-15dd124bbe7so814069c88.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 23:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949859; x=1794554659; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NH6LLO5d9K04QGTJQAsM95fgRxp71QEQs7Ta+RyYI+A=;
        b=xnX47ZF9RYTaGG9bK5X7UNOQ1yF6aRSTSWal/UoraGfhuuwt+VmUTN6qK7k9mCMlPd
         IV+tADUiJMx7bnIz9DO3hOjaHaFhM0Ca/zbQ5IEAhg4rlgNolqYyJi572+wUBOlhvU2q
         SZI2qyJKgok0BBCCxqTl9mzFNt8IKUODb3inmHAvzMWFtPGQG2KqzOC2lgkHSkhxrgq+
         Zt86F96Y0lKCzMdJ0QeuX82OaiIwPcFfcAIGQaEKg58MPTDC3e6gX9fyRyUQNYr8oWcV
         ePIXhGbISlEVk/nuh/rzRC0oRWj/P4TMSgAfwfNT1ojZJ8f6tbV4eSL4bZfsUXPDtovW
         pBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949859; x=1794554659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NH6LLO5d9K04QGTJQAsM95fgRxp71QEQs7Ta+RyYI+A=;
        b=uAPaHeowYhgcGXI6AMfWL23SeN0v/jNS18hMXUyNE9yezViNWI1Ad5HUkwaLdRLbka
         e6zBJklqg5OG7cgt89c/WkB7CRdp+0ZALgL+24gqNf90B6ZkYJxJGvylyNqmvFrjfuXY
         6BDZTg0jRkO5SkQ3/umHq8q9MYZLBH753C+tRmfi/q90BNsPEkYw1PXNVoltWW7CGBVD
         LcAA/meH3GTnD/PoYfjML5S1c/q22/iTkqUvw00SVq37g57Og1Tkt2T4DThhvn8jKZBH
         /3ktho8oXitPkPGPMCBkI0Kft4gLG3fY8WqvFk4OUMwbiwVWKundLUcpneFLMylOBfEK
         FoBQ==
X-Forwarded-Encrypted: i=1; AKwUvBxyXYbV1s8OBkU6IwcrNFG2Q0eca6i6K75DD8qju2vw3iqwSgCaQaNw24f/jsLBlGq4Owa4/7Uz9A==@kvack.org
X-Gm-Message-State: APuU4Z8+2DwT+U1fJxU5EDvgtjZnDkpeWWyW/o67buqWcT7CRVC/OXOb
	P2ErHrnsNBDZHSma4fzmWUv1QEwpqMxV+O28PfrnQJ8vgwoW6CTFJ9mS
X-Gm-Gg: AYBFou1KChYPOkFje/ZvKpwcbVWk72Z+KHg0w579AtrK7smpJ7s9Xgnlb0/0EuSDRYX
	dHj+ngrs50Kxx8Cwrl69BL8qy7gdtw48bEQ0/KS6ob9ikdWFp7c6QRSQnCiVKxZd9sxKzliLRHq
	lLG9Dpwbr7z/AmAXOs4u4GrtBeYN2+m9PBNw62PPX9EquXVi5iW/MjtfNzdeUi1CkS1yvFbhQN/
	1Cuuj+kymq7WHae3FJf84vhKu8JCBZ9uJ38tnF1bGNHBG09yWr5oSEctAj2k6v5z8tE0Y0GsqCx
	/jfTSk66m4YQQyTbCEyNU98rLcY8JKFjiYAokvSbErzEcCmueqnp/MPd9jES4F3vUyBLfHEBVTV
	KTTd8T0+K0lIyyzdx8PgPnV1kNEoeR529KU6iB602FHpYtzM4Whp3Q62CD9bmg6cZgLkTe8rw8M
	tcFi8iPTCNrNR5BmfVoSOpyNtVHl1MmArY1HEfZ5K8x1R9Ai1pGnBEZSCgA5bj7X9EZQERY8M7T
	y+4HDAeIv30sVXNSAocTKTBdxZ45TJXeM89bj6Eq0eDDLsd9TC7Zgw/9Q7OhkyxnZ4Npsdlwtm+
	TSsBRH+C3SEiIf2nnJtrnhctyQ3GbFCYoowELaH2YQ==
X-Received: by 2002:a05:701b:4301:b0:16b:fdbf:4a9c with SMTP id a92af1059eb24-1b25d32cfb3mr1771497c88.23.1793949859398;
        Thu, 05 Nov 2026 23:24:19 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4840f3sm6262220c88.5.2026.11.05.23.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:24:18 -0800 (PST)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v3 1/8] crypto: acomp - Define a unit_size in struct acomp_req to enable batching. mm: zswap: Set the unit size for zswap to PAGE_SIZE.
Date: Thu,  5 Nov 2026 23:24:05 -0800
Message-Id: <20261106072412.7909-2-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A7E44C0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 3qqxd6ubqmdgi4qtxhs3qg6i1nqhzaoi
X-Rspam-User: 
X-HE-Tag: 1793949860-410770
X-HE-Meta: U2FsdGVkX18hq4HRsmeOqo3OqaZ0DFJmLG+FXurligmZDnBpXk3S8f1NCsh2Iwseo4r8gEQUUM/L/vieKTzJZDIEBL8vXPR+mnlJlQ/j3CPoI8Fvk6nHSsWfsB0moo+fZj4GXldy28zMWMv87nBY5CLRWD+/dCBbiow+AIO2FRIOjfC6aha78Cg55qUTBPekF/PaDOLO8VxqD42rVXa77w1QqpT9vVce3ZuO9x6HkjFcZ+9b/iEdERPqoHPGscDuwUIQCwnt1aNGHmPKLJT+jgzgEhEXFDR83JovCjffRmfsWjgTJ1Ag38VtF3XgwGpCRLBPZ2guYDgm+8YvRA+bDZ22fdJL8+VBge/jj/DIak0bj7PBOyOw9eC4SbhEWMh9HSUDTi0jTf9rG5nY7+spee6Qgr4N3wRYN1dljeLbVhzX9qJ0pKQheXy+/QaK8FBAAa1f4TqEMrGXTLkLfv8HKwzBxyLzCMPGltdX5SDHfqfWqGXDaEsITmeqprFZLPMd4OLamshTdXyEM5DlgUvIxQru5Xx+fD2qjavPjel1qHbhFr3DMhdK8CH0I4ce2Tj/IwcxDDXcMwKvaVmTuSrC3EqECmELOqNZiloikaP801xC7z6EMJ28cfGMgcSGSz+6YeHBxKDIpzSjtbTXnt9MUYoRlpZC51qNrpqDH2SmtNp57PlB3fu6OvVtXzt6AjrkowVMP6mFbGAk6ZPkjLsK23jBqIThTstyam+WfyJQC0OqIzCceM76xjrgdILjrjxlgSsZXANJjEXGl+AGxkYurf/hsyjIhkWMIuuMVpi3nxpLjLBE/F3LX/BZpFAdtKAzxalmxaC4D4AzcmQmgVs6+DSYQP0Wgnum0IJXliBXdBfLUyayovaKfhAtU4Jgf3ao0wrKqY9rlxQfqflJzvTWD/QVpAtTsv+g8EjNjAma5bOxoHhPEl1g/FqgUaCA+K7VDz2KRoZzrulAcoNsjZQ
 Tc4pOpNq
 dgsYtLsUWnoAgdPx6ZtUSx4DuXKcQUqK5YoOrFPaajQVTNSn5Iw99vqOHYxcS3L3SNZzE9qrB8vwhKyQT3heRl6o/k5AAEBRS+IkmuztznMWSRq58sh4GKUNxktZnwmDGdYzM7NXVuCmCYGiu8jf/UN1FbDZJRKCUqHLCSAus61lK9zxWBbKAEHmGT3mlRw/WZfAhKYwrBRMEDu/NjKi64OVZ7JmXdTC7mCjyhZIvdTzi0g/7SUqrNSbh3mPS11YJbunlqTcSFEWJu4zSBtDNgf/stYJgkG491p9Xq2OP5XBUwTgUmfD068OKz3NM6CudyfpxUOwe/xHb4sb2SzjJA6PB2btKvt0V/pJRVVDchdR4diuYqVbrfEhIFAj3ztYRJQM50Bks2mfOAQOHwC/TtJJTmF9Gq5MaIh3LQdeTfcBfONFcfhWRLFcfiPGnUbOuhU8sFsaLe/C0Pj25IwbDj4UbRXyhqc5xUlJ7zsz3VkiKTvJwkNpvJ10tz4Ls7Zvb1vZBa3XQB3Mis/7N5IjzeZNzJn6/0XKzRCeB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

Please note that acomp_request_set_callback() sets the @req->unit_size
to 0.

In zswap_acomp_req_init(), after the call to
zswap_set_acomp_req_callback(), we set the unit size for zswap to
PAGE_SIZE.

      acomp_request_set_unit_size(areq->req, PAGE_SIZE);

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 include/crypto/acompress.h | 49 ++++++++++++++++++++++++++++++++++++++
 mm/zswap.c                 |  6 +++++
 2 files changed, 55 insertions(+)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 5d5358dfab73..6462fc46f4ec 100644
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
 
@@ -329,9 +331,56 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
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
+
 /**
  * acomp_request_set_params() -- Sets request parameters
  *
diff --git a/mm/zswap.c b/mm/zswap.c
index ad01c691a263..e1d57a7d9595 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -826,6 +826,12 @@ static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
 	crypto_init_wait(&areq->wait);
 	zswap_set_acomp_req_callback(areq->req, &areq->wait);
 
+	/*
+	 * This should be called after acomp_request_set_callback(),
+	 * which initializes req->unit_size to 0.
+	 */
+	acomp_request_set_unit_size(areq->req, PAGE_SIZE);
+
 	mutex_init(&areq->mutex);
 	return 0;
 }
-- 
2.39.5


