Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D96C606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 03:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ou1eYwvB
Received: by kanga.kvack.org (Postfix)
	id 2F49A6B0963; Tue, 27 Oct 2026 23:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A5856B0965; Tue, 27 Oct 2026 23:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA286B0966; Tue, 27 Oct 2026 23:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5D706B0963
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:05:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 402501C4612
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:18 +0000 (UTC)
X-FDA: 85370543916.23.B2A9DE9
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 77E4540002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Ou1eYwvB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793156716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjMo/sG1MEyEvRFVXuJWldDILdZ/eJ05L/MDldKgA8Y=;
	b=mCaWri3PzRvtxBQ7qTsAIe96WsWkWQgGAeFj1RpPyVnwi9wZr+3VAX4MSno/QbPrQXfmil
	0HdlUey62ZiIYgxRiOK2psb6WWycEOWQ5Xs2fKPqBCeV0ItgmEIFISTW6xaGp3z43Pd3iV
	r9FgZeuF5Yq7I/+T5t9vOzjttCZ32UE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Ou1eYwvB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793156716;
	b=0yloMG456jTT+6UW5nL1TJIPbUqH7UjSMunjzyqMpLst/yoFU7ZSWfJB+q6k+yzfAbGL82
	bf9fP7AiYtZp+lW30EdaWqc1YJMbc6YyTH/yNnn63Pw7Fi7FuXqXu4ZXBCI+BvDxzPWYwO
	A4WHbJJSFEO65EqjEbsbTLDVZr7Z7K4=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-15dd124bbe7so918952c88.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156715; x=1793761515; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TjMo/sG1MEyEvRFVXuJWldDILdZ/eJ05L/MDldKgA8Y=;
        b=Ou1eYwvB39u8V6jKJ+10z/5fcuFw7AV8fJGCHduO989jxMThNUFZ/sa4hEDNzyMbmZ
         WhICfZxH19zDdZdeOAVse9s4IqRTWUvyvAIdXDaSdY17gTpFc2pppYo/zkxSCLSHaPZk
         SL9oNrphpHkhcIl4yNUA12Af0fj+6fLttmsITSJyQXF7+qiWkx8aTmDEvejHz+nl+v05
         AwegDFO8NZ5o/WGo7r03XMiDVHsUJtVK3x6wC+Kkq0zLPe4I0hw4cS8+3ttjs9acIpql
         6hAxgCg0snHxRTe1cisSMdETrzSQ39lAtHT+4+XYRev3zIFHW5+4pjeYWSJyFZHjZcDG
         xupA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156715; x=1793761515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TjMo/sG1MEyEvRFVXuJWldDILdZ/eJ05L/MDldKgA8Y=;
        b=sAwCO1YXDdEBoadcT9psoD0ICnB3TUM5uTPBr15bDjU9SXfi4OGnxvRNdZ6YevW3WQ
         itXqHm8cLYjB5Lgm3TDSiGFBh4WbRcMdXNz7Kqh4xCTK9h0OcaQpGxe9LxZhlqFYajbk
         iTwkEZ47DhBEfFF9GN1Ijrah3US5e/15JXwl/O/z1ahZOJTYvdSx2tM9hw89+/IgLBjs
         wsgCqHEFukPoCyBah10A2Nmaq9boAJ6GXGLmdEPIP6TR2VdmWQ92vtrWDO+UGt0p7BzX
         gpD0oVy+B6vTmlvgZEJOVO97iqFpVqm7vnnJKzKC7B2dCFAMgaFEdknfkNGGLq7WzzRg
         KaFw==
X-Forwarded-Encrypted: i=1; AKwUvBymytmv163gG92gEXlMx7PUgzBkgRERBtUf/PaOGJAdVTQ51zcQKqR7LMWT79v9irCuy7qp0pE9PQ==@kvack.org
X-Gm-Message-State: AFq9FYKJFewh5UQY3MyDfQfauxn2xzPFTDGrl+Fwgtu0aPpIcki8+BLD
	Nsq3EV3GEkLUJvs46J4/dI3S1ucfaTXyHifrNOkv+iAR7d9jeIKGKWec
