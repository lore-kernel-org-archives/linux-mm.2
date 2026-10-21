Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F7B760A2622
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=QyPZXpHC
Received: by kanga.kvack.org (Postfix)
	id 3E2EA6B05C7; Tue, 20 Oct 2026 22:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 392FC6B05C8; Tue, 20 Oct 2026 22:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2337C6B05C9; Tue, 20 Oct 2026 22:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0381F6B05C7
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:43:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 865AC140402
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:43:06 +0000 (UTC)
X-FDA: 85345086372.02.61A6969
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id B6F9D40002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:43:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QyPZXpHC;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzRBudk57Qqbwf1gK+hPpqIGBBSPqnwfDQYwkBHugqY=;
	b=sRMK6MDhWuCYQz7XSJDG5bs1FDPJ3mR+W+NqtEOnwEBTX/D9hd9TslAuFr0oN7X5KVB974
	PadVgKhByFlmtxuKZ0kaau3lasNGUXaH0Pi11m3uT7GG8dyosRDrLsKDjpA+QllPBOWH7V
	HjTCqxCWauV2d9ATVjyO9FtpeoLOfpg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QyPZXpHC;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550584;
	b=t63dAg68ylbEdndoKyGbZpdbwdPVvRJWL/AUZOApqevtXnV1q2bZ9NTDzsgj+S8QbUk6al
	wUFuGwtIuXT6fYffuPL2IzmgkoDxUkEMceTYPUXOU0OLGjBHEc8crdY9VUbjLqmbHYKu6J
	PlC9zT2972syvMJcZzXCqqkEiqtGfto=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-3282db206d3so535811eec.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792550583; x=1793155383; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yzRBudk57Qqbwf1gK+hPpqIGBBSPqnwfDQYwkBHugqY=;
        b=QyPZXpHClClu+VZcknFBlC7WOhH224TdrHmo45qoX8kidJWFqoImR7gt5yQLnMWWKd
         /OLwoWxHpElpZLogCC/qMYlTGVP7zdFLNQZBfiEbH21OQH5wpISYLRNSGO7aRYpA9IA1
         WnwYDuLOp7x+7w31iNpiU9BwzgsdGQFzHXiCk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550583; x=1793155383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yzRBudk57Qqbwf1gK+hPpqIGBBSPqnwfDQYwkBHugqY=;
        b=AlBT3Wjsr/6iHjGJ8EiTr0uYVCa7ZZ95nqTOPePlTKIyDWjAEoiDYXRyYBGp27fpEi
         n98c5lNC8VuIY27YZ3t27sw1BZXCfdSY5aTcVVZwB/RM7tEIrnTNgS8h2FIFAFufkfm5
         fOPdG74fKuRhsP5ppEToRt/PrV8NRwVkhXseVQx54h5ncWmvuv5x1EW7vT6iBQIUs5XA
         jD2uyNZiaizQpt6qnrmMWQh54axo4LJ9NIgUeZfWndQah+NbsH5Ef7pTaz9ekZ+lf5DI
         oZMPNrPETEaN3Wfxp8jjDhgjJNVFNx3DjgQeVjNAGYdlIjeGXqjwV4iEXqzwNHh8K04A
         dnvA==
X-Forwarded-Encrypted: i=1; AKwUvBzZNinaxIFig5L+8ZPcX/a8yTlGA5GGSW5fcbYRzS4tJJUEboLc49TIcOEOmBHoZOLFR5b8m+de7g==@kvack.org
X-Gm-Message-State: AFq9FYLBRFbx59ssEtu7KbhZZPOEMdItQgletG+d9blNDFknarSyt7pL
	rhWBPjx+i3Gvsu1yt1xn99OOCiP8ypo9qwWHjUuRjbvmgxQ+Zm+Ac+zWlXTkBdRocw==
X-Gm-Gg: AYBFou0wRu96oStyzz14jqHDxwhulaSqO19Dop9T+sT7nkABab5sm9joA/+tzXuLhmf
	iS4UOuYA01t0MoGsWIfF4kYnYZlIxLiXk/w2vuUPQSlb9Cbvl+4zgky+He+qSW5X8g/JFRDoWw7
	brI0sDWOEcJfQXRIHZoR+YYRBUjwQz5F2PBW2gJunn6G4hr/MylgmWDC93I2Zgx8KySKmxAg1mz
	Z22j94fo2AzGZvyRFTBBUxoOPxz/g2qU4suUBJ1XMcceR7v0XD2QIeJySjfTz8wAKGCYnEmhmZz
	GD3ydBa2Ee2NDJjO+ol+2a4EcsTqZKO9/X5Fy6h1IAu4tQTYcx39meoemdgtGtUBUOL6fSr8Pga
	K7h6Wb90Ewhrlu+EkRWMS76GunybtNC6+CKAlWHyBCl82Ef0I3e/EcLl0WJQBSA1FsGUL5Za/Dz
	NqKVJ+mMYIFIng0KHaeb7eZkJDFxJjaxxJZ6ZVbCsT9W2detdkyjBDWmJUndVhrCxt1DrlvXsy4
	frsNd913LO3+iJxgfnwz1vRazas0W3lBqEl42NwOm/8VqMr5dU4/8xqR+P/QgAiChHVEYOuYz/d
	77ciU5ncVNSUhvDANZ7Db80AmkHIykkWnFIgJ7jj5nuxPuC2OI+HH4vRjeYYnhTl6g==
