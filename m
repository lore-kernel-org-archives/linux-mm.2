Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BC46CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9FEB6B009D; Mon, 12 Oct 2026 23:52:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50E56B009E; Mon, 12 Oct 2026 23:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B185A6B009F; Mon, 12 Oct 2026 23:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 791F86B009D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:52:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DEAEA120AEF
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:28 +0000 (UTC)
X-FDA: 85316230776.08.A08CE1A
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1FDB5100006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LzCxUaYD;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791863547;
	b=zpPXaKTCyd4FKNZ9/R+ON+PzN0+IqGz8y3bdx+gCVukm+smupXtnYHVsECZlX07dC6TqiW
	PdbUf9R/6kfSUn0EjgtKwbF0ThYUIYIP4pYbNVaxS9Z+1Q3FkmYN3igea4iTWeVlTpP7SY
	cXPOmzIVbpd5/C/ccukh9VmXpirBaX0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LzCxUaYD;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791863547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vDwGnfli5YECfAaBIHPOmEI8frIPb+i30TwuUetq8U=;
	b=CPmy0KBu2qG8m5s4501DT5t7GkF0cFwThaoxcOk/gMUcq8i9pcQbyJ/D0kSyZ/ksbRlbc2
	zdYmbmIZJpB/4whQJA0OiufSo8iIaSd25BgdE/9Ne6QnfbUGWg2tMN7N6eMRsHosIz1tEJ
	KMa0zzgK3MX34siOvMFvKmoN7XS21p4=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-878b44611ffso1573012b3a.3
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791863546; x=1792468346; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2vDwGnfli5YECfAaBIHPOmEI8frIPb+i30TwuUetq8U=;
        b=LzCxUaYDJr2VwUoTOoEONRkZ38wVauGRx/8TGbwzX3d+UQEfLBh7lYFvoSwpEQoQi/
         F6I0hwS6VwwFQzH8uLYM1U51irdarg1Z4e5JGnDay8DKE5k6Uo+uFC2BreOaPjFW8+Wd
         oVM+KXoA5/Ms2IQZetMvLGz3jdwxrYqJufcV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791863546; x=1792468346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2vDwGnfli5YECfAaBIHPOmEI8frIPb+i30TwuUetq8U=;
        b=HqtEUBvLiQ/bBX8bie0kIYaZ3cK5upI82YoxuiwNbYlDxzJRnrIJsz6ia9Rar1/EfR
         kZBB6RBwl3yu9uMT9EDsczBjlw5KnoSQVC6pibIznF+ObFIkEFeFLjIjA4wU7uIkfmzf
         ZSnPcSzgM91VMxaihJWAztjIteMftDbRB6XhhE+aOwdgcQy/r05Ciz7e7RICJ777/oIW
         3nVEDR+2IgKpsj9dXQrcqjX3yjH0tTOSr52kVVuA7yngWm4krE5nI+tjvUNHHUg+T6gp
         D0HECkgArfK/JEd/JlLDgbatku2RLo85fzgDVlLOJ47fWpWcnn7NQdK8BHKyoiEUAaA8
         8Lew==
X-Forwarded-Encrypted: i=1; AKwUvBxKXHeLhNcOtohyJL0cM6ekxupH9m2jsZ3kRfrdk0yd8ZCah+fvPZUPg0uiL5DJCpSmyqzkhSW/8Q==@kvack.org
X-Gm-Message-State: AFq9FYJz+jnuZQXfGYp0iqKS3Pjl+5UTzdIPhVj/ZdF9xzx6P+yAmZhW
	wqCu2e1s3riCBz0n+ZjccT1VV0BDPNaI9adsgEP4mJKSAWgPM1y9tlV4f7TBNfgmyQ==
