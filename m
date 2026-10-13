Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B02CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A079E6B0099; Mon, 12 Oct 2026 23:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8276B009B; Mon, 12 Oct 2026 23:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8136B009D; Mon, 12 Oct 2026 23:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55C306B0099
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:52:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF6C81C4718
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:25 +0000 (UTC)
X-FDA: 85316230650.04.CA6C0F0
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0C0BE140003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ki5JfI2G;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791863544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fG+ZRnn0wXsUMGdIWlrdX9yA9C4/sFFG7BBKDHx8FEs=;
	b=RS3RK2bNvNDcX1Xv+0qoum4ZXnAnt2YpyCcxVaxUD9CTgBRRO/zT6sX8nUbMz1045CCzEU
	4+qqjrXkPFh0P5y/5DP7tXEtRCcI2GQKLXLogMGCLW+M/ashWDr/ZJ+ncMtuO0GoWuwtow
	U8wXuonijDewdmCe027Lvj3xNla1faw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ki5JfI2G;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791863544;
	b=FhFVy0W0gNXo+602wmdV/xjNTRa4txeC/zJS0oHhh6BiFElM1WuXOn2ge3RiV7IjhZgSWq
	DEbaT7BQOVWN9qS1pZld4WakxMjKYH/VMF6dVBy3BSlP4Tg8UBGhgbM4sZ6yLb9rq2r++r
	jxPhE72pVC9NJ8PtJl20AM6n+FmpyRA=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-887a58523e6so586834b3a.3
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791863543; x=1792468343; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fG+ZRnn0wXsUMGdIWlrdX9yA9C4/sFFG7BBKDHx8FEs=;
        b=ki5JfI2GATI78BBsOuoZAmSEpbjpveaU8u6Js7xaGN/Z6VLfaNGoMFOK7pS63wmF4P
         Nse4oNSA9B14SCc6u1YeSF3tmmM4NCM2mJCkGjD5pXcLyw3sDfbnbn28OY8FRvcKDlAG
         J0mbfLIQKTYJlpEQCxmsOp6lyVueu0HImPDhI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791863543; x=1792468343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fG+ZRnn0wXsUMGdIWlrdX9yA9C4/sFFG7BBKDHx8FEs=;
        b=ITmUWHfRqn5xwHxWImfzNixA5ptZfdWvClGTC0sOpp99aGUb5999LRVZyX3zuDKt+Q
         TtcB1wmyuBWMnM27AJzOUq3fK5BfstaHJiEqJ+wxaCry5MJUfbsc4w1PaFjLn86x2a/n
         5PJ435WwrOIKa+GXYoYTGbP3UZUNMFiT2kxAGjJLv+2/AAGZr9euXARLrQt/7xdVygez
         ocRb8GzRDeefeCLVxDtPjZ3PE1hrshN1hZfj3jQutLZE1gPfLjeYCKAGVr2SKnezdKyr
         30eIWM8lO9w8EkPliEyTfciM4YyDPQ1V4CqpzJTfKRIjVybPycAGF040wR1q5KwI9NMK
         6e/A==
X-Forwarded-Encrypted: i=1; AKwUvBwAvgdwzowbQNk30dmjMl77pPrIisggapLu8aOU2GFcoCSYnc1e/w7ypii/+39dmrB7pS3YJbq7Kw==@kvack.org
X-Gm-Message-State: AFq9FYIg7XlwF8dPxty2SrNldpj1n58g/z9Fpb9PUg9i/ZKiblu+0eby
	2FtlzJ8AeqC22Hp/r2XOZTvJGX2BCX5OWtF0xoX4UUQSBhnty64rqO8XcFtE8aBuqg==
X-Gm-Gg: AYBFou0w2m0vSpWmN1c3uu2OHwRpcNm808AilftFuzxZUm6RbcQeIQgR2AcpU+21e1n
	pHFycuU9+gx+wmalnALniBVClDQ8RBVwK+0/mU3xp+ShflNA8+yJh7lugBL8YY6Qvp4qv22HyhK
	YqN9aej9nh4igGDM/GwMVe3gGzznJQ/qRNqm5EZ82ux4t4hkCoJBhSZ1+3+clMPuqD0S/p+bi9e
	AxgdV2PlT6sAFKp+JX6oajsNAxWtmT6D4hZcMhy5u1lILoaZKuhWj/v0CJ+R8d6ajBFpQbGsfCB
	XH0Qxby6Dtp2QQ4N42dzE5PusiX6Ft71u1L1BrxGIcnjynm2NJeGrb+SUA6Wbl3LlqkK8TeiKtv
	dtu4I2PseOOxzm5iIZQ5d8/h8jELf5LII6IKRAv+uAx1nt7RYxOupO8nZrfgohhjo7lLYjbxFSk
	wdmcoinXb0JrStpBt33LdY7yDM9HLnW2yKfPmOwC6NdvlNllWbCB7LZEvlYZhPejs3z0gk6Ne56
	3lBrVfM6NIEzI2wqeQCJFtuypUTyDsDvzzEecRHIRSp5dGS8RZoZBWLGuPfAw==
