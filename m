Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1DA3FD530E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 08:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2482F6B0005; Fri, 27 Feb 2026 03:21:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F5A06B0088; Fri, 27 Feb 2026 03:21:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F54C6B0089; Fri, 27 Feb 2026 03:21:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EAF746B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:21:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F9461A0567
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:21:49 +0000 (UTC)
X-FDA: 84489543138.06.6FB7585
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id C22204000A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:21:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XFvMVqTu;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772180507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VJq9az6bjggid+ayxEelbSnWqv4WCaON9zJSVCQ7fVc=;
	b=CTPrOB6ZsUgV8sHmK8snes+3sUlXpjmhGnhw/pDkGUTf+jYRXTuGgj58dZnsLreCbFDGb6
	8UagJY6YVxQ84mjla2hY7DqWV4PmSN9NLjRVbetRAFmCSxc7esuAYPlJBSHeq98ShYdnTV
	6MymPlPb67PvpCPGM4MvRV3HzQtey6g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772180507; a=rsa-sha256;
	cv=none;
	b=CJDCVFCNlsacJS1h5zAk85MY/3KmkGW5hYfRn8cgwCAdTd4U8a+YMiZdhFV6WZdst7IrsH
	oaTLHg12zfCywE8+RR0KKGfV/D8D0co77lNJNnBvXK1MZJ7aHrePXy26eKlTmbEggQYYMs
	kGkniNpAX9iSL9eTSCK0uL0jiIf4zec=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XFvMVqTu;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ade574f05eso12261435ad.3
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1772180506; x=1772785306; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VJq9az6bjggid+ayxEelbSnWqv4WCaON9zJSVCQ7fVc=;
        b=XFvMVqTuc3VA4Wwpvjh2lKlj5EyPoFW/lKILwzTy/VI0qCYAtf+OX185UadFvLxXIn
         QgvSsNOGq/+RETcuLPnLnnkIT7jtbBX0edgfD1EiXMHfx4AR7zD5AtbLrZVm7EWlW7RV
         HhARjyOTm32qnud+wyhTVmylw7SugO4SkrcZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772180506; x=1772785306;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VJq9az6bjggid+ayxEelbSnWqv4WCaON9zJSVCQ7fVc=;
        b=ErbBiI3RI04Gi4hle8GQ0Z3dEJK3DmRdGTEC1v7838rO7Nh56yzmAikODlu8GgcVG3
         EJrZ31uTUSV2r+YFoufAxl66wPPgQiRYoUufFx80h0jBz7nQkCxD+xSjkLtEaI/BQ6UA
         ShA6V/uaCYdyfDNZp+sqjoUX77h6eLvt4Lbg53/T2G/k2HM92VR+Vmqxei3JocRPOo99
         B6NpwGcwOOtK7dFb9J3+1vtatzr1HXiNUEunVr2/vm6LCFDeoogaDs7FLevtoTOBDEU0
         IEa6yGwPcyyj8GOLkcFU78DfmbY8I6h7Lk6No24A0UpmATMQcOsAlEGBwfgR+asqmdA1
         lQRg==
X-Forwarded-Encrypted: i=1; AJvYcCXpHSR3ne7uOSmtpjLiNdobpO3mTAD9gg8h8ywPwJNWm4Lfy/LweQnKFbV8e4UAeJDgL4IMDyy2Qg==@kvack.org
X-Gm-Message-State: AOJu0YwOGSbi/Dsc61OlzUd9tSJixu9yq36ss4H32pM5bxJiN/geTG4y
	/dg0fsR/423/6kxZNpWuR3T9DAog1l8YSs5tNmu5v4sdA//WgmQReMznTbdnXZgFUA==
X-Gm-Gg: ATEYQzyuEaDev4ERo46f+PSsuu4KYKADoLVa78bX342qd81xpwl6rHxMw+eHfrtecF9
	ljJ0TsqlGs1inSPEKK3jXBKnY4PQFMcfKXNGrGcXRhalxPjQUn36iCPCySW0NxVRpHcQLYuMGsj
	ARt5aqsWViMWoC5VK2Gvsk0DEhsVXDJ+U/t5srCs4V+OuxlmDkS0b5BB1/srL2GZBSmIomW8Pr7
	3oopvVg0qO7CswKAzrqo2SRojnVSdw8a0AsgiIGaNd9iKO1Lq1EXNv4HFNF19+GCctPZzyNhsX9
	ORwXI9vvVVwvyoQ4lRt29rrruSBlLypvYXG+gpHCJ3WuRy2lkxkK6gPnZjmxr4e7mzHt7MGJmTa
	n70Q+Wsyxks6JZhzB1kAxlmQ1qfoBMvFwFwbx18kbWXPXBEBuMGIIQcN5JWxegjKRaTsH2OFOdL
	UO0axtimzgg9Y9tBlBcRFe+ehfLgCMqZUW0vow1H/oduzJD0YGO2vV8J2fxHmKoj8rdtOloSWbn
	zsnLD8YLWSvLQ==
