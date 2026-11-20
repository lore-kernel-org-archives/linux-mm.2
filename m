Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F3E60A2623
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=foFiGMF3
Received: by kanga.kvack.org (Postfix)
	id C844B6B071F; Thu, 19 Nov 2026 23:19:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34E96B0745; Thu, 19 Nov 2026 23:19:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD926B074E; Thu, 19 Nov 2026 23:19:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89E526B071F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:19:21 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3DECA0D49
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:19:20 +0000 (UTC)
X-FDA: 85454192922.13.425116C
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 304D71C0006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:19:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=foFiGMF3;
	spf=pass (imf20.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795148359;
	b=aMRlCMBcAY7ze6Uw8M0f1u30aKWhK8OAok/d+Jkm+Fam7UoHICHt44qHfDHYRdOfzJNeGt
	JcQYGXwhZv4af2w6V6lk1mK65LNNgpgAS3gaK25L+cNaPH2VnyccAObyzVm0Zn9hRKzZT1
	lcpV/xUUxMRozgV1e3n0vkNxPk5U+LU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795148359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTz9wzGNtR/N3sgiwyDnjJ6OY+zHMig/3wvX7u6gSy0=;
	b=k7k+StcgDvD0HcWDCgvNKVsPS2aDqnoN1GH51m1XjC8iZccGcXGV5I7imVRaH0MlMybDQg
	iJs3PzP2VD9OF9vIJVw6YEMeeROdo6NsyxT8Iu51+boOREoJCG07BUct1xgu94tW1rt88O
	X4g+bB+esNEsYwk6blOxfhxoWbNgvS8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=foFiGMF3;
	spf=pass (imf20.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1b3beeaf6f9so610119c88.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148358; x=1795753158; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LTz9wzGNtR/N3sgiwyDnjJ6OY+zHMig/3wvX7u6gSy0=;
        b=foFiGMF3pFXvdkOIcE8TZ4ACyDnV73RLFQU1rUS4XYzl64Vei6P65eM5361+c8De4Z
         O/j0Rock/umN5KWbNxxqC4mRRrTPIp+pjq3xo69dwfkCDnmSd7KOaSo1iBEmb2fgFg+r
         wxKmHbjCuaU8XEChQmaGDChKQ/WWjryLleuV/F6G4mYbI3J3Zg3oSfom4HuLs3J1YqoX
         vz1CNdHVTzX6VK2tQIjq4oEA2zzWbzOWQ/5bw9juCrvgw58AkSM5rA3IS0CrbddlbsoQ
         1OAo3kg+mZFEferjEehEgSKyntw2ujkYWDazW4Ik6ms4GPwh6XX5bSZTg18rYEw09vfm
         EV7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148358; x=1795753158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LTz9wzGNtR/N3sgiwyDnjJ6OY+zHMig/3wvX7u6gSy0=;
        b=D3cnZ86haPMHw5290yBj6nX/i2UO7d765O3/GPmLJNdp9mEnhMvbxcWktbtakE6aLv
         UXow8+wRsIm+AMwAZysktJCHZ0a2oG0pjNHUNHZkuyCCABYY+CHQXvt5GX2NedA1buqU
         665uZ7d81njOagkt+3ZoJYWQFkVESGt6rVDK4xzySanGSqfSxq9GkLDPo5xKVj/b25+3
         ng2P98af2/prBd1zqwzAjT9b3D6DAPCC3LbOCTkpSt/R6u0Eqz3bJXrBPS7a383Lckbf
         R2N7bz04IGYwMbgoGfEYaJaUwPudnnT7BSU3coL8XV63lH+4JNKUgCV1KMh1gzFimaCa
         00RA==
X-Forwarded-Encrypted: i=1; AL+hErGDkSyofBQmmbcDL1l+aM6L6G7DUVFifeAPYR3nL4yNno0oMHH7nFc40hL5oLqWTc4dqW+o6nrmng==@kvack.org
X-Gm-Message-State: APuU4Z/5zleOqAaNqJ2miLorUBX1Jle3HbRSBU0ebmsMfJxwHZjkKvhl
	IFEUnV+KGWGLb5U97bZBdvWWfpSGnS/VhKWxLyRE8OM0VSp521pfmatA
X-Gm-Gg: AYBFou16OVu3DkhL8SBFsVmZDZzf+VxZuhT8VRnJpY+IUUPVe/wp9cAeAY7YZygxSra
	k4F96KDTSg+aN01MEnyzJZxlif7rByPlqFcZOHV3PZ03Xq4E1xKCEhXIM/bkL5yPrndg6SElGCF
	9Z9mHlVZoWgt3QP5I6OCWqmvhqgRYo9j6PdMeeN2x4R45Jja56fyhICNRykZxh4yV2//QZzzaZ9
	suwI5bmHvoYS32kBwatnQiM+6IYyAiM8dkV7LhOOYUGjZJRC8TvBl8IesQEmjzUZP7VOmUphDI1
	isVhNCugavbHHrhzu8Zvb7+hGV4Uya9sEMpq2XeJLPSgB/EYy/rybYzrhGY1RJJLF9ayeLZueK1
	k55/a9obJLvsx6VHog6q3Vyqqrw7FTGEd+FMKQsfAFvfKh9lfppYq6vLLKHwjluW/0eTWQHwWL9
	qf9VUQjvyErP7oTanDtjDlqtk5SKvtihg0QtIeJACdu3TjzrdPyXGfaS5lstOk2zyHnzDimc7J8
	3ILLK84EJuRyD0H8+jk0Qxp9AanD/vmN/6dcFmDb2/XCGri7HBf0c9NRJOM1PkfsKhv6HrlzBHl
	l/sZFgRbpcuRxwP3gXPIa8RMe+IiROSrwBkHfWVG/w==
X-Received: by 2002:a05:701b:260b:b0:1a4:3169:cb with SMTP id a92af1059eb24-1b5568c581amr1912909c88.17.1795148357871;
        Thu, 19 Nov 2026 20:19:17 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm3124341c88.7.2026.11.19.20.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:19:17 -0800 (PST)
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
Subject: [PATCH v4 1/8] crypto: acomp - Define a unit_size in struct acomp_req to enable batching. mm: zswap: Set the unit size for zswap to PAGE_SIZE.
Date: Thu, 19 Nov 2026 20:18:59 -0800
Message-Id: <20261120041906.5785-2-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 304D71C0006
X-Rspam-User:
X-Stat-Signature: ynzhaynjgwa8bs6u6pdwcfeaqotau38o
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795148359-943225
X-HE-Meta: U2FsdGVkX19X+HbQGbpcCSE/2NT+IGAjH0KlkawhfqTYjGn3j+tGESiwJbLA9d9uDj6wFKakZR4ZeG9jqfJl+Gms5xJopMTJ1r41gUbqPG2GJTcCWEiimdyMQ+IEwl5XgdsZobEm6998B5/4ALZuA/BKPu9iY1QNUus1/SDv3tjZuDZfH4qg3cPKo3f6bZSmxnZEjq0xq6qcgcvn34M0/bpJtTtpLqFe0aG1eM89ijnSZZiG0f9Ics7FPIgmYo1MdBtRnA8ubW6rMBLru8oVk63iWUSgUq3vZDi54ptO7vLVeci0IxPLktxiKWs+cDdkiTVQ5+TRhuPFH/Fu7p1zRAFOr4mngLhIsYNr+ZHUM/4C4du9zDS2JC63AFCiJZQlbc1ZRK4Fw6p/qM77ZwAWdah7hRwyKDN0w1ujN3GHMg0a9QceD5nqZxSizCqthsbhKNyiAQPvNKBNc4Ks13aDft/1P6oCjIjU3UFsjYbvaKpkQkmm9UktdG2HsAvkaI9kfkNkP9kklQmcqLhG9A8+3g+BR+OgQY/7Z8JNdZv2UpTBSHZibkL76PmCricKdf6e/PutB0dkw6LF8ud1lvMlGg0XrOsD64RQcZLhPIS53T6z0ghnLNPy+M45ibGj4079MK6vh6YQo0WywUsyD+9eH/XyfYCiWAp7E9tTOe06I3k2QxtCYF1C0crWhQocOF4rrH6PWqeINhW1cZq8hcabZHmMc0J/pIn4+jORefq8z/90UQ9sM5/ofTztzNOE96SyPqkMGsYqfTAuLrRkZ8oqpD5vLw1ugj5qP9NbKfZUrBrxmFUlK2rEe0VmSvtdkQOH4Kp8MlT0If0UqDymmefNEMdFnChYAiXAYR9YxxYUE1j4Xl3KqBuSAQRDA5TXAIRXr+ASOzg1nbBnX3Xt1ahZpT6vwRiV0MUhWmHzWu8qeTA588nxG2f+HXxGn5MzkcvTEo4vyOe51fCzOnKv4cs
 9lfZ9PAa
 tjQBdMqqoiyV2uqhOAa3ML5qwzk0LEoWbzxyANtBfiKTKRJBi4H9beFDNjJ9auSjU+DE9mxWs5OuXAj6jSiK6+xup+4cSz5U4QyzBwCg2nKVOAnSvrtMbIwd0v/8VFQeCUexN8fmEcTeNCD1FK2cLZBD0PttFQe6eDLimE1uS2itoq844n0RcHibWjKbNTDlh56o5L5lATT9rTqX6NRkBg75sWw/LO/Y/PmE4VWxTpxNOlrVS6dwcjyd9r5z1w2YyqyWSqIZgQlC073dEXJWxJiN4gdnTCs3GZrHKjYmoDKbrK40lgFE4DmJ4JFFUVgtc2aS9fTkGlfvwtXbdtE7gX3dWYhCh2VtjVsqeYp6e0icZ4YnAABeeWOanGohwsC9aErNViz0h6lkV3vKJigBQttdY/49YL9+u0nvdQdWjxGtlbvYrmsZijpyDIHsdgfd5TpW3nujazvRBMfbl69jpTn1XoDnDq8gzWnE2k5kUafzrHpkPqzOMf2nzE8Vizqm0dgx/ha2jSlIFAnYogVHe01pEVbob4N6INyKG72I6w9gf5XxCkzgS9rTn/LFf5Pb8fZ9UFV3Md4//H3sHOYUEFQPf8i1+9IlGdj6J4ZZtIbOpxgJvlYBrB+f471rmlDETEhiGhsqGmVxvyfs5UcdarAjQ1kKFk02xFQ0RzLSr8LsxGVRkAQ5o/tMKTl1vAtQCz9Ico4BBVl6knEfEqDoQJJQCNxGppFxW7t3795Wx9/7opfKkmk8gdtsqEtnUVJcCqpo8
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
index a2e0314db1cf..9a323862bd59 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -829,6 +829,12 @@ static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
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


