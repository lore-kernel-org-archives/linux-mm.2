Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28746CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92AB96B00AE; Tue,  2 Jun 2026 06:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902F36B00B3; Tue,  2 Jun 2026 06:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81E7D6B00AE; Tue,  2 Jun 2026 06:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 711396B00AE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:10:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 350E51A0241
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:10:15 +0000 (UTC)
X-FDA: 84834552390.01.9603609
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2FA1F1A0003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:10:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BANpJvZM;
	spf=pass (imf19.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395013;
	b=vYHqx4TjpyfwI/y7JIiIsjAMuvrmM631uBeHGTaNC+Bg/8ePKT8x3MjqhjSoOB7GLOsMyb
	7OEACltzWlvT+1QPr6h/w4MQdwAeYUbww+l2WQGybCS55B2OWbi7d6F8CdZKmkUyqfIzIV
	tXvvJGh8yknaOfD+N2PvS34GeRvoN2I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BANpJvZM;
	spf=pass (imf19.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395013;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lRCUMzAHndLIoqHDBN9uRut+UxmgXFuICM92TGjeUzA=;
	b=zUZf9LxFUo7JCUcgdtznclo4+E6s+5hJkBgKQjhquAIBUXNqJgVxWndBlvpUsgearD6m93
	nFj3TLJtAkV01FWiiZgR1Yd8DrXd3i+ZorFanfHbnxzjkl1LuAL49dFeKfvdiK7zsJ08gX
	R86sYBm77SIlXt7BUJDUDLXEgwE8fRE=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-46013161068so943897f8f.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780395012; x=1780999812; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lRCUMzAHndLIoqHDBN9uRut+UxmgXFuICM92TGjeUzA=;
        b=BANpJvZMiHuuqc37jwQaf+ZKtAkbelY7BGpavmxGw3Hs87g3aeQj38g58n2i04IIRO
         WHmYjWQpj/8fieojIiFwiiNEP9QEP6KXF5w4rZrbmMJQV/z79/ol8XlhK9eAJh2Jz7ZT
         3OjOCq1IPuUmw/DdFC2O6uKvuxldUFJzrmGg0oIEnP78Qs71UnMGlAqOV3sl45jpoejn
         Y4zOMfFz2VObUM+Wuz2fPmjg4HtPvQTibvZFr2HDVChfR2k2RjT1Pqhe3Qq6HT+KR6gy
         PD9l5pWzQ8ykwXMEAHzbNLnKIrykEq05Btf4c7tPIcjbZTUlNJuFm2O8DbgdJfG0N9fC
         SG5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395012; x=1780999812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lRCUMzAHndLIoqHDBN9uRut+UxmgXFuICM92TGjeUzA=;
        b=ZG1VoEoikutSXuZk+Cjntg4XAdpVm6qzfD2ZkSDDm6zfP7ViNPXIO/crYW23AK5qy9
         BMFvzE3ThIDw2IoU5lZjn2pn+/kkLfjn9A6orqOuqMVLAV29G9dyf99tUDPIT/2fZfkq
         vWazyBB4I02e5cCH8s/eA7w9fYBXTKAhpAvSsl5vI0rv46cNfLapluo3wZHvJl9Vi3pN
         YgpT8fU3IK2/kYjdhF9I4YqBIGDq5zkqSq3fZxjkUpotD/g1g06x3jUID8WTRjAoP1Kx
         J0dxmCKHzwBUFRl1lj6QL7WNhh7EPNx8MwWa5Gn7AUflVK0/O5/V5Q1EjU6EMssQs3w+
         +bUw==
X-Forwarded-Encrypted: i=1; AFNElJ8bKeA+GQ+5iMrO/vXCL2y7eqFh4Yei1nBatin+lMSHLLPJPbj/tAviILcBNSWz7Qzq6rj+kTQcug==@kvack.org
X-Gm-Message-State: AOJu0Yz4qbBSEp6rRUgsKtUhmgWJqI3/rcM4ErjF+TqZpXGOSRvVCEcv
	NU+T+Gr+v33T2EFTmg06LTjVvruhm2x0vzeQZcxfbusdtXvA8OvlMfPP
X-Gm-Gg: Acq92OHsvNziexnuDSmkwpt+iiqt1usAKdFKweZ4/RpptGhP6wucyh1ko7GriNfgz+A
	sZSvKbXiU3i0eKO3KV31npiZmi78FjwzKMNmhOF7ypyquq4Kr7Ls1RL88gmFiFqJ17LbKgn0esb
	2pUSVmqnpPVeyV05Q3C/bSF37gRqYpJAFtXgqZ5MWfRTZOn54vlKawxInkKtKQnAzpECqvMmSzH
	Fzok8eRAhSAa1yQt6yZaMhmMoV/13YPCfjGMrLeW3o4AqKG6KWqJeUygVMbqi5rD07kQM/utxiJ
	MgN6emYFjuUyceFOC0LMVRtpZuYPd/YwMY9/ZbuNT8q8NGydpkoy1ApGNy5LtqKCC1cqITnRb3P
	+m+BjcHBHs18BTHej0fJ11JjiuQz0Wt14dvxByipXE7k7tD8Wdjr0Iep+I+D7duVsn76v8i+C3N
	cDbNljFEMWwp8H6wGaNnkIlE0sbOjVIb4qjgs=
X-Received: by 2002:a5d:4684:0:b0:43d:7bc9:9b2c with SMTP id ffacd0b85a97d-45ef6b2a419mr23214449f8f.17.1780395011516;
        Tue, 02 Jun 2026 03:10:11 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8308:b093:bb00::d167])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef354cd87sm30636722f8f.24.2026.06.02.03.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:10:11 -0700 (PDT)
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
Subject: [PATCH v5 2/2] selftests/mm: add tests for process_vm_readv flags
Date: Tue,  2 Jun 2026 12:09:17 +0200
Message-ID: <20260602100917.3641359-3-alban.crequy@gmail.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260602100917.3641359-1-alban.crequy@gmail.com>
References: <20260602100917.3641359-1-alban.crequy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2FA1F1A0003
X-Rspam-User: 
X-Stat-Signature: 4zm9ipdq53x86g57atngdq7gxnmw6rkf
X-HE-Tag: 1780395012-428004
X-HE-Meta: U2FsdGVkX19V+L4LG4ZOwcBRcDJTcZvQ8sPMaxC7bSV28Pjzlt7sbhewCDOMwf+rqmtK003n9qFJw+sa2JJbJ/vrOgHHWauQrFONL0uJd0i+mCyh1t5034kv72Vh/fMG3jkswIEMS64ayFzpc0MriVWmLBVd2Tg7jE4XAk47nwxPGQSOnHUS/mNKF0UWLUclOtd7xjqeYgX9UP+JkQDw3pz2pWWsUKpeexJ1jZRoZYhWePn6pd8Al1ayTR/dvvzDX7eC6mPGk1waIsCVKd/c2HX3vdAOtqJICdtqSWSMFbKokurHQBjW21eSWSxqYkw0pxSNCOxqAzp6f6NGQT6xYXm8a6rdInGZ9g2R9v6mirSe5mQ302YmNAeMdxkRaA8zOMq+WDQ6Cafk5ClTGKvQiuWtIb85asIZswWdEW3KR8g9RMOTlzFAfR6N/vCmTjwO1xI0Pgq3h9OFIgFgOFC58gldiEZBJ+rWSEOgN7gJkY16RSfBhOJ9+3EZ5ck6B9Li8+y5p9dns6pHc8gmoWNriHsFdt3cpXvkLputC2deCQtT64BK52OVQSTFjj79lBvgmik5nzcDB2jqzfLrI0cVSMQfqiLfwyCaRPbGXPbY29rZUtKCxoOd8ghEtmGprnSZjQRJicVZn4aSEe0dXswJsWmRN2L7yytE786cvXEZNzlyv4/zZk7mSnrEb7jz1Nr6/qmz+Ze/EGyIiHfJfCyGmpiS0IeH3FRNdjWP6wV1VEeQm7M71QA1hNsA+K/tITE6Qw7r4NZ8WUU52BGiVrSnBq6c5jH+l1P+SH33xeDSnokywV5bS0I1knxlhLwSsMqps8FWjMi8K5KIj0HBQOm2fvU/hwfZTF5i+3ro4LF5RiNgkif7NTtl3clEIyyRH3uMrQKOytHbvVMK7TMedTesLD7DPRw3XJRj+znXaKZTJQR7GK7cXMUdN8yVtqLkpK5rc+fTRL3B/LeR3oWWiUn
 7OYooUMX
 ZvsCUKeSJ0v+bVLRjPSvWAi1kbSFrVlKSqmbkEbfZ9hWLD2HP8xt1jnsoFHegIjgbFLRWBHeVw0k9SRHface/tv38uGZLSSyPLr8LliIi/FwY8SNVj6d1TsBQ13vpUL0TWEhBy9sMoigGkPv2cEZinkT6a9Z/3Irii2bUjosNc5+tSrGi3SAQq7qL4vPHPaYm+pmUth+O5gZbGF+Df4IrQ+sUG4e6Z8FDvQshjsApg4VqWHEps+4R1AWoJnXG0+KcAYTHuUqRkt5tQktrIlFnCG2NGYuF6IkyXksaS9VKj1cMvrN//ZiMlOFVi9UchTKU1lWSKYCVpknhtR0DOZm+/SNokBRmsWSstQNa7VZ5MKlAI9UFVqI01yOeQFLygrA/NbMbSGr4q8qj4ow8Ju0je1t1g8Dt8THqZWm1Op9LC0aNIiEHOrFY5mta3XzXuDnfI6X8kPjn/tJ0dRKHutWgLf3slZ4ra41OdRN8DZh2bmvVgwwbty6L3R0k7Z4VhTg2/OVPVfw4UU1UCrWUaMxTc4m9UfwGDsnPniJT1wdQ2DRIAUICNQ6Wi4YIGmZYUYfAwHSqopdwfjzhd7Y=
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
v5:
- Add process_vm_readv to .gitignore (Sashiko)
- Use ~0UL instead of 255 for invalid flags tests (Sashiko)
- Use volatile uint8_t instead of volatile uint64_t for page fault-in
  to avoid alignment issues on strict-alignment architectures (Sashiko)
