Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24544CA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9DC96B00A5; Fri,  9 Oct 2026 03:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72E46B00A4; Fri,  9 Oct 2026 03:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C056B00A4; Fri,  9 Oct 2026 03:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 830406B00A4
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:12:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01DEA140280
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:48 +0000 (UTC)
X-FDA: 85302220458.26.6D0BCFC
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3F363140006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CI0D3SFi;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791529967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BnpVN29DtbqPgrKOel1BWS5wocQF0xrQV49DCLSnSB8=;
	b=K+hfbMWdIs/u8617yHDIbWrcBd8WGwSdQtB4fcqaR36QuDnLASI5o6+mmGjqWk5/FRYvIo
	yWJrl+2c5FuCqmlGX3fjFp26TuHG73fA8yqzipwQJ2alLC9NZproW4sGQsOxwrhF2EBKk5
	9t7FwBF7wTzS34oBmMwzGq2x4HaRtyw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CI0D3SFi;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791529967;
	b=XgGdgjlLxdEPD1dPuFDqQ0beVPcMa3zQRTGZKbDldXp0JzY3kfKyDDDF3tvFbluHqfQQrz
	V34l/m+MmRmco9Swx2QB817WGMSPzyWrgCfd5ZLB5QYrHgpOW9z/ak0KY0wCEs7bAifhWZ
	n3b61YHx99niJGBncdxFgeLX1Dolutk=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e623eda81cso14627335ad.0
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 00:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791529966; x=1792134766; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BnpVN29DtbqPgrKOel1BWS5wocQF0xrQV49DCLSnSB8=;
        b=CI0D3SFiWBCg+VJgq2py9rg9UfUWnEojzv2pNLkj16Wz4+JEaFkELZJzlLq/psm+oK
         yp9PbQ2DYOHiTlNml7OVeANMdxDTJuK25gC14RP0w1Er3vIlgXaz6B5FXYgdmnj2M/xQ
         rEf1+Tv5xLoTlLPnTk5X1V09kW9YXxYbqZgrA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791529966; x=1792134766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BnpVN29DtbqPgrKOel1BWS5wocQF0xrQV49DCLSnSB8=;
        b=vkFb8CJEdcnxir74zxGGFdkY03dze5/plYHYda/fX7saAe+6EEIhnQ51E/JqC8X9zD
         2zG+r/9wgzT6eGeX5GWejeaD5sUpjTk8YNRp4R+eNxhAOmiW7S0udLAEqQMWz8uZI5w1
         A8LGywK3Wo4BXOMGucuVIwj3vyHTiGqbX8ZMLRTjI5i/mQ0xLQSNRzvLwt4a+Fzr4GFi
         vRj8aPCq+ewhB+XuA4qqD36i6FXD+MkJK8H1Y4NQHus+3cLLMcGn5RmpqSm9CnnRruY/
         ThwNgr8DrLJYx2+J4DoZaLNM9+vnMx01onpz23C7y853+zFdY1AI+uHtkKlECiAzi03r
         EKGg==
X-Forwarded-Encrypted: i=1; AKwUvBywDCPpgZoxUSmQAsjzbhbjxajVvmVeD8+0g7c0Ci3zald5Bjz+ZnqmBGyyfRHwoivLePEnW1C8rQ==@kvack.org
X-Gm-Message-State: AFq9FYJoNuZWdeR+Pci2ZMt9z6AgvEUaCr0KBjbbQsnASh9R1zYBGF3F
	46uiWJrlxncywRF3BapJlQ9Gs63do6W5VTGWt35knAH5cLScmD6PmIjS4k9Y+ch9zg==
X-Gm-Gg: AYBFou1Ttiv2Dtg8umtb8x0aiv8dVPRsLcJ996/riAT1XTBZFCGsEZvwqLMlXzGRpJ/
	RolUni1MWNQ7mpIVbPKnX66r1KUL8eoy8+1N3fPhIgR3MnPVwjzAEy4N4wRzHspceRuORRp6mHS
	rYcul0YoqRqV3Np9TofsIHgCS3VN3XAFsXStzqbg94vBKDx7QA7KDT1iX7k/yfTE/6KZzZgLsq9
	+W0dPciV9grhgQwl4CosNFkAWKl/3wa8u9QJLAVZmkfyfKR49fZPOQyv9jSBoPGsd8U86jfNLa2
	dsAUiyRb0klyY3aFAXbdiEc0vYlHH9RzrUiCovB0EowvqVwGsATxeDpSoF955+6e+7rGR5Z/muw
	ALjP8c6msTwBDa5Ct6D6NeHSV8dR43AKLQ/USGyw9GT9CXUvtZ2fhwQUbEnRvM8Vz050bUEJnbj
	5F4eu33zU2lsdFbxbjf3mo5TrDA4xypgVUYQT2BNyxy0Zh8mi21eCfg2GPmT1CjW+igWR4+aMwL
	4P93eyf1dRlFa14eLzbUgcL1sqdw/y5g+sB4DWnJuTGzsnuIw+Or0hTLMUoSPA=
