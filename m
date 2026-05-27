Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB272CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 04:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 160D26B008A; Wed, 27 May 2026 00:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138AE6B008C; Wed, 27 May 2026 00:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04EF06B0092; Wed, 27 May 2026 00:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8DE46B008A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 00:49:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3F8E1C03E3
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:49:35 +0000 (UTC)
X-FDA: 84811971510.01.A182619
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9B7924000B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:49:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Skzi/U8m";
	spf=pass (imf04.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779857373; a=rsa-sha256;
	cv=none;
	b=3KAFFKW0HXTNVopW3gnOn58AoDwTzRuXFu2lFruwOUL8FTjX92HDrLIujJFsEPYtVeI6cJ
	KFaM5uXhYwvp0g6fVbWBk5BorwNBF64D3ES+pYGxkzKasS0odWB+oOJCc2JtP+dUW5LNmr
	8VvLob809ChSmdzNABnzUXpW9zzE4Q0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Skzi/U8m";
	spf=pass (imf04.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779857373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HdeTI3Be/i5d72s0tyEQ/VcPybxiAdaZv+qc7OW/TlU=;
	b=EnF56M1XP03mZpmunXrEKEaPx/SzdtdWqbOrLTKiAqv9n0/LxNulIhi79yvaWy4k26iRyn
	FbOUB148xVZ6UATm7fsWie1P2TGat939zbNoVC0LtH566Nkyl8vuJO2fZoPnH8NoNjsJ3z
	pfk1g4fFHhN1dzygyrCrDcw9GOLIiW8=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2babfd18435so50772165ad.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 21:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779857372; x=1780462172; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HdeTI3Be/i5d72s0tyEQ/VcPybxiAdaZv+qc7OW/TlU=;
        b=Skzi/U8m0VMhsG0nw8LnEFHfPzpJnpRT68sJTZ4zgH/ElB3P/2iOmhln7Zh6SrnDDz
         +XKXGIGc2HtCV2upf4b3zP6zgec3j5/PSQ/0gX7YEsEn2VHOtMziMQsMmz8w5nb2IQwp
         AlqAWVFUtOcaOixTuczqYOE3SNygB3aL7HwUNsiKxwLe1Cj0OGRFdUzSToba6KX3wpXT
         ugv38HD6+btngFhSvLmJFoN57+P/NHVkTlyxaD3yEs+JwBHQAjsQdOedOUysqVz2IK2y
         wm2ZnpMHT57Om+jtvFWOnoml26f9Wwzoq7QpTa9I69VmIMCmUiLynTGCyZfB2fBVjfcp
         fLcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779857372; x=1780462172;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HdeTI3Be/i5d72s0tyEQ/VcPybxiAdaZv+qc7OW/TlU=;
        b=EtcyoUR5OrzaXhxSm4PoomelwPREySYoanrURLt/RW3DlcBIn2GL7uFBnmGUyd6bPF
         URKjVT6bQs7WmSPdhu3nxGyXSkG4eXK4na7FlUbk7VkdJJzAwKJvq+56qvmQ3p7gQPd5
         ykWL9S/Yo9u9UUXgLhBM+kNopROVEuGKVBqhO8g7ZegBakFXmRaWqmibJNPisWeJ+T+N
         uod7rn/PonDC2KHBpj6X17weHf/FP1vn9fyHQJNPYjTk+jGXvLetoWZU3k3aH8fwAt5v
         B0QbOCL/G0zUB8w5zslf977Z2EXtOWHjzOueFAhHDcqHxAxGR1UEoX+/it0s2mRUVl/n
         9BDg==
X-Forwarded-Encrypted: i=1; AFNElJ/fH8f8GnFE+V5tKp1SQGp3oQRf2nzGNzTgr1JoghF4Qz7fMHXDzxX2f087tgg0e0EcpLxWMZJCaQ==@kvack.org
X-Gm-Message-State: AOJu0YwGpRaaODj3VcbHJ+Dkon0aMO65/BYQrY4ghWudan+K2dmCp584
	zNvew+Ar8VOfSGPW5T+13F008tnOkDCKpalFiHtKNH026AMpS4lhSO3P
X-Gm-Gg: Acq92OFlMN48iEhQN48rmV5nCc4BosDHcloBAHu0vL3ahsnk2Gq+hpq3078+PizOUXY
	skY93+TX/TLHSiX0fHWcMEgBevtbGz3m4Bfw+T+DOVaAFtLCU3nH4pocDzTWnKC3wZ9ECFkQacM
	2D/FJIKlN1lKwyqLfv1C0qqHpDFOmx++pQ8Bcl34M3PjdXw8H+cqiGq1ftbn3oxELDCm5FkephN
	0+bQ563OkzmNbZywOJThzeNlcOkdSMOWivHFtn3bpSFILrk62B6ewJv8wxxjC6OBfeGDQMUVQ/4
	vY1qRclQ1Iyj3zrj3JadHT4Hmckh6oovFBicogZTnIuHPLE+F2J/5a3J6Jmc9hyGICBIulBsk3l
	E0nuWyyudvSZsr6QyK+6Q1haxgWrh1BXfd++rDycnGtYnfTOl5rox/Bl/sFOIVE6irnJd/lgPqv
	E0l7UlUH333ZqtJO+WS0haCU+1eFjR50xtjg==
X-Received: by 2002:a17:903:3b8c:b0:2be:1db0:f166 with SMTP id d9443c01a7336-2beb0346484mr233822145ad.10.1779857372512;
        Tue, 26 May 2026 21:49:32 -0700 (PDT)
Received: from [127.0.0.1] ([116.80.91.208])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58dba7bsm135704105ad.66.2026.05.26.21.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 21:49:31 -0700 (PDT)
From: Cunlong Li <shenxiaogll@gmail.com>
Date: Wed, 27 May 2026 12:49:24 +0800
Subject: [PATCH v2 1/2] zram: fix use-after-free in
 zram_bvec_write_partial()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260527-zram-v2-1-2fb84b054b5c@gmail.com>
References: <20260527-zram-v2-0-2fb84b054b5c@gmail.com>
In-Reply-To: <20260527-zram-v2-0-2fb84b054b5c@gmail.com>
To: Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Cunlong Li <shenxiaogll@gmail.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779857366; l=1429;
 i=shenxiaogll@gmail.com; s=20260517; h=from:subject:message-id;
 bh=GYq7eClao3GaV9lgjcsADvNLW1hhn25v8rqXYSyuj3E=;
 b=y0NCB/JE8egqDA7ZvcgiKHXXTPhJDt3eJNcyH9vjqfcf2urXXxuO/7LuiX3+8OQB5bskhQHGQ
 e9j1YvGYcbyBEJhvACdZy6pB4TiDjVceAUvbcQ9UF8MJErpnJDy5PYO
X-Developer-Key: i=shenxiaogll@gmail.com; a=ed25519;
 pk=SKFifnqPdsvsjuhUiq+Y9vtCdhyZ/LrRcfYn8eRq6AE=
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9B7924000B
X-Stat-Signature: k8xpnqyprqkqxybjtzf1ggonfikz9ind
X-HE-Tag: 1779857373-544352
X-HE-Meta: U2FsdGVkX19t4+wHuiKLD+hAv8CjoDaC0i5TIuB846w0t1d4zXRStKJEMGeyBVCBVAAY5f9Ack5/2M9j+vOMnhNz44Q0gr2QMN3P75Bc+zEzJY/7zYWAKEW3w4GXhDNWc+Js6kRtROe8v/Jx1gGE9rt+TIejoYYvKtsu7CJ35D8Q93+qdGSMqWq1Rc/oVLtMMaHhk76GGqkcWzdOsPW1Vv2wusuDLPGlfaVRHHHE9ot5gGxj4wyhdpRRnt+4W6bHwD+09+4SNa2zBEKSkuQ5udNmujngBa71/cDI74h3p5FGMk3U7Y1pEyrxPSLDNEhIFkaFhIusyDfLIuO/FdLP3elzn4yrJJOBbl9f2D14tM9Pvrs6+pc8ZqMlR/BAQ1+xjGBEOYfz8SZKsejbhxHV+Dy661xlgx+I7p3uZ1gMledGBr93jFFb72uKO+oqVZujfxp44eRr9aJWBK6QTzpAQrR5B8WUckYGtswHoA4fsL8GMYtjGVHp0cFtO+mrlZGnfE6PwGHn3IrfY/KkrRuQVs6SiVANW0S4kiS2hGlPRK173akKXp5cAyuOPqA+V6/S909IEYw3SgFhnfdLjJIFtfLNbLpP3LaW7n4/cNQTd6a4wdxeCiZIaV0IpitBVNqFAgInNE1duPkIZSJTMcUZcFO9O+DdDlyoeuZnuD6iVSffWGsBUK0RTrVgPgmpAWGCoacRVC0eSRQL4UU9R3ol1enFnD5ulR12zGPWDfaTRtyArU3kk/0GNg9UL8Zwy/+ZiyELfwOaeM5ysj7bG+aPWJFlsNY5uaY7yxfG1frzgj8WA/CCXc8GaJBad72Zu5kCpY472wqqgjTclZ/ydtCAM8FQYW1BKoi65dHVky7iFNmGhZzjUo5AM7G1/pCLoQ+l3+AGJLn2aOs/PpzQL5M9SvfymPSvP2/JYZV2IraMrqjxkV7oCDaI0x+oc+X8qtgoDlGz4LisYpM6E+Db7UA
 +6FCbias
 879riGLIqmuucTIEzQUzTfKYWis7/AVtSaaPSC9ISHYXAzKGWJ7I9IZi1A1fPj1/FlstHoBQ9O6h6WYsV04WnbkpaCYwOBBpGtUgtcgklBB539zX5gab7x0CyFPPKx2C1wvA2V/XmGoaO46RnN2uvJX17l2kGzqResQhlz2L+yWX15EdkXp+gdMffuUHF7hF8QVv7e9o0bB4KURIaippxRzhr4cS1lFOh7qqPIL/wUbon9oqwEwSFI4wANMMaaKrwmOtNeaTQ5qgsnLmzDiFcLbq/eWZSAA7eJsnjJInZsMeu0KRzG9OGxhqu091E2WzobEquwIUxakonFj2ZnBdEmJF014n0/d5kB4YEHlYJjHii2S66zkwOce9SVUuhtkpFkmFej55bFMKrvgY2LVodmUc9XoCxgEPAY72EPLPlRmHFSH4Q2qq2rsefNkoMUm+erzNAKMfUsq4k/4z9Cie7cmthO8/CHbw1Ac+BOh1Ci2dBNir0om+05oeiHN9vBPnr6WZmbjvV51boid3eu50W+oTz+F2xv6T6MvufeNcBjXUGNmnr9Qig0nJhhfWUCdWkXu2jboYluIRBFwimVwXuXyXrTMrmbv64pZocbFPZSABV5Mch07eBBI9AECLnJM7hRsHX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zram_read_page() picks the sync or async backing device read path
based on whether the parent bio is NULL.  zram_bvec_write_partial()
passes its parent bio down, so for ZRAM_WB slots the read is
dispatched asynchronously and zram_read_page() returns 0 while the
bio is still in flight.  The caller then runs memcpy_from_bvec(),
zram_write_page() and __free_page() on the buffer, leaving the
async read to write into a freed page.

zram_bvec_read_partial() was switched to NULL in commit 4e3c87b9421d
("zram: fix synchronous reads") for the same reason; the
write_partial counterpart was missed.

Fixes: 4e3c87b9421d ("zram: fix synchronous reads")
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Signed-off-by: Cunlong Li <shenxiaogll@gmail.com>
---
 drivers/block/zram/zram_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index aebc710f0d6a..b23a8bbb687c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2333,7 +2333,7 @@ static int zram_bvec_write_partial(struct zram *zram, struct bio_vec *bvec,
 	if (!page)
 		return -ENOMEM;
 
-	ret = zram_read_page(zram, page, index, bio);
+	ret = zram_read_page(zram, page, index, NULL);
 	if (!ret) {
 		memcpy_from_bvec(page_address(page) + offset, bvec);
 		ret = zram_write_page(zram, page, index);

-- 
2.30.2


