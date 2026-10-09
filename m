Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 245E8CA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056676B0099; Fri,  9 Oct 2026 03:12:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22586B009B; Fri,  9 Oct 2026 03:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E393B6B009D; Fri,  9 Oct 2026 03:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE4F66B0099
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:12:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 291DBC0269
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:30 +0000 (UTC)
X-FDA: 85302219660.13.2A00448
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 59FCD1C0004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Y5H3CDOj;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791529948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYDIjpQnxgkFqNZQW2yn2pS6XpW/Xbtk8d0QrpCAmj8=;
	b=8VqdskDVzJjeuuQaH7ZFQTIAqpglFrTThmNuwExI8qxvd7kbXIfku0DdOAK6JzKNciWWWR
	3IsL5Oz+wIo22evW/aVvxPbbfKojt6cHjGUvlNWxfQCc8hbLrmxaGAQFmf3VMfslc+ktSu
	LPilOzwiZPSydKgGDIyI2pC73HihHQo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Y5H3CDOj;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791529948;
	b=3QQ8NFQ6jIPl6TtUF9vzamUXC3FRA/qc1nSugq8NFJibZFQNv7KEgOpOr3Ktuph68FPdOJ
	A1Gv8x/gKg0A4qsnDXg5zyyWjPKUl9diAd0pzwii2RJcJgcbOunuzA34RYfVt0k8EvLYFd
	vBCj/TbyRpRfBZ4YklARiHcm3FwkCqQ=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e8246b13cbso9429075ad.2
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 00:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791529947; x=1792134747; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rYDIjpQnxgkFqNZQW2yn2pS6XpW/Xbtk8d0QrpCAmj8=;
        b=Y5H3CDOjiH0ts9Z6s+RgwNACqHuQwPxn9eTEEZQEdlQXG+fFPrU/CrYiGTUJV7hGYj
         jW88/hnC8SKJeaRR4Mu3OEl2WlLwPddMX2QA6KD8gG8z/XmHuzkvbRJO5nGaYiLKGym5
         9ogf0udpBMm64XN4bMsjIjSYkXzOUn0XiRA/g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791529947; x=1792134747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rYDIjpQnxgkFqNZQW2yn2pS6XpW/Xbtk8d0QrpCAmj8=;
        b=V5D9LhbZtYRo4Rpd8IGP9i8H4urE1k/3TyAFb8duC3LBsobp15wfKuBbP9h3lil3Bw
         vO0+7r02vvG+2+E7gReAzfxXv/cAlRtcVx/5MpVdyiUEX0YCQk45TXWT+FxIB5QoR7Be
         eNM4amXX4Ztgw7878voI1X1CUqmyNejoYCB4IAm7rSJw1W4moDgj5tiiBQpW1b78PmMG
         OcUwOpkZOcUqjOlC0TqBOFtlfvUeKkyJM39mgo6D+JEQQk/+7bIUFNB1UC45ezYNe+bW
         Zr14rDdkyvXR209A7LdLGCTYNNotG6BIKyw8w9CpxtKyE5ClNuaO3/wXND2suZgQdUQu
         CdGA==
X-Forwarded-Encrypted: i=1; AKwUvByTC3XT6SxsJTf1wXWjK28xRro/yrCi1dd+ZbXLn0myFMYLO9bMK5AUtkUaALtS4UuPoPN2Cq2kNA==@kvack.org
X-Gm-Message-State: AFq9FYLoDL8b2bwTQoGLIUoKAUxunl6U5zQdhYMVAemwOtKDiY1AP/AY
	6GM6sLwAhU1xMBb1L+IhHkQh3mmUo7tIikpYSCgDY4sR0g69JCepw69lh6bdynAq9A==
X-Gm-Gg: AYBFou1E1DdA+A6rMhDm4UcLx9cwcnls1MqcGX9Q2zQvlBnZaVx1n6wqzdaegt6ZSaj
	7BTpRqQTt9Iw0X4EJFs9YsBjb/LzwEUbJzyO3FwDA60EnLpRkKyHGr5nJgWLsxBUrAhxLfz5ifu
	pfK1aEiFSTrhHr8Zzs5Xxgm3Sz5g8nIymdiJ5IsJ1rdf+mVsIS7u4c0zwkylY+LXExIsLB99Kal
	lnmWSwbRF3IohfBnMTXoDZ6fwij2QWqiw2pUNCuntsZ1b6r4RB1+6OIHJDLKBupsEa/IXje3R0G
	ZLH/BpgUzmIGIAPTBvUfOSkV3Js0koL9qxr7Tx4zR9wR6CBTFqADNgtOK6IJzZZ0BXxJIN/2WZF
	72G3hmm1Hxcq7OsN0Ay82Tdl7QkzEBYrcGaC8+8etolxRSfwTzho1tXUXDsO49CMh3eWt9+U8oa
	WenINico8Ekeye2bNOrwH7GQ5DEFtoXeVv9hkqiSh+4vx+TlvYo7szqbz6vleQNqSn6dow2WLLh
	+r2PYqXOibB7mRBtUIuojJxzuacX7KgjLgIWwPM71Be+e/s1F9RvNuS9U4Eu3g5
