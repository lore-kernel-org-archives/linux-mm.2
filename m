Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 486A8CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 03:52:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3D456B009E; Sat, 17 Oct 2026 23:52:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5BA6B00A2; Sat, 17 Oct 2026 23:52:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54126B009E; Sat, 17 Oct 2026 23:52:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9C096B009F
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:52:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0691116045B
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:52:13 +0000 (UTC)
X-FDA: 85334374146.26.438E813
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5043320003
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:52:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Fb0vG0C/";
	spf=pass (imf31.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792295531;
	b=aXCqwIT9fYhmpy937m3zLvBWDET6hdSnN/0BCVXWi23nnOeSBPlBR89HlDglavwCpM867X
	nynjbKLg2duiKAXrDjv0SGvyK0h3N044o+9pQTuTTK9ABpZhWnE5WkjwgjhtqWOZfcgOwW
	9MAzg+YimUo6Q7igwrOO0kO0jKNw6co=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Fb0vG0C/";
	spf=pass (imf31.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792295531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fme5Fc1fXAmcFrf6wN2HCLF0Z6nwqFMyz+eMc7qbO7s=;
	b=DTY/2Hkef5Hg7rdfr4FzZusXlToUalbBewHJ8cfTHZvaQzBTs/oVerm/Ie1WUPnemRwyDT
	+tkw41etyzwthTuH64XU7+scEi56ZeoeE6phaAn26CsclTVfa5t+QfV/N/3qIiWAqrKfrY
	9cFlMPTTS5F6Td6mbsJ7489IOf26YJQ=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ac451e128cso710321a91.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792295530; x=1792900330; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fme5Fc1fXAmcFrf6wN2HCLF0Z6nwqFMyz+eMc7qbO7s=;
        b=Fb0vG0C/tsKYSR0YwWfAn8ycrJ8vzXszTEDCGt+h1EKMY+zz5LBqSTtsIBC5nsFCef
         nLEkHILaJI0AqdTBOhRV2gc2Fgabtp5vHNNYg0sK24iTRvl/ZdgZnmLt26UKN/5pGNZo
         RRppU/7IHZIk1j7xLMcNDbHYwdBUYtngOMdyY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792295530; x=1792900330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Fme5Fc1fXAmcFrf6wN2HCLF0Z6nwqFMyz+eMc7qbO7s=;
        b=m4BzM7bVn98H9iFxi61RUbVxTFrxMi7QSs731Amfsonebrw3jl7iqOyZamENGneGEP
         hsdcCtq0Q2n8D785I8LaoR+mIlOd+1b+BC6IV7PX8eXuQxzTKd9YjMHmNMrTLqSn1vko
         gre2JKCWpV2i/D3k4eETX4GwzUvU58UinLHC7lY+L5qhzSlJyfF1gxoxkX286n7+0mQR
         jFyvXgkLFajcWjBFWZ7JPOq1ei3+ru67wzOlz6iNY+MAUx9Y5DpgEYrFZipQVWV4YJx7
         jUeqBRX6e8i0EuXtXd6RgG50CN0c45UD5HIj7PKByh0DtuwD5yvULR7yPrJehKn68Ctv
         0OcQ==
X-Forwarded-Encrypted: i=1; AKwUvBz2xtO/Prssos2C05fRYbu7sutnAi/QgAD4+CT65gIeltmL4c8k3ZFt+C5c4WOFB2W4Fgef3IaADg==@kvack.org
X-Gm-Message-State: AFq9FYICQAIBZNGVibD5Etx1FtYYkKmX3e11kRjsbp04yAmbyxd+IFyl
	GzD+Mto/wL5U5RG0iKsuz0JYOqjqWVQGwT5K+M6a07LyW6IyqtTS5S38LUH0TmwW0A==
X-Gm-Gg: AYBFou395n1L9hWR3mzG8DHG/FlqLBCiefWtMK6DAKomoCyA6i1eI+yPXiNJsvkHC/U
	zTUnDl/tiTvAHQ4UZ3gx26nAzQ/acF/tfjA+WsxGV1w3oLbUi+yYoORgNxaxqKZHREJuIIqL8Wu
	sH41l8bR0muLWinbB7JvYKJUjqDmM/R875oc0LGUigPO7fyAEnodlO0H4l+6WSrjv0AOJ1YrWiV
	3T6FAfDNPUfsQ0oSu+dl7w/8aeyLr+Es6vcKAOpci2tdTnNJ9qyKbi94UR/b1m24RwOw4sfzqj2
	twviX74eQdgKrEjo02XnZ/I70ktwvG+cMcN7dnJp+4w9Nw2WQtAOzxUDSlHHCtUU2LxGHNScVQZ
	HnYZzk01uQgL9STdT1Ye0aYOsyJgR3ccN/QojcuqE0rBfoRA9tMIyMMkQg/z1nl9vlbXp5xEdL8
	qo2rM5Jm/nH6pyymF41gv343ggcN8Hhh2TfbELfitDuObltb8JxVztvM8+5rpLVV4+ICJV0qGyP
	QD4E8luoeVHo3Uavc427kKNvCUshBuDsKZZL+ECYV3olQEBzKzyHaZTMzjv6Xpfaw42qgUQNg==
X-Received: by 2002:a17:90b:57ec:b0:3ac:6fcf:81a2 with SMTP id 98e67ed59e1d1-3acef5c49bbmr3585965a91.57.1792295529916;
        Sat, 17 Oct 2026 20:52:09 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:4569:b311:f3ea:5f8d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad25d5d1b4sm253024a91.16.2026.10.17.20.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 20:52:08 -0700 (PDT)
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
Subject: [PATCH v5 09/13] zram: split zcomp into separate R/W streams
Date: Sun, 18 Oct 2026 12:51:11 +0900
Message-ID: <20261018035125.3120704-10-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261018035125.3120704-1-senozhatsky@chromium.org>
References: <20261018035125.3120704-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5043320003
X-Rspam-User: 
X-Stat-Signature: tsqdoxrqymr6edppi8be7gtuyjd6m4o1
X-HE-Tag: 1792295531-374867
X-HE-Meta: U2FsdGVkX1/iLrMG+BcklnDnYAxWrrze55yMY6+AMC0VQ/8O3tV/Uf9pgc2YQRfu+d6nUd2DvJOqqjcxzL7igLqLjCmprbXKEiTBn/R1IM5xftGYGUqNdCDaiTMhiK2WExyzwCSVU3pTXulx/XLdmZ1tJ/5LzFgsoZ6f8meWaE/Vqei/OVMWSJi7wWesJ3YWAvCeNoSYvdPZ2vuf9E8h2JSJzP5/fid6Nvd6vNPTzBaprCg/xEU9yVA4GbItB952phSiwVB/5tJKhZ7jNQmOTgHlOAaDLTgP+bLvIwgm4SyUWPD1cAJfs4tXfh9KnW2TF7OoPvmCvu17RZBnd3oC/JHdOWU7rD94XQyxh8OKGkAKEuxNOB4IgFTuEiF5AVgHDuVq7VdHAIHL7FOzIchT6fCRMmjxlR1q8OaucZqaKha7K5HreQf4pps33cLV/5ACk/eZ3UAui+qq2ebe0aYV6o1phSOeo4VwtSsnvPpyWMcXq2oMgFwvPHndVo3z7tPDhKaxEkP8JiPiyzG7SoxkPfjfCXSvJFPO0m0bGwj+/ieILvMXYIGc5/d1TDSQqC7daJyAtkqBdcJqP33JHtS24hmd9oArMevVCxprygB4IRgo0sm62dsj9kTOmCxYSFH5pivn9nWWIS1Yu2hwgg1TgdfOaJUWam01VRCfm1HNvcWKzEzuoo/MOWeNCEicPLLsnYBRJtt6s2BEElcTlPjAGlPWIT9wQnNQF/kOyHH6XrYiDMDxa4y67cBquRnX3VLGzhmI0serr/yEVUXMGAiu4wFD/ptR0iuST81zojQ352gvzIwihW7QejDyuIBv2zJtrjICZu0kFqsAiuxs+u0z8YR0Ib7ODX4oeu72hxkdUZxhNuI46Ao2WTeT4Gk/tfe+ECDItv0pW5DcithcnBzPpYoLg95VHE54R8kmoyTRqcmKlzKdP0FApMwD7iapxISbPq7q6iYDiY+pge43QPB
 nJUDy/4z
 i5e/GTNvxMgkxNfJ77yVwHwxoMZlJ6KBjeytb77Ay10q1lhCaKuX7BMRA404F+Q1mb67T4Iwm01PX4hlMf47Yv4+OLvP7WVvO4U8dqt1sq97aO1ad4QX/sRwT2tNmv2kt5BnYmesGThuw3VuSi2hRtO7GJcUytM0A+IRkiLbPgmErvUt9JaLC5aAKYvyaGV98bPiG7LNRZY0MQ8h990Pj8FA3+qQfYYkc6s5kGFQAkSwDMVrv/aLBJJOYsCujlgkieP6d5mzeIcda5NOESaIX0e7dRAF6JV5kN7kYxqxOUqD0/XvmaKM1gwOJ4z8ZJuPR2Co2nTX27ALJv70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Split struct zcomp_strm into separate compression (Write zcomp_cstrm)
and decompression (Read zcomp_dstrm) streams, and split zcomp_ops
context creation/destruction into create_cctx/destroy_cctx and
optional create_dctx/destroy_dctx callbacks.

This decouples Read (decompression) and Write (compression) paths so
they no longer contend on the same per-CPU stream mutex (Writer vs
Reader priority inversion).  Currently, a (low priority) Writer that
holds the stream mutex can be preempted by a (higher priority) Reader
on the same CPU, which then blocks on that mutex until the Writer gets
to run again and releases it, which can take a long time when there
are other runnable tasks on that CPU.  The good news is that Read and
Write contexts are completely independent - compression uses its own
scratch buffer that decompression never touches, and decompression
uses its own local buffer (for spanning zsmalloc objects) that
compression never touches, so the Read/Write context split doesn't
noticeably increase memory usage.  In addition many S/W backends have
stateless decompression contexts.

A quick synthetic fio test for Writer vs Reader inversion on 24 CPUs
(preempt=full, zstd, 48 low priority (nice 19) writers, 24 normal
priority (nice 0) CPU hogs and 24 high priority (nice -19) readers):

  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        207k               1,150k        (+5.6x)
  Read clat avg    101.50 us          7.76 us       (-13.1x)
  Read clat stdev  5,615.90 us        30.78 us      (-182x)
  Read clat p99.99 258,998 us         111.10 us     (-2331x)
  Read clat max    1,342,600 us       11,217 us     (-120x)

Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_842.c     |   4 +-
 drivers/block/zram/backend_deflate.c |  96 ++++++++++-------
 drivers/block/zram/backend_lz4.c     |   7 +-
 drivers/block/zram/backend_lz4hc.c   |   4 +-
 drivers/block/zram/backend_lzo.c     |   4 +-
 drivers/block/zram/backend_lzorle.c  |   4 +-
 drivers/block/zram/backend_zstd.c    | 119 +++++++++++++---------
 drivers/block/zram/zcomp.c           | 147 +++++++++++++++++++++------
 drivers/block/zram/zcomp.h           |  28 +++--
 drivers/block/zram/zram_drv.c        |  38 +++----
 10 files changed, 298 insertions(+), 153 deletions(-)

diff --git a/drivers/block/zram/backend_842.c b/drivers/block/zram/backend_842.c
index 56ffda201727..f911cd1ca72e 100644
--- a/drivers/block/zram/backend_842.c
+++ b/drivers/block/zram/backend_842.c
@@ -63,8 +63,8 @@ static int decompress_842(struct zcomp_params *params, struct zcomp_ctx *ctx,
 const struct zcomp_ops backend_842 = {
 	.compress	= compress_842,
 	.decompress	= decompress_842,
-	.create_ctx	= create_842,
-	.destroy_ctx	= destroy_842,
+	.create_cctx	= create_842,
+	.destroy_cctx	= destroy_842,
 	.setup_params	= setup_params_842,
 	.release_params	= release_params_842,
 	.name		= "842",
diff --git a/drivers/block/zram/backend_deflate.c b/drivers/block/zram/backend_deflate.c
index 20685aca9bdc..5ffdaf80d8cf 100644
--- a/drivers/block/zram/backend_deflate.c
+++ b/drivers/block/zram/backend_deflate.c
@@ -13,11 +13,6 @@
 #define DEFLATE_DEF_WINBITS		(-11)
 #define DEFLATE_DEF_MEMLEVEL		MAX_MEM_LEVEL
 
-struct deflate_ctx {
-	struct z_stream_s cctx;
-	struct z_stream_s dctx;
-};
-
 static void deflate_release_params(struct zcomp_params *params)
 {
 }
@@ -51,70 +46,98 @@ static int deflate_setup_params(struct zcomp_params *params)
 	return 0;
 }
 
-static void deflate_destroy(struct zcomp_ctx *ctx)
+static void deflate_destroy_cctx(struct zcomp_ctx *ctx)
 {
-	struct deflate_ctx *zctx = ctx->context;
+	struct z_stream_s *cctx = ctx->context;
 
-	if (!zctx)
+	if (!cctx)
 		return;
 
-	if (zctx->cctx.workspace) {
-		zlib_deflateEnd(&zctx->cctx);
-		vfree(zctx->cctx.workspace);
-	}
-	if (zctx->dctx.workspace) {
-		zlib_inflateEnd(&zctx->dctx);
-		vfree(zctx->dctx.workspace);
+	if (cctx->workspace) {
+		zlib_deflateEnd(cctx);
+		vfree(cctx->workspace);
 	}
-	kfree(zctx);
+	kfree(cctx);
 }
 
-static int deflate_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
+static int deflate_create_cctx(struct zcomp_params *params,
+			       struct zcomp_ctx *ctx)
 {
-	struct deflate_ctx *zctx;
+	struct z_stream_s *cctx;
 	size_t sz;
 	int ret;
 
-	zctx = kzalloc_obj(*zctx);
-	if (!zctx)
+	cctx = kzalloc_obj(*cctx);
+	if (!cctx)
 		return -ENOMEM;
 
-	ctx->context = zctx;
+	ctx->context = cctx;
 	sz = zlib_deflate_workspacesize(params->deflate.winbits, MAX_MEM_LEVEL);
-	zctx->cctx.workspace = vzalloc(sz);
-	if (!zctx->cctx.workspace)
+	cctx->workspace = vzalloc(sz);
+	if (!cctx->workspace)
 		goto error;
 
-	ret = zlib_deflateInit2(&zctx->cctx, params->level, Z_DEFLATED,
+	ret = zlib_deflateInit2(cctx, params->level, Z_DEFLATED,
 				params->deflate.winbits, DEFLATE_DEF_MEMLEVEL,
 				Z_DEFAULT_STRATEGY);
 	if (ret != Z_OK)
 		goto error;
 
+	return 0;
+
+error:
+	deflate_destroy_cctx(ctx);
+	return -EINVAL;
+}
+
+static void deflate_destroy_dctx(struct zcomp_ctx *ctx)
+{
+	struct z_stream_s *dctx = ctx->context;
+
+	if (!dctx)
+		return;
+
+	if (dctx->workspace) {
+		zlib_inflateEnd(dctx);
+		vfree(dctx->workspace);
+	}
+	kfree(dctx);
+}
+
+static int deflate_create_dctx(struct zcomp_params *params,
+			       struct zcomp_ctx *ctx)
+{
+	struct z_stream_s *dctx;
+	size_t sz;
+	int ret;
+
+	dctx = kzalloc_obj(*dctx);
+	if (!dctx)
+		return -ENOMEM;
+
+	ctx->context = dctx;
 	sz = zlib_inflate_workspacesize();
-	zctx->dctx.workspace = vzalloc(sz);
-	if (!zctx->dctx.workspace)
+	dctx->workspace = vzalloc(sz);
+	if (!dctx->workspace)
 		goto error;
 
-	ret = zlib_inflateInit2(&zctx->dctx, params->deflate.winbits);
+	ret = zlib_inflateInit2(dctx, params->deflate.winbits);
 	if (ret != Z_OK)
 		goto error;
 
 	return 0;
 
 error:
-	deflate_destroy(ctx);
+	deflate_destroy_dctx(ctx);
 	return -EINVAL;
 }
 
 static int deflate_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 			    struct zcomp_req *req)
 {
-	struct deflate_ctx *zctx = ctx->context;
-	struct z_stream_s *deflate;
+	struct z_stream_s *deflate = ctx->context;
 	int ret;
 
-	deflate = &zctx->cctx;
 	ret = zlib_deflateReset(deflate);
 	if (ret != Z_OK)
 		return -EINVAL;
@@ -136,12 +159,9 @@ static int deflate_decompress(struct zcomp_params *params,
 			      struct zcomp_ctx *ctx,
 			      struct zcomp_req *req)
 {
-	struct deflate_ctx *zctx = ctx->context;
-	struct z_stream_s *inflate;
+	struct z_stream_s *inflate = ctx->context;
 	int ret;
 
-	inflate = &zctx->dctx;
-
 	ret = zlib_inflateReset(inflate);
 	if (ret != Z_OK)
 		return -EINVAL;
@@ -161,8 +181,10 @@ static int deflate_decompress(struct zcomp_params *params,
 const struct zcomp_ops backend_deflate = {
 	.compress	= deflate_compress,
 	.decompress	= deflate_decompress,
-	.create_ctx	= deflate_create,
-	.destroy_ctx	= deflate_destroy,
+	.create_cctx	= deflate_create_cctx,
+	.destroy_cctx	= deflate_destroy_cctx,
+	.create_dctx	= deflate_create_dctx,
+	.destroy_dctx	= deflate_destroy_dctx,
 	.setup_params	= deflate_setup_params,
 	.release_params	= deflate_release_params,
 	.name		= "deflate",
diff --git a/drivers/block/zram/backend_lz4.c b/drivers/block/zram/backend_lz4.c
index 5f2e27805d75..9767482a2fea 100644
--- a/drivers/block/zram/backend_lz4.c
+++ b/drivers/block/zram/backend_lz4.c
@@ -38,8 +38,7 @@ static int lz4_setup_params(struct zcomp_params *params)
 	if (!dict_stream)
 		return -ENOMEM;
 
-	ret = LZ4_loadDict(dict_stream,
-			   params->dict, params->dict_sz);
+	ret = LZ4_loadDict(dict_stream, params->dict, params->dict_sz);
 	if (ret != params->dict_sz) {
 		vfree(dict_stream);
 		return -EINVAL;
@@ -102,8 +101,8 @@ static int lz4_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 const struct zcomp_ops backend_lz4 = {
 	.compress	= lz4_compress,
 	.decompress	= lz4_decompress,
-	.create_ctx	= lz4_create,
-	.destroy_ctx	= lz4_destroy,
+	.create_cctx	= lz4_create,
+	.destroy_cctx	= lz4_destroy,
 	.setup_params	= lz4_setup_params,
 	.release_params	= lz4_release_params,
 	.name		= "lz4",
diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
index b62736b26622..2d1364a29b27 100644
--- a/drivers/block/zram/backend_lz4hc.c
+++ b/drivers/block/zram/backend_lz4hc.c
@@ -107,8 +107,8 @@ static int lz4hc_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 const struct zcomp_ops backend_lz4hc = {
 	.compress	= lz4hc_compress,
 	.decompress	= lz4hc_decompress,
-	.create_ctx	= lz4hc_create,
-	.destroy_ctx	= lz4hc_destroy,
+	.create_cctx	= lz4hc_create,
+	.destroy_cctx	= lz4hc_destroy,
 	.setup_params	= lz4hc_setup_params,
 	.release_params	= lz4hc_release_params,
 	.name		= "lz4hc",
diff --git a/drivers/block/zram/backend_lzo.c b/drivers/block/zram/backend_lzo.c
index 78538479c511..e703560d9ecd 100644
--- a/drivers/block/zram/backend_lzo.c
+++ b/drivers/block/zram/backend_lzo.c
@@ -61,8 +61,8 @@ static int lzo_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 const struct zcomp_ops backend_lzo = {
 	.compress	= lzo_compress,
 	.decompress	= lzo_decompress,
-	.create_ctx	= lzo_create,
-	.destroy_ctx	= lzo_destroy,
+	.create_cctx	= lzo_create,
+	.destroy_cctx	= lzo_destroy,
 	.setup_params	= lzo_setup_params,
 	.release_params	= lzo_release_params,
 	.name		= "lzo",
diff --git a/drivers/block/zram/backend_lzorle.c b/drivers/block/zram/backend_lzorle.c
index 011787f1430b..e95026e99202 100644
--- a/drivers/block/zram/backend_lzorle.c
+++ b/drivers/block/zram/backend_lzorle.c
@@ -61,8 +61,8 @@ static int lzorle_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 const struct zcomp_ops backend_lzorle = {
 	.compress	= lzorle_compress,
 	.decompress	= lzorle_decompress,
-	.create_ctx	= lzorle_create,
-	.destroy_ctx	= lzorle_destroy,
+	.create_cctx	= lzorle_create,
+	.destroy_cctx	= lzorle_destroy,
 	.setup_params	= lzorle_setup_params,
 	.release_params	= lzorle_release_params,
 	.name		= "lzo-rle",
diff --git a/drivers/block/zram/backend_zstd.c b/drivers/block/zram/backend_zstd.c
index 7a8b5ff186f2..d55615f34300 100644
--- a/drivers/block/zram/backend_zstd.c
+++ b/drivers/block/zram/backend_zstd.c
@@ -10,10 +10,8 @@
 #include "backend_zstd.h"
 
 struct zstd_ctx {
-	zstd_cctx *cctx;
-	zstd_dctx *dctx;
-	void *cctx_mem;
-	void *dctx_mem;
+	void *ctx;
+	void *mem;
 };
 
 struct zstd_params {
@@ -105,7 +103,7 @@ static int zstd_setup_params(struct zcomp_params *params)
 	return -EINVAL;
 }
 
-static void zstd_destroy(struct zcomp_ctx *ctx)
+static void zstd_destroy_cctx(struct zcomp_ctx *ctx)
 {
 	struct zstd_ctx *zctx = ctx->context;
 
@@ -113,30 +111,23 @@ static void zstd_destroy(struct zcomp_ctx *ctx)
 		return;
 
 	/*
-	 * If ->cctx_mem and ->dctx_mem were allocated then we didn't use
-	 * C/D dictionary and ->cctx / ->dctx were "embedded" into these
-	 * buffers.
+	 * If ->mem was allocated then we didn't use C/D dictionary and
+	 * ->ctx was "embedded" into this buffer.
 	 *
-	 * If otherwise then we need to explicitly release ->cctx / ->dctx.
+	 * If otherwise then we need to explicitly release ->ctx.
 	 */
-	if (zctx->cctx_mem)
-		vfree(zctx->cctx_mem);
+	if (zctx->mem)
+		vfree(zctx->mem);
 	else
-		zstd_free_cctx(zctx->cctx);
-
-	if (zctx->dctx_mem)
-		vfree(zctx->dctx_mem);
-	else
-		zstd_free_dctx(zctx->dctx);
+		zstd_free_cctx(zctx->ctx);
 
 	kfree(zctx);
 }
 
-static int zstd_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
+static int zstd_create_cctx(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
+	struct zstd_params *zp = params->drv_data;
 	struct zstd_ctx *zctx;
-	zstd_parameters prm;
-	size_t sz;
 
 	zctx = kzalloc_obj(*zctx);
 	if (!zctx)
@@ -144,40 +135,74 @@ static int zstd_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 
 	ctx->context = zctx;
 	if (params->dict_sz == 0) {
-		prm = zstd_get_params(params->level, PAGE_SIZE);
-		sz = zstd_cctx_workspace_bound(&prm.cParams);
-		zctx->cctx_mem = vzalloc(sz);
-		if (!zctx->cctx_mem)
-			goto error;
-
-		zctx->cctx = zstd_init_cctx(zctx->cctx_mem, sz);
-		if (!zctx->cctx)
-			goto error;
+		zstd_parameters prm = zp->cprm;
+		size_t sz = zstd_cctx_workspace_bound(&prm.cParams);
 
-		sz = zstd_dctx_workspace_bound();
-		zctx->dctx_mem = vzalloc(sz);
-		if (!zctx->dctx_mem)
+		zctx->mem = vzalloc(sz);
+		if (!zctx->mem)
 			goto error;
 
-		zctx->dctx = zstd_init_dctx(zctx->dctx_mem, sz);
-		if (!zctx->dctx)
+		zctx->ctx = zstd_init_cctx(zctx->mem, sz);
+		if (!zctx->ctx)
 			goto error;
 	} else {
-		struct zstd_params *zp = params->drv_data;
+		zctx->ctx = zstd_create_cctx_advanced(zp->custom_mem);
+		if (!zctx->ctx)
+			goto error;
+	}
+
+	return 0;
+
+error:
+	zstd_destroy_cctx(ctx);
+	return -EINVAL;
+}
+
+static void zstd_destroy_dctx(struct zcomp_ctx *ctx)
+{
+	struct zstd_ctx *zctx = ctx->context;
+
+	if (!zctx)
+		return;
+
+	if (zctx->mem)
+		vfree(zctx->mem);
+	else
+		zstd_free_dctx(zctx->ctx);
+
+	kfree(zctx);
+}
+
+static int zstd_create_dctx(struct zcomp_params *params, struct zcomp_ctx *ctx)
+{
+	struct zstd_params *zp = params->drv_data;
+	struct zstd_ctx *zctx;
 
-		zctx->cctx = zstd_create_cctx_advanced(zp->custom_mem);
-		if (!zctx->cctx)
+	zctx = kzalloc_obj(*zctx);
+	if (!zctx)
+		return -ENOMEM;
+
+	ctx->context = zctx;
+	if (params->dict_sz == 0) {
+		size_t sz = zstd_dctx_workspace_bound();
+
+		zctx->mem = vzalloc(sz);
+		if (!zctx->mem)
 			goto error;
 
-		zctx->dctx = zstd_create_dctx_advanced(zp->custom_mem);
-		if (!zctx->dctx)
+		zctx->ctx = zstd_init_dctx(zctx->mem, sz);
+		if (!zctx->ctx)
+			goto error;
+	} else {
+		zctx->ctx = zstd_create_dctx_advanced(zp->custom_mem);
+		if (!zctx->ctx)
 			goto error;
 	}
 
 	return 0;
 
 error:
-	zstd_destroy(ctx);
+	zstd_destroy_dctx(ctx);
 	return -EINVAL;
 }
 
@@ -189,10 +214,10 @@ static int zstd_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 	size_t ret;
 
 	if (params->dict_sz == 0)
-		ret = zstd_compress_cctx(zctx->cctx, req->dst, req->dst_len,
+		ret = zstd_compress_cctx(zctx->ctx, req->dst, req->dst_len,
 					 req->src, req->src_len, &zp->cprm);
 	else
-		ret = zstd_compress_using_cdict(zctx->cctx, req->dst,
+		ret = zstd_compress_using_cdict(zctx->ctx, req->dst,
 						req->dst_len, req->src,
 						req->src_len,
 						zp->cdict);
@@ -210,10 +235,10 @@ static int zstd_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 	size_t ret;
 
 	if (params->dict_sz == 0)
-		ret = zstd_decompress_dctx(zctx->dctx, req->dst, req->dst_len,
+		ret = zstd_decompress_dctx(zctx->ctx, req->dst, req->dst_len,
 					   req->src, req->src_len);
 	else
-		ret = zstd_decompress_using_ddict(zctx->dctx, req->dst,
+		ret = zstd_decompress_using_ddict(zctx->ctx, req->dst,
 						  req->dst_len, req->src,
 						  req->src_len, zp->ddict);
 	if (zstd_is_error(ret))
@@ -224,8 +249,10 @@ static int zstd_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 const struct zcomp_ops backend_zstd = {
 	.compress	= zstd_compress,
 	.decompress	= zstd_decompress,
-	.create_ctx	= zstd_create,
-	.destroy_ctx	= zstd_destroy,
+	.create_cctx	= zstd_create_cctx,
+	.destroy_cctx	= zstd_destroy_cctx,
+	.create_dctx	= zstd_create_dctx,
+	.destroy_dctx	= zstd_destroy_dctx,
 	.setup_params	= zstd_setup_params,
 	.release_params	= zstd_release_params,
 	.name		= "zstd",
diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 028e2f0f587e..1c9f6d5c8cd1 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -45,30 +45,65 @@ static const struct zcomp_ops *backends[] = {
 	NULL
 };
 
-static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
+static void zcomp_cstrm_free(struct zcomp *comp, struct zcomp_cstrm *zstrm)
 {
-	comp->ops->destroy_ctx(&zstrm->ctx);
-	vfree(zstrm->local_copy);
+	if (comp->ops->destroy_cctx)
+		comp->ops->destroy_cctx(&zstrm->ctx);
 	vfree(zstrm->buffer);
 	zstrm->buffer = NULL;
+	zstrm->ctx.context = NULL;
 }
 
-static int zcomp_strm_init(struct zcomp *comp, struct zcomp_strm *zstrm)
+static int zcomp_cstrm_init(struct zcomp *comp, struct zcomp_cstrm *zstrm)
 {
 	int ret;
 
-	ret = comp->ops->create_ctx(comp->params, &zstrm->ctx);
-	if (ret)
-		return ret;
+	if (comp->ops->create_cctx) {
+		ret = comp->ops->create_cctx(comp->params, &zstrm->ctx);
+		if (ret) {
+			/* backend has released partially created context */
+			zstrm->ctx.context = NULL;
+			return ret;
+		}
+	}
 
-	zstrm->local_copy = vzalloc(PAGE_SIZE);
 	/*
 	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
 	 * case when compressed size is larger than the original one
 	 */
 	zstrm->buffer = vzalloc(2 * PAGE_SIZE);
-	if (!zstrm->buffer || !zstrm->local_copy) {
-		zcomp_strm_free(comp, zstrm);
+	if (!zstrm->buffer) {
+		zcomp_cstrm_free(comp, zstrm);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void zcomp_dstrm_free(struct zcomp *comp, struct zcomp_dstrm *zstrm)
+{
+	if (comp->ops->destroy_dctx)
+		comp->ops->destroy_dctx(&zstrm->ctx);
+	vfree(zstrm->local_copy);
+	zstrm->local_copy = NULL;
+	zstrm->ctx.context = NULL;
+}
+
+static int zcomp_dstrm_init(struct zcomp *comp, struct zcomp_dstrm *zstrm)
+{
+	int ret;
+
+	if (comp->ops->create_dctx) {
+		ret = comp->ops->create_dctx(comp->params, &zstrm->ctx);
+		if (ret) {
+			/* backend has released partially created context */
+			zstrm->ctx.context = NULL;
+			return ret;
+		}
+	}
+
+	zstrm->local_copy = vzalloc(PAGE_SIZE);
+	if (!zstrm->local_copy) {
+		zcomp_dstrm_free(comp, zstrm);
 		return -ENOMEM;
 	}
 	return 0;
@@ -114,10 +149,10 @@ ssize_t zcomp_available_show(const char *comp, char *buf, ssize_t at)
 	return at;
 }
 
-struct zcomp_strm *zcomp_stream_get(struct zcomp *comp)
+struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp)
 {
 	for (;;) {
-		struct zcomp_strm *zstrm = raw_cpu_ptr(comp->stream);
+		struct zcomp_cstrm *zstrm = raw_cpu_ptr(comp->cstream);
 
 		/*
 		 * Inspired by zswap
@@ -136,12 +171,29 @@ struct zcomp_strm *zcomp_stream_get(struct zcomp *comp)
 	}
 }
 
-void zcomp_stream_put(struct zcomp_strm *zstrm)
+void zcomp_cstrm_put(struct zcomp_cstrm *zstrm)
+{
+	mutex_unlock(&zstrm->lock);
+}
+
+struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp)
+{
+	for (;;) {
+		struct zcomp_dstrm *zstrm = raw_cpu_ptr(comp->dstream);
+
+		mutex_lock(&zstrm->lock);
+		if (likely(zstrm->local_copy))
+			return zstrm;
+		mutex_unlock(&zstrm->lock);
+	}
+}
+
+void zcomp_dstrm_put(struct zcomp_dstrm *zstrm)
 {
 	mutex_unlock(&zstrm->lock);
 }
 
-int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
+int zcomp_compress(struct zcomp *comp, struct zcomp_cstrm *zstrm,
 		   const void *src, unsigned int *dst_len)
 {
 	struct zcomp_req req = {
@@ -159,7 +211,7 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 	return ret;
 }
 
-int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
+int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
 		     struct scatterlist *sg, unsigned int src_len, void *dst)
 {
 	struct zcomp_req req = {
@@ -191,23 +243,44 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
 int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zcomp *comp = hlist_entry(node, struct zcomp, node);
-	struct zcomp_strm *zstrm = per_cpu_ptr(comp->stream, cpu);
+	struct zcomp_cstrm *cstrm;
+	struct zcomp_dstrm *dstrm;
 	int ret;
 
-	ret = zcomp_strm_init(comp, zstrm);
-	if (ret)
+	cstrm = per_cpu_ptr(comp->cstream, cpu);
+	ret = zcomp_cstrm_init(comp, cstrm);
+	if (ret) {
 		pr_err("Can't allocate a compression stream\n");
-	return ret;
+		return ret;
+	}
+
+	dstrm = per_cpu_ptr(comp->dstream, cpu);
+	ret = zcomp_dstrm_init(comp, dstrm);
+	if (ret) {
+		pr_err("Can't allocate a decompression stream\n");
+		zcomp_cstrm_free(comp, cstrm);
+		return ret;
+	}
+
+	return 0;
 }
 
 int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
 {
 	struct zcomp *comp = hlist_entry(node, struct zcomp, node);
-	struct zcomp_strm *zstrm = per_cpu_ptr(comp->stream, cpu);
+	struct zcomp_cstrm *cstrm;
+	struct zcomp_dstrm *dstrm;
+
+	cstrm = per_cpu_ptr(comp->cstream, cpu);
+	mutex_lock(&cstrm->lock);
+	zcomp_cstrm_free(comp, cstrm);
+	mutex_unlock(&cstrm->lock);
+
+	dstrm = per_cpu_ptr(comp->dstream, cpu);
+	mutex_lock(&dstrm->lock);
+	zcomp_dstrm_free(comp, dstrm);
+	mutex_unlock(&dstrm->lock);
 
-	mutex_lock(&zstrm->lock);
-	zcomp_strm_free(comp, zstrm);
-	mutex_unlock(&zstrm->lock);
 	return 0;
 }
 
@@ -215,17 +288,27 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 {
 	int ret, cpu;
 
-	comp->stream = alloc_percpu(struct zcomp_strm);
-	if (!comp->stream)
-		return -ENOMEM;
-
 	comp->params = params;
 	ret = comp->ops->setup_params(comp->params);
 	if (ret)
 		goto cleanup;
 
-	for_each_possible_cpu(cpu)
-		mutex_init(&per_cpu_ptr(comp->stream, cpu)->lock);
+	comp->cstream = alloc_percpu(struct zcomp_cstrm);
+	if (!comp->cstream) {
+		ret = -ENOMEM;
+		goto cleanup;
+	}
+
+	comp->dstream = alloc_percpu(struct zcomp_dstrm);
+	if (!comp->dstream) {
+		ret = -ENOMEM;
+		goto cleanup;
+	}
+
+	for_each_possible_cpu(cpu) {
+		mutex_init(&per_cpu_ptr(comp->cstream, cpu)->lock);
+		mutex_init(&per_cpu_ptr(comp->dstream, cpu)->lock);
+	}
 
 	ret = cpuhp_state_add_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
 	if (ret < 0)
@@ -235,7 +318,8 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 
 cleanup:
 	comp->ops->release_params(comp->params);
-	free_percpu(comp->stream);
+	free_percpu(comp->dstream);
+	free_percpu(comp->cstream);
 	return ret;
 }
 
@@ -243,7 +327,8 @@ void zcomp_destroy(struct zcomp *comp)
 {
 	cpuhp_state_remove_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
 	comp->ops->release_params(comp->params);
-	free_percpu(comp->stream);
+	free_percpu(comp->dstream);
+	free_percpu(comp->cstream);
 	kfree(comp);
 }
 
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index f38fd31f9e4e..22be50dc51ba 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -39,10 +39,15 @@ struct zcomp_ctx {
 	void *context;
 };
 
-struct zcomp_strm {
+struct zcomp_cstrm {
 	struct mutex lock;
 	/* compression buffer */
 	void *buffer;
+	struct zcomp_ctx ctx;
+};
+
+struct zcomp_dstrm {
+	struct mutex lock;
 	/* local copy of handle memory */
 	void *local_copy;
 	struct zcomp_ctx ctx;
@@ -62,8 +67,11 @@ struct zcomp_ops {
 	int (*decompress)(struct zcomp_params *params, struct zcomp_ctx *ctx,
 			  struct zcomp_req *req);
 
-	int (*create_ctx)(struct zcomp_params *params, struct zcomp_ctx *ctx);
-	void (*destroy_ctx)(struct zcomp_ctx *ctx);
+	int (*create_cctx)(struct zcomp_params *params, struct zcomp_ctx *ctx);
+	void (*destroy_cctx)(struct zcomp_ctx *ctx);
+
+	int (*create_dctx)(struct zcomp_params *params, struct zcomp_ctx *ctx);
+	void (*destroy_dctx)(struct zcomp_ctx *ctx);
 
 	int (*setup_params)(struct zcomp_params *params);
 	void (*release_params)(struct zcomp_params *params);
@@ -73,7 +81,8 @@ struct zcomp_ops {
 
 /* dynamic per-device compression frontend */
 struct zcomp {
-	struct zcomp_strm __percpu *stream;
+	struct zcomp_cstrm __percpu *cstream;
+	struct zcomp_dstrm __percpu *dstream;
 	const struct zcomp_ops *ops;
 	struct zcomp_params *params;
 	struct hlist_node node;
@@ -87,12 +96,15 @@ const char *zcomp_lookup_backend_name(const char *comp);
 struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params);
 void zcomp_destroy(struct zcomp *comp);
 
-struct zcomp_strm *zcomp_stream_get(struct zcomp *comp);
-void zcomp_stream_put(struct zcomp_strm *zstrm);
+struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp);
+void zcomp_cstrm_put(struct zcomp_cstrm *zstrm);
+
+struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp);
+void zcomp_dstrm_put(struct zcomp_dstrm *zstrm);
 
-int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
+int zcomp_compress(struct zcomp *comp, struct zcomp_cstrm *zstrm,
 		   const void *src, unsigned int *dst_len);
-int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
+int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
 		     struct scatterlist *sg, unsigned int src_len, void *dst);
 
 #endif /* _ZCOMP_H_ */
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 0e1aa0da11aa..def5266679b0 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1348,7 +1348,7 @@ static ssize_t writeback_store(struct device *dev,
 static int decompress_bdev_page(struct zram *zram, struct page *page,
 				unsigned long index)
 {
-	struct zcomp_strm *zstrm;
+	struct zcomp_dstrm *zstrm;
 	struct scatterlist sg[1];
 	unsigned int size;
 	int ret, prio;
@@ -1373,7 +1373,7 @@ static int decompress_bdev_page(struct zram *zram, struct page *page,
 	sg_init_table(sg, 1);
 	sg_set_page(sg, page, size, 0);
 
-	zstrm = zcomp_stream_get(zram->comps[prio]);
+	zstrm = zcomp_dstrm_get(zram->comps[prio]);
 	ret = zcomp_decompress(zram->comps[prio], zstrm, sg, size,
 			       zstrm->local_copy);
 	if (!ret) {
@@ -1382,7 +1382,7 @@ static int decompress_bdev_page(struct zram *zram, struct page *page,
 		copy_page(dst, zstrm->local_copy);
 		kunmap_local(dst);
 	}
-	zcomp_stream_put(zstrm);
+	zcomp_dstrm_put(zstrm);
 	slot_unlock(zram, index);
 
 	return ret;
@@ -2115,7 +2115,7 @@ static int read_incompressible_page(struct zram *zram, struct page *page,
 static int read_compressed_page(struct zram *zram, struct page *page,
 				unsigned long index)
 {
-	struct zcomp_strm *zstrm;
+	struct zcomp_dstrm *zstrm;
 	struct scatterlist sg[2];
 	unsigned long handle;
 	unsigned int size;
@@ -2126,13 +2126,13 @@ static int read_compressed_page(struct zram *zram, struct page *page,
 	size = get_slot_size(zram, index);
 	prio = get_slot_comp_priority(zram, index);
 
-	zstrm = zcomp_stream_get(zram->comps[prio]);
+	zstrm = zcomp_dstrm_get(zram->comps[prio]);
 	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, size);
 	dst = kmap_local_page(page);
 	ret = zcomp_decompress(zram->comps[prio], zstrm, sg, size, dst);
 	kunmap_local(dst);
 	zs_obj_read_sg_end(zram->mem_pool, handle);
-	zcomp_stream_put(zstrm);
+	zcomp_dstrm_put(zstrm);
 
 	return ret;
 }
@@ -2300,7 +2300,7 @@ static int zram_write_page(struct zram *zram, struct page *page,
 	unsigned long handle;
 	unsigned int comp_len;
 	void *mem;
-	struct zcomp_strm *zstrm;
+	struct zcomp_cstrm *zstrm;
 	unsigned long element;
 	bool same_filled;
 
@@ -2310,20 +2310,20 @@ static int zram_write_page(struct zram *zram, struct page *page,
 	if (same_filled)
 		return write_same_filled_page(zram, element, index);
 
-	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
+	zstrm = zcomp_cstrm_get(zram->comps[ZRAM_PRIMARY_COMP]);
 	mem = kmap_local_page(page);
 	ret = zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
 			     mem, &comp_len);
 	kunmap_local(mem);
 
 	if (unlikely(ret)) {
-		zcomp_stream_put(zstrm);
+		zcomp_cstrm_put(zstrm);
 		pr_err("Compression failed! err=%d\n", ret);
 		return ret;
 	}
 
 	if (comp_len >= huge_class_size) {
-		zcomp_stream_put(zstrm);
+		zcomp_cstrm_put(zstrm);
 		return write_incompressible_page(zram, page, index);
 	}
 
@@ -2331,18 +2331,18 @@ static int zram_write_page(struct zram *zram, struct page *page,
 			   GFP_NOIO | __GFP_NOWARN |
 			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
 	if (IS_ERR_VALUE(handle)) {
-		zcomp_stream_put(zstrm);
+		zcomp_cstrm_put(zstrm);
 		return PTR_ERR((void *)handle);
 	}
 
 	if (!zram_can_store_page(zram)) {
-		zcomp_stream_put(zstrm);
+		zcomp_cstrm_put(zstrm);
 		zs_free(zram->mem_pool, handle);
 		return -ENOMEM;
 	}
 
 	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
-	zcomp_stream_put(zstrm);
+	zcomp_cstrm_put(zstrm);
 
 	slot_lock(zram, index);
 	slot_free(zram, index);
@@ -2451,7 +2451,7 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 			   struct page *page, u64 *num_recomp_pages,
 			   u32 threshold, u32 prio)
 {
-	struct zcomp_strm *zstrm = NULL;
+	struct zcomp_cstrm *zstrm = NULL;
 	unsigned long handle_old;
 	unsigned long handle_new;
 	unsigned int comp_len_old;
@@ -2483,7 +2483,7 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	 */
 	clear_slot_flag(zram, index, ZRAM_IDLE);
 
-	zstrm = zcomp_stream_get(zram->comps[prio]);
+	zstrm = zcomp_cstrm_get(zram->comps[prio]);
 	src = kmap_local_page(page);
 	ret = zcomp_compress(zram->comps[prio], zstrm, src, &comp_len_new);
 	kunmap_local(src);
@@ -2498,7 +2498,7 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 		*num_recomp_pages -= 1;
 
 	if (ret) {
-		zcomp_stream_put(zstrm);
+		zcomp_cstrm_put(zstrm);
 		return ret;
 	}
 
@@ -2507,7 +2507,7 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 
 	if (class_index_new >= class_index_old ||
 	    (threshold && comp_len_new >= threshold)) {
-		zcomp_stream_put(zstrm);
+		zcomp_cstrm_put(zstrm);
 
 		/*
 		 * Secondary algorithms failed to re-compress the page
@@ -2536,12 +2536,12 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 			       __GFP_HIGHMEM | __GFP_MOVABLE,
 			       page_to_nid(page));
 	if (IS_ERR_VALUE(handle_new)) {
-		zcomp_stream_put(zstrm);
+		zcomp_cstrm_put(zstrm);
 		return PTR_ERR((void *)handle_new);
 	}
 
 	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_new);
-	zcomp_stream_put(zstrm);
+	zcomp_cstrm_put(zstrm);
 
 	slot_free(zram, index);
 	set_slot_handle(zram, index, handle_new);
-- 
2.56.0.176.g3575e65682-goog


