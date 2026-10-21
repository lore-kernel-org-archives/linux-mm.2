Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E6260A263D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=GETUQ7dA
Received: by kanga.kvack.org (Postfix)
	id E69306B05C4; Tue, 20 Oct 2026 22:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E19D66B05C5; Tue, 20 Oct 2026 22:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97006B05C6; Tue, 20 Oct 2026 22:43:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97E786B05C4
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:43:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED98412041D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:43:00 +0000 (UTC)
X-FDA: 85345086120.09.C34E199
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 295EFA0005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:42:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GETUQ7dA;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.41 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LxFkZ6agSclWnjnr9VyHt4JNsSVqy4IW9aFQvxEPoY4=;
	b=Jg+tdnHZYeSTWFuh3/8qb8v1uYx/WU9/sL9/0TE1JZxihRt9Ri+5nuhBz2Amhu0+tqHSfA
	nDeQi4HzyojEN3K3VAyIPtO+EBBfGDrov2wzSZEk4PgvYzByg+4QjGBykPKivg5neP7h9o
	hVsWP0DvzIcw9ukSx4UEQso7l9HPsh8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GETUQ7dA;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.41 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550579;
	b=c63pCY1QsUvLyChMoJbPt+zr9Gug1g0ktA9RYai45w+XXHJgQTRUHyXw+kMIdNiTTCzNLP
	wgo7w5yxgcnnZ2J+R2BdCG0XZG/moxBwgM8/nJ3uHkX7IpSXmy/W2MMy/t9QsObaOHVy/L
	lVNofUl7CfLw8kMFLGzGWyrUjYPe94w=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-15354aa70e8so778258c88.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792550578; x=1793155378; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LxFkZ6agSclWnjnr9VyHt4JNsSVqy4IW9aFQvxEPoY4=;
        b=GETUQ7dAVvtRd+1oCzuWT98EshdLfi4wLLM8M/q3fiP5xOOpPEa9QH+3r6cuYCASah
         vYFuo43fcBzdh5antbhqAq717OLHv02d4utcfxduzZXcXN8t3Dwc8kwCqd8job/AZzPV
         PXPmdLHZb94iOZCBXVnPB4jAhwqTsimKh3tA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550578; x=1793155378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LxFkZ6agSclWnjnr9VyHt4JNsSVqy4IW9aFQvxEPoY4=;
        b=JQKbZKj1EakFLmvIOyU1BHKVlHFeKQ/tqnSu0HBVWdiX7f93WUqhOSonqgXt8Il3K7
         4pV9NbNc1aQmQ0v+vaZ+Odq31GXjqbj0BuYuLRLcnxVSbIUga4ixLP+0RvCOe4jHkGKZ
         8coningSzfsshoOjV4ogtmw+ScqFeDmAIF82jE/pq2brl1RdR34mfOi3fd7UJUj0JLgb
         vZA4hb5F6+zQrf88VN6v2nA8v+mHrdFOBhKybCbANQMuca3nWT/cm+GVcHEAIQSm3srG
         QF28a6shCYAzKT3PAPBTwOV6BwfxatS/0v50d7SL6MXPxIwsBqPxGBCuJw/FUm+/hVHD
         ZZnQ==
X-Forwarded-Encrypted: i=1; AKwUvByMmnmNj8GGi/sonTEx7rerXVaFvulPm/LnVVBPOnWoDyVvBtWOmiC34ZvXj2Lfa3DYJx7W3Xw1pA==@kvack.org
X-Gm-Message-State: AFq9FYJ3VqvJhOF1zV/Li+uc+Qt07+JIH/qO8iRsnEfZiT/UVAVogUHm
	7ZYm1AHPLXO3IdDaw6JBh15Jl3v+1IZZ3RNXN4gwfmB8vRCCdoZcUp4eYkwgeHQSgg==
X-Gm-Gg: AYBFou2zeWY99AZbZNpsYtbQ2SM0bczvUSiX59IUYV7DuFSzGYogZ0kRBrtP104E8IN
	2q0uLiMKmRJjeDTXxljvCeH3M7Vz5oKjDGvwVaTKfPoKL92Qsb9mxdLmEOT+7HG5sT95hGvonqA
	5p2oYy4yA4jbPEz6PqvIvMnQbAurE9OT8XAUARe1ssLW40fv0vuc1OBizILRcV6JXcU43pLGRoN
	DxFR726vz+duuaTnTt9FUW08wjvSKGCFErKNnoSZ3HHgMKAqGzXvNZ95Cksz6RXV0FiIZoO1x5D
	1B+q9vZNy9PkoGyUtEhWWOfu11Y1L1dnoTARKwoXxbQYTwIfN/AMfk4lq3BTkOD9M5anpqtBsVX
	5QPou1PH545lI6Cl8wTPWbmnYufOePf292y6wjBaNEuTMp5aeShkXs6qRbqqCWaC5IpmByCBHTd
	E3h2FPEmJuCTVnqab5MLiv35Ije/SEgFZka1CNDrIFbAhIo1AOsYv6refHlLvLr0UEUjrb/8AXf
	0RAqLIcqm5L1uUcvSJR1+vIS0RjGF0UqnphKz7PQA6EDkX6RMaY//hsRGijH+cy1U63NzC5Wmv3
	A1yq4kUO0srQVibGgjO9LK+Uih1pKA17FZrcLHUOKx7h
