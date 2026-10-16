Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA9F8CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8666B009E; Fri, 16 Oct 2026 00:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF0C6B009F; Fri, 16 Oct 2026 00:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C70B6B00A0; Fri, 16 Oct 2026 00:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D72236B009E
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:44:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DD051A02C4
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:49 +0000 (UTC)
X-FDA: 85327249098.20.210FB31
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7EC49A0002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=c54Rp+Qu;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792125887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtS1/0M01UFrLXwpgPFi8UFASC0cpcznpCMgk29ij1I=;
	b=1shvXq5ORrVdNVkEe5isSiMK+thfK2+S/kAN3GOnUzgMQ2MqI9wbQAQCdLzMV0vDqY4lmr
	WGa2ziv/rtM90fUf3pmiqfbJOFFPPadXVgdRtaW1GwhM2oQCQDlCqx357Z48xerGMVxJl5
	+vOlBuNZ2OnqfVbRj6bRja5cA9SYIAo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=c54Rp+Qu;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792125887;
	b=Nxim97E5V9yHjbvDy5GCOPosRXg3UJxbaavsRvvS12l7EOOxUCkp0kf4g9ObT6OnDgtV9Y
	RvrgsbYxQcb5VQxycNTFizwwsOmPajWmArXurMh9GzRkOpB5e+NcYSVchpwEqUuMNHIteK
	Sz40K3fcisTkf/pEbYlOEhDfWa1y1wk=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e977109392so5538955ad.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792125886; x=1792730686; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XtS1/0M01UFrLXwpgPFi8UFASC0cpcznpCMgk29ij1I=;
        b=c54Rp+QuYJDXjOOGuydf1+lR4Ukx4Jk/MS66qJu7Yh03659gfWqzaXjZXYp7SgoofU
         hNrBwhltZ5+lORhlY0TET7/Rjqc+6h1s25J5cGgO48SS7rxZB/xt1vwmFLZQ0flooxDx
         A2gLtYDLPsh3xgdNyag8BhLtJV00CPA0lzNZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792125886; x=1792730686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XtS1/0M01UFrLXwpgPFi8UFASC0cpcznpCMgk29ij1I=;
        b=BjIKqh5KMH1h01F3+VuKoGIUsiA8K8N697UW5kcLPgZaMrPNlcREwPL7lh973yS4IE
         1SJLd7fqs4CFAvsrfJpvNlweiBUFzxnVrHI9qpZo0vudKPqU5FZhnTEj/Gbjt9PlHJMl
         QmT+y7CLWp8Mitt3g3kKcqmYUwC4n+XVHAWJFux+CuR4ugm+bzw6ltcT23+2moGXy5gh
         bK12qzPcPgyZBgifaRtbe9Q7A49VvRAYfoNoekYM4H1W5cKz03t8LSH3lRFxlNMTjW57
         IpYk2aoK+F5nj1wqdH7tL25mPeiVPbXAi3ZE4t7Fx7eTlPy+Y49NMceOqVRgGFEw+4gX
         Stgg==
X-Forwarded-Encrypted: i=1; AKwUvBxpUYpzschQO8KJx+UAV9ppP31HMy9K5J5QmrpFksAdTqVwGqBBs83e1riE3CULXICvyfSyDL/Tww==@kvack.org
X-Gm-Message-State: AFq9FYL1JatNDVwsxoeS7e7yFC6V8LyEvugAlkc5RlnEcUjODvTBFsg3
	UdT+E2qk0S/s9IMNfIYScRTdVkl0ggeITsTzEA165rvkvh/0D37lR8qmeFET99m/Rg==
