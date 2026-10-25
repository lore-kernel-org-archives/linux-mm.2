Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 741AC606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=POU7lQh4
Received: by kanga.kvack.org (Postfix)
	id A41FF6B05BE; Sat, 24 Oct 2026 22:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ECA96B05BF; Sat, 24 Oct 2026 22:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4156B05C0; Sat, 24 Oct 2026 22:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 594946B05BE
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:19:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEA241404FE
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:08 +0000 (UTC)
X-FDA: 85359541176.29.1AA66A7
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1A8E940007
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=POU7lQh4;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXHOVm+rIyaOTo+cKj9ItrXebJiPbXZO152D86F4tDg=;
	b=m0CVFKaV5eTfkCJ9Vh3kgwPrqMDSZKwJx5IagzofRNAXO2hccWsG5myv06iZML0oMOsIGX
	7roN4nPBsX+RsBIoeb2lIfzP/PqoCa5JePf/E5NeWZrM8gTFMB5QNUKsH2jANW8Pz/5GhP
	EiRgjLgK+QHqkoRK4jcLT8/RRzjSrqY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=POU7lQh4;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894747;
	b=0SUw8QN++1hibyhyFMCrfL1JQw8KR8uNqsIp8fYuB3GCA7R11q8UP1lWrdo8uycEZtHqxj
	2VDYK0w8qlxuzZubvGpH3AAjA0xDKDo9zCBv6+jhrSIgUgGXPmAZr7AR+hxqs+YGA221IW
	B6wu6sGpJYT8V0Ejw0UVzhRyu09xsiw=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-14394530ec6so2650716c88.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792894746; x=1793499546; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RXHOVm+rIyaOTo+cKj9ItrXebJiPbXZO152D86F4tDg=;
        b=POU7lQh4hQjn3nEGIB4qV4iNjsTxokQDfXI0GEIhQg6OjI2mMvK9nsdvlV9CJXMn5k
         t1ZYWKryLUYCGM1+RZ81jWLR0CnfMVA7m8AEic6qua4nhUVwdr6QMruiyqTT1VRDFdGV
         fK+1nKD0V6NB4gvZZk4zu/7ZS9Mv1gFlW4JkM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894746; x=1793499546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RXHOVm+rIyaOTo+cKj9ItrXebJiPbXZO152D86F4tDg=;
        b=sUhP/2s0+97AanzJL/Dd68XrSnSC4t6Cld/RE8adrB8gCNiJUKA+eakClqQcMiMMR6
         yFblQ154hq95LvQ+SjHH55aIJFXuQgZXwtXzOJjz9RUOIRLCqZ4sZeWmvjJCbfBDBzG1
         hBhKulnXrqCDl2Xs/1FeLQ1fyPR2UrhlLWUrBC3fNhF52k+DMattNPLpcCWCNmg4HgmY
         y/F/VicnCi4ZUGhFrlKega/2JY1K5k2anlvP/ZjP5IQqMOD4LYydoRvJburFL87PW4u8
         IBgXDR5SjsVz2G56ktsxuB199zqDRVRbweZMdtzZ9aZ+DcLiLmdBUmeNScVE+1CsDTNG
         NljQ==
X-Forwarded-Encrypted: i=1; AKwUvBzSJ1IL2kA2EawkFhWl2b1URGtKLXQayIHP9ETF9AHpZZXacB4ulYRUlPDp7WNc7el4g1NEOvhCtg==@kvack.org
X-Gm-Message-State: AFq9FYKPdh+cejP5CTzcjT026fecrkfdXVK6zg1LiDATfJnAAtVSDgON
	RSaCxP6B0zLaKjbwuU19yeYhpfVD1ujhG4u50V9fFpxRS52XtNHMcoh/VJlANliPFg==
X-Gm-Gg: AYBFou2QBNhxyYCCWNq2XRea9SsScnrVZDlYU4gYgDE+F2MdYTOlLi7xkJ7jElCSPxr
	GMAT1KR9EiG1o8fBw90rmrwUiV015HKoMhkIprTsQEVz+iGvmBFTXMcgwtcqhUtbpv9TJ4vrJPG
	DT2Z5WjHk1jRbBJblPwiv/zecIQfVBL9neIlYiDPB+2QKZiaAB+D2lbOyd4P/eIiPqHzDNpC32H
	dxxRwO+ysVspsUkD6QKnn40hcLgUi4eUySgCQs/xugpdn1SjSAxQDN+SN9VnkC2T4IdGip5Pj11
	b+zypqH6cY+YHvLpBjEI/aHGGMztUoRC+s2e7O+5EOKzkbI46l+cWGK/5rqiGs7NRP9DJZ9Y+RO
	X0xzNkeXDKNWQxxNnXa6MELzlUlGgKBIflGvAsHS7Iq8k490Yz4aJas/5XBmQNUXoqPnPxlBb8K
	urCen7W/M6+xfqIJtVY2r1da1q809uoDUMXaIXKogNBoAM3JFpeVtNLqtQ8HfMImW+foZyYGYVc
	zafkCQrK6vrIFxXhYMxEb+aepVRCgAw7+hU0hlzA1pFd4cGATcQf/A9DyowP3fbgv39WqPCOfyF
	Z2cbbHgeZHrhJhNwGgfwU8jyngPgr8SFv07Nq4Oy1Y/W
