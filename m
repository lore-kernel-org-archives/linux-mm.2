Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A46BCCA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 206386B009D; Mon,  5 Oct 2026 08:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8B16B009E; Mon,  5 Oct 2026 08:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 032036B009F; Mon,  5 Oct 2026 08:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C44656B009D
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:21:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59990A6591
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:14 +0000 (UTC)
X-FDA: 85288482468.04.38E6D10
Received: from mail-pj2-f39.google.com (mail-pj2-f39.google.com [74.125.227.167])
	by imf04.hostedemail.com (Postfix) with ESMTP id 819D04000A
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=c31V7wm9;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.227.167 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791202872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OB0Ke2pkLbNFMV5pwqdAyoJ0c624yqq8WhN8H7vs2D4=;
	b=NnZPBRgTnRGnTK0MTr8orB25Rt5hr3ABOuJQy1uihHzZiOkn4AJZRWXL4xAGyRGyQnmx5k
	VX1YGexfShtieRywTjqrjG4lanSZn4GhjIdaAQWqpwZHsjERNTFocJxvlyV6lzmQ/j7aJK
	18Mtr3qzeyEXARb2irXPxnDUEzG1/aw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=c31V7wm9;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.227.167 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791202872;
	b=QCZJpkADKgI5BSQKS6YKiPReOLwwkXDGPVkPW0gMg4HDyQmGrNq4A82AyeLBm1orFx/6Hv
	M0YSiHsq9aR8d779lTfkv2NVkHIfgRexO/g4vRNwIhxbZDENIMQgfEqOPAbpMZ+m8ayRFh
	4oTUs3LKUiSEyutFR+FJFyOvObsSMA4=
Received: by mail-pj2-f39.google.com with SMTP id 98e67ed59e1d1-3a49896dd9dso402751a91.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 05:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791202871; x=1791807671; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OB0Ke2pkLbNFMV5pwqdAyoJ0c624yqq8WhN8H7vs2D4=;
        b=c31V7wm90nOq7thPmSSmkJcCcSBMH6tfZhvInnqz9AB+OtOzOrbXdK2WO/X8Z8sNrb
         Ymk7VwlxnPpUlLrFFAHiLKNCsDE4dmAn11Yo53swuUHy6SW1AbHCU9mz/vRHJx3B0FMu
         YQlX6Od0TIO5xrnwg64Lifw8U8C2lSrH51sM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791202871; x=1791807671;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OB0Ke2pkLbNFMV5pwqdAyoJ0c624yqq8WhN8H7vs2D4=;
        b=QWK6+WyGNbrb5Yj2zgqRtEKCXuGheVM/JVmNcAh1l1Oj5gvGBFqhSzHBhhEZaJr6hO
         rA3ild5t6oXB6RLIvvxENWIdNJ3v3xLkpyOmMEE92G5SA2SE0MiR/0gZlyXzNcxww58i
         TVoDj2g6tpNt1AbqmtRkTp9QPF4IxmUsyCFMzuzg4Lu0f1IekmZIcdDOihrcfUa//Rd5
         qJKXzZd4TLxjr2ZISZkFKhXTKr2Z8dRRiGQDJdOxxklO2CKTI4pcnSaGI3vnI5DCyMqd
         mRfMFMYWgzFtLYfQWsENu1RxmgQD8semWr9eZatI/fPfi0E4WGi2ek8lIKfSP2oLMIyn
         9ysg==
X-Forwarded-Encrypted: i=1; AKwUvBwwFJnS0sV4brM/6qGZ+Cx/tl3sJ6y5yal3ZhvKsKM5jnlfu880ehriHwZzWjFBfuc1+tuHI1jbVQ==@kvack.org
X-Gm-Message-State: AFq9FYL+9OA+Yaw9fptWgRBSoYG7kTmgAdyFdT7OTo7Hq6KGiHGs7K7n
	m2xjmYnV7G3W5Pu/cQ5cHKivUAQShyl5OBVFMlYNpKjIfkFgcroTN9PmHzjLZhVIWw==
X-Gm-Gg: AYBFou1Gz4q9FCoHrscbjMwYwEVazQhvNZoLwrCHzW5EemUR1yJ5NmRQNVw0kkzMtpI
	TJz8SUAOoH1/WPqMC5e7EHhSbVcRJ6MWJYYjQm2sEkzBOXSL/Sl1HKtup7pyr1RmkOleR6+ubwG
	pZHAw/txN/Cb1eqqzRwZX3ZaHahGnqrlrwmBhaajSSyb5QAkrSmbG6XczGGPFYPIOKxWKVerOp+
	cVC+xqolNiRvklUZSJrFLKP4YrdCMPcjvvyPFiotOkVuRu3jsxP+4spX32o50sptfYjzmk+qo7r
	oG3MDTbBTgrx2V2r1eq1Q5bbvalWUhjqYaDJwhVYTrgY5kZArHlBvRBvWPcJkzZzyDkBxBSxUrW
	GCV7nkDfAPsNKEYBUPGyYamtl/dHNDlkYZn759BkP+yKtRUN0sTcJqfAAJ4ud78G3A9EYyfWsCx
	DQl6m7nh3Xgg0gFXg+mVc3o8U4nUITgqXxPpapiciOf7OYlNT4VP4YmWps+1mQ3Ti07fwY2CO5R
	w0SKLTp+2Isv8DPYcTV8CfplL8RNLEybX5eF3XXVxRqMfoR0wddD7r8dAYEGuow
