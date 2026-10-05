Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1502DCA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366276B0099; Mon,  5 Oct 2026 08:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3169D6B009B; Mon,  5 Oct 2026 08:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22C736B009D; Mon,  5 Oct 2026 08:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1A166B0099
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:21:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8877840235
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:10 +0000 (UTC)
X-FDA: 85288482300.06.CC59705
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf14.hostedemail.com (Postfix) with ESMTP id B8EA4100005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CGrbDtaW;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.227.140 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791202868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xr7xKaCtjbvx7w72LQrkYXXkRaaEyza6tLflugoYiLo=;
	b=nxQtZaLzBq3ZDX923hnsOZnx/TVkUU6NzDxuD3lKC/KpnTaPb30yzxYR+uyowb8woORSnj
	/M2kPE9FI/0Veeej00tVK4w+MpYv/K9vSoOSR3cP8WywSfGfOA+Ukx+7wMEu1FmdO0CZiO
	4pZUOe3naU5ySSEgY5f7MFkcQM7YJNY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791202868;
	b=T6mk2C6ciC3NMlRL3kwgTEJPCeQb9ATV+CGIFeY/n4p1FDBOif9DZlumKNKIYuh7rfBHra
	lr8jC0MWu9TFuIENISGrMaqgKLUmYeZlgyZsFXS2t6DYqGE0IdTgz+cAH9MJ694sMtm29r
	9CFf9Nc/CDfaE2BHzbu+MHHYPtf2Auw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CGrbDtaW;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.227.140 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-398b3b189e0so584350a91.2
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 05:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791202867; x=1791807667; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xr7xKaCtjbvx7w72LQrkYXXkRaaEyza6tLflugoYiLo=;
        b=CGrbDtaW5voH0OiNHKyKt5B2zVNYC/UL7BT5+5dHIYghOrM3MBafIoN9oStvIxK8+P
         aAqwi8cpHUuiQy06DljwObI7wzT4c+9SMN1GFrhZgDAJ2NCxldgqbb1e2AkHm6REmcZG
         MSdOzBzeXCBm99tlBnyrjZg+Ged4egY70hBtM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791202867; x=1791807667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xr7xKaCtjbvx7w72LQrkYXXkRaaEyza6tLflugoYiLo=;
        b=xdcYIcja5M+x6tN9NbflyHkRHXMW85Wp/A6q7VV/0ZD5EyxqgjrmYymEJYXrZ6xdnV
         VS2WvZ1GGL8gbJU0SVI6NB04K+dLUDuoz/nPgGq00JrEX/zxJqxX099Ctw54QguP+WdY
         Ca+zGxvwLB3Gd52dmi4eQ/3s+rxp3+9CWjWx2Nvx0wc9eg/0lmkD8QAQu8T3BnUiLU8X
         oOMBJgdP/X09FXhkiZb0PeJf+hhxf3J09zkJGrFpTVmt87S0kapoCsHypnAU87B+4sW/
         hbhBWfN8tKWm8HT2RTWOTAMRJ06MNIXGM7GB1gWx3WDimGF126cWHxKEqo6+uVDohJ1n
         Q9lg==
X-Forwarded-Encrypted: i=1; AKwUvBwm5FU/h+LGPPE/gavtjOMKjdL2sp3q1w8U9xqY1MXVn8hpNrR6VkRCfNkz6cLuRkeiJEY+lRICaw==@kvack.org
X-Gm-Message-State: AFq9FYLR4Ou5bk6quUeVmm4rFCma35URiM+3t6zov5792Zk/oqKVZqRm
	W+qj7JPXfF7K8NczIFNubTicsnRhYvgzheYu+1FLwR70zoLEHeF4qZoZFGx/1++MbA==
X-Gm-Gg: AYBFou0blpsq29zOIo95d/Fz95DBW31mUfTSox+2MyEu4BDctt+3FCZlMY+7vQJyxJU
	z8JZE83lyM04H24mEooJcIrDN8NUA80tHOGG4y2X3N97I4BpMlUexwv//0ZYvW1RYKAvcToNuvc
	DLisQtTZqunCh+gGMqgFfDMsn42ngEK1E+4UXqU76LwO1pqzdwJhJxw1P3I0pH6VBNCHZwW/tvP
	2UyHm1HXXaHlzaCLxvEykCuiW60HJaQYheSoD7PHsGLbYn0b4cVZG1vToDBWgGBxZJTEqaznjOl
	yGoQkXzdw3WzTn61wNMEChRAGDfS1JfpdQEbiOf0fL4TigtjdelnSCgBeoeqw+6xkP/LD6xXQKJ
	xKOIUBRES4DZhzvrbjFuknPioeDrInak/XZnhnMrJrupic+AuMOrHuUE3MttCjXHv8TMNV4dKwg
	4rHrUI2Pqq+sElOTTBQw1IerQy8X6syHXl5OvLzbUjmVau307EG92LG/RA4BBYFmPZkJGhyfrzl
	S15AEurL1UoW5R+PP26TXWYqeoMzGNqZqhCzugUbzNI3YvXP7J9e6/+I+a+E0P0q4QFCkhljA==
