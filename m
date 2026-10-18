Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74651CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 03:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59A7A6B0098; Sat, 17 Oct 2026 23:52:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AE596B009B; Sat, 17 Oct 2026 23:52:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301596B009D; Sat, 17 Oct 2026 23:52:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1350F6B0098
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:52:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 485C5803A5
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:51:57 +0000 (UTC)
X-FDA: 85334373474.12.AB7365C
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 853FF40002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:51:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=IHARQdV1;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792295515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkV3g9p5RWCtmaVyEIk2+X1novLUQhh3QP4NEkjHPO0=;
	b=YRHjCj7APc6DzTdjLSol6HlZFfco/m1wLuIukFQLnbVHbd6oA2jJGdqt96ChiI+BbGrDnH
	AEj45dXvMWDjAxNpryDXRpSlDj83/Tx7RjhEVXTtKhkXjSVnzu+cE1oSbq/BEDmivsG4CA
	GepDgnLHhosIsGeVNsPidlWXAIOjNdQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792295515;
	b=jNmLHujs0tNM/GqZ8QUPo77+6os8VE9YkTFk5T/GR5MQNsvYDX5fKSqLCJYmoE8xwX7Eff
	HSgTxktcQOwC36j23kW5AlJhv9EHmyJXQ8Jbx8vedspmPI4nQqhK/jTDLP5xNIw1Jnapsd
	u/KS8NIsHVtXihfanRDK6gQ5ORlN1Jk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=IHARQdV1;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3a706146559so883073a91.2
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792295514; x=1792900314; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wkV3g9p5RWCtmaVyEIk2+X1novLUQhh3QP4NEkjHPO0=;
        b=IHARQdV1E9PBYIafHMY5w+VjwGuAEQvnDOUwdhaEbWTl/4HN/XuVcU/Y+a2xFNtIel
         tmA6ti5bzHwg7lWypfb1l0f6Wa1JvPojIRd1WS5NxWOm9taH5OGQgU/RKdI4/AK2KMQa
         2qm5WVLnYbVrqd1RjrBPmIPVAmCFho0V6Ju0g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792295514; x=1792900314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wkV3g9p5RWCtmaVyEIk2+X1novLUQhh3QP4NEkjHPO0=;
        b=pQHzLp3PhO1PneS9yjRPMrt7i+Lh3K/JOPH++rug8Gavbs1IWEqHFZXPJqwPuBho7V
         MYlyllG0AqJjJZs2dJsMTG2iDyhc4uFNTjta3EyUVFGrciw072EfZzDygGHjm+jrq/JL
         d9SNco+vhQDRhZ4PVqBFRSX9NaefRkKVDnHWLt836mBkSn3oG3XQKWrN2UzaMapMrErO
         jnbz/cHmuV//jtDGFtxR8TcLSzC8CjCokwJaQZ3Ee+4jOLasaaY8MYYJK1lR518vxN+m
         7Ob2JcxV6zgUFZXScoGP89h1zUa2tP3lriXbOL2M2H5JNoF28eck+XmV+Sb1i6xcvQDz
         58hw==
X-Forwarded-Encrypted: i=1; AKwUvByiQ0wm1EraV7GXFMFF6mw0PB8FFI6qsxoNZSvpxohUNn4F4cRiVurITyUKH3hEQIivyVMgmmV2qw==@kvack.org
X-Gm-Message-State: AFq9FYJtVcb/tVhnKtsnLxvbLb3AEWZqp2ZpVaKuKOPyAUK2ZcWf0f7r
	/ZjNmYbf++0lAatLyn2wdBgMOuXJyaVAHksNxPkcIQUhxlfLzo1VTqYSi2xCjb1JJQ==
X-Gm-Gg: AYBFou3ICfAAxdp+a37u8mVfgQhxhsW5z2w/IhQ8SRtD8HQdeN/UjGQlZFAy5LG07yr
	l9eDMdWEQos2u4cEI5FdWZddZaBbdBfjxfFByDqh8J5Xy2P4zPODY739codcZIYMEMyNGkhupLz
	dbQspL7vh8/JihSC/qhw1zwwBUFxw6TUHFq9GLyqRcmisLnqRnSypvo5/n0nB5mZ58NmvFLVP7J
	sHWY0umDHwvmUUSpkRsuzlkovWZJCLySWqLjpw8KJhC05oYaqMZU4ZnTmvCNkXc7m6e3f3qWEgy
	bALTpaCwFXksNuxTURMkeJrzxDV5w9oUN9BQH3SZYYrgmmDTpg51PMHfDuKI6PU54Gzym8uWFCE
	202TwpqxwP8OdiwBFH6yYyqCJsRPUbLrPozLGFLr78tnv5S5CNa5VLvHl4rNDvRcLkxzpYkXyKT
	TT/FZ4pq0xgkVvZzkB9vHCIHLuPyyrkyBp8L4UNE5xcRHd9V1FDWPPRQmBj4PNif329ekSkpiuq
	AwFYKIm6kapzUi3v8qz2isG5BZo393pleA5sHOJq/EVze/RE6Ktirg8rwbQ648=
