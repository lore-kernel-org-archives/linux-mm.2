Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DC94606A323
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=DOnk2bkG
Received: by kanga.kvack.org (Postfix)
	id 25C936B05C6; Tue, 20 Oct 2026 22:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4E16B05C7; Tue, 20 Oct 2026 22:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 086606B05C8; Tue, 20 Oct 2026 22:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1B086B05C6
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:43:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C368BC0414
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:43:03 +0000 (UTC)
X-FDA: 85345086246.15.8AA36ED
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id ED83E40004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:43:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=DOnk2bkG;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iK8xJeVT2HjyR4JlAaVJiBB2ezLNdeGOL3THtl93coY=;
	b=0iq4NgOlCnYrVvMxkJhjQHgh2Ek4ua+Fd0Cvxs2qqK5NpsDepcr44oyQU6IJMjHtIz2dQh
	DpMY1SdmL59EzYLmcsrZPuBAiKFbvsl7lIlWKF1cXiLz5W+zlSIXZmNmxKmbah9MCh4Lco
	reb+1IfTJVgNzXolFcGvfSZZ5VzDQwk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550582;
	b=B3OV/xhDYWe6BhgSl509GTLL56PqhkBDWJqDkIyxgxfE6VMfUkifZhbvkvwoE/fOj7EGR6
	HWGpmWlaWVBHyjqqA6lDecQ8KQobkwbxOYW/pL+Hi3sDBkY+C5QSjxpKotJmlPBXluceC+
	e3wQU/KnTQ5Ay0HET3z3ZA4MUHbjtrg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=DOnk2bkG;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-17bc533fda3so321983c88.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792550581; x=1793155381; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iK8xJeVT2HjyR4JlAaVJiBB2ezLNdeGOL3THtl93coY=;
        b=DOnk2bkG9L49LJ5Qye/KBGHldl2NSf47ZniKguS0a9dM+rvbYjHn6NZfjHoM1RfyDw
         w9KIeuNNP9we6bAiIkwe10gKyDs17lnTDvzkxsIgAYW8e49rW2Iuw8I/t8EQDFLlK8vy
         Oo60Sn2Dgmj6Nlkat/yWddMo+MqyM2KWdHlyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550581; x=1793155381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iK8xJeVT2HjyR4JlAaVJiBB2ezLNdeGOL3THtl93coY=;
        b=NYAomnEfOmI8QF7U1uKl5iBbyZNPCqL4QgBi/3KmXEe+pK219gB4SCHh6UTs8Gm7Iu
         XiijEfXw9IQdeYxG8xHoEm99sYvHD0nqP2kFT4VxziY7hQizyAqhksOEm/j/pDMaJVgL
         wuX0qfy9vD+rJR5RraLRFMmlprIvSnAgQvInatI5ISpooVvCmEhpZrS14RbByjeI/MdZ
         KQm80BOh3Ij/ihBRMAlurrJRRyzAQHTEqIeKy9aG12d/Hn+Oxu63srZ2LkcMBkQyPpHX
         aEKl0RuJZOWsL8uZPSievAzWph2QquBx9E4bx7OBCqtB3+TXaU0eRFZJ+HnHsAfFIK4z
         zfeQ==
X-Forwarded-Encrypted: i=1; AKwUvBxXvYiy3a+dgpSlYp9giBfcvjz4srk3RJHEUsS7Fw/NLaUpwaYYXmFtdXkcUWwSN06W5eaPU4uBzQ==@kvack.org
X-Gm-Message-State: AFq9FYKrCSC95fJ4uBAdOszDGErWbAx4NtcMSbOah1r3xcbSUWykffeo
	sqe3lZGf07j58BQ+uhtrAlyDs8V0h7jfTDhnXdOXpUvN9vUhE4GzmdfrCgWDI6pUvA==
X-Gm-Gg: AYBFou3vHDWg1B5aDsnxo2mDv9CkgR1Bt+tZb8PQjLlG964ld22Np9PK5GNLRtNRFL3
	8TkzdXEQvzbhWdmzn8LJQmP0m9ND+3TI3qz09yV7+BgF93PXT3rdSUfiXLRicB3+RmuDeGlyWYq
	G6rDZp5OUqeXtqv+2LJj3RhPjD98X+dHgQGV5qjJHwzdamkFjROg1U7ireMYpvrGkr77lC0MsIe
	G9eiBR5cKsWbGJ9UhO4lYXjUtXJRmQ/KAH2xZsPnCDcnyi2jtB3RDVeqNDvaxV00TRBUO1Zexay
	aWXoLljPguVFEPcSaYaKVPhizCT8+F0icLwH1GUtq3MBp5MEIaowqhCnduo8cyYUGC2DI90Z8az
	i6ZX1tbqM9YD46FYki6U49Jdsxx2ylSflwxGFZkB1j1D4b7t73Q7nD6tv5tdCTsogTN7+s1JRAh
	Bmg/Ngg/18KnmvYu7g75Z5Kv9xLZyjZvHGUrHLModSmeyDZAZiZ2KuTlU3WPgbt4agwcaLPmPov
	/K9KETBTcxO0SUCl9ln8GORP69SyTXT87Pd3jgUVanIBrEOKp/zKksI1FmNEhHrUtpNziL5SDae
	KK65tL7C9qgsKVfT55HHKWdgi75oXfqmKuhMjKEutTri