- Use UFFDIO_UNREGISTER in uffd handler error path to safely unblock
  the main thread without double-close (Sashiko)

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

 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   2 +
 .../selftests/mm/ksft_process_vm_readv.sh     |   4 +
 tools/testing/selftests/mm/process_vm_readv.c | 591 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   4 +
 5 files changed, 602 insertions(+)
 create mode 100755 tools/testing/selftests/mm/ksft_process_vm_readv.sh
 create mode 100644 tools/testing/selftests/mm/process_vm_readv.c

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index b0c30c5ee9e3..78525dfa5a95 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -23,6 +23,7 @@ transhuge-stress
 pagemap_ioctl
 pfnmap
 process_madv
+process_vm_readv
 *.tmp*
 protection_keys
 protection_keys_32
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
index 000000000000..34aa44c5eb67
--- /dev/null
+++ b/tools/testing/selftests/mm/process_vm_readv.c
@@ -0,0 +1,591 @@
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
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1, ~0UL);
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
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1, ~0UL);
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
+	*(volatile uint8_t *)test_data; /* fault in page for NOWAIT */
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
+	*(volatile uint8_t *)test_data; /* fault in page for NOWAIT */
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
+	void *mem;
+	size_t mem_len;
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
+		goto err;
+
+	if (read(ha->uffd, &msg, sizeof(msg)) != sizeof(msg))
+		goto err;
+
+	if (msg.event != UFFD_EVENT_PAGEFAULT)
+		goto err;
+
+	uffd_copy.dst = msg.arg.pagefault.address & ~(page_size - 1);
+	uffd_copy.src = (unsigned long)page;
+	uffd_copy.len = page_size;
+	uffd_copy.mode = 0;
+	ioctl(ha->uffd, UFFDIO_COPY, &uffd_copy);
+
+	munmap(page, page_size);
+	return NULL;
+
+err:
+	/*
+	 * Unregister the uffd region to unblock the main thread if it
+	 * is waiting for page fault resolution.
+	 */
+	{
+		struct uffdio_range range = {
+			.start = (unsigned long)ha->mem,
+			.len = ha->mem_len,
+		};
+		ioctl(ha->uffd, UFFDIO_UNREGISTER, &range);
+	}
+	munmap(page, page_size);
+	return (void *)(long)-EIO;
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
+	ha.mem = mem;
+	ha.mem_len = page_size;
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
index c17b133a81d2..f7b55dea8d68 100755
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


