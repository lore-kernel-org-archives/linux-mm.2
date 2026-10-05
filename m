Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ED6ECA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982546B009F; Mon,  5 Oct 2026 08:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958796B00A1; Mon,  5 Oct 2026 08:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820656B00A2; Mon,  5 Oct 2026 08:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5BA6B009F
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:21:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB394120233
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:19 +0000 (UTC)
X-FDA: 85288482678.24.BDA4A1F
Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0D74720002
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CyEgq1Cm;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.228.39 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791202878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0qz2g+oCCXDG8XSKh0DkoVq9FZFfH7mkIafQRkfkoYY=;
	b=vPEsTOn7S2GuBC6SDf0+zFZidNyN5Wm9v6rasV2HzwpYbRXB0Wep8ROIHFeT6ZxEOMLkv0
	MPKAJbTo7u4rSsXHP20yuGghe7myTIg04O9AG4w9Nr+/o5/gY+Hnp+QhFfr6clWSUKsmvh
	81ViNc0GSGt3nzBDmyaJowwA8GCnzNc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CyEgq1Cm;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.228.39 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791202878;
	b=aHiI0kJA/Nk/JPC4I8VwsBgExtynRxI69lhBWbxWJ6CAk8tI8RmxLFcobrxveSiVZkEymu
	uszPZo4F4itNyikBgmPr4yEbKiJXR0mEJS0ibnFJgaXg0e5RXkP051CVsUoldpFVTmx7wn
	9VUKxYHeUaWlWtC/XJyoQ2vK3HbLI7s=
Received: by mail-pz2-f39.google.com with SMTP id 41be03b00d2f7-cc78dd54610so434476a12.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 05:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791202877; x=1791807677; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0qz2g+oCCXDG8XSKh0DkoVq9FZFfH7mkIafQRkfkoYY=;
        b=CyEgq1CmEaY413d2Zlh4d6uuwiIqhDI8B3Byil6ry/Xs2Xib+xItUKBCpGTDjI+pt2
         L0sRt+Vm79/fEHvv/R66SuimU1pDVbUqz1DQ8fzlacoApxc3kkkchD6dLFiVwhzniBQf
         yXkZyfo+5WbAnJLwmYn5FbJ9uAiL9Uy3ihemU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791202877; x=1791807677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0qz2g+oCCXDG8XSKh0DkoVq9FZFfH7mkIafQRkfkoYY=;
        b=ISuQuxGg5GEK6j0HsN7NkKEQj4kOFezo+WNmW+nmx0Z5P6F+6brsHjOvTQifF7jFfj
         tKNVm2qPEhDIFrXwJYOOzqINOM09Xr1uqchKn+N+hAoMZm7eESOvfxzdcBZQv8UsM+y6
         2q1lK7+s3qVlGaw9rMv8rVl/l+5AiCs2+Aht64I7evFpR1dey+HK9fc2dH+YKa9Un+6T
         jEp+iXZwkCwIKCY/T/7bPu/9i25Ly66s2w0Y2+EFcXFEzdLDwwhgYDnRvyNJUSpQ2a0Q
         t+dgxXcwOfv20uxOhL2XsO1Nlk0K60md1klQr/kqY0Xqc8bk5ed3003bsTyVZC/yCNc4
         OZBg==
X-Forwarded-Encrypted: i=1; AKwUvByyhKUYTWy07oLPXg3yzBgd4xfK91oVMF2p7tcfTMPsuo+WbYkkFBGd5k5MC7pYJyRXcp5Nu8OTUA==@kvack.org
X-Gm-Message-State: AFq9FYK/UKZc4us7mN7MqfCuRlmhkDIfP/bmNy6j2vLi2yalzpzyuMce
	KAEZJrao3gm/P+BcQs45nxCiFxfPDOT4di+iJ3fodQ7WfZtg6DR3pf+7Z5EftNwRrA==
X-Gm-Gg: AYBFou2Vj4+0SKtDgiQ7Ew5nh2IEeHbQQQUqD/f66yS1KhNcJrYQ9hVFodO8BEm67Gd
	U7F0WZwlFP1WrpE0x5SK+p+RJRubHyh2w57ndcu/wxDfUwTA9fQlEmyT0oHFWpZXmFLlYdvmnKc
	9jV6W440VcIDZDt86adDt8vC+SjCK4yKq+BGZxw9FQ3xzuwkR7sNaxtnV3D4cJMZxLLARM8zyx8
	COLFf2OcSucNHlDoRjYjnFdtPMF6QODWKTiNk3849ki4ojqWplrOITa5IQ8ZAHm4jtbpNqO8zEw
	rF32wBrVBKXEA21jGFC9SZhwBBjRw4BeWqKm0J83E02vo3nG5E4+5M++YEj6DLR6tMHrZb1NRSP
	iuHsWPV+9zGfkcfqwMvEfmUKNK3T+lfaj4p863ql7XoMM7SvY0R9RfkjCHDkzAb68lpNHKMDhKH
	ArdBW7Uls8nptANH8U0vsow6oi//ISxgU+xvocQ68NlV8rm5xrdhnexsq8dpYPWPkDrP356pBof
	H/xAvTI0N1hlG3ivuVBS5ioQld3pj5tIJAt5O5sIFoxaH92p84U0JBdZ3t3+Ai6T6jk9qXjqg==
