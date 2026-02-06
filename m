Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92DF8ECD9BF
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 03:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A3D6B0092; Thu,  5 Feb 2026 22:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0FB96B0098; Thu,  5 Feb 2026 22:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C836B0093; Thu,  5 Feb 2026 22:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A58DB6B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:06:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72BCC1A0653
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:06:34 +0000 (UTC)
X-FDA: 84412543908.08.BAF63A8
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf21.hostedemail.com (Postfix) with ESMTP id A17E11C0007
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:06:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FJDRmYjE;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770347192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3YiiVFivrrauzk3iKGEroyfSWtS+uhzpXgx86baWfE=;
	b=nH6QvdAbDHRsumYbh71+6aM7fgIEscvxvBsaScbMMTCUaYGIjBdLM8GX9pIPuJxEem+May
	oRHZmzonQVmdxbE8X/vmxkUa/y2WiUqmeH0mkWOSpSoZh/7azRKcjiwrbD9DtP4IkGrJ9Q
	9FcjNBcK2Q9EAwhOhMjHMKeXnfMsxHo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FJDRmYjE;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770347192; a=rsa-sha256;
	cv=none;
	b=jyZyokpNJZoVnK7uozxxE4IFsQlCYOkMSX/JL3sbqJH+MjUOa+CRLXdwOPzzpd2EJpjA9Y
	pGVpl+h42IMg84pmRqg2ispXlrunh19bcykX7cZMKSwMnszq3MRE76q1bLYJunKWxUM8gX
	IYC/XHGm26g1TrDenvfIvJlWKa9MekI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=H3YiiVFivrrauzk3iKGEroyfSWtS+uhzpXgx86baWfE=;
	b=FJDRmYjEvpZ5Mw6YCHGLaPTuWpc5QPIkdROpfBAG2W51dvebMJYG3WjKT0uCAKD6KJudxm3I3
	TftngB0IEUqsK+7dRy+jquR4y6bwNlt0+BmTVDtgYWLXYyZJkD+ZQuzKY/oppLqecFo+Wesusth
	vWgOFpJzYVWdfeqI1kRO9r4=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f6f5p5m5bznTVK;
	Fri,  6 Feb 2026 11:02:38 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 9DA7D40563;
	Fri,  6 Feb 2026 11:06:27 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 6 Feb 2026 11:06:27 +0800
Received: from huawei.com (10.173.125.37) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 6 Feb
 2026 11:06:26 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>, <shuah@kernel.org>
