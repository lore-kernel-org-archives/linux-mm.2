Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB3CCFF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 12:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47C26B0095; Tue, 28 Apr 2026 08:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9A76B0096; Tue, 28 Apr 2026 08:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9A536B0098; Tue, 28 Apr 2026 08:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A43F56B0095
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:29:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52B20140136
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:29:27 +0000 (UTC)
X-FDA: 84707895174.15.19113E3
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4FA95180002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:29:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fXUjNbB9;
	spf=pass (imf24.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777379365;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mIZKdDhTnPDWJkdLmdF0ct42LRqQxNma8jQA8xXSthI=;
	b=nRVeoBxKb0ekYYo+q4dO96J5lHxsXHvB+vtBn22haz9xs30coOxhgQzzyL+PI/4bjiE5xE
	AT5PNsqwOiNCfOouwR6i9vUUCkkfubnmuyfO5MQH2ZwkGmYYzlwwcAmvL2K7ViF4MWYS+V
	J00MWmb4SK3bxHTNdZ70hbrNEfF6EY4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fXUjNbB9;
	spf=pass (imf24.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777379365; a=rsa-sha256;
	cv=none;
	b=4TjmOdrMgsdQqDA410W951TFju66IEmJpXpoYFzoecP91ldDhl1j/ANffjhod7Fd2PBKQr
	hNcR+/gFf/zv5rFcfVzN0JHfiA/7utHNfpQh3PbNzcTrxZ5t6Gw81ApmPJ31x+2ccuCJnv
	iduZ2cLDeK86C1L57sMoE1Me9fw3LcU=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488a14c31eeso94519185e9.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777379364; x=1777984164; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mIZKdDhTnPDWJkdLmdF0ct42LRqQxNma8jQA8xXSthI=;
        b=fXUjNbB9ZRgLVmz2FmzVLcULsV66YzjxwOMeo23taDYJC9ADSwmTWeJY1ETW6J7c1k
         i+oKjF3dvlYrz2OhkXQrOf04ngpnbEyYC5YlKCdPcYPidedmIxzw/9a9M4isX29fTz32
         wrYOEhnzd2Cf5guhZMdAftx8FaK7SW6kWlNcpGRUZYnBD5kT5hN1BwQT57yr9L/V4DKA
         hSQ7eRJ/R7pxrLGQwkJ4+qVu6rqmPufagXWjk8TJkwncMZaVCo+gnS2nKchrnQE2KQMx
         G6tG/E3W87XIi+JhZIonlzovP9oNv/CWc816ZiFDAFs1ie0n7EGUdbatHf2Dd3sx0yrn
         9zvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777379364; x=1777984164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mIZKdDhTnPDWJkdLmdF0ct42LRqQxNma8jQA8xXSthI=;
        b=GnLs8Gg1U5rO4LdA1ENyPkUxYko8TjuR1RQOfu+ZFqWYcAzMPZPq0TXNaUiyicJQ6m
         lV+OnR1+bRIMJLciLg2rMwzSo2ATrGx+e7L8jBU+lEtcPizt08VH4CtkKIQ1iYizcf49
         Cz839woI/vpy2s5sXkpgeTroMQKjzFIlcI2DwF+mh1XEDRZeXXYdCdPyI6lTv2lswaia
         H2V/+FUea5mv+o0qVCLsnpaRP8UNELbDoJM2XyOpdh4xOhRMW17sDJjLWYoGSUzBhTT2
         0zs2e6tj0B+EDwM7BXmoAM/mQyMRaL654+GACfIZBvj+zudrhv4JB7flXRw1mmR3grwi
         myHg==
X-Forwarded-Encrypted: i=1; AFNElJ/qDRYtrM8vHZ9nH2zVgDBSX+WAXxvQSDuSR8ss0jXMco7i3d/06U4gnKU1rHmM+TF0ilnG9xGJ5Q==@kvack.org
X-Gm-Message-State: AOJu0YxHCRhn9b0BSzfPLEC7Zu2zsTpxSxrc7hG7hisIkY6K26i3w4un
	9/g8hZ31Vq+CTAEg6oXa6lTKhwi3VS+3swqEcDlIJNmwGOlgMhH4y/zP
X-Gm-Gg: AeBDietL1z80PnywdfJIS0qtdpKGasLrJTN7kuIWtZD30JFPhdh85LZSIOjv9UO2QoF
	F8aHa9Yj9O341n83XF57x9vRrKmXPtFBDZ+Hkxk81OgG/xIYPq0RDKBoFluAB1bj7ykTP0aK60A
	CntkZumK9y0/+usI1kRoN3Freao9zDKLXnpca1EQpbtk0MtKYGxrxjDE9Hz5d7taHc9hkJwC3uQ
	6ZT5IIFb3oOO/od2tQVg19QDy/cRvrOhwOAXUN+X1AugyvK+E8NM9HrzQ4Qb6UOuFuTOg69ki+T
	c7QtelQZiyDHs+q5v743hYjs8wMTMj454PQAs6mhw9zjIQVvgsIs/wBdmFQU/8nKwkXLDonOlDF
	ghyUTyW9ldM10a0KYF1SL5VhYuMZta1fQ9dxzW9Nsi9pxULIt5vossPJwplfM/7pXCnQymZOKn8
	3f950lB4UJVKf3HhXhGQJbx2UGvVppJ9CgI0EoNO/BfCjg50S2M37u8Ct2uZYp0fLupU3QUgzLk
	w==
X-Received: by 2002:a05:600c:c048:b0:489:1ae1:4eb9 with SMTP id 5b1f17b1804b1-48a77b233e4mr28855135e9.28.1777379363615;
        Tue, 28 Apr 2026 05:29:23 -0700 (PDT)
Received: from localhost.localdomain (90-181-198-146.rco.o2.cz. [90.181.198.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a77af1b86sm47479045e9.5.2026.04.28.05.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 05:29:23 -0700 (PDT)
From: Alban Crequy <alban.crequy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH v3 2/2] selftests/mm: add tests for process_vm_readv flags
Date: Tue, 28 Apr 2026 14:28:26 +0200
Message-ID: <20260428122826.339550-3-alban.crequy@gmail.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260428122826.339550-1-alban.crequy@gmail.com>
References: <20260428122826.339550-1-alban.crequy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ccgihygxod56jmjg818atmays841ut8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4FA95180002
X-Rspam-User: 
X-HE-Tag: 1777379365-37306
X-HE-Meta: U2FsdGVkX1+IqQjd7vXvOQLozJ5VojuU2l7gl32Mv3Os/DfmF50Cylu2ECHBDW8j5jRu8qOVzTrYdw6AKxeF/yVf1138Z0d9e4tXs0MsvL3I++zdFfW1QcISWYVtL6dgZNmIRvP4mVX8kngw/1qkLF/llmiodZJCtUEgvIlDj4Uq+S0ZmZgiahhIqYLTH5HC04dY+bwmhvwKX0piA1fzlZ/eaXupslJhkT9Zvp6i2kEjX1wLddizpib3HTp5sL7PdjoRt4FXALZANXm9dLRsJ2VQKvDIklshc9reySuQGkGhkXniwx+5z5ALbNE6mwGvZZktYtDv4H7F2WYwEXCYPYWVU2gIq9vi64DB5yJbwX/sGF4WGG9d7tmXeXrr2HnFB25LXUvp8S6d2rqKliTXVfgohfhOIMiTBLF2VE7cqVYtehHW49JXUGjmejqB+aWNCLOb9MRonP1hNblKsl/lfo+taDyPTKODU+0mkyX88Ku20LkpdDaYgQiqqD/WEHzb+5WtGA6rgLRH1/0Mc2Y4g6xGuO2yZuu9tmkpNfGqGJOOOmAyiEHJ2afQRT1bJRgCVOOWx2AELykyXLvPBFbdIavFxdLMXOVHmTpY8Wm8nYXad5nRyjl9OlZk312Vo4VNGxP4P5nN+5lFR4QAdjZtZzaoUKL2l50WRWyjJLSDl4NDMbIzhCmeLeGcbIVOnQbmhgPGGfyVZp8X3MOTfLCmP9MqHK+UXby76B/6nyKRCZrCUUp76H0ajhg9O0A7l52tVq0sAwT8VWTS1JlW8x04avXTyCr3+BtGvyvK5MxOCuPouLycDUxIBFSBo2svRo0+fLP/1qOB5A0t93tx7f4J5PSXUCF8GtkIQahAmbKH42qJblFWh7mpOIlA3YfOJBZiU5UfNkJdGPnbzJ2NgAVaeJnWLGVtUe8zJiH/Ke5uhB+3IoL4z7fdAk1Zxp6hUkyUo03tTOJrs4KrBSHwVjb
 61wJuIGS
 EtwV47e+8xaMH7lM1mjdvW+z72miVr2ioK7LzZpyt8F5M4SlOjxMuvkni1wsP/aih5SjSWUZyTsghd2KJ2NKMR77n1mG7ijGN8YAhEhd2Oiz5fXpMqTFhmZjQ9Z2WGAcvD2VV3gKWA/lEgKVqVJJJ5IpVqAUS+FSrZybAQkrXyhbZKYCUjb4P8i+KC1VCB9h2MGF4X9P1vruwPRMxmKdgHtJ2gk/4swhNkfOVHCliujYwfVMLDqY7wxBw120i2c7xcMft7lDauRmhcIjmrauukzYClE/bzIkmOAG8J5DnjMLqfUC7lFHdRsC11vBuv9spRNx0SIywqZFhEOLRTPQb66PnkcJ5niivjWFtYTfOU1bQ3KPwYTbHsnrBffFGlPBMWOu4uuDzCzTocj/bsyK0w2r/fcziFtJYt5Uw4UeBc6hDsrqqNnJKuXhaSpNNX4C5+nePburTwlk8CvFtGKHFzz7+eSXDw8Nlki0darPFDBK60lbwU5yRDxOw6r3KjKI5WqBAvMuaZPO6jmEaYvVHp5FLcrIMwTRAX2y5g/J0t4jqik7tW1A30yMeP1xgIhaxZa57lws/yODnCFOT+Eoheom6a3nf6qTA8fE5S78BEldbXozN/GOxCMGdDyMBl8yQg0YKgMXgvJ1vl+Ge9kg1ErxnIg==
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

Signed-off-by: Alban Crequy <albancrequy@microsoft.com>
---
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
 tools/testing/selftests/mm/process_vm_readv.c | 421 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   4 +
 4 files changed, 431 insertions(+)
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
index 000000000000..0479ae424c78
--- /dev/null
+++ b/tools/testing/selftests/mm/process_vm_readv.c
@@ -0,0 +1,421 @@
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
+	ASSERT_EQ(-1, n);
+	ASSERT_EQ(EFAULT, errno);
+
+	munmap(mem, page_size);
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


