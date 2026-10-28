Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 962AB60A2603
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 03:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T+9pdfoj
Received: by kanga.kvack.org (Postfix)
	id 95DA36B095F; Tue, 27 Oct 2026 23:05:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934AA6B0961; Tue, 27 Oct 2026 23:05:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84B0A6B0962; Tue, 27 Oct 2026 23:05:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5562D6B095F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:05:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 66719140B5A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:15 +0000 (UTC)
X-FDA: 85370543790.11.56B1EF4
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id A3284A000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=T+9pdfoj;
	spf=pass (imf15.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793156713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NH6LLO5d9K04QGTJQAsM95fgRxp71QEQs7Ta+RyYI+A=;
	b=u71HmAcs+Fmmh4MCH91LDOppBNjU66wUVlSCafiVEixyCPxBVFJp36GZkBi3GgwG+qfoFq
	AsaEDB5/arqCOmW+8ElqEYVt6GMEazxbLgccPMbeqN77gbtnQiMjm0vYS49jDm0QPfIv7/
	nBbzUxxjOaLIZKIqGQaJogyIZYzzIjc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793156713;
	b=qJGO94mWwlxzjB8qXBpGsY7rdL+Bg02GbBEAWdDnUD2utl396ffqw85RdvDegzU5q+RFl7
	ZLQelsxd6cwkzzr0wsRR3XcK99Pmuq4a8EEqquYZ0U2L9qP/TQkx4jTnblT+MTGrpuIZk9
	roR/g2synR7NOn+5r4stWjIAQ+Nm1is=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=T+9pdfoj;
	spf=pass (imf15.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-15943c9c005so704494c88.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156712; x=1793761512; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NH6LLO5d9K04QGTJQAsM95fgRxp71QEQs7Ta+RyYI+A=;
        b=T+9pdfojT7Rs7Yg3+B5nPEEjF728aRm8N9j3AZ8mloNiq6GfprKop5QAuyg36bKibp
         rqJV7Bv7Hil8YAnt+0zSpXlKHzqU+zjK+AmEbUBdv7SWn6gylkt2fojUNzv9Vi2Clzxk
         mEXi/RsYaV0yrDD2Z+WHSUNa9fRyk6Xy0YNXgSHnnkjArBihMrAYShC/XczH86FXPGmO
         6R2YDQhR5WMMeoVm7uQ4NjK7yO8ExVUCAxO0B1oXHQ0BJcZElzqQv1cvJJuVhvW3PtDJ
         U6WksivhPF6AYiWUihFdO3p0HRabPla7UoJXkogrUikZiFoR+Vdc8TOEv6FqLG7AI4OH
         hHxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156712; x=1793761512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NH6LLO5d9K04QGTJQAsM95fgRxp71QEQs7Ta+RyYI+A=;
        b=w6yH7buiaE2AtiXFJnqWjSScYMVhj5xPvaS9rzQXdsYeBbUHY5pzA7BVugoo1fjdZh
         jg7pUk4tv02RJq5M6xvJ6jKYBFAmJCD7I51OUzkk76WwfUGIsLIzcMbieeX76dqZOJ7k
         F0i+NHap3lR63VsAQPMFiAGhcYVen3EfdVfrysgDXrrTW3r73/jTf7jNli7wovvmp4c8
         mqViZGAtJEipwGZDxKkaepvxbBM/DMZoMJKScrdAcs+gozMgZrIzBYbeQEPNXkEKbxeF
         03n8GPHvl6oTB9j+UOuyOLfVYNccHPmppOLn39BxdQTxHSEsb+H7zd/WZclb8BamWG17
         hAKA==
X-Forwarded-Encrypted: i=1; AKwUvBySnl8KKDU4QcCLVMrzgGX2ZQq8rG9a497aexnw8F0KG9zU7rRs4GHSxaQhulGAmGPf98Me7aT8gw==@kvack.org
X-Gm-Message-State: AFq9FYJ7UcVfEOr5uAFSw+J61S5dCXUYRjk/CQwJ1rhG+7KrEsSiBDJC
	Tw/NGJrQ3r/xDsbLDrGpcwbELBsQBtz5orueb0uFOsugNwQAJqCZ1fik
X-Gm-Gg: AYBFou3N+Erh30ebZGOaOgQXHKj8+bPkpnBJPe3nV8YkqBvsxnuXSg/xErH1/wR60j0
	V4l02yv06/rRgTOL4asPtNm7UearezPL5er3hVXkLyUpZn7gnKv0dlEXc9rZMb9YkSHVd73pCtx
	8Oc4PmfyM2kuS8+dFOA81cYFvb93mQOawKVlzrVZPej4YNpfx7Mnvo0xsG8HwSv4F9z64+QVf3m
	0M7WtawpnN9c8OlC5ba+zfmKYal8pFt2j7hB6cEnpBjwK6l8NgZax2FKYFfeng9bCKa1ZpskkRw
	mIHqHarR4K4xkIUMw9zc+h0ZcQ6CtRLYo7MOJtrH0rplX7T8YOQSx+HIEqJTF5BhyDDaZP2cT9c
	7hmfhwjpS4aC+/ArsEeC0SQmirkaUbmFvtqSS5rtyo0BTX4sWvSvwn8+0K4v9pMgPlFekGyG/8l
	fWW4YEgyR0lHL2zadjB4W3DBiAev4UZF7620xx0KjJT0IQ7fF8d+KZLDA98NeymlccBdBFJRe5b
	SzAEejxhT82hRhyphiiyQbJ56B92jJ0ohajlUMlVyNfcVoIbCLpj2KN8fI6ayUsjPH15Ioxqb9M
	WD7TDOzSfP7fkvs4AJDkioZ0xH88hFUZBn/cIl7VDw==
X-Received: by 2002:a05:7022:286:10b0:143:868a:20c1 with SMTP id a92af1059eb24-1a6cfa0e858mr1429965c88.46.1793156712194;
        Tue, 27 Oct 2026 20:05:12 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:11 -0700 (PDT)
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
Subject: [PATCH v2 1/8] crypto: acomp - Define a unit_size in struct acomp_req to enable batching. mm: zswap: Set the unit size for zswap to PAGE_SIZE.
Date: Tue, 27 Oct 2026 20:04:56 -0700
Message-Id: <20261028030503.17923-2-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A3284A000C
X-Stat-Signature: fgcx6djab4koqb13qmnqngwze5oso3ne
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793156713-955859
X-HE-Meta: U2FsdGVkX1+gY6os2AE2lOGLiY0uPBFSBE6vm3+uJduggAwGjR63HfwcOeepd0BrQBuL5cjCHTu9EIdvtOTjY5LoTEYfLG/xz55PKGhstgFYN7ibEUwIvUYyvNNgJ9WLtR1lYXw4twaBMGHe6MYsnQUrGt9yj3uhzduB1As2D47w+ZJWctxgifxgzKDn9/+nU5FvHkwjBqNvbQj5FsFsgzd5+l/RMYzFkybDY3A82xwOH8VmdGy+mdQ6MPgAYr5qpsokjSZcOnFL5Uk3NrL4E4E7jbIJV3Ydi2HMzKa1XbiV+/uliu+BR+PXXiCNWk/bcVEDVsPOtjmXVxTfrDMN6W2VPQ7qhVOfY9P2rFb1bWPfJkF2/ybngm51TQfA3WOw0AeEpTtG1LhZdGUmhEiA0uKTIBVO44vLbivxtCNhYzRFsNdVwAS7/q2p81feLNMWmTPIkUfj8GlRAsFFK/ufT5JNHwNuVd9erynM1qhuYJUKHY8uVftXnLVU/RiMGmbigP8+b3nycePycI9nXQQdgcz0zRsa6j+j8JklRfeqdczapQl/fJ9vdotNwYN2ifvLvTnZGJL9hpWMz9R+BnC1sq/bz+aq/0+iRt4/QV+/gnwzMxfemoJe1lFQ5JqdCEjTtwCEzasZKPjXJ2VByvlH9antgC9c2WX0itpRnzh0wfC/fNCqHg0ozIjPrut3VY2891ipgE5v39kP3p+Vg2yDmXfi+kAGls1X1A34ggE+/ippQw6MaDHBu0MVuYpRBiVRWNqF69zNABXXNGA64Z/4WK1YzHZtG8jgvK5DAKMiaTsuclb4bXDHMmkcM0ojpwOxAH+mh7SXItSr3SyZgKIV3HlZgzeg2mSIKQJ3f7YViVN10sHe1eHrgq48xY6ii2XhRVlwBpVXlF+w7Zrdd6iFktLh2Hx5AEXarsNXkzpQpHTVHdCLm+mgoug0/d4OlFfk8ZVgkzqjAb2E1J1w6v5
 lY38kgHz
 hymxom+g1DrqxPe3B/+qG55yPoY1+sG3lGoSpeNIBXkT5OccRSVKI2zs8k9mn3Ml/f7j5iZE9SL6g++jRjc1t//7Z6wMVw9UKedg/s79jsljsPMvRyZGMDhuyG5vU8nb77nI0+zmNzoy2HVyYq8PCpzrny9kBRz5dvsruV9eEUUMPCMmFs80S7KJ0gqZB/xZXPUb3WSZn3BHbSLQKEV1vJXvc8ssDxqDnzimc/a27ij/nZd2gLU2lnBObtQRlDDb4yu1LzhyiVmIoBboILQypcgH7lDgxeDbQNBWbqkO2GzBG/jitoLl16sGeT1gdekLXNdk1Ngd2Kx1qPEkqeLyRWpA1q8267WIVY6IZcTsgD/QcC3vKzQdKVGO7FK6e+PA2joTkORB0oxcHnev+w1/tS+PbzaQx4jRFCFt2aWupmMr6S1tBpQiEmJbafvbX1X0654IWRGJjkm0gIPgMF3OLmgcIjm0EHDkfr6bauDFjqYmltPUHGoxB4lz3rhVXjyBQiF8Dc7o060dNDHxq7XnIFweWXwt9BgdJ8wSy
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


