Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18DDCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 10:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756656B00BE; Thu, 21 Aug 2025 06:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706F06B00C4; Thu, 21 Aug 2025 06:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6356B00C5; Thu, 21 Aug 2025 06:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48CC56B00BE
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:12:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9FF05888E
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:12:14 +0000 (UTC)
X-FDA: 83800349388.19.1E841FE
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id DA4CCA0011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:12:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lUm1pgFs;
	spf=pass (imf15.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755771132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jOIaU+ivLyUInrFo1z4/NdrgXjFotuRBDXDYangsfLc=;
	b=d33ostUz2HU03ThoZ7ZTHZ5Ganvdk/VwmD79uUStqtKfZre65X0hLkH0ZsBU8HJviNs3an
	hQ3iMofkcHyU2QTZqzM859cxladPglyxmv8SNMK9ASNnp0if6y47HVBjp+VZCLchHXUVDr
	UXv3o5G7iCC/ntFF1bOXdLlrUVYcAfk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lUm1pgFs;
	spf=pass (imf15.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755771132; a=rsa-sha256;
	cv=none;
	b=ZvawC8npQIIg5FFxVnvC8Ed0ZjTCT90RVkdzZVL+eCgyChr57+Hk0t6UGOQNgEeqLMXz++
	fydp8HUK+jF7oyy54RYVn/9twxKZqTDEGKK6k3KAugfRSagHfwJFMzMjvXfowAsVioYCp3
	18KOz62mqpN8dppoAa4kiOlUPpA4GZU=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-323267b7dfcso791881a91.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 03:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755771132; x=1756375932; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jOIaU+ivLyUInrFo1z4/NdrgXjFotuRBDXDYangsfLc=;
        b=lUm1pgFsbRXRXyZaLMN2VkhPI5N0RfjDaCWXuQqr4699xQRml1v2iCXzDM2DLvLgOl
         NkZIErR6z1q8G9G5Aaqfuvq09NqZRoKqZ3Ba/oWv5xOl9h1gDoB7b7uKINtcd1Cr6RzQ
         XyojvbUokaBwoVhnX8it0KMjYF0NEI29rrVSrUdAku9mCqys19XA6IWQs09YvG5C/bB1
         SDYFqJ3YCVW3bFqaUCnVOAdMKMzY24+vyWba/q1cPFHPb0n6zLlpGvCsD/rOmlQcMa/9
         KgycSYR765N7Mh3479t66qv4goTb/b5kh/O9zbLm/nHQ+qlMo9+SkQCS+uyLuv5hFMvm
         Mh/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755771132; x=1756375932;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jOIaU+ivLyUInrFo1z4/NdrgXjFotuRBDXDYangsfLc=;
        b=t96A0czMsFByE+xueJ01oTD/HSVdFH74ChA8N6tVJHwGFB85Pyn/+Ur1GDI9fOWilm
         ON9HPQB3B/mORdoG3Yu6pWHgb8GuumB1JggLN+fgK0IU+u5XjZbRuUzxeJr8vrsi+aSA
         lJoXZ7fFityfo+8miN3FGpMvBi7W8huW/WyORaYv4X/TBxq6P3Sd36F7hS/ZtLKnawpn
         YtLx8bq6m+hLrNPBs6/ZV0mpEi/fc0DEsdIvN1EeeeLpTEMjyesUqBwu5LVwL90RUKnp
         l+1Vs0CgH78h8YqWt5YTuTWcfwPuicCNTR2Vd++xzTZwK0Xf3lIBn+tBUIGQaDW254v4
         pzWg==
X-Forwarded-Encrypted: i=1; AJvYcCXNm/peluWswwXxneccobkwM2mzce9bZsDc9WYdOgKPCbaoeofsmqwkxglkLywlBzdjpRElZj3OWQ==@kvack.org
X-Gm-Message-State: AOJu0Yypv/vyU3jRUSSx/HJ9L2KZy9nFZjNp8BjH8bqeMdfYpj2Kfhgb
	bPBPb6DqR/wfCw2TA6vVgTd+e4oAySBPjuw7VpoKLm6M9i8Zb4R5DA/Q
X-Gm-Gg: ASbGncujYvYzN9injLfoWbR1GLTGwpaKo73vAYl3qdzP/wLXy78VK/QtXRMQvJ1EO0f
	IHkNXqlWN2Deg3cr9tAmJsSkA+w8xAeo1Y33JZPo7Hi4edatnvkRgberdRprfmikmKlkmVlq4BV
	kYKDMXDynqzQski4Gf+SwyPjCdhClZ1NuRSBJBshUfcC4pFiTizUgcmkOKszy3ts9V2cjjcXu1v
	fwtaCAVXUnpppjTythaP4T4dSrVJlB6bXSFvUiT7YMW3jgGROtA6dkeIDun0DvqYRKSp6dEd6CU
	1NcnI5aquqFEvc8I82bpDj/cgSocY9vzqhdZzJIxA31mDQflMOHma5NvQEvKM4HFsyoZLKwBZtH
	UjxoJMnxG0bZUnTHo0CmNDu65DFOtgz9MeA==
X-Google-Smtp-Source: AGHT+IGyEK2exr+k/V0w8XXUmSIzv3Ytbu6vvsSe7eRwRcTsYn2OH5a5icQQPi/utnU7cQhUneD/0w==
X-Received: by 2002:a17:90b:224e:b0:323:7e80:8819 with SMTP id 98e67ed59e1d1-324ed15d2c5mr2462627a91.36.1755771131489;
        Thu, 21 Aug 2025 03:12:11 -0700 (PDT)
Received: from server.. ([103.250.145.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7ccfa8d1sm7835815b3a.0.2025.08.21.03.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 03:12:10 -0700 (PDT)
From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
To: akpm@linux-foundation.org,
	shuah@kernel.org
Cc: mic@digikod.net,
	gnoack@google.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	ming.lei@redhat.com,
	skhan@linuxfoundation.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	reddybalavignesh9979@gmail.com
Subject: [PATCH] selftests: centralise maybe-unused definition in kselftest.h
Date: Thu, 21 Aug 2025 15:41:59 +0530
Message-ID: <20250821101159.2238-1-reddybalavignesh9979@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DA4CCA0011
X-Stat-Signature: cfjaeo5epqhpi4u7d4u5qw8cuwicamwu
X-Rspam-User: 
X-HE-Tag: 1755771132-420073
X-HE-Meta: U2FsdGVkX19cPBjpKVueK5MPkt+B0p1B6vjuAmN4jtg2JnNR6pSQLHi49rNgCIM6LvnBtJxtWStU7avvVWw2XPNQSC3KZAQJqLnl6E5nW3eDhfjPPXhyAmcKIkE4wQr1pkiKG6x7SimgTdAAw67wnnhZ88gtuR5MX0Eh5WBJ2LgIHzzMMZ148U3tBRmQofuhTb0GxFV1hhRwoZcp6yPt122zbCz9/CjfuzK7SNEB5S1+k4RvFdE0s0WBplQWolv3LWiFkn+Rs9G8fApjvoRInnih7ftKxZa1cNbnN6qIGS+h8xno3+45zVr8ubxkpX9MXalKnUHxNxZQ1E1si6qERk1r2IJzY3/BjbP3mY2FDq8ogm5WRnH/DQ+180bj/BI7w3P1jxyuzZyv+VyhHFgdxoDgKQdTIueSVsu2vHbUVYMfb7wDyQ4KUBh1DvfLllU5lAjSOXyj5qtbeO04CZW54L5hW7oooGQFGjCsf1OoM+8GU4q+Xkkv1mqCeqTKLHgc61f6poH26KxZ1csfKVBGkPX4i5RrglM2ulyHfsI3DtDkm9zq2tI9fZ0tbiGZ3FqLjzbdmbdb+1uAk4BZYnKrZMj666fntTG7lwLr+kUxxM0ntRjHFetP3uGXI+hC9PogURLkbzIdhcx8xVXhsEPrB2/xONfj+7oBJMyMTGh01LAv3xeFx4rSppo9wkjZ0fGyazNBBw9jtw+d7iLXs8Ksv+ThgVWEh0CZ1weBOtAXn/gY85wkt9pvuesGu6wGacPV3TO/gdimVyVaIPdzdPu3AWlnAygeqv3H7P1F/Xd8jyYkE8fRM1bxmEzdoApMmOb3wMqxGagmMVj576r0BLenbajpHIe+OgGq8Os4P6mLRSrWsFJh3RvVNPD2Z/KVRaGAJ5IKikS/RdTHtwClnRKfC1w1BGZ3lLJNZJV5OxYHw0HgYaUg1LR+/VXaDkj4hiEm1FEgxSliUrE0i2+0hyv
 aIIkU53f
 aeMR73uX2itfVPxd/psTHIULy7epxs+D+6iZUqgZzLQgyvMKx/z8JIxv39BN89NOWGu6J30NaWtVBBB/m1joXLYYvEqBQA5oU720RIiVAvBlr2Wisno09meVazIZOvVwWVmywqyzmjcZn0KAUlEYrXy7xdOczaaSCQKEgIQtOhOZDFcOgKuwEuueL/W1YaNFcAu95l15hcO/tk/RFh6aVD0oDirWuru2VBJwBqcreWGY2oDpEpxdk2hXipiak10WDdPHOQWV0uFNjJvUi8ZlXlYlvpmOc+IHAPfZEh1xjKcxMmi+bk1aRVqAbkuhSuZg27zV/0xZwov4fesB6niW+f1kgrukNOIBhTyw64ALDkxWk95FNnbPMIuJU1TSugPTvulC8/cbrGcV7U51Y55q0uGbGP0u1GrsKKjluSwXJyWMR0+hc39Ghr3ooYgEegBYPIjWKVJvxIZ9bwK0MZykVjd/x/s+erItoeIhYKTJ2OKCpNX88lv33NqQzFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several selftests subdirectories duplicated the define __maybe_unused,
leading to redundant code. Moved to kselftest.h header and removed
other definition.

This addresses the duplication noted in the proc-pid-vm warning fix

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Link:https://lore.kernel.org/lkml/20250820143954.33d95635e504e94df01930d0@linux-foundation.org/

Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
---
 tools/testing/selftests/kselftest.h                    | 4 ++++
 tools/testing/selftests/landlock/audit.h               | 6 ++----
 tools/testing/selftests/landlock/common.h              | 4 ----
 tools/testing/selftests/mm/pkey-helpers.h              | 3 ---
 tools/testing/selftests/net/psock_lib.h                | 4 ----
 tools/testing/selftests/perf_events/watermark_signal.c | 2 --
 tools/testing/selftests/proc/proc-pid-vm.c             | 4 ----
 tools/testing/selftests/ublk/utils.h                   | 2 --
 8 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
index c3b6d2604b1e..661d31c4b558 100644
--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -92,6 +92,10 @@
 #endif
 #define __printf(a, b)   __attribute__((format(printf, a, b)))
 
+#ifndef __maybe_unused
+#define __maybe_unused __attribute__((__unused__))
+#endif
+
 /* counters */
 struct ksft_count {
 	unsigned int ksft_pass;
diff --git a/tools/testing/selftests/landlock/audit.h b/tools/testing/selftests/landlock/audit.h
index b16986aa6442..02fd1393947a 100644
--- a/tools/testing/selftests/landlock/audit.h
+++ b/tools/testing/selftests/landlock/audit.h
@@ -20,14 +20,12 @@
 #include <sys/time.h>
 #include <unistd.h>
 
+#include "../kselftest.h"
+
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
 #endif
 
-#ifndef __maybe_unused
-#define __maybe_unused __attribute__((__unused__))
-#endif
-
 #define REGEX_LANDLOCK_PREFIX "^audit([0-9.:]\\+): domain=\\([0-9a-f]\\+\\)"
 
 struct audit_filter {
diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
index 88a3c78f5d98..9acecae36f51 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -22,10 +22,6 @@
 
 #define TMP_DIR "tmp"
 
-#ifndef __maybe_unused
-#define __maybe_unused __attribute__((__unused__))
-#endif
-
 /* TEST_F_FORK() should not be used for new tests. */
 #define TEST_F_FORK(fixture_name, test_name) TEST_F(fixture_name, test_name)
 
diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
index ea404f80e6cb..fa15f006fa68 100644
--- a/tools/testing/selftests/mm/pkey-helpers.h
+++ b/tools/testing/selftests/mm/pkey-helpers.h
@@ -84,9 +84,6 @@ extern void abort_hooks(void);
 #ifndef noinline
 # define noinline __attribute__((noinline))
 #endif
-#ifndef __maybe_unused
-# define __maybe_unused __attribute__((__unused__))
-#endif
 
 int sys_pkey_alloc(unsigned long flags, unsigned long init_val);
 int sys_pkey_free(unsigned long pkey);
diff --git a/tools/testing/selftests/net/psock_lib.h b/tools/testing/selftests/net/psock_lib.h
index 6e4fef560873..067265b0a554 100644
--- a/tools/testing/selftests/net/psock_lib.h
+++ b/tools/testing/selftests/net/psock_lib.h
@@ -22,10 +22,6 @@
 
 #define PORT_BASE			8000
 
-#ifndef __maybe_unused
-# define __maybe_unused		__attribute__ ((__unused__))
-#endif
-
 static __maybe_unused void pair_udp_setfilter(int fd)
 {
 	/* the filter below checks for all of the following conditions that
diff --git a/tools/testing/selftests/perf_events/watermark_signal.c b/tools/testing/selftests/perf_events/watermark_signal.c
index e03fe1b9bba2..b3a72f0ac522 100644
--- a/tools/testing/selftests/perf_events/watermark_signal.c
+++ b/tools/testing/selftests/perf_events/watermark_signal.c
@@ -17,8 +17,6 @@
 
 #include "../kselftest_harness.h"
 
-#define __maybe_unused __attribute__((__unused__))
-
 static int sigio_count;
 
 static void handle_sigio(int signum __maybe_unused,
diff --git a/tools/testing/selftests/proc/proc-pid-vm.c b/tools/testing/selftests/proc/proc-pid-vm.c
index 978cbcb3eb11..2a72d37ad008 100644
--- a/tools/testing/selftests/proc/proc-pid-vm.c
+++ b/tools/testing/selftests/proc/proc-pid-vm.c
@@ -47,10 +47,6 @@
 #include <sys/resource.h>
 #include <linux/fs.h>
 
-#ifndef __maybe_unused
-#define __maybe_unused __attribute__((__unused__))
-#endif
-
 #include "../kselftest.h"
 
 static inline long sys_execveat(int dirfd, const char *pathname, char **argv, char **envp, int flags)
diff --git a/tools/testing/selftests/ublk/utils.h b/tools/testing/selftests/ublk/utils.h
index 36545d1567f1..a852e0b7153e 100644
--- a/tools/testing/selftests/ublk/utils.h
+++ b/tools/testing/selftests/ublk/utils.h
@@ -2,8 +2,6 @@
 #ifndef KUBLK_UTILS_H
 #define KUBLK_UTILS_H
 
-#define __maybe_unused __attribute__((unused))
-
 #ifndef min
 #define min(a, b) ((a) < (b) ? (a) : (b))
 #endif
-- 
2.43.0


