Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A56660A2611
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=AzntwJpY
Received: by kanga.kvack.org (Postfix)
	id 50B536B05BD; Sat, 24 Oct 2026 22:19:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB846B05BE; Sat, 24 Oct 2026 22:19:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383CE6B05BF; Sat, 24 Oct 2026 22:19:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1015A6B05BD
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:19:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A26580520
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:06 +0000 (UTC)
X-FDA: 85359541092.08.051CDC9
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id C1D80C0002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AzntwJpY;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yahG/YSHuokfDvQP5Q0/5Kaan38JHbmMn0blE+0uhe4=;
	b=N+2X1ct4U2+dUgQYGYMmn/5lvrIwXVyD0cbDb7hwVsv2Ca+dL1yQ+OhLaEAOy3FJpIJDcz
	3Yr0FavkgIgnTe43viQ/fRk9IXb1r0NlH+cs51uRdHAMQPFfnCyRHhkBKajw50PQIxakAH
	oSkGgh2zM/HeMJWWWzpSaWlW/+BSbLA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AzntwJpY;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894744;
	b=nZMBpUXAAr8WI5GZSLPbsw3VvjK8j64JCEbWVpx/HXB9bfh0dN02V4XtYNVcvKgmrTwaNS
	quA4eRC36yxAX1SUCftD0sCsoXgYVjegF56rDkBW0CCZMO6BYpozJ/Uj5u5OjzDcq8okCW
	7eUnOs915Au0v5tUbi31JtmGPPHj7Aw=
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-369f33df08eso700044eec.0
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792894744; x=1793499544; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yahG/YSHuokfDvQP5Q0/5Kaan38JHbmMn0blE+0uhe4=;
        b=AzntwJpYD5ABE08qSccWGepVLTzVPyi8YJQNJgjSYA6T6YqHRe0nUibuUBzquoWpmV
         8gcTCd0znfBSp+FYeuXu3vEG7r12qwN3tsE9mKn9Cjz/IwWXWUKM1IyBGLOyiiAZJbgU
         JVKbrr7IXgCkRSOzeIg+atStxX+MPMyZmmp4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894744; x=1793499544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yahG/YSHuokfDvQP5Q0/5Kaan38JHbmMn0blE+0uhe4=;
        b=lY5QSOP57eZFzSJQFIqRf/Nw/0kaSWB9IbuHP8cV01vBB/xb8p3frsFHwRklax7lsn
         3p9vROrHGFcJWasCwAmWplPbHr2s8YbLZDw/TJnar1cjlVuJW1yzE5uBxd5FmbsOqrw3
         /V3sl1+fM6t7DjafyAKcwbLAj0fs5HhCPOjJChns8w7/28+y5PKjvbD+fdJVrxy6ASlG
         /wwJuxZiYxrEYrYmqqxNlDEBGq3RjUhPJCgFdVhORk3PfDC+EpLJQYvm7Jw4+aeJLV5f
         YYWkmkEj1DHHx5ZzgjPpNZwZAWNUGWqmo6xFg4lb5vT3jEfix/x9u7Xl+ibzlsIqN6N6
         m4Hw==
X-Forwarded-Encrypted: i=1; AKwUvBxC96ngvgYgv+zOnqtrDRgQPNLHZWk2VBDMBySf7a0kGEFI1ovgm10pH4efakDIg1XgzVKgfJTT4w==@kvack.org
X-Gm-Message-State: AFq9FYKhqIF0fsHKO03SzmRARbjBJ+s+IHaZ2Wod185UmEsu51J8FYcT
	ts33imugA3KuQXZjQVDsD4Q7Fhn+tfjbVRle4k25QbLiFUcbtuCpmg/QlVE/FVZ2KA==
X-Gm-Gg: AYBFou2XX1Wppa1jcLk9pe/jCKT/w7Dlvz75v3CiJ/ETLh5L3V0I67SYJi3UzpDqaW4
	JyKNaGDUCRZ0mU3FnnQCg66J2SSN6mW+2XWdP2UqaBbOdQMG7XddyI7W4KSTnMrDizO/LOfyXZ/
	hae54fESkNx2YnxKbdhxM3Li5Qle8GFVXpMz0QVQ0wzyy0kD7xbiXUGOC+h9Uk7quGAdGy+TCNq
	YkPb8t/DzvmMZTorHDCUE4ssAUZxQJ8djVP777fQPodPVXE5j4PzQ80BfGTbe91Q5EcgTf8yvOK
	h2u6rrdC1JTJfPml7p+CCVFVn/QFtkAUgIRirXW+qMohnngw7RQ5zvv04hnr93P3BQ4BoCU1AGM
	LSGT9Et/hIbKWuzRysEk6kTA6J26WWMIXq8aqTwEWNK7FosPzXFdM8bBRTejsfOkDv6S0Ur/jML
	xcJDXQf9sSL7hVQc+t5FPwT+bu2wL7J9spT+mgy1VtYOl1PYExna8WAyR2PLFxcuzkI0vOalUVW
	YocFAUzERuQxEfJame8G15ZvFkW04pu263GgFpc8pxG8I4XUh9bOTewf1iSb2qX+oDp3heBcXED
	cshBas8BDgiCdUSODRRELNCZsjnKVPDtqh1TOLD3dNQJ