X-Gm-Gg: AYBFou3kKGncnBv3ofvuuL3x+N1egDt3CjirFj5T+9inHHZHjCuAO6vhdU0S+xYbENw
	DCsA28QqFX04Ekd4Cbi4xz97wTsFqifUGCD8YpGrNg7eG3hYV3PJQTZAH6RWeS/EGIjEbF3u15M
	WULAg0bzM50dlM3XsVF9JNk95FBRYMY4HjxfXUkOJwxCmb6BlIBetjPhnhyWV3R+xD9Y0C4XoIo
	emvw2oekRwuPfWXLoy4cG+lCqP+4BQ1vxP6wLWq44KIqS3lHHIKpidaGl5St+CT2uhbKC9Jfqe5
	drBWwlzDQ8oUeiEsU9o5EHHt08I0HSzOOcIs7c6a8uETp5z792SgLQt2rV2YBFzWamgJ1jVNxhw
	Cve/rUoMYkAnmq95udIeQ8b/+VN+taet/VBwA3CLXHdCTXbJNocB2lhjgNrGNKUixcXxzAWUVUI
	gs8pzp5UNIISpyJhVNLPkPolFnbETJF/FJ852EHiBiGrbGMNpqCiRV0qZl4eNELju/mbyhkjvVJ
	SWlx6Jkh2awr0K6mKp3lQadTeuIgcFPds4qGfbr8jTxmxui+liLvFyowj+pWYpL8SauuReZ
X-Received: by 2002:a05:6a00:2181:b0:893:8a6:3801 with SMTP id d2e1a72fcca58-897c6c24863mr9821862b3a.24.1791863545329;
        Mon, 12 Oct 2026 20:52:25 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:476:d384:7c2e:1579])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c41bbb27sm4326818b3a.40.2026.10.12.20.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 20:52:24 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 06/11] zram: lz4hc: use LZ4_decompress_safe_usingDict()
Date: Tue, 13 Oct 2026 12:50:53 +0900
Message-ID: <20261013035201.2809924-7-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261013035201.2809924-1-senozhatsky@chromium.org>
References: <20261013035201.2809924-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1FDB5100006
X-Stat-Signature: 1mpqyme1tkywiftg9mkz4cwgmee4e788
X-HE-Tag: 1791863546-562026
X-HE-Meta: U2FsdGVkX1/yC88j/4kLGVHQ9++iaoTiOHKWDNeNuWwBKNIwtWQJMD4g5NCP/kbwHG7I4ySp+KaB0xgi6995bQxQMWBF1ogqPObQZJHQLFMXoXsAOJYSRq+0NdNApFLpoxb8JLFLsCUQb8QbGDOhBbmGkEKT+7bkcgDAB++QMiDD1uVoTDnKC0zXX02Y5YDktwlzCutS1yO5nZvjlx53omZx+2HYr1LkQKtMenkRm4d8SCmYr/QLAnLkvulRixeI33cf8cv5Hk3tKACMvQ64DnZcbDCjB8KNWDDzSpp/lHGX/3t9hhey9AB5B//Bf+RTpd6mRsykMi+bo0y7WJFT39ofOX8qcxqkedl6Qhh7OfyJlZRKqwJNrPV+fR+9+TyC1pOcQ3Uz2rs0VsBEtRQ94YOC1rQzWyx5XeGL9JRRVRDxMHaDCKq1NXuOtQT/y+tXZjU5CMRxOuSaQATgOcWONrIM0W/Zgk48oRPwcjRIFrovEV52iitP8B5jqHyGHnENomY3HDLRQez/Ga9WHd5bD1wZhAGYo2fqZP6mxIFVhOgPzNub0shT6LZM2+WhCPEpw4S3LrAO2A2GTeE2FCJmwI/G6jGUlJ5gemjiFvVkgdtNJTssitykUmwbnIGKOXowEV0tHPea+UL4Mren2YZXa1uegzlwhG30pr4Qi9bav9qKos0xwGjuv+22DR3FEGpzQtr0zVzEYNDvVXNLkF0tq9hRoCbIXpGzOoaN9pQGRYcFrIWWmDWGL5LOEJm0HJETL/nbGaCtF3hksZYq4K4Nt5gWlz5rZEIONK/2uQxSmc68fl7RbqqUVbiNqwjl8b5y5G03i7ZMav6DTjSfe6uPagIHHoFR+OBm1OMdHJgHmHBO2kse78BRBt7LAmlKheClBL6qGklvX8ETjE344gqpmjVVInR38+GRq/RvZOY24A8SNf5RbEF4N2SRv9NkPzF5o0jjtMZUcQTaBtst9Vc
 1SVk8zX0
 7rhJ6A8G02qJD0bfUQyos16OyoY12L2stbGeUYryrDNYer6mvJfzwfjU+A60vUSdoKoTRlnyaYxc5lTas3hbKy8F2EwlBSfI/LdDWZoeaLMIUnc/CuQT7CARXOzjhw5mHRKY+j+jw7gXUcDNhyWaPFng6DX6y0uRClIHmosNyMThzESoQPwZHMPqSE0/EVZqvkmxGMXR63rXU3lqN2EaTYxGyy1KaQaW1m/+TnTWpg35ekX0+3G0g1NZ4fwdwTNe8T3NJU6nxGdnrumHPxiNKuA0XBetHMYgqEQr0yuTidcsou/OfsaK/Rwo8jI6zST2w3rRu9BLKumDc6Rv21r3PrmRUHPxV9NXRZVpFPh/L6DvmHAGGuamdGgsWpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use LZ4_decompress_safe_usingDict() in lz4hc_decompress() so we don't
