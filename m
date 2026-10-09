Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83D58CA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:12:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2045A6B009F; Fri,  9 Oct 2026 03:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 195446B00A0; Fri,  9 Oct 2026 03:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02EE06B00A1; Fri,  9 Oct 2026 03:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2D1D6B009F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:12:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38D2D1C29FC
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:34 +0000 (UTC)
X-FDA: 85302219828.27.3E6E72C
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 69B4240006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=EYFQWGEa;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791529952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vDwGnfli5YECfAaBIHPOmEI8frIPb+i30TwuUetq8U=;
	b=cLM/EagMG1L5wCqnfhGJkdFY9kSFY4vXEt3Zrfp5ajcqUXKeEb88/o9yCarfLmySHAMjIK
	Tsfna7za/StkksVSPmTXNehps336HkWyVG3a5TEiXh7gwRdZlKlWM3erJlMNL1ZIt0cnhr
	0lC0kp/JycKuL8oYY+4fkouFS4uRUb0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=EYFQWGEa;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791529952;
	b=nfcL20L7jbTz9jsTboeZ1r/R70T733sZk0sPb/3cMr8F9fGyPZGS2zzEDzU5r7hhvtznwK
	dYikixvIFdUiUc/OWHTL8YXJHExO8B2liACS5rMdhtXjbumo3QHOUUqh8GaowH0G2W9fiA
	RNAjLn765glYgn8X9lU58iIfZaLMRt4=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e608cd460eso17396865ad.3
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 00:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791529951; x=1792134751; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2vDwGnfli5YECfAaBIHPOmEI8frIPb+i30TwuUetq8U=;
        b=EYFQWGEa3UjB6R3kdLMlQQyoRmTaFdUcDCC89Bviu8V0n27Vc33AHFRdLUP5WNVK/c
         5/30k6q/GLrDqyqCjlZtwkw0l79pm97GZZcZi0XV9SXWMkffZbQmGSK2E/nKdfxkXAlf
         o2jwH+1CdjvsmyNfaeQVYVJSOAhzkJjFdE8wM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791529951; x=1792134751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2vDwGnfli5YECfAaBIHPOmEI8frIPb+i30TwuUetq8U=;
        b=rb4f2SdAxD0NXF3MGcxNsNqse3a1rKE635K5wVEf41hZhPaAKorKixz/mWrp2aQIeG
         i6KQw3RxFKhqU0cBPIdicLegfj417UOkmzsKBIhS/R9Cv8cvTLqi8anmbPi/45Lcufrb
         s7xIJYVSPL0tUA67iCIFzgGyBJWPW9uv0YSfop6vKP8MJcoNdXBRrthFF9GUPrW0R340
         egT3iXLpRvnAuLzAs1Ypg7lTqxdOw6VFznvk+kDlz+wEbhdu6KL0oK99SR2ja9xEVGiW
         oaX2FIK7Q8y/4UU6RNMGrXSigjGHLjZiTI6pFOOe1ZHJB/8B263NJUQMasJKj8nu/FNb
         CIDA==
X-Forwarded-Encrypted: i=1; AKwUvBxN2zPwZF4qqW6ffFYZk+zdYn/g+eQS7/+b+fDNQeiVO5h877tZiql5aE/7xaEBxe9K5Gmwi1I5hA==@kvack.org
X-Gm-Message-State: AFq9FYLN4PtP80SIv3QtLj7zazYwRoVzmrbaBmNzIll10yVrnWbPmxtP
	I51161r1msdQgAvROxamOLsZNkUyPsyazzP6TiebmF1PY9RW/WxailzHrUNuKqcmtg==
X-Gm-Gg: AYBFou1Uv5Xy0oP63uRBJoplK4pmf8pT9eQPzOI415KWV1RTFbwZDpjnS7BbcSvW7UI
	oFqCMMzsDKaJSonj8R5O/4D4Ps9yX2ZBpihrmgwG9gFfE7V3Vzrjz0K+jabtz5hL59Z8+Tye9lx
	r/jg00UFsCEJ4dRUSEHLET44GlmY9QJu/xdTApoYuldLZEqqXULoLCmoQ5A24utbezXZTsttoJ/
	WFQNyyTYr4ptwSfKs4NLRK0TTfvfkvw+e256yjT14nFIhsFd+UNyLOi4DCStHm6JyVrK3a2hQyA
	3/B4e1H+v+jUJ8hgfZhEygOzrkMwGLL+ZWtFsW38Dwox0iulEBYrJE4Wj1lFdiCsqA8ak60WXZ5
	BsRPUvHbuxG3bF1VQfzPx4ueqwHnZp2AQmHVMBBK7jcX/o2t9yGDiKn/70sdy1zVABgTsRpgTOJ
	pWFYTHCpImuQ7bThd1MP+79qCY6oQMNMXe/sxM9zAePLWPaFVKpPL9V/oU7ItekK2QKd7BECPDU
	sVxCWnjWdhdkuietT4Gsf9i//hyy7yBrniTXFhc7KF6mzNPQriS1Z0cPURSuRg=