X-Gm-Gg: AYBFou0aFhy57LGek3yIBTskQelinzFL75x1FJsKetz8UfKdeWBRKtlff1CZ3KSTmNt
	sXAQhSufNI+7ckfNvC7m9oze5u3bUU6Ae3z6D2+M2K+AJd4Z4WovQOSQ4d0xKwUqf4c0Fgx4iFS
	QjmnFKbcxQW6FMDdFjhSPmxUo2i9YAzEhwDsAMELmQhGap8xkZUl0oB+7pWW9voR6w+/SqwEkIU
	Z2SaKRwAvkx35wUkTFuC+QfIL/TtzqAkCCZELNP9VcP/Zw08tviL+rppAU0DwaHRY5jjtl+TU76
	cjQjTsqxlXNENt4PSHgr7CBecH2i1cFbLFwhgSrdbbAGOccf5Z1lLF6+5T4Z34ImTgGfWtz9PIZ
	70lFPdaG9o4vz3E/pwHhiR0ErcrXTHgW4RtsRlpfp1VSkwuVhtM9faDnPYC/jJBOtYQquKv0aCT
	/7SPBMdACHQ9Gn3dYvcIp7QEWmyKZoqyWaEu27zKQNaw3kHwLC8WpYaRi/Xb/OU2B54dB+E2+au
	GCwUsCSk4A1/lOYhKp9X+dGXEZrelnYliFYbCdO1PNQRp5t854vmNWuWOU0xfvRWfRb9pJYlIlf
	QOKWCuKXG7wHbHj16IC/t5FPn9JW7h78Ug+hfXJzhMhGHtJcHR3sBkN8nnQcjI4=
X-Received: by 2002:a05:7022:5f0d:b0:195:c6c2:c6b with SMTP id a92af1059eb24-1a6ce9bad49mr1386027c88.35.1793156714994;
        Tue, 27 Oct 2026 20:05:14 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:14 -0700 (PDT)
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
Subject: [PATCH v2 3/8] crypto: acomp - Add trivial segmentation wrapper.
Date: Tue, 27 Oct 2026 20:04:58 -0700
Message-Id: <20261028030503.17923-4-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 77E4540002
X-Stat-Signature: i8qr3uoiiwnh7wek5gmpcmq6eer41p3j
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793156716-916974
X-HE-Meta: U2FsdGVkX1/E27v/P4IcDcNDWADPZUfrvGFfhoIW2XfRW5jPukkOnRDpACfjiMFKozmW7F8c3gYqzid40/HdmXco/PAA+PnVSfZFqQ6bjQF+Pr492+8YCRfU4xd9YniEEa+5WoMvizaRwN5a2ZEhmqKyAZ7M3SoUY3hy8ThMqCsQlfdHopfeAK6V6ZRFM3xefq3QAeR7Lbkrse4jhsJhu8GWAAab/O7rPNkFkelSJjAmf/kJofoo3WaDk/pZvakfzWM/+OSQDx6x4xmzi2yBd1f8q5dPb4fi++hw71R3f4BpumnPj7KdsjTXCgQspKJBe4ZdiDfUw9B5n8s0EGormzaoni6rbIjzmtZJseLVXRVSkh4bxOO0P4SqXpk+cQpr4jVzNMe+1NB+xt5vfXwDYTPOtc7m2ZMOenbcHbmF5WnD2T2+U+ap6qMsXfDBsHnqfr1+mvz1Ag494hchR2GYCKWwSpnp/A+vi9h4H+99sSX4RJ9ReBDpJ/TkaYkUjHVMLMx1DtDziFePtJdPvVwrlvoktzObqvwUf3cSV2M84YVbnjo7xAlmH+U80jlpRxCkRibqr8X1vmJ3qufrV/1d7KltNoXOuqzuw+qhWq8WnAknK9Jtrw3NL1L4p4/r0H1JA2UXxRQDIUe5mSpWOH6m6fJ+3X7mwSdzS9QwuaNh/2B9tj2vFZPQu14Y1bKn0Bc9Xxwn+/KlYr6gulBOsIqYPlyoq9Tx0zaxdvKpL2IJdCJ/Qlow07QEcr+N1RP4wvdmB9eNwE9toGOVHj0lMInNagvb5lQ0gmOnb2zu6O15v5Dewa9CWGSmfsI1Ut1pmY8lycGRZlF2Ep9argo9YDJ6lXky+NlRs5uwbqXeHOTUGTwK88tPVuMkjSQveJNjozNgB1au/gnaw+kn3ZlUNQ4l3rOxUGzQoOF2xtG0sJadswNeeFA1xS926vbDSy+SzcWgQPetk/qT+c+qx6BOsvk
 j3W8kSSR
 ZYPYKxzyIWwW0wovWiwkl7x+9aTqqJsKOYTMV1nbfTtdhxaadEJxYu6JdRZa4RtVo4BoECH2sfuSLuL5u/hHiW7CezyDMO0pmA8qw4I1M6tdpOzNr3RkacEacp+umgA6lF84DprnIl89TfZIwnUHm8wK8rF0fEXWa0UtdNUDdRLY5MGVsRLLb1sNOC7+hJpqInHsCG5aLEmQc3AFiqpD5q1W6hAqxYIq5BX+9L5xR3EYMzrw7z9mrUBpbizo1vvXMvsMAcUoUfo0vwxSFKpa7hSTFCi7bkzRgusfrDkrR7CvVVNjBfbZ8ZfAZScP/VizgxQgBAjJv612Kwm/N3uc9OKhiTHddtMWVw7Ueii2Wcxe54FrdESTqvpQGPtVW1CNPPeD5KouqKFVvpK/zQetTNHew/EXNpRalcam/UIrDDwFwSyR0SUg2KhGHSdG42jIP5trZiULSzA4dLQeU2KiwtVl7Eemkn4XKbTsBzcnJNAMWpJnJU/hhUzq4KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This patch provides a wrapper for existing algorithms so that they can
