Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90489CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 14:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F496B0095; Fri, 15 May 2026 10:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06DD6B0096; Fri, 15 May 2026 10:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6A66B0098; Fri, 15 May 2026 10:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBB4D6B0095
	for <linux-mm@kvack.org>; Fri, 15 May 2026 10:34:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D2AA1C0036
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:34:40 +0000 (UTC)
X-FDA: 84769900320.06.4B7682B
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 403D21A000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:34:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VKPchynt;
	spf=pass (imf19.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778855678;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqcNYtqXHyuBuoGn/lDUKrSEtntd8NaZhDAVmVgi+Po=;
	b=I1d4aWGgxRi3d5WW/mkIEOQPts9uae7ub24XSrjqmxwnaL+quRpi5P2gkoRJID86PZ/MnF
	eFm6t3Pi1/4fV567oZe4j9mdZAfAhAMF1Xgq2lbF2IQkPLKZccF6CigBen/gFqulsbvYK4
	ijPrdToLBIIQWiHVZqpf7iWX+RX23lI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778855678; a=rsa-sha256;
	cv=none;
	b=5dj10WbdePnWcSy4bCIVUYxzxzCRoEfxy4nfGQlsPGSYWHLTiAtKA2jgt7FxKvPjo0XPTS
	UkepEMhdthQJ7uC5m56PfLfnkde2VcDpQR550uurbAOMfnPq1oaV5d7os1XNxpDGoFXjnL
	uU3tMeVJuoN033dn/NumcqALbFyT2+s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VKPchynt;
	spf=pass (imf19.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-444826c16ffso7722781f8f.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 07:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778855677; x=1779460477; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eqcNYtqXHyuBuoGn/lDUKrSEtntd8NaZhDAVmVgi+Po=;
        b=VKPchyntlOAZsjUBRNAQVzDBqnjZsXj8rtsjEcokC+Agf1tGeHidBJ/t+aqVdf7N92
         zHB5AUhmFlZi2HSs3eE14/6b6mk9CIXlUL0wjx6ZmGzEjjDUHXwlICFfZ2b64k7bCXqZ
         OiOAgvnrFORYpQRIrOxvgkhqjpkvjWI24RJNai1Gbw5fvUWvm+GsCQRwYhNp8N1cnLTC
         tq0TFNq909TlQkt9D06u7F3ymJ/k5HR+e7J3NJGRO94RZzYk8cfzGU+A/sgZ6L2dFJVp
         WhOMOgIQfAY5kX4gCuB8DFGJmNmcHh1cNcqNsKBYYKZn2msD1uB8thvpBHK5/PWZxB0e
         Vkkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778855677; x=1779460477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eqcNYtqXHyuBuoGn/lDUKrSEtntd8NaZhDAVmVgi+Po=;
        b=IcDqpYP/3ZnHygnCjQTP7H7lNWldmlqzU1/6xbKV/KYFSfIdMzTO7aKXWssXQ/ib1C
         1/h09WMZMDAKKGl0E5RO0McgVZ7VAJLOXZXubtOY6LBKniqNDQrb3kRDL5qz67zqE+/U
         Se9ZviFeCXJBu1UNG2sSjQoIMSStpFxMXjVC6G7ctP/3EmdC/egYcIONfeJ5Sm8yWW5B
         zSbA4sb3T+aWx7HFN544WLEXvwPVMMrYADOk89KjPDCWAV5cIcr9/9sJcR1hQlk/z6cL
         xqsQ/zhKG7g1S6kl38iHnCr03NqxCNv+yqZWLlig9gpf/JZ36C022Ktm4dOFlds17qH+
         4Wrw==
X-Forwarded-Encrypted: i=1; AFNElJ8lODqDLrgP2mVlow/8AHjG0CO7twSEWZ490kiozod6+SiALatdfBtnlnwgxiy6NoqmOFY8STYkzA==@kvack.org
X-Gm-Message-State: AOJu0YyZZKzqkDm5fUs4k6R682UfHnY5itgH7aCOGRg6L9GG9kZ1RuYr
	1qTVVEKx3mOVqn2ssNdb/sKZVnD3x5zHirtKJBXXkqdgE1jELWjVcF3h
X-Gm-Gg: Acq92OFKrdyUjQX2tpqC7JC7XqYXVIh2iU8aRJg0si2byvy9n5rdmqaMILKgG7/gHCA
	3dkYHwnuyBhrd1tIrPWakM8jUKbWhCc4dOGrkTmcB3OPK4YcO1EPudTuJywCTXrZzI+4ZV6Vh6x
	GInl7L97mltgZmhY4bGz24geVDESbgZrhIHYfagDzORxvlH9sIUnJ4pnDAFDaPBnHQ24gFO5GBM
	XT3MuPqOTxQpg9dRZ0Lu0acoJV0G8dRIgsA0gauaxqzilq2GlMv4j3KH2iKscPGwZY6TqnWXizA
	1B6FxWHWaNZmvxHY9QehxXRwPJXrAmq06eEYBNDiYgPwlEevSPd/5YOBh1gslfV5HWD5ZeBgQL3
	Xx7jIM7IkU1WdOi11ItyEBv6vVO3gUEQuQ7FQJ++mP7Iv6ltoCv5+t9oQv5DJo0WwCTART9URZ2
	HZm20/SmHnvBY4vbz9RRWJk7jt
X-Received: by 2002:a05:6000:290d:b0:43f:e934:50ac with SMTP id ffacd0b85a97d-45e5c362c4bmr6167043f8f.7.1778855676572;
        Fri, 15 May 2026 07:34:36 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8308:b093:bb00::bc35])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e767d16sm15773464f8f.6.2026.05.15.07.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 07:34:36 -0700 (PDT)
