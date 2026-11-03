Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E096606D815
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 00:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n6ngZ3t9
Received: by kanga.kvack.org (Postfix)
	id 0A7796B00EF; Mon,  2 Nov 2026 19:03:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 058806B05B1; Mon,  2 Nov 2026 19:03:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89406B05B2; Mon,  2 Nov 2026 19:03:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B41D16B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:03:28 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3CE971C34DB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:03:28 +0000 (UTC)
X-FDA: 85391858496.15.3A06EBA
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 967DD40002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:03:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=n6ngZ3t9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793664206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mwQ2z/age/B8OVHRkYCsNYXmBR1En6PKc33rR/ATxnM=;
	b=3F+Ti5DV7KJv11BMFpGD5zElksMHME4pMgwDe2nXPzHkncQbBv/JMoEFs3nyB3xSEmg3bL
	iW5+u0QHs85iYAYDByEXTnMjtOLN4dk5N/EIXE2OOLnOrrbBwD8RkzRObMmATKEu5x5Cwh
	niqwwVYlr2VkhDQSHg4j4Dk87P/yJqw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=n6ngZ3t9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793664206;
	b=KF+ZMvtqw4Ti+ZqmeHMlxClXjjol3ZEdgoQJ5LeTA8XNbezo38tNWhBpeo69V0/wmJUBkh
	sIdQkc+hWkaG+IlqjT81W31mDR0EvxIlyk5DxqjWc78//5THG3AR4/QfoK1DzEYOh3T8Lo
	SkzPbS3oaqDqfXE9bJnayx2PnLI4P+Y=
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-35b2c599f43so6184741eec.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 16:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793664205; x=1794269005; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mwQ2z/age/B8OVHRkYCsNYXmBR1En6PKc33rR/ATxnM=;
        b=n6ngZ3t9oPkIv+h6yiZznZU1+SCIpHABKLbj83Bo0UtRIuPz/y7fxIB1GkOQJ/R7Mx
         guJyZBHnW8jZpUb+Mg8qcNXRc22bEUJXgIdGAbkKGBUpJwbdYhKpiJRaO2sGpk2x/itm
         98jvGVdnQR9673S0+8Njtkj/7zAIPjC+etQzaWwSVaNR2SuhWnBzgiiZuGmqs5tI5dZy
         /P3/gupCl6kZv+7C24JTOfensSoUCWc2GP6aehpQcwMUkdVVFXRhjNe9C1MMNpX/oQ83
         u3ayA4tk8aB7NvB0eWHvgpQWB75P2l6EVwGh7FUQo9Qx4RDE++OTIeoyhGQI9Moc+xPY
         ylAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793664205; x=1794269005;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mwQ2z/age/B8OVHRkYCsNYXmBR1En6PKc33rR/ATxnM=;
        b=QyMLW4m7bMnvGrBiM9EXUwdm7ubiv5eS9Z1tu26Tsv8gm3mXuzozuioo8PvRwfl5EY
         1agSDgxlp684t753Momeb3OlrHFtcx56J1yeMwlKFcXP6X8udyYcEdnlEGBrlA9BCSqj
         ij3mJSUtdb92OnEBGcdxMUspRr1KaAcgyfXT2ECoHLd8CzwlV8vn8bAxMSBVOjC9m/sM
         fP+ayMoJfhtn2ZTKQW/zG0S6m9N5N7R1tQDmYin3wFSILIaZQ8VIB4AMQRZZgEXw8CQv
         duewDyITzc2/32P8K5+ZndAfESBGHoW3fcjh7NHC5gR8BFOeXPVxbOVCH+iBiiygLmp8
         vYXQ==
