Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8139FCC6B2D
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DE0F6B009F; Fri, 16 Oct 2026 00:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918A16B00A0; Fri, 16 Oct 2026 00:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F9E6B00A1; Fri, 16 Oct 2026 00:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51F516B009F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:44:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3C0B1C2FD2
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:51 +0000 (UTC)
X-FDA: 85327249182.20.DE239CE
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id F3E9D40002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dj3XATrF;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792125890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkV3g9p5RWCtmaVyEIk2+X1novLUQhh3QP4NEkjHPO0=;
	b=5IgFIcju3BwB5udPvY+6Xc7AfiyyFaN2ffFnlnEniuUlLuJfl3zmTVtwY4Edx90MakTsSP
	Yz9QmJTr9Ug39hqDVyqFrFFLBcbzV06BLcYVa4r733HXOXEyaCBsHiKFxNcOOr5f0sI+4l
	JhE6q3iG7eVRTNfoZDtTWhIuTQcPL3g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dj3XATrF;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792125890;
	b=lgfl16EDGaeUn44p7pd3Z+XsqTtA0eYPsDqIHcgxlN7WBIEqxayGfLxGHN/H8tYiREskJZ
	me8fgW5jJt+KoRedEO4hQ0BBy2gPnW7qkS6ES4RdNDMOwKyIij8mlPRJuhLNvS8emeLYcm
	3yMo4pv+aouReWtRDznrPZU2zBhRUZg=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e5fb79ce82so34701405ad.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792125889; x=1792730689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wkV3g9p5RWCtmaVyEIk2+X1novLUQhh3QP4NEkjHPO0=;
        b=dj3XATrFqiU5I9Wi5brm39CMHEmG5E4r9rK+LBO2npYHLiDHE4uwNLkKXYG/MrT+eY
         L2UAzhNBUW03166cNKJj6zTExoaJtIdm+yDqgeu7M19ZKhFsWhvTd68pdRF3F646k3Kb
         InWeUUrUEHSmKpbhMsFFt6QDD/LQY1bHeL4Ss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792125889; x=1792730689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wkV3g9p5RWCtmaVyEIk2+X1novLUQhh3QP4NEkjHPO0=;
        b=umjfoP8osiuZpV8hSFhmRT9q+bdaFB5WwWz68BE2zA2eVKPa/rmo4y2KnGMC4eglGF
         HnP3qyzAh9dR8TpFYFXHHa3WMMpeuuWzzPo5hpCpVrYI3zbAJmMLq8qe84wnMZLDM1dp
         FpDQVj3lDUt78fAk4aJdrg7/WSvwj0pnqDmj+KxaBLdjd/K1E3aVMzebk0vV1QSNpDID
         e2xiWrW6A2kKKR/KMl9PqB0dEpvlNcMGExxa2Ex5HKTol7ScG6GwY98Azha3MDwCN3hf
         Ad04zERJUb9vj3AEtsuXmuwkLztj+XBlx1FBkzGtkWPCCZc7nI2msFDcJO/0WP1qtMiy
         wZzg==
X-Forwarded-Encrypted: i=1; AKwUvBx7+WGnwxKzxoXAspNvQD7+P5w0OcBEYV0Q6WBZhMiYCvXCisK0gFeAAdNoaqetn02ky/jrDrA8tw==@kvack.org
X-Gm-Message-State: AFq9FYJVaMMAkDcGG4sMS1+lXn0Z81vJMjGisAFwmwNI6oVRHlOg93nX
	OTOoKxJS4uarRqAAs263T7SFXp9sxvviIYe6JcvsnbTW3dCBhvZJhZBV28I1s4lHxw==
X-Gm-Gg: AYBFou1XHR06IzMm1cm6iiPnO+EzPA9kUsSz42a08Qi7SzwzYmt+8+05CYqTbNl9V59
	iQhC5bARbY3o+EtjyoyzJkl9DJ8Lh+0s7frQz/iGLyjb8Zs7oFpxbAd+MIv4anDkS/QxZuYM/Di
	Z7Mvh7AaBA3j488Rife0gBf95ud9Bx0qNj0sy3m4pNr6fVv73dNNllG6ETkkbJX5vFEJ3V8b7/U
	sOg8K1Yew1vCBcwsh0hIPqxCRB24jeaExM0CMqAbKW7OTFBtUtS17SNISgLb4MtclBV6xG4nYmv
	KSxvIpXRtfUJQ6nMGzXJ7eE3rlNNIp3F4OakTcUXxceCkKr2Cci53iznPo4aOt1mKPemAhrIR5i
	YmztslkT5iwIUYAiSCSHFJYonkQIDjlGnV5YdMNH3pG1LjyTPQvsKsB0LPhN9TprzrhRloZ6C5x
	19Ms11c6Ddu9kSpwKVU8wtk1opxNebEOtCGRVSuNQvnpxLWjaLXtILJVUT/ocyB+P0yg7eKbgSl
	xgj93WaTNAJMHy5+ab75YAkIA6BHbCt/L2DhiCMnxteivl9StdjU+eW94mipGo=