CC: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<broonie@kernel.org>, <linmiaohe@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: [PATCH v4 1/3] selftests/mm: add memory failure anonymous page test
Date: Fri, 6 Feb 2026 11:16:37 +0800
Message-ID: <20260206031639.2707102-2-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260206031639.2707102-1-linmiaohe@huawei.com>
References: <20260206031639.2707102-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A17E11C0007
X-Stat-Signature: 78te3b435osqj3z67oosak9p5hn98y3o
X-Rspam-User: 
X-HE-Tag: 1770347191-793951
X-HE-Meta: U2FsdGVkX18indmB83bS7TXZlf4raoV7BP/xis8rIEucmz+EcFwrjvxaNWNwBNsn1Ba+JywP5ysnI9gIkMES3D8yCiOI29Qb8OTzDsL3utI+7rRHOQ/FR7IvXXQzktlTETk5A7v1sx+HlBCkZxrEx3taF02Hwubu/hoctA6bwU4OGEvxZ2QSMOWD9dz6gM2XY2OaeVClsvSHR3iguflvDnBNsZlWUfNNjn6X1wk3bS2NH3ibRLZELOex3SAu41l4iXrKWad9T0j0sQ9B6Aau/bO2wpbaGzXV2dE4yCxUxUd64Wfk3c0ZoSeyEXdY0Csshb/YQlkU6tGDn2ro/8hJlJgJjb9usdoEjPYczBXYhlMdSrsNiB3eQv86Db/XX7Rbn005EzNYWlMvPbl0ev+JvXpaqoFERCqyC7mL39g7+5Fyt3qu010omKodO2Dv3uuAb8MJs3pm37LFVITszG0TQCZrYtqcomWcUdKE0YsD32d6QesRXIjhdA6e6XtCl9FIuGgA+JIgSwsyehQk5B/U5iKowhCg/TiT73FGgHtuR6/8EFGV4Q3WBXpj/bpF1BGuXO1a57cjVFLnIYGDsAJxziwF1S8ywRQbgqJ9RKo14FoCbePSL6fXa1weJ9KiSOdiYbWLJXrhiHwmPuyatnp4l0C9HiyuNfboXXy0n2uuQU9PfeKdPUGpf5ueIL3n6yAJ1vwRZeeUPEr1oRSoeohQiAKiYa+JAGB2YAP99f4unAdncQmFeFEEJKEa16/dXy9ysjU13eNqT4pPzP8CQeNM2nsiz/6OmjG6SVMkUswzKDjcYu/ZiHfVpoOhXEWUgLex6vuqRjKwslAWitk0vmyVjZ3sQQSMedHRdJptcB9KBqeaz8ZxASga1/LIC/uOK/q0NDP5UKnHcF+i2+cganrxNHVAg2Yln9Lx/+BX3fjdstIoJ/BUUPr0GJ1kC7yBA+mkjNwCyaeRZmKj/4V6727
 oki+XGmB
 bfjmEh3l2/MLFzwlQh8my9uJmtPqayIB+4t+FpzoSXXfDnNEKWTMLiIMI+S+4uQTJaezPYA9aZfNzxJwC1taxXzMQutnA3kPdheYFmJTP+aMGUjAPGRMcegf8V0gbCo8Pv5b/7GfAAhJJxVMg5dL3bCxPdRrc4X4mr6Uhv/28sYtmoLCfHkdlZnRpgNe4kSzfQFGCacAUWA9ywBPY4o75O3aN0F6wq7qf6TfVHu9CgW3QVUQF45GukVQej4cuM9o/TPWxg7ZZbwzRy7vfKxVuP5+qjplwFdiALLHzyhxhzfSLWtVu8zX4gWlMCCxcE9hCJhKXV/DXCXiak7XTPMU8lkFUDGIv5N0eoI21HmqN9Y1jSVPiDWlx3lTcjSEj7qpTWI93Tid6CyRuyid2FZhZBM+iT52+NP0B3z1CK+M0/zAEiv8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds a new kselftest to validate memory failure handling for
anonymous pages. The test performs the following operations:
1. Allocates anonymous pages using mmap().
2. Injects memory failure via madvise syscall.
3. Verifies expected error handling behavior.
4. Unpoison memory.

This test helps ensure that memory failure handling for anonymous pages
works correctly, including proper SIGBUS delivery to user processes, page
isolation and recovery paths.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   2 +
 tools/testing/selftests/mm/config             |   2 +
 .../selftests/mm/ksft_memory_failure.sh       |   4 +
 tools/testing/selftests/mm/memory-failure.c   | 239 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |  21 ++
 tools/testing/selftests/mm/vm_util.c          |  41 +++
 tools/testing/selftests/mm/vm_util.h          |   3 +
 9 files changed, 314 insertions(+)
 create mode 100755 tools/testing/selftests/mm/ksft_memory_failure.sh
 create mode 100644 tools/testing/selftests/mm/memory-failure.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 64006f19954e..18d1ebf053db 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11691,6 +11691,7 @@ F:	include/linux/memory-failure.h
 F:	include/trace/events/memory-failure.h
 F:	mm/hwpoison-inject.c
 F:	mm/memory-failure.c
+F:	tools/testing/selftests/mm/memory-failure.c
 
 HYCON HY46XX TOUCHSCREEN SUPPORT
 M:	Giulio Benetti <giulio.benetti@benettiengineering.com>
diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index 702e5723c35d..bfd94a79e975 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -12,6 +12,7 @@ map_hugetlb
 map_populate
 thuge-gen
 compaction_test
+memory-failure
 migration
 mlock2-tests
 mrelease_test
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 905f1e034963..4847c6d6c1b0 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -75,6 +75,7 @@ TEST_GEN_FILES += map_populate
 ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64))
 TEST_GEN_FILES += memfd_secret
 endif
+TEST_GEN_FILES += memory-failure
 TEST_GEN_FILES += migration
 TEST_GEN_FILES += mkdirty
 TEST_GEN_FILES += mlock-random-test
