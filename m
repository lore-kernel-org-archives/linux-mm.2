Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62BBBCD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 19:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FB0A6B00E3; Mon, 11 May 2026 15:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AC446B00E4; Mon, 11 May 2026 15:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89AA96B00E6; Mon, 11 May 2026 15:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7413D6B00E3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:12:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17152140248
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:12:41 +0000 (UTC)
X-FDA: 84756085722.09.02A3F60
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id 54508180008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:12:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sBmNXB8m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778526759; a=rsa-sha256;
	cv=none;
	b=ssnwWuAPooOmmde7O8932G6VmVR1wwvtFrG1wzA40ODHnRxhvIKBvDCqLpZFxF/KKs0ebl
	yKqKQLXtyFMqCTItO55us3mIeNXHwqsPdqaXlbspVIPX+W5gZO62VIomE9Od9pFLkmRMew
	h/0rnUAscbY6D/xksMadmpMbOcwmfG0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sBmNXB8m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778526759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xArGq1W9dDFcfzmBReyO33DGfNzj4pxhNHfsKRuBCvQ=;
	b=rK0lAx98zKl/Cn+gBqfjEYZgeA0MjJjg9fg4blh0lty7qbiXSfqvsm9YeBxlZhdLBpilM5
	c8ANdnWi5aAuJAZcMaah1ucWRFs4vcXllXQwMhjvJoL4czWRZhAl74wkJytazErbN9/ZZ3
	ZkVSLjoeLoOfa27ilVbHZ2DHj/EKF3k=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-36643b96b99so2939673a91.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 12:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778526758; x=1779131558; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xArGq1W9dDFcfzmBReyO33DGfNzj4pxhNHfsKRuBCvQ=;
        b=sBmNXB8m+g37cS7rxOLjFD1tZsOyBAhJ6xRbx+/xFu60EckJn5ySy9SoHdJ6nD5Vla
         wL/Hv+sA1fKIUi+TnKfDwn215cQNkd84aL3KxxgTQqoK6w7OfTbv+MAp1cjXSseExbeC
         4dsi91A1AU1sB4U5pJv8iUHYc2P+mTwPpc3Bv142naXoVq0i4GzIOeHtr8NbvAQOMx/u
         qMogrP8grb8SmpqKkQrUieWHJd/R7oqI1/opaVJ+/oetFyYokzIFSBqPCzxSabqOzujm
         fb9wr5bacS9aIhhsz2mbdXofQA17dxtHOsO2WqAYqXrsJ/rkWQOSHGAnKAiMCLT7TfhO
         EZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778526758; x=1779131558;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xArGq1W9dDFcfzmBReyO33DGfNzj4pxhNHfsKRuBCvQ=;
        b=jYquGr9279Lc/YW8ghCOfaiCDFFCTzIaFO4An46WettMnXnd8l88XYE5JNBH3/L/Sv
         7uAMzoiwIw86F4SCxGPCpY4K/3uHCTHw4bOWWep6laAZ5K4jyi2riPuRKuELsIGgAgHp
         mDW/r+vFYvlMILvEyGhLmkO0ewu0O9sXOcN/axgtC1qfo6fhh49W9R5GJA3Onl0gUdZr
         dlEwnNZu0AY15rFKJXAVK4zWq9KpoDQ9xM7NKqnAQqoqYUywnf7k19eKnOpqcNbZC1Bv
         4/DJFfWpF+OYnHgLH4INYfkH7wPPWxtbzyOijihQ/0x3KeuTMWsIZ/v3JhHplIru0KPl
         xEvA==
X-Forwarded-Encrypted: i=1; AFNElJ//IUuwBsO40fmIJwWjv71OKqKz+Mzb58R5mDXjFXC8EYY57cUg3Aa61o4fBx8OlUrXWQKexohnmw==@kvack.org
X-Gm-Message-State: AOJu0Yx8Ir6KYqfF1M0pPkju1Gipx6TWetlxEanGudYUH6gd+vU3IJxF
	B8Ehf0m9j2gCAbl/4MW09kAadbjNDWl75UW2i9W5SoMscgRiWCYn07+uhFBsT7Yf
X-Gm-Gg: Acq92OE7ywamB9YS2yqs6BsRjbbgucCDRFxH9EQnGW9sALF3+8nkyw62CLS2R/vZXs8
	z8X9khsNlAZ8JaI5gLhcoWy8E8ObOY7cTZ2J8LuaJBT//jB6ymsEXNWUGEvqPwwV2Ns8xWnJ84H
	6Wwh3vKJC9zN0/SYaqM0CoCaGCC4CBZzhGnigNwffC2kwmqCRfo4ldvceg9GHdG2n/JaWGbL4Q5
	GQ82BhkB9SIVjus3l0H41vNiyB+ILuHpahsF620U6Tp/phjnR5NuSicScy+DuuRJhXsgLWAGHwF
	SxRGHsyOwL4WG0QrFGOhcx6H2I/jLfNl/MForovny7/+7Da21duW1c9CXcxTfVcbUUXNdgJRN8X
	9IStrS5N5z24vupaboHph+LKAV/wM2mPujsMevWUKj3/Bcn90PhhaqvC7ysSRsVpwKyjJooc+EY
	D7g2PB5UF4H+iHkmd/mzGybbgVpXKOUA==