X-Received: by 2002:a17:90b:1a90:b0:3a0:aa50:48bb with SMTP id 98e67ed59e1d1-3a6ce79881bmr4533629a91.29.1791202876826;
        Mon, 05 Oct 2026 05:21:16 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9211:ddf0:3c6a:bf9e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7e4b00de6sm3342997a91.1.2026.10.05.05.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 05:21:13 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 06/10] zram: lz4hc: use LZ4_decompress_safe_usingDict()
Date: Mon,  5 Oct 2026 21:20:21 +0900
Message-ID: <20261005122036.718976-7-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <20261005122036.718976-1-senozhatsky@chromium.org>
References: <20261005122036.718976-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0D74720002
X-Rspam-User: 
X-Stat-Signature: gbdfjcj7h8f16q9qj7dsxcaofipgt9pk
X-HE-Tag: 1791202877-587024
X-HE-Meta: U2FsdGVkX19/U57JaI0SqfRRBIsz/C8w7uKgEcVAHSU3wpF8CZznSPQHLgNGUXCrwLK34+y/PXV7IkvHKt9L8H/cIlgwQt+HILKVRH90AHKYx5XguBd8I9tFQHOviG+oGMnRBj4OCa+LieV7rHcnLFJJPoqHW8xYgZTpTiH+KGvSLGusHDvWzCvUQTmMSC9CSGkiFxdi5b+0juUimVz/kSQhDhgCk8PLl6OGwjX8ddhAhbEUrMbdGrNAYO5hZxeK+wDJd+9EsqNjRk8O55luyouW0h4nQkzbuFk4GVi3Zswd7dwkwAmJYlUOjodnoLY2uYf3/SYZuCo9aMPj/xrPs2snlt4Q8kmya4PUCDS3ZRyzZIfHp15RaFf8r4UG5zVSQAWqgMITjkX3B1doEpENivto6cgXEbiQHqPMU2aTIGObllvpEkdMFV+M47EXvLRkXY7vJi9ydgl5DFO4n+AjCJzcJKAujq3gVPosAz/62niFko9JNtiNvihLaou8qkKmTpQQuXVitJ+QGtzz6M8qqtLQ1U7EHUfe6Z1B0PlhpSyP/awwIAuZrQkSdguvnGHxvyPGTWGON6BEN+nhaDH95HrHUWM3uL1vP8xU/piPqqBE9M6F65NPGmaQyuTxZWpiSpnNF8j+9UogmUkFg7MskDqJR+2erER2nBamX9ZWJBsAzW/FikYpfzlY4F5PUbiqIlphIbnC6NVOd8dcedCjFFhGGU+FztKtZn6Qw1UhObsRITdZ0OoechjtPsOKM9y+bQTmvzC3qKI3FEO+VguB8UJQv8Uxjkq/f3ZeIOjyoWE3/RIT1fl3XR4YA5gxELxrVP2KLOlGs5bsPonhymf/fOUz+Fb7f0jRE0yn/z4GZZ6MxUBnOR9PtNEUj+x/tCHf/e1yS9lOFCCsLI2BTpS2lUfukIFAMXDlAu/aQ28uvF3saWwxj9kwGQD7N9Zx/KLD1+WNKHOgDld8OmTPBnF
 FnI1aZNA
 BiLuVBC65pGMmR/70zQyzOAfxmWyyQTX/VR1k3Igb5n5oeGwoV2CGkNNdQT+E+HY/+ToxbDtGCwDWABD36j42bjzWuA19ITqIdqrIXoT7t/JuEwWtkgBClcqXvmicUH0yJkXIgt8UXa9WxaDnFkzSWQ2LnOO2ZgakyQRZLxrbzc+MJsmL3mmG9wmkoz5ZaEkRbgDYdBZR1Lp1uc+AQMqJHdGDfJI2sm1mMnwXdIhGOa/mtrMGxycaIkGgygIzUeQwb8+BoVjgh/HCCDyOJZIL4xPQ+FUKLlXGsR7rERi1eBHU9nrV1lbW8jdSqjS4rpXYxvRvp3+KJ3WpX145/EPM/0iEkIhJdu9zSIgQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use LZ4_decompress_safe_usingDict() in lz4hc_decompress() to avoid
needing a per-CPU LZ4_streamDecode_t structure.  Drop struct lz4hc_ctx
as well and store the compression workspace directly in ctx->context,
matching backend_lz4.

Using vmalloc(LZ4HC_MEM_COMPRESS) instead of kzalloc() for cstrm when a
dictionary is configured also avoids power-of-2 page rounding (~256 KB
rounded up to 512 KB), saving ~252 KB per CPU.

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
2.56.0.rc1.315.gc6ed9934b7-goog