X-Received: by 2002:a17:90b:260b:b0:3a4:f1f9:1cb2 with SMTP id 98e67ed59e1d1-3a6ce6b4005mr8903790a91.13.1791202867515;
        Mon, 05 Oct 2026 05:21:07 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9211:ddf0:3c6a:bf9e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7e4b00de6sm3342997a91.1.2026.10.05.05.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 05:21:06 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 03/10] zram: zstd: do not allocate empty C/D-dictionaries
Date: Mon,  5 Oct 2026 21:20:18 +0900
Message-ID: <20261005122036.718976-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <20261005122036.718976-1-senozhatsky@chromium.org>
References: <20261005122036.718976-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B8EA4100005
X-Rspam-User: 
X-Stat-Signature: ideaeh9odyywz1ezctm4fehf8xtx4igc
X-HE-Tag: 1791202868-868246
X-HE-Meta: U2FsdGVkX1/XpwpoddhcoxvrFzYj3drUTVByQlazTVGRVyqRJg8EuhK1VpWCZdzt5KA+bHcv/ZxIAcOb89/eAVAYrLL/IlCVZ2NrUtrD79GSXxplcB2rzMsZxm+NzQgIJTf1eYsvlEbuC/Vtu2z7SZq0GLQaTxTWy8peJr8vNy6JgU5gwyRkGgROJ468ZIdaXKvivotYza0+wpDW6oFh5iDr0DazYEVCs69eR3WR/FjMYRJia8FiULcV1XSGI3FYzzfazXmGHq6WdWKbdBoXuBnsTthlMRTNy9h5OevtUgWdX8wikjCmwOqIMCMyT77RewFw8YBuBoEc1+w56MYapnHI7WlWtywaYSKUpr60vs/ppLgx8T8eQTI5VYdQOCfklvyuIToJHzgeFU/gsZwsEgF3eSZhkHyJUWrkmNhpBXf/TuXUKePU7o7SKqKZ5Y1vQfw8EcbVItIsvgJKGFfOzyrBKDyjHDXuOzxt8IRkvqHWJV1lTmBpMgH5AaR0XnJR5f7+euBl2iqua4ctbsnUPCaDJrNkg3kdKA26sUVa+qDZ9CmovR6fJXm+CJRngT+gyId0OOroTAcMvCFhzKUZogyflEcYcsTUtZwC7s6XMsN1iqRILn5WEfzIiQlSJ0Y62lRLP8zrSA6krnnlpHff/6y7RZQV47DPjR4OEXDf/jDtVoJ3yodivNqhbrVtapB3/BgXQFivDR7Je9465FjMJzz3W8sIu9PWEo4KviOSLNwua2un/WpsgqeNKCPgd70G36t5d3QnsWDk3ltCtq5ziI/jq25WUBPi0ekpFnDktWJRBrzfHHqtZj/v+3bPgquGZAIavmEgXcHajZe1w2UsvSJWZY/+A04iS2VQvug8VTYsx/d/PPIZU92TAM1tG+dFB3DxVuQpkiMVfh1d+LvZT9IVFfgOpE60iCSy6BPHyH0v9kcGAmmN7lZU2XCvdrSGewTWqJVD/u+KY1+gtzX
 XkdP0uNX
 zJ0bOPq+3l/Byig0XLwiKW+UBT9DSFMPS7Sw7eqNPe4sz/+GDcAUPannPGh4z6YhU6duuHYZDdhfglYGIPEut7F9GcRbJzEmQzANmGPx4Zz4FTDtiwq0mX5efjEyTNDT7BAGOqbrnuYdjttj8OemCwIrkbx4Cj1AOVrUPJXgC2eeohUaycQpTYSkvdgga6qetswlJtdTdtz7Q7c5fOsHFL+RlBIHOzJ1/0b7bx3CD1FaIjKXaYpSGbR/WjGKvjKmJbTosqgM6MQk4cfuRjz4Y14inBNkYnGYfkUxVQerlIHktG6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do not zstd_create_cdict_byreference() / zstd_create_ddict_byreference()
C/D dictionaries when no dictionary was provided in the first place,
because zstd still allocates internal memory for such calls (~96 KB at
default level 3, and ~160 KB at levels 9+ on x86_64).

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_zstd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/zram/backend_zstd.c b/drivers/block/zram/backend_zstd.c
index 127976b5455b..b367049f131d 100644
--- a/drivers/block/zram/backend_zstd.c
+++ b/drivers/block/zram/backend_zstd.c
@@ -76,6 +76,9 @@ static int zstd_setup_params(struct zcomp_params *params)
 	prm = zstd_get_cparams(params->level, PAGE_SIZE,
 			       params->dict_sz);
 
+	if (!params->dict || !params->dict_sz)
+		return 0;
+
 	zp->cdict = zstd_create_cdict_byreference(params->dict,
 						  params->dict_sz,
 						  prm,
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