X-Received: by 2002:a05:7022:b905:b0:143:2968:564c with SMTP id a92af1059eb24-190a67fa14bmr804644c88.26.1792550580717;
        Tue, 20 Oct 2026 19:43:00 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:97d1:a8be:236d:bf79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035c0c9a6sm2392047c88.3.2026.10.20.19.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:43:00 -0700 (PDT)
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
Subject: [PATCH v6 06/13] zram: lz4: use LZ4_decompress_safe_usingDict()
Date: Wed, 21 Oct 2026 11:42:16 +0900
Message-ID: <20261021024236.1787884-7-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
In-Reply-To: <20261021024236.1787884-1-senozhatsky@chromium.org>
References: <20261021024236.1787884-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ED83E40004
X-Stat-Signature: imhjdtxo8m8m57dje13f3m9eahyrpcyx
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792550581-621414
X-HE-Meta: U2FsdGVkX19FfxWJQPn8yaLI3ItiXPk42BXOhuknapYIuReYabxA7rTfqWXlv0TI8BguMWwO+2vhUgVJaEA4fxaiXwBkGSEKS1Fy6e0zpZkFZWGJKLC4N2SYgpB/TU+RCivn4SpRHEXuT6OOmynh799xXo27pLBOLrqua4P9UdHbBPlrUV/Fpnlel1CnRbgG/I1c30vvKQzYDDq+3Y0i7D/famykk0iqaWSl6GXYodzA8qzweDQSaRGy1UmKoySnI25CljW8Rzfn/P3nuPMWN4NMG9tYR25AxxCxtU+rjvXNbV3HpDKUDdD+WFoIcXOYaExbV8Cb2WCnqEpz1Qc09Jd2cjnGiJJfLjsVtGzMmbZULRh/oEoMydGslYN026e0QjtxsVvrtOcXlBpyp8sgKLRW2uGsHE9UTprMJPdsPtuCjv5636DCz8pZpQ0OdLqgW5SnKOb1Tpt/8jOxnDcYFH7GmylysTfbMK3a0lNWtZwR8stpKLepmXzRgCebruuD8KO0YTYiAry5H+4nPL6HY3A8n8DEdDn0cQ8LKkOi/Mx/fvHtxuTwBIyaWboQg1OTID8RRRixdwv//lz1teAhCY6qOahOujTAdkIbgG9vly67HS+lqy6m2XIrFsI4HxxaV+UvI97PeQc3yHRMROFqklmsUaoQf12ZiQxVJbIjK3yXuDkwEzq5iRWzFpAM4ePscnsfxKW9P3BHlCZhZJXIPdMWcxR9NoZUklggGxNvPufdqJNOdcOpqr5uLbwKFkiS/g/S5clAn6Z6ep0WTtJSpzTXuyXeQdEwq4zZFyeSeVSOmiyZTydncjz83N7PRcsr70gX1X1P5CRUMQcFuBJkwGFhW5FtGc40a63xKEYbvVKI6OYM0xz/lBk/DdBmTEb158wpD82woaAWTn62TQl3rLdycXx8uhvQh8bf8GW3tgiNaD2SdQSTIZxGBmCW8DWq8BNryIMNyGnUwNnFAWB
 lOJJRlco
 Uj96S1w6vVm39tl7miUV+CsP+FDplBx/quqs6nAbYyp8aDJaA5NJm9kUZomI75XD8O7vS10ta73teDVTOWKSIvQAbGkUYBR1BtGzBXnT6FfrverNFrlLv68bvZfUtjjrZEqY38lhMVkBKtDpcJr+Bc1sWeSJbVbmJwfUrCez/AY1R5+gpL6QHlj/FjeJ1oDhiZKTd+Ey83dp/iXkv6p9/5Dh8iskccfWIvDe9GBe+6la76c1d9u6u6APGHrn8WUo/+32krWVJTRooAKXgydrPiND0D8+6oH7R3VOqCPLavL5UOhAOvGQ36FTQsQ4DqzuXUBWwJZrxDYIme0G5uwyfMeAsxOjX0pfNPW9/
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
2.56.0.212.g129ede20d9-goog