X-Received: by 2002:a17:90b:2248:b0:35f:b348:63e with SMTP id 98e67ed59e1d1-365abbe373cmr27047114a91.9.1778526758140;
        Mon, 11 May 2026 12:12:38 -0700 (PDT)
Received: from vini ([2401:4900:8fc8:73c6:dda6:576b:fa0d:f68e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367d629f3b5sm8686184a91.8.2026.05.11.12.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 12:12:37 -0700 (PDT)
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: [RFC PATCH] mm/damon/sysfs-schemes: fix double increment of nr_regions
Date: Tue, 12 May 2026 00:42:15 +0530
Message-ID: <20260511191218.98881-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rk3zqrbq6myxxzcq4t3766efr6mwaywd
X-Rspam-User: 
X-Rspamd-Queue-Id: 54508180008
X-Rspamd-Server: rspam07
X-HE-Tag: 1778526759-530300
X-HE-Meta: U2FsdGVkX19TRgGZIfwNUKgdmJb07bcBdeOPvX9KdlP4TY+U6rgYWiUdNFWLZZKw3qw9Aq7s959WR/vBC9hkZ9avHNasI6lOdESMneJd+6YCEYkDBwsRllSG0jzcBE1/qllJDBGi26a++reCjgHyqxm5WcPtuDKipZKTHuEDDmcQ7Ue2IYbwXx2LUo6MLiambVxcgynG2pYRJW4s5SvGPQw5JIwZP3vl3V88h1iqjm0KQbev7WAa4s0L8dravtZEqsBLjFyQUc06xnHPQj8JJ3xDqEDKi4cFDc3TKUYCSkzQ847Ad9r4MiUCu8yZZ35d1wU+u4+qWsSIwSuGciw9wk3sfr8m/nIZHmDL66zAFcdsgipgnSI9KcmOudYr8mn6MYtodWipf05w/lTRpLA6NpD6U/fvtQjZKGaePBynK2AevamCo/sc/MMQAWXJ2DQa3y7utKnJmSk75DLn1EL3Idr/PhgRo2qcJ48Yzh//fNC1fZ9tVmSdCCgvBVky91fUOJDHTuLpMnfQtC1jA6LP32ptcfKR9QFzufaxmjr239gv325ulbRuilYUfEheXwN6Oyv/vwoCrrfaG/IaCzLG0t4gsXSQLzcoYS/C+knU0oq6cS9SbQMaanhYPB2DItpyg227VX2X4WLnr9qzcgT0UMMUgGvLTQFB4RiSOZ5YmOTAj0pZToHyvKX/lk3cHr97t91cbUANw2YGKeo0Qf5S4Ne9K8TfXJI3v78VnOznIklmt3qvfu1jt8VdIzmQ9JXxGJIUjHi+NvgmbvNc7QMsuo69S5bSmmK7s5jWZJ/1yH2adtZGGCWyxTlNdnLBUtzjKx++FKwDe+LWjhF07ZBUlSOdAZw4Kn9iOsc4spM6+v6ajCQ0yJz3WuxqOm+/y+I9dHETefb8wB3QOXGfEfzDIDmt8Nl3hlc3aQfZ9cAwYgZVXT+h/OZC8+1+k+fdUzzx6r0iDMxMwwGbfBlhswg
 LtRnmRWz
 AfzYf/D7iMATlfU4Elk5diZtdkn4UoatBLamT6WD6IbkjwCX6LqPJaRd+Mye5dTCgKvqnMIG/4DkEamfMOPVDtRMg+nVhZjLlqkoIpn8VUPU9q8I0I2yl0gTufEi3Kt+oMrIN4cYd/6A6bkuIHEI6l5FGrIMRiQmXVcJE7gc+xZioquoCAyEZTGoZ89x/BHlxu7LFVj2PUweR0M96LxrDZ6zqoQnTeNpjqZcakA74JEOEUwmz0y+ygFmb2dTA+AcX57bXPAhWus21HfrB1TZKUrCtn6j5C7mvBiRoomchPNGVGLnY+yIxGjRX5ZmK4tIaBmhjBct4d661RtqShj8CBVGYGTNYHiysro1CGKuV+SMSC3AVetLzJofp4Ezt7n1rU2uIjY8SDfcjv7XbOlCCW3tiNNvuhP8/XneE2a8dwmf6mwcIzGkIvOUFOKphkQ5sRIOty1strc3um7Y8ZZ+CfNPm1SVITg6MW9Qmh+m3RLop9JPSTqKwP4rO0YUvJV+tdE+5r+552V3Ej/P2v1leDuFG3zng7KOcQbNg12zEPEuAdWyfDGw5ae/nkd5sGlCJiApj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_sysfs_populate_region_dir() increments
sysfs_regions->nr_regions twice when adding a new region:
once explicitly before kobject_init_and_add(), and once
again through the post-increment used for the kobject name.

As a result, nr_regions no longer matches the actual
number of live regions, and region directory names skip
numbers (1, 3, 5, ...).

Use the already incremented value for naming instead of
incrementing nr_regions a second time.

Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
---
 mm/damon/sysfs-schemes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 622c3799db87..5d966ac86419 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2998,7 +2998,7 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 	if (kobject_init_and_add(&region->kobj,
 				&damon_sysfs_scheme_region_ktype,
 				&sysfs_regions->kobj, "%d",
-				sysfs_regions->nr_regions++)) {
+				sysfs_regions->nr_regions)) {
 		kobject_put(&region->kobj);
 	}
 }
-- 
2.54.0