X-Received: by 2002:a17:90b:2584:b0:39e:3d38:7ef1 with SMTP id 98e67ed59e1d1-3a6ce97f214mr4355728a91.10.1791202871230;
        Mon, 05 Oct 2026 05:21:11 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9211:ddf0:3c6a:bf9e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7e4b00de6sm3342997a91.1.2026.10.05.05.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 05:21:10 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 05/10] zram: lz4: use LZ4_decompress_safe_usingDict()
Date: Mon,  5 Oct 2026 21:20:20 +0900
Message-ID: <20261005122036.718976-6-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <20261005122036.718976-1-senozhatsky@chromium.org>
References: <20261005122036.718976-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 819D04000A
X-Stat-Signature: 51uorh9y1f5ycirnh1r4653edc4hzczg
X-HE-Tag: 1791202872-569524
X-HE-Meta: U2FsdGVkX19d6h0I2w4ZhK85p591CKzVz7wwM4wI3R41RrL6f23bgZ/Jfx/MkrgizfX9AXhkVvELViJvM0///vYpah8yp9ToFjUcJzznpUOgHWjAjli5qWTn3dVLZs2UI2UkegGffy4SIji8CLvmcx0v2JPGv0zUrqOTsylX7+WB9+ocVkX7eF+VwAcwDcxISVU4TD4J2O1KfSZqxASfB/MU0vX4EcnlGNf4I29IaPlqt5fNyZLgk7KDrH55Ynyrk7N5v+RqAxlhXQnsJYAznErWzCiB21IXSKXwjPUTRf6V4M8ZbD//IrGRqi9jkmTLbQ60NqNSl6lfJ34cy90Dj6CKgvxphNYC/+FxcWi/BPNuqNNo7e6fuv7Qt3naFRSkqfwF/MC0AchDkh3b68bMPjjhjJKNLOKPBIIoaaxuDwsqf39NwdZqdejkmtFyt6bXGRP1k/9HY3R81K38Gpuy2lq5dhOa0llS61SjSikIsgNJa7LwH2ErVEtmPrn4xCUzwSKHioSDHQlBqncq4P3lJIpGZwNR83yseObKJdmaD4Qjt2a1TmyphFLUg0ykqCIfhNK84dQ13bNQifLfEO8RWaJs1Wjkv6Ky9yajYSBvy6KFwMwEMKdg7+C/6IymhoG/YejhAgKeebO3zNBmMs4E7NJUoxHjKFruCy2a6ZiSMDMMXg+F78SvwfCwUDfR+BqK8ATm803FUaqWz8kI99ek1fWzze6v/844vM4+HPUkjS/pJUmBjY1Grf32lzC/qgC7+pVUEXV8X5KEHdmFSvKP5Nnztt6yNgYKOYD9gJUFEX1xQDJv7Nt3aT/CQuSFwpcW+dzA3yKI/zl1wU7l0Srs7IM1zQmPABXFVLJv55w5cKkeSguDzJHRT52CzCuYjCBvUz2LbtVs61mU2++14V99V4PRwf07rYRWylnl0jUpVkuWujFWP8tbeh9zDOxFd9O+EuoDpO9XULkRhcPY0Tv
 o+m816bQ
 Nz1wha6YTNvVVN0+SqTlC1YR2vXz7Uu0RAA60bPkxrg8/Xg71XcWMYXwaHnZuVyv0SkGnHYZQpA8K/r+cSu7pOkK0XnOLgpzi3/ywB3r7ycpqBmuIzeEzK6K/F6TMEUSBIdOrc01/WH71UeFG8Y2bK0zeFsa66QEVJb3RfP9wiEuY6C1JoGyqFNpQwBkuVrH6MVKeXOoSdluULCBckP43e3VsbSftVpkMYheaMaXfubYuioNd+NRGU/RDYyVSiZe9u5XUNkRT+pVaEqufKdhdzZmkeTMaiveeOz2lxfQiCrhpcgQyTiQ0jzodZox/J7zodU4/d7fSWuqCJC9mQMtILvzae/fVnPJ5eWrK
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
2.56.0.rc1.315.gc6ed9934b7-goog


