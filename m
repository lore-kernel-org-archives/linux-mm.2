Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C953FD065C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC716B008A; Wed, 11 Mar 2026 04:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33DB96B008C; Wed, 11 Mar 2026 04:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A356B0092; Wed, 11 Mar 2026 04:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E418D6B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:43:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8CF6113B497
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:43:36 +0000 (UTC)
X-FDA: 84533143632.03.38CD9D8
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id B909F1C0008
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:43:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GPWxY4VE;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773218614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YQanG0Ycz+PQWOQ4QkKwzQajwhv3TLjpxD3lKKqkSl8=;
	b=20NDlRZQE6C4YLtHiW7VmTRhr41DPpiNUAHdy1Rv+E0BDInFtKcW513GGXSaKSPkL/uGO+
	3VRuEud+btALzVu5OjudkZquf8/wGNcvFXppV46NvAlI/31rl9ykMvFJR9SiA3VWXH3O+F
	TFa5FGSB3VDPWYqB0sPYI264sY7X7N4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773218614; a=rsa-sha256;
	cv=none;
	b=YTOhKbHPYXKEV1C1gcATNztcHuUF+xaxnZfPqyNovldR3arSwBpdD6HGYvaDo5fvI04L82
	dYEUY+qLDGocaNRvHj+xDnYARNVaLtW1W+UzWDrfjN9i6E49FF0jLC+aJsWNQPq5N75bAM
	dHWQnFW6IR3N7J9MMFugE8XJEdp+ENg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GPWxY4VE;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ae41544dcfso119042925ad.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773218614; x=1773823414; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YQanG0Ycz+PQWOQ4QkKwzQajwhv3TLjpxD3lKKqkSl8=;
        b=GPWxY4VETf+5Q4fDuIufnSGvEdc5WVyWKjIJorm+ZRO5tVkPbGeWuAl1jBKqDVRNJI
         Iwm1zRaXOK6jXzuvm03Luk2/yYTZ6p+av/EquQ17bgqA3Nj++0spF1Y7QePHeelxQDDi
         WdsEU+9KMe3OQ19gs6zEGAB8Imhvgq1jRKw6U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773218614; x=1773823414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YQanG0Ycz+PQWOQ4QkKwzQajwhv3TLjpxD3lKKqkSl8=;
        b=IxXmXuDdQ8ZYhMlg+8Ldn6LZFsL4THOMCB+HcxKF2K9x/Mrytc0IZydEmmy0esZW1Y
         cY357JNuLNNPGoFUL1AmZJ7mKSYL9QmnDw1z7OSjmowqQKrH1SDeIinCzV6Md6QOJLgY
         DvL5P+c79mq9QUK4/hSR0Rw3SParW2h4SgwdA8lwLwRYJtwwD5r/Bed3sn2OTgy5ySi/
         ncSIkIIRlry0sqHqAdsERQKh4FkVpdlgHZZKqBgpLXOzSSGX7lULyVl4EXfEBiyIpdMI
         G6hqra8BcLrHuURinGiWcXrn+KAU8ntmowFpSDjxAyyPQkb1uXP4EhKEU7DOxyMv0oJ6
         iXSg==
X-Forwarded-Encrypted: i=1; AJvYcCUniX2t1iYuc6onBGMVkM/btV5Stv2xZFmUVm0XGydGKMb1C/8hW1K2ny2qPom8+Nrq3qSYuofNOA==@kvack.org
X-Gm-Message-State: AOJu0YzOnUXHMZpYGhJ0yQknzlunxZbuzI41DWc+AzC/XI3copV8qGMO
	mTdApkpqLz7+S0/33iyopRNiAFmTRLv/vy9TUDrNMU9B9FuuVtSgeyyQcAgJjo14Zw==
X-Gm-Gg: ATEYQzyP7Tio9ZjMX9KHZFtMimBUXnJdarbmfO8Io1/hrMRAsK4IpnurL3tEaQMC3kw
	UAEnLKP8Ji2CZUSzelJAmarexc9i1Ew4Uo9VqMLQC+UBqCD4cyhls3e5mePPEocxoYaiEVjIl1L
	Y8CVBon5qkshaSCjzc1MgFNBQpKKHpCR3vvlY7nZ5p0RW4fIeqFF8emG89LS2ne6VTt9XgcVeZZ
	95PD0cvGKXDLwwTp/C+O8NGIY+R+Uy+dFZnjgekkBiL98txgimOtG9dznna1wb7dyt7h3pk4i+5
	Met7KcyJs/hWZxjTxsY+LohDLvg5qw2UKD8IZXgMgQwM3Vaq8u8Tb6RTgf6fB9myhiklt/VCHWc
	hjGj8JOKe5jsPGPB4nvhDEBiK1SA/KsF/Q2EpvGlzWSjU+uOXHh/OeHFgExINmm3l7IQTQ7cD/v
	oQD3NCrlCARKvD1vjcx53nCTNGn7e4/z6D3JhY9kdC1TEgc6OThQct3V79wz4QWaK9vZ3RIaBdS
	aIIDJAWU01YLPOstn84hELy
X-Received: by 2002:a17:902:f651:b0:2aa:e6fa:2f6c with SMTP id d9443c01a7336-2aeae7d8961mr18404595ad.24.1773218613744;
        Wed, 11 Mar 2026 01:43:33 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:93a4:8281:fe98:426a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae261077sm16062035ad.40.2026.03.11.01.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 01:43:33 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 2/6] zram: do not autocorrect bad recompression parameters