accept a single segment while returning the compressed length or error
through the dst SG list length.

This trivial segmentation wrapper only supports compression with a
segment count of exactly one.

The reason is that the first user zswap will only allocate the
extra memory if the underlying algorithm supports segmentation,
and otherwise only one segment will be given at a time.

Having this wrapper means that the same calling convention can
be used for all algorithms, regardless of segmentation support.

To gain latency in the zswap_store() hot path impacted by this patch:

1) The most common code path is invoked first in
   crypto_acomp_compress().

2) The helper functions used in (1) are made __always_inline.

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 crypto/acompress.c                  | 39 ++++++++++++++++++++++++-----
 include/crypto/acompress.h          |  3 ++-
 include/crypto/internal/acompress.h |  4 +--
 include/linux/crypto.h              |  2 +-
 4 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index c8b4b8589769..c55b0e8eff3d 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -166,14 +166,20 @@ static void acomp_save_req(struct acomp_req *req, crypto_completion_t cplt)
 
 	state->compl = req->base.complete;
 	state->data = req->base.data;
+	state->unit_size = req->unit_size;
+	state->flags = req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
+					  CRYPTO_ACOMP_REQ_DST_VIRT);
+
 	req->base.complete = cplt;
 	req->base.data = req;
+	req->unit_size = 0;
 }
 
 static void acomp_restore_req(struct acomp_req *req)
 {
 	req->base.complete = req->chain.compl;
 	req->base.data = req->chain.data;
+	req->unit_size = req->chain.unit_size;
 }
 
 static void acomp_reqchain_virt(struct acomp_req *req)
