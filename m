Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E99DCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B206B00A0; Fri, 16 Oct 2026 00:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E43B6B00A1; Fri, 16 Oct 2026 00:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA296B00A2; Fri, 16 Oct 2026 00:44:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E52A76B00A0
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:44:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F228140298
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:56 +0000 (UTC)
X-FDA: 85327249392.26.97D4BBE
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85D7B140002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=c8sV+9J2;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792125894;
	b=Yuhjd1vr/K9SczoA/4cQzo0MqYKwy5WemB2vYliz7Ea9Bc1OST4Rl03707co10jG51QPOf
	GncAEmdAk0IujQPWkqQQG6vGkz7sl/tOUkPlPMBtVRrTOVXTzu+3YVZbLNqdR3SksQgJ4H
	yWPvSPQiSC1lhQmrdcSrafql5VTebCY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=c8sV+9J2;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792125894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXRdAMjjFZfXtnEnr4dqDWWhcOJ/4Lnn/GYCEcpDeYg=;
	b=Hj0vKevmZKGc9ns+lIk7Fl4RUJIKYlgXByO+AmxH5Ywa9eLWRhC5jDOGhRS6YaQ+hsqcO8
	LjOJyWwpz1X2ESA+2WneYhzi6rPDLoudPErZni4u3WOoY3qoN/amiYxBwH/K4t+dQ29cnB
	k84j4aV7ENt+CLuSE3qxnOynqqmxlRs=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e915887d9dso24711335ad.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792125893; x=1792730693; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tXRdAMjjFZfXtnEnr4dqDWWhcOJ/4Lnn/GYCEcpDeYg=;
        b=c8sV+9J2pfBtrzvr7UY4Jg7DLQKHLwTCXU6hpti2KqZZpt1uzE2iOxqTqgM7nfNFqb
         WY158ViwU/XYb7jModiWpVj0NzkcY2dVbeIJbog7yP58lujg5sWaGt564lh8gVQGXtMI
         8kKQqDGZKv15JjyvbXrBjbr1tMPYzToMVe49I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792125893; x=1792730693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tXRdAMjjFZfXtnEnr4dqDWWhcOJ/4Lnn/GYCEcpDeYg=;
        b=0m51L2uPa/bKBGmCF2kSIZGghU73ueOFZLKk1jvejXL7MtY7NXC+dlrpIfb8YdUezg
         cfEu6mSFQZggYYTldGpuv+oLSUGs9INSMu+1AR9yd3zDf7ZjO7pm+adToE9CuztC1BfR
         ed/UoyGY52mGW4t7quGLq92hZ86rG57h9OCZUD+AVSpP4ZgzHv8VcmJjN7nusIvK9Pny
         xplvtma9kc+Totxx6OwNowfAxwfGn0a5EXNuLlsYrVWgXhDNUItk3y1FZ3OEuRyeygaF
         8DdPNhoO4HoNnX6si4OPtY1iIZZBFEK63GtKkfum8ovynZalIsZ+2ES96k86Js+rXl4l
         xEhw==
X-Forwarded-Encrypted: i=1; AKwUvBxOanaMW2F5MpKC4G6mb5TOML96Mt5gcUtIxs88byraZWovqdro50WuvpdoYvubmhDl8JWHTD5N+Q==@kvack.org
X-Gm-Message-State: AFq9FYK1O60/kvhZ7tWM56Rh5Fa8mABapKGv2dZhyX7PCjdTrdov4imz
	91bg9IGMaC1lw1gi000uiVX5mwZ7tet+fEl5GEvVqhU3NB7PvaZcdhaMpRvCqnqntA==
X-Gm-Gg: AYBFou2DcNnD4eZA6TjedF12+hGfBFa9zLOAZKZ79q6c0aGcCdQuSRl5tFGnEOtgOut
	4yPbGBuA6vR3zC3GKOqwXWdosbj9+WxvRlKcsE7OohGIqpbRtk1Sxw3rgVMdmvxOX5aOfu56Cb6
	x5qEU/bummC8MITdHiz8moiCFSl4u2UDnP2RTBHzCPjWmq2shJ6/0KrM7t4TSZQ1bfDJAU5mbqc
	OGcjGo+uRycD6znuAIDkSB4pJuxNjJZyGvA675C0ZztNDkPag4YsKgisigHd/tVRCY0zvHoMJc7
	NB/gSNzXLGMkqGqmETqS3KDX5VdR+jqQDBAnlbAfePXFdIVGDqqzz+F8AvDlf/1z7mgn6oUmo6o
	tjcvGGNyTYhN9j9JLU9O4RxZcQsVtywcDu+9n7Wu8en22uBo00eQKUMQ8LG89I86jCrjeddxX8g
	wtK+rBXiYF/QSv4XomfWuYbvGfHQoDqgtwtedDihbcsHJUul3X0bIdsy2Sgo2vD17b0onjO6u5D
	7/uWohnE+1d0j3m46BBBA1vLqjPKIZPUJwqZ1+9QRvWNnrCDrNAUFl20OtRiz8=
