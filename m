Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A30CCA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16A9F6B009B; Mon,  5 Oct 2026 08:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F4A86B009D; Mon,  5 Oct 2026 08:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 031466B009E; Mon,  5 Oct 2026 08:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C59DF6B009B
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:21:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 578F61A01F2
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:12 +0000 (UTC)
X-FDA: 85288482384.02.A095733
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 93063100004
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QGf8WY7w;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791202870;
	b=YE/TQIfXS+pZUA7F9d+5aLLbxWniSC7Pu1Qo+Et4BhgB0YgIF3GciP1tpQo7zRRGeqzFrk
	ACot7tl6iKHr5wuN68VVsT57PHuTBUVN344APTpMXiD76WywLhzbKFDYiRmNU/7NcAkkBN
	nK85yC8BgdzNMHdEAUGlK7BCG8UYD0w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QGf8WY7w;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791202870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=15xwwAv4xGpeW4W5SjxpQZpMyGQBTQag36PfgzzT6ks=;
	b=nerH0wwRwVShDqfJAsBld1Qem+5TsTwJvAd9rvZ92qK3VGA5B2cU0W3xNUnqJd4KYQBXxB
	qKZ93MWUUnxVRBdieHZ6MUwFamPsNH2QEQ5/Ylb26O19DzFGbzxmsMQ5nbfq2tG3aWkJPL
	M33mfyY15D63cfAsH8LVLUGGJ7I7o40=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3a80d1c98f5so490192a91.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 05:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791202869; x=1791807669; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=15xwwAv4xGpeW4W5SjxpQZpMyGQBTQag36PfgzzT6ks=;
        b=QGf8WY7wS25ziCfQhJCX/dyLBxcyvIddvxQkBWAOEZASwsYB7qHbDZvjV5QZ38w7qL
         wJfvMEAhUJ+pVG0xesBLteXICusEm6jHC2/ess3eYBPiIwiZ6P70UIWRLyeL1bUywo3B
         07vhqPBvJ7HjT8xwvjDcFdPg57eOXiYFYLlWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791202869; x=1791807669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=15xwwAv4xGpeW4W5SjxpQZpMyGQBTQag36PfgzzT6ks=;
        b=z/MptiCnvogn+Dqh3Ns4RVpAOD/IeMF0DENnP5EOoK/e/pq15y2wQjgN1M2opCF4Xg
         cXbsDbdZvLYFnDQycFXzFBc+XqjSxSJee3R8t4wIMRooEjV7W5wZhInzmKCmvlPvCRUZ
         Td2ENNr4BVK4HiYT9X3V0b7LU1s+1NWpcquD6UJhN500CGd5noT0fR3qU7rJ0bp8ztgF
         7X6uUWXFzzXPG2XEvn9p0h+Ev7yKeLb/lj+QlIhrhemH2NOG5tUspATP9v3Y4axSoVbj
         vxvpHRQebWoZIGJDhBq7ZDUhl2yB7P+ayUtUhu9Km+pKy/IM/ZM6kmPESXaerTxQ/FIh
         Io4A==
X-Forwarded-Encrypted: i=1; AKwUvBzMnWipqNFFepxAB1YfoTH52P3kZ9V1vTfer2Q0Tvx+ytHv3FvBOj2BAsefQ3FihDOBjxL80/nY8w==@kvack.org
X-Gm-Message-State: AFq9FYKLxT3BtZXxd7b6QUUM0qV3/opab1KwZna1pt0bXExc5cSSgQmO
	Myk3QkoVDJf1kdqurVHAyNpibSDqAKBwrSAab5VOxEjXfIE0jK8OgRTNC6wtR7G+rQ==
X-Gm-Gg: AYBFou1BuPZIP24fm+3alQ7MwXFK5HAcb5z6J82QA93OYJ2envKeEmPFrq6T0Ai79pd
	4OdHk57SXyPJkbVG1ar4qqD+Hq1nuvtXoWNg2K+YukDXnFZgYa5MDtWcy0rjeC9fjTJkgiot4r7
	Td9EVpWgn3XEufMwVtXqML5rA+/4DwSdTmw95QoV1f6XqTocS1ZJwCrkzU6ySWNJi9uycLp2sTR
	xUfACfZapPJ8miJCVB6IWpm13HJ56fZ5IdXM+tFqAH84RIkvzWAShXCfBacOGENFcc1JWNgrQKC
	jEiG0vbt6NuRPUPgkBWueU9UUNIGj8sX0LjqjQzP+nhz6jU1igT/0Jul8augFFnKAJ9yaFuRghV
	ps7jOcYpmUwsCTqI57FlD1fsdJLjiwbpQ1un7KcmjsfRylcEVGfD33+dO+1frENObxCBnf+AbkA
	SJntb6NA2zFusmFqM36F94pv+4z5wfeoCOrHahDv/SnKkZ8ffbiDKGPfNDj3eU9Su3sBnaybA4h
	AI1wrv9JFhHtdJVlNMZr/bskqZh3e68NwuwCu9Axv3jPzeRUOfG7jOrSI6vJo0=
