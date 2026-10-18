Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB04CCCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 03:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56D06B009F; Sat, 17 Oct 2026 23:52:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8D26B00A0; Sat, 17 Oct 2026 23:52:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2EA6B00A2; Sat, 17 Oct 2026 23:52:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF5D6B00A0
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:52:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 338CF140337
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:52:00 +0000 (UTC)
X-FDA: 85334373600.28.0D64986
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6595E1A0002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:51:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OAkDINe7;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.45 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792295518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXRdAMjjFZfXtnEnr4dqDWWhcOJ/4Lnn/GYCEcpDeYg=;
	b=PU+hcvNkDro/3/Baa1kZ8NXwQ6mjhJWXqcqkcy5YOoWEzDKhdLJo8jOH0wOxJmz6KUCriL
	Ss5QaT+hgvo4nGYLt8cqvV2cBveyAFfZgTI7BC0OfaFkA+ZNjBtvqmlanmgrlzEINJXbKw
	RRP0SmIsun9q6Hepz/8fRljEwmCObDM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792295518;
	b=HLg21ThT6OyUs+dHwEUSHn5erlLWfizykCTN8Ksn7doNdarVo7geD73hqPJcRQ+8D4eDeu
	eefW1P19J9c9raY/eIqFBDn3EjElRy/A/DyeIPshZbW5UQnCz5CNrCAVb9tVUCFKgqLGj2
	gKuF4/fwRbxW0G/IM2lbON6hoVU4y+U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OAkDINe7;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.45 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3ac677668a9so932039a91.2
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792295517; x=1792900317; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tXRdAMjjFZfXtnEnr4dqDWWhcOJ/4Lnn/GYCEcpDeYg=;
        b=OAkDINe7J0jKDMjGAgw4dr1/yF10CP2KC+XfwifvuXvE9byniZLYS0DqbPKniE2dyi
         QwMu7JliFaY6v1VX/VuZYqZI8LJvDokb+GmX5jvdL6bn2zfDqwGOWUv4LhPTKvl5kYnn
         m5XiPvVe3G6SPsGlGoHefCz3Ye/VFD5EyuH/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792295517; x=1792900317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tXRdAMjjFZfXtnEnr4dqDWWhcOJ/4Lnn/GYCEcpDeYg=;
        b=yu/2d7s/YXlEnjNr4ki4jqaUgk6HFnqWbDpVtpHpC2Y/oeKak9OVFfDSaIY1fcSob8
         nqKx87hOJZtbBRiMJ/N6TWKLwPqCoPJ1WjCbtGZmyOJGNmsOTcfNidL6UL5ynJbsoNZh
         mMNhiaBOWTkD89TPbhxIkVriepI+fRmdmlViHnkLYzsL3i9t8LDX6v1d8xLPkvWAluSy
         ZO+omT/Aw0jfHJvl7WzkCBG7aFOnMy937/ce4BRoiV+ZlKBsNUl/gvWSq2U63cbtlGu7
         Kv7HTgKBVM5YBxqXlvsO3osj090XVjebUOAChevUe6/Bsb1kWzrMUKkpgqu0CHk8i1Gv
         FuKA==
X-Forwarded-Encrypted: i=1; AKwUvBybP45yO4dM83ChTn4FICJKkvgy2wQ1/BQGHeJmPpiJQwrEjBI40yrqFja4A082izAFCT5goFXfGA==@kvack.org
X-Gm-Message-State: AFq9FYJHTZBAt86c373/Z5zV8sdLNepXYI4K9WLrBX3oMErdt/P5lhy1
	yzTLxNUWj8YooFCT8s6ZU6lYO8OolngTw5TTfR+s2wo3sjO7p/r5SnoSMYA83+J/vg==
X-Gm-Gg: AYBFou3nVGoZQ+wZflG3sd8eXWCcGyd3DoUho24VlXgpS4o7kuaE3wyrunE1Ma3b89X
	jzSoMS2ykFfw+6F/HjTxE1WW/yQOdUHfY1isPqOdXRTipFU/nDcK3v8szGj/Ax+bpmb6FLnHWp5
	srDjMPzyg+Dffy4VNDjPPW3QGFTB156XqnbqH0mFBxTPwWgimvXQ3GCojmvDAcISS9hcDe5XTfN
	q7zimSVVuZo3jw05+k2wPriW8sAMxoyTqtVYvwvQTkBYvk3f9RThR6bCgdwxN5JFANuaJr0DFoK
	CN37jjV0pb95NVaV+49YCabSFG9J1jJko3flAB9Eai9fNWlwkmG0Go+mxSyS6QcGOs+prjLGRAm
	Kjb0HpuCL03/EgGzf7c+AZ62NxWbkaesqP4NTPwiukyvPex8u0pNVGV9Rsh+aMVM4pqZkzDjdlA
	1HzcsNZi0cDcPEuznqm5r/4uMZYYyf8GbpWUMU4XkVmzuuzohvMVYfuIa+hfxCn46DXx3PfmWtZ
	H9rP1g0v3/1lQD/nZXs8sPX6LoodL2do25mE3ATIwHEoSG+S1muminw266toq0=
