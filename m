Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297D4606A329
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 03:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LE5+UPgA
Received: by kanga.kvack.org (Postfix)
	id 16FE36B0961; Tue, 27 Oct 2026 23:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146826B0963; Tue, 27 Oct 2026 23:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D726B0964; Tue, 27 Oct 2026 23:05:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C12B96B0961
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:05:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DF3080B05
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:16 +0000 (UTC)
X-FDA: 85370543832.15.26726F1
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id D1613180004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LE5+UPgA;
	spf=pass (imf24.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793156714;
	b=MXKF6TgYp0uRQ6GfuFkycisYdZ43o0ZGwkOJ7yJD5c9TTctJ8Y6pUwHK5ntgBa9/b36SWt
	yHyO67rNf2367UKgsvwBuoqOinkgzRkp8pDqIawzCv9HpwpfWs88n+fc8iGDtqVv96fpq8
	7RUfZ4PACeRzPubwdAmpn7us/T2p8IU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LE5+UPgA;
	spf=pass (imf24.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793156714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
	b=ygOyVXGZqFgM71HiAL4mkWhyzHAkjXbSYtpchceJ5pUhhltYD6i1ZbLKKkULuBejOWpMrc
	OPLvYWw7FosderR5b6Gvy1smGA0wekRMObmj0u3tqWnTUkqdT7gsUOn044kxL6eBXWDJrj
	rysDjp6XN8PrDf4EUlMkm1jwMD0VT6A=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-14fc585291cso374600c88.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156714; x=1793761514; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=LE5+UPgA8FuBaEWAs5FQbhPyBTd3DLcpowBTVjgkOKnBwxScedzh7f9G+UgLHW/tWf
         Vuzi2O2To05Sd6tTWX6oelASHCo7CYCzvoBdVv0CZqrCw6/qWJTGnkn0QJ8sPJfX2O77
         Elk4SJ4lXJF1EzFLWNLgWhjNIh3n6sDH7do7jTwcJyJc/h+y/sUfWQ2jRR0otYdr6ag0
         kYE/OaeAENCU440tlOAIVaFgcUHJcwfrQad7CNb3uJpMkBmRU0hjxOs2HdtEXRfPmnQ5
         ZqBkXTrTyxN6ShNXiOPlPGSh2G4plkMrblyfSvi+AbvL2z+xhVj09Vb5ycWuLXcLaFhh
         2pQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156714; x=1793761514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=vfKrXDBBN1f9g5ZIoAmhRkS4ukbUzuXah7E3yrV5KKq+px6irPsL0c+QV/rkVD1zVx
         ypt1o9fJIREtRTlX8nrUJRMXbHOQ4tWa5XW294Ps7kdi1HDX+WP3IxkoTWArCBWqROEK
         8tsHZOghLkmp//1SxPFjB1j/Auv9lsbSSMERdPuY4Jar2eaAUuXnk13XcpibzZhFCYwg
         EQKBgMkJpOJUoJRByCOlVA6otA/zFSh7St1+Hc0YToVQfwkce1vlLIEb16zTIHtAmOdr
         UNDLVqTKw89cuZ6eV6PEmkyYXr1r9gcFI1YlMp8d6R/ar+uvRAS4lWM0HuZfjAQzX9Vs
         23ZA==
X-Forwarded-Encrypted: i=1; AKwUvBzmqTGFcdQsXAr5blXEoBMWYD2+zbvnBTh97lh2S1ynfT97sN6nc0QW0HxQJOio6UknCjhQ1yS/0Q==@kvack.org
X-Gm-Message-State: AFq9FYIaVYao7zEzRn7xTkiwfUxOfxPiM0xzThx72TzLFG6gaIsKAVNy
	lcknAszxbMqtIehRmb59fE7yo+++sdm4CjgdRFUeOlWO708PMt1NikGV
X-Gm-Gg: AYBFou1Yvj1OaB9fJX6eBhqLh/se2+Jsgz4Tqt6cGvul/flrdNvabwiIcoPUx7X4rar
	Zi9G62GleVM3paDFCag97EI98rtccvyGLyeaY68YH4w6rYZ0KSRdxIIl09f0fBd6hjLHYmiasY2
	z8TaPdxVexg6TQY5SwF6A7ND/u3ykkT+FVpqdLm6bk5rmo8fvx7cKzOyHSFeUS6D4f36oVnUuDx
	QdqjcsFnYQ1Evyx+cikp1h7QJioxoeEKtT9bbBiIobUgqw522GEHwE7eBShM5o0Pd5FnOaLXj15
	o6BuojmIYx6GHieWIWIT6LHhDDR4IumBU6/IzLcmDbzMjk20AO9X9Vk7rC1Vk/zxdr1+L5UgTaq
	wqUBDw+khUp8n9jP01P7UYzi9mwIIWxSbnwkAwp4+LVx/Z7TAA5F8ycWbi0AAvUaP6s6p3lW+aQ
	FytjmoXpoEk45Fj5Hbhf2hxDBViArKsh9FJI4tWH2jF+Lh4pmS6coJB63+iFqHVHu0/f1eSImWD
	W+0tpjrXvXq5AODE9LHnaT7hUumz/P0mc6ub5pWNPdpNbuXw/QJhS1egUWC42IcQbsqP0xRM16X
	RKPbHHcAafuA/nzNn1Ue5/vcCktNyYVpCDZyen9bXg==
X-Received: by 2002:a05:7022:404:b0:14f:b5ac:ace4 with SMTP id a92af1059eb24-1a6d00d22femr1741148c88.44.1793156713549;
        Tue, 27 Oct 2026 20:05:13 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:12 -0700 (PDT)
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
Subject: [PATCH v2 2/8] crypto: acomp - Add bit to indicate segmentation support.
Date: Tue, 27 Oct 2026 20:04:57 -0700
Message-Id: <20261028030503.17923-3-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D1613180004
X-Stat-Signature: kn4c1n87cop3ksx9xzhtq9rah1r4numy
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793156714-387179
X-HE-Meta: U2FsdGVkX1+0IQXKisTTBgTBE2xbymHMXbh7JCc99yGVAVWmankrlyR3jSXnSaVNLD8H7uGOsRSAcBBhcjhfyWNil0desn/3jzcZtVkwUW4RcBjKu/rOxKwgzpaEsZ/ltAwGT4Djybr7rZpd3ysWO5Sk5N7GcP6ZkXhJ0qPhMJt9ESjAOo/JJ/0ExzGLbWTUaXiI65JoEdf3lTvcvA+aSEAOJTBrKROjcGQNPe2LWzSXF4It8+awQknxOEtbvxQalKPGRDYUft4/UH528qUD2KSvYWNcVFEA8WNVaC1YCGbk0rCn7ynRQP05pqgtMfHSAB+QSJSOzfxJnhei+NOoTOqZc9cu8aWhqtGeKIhfyYfYW3lihlLsxha44VMqZRcEtnxhczGAUVrRZOGa70cSLSJBnDj0Ayx8S7konQu/HEHtw02GfFpZHw667Xt3RrSwH73GtJvoGnrROeNxRABAZ1/TSFf9BWTZEqGRmY1S25LQaHWiVI7Qv6vH8b+t//LD4Z4wwvIa3AU4mEn/Sdsp2jC7h1tFZ6KMkuJyI8dsEA02gG9IcmC1zYFvo6m5Lls9UUWAft1ezCBmzkjikrIxqxvJwJT/eePrhIPVPAbXW0aoGC5wtu2FKmd67U9RucuI3638rg0MN0IOpePAH1BFizBK5dZylHvrhR7bj/skzFQ/mzS1eZ0gzgOHjtr7jRdJ4foa0CCvtO+fOjA/44DdHt4F4q8EhB+CnxTew+jkfnNl+i63M4/nLqb1qfUlhsZ+0yIaTgSUDJiId0XPzUHEldr++CNW5oTJTxALeBNY/QEPRdei4o2IN4FJOtSUeWU7yFwhJwpqGom3ZnA51C9i6/evFAXcsFTRKKrXJbAZxEsOZY+HZCNNWpesLQ4t5FyWXeE8AViWV1ETip9HTUEc6wVHo9/QaU4rcgIGy38dDtZLuxAEiHonqb8kbt//z6Sca50G15Bom8aIreph0af
 ZeUVgaHA
 OU87saFP/JDe3wKL1E467JDhP64g0gPrAzqzfSAe/6/kd3yf/AngwBiKpi1joYKvGOK32losN6Xwz5WCFlqF2p4b+ly3CvleyPfzy8zCpFxihvIx0+kLy5nIgg8b440j4QpGSGQq5Yhr9yeHOBCHWXM61WhDA0T+YHDd3gK0he92a83Nf6SAvlkVUDbdBqPABvQkpsvC/1cAu/wwMQarEBqoo82JjJcLdX1YT1OnqEQwELBW6ghPpS7SkJnGne3JqJx/S1RLvpShF/sKVXZp6lE/1xlHKOkq9zabFNlmLHMTpXXuE3b0LFEZAynIaCOWz6y04IqoyTS0rqeaU4fDDOnGcuRc5RnwPFLDgcneUw5j7Cp1N9OJWr6h0DwiqobUlY4zeU7qbqMosnCzrdTVZ1K7ejmcZ4j3o7XnOkaNUzv3J4EsBK3h+dOqOnOT1riHLwOi/zwNen7U8povBDnsOVH4fVtUjwlBmEBoqIGphsP895Ko=
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