X-Received: by 2002:a05:6a00:1591:b0:898:e7e7:c0df with SMTP id d2e1a72fcca58-898e7e7c34fmr5110419b3a.45.1791863542893;
        Mon, 12 Oct 2026 20:52:22 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:476:d384:7c2e:1579])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c41bbb27sm4326818b3a.40.2026.10.12.20.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 20:52:22 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 05/11] zram: lz4: use LZ4_decompress_safe_usingDict()
Date: Tue, 13 Oct 2026 12:50:52 +0900
Message-ID: <20261013035201.2809924-6-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261013035201.2809924-1-senozhatsky@chromium.org>
References: <20261013035201.2809924-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0C0BE140003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 4exmyzpdt561yyttwa5finducau71f3m
X-HE-Tag: 1791863543-654964
X-HE-Meta: U2FsdGVkX19cokUKUPeATDfYQtbYf1OiZwlctpsaRJ+WsCRUVW1mfWH++CHPjwfQtiAowB4xi9pH+FU5cDY26bo5+7YDIMawTuzRERjDbgIuJJ8u6MkL1Hvh+E3FAaVnFTfXugioIlOWBTQ+dD6gNMtGWb//O3AuX0LnVrxVgoudDjTPA5iTJhlxu/taEpOyMx1UGCMNATKxlsSe9S6zdLJfHQrYYP91OEGl9oOujQcSg1LudsU+H5etxtIgCCtln4HOLK8OpGU1Mv7skysMiycng+j4o8Ad5lOiE0IGRAFIvodM+XfrKiGz50LBE+XI+xvdgtU+vQi4d/85pPBBnjamQi80b7yLY9ID8Cti2B6bnEwLuciRNNlcQ/ukctN8asj4kUCfPOOrxBzBdMoL8NLw8i93/iPlOPXZqxPrKCsdmCIJ084lpEACchi2xXJbOzr8jRJNWNSV13X5Rnybk3X3AtZPJSh5cpNAoPPYrCZDoqbl7mqT+OdhTmKfbYfud886h6EuD1PaiBzc+UN3y/2eMbleSyoj7DS0c2sOLD6/tDPRPS1PiJ0MftdNPIT2QCAfPiBKSlb5HT5N1SFGV51vYYztOFp8AxqaKgt/1/mCkNCiy7DUl+1AncKsXxCYQRzdoxvIWfk3QSIzRzJsb2X3f8IeqyOiLkk0Z+yXy+n2wrMR8o+IUpg1W3eVZnW3G+BhBzSb4ZgqQItmNWr7KjxZX80gcqURCiPVIcWXXDnu7ArBCk5Llq/bC3p/5H+m62s1jjU775YcRkerbhtPh9IBao52y6b27Xy6FOybmBzcWsqlFgFmVNMuhFjNbTdl7DxKpoxmP043JJp/bRfVIFPhGxlgyeI+OuRewP872YLFP1WiXQSYUTeTt1VA+ZRHWr212Q7ghrA+5q0zrtnrOtCOseur978MEzaS4C5wmbXxOK/nAjbKP/UqZYkLiewFbodnlTKMNeK/XOsZ5p5
 FjYG8R8Q
 BQ33Oxqi3i46/cA8y4sHWpsmGMeeLCQd5QyPn23e2o9I1GjEmGLL61dv7biSUeo5k5+CAmgemoaeV/Bl5xiaLkYGvfKltHaqdRv9AJqqOa7AqtqplcNxxdeyY6YyqU+uJx54zpPyA2bUEPBOJs5B4dUGi0qtQjoOTqDOPJqZILfbnS4oqgqDSo+xun21sbHB1yW9o/fJoIYKmaZYJ6f+/MAsbtyFmSkqYbkWWinYFU4S6TggoRpuknOizaojx64hYkgRlojKJ9boWwmOipE/kxDy4O5VBhNlaQO/idf6KVPdr3Qdb1mgb8E+KOtLmvM3x7u88eiHo2UBlIcBfdLl5Ko0EYqVjA5igM/wq
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