X-Received: by 2002:a17:903:b8f:b0:2e6:23e5:494b with SMTP id d9443c01a7336-2e842ab67d0mr7500745ad.19.1791529965967;
        Fri, 09 Oct 2026 00:12:45 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:383b:5817:8167:5051])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b19a2sm4483535ad.46.2026.10.09.00.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:12:44 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 10/11] zram: use a singleton compression context for recompression
Date: Fri,  9 Oct 2026 16:11:33 +0900
Message-ID: <20261009071157.3730698-11-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261009071157.3730698-1-senozhatsky@chromium.org>
References: <20261009071157.3730698-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3F363140006
X-Rspam-User: 
X-Stat-Signature: yxomw9txjrdz3rkgu7exp45cgtwgo7x6
X-HE-Tag: 1791529967-862876
X-HE-Meta: U2FsdGVkX19ponsSuwFNGSzbUeRizBDQ5drQm+VgmXSOrj0wTdCAk2NmPXMuHmIs4LMGeF3rQ7XZOnap+++Ptmq4D1nU1LGctQW7ly3ZB6rKk555V+vhZEvR8s8AH2YMxVqlt6hkh2SCMdFIxLd5wfWP0kWZ6W+S7FMDPZSmMzygoZz+8sBHOgCEnxc+8lSivuLj0UXzJUMM1+ZaVkgkCvw4nSt/Ghzu86K++wHtq2uIa9p4M8GFtzh836m3vEsV3igU0MTW/MXNhDpgJbBP36DUopjYd0ormnRvnVayEU35j4yPz4mkmdzCYcCa3h/cwgeDsAgDCs8PUPUnXxQMFiYxOK5u7HLp93bOazzM51EUxQJjcRqNHAJitGLXi0iOV6/wTTg/qO3NJb7ER6KeTd3pttpp5QqwuH0aYolw3XEcnQhgvftpsQDRcbrf+138NF5Tsqry17lB/EEZR4qgaWK2Ce2lbKT405CaOmeMnz+sksW5AQJjp0QAZvhIl0SiIkGw+vtVz0j1BAK2rg3TvhYd9n+QvF18Hxlz2UJp9+UBGRxOlg4NtbtBo5awlPj1YzpvMKnZN/XU4oGgv14ee/l/lWfnTpKjXrpVolCbyDasci4u8drk7h9yokbwxpsikSijFhLI2sxk2YLw2QMVoQxf37osYSf859SAUUxUOkuf5fdy9NiEyaPbHmOkmuwvNEUA7OD808Ci2CTWRdGcuMsxKY/rkQIwD4s9DLldbucrR6spRfz/ntaZ/Hc4Fl/woFu+Jza+Q/zDnYkAHYrT2czSQ6ZNNIH4c5etCaYTQFr6YNYQ3SwJaY9ogVBqlAPYQ0WcS+25d5vNn2kFtiNQjDmFxA4/1X4sR1tnvuzvY4dzCC0t8niBtG0UkEyCpZOPkj/FY53wsFaM8TfdivOgkW/1QSShWvYeHeXTHeukIls4OI2KDGt+lojAIeWN/lBm5fMV/nHZtw/2B3o8Gpe
 maY7SwcM
 ojejrRHLFkpDuJSwxdqmzYIoVQPu0qn25XI1UXcna6WxZrHZfd/rVfYaxpxQftR2SBEhsSUuP3ggpL0TKRV7jNt/MweIwX9/565vL5dqYRlsPiwWGlDFc4pgCVkwMp42a6WH4c06bz0F7qiquHm9lS6EUU416IcUc7EZyhkKEGmyeR30qsFC48oyzR+kOxw/mSh9CvdUsjmNtFQYzvdwSr1zPoWj1i+fVeqJfdHWvsiHlr+aCcg3yq/hVtw/C1Gm1PW0Bsdp9a9UQcF9kkTYUSaz9mc6EqB5EzDXd7RJAOTEaVS8LMTch3sYCbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Secondary compressors are only used by recompress_store(), which is
