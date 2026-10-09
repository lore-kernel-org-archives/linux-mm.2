Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FAF4CA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 141886B009B; Fri,  9 Oct 2026 03:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073ED6B009F; Fri,  9 Oct 2026 03:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5406B00A0; Fri,  9 Oct 2026 03:12:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9C716B009B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:12:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18B36160272
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:31 +0000 (UTC)
X-FDA: 85302219702.07.A5AF065
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4B0D31C000C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Zvyf6qix;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791529949;
	b=52IK1kNItSyFhHAO99h32sy0giM1wwG16i8SsAFNNyWsYMITyJQWAOVrjYhEseU4wP3w6l
	SCdx1qhiEtCXIaRgwTjPf7qY4FQ8zUniIi0EdcdG5KMeTulPM2w6UV6TtxpL80w1P3BoII
	yX1dO0UQioBtXOdQK0nmMd4UCtCCUms=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Zvyf6qix;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791529949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fG+ZRnn0wXsUMGdIWlrdX9yA9C4/sFFG7BBKDHx8FEs=;
	b=DIkVHkItg8JcuISXDSSP8YDKXB6FjqEOUb9GTarfIP/1GPhvaH9dwslaIEzTU7qvu2zHaR
	Xy3p2O4sq+nkwoUM+t2NXpF74ptY90yE2nxY/DAeH9Fx8K1b/pUuvGjijA9c86hL84kNAH
	XeKGYblSaKNnXvPllvMz0YBgT2dBXnM=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e5378b281aso22619355ad.2
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 00:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791529948; x=1792134748; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fG+ZRnn0wXsUMGdIWlrdX9yA9C4/sFFG7BBKDHx8FEs=;
        b=Zvyf6qixwcqmEKDXzn9BihwuNdSDXhHB2LnKBGer71eZBqyU0svQmCh8zIlLbTzMaK
         TNQqFHzDJJFczG/Hz4nLbAK5oJqXAbjTWUFfsL8udFJBk9YBVJTzojl85SB6RIr8r+gK
         mDU8P+fXBdSQAAqGqQGkEs2nkm0cvKyNWxmGU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791529948; x=1792134748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fG+ZRnn0wXsUMGdIWlrdX9yA9C4/sFFG7BBKDHx8FEs=;
        b=wxB4J1LsWwquiv09q8Aclx/XUHXCMLIXoX6d2r09kD/4SJR2k05IV3ZcqA8aRFXbsS
         ExlkD6UwI7I9VMbNU2bhc4h+90tg4KXLnU+vLpQOlnb7VFZaNlTMEV/6dqhbyXZ8jpxf
         3Bdqk8x6W8FZdZ6avl48gDK9LJEKAYfoMxNEldCtClenyC2M2SO4fOHojJ9VH2jw1Aaf
         vNPfQjReyclpBa/YtXlhvSStqiplSkSd0oIvXAWE02PEzb1bXr0AHi8o7WH/OL2liBSf
         XOHMry1lUTY1xgCtBV7YB/EuDUTVTzxJoarv68w7SjWeBLCTooLrkVgEmmYBikOFQegN
         v7JA==
X-Forwarded-Encrypted: i=1; AKwUvBy3/EmhfXUNRSwl2sfI39Y+l/CIzpw/iBCTn13BKOQmdALWX+aDtlvAOVzlGMzJMwXeZ04IKFIW4w==@kvack.org
X-Gm-Message-State: AFq9FYJXx2lrDUz3g7F3jf/9rNT1wYFozBWVTQhBe3Yc1gD0Qy5X3lqm
	AtH3gdAsVzfpY+7dgoMU4mbA0yEsA4SNIpcGW6YMlM/bn8xfPZHOIK5DncUuJi3xt3bbW+Vr68y
	btLU=
X-Gm-Gg: AYBFou3MgybSGJ1ROiPSmr8PltAaLwuzf0+7aEWnOoTK2FNJoBF0dbZSIKX1G5qJtKD
	K/XQhv90YMExhDaOZ8FpE6F17zN2Y1HcjOsKj/7x89CNEQ70FZlYyhiyrRQJ9S8d6N09cMl/N2B
	4Bhkwwr3MsiFwuiz9qUTFBVuyyI7rtJ04Gu+YQfg0Tb2MJZEg3kkw3m+IgKGNGRj15xIWbKVBgQ
	/mrpWUBp14XJrw3UrQYUW/E8whaa5+zwGgZQHTiOxDSLaJ2a2Q7pLXEigl3KJ9S5h9JAEA0ZJSf
	ynbzSouDOnuXHiG/qQg6vsHjqrZNNkZiITMIPKMuSwL/S+ZJVqOWp/oQfQdgYteCgq7MjU4aWJy
	gX5H0TY57cVwgt9rLOBXk79KYLa+m8uE0zz7kLPVUyr/y/qxrhBstJfr3xcO7mLUz3nLDGP6x/u
	M6a1Axp6adecLLJsEpwdc0Np6xvw+/f+nigvZkqszLQVBzyGRZraWAgbTxLCPYib5bK988FdZhz
	EqPHGD6cpiSBD2mRSp/q1mUB+UOgJ3H3HEz/5v3x2XEnQm4b8arVbenKX4RRqE=
