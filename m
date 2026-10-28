Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC3CC606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 03:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KlgODwLC
Received: by kanga.kvack.org (Postfix)
	id 95D7A6B0965; Tue, 27 Oct 2026 23:05:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90E916B0967; Tue, 27 Oct 2026 23:05:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5D56B0968; Tue, 27 Oct 2026 23:05:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2B26B0965
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:05:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B72A240BE8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:19 +0000 (UTC)
X-FDA: 85370543958.16.A5D330A
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id E6E40100003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KlgODwLC;
	spf=pass (imf14.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793156717;
	b=VZ6/F3hr2YxUrniItJHCzHTB5SX3f78TNOdn9d1twwrM8dTMTs3+m27AT6bQ6C4VcfxkI3
	i58jGG5BPPIjSuS4+/oNsrmtTOeAU4OzitcWGxEGhll0ZtyyMaQUOKuWNIEDcnZnmsCBeY
	OC4pxjUzx4uG13TI5v4b9DQvmsta6xM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KlgODwLC;
	spf=pass (imf14.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793156717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6azg2ZIUW0JXRWtBfLZZ7HNRUXzOL/ZgPLL5NXPpASo=;
	b=F6mBbPUkgSjJL0WWGfTp+hOsfiZuvHoq2A085VN84dVgzamdko6k2IH7OFnsvW5zknN827
	cw6ckxM6XSSfqcaZgIQuMI8Yh3NofrxNhZUUpS2/6bwYNWZtj/P7s5NpBvO+OQ/QH9BIRo
	VN6EMoqOSzgMuJWMFur7wWLtVo6gomA=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-14394530ec6so584478c88.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156717; x=1793761517; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6azg2ZIUW0JXRWtBfLZZ7HNRUXzOL/ZgPLL5NXPpASo=;
        b=KlgODwLCYXEIHW2kAqpkXONzgF5udq6kEgtiDKgKgGabbCYMTzAcDWAlAUh07bfxHG
         eCiMV6saGw6RhvSuZ3tgN6e7WzCNXGUfiledFDT8r3x1+H3qenzhYKAuD2uWQWYUQ+xw
         IxjmrDcWIciMqODPvLKRFPGvTlN9wj/I5hQ2csciU/lCT2c5yvo0piDVuNSY18WPPjSS
         1JZ9wPZXhF2YwT1woknV4OxXjNywt1cM2rGG4Jdb8ize80wVyp1lHDjIdwxV/ITVLjtq
         xq0Z/6LxN5ubu9I0GDXF85ieNAGdYPvdQlsjRYKAzGaLdsIuT5LIdo83N3YlOwz2QAGG
         y1tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156717; x=1793761517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6azg2ZIUW0JXRWtBfLZZ7HNRUXzOL/ZgPLL5NXPpASo=;
        b=DD9piBMB360Jcr7Mjk22V0+6RVGSoipUCX0E8WuuDgGMlSZ7/vskCLvbcL3VvYVeJX
         lkAccoum4Kr5qAx5lXsXw9Q08UdDei3tCp2dt9edVAkKUnzmwySek3GWF0qHbIplgfmF
         +6cBQ3bINtk4+RCKCBxmZYWtvoH+c2QJa2C5EsuhEVsUPYCb3hF7mKLdqw5ZxOzcqSSN
         g/54VKItmRJjvnld5Q2gNZSP/RxdH2SLi14Tyh6LmdoeWfaqLR+ZKnACJxIs3jYEGhVV
         MOUTJcSrJmngYJXJ1iaCPA+KEBlnVQFuUaIQUuxvr60OK2Pn/X3Tinql77Rb+seUJJzZ
         nC7Q==
X-Forwarded-Encrypted: i=1; AKwUvBxodBG0/FZCSyy++F+6WZatmaFcAey9eeG5kJ21PqtBoPdz3Wlc00++nxH5WfLfwwcFehHYslFYIg==@kvack.org
X-Gm-Message-State: AFq9FYLggzqKLBTRwCzmmdp8frJCBVPS9ilsh3WFLeUFf2Q0vd4HACWN
	Eh2FAnPginAMIhgKzRhaXTtUxqgnoAYyDUDliNYA5KgWwzmUxQcR4pGv
X-Gm-Gg: AYBFou1ndxw++cmvy9SEFlS1G0Sw0PIBGSsZgxdDbsQ38biMq0D8uiJZgYALbV/L9nw
	lE7hvy1aLNgqSFvsg0yl/DRRwg5vOPYFMZxk32r9w7QE+PKHm9IDKuSi6q1/QIZWnCEsHySldjc
	5fw7dtLSG6YID14pTcJST20i6TKnkWqZwv1CvaPQNabSv8WoM+YkjM/xZzWakYVHxMBsc5rWma1
	4TLm78/w3dmnsSK/dupE6PemtvmR9EmKX7AH6PsXXGyRNQvOJczf8Zb3x+1QhMnCLQ0tFtus/Am
	EtCxrmppfNaB3MJzanceAOpKePdorAFVivVPWnOQTzJs0l3B+ou1GYkfvy9CJjjPmeGOJSgNHWY
	2HSAJJe0/PXF+l34iGRaXqiRVT0lIQWYOkrn0Fr6gMsK6b+mdUqaACBli0Sfpy1+BulDKfN9a7M
	K0zK0C3rHUu8yQf/v4v9G4xRk6ulkolv4J66g4JYYWQ2IFZuX1bxz5FFdtLoEeYlYwsHK51NlA7
	euGOL/HZpZPHIcwjR6pvIgUu24PDB8meOHTuHYC8j3b29HFhSNgyl2cyBqqqt0Oqix2eytwWS93
	G2nASA0A1t28PWrmMvJlXKungu20pRvVPTV0hBUuqg==
X-Received: by 2002:a05:7022:6989:b0:183:7d42:cfb5 with SMTP id a92af1059eb24-1a6cfa0c476mr1988744c88.19.1793156716397;
        Tue, 27 Oct 2026 20:05:16 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:15 -0700 (PDT)
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
Subject: [PATCH v2 4/8] crypto: acomp - Add API to get a compression algorithm's batch-size.
Date: Tue, 27 Oct 2026 20:04:59 -0700
Message-Id: <20261028030503.17923-5-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zw4ey4o1inw1kya8nsnogew3newyszao
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E6E40100003
X-Rspam-User: 
X-HE-Tag: 1793156717-238826
X-HE-Meta: U2FsdGVkX1+Jdj1ACWWeOic476FH9T+N1y7j0R+Vb3nertX+pNRn8vc3ET9VLCsrRlWfY3cG86+Odl3IdYRsHeVkTsVa8JVM5i5LtdvuwhVpptusO5ZhoSRR2mToYCaUQfwAra6JSVZtosTKmVsDdZ+JztCMOWDKzUqR+AzB8EcKe7tptc9on+Zzt5cvDsojYnEY9o5D3AV7SyMZcZze8fGMYE0Yb2rZ35JYshaBn68RHnOfAWcpU1vjYOAV5zm7YwOaeYAidRRAEnw2O30jUjiCv6BimHwwUZMYBPT0XP+2veGguc34diV2uVxdR/b9CDMSQJKbyv0DbSBbSL0Rv3VD9IzKMbTtBB6DWEZkHow0j5lEMtYmVokxgEJdpsqM8QGKAfkBY0p5u8bpi1mMVvXYXhqpmnsFUPP2B+w2Us6zMNwmZIHGVvh+h/2wyRZN97B7odTXOr5vu5vqDLKB4sF6QGG7v/TNF1xqbC1gg4WiTqomVIPAf4TsM+7Pk2a5wFD7nwNN2aegut+LAL5QxflaXq0OsNJC+ENdKBRNs/6GMJwYPXkBrVVJqlXh8by5amSTnKkpj3K5EOT6K7WAby+LN0Zc/nsHq4fJ1R2FzNJaPGla1en3WT6ekaoKgNpk0DGiX4jZBMOB7oPfkjcLf+5nlRDOySTAb/RYlGJ5Z11CaW45ygFoUH7m+uXDzzNQncx9PdHWdgr0eVyLKKaDAXraGWRDiGGV9nbF/Fj72tDxONGM+N/d7/ab+fVveeVF8CdhXj3lv/jIGv+e4Xta0jDKu1j4VT7Wg6t5Wn1qsU8REDPZ+11ze3QzEVOsS/sF8Vvq5pxivjhTZp6eSfdn4NQVpZFoX9UIZEAqSVvWB1idvPm/NtraH83VdSvMOtyrfFQY54k+3QzZ0gKJFBtTLNGgl/1y25TIGnJheV6XkPVHSVTdqGgZkp/+15TomKTlOGA0OxiABlS0nY1oLG3
 ynynVb+a
 S9Ve4y3ubCH0bN3llTJBsq6IbiguD33REOqLj4roQM7G1SMWdEV8khXfitkTJhtl2Y+uyEK/RzsiYrfNjVCsLdXXfuP5sn4Lh6ia0jFuaEvqyLnqlTwCRnvO0aFwu2RZLEp5sTLU42/cGU2597jbXcvML8S+fmZhyocUFHPEkWkcAS2sNtnbkVmNR7/uAVpK+lARNuoTDal7t7lcE4T5pOC3MNgjy+kTbxD+2tQxuEcqWw9nYSI0JVYukGdWT/LQMqzKuRFQcSnJsEUs+LWbHtt4Ss37CVfsBTaGgizGwIOBB+DU91dD2wp9LJ4HHs/h3545sKCgq8S/vxZRdGHRxwLfQSoIGYWb6l5PtRFiPh1erZ/9yk74e8xSkIiJaGg4r2OcT5RfydI1+qo14GY3X7eSZJAeYi7qg5V3zBEMO0Ey/1EFDlO1R//9f0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This commit adds a @batch_size data member to struct acomp_alg.

An acomp_alg compression algorithm that supports batching of
compressions and decompressions must provide a @batch_size greater
than 1, representing the maximum batch-size that the compressor
supports, so that kernel users of crypto_acomp, such as zswap, can
allocate resources for submitting multiple compress/decompress jobs that
can be batched, and invoke batching of [de]compressions.

The new crypto_acomp_batch_size() API queries the crypto_acomp's
acomp_alg for the batch-size. If the acomp_alg has registered a
@batch_size greater than 1, this is returned. If not, a default of "1"
is returned.

zswap can invoke crypto_acomp_batch_size() to query the maximum number
of requests that can be batch [de]compressed. Based on this, zswap
can use the minimum of any zswap-specific upper limits for batch-size
and the compressor's max @batch_size, to allocate batching resources.

This enables zswap to compress/decompress multiple pages as a batch
to improve swapout/swapin performance and memory savings.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 crypto/acompress.c                  | 14 ++++++++++++++
 include/crypto/acompress.h          | 12 ++++++++++++
 include/crypto/internal/acompress.h |  3 +++
 3 files changed, 29 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index c55b0e8eff3d..8e285cb7477e 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -326,6 +326,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
 
+unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
+{
+	if (acomp_is_async(tfm) &&
+		(crypto_comp_alg_common(tfm)->base.cra_flags & CRYPTO_ALG_TYPE_ACOMPRESS)) {
+		struct acomp_alg *alg = crypto_acomp_alg(tfm);
+
+		if (alg && alg->batch_size > 1)
+			return alg->batch_size;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(crypto_acomp_batch_size);
+
 void comp_prepare_alg(struct comp_alg_common *alg)
 {
 	struct crypto_alg *base = &alg->base;
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index e64cf422510b..a71532ccb8dc 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -593,6 +593,18 @@ int crypto_acomp_compress(struct acomp_req *req);
  */
 int crypto_acomp_decompress(struct acomp_req *req);
 
+/**
+ * crypto_acomp_batch_size() -- Get the algorithm's batch size
+ *
+ * Function returns the algorithm's batch size for batching operations
+ *
+ * @tfm:	ACOMPRESS tfm handle allocated with crypto_alloc_acomp()
+ *
+ * Return:	@tfm's acomp_alg's @batch_size, if it has defined a
+ *		@batch_size greater than 1; else return 1.
+ */
+unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm);
+
 static inline struct acomp_req *acomp_request_on_stack_init(
 	char *buf, struct crypto_acomp *tfm)
 {
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 0c0d3fc8a9fc..2d4d302d1b3f 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -28,6 +28,8 @@
  *
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @batch_size:	Maximum batch-size for batching compress/decompress
+ *		operations.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
  *		transformation object. This function is called only once at
@@ -47,6 +49,7 @@
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int batch_size;
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
 
-- 
2.39.5


