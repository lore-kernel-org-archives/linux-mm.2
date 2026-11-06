Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A248F606A331
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uB7tEP2q
Received: by kanga.kvack.org (Postfix)
	id 1D1E16B05B7; Fri,  6 Nov 2026 02:24:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182336B05B8; Fri,  6 Nov 2026 02:24:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0421F6B05BA; Fri,  6 Nov 2026 02:24:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9B786B05B7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:24:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F948120CA8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:24:28 +0000 (UTC)
X-FDA: 85403856216.23.2B98E39
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id 88C8C20006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:24:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uB7tEP2q;
	spf=pass (imf31.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793949866;
	b=n5IHaAcKodAxTEb5I0dA0pSGSHca3sjL5JR5U5Lrd3YhUL0Km3L5IpT5SqQP5YNvQ6ovmL
	xmFB7SGvdyiqX57tR0ndQpjk4YS2k8x6g8KTltax66OKWSohPJW9euDSeGaA4lgX2H3/G/
	sPl0oMn/8+GEl0IamKonzMk/32ntays=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uB7tEP2q;
	spf=pass (imf31.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnkDMtwt0yq1d4PAeYVaT2YC+Oe3WZGJ26Fjv0oSbVo=;
	b=491OHa7zSFaB0vslawnbsT1BoX55oN4E6y1QLWGeXFyv0m3lmCIjJsRJyKLSEvKnU2aeEi
	o1dGWg6LhJyph1MyI9ObVHq8xPsw7Kpl/Iuzci6LTRlzsAlMoUYUfUIUesGrSuBX/nNa89
	B5BekhaqIoto8bjIOaM1w/s73L6DZ/Y=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-14394530ec6so544302c88.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 23:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949865; x=1794554665; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hnkDMtwt0yq1d4PAeYVaT2YC+Oe3WZGJ26Fjv0oSbVo=;
        b=uB7tEP2qkcznj0UuviuI56gv7yFH5bpmLGIzYi0zA/RiqKTyiyDAQ6WHlctcxufXjF
         lhsvVudxkhTUw3Uzv4liQ+3YY911MC6w75KutrVGgQfOO9/hfV4MJaei5A3yfUuvfeI9
         q9JqbNDBgCiE5WzEfbDEDKQSLteDt7n/RMFnUG0WGlyTR6UpHSFoOMj4RE/jPNL8CStY
         DgAcdAUwMntY2vpUaSqN6nwX55EF2L2ilS6Do0yi7/xGEKgGkyisZyUHa+4WPCUjqVkU
         fGP+Z1Gloa27Ztikz2kfSt3KwpOJYidULsHQqmow3ooura9Wpy2lJs9CdmGrtdywxCkU
         4Xjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949865; x=1794554665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hnkDMtwt0yq1d4PAeYVaT2YC+Oe3WZGJ26Fjv0oSbVo=;
        b=oEh0hNqdyUqDDhzCO++g08yY+2jJZ7vPvWPIxKQvDRGCfzptWrG6cKMePt6DY8BxEM
         qfdJBwAzU3oUXZxGXoLOpQWbWZ8+fboAmtTEVtSX4fUSccQTe8bHG3ZcM0duri0vcDbD
         qkQKA73mElDkjwT0xupDRUlgtj/xYVCyYWn0n+r0mkgFEKXzi2xKMUKuKZWhTTGzOfh7
         G7WU4O/Tw1P1RWxxGENsjlhMKlZMR4IGmna2jdhbvGfv03zNMST/W0p+5LuGaJY946Wv
         s6m+lq3jsTxNoH+R+vikGTTPW/N/3X2hBG4VnQlscseaIBFYusXHYON3syfu3dHHUFEY
         /f2w==
X-Forwarded-Encrypted: i=1; AKwUvByz3Rb/seEPYBn8cU1/o2WpkgTYM06MOBegZ6abjL65z2NJfCfQx0W7x+LenAq3YqmXr4yLhN6cbw==@kvack.org
X-Gm-Message-State: APuU4Z8WiI4eTRTR8Phez70QAbsNOyY2KWYrciCuqNmVG4tz+mI7fBls
	tFu9hYH6Jnkllp3kRgsk0R+tGtUPdRJmSfvDBn+1raAM86J0EOmTdcqu
X-Gm-Gg: AYBFou0GalN9sZuj3E508TlAuCVwT6qhT6/dK78ImEclKcw4LGdMtuVSKDHptexNqtS
	5QvjgpGUfXHAD8IeGSAgHgo6Oe3MxAFxZKWboEjeCF/wBaARD5TFC62hQrjF8NgDHMfh+TVs+ST
	tcUhXSIQ7g7zVE1uSgS+/RghVrVESgpjs2vFmnoB/OxD5u8mlOFKWuJv/9ptxldqYuXTeXBoS3s
	GZyIhBJKP0HJyKtJcJ8gumcsvUvDfl7v59Ot7LzKTnYJu0sa1f6wNPk1gSgACc9QjvWz4bM3GZs
	ejAkM8M2XQxDOX/4SbyMcDEZJcAwayYhFWRALiXBYKTTCQzffa+AmQPOnzJatbJs9l0qzhRFQR4
	vm2hHgDLs2vrd/zvQ3ZiElkPc2DdgH0oA8w7JVhdING/TwMKKbrELGlP8faRjmtwL2+zJsrXIN2
	sx0wPwwTGcIdJivzr4yJnvIIo4AGIpuQDEB1YiYLYQ3BOP5s/SAvKCfYtaolR4qwPSh1+d1cfo8
	o4gb5C7m25YpHloiuLYop5YYiQ18NZDBUM5dRszBxibzdojQI9FMBKAHnNbzJFMSBSMslKxp4bf
	Q/fXutDe7UzyBic/XqzfzJ2uDx/wPM8JeH2lcKCFzA==
X-Received: by 2002:a05:701b:270d:b0:183:7d42:cfb5 with SMTP id a92af1059eb24-1b25d30e08emr2068315c88.19.1793949863734;
        Thu, 05 Nov 2026 23:24:23 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4840f3sm6262220c88.5.2026.11.05.23.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:24:23 -0800 (PST)
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
Subject: [PATCH v3 4/8] crypto: acomp - Add API to get a compression algorithm's batch-size.
Date: Thu,  5 Nov 2026 23:24:08 -0800
Message-Id: <20261106072412.7909-5-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w5cz9cjjzza1w43on8xestb543dmd8oe
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 88C8C20006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793949866-647761
X-HE-Meta: U2FsdGVkX1/HPNHK4tLPP8J6WMzA/GELdvSOqvNGlHb5NpQxh5Vf81xkgdir+2+t6M6juWYr0nKctSP2NVu0bt7TCSXXMe3A7ZFS4WWMAoIc72mJoHv0aY1xF3yBNhEWP3gOU0wr9jCCDAoH8q3b0wCr6ICNYrbr/zvG5fv4RwhKZrJSoOlZ8obsH5UHlGM4jogH49QkOyTFbrGnv4zEIN2YNdmIcCu3w9IHhhX+H+thCjsNgPsM9XHBuxvSG9c/6SrnncDTYdz93i29m4hMkLF9lLz/tIptSgzaQO753bQkiMQhu1ZaX1z3lhR/ov/+4B9FblZMnjBhN9kwGPVUySzvbfSUVqiYKvoo9GWIY9pLGJu3Y/y54I08KyRGOGj1OGFShg+mYBsX0rmMJoq2+gLvqkddVOOIqmFZOXxXCEOH6M5Sr0sjeDGiynYpVa/ZfSEYR44l7E7q76CHQMMmoBtJWfVoEZqoTbcKkoBJg2mqAVQPeraX+v28ekYkYDGE2cHh3CsdqkajfzksX2HehIFq4ssKf2fnzuYqfxtsS+eeEr2J6Gm7GgVauNnY+VV0VJtmoCeGeSg9f8HAt5mEglV1jTFzXOoVrxn50cpSAuLZm92fcdMsVbonViXiMSm0JogYJ6fweMTmoWONV5qztyfX9b7Xgjdo03D4IaMPloOTsa0zXXSEY1hMzTi36f9234bcPbJoC63qf99iBevXDUXEcd9GXmpCvpMCEqQUOyYii3A9XaJLeTpDR7LsApf2hPlZv4TBkLiUKHGRLIlFI1voftO9EIsDD5fTlwgeSpCcj0GpPDbQZcjVPPOfll7E5fQREYu6tmOgBfxwnm7GRNnjS0MEf0f/JHb4ZbP8YrtSQn1D3wNPfo9g9/9tkdDUD2kcl5K3VV3UFqD4mkDYw5ha4PRhDi+4XztNnflB70mX0O3jkyBah62xKq+35lsfZlWWoW8AXD1pw5XuFsa
 wOAXYq0m
 R5xFgzqYp2vEgtCpXGBu4+uvnUlHJ8/iHr+kuPCN4qL03bN2WX1Ef0kYqUWWzPWWFpK6ripsTSxmJ5I11VdZ07W3XHJ4hDrz6ClTy34ULMdAbwT7MX6iegtCLtIlJJC8nQ6MwMQppG6CVcRAquYw57ozT0Lf8hJUbum1XScLRpD706VvHUCkWihenM9Rm3HswApnFNDT6vK9PpXgOL0x1i9PjvH0e+HuPTe+d5D3ObrbOO/gyvoLYJhENmlMrkzKGnGqIU8koMb47je3fioQp9hXFzg3/3t+T9L54wwuYjKp9pBaUoEwMmgVe8pxKToEVEpr17+PV4qk+RlObZZn/y5sAFboY1EhWP8UX/S25LPGcTjVjxDwfV+4cYUAPjCeYqGPCn2oDLEQSIyQ+XNVKLG4ggYWbQMzBOYf4fxD2LxFUMibW9OFkgc+HRQ==
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
index ac4dc52668b8..df9e42f519c3 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -327,6 +327,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
 
+unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
+{
+	if (acomp_is_async(tfm) &&
+	    (crypto_comp_alg_common(tfm)->base.cra_type == &crypto_acomp_type)) {
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
index 93fa02ce818b..3ce4704dc879 100644
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