@@ -192,9 +198,6 @@ static void acomp_virt_to_sg(struct acomp_req *req)
 {
 	struct acomp_req_chain *state = &req->chain;
 
-	state->flags = req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
-					  CRYPTO_ACOMP_REQ_DST_VIRT);
-
 	if (acomp_request_src_isvirt(req)) {
 		unsigned int slen = req->slen;
 		const u8 *svirt = req->svirt;
@@ -242,6 +245,10 @@ static int acomp_reqchain_finish(struct acomp_req *req, int err)
 {
 	acomp_reqchain_virt(req);
 	acomp_restore_req(req);
+
+	if (req->unit_size)
+		req->dst->length = unlikely(err) ? err : req->dlen;
+
 	return err;
 }
 
@@ -266,10 +273,13 @@ static int acomp_do_req_chain(struct acomp_req *req, bool comp)
 {
 	int err;
 
+	if (unlikely(req->unit_size && req->slen > req->unit_size))
+		return -ENOSYS;
+
 	acomp_save_req(req, acomp_reqchain_done);
 
 	err = acomp_do_one_req(req, comp);
-	if (err == -EBUSY || err == -EINPROGRESS)
+	if (unlikely(err == -EBUSY || err == -EINPROGRESS))
 		return err;
 
 	return acomp_reqchain_finish(req, err);
@@ -279,10 +289,27 @@ int crypto_acomp_compress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
 
+	if (likely((req->unit_size == req->slen) && acomp_request_issg(req) &&
+		    !crypto_acomp_req_seg(tfm) && !acomp_req_on_stack(req))) {
+		int err = tfm->compress(req);
+
+		req->dst->length = unlikely(err) ? err : req->dlen;
+		return err;
+	}
+
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
+
+	if (req->unit_size && acomp_request_issg(req)) {
+		if (!crypto_acomp_req_seg(tfm))
+			return acomp_do_req_chain(req, true);
+
+		return tfm->compress(req);
+	}
+
 	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
-		return crypto_acomp_reqtfm(req)->compress(req);
+		return tfm->compress(req);
+
 	return acomp_do_req_chain(req, true);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_compress);
@@ -294,7 +321,7 @@ int crypto_acomp_decompress(struct acomp_req *req)
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
 	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
-		return crypto_acomp_reqtfm(req)->decompress(req);
+		return tfm->decompress(req);
 	return acomp_do_req_chain(req, false);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 6462fc46f4ec..e64cf422510b 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -67,6 +67,7 @@ struct acomp_req_chain {
 		struct folio *dfolio;
 	};
 	u32 flags;
+	u32 unit_size;
 };
 
 /**
@@ -294,7 +295,7 @@ static inline void *acomp_request_extra(struct acomp_req *req)
 	return (void *)((char *)req + len);
 }
 
-static inline bool acomp_req_on_stack(struct acomp_req *req)
+static __always_inline bool acomp_req_on_stack(struct acomp_req *req)
 {
 	return crypto_req_on_stack(&req->base);
 }
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 93ae59623f13..0c0d3fc8a9fc 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -146,7 +146,7 @@ void crypto_unregister_acomp(struct acomp_alg *alg);
 int crypto_register_acomps(struct acomp_alg *algs, int count);
 void crypto_unregister_acomps(struct acomp_alg *algs, int count);
 
-static inline bool acomp_request_issg(struct acomp_req *req)
+static __always_inline bool acomp_request_issg(struct acomp_req *req)
 {
 	return !(req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
 				    CRYPTO_ACOMP_REQ_DST_VIRT));
@@ -189,7 +189,7 @@ static inline bool crypto_acomp_req_virt(struct crypto_acomp *tfm)
 	return crypto_tfm_req_virt(&tfm->base);
 }
 
-static inline bool crypto_acomp_req_seg(struct crypto_acomp *tfm)
+static __always_inline bool crypto_acomp_req_seg(struct crypto_acomp *tfm)
 {
 	return crypto_tfm_req_seg(&tfm->base);
 }
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 78c699ac3f82..0628b62e4946 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -492,7 +492,7 @@ static inline bool crypto_tfm_is_async(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_ASYNC;
 }
 
-static inline bool crypto_req_on_stack(struct crypto_async_request *req)
+static __always_inline bool crypto_req_on_stack(struct crypto_async_request *req)
 {
 	return req->flags & CRYPTO_TFM_REQ_ON_STACK;
 }
-- 
2.39.5


