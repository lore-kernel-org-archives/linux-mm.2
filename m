Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2603EC531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 02:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0886B009D; Thu, 23 Jul 2026 22:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC82C6B009F; Thu, 23 Jul 2026 22:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04C86B00A0; Thu, 23 Jul 2026 22:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6AD76B009D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:30:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC369120187
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:30:26 +0000 (UTC)
X-FDA: 85022091252.10.E18A63E
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0501040006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:30:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=E36dmo78;
	spf=pass (imf27.hostedemail.com: domain of gouhao@uniontech.com designates 54.92.39.34 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784860224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ZvTI/fcAWs1dkQ4W9g4AT4WdA/up4PGQNqGKnn0rhc=;
	b=eo7A5NiHATR19S4XOI5Gsq6gHa03ncXaPnGkEogm16WqlDXMY83w3lru2dU1UQYwtCEqeB
	XNe/RsirkjYfNzEhaB8d/uz8UJruGnnQRU8KYdG9dcCYGX8cNPYCE4AZspWAEZ/XS6dnQd
	zGG+qDFgnlyiGyBCY396uqlw2nLQ7LM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=E36dmo78;
	spf=pass (imf27.hostedemail.com: domain of gouhao@uniontech.com designates 54.92.39.34 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784860224;
	b=RpkTJ5vdvjjjMZnHExtPpyztMsFym9/YjnC3t1146zDA7KOg4GROvTM1rgFKw0BvK7EjX7
	kNDhTP7KeBRyTKd5S5dIjxK6A9gvnUCJtmt8HzHnSb/5pw49I4lGr3bDr5MJE1uR7heX5s
	9GYy7hZ6lt/UKhx0LVKU1yPngOrafyE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784860168;
	bh=+ZvTI/fcAWs1dkQ4W9g4AT4WdA/up4PGQNqGKnn0rhc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=E36dmo78kh/yyu/q/SFkWKgtLkmXa3lNLHr2zOdo+jTF5icGfxEpesU7j1j6LqF10
	 QQwvZdTVAlYgqiW3pimDLTXMBli0Soqng7q9p8S59eQcUdzXh9lkODYgaJpnoNS5zY
	 g2lv+WASdoWmV7/oPQi1SHKTdfaHsCYZQk5nlNqc=
X-QQ-mid: zesmtpip4t1784860156t81fb8ef9
X-QQ-Originating-IP: uU8Dw1tobLbkmKcfvIpWRxgng5wGRpu3yzVVioqlHrE=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 10:29:13 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1489989829865237816
EX-QQ-RecipientCnt: 26
From: Gou Hao <gouhao@uniontech.com>
To: maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	bharat@chelsio.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	gouhao@uniontech.com,
	namcao@linutronix.de,
	ynorov@nvidia.com,
	sshegde@linux.ibm.com,
	nilay@linux.ibm.com,
	clg@kaod.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-mm@kvack.org,
	gouhaojake@163.com,
	kernel@uniontech.com
Subject: [PATCH v2 4/6] drm: remove dead WARN_ON NULL check after GFP_NOFAIL allocation
Date: Fri, 24 Jul 2026 10:28:49 +0800
Message-Id: <20260724022851.466017-5-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260724022851.466017-1-gouhao@uniontech.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MhHYuF7Otq+omGliJcERnvbZVkOOOZVCoSpSN1uQyZfJdQLRoH1kKfid
	he32N3pqn1bYsxaOMS2WRssp5MkPP4cRJvzf0u3+R5vjLcwdD47CIpDol7E7rIDq9k54hcr
	T6ZUynVy6MW5a959l8FMvesSn56aoV772UNx863uO7qbzoh0rJV+FxUxpaCMfkTaIPaHkKw
	5mAc/wIjlwmjjPasEX7bdanS+S0FSnboG+EQTmPmPl1o4BbJJ/QDgIbMchN9Ujb9EZYztvz
	F1qV2hOI2YCIoLTithtaCemv8NcTGIs6HV7lAlO1xfZ/JyOtqJZyjW7phTmDFBPOqpI8TDc
	5WWJFXJUq4kxegeED3IfA/8rufn6Pk4ClmLdruqBEfIKDJHM6OsRNLkX9B7846zRcza07EO
	TsSmTMxBH2Uyd1KniJIsOm5R3AFi4J1Uwl/Z63iL9IONNBabuGt/y1rUbugjHUJ5q/8mzv3
	DVQhhCDG4ASP5xLieHhFqxorOuGf8emQSpDpguwPPRGZV/W+CAeHfguHMaoKQWJobMRMl/V
	yDAa26ktl6SFOJSAULhaISoMQr/dJVO9/frxOLhUOIa0Glhu/jvOMwg7BQFzoLJVt+a5Cum
	84J6Eu/I42j1wP1M1FcVCQXi1zlucBp/4t09Ye2O7c+q5chAI0TDvSqsWgdGiceQquUbmfQ
	z9+zrnRjd7sFBt7C2ni02HjvPhmti++WzkYof6aJBUVVE1eY6eCe/lRzhjrDZk5bUGUUYCC
	bKYlT0PfDeffQmmJ7KuxKpWyLCrF4HwFykzQBuI6tP/h+9QQMVTdqkuZwFZ3ax9wRb2Ixnj
	QYNkDuEzNsGNk3Hx5//HevDYkq9UtnCjuH74bnSziw9DN9qPcnAIkKNvRBVg91STe/71UWH
	FI8kgg3qrWPXnqJ0GtvjxP1qyOrCkLguLBMDkbnJQtLUvV7Hd7e6/VV4q1LQ3zrE88vXadu
	o0w4pIMkZqoQtpujBnLDObEEP15LGZ/YqlKrNBJiO+P/0br6BfBB3P0Mbay+5oWcUdZRzOI
	f34lArUM9+JqZI9f1Xcu3dFH9vbgJOnTY1obJsg2qGmFOGUH0t
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0501040006
X-Stat-Signature: spsrsz7u4edoukwoohk7oeqe5db5m7h3
X-HE-Tag: 1784860223-106311
X-HE-Meta: U2FsdGVkX1+vvPYqMjyVYni9HAFukZZDrCBMDanOlj39CRO7QO66ubcwFuIsTWl5Y14irZFWr53EBOZ9HTw1MaKaL7q6I+8zmI6mTfPbBoB9doq0PwVPx0sUa3HoAVPj0vwzxdS3A3686CNmrEaLB6rAjb7QfEe8EJmxRxOEJazo5hpaSbZmqL6PkLTieR2e7446AhIxlDsLwOBU3+uEJZBiwljKk+GZrUbQYDcdoH5IbhhyQzqY5LUypoBWMjPGHJNihTIjO3x8apfHxfMx9Pm30IClCchRLgGPsGtlhasu56RS7giDvMk568N3VShijNupkw/15nO7D0+yBHw9M1kJxZWPC8bAc4M9oC4yAyNFZ77oFVHxEUy87LZbs4tyd1b91GKSqTOX4DFlu5yzHDSJURWGvwxsh9oA+xqRn+sdl/4P/UR9ORzCM2fSxrZcJ3ri7Wv/PCBrKitKs+y5N7X+xjAFfiRECOXwnZnWey0rBw1sTjZYiH+IOFMKCBThqcqTM0itfDYA9SPesOr6ypV52Y4phRjRrTzuu67vmIFa1kL1wMoAh0zmKOZ9ZDkISaYvrT5hLkXqlmJG7VshK8kUzibygSQzE/ISmTjRvT6RGVEeVX+HO6z8DdidNzcaGxW/F96plvN+qFcL2CjTiezzXntyP4Hyr76evAwcaRHpu/Z0lsZT2uo54MN+x5GCrqFo5hvvNyE86icGx4OsV8PZdRa5zVP7cEtBT055Nus46WtC4q2hQZCeIHi1n7sCkULVOl2IwCmTD4Cspl+eZERMDpBqjYVrhyqexQYKrBs3iqQH4uo+lIvJsq6zlGTB939LV18+mKBQog+bylzUd3rZphCdNhngSBj6+RlTHEmteetEH8USBC9DaFtfp4MfzREwakU6hhT32xU28R5eVEv8i/gm57uRNEv7tBlQ2BEABT7e1cW2I4z92dxsIbR65a37+qMdQ4Ju8vMNl1q
 RVAVDU7o
 WmLqyS5M4TKKD9n+39ZjGYSe7ozbC2IWIeJoqKCqtHfpDTLfYyJDjiSvyGZ9t6tzslM06WhUBfDeyQ26DWthF66pnhFPNFn81hZt08Rd/BkR7m1gSKrBXuKzjdgCaM17W1RC23o4IIL8m+2WmVnCWm/x2KXfDvAYIajTbWLTdrinDQtbeEV+Q6dbOVQpzEVs6ALsDcfnxUAd5N4Vvbt0cR0416ESFE8gjptXMp0CrztC1JdZgEqtwPd5Dxp0W+azyAEskWBaScRFEdpqQ6ZiLiRsNqMv9f1eedjBvJGnpuXAQM10wpb/cDhkWFqcYISahL472/bWyD3x/65Fa+tNVnHqUgD4f7yPNQhhj097OFOSxYwxQVH+ugcO+s0fpMB4gFsU2HgWpliupWfq8sEy/iCJLIZzYDoe62IY4wdXXkQOLs5HXvVOAC6MNpSUiGla3lmdFBS+VUgvyRBK5T4PPK4AKXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kzalloc_obj with the __GFP_NOFAIL flag will never return NULL, so the
subsequent WARN_ON(!ctx) is unreachable dead code. Remove it.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 drivers/gpu/drm/drm_modeset_lock.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_modeset_lock.c b/drivers/gpu/drm/drm_modeset_lock.c
index 2c806b0146d67..e14814c30d8c0 100644
--- a/drivers/gpu/drm/drm_modeset_lock.c
+++ b/drivers/gpu/drm/drm_modeset_lock.c
@@ -149,11 +149,7 @@ void drm_modeset_lock_all(struct drm_device *dev)
 	int ret;
 
 	ctx = kzalloc_obj(*ctx, GFP_KERNEL | __GFP_NOFAIL);
-	if (WARN_ON(!ctx))
-		return;
-
 	mutex_lock(&config->mutex);
-
 	drm_modeset_acquire_init(ctx, 0);
 
 retry:
-- 
2.20.1