X-Received: by 2002:a17:903:1b68:b0:2dd:c100:4b77 with SMTP id d9443c01a7336-2e842ce7f76mr7930965ad.46.1791529948194;
        Fri, 09 Oct 2026 00:12:28 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:383b:5817:8167:5051])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b19a2sm4483535ad.46.2026.10.09.00.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:12:27 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 05/11] zram: lz4: use LZ4_decompress_safe_usingDict()
Date: Fri,  9 Oct 2026 16:11:28 +0900
Message-ID: <20261009071157.3730698-6-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261009071157.3730698-1-senozhatsky@chromium.org>
References: <20261009071157.3730698-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4B0D31C000C
X-Stat-Signature: 5njauxmwct5kauzcc7j5ncf47d4dshn6
X-HE-Tag: 1791529949-496702
X-HE-Meta: U2FsdGVkX1/detbbFjBSaF+VPKr14gIz6Cm+AaDuhcAmyYpC6OLbkhlKF3BXYgBIEWquF2yFyniUDxRxisd/ccyg6mvqv+Aqsl/2wuOQbxbvcMBRKL5eFcRjU06ZSNxcQqQuDebp6AFUbK5hfyAF2Xq+v5+3tIdd48y70oK/y8nxKbRaLPXDKgLUfW3lQXb4KaWAcJXWcuTOzXKKq1xEO3eVVGsTqUL4ctByyycs+mEQ/jqtql3c9Pe5FGFe0VQNRW1xnv6tHPndwcatM9F8thkzUZnQ2IEaJZqZoyeCmcGjXBVMB2EaZmhAl0tZlGm7Z+J4uGd42z+b6GTBMvxQQyyi2yufYhzXyD6P67ALfkxNn2NnCdaKxDRoK3haar737A/BH6pmNOHoUYhBNNZy618lgDU7731deYmj8y2CfN7rpjJGafvV54r1ELcfjURK3xUoh/NLZmuA3bBDyp2JC5yV+FJN6HkTmkZwbIpZ3z/tapX0JRDXxv45yeszoGKqv7YPzM2AbCCOdnpZcNdzgNCC45eSU9V6wIK7G/qsFtpnP13JoMkwA4zbWxH0z1wMwKJdGcg6VCSUzuGGhtAfAg6fNPAfmdph477uuUC7OzZsaE+LVP1gzh/TEyQcNvzsIC29ZkJjj26rFlRuik6CtojZY7IQM6EqbqCCrYtnySLuryDoQRgDAGZkF+7/B7Fku7MKFDH8vzhGzNk2JcJ3AN7FIOLMURP4r7QyvK+uwzT+eiZXY0RfHKLfQb3qnk5mhhcmCiL4kzZ7OF8/kAawGGRhrvNhCXFKSwKMns3oSJIzd35jrgnHbODRVipMrINgLhaSDOtJs12wl0IBSQbDTwb7pRZbG2y8F/l2UxPskLgFa4vxVOLTCTHmSclL5azEG4jSttq1L7U/zsY84G1T5/iv0jj3QfCnJD+xPEHKtr6KLNr82StdjQRsX5BhXL0EBuuwjh3SCwEAiUJ27ve
 8Weu34mi
 TV2il0THwIbbWzmxogIFNoBw1eMBmfH769koR2yUVQIB/Km+OFMjyAts4NSd+fyQJgE1FRWdNps8k36ENk4EVA67kKBMpEPKKX2X4W9MZEcyYi/nBcb13fpr6QVwnjL4w84MQCA5duTwxM5rk9086UQrxxH59jvU8GlgveeL/FDz8ENTrIhckv7kVzUUF3OxTujrYjpl7ErbX4qA1CdyBa34nPBnvLnxuWC0NlcHKNIrcGYL71oyK6qffmh55BNMaB5A/x/e+Ucs6J6asFbQaMCqkH2oAFE2N5QDaIOXeqJVjmS+zDJcj9UQNGL0y7Pxm3/5dZKVt9ld/gRDZ2qoYrb4UDlZAR691pdzD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use LZ4_decompress_safe_usingDict() in lz4_decompress() and drop the
per-CPU dstrm allocation.  Store the compression workspace directly
in ctx->context.

Using vmalloc(LZ4_MEM_COMPRESS) instead of kzalloc() for cstrm and
dict_stream when a dictionary is configured also avoids power-of-2
page rounding (~16 KB rounded up to 32 KB), saving ~12 KB per stream.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_lz4.c | 76 ++++++--------------------------
 1 file changed, 14 insertions(+), 62 deletions(-)