X-Received: by 2002:a05:701b:2810:b0:166:b307:5855 with SMTP id a92af1059eb24-1909aaddf34mr925658c88.0.1792550578027;
        Tue, 20 Oct 2026 19:42:58 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:97d1:a8be:236d:bf79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035c0c9a6sm2392047c88.3.2026.10.20.19.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:42:57 -0700 (PDT)
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
Subject: [PATCH v6 05/13] zram: lz4hc: pre-initialize dictionary stream in setup_params
Date: Wed, 21 Oct 2026 11:42:15 +0900
Message-ID: <20261021024236.1787884-6-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
In-Reply-To: <20261021024236.1787884-1-senozhatsky@chromium.org>
References: <20261021024236.1787884-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 295EFA0005
X-Stat-Signature: wx3isqpz9cwiqtamrsa4dxfxzfxny8nt
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792550579-642260
X-HE-Meta: U2FsdGVkX19ZrO94h8XQ8Jz8+kzXahaAHeLc8H/XB1vYAhAWbsCm92TwKPlcmJS+whWC+/xfZBSbKzvsfnAl4MQWVoO5A6yQQVjJYRlD96KUQYNa/Z8/PcmoGVGqQiaNdtlXEfjBfpDMwItTuCjGnely6Nm+gos27G69RWXGwWAMWrGVKqpqCP6tOie8b7NnL8KHw0V6t+fhyR8GUlv4hFZ0tS53x6L/Z7ry4bz7tl8sb48LNwIpRG/HQdouw9QibwH2Y62WvS0vgPhrFU7fxXoBqqo8rCXtru0LJO6q/nqg9yNQcKwxxlGQdvrwziT6MtTeUD0ZYaBzY+KIqsSoT11SvAK0q8b0TFKzSIKIUuKJ1CA0Xq3ja6TKqJuoaWfXERsMLROg82YRGQbXZjjWCc2bfO6Vah28NvRinOZF3LjkjGmZ2Mt69sJYIbkFCwDIsjfggmEiVAIPu9Vdcyh3XXVG5qSRGNq4rDW74NAf9M4kAQV1Jb5luc9VO2jlZ00X7UVEvmh9G7bi2FQUWj5qbZLH3qUACjUHTt7HMpUV7aIphQe3ICVACJ37F5hG24lH+EHzxSNXVvXbaCqOj0zfcpRw3flYCutAHoQv8P+c4eHRKBsDgTavkqUJjnKI2ZqkK2mIuD6496NHk4pbEFevuKI14NeZvE4b0Xunbm/wjkia7U8fJ8yzHIavWWCf33ydcXks1Qiu+W+j6p+xqVG8OauPefUIgMq9w4IUbFSqCLnJ4OcFraSd17e5z5ey9BnlNgB7zN3h2mAP9P7l8MkvMTC6H47QDzEzYuCdF++CJWm5iyDVAoeX65Ccp3cB8L5jUOEYk9cgnS8ZDC/7g78MDXyGv+il6b9WVo6sSgEcxCnysZG7mIMq0fljcJK/9lbCa7fFrS4WQ0kNECH4ZOU5J+Ue49F/ruPNe7IptX76TKTgxTQJb6Kk9J1djXmTclTVMB+V4CK7hqS2jrOvjGN
 pgechBHp
 Ze25jOEh3Nrnx2Y06bVhbTsHuvssJBigvNxSbO8UZ4/BzEDAEW1qH2gctLo6H01DkBErd7Auwps2N6dHycdBlvTzawGS3aDKoKa90NYPYQCePWLKbBXg1cpVhckKRjx/GgqP1v7/biO7Gw1fmGlykbOVNy1/y44JirdBdh9FpMT7gGy9p+iwwHprO5LrojbGPxBogrnwV4crDngdxmLgR2dk/QWc6VpPPI1tGxHOKHCIyvLHysbPjy1vKjWSFi7x0gFA+rTEr3AKb4I9+xpy5OziQiXUXFdrZZHXbTbMONBSTz3tjVusH359YaPIGhHc1TA+frTzbwaVWP5M4RXKCy5cCJpfMzpTRyOcH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
2.56.0.212.g129ede20d9-goog