X-Received: by 2002:a05:7022:b057:20b0:19a:ace1:793b with SMTP id a92af1059eb24-19aace17b02mr3889477c88.18.1792894743508;
        Sat, 24 Oct 2026 19:19:03 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm10387242c88.8.2026.10.24.19.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:19:03 -0700 (PDT)
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
Subject: [PATCH v7 08/15] zram: lz4: use LZ4_decompress_safe_usingDict()
Date: Sun, 25 Oct 2026 11:18:24 +0900
Message-ID: <20261025021839.1542805-9-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C1D80C0002
X-Stat-Signature: uup1pntis74yic6m4cuxq45qdgy3yjfh
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792894744-418173
X-HE-Meta: U2FsdGVkX194BiLN0J8/c7dhUrE3DF1tPF6cSul8kB8bbXHHk9gqkvquIhc4FEcWn5mCfpFV+fiU0PGGECNgAEtTa0m8DNfNiAAkZpIlPIKu9NFaT0yj8xu7G+VRextl1M/99/+MO10JA0QBbsTsxmfv1rXjICTB9ebvXTRpgli24qr0BtDgVdgLbHftEs/zMl8ZZGpVihHFVS0Mk9b3YztON4GWBvD3i/5CAVOFui2qD8q03tD1n6Ffl5MokyxY/9GJHfDMldqYV65NozriJn4iWXnfriYluPUI/yiWRYfWL07wIk7dRWkYCOIL9maGu7QOs2r+Cpc1VMGRyiOh/TTuDQTp64cSHY+qp6tgP9PuPInDn57/i84DTCzqsSYPzKn/9IMSZE+3F//rGhFcA1oiLzUhMg5r3vR27MmeOC0x0UwFvhRizlX0Sot6VyEelZF9Kq2kW549JtnY1x0AqXP1zSzh2ffGk+DWFSXZ8MNEdEujbLYWHYoWfpBpRELLRA5GXyJ48OMLiE+vCt7E2qOlVAdTJD9BaXhRE4XK6t+GH0mIEHpaoLcqLn8+Ek9cZQp7TbuIftW6HrcVOI7n1f8B4fN+K/PiDgaFF9QEJmJjv7LYoLaAezBy3n3sXB1mFUr1Ny/yjvwPBJAO/HW0DdVsTyqbdic47f8XTNrSG/xwKy/EHyCymXSTFcNGOKAYqVhKNvM+1ufO5BI5HKw61Jp/sDahs9DqVt6zEEbMd6aJxfPLFrC0qT9EruOem3IOAdoBPP3sHBTgaeB836Ojg+fRJletXQQcJh2QnWWh7SbgbEpr9pfPg4/zDPwdAVXlNn4N17z3e9YxHHi6+X3Y4mXAfoF2e8DtFJoZf3OKgd6i18natVmRvHQzXOeH0+OzX4MW75XumxC5KExt5jmiMmJ27Gd2MpbyOwhH3VyRkonMRK2A2KeqXxlBxI5hIR0wHR4zJreMgwyqCYUgVHv
 EQMN1WpV
 2VV4Ftz9ZqS5C48yrYCfK8p9FdCWPbcEzcrUMp4HpJgl3vJJS/AGZG6fII6jgL9ncuvmCNO88FUZ08XPvzgaTkDsyDrO7H640qQrEUbmqM59WVgm36sHwYtbce63DDVtv1g5RGH8rG4BRP/oTZwZlkFRms5K5tZ/zljoxQwVAknhOgn793Mtr8HVfHxxHs8Glgo+S8ihPrsERrPXl+Wy/QC6hWAtSAFDZzxRwjsxWTYAaoIVT+R+OQ7h2Kcl4PRZ1Agbjv0JlYupX+hdKlwNvGCmPhVSnNHfc7NO7rP2E2GCvPkR6EIK1M1d15mMBW+ijtFTrM8d2+oFy1wbH8pr7KR8dsIyS5zc1BU9H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
2.56.0.257.gf7497c7d27-goog