X-Forwarded-Encrypted: i=1; AKwUvBz8/8l27eG+ZkTIl5fm5YicIalazG556+JSxiFOpgIPYjF5Om1rB9DI6C/YVcm2xaomvlYMPe2Xcw==@kvack.org
X-Gm-Message-State: APuU4Z/SmeoTuPO6jUaboMPt2SCpjzpqUzQ9lHgVF6wZmtJ1kqeVersY
	ccS1wtRP7j0W//VbXk1XwaCHJmCJz7R48f74GR36VfjPuTm6O9ZqGYjv/W37gQ==
X-Gm-Gg: AYBFou0qtqYpTbDqtux2IQ5qSv0FiFSWbb22/78OmJvHg36R6/Od3fNIDy0/t52ywiY
	nJXd8XpCtGCzt04HpLEZDC19N02X9yIuo5YKZEFNpDZozplbZkq0Ukz+NZqu+GWYHn2LBnHRvPH
	DFxwu37YrpVVHD8R3P8fIKFP7CKKa3tPmH8MNLwTqVZX/FK0H0hQCecfKeoMLCNmi7kV4eyPak1
	dN6+R11s/hgQg9tlQzttxqBiph78p02JzHtWla1j7ZN/VvXxJhBc4k/trBqETDjsW4RkXOn6xVc
	vkbhnT5vvFxkDZrVQnTS2MTOwPasQYChB95Sg/CJs8TGvj3860EhWTLFoE5QhSblJ/NfiDHphWd
	+1LPGQS/ML2lPp5tyn7ZH3FMd0wG/9SS2p2ozSPp7wEuL4pWd/Q8Y5c5iaHEjuf7zIdHvDlr0Ud
	i/M8lduXjMR2ZOmFzQQVrKXutqrVnZKyoL9ZGOJrht69VZb7tJQXbIu8Ns2UezwDZBz55FCGiH7
	53RC5lssqnMasMX3xBTUg1lZqRnCgBYWAWDBdMfhEKwQnlEiccvC1MAhM2+BRi4ARTWPi6OmVbT
	vX7kpeH/+Ioy94oBuZjUViK3L9jQLEoUKtgDJaPTWw==
