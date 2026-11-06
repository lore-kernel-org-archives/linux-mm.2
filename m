Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B9D606D805
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GYiH9fxD
Received: by kanga.kvack.org (Postfix)
	id AD1C76B05B5; Fri,  6 Nov 2026 02:24:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5BC46B05B6; Fri,  6 Nov 2026 02:24:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998E86B05B7; Fri,  6 Nov 2026 02:24:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63BDA6B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:24:24 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1CE2A08D7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:24:23 +0000 (UTC)
X-FDA: 85403856006.20.65B30ED
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E016180003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:24:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GYiH9fxD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
	b=WzibBSTajgFeXw4hcPioOC+IvPO2fT7T0OWCKVoobyLsgoaYpB0Llyzh+R/XIHeSqcinrD
	0laN44kjZC1dik7jQb+HpWuWN6c+cRXavetOte2gCMNwJmfW8CDUBfPT+AMCrdpAPlnp5s
	IECU+aUBFYCqZeTR2zVnYhugXNOdHls=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GYiH9fxD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793949862;
	b=v2qHvr6uly006UMJZR/8SIr1To9QQOvz0voWjqChNoLMVfnzlv1mkQLo927yIwDi7T00wi
	KV/RpKeGLIyA0zBMFKI5YJ/vu9+NLZfJ31O7//hK+Dp2c2mUChUkwPQZFunKF0kz9nSvv0
	R38i8Yjo+AmoOlMASRpYIeuAqeVhn7M=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-15dd124bbe7so814102c88.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 23:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949861; x=1794554661; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=GYiH9fxDZx80Z7hUjJ4F7P58CiafVoy42zmJC1fhYX5jqM4mlznfW24LDob4ImhBSU
         CIfvZQ5fFkono8QAO+osqBqGk9kBKUJcDZxDSImU+gKnB2VkRFVpagWtM0b+/RsGsxR9
         An4fig4OYHr1dN8aYRRMxlJC9ks+MH2ZS/8dZmN6Zj5ohCs9vjj+Cg5EPpxAeUUsArXe
         kjFmddTb18rGG6PtPF31P9mDecfqRANcpS0W08x0CXxwUQfdNzTuawU5ZrCf42pgtUQa
         aaPmI7oiAnL5aJQx3UccHr3xFXjKNTlovK9aAVqYlVuYSPDIEy/BPhUISE3F4Y8v7laz
         qNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949861; x=1794554661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=c+b7NdTNJW+qfZjIqOfcNzPQLni597CpA2z24MvzCqJVAih8mBB/anON98Llz5T1tT
         0mHBjwV21k+EuUou85r/She6DQ5NGdemCSJ0Fu/pq/mO1IWXm4Qwp5aDZrXbEd+1xXdd
         hFtjQOAfHX+6I5WaFAgFWeeBL4Br/sRTMbLncvA59jlahsdYn3/SLX52qZmHpdAlx0l1
         2MPqLWWzy8ZSQV2RF/QC6JGv74fHxVAOlF3sedlZP7ZmWzT2QuR+4gFMfELjN1rmHD3n
         Hvab8aOvAws/s92A6mt/xA50KWoChnaABwI7BfCghqePas1lHkTqgUa/vcmff3Hjk/6g
         tNLw==
X-Forwarded-Encrypted: i=1; AKwUvBwR5Adm1JURb2e2HLvFERXLzQ7y30LSBw/nUaK24XfOGAg70CYs1A1RxgsGTu9FPxCvRXSAyr/83w==@kvack.org
X-Gm-Message-State: APuU4Z/mPkAe49MnQhArqQHeDbJa+qecCK/3wm465dr88YLvshkQm1QG
	IWkzJnPY3+3BnbOm9msPX+tHkwWocG8jdWJegTgnGrOSBlPODQ2C+lWIIQFkfA==
X-Gm-Gg: AYBFou2N04i6YHtocWbFsbadkOjGg2CqgtXd53Y7A6JSfN92ZANG/8/ETQFQgw0bSWv
	z8dtMZmPO1tTLrmtu2+qrJO6qaDu+0y/hatid8YhV8JJ6Y18SqTIx1QZ+47aXQIS1H06OrKvFrq
	AEdbSbTWD6aLGhuT9usJdQK2ioPtBt2jpUK+/WlCQmNompOQMVrj5gRNl1lpJx/VB41AxSN4c0t
	SJaccNFaemgJWLMLdnyTQZN77UAEyjpCZRD01mwSXwqum4gwPoLUtv+YM+/LafvdIKxlDLo6Jif
	CQumoubT63nJF0czkAnsU9VJb7mBqFLvtWUlOBQSGOp1xI7qlAHDpQsQsXUF1O39rWCBiUBbyS1
	QTzIFWwBpjhQmKpmyJkfGz4BQdom5Q/ZkHkvy7JVgfTi2ajdoHorN/KSg6DOOcjGumcfjpZfojQ
	TvGaFekv6yQ2YfLFbsngs6X7tW2IHYo49QnIOuk9JhNvWiByk+bdyP97FHbgBAX+h7TOCXC/rnd
	wf3jDtyupQBq3nSzwIpLkDUVm32HgvHzjhbN39+E5RLGojxz+0Upa4MXEuWYAB4ft82qLQEN48u
	X9FiU7Ph7asAe+KkIed6+Wn/EZmgOWK88nlHYdHR0g==
