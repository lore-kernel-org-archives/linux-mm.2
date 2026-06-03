Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7A74CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0956B0095; Wed,  3 Jun 2026 08:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265F16B009B; Wed,  3 Jun 2026 08:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E256B0098; Wed,  3 Jun 2026 08:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2FB36B0095
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:56:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E78D8D335
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:56:15 +0000 (UTC)
X-FDA: 84838599510.13.DAC5A16
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf15.hostedemail.com (Postfix) with ESMTP id 09D08A0017
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:56:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=HPbq2RCU;
	spf=pass (imf15.hostedemail.com: domain of "prvs=46141c1cd1=mnissler@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=46141c1cd1=mnissler@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780491373;
	b=UI01KM5yb1072/+bJuOoj5V7tV2H7HKeKZzAtxHQvXae37KsZgmlBhTLrjtwsoc0DOSrLa
	st/Mh8+pvf+C9Si/CvVv/gXN91Ri1OdIrNeW+SvrLtWN6n9Pi7/XGWhAiMrE0vDr1p+NO1
	vyU0fpq/J6mCvF197dFYzpEDjPsGdTM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=HPbq2RCU;
	spf=pass (imf15.hostedemail.com: domain of "prvs=46141c1cd1=mnissler@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=46141c1cd1=mnissler@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780491373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nBwBIUCMdRNvL7f/v1/Q1s15uv1gsyHqvb+RTBqsOdw=;
	b=lryIcVCG11whwkwG4fkEyj5wAyvJ+fs6HfzE4JRdPvRanoIbs5wS/7PfNREUDTb+0/VVo+
	Zc24GO0ET1TSgHsGn6r0/oYBDO4QgsXoodE+jprSDY2ejFixXW0Y9hYpJXCxAV14CD300J
	mlym4+JZ2YINeV8350/990IAxIGCXU0=
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 652MSFX13309990;
	Wed, 3 Jun 2026 05:56:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=nBwBIUCMdRNvL7f/v1/Q1s15uv1gsyHqvb+RTBqsOdw=; b=HPbq2RCUB7cL
	0SDXx+OKhe6D+L+K9YZClpeSNCYhNAfaPWCW20fh5i+uof+PuneDgqnBLLhj5A4Q
	AIAMfk5DdFZ5OnsR/dkOJlGTChC2uUQhl6XFiFHwHL9/tGBf2pslG9tLaK5pGbOf
	VdAkZdQvehssZqfGlqJd+Kj3BngLLPCUFlgXuRUOPtnAkuvP+0U9H/uqBhJvjgy8
	2ZiItOk1wEfPHOCCfHbm6FfH54l9g3inbN3TSFTD58aH6fbDVkIrJ5KttO1WlwtC
	8h8IBtWqQTSX92cKI4Y4NbE/AwT9dbKbIdhJh4WwJOj9B1DLg4epF3ppYDHzA/ez
	ETOp2XSUWA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4ej14mxx6e-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 03 Jun 2026 05:56:10 -0700 (PDT)
Received: from localhost (2620:10d:c085:108::4) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.41; Wed, 3 Jun
 2026 12:56:08 +0000
From: Mattias Nissler <mnissler@meta.com>
To: <linux-mm@kvack.org>
CC: Hugh Dickins <hughd@google.com>,
        Baolin Wang
	<baolin.wang@linux.alibaba.com>, <mnissler@meta.com>,
        <mattias.nissler@gmail.com>
Subject: [RFC PATCH 2/2] selftests: `memfd_tripwire` selftest
Date: Wed, 3 Jun 2026 05:55:21 -0700
Message-ID: <20260603125521.1468362-3-mnissler@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260603125521.1468362-1-mnissler@meta.com>
References: <20260603125521.1468362-1-mnissler@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::4]
X-Proofpoint-GUID: 440piY091cWxMuRaErXoomyl6Bn-XuSx
X-Proofpoint-ORIG-GUID: 440piY091cWxMuRaErXoomyl6Bn-XuSx
X-Authority-Analysis: v=2.4 cv=d9XFDxjE c=1 sm=1 tr=0 ts=6a20246a cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=wpfVPzegXHpEFt3DAXn9:22 a=VabnemYjAAAA:8 a=g6bl-ZKSQ4VxT3QDCaQA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAzMDEyNCBTYWx0ZWRfX5+uLB7RZx+jP
 G3XEoml/cqfOFvmf4cjsilKtlIVKvax6RWQwSCSO5M8dLo6B6Nz0bfwN2KpDIiOF8wzkINRxrNv
 NSYEGAUXOIA8nd0IIIFpu13KAct2jQ/sg7U4l8SW4rPzK4Y8SoPH6WXE4hhHbhNl2I7UniBwkER
 O6F7nj4Si+DSQkPKPejrxg6Goybxk+7KW6wuOxdeJOWEqggfgxMu+9nGgSJnKzIHfkbl8LLTi+W
 w8qaZZZ+Uk4V+ksFrblJJEPX8kS4T4rfUKAunrCE10xjhpJpbBVq77UnqpCgnK0/pdUebgMgAOp
 0pDBnJUj53Mpa8+jk+z92ANKQhJEonEawvnK3qxJMjN8++sBNnYnJ7I4ZKihRwb3SnLl6Rp62JR
 y/e0QD0rtSixQlvQ3Ppsj8JW4Ndzm85hxAD0gQBULmJiyTSWNSKFVRpBWhmc5KjKe3pqZeyr6zj
 S3PMR1SZZ6pYx36ubkg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-03_04,2026-05-28_03,2025-10-01_01
X-Rspamd-Queue-Id: 09D08A0017
X-Stat-Signature: xpdgqob3xzwn7grm3fepqdtqyqqa1ego
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780491372-435378
X-HE-Meta: U2FsdGVkX1/EREJSc2omMmtrTkSyyNP/fiobXlyu2c9GNHAxt5/7AhAPsCvki1eqr+QHW5z9un4bLL1pNB70BBqeycHf/MdQovAPpcyD4JwdBypOre8l411pXo+pU0BjOGnCgglNoDEK/DZZXVPtmJfuE0CDSSA3v0mcLuQWKLDj2TTLbWG+O7zqh3E8WigzLQ1Rbx9M6eVRypi1TUxqa0k0B7yvQzsjBjg1Orqp+VVj2wTkjGxujZ54qqjK/n/fZBzGZy9FyyTbpr33yRxzOhYziE0XITLw6Hkdqf/iTVi4WhgNpoIGAz9sBLyhoakBffQ6wr44S58wyfuYkbteN725cWVhcb5M/wN2i25Veiev0AwA+hsjt6NnvaIapyodixnOFJ+qNj1rm6B7ndPFScibteTzxZ3lDrWjiizkIW5av3UYPC4tQJ3MSMSB5jIndD45zjs6yHehGSIGxnIFLzrgSTDnryE5NtVRtAgNYqGMNMDdoxtMkYjrC9HZfRA9NtDkgVSxTge96YOhfJYZ/0p+e10v10O5bGPOTA8dMmtB/cCjWblCQgWxiJ7kItMsrR3WRnUDbNbxxUrv2GaPIT+YJSMy24s1uK8U573GqNP3GrRcgwKzDCYaMHwILo5Kw+ztlv1kRGo8KHj3r5UyNcgPUdFq8oGNZtA1AOScqld/b0yjrr7C4jmbHw0ludcmolrHT7Nz8h4XnSmjS1xYF7ljgQDH4LPSRTAnhtXxhxUP6yz+pKkCOa/1PJbupXU8Fy3UGlFDbuDU18qJCLcR0blhjF7UUgG/9BRtLOGSKmb24E6Aepnksj7821jILpAi4FTCccMYfCzchQ2J0/MxO2WFcOXc1HHj54Vx/jffDf3vnmoiuYSob26tn0kPEvU9pYS+YsCMSXk7yiKXv6ScV2LHgeyxtr29g2NfnBUiOHGWd1hhl2FI9qc6IrFDoE8SmZrfcD7qw6IEeJjNTie
 nSnFsGSd
 MfnSDnktiq81GQYDv376bjEAbzvldjBvWtN5FSwjFMh+pQbxEb6kzenpKm6HL3t/p00zrmWBV+aWbvDPCq+uRFQDpiQ9fcHaHJZvq6PMbs86kadsp4XHg5htdWXCEKOTaf+hkTHCJ7TfWs0eikatm3Meck5wBffl0ufkvYaYdvQFyNBwEOfThqidEs1NNgwmv935JLz6sfzqKUVCM6GJpkDKBdrj9NtUqVCW9Jp8XI5spXdf0ygH0lij1RUmAaRxfczD95fhrrDuZZJneptDjFqKHwuQy2hoXSHyjeMAULgeQJOqo+0XeefKX6eP9W5EVncXpnArFlk22l2V5BMShY1ycmxHirhNHMuUqq4UVp4eGsff7qRv75C71xqMYAfh9cSjH5P52O54zJpDgCEJH53eh/Ql5yINBndUCl529K+pd0Wkbvb6s3mSGryUDLjw2B5MMP8Jdc5br4JiYRslN2zUHvmvVYk/j+J5RjvBjdQDXlLKgaUa5ytOHlliHiTQlvpMJzk0mIA3Nc4+mpae+LZW8Xseb5/U44DmFPFPYzpxImDQCgHNP4yzwYLwTxSwfCtUXH1LNQJg20+c4yMEcdQzKoZdvJOZTEEGqeJgzRzk848Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test cases for `memfd_tripwire`, exercising basic semantics as well
as verifying behavior under stress.

Signed-off-by: Mattias Nissler <mnissler@meta.com>
Assisted-by: Claude:claude-opus-4-6
---
 tools/testing/selftests/mm/Makefile         |   1 +
 tools/testing/selftests/mm/memfd_tripwire.c | 695 ++++++++++++++++++++
 2 files changed, 696 insertions(+)
 create mode 100644 tools/testing/selftests/mm/memfd_tripwire.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index cd24596cdd27e..f87839733df5a 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -106,6 +106,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += memfd_tripwire
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/memfd_tripwire.c b/tools/testing/selftests/mm/memfd_tripwire.c
new file mode 100644
index 0000000000000..7229b387ffcf4
--- /dev/null
+++ b/tools/testing/selftests/mm/memfd_tripwire.c
@@ -0,0 +1,695 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * memfd_tripwire selftest
+ *
+ * Tests for the memfd_tripwire() syscall which creates a shared memory region
+ * with write notification support via poll() and ioctl-based re-arming.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <poll.h>
+#include <pthread.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdatomic.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <sys/wait.h>
+#include <time.h>
+#include <unistd.h>
+
+#include <linux/memfd_tripwire.h>
+
+#include "kselftest.h"
+
+#ifdef __NR_memfd_tripwire
+
+static int sys_memfd_tripwire(unsigned int flags)
+{
+	return syscall(__NR_memfd_tripwire, flags);
+}
+
+/*
+ * Poll the fd for POLLIN with the given timeout in milliseconds.
+ * Returns 1 if POLLIN is set, 0 on timeout, -1 on error.
+ */
+static int poll_check(int fd, int timeout_ms)
+{
+	struct pollfd pfd = { .fd = fd, .events = POLLIN };
+	int ret;
+
+	ret = poll(&pfd, 1, timeout_ms);
+	if (ret < 0)
+		return -1;
+	if (ret == 0)
+		return 0;
+	return (pfd.revents & POLLIN) ? 1 : 0;
+}
+
+static int tripwire_ack(int fd)
+{
+	return ioctl(fd, MEMFD_TRIPWIRE_ACK, 0);
+}
+
+static long page_size;
+
+static int setup_tripwire(size_t size, int *fd, char **mem)
+{
+	*fd = sys_memfd_tripwire(0);
+	if (*fd < 0) {
+		ksft_test_result_fail("memfd_tripwire: %m\n");
+		return -1;
+	}
+
+	if (ftruncate(*fd, size) < 0) {
+		ksft_test_result_fail("ftruncate: %m\n");
+		goto out;
+	}
+
+	*mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, *fd, 0);
+	if (*mem == MAP_FAILED) {
+		*mem = NULL;
+		ksft_test_result_fail("mmap: %m\n");
+		goto out;
+	}
+
+	return 0;
+
+out:
+	close(*fd);
+	return -1;
+}
+
+static double time_elapsed(struct timespec *start)
+{
+	struct timespec now;
+
+	clock_gettime(CLOCK_MONOTONIC, &now);
+	return (now.tv_sec - start->tv_sec) +
+	       (now.tv_nsec - start->tv_nsec) / 1e9;
+}
+
+/*
+ * Test 1: Sequential single-process semantics.
+ *
+ * Verifies the complete life cycle:
+ *   create -> poll (clean) -> write -> poll (dirty) -> ACK -> poll (clean)
+ *          -> write again -> poll (dirty)
+ */
+static void test_sequential(void)
+{
+	int fd;
+	char *mem;
+
+	if (setup_tripwire(page_size, &fd, &mem) != 0)
+		return;
+
+	/* Freshly created: should not have POLLIN */
+	if (poll_check(fd, 0) != 0) {
+		ksft_test_result_fail("POLLIN set on clean fd\n");
+		goto out;
+	}
+
+	/* Write to mapped memory */
+	mem[0] = 'A';
+
+	/* Should now report POLLIN */
+	if (poll_check(fd, 100) != 1) {
+		ksft_test_result_fail("POLLIN not set after write\n");
+		goto out;
+	}
+
+	/* Polling again without ACK should still show POLLIN */
+	if (poll_check(fd, 0) != 1) {
+		ksft_test_result_fail("POLLIN lost without ACK\n");
+		goto out;
+	}
+
+	/* ACK re-arms the tripwire */
+	if (tripwire_ack(fd) < 0) {
+		ksft_test_result_fail("ioctl ACK: %m\n");
+		goto out;
+	}
+
+	/* After ACK: should be clean again */
+	if (poll_check(fd, 0) != 0) {
+		ksft_test_result_fail("POLLIN set after ACK\n");
+		goto out;
+	}
+
+	/* Write again: must re-trigger */
+	mem[0] = 'B';
+
+	if (poll_check(fd, 100) != 1) {
+		ksft_test_result_fail("POLLIN not set after second write\n");
+		goto out;
+	}
+
+	ksft_test_result_pass("sequential\n");
+out:
+	munmap((void *)mem, page_size);
+	close(fd);
+}
+
+/*
+ * Test 2: Multi-page, writes to different pages trigger after re-arm.
+ */
+static void test_multi_page(void)
+{
+	int fd;
+	char *mem;
+	size_t size = page_size * 4;
+
+	if (setup_tripwire(size, &fd, &mem) != 0)
+		return;
+
+	/* Write page 0, observe, ACK */
+	mem[0] = 'A';
+	if (poll_check(fd, 100) != 1) {
+		ksft_test_result_fail("POLLIN not set after page 0 write\n");
+		goto out;
+	}
+	tripwire_ack(fd);
+
+	/* Write page 2: A different page must also trigger */
+	mem[page_size * 2] = 'B';
+	if (poll_check(fd, 100) != 1) {
+		ksft_test_result_fail("POLLIN not set after page 2 write\n");
+		goto out;
+	}
+	tripwire_ack(fd);
+
+	/* Write page 3 */
+	mem[page_size * 3] = 'C';
+	if (poll_check(fd, 100) != 1) {
+		ksft_test_result_fail("POLLIN not set after page 3 write\n");
+		goto out;
+	}
+
+	ksft_test_result_pass("multi_page\n");
+out:
+	munmap((void *)mem, size);
+	close(fd);
+}
+
+/*
+ * Test 3: Cross-process producer/consumer.
+ *
+ * Parent is the consumer (polls for events), child is the producer (writes
+ * to the shared mapping). Verifies that writes in the child process are
+ * visible to the parent via poll().
+ */
+static void test_cross_process(void)
+{
+	int fd, status;
+	char *mem;
+	pid_t pid;
+
+	if (setup_tripwire(page_size, &fd, &mem) != 0)
+		return;
+
+	pid = fork();
+	if (pid < 0) {
+		ksft_test_result_fail("fork: %m\n");
+		goto out;
+	}
+
+	if (pid == 0) {
+		/*
+		 * Child: wait a bit then write. The parent should be blocked
+		 * in poll() and wake up when we write.
+		 */
+		usleep(50000);
+		mem[0] = 'P';
+		_exit(0);
+	}
+
+	/* Parent: wait for the child's write */
+	if (poll_check(fd, 2000) != 1) {
+		ksft_test_result_fail("POLLIN not set after child write\n");
+		kill(pid, SIGKILL);
+		waitpid(pid, &status, 0);
+		goto out;
+	}
+
+	waitpid(pid, &status, 0);
+
+	if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
+		ksft_test_result_fail("child exited abnormally\n");
+		goto out;
+	}
+
+	/* Verify data written by child */
+	if (mem[0] != 'P') {
+		ksft_test_result_fail("data mismatch: got 0x%02x\n", mem[0]);
+		goto out;
+	}
+
+	ksft_test_result_pass("cross_process\n");
+out:
+	munmap((void *)mem, page_size);
+	close(fd);
+}
+
+/*
+ * Test 4: Multi-round cross-process producer/consumer.
+ *
+ * Uses a pipe to synchronize rounds between parent (consumer) and child
+ * (producer). Each round: child writes, parent detects via poll, parent
+ * ACKs, repeat. Verifies that the full cycle works reliably across
+ * process boundaries.
+ */
+static void test_cross_process_multi_round(void)
+{
+	int fd, status;
+	int pipe_to_child[2], pipe_to_parent[2];
+	char *mem;
+	pid_t pid;
+	int rounds = 1000;
+	char sync;
+
+	if (setup_tripwire(page_size, &fd, &mem) != 0)
+		return;
+
+	if (pipe(pipe_to_child) < 0 || pipe(pipe_to_parent) < 0) {
+		ksft_test_result_fail("pipe: %m\n");
+		goto out;
+	}
+
+	pid = fork();
+	if (pid < 0) {
+		ksft_test_result_fail("fork: %m\n");
+		goto out;
+	}
+
+	if (pid == 0) {
+		/* Child: producer */
+		close(pipe_to_child[1]);
+		close(pipe_to_parent[0]);
+
+		for (int i = 0; i < rounds; i++) {
+			/* Wait for parent to signal us to write */
+			if (read(pipe_to_child[0], &sync, 1) != 1)
+				_exit(1);
+			mem[0] = 'A' + i;
+			/* Tell parent we wrote */
+			if (write(pipe_to_parent[1], &sync, 1) != 1)
+				_exit(1);
+		}
+		_exit(0);
+	}
+
+	/* Parent: consumer */
+	close(pipe_to_child[0]);
+	close(pipe_to_parent[1]);
+
+	for (int i = 0; i < rounds; i++) {
+		/* Tell child to write */
+		sync = 'G';
+		if (write(pipe_to_child[1], &sync, 1) != 1) {
+			ksft_test_result_fail("write to pipe: %m\n");
+			goto reap;
+		}
+
+		/* Wait for child to confirm write */
+		if (read(pipe_to_parent[0], &sync, 1) != 1) {
+			ksft_test_result_fail("read from pipe: %m\n");
+			goto reap;
+		}
+
+		/* Detect the write */
+		if (poll_check(fd, 1000) != 1) {
+			ksft_test_result_fail("round %d: POLLIN not set\n", i);
+			goto reap;
+		}
+
+		/* Verify data */
+		if (mem[0] != (char)('A' + i)) {
+			ksft_test_result_fail("round %d: data 0x%02x\n", i,
+					      mem[0]);
+			goto reap;
+		}
+
+		/* Re-arm for next round */
+		if (tripwire_ack(fd) < 0) {
+			ksft_test_result_fail("round %d: ACK: %m\n", i);
+			goto reap;
+		}
+
+		/* Confirm clean after ACK */
+		if (poll_check(fd, 0) != 0) {
+			ksft_test_result_fail("round %d: POLLIN after ACK\n",
+					      i);
+			goto reap;
+		}
+	}
+
+	close(pipe_to_child[1]);
+	close(pipe_to_parent[0]);
+
+	waitpid(pid, &status, 0);
+	if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
+		ksft_test_result_fail("child exited abnormally\n");
+		goto out;
+	}
+
+	ksft_test_result_pass("cross_process_multi_round\n");
+	munmap((void *)mem, page_size);
+	close(fd);
+	return;
+
+reap:
+	close(pipe_to_child[1]);
+	close(pipe_to_parent[0]);
+	kill(pid, SIGKILL);
+	waitpid(pid, &status, 0);
+out:
+	munmap((void *)mem, page_size);
+	close(fd);
+}
+
+/*
+ * Test 5: Producer/consumer race stress test.
+ *
+ * A producer thread writes continuously while the consumer thread polls and
+ * ACKs. The invariant is: we must never "miss" an event. Specifically, after
+ * the consumer ACKs and the producer writes at least once more, the consumer
+ * must eventually see POLLIN again.
+ *
+ * We use an atomic generation counter to track this. The producer increments
+ * the generation and writes to the mapping. The consumer records the
+ * generation at ACK time and verifies that when it next sees POLLIN, the
+ * generation has advanced.
+ */
+static atomic_int stress_gen;
+static atomic_bool stress_stop;
+
+static void *stress_producer(void *arg)
+{
+	char *mem = arg;
+
+	while (!atomic_load(&stress_stop)) {
+		atomic_fetch_add(&stress_gen, 1);
+		mem[0]++;
+		/* Intentionally no explicit delay to maximize contention */
+	}
+
+	return NULL;
+}
+
+static void test_stress_no_lost_events(void)
+{
+	int fd;
+	char *mem;
+	pthread_t producer;
+	int ack_count = 0;
+	int gen_at_ack, cur_gen;
+	struct timespec start;
+
+	if (setup_tripwire(page_size, &fd, &mem) != 0)
+		return;
+
+	atomic_store(&stress_gen, 0);
+	atomic_store(&stress_stop, false);
+
+	if (pthread_create(&producer, NULL, stress_producer, (void *)mem)) {
+		ksft_test_result_fail("pthread_create: %m\n");
+		goto out;
+	}
+
+	/*
+	 * Consumer loop: run for ~2 seconds. In each iteration:
+	 *   1. Wait for POLLIN (the producer is writing continuously)
+	 *   2. Record the current generation
+	 *   3. ACK (re-arm)
+	 *   4. The producer is still writing, so POLLIN must come back
+	 */
+	clock_gettime(CLOCK_MONOTONIC, &start);
+	while (time_elapsed(&start) <= 2.0) {
+		/*
+		 * Wait for a write notification. The producer is looping, so
+		 * the timeout should be plenty.
+		 */
+		if (poll_check(fd, 1000) != 1) {
+			ksft_test_result_fail(
+				"POLLIN not set (ack_count=%d, gen=%d)\n",
+				ack_count, atomic_load(&stress_gen));
+			atomic_store(&stress_stop, true);
+			pthread_join(producer, NULL);
+			goto out;
+		}
+
+		/* Record generation and ACK */
+		gen_at_ack = atomic_load(&stress_gen);
+		if (tripwire_ack(fd) < 0) {
+			ksft_test_result_fail("ACK failed: %m\n");
+			atomic_store(&stress_stop, true);
+			pthread_join(producer, NULL);
+			goto out;
+		}
+		ack_count++;
+
+		/*
+		 * The producer is running concurrently. After ACK, it will
+		 * write again and increment the generation. We don't need to
+		 * check anything here because the next poll() iteration will
+		 * verify that the write was detected.
+		 *
+		 * Spin briefly to let the producer get ahead, exercising the
+		 * race between ACK (write-protect) and producer (write).
+		 */
+		cur_gen = atomic_load(&stress_gen);
+		while (cur_gen == gen_at_ack) {
+			sched_yield();
+			cur_gen = atomic_load(&stress_gen);
+		}
+	}
+
+	atomic_store(&stress_stop, true);
+	pthread_join(producer, NULL);
+
+	if (ack_count < 10) {
+		ksft_test_result_fail("too few ACK cycles: %d\n", ack_count);
+		goto out;
+	}
+
+	ksft_print_msg("stress: %d ACK cycles, final gen=%d\n", ack_count,
+		       atomic_load(&stress_gen));
+	ksft_test_result_pass("stress_no_lost_events\n");
+out:
+	munmap((void *)mem, page_size);
+	close(fd);
+}
+
+/*
+ * Test 6: Randomized multi-thread visibility stress test.
+ *
+ * N_VIS_WRITERS writer threads and N_VIS_READERS reader threads operate
+ * concurrently on a shared memfd_tripwire mapping for VIS_DURATION_S seconds.
+ * Each writer owns a uint32_t slot on its own page and writes monotonically
+ * increasing values, interspersed with random sleeps. Each reader randomly
+ * polls or sleeps; on POLLIN it snapshots committed values, ACKs, then reads
+ * the mapped memory and validates visibility.
+ *
+ * The invariant under test: after a reader calls ACK, all writes that were
+ * committed (writer_committed[i] updated with store-release) before the
+ * reader's snapshot (loaded with load-acquire) must be visible when reading
+ * the mapped memory. The ACK's TLB-flush IPI provides the cross-CPU memory
+ * barrier that makes this guarantee hold.
+ */
+
+#define N_VIS_WRITERS 4
+#define N_VIS_READERS 2
+#define VIS_DURATION_S 2
+#define VIS_WRITER_SLEEP_PCT 20
+#define VIS_READER_SLEEP_PCT 30
+#define VIS_MAX_WRITER_SLEEP_US 1000
+#define VIS_MAX_READER_SLEEP_US 3000
+
+struct vis_ctx {
+	int fd;
+	char *mem;
+	atomic_uint writer_committed[N_VIS_WRITERS];
+	atomic_bool stop;
+	atomic_bool failed;
+	char failure_msg[256];
+};
+
+struct vis_thread_arg {
+	struct vis_ctx *ctx;
+	int id;
+};
+
+static void *vis_writer_fn(void *arg)
+{
+	struct vis_thread_arg *ta = arg;
+	struct vis_ctx *ctx = ta->ctx;
+	int id = ta->id;
+	uint32_t *slot = (uint32_t *)(ctx->mem + id * page_size);
+	uint32_t value = 0;
+	unsigned int seed = (unsigned int)(id * 7919 + 1);
+
+	while (!atomic_load_explicit(&ctx->stop, memory_order_relaxed)) {
+		if (rand_r(&seed) % 100 < VIS_WRITER_SLEEP_PCT) {
+			usleep(rand_r(&seed) % VIS_MAX_WRITER_SLEEP_US);
+			continue;
+		}
+
+		value++;
+		*slot = value;
+		atomic_store_explicit(&ctx->writer_committed[id], value,
+				      memory_order_release);
+	}
+
+	return NULL;
+}
+
+static void *vis_reader_fn(void *arg)
+{
+	struct vis_thread_arg *ta = arg;
+	struct vis_ctx *ctx = ta->ctx;
+	uint32_t snapshot[N_VIS_WRITERS];
+	unsigned int seed = (unsigned int)(ta->id * 6971 + 42);
+	int i;
+
+	while (!atomic_load_explicit(&ctx->stop, memory_order_relaxed)) {
+		if (atomic_load_explicit(&ctx->failed, memory_order_relaxed))
+			break;
+
+		if (rand_r(&seed) % 100 < VIS_READER_SLEEP_PCT) {
+			usleep(rand_r(&seed) % VIS_MAX_READER_SLEEP_US);
+			continue;
+		}
+
+		if (poll_check(ctx->fd, 100) != 1)
+			continue;
+
+		for (i = 0; i < N_VIS_WRITERS; i++)
+			snapshot[i] =
+				atomic_load_explicit(&ctx->writer_committed[i],
+						     memory_order_acquire);
+
+		tripwire_ack(ctx->fd);
+
+		for (i = 0; i < N_VIS_WRITERS; i++) {
+			uint32_t *slot = (uint32_t *)(ctx->mem + i * page_size);
+			uint32_t observed = *slot;
+
+			if (observed < snapshot[i]) {
+				snprintf(
+					ctx->failure_msg,
+					sizeof(ctx->failure_msg),
+					"writer %d: observed %u < committed %u",
+					i, observed, snapshot[i]);
+				atomic_store(&ctx->failed, true);
+				atomic_store(&ctx->stop, true);
+				return NULL;
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static void test_stress_visibility(void)
+{
+	struct vis_ctx ctx;
+	struct vis_thread_arg wargs[N_VIS_WRITERS];
+	struct vis_thread_arg rargs[N_VIS_READERS];
+	pthread_t writers[N_VIS_WRITERS];
+	pthread_t readers[N_VIS_READERS];
+	size_t map_size = N_VIS_WRITERS * page_size;
+	struct timespec start;
+	int i, nw = 0, nr = 0;
+
+	if (setup_tripwire(map_size, &ctx.fd, &ctx.mem) != 0)
+		return;
+
+	atomic_store(&ctx.stop, false);
+	atomic_store(&ctx.failed, false);
+	ctx.failure_msg[0] = '\0';
+	for (i = 0; i < N_VIS_WRITERS; i++)
+		atomic_store(&ctx.writer_committed[i], 0);
+
+	for (i = 0; i < N_VIS_WRITERS; i++) {
+		wargs[i].ctx = &ctx;
+		wargs[i].id = i;
+		if (pthread_create(&writers[i], NULL, vis_writer_fn, &wargs[i]))
+			goto stop;
+		nw++;
+	}
+
+	for (i = 0; i < N_VIS_READERS; i++) {
+		rargs[i].ctx = &ctx;
+		rargs[i].id = i;
+		if (pthread_create(&readers[i], NULL, vis_reader_fn, &rargs[i]))
+			goto stop;
+		nr++;
+	}
+
+	clock_gettime(CLOCK_MONOTONIC, &start);
+	do {
+		usleep(100000);
+	} while (time_elapsed(&start) <= VIS_DURATION_S &&
+		 !atomic_load(&ctx.failed));
+
+stop:
+	atomic_store(&ctx.stop, true);
+	for (i = 0; i < nr; i++)
+		pthread_join(readers[i], NULL);
+	for (i = 0; i < nw; i++)
+		pthread_join(writers[i], NULL);
+
+	if (atomic_load(&ctx.failed)) {
+		ksft_test_result_fail("visibility: %s\n", ctx.failure_msg);
+	} else {
+		for (i = 0; i < N_VIS_WRITERS; i++) {
+			ksft_print_msg("visibility: writer %d committed %u\n",
+				       i,
+				       atomic_load(&ctx.writer_committed[i]));
+		}
+		ksft_test_result_pass("stress_visibility\n");
+	}
+
+	munmap((void *)ctx.mem, map_size);
+	close(ctx.fd);
+}
+
+#define NUM_TESTS 6
+
+int main(void)
+{
+	page_size = sysconf(_SC_PAGE_SIZE);
+	if (!page_size)
+		ksft_exit_fail_msg("Failed to get page size %m\n");
+
+	ksft_print_header();
+	ksft_set_plan(NUM_TESTS);
+
+	test_sequential();
+	test_multi_page();
+	test_cross_process();
+	test_cross_process_multi_round();
+	test_stress_no_lost_events();
+	test_stress_visibility();
+
+	ksft_finished();
+	return 0;
+}
+
+#else /* __NR_memfd_tripwire */
+
+int main(int argc, char *argv[])
+{
+	printf("skip: skipping memfd_tripwire test (missing __NR_memfd_tripwire)\n");
+	return KSFT_SKIP;
+}
+
+#endif /* __NR_memfd_tripwire */
-- 
2.52.0


