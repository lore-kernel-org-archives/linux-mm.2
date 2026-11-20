Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F6D060A5BFE
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LxHW6RPV
Received: by kanga.kvack.org (Postfix)
	id 0286D6B0723; Thu, 19 Nov 2026 23:19:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C886B0752; Thu, 19 Nov 2026 23:19:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07B86B0750; Thu, 19 Nov 2026 23:19:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2F3A6B0750
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:19:24 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A6E440A9A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:19:24 +0000 (UTC)
X-FDA: 85454193048.20.71DFB75
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 70C7C40008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:19:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LxHW6RPV;
	spf=pass (imf27.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795148362;
	b=RsS5w69vNRH4cw4rgIdz0QHMX/Hmwog2jBW7eCIsjCnLbYXg2GKEQSR7C2gLeQw53qQVFi
	UEc+R6MsgflMI+Pj6UwU91+TUnpsSv9DhKJcPDorTuS/Vov8Vd/MQYV2VHXIaUWyfia2NY
	B+qoKLpkCmybj6/wNbcHfhAyDz5yieE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795148362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0Xj9pg0Rg2jp4fCvJcvvgKONDkNxiGPLuEEZm9n/Ik=;
	b=gsXNWVuo5Ya6LvPkurv2W4K3eK6q/cfM+zFdQScbB/Dbj9j3QybwG8g6dp/PZVuvmGXWea
	YeS+B2TplHoI/5BWW/G5qrR3IIYxPE8xddTwjkZzrmfaSjfrhehnmnxhZK04WwC9uT/xTF
	mlJhODHqi0c2FdRVeYS4vaPtf6aDpmE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LxHW6RPV;
	spf=pass (imf27.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-14394530ec6so797495c88.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148361; x=1795753161; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J0Xj9pg0Rg2jp4fCvJcvvgKONDkNxiGPLuEEZm9n/Ik=;
        b=LxHW6RPVxHBeyn+sRuvvUsz51MW5rGXQrVReQYcMCiojAsJeaDKlWmVr0lCbi+VOVf
         EOA/dU9niVvcoVs69dAQpjWTSxF7aMdeLo1R6r5UjORPkA9ZhAOaG9bI58vX9fPc1ify
         DF4jbINEKUaVTZYBRbFd02ERCetTseLWPWK6V7HI2/RYlgD515+nGkhQsg3JvtAIzdZo
         9RKHRHn56IzKfLjkc78jNz5sC232K4W4Nwrx0xYSxBn0fwpymX2mzPnsCd4kOfQ+F6Cz
         g/2oWmSbv/pRY6hGCiBynG5Aie5LRtJDVWhPeJsvbfATc29GoTijlHLZpH4f191nuyoq
         LVnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148361; x=1795753161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J0Xj9pg0Rg2jp4fCvJcvvgKONDkNxiGPLuEEZm9n/Ik=;
        b=VmEUzpRO9tezoUeqHUkHCPwaAsizFxiN/ivxZOJbcuXsHJmQrcx6ojD7f3TjCQ2Tbk
         f5VKLbeBAw85ajI+nLsOf3HjirrjW3qB50+FAA4b8KdW2TVyf2IZzZj+aETyd8TFRqKl
         oBcW9FJ1V0B6MYF/O7uiHQ/LHWTO2wvF0DjG1NF9cmLOdVpqbKJmnEF+4QbpJbZd1cr2
         ko9JKDaBQyr3ENT3TTz3s15Zcx+/dc10Ss3O3Tk2zesfcyoeZORB08ZjFDNHY0S/Nl3C
         J7iWibBCArwOioruTY3wqisy2kRkcbBmzyQmmJPzCtEu8D1eNvIy5NzZMmhWV8szfvu7
         E82A==
X-Forwarded-Encrypted: i=1; AL+hErEqNJsEy3GzLCBi4RZQKgYKukPFrybaXnL9xfjRL20fI0FeSMPChUhY+qDu0ThjuTlhPx9t6GKSGg==@kvack.org
X-Gm-Message-State: APuU4Z9hz4HQYd9Vxd7+7ALeJX1QnBaLXyvluNUAKfnq8bm7aNdU5g5E
	Hu4do61gdZfwyzuXZqvMEcemMs0YxwFjQtbkSHdaTmSadHY4OgV9Jvvv
X-Gm-Gg: AYBFou1Kpb9DYe5wC0XIpARO+JNOcOkwV+LgKVlmiPiftS4uxXbsUznF8D1HGKnhTEl
	fsb6hcRJ1DL6QuyJDyPJwGRN2Qs72dTHRKV6i2Nz+4IRf+k8kYOkqUVPW8DNYMkXgvcNwhC20aE
	XWeU6XYLBC0Ju+A7mb3qUKxQpiYuw14Qf9o+0Iv0D80Ub4i3Mw2rE8BHe9sGNYwVZSXDe3gzJnj
	57dFIPVYIjPF4Grtz4UmkV/pTJY5sLf434aBtSlCaVqWE/JccKiJoJaEhT6LMMfQEtK7OMPyFsU
	0SXBuCAQmDWKreO8NMsPUbcnscO1Z4VkrOl6swoEC4d5pU0bGcJ5U9LujUXmH9JEDECXqbbB40i
	Fn+jyi3/6fabHHxm5ff1dgp6wsSQb+jYENM9CTwRg7VxJNdJWCeElUJIUPQcBfmwxPhJHfdSLmi
	QblzDawJ8JeXJWXrCpxUQMhxFPWQqfU2JnvWDMUOxJOQfD+IiWZDrutqnH1xREOCo12fFJB8pjK
	p8ZOT419PhTPP6FrMY+e65BRSbQfp3r3HKkvMT3qO5li3QJQZozWf3bUslvV5LG67COreTLT3O8
	CeexKGSf+4zz4fA7YeFXPM9znfaxWc+5lZJoFt+54A==
X-Received: by 2002:a05:7022:3c07:b0:1b5:514:6a23 with SMTP id a92af1059eb24-1b55689e9b5mr1438994c88.13.1795148361171;
        Thu, 19 Nov 2026 20:19:21 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm3124341c88.7.2026.11.19.20.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:19:20 -0800 (PST)
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
Subject: [PATCH v4 3/8] crypto: acomp - Add trivial segmentation wrapper.
Date: Thu, 19 Nov 2026 20:19:01 -0800
Message-Id: <20261120041906.5785-4-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: 9cfbzt43edaqs9ou7fyhnybc5i3pjkwm
X-Rspamd-Queue-Id: 70C7C40008
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795148362-436928
X-HE-Meta: U2FsdGVkX19yTjEomJeONmX3Xouq9ZWaH3Vs9yrujHGiZp3+liftUwPhafciiz9mGk7oTkWfBT4NG5JPQvpVZlDzsjMd2fCzc9AqBJdivqafWoNVZiToTnSKHVvxPctyIRBSUuHwODHaG4xPRU1gVeJkIveZmECJBmGppGuZmcFejMEFxe5aAe3Kb4hK5Jf8yFi09HQr8ANJ09NtmuWaSoyT9CtHilccaAweOMhIKZCx9ojoVo1D02nW4Wvj3sAC2e+TYvmyPwrAK/L4/7DIoirQT4TniMsZRiuP/OR4oamP+5O5joONFfdW80x9FSwq9fUOs9SSCuWn18S7T4ZqqQc9f/mK0SAooDMLZrhx/6zGpSA9rjsRnbKCLAUkacJ7YPp6RvtUlgFWyn38/e5UMCvbzHo2mX3FdVnSkPFLmcNqxcauPQaDHP+xll/MAdXIuLjnzrzFzjKHnHxnw9+8xJlpk9yT3f7YbcijsfgdvREQ/vyaiBF2iOF1+3XdXxhqZQisYPAFaF9e/cQcFHcF+loilXmCGMGyQm/bG/LLMtRkBUKTIrJxRyy/zfeq2CBtR4lrgHnyZk0ipCjvfc0AWnh21NJHvbl6JGr43e/EHF3TLHSePg8Ktoxnf3vVxE88Z02OcCCgARVUZdtGWZPNaYLq5jZ3XxPA929bTq1FYZF8GlpeFxbkT7EJ2CQ8UyBlVWTDFWk1o2qx4+KCA+qaQ8whrjHLyxVLfus6jBLkDZE8AYgF4yJ+3Hvj8Aq0G4/i8/zCf5VRR7Wo+SUb2YwKs0xRkpbEQEgTNE1HMx8hlmE3GZXMhAcf8ktGhJ2hyrCWKuOhATHs4UvBTGKonpplLVolCjuyiMkZzEU6lc42/5xHYV2Jj2KnfMXnkGu6uoJV0HkP/g0SUGKvADNSgmgut8GWJSzmB+WafAStraa/YIRrCmmfZtjVrNu4gily6rpfmuC7Gda1uclN+c0j9+M
 EnRj7+KR
 9ynVUeERT1EQIBJ7gUKol9YG2IuLaSQqwk+rVoB/LACaeTJJH/AafJEW/uLjP5RcWYS4lGyIY08y9HNYrjTCLZvsd7R46eoje/T7h3JekmvHZYro49glK+GGbEjoNSNXMKmAo1ufPX6dIonKxF7eHJdHUe7lENSNbAAbQuOa4tZX2J6Q6EtKCKIT4HbM9Xhf3w608DUwY2C/oVbe1wGgD3kO7Xus7ST0J4O73c0B55ILKh9oK6dVudVWVDCtHhKsQnDrAaHceH7n/cTWYmQf+oFmrhIPkVFt4UR+yhBBhvqORIsJoPv7xQ0sBmHaAjAg/pghTa1qeOXMCtQ1Py/65BWhKG97iMNGmrCtBZR8xjrpGlTEUb+RA9pEpwMGjefHARZ9dXk2s16+yDoMNN2LhRyt7exfXt0daN8f0ZLAmsUzLqVefV0ls+2jL61C/+QunJazitYlhvHtSLNsO2YtbOaWeOt8So3fFC/Rqcs1is6b4M0OPtRMOkBuMo2nMeNLEU32i0SHkz+8HQq6bdS7w50MKFbqcfF+5pvf6mekbDzAVgIkFQlX8w1lGi/W0uvDDfFyWKscYlMjkG12jGLpd2Y1Zm/RNUuoyUMUmznSXqI27BQTusHyQY7xLUjQeIbuXCYY4wrVIEPxFs82O4AT1cgUV0EmN/VI/W4TGaqNCC4oXS/lRJE2u0KHSKzFui9A/lqc/tbccu9xnJbo=
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
 crypto/acompress.c                  | 34 ++++++++++++++++++++++++++---
 include/crypto/acompress.h          |  5 +++--
 include/crypto/internal/acompress.h |  4 ++--
 include/linux/crypto.h              |  2 +-
 4 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index c8b4b8589769..ac4dc52668b8 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -166,14 +166,18 @@ static void acomp_save_req(struct acomp_req *req, crypto_completion_t cplt)
 
 	state->compl = req->base.complete;
 	state->data = req->base.data;
+	state->unit_size = req->unit_size;
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
@@ -242,6 +246,10 @@ static int acomp_reqchain_finish(struct acomp_req *req, int err)
 {
 	acomp_reqchain_virt(req);
 	acomp_restore_req(req);
+
+	if (req->unit_size)
+		req->dst->length = unlikely(err) ? err : req->dlen;
+
 	return err;
 }
 
@@ -266,10 +274,13 @@ static int acomp_do_req_chain(struct acomp_req *req, bool comp)
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
@@ -279,10 +290,27 @@ int crypto_acomp_compress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
 
+	if (likely((req->unit_size == req->slen) && acomp_request_issg(req) &&
+		    !crypto_acomp_req_seg(tfm) && !acomp_is_async(tfm))) {
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
@@ -294,7 +322,7 @@ int crypto_acomp_decompress(struct acomp_req *req)
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
 	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
-		return crypto_acomp_reqtfm(req)->decompress(req);
+		return tfm->decompress(req);
 	return acomp_do_req_chain(req, false);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 6462fc46f4ec..93fa02ce818b 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -67,6 +67,7 @@ struct acomp_req_chain {
 		struct folio *dfolio;
 	};
 	u32 flags;
+	u32 unit_size;
 };
 
 /**
@@ -199,7 +200,7 @@ static inline void acomp_request_set_tfm(struct acomp_req *req,
 	crypto_request_set_tfm(&req->base, crypto_acomp_tfm(tfm));
 }
 
-static inline bool acomp_is_async(struct crypto_acomp *tfm)
+static __always_inline bool acomp_is_async(struct crypto_acomp *tfm)
 {
 	return crypto_comp_alg_common(tfm)->base.cra_flags &
 	       CRYPTO_ALG_ASYNC;
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


