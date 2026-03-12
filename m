Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0AFF106ACCF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 17:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E805E6B0005; Thu, 12 Mar 2026 13:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E596B008A; Thu, 12 Mar 2026 13:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30F96B008C; Thu, 12 Mar 2026 13:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C390B6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:01:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D95516035E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:01:40 +0000 (UTC)
X-FDA: 84538027560.03.95E62F7
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6D03920019
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:01:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BigN85k0;
	spf=pass (imf03.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773334898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1FPLZLK/ARK3Chp/HwAUNJLe5P0+HW9eu31GldakyAM=;
	b=7mNV9w53bKrVKPSdaZGZEt5LM3NEy2Oqt3YfRk0BYJz3ufvqBOMW4DGOSlFTesr3L4Mli/
	LMMqGy/bGtzxVvcdgRTKy5McAY1X2DGsE+/y1IYZnkQF1qMTKMtqqr65Iule5IjFiw+H6y
	mp/bh8xssQoVejUTe8vJdCVWqT7c7xA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BigN85k0;
	spf=pass (imf03.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773334898; a=rsa-sha256;
	cv=none;
	b=aar/V7VuZ145jOaVJlJX/xWwt+wo5JMM87UivGChkPejaOuTd3PLV2corRVmsN2JU+jzfi
	WqabQeEDSUYlAhoo8TqRcxVR9OSafN2hUnWch9pgrj8iuCVs09hWolfc6tb2R3cB0Sj+3F
	Lv+wkTREBlI6IRAHcoLXFSyeJml2PQE=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5a13a06fc85so1574375e87.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773334896; x=1773939696; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1FPLZLK/ARK3Chp/HwAUNJLe5P0+HW9eu31GldakyAM=;
        b=BigN85k0qEWRorxEMAlw6tqhFUR1Jwalxq1VzvDc82M86yRJCdX2l3gGkMQK2wodgQ
         jKDNxusH65UgoONVplYKR8Rm+TGc/cHNErVArJbjbuEdnQgiAgyp0ILIlCxkHac/cZ1w
         7dkqzjrjjlrHSzN3WHKSfrIT4ETKa6zkYp+QHWiyXs6bRuIynWT5AWSggAphFrv/Rc9o
         umROc3+qWC3izld1CkBlXm5xLaj/a2rF38fwcG4LSdL1xH51+mShiI0Do2b5Rw/02Cx3
         guwd+GmqnVWgbHseGyxGDwpIvdkaSsgR/kf97trR6ZRKj5YWlUD06ydyE5aI8tE9a17C
         IZYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773334896; x=1773939696;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1FPLZLK/ARK3Chp/HwAUNJLe5P0+HW9eu31GldakyAM=;
        b=JQuxGrh+E+3a1yqB5rOlK8jfN4QnJ9wvWX8mvT2Ogt3f8irLt3VvWaP6wORsR87LLp
         yxm8aGtfHPztLlxFJ/xSoaDOYoe/fIpYDANyiGU5jYq8Kn414mwezmB5VN1Dekpvtwx1
         q+HIod18FNOFTTe5kZar7upD0plGHZeGWGOyw4tOGSW8ZxOrt4mmRp4a//UrgioZwT/x
         NX7rvHVyjRgbPUZTFNmqa00QqnitIrJ59sYG1mC62Dg0OtQmPHIZ7HYMpbubTRtMeDnz
         UsdHkZ1in5UL9KYl4YQJuQiiwWg7kPbIqAMVj2PP9LLzLXvTAqbDr7bOc3wx342QU5o+
         1zUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTJKWFRu13tktKuWJ/trIt2Ur8DJK/amrsJbG+cSG9t6Pxe8Du/W0K03Zk3TRbzS/Pty8d/u6n4w==@kvack.org
X-Gm-Message-State: AOJu0Yyjqao3jR4FCT8fvm9vELp362qtSXgwMz/5M110Apsfl25IVYM8
	VVSeoBMDLX9mNaKhu39fWwR8Jpb++qJ0Fp/Yb9kvMmfhpx6az9m6L3WK
X-Gm-Gg: ATEYQzx1CjWm71qsyIF/3eWoRr6FxkzbS3NGpqhQ6emGFvYrmk/xP0SCKhpjtN+eAvS
	pzaPLHTXQR1C3vwlz5kQ/bO6iLe7dTDKPyJnzKnAa/xkuLJmW04lhqIRXmlzQYhONA3k8RWUUV0
	WopLCiTKUo/8/Xd9YZPdMD3yxOKUX1/R56pUYuCz7fwi01pRN6yow8DsZ0Y7napZNPbVkWbJ3fn
	pnLpgY9/gkVvzMP0Mpz1i6egO9YxKll2NqBqrPqzxBR5/a6Nb2F9XmbCV6apG2YUcfvkDZTgyQg
	cgch/CZpyLlCMQ3rs+TpncsS8czgQp3k7tYnlKPkIgD3TD3vwpa/PtdvqyhkrvFcz7qFUbhmjvZ
	WPU0T2pILi9W20bAeSrLTuvkNd8F7q9/NChOOJnePz/mgvq6B+O3n3NN/kM9j34NFF60ZWDCv3r
	uB/Y/hUKME9bAmGVNHIuQfxKFNC79d2N2GRrNfi5YNsnc2LaixQjNgTc7R5oDNmp6en15LmH4=
X-Received: by 2002:ac2:592b:0:b0:5a1:26f7:85f5 with SMTP id 2adb3069b0e04-5a16270f30fmr65268e87.15.1773334894619;
        Thu, 12 Mar 2026 10:01:34 -0700 (PDT)
Received: from ubuntu.. (static.159.107.27.37.clients.your-server.de. [37.27.107.159])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38a67e5ecedsm9710711fa.21.2026.03.12.10.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 10:01:34 -0700 (PDT)
From: Josh Law <hlcj1234567@gmail.com>
X-Google-Original-From: Josh Law <objecting@objecting.org>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <hlcj1234567@gmail.com>,
	Josh Law <objecting@objecting.org>
Subject: [PATCH] lib/idr: fix infinite loop in idr_get_next()
Date: Thu, 12 Mar 2026 17:01:33 +0000
Message-Id: <20260312170133.6488-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D03920019
X-Stat-Signature: hqqb6tpwk46yma6csr1boahop9awntjz
X-Rspam-User: 
X-HE-Tag: 1773334898-986376
X-HE-Meta: U2FsdGVkX18k5Npt7MQjmhTyppaU3I0CQYrn4KrUcqhS7KEcKC1vZMZZG49Baoq3xk0GtvBHIXUGAKCsAkj/zNj4WW45t8LcvhN9B5EKdEA1EW8yXbQR7HbFlKFjXon/ZaXo1X7boqu3yHrNRwZZ1LjDlVFlNx1/hU4RSGF1s5GZK1t0r1yVy+Tiae91JuCRiOcGwKKNdOBzmU/n3vHttDkknAUszTtUmcLk9LLxmj6fcCS2ynLYjGvGhMK3few1nBvW/TtwI9tRLu3l503BpqOxPlKzm4baD6WHO5ovemuIk0ioahCpFNSI03DODxLvnZzvCXxB3jZoFCbEHG0p+kLvVUeqFbUMWtV8lnloRX//zWXaLljV2jU771gVw3xkWSlPW6v8mYpp6wFDDQ7ZVKikJlamNikHsvhh2HTj1qrpf/Do2Xi6aq/I+zIpsy3AdIaYkP4S9jXDrRkIoaBo79QzEG3mmSouXrMrAzYiJwIvqNmebq8YW92/Pbk5MZ003bn9yr5fd+Vt5y81wdZmkIMxh08JQWTUVB+RT2QffwcHC5edH90V+DIWgcVrd4LMY4h5hPMXhXIwa6945ljFTo+V4/gEVqzBliRsBcEFE1oBeGCh+ojvojXrcptpiCcEs+pF/YypALZFj1TPyaftK8xF3vrq1t0iyTELVqOihl8Yf0AAnwWYzgKB/wIeQwksmwrSBIQUKD2ZUobZzyH1dLYqnsjiw1WfNZG/LfUPZkE0fHRR9rK72Wura6u42zwj1LvQb2VfBStxysiYCGa/yZTnCr1VEc1ZJCxp/1aMbj1/nA6vD2jEeqqfCNk4kZ9ryHQD05ju+kvh1VVN3LX5SsjRNBU5eGLD7OHmcQ9dC1c83sfTBBk8cXqS2Rkf8Bv6Gqw5kuY85qrcRjXdF2zYeMPFuXkhXRP6Jp4QdqrncaOQzczncqGZXKm/zRYa6WHryiwkZB7uxfFqrLl3tCF
 mg6VCVQ5
 S++Y0MGd2WsBqwGo7JcBhVaYaNWdxW0pu0ORpBHyTY6gm4DkSRfTgHyn528mS+h/+fCyxFLRFLuI/bxm8JpLvv+oq7sFVK/7odIpvyFGv90E73xXubqhxICFKq8kU7i8BeOy+qGUoJciGte43uPoIWStLgeBF/SFRMDOraQGknVYZcR6v9l8ITTVF2/Z8Wwv/IAehOEGnafGxlLXIhwKliT6NgU8pQPCHdH0hIC4lWNcXekvpDy782CU456TqpmOZGpLUx1YtaKL0topigr1/4vyMQ8YivlYD7UJPYiHY+jeUPyEu24436x4XG7Ys+Xh0U9BBNG32X4Gxpt2V5TUjp5EoFfbfgZpIca7ena7qqkxHbHoWcKY/VQHnbSW9fdixrKZ43rGRND318+lcYLzgqaUtJxfXmxcWzKHiOgUZQ1d1VYWRwLNOuw5ybWGndKLc1D3ZPzIWpHflnUQOdqul3pDmmRJcD0W59gVS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Law <hlcj1234567@gmail.com>

From: Josh Law <objecting@objecting.org>

In idr_get_next(), if the returned id from idr_get_next_ul() is greater
than INT_MAX, the function issues a warning and returns NULL without
updating the *nextid pointer. This causes a soft lockup for any caller
iterating over an IDR (e.g. via idr_for_each_entry) because they will
receive NULL, fail to advance their index, and repeatedly query the same
state forever.

Fix this by setting *nextid to INT_MAX when the bounds check fails,
ensuring the caller's iteration will terminate.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 lib/idr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/idr.c b/lib/idr.c
index f25bd2b9e9a4..07098eb4ddc3 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -268,8 +268,10 @@ void *idr_get_next(struct idr *idr, int *nextid)
 	unsigned long id = *nextid;
 	void *entry = idr_get_next_ul(idr, &id);
 
-	if (WARN_ON_ONCE(id > INT_MAX))
+	if (WARN_ON_ONCE(id > INT_MAX)) {
+		*nextid = INT_MAX;
 		return NULL;
+	}
 	*nextid = id;
 	return entry;
 }
-- 
2.34.1