From: Alban Crequy <alban.crequy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Alban Crequy <alban.crequy@gmail.com>,
	Alban Crequy <albancrequy@microsoft.com>,
	Peter Xu <peterx@redhat.com>,
	Willy Tarreau <w@1wt.eu>,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org,
	Usama Arif <usama.arif@linux.dev>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH v4 2/2] selftests/mm: add tests for process_vm_readv flags
Date: Fri, 15 May 2026 16:33:35 +0200
Message-ID: <20260515143335.739511-3-alban.crequy@gmail.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260515143335.739511-1-alban.crequy@gmail.com>
References: <20260515143335.739511-1-alban.crequy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 403D21A000A
X-Stat-Signature: 1c1jkx93kro1b6afkgrnmqmp8ngt8ndj
X-Rspam-User: 
X-HE-Tag: 1778855678-380738
X-HE-Meta: U2FsdGVkX19xp7zaLPHS1qgIBkQ19CnfnWkh7Cby1DUhqAWUzmh1RQZHIHDOWrXtdyWcqidHUeLpSP9zTb/BBCML7oVAJbIsbz8KQ1NAfWrll+rP12iA//GR6A1d9Pgz5X7MCADL4xJVkT2hu/2LfG+n7b8ITf5Buxqa8JZRaJC6vFTZWza82pb3x69MTnT35ezjPdrBekrJy9ZFTj80PakK5621mq0bCr3s3wmR2uqIdpIfjPYokXbcWIBVq5ejnjvpbmm0XJZNMsPZY5dn/p1w+dfcLfw94XFvEl3SnepiVIla8ZIUh+g0hSXnh4kt0+5WAZXIAZaTsDbYrJJuIBXTNTxt2OIsayYfvw+y0aYrSjQjSf3KZp/+jWkHpJG5HB2DwYTv7dK3iACJjUMCSUrCw8zioVili+RFIGQOsKjAX1tgLBaCAAYCbbCH/FtZ9cbXcDg5xZIF5akma0oVcTcThI/AKsv5TtjUUdzfHs/ClZTZXg9N31b6v2C3LQF1jv2YGTgBzkuR/WoF4oMgORL5lz9QOfuc3NWE4K4LjNrF87V1xsytxqXvg7v+oGCdpuqeOyLIlQMZoTMJlfAxJhZmoxp67XeBfq+GlUYW4dCs4UVOLso6EHlCzUt2zqWKYi4YmV/ugjE2BPtm+5agUpZ9mG26xtzv8cxaVY2jW2ictua8Il4AxT5o0kziBFukztTBo6q7t4jQFuU9e9NUPCiHIHWhNfp7s+coX2J4VUb9uVk3sQoF9BPH4zk0KfhmrIa82oY4GWhVdFVVnaxHnGRCE4rq+W7WRkQXpxhkr5MmBaBhO9FCrsAdEmekmPm4WRG5OctRg1EKc1JLH3edsv/lI0mRBqkXTsp9FuN4NQqpXtWgBEjYIESiu1Y0tGnKZBi+UF51jidasbwV3+0SZSEICah2SRMY/ILz7hK7LSYRwzzBZetrjn6o8a+mPJD4UGUga/B7gNUOUP2aw6y
 Lqdvil0z
 jCNCSoz19TphpN/laou8jN+l+O2OnQy4iZCLM9B/lMerMKuFhb369w2YiU8HRaTKI2OMKbu0odphuuiUghLwvjapQ73emm4iQ6VqHdkiYWpchwCA57kGmUfa3FaBe9xPiK71RW4E2EzmhAmR8dgklsCuNbxzlp8/LZ0q8AaSiempAXdcaduG017+wpmXlTwqcFByOBsIihyctuz12AHFrT7w6VCH+8qRyY3o5Y0xyZLwtPeMuyX2tfIZ5UPpWLrNj8+0T4IUl0xh6gWrFB5UYW0ajuE9b/RTkfjOd3aUdf/NwvmZtFYvPvtz6SWi8w/VzfLMhlm1KcgnW4ympfsIR5I/5gdwTRdNB9XUxnmvI6dKedsLeyTS7KH9sjeAwnZQ6CgbxZ9v5qL06kVLyxFY3dLiwh9wrVn+U4pqkRaO5q4efHguvTj/myUj3t5Ansvxu8n80BmD8542O+eBBuyyamD2KIr+1sc52fEHbAFlZR8vlio1whfA5RRHLUxh3ZIxrLCjTBtBHABKnF1CIx8GOcnyN1bq6tYz2L+nzKOVG6o9UFIlUaiUWqflBJwJzmu2p/mSJMRa9NCn4sPk2NfmMW94w2FAevsEc3VDDfLuEsMaU1/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alban Crequy <albancrequy@microsoft.com>