X-Received: by 2002:a17:90b:55cd:b0:39e:53a:c8d4 with SMTP id 98e67ed59e1d1-3acef101a73mr3668360a91.12.1792295514356;
        Sat, 17 Oct 2026 20:51:54 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:4569:b311:f3ea:5f8d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad25d5d1b4sm253024a91.16.2026.10.17.20.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 20:51:52 -0700 (PDT)
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
Subject: [PATCH v5 05/13] zram: lz4: use LZ4_decompress_safe_usingDict()
Date: Sun, 18 Oct 2026 12:51:07 +0900
Message-ID: <20261018035125.3120704-6-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261018035125.3120704-1-senozhatsky@chromium.org>
References: <20261018035125.3120704-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ro48cw9haqgji4te9wiy4tiechkm7pf1
X-Rspam-User: 
X-Rspamd-Queue-Id: 853FF40002
X-Rspamd-Server: rspam10
X-HE-Tag: 1792295515-868275
X-HE-Meta: U2FsdGVkX1+YVRB9mm5E+CD9SHM+VERZuq2G5uRuTuceMYGCaQK5yJqcSHesjSXJ0+S9MMyzeSlxlaObkv5YPZP9MU1AsZDb/66Pt5KGnVHyP1UJZdkrXinVH2RV9YIEfBxOcNeuyJjBdkkeSbg7PED733niDcB31rgXSb1E/78mlePxvlSJCFu1xA25CCdvYF66tV0BYTVQlQGw5NM594og5JUfFhLSE3OT5ziBCM04+cUYyNJuQLJmXxwc90UAReMGBGxv4IOgZ0AJvsA9+d1XNolGLIWZ9OJZYfshu+4kMg/7J7R5XTK8RJeXsEbm10oYT47yJNHh2hEvAibPI3zXnCDLhf4XUB5lBcVUKVFa8nC3v4qjE9nCK5G0gNJaeqTO0XG2bD2PzUBe+eBuq24/Qm7Yi/l1ZerOB3sb7WRm2WILPKb//PlKJWMGinQGKuPBlp3mN4RIKhQ2Pn9NnQwXTWV2mVx6otN7YlRi5VMomfeeAw9lpczhHzJBUfJ/mPIqW+3lI1C70G9c5tWVZJXQKqmvPOLwuBYAulbCLDnUMSe7UcUQDaBimkZkOg0wAQNFMsT1v/DbxUG32J/WAzo3hW+cDPNyAfb6NK9DvPuH6A5qESo0jozohTNEfSRgR9WgaouRFJ2BXF24YhkGQUSPTZmyl06K3Ol7zyCTz/qlkUtpswpo0MpKKSmWhiZcr0zXo9EyzDhVwrPlcKS9noI1YVwI8OJDBZlaP/oFnFmPNnn8D6YpsS3v0fOUpXDNnWQqGQa7pagaL17xfpy6UoLgk21hc1MDNf1/uD0UjEJsMWbsF/6FwbPzvblmn79yyp3Bf1gRxZt4A0xPBypUTFFwy2CqvHbSnh/fGAP21UuAKF0AqiOKUGipC/vWP1BlrdCfc0TzWRr/MA+M15gcPIK6y8ngcVAPv2bQ6ALBufhWXz9S/1Lgv25Z/PWX8I31omJjobioKCP58Ztsvqu
 BpkhKBGv
 PK8djoBRg87GtYGQxKHvi9mZ00/n9GJybPXr3HLVVb9wZve/AxbITQpToI+89nl/BtyF61i0jusyYq8O+RzO5s2041fCMte+v+3B8Xkq50CNslW3QoQosASj6eGtY3vQnEguB9MrJbIAYI8PhJpnDMxovN2GENIlBhP6R5fiArJlAt6Ii+/1ZjJquI8njtA1tF9efyCJXiCz73A1rMbRlrKROvZlTzY/Eoir+iIu43dCF1ipCqSXoVdqsWI7UGyvitMe8LngPXyk/VLULgTmy92SRekSJDbYF6Kf/10h3ftoo6XxI589PoupmrRNT+DY+S5mfMMrDCrZ5pfep0S9EmTEk9RRNptbW/ehg
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