X-Gm-Gg: AYBFou0qzOotbvxtvjIHdtBMUjgBkmMulvHMWkaIsVs3T3UT7ImCuTHAUUS/TqLUjZo
	bEyQcj1wKOZQx6gUvF7wvFUQDgtv+nN4xRBcR+VpmjY7rI/DOSQmkBvF2WJItZiUf1BvNZWlCCW
	e83qbHTK5hTWB5YQBIFRlQtPl/ekOHX/pGXQ0N9Rx+R7yJ9zinZaedaUrfD5A/Qg9RNVf0rvg+7
	5oPOVzwHwJiuR3CmHWnwpBlfvgGYsQ74EUYmWLKpcBizbHxEGggyYXTHxeCsGO387rNZFjOanoF
	yHpa7DsO9OacdOG3m0TjzB7/wL/0mZaa0jCgNMyvZOcOdONmdQVb1PUqWpGVyyc02TsWuU2Iwrv
	uzbxYRnXn01xxiFjRHbOExEDXgTZPjkr/bEVtcq02U8oUOOEAmxNsqAyIrL97ZamUvGzfFDiWoF
	yn0tCbp99vjcXDEVMl5Zu0WWM2fjEAsOFVp9Gd0yY7TesbvKxNOlW1saj0TKEb4OgC7t3sJ/Jxv
	TcwXpKC6I6lojgewPvTP022ItLFmxMSfDcLzr2HCLSAkN54bp0Ej0FMpVm4vMU=
X-Received: by 2002:a17:902:e74f:b0:2e4:b37a:d577 with SMTP id d9443c01a7336-2e842ce7f01mr191500845ad.43.1792125886411;
        Thu, 15 Oct 2026 21:44:46 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:a579:8b87:8304:7ac2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e8b1b5esm4137235ad.67.2026.10.15.21.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:44:45 -0700 (PDT)
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
Subject: [PATCH v4 04/12] zram: lz4hc: pre-initialize dictionary stream in setup_params
Date: Fri, 16 Oct 2026 13:44:09 +0900
Message-ID: <20261016044429.1304561-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261016044429.1304561-1-senozhatsky@chromium.org>
References: <20261016044429.1304561-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7EC49A0002
X-Stat-Signature: qmra6ct9d6fhh91h6p69ougr5wtz7xd9
X-HE-Tag: 1792125887-768544
X-HE-Meta: U2FsdGVkX1/IsWhw0oLozZWj1PeeywmQ/fXpeFzY+/cWQUa+nu4Jk3Qe6BbBRrCydX3DRYvg0FlmDQPeoheny8IYcoCeiNVGJjE32nbjkAJVs7nA28Ma7zneZluVr1DdRqqmHaax7Ws4FoG3H7aMRnZmQYnepodNoOUfyDJWfOp6clkGEITRnw/Rk0TiCAHQ4tvTnvwjsfN3ugV3Ytn1C3U1B/FOZBHoPpxwV9Kn9l4b/3bEMKcPbJM5xF3OBEfPQNiu15VdPQgcXMzv8JMXJlaQOWnLiIqEVgwP+ZLNnKUX+0+dV+k1hctaLSSVW1nou9RF3miJEiT+Qu9Xnygg17gbeYN1BGzJR+aN57pUUvP9q3l47p4j56O7ooSirDaWh8ZpB5zmPVk+rLRdm+VtSbQ5/lBU8sEaw7h0CaokFAP6f3fFNHQdY7DHHSFl3LRLHV1Nhjy7s6vcNg+6IKK2THPgt0UeW5dGfuNgImSEm+MQ7Cj3CSTCIEzHB+I0FEDLyA1uHkIGw8TmGTgq/586sScBZ7FtpRvwSSwDNuQ4TkhB3mlnRiu2d3kjcBe4zweU0ZiHZC96d83Gh3uiJCMKfY7vg97lzXuF+tbaE03nVflpOh+0jS9YKwB+odLL6m/MTq5NfhgtmUmfSAkH5qpvmH21fd8mMa5EgHyDXpCLFljWUTPHUtj7PT7ErVqOoC/G9QrLT+Ws3s8cFwN8venZF1AFTJmHJMgG7S3yZuf7mVEBVEWsHviMoJlPSPXZt7BszaJtFSXpOu1zYDynwqS0X+Jq0YjTflYaWHj/whY9NaJMPOgk+lSlnoVYVgfrKWdX6wPNrBjVEyY1aQHaRvINStpTgb4UF62G6XdimiHLUo9jTZ7/vgAv1WVf+OWuiyQ7ZvSITXZituYq/Fh+uEL9rFQ+SRkCard09NaZMgd0bPYm/T6cN0wzyU3mKjvJSRoPBuNuwUH0kUuP5t5qE7M
 mdBRU97u
 LTSJLmGdN0pu6Be+DPtAPc6T5VPv11mRCCmPcXAlxIH+ANdTEaLuj8XfzzHVVkCALOTojd3xwWZlyI2NEgisHPbnShqzTSYbvARGT0XLJPwMEo3EPaTJFCqcRh5+aa8/ZaRKDI5CQtRY6KixVfInKhwA8hBqSgnbLGXF2QbDTTFBiJ7FMXPx9gupBwRDIxfZiseXC2ucwtNx5VZn6hQGyH7dEVRWnVCGN7ipHF39dcE/09eOM0BM4EMg6BWn/mwAEA+8AcPstt0GOeFKlEocw7z6y2iKy4cYWRw/YqmYS7ala0vhGU318xhQrRAOUXssaG/z9Z0hsi+IRF9En06Av98b1pFeKS5dodekn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pre-initialize the dictionary stream once in lz4hc_setup_params(), store