X-Received: by 2002:a05:693c:69d1:b0:358:3426:d601 with SMTP id 5a478bee46e88-36a4221b3c6mr19297627eec.2.1793664205205;
        Mon, 02 Nov 2026 16:03:25 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a429018casm36699729eec.14.2026.11.02.16.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 16:03:23 -0800 (PST)
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
Subject: [PATCH v1 1/1] mm: zswap: Move the crypto_acomp to be per pool, instead of per-CPU.
Date: Mon,  2 Nov 2026 16:03:13 -0800
Message-Id: <20261103000313.13677-1-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 967DD40002
X-Stat-Signature: 4js5zyu4zd49fgkoc4g1rqoaiy5x51gu
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793664206-719994
X-HE-Meta: U2FsdGVkX19dl6gEY23zz12Ht71fqj7KI1cWLFL7mJ4HTSytJionmv3UMHN6hGqy6veUZPSD3njMKb4bv6w8m8fmbjhMmBFkP5W5J+lpqqb+vU+yENiBswOtTC0rv/GGIPCSM/u/S8JDb0pHDDRYjJWQY/L3TolEduKFSHpBYhoE5DA6Y8JkK1qhC/FtmnbCizL65U166z/FfVe6oYkrc7g1z8Jo0VYTYh8hWKGR7XUjozfv4cQUs5s9VdFcw3m00G+Nzhfl7Gi0ZA+GRFtPKkCM4kROVsmyn8cCzcSVTmYAmp4Ed10M5iLx56fDZYsO2LF9VEkvUzcIGIBdDK1t3Q2iVozHu+ywwkByrFTGo06UuxcZStwwHv62s3K9yEGxPLQgXYJ1/t+P9w46kNLwVex1XWvzmuQqsBb7pj2RdkYa5GPz/b7rP/eRswXDJc4qpmNiPbqqunoyyCDtDXLkK7ldTNBrPMPguVAeWR2A0FQb3EmI9DewTzMmtsU009wIvt6NHdXVT3jDXCNAot9lwspM8LAJ4v0bdkiQTOEjpCl9IC6YcUYTPWoRZtf7upnKXEb8cLxzwiQmyvitB+UwZDp5KBVezDFK3xr+eSmSAnJ9YVf7zKEK6bRBNiwuppdOVE8NZkrp56kZysqONgFObOWv5o9p9E6yfdNCwfzzY4xsQRDe2xXcouv1G4lj9gFXD9BD2jI9T9XHlIqVAwEk6fvqTOHaJZAcklJ6PrDL3/8Dj0j6gOFboosH7XP9Fq76osjATTw3g+gvOR4WVkExn5GDP+omkK5BtJ9fGPHOORTYCiYO49Uf6DFFDhGE/zeSICjMJjbaUGGCi37Hi/NjWP6tmW6RBB6a6ngOHZq7+O+U/yvkOK5XyDktugKLTMcTh9LsyJDZyT9pJ7RUiRkRaH+duo2GIc05HnGyodNDteSI8u+CtqbPKjL0rHBPoG/8ShyHpWmlBk+tcOgwCS7
 3r7Gd0S4
 fXm7TJOORzVmn1g+kXVatJa/xy4Xq5ifm2YRxMyHBmtrgfk3scLdPcenFaEMsjHhOnmivd3xCSsoWydTYRq0JDjlpEKw1kU49e1cgWl8FfTU/bBFHEdcCtW5ceh4EDVCzlwAe2RkNTtwThXb8AVTzLPDpeTnFJl8jXAhl0oOZd8V8j8hHzT36eCBFCHldrV39wy5fpL5jDBs1Ci1l2qkKulSAsgjddhX/Kao+zZ3Q3xpASkqhMVU8EUIosP4FVjCF0Xnf2Tn8ZG6Sm1BvaycTGgV1CXbsEVgiImctBfiUAjvIrO+Gma5T3X+D/sG5c0Ktj5m07uazCGKgptGOCSvVsqAlJE8vUPoHOkVXhmeUYSGrgJWFfAV2ExyOLhnRo/lBkrfhdcryVPlrqEGUbqqkZiCOAQtayUQnOpqLFNhg8kVbosf/o1qeJ+2E9/ArwPPYYYjEaVIYJrq0zRwO9ddmpRfhFa3NzNlbOpeNXycLYtBwHv1MIjhVs1J+gD2bFvnubP0DadW+22OTYrw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The "struct crypto_acomp" member of the per-CPU "struct
crypto_acomp_ctx" has been moved to "struct zswap_pool" since this is a
global entity representing the crypto algorithm.