need per-CPU LZ4_streamDecode_t anymore.  This also lets us drop
struct lz4hc_ctx and keep compression workspace in ctx->context, just
like backend_lz4 does.

Using vmalloc(LZ4HC_MEM_COMPRESS) instead of kzalloc() for cstrm when a
dictionary is configured also avoids power-of-2 page rounding (~256 KB
rounded up to 512 KB), saving ~252 KB per CPU.

Acked-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_lz4hc.c | 70 +++++-------------------------
 1 file changed, 11 insertions(+), 59 deletions(-)

diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
index f3656c27af21..b62736b26622 100644
--- a/drivers/block/zram/backend_lz4hc.c
+++ b/drivers/block/zram/backend_lz4hc.c
@@ -4,18 +4,10 @@
 
 #include <linux/kernel.h>
 #include <linux/lz4.h>
-#include <linux/slab.h>
 #include <linux/vmalloc.h>
 
 #include "backend_lz4hc.h"
 
-struct lz4hc_ctx {
-	void *mem;
-
-	LZ4_streamDecode_t *dstrm;
-	LZ4_streamHC_t *cstrm;
-};
-
 static void lz4hc_release_params(struct zcomp_params *params)
 {
 	LZ4_streamHC_t *dict_stream = params->drv_data;
@@ -65,61 +57,32 @@ static int lz4hc_setup_params(struct zcomp_params *params)
 
 static void lz4hc_destroy(struct zcomp_ctx *ctx)
 {
-	struct lz4hc_ctx *zctx = ctx->context;
-
-	if (!zctx)
-		return;
-
-	kfree(zctx->dstrm);
-	kfree(zctx->cstrm);
-	vfree(zctx->mem);
-	kfree(zctx);
+	vfree(ctx->context);
 }
 
 static int lz4hc_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
-	struct lz4hc_ctx *zctx;
+	BUILD_BUG_ON(sizeof(LZ4_streamHC_t) != LZ4HC_MEM_COMPRESS);
 
-	zctx = kzalloc_obj(*zctx);
-	if (!zctx)
+	ctx->context = vmalloc(LZ4HC_MEM_COMPRESS);
+	if (!ctx->context)
 		return -ENOMEM;
-
-	ctx->context = zctx;
-	if (params->dict_sz == 0) {
-		zctx->mem = vmalloc(LZ4HC_MEM_COMPRESS);
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
-	lz4hc_destroy(ctx);
-	return -EINVAL;
 }
 
 static int lz4hc_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 			  struct zcomp_req *req)
 {
-	struct lz4hc_ctx *zctx = ctx->context;
 	int ret;
 
-	if (!zctx->cstrm) {
+	if (!params->drv_data) {
 		ret = LZ4_compress_HC(req->src, req->dst, req->src_len,
 				      req->dst_len, params->level,
-				      zctx->mem);
+				      ctx->context);
 	} else {
 		/* Cstrm needs to be reset */
-		memcpy(zctx->cstrm, params->drv_data, sizeof(*zctx->cstrm));
-		ret = LZ4_compress_HC_continue(zctx->cstrm, req->src, req->dst,
+		memcpy(ctx->context, params->drv_data, sizeof(LZ4_streamHC_t));
+		ret = LZ4_compress_HC_continue(ctx->context, req->src, req->dst,
 					       req->src_len, req->dst_len);
 	}
 	if (!ret)
@@ -131,22 +94,11 @@ static int lz4hc_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 static int lz4hc_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 			    struct zcomp_req *req)
 {
-	struct lz4hc_ctx *zctx = ctx->context;
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