X-Received: by 2002:a17:90b:4f8e:b0:3ab:d26b:c2e9 with SMTP id 98e67ed59e1d1-3acef1451d2mr3420740a91.33.1792295517163;
        Sat, 17 Oct 2026 20:51:57 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:4569:b311:f3ea:5f8d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad25d5d1b4sm253024a91.16.2026.10.17.20.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 20:51:56 -0700 (PDT)
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
Subject: [PATCH v5 06/13] zram: lz4hc: use LZ4_decompress_safe_usingDict()
Date: Sun, 18 Oct 2026 12:51:08 +0900
Message-ID: <20261018035125.3120704-7-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261018035125.3120704-1-senozhatsky@chromium.org>
References: <20261018035125.3120704-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6595E1A0002
X-Stat-Signature: jx1gg7xzf7myrspd1ryg53h4sitwnhkq
X-Rspam-User: 
X-HE-Tag: 1792295518-437342
X-HE-Meta: U2FsdGVkX18HfPJyltpGqexbHWhYLj6mvWaFhLO2CAQSz12+6CZH3j0IPD2aBLijDt2G3gj4RCPtJXHvlhZxsP7dqf1zLs+nmZx6Y23EilJA1x3MoKsP+1laG+01d9S6HGQ+JwrtbILLbCQQfcSkLrFDUo4R2JWPjTQoiMe/AGB8hsQL7KNACiQ4NCxBrgOGKSNF1D1V9oqNzpgljPpxsMydnW5sjWy2Ghe9bw+LYhi4DRgMmzvXTXP73DoVRkQLDhWuHxBRTEa8qmLHKT3LLKgAupH4p47d8Na8kJ1TnEMBwPGwhQCYUarT5fx+KI6/H3MrJhYVtiYsNTqN9bouohiZ7xBCDir6pLTeLQDxqql5uxjrCg/GMtJg/xMjG6GQ2SlYBmmP2uH9Z98MC95Bf4fW0GAqsVHiWJJAYE83i54wjbb6lKdhsSOMxoxm1leL1/iOx9Fx3JktwzOrBYp6BUIPKkyIj8fGOCX+tca3w9OZsw69dg4KOB0H/0iSGnL3Ouwg6ogaHIzh+xCROX+Uk9mJ7pea2cnsZksLp3oQx4PBFVlILjf0wYZmKf72zVxnfgRaU1OUTcxMr1qjKr2h2VvXtnn6NvfdTGdTXysEKpI3Cc8dzwarIMs67ttfNaF2dHhycHT1o/WR3y1PI/shapPCTKrmuWOzxeVOr3fjuIOFmgEvXc7+pR/1Xf1OizK91JrDPJDAcjJzce0eYZEE+An6PPYqwULbFGQs8L5zJhw0yh0uvpJvOpAebnzz4YSl+a3syRx7UlEa0rupi5kyNL9j+sNq9/itG+/JJUmNI391zMQiPf9kZHaNmbnVYd/KzKV7dfoYTPx8+V7Bl3TAKQdk9RtliFZ64RhkGTPLl079fhp9e/u11CzSXPbCkw9LUl8VYLFqjF6taFA+rDIu47SDq0eGBIii1CilgUEuUO6K0ntKwQs57rB8M7OxdXFFEkichvHICtb+VQL3kSd
 CPxBZ4XZ
 6UUtGuvCakgVO/YXZ4InN0p5Mp+u7zXIbFn1uQnMU9kbJPaLJn+LhyGWMdE9gzpnfk5Qx6G+qUyweVIqYl4dLZKyeVhcVeUYJeWMNOj1ohlppypaldKqez6u38MWgsN6+hnmVV9V0bQuK8Tm2LBrlfW2NW3+MzGm4ek/5y4Bsyi1+cjV5MvXkFKyzeipuTkkFerGfNjLgb/JgvSrn1xY/LVjTckPaLPxPz8V62gcSCqhTrHPFPpoSNsPSiDie9yEP9eucEgAZLKyoErlnG/paJzq6/RcFczTvd/rbnm1nhpbvMuEIEGLR9H4OIuIP3M96uVEXR27Kx4ji9N7EPOptKJdnMom8fR7jJyYwbQK2Z6DLjENDlB2lj1o9J5ibnzR5NJyZ
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


