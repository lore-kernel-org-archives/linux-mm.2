Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B16D0CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 09:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA14880029; Mon, 27 Oct 2025 05:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51AC8000A; Mon, 27 Oct 2025 05:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67E080029; Mon, 27 Oct 2025 05:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C332A8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:13:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69B94B96DD
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:13:09 +0000 (UTC)
X-FDA: 84043330098.11.86BA0F6
Received: from cmccmta1.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2856F40008
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:13:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of bajing@cmss.chinamobile.com designates 111.22.67.135 as permitted sender) smtp.mailfrom=bajing@cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761556387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=aKw82pXdMpn/ObwzjoSNfbo1FOc45dMx2bgNJuXIiEU=;
	b=j/0DggDXvQB7U5IafbyEvVUHcL4TGVJVuVF7DPUenG4P6pN+yE9kE12dA8nGUzKv7nKJnK
	3wskfhQ6uV9eUZBwyVAWspx1ytZ5gYSdQdnV3xjO4VS/+MEBCGUBx7mEtMYqJR8hrLQ2GJ
	yRgHEioFY38M2vHjwVJVsxZUH6Ni1M0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of bajing@cmss.chinamobile.com designates 111.22.67.135 as permitted sender) smtp.mailfrom=bajing@cmss.chinamobile.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761556387; a=rsa-sha256;
	cv=none;
	b=DcpQNSQdGjVLgTcTzk6xHjJNEeCQDy/H0RpwNEz56ok/Qb9AAEcMJk1fTH9GcNGqJ4Hppm
	x5FpKfr6UYY6OhNKxSh6xt+Qpc9WvMMF3ctEUcP9xIlxkhVgPUNOe+ObWQQZmXKPgnYYkh
	GOg4MYrBs/u7zmCEmfcfzUx8bIlnuSg=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee368ff379c6a4-19fb3;
	Mon, 27 Oct 2025 17:13:03 +0800 (CST)
X-RM-TRANSID:2ee368ff379c6a4-19fb3
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHA-W4100033 (unknown[36.137.216.17])
	by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee868ff37855ca-a4e75;
	Mon, 27 Oct 2025 17:13:02 +0800 (CST)
X-RM-TRANSID:2ee868ff37855ca-a4e75
From: bajing <bajing@cmss.chinamobile.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bajing <bajing@cmss.chinamobile.com>
Subject: [PATCH] Fix the problem that kunit cannot run
Date: Mon, 27 Oct 2025 17:12:30 +0800
Message-ID: <20251027091231.1770-1-bajing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: egdg4e4uig71rpxmc79qz6y4j5m3poan
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2856F40008
X-HE-Tag: 1761556385-599802
X-HE-Meta: U2FsdGVkX19joSb84oDCZ7wGjoVRAysUzZRNeR5vJiB8PU2Kab2PCdkOlMQbzPdhd2zH3bgTS3WKE7tDwCE0cl2d8A4EsAk7oBrlPAezDJQTDyzd9LMF/c/87zxd5NhD5YlxQBjuFDMyaZg4qVp4EpGTtIfiPH2mRXj4FGjxxrC6xiRM9PCuUzGsK9pGZcmk4zeJ7j0tozlshyzM7F5yevp1OLK3jMMWd1oky+5op5bfilrRSO9YjW60BXtnyJjKXAPJ8rLLMXrJXpfF8qGbqooMw5ZBqK5h81vh9wGeaUjk66N0FttmMIEyw+JEYobdwdwdwkxY5PpL4Sh/Wk7wAyAgeJ9xKhRvnSCHRsE0b4L61/1h6bYZoQD+KSHng6HqgZ1YysOb8V9QmrF2mCQazz8hEFjVnQls/mLeJ8QktZGVM2KONWbNr8vWCDM+pXJvXoLwTojRseF68HXPm9Z4UoMyCZJ7/spCS9hHGnXTk2uy+Zn2hNIC3kpwx5hk9hflSmL95S1ECaSo8lCNaegLuvdXEUwuMjRMwxJagcCUeQ3zEyW5NTeyQsbmvCt7l9YAsgU600IzVULtR2OPuDave+MEpwMqSaap0O5B0+doa4YcICL9RmqTPUpmZsDPTOTy4cRzYF5h5fA8a2zHN3TOp0NMHthg4ICM6mtDcy6kkLbhcTu8XFm3Vz/v3BK4c2y57x0vegiUSgZN3788HC/VpLB9jmCLgQnnkMO1LRnCoieSzXR+xjUNedmgQqtRbNRuGhGyd6IaNHiXafpEETg6CsOU7QFEOVSCRQImEEJP7DkSggBt8ehAmXtx0se0Z1fh226MKu1X0aKg73UX/CTGjGQgPbI/g521w6qGmoz2ZOjDr5YPPsnwGdVyJ4e7f+wRgCVAG1arC0SDXWt7HYMe3r9+U34Llp9vfY3+7tXIQATo3nwfdN8F5+KcjPPlGV5e0D0IZc9LUqKu0Gs8r+J
 J9IhFi7l
 ohlnok7bJy0Ky0HvA4hFZXsxQRIM2teD3+EqkhdhnZOHm28K/c6+/WxubWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running ./tools/testing/kunit/kunit.py run,the error for mm/swap.h
is as follows:
ERROR:root:In file included from ../mm/shmem.c:43:
../mm/swap.h: In function ‘non_swapcache_batch’:
../mm/swap.h:66:19: error: implicit declaration of function ‘swp_offset’;
did you mean ‘pud_offset’? [-Werror=implicit-function-declaration]
   66 |  pgoff_t offset = swp_offset(entry);
      |                   ^~~~~~~~~~
      |                   pud_offset
In file included from ../mm/shmem.c:68:
../include/linux/swapops.h: At top level:
../include/linux/swapops.h:107:23: error: conflicting types for ‘swp_offset’
  107 | static inline pgoff_t swp_offset(swp_entry_t entry)
      |                       ^~~~~~~~~~
In file included from ../mm/shmem.c:43:
../mm/swap.h:66:19: note: previous implicit declaration of ‘swp_offset’ was here
   66 |  pgoff_t offset = swp_offset(entry);
      |                   ^~~~~~~~~~
cc1: some warnings being treated as errors
make[4]: *** [../scripts/Makefile.build:243: mm/shmem.o] Error 1
make[3]: *** [../scripts/Makefile.build:480: mm] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [/home/openeuler/kernel/Makefile:1924: .] Error 2
make[1]: *** [/home/openeuler/kernel/Makefile:234: __sub-make] Error 2
make: *** [Makefile:234: __sub-make] Error 2

Signed-off-by: bajing <bajing@cmss.chinamobile.com>
---
 mm/swap.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/swap.h b/mm/swap.h
index 26fa536a8947..04695e1af068 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -4,6 +4,7 @@
 
 #ifdef CONFIG_SWAP
 #include <linux/blk_types.h> /* for bio_end_io_t */
+#include <linux/swapops.h>
 
 /* linux/mm/page_io.c */
 int sio_pool_init(void);
-- 
2.50.1.windows.1




