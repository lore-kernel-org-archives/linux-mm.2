Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6490FC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53286B008C; Tue, 28 Jul 2026 23:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2ADE6B0092; Tue, 28 Jul 2026 23:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF39C6B0093; Tue, 28 Jul 2026 23:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9372A6B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:58:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 176C1805BC
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:58:31 +0000 (UTC)
X-FDA: 85040457222.26.EE60E79
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4FE78180002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:58:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=DUDoz4vt;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785297509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SzTw2BiFO30knaj/h/2GtXRcts3dKJPQCFGFVCfyqgE=;
	b=xK4uqEcVEdEt+1+Pnhr3sm4cC3s97E9ZdMK38QLjWksUxZcnHlR89TAzlN15Nk8W0yMPe4
	ql9h1If9cAfG6JqCcBWr3CRCHLuQUaJd6uUREjRxeJvrzp7AJpmu4++RCiod0SzWQEk7EZ
	ARJ02dgLMN9zyeQCY260CNbMh1xpuPM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=DUDoz4vt;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785297509;
	b=jyZdBw7g3S1g4of+NoZjYuiCmms913yGGdZay/RH8oywQEa2yiwAVW/udbD+VAdgn7bF5I
	lQeOo6NDSkw21Vq6cOknJaQzKBFBkrNloIQCiUGw9wq9Nj0u8ZYTzQBonGCXz7R/Ap4q9v
	XKIQoU+4W8CtD1WbEoZbi7f8kM/ISQE=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38f0f132f56so1186332a91.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785297508; x=1785902308; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SzTw2BiFO30knaj/h/2GtXRcts3dKJPQCFGFVCfyqgE=;
        b=DUDoz4vt6a/BSC+4G/EzlGkVkHBC/KpeMrupC5dB/5q+XjmMK69uQk5JWWkcAH8KQR
         vT3XMTGF35oLG6Kl6Yi+H0Ydog6IrPvZ85uoxeTH3RR4d5Kw/xHVonpoRG633qybRID2
         VMX7XikyRJd1Wb3ZN8h/O8WqHuanwet1OnUTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785297508; x=1785902308;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SzTw2BiFO30knaj/h/2GtXRcts3dKJPQCFGFVCfyqgE=;
        b=CNsurXMg7a0EFPmpE/6JPSqaBIgg0gvWVEA0wqW3SjhEwrlVDfyAcLvvNiZgPKMNOt
         +JBOBIHi17Zo63Q6QouMw3Hupl3J1AjzVXg6QYyXI6U8JHaZO7JW6YkAywCRe9slKDrr
         rPr7XVquDNTi95jiyUhQJaKraY7SdXbWzzWIorrvyp9LBz9HaDwwkCmPEFuIK0WbIhyl
         9gNYxPh8Ttp5l0bzSUH9qmuwQUDNmpnFmJY7j0LpOQxnhCXq1JoYpd8z8wsHo/gG/Y8W
         81sTeptYmFPBhCnTM3GU/biK4kTNyfSMOI6P1Z/bc3CrLp5Vg7S2ikhLEHS3jRxRogia
         IqQQ==
X-Forwarded-Encrypted: i=1; AHgh+RrorNyI0gW1LwHwsqu9D0l1rNd7bC5OdYzyo74sl0AGb9INLUThS9Fff2VZqDoTIELePZCyKSv80A==@kvack.org
X-Gm-Message-State: AOJu0Yy1CZZnaszZcfiZI0FXtnGbS3PWoOn0tmITb/+X8/ASqArflZ01
	FBT3W1CTl8xlBfRRjQ/lYHIycTas729Yolx5LLhiaqWiMmYJUQWmtA2I1op2O+40jw==
X-Gm-Gg: AR+sD13prjUqA9w6EY/1RyBFgV6dmjGw5qYKXfzK/+bJgN5SWPSXvVTUXI1Lr87zyWP
	3GQ+Jn6mSS0/oDQhKerM+hvCTksUIJXgSioNRigPrLZk7dfRCs/3p1sWDc5U6PD052DANHpluSu
	Ebr3is0cBgEPmadUbLaCsbqlKJe5K/u4orR+sTRF3C+1T0dnlgX+3BefAnfY/pGMhDyb8/0j7mx
	X8/1UerwhJVyXGBu4+wCMrptYvXzBOI8w54/fYyehsmpfanlc5Zz3I7vaxUoP7vbqrqjzGox/99
	LqctMZ73H3KqISa8mZ5O8R0CaPdolFTdw1jtiTZaCCtTG2vmp61BAcL/tCDOBYFEsgm38vgIJ9K
	dhi9S7t42TXLj5IzgCKdu8HI55jAOX7so9f8IiUrELLrelRKqauZQGoGIGuA6YRnAhPYKs3lPi3
	SsykapebsBb/NQS10eaVxyPj7Y7dA7zk9Pze22qGMK/8ujlILOG1H1Gn0+JzuhDmWfxTcE2MRIY
	Iv482+N2NtQNcULArRk8rtH0LDocfwmf1+RyLlrDIUqAoe4UbJm5YhA/oH5mg==