X-Received: by 2002:a05:701b:205c:10b0:155:7721:3a4c with SMTP id a92af1059eb24-19936d400e6mr4672343c88.35.1792894745835;
        Sat, 24 Oct 2026 19:19:05 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm10387242c88.8.2026.10.24.19.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:19:05 -0700 (PDT)
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
Subject: [PATCH v7 09/15] zram: lz4hc: use LZ4_decompress_safe_usingDict()
Date: Sun, 25 Oct 2026 11:18:25 +0900
Message-ID: <20261025021839.1542805-10-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1A8E940007
X-Stat-Signature: 6znwxs3rhzs1yjiwae3he5zmiihcxjaw
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792894746-201983
X-HE-Meta: U2FsdGVkX1/fRKo09UG7bTSPLKPGLnDMrcC5dO+0JJr23V2+jbuc8SyznPXtO3YFpi7wBYdSRslP5oMjx0CNpP2gS9gFZiS6n8YRZXEW1A7bYQCw/sUEiNHXXF3z72TSxAG0ByNiLkI65SbDum0AIaZ5R9WFO5HwTAeEoM4SX12/yXIsSxEsAu777p1CgyGAWnvv7P1scA5pDRT/227ePkrpPON7sT6KdLdxJgKL+J9awARTmSbESSTVIa4IQxYLcq3HwbsHlTAD7JJeDgXF+6LZrTK4FHzJY0PpP3qzyyjSNzL+2yFvZwh9sK4ayLWgQqV2ZdgqZrRTDE7iHd2p0/Jx4VkXABI/Rnjzy8zcn9sNYHki+B4udtYSZ1Cyitz1nsVTWP81R3Rc/e5AmZk1U2MvCgCY3/aO2Fq7l5Pr6NmxD05aLeP3JHtw3/WlZT+NVqG2L53tO8gAGe2EUEgMaenmYd3jrYK+InKEspvycSZAlM4c6eoVoQNDZx8h5Uu0wB4OcOGV1PRa1UthqTNy8Q6k7QH+yiiXI0+0EYlzp3ErOAmhWuS07KiZ1uQqfjXxwyqIrJXke5FExU31x2yu8Dzj+hfVlp2SzX9B1WDu/38y1O7welpev9z0EXldxUcf1epYq4w1pzToHLzyp0WmqsQ12ofpEwRBzZEcMSr28Mw+OqC4qI15D1wNy1vpjbKo/H9n2mYRN8QxYVyBgUt9+T023+dZYE40cMojV+wsVIuwKqaUsuNpcgBEtYmvgG2keXnuBzXiCYtZ7YsSh6b+ZbA3jhWYZTNJ8Alre4uMWYUe6oGahSBStMDh6lV2p3DsEX+zniWaHf5gjubjUSYBI/NW4uqxfJZ5IomBvKPPzni4ZAPLtGwb3/mjOXL5t4fNx5WTDxGNBWR6PuMltw30Hx7vob8Ra1wEzyD8EtrlS6ss8Fp8np9zdqJb1aRp3za4XY/ll/pZ6EDixIiEKoS
 XNdsqAUI
 Ezwzl86tJ8Rco3VcgEU+ieJfuDsCPlGlogVKR25t52IBNOQ6UNkLyhXYgleoPOLMTCZHuE27spSdQp9H89EP4fHpHoHqxtCKAsdxZ/sorWQcM2XaYvH46fr/T0OykoC54hMRcUoF+FAxWJBjIIaGE8kRusg00EMXyP1pv2lijkmhA5KWOy1hNHR9RLhOauyh7fKsACfcxHhXeRRx5qb1BZsCynzMjro26uy7P37rxUmArAKFnZ+tJu/FAjcER6iOkjhFTReGjKbVcQR4qMLsQCppCLR19y10HJ80qVH46aJ1we1bXE7GOAVAbzMdietc39eUfTeIQT79F5gNV4tXVrVwMPL8DCmr67EuY1b4pLQq1KeXMiZXuTdgYxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
2.56.0.257.gf7497c7d27-goog


