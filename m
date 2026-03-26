Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 696A910AB82D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56AF6B00BB; Thu, 26 Mar 2026 19:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2E726B00BC; Thu, 26 Mar 2026 19:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCEF96B00BD; Thu, 26 Mar 2026 19:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A9A956B00BB
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:47:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 71AE4E156E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:47:31 +0000 (UTC)
X-FDA: 84589853502.02.46A39BB
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 80651C000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:47:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oiQelTnP;
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oiQelTnP;
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774568849; a=rsa-sha256;
	cv=none;
	b=S+KgRMFYQBmp/8/pQT3GTtJMFjp0aurULsYuhfu4/aWbta8/KKeZRUY2IBvsMQhzK+X0m/
	OQAADHHONzFS1VSMXyhGxC/fL2aPrGvt5H0sbk7vfHrB07vCNn30A02YYX0DE/Pj5gLhHD
	LI0wRrKr06O7hfoELoXSp0II4IN0UUE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774568849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hwh8cuNEpoLwXQSyJbOzsPP4ho/foZ01KLl/zuIjPAM=;
	b=gPSiVyrMGb+wryChs85WGk0Ls2Jkb5RguqoRvv+XULl0X9LyD2esE9tPlEWBxUKC5UdFth
	nFs7djIpFfXADO11us0Es4Wr1+XlGTBhzsfSG09/VvkVuNxDrvUOPfjtkLsjAHp+e1pZ/T
	4E6W+gIhkOAlHfgNk9pEn2KI25Y4OeY=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ab46931cf1so19593135ad.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774568848; x=1775173648; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hwh8cuNEpoLwXQSyJbOzsPP4ho/foZ01KLl/zuIjPAM=;
        b=oiQelTnPjaaX92Ox2QBYBcF2v/y387S0nlPgWC87nIS7d/BV4hWSXWGcCim/cHZj+o
         IGfiEEDwVWdEIBJxj/0cslxeKYmZrXeMCf3GtVht+GLZhx9DAVogQtsfGIE3CLrv3afw
         D17VGb66UcSJDbmrppqqdKhRm5qqrQiXroUEu2MYMlOJKXj/MmojvYCCD3j73Ajq6ZS1
         mjxA4muqUw21DO+TdcKt00lanCXcs7146rfAaYZhkXSmFkeSkJyOjfyDXHVhReI9BiK1
         87FgGoWdOD9Lv5SkS3PjrLvBqlsF8h9yd2e5QUVxM6vMOfp4QuQbRc+zOJwkZ3SiNmi3
         GW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774568848; x=1775173648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hwh8cuNEpoLwXQSyJbOzsPP4ho/foZ01KLl/zuIjPAM=;
        b=B9ovvs8vZ4M9fZFBcMouT9dA+OkUKDc6RLTT86fyi0wN3QlZQKNNkk3mTRhSwY0/6G
         xUlclLUlESYQbEPBxjIp7VCycg7+A6N2SmpZlJIYfIsAaATAQ+a7oNnzPDrxsdhecXpE
         o/twx66PibH+b1H1buKqDHaXk6JOjoh8t7zlEkhsh1JMVhZXTPHQnoTXzJKxjHUs3STn
         8v7KdEjghXsfJ0QZ9z1TrR0HL9w3ZjYONkB7EVBY/JOHSQTTcP3co0YPwnQtRG8ujPe5
         gW885jo2Out6F/PrP2rgACgFV7tPS1+0rosDJbWBD97t3EtHBJEJPBhYkHNrLnhIT5DP
         nSOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTsoBsZXUlCQO043QrDElsUov17Y3iI5Y/pU7XeQW3bp6j8aPT34HSBk3q0Lh4fQ6gSVpGzOq+EA==@kvack.org
X-Gm-Message-State: AOJu0YwL4khTTjO1RULoMb5+hDLW3V1D0ueUVywQcGRQIuFEtIyxFr8g
	jjnBV2rtdqkH/a33+5cysE99E7pukB4eSbSqW5yfpZu1tWXYc1sY8HjG
