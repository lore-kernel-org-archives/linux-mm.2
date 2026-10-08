Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12D75CA600D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 18:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345F36B0096; Thu,  8 Oct 2026 14:28:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7B56B0098; Thu,  8 Oct 2026 14:28:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4156B0099; Thu,  8 Oct 2026 14:28:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E232E6B0096
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 14:28:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A8B4160469
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:37 +0000 (UTC)
X-FDA: 85300294674.08.1082652
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8828340007
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RxhoDUVF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791484115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4EAC3tfhBdLfYAd9CNDrPAiNc4+pBWw6wHTFnfZXC+o=;
	b=k04Ks6cvhLCjn6VGCXkBeuJwAskQ/CC6zlXO9awEddwEyL+78Y0YC9WzDwrp4kBIHB5RUU
	Vdqpa8C0qe3EdOm70yVQMSPoDFChfINlSo2RYCnXhvSTU0EA3JPJw1bFY6eH8DngU0FuXc
	+7ApogdYPRB7QR7Cki/0ZyGyl/A0v3U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RxhoDUVF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791484115;
	b=HmtmFkPtfdRJY7y3qDN67xBKiXtZ5esAgKkRc36V7JtZOLB9mhBlEHJ9u+Fp8Kl5lnbD5h
	1IAS/7KfpGi9SoNTc+Xtos9xBTu3zwG3JtS0VwWJDRQqHa7uJQ+8r1DhZzXxI9wW3+Mu+n
	KdizxMDwlPoUN+dCTOdNWkU8SoIBgo4=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-15dd124bbe7so4562430c88.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 11:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484114; x=1792088914; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4EAC3tfhBdLfYAd9CNDrPAiNc4+pBWw6wHTFnfZXC+o=;
        b=RxhoDUVF3kT5hXWUeUJ6vct5tHkmtXHtijbqxoe3ip5XJxWLdUdvSu5mVfeo+Z83Uo
         YrWUIketRz6CRe706AIdVfy7BAgKG4sCSGgIPk71PqXwtVGQjg2RWEuAlMQFTxBQL2ym
         7gcgIdGSjMq+zmYqseZJxFi9g2cj1ITmo6N0sK+/wL6sR38SW4gnhr4Jt802qe5DD0wd
         JsWctpqzUacQauS7vdxjouCNnBWWKfEX9bd6nB4eFbybHD9KY3G6F73JKp7V6g5C0sT1
         czgjXvxohnZnCf2lunDFGi20Aqxtme1uK6TWwKBHY7ejmNrA4/Mnv1rzJmpDyZxU5yh+
         Tufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484114; x=1792088914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4EAC3tfhBdLfYAd9CNDrPAiNc4+pBWw6wHTFnfZXC+o=;
        b=fF26OY1WPoGQQUJCYfxpm4yJHrEdK6NAg4XKOQkmQKMjKGuOrkdPdyQq02HSTHJ3gx
         ySK0WQ3y52RYVBrvqT9jEO8JWyt0OT+1SlkZHOkvqKS2+Y0a6D3/sbtcl2i2vN+prbfV
         UmrAv73eYYS1gb/TYS0nPLlG3HQ0UZwP4m/p1j7KFTKmRkeMdaNfq1XfXJ9OI1s7ahbO
         V1YqXQtakKXCIwgFgIewzvi/Bb0az7NaGwJM+9f4h8DX8CQZnkw4PcnmFN1FuMHrQe3P
         RobFQdI/S2+OoeWJmg5CX5xsBvc86njR3fakWNFgZh+3Xk+sT86mRGgtOcP6vcNddkWq
         I02w==
X-Forwarded-Encrypted: i=1; AKwUvBwZXIXbOVotzETiifV52w15mAMhvZGTHS7yH66s7dB+/hIiSpr/0xvm4CD23H+n5wIUx0yJuz4nog==@kvack.org
X-Gm-Message-State: AFuF++lSgePym4Y4flGjlLKCbeBZWOMlXUKjCA93Q1tuMk47oFPifK6h
	1KBireO4VDhaPQB9RuW+7fD7FO9Uijn/oQzVUbY+QetQlE7zDgifoNA+
X-Gm-Gg: AYBFou0vM7Qva5A2ea8SB/moD9cs2qdpMdWDXQJkv5lWa8okGo+dgIleG+MYiFhsXFs
	UOWbPU952aw2KTjY79GxRrYfiTjjm5+KR5ZQwx3VyxIQuwSf7grOOEgckOkldRCxb+ZbIZiC+XJ
	LS+CQPaxx7LiAnWCM7d+nEeCfLFVFWHDUWfBU/+mJmAYLeDcAJTI5NR9lp+U/MZSQu0LO/MsxfO
	7/lvBR8jZeRKqt+YHt/ZAMKRzgxMJQ/dr2ziJN2RtJrkUOlnSUZudF3FDNj/4B6pHbHcgLPmP/M
	EpKdWTUB9QX8avJB6VBctCFXJo72nc1uqPrR36puUdsEmSHGc8AlnMCbY/4kgaU9h7Vr+8Y2+NB
	fQ2SGUfdG4HpuSnlvWrx/l4fT2gP2NPgWV5vcb/PswFj5kqf7dG3rArMnKLf4SaUt1PqnJzc/i1
	KnOHF5p0MJWlumf2mkObqIjU94xL6r22QFrF+/Oi/SOP/48mrW3qqQFLEnsXXkufvHn6JN1WPgN
	KpY4oLpj0c=
