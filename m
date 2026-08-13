Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E768C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 06:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D474F6B03C3; Thu, 13 Aug 2026 02:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF83E6B03C5; Thu, 13 Aug 2026 02:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E686B03C6; Thu, 13 Aug 2026 02:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6C76B03C3
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:34:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2649E80549
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:34:15 +0000 (UTC)
X-FDA: 85095281670.20.176887F
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 64723C0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:34:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lNMFObuh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786602853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rl6igOnyCyLcIUIdrNjrR0vSvz5V+iB+/lHA2MvB5zU=;
	b=276iTH2GCNATr2NNivdeVqSmyNott/gZ0sF6crkd85AupktCeEGBqJWeLTE2GutYkL0VNk
	UHqEYlSkz8yArLhatUgQQszBWHdr/HO6LlY8fgFtMpUOgSqGGa4KiBU9995Uo7F/L0bbwv
	0DIWGGCoRzoHqOpapX4ANH790p1QG/M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lNMFObuh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786602853;
	b=y8gAs1cerX3fxyuPYevx63tAbDVZ5+KRr+vaGl6OE+4tHe1G/hLNFHcQBn1xGd7H43iFXt
	N1BtMQLrdkD+BjA2OCizFK3kgq3ctZWbz2fdugrqtg183r8LO7w3EJuAI7jfK3NI4i47DC
	4a3/cN7W/rcAgNSbG5LeCwOeoi6UgDw=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so1919983a91.2
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786602852; x=1787207652; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rl6igOnyCyLcIUIdrNjrR0vSvz5V+iB+/lHA2MvB5zU=;
        b=lNMFObuhIxc9bi7rM+cYiUm4hDH+JqJaajiwYg4Y6dMmjXyoZtBsx+ubTo6ADn8/LI
         a9+IntP64kDY2e2cU1RZhaCX2Zij4UUK7eZYAV1EXQ/VIftFzrL9Ax+hQmEZXNXsdlpK
         0a/mUHbUusJyyO5M14CXfM1oJdypZ7J0vi8zDhY3693n8vpPGkthKkYNNDvhB7YoGdKv
         yi8tCq7bXcrV9duuSx9ZQfm39eSXXYEuX/Z5Kpk3dKmZFk4KALaxGMchvG5tDvFVgfc9
         vBdPwFSkOAkWKQJ5l0M7BeQoVCZs6uAWSmfOsTpbesvdBUOTc2SLfKvXrirvwFjc+ecf
         YurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786602852; x=1787207652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rl6igOnyCyLcIUIdrNjrR0vSvz5V+iB+/lHA2MvB5zU=;
        b=fnAhvj4QMhvpKHMgTw4LNEfLU/P/1HlB1O7Z/UtgkHACXAL4Kq1FG33lm9EcbG7nR0
         mPE8+24wK5HcnwXNKl2JrpQY9TV2PFNotGY31VzzbERhNFDqfbwnsplkkGqckN/kZ8b4
         9lpMHplzGlHn6yVpYKFTCaulRODX+9ocLIBJNDJzexCv6aS7JOYBdBzQn6k4bZTigqos
         CZPq2DYGDGoWLKD4MEjNPFmtyV4kI45NJnEH7H053ip+1ms9Wju1NXQBXZfkk1PEevLF
         zHiR8N54la45M7cCpob5e3EvnPnQ2C6q+FrLAHz7GwyUCKsqt5SlQyvCrZdNEHS5ziaq
         FXQQ==
X-Gm-Message-State: AOJu0YwuLxHd0SNEdFmOq/g2AuV7OdL42aquOnsmSrp9rggCqoOanAV3
	+22xdgLmpUCB79zHImRUnDFgZqBSt547PH8WFazk+u7DLCUmR0eKx00o
X-Gm-Gg: AR+sD12QaT9GNKmzNHvN4WQHtlor2gSvX0kUBsSy6YXr5kgQCSJP0kFTtxOmqrLtn4j
	fNyjyrVWBv3agfrkBYfEc+QPrT/9aoiIwhnUYjBf4JK2Um+uhuFgIz1ScMVqMZmHbWrp98IHiGw
	iibK1Hkk5oJY3fgwig9ZMDgy7cFwDY4qmNicfsFkO4SCg1p8TzrzL6M5XAM/cKLKOYkp0kI7dYW
	ZY4OX3YYprpSZr3yrs42MYQAFuEupqhgatYnL0tFX76V8Iw62fskXNdhYVtM15aTKwM+gNMSoSF
	avHETnvDoVqs9qFS12XsEnYXyT6ZKVit9CWZTD7WP5E++1252Y9hjl8pFbfHkwR4fjKiYpB2k7n
	nduMlZZxjByRglV9E4Yojacggp9keqh47XW6vIaHiycS0hvGz7a9AuYoH+jxwAb/BEC1IbFIhnY
	gwDafxZ+iOL9eAu03Y9fuWp3o227yXKGt1g8wnbp3rh2ZrPUvWvxa2bxYYTfmqJp0EkzMjwIKnV
	ov63+IYOsb/RGINV65UZmGuVrmIpD+i89yRkQWQ+0UaE4F40A4Nm4puzwHbvQwG9Q==