X-Received: by 2002:a17:90b:1806:b0:3a4:8c41:fab6 with SMTP id 98e67ed59e1d1-3a78750a564mr6101771a91.46.1791202869374;
        Mon, 05 Oct 2026 05:21:09 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9211:ddf0:3c6a:bf9e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7e4b00de6sm3342997a91.1.2026.10.05.05.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 05:21:08 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 04/10] zram: lz4hc: pre-initialize dictionary stream in setup_params
Date: Mon,  5 Oct 2026 21:20:19 +0900
Message-ID: <20261005122036.718976-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <20261005122036.718976-1-senozhatsky@chromium.org>
References: <20261005122036.718976-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 93063100004
X-Stat-Signature: f5cya77w5ceoied8ozzfdysp8fp8hayy
X-HE-Tag: 1791202870-243944
X-HE-Meta: U2FsdGVkX1+D7PlGgXZD5b1wolwA/iHfJOgv2eWJ7ei5xc0BjyDBe609JkOAxByzyval9LPH2IGav+s3y+e64ZFcdAdv/5E0WCMKEcs02B5wMF/h5NYbCtYd8Oajs557KJPNDFt/o3deCSkpJnpGyYCxJmbvKY3cOrPXjYp2IRm5q0GlvTD33EXQN6JPB8fu0EVyWQvtpFICWzRQL0O48CVG4SSXmOgdNhw7jOX+5U/c+kGBUNE/ig2nGIIM59wtdZcbdX1ZcXj0jUTw68Fcy0b0Dghqw4rLyUposzqoT/IheqH+eXElMw4cVP0h//TX5Qun2U0bPR558doV+IO+/3UE4xRTkIi/dlbI1TQ0/Ur2TC1sLt6UpDXHIz6YaAImZPz3s+cWntOIkLn8BSqUYnWpDeDocWQbpDFH/Y1kLQLunsSKKq2Rv2Pq3rOy0zaXxWwSCuz3BVN8ddFdegkOx3KT7u7tL5y3k0onZFjwwD9k+R8GZZYq2/cnlG4K3gcbppfa8p/fhYOgFmqFkuU4DzTM+J7zhrG071Ee8RnceeyJ7GRzkSawCBy70QeSmv78aYgcOOOZd636djLHfI3lm6pDakDRESAwLnZoRvG1XomPvWzSc+1SbQ13dTTx+95RGbZVcIT1u6zPXSty4xCrPkbEbocYs6DIN2R+LggX8yyupHmydQgkOavkxltxsreTJzRlzJhdxKk1dbNAZshUbjpt4uKgkgvOQDLvl0wyvQ/RG34F+q8AtDCsX5m0Y5uQUpN1ix7Mm4BLpJR+O1MQlacydDXjQ0XO0je5mufH9YB+h+uNN5Sib1amJZ039YA1kVMbmoQHOl/XaVKKVGaeBsIzaa4JQWHNnsJF/lc2+y9ZLjmVdtPz5k2pVLv5IzN4UUuqSWYXTMpGO/3am29b3pKpWGNxo/ns6BA+9fk+A587uC7aDQRzxQf7hJJXe5ZbVlWG3uYwT5ZIvkHel/7
 qhsuB9i0
 Wpw+kcZ+C0YK06ur+QDeBFUtb82g45v6xvMTflvPZAdZ7CVsTiqZGqXs8wyrCc502NJ+zuTa6/cYgwJYTyFAOqT26BmIquf83ySrPtJ4f7xrq5oQXePCbIVi9fRkWLVCqRWeX4+tEDLj8egvdjnBCfJj9KDHcWaFCXaDIzTpb0KXpxEhMN2+SpAzwzBCDTsvfsBoB++mTVWTLge+3sESey8IXHaTZKb9F0WAkl1DK14kL3lOhC/TX1Et7wpeOcFZxbuKv6Poo+JOnxtz6AKTrgj2OkEREFGYjtqzzHC6dzPazyDzrVGiq/U4JAwoHonXJLr1dJYmJsRKgfWjxUSgW9aAJEVN5liPNVGRs
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
2.56.0.rc1.315.gc6ed9934b7-goog