Add selftests for the PROCESS_VM_PIDFD and PROCESS_VM_NOWAIT flags
introduced in process_vm_readv/writev.

Tests cover:
- basic read with no flags
- invalid flags (EINVAL)
- invalid address (EFAULT)
- flag validation precedence over address validation
- invalid pidfd (EBADF)
- invalid pid (ESRCH)
- PROCESS_VM_PIDFD: read via pidfd
- PROCESS_VM_NOWAIT: read from resident memory
- PROCESS_VM_PIDFD | PROCESS_VM_NOWAIT combined
- userfaultfd blocking read (no flags)
- PROCESS_VM_NOWAIT with userfaultfd (non-blocking, returns EFAULT)
- PROCESS_VM_NOWAIT partial read with single iovec across resident
  and non-resident pages (returns page_size bytes)
- PROCESS_VM_NOWAIT partial read with two iovecs, first resident,
  second non-resident (returns page_size bytes)

Tests gracefully SKIP on kernels without PROCESS_VM_PIDFD or
PROCESS_VM_NOWAIT support (EINVAL).

Signed-off-by: Alban Crequy <albancrequy@microsoft.com>
---
v4:
- Add selftests for NOWAIT partial reads across resident and
  non-resident pages (single iovec and two iovecs)
- SKIP tests gracefully on kernels without flag support (Sashiko)
- Verify content of partial reads

v3:
- Add selftest for invalid pidfd (David Hildenbrand)
- Add selftest for invalid pid
- SKIP on kernels without PROCESS_VM_PIDFD support
- Remove hardcoded __NR_pidfd_open fallback, use <sys/syscall.h> (Sashiko)
- SKIP pidfd tests on kernels without pidfd_open (ENOSYS) (Sashiko)
- SKIP userfaultfd tests when unprivileged userfaultfd is disabled (EPERM) (Sashiko)
- Fault in test_data before NOWAIT tests to ensure page is resident (Sashiko)
- Add ksft_process_vm_readv.sh wrapper and run_vmtests.sh entry