serialized under zram->dev_lock, so we only ever use one secondary
compressor at a time, yet we still allocate them on each CPU, which is
just a plain memory wastage.  However, we do need per-CPU decompressors
in order to support concurrent reads.

Now that Read and Write contexts are split, we can allocate just a
single compression stream (recomp_cstream) for secondary algorithms
instead of per-CPU streams, which saves N - 1 compression contexts
and 2 * PAGE_SIZE buffers.

For example, on an 8-CPU x86_64 system (4K PAGE_SIZE), this saves:
- zstd (level 3, default):        ~700 KB (~100 KB/CPU)
- zstd (levels 12-22, no dict):   ~1.91 MB (~280 KB/CPU)
- zstd (levels 14-22, 110K dict): ~5.33 MB (~780 KB/CPU, lazy)
- deflate (winbits=-11, default): ~1.04 MB (~152 KB/CPU)
- deflate (winbits=15):           ~1.86 MB (~272 KB/CPU)
- lz4hc:                          ~1.84 MB (~269 KB/CPU)

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zcomp.c    | 78 +++++++++++++++++++++++++----------
 drivers/block/zram/zcomp.h    |  9 ++--
 drivers/block/zram/zram_drv.c |  5 ++-
 3 files changed, 66 insertions(+), 26 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 1c9f6d5c8cd1..20c487bafff2 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -151,6 +151,11 @@ ssize_t zcomp_available_show(const char *comp, char *buf, ssize_t at)
 
 struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp)
 {
+	if (comp->recomp_cstream) {
+		mutex_lock(&comp->recomp_cstream->lock);
+		return comp->recomp_cstream;
+	}
+
 	for (;;) {
 		struct zcomp_cstrm *zstrm = raw_cpu_ptr(comp->cstream);
 
@@ -243,22 +248,25 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
 int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zcomp *comp = hlist_entry(node, struct zcomp, node);
-	struct zcomp_cstrm *cstrm;
+	struct zcomp_cstrm *cstrm = NULL;
 	struct zcomp_dstrm *dstrm;
 	int ret;
 
-	cstrm = per_cpu_ptr(comp->cstream, cpu);
-	ret = zcomp_cstrm_init(comp, cstrm);
-	if (ret) {
-		pr_err("Can't allocate a compression stream\n");
-		return ret;
+	if (comp->cstream) {
+		cstrm = per_cpu_ptr(comp->cstream, cpu);
+		ret = zcomp_cstrm_init(comp, cstrm);
+		if (ret) {
+			pr_err("Can't allocate a compression stream\n");
+			return ret;
+		}
 	}
 
 	dstrm = per_cpu_ptr(comp->dstream, cpu);
 	ret = zcomp_dstrm_init(comp, dstrm);
 	if (ret) {
 		pr_err("Can't allocate a decompression stream\n");
-		zcomp_cstrm_free(comp, cstrm);
+		if (cstrm)
+			zcomp_cstrm_free(comp, cstrm);
 		return ret;
 	}
 
@@ -271,10 +279,12 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
 	struct zcomp_cstrm *cstrm;
 	struct zcomp_dstrm *dstrm;
 
-	cstrm = per_cpu_ptr(comp->cstream, cpu);
-	mutex_lock(&cstrm->lock);
-	zcomp_cstrm_free(comp, cstrm);
-	mutex_unlock(&cstrm->lock);
+	if (comp->cstream) {
+		cstrm = per_cpu_ptr(comp->cstream, cpu);
+		mutex_lock(&cstrm->lock);
+		zcomp_cstrm_free(comp, cstrm);
+		mutex_unlock(&cstrm->lock);
+	}
 
 	dstrm = per_cpu_ptr(comp->dstream, cpu);
 	mutex_lock(&dstrm->lock);
@@ -284,7 +294,8 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
 	return 0;
 }
 
-static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
+static int zcomp_init(struct zcomp *comp, struct zcomp_params *params,
+		      bool recomp)
 {
 	int ret, cpu;
 
@@ -293,10 +304,28 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 	if (ret)
 		goto cleanup;
 
-	comp->cstream = alloc_percpu(struct zcomp_cstrm);
-	if (!comp->cstream) {
-		ret = -ENOMEM;
-		goto cleanup;
+	if (recomp) {
+		comp->recomp_cstream = kzalloc_obj(*comp->recomp_cstream);
+		if (!comp->recomp_cstream) {
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+		mutex_init(&comp->recomp_cstream->lock);
+		ret = zcomp_cstrm_init(comp, comp->recomp_cstream);
+		if (ret) {
+			/* zcomp_cstrm_init() cleans up after itself */
+			kfree(comp->recomp_cstream);
+			comp->recomp_cstream = NULL;
+			goto cleanup;
+		}
+	} else {
+		comp->cstream = alloc_percpu(struct zcomp_cstrm);
+		if (!comp->cstream) {
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+		for_each_possible_cpu(cpu)
+			mutex_init(&per_cpu_ptr(comp->cstream, cpu)->lock);
 	}
 
 	comp->dstream = alloc_percpu(struct zcomp_dstrm);
@@ -305,10 +334,8 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 		goto cleanup;
 	}
 
-	for_each_possible_cpu(cpu) {
-		mutex_init(&per_cpu_ptr(comp->cstream, cpu)->lock);
+	for_each_possible_cpu(cpu)
 		mutex_init(&per_cpu_ptr(comp->dstream, cpu)->lock);
-	}
 
 	ret = cpuhp_state_add_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
 	if (ret < 0)
@@ -317,6 +344,10 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 	return 0;
 
 cleanup:
+	if (comp->recomp_cstream) {
+		zcomp_cstrm_free(comp, comp->recomp_cstream);
+		kfree(comp->recomp_cstream);
+	}
 	comp->ops->release_params(comp->params);
 	free_percpu(comp->dstream);
 	free_percpu(comp->cstream);
@@ -326,13 +357,18 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 void zcomp_destroy(struct zcomp *comp)
 {
 	cpuhp_state_remove_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
+	if (comp->recomp_cstream) {
+		zcomp_cstrm_free(comp, comp->recomp_cstream);
+		kfree(comp->recomp_cstream);
+	}
 	comp->ops->release_params(comp->params);
 	free_percpu(comp->dstream);
 	free_percpu(comp->cstream);
 	kfree(comp);
 }
 
-struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params)
+struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params,
+			   bool recomp)
 {
 	struct zcomp *comp;
 	int error;
@@ -355,7 +391,7 @@ struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params)
 		return ERR_PTR(-EINVAL);
 	}
 
-	error = zcomp_init(comp, params);
+	error = zcomp_init(comp, params, recomp);
 	if (error) {
 		kfree(comp);
 		return ERR_PTR(error);
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 22be50dc51ba..e48e3f075352 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -33,7 +33,8 @@ struct zcomp_params {
 /*
  * Run-time driver context - scratch buffers, etc. It is modified during
  * request execution (compression/decompression), cannot be shared, so
- * it's in per-CPU area.
+ * it's in per-CPU area (except for recompression, which uses a single
+ * per-device compression stream).
  */
 struct zcomp_ctx {
 	void *context;
@@ -81,8 +82,9 @@ struct zcomp_ops {
 
 /* dynamic per-device compression frontend */
 struct zcomp {
-	struct zcomp_cstrm __percpu *cstream;
 	struct zcomp_dstrm __percpu *dstream;
+	struct zcomp_cstrm __percpu *cstream;
+	struct zcomp_cstrm *recomp_cstream;
 	const struct zcomp_ops *ops;
 	struct zcomp_params *params;
 	struct hlist_node node;
@@ -93,7 +95,8 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node);
 ssize_t zcomp_available_show(const char *comp, char *buf, ssize_t at);
 const char *zcomp_lookup_backend_name(const char *comp);
 
-struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params);
+struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params,
+			   bool recomp);
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index def5266679b0..70d3f0ed9a3c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2522,7 +2522,7 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	}
 
 	/*
-	 * We are holding per-CPU stream mutex and entry lock so better
+	 * We are holding compression stream mutex and entry lock so better
 	 * avoid direct reclaim.  Allocation error is not fatal since
 	 * we still have the old object in the mem_pool.
 	 *
@@ -2924,7 +2924,8 @@ static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
 			continue;
 
 		comp = zcomp_create(zram->comp_algs[prio],
-				    &zram->params[prio]);
+				    &zram->params[prio],
+				    prio != ZRAM_PRIMARY_COMP);
 		if (IS_ERR(comp)) {
 			pr_err("Cannot initialise %s compressing backend\n",
 			       zram->comp_algs[prio]);
-- 
2.56.0.385.gd3acb90ef8-goog