X-Gm-Gg: ATEYQzxkcqL9Uec301K/vH7sQwN3Dpoz9KWlg/XXuWEPFyJKPvPYuZhJtaz6mrQvg0/
	qosyb/4E+2u+BjrUH00nDPiQiS8Yx6ESQ9/dCbAt40feED/0nwCRg3BDLFumPEX+RZksacqY2BY
	fDGOfGwBGfPCJVUtSuO5fYonNBf13ULmHRcNSpNt00HAGdWLx8/xCUNzz5Fc8Xa9TOBfgcRb6/m
	2sKVd+9UtkWXT1Y10xZniZF13X18pBLU/oiP47Qsr3U5FDZ6XghV1psOO6hD5XYVSKRY6aPIoni
	n5hH1CbIbBUhUKoiWuL0GAamkrQ/cbYF5GqiT7MOJZJxj50Rk2CL54gCJVSZWgTamej8dva3252
	Y6XimW4FH+14wYUUPhCpL8ihR4CiLJ6Z9Bw6t1afSFaccIQ4mI5rSfsIosm3Wj+ym6gJ0r0rC8p
	P8n1VQh+KcgLgsA+3s
X-Received: by 2002:a17:902:d4cf:b0:2b0:51f6:d469 with SMTP id d9443c01a7336-2b0ce5d7ee7mr2127515ad.23.1774568848344;
        Thu, 26 Mar 2026 16:47:28 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:2::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc76bbdcsm42362145ad.5.2026.03.26.16.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 16:47:27 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: jack@suse.cz,
	willy@infradead.org,
	miklos@szeredi.hu,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 1/1] mm: start background writeback based on per-wb threshold for strictlimit BDIs
Date: Thu, 26 Mar 2026 16:46:29 -0700
Message-ID: <20260326234629.840938-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260326234629.840938-1-joannelkoong@gmail.com>
References: <20260326234629.840938-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 80651C000A
X-Stat-Signature: bzz3s9ten8b5gp6pbyrm16ctsd7uud1t
X-Rspam-User: 
X-HE-Tag: 1774568849-94158
X-HE-Meta: U2FsdGVkX19lo7Isb9ospcMVxghzucaP0OoQbDKlyRWcAHVGZlk1r3HuTN431QL33SS7zz0OeZZABWkuN3vgfR+qyXyMcG6su4UDQ8L8YEPe+YKbzTBz5eb4316QNlz7a++1g4ON1APtXv3e2C+4VzHdzT2/OIQSyWZ5jSdskI3nybhXoRgkJLwCojzmbzNC8nD3/xAu+BH2n4wX0C0NTJiIFRVlcuMV7dV8UzNTcyPTBQ+xG/1G5iB8640rPeDaIi/VDlhX1/asz/8eDbjfgHiP//kJW6mwN2zMoJURG+SRcYTi5DL91Mdm9auhH0kOWcVFSgtV9X74JKbe1sszNi5v9oVYBcqiwPt2GpK7FmItXR5JTVUha9OW9gaCgojGtJj/E5M+hsjpxDXdBxj21x0nNkqy8+nGQJ2UB7p8BUhoisEQ4ByJTdZD4IEHv+P0LI+kHP51sQMD6vCMy4hGVTRPWEPaz53UxGY4iiRJXT2xyKBz0Y04bfL7EC/jcmW4qvyVmq1D2Ri9bg9ij3KeMy1ZAnHsNRlEz6FJ2Wt00uicsKxkYO7iXWkd2L4u7CsHBWZ/u77JiMetRXlg9vixML/8YxfbMxjeul8cYjDwT5P8VOzJqz2kL4+LO2eKQWJtqGq1d4bM5duOBs2IG2A7wiw9jqUxnsyTFlgqycMdtEftCJa4Kw0UTQeRj4wMLCLV6kFyAjU3urHiPBywEEox6WOJYa0e7eAhNGkp1sUCURer1iL5jX9OA8GdKEG8pM28XolXEwbMpvXLuXNGJH1exX/qWoib9sPBgm4pNLh+H4L1oTv0RVGrCV/TTty2goI4lO4ODlSaQ97Pe4tFD2dF8K+AD+kBOs6s7L8OQem2BO8nwn7jg7v+OCfnsSEPBQOWpRAbnI8HVDAhtsNRSUNRDl/+DJzakoTWYbWHZ8+Uv8fpXOWLAgKP9LOjjMEbnLOeYlxpzzl2romEyTbJ1YZ
 dKWQvKcD
 po2G5wdJkHUeVtAvObDb6E76KV1d6bqWQWpWSwG4Qoqq3DFoAazbxk2NKJEd20nP1D+fO/NNoTpYC0nb5c/zqr/bxC1kV4kJN9JM0gLoXIRlgbT5crD2Tmv7rJtX3JUEGl9f2lIfYK2iOuMbaJgbpaXxjIo0ycAiPDrPNkUfSCLrkNR4YPRrEsctl/NnbF91bcSkAHB7BDfQSFQEfmMrd502iVVphkkxHs4p2SAEDQ61tOse5ho78n/7qOMLTRyFiKFBUEpFBIfrqbDqHgqRoZXJWsMSwuw9bamJ44OzPnb36mDqg9dL7efdHruEm1PdFrWvXV4kKRdC2i/UZZTZfnrlnzOo2bLm9ni0NOg+zVP17nULguKnUA6LgrV0AdYNKDod143IvNR1rmv0XPKWqDwLDQEpU/7bYb+6uqK2M+5ak6frfc4AMKgz8shjO8sRTOjx55N8yBXrZgjQ2zy9SMRhfGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The proactive nr_dirty > gdtc->bg_thresh check in balance_dirty_pages()
