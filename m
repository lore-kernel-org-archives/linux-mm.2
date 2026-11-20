Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E37606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yEYUfy01
Received: by kanga.kvack.org (Postfix)
	id A13DE6B06F2; Thu, 19 Nov 2026 23:19:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4AD6B0750; Thu, 19 Nov 2026 23:19:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E336B0751; Thu, 19 Nov 2026 23:19:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 48FB76B06F2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:19:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5BACC0CFA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:19:25 +0000 (UTC)
X-FDA: 85454193090.09.AA64D0C
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 06E8420007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:19:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yEYUfy01;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795148364;
	b=iP2hBlwSnsX+pqHVCVAlfH+7xgE9jsvdIG8bDtvrdU3q4z3r3kyBSrIc0yslpClXqpQECY
	1ktkya80Ac9R9NChLJymGyaTn7f2vu5fCjdYaKFYqTvsLiDfH2yIuMaZkXbo+6z+9Bw8as
	/FUBLG9Fy5uKF4q3CZyT3XnOyNWoKHQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795148364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnkDMtwt0yq1d4PAeYVaT2YC+Oe3WZGJ26Fjv0oSbVo=;
	b=am8QCWeZTwrBAX63cSJcslH5YOMXvHuihUh+SOfpXY4r9uMBDYk4k9vOynfy3LgG/fHXfx
	0cgVD9A49LgqDwCqD4Ic3dilDpZVzGTgJX4AIT4BLlh7vvPDKVisPyKAGHdiTUkEfDhCxT
	jmdZTtXwZM1nSdfuS8LKrDcdrO8kmXU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yEYUfy01;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1a8cc11ac42so677018c88.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148363; x=1795753163; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hnkDMtwt0yq1d4PAeYVaT2YC+Oe3WZGJ26Fjv0oSbVo=;
        b=yEYUfy01jV5l1ro5mHquND1BCy6PSIbJe+Ee9GrwNSDWsHp+wjvtmlXVWouHWrPbBe
         6UmMFA0q/2Iy8GAAPFVPXhqfjRJHocrreDTe9WKll3ds2Fr+bLoJaMgwF0VetpdtQQRV
         vURbpLlOZoQyP36weKUCk1b+3dXSKRe8wbuzQnZtKF41PuQ2P7mIXoeaUluDFitZ5axF
         aahyKYw1Hwy5AVL3sSJ3ZsAqlheW+l6BVj8f8Hjhd7B3lUsNcdshldLkl4KfGJP25UIq
         D1qLYeD778V0K8PeddTIgV6CMLszRy/QUUQGoyzcPa6V1BW5/VtCHb7XmlpGS8QESMFg
         nRRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148363; x=1795753163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hnkDMtwt0yq1d4PAeYVaT2YC+Oe3WZGJ26Fjv0oSbVo=;
        b=sAldUs+OBWP7yUdB03aT5VHhDq9M5CDEtOd/lvcX//OAYOJbR+Atgp7rQX8wM2Yy+K
         os92aZQb5d1W01CUPiVtrvio9ijSwobfd9jOn0XesX2qQk7VgzDgIqkHS6PnjFYUsE3M
         ZX6Ca/71KW8ApIJcMI7h3PJfmVP4Ij/r7y287f6w/C7asAlJSFn9M7GHHR10Ao6Tczjt
         caMyqmOxgiyqMJSETQaZNSx/UubgSUvoxddaxo8r+X6JTO3vIO3NthgQdbmRhTP5qaL2
         2tQmVmvYB/vspl2TVemPgIq/fpOSLgP7KXOgHRzNu0wSek8tfTqY0lNGXRw8WQ00sMOD
         bDQw==
X-Forwarded-Encrypted: i=1; AL+hErE/ZIK2Be7eBIT3AJRrgbNKSmktLVepgOAagQ4H49JU5kD3GQ4W77sjVlIUFG9FjuDJD4GHUh3FaQ==@kvack.org
X-Gm-Message-State: APuU4Z+8owwfVLKwq8Ds6ktdo8enT89O0xW4zPDlkZrofyXeE3zVeM6o
	T/GvfWi5F84Rb3nFCTBRjr0Gu78P7LZOFR7PuJXOiUz1xU9uFrsW7RzZ
X-Gm-Gg: AYBFou104f1tVwE5wdX7gUTR5dWRH96gbXirTRrwxCVhPzgCg2abGnxbHlTbOkPvgaM
	GYC1V57bujmMELaVAL2vn9sdZKAcSMKYHNcAip6jWhBqxUXcusqVQUdDzdRuQ0feo17NIzKHRYd
	PXcdRA7c2lraNBP4gG5+4sXRpoK+eToPeIfRYrqdlC3zhUWNRkh7L6wEMCJxfM02tP/31BRbvoh
	xZUpIycZmDHGPetDsIsmkttsriyOnbDkDzgTsu7n4ut9/pp2Rk35IeidFbaQyhNUKroHhsh0Esn
	0EDAVv7MeMF5byidQhcbs2+KNY3u9kaDeRc0i+td8HF7pqSwRHuOzQw4yWiOsCqOQ/LWZI8Yc7f
	5pELTao7UjZlMcFO0w9PVdd91H+MPSCLRS4Tcha4UPyrWzz7V/kCbcwFFPYc2nXQL1oATEd3fX8
	+hsz+1VOlgEX0IAYoLwtBMa+XSV1N1saJsE+pE5ybUAbdyUGFWarUnqYysYXhbhJcCke7GGQdPg
	BxVTdn8DdNSm5rxrBWwuaRYxVd2FQ28vriGoY7Ys22iPrgBsf9/kBh+2t24RrukjLN1Xxx99vyP
	on9gTRDjcc1M7oqGD0iVRp4pNMdF2o8jcez8eHgIJg==
