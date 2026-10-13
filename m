Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3331CA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4796B0098; Mon, 12 Oct 2026 23:52:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2422A6B0099; Mon, 12 Oct 2026 23:52:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D086B009B; Mon, 12 Oct 2026 23:52:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DACF26B0098
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:52:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6133480328
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:23 +0000 (UTC)
X-FDA: 85316230566.04.ABB0365
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 91D5AC0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=iTi13qyw;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791863541;
	b=CoGJWIb5QlEaXt7G8vecOUTy51Qng6hlBzCqzqICsUqJjKFOPXdSqrQmYehvSTy+5A0v8u
	aA2Sb54mXfQyCx+LWyiDOC8sG0vWY/NzsNVe1OCoMrZkntaVneTxxklw6I57FYADyvsUlg
	u+NbS9SKm48r0THE+roe3sIx6EabJ+c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=iTi13qyw;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791863541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYDIjpQnxgkFqNZQW2yn2pS6XpW/Xbtk8d0QrpCAmj8=;
	b=Xw/8QtkWGWq8iQ+v5SOp2mvDoCbZJ+2HtifBfSM/DvetvXLniMw1TSTKhohdrMM6SnHHlp
	758VfsrS4ifC9corXjwa4nuNoJcuRoJ2ruGWavl7R0Y2JaYSJ1Yew6s1E8NdLTc0/5TXeA
	UNBRhb9FS9aRDoBPEkMmU/CLKFq5hsM=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-88bda150550so963374b3a.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791863540; x=1792468340; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rYDIjpQnxgkFqNZQW2yn2pS6XpW/Xbtk8d0QrpCAmj8=;
        b=iTi13qyw0NcE6ZrNxvVumkxEcy8u48ptx47oz3/1YxXKjpP5m58NqYRbBbm1wR4+7z
         mrCa8eFmTA/rmp/gL1Nyg039l+FZwVc2DYmEajjx5Bvbci10xwRWG3/9O+caarZguHIR
         UlLTDWGtRJV3SzRzZ5pcwqYbVVWB6TCwO8Jhc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791863540; x=1792468340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rYDIjpQnxgkFqNZQW2yn2pS6XpW/Xbtk8d0QrpCAmj8=;
        b=swMEgTduQ/zW3KLZKcbiix5POWa7stERl75/IJRs+UXH5vkdwhpwxsUe7EFu9LcuIJ
         JQMGDdNuYagkrnjS392469uHtsWYNQRSvswbVmz+0TSrIjSlPoDMWHRjV2bweo7OzF84
         cKxW0vDXMNG0hs4YO1hADM8ZXJGL1CNOxCQBpLcv0WYw54OvChdgoYRuQ3hCXQb2uMUy
         g4vHpcXmLtpmnw1AmkYfJaoPSLjagW18N0/2ehwi4iCk8cvTDjyd7qWHI9+uC6u7AsCR
         6KSpvquNHeQzCnwLG7pCH7Lhw8UC+/N1STxg5ecQjp21/s+ekiBLDpPAwc80YOnzxPGM
         0g8A==
X-Forwarded-Encrypted: i=1; AKwUvBzjiM6On5hp8olXEF7+UFtlUNNDEX45/KpZsyaVlz7FMQUi/MBxxPEz7Mgjx41g1gJviM21Cdggbw==@kvack.org
X-Gm-Message-State: AFq9FYKMcJj+2KqM+41PqVzjhqKM52wHQETVjAQr+suZmtgYUhRkxNFi
	HxVR+FSsnSEqGFYxwHcvWG79ZR+nDi1tnKPN4fS4wlbKcIocAG2JZ4N2JiqTD5BSSQ==
X-Gm-Gg: AYBFou2GJvNsGAlBqYWLuP+EmVWzdm9+RxaEDeScghcsFV6fUHLsdRqTE6nEFjZ4OdJ
	RH4k1jxIVdJmeS5mrABjRuQdYLnrvOtWXm6Rt7J3O2MlWTTNz4ClxhFMfTqChQZMG1PVKzXwqh/
	vdfAwnkI59cnS/i3vl5aKshkYOeHOI2xCXrd9sYb5BiLSsNxlXy9AaCfV+qS9zmcPZiY9W1BU1r
	tM3kp0K2CkSkIi5/xCThdEy7x6U+Dmjb9DmCrS0kHxRuS4yqJ5tYgAZzdyaB+dGXpCJWGmGNf52
	6pl4A5CCXEHe4Pa2+ixuecBXO6Ulh53rX2K39++BhhSzjtANZAWAont58YBNII1lyUkgxdHAxxb
	pvyTOPdRzKXIs2a4bM+eGwozcIpYmENhzPZr7h7MNdwS4w9Jiwel+uzJsAIS53hIG3pikwrQY/g
	dZycZlW1eAi1C3RJ6+9XTkzIMvCsX0/rqAxmAxxBqnqv0prZ5S7gpSpDXxoqGXVRJRc3xqDGM8F
	5jjijcY2vq03HyYeQvciuWYt2oSSQ4a9mhJ2NFkIKvxyPjOMCRN3ChTSt2a3g==
