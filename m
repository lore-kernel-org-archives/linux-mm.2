Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABA89CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 02:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F168D280009; Thu, 21 Aug 2025 22:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7998E0056; Thu, 21 Aug 2025 22:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE02280009; Thu, 21 Aug 2025 22:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCF148E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 22:51:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A5151403CD
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:51:44 +0000 (UTC)
X-FDA: 83802868128.11.259E9D9
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7EF70180005
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:51:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hzg0X4qW;
	spf=pass (imf16.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755831102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5y1fBCXfKiFD4O4AUiF2Q1s/sYVAdN3oCGBndILrhJI=;
	b=yYuQglzT+C5p1j92zqYOzip/gAHtBmSaFtrNqnlmEfsZKk349YHNjWX5/tpaHcgeMpEJ1J
	/66Uc3op3OxKIjddyDh0OoBtDiD5YfTD5yo153IGd3QBqN1lf80U2JOJG/utvwjf1tGHK8
	yt9uQgssERcgpBOUxg8DUhwTjjRMqnk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hzg0X4qW;
	spf=pass (imf16.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755831102; a=rsa-sha256;
	cv=none;
	b=itT7Dj/IGvb5sEGPzC3WVVbTpuTzH7rbS0tpfXB9D03NsO8KjajZSTmQz/26hLdcRAOZ2V
	uXOiZ8KlhGsy7o1eodP09BzQpPSolqUrWwMgRwpD73OT97T34R+ETe4gV43kLAD/6dp4wQ
	2lCcSSCoxgPev0bN4Jwlv+nwKIPNzDM=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2445806d44fso13752905ad.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755831101; x=1756435901; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5y1fBCXfKiFD4O4AUiF2Q1s/sYVAdN3oCGBndILrhJI=;
        b=Hzg0X4qWlnKJQ6cZ0GfC9/v+/viS8hKkm19wFTKQSsFJQvpVTbrQ/c2xWolLw5nakG
         y2HtZ9f/mjJmtZLEd9zjldnbn/dzzxB2iKKivdcwFLdL/Yy/Xd4fvREVRJPKoPLIJUlp
         +P3fPRZYkJXkZYpfWXzVMl7Yy2pEyzMANGw8HMBFSY8EPOat8qtglV4gmaZYqx+k31KK
         XH0QbqKdOUL/ah8iwRvOtlTVcGYD9Ll4PvxZ8/81mhfsPHYBROvvTejFvo47mJ+1+GcH
         WLVHPxWiqFolrteWTDaoY5TvUA/r15ocAnCwU83TKXcFB4jf/boyXCBjzgTTvz+jHRyi
         rmeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755831101; x=1756435901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5y1fBCXfKiFD4O4AUiF2Q1s/sYVAdN3oCGBndILrhJI=;
        b=NIvR2WW4yuV4/4fOta25FGoH3JgqK4xqg59EcQFJP+du0pbfc5+kx4+OC0en0ETBI7
         KIvfaQc5qtlJ/3IaYi67sxF/SlBofis/owSuKyiVh+fjNbyyzgJyTRthok1X/KoiLgak
         +7+zl/SULnLcB6ddw6Tfw1X4REMw4UeKc/KEAMj6LuQOPxkmGri4/kqliSpzHbohydAF
         xlcBEmxawMJaEKLeXZIkUAhCN+OO4tP6mgI2N48mLHynPOWLFmVTa0/iFjO80hQO/uiQ
         Ujq79xuEYWP+lbpDMBrLs1vWNTCO6Asj4Vi++v7SGLEgyVbWPLiyt80t7zBdu3ytGWrQ
         QBlw==
X-Forwarded-Encrypted: i=1; AJvYcCVRJvXEJvz3XvUwvkh77MWE4VOgpBUWOvPMUOKAWIsBCtZ32NJbGH2LdOF4Ndg6JTIl5PghReKw+Q==@kvack.org
X-Gm-Message-State: AOJu0YxKReO7hs79Hg1g/2gnAhfbAXnryPieLs833h4/wWZHfHi4wxbN
	cz6ZOa2eZE0yEeiKHuTSgzCsEFYVADrTIgLBXF+94C4BNCT6N4Sb/8gm
X-Gm-Gg: ASbGnctEBFyUZBf2FNx/lswWDQxrQ+9q0L37wpzgqi+wYnJobQSMQOaXGPfuoM6iuzH
	P/WaXoL4MlkwIBc5+oAjJKh0bs0Y6ttj76l9IOBsNzWIWPRDrqwhEqJZWYkKZCxgwuKllo/StUk
	OAibaNilAJnscpiklRiubtmcuOWn7C+LLK8IVSGB60afKa7P5IXHieDxReXSRZOZ3dis97qeCG2
	viZTKje6qIpbcOWgZ4e9oWHlej+zzWE+zaiOeKqJtWfqs8kvOZa1ohoQsP02it41VCpmyZWVkbR
	txkf+08w3L5HXauXbfUeTDaMjVPAjppf0BZIQyg1NN4TPNA/MDskh0GdxaxGz1TjCb83N5AP69o
	oxDqCdoqM2DoRLKag
X-Google-Smtp-Source: AGHT+IG6EHV8ZRai6TgzlWPeLJW94eI6szB0VIDlvVy7DY/ryr2+cLBvv/1oIXijaDK6rW2eCMhxtw==
X-Received: by 2002:a17:903:1a2b:b0:242:9d61:2b60 with SMTP id d9443c01a7336-2462edac937mr23760035ad.6.1755831101073;
        Thu, 21 Aug 2025 19:51:41 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24614a8e166sm27790215ad.75.2025.08.21.19.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 19:51:40 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v4] mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Fri, 22 Aug 2025 11:50:57 +0900
Message-ID: <20250822025057.1740854-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7EF70180005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: eez6zqj4fwke1wbtdztsi9obth7x4wu6
X-HE-Tag: 1755831102-936941
X-HE-Meta: U2FsdGVkX1/gnAtWAF8YgBkRnnUBVFm+bZQeB2AL+zaL8/NbqUPGx5VwkdYmyAOXKwwVsWIyy1BIN51iLud7lHCHZGDuCdLCLV6USTfb8NdXs2DRGVNkKzNa3zNmYB7KwNfZTT51exqonmeLv5CHHxhOUPs463wTFQf/Dh3j23CHJndi4UQ/cNjkwX1riY3DRK1HfrjKCrUTpwux9FH9A6HhEguutt5YbZvkHRkYX6djbtcAnx0ey+8aJeA9erTw+IBHSX2yj4paD4C+HJrxeBaeE5qCVc4BTA92z/15KOQfiYYtoZ3ZXeTDXV3cbqjRGWmMUukde/PHRFLFj9xFy8v8PqLnnW7m70CpnIC/XqZjoLoj4ZS9Ugg4vUUxDeAdPLXKb/kyMUkNx6rauEbB/EZccqpNx1dhR5WrLK5QIzqDRfl+J7Zh2LNA2l5OZh4xpxPMIODFEK9/3hEL7kAdgZhRS3UPRjB4MH0ECQDGEVhpX6xGP4cOzHPrVgaaai7Htb8lgRc6gdNav4gzJ33Dk1fRaFe/yOcsTpGWVTB8oqzvS2pkaYMk6eqinNQhkU+s2NyIjWoOBDTKYVOF5BD2gpHB+Ubk11XqE07IoQ7CLFwagZE2azH5L3qvUvB9K5yiep0ddn4o8LKrZiQcSSqvFm/mdOFKbeKMF7k7gYuAnMCG/x5tY+sBnpltZnJaIPqRi7SCYUtii5BbFAkli88bA7tQjoP83xApMza0r7iCcKbhoc69atu9SvoR3A9z2lyi4fl7iWcqE6YAO+8OzQ+b4rXHoA4qm65VILiWWiMdZNm4RG89z6TNXG90litozfmwY3nkp85KzmxkUi3motE5YVSz7U+MaGrxeX86iUgfb7hFvLtLmNHFsD4/c8w+xfG3W7eX9ac1+NhxcJHlTeuTb150T+HtJamhaG7Do/l2ri68O5+0KwtZw2CZtUgifMZKL8u4yPDFDxII1Aa+EXo
 y3DJV6bZ
 esPNb6uruZSuV1LDl2qdFwc9eku2U4toYGDfMK4Kc6GAPyD7a3mtPiai7PoEtMUHKWOP0kWeQjBh01C9nLYozXqLMTuXryCUBtVojGwohWpv1LgcpoVwG5wqHmlxFyWwep/Q02Fi++4mK7fSfVJ5QohAmms8fGpM/OUouRihJ5pyDtiKdAvXTwvarX1S2MfdJh8+4MWaJ1F3opMQDVFZuC2HoiyzWqiBRHVUh6tMKcT6CVfGW91xQPFVbCKXhgdYM12AIsd4yHl7XDQhc3+/wVPAMaPNO/fOSdtgZigsArD0uitxRaZHD2XuW3/xwjpQFVQQdNM9lV9iyOR5KgpoqyrsXe9F9ysmyVjlXK1qSCFrm/E9bFaohjihzg/TOZwTJjNcL9vQFEJ2Xd/f4tjagP2GTUwVOEWlp0yeenC2U2k4/4wMpMMkA86rIovS9Woi6WTfSwVsD3DzSAiWvXzOFWZ6rKCjQjt7ZncNkcvN6fz43Wyo=
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

And jiffies comparison help functions cast unsigned value to signed to
cover wraparound

 #define time_after_eq(a,b) \
  (typecheck(unsigned long, a) && \
  typecheck(unsigned long, b) && \
  ((long)((a) - (b)) >= 0))

When quota->charged_from is initialized to 0, time_after_eq() can 
incorrectly return FALSE even after reset_interval has elapsed.
This occurs when (jiffies - reset_interval) produces a value with MSB=1, 
which is interpreted as negative in signed arithmetic.

This issue primarily affects 32-bit systems because:
On 64-bit systems: MSB=1 values occur after ~292 million years from boot
(assuming HZ=1000), almost impossible.

On 32-bit systems: MSB=1 values occur during the first 5 minutes after 
boot, and the second half of every jiffies wraparound cycle, starting
from day 25 (assuming HZ=1000)

When above unexpected FALSE return from time_after_eq() occurs, the
charging window will not reset. The user impact depends on esz value
at that time.

If esz is 0, scheme ignores configured quotas and runs without any
limits.

If esz is not 0, scheme stops working once the quota is exhausted. It
remains until the charging window finally resets.

So, change quota->charged_from to jiffies at damos_adjust_quota() when
it is considered as the first charge window. By this change, we can avoid
unexpected FALSE return from time_after_eq()

Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control") # 5.16
Cc: stable@vger.kernel.org
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Changes from v3 [3]
- fix checkpatch script errors

Changes from v2 [2]
- remove unnecessary example about time_after_eq()
- remove description of unexpected reset of quota->charged_from
- clarify user impacts and when bug happens

Changes from v1 [1]
- not change current default value of quota->charged_from
- set quota->charged_from when it is consider first charge below
- add more description of jiffies and wraparound example to commit
  messages

[1] https://lore.kernel.org/damon/20250818183803.1450539-1-ekffu200098@gmail.com/
[2] https://lore.kernel.org/damon/20250819150123.1532458-1-ekffu200098@gmail.com/
[3] https://lore.kernel.org/damon/20250821163346.1690784-1-ekffu200098@gmail.com/
---
I checked patch by checkpatch.pl script, just leave result for reference.

./scripts/checkpatch.pl ../patch/250822/v4-0001-mm-damon-core-set-quota-charged_from-to-jiffies-at-f.patch
total: 0 errors, 0 warnings, 10 lines checked

../patch/250822/v4-0001-mm-damon-core-set-quota-charged_from-to-jiffies-at-f.patch has no obvious style 
problems and is ready for submission.
---
 mm/damon/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index cb41fddca78c..93bad6d0da5b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2130,6 +2130,10 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	if (!quota->ms && !quota->sz && list_empty(&quota->goals))
 		return;
 
+	/* First charge window */
+	if (!quota->total_charged_sz && !quota->charged_from)
+		quota->charged_from = jiffies;
+
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
-- 
2.43.0