X-Received: by 2002:a05:701a:cccd:20b0:1b5:3819:f8f with SMTP id a92af1059eb24-1b55692aa4emr1650809c88.36.1795148362798;
        Thu, 19 Nov 2026 20:19:22 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm3124341c88.7.2026.11.19.20.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:19:22 -0800 (PST)
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
Subject: [PATCH v4 4/8] crypto: acomp - Add API to get a compression algorithm's batch-size.
Date: Thu, 19 Nov 2026 20:19:02 -0800
Message-Id: <20261120041906.5785-5-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 06E8420007
X-Stat-Signature: jbjff981ah6uaxdsqnmuggndt78oj9j8
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795148363-44518
X-HE-Meta: U2FsdGVkX19XERNIKh2lgTqZjTYfcYu+Arbtj92em/nvqCLmjsGd6juZL+ymF8gpL5DAEE/3/NePcXdky4rXlT9XLiCmkI1EcpRCQm3SrUCIKrCIZcGf5aOMKJ44EBRwruMmSXm9v8bmerH0KDPMNaXRsUlxB94X5hHZKJk4tPJcUObAZi8fvemMhv1TYYoxz02v/eaE/fD9OVzyS/MYqcza65+RQtpsqswust78RIzcl1whA3UpwVREK3M8ZIJWtbWkVzAUE5+Cun8JuHtKsXqBwiTTbQPshTUWrYRPYS7o09RtvBPjVMfBixF5If1Ne3Hs6L02UHhXCWuUI6Z07XFagRybumnF2/8DkSLjFHzIpVHWdN4grZ7BkLEc+l6Zl9jmYRP9tHpiglo4CD4NZf53BU8kmpw+z8z4zSomJ3OkcMd/N9MojW9mSV3jOJBG7dNlNAa24q5r2CAM7oEgECDqYq2K2DFCh5rqbp/ldhHhjnPvPnr4Bklid6fP2WWgTc6taTbKxv4WGTaUjc5k578A8FPjLUxKrAiZrPXATKIV6RYNe5gOOIivI4ydHLZNzpRrr143r00X6/UY0xsOz+ZYWqF0WncwEoW9JXigXj8U8fcTsG2h3yuRPRXm50S5VrDbMptXP7jVro5Le2nEma/gejILjXPfq2HWvUVsVGpM96v9C1lhIwz8IqU8E3JHuL+L4LX6zlIhCaCBCahLcYFkWu6IlK7GPbUZE0oY0hwkpl8wdLwjmNHlSu4fN/1wNe/WAyqm2EqyidiZdEn5BwWaOneI7fdMnTIGlPTQHm+0gwBsM4DHh0pMiY6T1CoEtjdaxy10ibFVpvYtoKQ+pjtdtqKcirw1e9Dryg2FRSnUwVqfHpISnarBwx5fzpcSZLgYF5xpeg4IguAd2A5v52tDYegi+0r4JuDAC+Mriqs4nmqUUytJDB/rUyK7YPK2gyz9AIw5gaiYWrNnUgs
 /pszXa51
 Ne4C1xpCO5tGQWPFbLnaBeURR3zVpFZTmU9vWgETYsQULbY/dEFV9OY7pLzEayjzNB56bDnBm97QOmvE7I+YlJc216WA2M8TxmEs1RyfVW9Dk2ymwcnYKCV2K9F0ri2BxSHXUZ7uHRqiN6lWx2+wkYoVwO4M2VW8t/pDELUR3/rOH9S76Ng1d89eFdAurwxPgMRilrm7WWXG79DgqXe39r/Pr7iqonDHXU7GYngbtCl/dtKGOThOe5f6QG3ooT3Y/39erlG2Cxj2m0xBbK9HpD8DW3qgQXF9EboRdR8j3OOeeimjgpvb58OzXPbNwjmpWBIFVDjBx0IP8s8hvwMR/virfuKk8SaNO+WJ2iVCGQvJ8djTdHtyQs21rF4peEC4uyIxlKZlebjgROot6B7DS8v7Xj3jWKRKiFi7bWHEQiwa/+uOGJzYq6nXJ1sQXwA1x/2Tg0te0QI2FzyfBC2HpKXMC8Q9Rf9BU13snWUdrRowk0caYS+s9tOTB3M/oqt/aHk2jv48M9t9JqIwsZCfKBkIhsKpP/I7EyNr0cv46Whem+X0Tv03qNKouy6Qf6Ho9aP3pWX+c3Javf3RnlvitQnOFQYGWJso+1lcKLdzABMIXjx6oC56mmKW0pipQglpP4UljZ1kWb9tajoJXiC+MqVo/Qg==
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