X-Received: by 2002:a05:7022:ea8c:b0:19b:98bc:326f with SMTP id a92af1059eb24-1b25d31f475mr2175998c88.18.1793949860685;
        Thu, 05 Nov 2026 23:24:20 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4840f3sm6262220c88.5.2026.11.05.23.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:24:20 -0800 (PST)
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
Subject: [PATCH v3 2/8] crypto: acomp - Add bit to indicate segmentation support.
Date: Thu,  5 Nov 2026 23:24:06 -0800
Message-Id: <20261106072412.7909-3-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0E016180003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8acrqumhp79wecmis9qx4zfwioq9okh9
X-HE-Tag: 1793949861-270129
X-HE-Meta: U2FsdGVkX1+kSKM8WXcmKJ2lpw5lgiR6HOIqFl7dlxQUC6BIjnGU/2tilvnpkx9nCDZwhKIiaYDV4QhwmrLKbdqDMQD3g50t+hAw98u8auPbhKmAu2e22Nppvmhhwt3IWFIZ3YSjQYGXuVJHA7EZEw04VT6tGvRQT1/vsv+2sITqGqFnrEauTEFoZzEYKPOdwrzE40LEoEZgW9ZFSnBmI4ETuHslAieLTJy0umG0omYUV9c8mXihiIljcmfkhIKvzkvKE2n6T3vZnVKS6Y/4BkwifmOCJXgsCtcPlnZITHJpM4AAqXjGOzT0aYof4OZ/sJ2vZZBrdBG/XDHr7OptkTbNntxtzffg1JiSdIxOjPV2A5chNNzASDKRQOkKuo8vw9Ge6pBEVtWNSPi9kPWEKa0XPkFXL6GJxgB7OBcIBUOMNOsht9rrUKQNHPUn6Ak3gfOxZd3hoyuGWvMYZ+kbx/7QM7bxEvF+gykSjslRhjLPbop7COzllp776MZ022QWvuPmLbv6/VsiwZMqYffQih7mYdACflRbVavjJO8ksZ33cSgjUOjODU2xZ+YcjEGhzLK3aPbzg3+C2lQuGeU6ECW1m1umzT1Ar3cfw9kk05kC72E3257wE4G4k46JKOlWfm549jizTzqDavMeOl1QYX0Mn0PtlZR71JrO2vPWp9jRVowHdrP1g9zbJyt56GsfAcFYYUz+HNBGxt+taLs3cklLcW9CuzIU5x1NVKQAPcIfD4uFi/hEbHoJoqUA1xiULyEwl4Td2pwwuk3Yg/A2mu75kPYcf0asWnl3pwsf7xLcxI2kt0XefJnfDYDR5Bt9NGaz3uvi3w5aK8e916ibPpzWIOrj8Ri8sdVO4jSzVKlnnp6dtDwBGx9Jy/vmM+IuZb3ygOFBTCnzul6RZv3gaF3ftx2FtlBdOixvo85Jc0a+iT4F3r9pN3mwtiDS10XpmM1hJzr2pOKhel7EMS2
 StrsN+r/
 rxfAgi+Z6JKS3QwzVwWv1n2PsXzioZ2KBj888NZzjD3/FGO6On+tVwd0BRnxZ4MOQD9I4oyUtmb66Uq4SWUhw/CT5je2SfRZAnbQbFg+QLYMTZwZGmfWRuprDvN8/V9n8duPwrGTezcEuvNkMkrxr4Ai/M1z1G7Sn1l/8g0d8g9ViO3Vzin3uLNrQr4luY2T7Dmvi+cbi3wZ4iiZ+1tEDypH7wtYy/ygtvKpCuhvWlUh/dhe4yDyBugq7LF+t/bTgKJun0vaL+z2DIrlUIyKH04DsZ1QBRSaLSd/ifWDeHGsjKWhkraq6VEJE+hwYGqltkOJjULHKW4Y3ZL2tYkse/CrCe3jzEdPdAPV+XNI8DoDPs+EdliYSo7X+r4J7K4IF9/GwBUDmp/J0j8zraqNrluvfkSKl7Dfoh4KTY7havVgX4ngopgBKpOzsHiTaOJInwrXe66JWnIPIiDc7QU4W0vNOiq+1Aimrgs2BjeW0xrhK0FE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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