X-Received: by 2002:a17:902:e5d1:b0:2dd:b3e0:850 with SMTP id d9443c01a7336-2e8429a7446mr9570285ad.17.1791529945275;
        Fri, 09 Oct 2026 00:12:25 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:383b:5817:8167:5051])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b19a2sm4483535ad.46.2026.10.09.00.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:12:23 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 04/11] zram: lz4hc: pre-initialize dictionary stream in setup_params
Date: Fri,  9 Oct 2026 16:11:27 +0900
Message-ID: <20261009071157.3730698-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261009071157.3730698-1-senozhatsky@chromium.org>
References: <20261009071157.3730698-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 59FCD1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: ac58893kp7oii3yg1ei16ig1m6xcrxg3
X-HE-Tag: 1791529948-604264
X-HE-Meta: U2FsdGVkX1/feZrc5Ka/iniUP0QVxO2CLd6N3gWjXTdzq4lgbmO+h/KqZCmDpN07f+kMVlORUk9Ze+no+YTbklfvoh8raAjfcm1cB+H34ByuHLyFreSMZXBxHHaCUbI5Oe2zqpPuQWKk0tatcFRxir6EHAmQIYR/9HYXc0U+eH6BtSRBO5l65zQUJssvbwpbcV9QZEJJXlYU7P+yLR77IaSnoaQsf9EcI8ya8K5CiMNSd4C8pbAJjxCD3HjvuJNpz8ssJjGutjpbqvHsce4bdjE5Kvow8b44BfwOHkA+4bK0hh2llPyf3NmDACs4pcZ7j+gad9W8DNw97unzHWkDM0g1TlZ7KnuBhMNgY+N13MgC4pyUTSZcxXLFo1Dgk5tJvqB2LJIaQoSIgOuTFHQilZyy00qDq/tjMkj+x7eMjjshNSDL4Lav33VaMCMNZQwx7Nh7crCzup2O7jxMM3URlUUop2lfz8gWy5iLQ87A5CO2ZUARiFIw/LNZI6McRjkE0beHErYgSg3HCezY1ETo5zb3WUSGeNZPtmg/yuZpSVjrl4+/yTD5dldxkKh3SdAuy1y9EPiq8eT5S+OPmmlrRw1r+1cIeYMNMZlffoERksDxfn8MdPgZEDQsr2WH13OAkMgZ6vhNi6A1PqSmSMruYQUxaoq2S45W1chs11d57zgpT40QwCHAYWiqKhjdqv640I4InicrdgXzjzQVEQu84mdffT3AYF70nKVLVD0oO3tr9Ovj1Qy88sgM85sX39YUH2nU3efgQoTOPTWDUfcN4bdLe8JWm6S01YGOt5isFuOTSjq6Q67Y58d/X0Hn2KH0babPfjraQPvbrdYUQJWEd5Z7GCpA0UiK6tUiajCDnDO3QaFpPKWcS2ErnCNbIRqLltHtM42i5ZFZuf5Tz9euWPVOzOj4sxOAPrVVSGuiOtXyfo/tn3qfTLDAOHQVPuUkoePDzMZKp8qVpv6D3/+
 268mjD0m
 pPQzBI53RdcY0nPJI6RA5ENfVx9hjH2duyJKnLaklJ8qNEgjpvBSL/vtfZPUhOHO6QDK9tc1KKl+AmTQioNuiH0O8p4idcxcw8vVYKE8b6S5FotJCMCiKqVPLrQfV73CZ/KY9ieUUnIQy98Clwhd9C5fnlu/7gj8zRdNgXhbuwGeQYMF9z+Pcf1MFYi/8SNsOq8Aawlpux7rQohffUORpvRNfTkwoNJoHcZyyjhTlcVB/4UBnSSwEv3LVQeC9oaBTFscZEnigR9Kfcea9pyHenVnnqRzxd0wczOc5juu4zkRyXhid2c3j9ivCxOwNnEGnl0ig7xFUNOWovZYtGh0WXBSCuTbuSXdq887h
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