v2:
- New patch.

 tools/testing/selftests/mm/Makefile           |   2 +
 .../selftests/mm/ksft_process_vm_readv.sh     |   4 +
 tools/testing/selftests/mm/process_vm_readv.c | 573 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   4 +
 4 files changed, 583 insertions(+)
 create mode 100755 tools/testing/selftests/mm/ksft_process_vm_readv.sh
 create mode 100644 tools/testing/selftests/mm/process_vm_readv.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index cd24596cdd27..feb3a0b9a57e 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -106,6 +106,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += process_vm_readv
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
@@ -167,6 +168,7 @@ TEST_PROGS += ksft_pfnmap.sh
 TEST_PROGS += ksft_pkey.sh
 TEST_PROGS += ksft_process_madv.sh
 TEST_PROGS += ksft_process_mrelease.sh
+TEST_PROGS += ksft_process_vm_readv.sh
 TEST_PROGS += ksft_rmap.sh
 TEST_PROGS += ksft_soft_dirty.sh
 TEST_PROGS += ksft_thp.sh
diff --git a/tools/testing/selftests/mm/ksft_process_vm_readv.sh b/tools/testing/selftests/mm/ksft_process_vm_readv.sh
new file mode 100755
index 000000000000..09d0fcc9a35d
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_process_vm_readv.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t process_vm_readv
diff --git a/tools/testing/selftests/mm/process_vm_readv.c b/tools/testing/selftests/mm/process_vm_readv.c
new file mode 100644
index 000000000000..c6ce7ed75c98
--- /dev/null
+++ b/tools/testing/selftests/mm/process_vm_readv.c
@@ -0,0 +1,573 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <poll.h>
+#include <pthread.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <sys/uio.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include <linux/userfaultfd.h>
+
+#include "kselftest_harness.h"
+
+#ifndef PROCESS_VM_PIDFD
+#define PROCESS_VM_PIDFD	(1UL << 0)
+#endif
+
+#ifndef PROCESS_VM_NOWAIT
+#define PROCESS_VM_NOWAIT	(1UL << 1)
+#endif
+
+static int sys_pidfd_open(pid_t pid, unsigned int flags)
+{
+	return syscall(__NR_pidfd_open, pid, flags);
+}
+
+static const uint8_t test_data[] = { 0x01, 0x02, 0x03, 0x04,
+				     0x05, 0x06, 0x07, 0x08 };
+#define POISON_BYTE 0xCC
+
+/*
+ * Test: basic process_vm_readv with no flags
+ */
+TEST(read_basic)
+{
+	uint8_t buf[sizeof(test_data)];
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = {
+		.iov_base = (void *)test_data,
+		.iov_len = sizeof(test_data)
+	};
+	ssize_t n;
+
+	memset(buf, POISON_BYTE, sizeof(buf));
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1, 0);
+	ASSERT_EQ(sizeof(test_data), n);
+	ASSERT_EQ(0, memcmp(buf, test_data, sizeof(test_data)));
+}
+
+/*
+ * Test: invalid flags should return EINVAL
+ */
+TEST(read_invalid_flags)
+{
+	uint8_t buf[8] = { 0 };
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = {
+		.iov_base = (void *)test_data,
+		.iov_len = sizeof(test_data)
+	};
+	ssize_t n;
+
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1, 255);
+	ASSERT_EQ(-1, n);
+	ASSERT_EQ(EINVAL, errno);
+}
+
+/*
+ * Test: invalid address should return EFAULT
+ */
+TEST(read_invalid_address)
+{
+	uint8_t buf[8] = { 0 };
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = { .iov_base = NULL, .iov_len = 8 };
+	ssize_t n;
+
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1, 0);
+	ASSERT_EQ(-1, n);
+	ASSERT_EQ(EFAULT, errno);
+}
+
+/*
+ * Test: invalid address with invalid flags should return EINVAL
+ * (flag check happens before address validation)
+ */
+TEST(read_invalid_address_invalid_flags)
+{
+	uint8_t buf[8] = { 0 };
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = { .iov_base = NULL, .iov_len = 8 };
+	ssize_t n;
+
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1, 255);
+	ASSERT_EQ(-1, n);
+	ASSERT_EQ(EINVAL, errno);
+}
+
+/*
+ * Test: invalid address with all valid flags should return EFAULT
+ * (flags are valid so we get past the flag check to the address check)
+ */
+TEST(read_invalid_address_all_valid_flags)
+{
+	int pidfd;
+	struct iovec local_iov = { .iov_base = NULL, .iov_len = 8 };
+	struct iovec remote_iov = { .iov_base = NULL, .iov_len = 8 };
+	ssize_t n;
+
+	pidfd = sys_pidfd_open(getpid(), 0);
+	if (pidfd < 0 && errno == ENOSYS)
+		SKIP(return, "pidfd_open not supported");
+	ASSERT_GE(pidfd, 0);
+
+	n = process_vm_readv(pidfd, &local_iov, 1, &remote_iov, 1,
+			     PROCESS_VM_PIDFD | PROCESS_VM_NOWAIT);
+	ASSERT_EQ(-1, n);
+	if (errno == EINVAL)
+		SKIP(return,
+		     "PROCESS_VM_PIDFD or PROCESS_VM_NOWAIT not supported");
+	ASSERT_EQ(EFAULT, errno);
+
+	close(pidfd);
+}
+
+/*
+ * Test: read with an invalid pidfd should return an error, not crash
+ */
+TEST(read_invalid_pidfd)
+{
+	uint8_t buf[sizeof(test_data)] = { 0 };
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = {
+		.iov_base = (void *)test_data,
+		.iov_len = sizeof(test_data)
+	};
+	ssize_t n;
+
+	/* fd 9999 is almost certainly not a valid pidfd */
+	n = process_vm_readv(9999, &local_iov, 1, &remote_iov, 1,
+			     PROCESS_VM_PIDFD);
+	ASSERT_EQ(-1, n);
+	if (errno == EINVAL)
+		SKIP(return, "PROCESS_VM_PIDFD not supported");
+	ASSERT_EQ(EBADF, errno);
+}
+
+/*
+ * Test: read with an invalid pid should return ESRCH
+ */
+TEST(read_invalid_pid)
+{
+	uint8_t buf[sizeof(test_data)] = { 0 };
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = {
+		.iov_base = (void *)test_data,
+		.iov_len = sizeof(test_data)
+	};
+	ssize_t n;
+
+	/* pid 999999 is almost certainly not a valid process */
+	n = process_vm_readv(999999, &local_iov, 1, &remote_iov, 1, 0);
+	ASSERT_EQ(-1, n);
+	ASSERT_EQ(ESRCH, errno);
+}
+
+/*
+ * Test: read with PIDFD flag
+ */
+TEST(read_pidfd)
+{
+	uint8_t buf[sizeof(test_data)];
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = {
+		.iov_base = (void *)test_data,
+		.iov_len = sizeof(test_data)
+	};
+	ssize_t n;
+	int pidfd;
+
+	memset(buf, POISON_BYTE, sizeof(buf));
+	pidfd = sys_pidfd_open(getpid(), 0);
+	if (pidfd < 0 && errno == ENOSYS)
+		SKIP(return, "pidfd_open not supported");
+	ASSERT_GE(pidfd, 0);
+
+	n = process_vm_readv(pidfd, &local_iov, 1, &remote_iov, 1,
+			     PROCESS_VM_PIDFD);
+	if (n == -1 && errno == EINVAL)
+		SKIP(return, "PROCESS_VM_PIDFD not supported");
+	ASSERT_EQ(sizeof(test_data), n);
+	ASSERT_EQ(0, memcmp(buf, test_data, sizeof(test_data)));
+
+	close(pidfd);
+}
+
+/*
+ * Test: read with NOWAIT from resident memory (should succeed)
+ */
+TEST(read_nowait_resident)
+{
+	uint8_t buf[sizeof(test_data)];
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = {
+		.iov_base = (void *)test_data,
+		.iov_len = sizeof(test_data)
+	};
+	ssize_t n;
+
+	*(volatile uint64_t *)test_data; /* fault in page for NOWAIT */
+	memset(buf, POISON_BYTE, sizeof(buf));
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1,
+			     PROCESS_VM_NOWAIT);
+	if (n == -1 && errno == EINVAL)
+		SKIP(return, "PROCESS_VM_NOWAIT not supported");
+	ASSERT_EQ(sizeof(test_data), n);
+	ASSERT_EQ(0, memcmp(buf, test_data, sizeof(test_data)));
+}
+
+/*
+ * Test: read with PIDFD + NOWAIT from resident memory
+ */
+TEST(read_pidfd_nowait_resident)
+{
+	uint8_t buf[sizeof(test_data)];
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = {
+		.iov_base = (void *)test_data,
+		.iov_len = sizeof(test_data)
+	};
+	ssize_t n;
+	int pidfd;
+
+	*(volatile uint64_t *)test_data; /* fault in page for NOWAIT */
+	memset(buf, POISON_BYTE, sizeof(buf));
+	pidfd = sys_pidfd_open(getpid(), 0);
+	if (pidfd < 0 && errno == ENOSYS)
+		SKIP(return, "pidfd_open not supported");
+	ASSERT_GE(pidfd, 0);
+
+	n = process_vm_readv(pidfd, &local_iov, 1, &remote_iov, 1,
+			     PROCESS_VM_PIDFD | PROCESS_VM_NOWAIT);
+	if (n == -1 && errno == EINVAL)
+		SKIP(return, "PROCESS_VM_PIDFD or PROCESS_VM_NOWAIT not supported");
+	ASSERT_EQ(sizeof(test_data), n);
+	ASSERT_EQ(0, memcmp(buf, test_data, sizeof(test_data)));
+
+	close(pidfd);
+}
+
+/*
+ * Userfaultfd helpers for NOWAIT tests
+ */
+static int setup_userfaultfd(void)
+{
+	struct uffdio_api api = { .api = UFFD_API };
+	int uffd;
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (uffd < 0)
+		return -errno;
+
+	if (ioctl(uffd, UFFDIO_API, &api)) {
+		close(uffd);
+		return -errno;
+	}
+
+	return uffd;
+}
+
+static void *register_uffd_region(int uffd, size_t size)
+{
+	struct uffdio_register reg;
+	void *mem;
+
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED)
+		return NULL;
+
+	reg.range.start = (unsigned long)mem;
+	reg.range.len = size;
+	reg.mode = UFFDIO_REGISTER_MODE_MISSING;
+	if (ioctl(uffd, UFFDIO_REGISTER, &reg)) {
+		munmap(mem, size);
+		return NULL;
+	}
+
+	return mem;
+}
+
+struct uffd_handler_args {
+	int uffd;
+	const void *content;
+	size_t content_len;
+};
+
+static void *uffd_handler_thread(void *arg)
+{
+	struct uffd_handler_args *ha = arg;
+	struct uffd_msg msg;
+	struct uffdio_copy uffd_copy;
+	struct pollfd pfd = {
+		.fd = ha->uffd,
+		.events = POLLIN
+	};
+	void *page;
+	long page_size = sysconf(_SC_PAGESIZE);
+	int ret;
+
+	page = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (page == MAP_FAILED)
+		return (void *)(long)-ENOMEM;
+
+	memcpy(page, ha->content, ha->content_len);
+
+	ret = poll(&pfd, 1, 5000);
+	if (ret <= 0)
+		goto out;
+
+	if (read(ha->uffd, &msg, sizeof(msg)) != sizeof(msg))
+		goto out;
+
+	if (msg.event != UFFD_EVENT_PAGEFAULT)
+		goto out;
+
+	uffd_copy.dst = msg.arg.pagefault.address & ~(page_size - 1);
+	uffd_copy.src = (unsigned long)page;
+	uffd_copy.len = page_size;
+	uffd_copy.mode = 0;
+	ioctl(ha->uffd, UFFDIO_COPY, &uffd_copy);
+
+out:
+	munmap(page, page_size);
+	return NULL;
+}
+
+/*
+ * Test: read from userfaultfd-registered memory (no flags, should block
+ * until page fault is resolved by handler thread)
+ */
+TEST(read_userfaultfd_blocking)
+{
+	int uffd;
+	void *mem;
+	long page_size = sysconf(_SC_PAGESIZE);
+	uint8_t buf[sizeof(test_data)];
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov;
+	struct uffd_handler_args ha;
+	pthread_t handler;
+	ssize_t n;
+
+	memset(buf, POISON_BYTE, sizeof(buf));
+
+	uffd = setup_userfaultfd();
+	if (uffd == -EPERM)
+		SKIP(return, "userfaultfd requires privileges (vm.unprivileged_userfaultfd=0)");
+	if (uffd == -ENOSYS)
+		SKIP(return, "userfaultfd not supported");
+	ASSERT_GE(uffd, 0);
+
+	mem = register_uffd_region(uffd, page_size);
+	ASSERT_NE(NULL, mem);
+
+	ha.uffd = uffd;
+	ha.content = test_data;
+	ha.content_len = sizeof(test_data);
+	ASSERT_EQ(0, pthread_create(&handler, NULL, uffd_handler_thread, &ha));
+
+	remote_iov.iov_base = mem;
+	remote_iov.iov_len = sizeof(test_data);
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1, 0);
+	ASSERT_EQ(sizeof(test_data), n);
+	ASSERT_EQ(0, memcmp(buf, test_data, sizeof(test_data)));
+
+	pthread_join(handler, NULL);
+	munmap(mem, page_size);
+	close(uffd);
+}
+
+/*
+ * Test: read with NOWAIT from userfaultfd-registered memory that has
+ * not been faulted in yet. Should return EFAULT (not block).
+ */
+TEST(read_nowait_userfaultfd)
+{
+	int uffd;
+	void *mem;
+	long page_size = sysconf(_SC_PAGESIZE);
+	uint8_t buf[sizeof(test_data)] = { 0 };
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov;
+	ssize_t n;
+
+	uffd = setup_userfaultfd();
+	if (uffd == -EPERM)
+		SKIP(return, "userfaultfd requires privileges (vm.unprivileged_userfaultfd=0)");
+	if (uffd == -ENOSYS)
+		SKIP(return, "userfaultfd not supported");
+	ASSERT_GE(uffd, 0);
+
+	mem = register_uffd_region(uffd, page_size);
+	ASSERT_NE(NULL, mem);
+
+	/* Ensure the page is not present */
+	madvise(mem, page_size, MADV_DONTNEED);
+
+	remote_iov.iov_base = mem;
+	remote_iov.iov_len = sizeof(test_data);
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1,
+			     PROCESS_VM_NOWAIT);
+	if (n == -1 && errno == EINVAL)
+		SKIP(return, "PROCESS_VM_NOWAIT not supported");
+	ASSERT_EQ(-1, n);
+	ASSERT_EQ(EFAULT, errno);
+
+	munmap(mem, page_size);
+	close(uffd);
+}
+
+/*
+ * Test: NOWAIT read across two pages with a single iovec, where the
+ * first page is resident and the second is not. Tests whether a
+ * partial read within a single iovec element is possible.
+ */
+TEST(read_nowait_partial_single_iovec)
+{
+	int uffd;
+	void *mem;
+	long page_size = sysconf(_SC_PAGESIZE);
+	uint8_t *buf;
+	struct iovec local_iov;
+	struct iovec remote_iov;
+	struct uffdio_copy uffd_copy;
+	ssize_t n;
+	void *src_page;
+
+	uffd = setup_userfaultfd();
+	if (uffd == -EPERM)
+		SKIP(return, "userfaultfd requires privileges (vm.unprivileged_userfaultfd=0)");
+	if (uffd == -ENOSYS)
+		SKIP(return, "userfaultfd not supported");
+	ASSERT_GE(uffd, 0);
+
+	/* Allocate 2 pages and register with userfaultfd */
+	mem = register_uffd_region(uffd, 2 * page_size);
+	ASSERT_NE(NULL, mem);
+
+	/* Resolve page 1 via UFFDIO_COPY, leave page 2 missing */
+	src_page = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(MAP_FAILED, src_page);
+	memset(src_page, 0xAA, page_size);
+
+	uffd_copy.dst = (unsigned long)mem;
+	uffd_copy.src = (unsigned long)src_page;
+	uffd_copy.len = page_size;
+	uffd_copy.mode = 0;
+	ASSERT_EQ(0, ioctl(uffd, UFFDIO_COPY, &uffd_copy));
+	munmap(src_page, page_size);
+
+	/* Read across both pages with a single iovec */
+	buf = malloc(2 * page_size);
+	ASSERT_NE(NULL, buf);
+	memset(buf, POISON_BYTE, 2 * page_size);
+
+	local_iov.iov_base = buf;
+	local_iov.iov_len = 2 * page_size;
+	remote_iov.iov_base = mem;
+	remote_iov.iov_len = 2 * page_size;
+
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1,
+			     PROCESS_VM_NOWAIT);
+	if (n == -1 && errno == EINVAL)
+		SKIP(return, "PROCESS_VM_NOWAIT not supported");
+	ASSERT_EQ(page_size, n);
+
+	/* Verify the first page was read correctly */
+	for (int i = 0; i < page_size; i++)
+		ASSERT_EQ(0xAA, buf[i]);
+
+	free(buf);
+	munmap(mem, 2 * page_size);
+	close(uffd);
+}
+
+/*
+ * Test: NOWAIT read across two pages with two iovecs (one per page),
+ * where the first page is resident and the second is not. Tests
+ * whether the syscall returns bytes from the first iovec.
+ */
+TEST(read_nowait_partial_two_iovecs)
+{
+	int uffd;
+	void *mem;
+	long page_size = sysconf(_SC_PAGESIZE);
+	uint8_t *buf1, *buf2;
+	struct iovec local_iov[2];
+	struct iovec remote_iov[2];
+	struct uffdio_copy uffd_copy;
+	ssize_t n;
+	void *src_page;
+
+	uffd = setup_userfaultfd();
+	if (uffd == -EPERM)
+		SKIP(return, "userfaultfd requires privileges (vm.unprivileged_userfaultfd=0)");
+	if (uffd == -ENOSYS)
+		SKIP(return, "userfaultfd not supported");
+	ASSERT_GE(uffd, 0);
+
+	/* Allocate 2 pages and register with userfaultfd */
+	mem = register_uffd_region(uffd, 2 * page_size);
+	ASSERT_NE(NULL, mem);
+
+	/* Resolve page 1 via UFFDIO_COPY, leave page 2 missing */
+	src_page = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(MAP_FAILED, src_page);
+	memset(src_page, 0xBB, page_size);
+
+	uffd_copy.dst = (unsigned long)mem;
+	uffd_copy.src = (unsigned long)src_page;
+	uffd_copy.len = page_size;
+	uffd_copy.mode = 0;
+	ASSERT_EQ(0, ioctl(uffd, UFFDIO_COPY, &uffd_copy));
+	munmap(src_page, page_size);
+
+	/* Two iovecs: one for each page */
+	buf1 = malloc(page_size);
+	buf2 = malloc(page_size);
+	ASSERT_NE(NULL, buf1);
+	ASSERT_NE(NULL, buf2);
+	memset(buf1, POISON_BYTE, page_size);
+	memset(buf2, POISON_BYTE, page_size);
+
+	local_iov[0].iov_base = buf1;
+	local_iov[0].iov_len = page_size;
+	local_iov[1].iov_base = buf2;
+	local_iov[1].iov_len = page_size;
+
+	remote_iov[0].iov_base = mem;
+	remote_iov[0].iov_len = page_size;
+	remote_iov[1].iov_base = (char *)mem + page_size;
+	remote_iov[1].iov_len = page_size;
+
+	n = process_vm_readv(getpid(), local_iov, 2, remote_iov, 2,
+			     PROCESS_VM_NOWAIT);
+	if (n == -1 && errno == EINVAL)
+		SKIP(return, "PROCESS_VM_NOWAIT not supported");
+	ASSERT_EQ(page_size, n);
+
+	/* Verify the first page was read correctly */
+	for (int i = 0; i < page_size; i++)
+		ASSERT_EQ(0xBB, buf1[i]);
+
+	free(buf1);
+	free(buf2);
+	munmap(mem, 2 * page_size);
+	close(uffd);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d8468451b3a3..7d30f6101088 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -91,6 +91,8 @@ separated by spaces:
 	test VMA merge cases behave as expected
 - rmap
 	test rmap behaves as expected
+- process_vm_readv
+	test process_vm_readv flags (pidfd, nowait)
 - memory-failure
 	test memory-failure behaves as expected
 
@@ -531,6 +533,8 @@ CATEGORY="page_frag" run_test ./test_page_frag.sh nonaligned
 
 CATEGORY="rmap" run_test ./rmap
 
+CATEGORY="process_vm_readv" run_test ./process_vm_readv
+
 # Try to load hwpoison_inject if not present.
 HWPOISON_DIR=/sys/kernel/debug/hwpoison/
 if [ ! -d "$HWPOISON_DIR" ]; then
-- 
2.45.0