Date: Wed, 11 Mar 2026 17:42:45 +0900
Message-ID: <20260311084312.1766036-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260311084312.1766036-1-senozhatsky@chromium.org>
References: <20260311084312.1766036-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B909F1C0008
X-Stat-Signature: q4y6m7wofkkudk5795q1z6funpjkgdek
X-Rspam-User: 
X-HE-Tag: 1773218614-7630
X-HE-Meta: U2FsdGVkX19rOjir8E6J+Davwp3r1EcxAQ/+RzuGA3WiARGQzV+/EO13XcQaxKMR2kkRjtz+ve4MZF5y6tLvklo/6W98yLwp6VeQ3ToB181mI1oVwzxswk/EiaGyqmJNtA/oRdJyc0RNjzwpV1lUAi3rXJrQfT2NeW3vWR+WF4CZMmva841lTcAFHa3ooOFLp+QTa/H9RlfTQUG9HZRbDu/xTanKXnGKUQ5eT63HneQF09W5Cz+5rhxiaEe3f1+LniwakAQ4MQZKqfmCvojSGikGS0XpOeX7SnfTnz6rnCXZTbiTdBrSpsmAoKMsQxx0vl7kQotPEedBa382nyfpFXyBE5bqBExJ/DBUUS0zuqHlyez/lfA3W6qmlBbC+th0+qjZAwxY8JYmjxTN1vWONgYg5vURwNnq1vGt9b6NeqSxe4gEglSALYH2KLPVIXZWOsvDM9+/8XPNM0xq7qzkaj9C9PcFfpGJrPYYWYlDCSUJOC2KHC7p/Qiyd+u/2SNwkwLXwWM59/cT3N8w4/ilELYPdKdEA68t3jJ3CqDI0bGzGhoTG0xEkr9X9ojyHLFxaN+5Oq4nJAeW+SCyeQtsQIDUHsoOi/LSyjBui5IYKzQ9+4DNF1jQCy4oZKZvRnnvjovHq/vhYhIhh+x8TmSNj94XoQTZwnAm9WF5A1ZauOhFqqup4/zeIUNGNyCuWXH0ve4+y3CSmRLBZHTo4bz6UR5n/U0IeXk5skpqCiX1yHGuBbk+UXu3TccKOp6DQoA6Mb3QX+/O3D9nPawViOkDOhSpmmKjCCN/o/55jEOjXHngGLLRIzQOpLeEd6ULG6PWuQqBwXJop0+gQYHuFrLVa2GwvSUSdlYiyfgnLiEG7sHvioEnPOky+wQfp6dq3dGkoh+6Iww5iwVP5t3O/IEXM73kP4VytB69n8vPu/DfWUebsIkHeOlfCCEXKSchAG+n5B8ScpyDV/wNaK2Wbvf
 n/bd2LIw
 ZLtcmcqoKPDw7eTKepee46IfP0VLoRowidFi6KTkZ074C1bXFls0lB4WGyk38aXzZX92EG8u43X4cnO9cq1XMaEk2ZaEh5hVFS4Jo1nZ61sF5gZruvB/RPZG+IQzvZ/v1cVg5Vk2SMFuosHLyUg+0T5k/ObEuE5s0/gz+tXmCFqdzHWaS+VOf7cXVTt7y+MnFllxZ3hTz0GxuVzCM1XVcsvnwR/oHCz6Q+0f/FpumvS4pOywpf7CtVc48i6+0FanMun8gFuHQ6t3pzaxA4RkvEMCOOIxejK7ezWdAzqU1f6j9GUWqIJ7bzwoX5jEjUcXArCEI8pgEGUj2cRI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do not silently autocorrect bad recompression priority
parameter value and just error out.

Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index db862179cf59..add3291ff27f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2528,19 +2528,16 @@ static ssize_t recompress_store(struct device *dev,
 				struct device_attribute *attr,
 				const char *buf, size_t len)
 {
+	u32 prio = ZRAM_SECONDARY_COMP, prio_max = ZRAM_MAX_COMPS;
 	struct zram *zram = dev_to_zram(dev);
 	char *args, *param, *val, *algo = NULL;
 	u64 num_recomp_pages = ULLONG_MAX;
 	struct zram_pp_ctl *ctl = NULL;
 	struct zram_pp_slot *pps;
 	u32 mode = 0, threshold = 0;
-	u32 prio, prio_max;
 	struct page *page = NULL;
 	ssize_t ret;
 
-	prio = ZRAM_SECONDARY_COMP;
-	prio_max = zram->num_active_comps;
-
 	args = skip_spaces(buf);
 	while (*args) {
 		args = next_arg(args, &param, &val);
@@ -2590,10 +2587,7 @@ static ssize_t recompress_store(struct device *dev,
 			if (ret)
 				return ret;
 
-			if (prio == ZRAM_PRIMARY_COMP)
-				prio = ZRAM_SECONDARY_COMP;
-
-			prio_max = prio + 1;
+			prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 			continue;
 		}
 	}
@@ -2613,7 +2607,7 @@ static ssize_t recompress_store(struct device *dev,
 				continue;
 
 			if (!strcmp(zram->comp_algs[prio], algo)) {
-				prio_max = prio + 1;
+				prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 				found = true;
 				break;
 			}
@@ -2631,6 +2625,11 @@ static ssize_t recompress_store(struct device *dev,
 		goto out;
 	}
 
+	if (prio < ZRAM_SECONDARY_COMP || prio >= ZRAM_MAX_COMPS) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	page = alloc_page(GFP_KERNEL);
 	if (!page) {
 		ret = -ENOMEM;
-- 
2.53.0.473.g4a7958ca14-goog