X-Received: by 2002:a17:903:2ac4:b0:2e8:1c7b:3b6e with SMTP id d9443c01a7336-2e933775c8amr70192855ad.26.1792125893414;
        Thu, 15 Oct 2026 21:44:53 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:a579:8b87:8304:7ac2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e8b1b5esm4137235ad.67.2026.10.15.21.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:44:50 -0700 (PDT)
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
Subject: [PATCH v4 06/12] zram: lz4hc: use LZ4_decompress_safe_usingDict()
Date: Fri, 16 Oct 2026 13:44:11 +0900
Message-ID: <20261016044429.1304561-7-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261016044429.1304561-1-senozhatsky@chromium.org>
References: <20261016044429.1304561-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hdtcd7ibtaajhria8a37qz6hg5zbeswz
X-Rspamd-Queue-Id: 85D7B140002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792125894-558809
X-HE-Meta: U2FsdGVkX18yES7T94YLOzatN9ghcATHE0FZXQyUOQ1P4+TUQeHvTpCllbcBvYv0ubywIIxNkXXcoI/fRMOpw1okDwl0xp/hzcH09wY57ie+0t+waGsivOpVf2ycCqA/3q3ZpXtngh8o1OshoiftmSjUAn+0064wnkMGBZ3alkiV2re2VRAoCyGb92/yOhdvpO+OcVhcB9O09JdUQG2jLguohoxY/J9YMHyp+KDb1sMZK1IL/5Eo1quHd0U9PJ4yXrti+bYqWWlZ1yaby0EeqUcB96J3kInb5N90ucByu6+tyLYxTK73e6cE8+Hh81joBcK64OMWbXPZQGluvMZu5SkqrclrEg9nltCdagj3VTDC3N1llO+Xx/ptf7pxjeoSQJUHCWZDlU1oubRD8eWzO7Kq8QKCQBji95TTtQKeJZ3+y7ZeVTXcJbKv48v6Tcju5NVddWwTxPSOy0lfHgIXFd5I0ZEXZT24QpCL29oH/kzvV1iOAx358bfSZC4koaCUnmDi8HYfzsGOgoXrNbfNWz/qEQBU8LZ/D8ISjfqnN3Cy6ITpgt4rtBAKS6CrnY30ZtsVr2ciRE1bKJiym0r3U4hUHMLbTXNZA3Twhkq2XSHwEA9dCecaI3N6MAuEeZnc40j/OOktiIl0NOKQlsv1E+Hq01747qYaQEw/igg0YlWsMufdLyWIdQxiGcnqczVtCt5c7DPe3kyjnZAwJMx2bf0hk0Ta7QBvLkvTM0hnxRNKBO5RG+9Vu2N6r8Zh7Q24oiaDAfw7U2ViHn2MVu5DtVTmFM0wDJGyGJukN74UHdKDLfVzqvClxDa0JrzdHgZsrfJZVN8pYWWw2CtpYTGy6ROgnTCRD7eBezlO+eJDWSP2RENKIQMt1FJCOlWkGwp1R9CuegmwY8+cWohr/v0lHz3XXKp6GSlgbCZIP1LoZmeK8lQLIyE9TGFLmBfBCZ5PkgOvbVJ+5TlF89SAyUV
 fBVX/hio
 cbe88Zd6XICLZGpXFpWBjJ8bovYr8fm0Oufp7cCWJDX3Wtn8SSLgWwwd8AusEsP5pe/e08OaGbip6/9qb06uR3Ov8un7uINO4O0LlR6QLzAHpBFseu7JEKWPr1aIa6HJngpdhfmjs4FMG5JbYUXpILOGqzRtGPFoCK9ICjriqZsiece0iu2v3iBo5nH1ZOn0SPgoGEBreg8Qwr8mUKl6dLWmIdp90wXayyNOyJJ13owWhQt2YKki7U8qjDBQ27JqRxTTZK6IpNegjluM7lCOYT4+qGvaU7K4BB59riDiH8w237sdYCIXpQ4A9CbhmhJXfEbMgVi5t6Ek1Id7aAxQRCLGvtfeywOKAzCzyl2KKL7smsL5tQ69BURNWcA==
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
2.56.0.176.g3575e65682-goog