We save 56 bytes per-CPU by not allocating per-CPU memory for the
crypto_acomp. The size of the global "struct zswap_pool" increases from
240 to 248 bytes as a result of this change.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 63 +++++++++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ad01c691a263..68825a6c0b68 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -151,7 +151,6 @@ struct zswap_comp_ctx {
 
 /* Separate requests, so that decompression does not wait for compression. */
 struct crypto_acomp_ctx {
-	struct crypto_acomp *acomp;
 	struct zswap_comp_ctx comp;
 	struct zswap_acomp_req decomp;	/* unused with on-stack requests */
 };
@@ -167,6 +166,7 @@ struct zswap_pool {
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
 	struct rcu_work release_rwork;
+	struct crypto_acomp *acomp;
 	struct hlist_node node;
 	u8 idx;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
@@ -286,16 +286,6 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 	acomp_request_free(acomp_ctx->decomp.req);
 	acomp_ctx->decomp.req = NULL;
 
-	/*
-	 * We have to handle both cases here: an error pointer return from
-	 * crypto_alloc_acomp_node(); and a) NULL initialization by zswap, or
-	 * b) NULL assignment done in a previous call to acomp_ctx_free().
-	 */
-	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
-		crypto_free_acomp(acomp_ctx->acomp);
-
-	acomp_ctx->acomp = NULL;
-
 	kfree(acomp_ctx->comp.buffer);
 	acomp_ctx->comp.buffer = NULL;
 }
@@ -322,6 +312,17 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
 
+	/*
+	 * In case of an error, crypto_alloc_acomp() returns an
+	 * error pointer, never NULL.
+	 */
+	pool->acomp = crypto_alloc_acomp(pool->tfm_name, 0, 0);
+	if (IS_ERR(pool->acomp)) {
+		pr_err("could not alloc crypto acomp %s : %pe\n",
+			pool->tfm_name, pool->acomp);
+		goto error;
+	}
+
 	/* Many things rely on the zero-initialization. */
 	pool->acomp_ctx = alloc_percpu_gfp(*pool->acomp_ctx,
 					   GFP_KERNEL | __GFP_ZERO);
@@ -385,6 +386,14 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
+
+	/*
+	 * We have to handle both cases here: an error pointer return from
+	 * crypto_alloc_acomp(); and NULL initialization by kzalloc_obj().
+	 */
+	if (!IS_ERR_OR_NULL(pool->acomp))
+		crypto_free_acomp(pool->acomp);
+
 	if (pool->zs_pool)
 		zs_destroy_pool(pool->zs_pool);
 	kfree(pool);
@@ -423,6 +432,13 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 
 	free_percpu(pool->acomp_ctx);
 
+	/*
+	 * We have to handle both cases here: an error pointer return from
+	 * crypto_alloc_acomp(); and NULL initialization by kzalloc_obj().
+	 */
+	if (!IS_ERR_OR_NULL(pool->acomp))
+		crypto_free_acomp(pool->acomp);
+
 	zs_destroy_pool(pool->zs_pool);
 	kfree(pool);
 }
@@ -840,34 +856,20 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	 * To handle cases where the CPU goes through online-offline-online
 	 * transitions, we return if the acomp_ctx has already been initialized.
 	 */
-	if (acomp_ctx->acomp) {
-		WARN_ON_ONCE(IS_ERR(acomp_ctx->acomp));
+	if (acomp_ctx->comp.areq.req)
 		return 0;
-	}
 
 	acomp_ctx->comp.buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
 	if (!acomp_ctx->comp.buffer)
 		return ret;
 
-	/*
-	 * In case of an error, crypto_alloc_acomp_node() returns an
-	 * error pointer, never NULL.
-	 */
-	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp_ctx->acomp)) {
-		pr_err("could not alloc crypto acomp %s : %pe\n",
-				pool->tfm_name, acomp_ctx->acomp);
-		ret = PTR_ERR(acomp_ctx->acomp);
-		goto fail;
-	}
-
-	ret = zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp);
+	ret = zswap_acomp_req_init(&acomp_ctx->comp.areq, pool->acomp);
 	if (ret)
 		goto req_fail;
 
 	/* Skip the per-CPU request when decompression can use the stack. */
-	if (acomp_is_async(acomp_ctx->acomp)) {
-		ret = zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
+	if (acomp_is_async(pool->acomp)) {
+		ret = zswap_acomp_req_init(&acomp_ctx->decomp, pool->acomp);
 		if (ret)
 			goto req_fail;
 	}
@@ -876,7 +878,6 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 
 req_fail:
 	pr_err("could not alloc crypto acomp_request %s\n", pool->tfm_name);
-fail:
 	acomp_ctx_free(acomp_ctx);
 	return ret;
 }
@@ -1031,7 +1032,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	 * Otherwise serialize decompression on the shared per-CPU request.
 	 */
 	if (!acomp_ctx->decomp.req) {
-		ACOMP_REQUEST_ON_STACK(req, acomp_ctx->acomp);
+		ACOMP_REQUEST_ON_STACK(req, pool->acomp);
 		DECLARE_CRYPTO_WAIT(wait);
 
 		zswap_set_acomp_req_callback(req, &wait);
-- 
2.39.5


