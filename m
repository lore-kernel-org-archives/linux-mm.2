Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61CD7C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44A846B0099; Tue, 28 Jul 2026 16:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 428CC6B009D; Tue, 28 Jul 2026 16:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F026B00B7; Tue, 28 Jul 2026 16:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E0166B0099
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:47:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97F4EA1739
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:47:40 +0000 (UTC)
X-FDA: 85039371480.18.8801430
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id E5858160004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:47:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y7PmEOw4;
	spf=pass (imf08.hostedemail.com: domain of jakovnovak30@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jakovnovak30@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ytQPuk/Djc/IdfIxup0S/O4J+teQ2GhQjH2sKJeJZ5c=;
	b=xM4UAoVVnfs1cKqT8O2lAPCy1xWjt5Yfkv6Y3WTxuY6iVB0y/JSyhYgYgt6uKZZCz/BEQw
	Ucf139NXE4kULVPGEqOBBLn3XPEQND0QBNCdMrviST9tbWwd+JMRJIdLfQNWInN/oOHitl
	gNtYNPrL9vpqkN+75lGK+SgXJuw6gv0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271658;
	b=jfC4Ln+IfeCdvaKYS8j5+4Y/naS8i8eQUE7KvDwtmAu5Qr+zd2vQ1+zPFa5/diahheFFvW
	UYPyOGREAhRt+JeQHw+Ky5JlUJT4YWDl6ffd+084v7CZmFOwQxe7kjTbm0WywyEsrOJfXL
	HekX9qlIS2bpdlB3cJ2/3exTIBVSZGc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y7PmEOw4;
	spf=pass (imf08.hostedemail.com: domain of jakovnovak30@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jakovnovak30@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4954aff6088so2360695e9.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785271657; x=1785876457; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ytQPuk/Djc/IdfIxup0S/O4J+teQ2GhQjH2sKJeJZ5c=;
        b=Y7PmEOw4L1grNJGQ81D1QXGMQbB9ZzDGkOaHddbhbeZUyQGrk8lGP8j0DMa9Ow2l1d
         zaXm6/n8UFxMdJUwFtS4CPXDCjrH6QuASAuNjTj/GybOjRx4E9bDQsbXxL0txMcicJ49
         gulUOk/3lN/HUTtHlOr6evtiPkCGfVkpbY5ViOFJBFG1wJDDoxIQb7FBYQmO+jReESi2
         37JL8tF1fd+RNLy/bHrHGoSEF/zpChjbhFmDyZnWON3cvGtd3mOyaZSaMO5Qns1yqTWy
         0fgmOsytJcvh563cLP2hEnlCn9VAq1N0RlU3Lm2VuVmFRq+pKi2NQIQKd5Y1PXQNA1ml
         Nl6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785271657; x=1785876457;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ytQPuk/Djc/IdfIxup0S/O4J+teQ2GhQjH2sKJeJZ5c=;
        b=eNSWvwXcYdFDlh3U5pWfS5P8JAW1j4zLVRpijKG0wZX2OeYMTBn9kKwnMIc/7mlmWB
         wCfVFyHvDZiB6hxa1bMys4/+rP/kTiPnF9BiyNVM9t4loORbCsWZ/dbkQn3bFnwWbJRM
         XXaA/89A5IVDBxbAhwcUlqHfviORnd9nwbQyIlzgz2OU2XRiOGvQVI8enNUvfa5Ozqj4
         4+p9r9N3xk+aJ1iJSnx9cIokWNgRBqSvB4z/4bN12hnPSgAL5Trcgbcj86Bqg01NYFd6
         lqoQEMAIl3KrBOLLe+HgZ/a/wMSNLynfdeWGfbB400q8rh0nyDx/whWDaBGRpoxLhvD/
         Sn1g==
X-Gm-Message-State: AOJu0YyOUaYdVh/AWqr9a8+OGzWg1d+rFv/VpfuI1WRB536UwEBc8j+B
	x4Meju3yA7d/qXH405fI2Ln7XIBASyohjWPXselDAyceE7/U2k6g2rAstLe4FkI=
X-Gm-Gg: AR+sD11OGgylRtwxQ24ZeNXKbU+LwMZbYPLgH2k23JoYFa4eBN9PEwwujr3kj4MaROg
	gui8S6XRVdgzWXk9S8c0AY9r2Ig7g4H1jF2e+tzRcdFtRdfDkz5b7qoVXZLsRvtZAKhdR0INmpl
	K9Z3iMv2c9Jdsx+njBE2BHMxoAVvpvnKryudltpnPQf+fYhMaWgLEM5nrCrHOTctb2iAGDZpVaZ
	zREqfJQgkzyNSH9HAdNaNyouCZHvgOSuUt+bhGiu6qTGHby5Ppc1iaT0fwICJCVO+HZbUwEu8YU
	LPlatYnjNMq/1jKvxdu7g0ZoqsWrzccCIC1GE0ShOfD8Ylz4vq0HYQQDt3/cIxrvwSpz1fuTQWJ
	ouCRxeZmu8x81tELVghUJ9v0rGZ1DVAyzi2qWGmFVqGgwskjvKWRA+qEQrumzPN1xR0wt5t3S71
	VhR351b5rt/zLkx3qBAjV/sdpfUuFpenQ9ZY4X0J0v0ZbqOpuWHNrHilHae6mLQlEen9y4ARdNo
	+vQBKqe0SDD/gIrIcxsZjsaYNM8W73ZmU4SQTf0K0nKjan1aMKzFHHp6fsLoegdFwkwQqwUPqgd
	tdbN4rSApAsx+QAdiyOuc2gD4g==
X-Received: by 2002:a05:600c:4fcc:b0:493:bfea:2780 with SMTP id 5b1f17b1804b1-496c643b124mr46776785e9.9.1785271656377;
        Tue, 28 Jul 2026 13:47:36 -0700 (PDT)
Received: from archtop.localdomain (92-242-249-25.broadband.mtnet.hr. [92.242.249.25])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6b27435sm1709418f8f.35.2026.07.28.13.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 13:47:35 -0700 (PDT)
From: Jakov Novak <jakovnovak30@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"\\  Liam R . Howlett \\ " <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jakov Novak <jakovnovak30@gmail.com>
Subject: [PATCH v2] mm/khugepaged: replace mutex_lock/mutex_unlock usage with guard macro
Date: Tue, 28 Jul 2026 22:46:37 +0200
Message-ID: <20260728204636.20998-2-jakovnovak30@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s1nuigk6uopj1j7zhidjq9dmrfep6wqa
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E5858160004
X-HE-Tag: 1785271658-234873
X-HE-Meta: U2FsdGVkX1/uNrNsF5JoITCkOUI4EvEUyK/2uAcpee/phRE+dV9HxyFiNWEPaVxroFynzuUtAELwyZjixgSHMwauRKhcn91kzzDR6MDb51eo3dTLees/ach3BKUEPWHwx9MAuZ+oBAcebjoOzuJ3lB/FQFYbkp4RwVC8ZIFVisr7r0vBwr+pHBxbhv0Wwg2P1qxYIQ1WMEbu5W3j/9kNcd9ViPhx34cmQXgBnZWCVzWmrHQ4QC4WTKp7gL3ALfjYLUJvNLqJEKUzpRdSROf5v98nX4eD8vYmGYpEcMQ1mdfIlXy03YiPUhk72p/2Yl8BVmi+dJE/QGMKAKolzSmj8GV2Noww5fZF79zSjNT8h7zi6hkB9kSbjohycm/QiXtlTomeod2QSa0YxwhEbNayJCb7itamTZ+whIBrTul82pUNa/vt9Vl16FboBBpl07AD20dn8DrEWhqbB4/CK4idc09ffBlePKFcY1ndvG4SPFvpJD5JR6MeYhG/QAYwbWM+HnuKvuDkFnbDE6o9WMb/evzG0ATkR2MrOOLSIi9Bor+4ScMXgRq+wia+ppidP7pa5B/bHmVybgebq486bsrVh+KjoZUZk8P8u1drYRDgzMmFReSFcUCdr+FuBiVSL7XjPHXYalQ4tWeR3Sd6bHoh8zB+W32nP6SyRXquKCOyhOpZZb7xv3rG4yjvBVyk0Y8RFDe2mt6Npa3F3q187yQKFr7dQ/NW0gA1j/pCA8KComxKxy0iG85QCtsMy0mZzRgRXvgOy74zgPVbdfxc58g/Ut3bXSE9MhNUwohiYQKhp6rkXBa97yxY7kbjzdQGF+5BY5HkSUIx19Q7h0yfaQxx37HJiFfOWLwc7zLtJqalSRJWs0CuY8djpdvY7Myl69pF6RXS2VApNAZyXQDRTEpL252CCFk/14rC/VGqNNypG4CVh1aWmyrjqwrSIMUrx8kBgt/azQsu66U2trvgWYM
 NxNj4a7I
 dkWTnNUqTVwwBE/FPQ7FpHMs3WxVXL8xphfXAUhBA94gre1hpbLPrjKwLYf0ze1rSMRlH3rODiaJVk65pBHdN0wGZtGQkepoAdpc/ShQzZdeVBgPOkxbQtJ8Uit9cfso6OGyg7tPpLXDQEhOZ02xjcWrzcogSmVl9ZKx1OEOO/F41tFVeCmaeodYEuZMLEOOGoIU8n4Y0ahRuAV3k4pC8J0D7QcEmTLy0u5ut83j4B1jJ/CFkgneYYnbf1FAGpwRQJbVTHEA/4o1Y/+29CADOxxwfAc6k1JVEiX/bH5trL2avF5cO5GOKUQZP56CpDoKUkfYwRgG3cehTPTjgISP/idoYrvoVWVQbQoBSJ4Yp5PhqOIC7KRsV99QBg4GJQ0IYvAb3MuWE6Hs/SOkpAMAOmczBnBfdD3vVKHjboFLiBz8+QqPfHrOmexpfk9cGJxmPx015F2ZOGWv28EC/OqTZYvRUAsBMcpUH0qv664pzqMezZvzRxVFZ7cNcYkoV+FMTrsM18PH8Adaykofex2GxOb6xmj+QonZI12bV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, khugepaged locks the khugepaged_mutex in two functions:
start_stop_khugepaged and khugepaged_min_free_kbytes_update. Remove
mutex_lock/mutex_unlock usage in these functions and replace it with the
guard macro. This makes the code more readable (removing a goto statement)
and makes it harder to introduce bugs in the future.
No functional changes introduced.

Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v2:
  - Added #include <linux/cleanup.h> to the includes at the top of the file
  - Moved err declaration to the scope where it's used in
    start_stop_khugepaged
  - Made default case return 0 instead of err in start_stop_khugepaged

 mm/khugepaged.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 617bca76db49..7890bd3e2a9d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -23,6 +23,7 @@
 #include <linux/ksm.h>
 #include <linux/pgalloc.h>
 #include <linux/backing-dev.h>
+#include <linux/cleanup.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -3111,18 +3112,17 @@ void set_recommended_min_free_kbytes(void)
 
 int start_stop_khugepaged(void)
 {
-	int err = 0;
-
-	mutex_lock(&khugepaged_mutex);
+	guard(mutex)(&khugepaged_mutex);
 	if (hugepage_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
 		if (IS_ERR(khugepaged_thread)) {
+			int err;
 			pr_err("khugepaged: kthread_run(khugepaged) failed\n");
 			err = PTR_ERR(khugepaged_thread);
 			khugepaged_thread = NULL;
-			goto fail;
+			return err;
 		}
 
 		if (!list_empty(&khugepaged_scan.mm_head))
@@ -3132,17 +3132,14 @@ int start_stop_khugepaged(void)
 		khugepaged_thread = NULL;
 	}
 	set_recommended_min_free_kbytes();
-fail:
-	mutex_unlock(&khugepaged_mutex);
-	return err;
+	return 0;
 }
 
 void khugepaged_min_free_kbytes_update(void)
 {
-	mutex_lock(&khugepaged_mutex);
+	guard(mutex)(&khugepaged_mutex);
 	if (hugepage_enabled() && khugepaged_thread)
 		set_recommended_min_free_kbytes();
-	mutex_unlock(&khugepaged_mutex);
 }
 
 bool current_is_khugepaged(void)
-- 
2.55.0