only checks the global dirty threshold to start background writeback
while the writer is still free-running, but for strictlimit BDIs (eg
fuse), the per-wb dirty count can exceed the per-wb background threshold
while the global threshold is not yet exceeded, so background writeback
for this case never gets proactively started.

Add a per-wb threshold check for strictlimit BDIs so that background
writeback is started when wb_dirty exceeds wb_bg_thresh, which drains
dirty pages before the writer hits the throttle wall, matching the
proactive behavior that the global check provides for non-strictlimit
BDIs.

fio runs on fuse show about a 3-4% improvement in perf for buffered
writes:
fio --name=writeback_test --ioengine=psync --rw=write --bs=128k \
    --size=2G --numjobs=4 --ramp_time=10 --runtime=20 \
    --time_based --group_reporting=1 --direct=0

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/page-writeback.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index c1a4b32af1a7..30f3d5a6270f 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1835,7 +1835,9 @@ static int balance_dirty_pages(struct bdi_writeback *wb,
 			balance_domain_limits(mdtc, strictlimit);
 		}
 
-		if (nr_dirty > gdtc->bg_thresh && !writeback_in_progress(wb))
+		if (!writeback_in_progress(wb) &&
+		    (nr_dirty > gdtc->bg_thresh ||
+		     (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh)))
 			wb_start_background_writeback(wb);
 
 		/*
@@ -1862,15 +1864,9 @@ static int balance_dirty_pages(struct bdi_writeback *wb,
 		 * Unconditionally start background writeback if it's not
 		 * already in progress. We need to do this because the global
 		 * dirty threshold check above (nr_dirty > gdtc->bg_thresh)
-		 * doesn't account for these cases:
-		 *
-		 * a) strictlimit BDIs: throttling is calculated using per-wb
-		 * thresholds. The per-wb threshold can be exceeded even when
-		 * nr_dirty < gdtc->bg_thresh
-		 *
-		 * b) memcg-based throttling: memcg uses its own dirty count and
-		 * thresholds and can trigger throttling even when global
-		 * nr_dirty < gdtc->bg_thresh
+		 * doesn't account for the memcg-based throttling case. memcg
+		 * uses its own dirty count and thresholds and can trigger
+		 * throttling even when global nr_dirty < gdtc->bg_thresh
 		 *
 		 * Writeback needs to be started else the writer stalls in the
 		 * throttle loop waiting for dirty pages to be written back
-- 
2.52.0


