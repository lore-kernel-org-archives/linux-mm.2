Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA061CA6011
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 18:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7C26B0093; Thu,  8 Oct 2026 14:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 677746B0095; Thu,  8 Oct 2026 14:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53FBB6B0096; Thu,  8 Oct 2026 14:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 346906B0093
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 14:28:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C63741403B3
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:34 +0000 (UTC)
X-FDA: 85300294548.13.6540C63
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id E64A910000D
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lY2a8S4l;
	spf=pass (imf05.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791484112;
	b=rxxmPnrbg1Im8x8wGfyq0Dd/8iYjVaojwo+tl2oI5USP3O+2zHNXBNuNGOcOm9e4MLq7xX
	3ayhNjOIDMci43iIk2mplcCvOU0YVJ9fjAqMtzPRBKwSSFRLgz6X09gfqY0aoWzrUo3xFx
	W4eMDKXYNLU3pvVFZM5EpGNBduc7E7g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lY2a8S4l;
	spf=pass (imf05.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791484112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
	b=vhkY+Xj2/Ia5z9r5QhKJk4ywmAqJ4wa4Y3XhPEMoYcMgRIP07QNxkJP8mgAgMXQpPvZ2HN
	51L1hhqCZa+N1ua3Evr4uRTKnnQ2s7y4BETf3Iu+lVZO2UFGubAJlz37Q6iBWKkkhUKNqc
	5uZbIBFXU0s4p8Ztl7jwV/nfNFmW+ks=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1419d3416ceso10781255c88.0
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 11:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484112; x=1792088912; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=lY2a8S4lnbAyiKeSqGJMDs8blkE6X4+cCdDjhwNxVIkMSzd+Ek1oeloFREg3w5uzoK
         3G/epgzvuizdfFNvEvEZhoFuKnxtUutNB2Ben/QmUqw+RfKh7/aOEK0KS+mx2z1kC2ck
         xL9MfUYV1yfVWJHB8csLvmUzMcj9V/Od3J0BWwEPq8n0hdgKo55OZo5NH2semcXhpe5q
         K1YOfMUfSEpaaodjH+E8OJ2ga/KlAsYIood6JZy3SdEKH/QesI4IZFMfkDtuoHJ8E3G6
         gFcJ+pIV3Alzq1ywd1BIbA413np4ouAbQ30VpbeaJ3mRZdYU5OBfI8FftgsJV/OW9FW1
         fsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484112; x=1792088912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=qx50T06v/UsxsqfZXfaIOyDtwBKv2CsK3jcU0/p1meqkbB97hajhXByGIIcSMoQLPm
         2cGTfFeuu2yEimkoSg78qGyqlVVNwiqZNWxzU7Joa8IKV1uTnLNTvLPtdwVtPpt21hoz
         cognr3aidOFw8x0kpte7Tu2tRIse7v3AN15rDWBmqmcsOM51Pkk2tikOKW5vA2HP6AoZ
         bhqWOyb/zrxmN0Wooz+Pf7COdUrcz3k+oc+xKMgrj0WO7juoqsQArJjHOxjpGAocVzLB
         NIPLDw5W/BQCQnpTaT6Gg1TEO+mQ0XJEreOFmTyX3QRrrtWB76hnm6TEZ37xL7Q3391z
         0BWA==
X-Forwarded-Encrypted: i=1; AKwUvBwIj8/8Wx+XUTlTK7sSa1gAR/g3vaM0ccoMESg9J1f3f9cyj4KSty/lBGFZua/zit4SpJlhGhbz3A==@kvack.org
X-Gm-Message-State: AFuF++kVkcfSOShRiQKzsRaLs9eM5ykurSsyyFLUa7wKlmQjA7zRXNHO
	fbf/vAxSqQQD0mRUVNqSEX0qODPEwTmqcUnkYrUCDx6XSEKnkvkooCFx
X-Gm-Gg: AYBFou201jisDm+pR2IvRc2p4jJ1AxkajIoval0FzFCEHnMXDRIM6yXpQUSSh5Q3QAB
	iIopVnfCIKWEiVQvgjQRRjCfLL2meL2BeOgDGABK5qAB4IvkwgzKZrbQ0gNC5wKFDhSZYz8GT29
	eORQi1+a2sK6mSWvFs7aXycqVvVJWeB6QIb/3VGSFPxGq9vM+LyjUkBkFeaic3Yw4Re4JZvnKjp
	iS+FKtYsTjk/7eHMSWEC6dnvzUyK5UFdpwF5WruCKqphmMcdWph492o3rlms940akPGkjPSP1l+
	qtpEoYvJ5oPVfM05lK3aP0bS9pnSJzkuGDNf4jl2r8f/hKuCVMzoDDqKzfogF8ndnW/jqvNybqo
	Uo4rCy4kT2A7KyhQcva+IGyj+IeldTCH1Qtfy71LchfZAao4dQZhKVn3MANSPpFvIkKuldVkzhb
	0LCRNKi/MVk4QZvhCmJAKV1X5y56ukw0z0+vnQ5MgqeR/2RgJap4ZpKqlAYHmwVGu9arrtRIcB8
	lfKG2qtxjqGIG8no0WI+Q==
X-Received: by 2002:a05:7022:f115:b0:14f:fb87:cf62 with SMTP id a92af1059eb24-16205cc1b15mr6242946c88.27.1791484111604;
        Thu, 08 Oct 2026 11:28:31 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:31 -0700 (PDT)
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
Subject: [PATCH v1 2/8] crypto: acomp - Add bit to indicate segmentation support.
Date: Thu,  8 Oct 2026 11:28:08 -0700
Message-Id: <20261008182814.27450-3-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E64A910000D
X-Stat-Signature: zmxwhseeu1y75q11kdxdbrf4cw1nyi4u
X-HE-Tag: 1791484112-497894
X-HE-Meta: U2FsdGVkX19HBLoO2xsIThHbMPSzTNhw1qt5TooMzgTWzOeecr++EKh63zV9/2xpFvxbff7mpMkfmonUwkdkzu5jhNOM1e4im4EYhk3RFni+iw3AhsRVzaMRFKjKfyHcxI2s/ZQexnt+kTxgdQjSbb7RW8FofqQGYFJilhvwS/N50BHRdFnKn/llnXKBj+/mOjLCMZO7JORw4Gk71978oa2veK3Ipvjh1PmWVLbWluDg/XyS0r/hp15aHndYilmryY6C6KZMd6VoUjhZOQ+1MmgyLiBdXqmlCddnyOb7pmqlJ5Al6NFACyVA2dSeWmS57C1UbYao00cla4gHkx3LhH9p6kmUu3EaQjZbVTkGt7Dh0qs/ci1ktlDc793zdeaOVsZZAgw0uO+TrA1Z3/VoSchCmdcRglvArZTs/WNXwBWH7mMcGmvHZcMO8ALFvZyk7DWTrBnkRF3TS7abj5cn0/bMjPhTt0gQTBpx4f7yD7XYCCD6AgyBYXe5rr1c1aHgpGhs4oF2iD7KMt/uWuZrTXpGJ5QOWGz/gv7Shr4YfaG1M1hfNPnHbGpvfNiuCzmuf8IA/j+uo88oYsQsYAaN8OeatrizOWaNZciGSUKkmHkPr8aDbEbSy+khOhC/nX1QPlerM3bJYNb/h1TFGsCVAlO0PNQgQzfWjnV4w9NbACftaZev68M/Mjky7a5ZtNdBFMJEeTz6flqwcbCdQZncWbFXaoIFlwb2wPCBD+cjCwT7NqJKAqTFrPgxyy34dW+e6NPk+AiNFvZk7AhcKVe6TwKKPLwmEtu1aPJ2BM7/Q2Ogd6tnY9Gx/i+2iuTg0PhiVxt2yekuabW5v7uL7gLUEqPMJ+5l8MyaK4y/pc13870cc+GX4FlkfR9TSMkxU5Vd7JmR49q7+aa5w5BRbwwrxcvwczWEQKvJ9l16sXPDvMAZ71PPaHcF6KdEZav+41m1W3BSCvNE3zIxUuuE3pg
 3hLAiL4q
 SDP8jC8u+d/LbtAoMFHJw3tIv1HVCkYnrgFo4gpQ7wLeBMu6JDzN89BN8bmdkXi/9X8CGv7xFjFXnw6kjSXuy87uo03w5HOlmx/iH/PZ8B7EDHfA1jLZY4qrUefnHH7PlZvQv70B+FLOcaurD7tILC5yqChTynv2x49jzDdDI6xYLiK2MsEUhEXfBrPZ8up2l6QUyN0s4ajgIvFrf4GAQ712knljKaJuroQ/kfuai6AOzahk6cDLWUFxO4M2gjtqu9rZgfg3b+N19P21htJqYf1OHh2tnA3mdBOMHL6Umk2lLj94pXzfl6sjIG4+YbzqUamLipdqGJTvBbTge8SUQ3pykd7WNbukKPpTXpkfenBk284sCKLj8oTPvq8w3JPncfm9F3vQPh2K+H+QaILClUw0/LgQmgiZq7hoQhJOZh1lDSh2BO+CVXZLpAC4lBeDWFzXiqrKq+jmJ1Jf1KOcDSifiobmz3M5+kGwUzEqwqiqQDWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds segmentation support for compression.

Add a bit to the crypto_alg flags to indicate support for segmentation.
Also add a helper for acomp to test whether a given tfm supports
segmentation.

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 include/crypto/algapi.h             | 5 +++++
 include/crypto/internal/acompress.h | 5 +++++
 include/linux/crypto.h              | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 05deea9dac5e..7d406cfe5751 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -280,6 +280,11 @@ static inline bool crypto_tfm_req_virt(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_VIRT;
 }
 
+static inline bool crypto_tfm_req_seg(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_SEG;
+}
+
 static inline u32 crypto_request_flags(struct crypto_async_request *req)
 {
 	return req->flags & ~CRYPTO_TFM_REQ_ON_STACK;
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 9cd37df32dc4..93ae59623f13 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -189,6 +189,11 @@ static inline bool crypto_acomp_req_virt(struct crypto_acomp *tfm)
 	return crypto_tfm_req_virt(&tfm->base);
 }
 
+static inline bool crypto_acomp_req_seg(struct crypto_acomp *tfm)
+{
+	return crypto_tfm_req_seg(&tfm->base);
+}
+
 void crypto_acomp_free_streams(struct crypto_acomp_streams *s);
 int crypto_acomp_alloc_streams(struct crypto_acomp_streams *s);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b7c97f1c47c9..78c699ac3f82 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -139,6 +139,9 @@
 /* Set if the algorithm cannot have a fallback (e.g., phmac). */
 #define CRYPTO_ALG_NO_FALLBACK		0x00080000
 
+/* Set if the algorithm supports segmentation. */
+#define CRYPTO_ALG_REQ_SEG		0x00100000
+
 /* The high bits 0xff000000 are reserved for type-specific flags. */
 
 /*
-- 
2.39.5