X-Received: by 2002:a17:90b:52cf:b0:380:21b7:e727 with SMTP id 98e67ed59e1d1-3931e29780bmr3917272a91.14.1786602852144;
        Wed, 12 Aug 2026 23:34:12 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3931f44dcbbsm1650400a91.16.2026.08.12.23.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 23:34:11 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id A203E15B0431; Thu, 13 Aug 2026 15:34:10 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: linux-mm@kvack.org
Cc: geert@linux-m68k.org,
	daniel@thingy.jp,
	Hajime Tazaki <thehajime@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org
Subject: [RFC PATCH 4/6] selftests: fix build errors on alpine linux
Date: Thu, 13 Aug 2026 15:33:59 +0900
Message-ID: <20260813063401.1786548-5-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813063401.1786548-1-thehajime@gmail.com>
References: <20260813063401.1786548-1-thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 64723C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: 64niwhtxzyoyc467zmhhio9isujitqi4
X-HE-Tag: 1786602853-954654
X-HE-Meta: U2FsdGVkX19tmNLZiTN/Rivi4/xwFpRnQXdZ6rEfR5QwORffw8ZIsdVmrBMcQjcuRrfOgg6gdCozupnJbNM4rRjy6tPOPe0Ty8qCMBUiSXFy39d2DqxaRyMgLScYOcSo4j3cz24LBbIojlsO/gzF2sbm+YOoyHc1R2b03q8PyKfxWXsRyNOsUJ80tHHETM1OSnJCMu5+q7P4Eg/gtVxD/PLxjAC6ABbYkCWEodedXc7Nf3IK4yBVFgiMBCiBmm8yPAhmjjH1W7+hCgSpcbdFTnOTLYEGk0tYTKIwWosw6MeEq5G/qX2txKxf+U93kmT7d0AnRr1giG9gCiv56U0wPLhR0lfMKvO3idtgsXe7agi5SPuKo2wnhRNuA+oBv5nU5Nddw1Vdb96bPjtQ2gHKgxF7QPxBkJVsaam3fPjxK4cUc8SCzuKgABn728HhtcfsG8f6haXfuNaQFANBbolgAF1VlJGBElldvHzkUqwf82QESW5ixtybJZJWZ9TL0ZpJT6+2pYdVR8dZ+gpSoyV6OUcHTctOQLElTdBEgrTGtf/BtFkq+m++HoEzo2q6C0rfpsp8p/FPmeB1Q8DsVmMNnKEAsClA/jPOi2r/Z+p3MEwveMs9NqTJ+qwVvjFBBODK/1p6ecrUf4lxz+BBC9+29SqM1f9S5aUi2uynqEVo+AW8nLN71ZBRSciZ7PZTY0nQX12n3TJUCN4uzj0as5S6N35OAa5V6uAdtjC9iEC+v6pTfu2dygAJWQO+nL2/TPN/fyP/UgQuMDD3waIE2eVFBakpfKkraPFCr99TXFDJ5Kclaul07tKmDf2jr4Lmf8/riWgF0AspCEZfXzjcvAHGPntj0ulvMegUjf18QLDPuBYmZ4S1H91zQD4xwNhFkbcWkmF8W/n3gueI7IcM3TcsWWoLkzdbW2kGkvPjMSRbUsZrVjEATy2vOFmxBfIBucuHtMXo0x030viGZ6Vemkp
 WyB+4p1O
 qdrsu14F3MJtAE4GNzzOCUA5HTSewEuAu9zVqMkTcrMcd3jqQtdDpwNhbKVW4z9rv3fBcwtGnA8OPzCf/CJl0TrHv89CA80EkL1Ah96YuXCSBcHAISXzUJQNcm0VctgQBOlTBbzXIHcCUWtqXztF6Hh3a9C8SnC+nU4vhtJDJwOGfLlPJP5m9NC9BCHckq7/Tf7wH7g2DiipeJyY8VsF0mzHyfkmwgr26RowCLnw7a2vduIjn50hIWvsh7w+MS0tu84jzlDHDN5QDs/7d94CKd0CPhvcFTot82uUrSpoTIIKKDLquggbzqPLGqKPCXj+zSIRyhbzv3VxCkO8/wVZbGhy0DXTS1cXxQZqZNijx203AQDhHhDabc66xCqCUP4kJqz2QbHuO9n0VlEokIXptYQ7Eo6baXIKgL4/MO15OcBKa3tsiP0cR3S121Df4gJL4JNRar7pioc8l2m0QvFQElNUW0Vca8bCd779/a/0XZPKOcIv3iIPfPZhZYP+bSPlfupVuqhd7s2hQ/e3e9fGhCxDOHnK0n48xi4cAWaZRQch/nwjIV9s8rXE9uGYpt4NwriLUAu6wDfsxe8ViGJ+NHZMsLFDUz3YnjpZhvZJGxB5E9OEvgW/jBff1zYbTl6CMGznuEoIzD839na3Z4DnRtZhMv89CMndUYh5CyiXpXwV3JqkrfmFX8I2SZlnydby2oZ60
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some nommu architectures only work on Alpine Linux, which doesn't use
glibc for the standard library.  It uses musl-libc and is implemented in
a different way as glibc, resulting build failures.