diff --git a/drivers/block/zram/backend_lz4.c b/drivers/block/zram/backend_lz4.c
index 158fd8b5e8a9..5f2e27805d75 100644
--- a/drivers/block/zram/backend_lz4.c
+++ b/drivers/block/zram/backend_lz4.c
@@ -4,18 +4,10 @@
 
 #include <linux/kernel.h>
 #include <linux/lz4.h>
-#include <linux/slab.h>
 #include <linux/vmalloc.h>
 
 #include "backend_lz4.h"
 
-struct lz4_ctx {
-	void *mem;
-
-	LZ4_streamDecode_t *dstrm;
-	LZ4_stream_t *cstrm;
-};
-
 static void lz4_release_params(struct zcomp_params *params)
 {
 	LZ4_stream_t *dict_stream = params->drv_data;
@@ -24,7 +16,7 @@ static void lz4_release_params(struct zcomp_params *params)
 	if (!dict_stream)
 		return;
 
-	kfree(dict_stream);
+	vfree(dict_stream);
 }
 
 static int lz4_setup_params(struct zcomp_params *params)
@@ -42,14 +34,14 @@ static int lz4_setup_params(struct zcomp_params *params)
 	if (!params->dict || !params->dict_sz)
 		return 0;
 
-	dict_stream = kzalloc_obj(*dict_stream);
+	dict_stream = vzalloc(sizeof(*dict_stream));
 	if (!dict_stream)
 		return -ENOMEM;
 
 	ret = LZ4_loadDict(dict_stream,
 			   params->dict, params->dict_sz);
 	if (ret != params->dict_sz) {
-		kfree(dict_stream);
+		vfree(dict_stream);
 		return -EINVAL;
 	}
 	params->drv_data = dict_stream;
@@ -59,61 +51,32 @@ static int lz4_setup_params(struct zcomp_params *params)
 
 static void lz4_destroy(struct zcomp_ctx *ctx)
 {
-	struct lz4_ctx *zctx = ctx->context;
-
-	if (!zctx)
-		return;
-
-	vfree(zctx->mem);
-	kfree(zctx->dstrm);
-	kfree(zctx->cstrm);
-	kfree(zctx);
+	vfree(ctx->context);
 }
 
 static int lz4_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
-	struct lz4_ctx *zctx;
+	BUILD_BUG_ON(sizeof(LZ4_stream_t) != LZ4_MEM_COMPRESS);
 
-	zctx = kzalloc_obj(*zctx);
-	if (!zctx)
+	ctx->context = vmalloc(LZ4_MEM_COMPRESS);
+	if (!ctx->context)
 		return -ENOMEM;
-
-	ctx->context = zctx;
-	if (params->dict_sz == 0) {
-		zctx->mem = vmalloc(LZ4_MEM_COMPRESS);
-		if (!zctx->mem)
-			goto error;
-	} else {
-		zctx->dstrm = kzalloc_obj(*zctx->dstrm);
-		if (!zctx->dstrm)
-			goto error;
-
-		zctx->cstrm = kzalloc_obj(*zctx->cstrm);
-		if (!zctx->cstrm)
-			goto error;
-	}
-
 	return 0;
-
-error:
-	lz4_destroy(ctx);
-	return -ENOMEM;
 }
 
 static int lz4_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 			struct zcomp_req *req)
 {
-	struct lz4_ctx *zctx = ctx->context;
 	int ret;
 
-	if (!zctx->cstrm) {
+	if (!params->drv_data) {
 		ret = LZ4_compress_fast(req->src, req->dst, req->src_len,
 					req->dst_len, params->level,
-					zctx->mem);
+					ctx->context);
 	} else {
 		/* Cstrm needs to be reset */
-		memcpy(zctx->cstrm, params->drv_data, sizeof(*zctx->cstrm));
-		ret = LZ4_compress_fast_continue(zctx->cstrm, req->src,
+		memcpy(ctx->context, params->drv_data, sizeof(LZ4_stream_t));
+		ret = LZ4_compress_fast_continue(ctx->context, req->src,
 						 req->dst, req->src_len,
 						 req->dst_len, params->level);
 	}
@@ -126,22 +89,11 @@ static int lz4_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 static int lz4_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 			  struct zcomp_req *req)
 {
-	struct lz4_ctx *zctx = ctx->context;
 	int ret;
 
-	if (!zctx->dstrm) {
-		ret = LZ4_decompress_safe(req->src, req->dst, req->src_len,
-					  req->dst_len);
-	} else {
-		/* Dstrm needs to be reset */
-		ret = LZ4_setStreamDecode(zctx->dstrm, params->dict,
-					  params->dict_sz);
-		if (!ret)
-			return -EINVAL;
-		ret = LZ4_decompress_safe_continue(zctx->dstrm, req->src,
-						   req->dst, req->src_len,
-						   req->dst_len);
-	}
+	ret = LZ4_decompress_safe_usingDict(req->src, req->dst, req->src_len,
+					    req->dst_len, params->dict,
+					    params->dict_sz);
 	if (ret < 0)
 		return -EINVAL;
 	return 0;
-- 
2.56.0.385.gd3acb90ef8-goog


