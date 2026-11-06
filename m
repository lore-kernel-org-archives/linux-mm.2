Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454EE606EEB3
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a1D6LomM
Received: by kanga.kvack.org (Postfix)
	id BE3B86B05B6; Fri,  6 Nov 2026 02:24:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6DC96B05B7; Fri,  6 Nov 2026 02:24:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A366C6B05B8; Fri,  6 Nov 2026 02:24:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7368F6B05B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:24:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0450880CA0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:24:26 +0000 (UTC)
X-FDA: 85403856174.18.A9D7DF9
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 27E2F140005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:24:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=a1D6LomM;
	spf=pass (imf26.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0Xj9pg0Rg2jp4fCvJcvvgKONDkNxiGPLuEEZm9n/Ik=;
	b=rwZ2hWloMtIzunAhGwCnL7l1Jk2VJgmm9u3WU6LUfpqv6/7y+e6XHpu0KLJIgc0FygPsIj
	EbUUCGN87f1gHjjrLtskx4RDq7uOmI9/gOcD8DpafPuphp4VAOKWsHu9bNiE02/97xq5Gv
	5aHjYKQmhZVUc6XWjRTqkzj2HvrndSA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=a1D6LomM;
	spf=pass (imf26.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793949865;
	b=0JzKnQfvY+gmyA8RRplrz++TcQN3PIrtpt3ZD+qq96YNq0VSu7ZI6RpIlDGx1p0XsnK3XC
	PkRhaUGvXy+Cq5YDQFlt5eSc94U4ff0fetzSOVWdDGP4ZH9+EdjhMoXl/OaasCvNH/NAvp
	JiFqj6S0acMYJL1KBQ2qb3U0BIUQb2I=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1a3c08d6928so665585c88.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 23:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949864; x=1794554664; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J0Xj9pg0Rg2jp4fCvJcvvgKONDkNxiGPLuEEZm9n/Ik=;
        b=a1D6LomMGspQoNDy7Xdf2aafEe6ryOrMYcczAOQfoJDwRwFU1G59/dsncznQFFTsWn
         pX0ar6DtKaNwYbKgLA824N6mxhyyzkKsuLjr3pA06+aB1cwbEWEspi3NZYx4jzzcqKXS
         MSrXZbmwzghGypAzzEhEmLoxw429rX2oNT50u9L4/09wd/FpskkDJ2nPxv31M3Uf+gng
         P1vkz3DkFXwU75GtCt+AhuTBSgtRAgiDX4NBQRE9NHVHvxnsXb0EHNCXu08UWFxkwmkx
         /hKAgn0vaYvVkzbfqDIVnWLaU/nHE+UgnhFOc3QuVeik5iEryly3PqUSKhYR4OFvgcVi
         L6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949864; x=1794554664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J0Xj9pg0Rg2jp4fCvJcvvgKONDkNxiGPLuEEZm9n/Ik=;
        b=a3o939FsmlyetD7zN1dNKECf4jJa18EQ+jfYTLlXM8ZQwywHoJZgmpye6LsIR4Io0p
         gqqr6OoK8NH5MxTWa20yT6melvrA1AfnKmhwzUTMkE4UpVsK2ohOZqC7erZZwFxCAlEH
         iCk7DXWwjmWeRsHO4nMaiIlmv1NTKJ8bHs2m/Znb7MQNTMOP4C7G5oGRResCi+J6f3Pm
         pg/Ja8M75y1QSVlaSEmTtwnYqM7y7ze9Lorn94C41vM2HcBtFehh31xpwEni4ABbLrP8
         E+ly6jzZppb0rYkli25cCgk6NCwPlMNcA/s7j8OJJUm70jPIk1AQqucXfwsm2T5rwUq+
         MW0g==
X-Forwarded-Encrypted: i=1; AKwUvByKHxs/UUqNm5zJPvFzc5wayKeIyTkQAc8rZSrji/1JqAUJJJhZAOsrj7K8EULu5+MBMZlNdUop1g==@kvack.org
X-Gm-Message-State: APuU4Z8kB56vjgB5yNbzL7ZNIpRZ+y/xGMF3go1/H8Vpzcc2ud4h1oE8
	6eiDVA23JE4cd1J9lgqjzQa86837iM/MNGDBecGEbV3yfLf1HdVeaFV5
X-Gm-Gg: AYBFou34pY4XEAp1bOlV/Dtf+y3+kgm6pARFSetQtutWl/HlBVggLSOspy5jbEc/3qo
	MnSqZ5wQLxcziEJkD7svJXrchCN19Uq0dENUeT3xNtkqQXcvAc2/JaGxRjT9BnGHhff8eggt0a6
	0RAbb7p7cyqDl9Vz88NZZTNff6Adsbg+KdUKUaJdiL8uJj23G9VdntBfmfDAFZTh6jmRbC5fu16
	ogwPlxI/+tCvO1L+3FQNK6srOafHoshO5YvU9+x6a2jNWujuPnxDK5w0+i2jHX8RRk8C+dwCzWL
	ISTSK60nrRrEzyZuDs0NADi2H7+ie7umqzR93S/Js/f+mHhPcikPMJMjIPrWBll5mxArr4QpsFW
	EnEZZveQ2rcDNp9sAGUUENYqiwX1cFv5o9yD+KIJ6dtBB89wzgnIwPpX1KOMsnXgmwgQ4eZoejk
	Rq7LxfN8bVeQrtjtzeHBY7CaK+2dGw2xQ19+rdjtnSrU56nB2BxHvGRI9qXr2uE5xyxPZ8RZotZ
	9xvSPPfExKUYRxYbdfSg2dzFnVulKexQ9TF1kt8qYh9tGYDiQ5MOyeldLSrrhDjhUXNx8OORZUN
	3AEZkIpUVH0PCWRSCGfWL1AggabvcmWg50JQYQY6Rw==
X-Received: by 2002:a05:701b:2905:b0:151:2e62:fe4b with SMTP id a92af1059eb24-1b25d338dddmr1769252c88.23.1793949862359;
        Thu, 05 Nov 2026 23:24:22 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4840f3sm6262220c88.5.2026.11.05.23.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:24:21 -0800 (PST)
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
Subject: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation wrapper.
Date: Thu,  5 Nov 2026 23:24:07 -0800
Message-Id: <20261106072412.7909-4-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wbsae5qyf8xz7hrfmzho8wqpgqyp1tpa
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 27E2F140005
X-HE-Tag: 1793949864-747863
X-HE-Meta: U2FsdGVkX1/JPOkQSRlv44uBVPdfDBTBQJb+lfhMdcYrfmsj8JrWvuvQwYdYrCQP1ZHtVyoIMBQOvkZGNGS+QtkA32WlnjgFqBoZctY2T24J7QBlR5Z0rYJatS5R8Avast2Hkgk0pxMnI7gJti9mlUdi6lfQN0cNiyZdlPP7lDKymha2XRFqt4HZ0jH8UyHsXn/XC7EWCerNuSKIPrU2pNb88DtoE7gW6wrHOrg7ykMQw+QTUnplqFKFteGiya1wPUN0LCJ+5mFw7wazfdug2PqHhirSWkrLENa212WPm56FyFIa/i6zdV3adyi4SIiQZOIWQvSoaApjWL7gSyPn4Q+ja8T4wuNTVqsTG5GsFlxxuxOrHmD0onCGmLigH6eQeSddq4FfkDKyqde0cSj2uMJH58ii5FsCwjBila3z1c0NuHxHUdueHe4k8CNU0PL2G+FKdb9pe9ZE6g2SN/0cmDhWLN69/uG3Brr6eiPWS7v+R9h56AVrXEPSjFqZQFO1QnvRmz53l3edbUfltxlat3hfZBTHFitHWAG1idW0YMT+ha2ieASqpNG1URwiWDb7qsYpHa6GKmfi2ngn8Nh/75w1MvsiKJdKtyQBG4qQY8QI9XYwMB0dUiM61l9SuQa4O5WYZGEXc0o3NzG54VLbgM8d7iOb+PrznMMf0J1/7LrlvU7B6fABbvDIo+nyJrx01IhYU/K2Myu+kmOdrofTeuRJC9ycyDVtbRo08JMAzyBmQgD3PYngS4rm+QKh8md9JhslBunLYSgiK0bWSYBanaSAsBAg61IjSx9ebtx1Jkc1MQYzt15kvqUHshpFbrIA47xXmMxpcWqJd1PBJBZmNegkUrUCSvyMtqd2Edr+U3MOcItVi+gIvL3JxYXdica30Ru4uljnmAukko5J331TmCyK+EvD/xmEpnw1WFWspE59keGStHEsrSpeBcIrYvQdTpXmQu3AGvIU8Ur3dHi
 LJ7QQFqU
 CoIcIaCvXGaaZLplQiiG39LN7DMmiF1bCv6sw2szvaUIHhlmmfSLeZWvAF4ZQBzAYGwBTuQzwsMPmMUJ7cwNhslXitwgtihEqVDHYa/XDtyl0Vkb9QqwNpi+m0xuO9rjAIkqp6Vaf3eF/M7tnkoVc3h9N1fq8e+B3kqHG0uSpXVfI1cagBzPbA6/QE/buqPfF4ZItfatjsPnR4ysb9f8WoHROzCQotkoXhlieM7bqsInTsktOtW9h7iloOSBBDN91J4CGJxwuxdnduXnzg2KCQwFdC2U5M1Wf4EutkvZRxS1ms5gH+ufFvVtDTjr7HJdQJVsn5AudQTONuf34n0mJrP7vuOmBBQgN8AT8C48dlrqFT5whfk4YSnziQIIjscxHXIhqpwUj0JRhoUwIEo7diq7DupAyHCJhuKTpfcIbXYOujPAchPg1ttfmwLT85GnDFRi0xOiul10bwyd7jLjsqB82A+JVty0z+2NDTAwsDtgmE8floRvzVWZJGg==
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