X-Received: by 2002:a05:6a00:1803:b0:881:ac65:715c with SMTP id d2e1a72fcca58-897c653b391mr9755218b3a.10.1791863540508;
        Mon, 12 Oct 2026 20:52:20 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:476:d384:7c2e:1579])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c41bbb27sm4326818b3a.40.2026.10.12.20.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 20:52:20 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 04/11] zram: lz4hc: pre-initialize dictionary stream in setup_params
Date: Tue, 13 Oct 2026 12:50:51 +0900
Message-ID: <20261013035201.2809924-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261013035201.2809924-1-senozhatsky@chromium.org>
References: <20261013035201.2809924-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 91D5AC0004
X-Rspam-User: 
X-Stat-Signature: 9kxejfstnsmqtic5osk914zg3wjkywxa
X-HE-Tag: 1791863541-666667
X-HE-Meta: U2FsdGVkX1+BTEEemHF8h9vjKGFr4BZn35Z/0pV84oioH2sP/snZneHmRIJ/tdtA3soy/lanvEARTy5ZNoaG9KwqYWcoAH2xVckyvb0V6oKSoDCKIf+jm3sEO4kekfwUcQgYpstMAW+LdUWjhViWnRw0rsLvTSQLkRow4MpbgsdtNpzrjZLvXLlP6ccvyTfPtMqH02pzklrXhUQAIiZF+lgk09LSICujpIFA+6sukod03rHA1KFHPtX+uTkUNGOQbu9lkhfTIGuw6D4FwE5YGw8mvMAz7qfO7FoUBtnPClDUz1qxmvV/322RyhybNNKJfzSQbgk9FKbqprC6+4ILImHZdix8Ca3aLjTUE4F9KYa9V6nzDKRoi1/ZMm7qkPOu3PabkcK0gAYt71acLJTrzuNcNSdz5YBHTPXOQOFVTnm15nH1yXd1Vb26FnuzdPAb22PuM/hXM5/P4xy0vUpDPsAfbZLdiM11C2PISyeaiBWDJLvAvxdodSvADwBqOYZQ9JM8/YMS1F0T4j22MK1ITGFE6sROV/Z4myiWqjYtehF4BqD+cVT2i7sDnuK/Adu4QqwotKHuFwp4LJ0klgWgBFZNkCKE1c29J7cKMktwl+hscFyfoFph1rFfhwgXvTA8URm6nJLmfMErDeTtaGX9WrOa1eu54E1ffUXeBZPDcrY0sioV76Oi/TZcKUAQOSzFDZ0TL7zy+KHzRT/NRXBON1dEOvaKUhdI+gxFIB5X/EAzmdxVLw0WTnpiY8TpQvQITjm9paEzLG4v37h3dE4fk/vPrCiDZXgUgNyC97kgb0sjUAbNhIRKj/2uFkiJ8X0AVwrmcuUKmLBSPq+5tOS2KyZTceiNV3/aTzTnVOeK2WBsyy0dow7A2QoeWop744C3w26kanzY5QE2NiZzgJt9Cwt9aQwo+IGCtARPByBs7RGxENfOHZUNFmRv5mRshK5de7fLMEzRrtoFwl68Nw+
 7xlcKVag
 kSH0Pe6aYrL8CaGnAHm9giWno2vZXjGutkbv/cUNOkvHM/1xXGwm1H98OrIE0yEk8KmqJaSK2bYtuUxf7Qjr7oPsq+YW20CoE+sHVBCrJrhUQmfH3nqs31RMPb+riDeKOhreeonyNyKljW1T0hCxy76ZgH+87Th9SkPtfhOADBgkaaMh3knu9Sm0MEn/hHH5HMSQlc5V7gixPJWp51Bb5C4DoXIO0m4A/dtOjYsSuxS9NDZ5XpuugczIFkK7kXsvLHMHmDnBVM338Ai3rcuwFB2KEGfjGPQEC91zCFy4edGd6MM65eFAJqQk9mkipi4l9jD0bLjT9DOc1taHaFE33XJD6FEX7yNx/mQTQ
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
2.56.0.385.gd3acb90ef8-goog


