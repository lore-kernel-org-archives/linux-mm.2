Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1940FCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 808826B009E; Tue, 12 May 2026 03:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8E56B009F; Tue, 12 May 2026 03:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CEA16B00A0; Tue, 12 May 2026 03:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4A36B009E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:49:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5D9DC1AB4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:49:38 +0000 (UTC)
X-FDA: 84757993236.21.170EC64
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2DD5AC0011
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:49:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QDCDtMi1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778572177; a=rsa-sha256;
	cv=none;
	b=7+I95n+5ed+ZiDZOvFAVKbK+1Mvp9t/RlU9NXdoYaj7ykBmgsHRmxn0Q0Ft3EWL/nRMJ2i
	t+Y4An1ksplR/Ra+bqJgC3CoFuwbBup7joldSD2L8HZiefJKKghidKVbhNLAZe2uZaz9AW
	cjhV8tsdhppb1kZABVdop6KG2B/cgtU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QDCDtMi1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778572177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XTXY4pA4hLihSGJD9owJJpsehQXc1UOF+hNlelmcd9s=;
	b=Zjo9H94FaosiniCFKiBaa2bYU7ehsjs4phpKqO0tFBfkMCXIhyoHzPSSaZcf2ctbkgSyun
	35bSlIGYJYA9BxfeoCnTVuqujBr3hwl5JhWE3Dsi510blL9/rXKGlwoYlWGDNMnntqlLA/
	XCeA42GoxKO8AzGHAsYxjzfndZkCndM=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2adff872068so27832415ad.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 00:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778572176; x=1779176976; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XTXY4pA4hLihSGJD9owJJpsehQXc1UOF+hNlelmcd9s=;
        b=QDCDtMi12QmoqquIQAqOIBPBUoFSognLcB6G3oLOeGaJPLgdJcdN1PdMLhBsi7cCxN
         kLsyqB9l/CF9CyW20jVkIn9KIJnXlyulLNNDSm265VZG987f43dC7ciOV0Mo7PtZkfBQ
         8wxhqu4yivAadE+K6QNYtMmB7RSoNnmkRpaZJVBO/5bMUYO99OLl2aWiVLIw51DsfDV2
         7eVKgOyRAo0mW7lZospJLiDVdFaxEZWFTkzlbocDLFGDXX4L8ejFp3q7GNwYaRGeVQB1
         vxwE33KoSP9MwHDsgWDzjqhMNBHekPcOqesAQrGroyftQUeY5J6mqiI2dijoT/HkD+tR
         6Ygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778572176; x=1779176976;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XTXY4pA4hLihSGJD9owJJpsehQXc1UOF+hNlelmcd9s=;
        b=CVJho9T4PsJ4/uUpFElfuU95MLg8ckxdUeBJ8XgUQ3B+i3mWLeZ/Pawhhyz2hrrSQb
         2Y/sTT5BkjEaFDwxbofbVfnJfPfR1GaIisa45LjrVm7bZRmzRRg//8l7TzMrFkhG94uc
         +H77KWNLxU4Ro1stu60r7LXqcJj/0BrcA+XtjIKegq5zaCRU3qfxIpkh16uArcD2RAbM
         X9m0ucQbeWPctr5cIz+GwjS1YlIZuKfKi/APhaoMNI6O9xyQz9iO6o8DrGPDcPLUe244
         3m81FkH/J2+3oQwFezog7Ls8AZk/qDPiiAa5pWULfCNN3s8J0WsXHBK9a3J9n2Oyhj6Z
         lalw==
X-Forwarded-Encrypted: i=1; AFNElJ92PD7C1kV8t0f33scttxyQi/ME3kOaUi7nqsblbPDAVD9YkQgs+RNu9Vpazrz2TKFPw0+5ZGcVUA==@kvack.org
X-Gm-Message-State: AOJu0YwDl/DRyTfuIjgTDQK07+8XEsLEZocmvRHd5hr6zz/RObTT4GSr
	nigTLeE4A4C5pBy74v52NsTthc+3rdFrotvw2tRnllQbfKuSsgGLGmirFpeRnrOM
X-Gm-Gg: Acq92OGBEZdD+RRJKSePznNyUVsLE1K1kw4bnapIweTSMgHcETCZSpFLmUIB4Ug773K
	Ne/qbm+gQsYm17hIMj7epPrZGDmCtz6WDIbqSy+zfDygArPMnl5WeT3EpYl2x1i02F4gUpjX0Fe
	L5XNb1y4+2DOaWlYgWl4gd61vetcvfXkDgZQA4vHLHTw5ETOOBBCaQHnRMnqbAJMdC2V14jqI+A
	3Ib2E8UCpay4qCsAy1FzhpBPiyn+ivNuGemovciZypgc/CmBhB2Wdn9yAfGPtk9/+uul4m0pu9u
	5NtYVg2yIG9FdprEGLgROGaa85pO5joM5KaDykfbF+GR+oXihjyaVsTH8ckkv3d56zgdWke7CCe
	u0ogRXT4cJxK97RCpS1C5HcI3mZGKzDg79TEdPxqvahddOLtUygiWKnvBTQ7LCYZGAXr8xEwlpj
	349WQuy4h8Qu3MstgoK+I9m87K1rsFDg==
X-Received: by 2002:a17:903:32ce:b0:2b7:8a56:7cda with SMTP id d9443c01a7336-2bd010f53f3mr23860395ad.4.1778572176149;
        Tue, 12 May 2026 00:49:36 -0700 (PDT)
