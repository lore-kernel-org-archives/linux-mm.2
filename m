Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F4CCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 18:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C70778E0021; Mon, 18 Aug 2025 14:38:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48B18E000A; Mon, 18 Aug 2025 14:38:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85E28E0021; Mon, 18 Aug 2025 14:38:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A7FB18E000A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:38:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23943C090D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:38:15 +0000 (UTC)
X-FDA: 83790738150.12.0B9502D
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 65D342000B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:38:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E1RcWwsS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755542293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KxwqBJkCYrqlcIrilSVqc8pbG8LIOmyCmMOU0LIr8Ms=;
	b=ZvkJavOl5JvnZHzTj+EX+qo4jeYy8vr30GKCuKhfio14cixaGaifkBbs01SlLWpVZxds8D
	Yvcj4oCw0kXXLBrD4286ZgL8gXrL1LyRFuHtIXubCkUe2ajLCJCqf0QgEI6S26+n0Gj2Y1
	+6LChT1j/+BPku1KiMGiGyIiQBE0cso=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E1RcWwsS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755542293; a=rsa-sha256;
	cv=none;
	b=p79vLBsR1S9r2m+nHoxSeKHjsrYysyVUmybr/1EIVq4vt+eYF16LruO03VlWW/vk/OAGpi
	MYuTBenLJOHfA7zXv8w6et4N9KGRrINw15znsZcpx3HwBnLI43Fb+FyWT+ro4Z5Lz2PuKK
	/+iHn4TfS9IvhGsoEdYh13LtBpWnR5Q=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-76e2eb9ae80so3434815b3a.3
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755542292; x=1756147092; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KxwqBJkCYrqlcIrilSVqc8pbG8LIOmyCmMOU0LIr8Ms=;
        b=E1RcWwsS+VUdxAFBB7a2JPAvD1qNpaDYnLyZMvVzUtYoV1u/yXB4rftHBeQSAZyDkX
         nGv1Mp6v/akSEi5DGGVJABoOuMe1YQqBO/d42uV+Di8mQnQ/nhwpHFMuVDZH0ht/1wJH
         NEWIF8U4DoZImLTGm3Tqo6H2bgVvRgN6MaHRhrqGmx9o0SPUKQ4/fq7wfnjf8kC60TMf
         +OZXK0hVNvoFGMiGLP12XgdbQBYNdlRod1sM+rZZ5+5rzi/SNr1ieMBW3BBaqa1cpFKD
         W83rWdWpFK/1f3/WG/6seHboudy63QXQHhl6+aAQ8NvDtpvkz5y1zSFGBiOS2/5oqttt
         vfIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755542292; x=1756147092;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KxwqBJkCYrqlcIrilSVqc8pbG8LIOmyCmMOU0LIr8Ms=;
        b=HrHe1/7gsstI+/E5CYOUzOH9VDZOOvqT43KDWAggTp0btAsfX4KHuCdTmRGm9KRewp
         uBBRHYkabyCeH4Bl79nC3/pzBDSCPHPud3EKFE2vqKGc60nmvFtirjqsU+T89Qkh8kpR
         aR3QsB7WZig4SHqU4LVsBEBeLckjqQyLcLIWMO9DRCavJUWBeJoKJ/9orXDzOsdsw0OD
         eeGZmaKB/PS/1O5ddZ4eQ9OHNoPCkOSPhqzLpcjAdq1ln8rz5BUuTNPj0OhEqvE4TiaG
         e/oqlQwttVVpqaI+aJe29Wex+lgTP5SOLXpyZ2o/OYwvFBywmsN1Z4BCb0LKZpRRamsP
         7Hlg==
X-Forwarded-Encrypted: i=1; AJvYcCXy9Y3NUP5kgWwhTwh93pVLJsQCpLCurQYttBg37BxM7crvgFMnjRPx6CDOWl2A7/oBGkvGYw4YYQ==@kvack.org
X-Gm-Message-State: AOJu0YxSlEoLo/1a8Fba26wmGPw9FkZt7bz7/DvJmK1s34AZvtDg59ek
	QDo2VB3sZMXxeQOgmNJa5uWKSw6yLqAFfLvfiDD2ekngg5aCKji3hWxX
X-Gm-Gg: ASbGncvjhXPPKhKQxxRFkwuVDLO4+rVLYtasCZSkkqKBuTeZ+ZJJXdcr3YpUGwB0gmM
	D5KkTVPbHpWKBXRILcmWZGcQQLJKIAwZwim399orA00Nngp6kI3wtmqMWu04PnuG1FLOkn0af7L
	g8rtGPlrl3IbrCKC7gJPvbDQBQCPAQihqzfOOcNi4SKAeHMMFy42Pxs8OkoNnghXKYKOH2lxChT
	gZG662L94fTe1edehRBrccAKSQzgUrpx8j5NJouIIo445QfJHAwUpInjjhdzu6ABWOtuXnlZmpd
	MWNUkVjfci9OXA6BIjCOolay/CA1Z4stRNdHNrZq/Fp6EQDMzhkuwKBl2xjF9Zqik/hiR2nSRx+
	bIUgEBJ21cFETA1DK
