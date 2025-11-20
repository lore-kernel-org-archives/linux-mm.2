Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8182CF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D9C6B00A5; Thu, 20 Nov 2025 10:22:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEDBE6B00A7; Thu, 20 Nov 2025 10:22:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD0B6B00B5; Thu, 20 Nov 2025 10:22:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9BA86B00A5
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:22:09 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75F7D1601C4
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:22:09 +0000 (UTC)
X-FDA: 84131351178.25.6815EEF
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 970EFC000C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:22:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=H8cxB+wg;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763652127; a=rsa-sha256;
	cv=none;
	b=Kvsv/9LG+xjWDu8744HcpfZ+7zVj8ijIn+iKcdFnjKYWzT5HAnjbWtEoGy/6Qr8Y7b5X30
	NQXuwWsBFzjpPMD1QVvAsSsJHKgahn8GJpg4/5LpiAG7MmVsA1eVCSLe8c/6vklq6fyWLA
	XNGQp309qmcPkshe6tlW10w0EOxUbOc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=H8cxB+wg;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763652127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e2iGg+ib6UXPOcDyrMO0wHUXBQgntN6Dn49JrmQl88Q=;
	b=iimZfnexfdvzVoNZU5f0O6r7VFcQShTDH0cbMGZR2UISZxllwCZaduROz+TQ5Or0xzWnEH
	qGpKzlXS0O8sfkv1AoqgjZvF2eqHqM+pwN8BlUk+YIGJyMmp7FZbST1A+MC4ZpIhdPZhYt
	UAd/ypdH1RDskavlLbnYwh8C6kmopwI=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29568d93e87so9006075ad.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763652126; x=1764256926; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e2iGg+ib6UXPOcDyrMO0wHUXBQgntN6Dn49JrmQl88Q=;
        b=H8cxB+wgrokwB9fpLswGeWeN+oZ7Q3B4a7goLmEtrfCzJZwhSN9DpZF3Elro3v6FxB
         Jb3xNFPrnnLallFM2zS5urzbMWY0aI8/R9XRt8e1ZBaWNJJ5oNmR2nrr7Bf22nddJpPr
         KqPFizfhUobiX3tNLGDnFmov7s9sW5GfxaEnU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763652126; x=1764256926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2iGg+ib6UXPOcDyrMO0wHUXBQgntN6Dn49JrmQl88Q=;
        b=InVJj/LeVxHh4gQejqjAEZW/0P9+lHB1mLlyYexBiXsDU+9UNbQW27VnGtntt+Mfn1
         irIuM0IUAeZABmmt/Xi1AixsW9MyweRjgw+DyOxtiNla1uTDjIPvBJ32Fg8Vf2IVoJ7k
         vf9zdi2kiyzkSo1eiKnKgnElcX8jURxjL/gmNZOA406IGHqB/R32W2cP9h27AFM/37mv
         trla/iEtMUleD/paiZs1GnSyVcSPYHbF8rWY2fUzSD7D7TpHXpnh6VLdmnyZ5vDFNIg6
         5P/BzsIEqA5yyeWtYlnEswSz/RWJkYY9Fz0fzqYsimPOpnezp2ynMP+S9g/LIH2IrJV2
         Z3KA==
X-Forwarded-Encrypted: i=1; AJvYcCX2S1xC+7rX8ZgttnNSRVh6mvFiDcDNBDqb7ay6+OjAwphlPPrUiFyr66Y7+MioWN3wPuj12Ktfjg==@kvack.org
X-Gm-Message-State: AOJu0YwG5Bqy60nRerjGzump1ah3nWDioo5DPJbktAOiZFcE2HOcFobC
	uA0GrKFewiP+YMFE7rxyJ7dMqsnRRpKBJLfRlDPRk6+QCra6e7xHBrsgrr/zMGntfA==
X-Gm-Gg: ASbGncuHvyUw8t9l4aVj1WJ2VTW4RTzzbq/J43iv2clMwaSQbZcS8ZolCySHoxpFk7Z
	A+PLprhn2N+YYBTYBWMCAUOupnq3VA/DwG8ByHTHICcwKOn+JpMf4GtiUW3B8ROW7/q3wH4t0C8
	KoClALpXEdURnR5g3pYcn8LX7P3ch49kli+7AI+J4jqnwGAV07Sd0q3k6AhNzrBf1QjLm48z12e
	wm/GUT+ihVE97RDV9081Jcf5orWR3N6Gju3agbFcQl4FpVjxJ8TTyG65Su1GtSdbJyQz0Xmd6ag
	eSAOE1GYKxnQf6tLRO90xNfjHpFzYDhdNcAs69CGL0QF7Sg9VAweMLJeHvoxhOjbDbdDCtybwdx
	rvc/M0i74wGIkR7WOvkkOlzQcD0trM0Wof69p71/owud4amL4eC730Lrj0T3TrPcuY5ELCTDJq0
	QrmnYawY6toqhFiyAxQZOPiLP3nxTAD9hkiuXXCA==