@@ -154,6 +155,7 @@ TEST_PROGS += ksft_ksm_numa.sh
 TEST_PROGS += ksft_madv_guard.sh
 TEST_PROGS += ksft_madv_populate.sh
 TEST_PROGS += ksft_memfd_secret.sh
+TEST_PROGS += ksft_memory_failure.sh
 TEST_PROGS += ksft_migration.sh
 TEST_PROGS += ksft_mkdirty.sh
 TEST_PROGS += ksft_mlock.sh
diff --git a/tools/testing/selftests/mm/config b/tools/testing/selftests/mm/config
index deba93379c80..1dbe2b4558ab 100644
--- a/tools/testing/selftests/mm/config
+++ b/tools/testing/selftests/mm/config
@@ -11,3 +11,5 @@ CONFIG_ANON_VMA_NAME=y
 CONFIG_FTRACE=y
 CONFIG_PROFILING=y
 CONFIG_UPROBES=y
+CONFIG_MEMORY_FAILURE=y
+CONFIG_HWPOISON_INJECT=m
diff --git a/tools/testing/selftests/mm/ksft_memory_failure.sh b/tools/testing/selftests/mm/ksft_memory_failure.sh
new file mode 100755
index 000000000000..ae1614d4d49b
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_memory_failure.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t memory-failure
diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
new file mode 100644
index 000000000000..37806a58f4b4
--- /dev/null
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -0,0 +1,239 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Memory-failure functional tests.
+ *
+ * Author(s): Miaohe Lin <linmiaohe@huawei.com>
+ */
+
+#include "../kselftest_harness.h"
+
+#include <sys/mman.h>
+#include <linux/mman.h>
+#include <linux/string.h>
+#include <signal.h>
+#include <setjmp.h>
+#include <unistd.h>
+#include <fcntl.h>
+
+#include "vm_util.h"
+
+enum inject_type {
+	MADV_HARD,
+	MADV_SOFT,
+};
+
+enum result_type {
+	MADV_HARD_ANON,
+	MADV_SOFT_ANON,
+};
+
+static jmp_buf signal_jmp_buf;
+static siginfo_t siginfo;
+const char *pagemap_proc = "/proc/self/pagemap";
+const char *kpageflags_proc = "/proc/kpageflags";
+
+FIXTURE(memory_failure)
+{
+	unsigned long page_size;
+	unsigned long corrupted_size;
+	unsigned long pfn;
+	int pagemap_fd;
+	int kpageflags_fd;
+	bool triggered;
+};
+
+FIXTURE_VARIANT(memory_failure)
+{
+	enum inject_type type;
+	int (*inject)(FIXTURE_DATA(memory_failure) * self, void *vaddr);
+};
+
+static int madv_hard_inject(FIXTURE_DATA(memory_failure) * self, void *vaddr)
+{
+	return madvise(vaddr, self->page_size, MADV_HWPOISON);
+}
+
+FIXTURE_VARIANT_ADD(memory_failure, madv_hard)
+{
+	.type = MADV_HARD,
+	.inject = madv_hard_inject,
+};
+
+static int madv_soft_inject(FIXTURE_DATA(memory_failure) * self, void *vaddr)
+{
+	return madvise(vaddr, self->page_size, MADV_SOFT_OFFLINE);
+}
+
+FIXTURE_VARIANT_ADD(memory_failure, madv_soft)
+{
+	.type = MADV_SOFT,
+	.inject = madv_soft_inject,
+};
+
+static void sigbus_action(int signo, siginfo_t *si, void *args)
+{
+	memcpy(&siginfo, si, sizeof(siginfo_t));
+	siglongjmp(signal_jmp_buf, 1);
+}
+
+static int setup_sighandler(void)
+{
+	struct sigaction sa = {
+		.sa_sigaction = sigbus_action,
+		.sa_flags = SA_SIGINFO,
+	};
+
+	return sigaction(SIGBUS, &sa, NULL);
+}
+
+FIXTURE_SETUP(memory_failure)
+{
+	memset(self, 0, sizeof(*self));
+
+	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
+
+	memset(&siginfo, 0, sizeof(siginfo));
+	if (setup_sighandler())
+		SKIP(return, "setup sighandler failed.\n");
+
+	self->pagemap_fd = open(pagemap_proc, O_RDONLY);
+	if (self->pagemap_fd == -1)
+		SKIP(return, "open %s failed.\n", pagemap_proc);
+
+	self->kpageflags_fd = open(kpageflags_proc, O_RDONLY);
+	if (self->kpageflags_fd == -1)
+		SKIP(return, "open %s failed.\n", kpageflags_proc);
+}
+
+static void teardown_sighandler(void)
+{
+	struct sigaction sa = {
+		.sa_handler = SIG_DFL,
+		.sa_flags = SA_SIGINFO,
+	};
+
+	sigaction(SIGBUS, &sa, NULL);
+}
+
+FIXTURE_TEARDOWN(memory_failure)
+{
+	close(self->kpageflags_fd);
+	close(self->pagemap_fd);
+	teardown_sighandler();
+}
+
+static void prepare(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
+		    void *vaddr)
+{
+	self->pfn = pagemap_get_pfn(self->pagemap_fd, vaddr);
+	ASSERT_NE(self->pfn, -1UL);
+
+	ASSERT_EQ(get_hardware_corrupted_size(&self->corrupted_size), 0);
+}
+
+static bool check_memory(void *vaddr, unsigned long size)
+{
+	char buf[64];
+
+	memset(buf, 0xce, sizeof(buf));
+	while (size >= sizeof(buf)) {
+		if (memcmp(vaddr, buf, sizeof(buf)))
+			return false;
+		size -= sizeof(buf);
+		vaddr += sizeof(buf);
+	}
+
+	return true;
+}
+
+static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
+		  void *vaddr, enum result_type type, int setjmp)
+{
+	unsigned long size;
+	uint64_t pfn_flags;
+
+	switch (type) {
+	case MADV_SOFT_ANON:
+		/* It is not expected to receive a SIGBUS signal. */
+		ASSERT_EQ(setjmp, 0);
+
+		/* The page content should remain unchanged. */
+		ASSERT_TRUE(check_memory(vaddr, self->page_size));
+
+		/* The backing pfn of addr should have changed. */
+		ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self->pfn);
+		break;
+	case MADV_HARD_ANON:
+		/* The SIGBUS signal should have been received. */
+		ASSERT_EQ(setjmp, 1);
+
+		/* Check if siginfo contains correct SIGBUS context. */
+		ASSERT_EQ(siginfo.si_signo, SIGBUS);
+		ASSERT_EQ(siginfo.si_code, BUS_MCEERR_AR);
+		ASSERT_EQ(1UL << siginfo.si_addr_lsb, self->page_size);
+		ASSERT_EQ(siginfo.si_addr, vaddr);
+
+		/* XXX Check backing pte is hwpoison entry when supported. */
+		ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, vaddr));
+		break;
+	default:
+		SKIP(return, "unexpected inject type %d.\n", type);
+	}
+
+	/* Check if the value of HardwareCorrupted has increased. */
+	ASSERT_EQ(get_hardware_corrupted_size(&size), 0);
+	ASSERT_EQ(size, self->corrupted_size + self->page_size / 1024);
+
+	/* Check if HWPoison flag is set. */
+	ASSERT_EQ(pageflags_get(self->pfn, self->kpageflags_fd, &pfn_flags), 0);
+	ASSERT_EQ(pfn_flags & KPF_HWPOISON, KPF_HWPOISON);
+}
+
+static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
+		    void *vaddr)
+{
+	unsigned long size;
+	uint64_t pfn_flags;
+
+	ASSERT_EQ(unpoison_memory(self->pfn), 0);
+
+	/* Check if HWPoison flag is cleared. */
+	ASSERT_EQ(pageflags_get(self->pfn, self->kpageflags_fd, &pfn_flags), 0);
+	ASSERT_NE(pfn_flags & KPF_HWPOISON, KPF_HWPOISON);
+
+	/* Check if the value of HardwareCorrupted has decreased. */
+	ASSERT_EQ(get_hardware_corrupted_size(&size), 0);
+	ASSERT_EQ(size, self->corrupted_size);
+}
+
+TEST_F(memory_failure, anon)
+{
+	char *addr;
+	int ret;
+
+	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (addr == MAP_FAILED)
+		SKIP(return, "mmap failed, not enough memory.\n");
+	memset(addr, 0xce, self->page_size);
+
+	prepare(_metadata, self, addr);
+
+	ret = sigsetjmp(signal_jmp_buf, 1);
+	if (!self->triggered) {
+		self->triggered = true;
+		ASSERT_EQ(variant->inject(self, addr), 0);
+		FORCE_READ(*addr);
+	}
+
+	if (variant->type == MADV_HARD)
+		check(_metadata, self, addr, MADV_HARD_ANON, ret);
+	else
+		check(_metadata, self, addr, MADV_SOFT_ANON, ret);
+
+	cleanup(_metadata, self, addr);
+
+	ASSERT_EQ(munmap(addr, self->page_size), 0);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 29be9038bfb0..afdcfd0d7cef 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -91,6 +91,8 @@ separated by spaces:
 	test VMA merge cases behave as expected
 - rmap
 	test rmap behaves as expected
+- memory-failure
+	test memory-failure behaves as expected
 
 example: ./run_vmtests.sh -t "hmm mmap ksm"
 EOF
@@ -527,6 +529,25 @@ CATEGORY="page_frag" run_test ./test_page_frag.sh nonaligned
 
 CATEGORY="rmap" run_test ./rmap
 
+# Try to load hwpoison_inject if not present.
+HWPOISON_DIR=/sys/kernel/debug/hwpoison/
+if [ ! -d "$HWPOISON_DIR" ]; then
+	if ! modprobe -q -R hwpoison_inject; then
+		echo "Module hwpoison_inject not found, skipping..."
+	else
+		modprobe hwpoison_inject > /dev/null 2>&1
+		LOADED_MOD=1
+	fi
+fi
+
+if [ -d "$HWPOISON_DIR" ]; then
+	CATEGORY="memory-failure" run_test ./memory-failure
+fi
+
+if [ -n "${LOADED_MOD}" ]; then
+	modprobe -r hwpoison_inject > /dev/null 2>&1
+fi
+
 if [ "${HAVE_HUGEPAGES}" = 1 ]; then
 	echo "$orig_nr_hugepgs" > /proc/sys/vm/nr_hugepages
 fi
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index d954bf91afd5..a6d4ff7dfdc0 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -723,3 +723,44 @@ int ksm_stop(void)
 	close(ksm_fd);
 	return ret == 1 ? 0 : -errno;
 }