X-Received: by 2002:a05:7022:296:10b0:168:3243:c90c with SMTP id a92af1059eb24-1683243cd45mr1540837c88.15.1791484113969;
        Thu, 08 Oct 2026 11:28:33 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:33 -0700 (PDT)
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
Subject: [PATCH v1 4/8] crypto: acomp - Add API to get a compression algorithm's batch-size.
Date: Thu,  8 Oct 2026 11:28:10 -0700
Message-Id: <20261008182814.27450-5-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jq5rf151xtpp3wgqjwooyipahqrsf7qm
X-Rspam-User: 
X-Rspamd-Queue-Id: 8828340007
X-Rspamd-Server: rspam08
X-HE-Tag: 1791484115-230133
X-HE-Meta: U2FsdGVkX1/HP0syzG3T24WS+8XMdccI8wgGKRq0yH8Km+vWN6nNT4xwfthzWTTpVI3ZaxWqMiSta3p4XzurZ9F2dP9Mw1zXya+uvezBSWMTnZJtrQH7kmydxIhNGxNN3Lkr0JacF8KlVAYU66YycmEciDbVBBH0RaFCq2jV7bhTP9a2uOYxtJ3wraex6j9ZmN+CYLDB43aBUaHprNX3EX8rBNIhgESaXtivvwGrRtaCBknTo2NbNymWKOR4M9SCGqHsEh1dKIcXJ2jRdg8lGT3HaJXMo9K3jRdwuRgm9CNv4fz3BLUdE7wxOpA9VYZvh3eBIe2MuG9Kx++WZ9P6R1C7A+fexaG217fKrhYCJquIemfnV/dePzvSs7S/dq/LozL+oFvMviqjCwUxT+TQaQV8V+AjBPOVKUALERWsvLPqpB6rJArfNgaBJ3ylA29e3SWqRyurvI+Mm64HqP6ZETDLAgWc85kJ8t7SaG1GYRcjwgCkjH/t5vW/KL1nUVOavY1EOLQ15Yg0ASrM7++maR+Qkks+c3/WjMJGA8MPMiMMMUCZqcfuvZBhOuPnYQrtPA4ITEYrD+19XdUmlaR1L1vG5rzTmmIssumtkfzk2YvtfucTcJ+KQ9yANLrvk+O5rnpzDVhFviTXT1X0P9JHUEkcYlMOnHlU25k7lYyT5e2idOvALxgL8m2IXyWaPcbKA33aacxDKWJlqsyb/iwQPcnDptdrgCkSup7+RkeYH4qV6TTPVa416Do8ZHETwcCJBV1wnEIa5W3t8R3V4xi5AXgLlBd0vfWq5+cRg7yua9CN+DqmZsQmD2AaQNhjv040Yx+2I3HhxIEEkZD7wafToKDQ3iuzmLbLI6SD83CT2wVrAH7ha9ST24ohS5X3wrqGSb3Qo9jTgqU68i3abHFzty0IlsU8jD2G0v1itMYKXoqui5Fx94Q5EbZ4xU7FogXSqAn0TvHbcggagujS+EA
 KCOZ1tpq
 U66s94c6O5sV1+osWnvsPhWL/qR4GaWvj303fGL15cpbkjOyvKtlSvyHiwYFVxWdRVxQu7MxGFLmhFuHWLQks3sHORxSL4M4VNPfFCDsOS5Kz2VLvYNX6EjOyGxBm0uS2Mo9QvLzse5qGoeXC+KhuP09pACW7jOyTrd2GCd/tfGGMl8ecsfaKZj1lvl92YRxZJQ1JJ/vIGULHCSoCXaLyMGlVeUh95ZDfYO6Okw9qV8PQlbaR3NYkdFMJ7njnVjXTVt168w9AZnL4fllSej3Xjz/0HGntFzJGGVG8BVesYvDrupaLsiA6SGUqhxQ6q2q/Q6m5VlOvY8zkrFoZwhGdXd5M/bR3SPkt6FEDnJgPztAM4sLKokECdJ2pyclCieZ4gbhxAuHp9paRKB/bGjt15h8F5lmE/sHVeabKFFSms7ALLnFtpaiugK/qmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 8c9a76073159..192ea996e779 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -318,6 +318,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
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
index fc0665b77a8f..06578c4367f6 100644
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
index 93ae59623f13..b790722c263a 100644
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