X-Received: by 2002:a17:90b:17cd:b0:38e:7297:a92e with SMTP id 98e67ed59e1d1-38f8365c478mr512651a91.9.1785297508095;
        Tue, 28 Jul 2026 20:58:28 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:65c1:52a3:f6d3:37dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f7eef9c5asm722087a91.0.2026.07.28.20.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 20:58:27 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Haoqin Huang <haoqinhuang7@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 0/2] zram: fix zram issues reported by sashiko
Date: Wed, 29 Jul 2026 12:50:31 +0900
Message-ID: <20260729035820.751990-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4FE78180002
X-Stat-Signature: u9hmyweuwmx75rwn3dtnyqg7zhq5zz8o
X-HE-Tag: 1785297509-424864
X-HE-Meta: U2FsdGVkX1/du5aVWpZgAbaeu/jXRjdcRVSfwdXs2AmNBwgrJU5cF+BWIgSn4gE2Mad/YanQ3KIs22k/xF6fLnnzE8NNvtzsbyjzcPKy66AKuPP1BjpeO0WTlFN429vJB5EFoe/qsXPT1g+9kuZikVqxrKB5V5fGOWMUoe/zsatJLkrWHbcZAuaPRDUr04hBklFjI1smO8icycm4dhhfHdGWKV47pl8AhgbkI5eHDto38JKYRhr2s3QUpNjXbUg/1LyLNAQ4Ge1HT0FSKaflOc6ZxVAc6QI+eDXM+h1idsYw35qqBuzQTJoDU9MesP/EVVA+pV15ij+YX8kZ4ozNBgA188jIJLdLw1dFixJ25QuSBJL0jY0OvduyfucI2I65v5StA/yUiUY7rVIvQg4uR0BGnWyNXOBU/utSc9towodZCkTlUnJTI1afcWekYq7q6g3Zk+pOVPd5b3v81KfwOo6HYkYxOaxcsvhiWFJanOTCfWw0MlB/PQOFdAEM0jqNwHFlBn+HsS+FWspedFlFnKS5I3+qtbez66+CbQIZ/xeaCzjqHry0U7/qfCQyzuhXW6cHSAPGVMltSI8lMSa6YIJOmubnYGZMz8D7iLnQKhfKT8qib+nuYGC/wHJVSznCJzEJ/7N9/IAmKd/8pIHfIeaye6gzht1fFCCKCtis1DzOIc+wIZfhNvw1I4/ZDnmQmRCLq1lSIhOygDZVkAQh7BsX9wghZLoEmhBtfnqjuT7tDYrgkzArCVZLZ6qivIYdOYZQSUj6nHdpPNIiv4rYirX74hZcTgeCkwIajEZb95sk2CyWM0JEZchcA8cFLeJuLq+QVXSxZ7g2CYkZmfnH2XoqLKm1CPCtrVoA3QQUgg5ZJ7l8S7NJf0RuafNWODseWC9J7fK4YLVRZmU/MqHIVgR4va4WNCFz0uhNvxE55hcG4rfNwoxz7t+hm9niBZcIhcfodVcDYzc/bc7ZVi4
 14DoAK9o
 QpJlDqbnD5nvFzQAWQkrhg7W1glrvclaJ3GrsGD3MDu35Xf1UdYeMEieVbNBaUFrvGqcvEGS/tITQ8ZTN7ujy9j+TRycLEdcT6Iu5hVPzdwvCCdKygg5+zROC1ypGbTgqEXFEuJT9KTgTfMtJutHVmxaAT/WiEtl5gGPRExoYbck8pglhzyX2FdYIwBajsoMIBlcvXD96NDu9kfA2Fo59VXIUAE0ezGgfYSY5bRKHXIUZhtZ2WF7M0oRF6jM7A5k20qeSAk/Cd5ykXE7RTfbGjVGj2zVDyy6zKVctPAQfUA9Ko6qJIsPB3LZGYws/tcuylu+DjXx24w6Byh9zBdkit1uX2k0GgDbRCdW2o7PwTVCj9OkoPOZxFBCGb7tTao2nXYuvqMxTGpzUPT3QGy+NeGKXUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko drove by and reported [1] a couple of zram issues:
a possible BUG_ON() in zlib code due to missing winbits range
validation and one possible NULL-ptr dereference in zcomp.
Both are low risk yet still worth fixing.

[1] https://sashiko.dev/#/patchset/20260728092935.31139-1-haoqinhuang7@gmail.com

Sergey Senozhatsky (2):
  zram: set default primary compressor in zram_destroy_comps()
  zram: validate deflate params

 drivers/block/zram/backend_deflate.c | 8 +++++++-
 drivers/block/zram/zram_drv.c        | 3 +--
 2 files changed, 8 insertions(+), 3 deletions(-)

-- 
2.55.0.508.g3f0d502094-goog