+
+int get_hardware_corrupted_size(unsigned long *val)
+{
+	unsigned long size;
+	char *line = NULL;
+	size_t linelen = 0;
+	FILE *f = fopen("/proc/meminfo", "r");
+	int ret = -1;
+
+	if (!f)
+		return ret;
+
+	while (getline(&line, &linelen, f) > 0) {
+		if (sscanf(line, "HardwareCorrupted: %12lu kB", &size) == 1) {
+			*val = size;
+			ret = 0;
+			break;
+		}
+	}
+
+	free(line);
+	fclose(f);
+	return ret;
+}
+
+int unpoison_memory(unsigned long pfn)
+{
+	int unpoison_fd, len;
+	char buf[32];
+	ssize_t ret;
+
+	unpoison_fd = open("/sys/kernel/debug/hwpoison/unpoison-pfn", O_WRONLY);
+	if (unpoison_fd < 0)
+		return -errno;
+
+	len = sprintf(buf, "0x%lx\n", pfn);
+	ret = write(unpoison_fd, buf, len);
+	close(unpoison_fd);
+
+	return ret > 0 ? 0 : -errno;
+}
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 522f7f9050f5..e9c4e24769c1 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -20,6 +20,7 @@
 
 #define KPF_COMPOUND_HEAD             BIT_ULL(15)
 #define KPF_COMPOUND_TAIL             BIT_ULL(16)
+#define KPF_HWPOISON                  BIT_ULL(19)
 #define KPF_THP                       BIT_ULL(22)
 /*
  * Ignore the checkpatch warning, we must read from x but don't want to do
@@ -154,6 +155,8 @@ long ksm_get_full_scans(void);
 int ksm_use_zero_pages(void);
 int ksm_start(void);
 int ksm_stop(void);
+int get_hardware_corrupted_size(unsigned long *val);
+int unpoison_memory(unsigned long pfn);
 
 /*
  * On ppc64 this will only work with radix 2M hugepage size
-- 
2.33.0