X-Google-Smtp-Source: AGHT+IE8tNk0FkEIShJqDYWzZEbbNAd6ppfq05qQmtYQbN9xJbxUzpj7n3cqYrDIpYxS6M/t0wrnYw==
X-Received: by 2002:a17:90b:4a4b:b0:340:4abf:391d with SMTP id 98e67ed59e1d1-34727c05f0fmr4499624a91.16.1763652126303;
        Thu, 20 Nov 2025 07:22:06 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:6762:7dba:8487:43a1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f023f968sm3179642b3a.38.2025.11.20.07.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 07:22:05 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>
Cc: Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
Date: Fri, 21 Nov 2025 00:21:20 +0900
Message-ID: <20251120152126.3126298-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 970EFC000C
X-Stat-Signature: 4ofwc4fixmac6wkgahzpsm7wxthd46ta
X-Rspam-User: 
X-HE-Tag: 1763652127-771455
X-HE-Meta: U2FsdGVkX19H/ExEFRQqZrR4cWgOQYLl1SibP4Ikp0BgdrN0V2fxF6JYUyo7EVhrFQFERQ3HgIZTbw1viaeb5Zh11eUnDUlJmhQkWIZRK1bNgOb8MoXTUlyGKxRMO35EvlZQP7WQWxxuEtRxY3JQDct7+29c/3lKSQ0lpiiDVj/e5MeXlkg7lWiV/Aw2FuXkN5hJP/I+U/uOGpH9D2vE37MqyHg52DOLJTRXbrZ6bqKo71PW3F3Eg1k5zFB43ddsQVg+ne/MQdo3cHcN6VwGhOMgg5a4B+f2PQcXkGFfLlOoYrbp3FMh0yf+X104lEo5QCWwLVCS2b/TjJmL+whWkDB3juIf5uQJyjU6hEXj2Z0C48N4zXGJlp27EnXNCn3Fql7u/N9gzgdzkRnhLcMHzxIyYrNN+CUG7+41ZzqwhTdW7IIbS/iAaLp8PjvpVFnIClSMb19oMKDcbJSsr9mjF7/z41hBj0XixcL9oDEb3cCZWA+/jUwEFCNKG78/CVEbNugby82x5PMXK7aUFEatoIpH2OfVbosPbIveLkJakss0tVtacFH8Ritf3ThpfGiFQXA2cAx8455QzDnm0FjWaS4UEeQ6gsb966yLoclfefDrk9o7EZxATvjPo0ElpVpJyEIIJGbFsRMiqYzYfP4Al6oV47oTNEW4JOUHWa1GWeUq1KEtgJ7fhm47rRKwQ0biDAmaHyK+c9Q8wJr8FO8pBX7/YMo8BZv2zAW2xxv41E26K+zkgp9jN4kZJqpMUGZy0bcMPDKrpQFrVoYbu5yCWZlVOo/YQfzlgPZ2N6Nq1ewcRtRsE7kmRBNCSpLRrbyg1IGbYSr7fXTm3IWVuLD7F136CPW+WGE0lWFFmXbvUQd4tzjVGlwmk0/hgrkAqRyivU/y46hbKrhWkgC+0iRzTeh3GqavwXLVrZUmEICQJcRWEsMLyi0m/VNvrMJ/1isWo9nAOEp4zSNxl72UojK
 z9etDXoD
 rCExpTt11QRfTJg0u4sBW0G0OqKTZSHqJmmncg/TtJZafl0gC2QpaDMvij2BSI1UJ0QVW6YUoUOpsrF5rPhMBxE8mtnt/yV07P2WtF1clNwImTG9IuiSciOOQDy1eeTc9RciYK9l3y5u7igB5JzOeCpDwYdeT3ueYjTs7+zSXerDY0E+H/WqZAIUS5F2oMkBmj0BaplaHeOZufPCaQ2m39iD5s1nG5oYDN0Vb/MHv6jMathCOo8EetW0Be0+XZfM8HsjNhQHQR0lyL0eW73/eJC4T5dBfhlqXA+llQgjYM3tyV1JNQtBeoKl4GU7kIF1M0l5GHAAC6XseVA4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RFC

This is a different approach compared to [1].  Instead of
using blk plug API to batch writeback bios, we just keep
submitting them and track available of done/idle requests
(we still use a pool of requests, to put a constraint on
memory usage).  The intuition is that blk plug API is good
for sequential IO patterns, but zram writeback is more
likely to use random IO patterns.

I only did minimal testing so far (in a VM).  More testing
(on real H/W) is needed, any help is highly appreciated.

[1] https://lore.kernel.org/linux-kernel/20251118073000.1928107-1-senozhatsky@chromium.org

v3 -> v4:
- do not use blk plug API

Sergey Senozhatsky (6):
  zram: introduce writeback bio batching
  zram: add writeback batch size device attr
  zram: take write lock in wb limit store handlers
  zram: drop wb_limit_lock
  zram: rework bdev block allocation
  zram: read slot block idx under slot lock

 drivers/block/zram/zram_drv.c | 470 ++++++++++++++++++++++++++--------
 drivers/block/zram/zram_drv.h |   2 +-
 2 files changed, 364 insertions(+), 108 deletions(-)

-- 
2.52.0.rc1.455.g30608eb744-goog