Received: from vini ([2401:4900:8fc8:73c6:dda6:576b:fa0d:f68e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d3ffa0sm127554695ad.25.2026.05.12.00.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 00:49:35 -0700 (PDT)
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: [PATCH] selftests/mm: check file initialization writes in split_huge_page_test
Date: Tue, 12 May 2026 13:19:24 +0530
Message-ID: <20260512074924.27721-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1ypy9ujudodymk4koc9f1hdtrcafg16i
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DD5AC0011
X-Rspamd-Server: rspam07
X-HE-Tag: 1778572177-615606
X-HE-Meta: U2FsdGVkX1960QntUr3NJ+hwy6IOQEhhb+vBgTK0YHYoUF3guuH4aRmQarHvTtzcdLmkRKB7p6BypEK4hbpRNbe7fLCZL1G+/ZA9bWAPSXsL0fuUH0j3f8Hwszez1QII4Id7fSIxTHQf82//cQR0AIG+4JdsDVIZQUtITfOVdzRjSOqWkSNdl0zdzFOjL7vaKulYw2saVDP7KcpiXSjDp+cpU+D2T09Cn03pJC+1Tu0RFGK6gexPGvuhSLWPNZb03DJA2u+1KMmhq7wag6CEoH8LeTjwUK9PZ7eX/11saimzWKMctmvYmDBspjRPVVHD4IYnJE/Zwvv1dwoo/KfySkxXg05UT1+aWgLwDWz4CDf0Ru1R22iYoetupTKKCjxInYUnZYBgh9bHhBQXa8stb5IhxltgAhv9GhWtQlgyz19hEWSTcQDI5vziRwfuGJOO8YaE5QD1BalTTeskS6G7f/rFEUC1MXNsT2ZE7CSorRnpe9Y0KkD+Sgir9AQrVV9pOCIaPXk5/BclNexqBcK2d/lXnnf4HmMxZR+/HaJmKQYJyXvwm2aYwmoqF1I+BkNoNiEUCuz4If2QNlnEgm27/W3GoAd4xRjenmoxiIXSZvXpHrbzjeOGU/42XcblX0pCteYDoX9bAgYklio7FKWWJCCAmYIZNhfcH56rDsIW4xsXiVHF53NSD3bv8ieGgQ6BjGcX9yXsaK/88d7C5QwDeLkez/v/pz0jY6YyGP3x/N8pbslDz/HDOKAUAzcarWJbK5jG8jotBnReMysO5OkH7xtriiI+nJ0KC3ZZ4SFsRb9xAp7Q2T2ElvGUwZEIEeaE8YpfE1iBn79+6JGvoJ97/2DtCZy8jn4xhEfCnu181kaitppcSu9Be98UmbYF5lD5ZxaY7aeRXEuFUD0+KS/jNyX13IdOATKJuG6F8m0dGNUC5G0vyRQa5A3OXmEJ02EWH9p7y+m8aK7eZJgkMQf
 GEO4I8Cp
 EkpHfabRxMLa/Q6TUKOH65UYLDc4OW06bhNCTOO98ia+R1Tu7+uD9sE+wk5qR/Md5ZCJUJiAfswv+bJqDWrGd+ENQUhliSmSYctDsR+fQDJlSb6DZmLugRF5vC6kqqM3Ae3Xeian4xKN3rql0WEt3T28/sTpyq/sAyWQm6WHBubInH6iajdjiq5HMjXBR4tzz5IYVu5GJHTgH5SlugJFZyYnnZG7Oj/+NnhTwKXLXPuu8NJ3nZjGhQ94JBeaTs4ye6L3lexPyMvFLffFyjg5vEPDltRdZL6QllJ5gxJZkDdSRWv0prvWIYBQjBKFHKAZ4E86G9Pud1fXqdVQI3MD7+9GMXzul6xbvK99xzwg52UhnJS2O9mQZrVuCHGvSmdpPmjkxRJPijADtdbtijHkCh8ePBa6vN+tzCmmv3FaOWVV9O/T+m5bMaTKYs31Bl89YrQQbmOlK/6Bl4mHrbuJaBxxy4+bZ/o/9D8gxipYtgrxseercHtYtj0biMKiXHn/YliO2k1fYLaqYL4PEztl2jnz35bgnkTd/BsCA23/+Cuv3VXRtVw/TLTExa0Vby22EWuQ2G/uup9hwYtvx2nHPBOrQU4vzbkxLv/DLMmulYzXdW+YqbhfXYVM6FG43HxkcBidW3y5QEAvcyl8aPDwhLV1Hgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

create_pagecache_thp_and_fd() fills the backing file for the
pagecache THP tests using repeated write() calls, but the return
value is never checked.

If a write fails or completes only partially, the test may continue
with an incompletely initialized file and produce misleading results.

Check the result of write() and fail the test if the expected number
of bytes was not written.

Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 500d07c4938b..eab69b0f59a0 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -609,9 +609,16 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
 	assert(fd_size % sizeof(buf) == 0);
 	for (i = 0; i < sizeof(buf); i++)
 		buf[i] = (unsigned char)i;
-	for (i = 0; i < fd_size; i += sizeof(buf))
-		write(*fd, buf, sizeof(buf));
-
+	for (i = 0; i < fd_size; i += sizeof(buf)) {
+		ssize_t written;
+
+		written = write(*fd, buf, sizeof(buf));
+		if (written != sizeof(buf)) {
+			ksft_perror("write testfile");
+			close(*fd);
+			goto err_out_unlink;
+		}
+	}
 	close(*fd);
 	sync();
 	*fd = open("/proc/sys/vm/drop_caches", O_WRONLY);
-- 
2.54.0