X-Google-Smtp-Source: AGHT+IF21jrPOmeVtvFP4xBgTBNfDa+e87BFfHyEAdLZp40Ly+ufee667RTgqihPyTvRbODt7k8r2A==
X-Received: by 2002:a05:6a00:2288:b0:76b:ef8f:c292 with SMTP id d2e1a72fcca58-76e7ee01fe8mr369879b3a.16.1755542291913;
        Mon, 18 Aug 2025 11:38:11 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d4f76b5sm269201b3a.59.2025.08.18.11.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 11:38:11 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH] mm/damon/core: set initial quota->charged_from to INITIAL_JIFFIES
Date: Tue, 19 Aug 2025 03:38:03 +0900
Message-ID: <20250818183803.1450539-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 65D342000B
X-Stat-Signature: fi4pza13f7cc1c149nw9hursamusicni
X-Rspam-User: 
X-HE-Tag: 1755542293-78534
X-HE-Meta: U2FsdGVkX19YoINXaFO+ZPjZeUUow2BgoJv4S8JOxN0J42GZSPCbVRyXU3uudDkVpRYBGlRAOPmuzO52igOSDHI2WCDui1VNRdZSBnKjSsPejplznT1TQ4600mrR2A+CNo7OeWuIOenT3jQuSVGnu/tqt/w6/Zx8x2hndmVkEPoH6geTTkg/j7B1HI/a6+1PyPmit3DHoNtJVUjycTo4TIFMGFVwgDyKMTVSXki9/cQLbetnuZKw3HWbIYobyb11G5xYKz1pdmn2mS1+jooYDYhBTEQpTTFvre7+KYSRkNJ1c3M3OPIF3PErGOsqvGIWkVt49SKA+N4Kv2LjJ/xaGzgCJY3FGCtuJoMR2Pa1Ace+ovbiXOX1DY/XLoMSIzVhSU342rxm052WDrr9kZO719z4hwK+fU7la7W+T+AT7OAcbhxiA1IeYFsMN/I1CCOtgRtY9diEtijUFQryrQAsNhYOz7ZqBF5VH2tKxlkYd78EYgySKcYvjChePs3mLx/J6OwWMMPMTqCLr26rgOHN4UAa69tKAyW10R4Ri2VuJS9+EOh+DXSKsWrIPIpjw1SNw//+C3Q3KB0lT05OA5gv4US1Mk3AYUZr7Y5bcPCMlUKDlCXkQD2mpTq25AaYzTPOikplduqlXgiLY0UYPnlivamHTBW/6oLQnPUxZ9BZq1Hdxo+Bg2rzbedBucZzYcCYfuLyqiWup8Qwim9v5DSNtntOUidV7WWp3T9rdX5Dg56oEXwfn6PO8QUlM1YAwf2QRWa7VIHiQY/xr+bpmPY6D9TVQdajVQUVPLJtye+4W0M4dAZFznn7XabvkisYutnAYxgfK6XB/uY+NXY+DOKT/sOYP6rX3uFH6jgyaVlz7U/9Per0+xaloRQR6G0FtoCAA3eCxT4fX4YQxV/xFU3maSwDfG6G5bjzmkLJ6Ds2yOIz3dNoX1FZYH2JvAQuNAnqglPlmyLyiKJZO1bMQy2
 OEjqIk57
 c+EheBIp8XcYFRATtt/Bsh4CwaptFDhvKd1dnF/+h5TkcLzH2uWP+39h0ekxU2IZqmgSnOboppxhDW+ALfgu+XAtlVcxHlUQLoEyUWZd0/D9FoOCFbH1rIBGEDH1nRKzRu+/llX4/tWGHZRhJOU0AXKzqYeGzPD/H330OWZrmmxTZh+7lcjMWDfFWGmbCNUIIMzMBeieumHVqkvVFPFoiGG5Q17KP0+E/aTEXOQIg5Rx2ynQr5rIDrwyVR6SNxn6HKH8WiiSDH2GRgka42RfHRn0bT6QI7Zuh2I99nXD85nonwPDgKGaBJj7vz1cPoIkgGRxdE7qkKES8VWYhgAGiUVekbPsWlsV6Ez5eCo518IL4AaPZk71VObFdz9JCWzcOIpIYJQkMgfg7Hg9qbhFiuoEPeGUApp1hZyeO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
include/linux/jiffies.h

 /*
  * Have the 32 bit jiffies value wrap 5 minutes after boot
  * so jiffies wrap bugs show up earlier.
  */
  #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))

In 32bit system, if quota->charged_from is initialized to 0 as it now,
it will not adjust event if reset_interval_ms passes for the first 5
minutes.

So change initialize value of quota->charged_from to INITIAL_JIFFIES.
This soultion has already been applied in commit 7d70e15480c0 ("writeback:
add missing INITIAL_JIFFIES init in global_update_bandwidth()") or else.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
I think it would be good to add selftest of below senario. 

1. Set DAMON with quota.
2. Wait and check esz is updated well.
3. If esz is not updated after quite long time, set test to fail.

but I'm not sure that selftest can support environment handling; jiffies
with INITIAL_JIFFIES or near there.

If there is another method that i don't know. Could you please let me
know? Or any better idea?

---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index cb41fddca78c..90317a3bcf78 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -366,7 +366,7 @@ static struct damos_quota *damos_quota_init(struct damos_quota *quota)
 	quota->total_charged_sz = 0;
 	quota->total_charged_ns = 0;
 	quota->charged_sz = 0;
-	quota->charged_from = 0;
+	quota->charged_from = INITIAL_JIFFIES;
 	quota->charge_target_from = NULL;
 	quota->charge_addr_from = 0;
 	quota->esz_bp = 0;
-- 
2.43.0