X-Received: by 2002:a17:903:320d:b0:2dd:c100:7cc8 with SMTP id d9443c01a7336-2e842cd7525mr8918245ad.68.1791529951295;
        Fri, 09 Oct 2026 00:12:31 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:383b:5817:8167:5051])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b19a2sm4483535ad.46.2026.10.09.00.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:12:30 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 06/11] zram: lz4hc: use LZ4_decompress_safe_usingDict()
Date: Fri,  9 Oct 2026 16:11:29 +0900
Message-ID: <20261009071157.3730698-7-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261009071157.3730698-1-senozhatsky@chromium.org>
References: <20261009071157.3730698-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 69B4240006
X-Stat-Signature: 6oges5mdd8z5skf9sdg1ssjhg6nsueri
X-HE-Tag: 1791529952-717902
X-HE-Meta: U2FsdGVkX18lpTAeXpH9DSZ3f4xHj9l01IYVrzsLoNslcLCj8+GZfG1E8EefhTTqJGddCS6WeXl+fTMotiiGD6GOn/pOsFqPRIE1oXyj6D+xDQf42eOLQWagtmCdaS19bO6qCFQYNZ5Q+qYH2BC6fSLA/jStu9mZYc+anVoKtWsrRpjdhDayaA08jT97l4MIQ+7PL+1L+Idw+Kz20wSpnb+7E/SNj1bN1s3sdrf6AJijtpoHVoNfBMxE6+NlRv9IST6m+pKGOgs1JIR5Tuh4CnMevnJtkMKZQ/SBavcujmqMUwG6+uf4548itfLJy2XYyMsyEfm7yGH8gDV2NQZIo0kHIJqgc9gjsMIH72J6+wDRmojUDB1Abozu53z27Jg3PdP9rNHlBmahXctg7uywddk+qn+BFrMfApLsl+TpZspSMt6ps7NcCNBM4dfqpSJ3WpmFRK4MrXT0Q2qharK4XSfKPGmzPUYuap7dmkyQ9FuzKGIWb+N43g+m5S2GyBg5PRDjVfGa/XzZaM2sd7NT0581RIl8fwmdBcQTqlhO7TRGwFXkyX2xvwzFGkpXqyNWgIsghX0z0C8AE2lyQnt3DAclTBP4e+air75QzjIXgMbes3dIbcE1Sr0Qe2kYWaf0dOUR048orl04mJUSYPZMQ7xBlEY5Qfr1Swpo8BzBwUI6E5WV5RyHaB80KNEqB0AYTJbX4PySobR9WuPB/qGzXaT6dUvXHYylcjBq62pHzAznDUfNpN27jNM7GM6HPCB8RXS06DKXIE82tWdZOOjEPMAOnGH6nVXeIDs3gSbcwe3C3g6lTPsoFOH8qRfxKI4aMbaJIVDpZgSGuah8k2QWlaKWGYDwsd5Rj/bwaJgaq7Q4HJkpKTxUWUepd88oYuWr//VK7pgEwn4FSH2PJBepCm+2eNg0cC0yaYaNmm0DKl011m7WNfoUrHxtsEyFasph4+Ol1vwCkC8m/UveBG4
 0Jv7vIPh
 VuI2cSVxqgxwvYQnpOxIVPv0DVQOcaZHFyou3MdHFnVBQmMGLf57LOma6F8Cus+2KHBYBcU1r4Ytwn+XPk1wr0j2Wt3Nigpc2tNsPRd9zAdYkT29Q0JVmDQ0iJ94OG9WwoeumyeICymWnkZphr80cJcstQ6H66AecZFrKeePhNG6WbXzZHCQ7tVXC6GP+Loc0baFUfPXPED6QdgUQ2GP8uIi2uXtgPsxN/po9YCNFbVI3+UdT+ZtDCYsFhYL7M64H+tW9ra9BI2hVUtrQ8scYsecp+5sFIClCV9V7sf3Tzj/594lf4DTYbNU4t87IyVNqBn+wsEDMva8f5UcuAEY1v2n71CWN0UrEv3r5HRYunOR0JXtMgrtYc4jdtg==
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