X-Received: by 2002:a17:902:db0b:b0:2a0:e532:242e with SMTP id d9443c01a7336-2ae2e3e3c6cmr19505095ad.11.1772180506517;
        Fri, 27 Feb 2026 00:21:46 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:280f:e47e:6718:7698])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb69fa4fsm48796025ad.45.2026.02.27.00.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 00:21:45 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Brian Geffon <bgeffon@google.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 1/5] zram: do not autocorrect bad recompression parameters
Date: Fri, 27 Feb 2026 17:21:07 +0900
Message-ID: <8a5d53d19a8dbd51d7d81d153676895163e0735e.1772180459.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C22204000A
X-Stat-Signature: qesnnfpdcsispk8on8kggh3c8sa5yhdk
X-Rspam-User: 
X-HE-Tag: 1772180507-963549
X-HE-Meta: U2FsdGVkX19pqnZ92leeITqWJp0Zx8yV4V4kXkJwIKb28sL+o6m31DDK/6qfQxOVNBHnOfyV+0udfA2WWi/Y5CZYIedHN55wkfgW/l9dvcwBmT11esc4hHvY7x3iAJYV4zljCmJB57ifjAVEYRWVhVj97duRf623L1yWhHXYGrxmo+XxAmAr/QQCJlgiFzoE6Uw/5yyg1efwLa9jY7+g4WZ3lUz9hQSHZRwGx+B78jVQoLt43HcpFWUUfjDJOA+Ams8M0JZsD9pRdrBElHyYnD5rNlNJxQxiQOJUKy9tLP3osJnEtgovtaSrQ36bNP/atEGjAcOKAwPcxN+JbLt4KsJqokKqkVIechqBnflx+wPMVy74tfEQkqFELAuee/e904n8HDWU6aUhf+94FXwSYp3Ye+EEdhAd8P9uLY0aVSgTjm1tYRSR9hBuhOIJbQvF3GqqRagk3fSnfwz39KwNXEd1/b29BD/+dArF6q/1PxyXcyJ9pABDDqvsaSYBxW7Tk/y7i9kum68Q4tJ/2YGNFie1fhtkX27rMC4yII8ql89M1jBLrsNGePb4MDeLVbIY50/WqC+SLG+8ezWTI22SVCpsggenAHKTzYBO3hoFq7cBbL0afMWNIy4FffZZB1UN1MBe8LnOZGmoOcSrOY6DD+5KGH4xmzGFCl1l2EPlXwCxalOg1T7kCdBS3SnGgJpCOab8mjUT1nOcrQxa63Fu6Iu+kERh7BaGqPItHo5BM+KsphVb603aVajmASyhb/+uyyBimdhuqLYjkpY6vk+hpus3S2OCWX57OQ1/mW7pUbST+q1MhrI8dn4eSq7ESyNNIl36m1x0RFC2iLpr4lXe9CxFcyJhNarBCOmf+7C7TYPfNOZEZ2h+5izGkRnbuc/MKNoXRijerHRKmz2uqjglTZoHR3JG9/nDgySN6TZjyPHgYIw0FZhEVq/mmVdRXiPBJFWlTkaxRRgG8zfG30c
 eJeJ8pGJ
 4i0f5mw8Ot+XbV1FGBBQdc2tmAy8I4ff694uWHvQ10rRPa9PzaKiFpMxzyeYLHX+ifJaJY5NxKS1AsnbIuNH15sMNgDW+O2P2IAmR9ybeOm/OCeEidWfFkDXI3EvbUG2AFWR1oH/Dxvu1X08b37x0TszWZ4LvD+DfLSY/hx2f0qMJa5bYhTR5tF5H0pDLmvv1kvuobf1e9FiiOSol9cYYs5ffoxvQ+qaoXdWNvRJjzHD48CyNV0eFEmE+ygXBBjpyEGUMGxn8LmfrBdmJUuMO82P+FJVzDiyohHQ5g0k39Rdzd/I4ixO83xw2n9IzlKO52cd7+bO8v5CU8Ok=
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
index 4eaec24a23fe..53e0bbf9d6ec 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2524,19 +2524,16 @@ static ssize_t recompress_store(struct device *dev,
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
@@ -2586,10 +2583,7 @@ static ssize_t recompress_store(struct device *dev,
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
@@ -2609,7 +2603,7 @@ static ssize_t recompress_store(struct device *dev,
 				continue;
 
 			if (!strcmp(zram->comp_algs[prio], algo)) {
-				prio_max = prio + 1;
+				prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 				found = true;
 				break;
 			}
@@ -2627,6 +2621,11 @@ static ssize_t recompress_store(struct device *dev,
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