This commit fixes this issue by adding missing definitions. The fixes
are now only covered to TARGETS=mm which was tested for the moment;
future contributions are needed to fully build/execute tests on nommu
platforms.

Cc: Shuah Khan <shuah@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-um@lists.infradead.org
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
---
 tools/testing/selftests/kselftest.h      | 43 ++++++++++++++++++++++++
 tools/testing/selftests/lib.mk           |  2 +-
 tools/testing/selftests/mm/hugetlb_dio.c |  8 ++---
 tools/testing/selftests/mm/mdwe_test.c   |  4 +--
 4 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
index ae18c491ae53..ac21bf3d802e 100644
--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -58,6 +58,7 @@
 #include <string.h>
 #include <stdio.h>
 #include <sys/utsname.h>
+#include <stdint.h>
 #endif
 
 #ifndef ARRAY_SIZE
@@ -81,6 +82,48 @@
 #endif
 #endif /* end arch */
 
+#if !defined(NOLIBC) && !defined(__GLIBC__)
+#ifdef __LP64__
+typedef int64_t __fsword_t;
+#else
+typedef int32_t __fsword_t;
+#endif
+
+/*
+ * for a workaround to avoid struct conflict under
+ * musl-libc (<sys/prctl.h> v.s. <linux/prctl.h>)
+ */
+#include <sys/prctl.h>
+#ifndef _LINUX_PRCTL_H
+#define _LINUX_PRCTL_H
+#endif
+
+#ifndef PR_SET_MDWE
+#define PR_SET_MDWE 65
+#endif
+
+#ifndef PR_MDWE_REFUSE_EXEC_GAIN
+#define PR_MDWE_REFUSE_EXEC_GAIN (1UL << 0)
+#endif
+
+#ifndef PR_MDWE_NO_INHERIT
+#define PR_MDWE_NO_INHERIT (1UL << 1)
+#endif
+
+#ifndef PR_GET_MDWE
+#define PR_GET_MDWE 66
+#endif
+
+#ifndef PR_SET_MEMORY_MERGE
+#define PR_SET_MEMORY_MERGE 67
+#endif
+
+#ifndef PR_GET_MEMORY_MERGE
+#define PR_GET_MEMORY_MERGE 68
+#endif
+
+#endif
+
 /* define kselftest exit codes */
 #define KSFT_PASS  0
 #define KSFT_FAIL  1
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index f02cc8a2e4ae..2cc819006424 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -197,7 +197,7 @@ clean: $(if $(TEST_GEN_MODS_DIR),clean_mods_dir)
 	$(CLEAN)
 
 # Build with _GNU_SOURCE by default
-CFLAGS += -D_GNU_SOURCE=
+CFLAGS += -D_GNU_SOURCE= -D_LARGEFILE64_SOURCE
 
 # Additional include paths needed by kselftest.h and local headers
 CFLAGS += -I${top_srcdir}/tools/testing/selftests
diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
index fb4600570e13..aee6be530ccb 100644
--- a/tools/testing/selftests/mm/hugetlb_dio.c
+++ b/tools/testing/selftests/mm/hugetlb_dio.c
@@ -22,12 +22,9 @@
 #include "kselftest.h"
 #include "hugepage_settings.h"
 
-#ifndef STATX_DIOALIGN
-#define STATX_DIOALIGN		0x00002000U
-#endif
-
 static int get_dio_alignment(int fd)
 {
+#ifdef STATX_DIOALIGN
 	struct statx stx;
 	int ret;
 
@@ -43,6 +40,9 @@ static int get_dio_alignment(int fd)
 		return 1;
 
 	return stx.stx_dio_offset_align;
+#else
+	return -1;
+#endif
 }
 
 static bool check_dio_alignment(unsigned int start_off,
diff --git a/tools/testing/selftests/mm/mdwe_test.c b/tools/testing/selftests/mm/mdwe_test.c
index 647779653da0..031c79ed067e 100644
--- a/tools/testing/selftests/mm/mdwe_test.c
+++ b/tools/testing/selftests/mm/mdwe_test.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include "kselftest_harness.h"
+
 #ifdef __aarch64__
 #include <asm/hwcap.h>
 #endif
@@ -14,8 +16,6 @@
 #include <sys/wait.h>
 #include <unistd.h>
 
-#include "kselftest_harness.h"
-
 #ifndef __aarch64__
 # define PROT_BTI	0
 #endif
-- 
2.43.0