it in params->drv_data, and memcpy() it into the per-CPU stream before
LZ4_compress_HC_continue(), matching backend_lz4.  This avoids resetting
and hashing the dictionary on every page compression.

This also rejects dictionaries larger than 64 KB at device init time
(matching backend_lz4), instead of failing every page compression with
-EINVAL.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_lz4hc.c | 31 +++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
index 5c009835a684..f3656c27af21 100644
--- a/drivers/block/zram/backend_lz4hc.c
+++ b/drivers/block/zram/backend_lz4hc.c
@@ -18,10 +18,20 @@ struct lz4hc_ctx {
 
 static void lz4hc_release_params(struct zcomp_params *params)
 {
+	LZ4_streamHC_t *dict_stream = params->drv_data;
+
+	params->drv_data = NULL;
+	if (!dict_stream)
+		return;
+
+	vfree(dict_stream);
 }
 
 static int lz4hc_setup_params(struct zcomp_params *params)
 {
+	LZ4_streamHC_t *dict_stream;
+	int ret;
+
 	if (params->level == ZCOMP_PARAM_NOT_SET) {
 		params->level = LZ4HC_DEFAULT_CLEVEL;
 	} else if (params->level < 1 || params->level > LZ4HC_MAX_CLEVEL) {
@@ -35,6 +45,21 @@ static int lz4hc_setup_params(struct zcomp_params *params)
 		return -EINVAL;
 	}
 
+	if (!params->dict || !params->dict_sz)
+		return 0;
+
+	dict_stream = vzalloc(sizeof(*dict_stream));
+	if (!dict_stream)
+		return -ENOMEM;
+
+	LZ4_resetStreamHC(dict_stream, params->level);
+	ret = LZ4_loadDictHC(dict_stream, params->dict, params->dict_sz);
+	if (ret != params->dict_sz) {
+		vfree(dict_stream);
+		return -EINVAL;
+	}
+	params->drv_data = dict_stream;
+
 	return 0;
 }
 
@@ -93,11 +118,7 @@ static int lz4hc_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 				      zctx->mem);
 	} else {
 		/* Cstrm needs to be reset */
-		LZ4_resetStreamHC(zctx->cstrm, params->level);
-		ret = LZ4_loadDictHC(zctx->cstrm, params->dict,
-				     params->dict_sz);
-		if (ret != params->dict_sz)
-			return -EINVAL;
+		memcpy(zctx->cstrm, params->drv_data, sizeof(*zctx->cstrm));
 		ret = LZ4_compress_HC_continue(zctx->cstrm, req->src, req->dst,
 					       req->src_len, req->dst_len);
 	}
-- 
2.56.0.176.g3575e65682-goog