X-Received: by 2002:a17:902:fd8c:b0:2d6:f6ba:263d with SMTP id d9443c01a7336-2e948deee77mr60342135ad.7.1792125888837;
        Thu, 15 Oct 2026 21:44:48 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:a579:8b87:8304:7ac2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e8b1b5esm4137235ad.67.2026.10.15.21.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:44:48 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v4 05/12] zram: lz4: use LZ4_decompress_safe_usingDict()
Date: Fri, 16 Oct 2026 13:44:10 +0900
Message-ID: <20261016044429.1304561-6-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261016044429.1304561-1-senozhatsky@chromium.org>
References: <20261016044429.1304561-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: famgewouhau6nyy4h68gy9cy818jkrfy
X-Rspam-User: 
X-Rspamd-Queue-Id: F3E9D40002
X-Rspamd-Server: rspam08
X-HE-Tag: 1792125889-902734
X-HE-Meta: U2FsdGVkX1+lu5tM1B2qXUuneubqi7vhxT3Eo5/r/gGdTXxa0cD006rUbR5UY2saViQSQIX6vgwymvwTUi5Ry/kiVcdy+JjkNOpnaZSwsE5iYTDdKHPyO2h0HD3YEU8FHCccVAw1PpW+1JFWG+k4E+XexivBnreIjcClr4LtNE/4mlGLMc0v8tH2ZvFMFTG+0392ZPzS4A0ss8IHqiAhFV7sOP7j2NoIMhuCqwt1Wjl6eaE4JCUjF6Tzy1EqHk5dcT8JtfiEjv9fEIvCKYpVMEAMao6Mo4gZrjQSdhNmIDPRVNhfGkx3Yd8BxIhUDR2vH2lg5s7yk9Eh/xCJK3p1J4C5aAC5UCoV91o+g9taOIMonfUysIYufOUHqCcvGfEH2R96BSyDJ4xv7jWdxsxib8Iv6GUIKA1m6zG07l7JQYEOMNkHVUWz3dIP99vY3iX9yxxovRJZyeQHrkCn3UObEIxhcYGSmYHVMUzir55JWrJWiSsPt12EE3yE+Ayw+DiNvRO3cH9YE8GGMEkOU8ZPijurZ5FUBothrOtz7cYjJOlX4DISoOLaHXudjFj87DU4nbfccKPmnyHhFgpyRR3TotqfDt73MHqYSUSCj0QjRZzbBg+2egIYUhvgsG8Z4CWQpvUOOc7BgcOeqrThq63m2ZQP6nU6r8FBEOvXu1HvoSBBjx3ToUWIpx5jHBbRzwL4MlskmzLCMqtmSyyX8yTzY7qBz08LptbQK42XQUx6yhUcLEVZjHWqcZskK5epu9gfLaWCoJQAjzqpSL4TVni7SaEIHfwyu94RmzVTVNj+zqGqrPGA22v7e/xXhiJESkNwVQwLiYpjBF34tAz0T8pwvH68PrWNUrruChGM7vs1KbYZE+Oca5CYOtO0PeVTdaocPpM+H96VPPMXiE5bxa3WfxdggN0rvmIwKN70MVfAsJ/rB1o5601pjEbJCfY9I37ivoiZiA4onFVopSoeJZy
 x1FHz5pT
 Gj+P5jAfHuy7KSqUQkcM9i/HDk6JM0K8oOboNCB+zyjytAYaJIc68tSdh0/G1Ra50FDNrt7t4J4YSaEzJzAh0jnhpVK8UoOCbU1H3yT9Qiw49PShNLPmbNTU5JqL+c3X9gtdfwqCUVMaNXhkc+Lq8CvJF+8BqepqpXK6Q9BpHER5te2dlf5gAZdXC+ph20FiGfwFf38OoXov6UVzqpLSfAffK2EimyF5jwdbq9Wa9gid+VLUvrlGS88sHWNL//O2XN5FGa91gasjq6eUDmsWQLe/jQ9iIq0ziAYvyBOEF20OSruK7tbBqJ2EUbvuuX+Rkim1pw6dp1hQGqzA3L1q0b5DgBeYQy/ZqcjN6
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
2.56.0.176.g3575e65682-goog