X-Received: by 2002:a05:701b:2402:b0:187:eb7f:bb4 with SMTP id a92af1059eb24-190a794290fmr879686c88.46.1792550583525;
        Tue, 20 Oct 2026 19:43:03 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:97d1:a8be:236d:bf79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035c0c9a6sm2392047c88.3.2026.10.20.19.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:43:03 -0700 (PDT)
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
Subject: [PATCH v6 07/13] zram: lz4hc: use LZ4_decompress_safe_usingDict()
Date: Wed, 21 Oct 2026 11:42:17 +0900
Message-ID: <20261021024236.1787884-8-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
In-Reply-To: <20261021024236.1787884-1-senozhatsky@chromium.org>
References: <20261021024236.1787884-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B6F9D40002
X-Stat-Signature: zinq5zf7f3ktqci49yuyaybu6qeh75y7
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792550584-921902
X-HE-Meta: U2FsdGVkX19TTsuCBR3Krhg2fGYh2jk6v9O8vz6o8O9KTqDovBIZdivWv2oNmUJjYe4zRGdAgxtli9DA6ZBBsIIdPrDPouHKgB+4/5ks3KPMK5za1Qa4p1YeWTf6+FMI7YNfze64KXxlyv03ZQ25yWLVR685Ou4Kf64DwQ7DfOd3fhEc6ssfUgOMmabndBaloYZYo1nMjxpXp/t6BbA3RdnbaAwY/KLleQkl17R4STjKFHWu5SGcT3TxSavTZOmFPMol+zGzmYuwE3g5eJjfKk/ofkOBQbw9WJ1WSSMah8IB9F0BwqkCMpZTDXGvrD2Iq0eibY1HHJi/oZrCNeCngRmgRQEcDbpxL4q61JhsePpgnMUDIQ2c+WC42/ftKXyzxDr2G25QRk3oxoULpfpswkdbp5xIs6K/3CUhktI4c0q4jt3wvy1BkvSlatqdFiLUfPo3QloiVlgCY/vDmxerw+f3Tnhf/zM/3l3T3fjMRSVsbT+YbVLQQfQCMAHznN0cXKIgMeXb2PzWaBBJbFibBgNZikU5c2xOCaKS/PpN7Z6105unv2+phel0cd0nIRdkB4sC3RCXEo/sxvgqSxyk/IcdL5gxiTj22p6VyZD04cGk2FT1TqD7f6IJJRnSsEVJCMkSyUKIItc2kJ8d1IakSP5EUBxYB/Dyo6/p4kdVH/PbNxAaQqSUSyd3FNyT+7A8n0gkXge+xapakKQnydLfAYqynWuDF7VDrAgH6fetrvtNlVkuEPLw9zsFWqwbvRHtCRShbtiza+Brme1ohrPvH9R1UoYeClMKz2vZw4hVrcItz0o0TBm3VTKpVaeO6ElTMDMa9fH6Cd1Xpe9iWvT7nMTYDr4nf5KrzxYMwLngOJyZWqDulM+DsxdRMKP3qQwTj23jIbKxXlvJXWLY/fo24hgjWPyBI+7nQt9dHPj8mTC/TPCoZHhk9ARMztoVjt+fbfLzMxh2YtQOhAHijHA
 ySFzwcpB
 Aq+XklLoZxzHD0/qHH8jOJvW1XlO6/1VXbxG+Yb/ahPcNaFCt5OYRcVv3a9+1GbU7PMCGLOOSZLyvyBO8HvUpkhdegOZIkrcwYr89l9Jy0lvTJ0FWLf5fwhBlZ2XipohOrANAlNG6yefryl4nIcw5nKY9YuQpqPfz7rQ/5eGfPYc2sjUyy3OY8j2lb2VT9+rkuf/Gojzcl9TIFjeGyfkls/MZay3LRD0qgybm861qHQL/1cBygcsK4sHp57njDTk+K+Em98Af1HqPE97AEETlcUFYdMkvBGDJrU0us4yLbQ0CVOoE2psh3g8cM7Ou2ZNZymaMKtAGHI4FQyclo1mFFyMSE1lYERuOmE3pp6fkl0PXfS/9y6Kym97tNA==
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
2.56.0.212.g129ede20d9-goog


